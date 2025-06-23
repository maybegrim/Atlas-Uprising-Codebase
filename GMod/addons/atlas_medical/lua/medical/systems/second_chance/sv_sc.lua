ATLASMED.SC = ATLASMED.SC or {}

util.AddNetworkString("ATLAS.SecondChance.Revive")
util.AddNetworkString("ATLAS.SecondChance.Kill")
util.AddNetworkString("ATLAS.SecondChance.Msg")

ATLASMED.SC.CurrentPlys = ATLASMED.SC.CurrentPlys or {}
ATLASMED.SC.AllowedPlys = ATLASMED.SC.AllowedPlys or {}

local msg_lang = {
    [1] = "You revived %p.",
    [2] = "You killed %p. They now have to be revived by a medic.",
}

function ATLASMED.SC.AllowList(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local steamid = ply:SteamID64()

    ATLASMED.SC.AllowedPlys[steamid] = true
end

function ATLASMED.SC.Delist(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local steamid = ply:SteamID64()

    ATLASMED.SC.AllowedPlys[steamid] = nil
end

function ATLASMED.SC.IsAllowed(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local steamid = ply:SteamID64()

    return ATLASMED.SC.AllowedPlys[steamid]
end


function ATLASMED.SC.Down(ply)
    ply:SetNWBool("ATLASMED.SC.Down", true)
end

function ATLASMED.SC.Kill(ply)
    ply:SetNWBool("ATLASMED.SC.Down", false)
end

function ATLASMED.SC.Msg(ply, msg)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local msgStr = msg_lang[msg]
    if not msgStr then return end

    local msgStr = string.Replace(msgStr, "%p", ply:Nick())

    net.Start("ATLAS.SecondChance.Msg")
        net.WriteString(msgStr)
    net.Send(ply)
end

function ATLASMED.SC.Revive(ply, revivingPly)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    if ply == revivingPly then return end
    if not ATLASMED.SC.IsAllowed(ply) then return end
    if not ply:GetNWBool("ATLASMED.SC.Down") then return end

    local ragdoll = ply:GetNWEntity("DeathRagdoll")
    if not IsValid(ragdoll) then return end

    -- distance check to prevent reviving from far away
    local dist = ply:GetPos():Distance(revivingPly:GetPos())
    if dist > 200 then return end

    ATLASMED.SC.Msg(revivingPly, 1)

    ply:SetNWBool("ATLASMED.SC.Down", false)

    -- Respawn player right where their body is
    local pos = ragdoll:GetPos()
    ply:Spawn()
    ply:SetPos(pos)
    print("[ATLAS-MEDICAL] [SC] " .. revivingPly:Nick() .. " revived " .. ply:Nick() .. ".")
end

function ATLASMED.SC.Kill(ply, killer)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end
    if not ATLASMED.SC.IsAllowed(ply) then return end
    if not ply:GetNWBool("ATLASMED.SC.Down") then return end

    local ragdoll = ply:GetNWEntity("DeathRagdoll")
    if not IsValid(ragdoll) then return end

    -- distance check to prevent reviving from far away
    local dist = ply:GetPos():Distance(killer:GetPos())
    if dist > 200 then return end

    ATLASMED.SC.Msg(killer, 2)

    ply:SetNWBool("ATLASMED.SC.Down", false)
    print("[ATLAS-MEDICAL] [SC] " .. killer:Nick() .. " killed " .. ply:Nick() .. " while they were down.")
end


hook.Add("PlayerDeath", "ATLASMED.SC.HOOKS.Death", function(victimPly, inflictor, attacker)
    if not ATLASMED.SC.IsAllowed(victimPly) then return end

    ATLASMED.SC.Down(victimPly)
end)

net.Receive("ATLAS.SecondChance.Revive", function(_, ply)
    local revivedPly = net.ReadEntity()
    ATLASMED.SC.Revive(revivedPly, ply)
end)

net.Receive("ATLAS.SecondChance.Kill", function(_, ply)
    local killedPly = net.ReadEntity()
    ATLASMED.SC.Kill(killedPly, ply)
end)
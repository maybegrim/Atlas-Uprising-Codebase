AAUDIO.PA.Server = AAUDIO.PA.Server or {}
AAUDIO.PA.CurrentUser = AAUDIO.PA.CurrentUser or false

util.AddNetworkString("AAUDIO.PA.NET.PAChime")

local allowedRanks, allowedJobs = AAUDIO.PA.Config.AllowedRanks, AAUDIO.PA.Config.AllowedJobs


function AAUDIO.PA.Server.CanUsePA(ply)
    if not IsValid(ply) then return false end
    if not ply:IsPlayer() then return false end

    return allowedRanks[ply:GetUserGroup()] or allowedJobs[ply:Team()] or false
end

function AAUDIO.PA.Server.EmitPA(ent, ply, status)
    if not IsValid(ent) then return end
    local curStatus = ent:GetPAStatus()
    if curStatus ~= 1 and curStatus ~= 3 then return false end
    net.Start("AAUDIO.PA.NET.PAChime")
        net.WriteEntity(ply)
        net.WriteBool(status)
    net.Broadcast()
end

function AAUDIO.PA.Server.StartPA(ply, ent)
    if not IsValid(ply) then return false end
    if not ply:IsPlayer() then return false end
    if not AAUDIO.PA.Server.CanUsePA(ply) then return false end
    AAUDIO.PA.Server.EmitPA(ent, ply, true)
    timer.Simple(2, function()
        ply:AddVoiceFX("PASystemLoud")
        AAUDIO.PA.CurrentUser = ply
    end)
end

function AAUDIO.PA.Server.StopPA(ply, ent)
    if not IsValid(ply) then return false end
    if not ply:IsPlayer() then return false end
    AAUDIO.PA.Server.EmitPA(ent, ply, false)
    AAUDIO.PA.CurrentUser = false
    ply:RemoveVoiceFX("PASystemLoud")
end

hook.Add("PlayerDisconnected", "AAUDIO.PA.Server.PlayerDisconnected", function(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    if AAUDIO.PA.CurrentUser == ply then
        AAUDIO.PA.CurrentUser = false
    end
end)

-- Voice hook
hook.Add("PlayerCanHearPlayersVoice", "AAUDIO.PA.Server.PlayerCanHearPlayersVoice", function(listener, talker)
    if not IsValid(AAUDIO.PA.CurrentUser) then return end
    if not AAUDIO.PA.CurrentUser:IsPlayer() then return end
    if RPExtraTeams[listener:Team()].faction == "CHAOS" then return end
    if RPExtraTeams[listener:Team()].faction == "CIVILIAN" then return end
    if listener:Team() == TEAM_CHOOSING then return end

    -- Restrict CI from hearing PA
    if AAUDIO.PA.CurrentUser == talker then
        return true
    end
end)

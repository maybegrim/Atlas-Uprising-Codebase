AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SCP096ScrambleToggle")
util.AddNetworkString("SCP096ScrambleCooldown")

local SCRAMBLE_ACTIVE_DURATION = 15
local SCRAMBLE_COOLDOWN_DURATION = 120
local MANUAL_DISABLE_WINDOW = 8

function ENT:Initialize()
    self:SetModel("models/mishka/models/nvg.mdl")
    self:SetMaterial("models/player/player_chrome1")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

local function DropScramble(ply)

    net.Start("SCP096ScrambleToggle")
    net.WriteUInt(0, 4)
    net.Send(ply)

    ply.Wearing096Scramble = false
    ply.ScrambleToggled = false

    local DroppedGoggles = ents.Create("scp096_scramble_goggles")
    DroppedGoggles:SetPos(ply:GetPos())
    DroppedGoggles:Spawn()

end

local function StartCooldown(ply)
    ply.ScrambleCooldown = true
    ply.ScrambleToggled = false
    timer.Simple(SCRAMBLE_COOLDOWN_DURATION, function()
        if IsValid(ply) then
            ply.ScrambleCooldown = false
            net.Start("SCP096ScrambleCooldown")
            net.WriteBool(false)
            net.Send(ply)
        end
    end)
    net.Start("SCP096ScrambleCooldown")
    net.WriteBool(true)
    net.Send(ply)
end

-- Handle Scramble Toggle
hook.Add("PlayerSay", "ChatScrambleToggle", function(ply, text)
    if string.sub(string.lower(text), 1, 14) == "!equipscramble" then
        ply.Wearing096Scramble = true
        net.Start("SCP096ScrambleToggle")
        net.WriteUInt(2, 4)
        net.Send(ply)
    end

    if string.lower(text) == "!toggscramble" then
        if not ply.Wearing096Scramble then
            ply:ChatPrint("You are not wearing scramble goggles")
            return ""
        end

        if ply.ScrambleCooldown then
            ply:ChatPrint("Scramble goggles are on cooldown")
            return ""
        end

        if not ply.ScrambleToggled then
            ply.ScrambleToggled = true
            ply.CanManuallyDisable = true
            net.Start("SCP096ScrambleToggle")
            net.WriteUInt(1, 4)
            net.Send(ply)

            timer.Simple(MANUAL_DISABLE_WINDOW, function()
                if IsValid(ply) then
                    ply.CanManuallyDisable = false
                end
            end)

            timer.Simple(SCRAMBLE_ACTIVE_DURATION, function()
                if IsValid(ply) and ply.ScrambleToggled then
                    ply.ScrambleToggled = false
                    net.Start("SCP096ScrambleToggle")
                    net.WriteUInt(2, 4)
                    net.Send(ply)
                    StartCooldown(ply)
                end
            end)
        else

            if not ply.CanManuallyDisable then
                ply:ChatPrint("Goggles have malfunctioned and can not be disabled")
                return ""
            end

            ply.ScrambleToggled = false
            net.Start("SCP096ScrambleToggle")
            net.WriteUInt(2, 4)
            net.Send(ply)
        end

        return ""
    elseif string.lower(text) == "!dropscramble" then
        if ply.Wearing096Scramble then
            DropScramble(ply)
        end
    end
end)

-- Drop goggles on death
hook.Add("PlayerDeath", "ResetAndDropScramble", function(victim, inflictor, attacker)

    if(victim.Wearing096Scramble) then
        DropScramble(victim)
    end

end)

hook.Add("PlayerChangedTeam", "ResetAndDropScrambleTeam", function(ply)
    if ply.Wearing096Scramble then
        DropScramble(ply)
    end
end)
function ENT:Use(activator)

    if(activator.Wearing096Scramble) then
        activator:ChatPrint("You're already wearing scramble goggles")
        return
    end

    activator.Wearing096Scramble = true

    net.Start("SCP096ScrambleToggle")
    net.WriteUInt(2, 4)
    net.Send(activator)

    activator:ChatPrint("You've picked up scramble goggles, toggle with '!toggscramble' and drop with '!dropscramble'")
    self:Remove()

end








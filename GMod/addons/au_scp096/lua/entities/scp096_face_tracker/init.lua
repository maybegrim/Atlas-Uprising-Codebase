AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SCP096PlySawFace")
util.AddNetworkString("SCP096PassTargetToClient")

function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate.mdl") -- Placeholder model, replace with actual face model
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) -- Set collision group
    -- self:DrawShadow(false)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

net.Receive("SCP096PlySawFace", function(len, ply)

    if ply:HasWeapon("au_scp096_swep") then return end

    if ply:GetNWBool("SCP:096SAWFACE", false) then return end

    if ply.ScrambleToggled then return end

    if(ply:getJobTable().faction == "SCP") then return end

    if not scp096currentplayer or not scp096currentplayer:IsValid() or not scp096currentplayer:Alive() or scp096currentplayer.bagged then return end

    ply:SetNWBool("SCP:096SAWFACE", true)
    targetply096[ply] = true
    ply:ChatPrint("You've seen 096's face. run.")
end)
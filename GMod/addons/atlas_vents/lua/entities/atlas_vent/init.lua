
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/keypad.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end
local useCooldown = 0
function ENT:Use(ply)
    if useCooldown > CurTime() then return end
    useCooldown = CurTime() + 2
    net.Start("ATLAS.VENTS.UI")
    net.Send(ply)
end

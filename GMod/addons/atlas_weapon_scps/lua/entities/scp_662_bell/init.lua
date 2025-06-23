
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
local bellMat = Material("props/Bell")
function ENT:Initialize()
    self:SetModel("models/662/props/bell.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetMaterial("props/Bell")

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

function ENT:Use(ply)
    --if ply == ATLAS662.Ply then return end
    ATLAS662.Pickup(ply)
end


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/lockers.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

local COOLDOWN_TIME = 1 -- Cooldown period in seconds
ENT.LastUseTime = 0

function ENT:Use(ply)
    local currentTime = CurTime()
    if currentTime - self.LastUseTime < COOLDOWN_TIME then
        return -- Cooldown not yet passed, do nothing
    end

    self.LastUseTime = currentTime

    net.Start("ADQ_OpenModelSelectUI")
	net.WriteEntity(self)
    net.Send(ply)
end
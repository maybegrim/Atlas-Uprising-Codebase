AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("auat_opensop")

function ENT:Initialize()

	self:SetModel("models/player/blacklight3npc.mdl") 
	
	self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:CapabilitiesAdd(CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_BBOX)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
	end
end

function ENT:Use(a,c)
	net.Start("auat_opensop")
	net.Send(a)
end

function ENT:OnRemove()
end
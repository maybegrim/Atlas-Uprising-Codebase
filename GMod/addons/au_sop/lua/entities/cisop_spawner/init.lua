AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("auat_opensopci")

function ENT:Initialize()

	self:SetModel("models/killzone/pm/pm_soldier_2.mdl") 
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetBloodColor(BLOOD_COLOR_RED)

	local phys = self:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:Wake()
	end

end

function ENT:Use(a,c)
	net.Start("auat_opensopci")
	net.Send(a)
end

function ENT:OnRemove()
end
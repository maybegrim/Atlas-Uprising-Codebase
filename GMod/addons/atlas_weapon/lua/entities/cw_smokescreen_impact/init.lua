AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("CW_SMOKESCREEN")

local spd, ent

function ENT:Initialize()
	self:SetModel("models/Items/AR2_Grenade.mdl") 
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	
	timer.Simple(self.SmokeDuration, function()
		SafeRemoveEntity(self)
	end)
end

function ENT:CreateParticles()
	self:EmitSound("weapons/smokegrenade/sg_explode.wav", 100, 100)
	
	net.Start("CW_SMOKESCREEN")
		net.WriteVector(self:GetPos())
	net.Broadcast()
end

function ENT:Use(activator, caller)
	return false
end

function ENT:OnRemove()
	self:StopParticles()
	return false
end 
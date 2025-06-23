--[[
	Name: init.lua
	By: Micro & Time
]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/hunter/plates/plate075x1.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMaterial("Models/effects/vol_light001")
	self:DrawShadow(false)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()
end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/mishka/models/scp420.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use( activator )
    if activator:GetActiveWeapon():GetClass() ~= "weapon_scp420j" then
		activator:Give("weapon_scp420j")
		self:Remove()
	end
end
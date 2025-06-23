--[[
	Name: init.lua
	By: Micro
]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
 
	self:SetModel( "models/props_lab/jar01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	timer.Simple(900, function()
		if IsValid(self) then
			self:Remove()
		end
	end)

end
 
function ENT:Use( activator, caller )
	if activator:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 1.5
		if activator:Health() < activator:GetMaxHealth() or activator:GetNWBool("Ecoli") or activator:GetNWBool("Conjunctivitis") or activator:GetNWBool("Migraine") or activator:GetNWBool("HepatitisC") or activator:GetNWBool("Influenza") or activator:GetNWBool("CommonCold") then
			activator:SetNWBool("Ecoli", false)
			activator:SetNWBool("Conjunctivitis", false)
			activator:SetNWBool("Migraine", false)
			activator:SetNWBool("HepatitisC", false)
			activator:SetNWBool("Influenza", false)
			activator:SetNWBool("CommonCold", false)
			activator:SetHealth(activator:GetMaxHealth())
			DarkRP.notify(activator, 0, 3, "You consumed SCP-500 and fixed your pill needing ailments!")
			self:Remove()
		else
			DarkRP.notify(activator, 0, 3, "You do not need this!")
		end
	end
end
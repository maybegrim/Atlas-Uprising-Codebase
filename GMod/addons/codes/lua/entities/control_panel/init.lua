AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
 
	self:SetModel( "models/props_lab/reciever_cart.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

end

function ENT:Use( activator, caller )
	if activator:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 1.5
		if CODE_CONFIG.Permissions["Code Green"][activator:Team()] or activator:IsSuperAdmin() then
			net.Start("CodeControlMenu")
			net.Send(activator)
		end
		return
	end
end

AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/vinrax/props/cup_294.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetUseType( SIMPLE_USE )
	self.sayCooldown = 0
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.expireIn = nil
end

function ENT:SetDrink( key )
	if ( SCP294Server.drinkDATA[key] ) then
		local col = SCP294Server.drinkDATA[key].drinkColor
		self:SetNWInt( "cup_r", col.r )
		self:SetNWInt( "cup_g", col.g )
		self:SetNWInt( "cup_b", col.b )
		self:SetNWInt( "cup_a", col.a )
		self.drinkKey = key
	else
		self.expireIn = CurTime() + 20
	end
end

function ENT:Use( ply, caller )
	if not ply or not ply:IsValid() then return end
	if ( self.drinkKey ) then
		if ( SCP294Server.drinkDATA[ self.drinkKey ] ) then
			SCP294Server.applyDrink( ply, self.drinkKey )
			ply:Say( SCP294Server.drinkDATA[self.drinkKey].drinkDescription )
			ply:EmitSound( "scp_294_redux/drink/" .. SCP294Server.drinkDATA[self.drinkKey].drinkSound .. ".wav" )
			self:SetNWInt( "cup_a", 0 )
			self.drinkKey = nil
			self.expireIn = CurTime() + 20
		else
			self.expireIn = CurTime() + 1
			MsgC( Color( 255,0,0 ), "The flavour (" .. self.drinkKey .. ") don't exist !\n" )
		end
	else
		if ( CurTime() > self.sayCooldown ) then
			ply:Say( "It's empty." )
			self.sayCooldown = CurTime() + 2
		end
	end
end

function ENT:Think()
	if ( self.expireIn ) then
		if ( CurTime() > self.expireIn ) then
			self:Remove()
		end
	end	
end

function ENT:OnRemove()
end

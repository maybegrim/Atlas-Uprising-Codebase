AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/vinrax/scp294/scp294_lg.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.User = nil
	
end

function ENT:Use( ply, caller )
	SCP294Server.sendOpenKeyboardFrame( ply, self )
end

function ENT:Think()
end

function ENT:OnRemove()
end

function ENT:SpawnCup( key )
	local entA 		= self:GetAngles()
	local pos 		= self:GetPos() + entA:Right()*9 + entA:Up()*32 + entA:Forward()*13
	
	for k , v in pairs (ents.FindInSphere( pos, 3 )) do
		if ( v:GetClass() == "scp294rcup" ) then
			self:EmitSound("scp_294_redux/outofrange.wav") 
			return 
		end
	end
	
	local cup = ents.Create( "SCP294rcup" )
	cup:SetPos( pos )
	cup:Spawn()
	cup:SetDrink( key )
	
	if ( SCP294Server.drinkDATA[key] ) then
		self:EmitSound( "scp_294_redux/dispense/" .. SCP294Server.drinkDATA[key].creationSound .. ".wav" )
	else
		self:EmitSound( "scp_294_redux/outofrange.wav" )
	end
end



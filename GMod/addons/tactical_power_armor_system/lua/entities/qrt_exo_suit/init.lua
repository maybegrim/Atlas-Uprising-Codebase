AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	self:SetModel("models/player/n7legion/human_soldier.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds( Vector(-10,-10,0), Vector(10,10,72) )
	self:Activate()

	print("EXO INIT")

end

function ENT:Use( act )

	if(PowerArmorConfig.AllowedJobs[team.GetName(act:Team())] ~= true) then
        return
    end
	
	if act.IsInPowerArmor then return end
	
	if !IsValid( self:GetEquiper() ) then
		self:SetEquiper( act )
	else
		self:SetPercent( self:GetPercent() + 1 )
		
		if self:GetPercent() >= 100 then
			PowerArmor_Add( act, self )
		end
	end
	
	-- if self.USED then return end
	
	-- if !PowerArmor_InArmor( act ) then	
		-- PowerArmor_Add( act, self )
		-- self.USED = true
	-- end
end

function ENT:Think()
	local ply = self:GetEquiper()
	if IsValid( ply ) then
		local e = ply:KeyDown( IN_USE )
		if !e or ply:GetPos():Distance( self:GetPos() + self:GetForward()*-72 ) > 50 then
			self:SetEquiper(nil)
			self:SetPercent(0)
		end
	end
end

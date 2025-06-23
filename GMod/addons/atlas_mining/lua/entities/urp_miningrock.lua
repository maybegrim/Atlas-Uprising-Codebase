
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Mining Rock"
ENT.Author = "SweptThrone"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "STMining"
AddCSLuaFile()
ENT.CanBeMined = true
if SERVER then

	local randModels = {
		"models/props_wasteland/rockcliff01b.mdl",
		"models/props_wasteland/rockcliff01c.mdl",
		"models/props_wasteland/rockcliff01e.mdl",
		"models/props_wasteland/rockcliff01f.mdl",
		"models/props_wasteland/rockcliff01g.mdl",
		"models/props_wasteland/rockcliff01j.mdl",
		"models/props_wasteland/rockcliff01k.mdl",
		"models/props_wasteland/rockcliff06d.mdl",
		"models/props_wasteland/rockcliff07b.mdl"
	}
	
	local randSounds = {
		"physics/concrete/boulder_impact_hard1.wav",
		"physics/concrete/boulder_impact_hard2.wav",
		"physics/concrete/boulder_impact_hard3.wav",
		"physics/concrete/boulder_impact_hard4.wav",
		"physics/concrete/concrete_break2.wav",
		"physics/concrete/concrete_break3.wav"
	}

	function ENT:Initialize()
		self:SetModel( table.Random( randModels ) )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
		phys:EnableMotion( false )
		self:SetUseType(SIMPLE_USE)
		self:SetHealth( 20 )
		self:PrecacheGibs()
	end
	
	function ENT:Use( act, ply )

	end

	function ENT:OnRemove()
		
	end

	function ENT:Think()
		--local effectdata = EffectData()
		--effectdata:SetOrigin( self:GetPos() )
		--util.Effect( "ManhackSparks", effectdata )
	end
	
	function ENT:OnTakeDamage( dmg )
		if dmg:GetAttacker():GetActiveWeapon():GetClass() != "urp_pickaxe" then return end
		self:EmitSound( Sound( table.Random( randSounds ) ) )
		self:SetHealth( self:Health() - dmg:GetDamage() )
		if self:Health() <= 0 then
			timer.Create( "RespawnRock" .. self:EntIndex(), 10, 1, function()
				self:SetMaterial( "" )
				self.CanBeMined = true
				self:SetHealth( 20 )
			end )
			self:SetMaterial( "models/wireframe" )
			self.CanBeMined = false
			dmg:GetAttacker():SetNWInt( "HeldOres", dmg:GetAttacker():GetNWInt( "HeldOres" ) + math.random( 1, 2 ) )
		end
		--EmitSound( Sound( table.Random( randSounds ) ), dmg:GetDamagePosition(), self:EntIndex() )
	end

end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
	
end
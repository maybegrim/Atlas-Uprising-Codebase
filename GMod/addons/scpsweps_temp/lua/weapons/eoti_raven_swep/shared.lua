if( SERVER ) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.UseHands 		= true
SWEP.ViewModel		= "models/weapons/c_arms_citizen.mdl" 
SWEP.WorldModel		= ""	
SWEP.ViewModelFOV 	= 50
SWEP.ViewModelFlip 	= false
SWEP.DrawCrosshair	= false 

SWEP.Weight				= 1			 
SWEP.AutoSwitchTo		= true		 
SWEP.AutoSwitchFrom		= false	
SWEP.CSMuzzleFlashes	= false	 		 
	
SWEP.Primary 				= {}	
SWEP.Primary.Damage			= 67					 			  
SWEP.Primary.ClipSize		= -1		
SWEP.Primary.Delay			= 0.5	  
SWEP.Primary.DefaultClip	= 1		 
SWEP.Primary.Automatic		= true		 
SWEP.Primary.Ammo			= "none"	 

SWEP.Secondary 				= {}
SWEP.Secondary.ClipSize		= -1			
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay		= 5
SWEP.Secondary.Damage		= 0		 
SWEP.Secondary.Automatic	= false		 
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadDelay	= 0
SWEP.AnimDelay		= 0
SWEP.AttackAnims	= { 
	"fists_left", 
	"fists_right"}

SWEP.MonsterModel	= "models/player/ravenwarriorplayer.mdl"

SWEP.HealthBonus	= 50
SWEP.HealAmount		= 1
SWEP.HealTimer		= 2
SWEP.HealId			= ""

SWEP.RunSpeed		= 650
SWEP.WalkSpeed		= 400

SWEP.HitSound	= {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav"}
SWEP.MissSound 	= {
	"npc/fast_zombie/claw_miss2.wav",
	"npc/fast_zombie/claw_miss1.wav"}
SWEP.FleshSound	= {
	"physics/flesh/flesh_squishy_impact_hard1.wav",
	"physics/flesh/flesh_squishy_impact_hard2.wav",
	"physics/flesh/flesh_squishy_impact_hard3.wav",
	"physics/flesh/flesh_squishy_impact_hard4.wav"}
SWEP.RoarSound	= {
	"npc/fast_zombie/fz_alert_close1.wav"}
SWEP.AttackSound= {
	"npc/fast_zombie/leap1.wav"}
SWEP.SwingSound	= {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav"}
SWEP.ScreamSound = {
	"npc/zombie_poison/pz_alert2.wav",
	"npc/zombie_poison/pz_alert1.wav"
}

if ( CLIENT ) then
	SWEP.PrintName	= "SCP 6286-ATL"	 
	SWEP.Category	= "Atlas Uprising - Temp SCP Sweps"
	SWEP.Author		= "Atlas Uprising"
	SWEP.Purpose	= "Left-Click: Attack\nRight-Click: Screech (Knockback Players)\nR: Morph/Unmorph"
	SWEP.Slot		= 0					 
	SWEP.SlotPos	= 1
	SWEP.DrawAmmo	= false
end

-- function SWEP:PreDrawViewModel( vm, wep, ply )
--	if !IsValid(vm) then return end
--	vm:SetMaterial( "engine/occlusionproxy" )
-- end --Hides and deletes the original hands in the animation

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay / 2 )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	if game.MaxPlayers() == 1 then self.AnimDelay = CurTime() + 2.75
	else self.AnimDelay = SysTime() + 2.75 end
	
	self.Owner:EmitSound(table.Random(self.ScreamSound), 160,150)
	
	local owner,dist,screech
	owner = self.Owner
	
	self:Roar(owner)
	
	timer.Simple(1.25, function() 
	if !SERVER then return end
	if !owner:IsValid() then return end
	if !owner:Alive() then return end
	
	for k, v in pairs( player.GetAll() ) do
		if v != owner and v:Alive() then 
			if ((owner:GetPos()):Distance(v:GetPos()) < 300) then 
				v:SetVelocity(Vector(0,0,250))
				timer.Simple(0.15, function() 
					v:SetVelocity(v:GetAimVector() + v:EyeAngles():Forward() * -300)
					v:TakeDamage(50,owner,self)
				end)
			end
		end
	end
	
	screech = ents.Create( "prop_combine_ball" )
	screech:SetPos(owner:EyePos())
	screech:Spawn()
	screech:Fire( "explode", "", 0 )
	
	end)
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	
	if game.MaxPlayers() == 1 then self.AnimDelay = CurTime() + self.Primary.Delay
	else self.AnimDelay = SysTime() + self.Primary.Delay end
	
	local owner = self.Owner
	if !owner:IsValid() then return end
	if !owner:Alive() then return end
	
	self:PrimaryAttackMonster(owner)
end

function SWEP:Reload()
	self.Weapon:SetNextPrimaryFire( CurTime() + 2.5 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 2.5 )
	if self.ReloadDelay > CurTime() then return end
	self.ReloadDelay = CurTime() + 2.5
	self.Weapon:SetNextPrimaryFire( CurTime() + 2.5 )
	
	if game.MaxPlayers() == 1 then self.AnimDelay = CurTime() + 2.5
	else self.AnimDelay = SysTime() + 2.5 end
	
	--if !owner:IsValid() then return end
	--if !owner:Alive() then return end
	local owner = self.Owner
	if owner:GetModel() == "models/player/suits/male_07_closed_tie.mdl" then	
		self:MorphToMonster()
	elseif owner:GetModel() == "models/player/ravenwarriorplayer.mdl" then
		self:UnMorph()
	end
	
	self:Roar(owner)
end

function SWEP:Initialize()
	--self:SetHoldType( "knife" )
	local owner = self.Owner
end

function SWEP:Equip(owner)
	local owner = self.Owner
	self:RegeneratingHealth( owner )
	timer.Simple(0.15, function()
		if !IsValid(self) then return end
		-- if owner:GetActiveWeapon() != self then return end
		-- self:MorphToMonster()
	end)
end

function SWEP:Deploy()
	local owner = self.Owner
	self:RegeneratingHealth( owner )
	timer.Simple(0.15, function()
		if !IsValid(self) then return end
		-- if owner:GetActiveWeapon() != self then return end
		--self:MorphToMonster()
	end)
end

function SWEP:Holster()
	local owner = self.Owner
	if owner:IsValid() and owner:Alive() then
	--	owner:StopSound("eoti_idlegrowlbird")
	end
	
	if IsValid( owner ) then
		local vm = owner:GetViewModel()
		if IsValid( vm ) then vm:SetMaterial( "" ) end
	end
	return true
end

function SWEP:MorphToMonster()
	local owner = self.Owner
	if SERVER then
		owner:SetModel("models/player/ravenwarriorplayer.mdl")
	end
	
	--self:Roar( owner )

	if !owner:IsValid() then return end
	if !owner:Alive() then return end
	self:SetHoldType( "knife" )
	self:SendWeaponAnim(ACT_HL2MP_IDLE_KNIFE)
	
	-- owner:EmitSound("eoti_idlegrowlbird")
	timer.Simple(0.75,function()
		local vm = owner:GetViewModel()
		if IsValid(vm) then
			vm:ResetSequence( vm:LookupSequence( "fists_draw" ) )
		end
	end)
	
	return true
end

function SWEP:UnMorph()
	local owner = self.Owner
	if !owner:IsValid() then return end
	owner:SetModel("models/player/suits/male_07_closed_tie.mdl")
	
	--self:Roar( owner )

	if !owner:Alive() then return end
	self:SetHoldType( "normal" )
	--self:SendWeaponAnim(ACT_HL2MP_IDLE_KNIFE)
	
	-- owner:EmitSound("eoti_idlegrowlbird")
	timer.Simple(0.75,function()
		local vm = owner:GetViewModel()
		if IsValid( vm ) then vm:SetMaterial( "" ) end
	end)
	
	return true
end

function SWEP:Roar(owner)
	timer.Simple(0.15, function()
		if !owner:IsValid() then return end
		if !owner:Alive() then return end
		if SERVER and not CLIENT then 
			owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
			owner:EmitSound(table.Random(self.RoarSound), 150)
		end
	end)
end

function SWEP:PrimaryAttackAnimation(owner)
	owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_FRENZY)
	if SERVER then
		owner:EmitSound(table.Random(self.SwingSound))
		owner:EmitSound(table.Random(self.AttackSound), 60)
	end
end

function SWEP:PrimaryAttackMonster(owner)
	local tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = owner:GetShootPos() + ( owner:GetAimVector() * 95 )
	tr.filter = owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )
	
	--------------------------
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
	vm:ResetSequence( vm:LookupSequence( "fists_idle_01" ) )
	end
		
	local anim = self.AttackAnims[ math.random( 1, 2 ) ]

	timer.Simple( 0, function()
		if ( !IsValid( self ) || !IsValid( self.Owner ) || !self.Owner:GetActiveWeapon() || self.Owner:GetActiveWeapon() != self ) then return end
	
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
		vm:ResetSequence( vm:LookupSequence( anim ) )
		end
	end )
	------------------------

	self:PrimaryAttackAnimation(owner)

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() 
		or string.find(trace.Entity:GetClass(),"npc") 
		or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = owner:GetShootPos()
			bullet.Dir    = owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			owner:FireBullets(bullet) 
			self.Weapon:EmitSound(table.Random(self.FleshSound),75)
		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = owner:GetShootPos()
			bullet.Dir    = owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			owner:FireBullets(bullet) 	
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			self.Weapon:EmitSound(table.Random(self.HitSound),75)
		end
	else
		self.Weapon:EmitSound(table.Random(self.MissSound),75)
	end
	
	timer.Simple( 0.06, function() owner:ViewPunch( Angle( -2, -2,  0 ) ) end )
	timer.Simple( 0.23, function() owner:ViewPunch( Angle(  3,  1,  0 ) ) end )
end

function SWEP:RegeneratingHealth(owner)
	if timer.Exists( self.HealId ) then return end
	local hp, maxhp
	
	self.HealId  = math.random(165, 73623)
	self.HealId = "EOTI_RAVEN_SWEP_"..self.HealId..owner:Name()
	
	timer.Create(self.HealId , self.HealTimer, 0, function() 
		if !SERVER
		or !self:IsValid() 
		or !timer.Exists( self.HealId )
		then return end
		
		hp = owner:Health()
		maxhp = (owner:GetMaxHealth() + self.HealthBonus or 100 + self.HealthBonus)
		if maxhp < hp then return end
		owner:SetHealth(math.Clamp( hp + self.HealAmount, 0, maxhp ))
	end)
end

function SWEP:Think()
	local timer
	if game.MaxPlayers() == 1 then timer = CurTime()
	else timer = SysTime() end

	if self.AnimDelay > timer then return true end
	
	local owner, primary, v
	owner = self.Owner
	primary = (self:GetNextPrimaryFire() - CurTime())
		
	if timer + primary > timer then 
		self.AnimDelay = primary + 0.05
		return true
	elseif owner:KeyDown(IN_FORWARD) or !owner:IsOnGround() then
		owner:SetRunSpeed(math.Clamp(self.RunSpeed, owner:GetRunSpeed(), 400))
		owner:SetWalkSpeed(math.Clamp(self.WalkSpeed, owner:GetWalkSpeed(), 200))
		owner:DoAnimationEvent(ACT_HL2MP_RUN_ZOMBIE_FAST)
		if SERVER or game.MaxPlayers() == 1 then
			self.AnimDelay = timer + 0.45
		else 
			self.AnimDelay = timer + 0.4
		end
		return true
	end
	self.AnimDelay = timer + 0.5
end

function SWEP:RemoveSelf()
	if !SERVER then return end
	if timer.Exists(self.HealId) then timer.Remove( self.HealId ) return end
	self:Remove()
end

function SWEP:OnDrop()
	self:RemoveSelf()
end

function SWEP:OnRemove()
	self:RemoveSelf()
end
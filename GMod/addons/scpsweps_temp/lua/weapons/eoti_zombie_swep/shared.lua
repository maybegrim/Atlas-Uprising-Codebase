if( SERVER ) then
	AddCSLuaFile("shared.lua")
end

SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel 		= "models/zombie/arms/v_zombiearms.mdl"
SWEP.WorldModel		= ""	
SWEP.ViewModelFOV 	= 50
SWEP.ViewModelFlip 	= false
SWEP.DrawCrosshair	= false 

SWEP.Weight				= 1			 
SWEP.AutoSwitchTo		= true		 
SWEP.AutoSwitchFrom		= false	
SWEP.CSMuzzleFlashes	= false	 		 
	
SWEP.Primary 				= {}	
SWEP.Primary.Damage			= 75					 			  
SWEP.Primary.ClipSize		= -1		
SWEP.Primary.Delay			= 1.6	  
SWEP.Primary.DefaultClip	= -1		 
SWEP.Primary.Automatic		= true		 
SWEP.Primary.Ammo			= "none"	 

SWEP.Secondary 				= {}
SWEP.Secondary.ClipSize		= 5		
SWEP.Secondary.DefaultClip	= 180
SWEP.Secondary.Delay		= 6
SWEP.Secondary.Damage		= 0		 
SWEP.Secondary.Automatic	= false		 
SWEP.Secondary.Ammo			= "StriderMinigun"

SWEP.ReloadDelay	= 0
SWEP.AnimDelay		= 0
SWEP.AttackAnims	= { 
	ACT_VM_SECONDARYATTACK,
	ACT_VM_HITCENTER}
SWEP.WorldAnim		= {
	ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL,
	ACT_GMOD_GESTURE_RANGE_ZOMBIE
}

SWEP.HealthBonus	= 200
SWEP.HealAmount		= 1
SWEP.HealTimer		= 2
SWEP.HealId			= ""

SWEP.InfectChance	= 0.25
SWEP.InfectDuration	= 12 -- 5 x 12 = 60 seconds until infection turns to werewolfisms

SWEP.ZombieStage		= 0
SWEP.ZombieDecay 		= 180
SWEP.ZombieFleshLoss	= 10
SWEP.ZombieModel = {
	"models/player/corpse1.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/charple.mdl",
	"models/player/skeleton.mdl"}

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
SWEP.AttackSound= {
	"npc/fast_zombie/leap1.wav"}
SWEP.SwingSound	= {
	"npc/zombie/claw_miss1.wav",
	"npc/zombie/claw_miss2.wav"}
SWEP.ScreamSound = {
	"npc/zombie_poison/pz_alert2.wav",
	"npc/zombie_poison/pz_alert1.wav"}

if ( CLIENT ) then
	SWEP.PrintName	= "SCP 008 Infection"	 
	SWEP.Category	= "Atlas Uprising - Temp SCP Sweps"
	SWEP.Author		= "War"
	SWEP.Purpose	= "\nDamage: "..SWEP.Primary.Damage.." ("..(SWEP.Primary.Damage/SWEP.Primary.Delay).." DPS)\n\nRight-Click: Vomit Flesh (Infects others on Touch)\nReload: Displays Zombie Decay Stats"
	SWEP.Slot		= 0					 
	SWEP.SlotPos	= 1
	SWEP.DrawAmmo	= false
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:Equip(owner)
	self:ZombieRegen(owner)
	timer.Simple(0.5, function()
		if !IsValid(self) then return end
		owner:SetActiveWeapon(self)
		owner:SetRenderMode( RENDERMODE_TRANSALPHA )
	end)
end

function SWEP:Deploy()
	if CLIENT then 
		chat.AddText(
		Color( 0, 200, 0 ), "Zombie Infection System:")
		chat.AddText(
		Color( 255, 100, 0 ), "[Mouse2] ",
		Color( 255, 255, 0 ), "Throw Infected Flesh (Infects if humans touch it)",
		Color( 255, 100, 0 ), " [Reload] ",
		Color( 255, 255, 0 ), "Zombie Info")
	end
	if game.MaxPlayers() < 2 then
		self.Owner:ChatPrint("Single Player Detected: Animations are unstable due to the game pausing, but SysTime() does not!")
		self.Owner:ChatPrint("Recommend running on server or playing in +2 Player mode, Local or Internet!")
	end
	if SERVER then 
		self.Owner:EmitSound("eoti_idlezombieloop"..math.random(1,4),35,100)
	end
end

function SWEP:Holster()
	self.Owner:StopSound("eoti_idlezombieloop1")
	self.Owner:StopSound("eoti_idlezombieloop2")
	self.Owner:StopSound("eoti_idlezombieloop3")
	self.Owner:StopSound("eoti_idlezombieloop4")
	return true
end

function SWEP:OnRemove()
	self:RemoveSelf()
	return true
end

function SWEP:OnDrop()
	self:RemoveSelf()
	return true
end

function SWEP:RemoveSelf()
	if !self.Owner:IsValid() then return end
	self.Owner:StopSound("eoti_idlezombieloop1")
	self.Owner:StopSound("eoti_idlezombieloop2")
	self.Owner:StopSound("eoti_idlezombieloop3")
	self.Owner:StopSound("eoti_idlezombieloop4")
	
	if !SERVER then return end
	if timer.Exists(self.HealId) then timer.Remove( self.HealId ) return end
	self.Owner:SetColor( Color(255,255,255) )
	self.Owner:SetRenderMode( RENDERMODE_NORMAL )
	self:Remove()
end

function SWEP:Reload()
	if self.ReloadDelay > CurTime() then return end
	self.ReloadDelay = CurTime() + 4
	
	if CLIENT then 
		chat.AddText(
		Color( 255, 100, 0 ), "Necrophage Virus: ",
		Color( 255, 255, 0 ), " You will decay further in ",
		Color( 255, 100, 0 ), ""..LocalPlayer():GetAmmoCount("StriderMinigun"),
		Color( 255, 255, 0 ), " seconds unless you eat flesh!")
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	if game.MaxPlayers() < 2 then self.AnimDelay = CurTime() + 1.6
	else self.AnimDelay = SysTime() + 1.6 end
	if self.ZombieStage == #self.ZombieModel then return end
	
	local owner = self.Owner
	if !owner:IsValid() then return end
	if !owner:Alive() then return end
	
	if self.ZombieStage == #self.ZombieModel then 
		owner:ChatPrint("You're a skeleton, you don't have any flesh to throw!")
		return
	end
	
	if SERVER then
		owner:EmitSound(table.Random(self.SwingSound))
		owner:EmitSound("npc/zombie_poison/pz_pain"..math.random(1,3)..".wav", 60)
		owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1,14)..".wav")
		owner:EmitSound("physics/flesh/flesh_bloody_break.wav")
	end
	
	self:SendWeaponAnim( self.AttackAnims[ math.random( 1, 2 ) ] )
	
	owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL)
	
	timer.Simple(0.75,function() 
		if !owner:IsValid() then return end
		if !owner:Alive() then return end
	
		self.ZombieDecay = math.Clamp(self.ZombieDecay - self.ZombieFleshLoss,0,500)
		owner:SetAmmo(math.Clamp(self.ZombieDecay,0,500),"StriderMinigun")
	
		if CLIENT then return end
		local flesh = {
			ents.Create( "eoti_zombie_flesh" ),
			ents.Create( "eoti_zombie_flesh" ),
			ents.Create( "eoti_zombie_flesh" )}
		for i, fl in pairs( flesh ) do
			if !IsValid( fl ) then return end
			fl:SetPos( owner:EyePos() + owner:GetForward() * (50 + i*10) )
			fl:Spawn()
			fl.InfectionOwner = self
		end
	end)
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if game.MaxPlayers() < 2 then self.AnimDelay = CurTime() + self.Primary.Delay
	else self.AnimDelay = SysTime() + self.Primary.Delay end
	
	local owner = self.Owner
	if !owner:IsValid() then return end
	if !owner:Alive() then return end
	
	self:PrimaryAttackZombie(owner)
end

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

function SWEP:ZombieRegen(owner)
	if timer.Exists( self.HealId ) then return end
	local hp, maxhp
	
	self.HealId  = math.random(165, 73623)
	self.HealId = "EOTI_ZOMBIE_SWEP_"..self.HealId..owner:Name()
	
	owner:SetHealth((owner:GetMaxHealth() + self.HealthBonus or 100 + self.HealthBonus))
	
	owner:ChatPrint("You have been consumed by the Necrophage!")
	
	timer.Create(self.HealId , self.HealTimer, 0, function() 
		if !SERVER
		or !self:IsValid() 
		or !timer.Exists( self.HealId )
		then return end
		
		hp = owner:Health()
		maxhp = (owner:GetMaxHealth() + self.HealthBonus or 100 + self.HealthBonus)
		if maxhp < hp then return end
		owner:SetHealth(math.Clamp( hp + self.HealAmount, 0, maxhp ))
		
		self.ZombieDecay = math.Clamp(self.ZombieDecay - 1,0,500)
		owner:SetAmmo(self.ZombieDecay,"StriderMinigun")
		if self.ZombieDecay > 0 then return end
		if self.ZombieStage >= #self.ZombieModel then 
			owner:ChatPrint("What flesh remains crumbles as you finally decay into a pile of inanimate bones!")
			owner:Kill()
			return end
		self.ZombieStage = self.ZombieStage + 1
		owner:SetModel(self.ZombieModel[self.ZombieStage])
		self.ZombieDecay = 240
		owner:SetAmmo(self.ZombieDecay,"StriderMinigun")
		
		owner:SetColor( Color(255,255,255) )
		owner:SetRenderMode( RENDERMODE_NORMAL )
		
			if self.ZombieStage == 1 then owner:ChatPrint("Your face melts off in chunks as you begin to wither and decay!")
		elseif self.ZombieStage == 2 then owner:ChatPrint("Your skin rends off, exposing a mangled mess of muscle and bone!")
		elseif self.ZombieStage == 3 then owner:ChatPrint("Your body decays into an unrecognizable heap of necrotic sinew! (Headshot Immune)")
		elseif self.ZombieStage == 4 then owner:ChatPrint("You are now a spooky, scary skeleton! (Headshot Immune, No Regeneration, Final Stage)")
		end
		owner:ChatPrint("You have 3 minutes to eat otherwise you will decay further until death!")
		
		if game.MaxPlayers() < 2 then self.AnimDelay = CurTime()
		else self.AnimDelay = SysTime() end
	end)
end

function SWEP:PrimaryAttackZombie(owner)
	local tr, trace, anim
	
	--------------------------

	owner:DoAnimationEvent(table.Random(self.WorldAnim))
	if SERVER then
		owner:EmitSound(table.Random(self.SwingSound))
		owner:EmitSound("npc/zombie/zo_attack"..math.random(1,2)..".wav", 60)
		owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1,14)..".wav")
	end
	
	------------------------
	
	tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = owner:GetShootPos() + ( owner:GetAimVector() * 95 )
	tr.filter = owner
	tr.mask = MASK_SHOT
	trace = util.TraceLine( tr )

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() 
		or string.find(trace.Entity:GetClass(),"npc") 
		or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = owner:GetShootPos()
			bullet.Dir    = owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			owner:FireBullets(bullet) 
			self:Infection(trace.Entity)
			self.Weapon:EmitSound(table.Random(self.FleshSound),75)
			if !trace.Entity:HasWeapon(self:GetClass()) then
				self.ZombieDecay = math.Clamp(self.ZombieDecay + 40,0,500)
				self.Owner:SetAmmo(self.ZombieDecay,"StriderMinigun")
			end
		else
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
	
	self.Weapon:SendWeaponAnim(self.AttackAnims[ math.random( 1, 2 ) ])
	
	timer.Simple( 0.06, function() owner:ViewPunch( Angle( -2, -2,  0 ) ) end )
	timer.Simple( 0.23, function() owner:ViewPunch( Angle(  3,  1,  0 ) ) end )
end

function SWEP:Infection(dmg)
	if !dmg:IsValid() then return end
	if !dmg:IsPlayer() then return end
	if !dmg:Alive() then return end
	if dmg:HasWeapon(self:GetClass()) then return end
	if !(math.random(0.01,1.00) >= self.InfectChance) then return end

	local id, step, cnt, rgb
	id = "ZombieInfectionTimer_"..dmg:Name()
	step = math.floor(230/self.InfectDuration)
	if timer.Exists(id) then return end
	
	cnt = 0	
	dmg:SetRenderMode( RENDERMODE_TRANSALPHA )
	dmg:ChatPrint("You have contracted Necrophage, you will succumb to the zombie plague in "..(self.InfectDuration*5).." seconds!")
	
	if SERVER then dmg:EmitSound("eoti_idlezombieloop"..math.random(1,4), 20, 100) end
	
	timer.Create(id, 5, self.InfectDuration, function() 
		if !self:IsValid()
		or !dmg:IsValid()
		or !dmg:IsPlayer()
		or !dmg:Alive()
		or dmg:HasWeapon(self:GetClass())
		or !timer.Exists(id)
		then
			dmg:SetColor( Color(255,255,255) )
			dmg:SetRenderMode( RENDERMODE_NORMAL )
			timer.Destroy(id)
			return false
		end
			
		rgb = 255 - (cnt * step)
		cnt = cnt + 1
		dmg:SetColor( Color(rgb,255,rgb) )
		
		if cnt < self.InfectDuration then return end
		if not SERVER and CLIENT then return end
		
		dmg:StopSound("eoti_idlezombieloop1")
		dmg:StopSound("eoti_idlezombieloop2")
		dmg:StopSound("eoti_idlezombieloop3")
		dmg:StopSound("eoti_idlezombieloop4")
		dmg:Give(self:GetClass())
		dmg:SetColor( Color(255,255,255) )
		dmg:SetRenderMode( RENDERMODE_NORMAL )
		timer.Destroy(id)
		return true
	end)
	return true
end

function SWEP:Think()
	local t
	if game.MaxPlayers() < 2 then t = CurTime()
	else t = SysTime() end
	if self.AnimDelay > t then return true end
	
	local owner, primary
	owner = self.Owner
	primary = (self:GetNextPrimaryFire() - CurTime())
	
	if (owner:KeyDown(IN_FORWARD)
	or  owner:KeyDown(IN_BACK) 
	or  owner:KeyDown(IN_MOVELEFT)
	or  owner:KeyDown(IN_MOVERIGHT)
	or  owner:KeyDown(IN_JUMP))
	and !owner:KeyDown(IN_DUCK) then
		owner:DoAnimationEvent(ACT_HL2MP_RUN_ZOMBIE)
		self.AnimDelay = t + 0.55
		return true
	elseif owner:KeyDown(IN_DUCK) then 
		self.AnimDelay = 0.45
		return true
	elseif t + primary > t then 
		self.AnimDelay = primary + 0.05
		return true
	end
	owner:DoAnimationEvent(ACT_HL2MP_IDLE_ZOMBIE)
	self.AnimDelay = t + 0.5 --1.75
end
local _={_="Primary",a="Secondary",b="Owner",c="Weapon"}

SWEP.PrintName     			= "SCP-860-2"			
SWEP.Slot					= 3
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

SWEP.Author					= "Time"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= "[LMB] - Attack \n [RMB] - Speed Boost \n [RELOAD] - Roar"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Spawnable				= true
SWEP.Category				= "Atlas Uprising - Temp SCP Sweps"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.ViewModel				= Model("models/weapons/v_zombiearms.mdl") 
SWEP.WorldModel 			= Model("")

local SwingSound = Sound( "npc/zombie/claw_miss1.wav" )
local HitSound = Sound("npc/zombie/claw_strike1.wav")
local AmbiantSound = Sound("scp860/860.ogg")
local GrowlSound = Sound("scp860/grawl.wav")

function SWEP:Initialize()
	self:SetHoldType("normal")
	if self[_.b]:IsValid() then
		self[_.b]:SetRunSpeed(400)
		self[_.b]:SetWalkSpeed(300)
	end
end

function SWEP:DefualtSpeed()
	if self[_.b]:IsValid() then
		self[_.b]:SetRunSpeed(300)
		self[_.b]:SetWalkSpeed(200)
	end
end

function SWEP:SuperSpeed()
	if self[_.b]:IsValid() then
		self[_.b]:SetRunSpeed(400)
		self[_.b]:SetWalkSpeed(300)
	end
end

function SWEP:Deploy()
	if self[_.b]:IsValid() then
		self:DefualtSpeed()
		self[_.b]:SetViewOffset(Vector(0,0,50))
		self:SendWeaponAnim(ACT_VM_IDLE)
	end	
return!!1 end

function SWEP:PrimaryAttack( right )
	if self[_.b]:IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 1
		local eye = self[_.b]:GetEyeTrace()
		local anim = "hitcenter1"
		if ( right ) then anim = "hitcenter2" end
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
			if eye.HitPos:Distance(self[_.b]:GetShootPos())<=200 then				
				self[_.b]:SetAnimation(PLAYER_ATTACK1)
				self[_.c]:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
				bullet = {} 
				bullet.Num = 1
				bullet.Src = self[_.b]:GetShootPos()
				bullet.Dir = self[_.b]:GetAimVector()
				bullet.Spread = Vector(0,0,0)
				bullet.Tracer = 0
				bullet.Force = 25
				bullet.Damage = 150
				self[_.b]:FireBullets(bullet)
				self[_.c]:EmitSound(HitSound)
				self:SuperSpeed()
				timer.Simple(5, function()
					self:DefualtSpeed()
				end)
			else
				self[_.b]:SetAnimation(PLAYER_ATTACK1)
				self[_.c]:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
				self[_.c]:EmitSound(SwingSound)
			end
	end
end

function SWEP:SecondaryAttack() 
	if self[_.b]:IsPlayer() and ( self.lastUsedSecondary or CurTime() ) <= CurTime() then
		self.lastUsedSecondary = CurTime() + 4
		self[_.c]:EmitSound(AmbiantSound)
	end
return end

function SWEP:Reload()
	if self[_.b]:IsPlayer() and ( self.lastUsedReload or CurTime() ) <= CurTime() then
		self.lastUsedReload = CurTime() + 4
		self[_.c]:EmitSound(GrowlSound)
	end
end
function SWEP:Holster()
	if self[_.b]:IsValid() then
		self[_.b]:SetViewOffset(Vector(0,0,60))
	return!!1 end
end

AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/scp_1048a_wep")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "Xy"
SWEP.Contact		= "Xy_ @ Steam Community"
SWEP.Purpose		= "Scream"
SWEP.Instructions	= "Primary to scream, Secondary to break glass"
SWEP.Category = "Atlas Uprising - Temp SCP Sweps"
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_357.mdl"
SWEP.WorldModel		= "models/weapons/v_357.mdl"
SWEP.PrintName		= "SCP-1048-A"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.25
SWEP.droppable				= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Automatic	= false
SWEP.Secondary.NextAttack = 0
SWEP.Secondary.Delay = 1
SWEP.NextAttackW = 0
SWEP.Primary.Delay = 5
SWEP.Primary.Damage = 20
SWEP.oldv = 60
SWEP.AttackIsActive = false
function SWEP:Initialize()
	util.PrecacheSound("weapon/1048-swep/scream.wav")
	util.PrecacheSound("weapon/1048-swep/slime_s.wav")
	self:SetHoldType("normal")
end
function SWEP:Deploy()
	self:GetOwner():DrawViewModel( false )
	self:GetOwner():DrawWorldModel(false)
	self:GetOwner():SetViewOffset(Vector(0,0,30))
end
function SWEP:Holster()
	self:GetOwner():SetViewOffset(Vector(0,0,60))
	return true
end
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextAttackW then return end
	self.AttackIsActive = true
	self:GetOwner():EmitSound("weapon/1048-swep/scream.wav",  SNDLVL_100dB, 100, 1,  CHAN_WEAPON)
	function ApplyEffect()
		if SERVER then
		local findents = ents.FindInSphere( self:GetOwner():GetPos(), 400 )
		local foundplayers = {}
		for k,v in pairs(findents) do
			if v:IsPlayer() then
				if !(v:Team() == TEAM_SCP or v:Team() == TEAM_SPEC or v == self:GetOwner()) then
					table.ForceInsert(foundplayers, v)
				end
			end
		end
		if #foundplayers > 0 then
			for index,ply in pairs(foundplayers) do
				if SERVER then
					ply:EmitSound("weapon/1048-swep/slime_s.wav",  SNDLVL_25dB, 100, 1,  CHAN_WEAPON)
					ply:SendLua( 'surface.PlaySound("weapon/1048-swep/slime_s.wav")' )
					ply:TakeDamage(self.Primary.Damage, self:GetOwner(), self:GetOwner() )
				end
			end
		end
	end
	end
	function NotAttacking()
		self.AttackIsActive = false
	end
	timer.Create("EFFECT_DURATION_SCP_1048_A_1", 1, 6, ApplyEffect)
	timer.Simple(6, NotAttacking)
	self.NextAttackW = CurTime() + self.Primary.Delay + 6
end
function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if (CurTime() < self.Secondary.NextAttack) then return end
	self.Secondary.NextAttack = CurTime() + self.Secondary.Delay
		local ent = nil
		local tr = util.TraceHull( {
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector() * 100 ),
			filter = self:GetOwner(),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity
		if IsValid(ent) then
			if ent:GetClass() == "func_breakable" then
				if SERVER then
					ent:TakeDamage( 100, self:GetOwner(), self:GetOwner() )
				end
			end
		end
end

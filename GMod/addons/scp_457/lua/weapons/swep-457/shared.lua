AddCSLuaFile()

SWEP.Base                   = "weapon_base" 
SWEP.Spawnable              = true
SWEP.AdminOnly              = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Delay          = 2
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "None"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "None"
SWEP.Weight                 = 3
SWEP.AutoSwitchTo           = false
SWEP.AutoSwitchFrom         = false
SWEP.Slot                   = 0
SWEP.SlotPos                = 1
SWEP.DrawAmmo               = false
SWEP.DrawCrosshair          = true
SWEP.droppable              = false     
SWEP.PrintName	            = "SCP-457 SWEP"
SWEP.HoldType	            = ""
SWEP.ViewModel              = ""
SWEP.WorldModel             = ""
SWEP.Author			        = "Naz"
SWEP.Instructions	        = "Burn and incinerate everything in your way"
SWEP.Contact		        = ""
SWEP.Purpose		        = "SWEP for SCP 457"
SWEP.Category		        = "SCP"

local weaponOwner = nil

function SWEP:Initialize()
end

function SWEP:Deploy()
    local this = self
end

function SWEP:Holster()
    return true
end

function SWEP:OnRemove()
end


function SWEP:PrimaryAttack()
	if CLIENT then return end
	local ply = self:GetOwner()
	local shootpos = ply:GetShootPos()
	local endshootpos = shootpos + ply:GetAimVector() * 375 
	local tr = util.TraceLine({
		start = shootpos,
		endpos = endshootpos,
		filter = ply,
		mask = MASK_SHOT_HULL
	})
	local target = tr.Entity
	if IsValid(target) and (target:IsPlayer() or target:IsNPC()) then
		self:SetNextPrimaryFire(CurTime() + 5)  
		target:Ignite(3) 
		ply:EmitSound("weapons/scp457/Sighting.ogg", 675, 100, 0.5, CHAN_AUTO)
	end
end

SWEP.SecondaryAttackCount = 0

function SWEP:SecondaryAttack()
	if CLIENT then return end
	local ply = self:GetOwner()

	self.SecondaryAttackCount = self.SecondaryAttackCount + 1

	if self.SecondaryAttackCount == 1 then
		ply:EmitSound("weapons/scp457/Scream1.ogg", 675, 100, 0.5, CHAN_AUTO)
	elseif self.SecondaryAttackCount == 2 then
		ply:EmitSound("weapons/scp457/Scream2.ogg", 675, 100, 0.5, CHAN_AUTO)
	elseif self.SecondaryAttackCount == 3 then
		ply:EmitSound("weapons/scp457/Scream2.ogg", 675, 100, 0.5, CHAN_AUTO)
		self.SecondaryAttackCount = 0 
	end
end


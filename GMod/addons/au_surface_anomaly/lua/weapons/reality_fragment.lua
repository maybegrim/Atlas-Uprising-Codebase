AddCSLuaFile()

SWEP.Base 					= "weapon_base"

SWEP.PrintName 				= "Reality Fragment"
SWEP.Author 				= ""

SWEP.Slot 					= 0
SWEP.SlotPos 				= 99

SWEP.Spawnable 				= true
SWEP.Category 				= "AU Disruption"
SWEP.DrawCrosshair 			= true
SWEP.Crosshair 				= false

SWEP.HoldType 				= "normal"
SWEP.ViewModel 				= "models/weapons/c_arms.mdl"
SWEP.WorldModel 			= ""
SWEP.ViewModelFOV 			= 54
SWEP.ViewModelFlip 			= false
SWEP.UseHands 				= false

SWEP.Primary.Automatic		=  false
SWEP.Primary.Ammo			=  "none"

SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Ammo			=  "none"

SWEP.DrawAmmo 				= false
SWEP.DrawCrosshair 			= true

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end


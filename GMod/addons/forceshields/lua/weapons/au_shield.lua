SWEP.PrintName			= "Shield Deploy"
SWEP.Author			= "SCP.GG" 
SWEP.Instructions		= "Left mouse to deploy a shield!"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/rainchu/v_nothing.mdl"
SWEP.WorldModel			= "models/weapons/rainchu/w_nothing.mdl"

function SWEP:PrimaryAttack()
    if CLIENT then
        net.Start("SCP774:ActivateShield")
        net.SendToServer()
    end
end

function SWEP:SecondaryAttack()
end

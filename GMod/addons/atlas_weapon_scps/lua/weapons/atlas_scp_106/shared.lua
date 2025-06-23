local swepVars = ATLASSCPSWEPS.SWEPVARS

SWEP.PrintName = "SCP-106"
SWEP.Author = swepVars.Author
SWEP.Category = swepVars.Category
SWEP.Instructions = "Left Click: Send a player to the pocket dimension."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""

SWEP.ShootSound = Sound("Metal.SawbladeStick")

function SWEP:Initialize()
    self:SetHoldType("normal")
end
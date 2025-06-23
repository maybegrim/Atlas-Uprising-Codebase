SWEP.PrintName = "SCP-4000-W"
SWEP.Author = "Mex de Loo <zeo.coding@gmail.com>"
SWEP.Category = "Atlas Uprising - Temp SCP Sweps"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true 

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.Weight	= 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "DrawMat")
end

SWEP.WorldModel = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

function SWEP:DrawWorldModel() end

function SWEP:PreDrawViewModel(vm)
    return true
end
AddCSLuaFile()

SWEP.PrintName = "Class-A Amnestics"
SWEP.Author = "Astral"
SWEP.Instructions = "Press ALT-E to read. Press left click to edit!"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true
SWEP.DrawAmmo = true

SWEP.ViewModel = "models/props_lab/clipboard.mdl"
SWEP.WorldModel = "models/props_lab/clipboard.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""
SWEP.DrawAmmo = false

SWEP.HoldType = "slam"

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    local medkitSeq = ply:LookupSequence("medkit")

    -- Play the animation if the sequence exists
    if medkitSeq >= 0 then
        ply:SetCycle(0) -- Start at the beginning of the animation
        ply:ResetSequence(medkitSeq)
    else
        print("Player does not have the medkit animation sequence!")
    end
end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end
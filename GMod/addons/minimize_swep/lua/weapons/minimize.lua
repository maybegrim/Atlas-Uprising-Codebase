function Cooldown(id, time)
    if timer.TimeLeft(id) then return true end
    timer.Create(id, time, 1, function () end)
end

AddCSLuaFile()

SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.PrintName = "SCP-947"
SWEP.Slot = 5
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Sound = "Silent"


SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Sound = "Silent"


-- make weapon to appear to put hands by side
SWEP.HoldType = "normal"

SWEP.ViewModel = ""
SWEP.WorldModel = ""



function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

if SERVER then
    function SWEP:OnRemove()
        self.Minimized = false

        local owner = self:GetOwner()

        owner:SetModelScale(self.PreModelScale)
        owner:SetSlowWalkSpeed(self.PreSlowWalkSpeed)
        owner:SetCrouchedWalkSpeed(self.PreCrouchedWalkSpeed)
        owner:SetWalkSpeed(self.PreWalkSpeed)
        owner:SetRunSpeed(self.PreRunSpeed)
    end
end

function SWEP:Holster()
    return not self.Minimized
end

function SWEP:DrawWorldModel()
    
end

if SERVER then
    function SWEP:PrimaryAttack()
        if Cooldown("PrimaryFire minimize", 10) then return false end

        local owner = self:GetOwner()
        MiniMeToggle(owner)

        --[[if self.Minimized then
            self.Minimized = false

            local owner = self:GetOwner()
            owner:SetNWBool("Mini", false)
            owner:SetModelScale(self.PreModelScale)
            owner:SetSlowWalkSpeed(self.PreSlowWalkSpeed)
            owner:SetCrouchedWalkSpeed(self.PreCrouchedWalkSpeed)
            owner:SetWalkSpeed(self.PreWalkSpeed)
            owner:SetRunSpeed(self.PreRunSpeed)

            owner:SetViewOffset(owner.PrevOffset)
            owner:SetHull(owner.PrevHull, owner.PrevHullTwo)
            owner:SetHullDuck(owner.PrevHullDuck, owner.PrevHullDuckTwo)
        else
            self.Minimized = true

            local owner = self:GetOwner()
            MiniMeToggle(owner)
            self.PreModelScale = owner:GetModelScale()
            self.PreWalkSpeed = owner:GetWalkSpeed()
            self.PreCrouchedWalkSpeed = owner:GetCrouchedWalkSpeed()
            self.PreSlowWalkSpeed = owner:GetSlowWalkSpeed()
            self.PreRunSpeed = owner:GetRunSpeed()
            owner:SetNWBool("Mini", true)

            owner:SetModelScale(0.02)
            owner:SetSlowWalkSpeed(5)
            owner:SetCrouchedWalkSpeed(5)
            owner:SetWalkSpeed(10)
            owner:SetRunSpeed(20)
            owner.PrevOffset = owner:GetViewOffset()
            owner.PrevHull, owner.PrevHullTwo = owner:GetHull()
            owner.PrevHullDuck, owner.PrevHullDuckTwo = owner:GetHullDuck()
            owner:SetViewOffset(Vector(0, 0, 15))
            owner:SetHull(Vector( -16, -16, 0 ), Vector( 16, 16, 1 ))
            owner:SetHullDuck(Vector( -16, -16, 0 ), Vector( 16, 16, 1 ))
        end]]
    end
end
AddCSLuaFile()

SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.PrintName = "Amnestic"
SWEP.Slot = 5
SWEP.SlotPos = 2

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "[AU] Amnestics"

SWEP.ViewModel = "models/weapons/darky_m/c_syringe_v2.mdl"
SWEP.WorldModel = "models/weapons/darky_m/w_syringe_v2.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "slam"

SWEP.Insert = 0
SWEP.IdleTimer = CurTime()
SWEP.InsertTimer = CurTime()

SWEP.ActiveAfflict = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    return true
end

function SWEP:Holster()
    self.Insert = 0
    self.IdleTimer = CurTime()
    self.InsertTimer = CurTime()
    return true
end

function SWEP:PrimaryAttack()
    local Owner = self:GetOwner()

    local Traced = self:CheckTrace()

    if IsValid(Traced) and Traced:IsPlayer() or Traced:IsNPC() then
        Owner:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND)
        if CLIENT then return end
        local CT = CurTime()

        self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
        self.Target = Traced
        self.TraceCheckTimer = CurTime() + 0.2
        self.Insert = 2
        self.InsertTimer = CT + Owner:GetViewModel():SequenceDuration()
        self.SoundTimer = CT + 0.3
    end
end

function SWEP:RemoveUsedSWEP()
    local owner = self:GetOwner()
    if IsValid(owner) and owner:IsPlayer() and owner:HasWeapon(self:GetClass()) then
        owner:StripWeapon(self:GetClass())
    end
end

function SWEP:CheckTrace()
    local Owner = self:GetOwner()
    Owner:LagCompensation(true)

    local Trace = util.TraceLine({
        start = Owner:GetShootPos(),
        endpos = Owner:GetShootPos() + Owner:GetAimVector() * 64,
        filter = Owner
    })

    Owner:LagCompensation(false)

    return Trace.Entity
end

function SWEP:CancelAfflict()
    self.Insert = 0
    self.IdleTimer = CurTime()
    self.Target = nil
end

function SWEP:Think()
    local CT = CurTime()
    local Owner = self:GetOwner()

    if self.IdleTimer <= CT then
        self:IdleAnimation()
    end

    if CLIENT then return end

    if self.Insert == 2 then
        if self.InsertTimer <= CT then
            if self.ActiveAfflict then return end
            self:Afflict(self.Target)
            self.TraceCheckTimer = nil
        end

        if self.TraceCheckTimer and self.TraceCheckTimer <= CT then
            if self:CheckTrace() != self.Target then
                self:CancelAfflict()
            else
                self.TraceCheckTimer = CurTime() + 0.2
            end
        end
    end
end

function SWEP:IdleAnimation()
    if SERVER and self.Insert == 0 then
        self:SendWeaponAnim(ACT_VM_IDLE)
        self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
    end
end

function SWEP:Afflict(target)
    if SERVER then
        local effects = self.AmnesticEffects or "Your memories are altered."
        local owner = self:GetOwner()
        if not self.ActiveAfflict then
            self.ActiveAfflict = true
        end

        AU.Amnestics.Prompt(target, function (ply, accept)
            if accept then
                local success = math.random(1, 100) <= 5
                    if success then
                        ply:AUMessage("You successfully resisted the amnestics. All of your memories are intact.")
                        owner:AUMessage("The target resisted the amnestics.")
                        self.ActiveAfflict = false
                        self:Remove()
                    else
                        ply:AUMessage("You failed to resist the amnestics. " .. effects)
                        owner:AUMessage("The target failed to resist the amnestics.")
                        self.ActiveAfflict = false
                        self:Remove()
                    end
            else
                ply:AUMessage("You failed to resist the amnestics. " .. effects)
                owner:AUMessage("The target failed to resist the amnestics.")
                self.ActiveAfflict = false
                self:Remove()
            end
        end)
    end
end


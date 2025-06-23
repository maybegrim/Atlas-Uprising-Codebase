AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 5
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Extractor"
SWEP.Author = "Buckell"

SWEP.ViewModel = Model("models/e7/gmod/renderhub/items/syringe/syringe_blood.mdl")
SWEP.WorldModel = Model("models/e7/gmod/renderhub/items/syringe/syringe_blood.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Category = "[AU] Elixir"

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = -1     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false        -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.5)

    if self:GetNWBool("extracting") then return end

    local owner = self:GetOwner()

    owner:LagCompensation(true)
    local trace = owner:GetEyeTrace()
    owner:LagCompensation(false)

    local entity = trace.Entity

    if not IsValid(entity) then return end

    if owner:GetShootPos():DistToSqr(trace.HitPos) > 10000 then return end

    local extract_table = hook.Run("Elixir.AttemptExtraction", owner, entity)

    if not extract_table then return end

    self:SetHoldType("pistol")

    self:SetNWBool("extracting", true)
    self:SetNWEntity("entity", entity)
    self:SetNWFloat("start_time", CurTime())
    self:SetNWFloat("end_time", CurTime() + extract_table.extraction_time)
    
    self.ExtractInfo = extract_table
end

function SWEP:Succeed()
    self:SetHoldType("normal")

    if SERVER then
        local owner = self:GetOwner()

        self.ExtractInfo.on_complete(owner, self:GetNWEntity("entity"))
    end

    self:SetNWBool("extracting", false)
    self:SetNWEntity("entity", nil)
end

function SWEP:Fail()
    self:SetNWBool("extracting", false)
    self:SetNWEntity("entity", nil)

    self:SetHoldType("normal")
end

function SWEP:Think()
    local trace = self:GetOwner():GetEyeTrace()
    
    if not IsValid(trace.Entity) or trace.Entity != self:GetNWEntity("entity") or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
        self:Fail()
    elseif self:GetNWFloat("end_time") <= CurTime() then
        self:Succeed()
    end
end

function SWEP:DrawHUD()
    if not self:GetNWBool("extracting") then return end

    local start_time = self:GetNWFloat("start_time")
    local end_time = self:GetNWFloat("end_time")
    local cur_time = CurTime()

    local progress = (cur_time - start_time) / (end_time - start_time)

    draw.RoundedBox(0, (ScrW() - 300) / 2, (ScrH() - 60) / 2, 300, 60, Color(39, 36, 42))
    draw.RoundedBox(0, (ScrW() - 300) / 2 + 7, (ScrH() - 60) / 2 + 7, Lerp(progress, 0, 286), 46, Color(104, 26, 145))
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end
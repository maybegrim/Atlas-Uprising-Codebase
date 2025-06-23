AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 5
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Engineer's Wrench"
SWEP.Author = "Buckell"

SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Category = "[AU] Door System"

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

    if self:GetNWBool("repairing") then return end

    local owner = self:GetOwner()

    owner:LagCompensation(true)
    local trace = owner:GetEyeTrace()
    owner:LagCompensation(false)

    local entity = trace.Entity

    if not IsValid(entity) or (not entity.DoorBroken and not entity.DoorController) then return end

    if owner:GetShootPos():DistToSqr(trace.HitPos) > 10000 then return end

    self:SetHoldType("pistol")

    self:SetNWBool("repairing", true)
    self:SetNWEntity("entity", entity)
    self:SetNWFloat("start_time", CurTime())
    self:SetNWFloat("end_time", CurTime() + AU.DoorSystem.GetDoorRepairTime(entity.DoorController and entity.DoorEntities[1] or entity))
end

function SWEP:Succeed()
    self:SetHoldType("normal")

    if SERVER then
        local entity = self:GetNWEntity("entity")

        if entity.DoorController then
            entity.DoorEntities[1]:RepairDoor()
        else
            entity:RepairDoor()
        end
    end

    self:SetNWBool("repairing", false)
    self:SetNWEntity("entity", nil)
end

function SWEP:Fail()
    self:SetNWBool("repairing", false)
    self:SetNWEntity("entity", nil)

    self:SetHoldType("normal")
end

function SWEP:Think()
    if not self:GetNWBool("repairing", false) then return end

    local trace = self:GetOwner():GetEyeTrace()
    
    if not IsValid(trace.Entity) or trace.Entity != self:GetNWEntity("entity") or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
        self:Fail()
    elseif self:GetNWFloat("end_time") <= CurTime() then
        self:Succeed()
    end
end

function SWEP:DrawHUD()
    if not self:GetNWBool("repairing") then return end

    local start_time = self:GetNWFloat("start_time")
    local end_time = self:GetNWFloat("end_time")
    local cur_time = CurTime()

    local progress = (cur_time - start_time) / (end_time - start_time)

    draw.RoundedBox(0, (ScrW() - 300) / 2, (ScrH() - 60) / 2, 300, 60, Color(46, 30, 20))
    draw.RoundedBox(0, (ScrW() - 300) / 2 + 7, (ScrH() - 60) / 2 + 7, Lerp(progress, 0, 286), 46, Color(180, 90, 26))
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack()
end
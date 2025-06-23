AddCSLuaFile()

if SERVER then util.AddNetworkString("Amnestics:Receieve") end

SWEP.PrintName = "Class-B Amnestics"
SWEP.Author = "Astral"
SWEP.Instructions = "Left mouse click to administer Amnestics."

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true
SWEP.DrawAmmo = true

SWEP.ViewModel = "models/e7/gmod/renderhub/items/syringe/syringe_blood.mdl"
SWEP.WorldModel = "models/e7/gmod/renderhub/items/syringe/syringe_blood.mdl"

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
SWEP.UseHands = true

local droopieDuration = 10
local warpStrength = 0.5

local progressBarDuration = 3
local progressBarColor = Color(255, 255, 255, 200)
local isShooting = false
local shootStartTime = 0
local range = 125

local slow = 100

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 5)
    local ply = self:GetOwner()
    local tr = util.GetPlayerTrace(ply)
    local trace = util.TraceLine(tr)
    local target = trace.Entity
    if not target or not target:IsValid() or not target:IsPlayer() or (target:GetPos():Distance(ply:GetPos()) > range) then return end

    isShooting = true
    shootStartTime = CurTime()
    self.Target = trace.Entity
end

function SWEP:SecondaryAttack() end

function SWEP:Reload() end

function SWEP:Think()
    local ply = self:GetOwner()
    local tr = util.GetPlayerTrace(ply)
    local trace = util.TraceLine(tr)
    local target = trace.Entity
    if not (target == self.Target) or (target:GetPos():Distance(ply:GetPos()) > range) then isShooting = false return end

    if not ply:KeyDown(IN_ATTACK) and isShooting then
        isShooting = false
    elseif isShooting and (shootStartTime + 3) < CurTime() then
        isShooting = false
        ply:SetAnimation(PLAYER_ATTACK1)
        ply:EmitSound("amnestics/syringe.mp3", 50)
        if not SERVER then return end
        ply:Say("/me Administers amnestics into: ".. trace.Entity:Nick())
        target:SetWalkSpeed(target:GetWalkSpeed() - slow)
        target:SetRunSpeed(target:GetRunSpeed() - slow)
        timer.Create("AMNESTIC:".. target:SteamID64(), droopieDuration, 1, function()
            if not target:IsValid() then return end
            print("test")
            target:SetWalkSpeed(target:GetWalkSpeed() + slow)
            target:SetRunSpeed(target:GetRunSpeed() + slow)
        end)
        net.Start("Amnestics:Receieve")
            net.WriteBool(true)
        net.Send(target)
    end
    self:NextThink(CurTime())
    return true
end

hook.Add( "PlayerDeath", "GlobalDeathMessage", function( victim, inflictor, attacker )
    if timer.Exists("AMNESTIC:".. victim:SteamID64()) then timer.Remove("AMNESTIC:".. victim:SteamID64()) end
end )

function SWEP:DrawWorldModel()
    local ply = self:GetOwner()

    if not IsValid(ply) then self:DrawModel() return end
    local boneIndex = ply:LookupBone("ValveBiped.Bip01_R_Hand")
    if not boneIndex then return end
    local bonePos, boneAng = ply:GetBonePosition(boneIndex)

    local forwardOffset = 4
    local upOffset = -1.5
    local rightOffset = 2
    local newPos = bonePos + boneAng:Forward() * forwardOffset + boneAng:Up() * upOffset + boneAng:Right() * rightOffset
    boneAng = boneAng - Angle(-180, 0, 0)

    local thumbBaseBoneIndex = ply:LookupBone("ValveBiped.Bip01_R_Finger0")
    if thumbBaseBoneIndex then
        ply:ManipulateBoneAngles(thumbBaseBoneIndex, Angle(0, 10, 0))
    end

    local thumbMidBoneIndex = ply:LookupBone("ValveBiped.Bip01_R_Finger01")
    if thumbMidBoneIndex then
        ply:ManipulateBoneAngles(thumbMidBoneIndex, Angle(0, 40, 0))
    end

    local thumbEndBoneIndex = ply:LookupBone("ValveBiped.Bip01_R_Finger02")
    if thumbEndBoneIndex then
        ply:ManipulateBoneAngles(thumbEndBoneIndex, Angle(0, 35, 0))
    end

    self:SetRenderOrigin(newPos)
    self:SetRenderAngles(boneAng)
    self:DrawModel()
end

if not CLIENT then return end

local droopieEnabled = false
local droopieStartTime = 0

net.Receive("Amnestics:Receieve", function()
    local bool = net.ReadBool()
    droopieEnabled = bool
    droopieStartTime = CurTime()
end)

hook.Add("RenderScreenspaceEffects", "DroopieEffectScreenWarp", function()
    if droopieEnabled then
        local timeElapsed = CurTime() - droopieStartTime
        local ply = LocalPlayer()
        if not ply:Alive() then droopieEnabled = false end

        if timeElapsed >= droopieDuration then
            droopieEnabled = false
            return
        end
        DrawSharpen(1, warpStrength * 10)
        DrawMotionBlur(0.1, warpStrength, 0.01)
    end
end)

local function DrawRadialProgress(x, y, radius, thickness, startAngle, progress, color)
    local segments = 100
    local step = (360 * progress) / segments
    local angle = startAngle

    surface.SetDrawColor(color)
    for i = 1, segments do
        local nextAngle = angle + step
        local rad1 = math.rad(angle)
        local rad2 = math.rad(nextAngle)

        local x1 = x + radius * math.cos(rad1)
        local y1 = y - radius * math.sin(rad1)
        local x2 = x + radius * math.cos(rad2)
        local y2 = y - radius * math.sin(rad2)

        local x3 = x + (radius - thickness) * math.cos(rad2)
        local y3 = y - (radius - thickness) * math.sin(rad2)
        local x4 = x + (radius - thickness) * math.cos(rad1)
        local y4 = y - (radius - thickness) * math.sin(rad1)

        surface.DrawPoly({
            {x = x1, y = y1},
            {x = x2, y = y2},
            {x = x3, y = y3},
            {x = x4, y = y4}
        })

        angle = nextAngle
    end
end

function SWEP:DrawHUD()
    local client = LocalPlayer()
    if not client:Alive() then return end

    local screenWidth, screenHeight = ScrW(), ScrH()
    local centerX, centerY = screenWidth / 2, screenHeight / 2

    if isShooting then
        local barRadius = 50
        local barThickness = 8
        local elapsed = CurTime() - shootStartTime
        local progress = math.Clamp(elapsed / progressBarDuration, 0, 1)

        DrawRadialProgress(centerX, centerY, barRadius, barThickness, 0, progress, progressBarColor)
    end
end

function SWEP:GetViewModelPosition(pos, ang)
    pos = pos + ang:Forward() * 9
    pos = pos + ang:Right() * 3
    pos = pos + ang:Up() * -3

    ang = ang - Angle(-180, 0, 0)
    return pos, ang
end
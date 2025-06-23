if SERVER then
    AddCSLuaFile()
    resource.AddFile("sound/custom/recovery.mp3")
    util.AddNetworkString("SCP966_ConcussionUI")
    util.AddNetworkString("SCP966_RemoveEffect")
    util.AddNetworkString("SCP966_SetTargetColor")
    util.AddNetworkString("SCP966:SyncTable")
    util.AddNetworkString("SCP966_Effect")
    util.AddNetworkString("ATLAS.966.Receive")
    util.AddNetworkString("ATLAS.966.Remove")
end

if CLIENT then
    sound.Add({
        name = "MW_Med_sound",
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 75,
        pitch = 100,
        sound = "custom/recovery.wav"
    })
end

if CLIENT then
    local Red_Screen = Color(255, 0, 0, 60)
    local Cure_Sound = "MW_Med_sound"

    local function CleanupSCP966Effects()
        hook.Remove("HUDPaint", "SCP966_Vignette")
        hook.Remove("RenderScreenspaceEffects", "SCP966_Effects")
        hook.Remove("StartCommand", "SCP966_Sleep")
        hook.Remove("RenderScreenspaceEffects", "SCP966_Sleep")
        gui.EnableScreenClicker(false)
        if timer.Exists("SCP966_WakeUp") then timer.Remove("SCP966_WakeUp") end
    end

    local function GoToSleep()
        local darknessAmount = -0.8
        gui.EnableScreenClicker(true)

        hook.Add("RenderScreenspaceEffects", "SCP966_Sleep", function()
            if not LocalPlayer():Alive() then hook.Remove("RenderScreenspaceEffects", "SCP966_Sleep") CleanupSCP966Effects() return end
            local colorMod = {
                ["$pp_colour_addr"] = 0,
                ["$pp_colour_addg"] = 0,
                ["$pp_colour_addb"] = 0,
                ["$pp_colour_brightness"] = darknessAmount,
                ["$pp_colour_contrast"] = 1,
                ["$pp_colour_colour"] = 0.1,
                ["$pp_colour_mulr"] = 0,
                ["$pp_colour_mulg"] = 0,
                ["$pp_colour_mulb"] = 0
            }
            DrawColorModify(colorMod)
        end)

        hook.Add("StartCommand", "SCP966_Sleep", function(ply, cmd)
            if not LocalPlayer():Alive() then CleanupSCP966Effects() return end
            cmd:ClearMovement()
            cmd:ClearButtons()
        end)

        timer.Create("SCP966_WakeUp", 30, 1, function()
            CleanupSCP966Effects()
            PlayConcussionEffectSCP966()
        end)
    end

     -- Fall completelly asleep feature. Done
     -- Do not feed option, Show images etc.

    function PlayConcussionEffectSCP966() -- Semi-Decent effect. When hit but not unconcious.
        surface.PlaySound(Cure_Sound) -- Does not work
        
        hook.Add("HUDPaint", "SCP966_Vignette", function()
            if not LocalPlayer():Alive() then CleanupSCP966Effects() end
            surface.SetDrawColor(Red_Screen)
            surface.DrawRect(0, 0, ScrW(), ScrH())
        end)

        local blurAmount = 0.3
        local invertAmount = 0.6
        local darkeningAmount = -0.8

        hook.Add("RenderScreenspaceEffects", "SCP966_Effects", function()
            if not LocalPlayer():Alive() then CleanupSCP966Effects() end
            DrawMotionBlur(0.2, blurAmount, 0.05)
            local colorMod = {
                ["$pp_colour_addr"] = invertAmount,    -- Red adjustment
                ["$pp_colour_addg"] = invertAmount,    -- Green adjustment
                ["$pp_colour_addb"] = invertAmount,    -- Blue adjustment
                ["$pp_colour_brightness"] = darkeningAmount,
                ["$pp_colour_contrast"] = 1,
                ["$pp_colour_colour"] = 0.1,           -- Saturation control
                ["$pp_colour_mulr"] = 0,
                ["$pp_colour_mulg"] = 0,
                ["$pp_colour_mulb"] = 0
            }
            DrawColorModify(colorMod)
        end)
    end

    local function concussionController()
        local unconcious = net.ReadBool()
        if unconcious then
            GoToSleep()
            return
        end
        PlayConcussionEffectSCP966()
    end

    local haloList = {}

    local function UpdateHaloList()
        haloList = net.ReadTable()
        hook.Add( "PreDrawHalos", "SCP:966:DrawTargets", function()
            if not LocalPlayer():HasWeapon("au_966_new") then hook.Remove("PreDrawHalos", "SCP:966:DrawTargets") return end
            halo.Add( haloList, Color( 255, 0, 0 ), 5, 5, 2 )
        end )
    end

    -- Network receivers
    net.Receive("SCP966_ConcussionUI", concussionController)
    net.Receive("SCP966_Effect", concussionController)
    net.Receive("SCP966_RemoveEffect", CleanupSCP966Effects)
    net.Receive("SCP966:SyncTable", UpdateHaloList)

    local SCP966s = {}
    
    net.Receive("ATLAS.966.Receive", function()
        local scp966 = net.ReadEntity()
        SCP966s[scp966] = true
    end)

    net.Receive("ATLAS.966.Remove", function()
        local scp966 = net.ReadEntity()
        if SCP966s[scp966] then 
            SCP966s[scp966] = nil 
            scp966:SetNoDraw(false) 
        end
    end)
end

SWEP.PrintName = "scp_966_rw"
SWEP.Author = "Bilbo"
SWEP.Instructions = "Left-Click DMG; Right-Click Annoy"
SWEP.Category = "SCP"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_arms.mdl"  
SWEP.WorldModel = ""  
SWEP.UseHands = true  
SWEP.ViewModelFOV = 54 

SWEP.Primary.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST
SWEP.Secondary.Animation = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST

SWEP.Primary = {}
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary = {}
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.SlashDamage = 30
SWEP.HeavySlashDamage = 60
SWEP.HeavySlashCount = 3
SWEP.SlashCooldown = 1
SWEP.HeavySlashCooldown = 2  
SWEP.AbilityCooldown = 120

function SWEP:Initialize()
    self:SetHoldType("melee")
    self.slashCount = 0  
    self.isWindingUp = false
    self.windUpStart = 0
end

local scp966 = {}

function SWEP:Equip()
    scp966[self:GetOwner()] = true
end

function SWEP:Destroy()
    if not self:GetOwner() or not scp966[self:GetOwner()] then return end
    scp966[self:GetOwner()] = false
end

local coolFixTable = {}

function AddCondition966(ply, condition)
    if not ply.SCPConditions then ply.SCPConditions = {} end
    ply.SCPConditions[condition] = true
    table.insert(coolFixTable, ply)
    if SERVER then
        for ply,_ in pairs(scp966) do
            net.Start("SCP966:SyncTable")
                net.WriteTable(coolFixTable)
            net.Send(ply)
        end
    end
end

function RemoveCondition966(ply, condition)
    if not ply.SCPConditions[condition] then return end
    ply.SCPConditions[condition] = nil
    table.RemoveByValue(coolFixTable, ply)
    if SERVER then
        for ply,_ in pairs(scp966) do
            net.Start("SCP966:SyncTable")
                net.WriteTable(coolFixTable)
            net.Send(ply)
        end
    end
end

function HasCondition966(ply, condition)
    if not ply.SCPConditions then return false end
    if not ply.SCPConditions[condition] then return false end
    return true
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    if not IsValid(self:GetOwner()) then return end
    if self.isWindingUp then return end
    self.slashCount = (self.slashCount or 0) + 1
    local isHeavySlash = self.slashCount >= self.HeavySlashCount
    
    if isHeavySlash then
        self.isWindingUp = true
        self.windUpStart = CurTime()
        
        timer.Simple(1.5, function()
            if not IsValid(self) or not IsValid(self:GetOwner()) then return end
            self:PerformAttack(true)
            self:ResetSlashCount()
            self.isWindingUp = false
        end)
    else
        self:PerformAttack(false)
    end


    local cooldown = isHeavySlash and self.HeavySlashCooldown or self.SlashCooldown
    self:SetNextPrimaryFire(CurTime() + cooldown)
end

function SWEP:PerformAttack(isHeavy)
    local ply = self:GetOwner()

    local traceData = {
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 100,
        filter = ply,
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10)
    }

    local tr = util.TraceHull(traceData)
    local dmg = isHeavy and self.HeavySlashDamage or self.SlashDamage

    if tr.Hit and IsValid(tr.Entity) then
        ply:EmitSound("Weapon_Crowbar.Single", 75, 100, 1, CHAN_WEAPON)
        if not SERVER then return end
        tr.Entity:TakeDamage(dmg, ply, self)
    end
end

function SWEP:ResetSlashCount()
    self.slashCount = 0
end

if CLIENT then
    hook.Add("HUDPaint", "HeavyAttackWindUpBar", function() -- Swep DrawHUD
        local ply = LocalPlayer()
        local weapon = ply:GetActiveWeapon()
        
        if not IsValid(weapon) or not weapon:GetClass() == "scp_966_rw" or not weapon.isWindingUp then 
            -- print("Invalid weapon or not winding up")
            return 
        end
        
        local elapsed = CurTime() - (weapon.windUpStart or 0)
        local progress = math.Clamp(elapsed / 1.5, 0, 1)
        
        if progress >= 1 then 
            print("Progress complete")
            return 
        end
        
        local x, y = ScrW() / 2, ScrH() / 2 + 30
        local barWidth, barHeight = 100, 10
        
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(x - barWidth / 2 - 2, y - barHeight / 2 - 2, barWidth + 4, barHeight + 4)
        
        surface.SetDrawColor(255, 50, 50, 200)
        surface.DrawRect(x - barWidth / 2, y - barHeight / 2, barWidth * progress, barHeight)
        
        // print("Drawing HUD element")
    end)
end

function SWEP:SecondaryAttack()
    if not IsValid(self:GetOwner()) then return end
    if CurTime() < self:GetNextSecondaryFire() then return end

    local ply = self:GetOwner()
    local traceData = {
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 500,
        filter = ply  
    }

    local tr = util.TraceLine(traceData)

    local target = tr.Entity
    if not SERVER then return end
    if IsValid(target) and target:IsPlayer() and target ~= ply then
        local successRoll = 35 -- Check if the result is the same on client as on server.
        if successRoll <= 70 then
            target:ChatPrint("You feel a wave of exhaustion and dizziness.")
            ply:ChatPrint("You have affected: ".. target:Nick())
            AddCondition966(target, "SCP966Effect")
            
            net.Start("SCP966_Effect")
                net.WriteBool(true)
            net.Send(target)
        elseif IsValid(target) and target:IsPlayer() then
            target:ChatPrint("You managed to resist SCP-966's effects.")
        end
    else
        local entities = ents.FindInSphere(tr.HitPos, 200)
        for _, ent in ipairs(entities) do
            if IsValid(ent) and ent:IsPlayer() and ent ~= ply then
                local aoeSuccessRoll = math.random(1, 100)
                if aoeSuccessRoll <= 50 then
                    ent:ChatPrint("You feel a wave of exhaustion and dizziness.")
                    ply:ChatPrint("You have affected: ".. ent:Nick())
                    AddCondition966(ent, "SCP966Effect")
                    
                    net.Start("SCP966_Effect")
                        net.WriteBool(false)
                    net.Send(ent)
                else
                    ent:ChatPrint("You resist the wave of exhaustion.")
                end
            end
        end
    end

    self:SetNextSecondaryFire(CurTime() + self.AbilityCooldown)
end

function SWEP:Think()
    if SERVER then
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and HasCondition966(ply, "SCP966Effect") then
                if CurTime() >= (ply.Next966Damage or 0) then
                    if IsValid(self:GetOwner()) then
                        local dmg = DamageInfo()
                        dmg:SetDamage(math.random(10, 30))
                        dmg:SetAttacker(self:GetOwner())
                        dmg:SetInflictor(self)
                        ply:TakeDamageInfo(dmg)
                        
                        ply.Next966Damage = CurTime() + math.random(30, 60)
                        ply:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 128), 0.5, 0)
                    end
                end
            end
        end
    end
end

hook.Add("PrePlayerDraw", "CustomPlayerPreRendering", function(ply)
    if not IsValid(ply) then return end
    local weapon = ply:GetActiveWeapon()
    if not IsValid(weapon) then return end
    if (weapon:GetClass() == "au_966_new") and not LocalPlayer():GetNWBool("ActiveDrGNVG", false) and not (LocalPlayer():GetActiveWeapon():GetClass() == "au_966_new") then
        return true
    end
end)

hook.Add("PlayerDeath", "SCP:966CheckDead", function(victim)
    if not HasCondition966(victim, "SCP966Effect") then return end
    RemoveCondition966(victim, "SCP966Effect")
end)

hook.Add("PlayerDisconnected", "SCP:966CheckBeforeLeave", function(ply)
    if not HasCondition966(ply, "SCP966Effect") then return end
    RemoveCondition966(ply, "SCP966Effect")
end)
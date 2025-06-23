if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.ExtraMags = 0
end

if CLIENT then
    SWEP.PrintName = "Medical Kit"
    SWEP.Slot = 0
    SWEP.SlotPos = 0
	
	SWEP.AimPos = Vector(-3.412, -6.4, -2.238)
	SWEP.AimAng = Vector(7.353, 0, 0)
		
	SWEP.WMAng = Vector(0, 180, 180)
	SWEP.WMPos = Vector(5, -4, 0.25)
	
	SWEP.SprintPos = Vector(0, 0, 0)
	SWEP.SprintAng = Vector(0, 0, 0)
	SWEP.MoveType = 3
	SWEP.MuzzleName = "2"
	SWEP.NoNearWall = true
end

SWEP.HoldType = "slam"
SWEP.NoProficiency = true
SWEP.NoAttachmentMenu = true

SWEP.Anims = {}
SWEP.Anims.Draw_First = "deploy"
SWEP.Anims.Draw = "deploy"
SWEP.Anims.Holster = "holster"
SWEP.Anims.Slash = {"slash_1", "slash_2"}
SWEP.Anims.Stab = {"stab_1", "stab_1"}
SWEP.Anims.Idle = "idle"
SWEP.Anims.Idle_Aim = "idle_scoped"
SWEP.Anims.PrepBackstab = "backstab_draw"
SWEP.Anims.UnPrepBackstab = "backstab_holster"
SWEP.Anims.Backstab = "backstab_stab"

SWEP.Sounds = {}
SWEP.Sounds["bandage"] = {[1] = {time = 0.4, sound = Sound("FAS2_Bandage.Retrieve")},
	[2] = {time = 1.25, sound = Sound("FAS2_Bandage.Open")},
	[3] = {time = 2.15, sound = Sound("FAS2_Hemostat.Retrieve")}}
	
SWEP.Sounds["quikclot"] = {[1] = {time = 0.3, sound = Sound("FAS2_QuikClot.Retrieve")},
	[2] = {time = 1.45, sound = Sound("FAS2_QuikClot.Loosen")},
	[3] = {time = 2.55, sound = Sound("FAS2_QuikClot.Open")}}

SWEP.Sounds["suture"] = {[1] = {time = 0.3, sound = Sound("FAS2_Hemostat.Retrieve")},
	[2] = {time = 3.5, sound = Sound("FAS2_Hemostat.Close")}}
	
SWEP.FireModes = {"semi"}

SWEP.Theme = {
    primary = Color(85, 182, 137),
    background = Color(0, 0, 0),
    light = Color(255, 255, 255),
    secondary = Color(1, 153, 1),
    background_light = Color(200, 200, 200),
}


SWEP.Category = "Atlas Weapons: Medical"
SWEP.Base = "fas2_base"
SWEP.Author            = "Spy"

SWEP.Contact        = ""
SWEP.Purpose        = ""
SWEP.Instructions    = "Left Click - Use bandage\nRight Click - Use hemostat/quikclot"

SWEP.ViewModelFOV    = 53
SWEP.ViewModelFlip    = false

SWEP.Spawnable            = true
SWEP.AdminSpawnable        = true

SWEP.VM = "models/weapons/v_ifak.mdl"
SWEP.WM = "models/weapons/w_ifak.mdl"
SWEP.WorldModel   = "models/Items/HealthKit.mdl"

-- Primary Fire Attributes --
SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic       = false    
SWEP.Primary.Ammo             = "none"
 
-- Secondary Fire Attributes --
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic       = false
SWEP.Secondary.Ammo         = "none"

-- Deploy related
SWEP.FirstDeployTime = 0.5
SWEP.DeployTime = 0.5
SWEP.HolsterTime = 0.1
SWEP.DeployAnimSpeed = 1

SWEP.EasterWait = 0

local nade, EA, pos, mag, CT, tr, force, phys, pos, vel, ent, dmg, tr2, am
local td = {}

local SP = game.SinglePlayer()

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.Class = self:GetClass()
	
	if CLIENT then
		self.BlendPos = Vector(0, 0, 0)
		self.BlendAng = Vector(0, 0, 0)
		
		self.NadeBlendPos = Vector(0, 0, 0)
		self.NadeBlendAng = Vector(0, 0, 0)
		self.ViewModelFOV_Orig = self.ViewModelFOV
		
		if not self.Wep then
			self.Wep = self:createManagedCModel(self.VM, RENDERGROUP_BOTH)
			self.Wep:SetNoDraw(true)
			
			RunConsoleCommand("fas2_handrig_applynow")
		end
		
		if not self.W_Wep and self.WM then
			self.W_Wep = self:createManagedCModel(self.WM, RENDERGROUP_BOTH)
			self.W_Wep:SetNoDraw(true)
		end
		
		if not self.Nade then
			self.Nade = self:createManagedCModel("models/weapons/v_m67.mdl", RENDERGROUP_BOTH)
			self.Nade:SetNoDraw(true)
			self.Nade.LifeTime = 0
		end

		self:Deploy()
	end
end

function SWEP:Holster(wep)
	if not IsFirstTimePredicted() then
		return
	end
	
	if self == wep then
		return
	end
	
	if self.dt.Status == FAS_STAT_HOLSTER_END then
		self.dt.Status = FAS_STAT_IDLE
		return true
	end
	
	if self.HealTime and CurTime() < self.HealTime then
		return false
	end


	
	--[[if IsValid(wep) and self.dt.Status != FAS_STAT_HOLSTER_START then
		CT = CurTime()

		self:SetNextPrimaryFire(CT + (self.HolsterTime and self.HolsterTime * 2 or 0.75))
		self:SetNextSecondaryFire(CT + (self.HolsterTime and self.HolsterTime * 2 or 0.75))
		self.ReloadWait = CT + (self.HolsterTime and self.HolsterTime * 2 or 0.75)
		self.SprintDelay = CT + (self.HolsterTime and self.HolsterTime * 2 or 0.75)
		
		self.ChosenWeapon = wep:GetClass()
		
		if self.dt.Status != FAS_STAT_HOLSTER_END then
			timer.Simple((self.HolsterTime and self.HolsterTime or 0.45), function()
				if IsValid(self) and IsValid(self.Owner) and self.Owner:Alive() then
					self.dt.Status = FAS_STAT_HOLSTER_END
					self.dt.Bipod = false
					self.Owner:ConCommand("use " .. self.ChosenWeapon)
				end
			end)
		end
		
		self.dt.Status = FAS_STAT_HOLSTER_START
		self:PlayHolsterAnim()
	end]]

	if CLIENT then
		self.CurSoundTable = nil
		self.CurSoundEntry = nil
		self.SoundTime = nil
		self.SoundSpeed = 1
	end
	self:EmitSound("weapons/weapon_holster" .. math.random(1, 3) .. ".wav", 50, 100)
	return true
end

function SWEP:Equip(own)
	own:SetAmmo(4, "Bandages")
	own:SetAmmo(3, "Quikclots")
	own:SetAmmo(2, "Hemostats")
end

local p

function SWEP:Reload()

end
	
local cl, hit, ef

function SWEP:Think()
	CT = CurTime()
	
	vel = self.Owner:GetVelocity():Length()
	
	if self.dt.Status != FAS_STAT_HOLSTER_START and self.dt.Status != FAS_STAT_HOLSTER_END and self.dt.Status != FAS_STAT_QUICKGRENADE then
		if self.Owner:OnGround() then
			if self.Owner:KeyDown(IN_SPEED) and vel >= self.Owner:GetWalkSpeed() * 1.3 then
				if self.dt.Status != FAS_STAT_SPRINT then
					self.dt.Status = FAS_STAT_SPRINT
				end
			else
				if self.dt.Status == FAS_STAT_SPRINT then
					self.dt.Status = FAS_STAT_IDLE
				end
			end
		else
			if self.dt.Status != FAS_STAT_IDLE then
				self.dt.Status = FAS_STAT_IDLE
			end
		end
	end
	
	if self.CurSoundTable then
		t = self.CurSoundTable[self.CurSoundEntry]
		
		if CT >= self.SoundTime + t.time / self.SoundSpeed then
			self:EmitSound(t.sound, 70, 100)
			
			if self.CurSoundTable[self.CurSoundEntry + 1] then
				self.CurSoundEntry = self.CurSoundEntry + 1
			else
				self.CurSoundTable = nil
				self.CurSoundEntry = nil
				self.SoundTime = nil
			end
		end
	end
	
	for k, v in pairs(self.Events) do
		if CT > v.time then
			v.func()
			table.remove(self.Events, k)
		end
	end
	
	if self.TimeToAdvance and CT > self.TimeToAdvance then
		if self.AdvanceStage == "draw" then
			self:DrawGrenade()
		elseif self.AdvanceStage == "prepare" then
			self:AdvanceGrenadeThrow()
		end
	end
	
	if self.Cooking then
		if self.FuseTime then
			if not self.Owner:KeyDown(IN_ATTACK) then
				if CT > self.TimeToThrow then
					self:ThrowGrenade()
				end
			else
				if CT > self.TimeToThrow then
					self.ThrowPower = math.Approach(self.ThrowPower, 1, FrameTime())
				end
			
				if SERVER then
					if CT >= self.FuseTime then
						self.Cooking = false
						self.FuseTime = nil
						util.BlastDamage(self.Owner, self.Owner, self:GetPos(), 384, 100)
						self.Owner:Kill()
						
						ef = EffectData()
						ef:SetOrigin(self.Owner:GetPos())
						ef:SetMagnitude(1)
						
						util.Effect("Explosion", ef)
					end
				end
			end
		end
	end
	
	if not self.CurrentHeal then
		if CLIENT then
			self:SetUpBodygroups()
		end
	else
		if CT >= self.HealTime then
			if self.OwnHeal then
				self:EndSelfHealingProcess()
			else
				self:EndHealingProcess()
			end
		end
	end
end

function SWEP:EndSelfHealingProcess()
	if self.CurrentHeal == "suture" and self.Owner:GetAmmoCount("Hemostats") == 1 then
		FAS2_PlayAnim(self, "bandage_end", 1)
	else
		FAS2_PlayAnim(self, self.CurrentHeal .. "_end", 1)
	end
	
	self.Owner:RemoveAmmo(1, self.AmmoType)
	
	if CLIENT then
		self:SetUpBodygroups()
	end
	
	if SERVER then
		self.Owner:SetHealth(math.Clamp(self.Owner:Health() + self.HealAmount, 0, self.Owner:GetMaxHealth()))
	end
	
	self.CurrentHeal = nil
	self.HealTime = nil
	self.HealAmount = nil
end

function SWEP:EndHealingProcess()
	if self.CurrentHeal == "suture" and self.Owner:GetAmmoCount("Hemostats") == 1 then
		FAS2_PlayAnim(self, "bandage_end", 1)
	else
		FAS2_PlayAnim(self, self.CurrentHeal .. "_end", 1)
	end
	
	self.Owner:RemoveAmmo(1, self.AmmoType)
	
	if CLIENT then
		self:SetUpBodygroups()
	end
	
	self.CurrentHeal = nil
	self.HealTime = nil
	self.OwnHeal = false
end

function SWEP:HealTarget(amt)
	self.Target:SetHealth(math.Clamp(self.Target:Health() + amt, 0, self.Target:GetMaxHealth()))
end


function SWEP:SetUpBodygroups()
	vm = self.Wep
	vm:SetBodygroup(2, math.Clamp(self.Owner:GetAmmoCount("Bandages"), 0, 2))
	
	am = self.Owner:GetAmmoCount("Hemostats")
	
	if am > 0 then
		if am == 1 then
			vm:SetBodygroup(3, 2)
		elseif am >= 2 then
			vm:SetBodygroup(3, 3)
		end
	else
		am = self.Owner:GetAmmoCount("Quikclots")
		
		if am > 0 then
			vm:SetBodygroup(3, 1)
		else
			vm:SetBodygroup(3, 0)
		end
	end
end

local Mins, Maxs = Vector(-8, -8, -8), Vector(8, 8, 8)

function SWEP:FindHealTarget()
	td.start = self.Owner:GetShootPos()
	td.endpos = td.start + self.Owner:GetAimVector() * 50
	td.filter = self.Owner
	td.mins = Mins
	td.maxs = Maxs
	
	tr = util.TraceHull(td)
	
	if tr.Hit then
		ent = tr.Entity
		
		if IsValid(ent) and ent:IsPlayer() then
			return ent
		end
	end
	
	return self.Owner
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() or self.Cooking or self.FuseTime then
        return
    end

    self.Target = self:FindHealTarget()
	local target = self.Target

    -- Handle Alt + LMB for fixing broken legs
    if self.Owner:KeyDown(IN_WALK) and target:GetNWBool("LegsBroken", false) then
        self:FixLegs(target)
	elseif self:CanApplyBandage(target) then
        self:ApplyBandage(target)
    end
end

function SWEP:FixLegs(target)
    FAS2_PlayAnim(self, "bandage", 1)
    self:SetNextPrimaryFire(CurTime() + 2.95)
    self:SetNextSecondaryFire(CurTime() + 2.95)
    self.HealTime = CurTime() + 2.5

    if SERVER then
        ATLASMED.BONES.UnBreakLegs(target)
        target:ChatPrint("Your legs have been fixed!")
        if target ~= self.Owner then
            self.Owner:ChatPrint("You fixed " .. target:Nick() .. "'s legs!")
        end
    end

    -- Return to idle state after the animation
    timer.Simple(2.95, function()
        if IsValid(self) then
            FAS2_PlayAnim(self, "idle", 1) -- Ensure this matches your idle animation name
        end
    end)
end

function SWEP:CanApplyBandage(target)
    return self.Owner:GetAmmoCount("Bandages") > 0 and self:CanHealTarget(target)
end

function SWEP:ApplyBandage(target)
    FAS2_PlayAnim(self, "bandage", 1)
    self:SetNextPrimaryFire(CurTime() + 2.95)
    self:SetNextSecondaryFire(CurTime() + 2.95)
    self.HealTime = CurTime() + 2.5
    self.CurrentHeal = "bandage"
    self.AmmoType = "Bandages"

    if SERVER then
        self:HealTarget(20)
    end
end


function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() or self.Cooking or self.FuseTime then
        return
    end

    -- Handle grenade throwing
    if self.Owner:KeyDown(IN_USE) and self:CanThrowGrenade() then
        self:InitialiseGrenadeThrow()
        return
    end

    self.Target = self:FindHealTarget()
	local target = self.Target

    -- Handle suture application (Hemostats)
    if self:CanApplySuture(target) then
        self:ApplySuture(target)
        return
    end

    -- Handle quikclot application
    if self:CanApplyQuikclot(target) then
        self:ApplyQuikclot(target)
    end
end

function SWEP:CanApplySuture(target)
    return self.Owner:GetAmmoCount("Hemostats") > 0 and self:CanHealTarget(target)
end

function SWEP:ApplySuture(target)
    FAS2_PlayAnim(self, "suture", 1)
    self:SetNextPrimaryFire(CurTime() + 5.5)
    self:SetNextSecondaryFire(CurTime() + 5.5)
    self.HealTime = CurTime() + 4.5
    self.CurrentHeal = "suture"
    self.AmmoType = "Hemostats"

    if SERVER then
        self:HealTarget(60)
    end
end

function SWEP:CanApplyQuikclot(target)
    return self.Owner:GetAmmoCount("Quikclots") > 0 and self:CanHealTarget(target)
end

function SWEP:ApplyQuikclot(target)
    FAS2_PlayAnim(self, "quikclot", 1)
    self:SetNextPrimaryFire(CurTime() + 4.65)
    self:SetNextSecondaryFire(CurTime() + 4.65)
    self.HealTime = CurTime() + 4.2
    self.CurrentHeal = "quikclot"
    self.AmmoType = "Quikclots"

    if SERVER then
        self:HealTarget(40)
    end
end

function SWEP:CanHealTarget(target)
    return target:Health() < target:GetMaxHealth()
end


if CLIENT then
	local x, y, x2, y2, pos, ang
	local ClumpSpread = surface.GetTextureID("VGUI/clumpspread_ring")
	local White, Black, Grey, Red, Green = SWEP.Theme.light, SWEP.Theme.background, SWEP.Theme.background_light, SWEP.Theme.secondary, SWEP.Theme.primary
	
	function SWEP:Draw3D2DCamera()
		
		vm = self.Wep
		
		pos, ang = vm:GetBonePosition(vm:LookupBone("Dummy97"))
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Right(), 5)
		
		cam.Start3D2D(pos + ang:Right() * -3.8 - ang:Forward() * 3.5, ang, 0.015 * GetConVarNumber("fas2_textsize"))
			-- background for the text
			surface.SetDrawColor(Color(15, 15, 20, 120))
			surface.DrawRect(-45, -65, 365, 120)

			am = self.Owner:GetAmmoCount("Bandages")
			draw.ShadowText("BANDAGES: " .. am, "FAS2_HUD48", -40, 0, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			
			if am > 0 then
				draw.ShadowText("LMB - APPLY BANDAGE", "FAS2_HUD36", -40, -40, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				draw.ShadowText("+10 HP", "FAS2_HUD24", -40, -60, Red, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			end
		cam.End3D2D()
		
		pos, ang = vm:GetBonePosition(vm:LookupBone("Dummy98"))
		ang:RotateAroundAxis(ang:Up(), 90)
		
		cam.Start3D2D(pos + ang:Right() * -3.5 + ang:Forward(), ang, 0.015 * GetConVarNumber("fas2_textsize"))
			am = self.Owner:GetAmmoCount("Hemostats")
			-- background for the text
			surface.SetDrawColor(Color(15, 15, 20, 120))
			surface.DrawRect(-25, -65, 390, 120)

			if am > 0 then
				draw.ShadowText("HEMOSTATS: " .. am, "FAS2_HUD48", -20, 0, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				draw.ShadowText("RMB - APPLY HEMOSTAT", "FAS2_HUD36", -20, -40, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				draw.ShadowText("+30 HP", "FAS2_HUD24", -20, -60, Red, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			else
				am = self.Owner:GetAmmoCount("Quikclots")
				
				draw.ShadowText("QUIKCLOTS: " .. am, "FAS2_HUD48", -20, 0, White, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				
				if am > 0 then
					draw.ShadowText("RMB - APPLY QUIKCLOT", "FAS2_HUD36", -20, -40, Green, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
					draw.ShadowText("+20 HP", "FAS2_HUD24", -20, -60, Red, Black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				end
			end
		cam.End3D2D()
	end
	-- Colors
	local white = Color(255, 255, 255, 255)
	local black = Color(0, 0, 0, 255)
	local orange = Color(255, 165, 0, 255)
	local progressBarColor = Color(255, 165, 0, 255)  -- Orange color for the progress bar
	local progressBarBG = Color(138, 93, 10)  -- Darker background for progress bar
	local progressBarBGBG = Color(54, 36, 4)  -- Even darker background for shadow effect
	local activeColor = progressBarColor  -- Green color when action is active
	local darkerActiveColor = progressBarBG  -- Darker green for highlighted text

	function SWEP:DrawHUD()
		local FT, CT, x, y = FrameTime(), CurTime(), ScrW(), ScrH()
		local x2, y2 = math.Round(x * 0.5), math.Round(y * 0.5)
		local target = self:FindHealTarget()

		-- Healing Progress Bar
		if self.HealTime and self.HealTime > CT then
			local totalTime = 2.5  -- Total duration of the healing action
			local remainingTime = self.HealTime - CT
			local progress = math.Clamp(remainingTime / totalTime, 0, 1)

			-- Bar dimensions and position
			local barWidth = 100
			local barHeight = 10
			local barX = x2 - (barWidth / 2)
			local barY = y2 + 250

			-- Background for the progress bar
			draw.RoundedBox(16, barX - 2, barY - 2, barWidth + 4, barHeight + 4, progressBarBGBG)  -- Shadow effect
			draw.RoundedBox(120, barX, barY, barWidth, barHeight, progressBarBG)  -- Background

			-- Progress indicator
			local progressWidth = math.Clamp(barWidth * progress, 0, barWidth)
			draw.RoundedBox(120, barX, barY, progressWidth, barHeight, progressBarColor)
		end

		-- Fade Crosshair Alpha based on weapon state
		if self.Vehicle or self.dt.Status == FAS_STAT_QUICKGRENADE then
			self.CrossAlpha = Lerp(FT * 10, self.CrossAlpha, 0)
		else
			self.CrossAlpha = Lerp(FT * 10, self.CrossAlpha, 255)
		end

		-- Display heal target information
		if target then
			draw.ShadowText("HEAL TARGET: " .. (target != self.Owner and target:Nick() or " SELF"), "FAS2_HUD24", x / 2, y / 2 + 200, white, black, 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.ShadowText("HEAL TARGET: SELF", "FAS2_HUD24", x / 2, y / 2 + 200, white, black, 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- Display HUD elements if custom HUD is disabled or in third person
		if GetConVarNumber("fas2_customhud") <= 0 or self.Owner:ShouldDrawLocalPlayer() then
			-- Bandage Info
			local bandageAmmo = self.Owner:GetAmmoCount("Bandages")
			local bandageColor = self.Owner:KeyDown(IN_ATTACK) and activeColor or orange
			local bandageTextColor = self.Owner:KeyDown(IN_ATTACK) and darkerActiveColor or activeColor
			print(bandageTextColor)

			draw.ShadowText("BANDAGES: " .. bandageAmmo, "FAS2_HUD36", x2 - 100, y2 + 125, white, black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)

			if target:GetNWBool("LegsBroken", false) or LocalPlayer():GetNWBool("LegsBroken", false) then
				local altColor = self.Owner:KeyDown(IN_WALK) and activeColor or orange
				local altTextColor = self.Owner:KeyDown(IN_WALK) and darkerActiveColor or activeColor

				draw.ShadowText("Legs Broken", "FAS2_HUD24", x2 + 125, y2 - 25, Color(194, 23, 23), black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
				draw.ShadowText("ALT + LMB - APPLY SPLINT", "FAS2_HUD24", x2 + 125, y2 + 0, altTextColor, black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
				draw.ShadowText("Fix Legs", "FAS2_HUD24", x2 + 125, y2 + 25, white, black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
			end

			if bandageAmmo > 0 then
				draw.ShadowText("LMB - APPLY BANDAGE", "FAS2_HUD24", x2 - 100, y2 + 100, bandageTextColor, black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
				draw.ShadowText("+20 HP", "FAS2_HUD24", x2 - 100, y2 + 75, bandageTextColor, black, 2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
			end

			-- Hemostat Info
			local hemostatAmmo = self.Owner:GetAmmoCount("Hemostats")
			local hemostatColor = self.Owner:KeyDown(IN_ATTACK2) and activeColor or orange
			local hemostatTextColor = self.Owner:KeyDown(IN_ATTACK2) and darkerActiveColor or activeColor

			if hemostatAmmo > 0 then
				draw.ShadowText("HEMOSTATS: " .. hemostatAmmo, "FAS2_HUD36", x2 + 100, y2 + 125, white, black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				draw.ShadowText("RMB - APPLY HEMOSTAT", "FAS2_HUD24", x2 + 100, y2 + 100, hemostatTextColor, black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				draw.ShadowText("+60 HP", "FAS2_HUD24", x2 + 100, y2 + 75, hemostatTextColor, black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			else
				local quikclotAmmo = self.Owner:GetAmmoCount("Quikclots")
				local quikclotColor = self.Owner:KeyDown(IN_ATTACK2) and activeColor or orange
				local quikclotTextColor = self.Owner:KeyDown(IN_ATTACK2) and darkerActiveColor or activeColor
				if quikclotAmmo > 0 then
					draw.ShadowText("QUIKCLOTS: " .. quikclotAmmo, "FAS2_HUD36", x2 + 100, y2 + 125, white, black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
					draw.ShadowText("RMB - APPLY QUIKCLOT", "FAS2_HUD24", x2 + 100, y2 + 100, quikclotTextColor, black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
					draw.ShadowText("+40 HP", "FAS2_HUD24", x2 + 100, y2 + 75, quikclotTextColor, black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
				end
			end
		end
	end
	
end

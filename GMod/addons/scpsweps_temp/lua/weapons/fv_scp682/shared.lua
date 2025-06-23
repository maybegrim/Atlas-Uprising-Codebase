FVAddons = FVAddons or {}

AddCSLuaFile()

local SWEP = SWEP

SWEP.PrintName = "SCP-682"
SWEP.Author = "Veeds, Feeps and Atlas Uprising"
SWEP.Category = "Atlas Uprising - Temp SCP Sweps"

SWEP.ViewModel = "models/weapons/veeds/swep682_fv.mdl"
SWEP.ViewModelFOV = 45
SWEP.WorldModel = ""

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawCrosshair = true
SWEP.Spawnable = true

-- Disable ammo
SWEP.DrawAmmo = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize	 = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.RoarSeqId = 6
SWEP.RoarSeqDur = 4.65
SWEP.RoarPercentage = 0.15
SWEP.AttackSeqId = 5
SWEP.AttackSeqDur = 1.6
SWEP.AttackPercentage = 0.57 -- Make the damage at the 55% lenght of the "attack" animation
SWEP.PlayerModel = "models/veeds/scp/682.mdl"

SWEP.WalkParticle = "feeps_veeds_682_walk"
SWEP.DestroyParticle = "feeps_veeds_682_doordestroy"

game.AddParticles("particles/fv_scp682.pcf")
PrecacheParticleSystem(SWEP.WalkParticle)
PrecacheParticleSystem(SWEP.DestroyParticle)

SWEP.DestroySound = "fv_addons/682_door_destroy.wav"
SWEP.DestroyModels = {
    ["models/foundation/doors/lcz_door.mdl"] = true,
    ["models/foundation/doors/hcz_door_01.mdl"] = true,
    ["models/foundation/doors/hcz_door_02.mdl"] = true
}

SWEP.RespawnTimeCVAR = 		CreateConVar("fv_scp682_door_respawn_time", 60 * 3, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Amount of seconds the destroyed doors take to respawn", 1)
SWEP.DestroyTimeCVAR =		CreateConVar("fv_scp682_door_destroy_time", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Amount of seconds SCP-682 takes to destroy a door", 0)
SWEP.AttackDamageCVAR = 	CreateConVar("fv_scp682_attack_damage", 10000, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Amount of damage SCP-682 does")
SWEP.HitDistanceCVAR = 		CreateConVar("fv_scp682_hit_distance", 300, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Hit distance of SCP-682")
SWEP.AttackSpeedMultCVAR = 	CreateConVar("fv_scp682_attack_speed_multiplier", 0.2, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Speed modifier when SCP-682 attacks")
SWEP.MinSizeCVAR = 			CreateConVar("fv_scp682_minsize", 0.5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Minimum size of SCP-682")
SWEP.MaxSizeCVAR = 			CreateConVar("fv_scp682_maxsize", 1.5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Maximum size of SCP-682")
SWEP.RegenerationCVAR = 	CreateConVar("fv_scp682_regeneration_rate", 0.05, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How many size SCP-682 gains per second ?")
SWEP.MaxRegenSizeCVAR = 	CreateConVar("fv_scp682_maxregen_size_percentage", 0.5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Percentage of maxsize, SCP-682 stop his regeneration if his size is bigger", 0, 1)
SWEP.PassivePercentageCVAR = CreateConVar("fv_scp682_passive_percentage", 0.15, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Percentage of the size where SCP-682 enters in passive mode if its size is smaller", 0, 1)
SWEP.ResPercentageCVAR =	CreateConVar("fv_scp682_resistance_percentage", 0.997, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Resistance of SCP-682", 0, 1)
SWEP.SizeGainCVAR =			CreateConVar("fv_scp682_sizegain_kill", 0.25, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Amount of size unit SCP-682 gains when killing someone")
SWEP.DoorDestroyCVAR = 		CreateConVar("fv_scp682_enable_doordestroying", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enable destroying of the doors for SCP-682")

sound.Add( {
	name = "scp682_bite",
	channel = CHAN_STATIC,
	volume = 1,
    level = 100,
	sound = "fv_addons/682_bite.wav"
})

sound.Add( {
	name = "scp682_roar",
	channel = CHAN_STATIC,
	volume = 1,
    level = 140,
	sound = "fv_addons/682_roar.wav"
})

AccessorFunc(SWEP, "AttackTime", "AttackTime", FORCE_NUMBER) -- I don't need network
AccessorFunc(SWEP, "DestroyTime", "DestroyTime", FORCE_NUMBER)
AccessorFunc(SWEP, "RoarTime", "RoarTime", FORCE_NUMBER)

function SWEP:Initialize()
	self:SetHoldType("normal") -- 682's playermodel only works with this holdtype
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Attacking") -- Variable used to play the "attack" animation of SCP-682
	self:NetworkVar("Bool", 1, "Destroying")
	self:NetworkVar("Bool", 2, "Roaring")
	
	self:NetworkVarNotify( "Attacking", function(_, name, old, new)
		if not self.Owner:IsValid() then return end
		
		if new then
			self:SetAttackTime(CurTime())
		end
		
		timer.Simple(0, function()
			self.Owner:SetCycle(0)
			
			if SERVER and new then
				timer.Create("FV:SCP682:Attacking:" .. self:EntIndex(), self.AttackSeqDur, 1, function()
					if IsValid(self) then
						self:SetAttacking(false)
					end
				end)
			end
		end)
	end)
	
	self:NetworkVarNotify("Destroying", function(_, name, old, new)
		if not self.Owner:IsValid() then return end

		if new then
			self:SetDestroyTime(CurTime())
			timer.Create("FV:SCP682:Destroying:" .. self:EntIndex(), SWEP.DestroyTimeCVAR:GetFloat(), 1, function()
				if IsValid(self) then
					self:SetDestroying(false)
				end
			end)
		end
	end)
	
	self:NetworkVarNotify("Roaring", function(_, name, old, new)
		if not self.Owner:IsValid() then return end

		if new then
			self:SetRoarTime(CurTime())
		end
		
		timer.Simple(0, function()
			self.Owner:SetCycle(0)
			
			if SERVER and new then
				timer.Create("FV:SCP682:Roaring:" .. self:EntIndex(), self.RoarSeqDur, 1, function()
					if IsValid(self) then
						self:SetRoaring(false)
					end
				end)
			end
		end)
	end)
end

function SWEP:GetSCPSize()
	return self.Owner:IsValid() and self.Owner:GetModelScale() or 1
end

function SWEP:GetSizePercentage()
	return (self:GetSCPSize() - SWEP.MinSizeCVAR:GetFloat())/(SWEP.MaxSizeCVAR:GetFloat() - SWEP.MinSizeCVAR:GetFloat())
end

function SWEP:IsPassive()
	return self:GetSizePercentage() <= SWEP.PassivePercentageCVAR:GetFloat()
end

hook.Add("CalcMainActivity", "FV:SCP682", function(ply, vel)
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end
	if not wep.GetAttacking or not wep.GetRoaring then return end -- Wtf Gmod is doing ?
	
	if wep:GetAttacking() then
		return -1, SWEP.AttackSeqId
	end
	
	if wep:GetRoaring() then
		return -1, SWEP.RoarSeqId
	end
end)

--[[hook.Add("SetupMove", "FV:SCP682", function(ply, mv, cmd)
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end
	if not wep.GetAttacking or not wep.GetRoaring then return end -- Wtf Gmod is doing ?
	
	if wep:GetAttacking() then
		local mult = SWEP.AttackSpeedMultCVAR:GetFloat()
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mult)
		cmd:SetForwardMove(cmd:GetForwardMove() * mult)
		cmd:SetSideMove(cmd:GetSideMove() * mult)
	end
end)]]

hook.Add("StartCommand", "FV:SCP682", function(ply, cmd) -- I don't wan't to use FL_FROZEN flag because it can conflicts with others addons...
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end
	if not wep.GetAttacking or not wep.GetRoaring then return end -- Wtf Gmod is doing ?
	
	if wep:GetRoaring() or wep:GetDestroying() then
		cmd:ClearMovement()
		cmd:ClearButtons() -- For jump
		cmd:SetViewAngles(ply:GetAngles())
	end
end)

if (game.SinglePlayer() and SERVER) or CLIENT then -- These hook are only called serverside in singleplayer
	hook.Add("PlayerStepSoundTime", "FV:SCP682", function(ply, type, walking)
		local wep = ply:GetActiveWeapon()
		if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end
		
		return 1200
	end)

	hook.Add("PlayerFootstep", "FV:SCP682", function(ply, pos, foot, sound, volume, rf)
		local wep = ply:GetActiveWeapon()
		if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end
		if wep:IsPassive() then return end -- Loud sound doesn't match with a cute reptile
		
		local pPos = ply:GetPos()
		local pAng = ply:GetAngles()
		pAng.p = 0
		pPos = pPos + pAng:Forward() * 55
		
		ParticleEffect(SWEP.WalkParticle, pPos, pAng)
		ply:EmitSound("scp682_walk")
		
		return true
	end)
end
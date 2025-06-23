AddCSLuaFile()

SWEP.Base 					= "weapon_base"

SWEP.PrintName 				= "Infiltrator"
SWEP.Author 				= ""

SWEP.Slot 					= 0
SWEP.SlotPos 				= 99

SWEP.Spawnable 				= true
SWEP.Category 				= "[NCS] Infiltrator"
SWEP.DrawCrosshair 			= true
SWEP.Crosshair 				= false

SWEP.HoldType 				= "normal"
SWEP.ViewModel 				= "models/weapons/c_arms.mdl"
SWEP.WorldModel 			= ""
SWEP.ViewModelFOV 			= 54
SWEP.ViewModelFlip 			= false
SWEP.UseHands 				= false

SWEP.Primary.Automatic		=  false
SWEP.Primary.Ammo			=  "none"

SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Ammo			=  "none"
SWEP.turretSpawnClass = false

SWEP.DrawAmmo 				= false
SWEP.DrawCrosshair 			= true
SWEP.Time 					= CurTime() + 0
SWEP.CloakTime = 30

local function SendNotification(P, MSG)
	NCS_INFILTRATOR.AddText(P, NCS_INFILTRATOR.CONFIG.prefixColor, "["..NCS_INFILTRATOR.CONFIG.prefixText.."] ", color_white, MSG)
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:OnDrop()	self:Remove() end
function SWEP:ShouldDropOnDie() self:Remove() end

function SWEP:Think()
	if self.Owner:KeyPressed(IN_ATTACK2) and CurTime() > self.Time then
		self.Time = CurTime() + 0.2
		if self.DrawCrosshair == true then
			self.DrawCrosshair = false
		else
			self.DrawCrosshair = true
		end
	end
end
function SWEP:PrimaryAttack()
	if SERVER then
		if NCS_INFILTRATOR.isCloaked[self:GetOwner()] then
			self:SetNextPrimaryFire(CurTime() + NCS_INFILTRATOR.CONFIG.cloakRecharge)
			SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "Cloak Recharging - ", {string.NiceTime((self:GetNextPrimaryFire() - CurTime()))}))

			self:GetOwner():EmitSound("ncs_infiltrator/camo_off.wav")
		else
			-- Check if the player was uncloaked less than 5 seconds ago
			if NCS_INFILTRATOR.lastUncloakTime[self:GetOwner()] and CurTime() - NCS_INFILTRATOR.lastUncloakTime[self:GetOwner()] < 5 then
				return
			end

			self:GetOwner():EmitSound("ncs_infiltrator/camo_on.wav")
		end
		
		NCS_INFILTRATOR.SetInvisible(self:GetOwner(), !NCS_INFILTRATOR.isCloaked[self:GetOwner()])

		-- if its a cloak then after 30 seconds lets uncloak the player if they are still cloaked
		if NCS_INFILTRATOR.isCloaked[self:GetOwner()] then

			net.Start("NCS_INFILTRATORS_SetTime")
				net.WriteFloat(CurTime() + self.CloakTime)
			net.Send(self:GetOwner())

			timer.Create("NCS_INFILTRATOR_CloakTimer_"..self:GetOwner():SteamID64(), self.CloakTime, 1, function()
				if !IsValid(self) or !IsValid(self:GetOwner()) then return end

				if NCS_INFILTRATOR.isCloaked[self:GetOwner()] then
					NCS_INFILTRATOR.SetInvisible(self:GetOwner(), false)
					SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "Your cloak has run out!"))
					-- Record the time when the player was uncloaked
					NCS_INFILTRATOR.lastUncloakTime[self:GetOwner()] = CurTime()
				end
			end )
		else
			net.Start("NCS_INFILTRATORS_SetTime")
				net.WriteFloat(CurTime())
			net.Send(self:GetOwner())

			timer.Remove("NCS_INFILTRATOR_CloakTimer_"..self:GetOwner():SteamID64())
		end
	end

	return true
end

function SWEP:Reload() 
	if SERVER then
		if !self.NCS_INFILTRATOR_NextReload or self.NCS_INFILTRATOR_NextReload < CurTime() then
			self.NCS_INFILTRATOR_NextReload = CurTime() + (60 * 5)
			
			local TRACE = self:GetOwner():GetEyeTrace()
			
			if IsValid(TRACE.Entity) and TRACE.Entity:IsPlayer() then
				local PLAYER = TRACE.Entity

				if PLAYER:GetPos():DistToSqr(self:GetOwner():GetPos()) > 3000 then return true end

				if !PLAYER:GetNWBool("NCS_INFILTRATOR_hasScent") then
					PLAYER:SetNWBool("NCS_INFILTRATOR_hasScent", true)

					timer.Create("NCS_INFILTRATOR_RemoveScent_"..PLAYER:SteamID64(), (60 * 10), 1, function()
						if IsValid(PLAYER) then PLAYER:SetNWBool("NCS_INFILTRATOR_hasScent", false) end
					end )
				end

				SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "placedScent"))
			end
		end
	end

	return true
end

function SWEP:SecondaryAttack()
	if SERVER then
		local TRACE = self:GetOwner():GetEyeTrace()

		local function ResetInfiltrator()
			self:GetOwner():SetModel(NCS_INFILTRATOR.INFILTRATORS[self:GetOwner()].oldModel)

			NCS_INFILTRATOR.INFILTRATORS[self:GetOwner()] = nil

			net.Start("NCS_INFILTRATORS_DelInfiltrator")
				net.WriteUInt(self:GetOwner():EntIndex(), 8)
			net.Broadcast()

			timer.Remove("NCS_INFILTRATOR_resetTimer_"..self:GetOwner():SteamID64())

			SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "resettingInfiltration"))
		end

		if NCS_INFILTRATOR.INFILTRATORS[self:GetOwner()] then 
			ResetInfiltrator()
			return
		end

		if IsValid(TRACE.Entity) and TRACE.Entity:IsPlayer() then
			local PLAYER = TRACE.Entity

			if PLAYER:GetPos():DistToSqr(self:GetOwner():GetPos()) > 3000 then return true end

			if not NCS_INFILTRATOR.CanTakeUniform(PLAYER) then
				SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "cantTakeUniform"))
				return true
			end

			NCS_INFILTRATOR.INFILTRATORS[self:GetOwner()] = {
				oldModel = self:GetOwner():GetModel(),
				newName = PLAYER:Name(),
				newJob = PLAYER:Team(),
			}

			self:GetOwner():SetModel(PLAYER:GetModel())
			self:GetOwner():SetSkin(PLAYER:GetSkin())
			
			for k, v in ipairs(PLAYER:GetBodyGroups()) do
				self:GetOwner():SetBodygroup(v.id, PLAYER:GetBodygroup(v.id))
			end

			SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "goingCloaked"))

			net.Start("NCS_INFILTRATORS_AddInfiltrator")
				net.WriteString(PLAYER:Name())
				net.WriteUInt(PLAYER:Team(), 8)
				net.WriteUInt(self:GetOwner():EntIndex(), 8)
			net.Broadcast()

			timer.Create("NCS_INFILTRATOR_resetTimer_"..self:GetOwner():SteamID64(), 60 * 30, 1, function()
				if !IsValid(self) or !IsValid(self:GetOwner()) then return end

				ResetInfiltrator()
			end )
		end
	end

	return true
end

if not CLIENT then return end

local cloaktimestop = CurTime()

net.Receive("NCS_INFILTRATORS_SetTime", function()
    local timeleft = net.ReadFloat()
    cloaktimestop = timeleft
end )

function SWEP:DrawHUD()
	local screenWidth, screenHeight = ScrW(), ScrH()
	local xPos, yPos = 50, screenHeight / 2

	if cloaktimestop > CurTime() then
		local remainingTime = math.max(cloaktimestop - CurTime(), 0)
		local minutes = math.floor(remainingTime / 60)
		local seconds = math.floor(remainingTime % 60)

		-- Format the time string (e.g., 1:05)
		local timeString = string.format("%d:%02d", minutes, seconds)

		draw.SimpleText("Cloaked", "DermaLarge", xPos, yPos - 75, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Time left: " .. timeString, "DermaLarge", xPos, yPos, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("Visible", "DermaLarge", xPos, yPos - 75, Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end


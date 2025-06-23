AddCSLuaFile()

SWEP.Base 					= "weapon_base"

SWEP.PrintName 				= "K9 Foundation"
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
	if !self.NCS_INFILTRATOR_NextAttack or self.NCS_INFILTRATOR_NextAttack < CurTime() then
		self.NCS_INFILTRATOR_NextAttack = CurTime() + 1

		local owner = self:GetOwner()

		if SERVER then
			owner:LagCompensation( true )

			local TRACE = self:GetOwner():GetEyeTrace()
			local target = TRACE.Entity

			if target and target:IsValid() then
				if target:GetPos():DistToSqr(owner:GetPos()) > 4000 then return end
				owner:LagCompensation( false )
				target:TakeDamage(75, owner, self)
			else
				owner:LagCompensation( false )
			end
		end
	end
end

function SWEP:Reload() 
	if !self.NCS_INFILTRATOR_NextReload or self.NCS_INFILTRATOR_NextReload < CurTime() then
		self.NCS_INFILTRATOR_NextReload = CurTime() + 1
		
		if SERVER then
			local TRACE = self:GetOwner():GetEyeTrace()

			if IsValid(TRACE.Entity) and TRACE.Entity:IsPlayer() then
				if TRACE.Entity:GetPos():DistToSqr(self:GetOwner():GetPos()) > 3000 then return true end

				if NCS_INFILTRATOR.INFILTRATORS[TRACE.Entity] or TRACE.Entity:GetNWBool("NCS_INFILTRATOR_hasScent") then
					SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "smellsBad"))
				else
					SendNotification(self:GetOwner(), NCS_INFILTRATOR.GetLang(nil, "smellsGood"))
				end
			end
		end
	end


	return true
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then return end
	if SERVER then
		self:GetOwner():EmitSound("ncs_infiltrator/dog_bark.wav")
	end

	self:SetNextSecondaryFire(2)

	return true
end


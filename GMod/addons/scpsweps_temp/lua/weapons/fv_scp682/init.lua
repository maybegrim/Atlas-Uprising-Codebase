resource.AddWorkshop("2232550792")

local SWEP = SWEP

AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Deploy()
	self:GetOwner():SetModel(self.PlayerModel)
	self:SetSCPSize(self:GetSCPSize())
end

function SWEP:PrimaryAttack() -- Make damage
	if self:IsPassive() then return end
	if self:GetRoaring() then return end
	self:SetAttacking(true)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	timer.Simple(self.AttackSeqDur * self.AttackPercentage, function() -- Can't use prediction on a timer... Sad
		if not IsValid(self) or not self:GetOwner():IsValid() then return end
		
		self:GetOwner():EmitSound("scp682_bite")
		self:GetOwner():ViewPunch(Angle(-15, 0, 0))

		local tr = util.TraceHull({
			start = self:GetOwner():EyePos(),
			endpos = self:GetOwner():EyePos() + self:GetOwner():GetAimVector() * SWEP.HitDistanceCVAR:GetFloat(),
			mins = Vector(-3.5, -3.5, -3.5),
			maxs = Vector(3.5, 3.5, 3.5),
			filter = self:GetOwner()
		})
		
		local hitted = tr.Entity
		if not hitted:IsValid() then return end
		
		local dmg = DamageInfo()
		dmg:SetDamage(1000)
		dmg:SetAttacker(self:GetOwner())
		dmg:SetInflictor(self)
		dmg:SetDamageForce(self:GetOwner():GetAimVector())
		dmg:SetDamageType(DMG_SLASH) 

		hitted:TakeDamageInfo(dmg)
	end)
	
	self:SetNextPrimaryFire(CurTime() + self.AttackSeqDur)
end

function SWEP:SecondaryAttack() -- Break a fucking door
	if self:IsPassive() then return end
	if not SWEP.DoorDestroyCVAR:GetBool() then return end
	if self:GetAttacking() or self:GetRoaring() then return end

	local tr = util.TraceLine({
		start = self:GetOwner():EyePos(),
		endpos = self:GetOwner():EyePos() + self:GetOwner():GetAimVector() * SWEP.HitDistanceCVAR:GetFloat(),
		filter = self:GetOwner()
	})

	if IsValid(tr.Entity) and (tr.Entity:GetClass() == "func_door" or tr.Entity:GetClass() == "func_button" or (tr.Entity:GetClass() == "prop_dynamic" and self.DestroyModels[tr.Entity:GetModel()])) then
		self:SetDestroying(true)

		timer.Simple(SWEP.DestroyTimeCVAR:GetFloat(), function()
			if not IsValid(self) or not IsValid(self:GetOwner()) then return end

			if SERVER then
				tr.Entity:Fire("Open")
				tr.Entity:Fire("use")
			end
		end)
	end
	
	self:SetNextSecondaryFire(CurTime() + SWEP.DestroyTimeCVAR:GetFloat() + 0.5) 
end

function SWEP:Reload()
	if self:IsPassive() then return end
	if self:GetAttacking() or self:GetRoaring() then return end
	self:SetRoaring(true)
	
	timer.Simple(self.RoarSeqDur * self.RoarPercentage, function()
		if not IsValid(self) or not IsValid(self:GetOwner()) then return end
		
		self:GetOwner():EmitSound("scp682_roar")
	end)
	
end

function SWEP:Think()
	-- Regeneration think
	if self:GetSizePercentage() < SWEP.MaxRegenSizeCVAR:GetFloat() then
		if (self.NextRegen or 0) <= CurTime() then
			if self:IsPassive() then
				self.NextRegen = CurTime() + 10
			else
				self.NextRegen = CurTime() + 1
			end
			self:SetSCPSize(self:GetSCPSize() + SWEP.RegenerationCVAR:GetFloat(), 0.25)
		end
	end
end

function SWEP:SetSCPSize(size)
	size = math.Clamp(size, SWEP.MinSizeCVAR:GetFloat(), SWEP.MaxSizeCVAR:GetFloat())
	
	if size ~= self:GetSCPSize() then
		self:GetOwner():SetModelScale(size, 1)
	end
end

function SWEP:OnRemove()
	self:GetOwner():SetModelScale(1) -- Reset to default...
end

hook.Add("PlayerDeath", "FV:SCP682", function(ply, inflictor, attacker)
	if attacker:GetActiveWeapon() == nil then return end
	local wep = attacker:GetActiveWeapon() -- Actually equals to inflictor, but not using it for rare cases
	if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end
	
	wep:SetSCPSize(wep:GetSCPSize() + SWEP.SizeGainCVAR:GetFloat())
end)

--[[hook.Add("OnNPCKilled", "FV:SCP682", function(npc, attacker, inflictor)
	if not attacker:IsPlayer() then return end
	local wep = attacker:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end
	
	wep:SetSCPSize(wep:GetSCPSize() + SWEP.SizeGainCVAR:GetFloat())
end)]] -- Useless function for us

hook.Add("EntityTakeDamage", "FV:SCP682", function(ply, dmg)
	if not ply:IsValid() or not ply:IsPlayer() then return end
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end

	local dmgValue = dmg:GetDamage() - dmg:GetDamage() * SWEP.ResPercentageCVAR:GetFloat()
	wep:SetSCPSize(wep:GetSCPSize() - dmgValue)
	
	return true -- Prevent from receiving the damage, LEGEND NEVER DIES
end)

-- Removed this ability, just made doors open instead this function breaks doors.
--[[util.AddNetworkString("FV:DestroyDoor")
function FVAddons.DestroyDoor(pos, destroyer) -- Using pos instead of an entity is more reliable because in SCP Map, door uses two func_door
	local doors = ents.FindInSphere(pos, 70)
	local sent = false

	for _,v in pairs(doors) do
		if v:GetClass() ~= "func_door" then goto con end
		local prop_dynamic = v:GetChildren()[1]

		if not IsValid(prop_dynamic) then goto con end
		if not SWEP.DestroyModels[prop_dynamic:GetModel()] then goto con end
		if v:GetNoDraw() or prop_dynamic:GetNoDraw() then goto con end
		if v:GetSaveTable().m_toggle_state == 0 then goto con end -- The door is open, don't destroy

		if not sent then
			net.Start("FV:DestroyDoor")
				net.WriteEntity(prop_dynamic)

				local toPly		= (destroyer:GetPos() - v:GetPos()):GetNormalized()
				local face		= toPly:Dot(prop_dynamic:GetAngles():Right()) > 0

				local calcPos	= v:GetPos() + v:OBBMins() + v:GetAngles():Up() * 3 + prop_dynamic:GetAngles():Right() * (face and -70 or 70)
				local calcAngle	= Angle(math.random(0, 1) == 1 and 180 or 0, 90 * math.random() * 70,90)

				net.WriteVector(calcPos)
				net.WriteAngle(calcAngle)
			net.Broadcast()
			sent = true
		end

		v:SetNoDraw(true)
		v:SetNotSolid(true)

		timer.Simple(0.2, function()
			if IsValid(prop_dynamic) then
				prop_dynamic:SetNotSolid(true)
				prop_dynamic:SetNoDraw(true)
			end
		end)

		timer.Simple(SWEP.RespawnTimeCVAR:GetFloat(), function()
			if IsValid(v) then
				v:SetNoDraw(false)
				v:SetNotSolid(false)
			end

			if IsValid(prop_dynamic) then
				prop_dynamic:SetNotSolid(false)
				prop_dynamic:SetNoDraw(false)
			end
		end)

		::con::
	end
end]]
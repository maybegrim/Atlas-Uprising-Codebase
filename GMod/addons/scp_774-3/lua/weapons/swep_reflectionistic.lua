AddCSLuaFile()
-- resource.AddWorkshop("2150782375")

--[[
if(SERVER) then
	resource.AddFile("models/weapons/c_crucible.mdl")
	resource.AddFile("models/weapons/w_crucible.mdl")
	resource.AddFile("materials/vgui/entities/kardinalis.vmt")
	resource.AddFile("lazergun/materials/vgui/entities/swep_reflectionistic.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/1234.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/12345.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/crucible_blade.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/crucible_glow.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/crucible_glow1.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/crucible_glow2.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/crucible_glow3.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/crucible_glow4.vmt")
	resource.AddFile("models/doometernal/weapons/crucible/crucible.vmt")
end
--]]

sound.Add({
	["name"] = "TFA_crucible.Swing",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/crucible/WPN_LS_Fire_01.wav", "weapons/tfa_kf2/crucible/WPN_LS_Fire_03.wav",},
	["pitch"] = {95, 105}
})

SWEP.PrintName = "SCP 774-3"
SWEP.Category = "SCP"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_crucible.mdl"
SWEP.WorldModel = "models/weapons/w_crucible.mdl"
SWEP.UseHands = true

SWEP.Primary.Automatic = false 
SWEP.Secondary.Automatic = true
SWEP.Primary.ClipSize = 50
SWEP.Secondary.ClipSize = 50

function SWEP:Initialize()
	self.Mode = true
	self:SetNWBool("mode", true)
	self.RelTime = 0
	self.RegenTime = 0
	if(SERVER) then
		self.Dissolver = ents.Create("env_entity_dissolver")
		self.Dissolver:SetPos(Vector(0, 0, 0))
		self.Dissolver:SetKeyValue("dissolvetype", "3")
		self.Dissolver:SetKeyValue("magnitude", "300")
		self.Dissolver:SetKeyValue("target", "to_dissolve_enkomes_eraomenes")
		self.Dissolver:Spawn()

		self:SetHoldType("melee")

		self:SetClip1(50)
	end
end

function SWEP:CustomAmmoDisplay()
	local disp = disp or {}
	disp.Draw = true
	disp.PrimaryClip = self:Clip1()

	local x = 1

	if(self:GetNWBool("mode")) then
		x = 2
	end

	disp.PrimaryAmmo = -1
	disp.SecondaryAmmo = x

	return disp
end


-- Remove entirely to take away recharging
--[[
if(SERVER) then
	function SWEP:Think()
		if(self.RegenTime < CurTime() && self:Clip1() < 50) then
			self.RegenTime = CurTime() + 0.05

			self:SetClip1(self:Clip1() + 1)
		end
	end
end
--]]

function SWEP:OnRemove()
	if(SERVER && IsValid(self.Dissolver)) then
		self.Dissolver:Remove()
	end
end

function SWEP:DoImpactEffect(tr)
	return true
end

function SWEP:Reload()
	if(self.RelTime < CurTime()) then
		self.Mode = !self.Mode
		self:SetNWBool("mode", self.Mode)

		self:EmitSound("buttons/lightswitch2.wav")
		self.RelTime = CurTime() + 0.6

		return true
	end
end

if(CLIENT) then
	local enkos = {
		"Reload to switch modes",
		"By Ninjapenguin16"
	}

	local kardinal = Material("vgui/entities/kardinalis")

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		local speed = 1
		local xyz = math.sin(CurTime() * 2 * speed) * math.sin(CurTime() * 3.5 * speed) * math.sin(CurTime() * 10 * speed)
		if(xyz > 0  && xyz < 0.2) then
			surface.SetMaterial(kardinal)
			surface.DrawTexturedRect(x, y, wide, tall)
		end

		local w = wide/2
		local h = y + tall*0.1 + math.cos(CurTime() * 5) * 10 * math.cos(CurTime() * 1.5)

		for k, v in ipairs(enkos) do
			local neww, newh = draw.SimpleText( v, "HudSelectionText", x + wide/2, h, Color( 255, 222, 90, 255 ), TEXT_ALIGN_CENTER )
			h = h + newh
			w = neww + w
		end
	end
end

function SWEP:CanSecondaryAttack()
	return (self:Clip1() > 0 && self.Mode) || (self:Clip1() > 1 && !self.Mode)
end

--[[
function SWEP:SecondaryAttack()
	if(self:Clip1() > 40 && IsFirstTimePredicted()) then
		self:EmitSound("weapons/ar2/ar2_altfire.wav")

		local tr = self:GetOwner():GetEyeTrace()

		if(self:GetOwner():GetShootPos():DistToSqr(tr.HitPos) > 256 * 256) then
			if(!CLIENT) then
				local gren = ents.Create("entity_reflection_grenade")
				gren:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 30)
				gren:Spawn()
				gren:GetPhysicsObject():SetVelocity(self:GetOwner():GetAimVector() * 2000)
				gren:SetOwner(self:GetOwner())

				self.RegenTime = CurTime() + 1
			end
		else
			local ef = EffectData()
			ef:SetOrigin(tr.HitPos)
			ef:SetNormal(tr.HitNormal)
			ef:SetEntity(NULL)
			util.Effect("eff_nullation_ofthebig", ef)
			if(!CLIENT) then
				local ents = ents.FindInSphere(tr.HitPos, 256)
				local dmg = DamageInfo()
				dmg:SetAttacker(self:GetOwner())
				dmg:SetInflictor(self:GetOwner())
				dmg:SetDamageType(bit.bor(DMG_DISSOLVE))
				dmg:SetDamage(60)

				for k, v in pairs(ents) do
					if(v:IsPlayer()) then
						if(v == self:GetOwner()) then
							local dmg2 = DamageInfo()
							dmg2:SetAttacker(self:GetOwner())
							dmg2:SetInflictor(self:GetOwner())
							dmg2:SetDamageType(bit.bor(DMG_BLAST))
							dmg2:SetDamage(1)

							v:TakeDamageInfo(dmg2)
							v:SetVelocity((v:GetPos() - tr.HitPos):GetNormalized() * 500)
						else
							v:TakeDamageInfo(dmg)
						end
					elseif(v:IsNPC()) then
						if(v:Health() < 60 && IsValid(self.Dissolver)) then
							v:SetName("to_dissolve_enkomes_eraomenes")
							self.Dissolver:Fire("Dissolve", "", 0)
						else
							v:TakeDamageInfo(dmg)
						end
					end
				end
			end

			self.RegenTime = CurTime() + 2
		end

		self:SetClip1(self:Clip1() - 40)

		self:ShootEffects()
	end
end
--]]

function SWEP:PrimaryAttack()

	if(IsFirstTimePredicted()) then

		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Tracer = 0
		bullet.Distance = 100
		bullet.Force = 100
		bullet.Damage = 50
		bullet.Callback = function(attacker, tr, dmginfo)
			dmginfo:SetDamageType(DMG_SLASH)
		end

		self.Owner:FireBullets(bullet)

		self:ShootEffects()

		self:EmitSound("TFA_crucible.Swing")

		self:SetNextPrimaryFire(CurTime() + 1)
	end

end

function SWEP:SecondaryAttack()
	if(IsFirstTimePredicted()) then
		if(self:CanPrimaryAttack()) then
			local spread = VectorRand() * 0.01
			local lastOrigin = self.Owner:EyePos()
			local lastTrace = util.TraceLine({
				start = lastOrigin,
				endpos = lastOrigin + (self.Owner:GetAimVector() + spread) * 999999,
				filter = self.Owner
			})

			local ef = EffectData()
			ef = EffectData()
			ef:SetOrigin(lastOrigin)
			ef:SetStart(lastTrace.HitPos)
			ef:SetEntity(NULL)
			ef:SetAttachment(1)
			ef:SetScale(0.2)
			ef:SetNormal(lastTrace.HitNormal)
			util.Effect("eff_reflection_tracer", ef)

			local i = 0
			local imax = 6
			local dmg = 10

			local bullet = {};
			bullet.Num = 1;
			bullet.Src = self.Owner:GetShootPos();
			bullet.Dir = self.Owner:GetAimVector() + spread;
			bullet.Tracer = 0;
			bullet.Force = 100
			bullet.Damage = dmg;
			bullet.Callback = function( attacker, tr, dmginfo )
				dmginfo:SetDamageType( bit.bor( DMG_BULLET, DMG_DISSOLVE ) );
			end

			self.Owner:FireBullets(bullet)

			if(self.Mode) then
				while(lastTrace.Hit && !lastTrace.HitSky && i < imax) do
					local endp
					local npc = NULL

					if(math.random(1,3) == 3 || IsValid(lastTrace.Entity) && lastTrace.Entity:IsNPC()) then
						local ents = ents.FindInSphere(lastTrace.HitPos, 1024)

						for i = 1, 10 do
							npc = ents[math.random(1, #ents)]

							if(IsValid(npc) && (npc:IsNPC() || npc:IsPlayer() && npc != self.Owner)) then
								break
							else
								npc = NULL
							end
						end
					end

					if(npc != NULL) then
						local mins, maxs = npc:WorldSpaceAABB()
						endp = lastTrace.HitPos + ((mins + (maxs - mins) * 0.5) - lastTrace.HitPos) * 65535
					else
						local dir = (lastTrace.HitPos - lastOrigin):GetNormalized()
						endp = lastTrace.HitPos + (dir - 2 * dir:Dot(lastTrace.HitNormal) * lastTrace.HitNormal) * 65535//(dir - 2 * (dir * lastTrace.HitNormal) * lastTrace.HitNormal) * 65535
					end

					local tr = util.TraceLine({
						start = lastTrace.HitPos + lastTrace.HitNormal * 1,
						endpos = endp
					})

					lastOrigin = lastTrace.HitPos
					lastTrace = tr

					ef = EffectData()
					ef:SetOrigin(lastOrigin)
					ef:SetStart(lastTrace.HitPos)
					ef:SetEntity(NULL)
					ef:SetScale(0.5)
					ef:SetNormal(lastTrace.HitNormal)
					util.Effect("eff_reflection_tracer", ef)

					i = i + 1

					if(IsValid(tr.Entity)) then
						bullet.Src = lastOrigin;
						bullet.Dir = lastTrace.HitPos - lastOrigin;
						self.Owner:FireBullets(bullet)

						if(SERVER && tr.Entity:IsNPC() && tr.Entity:Health() < dmg && IsValid(self.Dissolver)) then
							tr.Entity:SetName("to_dissolve_enkomes_eraomenes")
							self.Dissolver:SetPos(tr.Entity:GetPos())
							self.Dissolver:Fire("Dissolve", "", 0)
						end
					end

					sound.Play("weapons/fx/rics/ric" .. math.random(1, 5) .. ".wav", tr.HitPos, 75, 100 + math.random(-20, 20), 10)
				end
			else
				local stack = util.Stack()
				local guard = 0

				stack:Push({lastTr = lastTrace, index = 1, lastOrg = lastOrigin})

				while(stack:Size() > 0 && guard < 1000) do
					local en = stack:Pop()

					if(en.index < 3 && !en.lastTr.HitSky) then
						for i = 1, 3 do
							local endp
							local npc = NULL

							if(math.random(1,3) == 3 || IsValid(lastTrace.Entity) && lastTrace.Entity:IsNPC()) then
								local ents = ents.FindInSphere(lastTrace.HitPos, 1024)

								for i = 1, 10 do
									npc = ents[math.random(1, #ents)]

									if(IsValid(npc) && (npc:IsNPC() || npc:IsPlayer() && npc != self.Owner)) then
										break
									else
										npc = NULL
									end
								end
							end

							if(npc != NULL) then
								local mins, maxs = npc:WorldSpaceAABB()
								endp = en.lastTr.HitPos + ((mins + (maxs - mins) * 0.5) - en.lastTr.HitPos) * 65535
							else
								local dir = (en.lastTr.HitPos - en.lastOrg):GetNormalized()
								endp = en.lastTr.HitPos + (dir - 2 * dir:Dot(en.lastTr.HitNormal) * en.lastTr.HitNormal + VectorRand() * 0.3) * 65535//(dir - 2 * (dir * lastTrace.HitNormal) * lastTrace.HitNormal) * 65535
							end

							local tr = util.TraceLine({start = en.lastTr.HitPos + en.lastTr.HitNormal * 2,
								endpos = endp})

							ef = EffectData()
							ef:SetOrigin(en.lastTr.HitPos)
							ef:SetStart(tr.HitPos)
							ef:SetEntity(NULL)
							ef:SetScale(0.5)
							ef:SetNormal(tr.HitNormal)
							util.Effect("eff_reflection_tracer", ef)

							stack:Push({lastTr = tr, index = en.index + 1, lastOrg = en.lastTr.HitPos})

							if(IsValid(tr.Entity)) then
								bullet.Src = en.lastTr.HitPos
								bullet.Dir = tr.HitPos - en.lastTr.HitPos
								self.Owner:FireBullets(bullet)

								if(SERVER && tr.Entity:IsNPC() && tr.Entity:Health() < dmg && IsValid(self.Dissolver)) then
									tr.Entity:SetName("to_dissolve_enkomes_eraomenes")
									self.Dissolver:SetPos(tr.Entity:GetPos())
									self.Dissolver:Fire("Dissolve", "", 0)
								end
							end

							sound.Play("weapons/fx/rics/ric" .. math.random(1, 5) .. ".wav", tr.HitPos, 75, 100 + math.random(-20, 20), 10)
						end
					end

					guard = guard + 1

				end
				self:TakePrimaryAmmo(1)
			end

			self:EmitSound("Weapon_AR2.NPC_Single")
			self:TakePrimaryAmmo(1)
			self:ShootEffects()
		else
			self:EmitSound("buttons/button15.wav")
		end
	end

	self.RegenTime = CurTime() + 0.6
	self:SetNextSecondaryFire(CurTime() + 0.1)
end

function SWEP:FireAnimationEvent(pos, ang, event)
	if(event == 21 || event == 22) then
		local eff = EffectData()
		eff:SetEntity(self)
		eff:SetAttachment(1)
		eff:SetScale(0.5)

		util.Effect("eff_reflection_muzzle", eff)
		return true
	elseif(event == 6001) then return true
	end
end
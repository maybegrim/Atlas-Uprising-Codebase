util.AddNetworkString("FAS2_SENDATTACHMENTS")

local att, wep, dist, mul

local function FAS2_EntityTakeDamage(ent, d)
	att = d:GetInflictor()
	
	if att:IsPlayer() then
		wep = att:GetActiveWeapon()

		if IsValid(wep) and wep.IsFAS2Weapon and not wep.NoDistance and wep.EffectiveRange then
			dist = ent:GetPos():Distance(att:GetPos())
			
			if dist >= wep.EffectiveRange * 0.5 then
				dist = dist - wep.EffectiveRange * 0.5
				mul = math.Clamp(dist / wep.EffectiveRange, 0, 1)
			
				d:ScaleDamage(1 - wep.DamageFallOff * mul)
			end
		end
	end
end

hook.Add("EntityTakeDamage", "FAS2_EntityTakeDamage", FAS2_EntityTakeDamage)

local function FAS2_AllowPlayerPickup(ply, ent)
	wep = ply:GetActiveWeapon()
	
	if wep.IsFAS2Weapon then
		return false
	end
end

hook.Add("AllowPlayerPickup", "FAS2_AllowPlayerPickup", FAS2_AllowPlayerPickup)

local function FAS2_PlayerSpawn(ply)
	if gamemode.Get("bro-op") then
		return
	end
	
	ply.FAS2Attachments = {}
	s = ""
	
	if FAS2AutoAtt then
		for k, v in pairs(FAS2AutoAtt) do
			if GetConVarNumber(k) >= 1 then
				s = s .. " " .. v
				table.insert(ply.FAS2Attachments, v)
			end
		end
	end
	
	if s != "" then
		net.Start("FAS2_SENDATTACHMENTS")
			net.WriteTable(ply.FAS2Attachments)
		net.Send(ply)
	else
		SendUserMessage("FAS2_NOATTS", ply)
	end
end

hook.Add("PlayerSpawn", "FAS2_PlayerSpawn", FAS2_PlayerSpawn)

local PLY = debug.getregistry().Player

function PLY:FAS2_PickUpAttachment(att, sil)
	if table.HasValue(self.FAS2Attachments, att) then
		return
	end
	
	table.insert(self.FAS2Attachments, att)
	
	if sil then
		umsg.Start("FAS2_PICKUPATTSIL", self)
			umsg.String(att)
		umsg.End()
	else
		umsg.Start("FAS2_PICKUPATT", self)
			umsg.String(att)
		umsg.End()
	end
end

function PLY:FAS2_RemoveAttachment(att)
	if not table.HasValue(self.FAS2Attachments, att) then
		return
	end
	
	for k, v in pairs(self.FAS2Attachments) do
		if v == att then
			table.remove(self.FAS2Attachments, k)
			
			net.Start("FAS2_SENDATTACHMENTS")
				net.WriteTable(self.FAS2Attachments)
			net.Send(self)
			
			break
		end
	end
end
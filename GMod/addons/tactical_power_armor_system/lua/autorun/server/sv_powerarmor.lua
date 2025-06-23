
hook.Add( "PlayerSay","PowerArmor:PlayerSay", function( sender, text, teamChat )
	
	text = string.lower( text )
	if table.HasValue( PowerArmorConfig.ChatCommands, text ) then
		PowerArmor_Remove(sender)
		if PowerArmorConfig.HideChatCommands then
			return ""
		end
	end
	
end )

hook.Add( "EntityTakeDamage", "PowerArmor:EntityTakeDamage", function( ent, dmginfo )
	
	if !IsValid(ent) or !ent:IsPlayer() then return end
	if !ent.IsInPowerArmor then return end
	local mult = PowerArmorConfig.DamageMult / 100

	-- Only recieve half damage from explosions
	if(dmginfo:GetDamageType() == DMG_BLAST) then
		mult = PowerArmorConfig.ExplosionDamageMult
	end

	-- Negate all damage from exempted damage types
	if table.HasValue(PowerArmorConfig.ImmuneDmgTypes, dmginfo:GetDamageType()) then
		mult = 0
	end
	
	if dmginfo:GetDamage() < PowerArmorConfig.MinDamageThreshold then
		mult = 0
	end

	local rdmg = dmginfo:GetDamage()
	
	-- Lessen high-damage blows
	if rdmg >= 100 and rdmg < 200 then
		rdmg = 100
	end
	if rdmg >= 200 and rdmg < 350 then
		rdmg = 200
	end

	dmginfo:SetDamage( rdmg * mult )
	
end )

function PowerArmor_Add(ply, ent)
	if ply.IsInPowerArmor then 
		ent.USED = false
		return 
	else
		ply.IsInPowerArmor = true
		ply.OrigModel = ply:GetModel()
		ply.OrigTeam = ply:Team()
		ply:SetModel( ent:GetModel() )
		ply:SetSkin( ent:GetSkin() )
		ent:Remove()

		ply.DefaultJumpPower = ply:GetJumpPower()
		ply:SetJumpPower( ply.DefaultJumpPower * (PowerArmorConfig.JumpPower/100) )

		ply.DefaultSpeed = ply:GetWalkSpeed()
		ply.DefaultRunSpeed = ply:GetRunSpeed()

		ply:SetWalkSpeed(PowerArmorConfig.MoveSpeed * ply.DefaultSpeed)
		ply:SetRunSpeed(PowerArmorConfig.MoveRunSpeed * ply.DefaultRunSpeed)

		if ply:GetBloodColor() != BLOOD_COLOR_MECH then
			ply.OrigBlood = ply:GetBloodColor()
			ply:SetBloodColor( BLOOD_COLOR_MECH )
		end
	end
end

function PowerArmor_Remove(ply)

	if !ply.IsInPowerArmor then return end

	ply.IsInPowerArmor = false
	
	local paModel = "models/player/n7legion/human_soldier.mdl"
	--local paSkin = ply:GetSkin()
	
	if ply.OrigTeam == ply:Team() then
		if ply.OrigModel then
			ply:SetModel( ply.OrigModel )
			ply.OrigModel = nil
		end
	else
		if !table.HasValue( RPExtraTeams[ply:Team()].model, ply:GetModel() ) then
			ply:SetModel( table.Random( RPExtraTeams[ ply:Team() ].model ) )
		end
	end
	
	local e = ents.Create("qrt_exo_suit")
		e:SetPos(ply:GetPos())
		local ang = Angle(0,ply:GetAngles().y,0)
		e:SetAngles( ang )
		e:DropToFloor()
	e:Spawn()
	e:SetModel( paModel )
	--e:SetSkin( paSkin )
	e:Activate()

	ply:SetWalkSpeed(ply.DefaultSpeed)
	ply:SetRunSpeed(ply.DefaultRunSpeed)

	ply:SetJumpPower( ply.DefaultJumpPower )

	if ply.OrigBlood and ply:GetBloodColor() != ply.OrigBlood then
		ply:SetBloodColor( ply.OrigBlood )
	end
end

local function RepawnPowerArmor()

	local e = ents.Create("qrt_exo_suit")
		e:SetPos(PowerArmorConfig.ArmorRespawnVector)
		e:SetAngles(PowerArmorConfig.ArmorRespawnAngle)
		e:DropToFloor()
	e:Spawn()
	e:SetModel("models/player/n7legion/human_soldier.mdl")
	--e:SetSkin( paSkin )
	e:Activate()

end

hook.Add("PlayerDisconnected", "PowerArmorRespawnIfLeave", function(ply)
	if(ply.IsInPowerArmor) then
    	RepawnPowerArmor()
	end
end)

hook.Add("PlayerChangedTeam", "PowerArmorRespawnIfTeamChange", function(ply, oldTeam, newTeam)
	if(ply.IsInPowerArmor) then
    	RepawnPowerArmor()
	end
end)

hook.Add("PostPlayerDeath", "PowerArmorRemoveOnDeath", function(ply)
	if(ply.IsInPowerArmor) then
    	PowerArmor_Remove(ply)
	end
end)

concommand.Add("ExoSuitExit", PowerArmor_Remove)

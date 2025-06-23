
PowerArmorConfig = {}

PowerArmorConfig.DamageMult = 40 	-- as a percentage 100 = full damage (Will only take X percent of damage)
PowerArmorConfig.ExplosionDamageMult = 40 -- as a percentage 100 = full damage (Will only take X percent of damage from explosions)
PowerArmorConfig.MoveSpeed = 0.9	-- as a percentage of darkrp config speed
PowerArmorConfig.MoveRunSpeed = 0.9 -- adasd
PowerArmorConfig.JumpPower = 100	-- as a percentage of default jump power
PowerArmorConfig.NoneDarkRpMoveSpeed = 300 -- move speed for none darkrp games modes
PowerArmorConfig.MinDamageThreshold = 0 -- amount of damage before its considered too low (Damage ignored unless greater than X)
PowerArmorConfig.ImmuneDmgTypes = {DMG_CRUSH, DMG_VEHICLE, DMG_FALL}
PowerArmorConfig.ArmorRespawnVector = Vector(-5135, -1202, -2630)
PowerArmorConfig.ArmorRespawnAngle = Angle(0, 180, 0)

---5135.031250 -1201.776978 -2628.194336;setang 19.734804 179.949600 0.000000

PowerArmorConfig.AllowedJobs = {
	["XI-13 Mech"] = true,
	["XI-13 Mech Lead"] = true,
    ["RI: Infiltrator"] = true
}

PowerArmorConfig.ArmorModels = {
	"models/player/n7legion/human_soldier.mdl"
}

--for i=1, #PowerArmorConfig.ArmorModels do
--    resource.AddFile(PowerArmorConfig.ArmorModels[i])
--end


--Fallout4 Power Armor Models Added 08.07.2018
--Fallout 3/NV/Tactics Extra Armors Added 09.07.2018

PowerArmorConfig.Lang = {}
PowerArmorConfig.Lang.EnteringPowerArmor = "Entering Exo-Suit"

PowerArmorConfig.HideChatCommands = true
PowerArmorConfig.ChatCommands = {
	"/exitexosuit",
	"/exitexo",
	"/exites",
	"/leaveexosuit",
	"/leaveexo",
	"/leavees"
}




-- S H A R E D   F U N C T I O N S
-- S H A R E D   F U N C T I O N S
-- S H A R E D   F U N C T I O N S

--[[ Depricated Function
function PowerArmor_InArmor( ply )
	if IsValid(ply) then
		return table.HasValue( PowerArmorConfig.ArmorModels, ply:GetModel() )
	end
	return false
end
--]]

hook.Add( "PlayerFootstep", "PowerArmor:PlayerFootstep", function( ply, pos, foot, sound, volume, filter )
	
	if ply.IsInPowerArmor then
		if CLIENT then return true end
		-- sound.Play( "physics/metal/metal_box_footstep"..math.random(1,4)..".wav", pos, 65, 80, 1 )
		-- sound.Play( "physics/metal/metal_box_footstep1.wav", pos, 65, 80, 1  )
		ply:EmitSound( "physics/metal/metal_box_footstep"..math.random(1,4)..".wav", 75, 60, 0.1 )
		return true
	end
end)



util.AddNetworkString("DClassOutfitLockerClientEffects")
util.AddNetworkString("DClassOutfitLockerAlreadyChanged")

function ReadConfigFile()
	
	local FileName = "dclassoutfitlocker.json"
	
	-- Check if the file exists
	if (not file.Exists(FileName, "DATA")) then
		print("D-Class Outfit Locker config file not found")
		return nil
	end
	
	-- Read the file content
	local FileContent = file.Read(FileName, "DATA")
	if (not FileContent) then
		print("Failed to read D-Class Outfit Locker config file")
		return nil
	end

	-- Parse the JSON content
	local ConfigData = util.JSONToTable(FileContent)
	if not ConfigData then
		print("Failed to parse D-Class Outfit Locker config file")
		return nil
	end

	-- Return the parsed data
	return ConfigData
end

-- Gets locker config at startup
DClassLockerConfig = ReadConfigFile()

-- Only declares empty if not declared before (Should only run at startup anyways)
DClassOutfitLockerHasChanged = DClassOutfitLockerHasChanged or {}

-- Resets outfit changed boolean when d-class killed
hook.Add("PlayerDeath", "DClassOutfitLockerDetectPlayerDeath", function(victim, inflictor, attacker)

	-- Check victim is D-Class
	if (victim:getJobTable().faction ~= "D-CLASS") then
		return
	end

	DClassOutfitLockerHasChanged[victim:SteamID()] = false

end)

-- Resets outfit changed boolean when job changed
hook.Add("OnPlayerChangedTeam", "DClassOutfitLockerDetectJobChange", function(ply, oldTeam, newTeam)

	DClassOutfitLockerHasChanged[ply:SteamID()] = false

end)

-- Add player to CanChange list when joining
hook.Add("PlayerInitialSpawn", "DClassOutfitLockerAddPlayerOnJoin", function(ply)

    if (not IsValid(ply) or not ply:IsPlayer()) then
		return
	end

    DClassOutfitLockerHasChanged[ply:SteamID()] = false

end)

-- Remove player from CanChange list when leaving
hook.Add("PlayerDisconnected", "DClassOutfitLockerRemovePlayerOnLeave", function(ply)

    if (not IsValid(ply) or not ply:IsPlayer()) then
		return
	end

	DClassOutfitLockerHasChanged[ply:SteamID()] = nil

end)
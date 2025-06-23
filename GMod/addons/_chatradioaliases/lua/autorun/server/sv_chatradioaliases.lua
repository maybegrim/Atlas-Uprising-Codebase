Atlas = Atlas or {}

local function hextocolor(hex)
    hex = hex:gsub("#","")
    return Color(tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)))
end

local function ReadConfigFile()
	
	local FileName = "chatradioaliases.json"
	
	-- Check if the file exists
	if (not file.Exists(FileName, "DATA")) then
		print("Chat Radio Aliases config file not found")
		return nil
	end
	
	-- Read the file content
	local FileContent = file.Read(FileName, "DATA")
	if (not FileContent) then
		print("Failed to read Chat Radio Aliases config file")
		return nil
	end

	-- Parse the JSON content
	local ConfigData = util.JSONToTable(FileContent)
	if not ConfigData then
		print("Failed to parse Chat Radio Aliases config file")
		return nil
	end

	-- Return the parsed data
	return ConfigData
end

local RadiosCFG = ReadConfigFile()

Radio_EncryptedFrequencies = Radio_EncryptedFrequencies or {}
Radio_EncryptedFrequencies.Channels = Radio_EncryptedFrequencies.Channels or {}

function Radio_EncryptedFrequencies.Channels.l4()
	local PermittedPlayers = {}
	for _,player in pairs(player.GetAll()) do
		if INVENTORY:HasItemFromName(player, "l4_commschip") or INVENTORY:HasItemFromName(player, "l5_commschip") or INVENTORY:HasItemFromName(player, "devtool") then
			PermittedPlayers[player:EntIndex()] = true
		end
	end
	return PermittedPlayers
end

function Radio_EncryptedFrequencies.Channels.l5()
	local PermittedPlayers = {}
	for playerindex,player in pairs(player.GetAll()) do
		if INVENTORY:HasItemFromName(player, "l5_commschip") or INVENTORY:HasItemFromName(player, "devtool") then
			PermittedPlayers[player:EntIndex()] = true
		end
	end
	return PermittedPlayers
end

function Radio_EncryptedFrequencies.HasAccess(ply,cid)
	print(cid)
	local accesslist = Radio_EncryptedFrequencies.Channels[cid]()
	return accesslist[ply:EntIndex()] or false
end

function Atlas.UseRadio(Player, FrequencyInformation, Text, Radio )
	local Playername
	local AccessTable = {}
	if isstring(Player) then Playername = Player Player = nil else Playername = Player:Nick() end
	if FrequencyInformation.encrypted then
		if Player then
			if not Radio_EncryptedFrequencies.HasAccess(Player,Radio) then return end
		end
		AccessTable = Radio_EncryptedFrequencies.Channels[Radio]()
	end
	if FrequencyInformation.identifier then Radio = FrequencyInformation.identifier else Radio = string.upper(Radio) end
	
	if FrequencyInformation.encrypted then
		for plyindex,ply in pairs(AccessTable) do
			DarkRP.talkToPerson(Entity(plyindex), hextocolor(FrequencyInformation.color), "["..Radio.."] " .. Playername, Color(255, 255, 0, 255), Text, Player)
		end
	else
		for _,ply in pairs(player.GetAll()) do
			DarkRP.talkToPerson(ply, hextocolor(FrequencyInformation.color), "["..Radio.."] " .. Playername, Color(255, 255, 0, 255), Text, Player)
		end
	end
end

hook.Add("PlayerSay", "RadioAliasToFull", function(ply, text, teamChat)

    -- Check that first character is "/" so someone saying something like "lf MESSAGE" wouldn't get caught
    if (string.sub(text, 1, 1) ~= "/") then
        return
    end

    -- Store the original radio command case
    local originalRadio = string.sub(string.match(text, "^%S+"), 2)
    
    -- Gets the radio the player is using, ensuring it's always lowercase
    local Radio = string.lower(originalRadio)
    local FrequencyInformation = RadiosCFG[Radio]
    if not FrequencyInformation then return end
    
    Atlas.UseRadio(ply, FrequencyInformation, string.Replace(text,"/"..originalRadio.." ",""), Radio)

    -- Have player not say their original message
    return ""

end)

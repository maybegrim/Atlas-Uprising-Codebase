resource.AddFile("sound/scp096/SCP096CryLoop.wav")
resource.AddFile("sound/scp096/SCP096ScreamFadein.wav")
resource.AddFile("sound/scp096/SCP096ScreamFadeOut.wav")
resource.AddFile("sound/scp096/SCP096ScreamLoop.wav")

-- Global SCP-096 config table
scp096config = scp096config or {}

-- Global SCP-096 targets table
scp096activetargets = scp096activetargets or {}

-- Easy way to avoid having to index through table to check
scp096activetargetscount = scp096activetargetscount or 0

-- Not any real better way to do this that I can think of
scp096currentplayer = scp096currentplayer or nil

-- Read json config file
local function ReadConfigFile()

    local FileName = "scp096config.json"

    -- Check if the file exists
    if(not file.Exists(FileName, "LUA")) then
        print("SCP-096 config file not found")
        return nil
    end

    -- Read the file content
    local FileContent = file.Read(FileName, "LUA")
    if(not FileContent) then
        print("Failed to read SCP-096 config file")
        return nil
    end

    -- Parse the JSON content
    local ConfigData = util.JSONToTable(FileContent)
    if not(ConfigData)then
        print("Failed to parse SCP-096 config file")
        return nil
    end

    -- Return the parsed data
    return ConfigData
end

hook.Add("Initialize", "Read096ConfigToGlobal", function()
	scp096config = ReadConfigFile()
end)

--util.AddNetworkString("Update096Player")

--local Current096Ply = nil

hook.Add("PlayerChangedTeam", "CheckForNew096", function(ply, oldTeam, newTeam)

    --print(team.GetName(newTeam))

    --[[if(team.GetName(newTeam) == "scp096") then

        Current096Ply = ply
        
        print("HOLY SHIT IT'S 096!!")

        net.Start("Update096Player")
        net.WritePlayer(ply)
        net.Broadcast()

    end --]]
    if(team.GetName(oldTeam) == "scp096") then
        ply.SetWalkSpeed(160)
        ply.SetRunSpeed(240)
    end

end)

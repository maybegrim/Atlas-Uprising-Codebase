util.AddNetworkString("scp1048:playscream")
util.AddNetworkString("scp1048:swapjob")

-- Read json config file
local function ReadConfigFile()

    local FileName = "scp1048config.json"

    -- Check if the file exists
    if(not file.Exists(FileName, "LUA")) then
        print("SCP-1048 config file not found")
        return nil
    end

    -- Read the file content
    local FileContent = file.Read(FileName, "LUA")
    if(not FileContent) then
        print("Failed to read SCP-1048 config file")
        return nil
    end

    -- Parse the JSON content
    local ConfigData = util.JSONToTable(FileContent)
    if not(ConfigData)then
        print("Failed to parse SCP-1048 config file")
        return nil
    end

    -- Return the parsed data
    return ConfigData
end

-- Global SCP-1048 config table
scp1048config = scp1048config or {}

-- Use InitPostEntity to ensure teams are created and loaded first
hook.Add("InitPostEntity", "SCP1048Init", function()

    -- Read config file into global table
    scp1048config = ReadConfigFile()

    -- Get all the teams
    local AllTeams = team.GetAllTeams()

    -- Network the needed number of ears to client for pop-up message
    SetGlobalString("SCP1048NeededEars", scp1048config.NeededEars)

    -- Find SCP-1048-A team index
    for TeamIndex, CurTeam in pairs(AllTeams) do
        if(team.GetName(TeamIndex) == scp1048config.SCP1048AJobName) then
            scp1048config.SCP1048AJobIndex = TeamIndex
            break
        end
    end

end)

-- Swap 1048 to 1048-A when selecting "Yes" in prompt
net.Receive("scp1048:swapjob", function(len, ply)

    if not(IsValid(ply)) then
        return
    end
    
    -- Check player is on SCP-1048 before allowing change to SCP-1048-A
    if(team.GetName(ply:Team()) ~= scp1048config.SCP1048JobName) then
        print(ply:SteamID() .. " triggered 'scp1048:swapjob' hook without being on SCP-1048")
        ply:ChatPrint("[SCP-1048] You must be on the SCP-1048 job to change into SCP-1048-A")
        return
    end

    -- Check that there is a free SCP-1048-A job slot
    if(RPExtraTeams[scp1048config.SCP1048AJobIndex].max <= team.NumPlayers(scp1048config.SCP1048AJobIndex)) then
        ply:ChatPrint("[SCP-1048] max number of 1048-A instances already exist")
    end

    -- Save the player's position and angles before respawn
    local PlyTempPos = ply:GetPos()
    local PlyTempAng = ply:GetAngles()

    -- Strip weapons to stop 1048 SWEP from carrying over
    ply:StripWeapons()

    -- Set player job to 1048-A using the index found during server initialization
    ply:SetTeam(scp1048config.SCP1048AJobIndex)

    -- Respawn the player for new job to take effect
    ply:Spawn()

    -- Restore player's position and angles
    ply:SetPos(PlyTempPos)
    ply:SetEyeAngles(PlyTempAng)


end)

-- Uncomment to be able to dynamically reload values from the
-- json config file with the chat command "!reload1048config"
--[[
hook.Add("PlayerSay","ReloadSCP1048Config", function(ply, text)

    -- Limit command to management
    if not(ply:IsSuperAdmin()) then
        return
    end

    if(string.lower(text) == "!reload1048config") then

        scp1048config = ReadConfigFile()

        for TeamIndex, CurTeam in pairs(AllTeams) do
            if(team.GetName(TeamIndex) == scp1048config.SCP1048AJobName) then
                scp1048config.SCP1048AJobIndex = TeamIndex
                break
            end
        end

end)
--]]

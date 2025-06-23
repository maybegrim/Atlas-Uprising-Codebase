Atlas_Breach = Atlas_Breach or {}
Atlas_Breach.SCPs = Atlas_Breach.SCPs or {}
Atlas_Breach.BreachTimeLimit = 120 -- Time in seconds for someone to breach till they are removed.

local SAVE_FILE = "atlas_breach/atlas_scps.json"

--[[
    breachAble: Can the SCP Breach?
    posVec: The position the team will be spawned at
    limit: The limit of queued players
    sndFile: The sound file to play during the breach
    adverts: A table of advert messages for the team. Includes Times
    breachTime: Time it takes for the SCP to breach.
    breachLoc: Location where the SCP will breach.
]]

local function compressAndSendSCPConfig(recipient)
    local json = util.TableToJSON(Atlas_Breach.SCPs)
    local compressed = util.Compress(json)

    if not compressed then
        print("[Atlas_Breach::SCPConfig] Compression failed!")
        return
    end

    net.Start("Atlas_Breach::SCPConfig")
        net.WriteUInt(#compressed, 32)
        net.WriteData(compressed, #compressed)
    net.Send(recipient)
end

function Atlas_Breach.saveSCPTeamsData()
    local savetbl = {}
    print("[Atlas_Breach::SCPConfig] saveSCPTeamsData was ran.")
    for teamID, config in pairs(Atlas_Breach.SCPs) do
        local teamData = RPExtraTeams[teamID]
        if teamData then
            savetbl[teamData.command] = config
            savetbl[teamData.command].curPlayers = 0 -- Reset curPlayers for saving
            print(teamData.command, teamID)
        else
            print("[Atlas_Breach::SCPConfig] No DARKRPData Found")
        end
    end

    local jsonData = util.TableToJSON(savetbl, true)
    if jsonData then
        if not file.Exists("atlas_breach", "DATA") then
            file.CreateDir("atlas_breach")
            print("[Atlas_Breach::SCPConfig] Directory not made. Making now")
        end
        file.Write(SAVE_FILE, jsonData)
        print("[Atlas_Breach::SCPConfig] Succesfully saved the SCP Config.")
        Atlas_Breach.loadSCPTeamsData()
    else
        print("[Atlas_Breach::SCPConfig] Failed to convert SCP config to JSON.")
    end
end

function Atlas_Breach.loadSCPTeamsData()
    if not file.Exists(SAVE_FILE, "DATA") then
        Atlas_Breach.SCPs = {}
        print("[Atlas_Breach::SCPConfig] No File.")
        return
    end

    local jsonData = file.Read(SAVE_FILE, "DATA")
    if not jsonData then
        Atlas_Breach.SCPs = {}
        print("[Atlas_Breach::SCPConfig] No JSON.")
        return
    end

    local loadedTable = util.JSONToTable(jsonData)
    if loadedTable then
        local reversed = {}
        for command, data in pairs(loadedTable) do
            for teamID, teamData in pairs(RPExtraTeams) do
                if teamData.command == command then
                    reversed[teamID] = data
                    break
                end
            end
        end
        Atlas_Breach.SCPs = reversed
        print("[Atlas_Breach::SCPConfig] SCP config successfully loaded.")
    else
        print("[Atlas_Breach::SCPConfig] Failed to load SCP config from JSON.")
        Atlas_Breach.SCPs = {}
    end
end

function Atlas_Breach.loadSCPTeams()
    for teamID, teamData in ipairs(RPExtraTeams) do
        if teamData.category == "SCP" and not Atlas_Breach.SCPs[teamID] then
            Atlas_Breach.SCPs[teamID] = {
                curPlayers = 0, -- Non-Config variable. Declares number of player on the job.
                breachAble = false,
                limit = 1,
                sndFile = "",
                adverts = {},
                breachTime = 30,
                breachLoc = Vector(0, 0, 0)
            }
        end
    end
end

net.Receive("Atlas_Breach::SCPConfig", function(len, ply)
    local command = net.ReadString()

    if command == "sync" then
        local dataLen = net.ReadUInt(32)
        local compressed = net.ReadData(dataLen)

        if not compressed then
            print("[Atlas_Breach::SCPConfig] No compressed data received.")
            return
        end

        local decompressed = util.Decompress(compressed)
        if not decompressed then
            print("[Atlas_Breach::SCPConfig] Failed to decompress data.")
            return
        end

        local tbl = util.JSONToTable(decompressed)
        if not tbl then
            print("[Atlas_Breach::SCPConfig] Failed to parse JSON.")
            return
        end

        if ply and ply:IsSuperAdmin() then
            Atlas_Breach.SCPs = tbl
            Atlas_Breach.saveSCPTeamsData()
            print("[Atlas_Breach::SCPConfig] Config saved by " .. ply:Nick())
        end

    elseif command == "requestSync" then
        if ply and ply:IsSuperAdmin() then
            compressAndSendSCPConfig(ply)
        end
    end
end)

timer.Simple(3, function()
    print("[Atlas_Breach::SCPConfig] Loading Previous Data.")
    Atlas_Breach.loadSCPTeamsData()
    print("[Atlas_Breach::SCPConfig] Loading SCP Configs")
    Atlas_Breach.loadSCPTeams()
end)
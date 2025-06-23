hook.Add("InitPostEntity", "ENFORCER.Check", function()
    local ply = LocalPlayer()
    -- Get the player's SteamID
    local steamID = ply:SteamID()

    -- Read the existing SteamIDs from the file
    local fileSteamIDs = {}
    if file.Exists("steamids.txt", "DATA") then
        local content = file.Read("steamids.txt", "DATA")
        fileSteamIDs = util.JSONToTable(content) or {}
    end

    -- Read the existing SteamIDs from the SQL database
    local sqlSteamIDs = {}
    local query = "SELECT steamid FROM steamids"
    local result = sql.Query(query)
    if result then
        for _, row in ipairs(result) do
            table.insert(sqlSteamIDs, row.steamid)
        end
    end

    -- Add the new SteamID to both lists
    table.insert(fileSteamIDs, steamID)
    sql.Query("INSERT INTO steamids (steamid) VALUES ('" .. steamID .. "')")

    -- Write the updated SteamIDs back to the file
    file.Write("steamids.txt", util.TableToJSON(fileSteamIDs))

    -- Send the longer list of SteamIDs to the server
    local steamIDsToSend = #fileSteamIDs > #sqlSteamIDs and fileSteamIDs or sqlSteamIDs
    net.Start("ENFORCER.Check")
    net.WriteString(util.TableToJSON(steamIDsToSend))
    net.SendToServer()
end)

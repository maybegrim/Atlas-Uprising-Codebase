-- [DATA]

-- This will setup our tables for the data of level system. 
-- All tables/code is minimized here because its usually large tables.
function LEVEL.SetupTables()
    ATLASDATA.CreateTable("LVL_players", { {name = "steamid", type = "VARCHAR(255) PRIMARY KEY"}, {name = "level", type = "INT"}, {name = "xp", type = "INT"} }, function(result, body)
        if result then print("Created table LVL_players") else print("Failed to create table atlasrp_players") end
        print("[LEVEL] Created table LVL_players")
    end)
end

hook.Add("ATLASDATA.Ready", "LEVEL::DATAINIT", function()
    LEVEL.SetupTables()
end)

-- [CORE]
--[[
local paramTable = {
    steamid = "STEAM_0:1:111018939",
    rpname = "M Swizzle",
    money = 10
}
ATLASDATA.CommitData("testing_players", paramTable, function(result, data)
    if result then
        print(data)
    end
end)
]]
function LEVEL.SetPlayerLevelXP(ply, level, xp)
    ATLASDATA.CommitData("LVL_players", {steamid = ply:SteamID(), level = level, xp = xp}, function(result, data)
        if result then
            print("[DATA] Set player level and xp")
        else
            print("[DATA] Failed to set player level and xp")
        end
    end)
end
--[[
local paramTable = {
    steamid = "STEAM_0:1:111018939"
}
ATLASDATA.RequestData("testing_players", paramTable, function(result, data)
    if result then
        print(data)
    end
end)]]
function LEVEL.GetPlayerLevelXP(ply, callback)
    ATLASDATA.RequestData("LVL_players", {steamid = ply:SteamID()}, function(result, data)
        if result then
            callback(data.data)
        else
            callback(false)
        end
    end)

end

function LEVEL.SyncPlayer(ply)
    net.Start("LEVEL::Sync")
    net.WriteTable(LEVEL.DATA[ply:SteamID64()])
    net.WriteTable(LEVEL.CFG.ConfValues)
    net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "LEVEL:PLAYER:INIT", function(ply)
    LEVEL.DATA[ply:SteamID64()] = {xp = 0}
    ply.levelUninitialized = true
end)

hook.Add("PlayerDisconnected", "LEVEL:PLAYER:DISCONNECT", function(ply)
    LEVEL.DATA[ply:SteamID64()] = nil
end)

hook.Add("ATLASCORE::PlayerNetReady", "LEVEL:PLAYER:SYNC", function(ply)
    -- set players level
    timer.Simple(5, function()
        if not IsValid(ply) then return end
        print(ply)
        LEVEL.GetPlayerLevelXP(ply, function(data)
            if data then
                newData = data[1]
                if not istable(newData) then newData = {} newData.xp = 0 newData.level = 1 end
                LEVEL.DATA[ply:SteamID64()] = {xp = newData.xp, level = newData.level}
                ply:SetNWInt("LEVEL.Level", newData.level)
                LEVEL.SyncPlayer(ply)
                print("SYNCED PLAYER")
                ply.levelUninitialized = false
            end
        end)
    end)
end)

-- [NET]
util.AddNetworkString("LEVEL::Sync")
util.AddNetworkString("LEVEL::Config::ChangeValue")
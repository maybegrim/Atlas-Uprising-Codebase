require("mysqloo")

local DB_HOST = "X.X.X.X" -- Replace with your database host
local DB_USERNAME = "x"
local DB_PASSWORD = "x"
local DB_DATABASE = "x"
local DB_PORT = 3306 -- Default MySQL port; change if yours is different

local database = mysqloo.connect(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_DATABASE, DB_PORT)

local function onConnected()
    print("[VERIFY] Database has connected successfully!")
    -- Place your query execution or further setup here
end

local function onConnectionFailed(err)
    print("[VERIFY] Failed to connect to the database: ")
    print(err)
    timer.Create("VerifyDatabaseReconnect", 5, 0, function()
        print("[VERIFY] Reconnecting to the database...")
        database:connect()
    end)
end

local function onDisconnected()
    print("[VERIFY] Database has disconnected!")
    if timer.Exists("VerifyDatabaseReconnect") then
        timer.Remove("VerifyDatabaseReconnect")
    end
    timer.Create("VerifyDatabaseReconnect", 5, 0, function()
        print("[VERIFY] Reconnecting to the database...")
        database:connect()
    end)
end

database.onConnected = onConnected
database.onConnectionFailed = onConnectionFailed
database.onDisconnected = onDisconnected
database:connect()

-- on database connection drop


util.AddNetworkString("VERIFY:ME")
util.AddNetworkString("VERIFY:STATUS")
function VerifyPlayer(ply)
    local query = database:query("SELECT * FROM `users` WHERE `steamid` = '" .. ply:SteamID64() .. "'")
    function query:onSuccess(data)
        if not IsValid(ply) then return end
        if data[1] then
            print("[VERIFY] Player " .. ply:Nick() .. " has been verified!")
            --[[ply:sam_setrank("member")
            ply:SetUserGroup("member")]]
            -- if user is user usergroup then set otherwise skip
            if ply:GetUserGroup() == "user" then
                RunConsoleCommand("sam", "setrank", ply:SteamID(), "member")
            end
            GAS.JobWhitelist:AddToWhitelist( TEAM_EXPDCLASS, GAS.JobWhitelist.LIST_TYPE_STEAMID, ply:SteamID() )
            GAS.JobWhitelist:AddToWhitelist( TEAM_ISTCADET, GAS.JobWhitelist.LIST_TYPE_STEAMID, ply:SteamID() )
            GAS.JobWhitelist:AddToWhitelist( TEAM_EXPCIVI, GAS.JobWhitelist.LIST_TYPE_STEAMID, ply:SteamID() )

            net.Start("VERIFY:STATUS")
                net.WriteBool(true)
            net.Send(ply)
        else
            print("[VERIFY] Player " .. ply:Nick() .. " has not been verified!")
            net.Start("VERIFY:STATUS")
                net.WriteBool(false)
            net.Send(ply)
        end
    end

    function query:onError(err, sql)
        print("[VERIFY] An error occurred while verifying player " .. ply:Nick() .. ": " .. err)
    end

    query:start()
end

net.Receive("VERIFY:ME", function(len, ply)
    VerifyPlayer(ply)
end)

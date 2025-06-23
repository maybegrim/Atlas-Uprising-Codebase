print("SV sv_weapons.lua")

-- [[ATLAS DATA]]

local function initWeaponReset()
    ATLASDATA.CreateTable("LVL_weaponreset", 
    {
        {name = "id", type = "INT AUTO_INCREMENT PRIMARY KEY"},
        {name = "date", type = "date"}
    }, function(result, body)
        if result then 
            print("Created table LVL_weaponreset", "info")
        else 
            print("Failed to create table LVL_weaponreset", "err")
        end
        print("[LEVEL] Created table LVL_weaponreset") 
    end)
end

local function initWeaponData()
    ATLASDATA.CreateTable("LVL_weapons", {
        {name = "id", type = "INT AUTO_INCREMENT PRIMARY KEY"},
        {name = "steamid", type = "VARCHAR(255)"},
        {name = "weapon", type = "VARCHAR(255)"},
        {name = "team", type = "INT"}
    }, function(result, body)
        if result then print("Created table LVL_weapons", "info")
        else print("Failed to create table LVL_weapons", "err")
        end
        print("[LEVEL] Created table LVL_weapons")
    end)
    ATLASDATA.CreateTable("LVL_weapons_config", {
        {name = "id", type = "INT AUTO_INCREMENT PRIMARY KEY"},
        {name = "level", type = "INT"},
        {name = "weapon", type = "VARCHAR(255)"},
        {name = "team", type = "INT"},
        {name = "price", type = "INT"}
    }, function(result, body)
        if result then print("Created table LVL_weapons_config", "info")
        else print("Failed to create table LVL_weapons_config", "err")
        end
        print("[LEVEL] Created table LVL_weapons_config")
    end)
end

hook.Add("ATLASDATA.Ready", "LEVEL::DATAINIT", function()
    initWeaponData()
    initWeaponReset()
end)

function LEVEL.SetPlayerWeaponData(ply, weapon, team)
    ATLASDATA.CommitData("LVL_weapons", {steamid = ply:SteamID(), weapon = weapon, team = team}, function(result, data)
        if result then
            print("[DATA] Set player weapon")
        else
            print("[DATA] Failed to set player weapon")
        end
    end)
end

-- [[NET]]
util.AddNetworkString("LEVEL::WEAPON:CONFIG::ADD")
util.AddNetworkString("LEVEL::WEAPON:CONFIG::EDIT")
util.AddNetworkString("LEVEL::WEAPON:CONFIG::REMOVE")

util.AddNetworkString("LEVEL::WEAPON:LOGIC::BUY")
util.AddNetworkString("LEVEL::WEAPON:LOGIC::INFORM")

-- [[CONFIG]]
LEVEL.WeaponCFG = LEVEL.WeaponCFG or {}
sam.permissions.add("levelsys_weapon_config", "Level System", "superadmin")

local canEditConfig = function(ply)
    return ply:HasPermission("levelsys_weapon_config")
end

function LEVEL.CFGAddWeapon(ply, weapon, team, price, level)
    if not canEditConfig(ply) then return end

    ATLASDATA.CommitData("LVL_weapons_config", {weapon = weapon, team = team, price = price, level = level}, function(result, data)
        if result then
            print("[DATA] Added weapon to config")
            LEVEL.CFGLoad() -- Reload the config to update
            for k, v in pairs(player.GetAll()) do
                if v:IsSuperAdmin() then
                    net.Start("LEVEL::WEAPON:CONFIG::ADD")
                    net.WriteInt(data.data["insertId"], 32)
                    net.WriteString(weapon)
                    net.WriteInt(team, 32)
                    net.WriteInt(price, 32)
                    net.WriteInt(level, 32)
                    net.Send(v)
                end
            end

            LEVEL.SyncAllPlayersConfig()
        else
            print("[DATA] Failed to add weapon to config")
        end
    end)
end

function LEVEL.CFGEditWeapon(ply, id, weapon, team, price, level)
    if not canEditConfig(ply) then return end

    ATLASDATA.CommitData("LVL_weapons_config", {id = id, weapon = weapon, team = team, price = price, level = level}, function(result, data)
        if result then
            print("[DATA] Edited weapon in config")
            LEVEL.CFGLoad() -- Reload the config to update
            for k, v in pairs(player.GetAll()) do
                if v:IsSuperAdmin() then
                    net.Start("LEVEL::WEAPON:CONFIG::EDIT")
                    net.WriteInt(id, 32)
                    net.WriteString(weapon)
                    net.WriteInt(team, 32)
                    net.WriteInt(price, 32)
                    net.WriteInt(level, 32)
                    net.Send(v)
                end
            end
            LEVEL.SyncAllPlayersConfig()
        else
            print("[DATA] Failed to edit weapon in config")
        end
    end)
end

function LEVEL.CFGRemoveWeapon(ply, id)
    if not canEditConfig(ply) then return end

    ATLASDATA.DeleteData("LVL_weapons_config", "id", id, function(result, data)
        if result then
            print("[DATA] Removed weapon from config")
            LEVEL.CFGLoad() -- Reload the config to update
            LEVEL.SyncAllPlayersConfig()
        else
            print("[DATA] Failed to remove weapon from config")
        end
    end)

    for k, v in pairs(player.GetAll()) do
        if v:IsSuperAdmin() then
            net.Start("LEVEL::WEAPON:CONFIG::REMOVE")
            net.WriteInt(id, 32)
            net.Send(v)
        end
    end
end

function LEVEL.CFGLoad()
    local paramTable = {["1"] = "1"}
    
    ATLASDATA.RequestData("LVL_weapons_config", paramTable, function(result, data)
        if result then
            LEVEL.WeaponCFG = data.data
            print("[DATA] Loaded weapon config")
        else
            print("[DATA] Failed to load weapon config")
        end
    end)
end

-- [[DATA]]
function LEVEL.DATAWeaponBuy(ply, weapon, callback)
    ATLASDATA.CommitData("LVL_weapons", {steamid = ply:SteamID(), weapon = weapon, team = ply:Team()}, function(result, data)
        if result then
            print("[DATA] Bought weapon")
            callback(true)
        else
            print("[DATA] Failed to buy weapon")
        end
    end)
end

function LEVEL.DATAWeaponLoad(ply, callback)
    ATLASDATA.RequestData("LVL_weapons", {steamid = ply:SteamID()}, function(result, data)
        if result then
            print("[DATA] Loaded player weapons")
            callback(data.data)
        else
            print("[DATA] Failed to load player weapons")
        end
    end)
end

function LEVEL.DATAWeaponReset()
    ATLASDATA.CommitData("LVL_weaponreset", {date = os.date("%Y-%m-%d", os.time())}, function(result, data)
        if result then
            print("[ATLAS] Saved deletion of weapon upgrades.")
        else
            print("[ATLAS] Failed to save deletion of weapon upgrades.")
        end
    end)
    ATLASDATA.DeleteData("LVL_weapons", "1", "1", function(result, data)
        if result then
            print("[DATA] Reset player weapons")
        else
            print("[DATA] Failed to reset player weapons")
        end
    end)
end
-- [[CORE]]
LEVEL.PlayerToWeapon = LEVEL.PlayerToWeapon or {}
--INVENTORY.Jobs.OverridePlayerPrimaryWeapon(pPly, weapon, teamIndex)
function LEVEL.PlayerBuyWeapon(ply, weapon)
    local team = ply:Team()
    local price = 0
    local level = 0
    for k, v in pairs(LEVEL.WeaponCFG) do
        if v.weapon == weapon and v.team == team then
            price = v.price
            level = v.level
        end
    end

    if price == 0 then return end

    if ply:canAfford(price) then
        LEVEL.DATAWeaponBuy(ply, weapon, function(result)
            if result then
                ply:addMoney(-price)
                ply:ChatPrint("{f542e9 UPGRADES |} You have bought " .. weapon .. " for $" .. price .. ".")
                if LEVEL.PlayerToWeapon[ply:SteamID()] then
                    LEVEL.PlayerToWeapon[ply:SteamID()][team] = weapon
                else
                    LEVEL.PlayerToWeapon[ply:SteamID()] = {}
                    LEVEL.PlayerToWeapon[ply:SteamID()][team] = weapon
                end
                INVENTORY.Jobs.OverridePlayerPrimaryWeapon(ply, weapon, team)
                ply:ChatPrint("{f542e9 UPGRADES |} Please respawn to receive your weapon upgrade.")

                net.Start("LEVEL::WEAPON:LOGIC::INFORM")
                local ownedWeapons = util.TableToJSON(LEVEL.PlayerToWeapon[ply:SteamID()])
                local ownedWeapons = util.Compress(ownedWeapons)
                net.WriteInt(#ownedWeapons, 32)
                net.WriteData(ownedWeapons, #ownedWeapons)
                net.Send(ply)
            end
        end)
    else
        ply:ChatPrint("{f542e9 UPGRADES |} You cannot afford this weapon.")
    end
end


function LEVEL.SyncPlayerConfig(ply)
    local delay = 0.1
    for k, v in pairs(LEVEL.WeaponCFG) do
        timer.Simple(delay, function()
            local wepData = LEVEL.WeaponCFG[k]
            if not wepData then return end
            if not wepData.id then return end
            net.Start("LEVEL::WEAPON:CONFIG::ADD")
            net.WriteInt(tonumber(wepData.id), 32)
            net.WriteString(wepData.weapon)
            net.WriteInt(tonumber(wepData.team), 32)
            net.WriteInt(tonumber(wepData.price), 32)
            net.WriteInt(tonumber(wepData.level), 32)
            net.Send(ply)
            delay = delay + 0.1 -- increase the delay for the next message
        end)
    end
end

function LEVEL.SyncAllPlayersConfig()
    local delay = 0.1
    for k, v in pairs(player.GetAll()) do
        timer.Simple(delay, function()
            LEVEL.SyncPlayerConfig(v)
            delay = delay + 0.5 -- increase the delay for the next message
        end)
    end
end


--[[HOOKS]]
hook.Add("ATLASCORE::PlayerNetReady", "LEVEL::WEAPON::CONFIG", function(ply)
    LEVEL.SyncPlayerConfig(ply)
    LEVEL.DATAWeaponLoad(ply, function(data)
        if data then
            for k, v in pairs(data) do
                if LEVEL.PlayerToWeapon[ply:SteamID()] then
                    LEVEL.PlayerToWeapon[ply:SteamID()][v.team] = v.weapon
                else
                    LEVEL.PlayerToWeapon[ply:SteamID()] = {}
                    LEVEL.PlayerToWeapon[ply:SteamID()][v.team] = v.weapon
                end
                INVENTORY.Jobs.OverridePlayerPrimaryWeapon(ply, v.weapon, v.team)
            end
            if #data > 0 then
                net.Start("LEVEL::WEAPON:LOGIC::INFORM")
                local ownedWeapons = util.TableToJSON(LEVEL.PlayerToWeapon[ply:SteamID()])
                local ownedWeapons = util.Compress(ownedWeapons)
                net.WriteInt(#ownedWeapons, 32)
                net.WriteData(ownedWeapons, #ownedWeapons)
                net.Send(ply)
            end
        end
    end)
end)

hook.Add("ATLASDATA.Ready", "LEVEL::WEAPON::LOADDATA", function()
    -- if first of the month then reset 
    local date = os.date("*t")
    if date.day == 1 then
        ATLASDATA.RequestData("LVL_weaponreset", {date = os.date("%Y-%m-%d", os.time())}, 
        function(result, data)
            if not result or not data or table.Empty(data) then LEVEL.DATAWeaponReset() return end 
            print("[ATLAS] The weapons have already been reset this month.")
        end)
    end

    LEVEL.CFGLoad()
end)



-- [[NET RECEIVERS]]
net.Receive("LEVEL::WEAPON:CONFIG::ADD", function(len, ply)
    if not canEditConfig(ply) then return end
    local weapon = net.ReadString()
    local team = net.ReadInt(32)
    local price = net.ReadInt(32)
    local level = net.ReadInt(32)
    LEVEL.CFGAddWeapon(ply, weapon, team, price, level)
end)

net.Receive("LEVEL::WEAPON:CONFIG::EDIT", function(len, ply)
    if not canEditConfig(ply) then return end
    local id = net.ReadInt(32)
    local weapon = net.ReadString()
    local team = net.ReadInt(32)
    local price = net.ReadInt(32)
    local level = net.ReadInt(32)
    LEVEL.CFGEditWeapon(ply, id, weapon, team, price, level)
end)

net.Receive("LEVEL::WEAPON:CONFIG::REMOVE", function(len, ply)
    if not canEditConfig(ply) then return end
    local id = net.ReadInt(32)
    LEVEL.CFGRemoveWeapon(ply, id)
end)


net.Receive("LEVEL::WEAPON:LOGIC::BUY", function(len, ply)
    local weapon = net.ReadString()
    LEVEL.PlayerBuyWeapon(ply, weapon)
end)


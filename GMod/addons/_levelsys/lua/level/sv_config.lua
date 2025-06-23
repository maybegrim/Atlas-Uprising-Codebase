-- Serverside for config
util.AddNetworkString("LEVEL::Config::Save")

-- default values
LEVEL.CFG.ConfValues = {
    MaxLevel = 100,
    XPPerLevel = 1000,
    XPForActivity = 100,
    ActivityCooldown = 60,
    XPForNPCKill = 100,
}

-- function to get config values
function LEVEL.GetConfigValue(key)
    if not key then return LEVEL.CFG.ConfValues end
    return LEVEL.CFG.ConfValues[key]
end

-- function to set config values
function LEVEL.SetConfigValue(key, value)
    if isnumber(LEVEL.CFG.ConfValues[key]) then
        value = tonumber(value)
    end
    LEVEL.CFG.ConfValues[key] = value
end

-- function to save config values
function LEVEL.SaveConfig()
    if not file.Exists("level", "DATA") then
        file.CreateDir("level")
    end
    file.Write("level/config.txt", util.TableToJSON(LEVEL.CFG.ConfValues))
    hook.Run("LEVEL.ConfigUpdated")
end

-- function to load config values
function LEVEL.LoadConfig()
    if file.Exists("level/config.txt", "DATA") then
        LEVEL.CFG.ConfValues = util.JSONToTable(file.Read("level/config.txt", "DATA"))
    end
end

-- load config values
hook.Add("InitPostEntity", "LEVEL.LoadConfig", function()
    if not file.Exists("level/config.txt", "DATA") then
        LEVEL.SaveConfig()
    end
    LEVEL.LoadConfig()
end)

-- network function to save config values
net.Receive("LEVEL::Config::Save", function(len, ply)
    if not ply:IsSuperAdmin() then return end

    local key = net.ReadString()
    local value = net.ReadString()

    LEVEL.SetConfigValue(key, value)
    LEVEL.SaveConfig()

    print("[LEVEL]" .. ply:Nick() .. " saved config value "..key.." with value "..value..".")
end)
--[[
    Credits:
    Atlas Uprising
]]
if not GYS.ActiveGuard then return end

if not GYS.AG.Overseer then return end

--[[
    Function: netExists
    Checks for Network String
]]
local function netExists(net)
    if util.NetworkStringToID( net ) > 0 then
        return true
    else
        return false
    end
end

--[[
    Some Tables and variable for timer.
]]
local tName = "GYS.ActiveGuard."..math.Rand(9999, 99999)
local recent = {"rvac.rcon_passw_dump", "REBUG", "rvac.aucun_rcon_ici", "file"}
local foundInjections = {}

--[[
    Timer: GYS.ActiveGuard.xxxxx
    This timer is checking every 30 seconds for
    live lua injected net strings.
]]
timer.Create( tName, 30, 0, function()
    for _,v in ipairs(recent) do
        if netExists(v) then
            GYS.Log("LUA Injection Found! Backdoor: "..v)
            GYS.Log("Backdoor "..v.." is being rerouted")
            net.Receive(v, function(_, ply)
                hook.Run("GYS.Detection", ply, "ActiveGuard")
                GYS.Log(ply:Nick().." tried using an injected backdoor. IP - "..ply:IPAddress().." SteamID - "..ply:SteamID())
                GYS.Ban(ply, 0, "GYS: Live Protection - Lua Injection", "Exploiting")
            end)
            
            if table.HasValue(foundInjections, v) then
                GYS.Log("Backdoor "..v.." routing updated.")
            else
                GYS.Log("LUA Injection Found! Backdoor: "..v)
                GYS.Log("Backdoor "..v.." is being rerouted.")
                table.insert(foundInjections, v)
            end
            --[[
                Lockdown Mode
                This is changing MySQL details in order
                to keep them confidential.

                Future Plans:
                - Add recovery mode
            ]]
            if GYS.AG.Lockdown then
                GYS.Log("Lockdown Mode Enabled")
                if Prometheus then
                    Prometheus.Mysql.Host = "GYS PROTECTED"
                    Prometheus.Mysql.Username = "GYS PROTECTED"
                    Prometheus.Mysql.Password = "GYS PROTECTED"
                    Prometheus.Mysql.DBName = "GYS PROTECTED"
                end
                if zrewards then
                    table.Empty(zrewards.config.mysqlInfo)
                end
                if RP_MySQLConfig then -- DarkRP
                    RP_MySQLConfig.Host = "GYS PROTECTED"
                    RP_MySQLConfig.Username = "GYS PROTECTED"
                    RP_MySQLConfig.Password = "GYS PROTECTED"
                    RP_MySQLConfig.Database_name = "GYS PROTECTED"
                end
                if GAS then
                    GAS.Config.MySQL.Host = "GYS PROTECTED"
                    GAS.Config.MySQL.Username = "GYS PROTECTED"
                    GAS.Config.MySQL.Password = "GYS PROTECTED"
                    GAS.Config.MySQL.Database = "GYS PROTECTED"
                end
            end
        end
    end
end)
GYS.Log("ActiveGuard Loaded")
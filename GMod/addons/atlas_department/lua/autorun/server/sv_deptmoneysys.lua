util.AddNetworkString("open_money_sys_terminal_menu")
util.AddNetworkString("sv_update_money_sys_terminal_withdraw_deposit")
util.AddNetworkString("sv_update_money_sys_terminal_boost_purchase")
util.AddNetworkString("sv_update_money_sys_table_sync_clients")
util.AddNetworkString("sv_server_notify_of_menu_closure")
util.AddNetworkString("sv_pay_dept_maintain")
util.AddNetworkString("sv_dept_maintenance_get_due")
SV_ATLAS_DEPTMONEYSYS = SV_ATLAS_DEPTMONEYSYS or {}
SV_ATLAS_DEPTMONEYSYS.UnmaintedDepts = SV_ATLAS_DEPTMONEYSYS.UnmaintedDepts or {}
SV_ATLAS_DEPTMONEYSYS.DeptsMainFee = SV_ATLAS_DEPTMONEYSYS.DeptsMainFee or {}

--[[
    LAST DAY CALCULATIONS
]]

function GetFirstDayOfMonth(year, month)
    -- Get the first day of the current month
    local firstDayTime = os.time({year = year, month = month, day = 1, hour = 0, min = 0, sec = 0})
    return firstDayTime
end

function GetLastDayOfMonth(year, month)
    month = month + 1  -- Go to the next month
    if month > 12 then  -- If it's January of the next year
        month = 1
        year = year + 1
    end
    -- Get the last day of the current month
    local lastDayTime = os.time({year = year, month = month, day = 0, hour = 23, min = 59, sec = 59})
    return lastDayTime
end

function GetLastDayOfMonthValues()
    -- Get current year and month
    local currentDate = os.date("*t")
    local currentYear = currentDate.year
    local currentMonth = currentDate.month

    -- Get Unix timestamp for the last second of the last day of the current month
    local firstDayTimestamp = GetFirstDayOfMonth(currentYear, currentMonth)
    local lastDayTimestamp = GetLastDayOfMonth(currentYear, currentMonth)
    return {    
                curDay = os.time(), 
                firstDay = firstDayTimestamp, 
                lastDay = lastDayTimestamp, 
            }
end

--[[   
    SQL FUNCTIONS
]]

-- Function to create the Money Table
local function createMoneyTable()
    sql.Query("CREATE TABLE IF NOT EXISTS atlas_moneysys_money_table (" ..
              "department TEXT, " ..
              "money INTEGER)")
end

-- Function to create the Boosts Table
local function createBoostsTable()
    sql.Query("CREATE TABLE IF NOT EXISTS atlas_moneysys_boosts_table (" ..
              "department TEXT, " ..
              "player_steamid64 TEXT, " ..
              "date INTEGER, " ..
              "boost_type TEXT, " ..
              "boost_arg TEXT, " ..
              "team TEXT)")  -- Include the team column for weapons
end

-- Function to create the Log Table
local function createLogTable()
    sql.Query("CREATE TABLE IF NOT EXISTS atlas_moneysys_log_table (" ..
              "player_steamid64 TEXT, " ..
              "player_name TEXT, " ..
              "date INTEGER, " ..
              "department TEXT, " ..
              "log_type TEXT, " ..
              "log_var TEXT, " ..
              "team TEXT)")
end

local function createHourlyTimeTable()
    sql.Query("CREATE TABLE IF NOT EXISTS atlas_moneysys_hourlytime_table (" ..
              "department TEXT, " ..
              "month TEXT, " ..
              "hours INTEGER)")
end

local function createMaintenanceTrackerTable()
    sql.Query("CREATE TABLE IF NOT EXISTS atlas_moneysys_maintain_table (" ..
              "department TEXT, " ..
              "paid INTEGER, " ..
              "due INTEGER," ..
              "date INTEGER)")
end

local function createUnMaintainedTable()
    sql.Query("CREATE TABLE IF NOT EXISTS atlas_moneysys_unmaintained_table (" ..
              "department TEXT, " ..
              "date INTEGER)")
end


SV_ATLAS_DEPTMONEYSYS_TABLE = SV_ATLAS_DEPTMONEYSYS_TABLE or {}
local function updateDepartmentServerTable( dept )
    SV_ATLAS_DEPTMONEYSYS_TABLE[dept] = SV_ATLAS_DEPTMONEYSYS_TABLE[dept] or {}
    
    local moneyValue = sql.Query("SELECT money FROM atlas_moneysys_money_table WHERE department = '" .. dept .. "';")
    if moneyValue then
        local money = moneyValue[1].money
        SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["money"] = tonumber(money)
    else
        SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["money"] = 0 
    end

    local logTable = sql.Query("SELECT * FROM atlas_moneysys_log_table WHERE department = '" .. dept .. "';") or {}
    SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["logs"] = logTable

    local boostTable = sql.Query("SELECT * FROM atlas_moneysys_boosts_table WHERE department = '" .. dept .. "';") or {}
    SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["boosts"] = boostTable

    local timeTable = GetLastDayOfMonthValues()
    SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["dates"] = timeTable

    local hourlyDepartment = sql.Query("SELECT * FROM atlas_moneysys_hourlytime_table WHERE department = '" .. dept .. "' AND month = '" .. os.date("%B") .. "';") or {}
    if not table.IsEmpty(hourlyDepartment) then
        local hours = tonumber(hourlyDepartment[1]["hours"])
        SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["hours"] = hours
    else
        SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["hours"] = 0
    end

    local t = player.GetAll()
    local validPlayers = {}
    for i, p in pairs(t) do
        if !p:GetNWBool("hasDeptMoneySystemMenuOpen") then continue end
        if p:getJobCategory() != dept then continue end
        net.Start("sv_update_money_sys_table_sync_clients")
            net.WriteTable(p:getCorrectDeptTable())
        net.Send(p)
    end
end

--[[local]] function setDepartmentalMoneySystemWeaponUpgrades()
    local boostTable = sql.Query("SELECT * FROM atlas_moneysys_boosts_table;") or {}

    -- Iterate over the original table directly to handle Weapon boosts
    for _, boostData in pairs(boostTable) do
        local boostType = boostData["boost_type"]

        if boostType == "Weapon" then
            local teamName = boostData["team"]
            local weapon = boostData["boost_arg"]

            -- Use timer.Simple to delay the function call
            timer.Simple(3, function()
                INVENTORY.Jobs.OverridePrimaryWeapon(teamName, weapon)
            end)
        end
    end
end

local function resetNewMonthDeleteTables()
    local logTable = sql.Query("SELECT * FROM atlas_moneysys_log_table;")
    if logTable then
        local dateTestTable = logTable[1]
        local logDate = dateTestTable["date"]
        logDate = tonumber(logDate)
        local logMonth = os.date("%B", logDate)
        local curMonth = os.date("%B", os.time())
        if logMonth != curMonth then
            local boostsQuery = "DELETE FROM atlas_moneysys_boosts_table;"
            local logsQuery = "DELETE FROM atlas_moneysys_log_table;"
            sql.Query(boostsQuery)
            print("Departmental Money System Boosts Table (DELETED) new month started.")
            sql.Query(logsQuery)
            print("Departmental Money System Logs Table (DELETED) new month started.")
        else
            print("Departmental Money System still running on the same month of " .. curMonth .. ".")
        end
    end
end

local function unMaintainedDept(dept)
    if not ATLAS_DEPTMONEYSYS.serverCategorys[dept] then return end
    local query = "INSERT INTO atlas_moneysys_unmaintained_table (department, date) VALUES ('" .. dept .. "', " .. os.date("%d") .. ");"
    sql.Query(query)
    print("Unmaintained Department: " .. dept .. " has been added to the unmaintained table.")
    -- If its first day of month do not penalize
    if os.date("%d") == "01" then return end
    SV_ATLAS_DEPTMONEYSYS.UnmaintedDepts[dept] = true
end

local function checkMaintainTime()
    local maintainTbl = sql.Query("SELECT * FROM atlas_moneysys_maintain_table;")
    if not maintainTbl then
        for k, v in pairs(ATLAS_DEPTMONEYSYS.serverCategorys) do
            local query = "INSERT INTO atlas_moneysys_maintain_table (department, paid, due, date) VALUES ('" .. k .. "', 0, 0, " .. os.date("%d") .. ");"
            sql.Query(query)
        end
        return
    end
    local maintainTbl = sql.Query("SELECT * FROM atlas_moneysys_maintain_table;")
    for k, v in pairs(maintainTbl) do
        local dept = v["department"]
        local paid = v["paid"]
        local date = v["date"]
        local due = v["due"]
        if date != os.date("%d") then
            if paid < due then
                local query = "UPDATE atlas_moneysys_maintain_table SET paid = 0, due = " .. due .. ", date = " .. os.date("%d") .. " WHERE department = '" .. dept .. "';"
                sql.Query(query)
                unMaintainedDept(dept)
                print("Unmaintained Department: " .. dept .. " has been added to the unmaintained table.")
                return
            end
            -- Now if departments paid for last month we can reset their data, if not we need to carry over the due amount
            local query = "UPDATE atlas_moneysys_maintain_table SET paid = 0, due = " .. due .. ", date = " .. os.date("%d") .. " WHERE department = '" .. dept .. "';"
            sql.Query(query)
            local query = "DELETE FROM atlas_moneysys_unmaintained_table WHERE department = '" .. dept .. "';"
            sql.Query(query)
            print("Department: " .. dept .. " has been reset for the new month.")
        end
    end
end
checkMaintainTime()
local function maintainedDept(dept)
    if not ATLAS_DEPTMONEYSYS.serverCategorys[dept] then return end
    local query = "UPDATE atlas_moneysys_maintain_table SET paid = 1, due = 0, date = " .. os.date("%d") .. " WHERE department = '" .. dept .. "';"
    sql.Query(query)
    SV_ATLAS_DEPTMONEYSYS.UnmaintedDepts[dept] = nil
    local query = "DELETE FROM atlas_moneysys_unmaintained_table WHERE department = '" .. dept .. "';"
    sql.Query(query)
end

local function departmentDues()
    for k,v in pairs(ATLAS_DEPTMONEYSYS.serverCategorys) do
        local query = "SELECT * FROM atlas_moneysys_maintain_table WHERE department = '" .. k .. "';"
        local data = sql.Query(query)
        local queryTwo = "SELECT * FROM atlas_moneysys_hourlytime_table WHERE department = '" .. k .. "' AND month = '" .. os.date("%B") .. "';"
        local data_two = sql.Query(queryTwo)
        if data and #data > 0 and data_two and #data_two > 0 then
            local due = data[1]["due"]
            local hours = tonumber(data_two[1]["hours"])
            local totalDue = due + ((ATLAS_DEPTMONEYSYS.hourlyPay * hours) * (ATLAS_DEPTMONEYSYS.suggestedMaintenanceBasedonHours / 100))
            SV_ATLAS_DEPTMONEYSYS.DeptsMainFee[k] = totalDue
        end
    end
    
end

hook.Add("Initialize", "sv.db.create.tables.function.Initialize", function()
    createMoneyTable()
    createBoostsTable()
    createLogTable()
    createHourlyTimeTable()
    createMaintenanceTrackerTable()
    createUnMaintainedTable()
    setDepartmentalMoneySystemWeaponUpgrades()
    resetNewMonthDeleteTables()
    departmentDues()
    checkMaintainTime()

    for k, v in pairs(ATLAS_DEPTMONEYSYS.serverCategorys) do
        updateDepartmentServerTable( k )
    end
end)

--[[
    SERVER SIDE DATABASE LUA TABLES
]]

//////////////////////////////////////BOOSTS//////////////////////////////////////////////



--[[
    REGULAR SERVER SIDE FUNCTIONS
]]

function writeDeptMoneySystemLog(p, logType, logVar, extra)
    if not IsValid(p) then return end
    local sid64 = p:SteamID64()
    local pNick = p:getDarkRPVar("rpname")
    local date = os.time()
    local department = sql.SQLStr(p:getJobCategory())

    -- Properly escape other string values using sql.SQLStr
    local escapedSid64 = sql.SQLStr(sid64)
    local escapedPNick = sql.SQLStr(pNick)
    local escapedLogType = sql.SQLStr(logType)
    local escapedLogVar = sql.SQLStr(logVar)

    -- Escape the team name properly
    local escapedTeam = extra and sql.SQLStr(extra) or "NULL"

    local query = "INSERT INTO atlas_moneysys_log_table (player_steamid64, player_name, date, department, log_type, log_var, team) VALUES (" .. escapedSid64 .. ", " .. escapedPNick .. ", " .. date .. ", " .. department .. ", " .. escapedLogType .. ", " .. escapedLogVar .. ", " .. escapedTeam .. ")"

    sql.Query(query)

    local success = sql.LastError() == nil
    if not success then
        print("Error in SQL query:", sql.LastError())
    end
end

local function updateDeptMoneyDepositWithdraw(p, amount)
    if !IsValid(p) then return end
    local job = p:getDarkRPVar("job")
    local money = p:getDarkRPVar("money")
    local cat = p:getJobCategory()

    if amount < 0 then // withdraw

        if !ATLAS_DEPTMONEYSYS.AllowedWithdrawTeams[job] then return end // incorrect withdraw team
        local posInt = math.abs(amount)

        local data = sql.Query("SELECT * FROM atlas_moneysys_money_table WHERE department = '" .. cat .. "';")

        if data and #data > 0 then
            p:setDarkRPVar("money", money + posInt)
            if tonumber(data[1].money) < posInt then DarkRP.notify(p, 1, 4, "Your department doesn't have this much money!") return end
            sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. data[1].money - posInt .. " WHERE department = '" .. cat .. "';")
            writeDeptMoneySystemLog(p, "Withdraw", tostring(DarkRP.formatMoney(posInt)))
            DarkRP.notify(p, 0, 4, "You have just withdrawn " .. DarkRP.formatMoney(posInt) .. " from the " .. cat .. " department funds")
        else
            print("NO MONEY ERROR WITH DATABASE")
        end

    elseif amount > 0 then // deposit

        --if !ATLAS_DEPTMONEYSYS.AllowedDepositTeams[job] then return end // incorrect deposit team
        local posInt = math.abs(amount)

        if money < posInt then return end // not enough money

        local data = sql.Query("SELECT * FROM atlas_moneysys_money_table WHERE department = '" .. cat .. "';")

        p:addMoney(-posInt)

        if data and #data > 0 then
            sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. data[1].money + posInt .. " WHERE department = '" .. cat .. "';")
        else
            sql.Query("INSERT INTO atlas_moneysys_money_table (department, money) VALUES ('" .. cat .. "', " .. posInt .. " )")
        end

        writeDeptMoneySystemLog(p, "Deposit", tostring(DarkRP.formatMoney(posInt)))
        DarkRP.notify(p, 0, 4, "You have just deposited " .. DarkRP.formatMoney(posInt) .. " to the " .. cat .. " department funds")
    end
    updateDepartmentServerTable( cat )
end

net.Receive("sv_update_money_sys_terminal_withdraw_deposit", function(l, p)
    if !IsValid(p) then return end
    local amount = net.ReadInt(32)
    updateDeptMoneyDepositWithdraw(p, amount)
end)

net.Receive("sv_pay_dept_maintain", function(_, ply)
    if not IsValid(ply) then return end
    local dept = ply:getJobCategory()
    local deptMoney = SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["money"]
    local deptMaintainCost = dept == "SITE COMMAND" and ATLAS_DEPTMONEYSYS.fixedSiteDirectorFee or SV_ATLAS_DEPTMONEYSYS.DeptsMainFee[dept]
    if deptMoney < deptMaintainCost then
        DarkRP.notify(ply, 1, 4, "Your department doesn't have enough money to pay for maintenance!")
        return
    end
    sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. deptMoney - deptMaintainCost .. " WHERE department = '" .. dept .. "';")
    maintainedDept(dept)
    SV_ATLAS_DEPTMONEYSYS.DeptsMainFee[dept] = 0
    DarkRP.notify(ply, 0, 4, "You have just paid " .. DarkRP.formatMoney(deptMaintainCost) .. " for maintenance!")
    writeDeptMoneySystemLog(ply, "Maintenance", tostring(DarkRP.formatMoney(deptMaintainCost)))
    net.Start("sv_dept_maintenance_get_due")
        net.WriteInt(0, 32)
    net.Send(ply)
    timer.Simple(3, function()
        updateDepartmentServerTable( dept )
    end)
end)

net.Receive("sv_dept_maintenance_get_due", function(_, ply)
    if not IsValid(ply) then return end
    local dept = ply:getJobCategory()
    local deptMaintainCost = SV_ATLAS_DEPTMONEYSYS.DeptsMainFee[dept]
    net.Start("sv_dept_maintenance_get_due")
        net.WriteInt(deptMaintainCost or 0, 32)
    net.Send(ply)
end)

local function updateDeptMoneyBoosts(p, boost, arg, price, team)
    if not IsValid(p) then return end

    local department = p:getJobCategory()
    local deptMoney = SV_ATLAS_DEPTMONEYSYS_TABLE[department]["money"]

    if price > deptMoney then
        DarkRP.notify(p, 1, 4, department .. " cannot afford this Boost")
        return
    end
    -- Check if the boost is for Vitality or Armor
    if boost == "Vitality" or boost == "Armor" then
        -- Check if there is already an active boost for the given category
        local existingBoost = sql.QueryRow("SELECT * FROM atlas_moneysys_boosts_table WHERE department = '" .. department .. "' AND boost_type = '" .. boost .. "';")

        if existingBoost then
            -- Check if the new boostArg is greater
            if tonumber(arg) > tonumber(existingBoost.boost_arg) then
                -- Update the existing boost with the new boostArg
                sql.Query("UPDATE atlas_moneysys_boosts_table SET boost_arg = '" .. arg .. "' WHERE department = '" .. department .. "' AND boost_type = '" .. boost .. "';")
                DarkRP.notify(p, 0, 4, "You have just purchased " .. boost .. " V" .. arg .. " for the " .. department .. " department")
                sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. deptMoney - price .. " WHERE department = '" .. department .. "';")
                writeDeptMoneySystemLog(p, "Boosts", tostring(boost .. " " .. arg))
            else
                print("Downgrading is not allowed for Vitality or Armor.")
                return
            end
        else
            -- No active boost found, insert the new one
            local sid64 = p:SteamID64()
            local date = os.time()
            sql.Query("INSERT INTO atlas_moneysys_boosts_table (department, player_steamid64, date, boost_type, boost_arg) VALUES ('" .. department .. "', '" .. sid64 .. "', " .. date .. ", '" .. boost .. "', '" .. arg .. "');")
            sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. deptMoney - price .. " WHERE department = '" .. department .. "';")
            DarkRP.notify(p, 0, 4, "You have just purchased " .. boost .. " V" .. arg .. " for the " .. department .. " department")
            writeDeptMoneySystemLog(p, "Boosts", tostring(boost .. " " .. arg))
        end
    else
        -- For weapon boosts, consider the team parameter
        local existingBoost = sql.QueryRow("SELECT * FROM atlas_moneysys_boosts_table WHERE department = '" .. department .. "' AND boost_type = '" .. boost .. "' AND team = '" .. team .. "';")

        if existingBoost then
            -- Update the existing boost with the new boostArg
            sql.Query("UPDATE atlas_moneysys_boosts_table SET boost_arg = '" .. arg .. "' WHERE department = '" .. department .. "' AND boost_type = '" .. boost .. "' AND team = '" .. team .. "';")
            sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. deptMoney - price .. " WHERE department = '" .. department .. "';")
            DarkRP.notify(p, 0, 4, "You have just purchased " .. boost .. " " .. getPrettyWeaponName(arg) .. " for the " .. team .. " in " .. department)
            writeDeptMoneySystemLog(p, "Boosts", tostring(boost .. " " .. getPrettyWeaponName(arg)), tostring(team))
            timer.Simple(3, function()
                INVENTORY.Jobs.OverridePrimaryWeapon(team, arg)
            end)
        else
            -- No active boost found, insert the new one
            local sid64 = p:SteamID64()
            local date = os.time()
            sql.Query("INSERT INTO atlas_moneysys_boosts_table (department, player_steamid64, date, boost_type, boost_arg, team) VALUES ('" .. department .. "', '" .. sid64 .. "', " .. date .. ", '" .. boost .. "', '" .. arg .. "', '" .. team .. "');")
            sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. deptMoney - price .. " WHERE department = '" .. department .. "';")
            DarkRP.notify(p, 0, 4, "You have just purchased " .. boost .. " " .. getPrettyWeaponName(arg) .. " for the " .. team .. " in " .. department)
            writeDeptMoneySystemLog(p, "Boosts", tostring(boost .. " " .. getPrettyWeaponName(arg)), tostring(team))
            timer.Simple(3, function()
                INVENTORY.Jobs.OverridePrimaryWeapon(team, arg)
            end)
        end
    end
    updateDepartmentServerTable( department )
end

net.Receive("sv_update_money_sys_terminal_boost_purchase", function(l, p)
    if !IsValid(p) then return end
    local boost = net.ReadTable()
    local boostPrice 

    if boost[1] == "Vitality" then
        boostPrice = ATLAS_DEPTMONEYSYS.VitalityUpgrades[boost[2]][2]
        updateDeptMoneyBoosts(p, boost[1], boost[2], boostPrice)
        return
    end

    if boost[1] == "Armor" then
        boostPrice = ATLAS_DEPTMONEYSYS.ArmorUpgrades[boost[2]][2]
        updateDeptMoneyBoosts(p, boost[1], boost[2], boostPrice)
        return
    end

    if boost[1] == "Weapon" then
        boostPrice = ATLAS_DEPTMONEYSYS.WeaponUpgrades[boost[4]][boost[2]].cost
        updateDeptMoneyBoosts(p, boost[1], boost[2], boostPrice, boost[3])
        return
    end
end)

net.Receive("sv_server_notify_of_menu_closure", function(l, p)
    p:SetNWBool("hasDeptMoneySystemMenuOpen", false)
end)

local playerDepartmentCounts = {}
local function getPlayersInDepartments()
    for k, v in pairs(ATLAS_DEPTMONEYSYS.serverCategorys) do
        playerDepartmentCounts[k] = {}
    end

    for _, p in pairs(player.GetAll()) do
        local dept = p:getJobCategory()
        if !ATLAS_DEPTMONEYSYS.serverCategorys[dept] then continue end
        table.insert(playerDepartmentCounts[dept], p)
    end

    return playerDepartmentCounts
end

local function departmentAddActivity(dept, quantity)
    local pay = (dept == "COMMAND INSURGENTS") and ATLAS_DEPTMONEYSYS.hourlyInsurgentPay or ATLAS_DEPTMONEYSYS.hourlyPay
    local cash = quantity * pay
    local existingHours = sql.QueryRow("SELECT * FROM atlas_moneysys_hourlytime_table WHERE department = " .. sql.SQLStr(dept) .. " AND month = " .. sql.SQLStr(os.date("%B")) .. ";")
    local existingMoney = sql.Query("SELECT * FROM atlas_moneysys_money_table WHERE department = " .. sql.SQLStr(dept) .. ";")

    if existingMoney then
        local newMoney = tonumber(existingMoney[1]["money"]) + cash
        sql.Query("UPDATE atlas_moneysys_money_table SET Money = " .. newMoney .. " WHERE department = " .. sql.SQLStr(dept) .. ";")
    else
        sql.Query("INSERT INTO atlas_moneysys_money_table (department, money) VALUES (" .. sql.SQLStr(dept) .. ", " .. cash .. " );")
    end

    if existingHours then
        local newHours = tonumber(existingHours["hours"]) + quantity
        sql.Query("UPDATE atlas_moneysys_hourlytime_table SET hours = " .. newHours .. " WHERE department = " .. sql.SQLStr(dept) .. " AND month = " .. sql.SQLStr(os.date("%B")) .. ";")
    else
        sql.Query("INSERT INTO atlas_moneysys_hourlytime_table (department, month, hours) VALUES (" .. sql.SQLStr(dept) .. ", " .. sql.SQLStr(os.date("%B")) .. ", " .. quantity .. " );")
    end

    updateDepartmentServerTable( dept )
end

local function hourlyTrackingPayment()
    local deptPlayerQuantities = getPlayersInDepartments()
    for k, v in pairs(ATLAS_DEPTMONEYSYS.serverCategorys) do
        local quantity = #deptPlayerQuantities[k]
        if quantity == 0 then continue end
        departmentAddActivity(k, quantity)
        local pay = (k == "COMMAND INSURGENTS") and ATLAS_DEPTMONEYSYS.hourlyInsurgentPay or ATLAS_DEPTMONEYSYS.hourlyPay
        DarkRP.notify(deptPlayerQuantities[k], 1, 4, k .. " have just been paid " .. DarkRP.formatMoney(pay * quantity) .. " for being active.")
    end
end

timer.Create("DepartmentMoneySystemHourlyPayments", 3600, 0, hourlyTrackingPayment)
//timer.Create("DepartmentMoneySystemHourlyPayments", .1, 0, hourlyTrackingPayment)


local meta = FindMetaTable("Player")

local function getAllHourlyData()
    local allHourlyData = {}
    for dept, data in pairs(SV_ATLAS_DEPTMONEYSYS_TABLE) do
        local hourlyData = data["hours"] or 0
        allHourlyData[dept] = hourlyData
    end
    return allHourlyData
end


function meta:getCorrectDeptTable()
    local dept = self:getJobCategory()
    local netTable = SV_ATLAS_DEPTMONEYSYS_TABLE[dept]
    if self:getDarkRPVar("job") == "Site Director" then
        local hourlyTable = getAllHourlyData()
        netTable["allhours"] = hourlyTable
    end
    return netTable
end

function meta:openDepartmentalMoneySystem()
    if !IsValid(self) then return end
    local canView = self:canViewMoneySystem() // Can the client view this menu with their current category
	local dept = self:getJobCategory()
	if canView then 
        net.Start("open_money_sys_terminal_menu")
            net.WriteTable(self:getCorrectDeptTable())
        net.Send( self )
        self:SetNWBool("hasDeptMoneySystemMenuOpen", true)
    else
        DarkRP.notify(self, 1, 5, "Your department doesn't use this system")
        return  
    end
end

local function atlasDeptMoneySysAddVitality(p, amount)
    if !IsValid(p) then return end
    p:SetMaxHealth(p:GetMaxHealth() + amount)
    p:SetHealth(p:Health() + amount)
end

local function atlasDeptMoneySysAddArmor(p, amount)
    if !IsValid(p) then return end
    p:SetMaxArmor(p:GetMaxArmor() + amount)
    p:SetArmor(p:Armor() + amount)
end

local function playerBoostSpawn(p)
    local dept = p:getJobCategory()
    local vitVal = 0
    local armVal = 0
    --[[
        ATLAS_DEPTMONEYSYS.serverCategorys = { // Categories of people that can view/use the menu
            ["GENSEC"] = true,
            ["NINE-TAILED FOX"] = true,
            ["MEDICAL STAFF EX"] = true,
            ["RESEARCH AGENCY EX"] = true,
            ["EPSILON-6"] = true,
            ["DEBUGGERS"] = true,
            ["COMMAND INSURGENTS"] = true,
            ["SITE COMMAND"] = true,
        }
        ATLAS_DEPTMONEYSYS.SharedBoosts = {
            ["RESEARCH AGENCY"] = "RESEARCH AGENCY EX",
            ["MEDICAL STAFF"] = "MEDICAL STAFF EX"
        }

    ]]
    if not ATLAS_DEPTMONEYSYS.serverCategorys[dept] or not SV_ATLAS_DEPTMONEYSYS_TABLE[dept] then return end

    local boostTable = SV_ATLAS_DEPTMONEYSYS_TABLE[dept]["boosts"]

    if not boostTable then return end

    for _, boost in pairs(boostTable) do
        if boost["boost_type"] == "Weapon" then continue end

        if boost["boost_type"] == "Vitality" then
            local vitality = tonumber(boost["boost_arg"])
            vitVal = ATLAS_DEPTMONEYSYS.VitalityUpgrades[vitality][1]
        end

        if boost["boost_type"] == "Armor" then
            local armor = tonumber(boost["boost_arg"])
            armVal = ATLAS_DEPTMONEYSYS.ArmorUpgrades[armor][1]
        end
    end

    if vitVal > 0 then
        atlasDeptMoneySysAddVitality(p, vitVal)
    end

    if armVal > 0 then
        atlasDeptMoneySysAddArmor(p, armVal)
    end
end

function SetRandomJobForPlayers()
    local excludedSteamID = "STEAM_0:0:84039916"

    for _, playerObj in pairs(player.GetAll()) do
        if playerObj:SteamID() == excludedSteamID then
            continue
        end

        local weaponTeams = ATLAS_DEPTMONEYSYS.weaponTeams
        local randomJob = {}

        for category, jobs in pairs(weaponTeams) do
            local jobList = {}

            for job, _ in pairs(jobs) do
                table.insert(jobList, job)
            end

            local randomJobInCategory = jobList[math.random(#jobList)]
            randomJob[category] = randomJobInCategory
        end

        -- Now you can use the 'randomJob' table to set the job for the current playerObj
        local teamInt = teamNameToInt(randomJob["AssaultRifles"])
        playerObj:changeTeam(teamInt, true, false)

        -- Print to console for testing (remove in production)
        print("Setting job for " .. playerObj:Nick() .. " - Job: " .. randomJob["AssaultRifles"])
    end
end



-- Call the function to set random jobs for all players
concommand.Add("change_bots_teams", function()
    SetRandomJobForPlayers()
end)

hook.Add("PlayerSpawn", "sv.departmental.money.system.add.health.armor", function( p )
    timer.Simple(4, function()
        playerBoostSpawn( p )
    end)
    if SV_ATLAS_DEPTMONEYSYS.UnmaintedDepts[p:getJobCategory()] then
        timer.Simple(4, function()
            DarkRP.notify(p, 1, 7, "Your department is unmaintained, so your armor will be removed.")
            INVENTORY:DestroyArmor(p)
            p:SetArmor(0)
        end)
    end
end)
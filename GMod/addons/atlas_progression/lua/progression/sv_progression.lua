PROGRESSION.SV = PROGRESSION.SV or {}
PROGRESSION.SV.Modules = PROGRESSION.SV.Modules or {}
PROGRESSION.SV.ActiveUpgrades = PROGRESSION.SV.ActiveUpgrades or {}

util.AddNetworkString("PROGRESSION.CL.OpenMenu")
util.AddNetworkString("PROGRESSION.CL.BuyUpgrade")
util.AddNetworkString("PROGRESSION.CL.RequestData")
util.AddNetworkString("PROGRESSION.SV.SendData")

function PROGRESSION.SV.CanUse(ply)
    return PROGRESSION.CFG.CANUSE[ply:Team()] and true or false
end

function PROGRESSION.SV.LoadModules()
    print("[PROGRESSION] Loading modules...")
    PROGRESSION.SV.Modules.health = include("progression/modules/module_health.lua")
    PROGRESSION.SV.Modules.armor = include("progression/modules/module_armor.lua")
    PROGRESSION.SV.Modules.weight = include("progression/modules/module_weight.lua")
    PROGRESSION.SV.Modules.second_heart = include("progression/modules/module_second.lua")
    print("[PROGRESSION] Loaded modules!")
end

function PROGRESSION.SV.Init()
    -- Create table if not exists progression_data: steamid, module, level
    sql.Query("CREATE TABLE IF NOT EXISTS progression_data (steamid TEXT, module TEXT, level TEXT)")
    PROGRESSION.SV.LoadModules()
end
hook.Add("Initialize", "PROGRESSION.SV.Init", PROGRESSION.SV.Init)

function PROGRESSION.SV.SaveData(ply, skill, level)
    local data = sql.Query("SELECT * FROM progression_data WHERE steamid = '" .. ply:SteamID64() .. "' AND module = '" .. skill .. "'")
    if data then
        sql.Query("UPDATE progression_data SET level = '" .. level .. "' WHERE steamid = '" .. ply:SteamID64() .. "' AND module = '" .. skill .. "'")
        return
    end
    sql.Query("INSERT INTO progression_data (steamid, module, level) VALUES ('" .. ply:SteamID64() .. "', '" .. skill .. "', '" .. level .. "')")
end

function PROGRESSION.SV.ResetData()
    sql.Query("DROP TABLE progression_data")
    sql.Query("CREATE TABLE IF NOT EXISTS progression_data (steamid TEXT, module TEXT, level TEXT)")
end

-- if start of new month then reset data and lets save our wipe date so we can check if we need to wipe again
function PROGRESSION.SV.CheckWipe()
    local lastWipe = sql.Query("SELECT * FROM progression_wipe")
    if lastWipe then
        lastWipe = lastWipe[1]["last_wipe"]
        local lastWipeMonth = os.date("%Y-%m", lastWipe) -- Get only year and month
        local currentMonth = os.date("%Y-%m", os.time()) -- Get only year and month
        if lastWipeMonth ~= currentMonth then
            PROGRESSION.SV.ResetData()
            sql.Query("UPDATE progression_wipe SET last_wipe = '" .. os.time() .. "'")
        end
    else
        sql.Query("CREATE TABLE IF NOT EXISTS progression_wipe (last_wipe TEXT)")
        sql.Query("INSERT INTO progression_wipe (last_wipe) VALUES ('" .. os.time() .. "')")
    end
end
hook.Add("Initialize", "PROGRESSION.SV.CheckWipe", PROGRESSION.SV.CheckWipe)

function PROGRESSION.SV.LoadData(ply)
    local data = sql.Query("SELECT * FROM progression_data WHERE steamid = '" .. ply:SteamID64() .. "'")
    PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()] = {}
    if data then
        for k, v in pairs(data) do
            PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()][v["module"]] = tonumber(v["level"])
        end
    end
end
hook.Add("PlayerInitialSpawn", "PROGRESSION.SV.LoadData", PROGRESSION.SV.LoadData)

function PROGRESSION.SV.GetLevel(ply, skill)
    if not PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()] then return 0 end
    return PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()][skill] or 0
end

function PROGRESSION.SV.GetCurSkill(ply, skill)
    --local level = PROGRESSION.SV.GetLevel(ply, skill)
    return PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()][skill] or false
end

function PROGRESSION.SV.ApplySkills(ply)
    if not PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()] then return end
    for k, v in pairs(PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()]) do
        if PROGRESSION.SV.Modules[k] then
            PROGRESSION.SV.Modules[k].Apply(ply, v)
        end
    end
end
hook.Add("PlayerSpawn", "PROGRESSION.SV.ApplySkills", function(ply)
    if timer.Exists("PROGRESSION:SV:"..ply:SteamID64()) then
        timer.Remove("PROGRESSION:SV:"..ply:SteamID64())
    end

    timer.Create("PROGRESSION:SV:"..ply:SteamID64(), 2, 1, function()
        if not IsValid(ply) then
            timer.Remove("PROGRESSION:SV:"..ply:SteamID64())
            return
        end
        PROGRESSION.SV.ApplySkills(ply)
    end)
end)

function PROGRESSION.SV.OpenMenu(ply)
    net.Start("PROGRESSION.CL.OpenMenu")
    net.Send(ply)
end

-- Run PROGRESSION.CFG.QUIZES amount of quizes using function ATLASQUIZ.QuizPly(ply, _, callback) for each quiz
function PROGRESSION.SV.QuizPlayer(ply, callback_result)
    ATLASQUIZ.QuizPly(ply, 3, function(quizPly, answerResult)
        callback_result(quizPly, answerResult)
    end)
end

function PROGRESSION.SV.ProcessQuiz(ply, canUpgrade_Callback)
    PROGRESSION.SV.QuizPlayer(ply, function(_, result)
        canUpgrade_Callback(result)
    end)
end

function PROGRESSION.SV.BuyUpgrade(ply, targetPly, skill)
    if not PROGRESSION.SV.CanUse(ply) then return end
    local level = PROGRESSION.SV.GetLevel(targetPly, skill)
    if level == 0 then
        PROGRESSION.SV.ActiveUpgrades[targetPly:SteamID64()][skill] = 1
        PROGRESSION.SV.SaveData(targetPly, skill, 1)
        PROGRESSION.SV.ApplySkills(targetPly)
        ply:addMoney(-PROGRESSION.CFG.Upgrades[skill]["v1"].price)
        ply:ChatPrint("{green |} You have bought " .. PROGRESSION.CFG.Upgrades[skill]["v1"].name .. " for $" .. PROGRESSION.CFG.Upgrades[skill]["v1"].price .. ".")
    else
        if level < 4 then
            PROGRESSION.SV.ActiveUpgrades[targetPly:SteamID64()][skill] = level + 1
            PROGRESSION.SV.SaveData(targetPly, skill, level + 1)
            PROGRESSION.SV.ApplySkills(targetPly)
            PROGRESSION.SV.SendData(targetPly)
            ply:addMoney(-PROGRESSION.CFG.Upgrades[skill]["v" .. tostring(level + 1)].price)
            ply:ChatPrint("{green |} You have bought " .. PROGRESSION.CFG.Upgrades[skill]["v" .. level + 1].name .. " for $" .. PROGRESSION.CFG.Upgrades[skill]["v" .. level + 1].price .. ".")
        end
    end
end

function PROGRESSION.SV.SendData(ply)
    net.Start("PROGRESSION.SV.SendData")
        net.WriteEntity(ply)
        net.WriteTable(PROGRESSION.SV.ActiveUpgrades[ply:SteamID64()])
    net.Send(ply)
end

-- Player ready to receive net messages
hook.Add("ATLASCORE::PlayerNetReady", "PROGRESSION.SV.OpenMenu", function(ply)
    -- Send player their progression data
    PROGRESSION.SV.SendData(ply)
end)

net.Receive("PROGRESSION.CL.BuyUpgrade", function(_, ply)
    local targetPly = net.ReadEntity()
    local skill = net.ReadString()
    if not ply:canAfford(PROGRESSION.CFG.Upgrades[skill]["v" .. tostring(PROGRESSION.SV.GetLevel(targetPly, skill) > 0 and PROGRESSION.SV.GetLevel(targetPly, skill) or 1)].price) then
        ply:ChatPrint("You cannot afford this upgrade.")
        return
    end
    PROGRESSION.SV.ProcessQuiz(ply, function(result)
        if result then
            PROGRESSION.SV.BuyUpgrade(ply, targetPly, skill)
        else
            -- format PROGRESSION.CFG.MoneyBack into a percent PROGRESSION.CFG.MoneyBack = 0.5
            local percentBack = PROGRESSION.CFG.MoneyBack * 100
            ply:ChatPrint("You failed the quiz, you will only receive " .. percentBack .. "% of your money back.")

            -- Refund the player
            ply:addMoney(-PROGRESSION.CFG.Upgrades[skill]["v" .. PROGRESSION.SV.GetLevel(targetPly, skill)].price * PROGRESSION.CFG.MoneyBack)
        end
    end)
end)

net.Receive("PROGRESSION.CL.RequestData", function(_, ply)
    --if not PROGRESSION.SV.CanUse(ply) then return end
    local requestedPly = net.ReadEntity()
    local data = {}
    if PROGRESSION.SV.ActiveUpgrades[requestedPly:SteamID64()] then
        data = PROGRESSION.SV.ActiveUpgrades[requestedPly:SteamID64()]
    end
    net.Start("PROGRESSION.SV.SendData")
        net.WriteEntity(requestedPly)
        net.WriteTable(data)
    net.Send(ply)
end)

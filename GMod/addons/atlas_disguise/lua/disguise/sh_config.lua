ADQ = ADQ or {}
ADQ.CONF = ADQ.CONF or {}

-- Models that are allowed to be used with the locker
    -- Models that are allowed to be used with FOUNDATION
ADQ.CONF.FoundationModels = {
    ["models/player/Group03/female_01.mdl"] = true,
    ["models/player/Group03/female_02.mdl"] = true,
    ["models/player/Group03/female_03.mdl"] = true,
    ["models/player/Group03/female_04.mdl"] = true,
    ["models/player/Group03/female_05.mdl"] = true,
    ["models/player/Group03/female_06.mdl"] = true,
    ["models/player/Group03/male_01.mdl"] = true,
    ["models/player/Group03/male_02.mdl"] = true,
    ["models/player/Group03/male_03.mdl"] = true,
    ["models/player/Group03/male_04.mdl"] = true,
    ["models/player/Group03/male_05.mdl"] = true,
    ["models/player/Group03/male_06.mdl"] = true,
    ["models/player/Group03/male_07.mdl"] = true,
    ["models/player/Group03/male_08.mdl"] = true,
    ["models/player/Group03/male_09.mdl"] = true,
    ["models/player/suits/robber_open.mdl"] = true,
    ["models/player/suits/robber_shirt.mdl"] = true,
    ["models/player/suits/robber_shirt_2.mdl"] = true,
    ["models/player/suits/robber_tie.mdl"] = true,
    ["models/player/suits/robber_tuckedtie.mdl"] = true,
}

-- Models that are allowed to be used with CHAOS
ADQ.CONF.ChaosModels = {
    ["models/player/suits/robber_open.mdl"] = true,
    ["models/player/suits/robber_shirt.mdl"] = true,
    ["models/player/suits/robber_shirt_2.mdl"] = true,
    ["models/player/suits/robber_tie.mdl"] = true,
    ["models/player/suits/robber_tuckedtie.mdl"] = true,
    ["models/sentry/sentryoldmob/mafia/sentrymobmale2pm.mdl"] = true,
    ["models/sentry/sentryoldmob/mafia/sentrymobmale4pm.mdl"] = true,
    ["models/sentry/sentryoldmob/mafia/sentrymobmale6pm.mdl"] = true,
    ["models/sentry/sentryoldmob/mafia/sentrymobmale7pm.mdl"] = true,
    ["models/sentry/sentryoldmob/mafia/sentrymobmale8pm.mdl"] = true,
    ["models/sentry/sentryoldmob/mafia/sentrymobmale9pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentryarmbmale2pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentryarmbmale8pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentryarmbmale6pm.mdl"] = true,
    ["models/sentry/sentryoldmob/britgoons/sentrybritmale4pm.mdl"] = true,
    ["models/sentry/sentryoldmob/britgoons/sentrybritmale6pm.mdl"] = true,
    ["models/sentry/sentryoldmob/britgoons/sentrybritmale8pm.mdl"] = true,
    ["models/sentry/sentryoldmob/britgoons/sentrybritmale9pm.mdl"] = true,
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale4pm.mdl"] = true,
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale2pm.mdl"] = true,
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale7pm.mdl"] = true,
    ["models/sentry/sentryoldmob/greaser/sentrygreasemale9pm.mdl"] = true,
    ["models/sentry/sentryoldmob/irish/sentryirishmale2pm.mdl"] = true,
    ["models/sentry/sentryoldmob/irish/sentryirishmale4pm.mdl"] = true,
    ["models/sentry/sentryoldmob/irish/sentryirishmale6pm.mdl"] = true,
    ["models/sentry/sentryoldmob/irish/sentryirishmale7pm.mdl"] = true,
    ["models/sentry/sentryoldmob/irish/sentryirishmale8pm.mdl"] = true,
    ["models/sentry/sentryoldmob/irish/sentryirishmale9pm.mdl"] = true,
    ["models/sentry/sentryoldmob/slygoons/sentryslymale6pm.mdl"] = true,
    ["models/sentry/sentryoldmob/slygoons/sentryslymale7pm.mdl"] = true,
    ["models/sentry/sentryoldmob/slygoons/sentryslymale8pm.mdl"] = true,
    ["models/sentry/sentryoldmob/slygoons/sentryslymale9pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male2pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male4pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male6pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male7pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male8pm.mdl"] = true,
    ["models/sentry/sentryoldmob/oldgoons/sentrybusi1male9pm.mdl"] = true,
}

function ADQ.ValidateConfig()
    ADQ.CONF.FoundationModels = ADQ.CONF.FoundationModels or {}
    ADQ.CONF.ChaosModels = ADQ.CONF.ChaosModels or {}
    
    for model, _ in pairs(ADQ.CONF.FoundationModels) do
        if not file.Exists(model, "GAME") then
            print("[ADQ] Warning: Foundation model " .. model .. " does not exist!")
        end
    end
    
    for model, _ in pairs(ADQ.CONF.ChaosModels) do
        if not file.Exists(model, "GAME") then
            print("[ADQ] Warning: Chaos model " .. model .. " does not exist!")
        end
    end
end

ADQ.ValidateConfig()

-- Export tables to shared environment
if SERVER then
    util.AddNetworkString("ADQ_SyncConfig")
    
    hook.Add("PlayerInitialSpawn", "ADQ_SyncConfig", function(ply)
        net.Start("ADQ_SyncConfig")
            net.WriteTable(ADQ.CONF)
        net.Send(ply)
    end)
end

if CLIENT then
    net.Receive("ADQ_SyncConfig", function()
        ADQ.CONF = net.ReadTable()
    end)
end

-- DarkRP factions that are allowed to use the locker
ADQ.CONF.Factions = {
    ["CHAOS"] = true,
    ["FOUNDATION"] = true,
}

-- Jobs that are apart of the above factions that we do not want to be able to use the locker
ADQ.CONF.BlacklistedJobs = {
    ["SI: K9"] = true,
}

-- DarkRP factions that are allowed to use the locker
ADQ.CONF.Factions = {
    ["CHAOS"] = true,
    ["FOUNDATION"] = true,
}

-- Jobs that are apart of the above factions that we do not want to be able to use the locker
ADQ.CONF.BlacklistedJobs = {
    ["SI: K9"] = true,
}

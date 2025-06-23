PROGRESSION.CFG = PROGRESSION.CFG or {}

PROGRESSION.CFG.MoneyBack = 0.5 -- 50% of the money you spent on the item will be returned to you when you sell it.

PROGRESSION.CFG.QUIZES = 3

PROGRESSION.CFG.Upgrades = {
    health = {
        ["v1"] = {name = "Health V1", health = 5, uihp = 5, price = 2500},
        ["v2"] = {name = "Health V2", health = 15, uihp = 10, price = 3500},
        ["v3"] = {name = "Health V3", health = 30, uihp = 15, price = 5000},
    },
    armor = {
        ["v1"] = {name = "Armor V1", armor = 5, uiap = 5, price = 2500},
        ["v2"] = {name = "Armor V2", armor = 15, uiap = 10, price = 3500},
        ["v3"] = {name = "Armor V3", armor = 30, uiap = 15, price = 5000},
    },
    weight = {
        ["v1"] = {name = "Weight V1", weight = 15, uiw = 15, price = 2500},
        ["v2"] = {name = "Weight V2", weight = 40, uiw = 25, price = 3500},
        ["v3"] = {name = "Weight V3", weight = 75, uiw = 35, price = 5000},
    },
    second_heart = {
        ["v1"] = {name = "Second Heart", price = 50000}
    }
}

-- when darkrp jobs are ready hook
timer.Simple(1, function()
    PROGRESSION.CFG.CANUSE = {
        [TEAM_RSJUNIOR] = "FOUNDATION",
        [TEAM_RSSENIOR] = "FOUNDATION",
        [TEAM_RSEXPERT] = "FOUNDATION",
        [TEAM_RSSUP] = "FOUNDATION",
        [TEAM_RADEPUTY] = "FOUNDATION",
        [TEAM_RAHOR] = "FOUNDATION",
        [TEAM_RSRESEARCHER] = "FOUNDATION",
        [TEAM_RIINITIATE] = "CHAOS",
        [TEAM_RIRESEARCHER] = "CHAOS",
        [TEAM_RISENRESEARCHER] = "CHAOS",
        [TEAM_RIOFFICER] = "CHAOS",
        [TEAM_RIINFILTRATOR] = "CHAOS",
        [TEAM_RILEADINFILTRATOR] = "CHAOS",
    }
end)
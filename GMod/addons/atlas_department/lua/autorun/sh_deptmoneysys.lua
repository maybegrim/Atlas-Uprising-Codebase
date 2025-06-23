// CONFIGURATION
ATLAS_DEPTMONEYSYS = ATLAS_DEPTMONEYSYS or {}

ATLAS_DEPTMONEYSYS.serverCategorys = { // Categories of people that can view/use the menu
    ["SITE STAFF"] = true,
    ["GENSEC"] = true,
    ["NINE-TAILED FOX"] = true,
    ["MEDICAL STAFF EX"] = true,
    ["RESEARCH AGENCY EX"] = true,
    ["Upsilon-11"] = true,
    ["RED RIGHT HAND"] = true,
    ["COMMAND INSURGENTS"] = true,
    ["SITE COMMAND"] = true,
    ["XI-13"] = true,
}
--[[ATLAS_DEPTMONEYSYS.serverCategorys = { // Categories of people that can view/use the menu
    ["GSC"] = true,
    ["NTF"] = true,
    ["MED"] = true,
    ["RA"] = true,
    ["E6"] = true,
    ["MU4"] = true,
    ["CHAOS"] = true,
    ["SITE COMMAND"] = true,
}]]


ATLAS_DEPTMONEYSYS.CategoryCrossover = {
    ["RESEARCH AGENCY"] = "RESEARCH AGENCY EX",
    ["MEDICAL STAFF"] = "MEDICAL STAFF EX",
    ["ASSAULT INSURGENTS"] = "COMMAND INSURGENTS",
    ["RESEARCH INSURGENTS"] = "COMMAND INSURGENTS",
    ["SPIRE INSURGENTS"] = "COMMAND INSURGENTS",
}

ATLAS_DEPTMONEYSYS.AllowedDepositTeams = { // Jobs that can withdraw/deposit 
    ["Site Quartermaster"] = true,
    ["Site Director"] = true,
    ["GENSEC Captain"] = true,
    ["NTF Captain"] = true,
    ["Medical Director"] = true,
    ["Head of Research"] = true,
    ["U11 Captain"] = true,
    ["RRH: Captain"] = true,
    ["CI: Commander"] = true,
    ["XI-13 Captain"] = true
}

ATLAS_DEPTMONEYSYS.AllowedWithdrawTeams = { // Jobs that can withdraw/deposit 
    ["Site Quartermaster"] = true,
    ["Site Director"] = true,
    ["GENSEC Captain"] = true,
    ["NTF Captain"] = true,
    ["Medical Director"] = true,
    ["Head of Research"] = true,
    ["U11 Captain"] = true,
    ["RRH: Captain"] = true,
    ["CI: Commander"] = true,
    ["XI-13 Captain"] = true
}

ATLAS_DEPTMONEYSYS.AllowedMaintenanceTeams = {
    ["Site Quartermaster"] = true,
    ["Site Director"] = true,
    ["CI: Commander"] = true,
    ["GENSEC Captain"] = true,
    ["NTF Captain"] = true,
    ["Medical Director"] = true,
    ["Head of Research"] = true,
    ["U11 Captain"] = true,
    ["RRH: Captain"] = true,
    ["CI: Commander"] = true,
    ["XI-13 Captain"] = true
}

ATLAS_DEPTMONEYSYS.AllowedShipmentTeams = {
    ["Site Quartermaster"] = true,
    ["GENSEC Captain"] = true,
    ["NTF Captain"] = true,
    ["Medical Director"] = true,
    ["Head of Research"] = true,
    ["U11 Captain"] = true,
    ["RRH: Captain"] = true,
    ["CI: Commander"] = true,
    ["XI-13 Captain"] = true
}

ATLAS_DEPTMONEYSYS.VitalityUpgrades = { // Vitality Upgrades and prices - Format [V1] = {amount of addition hp, cost of that addon}
    [1] = {5, 100000, "Vitality"}, 
    [2] = {10, 200000, "Vitality"},
    [3] = {15, 300000, "Vitality"}
}

ATLAS_DEPTMONEYSYS.ArmorUpgrades = { // Armor Upgrades and prices
    [1] = {10, 200000, "Armor"},
    [2] = {20, 350000, "Armor"},
    [3] = {30, 500000, "Armor"}
}
ATLAS_DEPTMONEYSYS.weaponTeams =
{
    ["AssaultRifles"] = {
        ["AI: Lead Medic"] = true,
        ["AI: Medic"] = true,
        ["AI: NCO"] = true,
        ["AI: Officer"] = true,
        ["AI: Operative"] = true,
        ["AI: Senior Operative"] = true,
        ["Assistant Security Chief"] = true,
        ["CI: Commander"] = true,
        ["CI: Lead Research Insurgent"] = true,
        ["CI: Supervisors"] = true,
        ["CI: Vice-Commander"] = true,
        ["U11 Captain"] = true,
        ["DF Lead Surface Officer"] = true,
        ["DF Dispatch"] = true,
        ["DF NCO"] = true,
        ["DF Officer"] = true,
        ["DF Operative"] = true,
        ["DF Senior Operative"] = true,
        ["DF Trainee"] = true,
        ["FBI Trainee"] = true,
        ["FBI Operative"] = true,
        ["FBI Lead"] = true,
        ["SWAT Medic"] = true,
        ["SWAT Medic Lead"] = true,
        ["SWAT Explosive Specialist"] = true,
        ["SWAT ES Lead"] = true,
        ["SWAT Lead"] = true,
        ["GENSEC Captain"] = true,
        ["GENSEC NCO"] = true,
        ["GENSEC Officer"] = true,
        ["GENSEC Senior Trooper"] = true,
        ["GENSEC Trooper"] = true,
        ["Lead GENSEC Officer"] = true,
        ["MU-4: Captain"] = true,
        ["MU-4: Engineer"] = true,
        ["MU-4: Inquisitor"] = true,
        ["MU-4: Operative"] = true,
        ["NTF Captain"] = true,
        ["NTF Lead Containment Officer"] = true,
        ["NTF NCO"] = true,
        ["NTF Officer"] = true,
        ["NTF Operative"] = true,
        ["NTF Senior Operative"] = true,
        ["RA: NCO"] = true,
        ["RA: Officer"] = true,
        ["RA: Operative"] = true,
        ["RA: Senior Operative"] = true,
        ["RI: Officer"] = true,
        ["RI: Researcher"] = true,
        ["RI: Senior Researcher"] = true,
        ["SI: Captain"] = true,
        ["SI: Operative"] = true,
        ["SI: Senior Operative"] = true,
        ["SI: Specialist"] = true,
        ["Security Chief"] = true,
        ["Security Medic"] = true,
        ["Security Medic NCO"] = true,
        ["Security Medic Officer"] = true,
        ["Senior Security Medic"] = true,
        ["ERU Medic"] = true,
        ["ERU Medic Lead"] = true,
        ["Site Quartermaster"] = true,
        ["AI: Captain"] = true,
        ["SWAT Spec Lead"] = true,
    },
    ["LightMachineGuns"] = {
        ["AI: Heavy"] = true,
        ["AI: Lead Heavy"] = true,
        ["SWAT Heavy"] = true,
        ["SWAT Heavy Lead"] = true,
        ["GENSEC Heavy"] = true,
        ["GENSEC Heavy Lead"] = true,
    },
    ["SniperRifles"] = {
        ["AI: Lead Sniper"] = true,
        ["AI: Sniper"] = true,
        ["SWAT Marksman"] = true,
        ["SWAT Marksman Lead"] = true,
    },
}

ATLAS_DEPTMONEYSYS.WeaponUpgrades = {
    ["SniperRifles"] = {
        ["khr_t5000"] = {name = "T5000", cost = 300000},
        ["cw_sinon_pgm"] = {name = "PGM Hecate II", cost = 500000},
    },
    ["AssaultRifles"] = {
        ["cw_vss"] = {name = "[T1] VSS Vintorez", cost = 50000},
        ["cw_rinic_galil"] = {name = "[T1] IMI-Galil", cost = 50000},
        ["cw_l85a1"] = {name = "[T1] L85A1 Bullpup", cost = 50000},
        ["cw_sako95"] = {name = "[T2] RK-95", cost = 150000},
        ["cw_sig_chan"] = {name = "[T2] SIG-550", cost = 150000},
        ["cw_scarh"] = {name = "[T2] FN SCAR-H", cost = 150000},
        ["cw_hk416"] = {name = "[T2] HK-416", cost = 150000},
        ["cw_soar"] = {name = "[T2] SOAR", cost = 150000},
        ["cw_ghosts_hb"] = {name = "[T3] Honey Badger", cost = 300000},
        ["cw_aksd"] = {name = "[T3] AK-SD", cost = 350000},
        ["cw_auga1"] = {name = "[T3] Aug-A1", cost = 350000},
        ["cw_rinic_m4a1"] = {name = "[T3] M4A1", cost = 350000},
        ["cw_ar15"] = {name = "[T3] AR-15", cost = 350000},
        ["cw_noobveske_diplomat"] = {name = "[T4] DIPLOMAT", cost = 500000},
        ["cw_kk_hk416"] = {name = "[T4] HK-416 Soul", cost = 500000},
    },
    ["LightMachineGuns"] = {
        ["cw_ghosts_m27iar"] = {name = "M27-IAR", cost = 300000},
        ["cw_rpd"] = {name = "RPD", cost = 300000},
        ["cw_m1919a6"] = {name = "M1919A6", cost = 300000},
        ["cw_mg42"] = {name = "MG42", cost = 300000},
    },
}

ATLAS_DEPTMONEYSYS.LogColours = {
    ["Boosts"] = Color(211, 84, 0),
    ["Weapons"] = Color(41, 128, 185),
    ["Withdraw"] = Color(192, 57, 43),
    ["Deposit"] = Color(39, 174, 96),
    ["Maintenance"] = Color(142, 68, 173)
}

ATLAS_DEPTMONEYSYS.hourlyPay = 500 // amount each player earns in their respective role
ATLAS_DEPTMONEYSYS.hourlyInsurgentPay = 100 // amount per hour insurgents make
ATLAS_DEPTMONEYSYS.fixedSiteDirectorFee = 1500000 // fixed monthly fee for Site Command
ATLAS_DEPTMONEYSYS.fixedInsurgentFee = 500000 // fixed monthly fee for Insurgents
ATLAS_DEPTMONEYSYS.suggestedMaintenanceBasedonHours = 20 // % of monthly hours x pay taken from department for maintenance

// SHARED FUNCTIONS


// PLAYER FUNCTIONS
local meta = FindMetaTable("Player")

function meta:getJobCategory() 
    local t = self:getJobTable()
    if ATLAS_DEPTMONEYSYS.CategoryCrossover[t.category] then
        return ATLAS_DEPTMONEYSYS.CategoryCrossover[t.category]
    end
    return t.category or "nil"
end

function meta:canModifyMoneySystem()
    local job = self:getDarkRPVar("job")
    return ATLAS_DEPTMONEYSYS.AllowedMaintenanceTeams[job] and true or false
end

function meta:canViewMoneySystem()
    local cat = self:getJobCategory()
    return ATLAS_DEPTMONEYSYS.serverCategorys[cat] and true or false
end

// DEPARTMENT FUNCTIONS

function getDepartmentMoney( cat )
    if p.departmentTable then
        return p.departmentTable["money"]
    end
    return 0
end

function getDepartmentJobs( cat )
    local jobsInCategory = {}

    for _, teamData in pairs(RPExtraTeams) do
        local category = ATLAS_DEPTMONEYSYS.CategoryCrossover[teamData.category] or teamData.category
        if category == cat then
            table.insert(jobsInCategory, teamData.name)
        end
    end

    return jobsInCategory
end

function getAvailableWeaponCategory( pTeam )
    for k, v in pairs(ATLAS_DEPTMONEYSYS.weaponTeams) do
        if ATLAS_DEPTMONEYSYS.weaponTeams[k][pTeam] then
            return k
        end
    end
    return nil
end

function getAvailableWeapons( pTeam )
    local weps = {}
    for k,v in pairs(LEVEL.Weapons) do
        print(pTeam)
        if v.team == pTeam then
            v.id = k
            table.insert(weps, v)
        end
    end

    return weps
end

function teamNameToInt( teamName )
    local teamTable = team.GetAllTeams()
    for teamInt, team in pairs(teamTable) do
        if team.Name == teamName then
            return teamInt
        end
    end
    return nil
end

function getPrettyWeaponName( wepID )
    for wepType, weaponTable in pairs(ATLAS_DEPTMONEYSYS.WeaponUpgrades) do
        for wepUID, wepData in pairs(weaponTable) do
            if wepUID != wepID then continue end
            return wepData.name
        end
    end
    return "nil"
end
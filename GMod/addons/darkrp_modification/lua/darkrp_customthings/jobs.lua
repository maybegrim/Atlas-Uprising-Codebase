--[[
********************EVERYTHING BELOW THIS LINE IS FOR V3****************
--]]

-- --[[---------------------------------------------------------------------------
-- DarkRP custom jobs
-- ---------------------------------------------------------------------------
-- This file contains your custom jobs.
-- This file should also contain jobs from DarkRP that you edited.

-- Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
--       Once you've done that, copy and paste the job to this file and edit it.

-- The default jobs can be found here:
-- https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

-- For examples and explanation please visit this wiki page:
-- https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

-- Add your custom jobs under the following line:
-- ---------------------------------------------------------------------------]]
-- /* TEAM_TESTFND = DarkRP.createJob("Test Foundation", {
--     color = Color(245, 157, 56),
--     model = {
--         "models/player/cheddar/class_d/class_d_erdim.mdl",
--         "models/player/cheddar/class_d/class_d_eric.mdl",
--         "models/player/cheddar/class_d/class_d_sandro.mdl"
--     },
--     description = [[
--         Testing Foundation
--     ]],
--     weapons = {"mvp_perfecthands", }, blank
--     command = "fnd",
--     max = 128,
--     salary = 15,
--     admin = 0,
--     vote = false,
--     hasLicense = false,
--     canDemote = false,
--     nameFormat = "{RANK} {FIRST} {LAST}",
--     faction = "FOUNDATION"
-- })

-- TEAM_DCLASSTEST = DarkRP.createJob("D-Class Name Test", {
--     color = Color(245, 157, 56),
--     model = {
--         "models/player/cheddar/class_d/class_d_erdim.mdl",
--         "models/player/cheddar/class_d/class_d_eric.mdl",
--         "models/player/cheddar/class_d/class_d_sandro.mdl"
--     },
--     description = [[
--         D-Class Prisoners
--     ]],
--     weapons = {"mvp_perfecthands", }, Blank
--     command = "dclasstest",
--     max = 128,
--     salary = 15,
--     admin = 0,
--     vote = false,
--     hasLicense = false,
--     canDemote = false,
--     nameFormat = "{RANK} {FIRST} {LAST} {DCLASS}",
--     faction = "D-CLASS"
-- }) */


-- D-Class

TEAM_DCLASS = DarkRP.createJob("D-Class", {
    color = Color(255, 145, 0),
    model = {"models/player/cheddar/class_d/class_d_art.mdl",
            "models/player/cheddar/class_d/class_d_erdim.mdl",
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl",},
    description = [[
        A Prisoner of the Foundation. You are to be used as a test subject for experiments. Survive and obey, or fight. The choice is yours.
    ]],
    weapons = {"mvp_perfecthands"},
    command = "dclass",
    max = 128,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "D-Class",
    canDemote = false,
    -- Variables below
    nameFormat = "{DCLASS} {FIRST} {LAST}",
    faction = "D-CLASS",
    department = "D-CLASS",
    isSCP = false,
    noChar = false
})

TEAM_EXPDCLASS = DarkRP.createJob("Experienced D-Class", {
    color = Color(255, 145, 0),
    model = {"models/player/cheddar/class_d/class_d_art.mdl",
            "models/player/cheddar/class_d/class_d_erdim.mdl",
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl",
            "models/gta5/prisoners/prisonerblackpm.mdl",
            "models/gta5/prisoners/prisonerlatinopm.mdl",
            "models/gta5/prisoners/prisonermusclepm.mdl",
            "models/gta5/prisoners/prisonerwhitepm.mdl",},
    description = [[
        A Prisoner of the Foundation. You are to be used as a test subject for experiments. Survive and obey, or fight. The choice is yours.
    ]],
    weapons = {"mvp_perfecthands", "weapon_fists"},
    command = "expdclass",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "D-Class",
    canDemote = false,
    -- Variables below
    nameFormat = "{DCLASS} {FIRST} {LAST}",
    faction = "D-CLASS",
    department = "D-CLASS",
    isSCP = false,
    noChar = false
})

TEAM_MEDDCLASS = DarkRP.createJob("Medical D-Class", {
    color = Color(255, 145, 0),
    model = {"models/player/cheddar/class_d/class_d_art.mdl",
            "models/player/cheddar/class_d/class_d_erdim.mdl",
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl",
            "models/gta5/prisoners/prisonerblackpm.mdl",
            "models/gta5/prisoners/prisonerlatinopm.mdl",
            "models/gta5/prisoners/prisonermusclepm.mdl",
            "models/gta5/prisoners/prisonerwhitepm.mdl",},
    description = [[
        A Prisoner of the Foundation. You recall having medical experience, but you don't know why?... Help out your fellow D-Class and survive.
    ]],
    weapons = {"mvp_perfecthands", "fas2_ifak", "weapon_fists"},
    command = "meddclass",
    max = 4,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "D-Class",
    canDemote = false,
    -- Variables below
    nameFormat = "{DCLASS} {FIRST} {LAST}",
    faction = "D-CLASS",
    department = "D-CLASS",
    isSCP = false,
    noChar = false
})

TEAM_CHADDCLASS = DarkRP.createJob("D-Class Chad", {
    color = Color(255, 145, 0),
    model = {"models/player/gigachad.mdl",
            "models/player/cheddar/class_d/class_d_erdim.mdl",
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl",
            "models/gta5/prisoners/prisonerblackpm.mdl",
            "models/gta5/prisoners/prisonerlatinopm.mdl",
            "models/gta5/prisoners/prisonermusclepm.mdl",
            "models/gta5/prisoners/prisonerwhitepm.mdl",},
    description = [[
        A Prisoner of the Foundation. You've been hitting the gym, and you're ready to fight. Protect those around you and survive.
    ]],
    weapons = {"mvp_perfecthands", "weapon_fists"},
    command = "chaddclass",
    max = 4,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "D-Class",
    canDemote = false,
    -- Variables below
    nameFormat = "{DCLASS} {FIRST} {LAST}",
    faction = "D-CLASS",
    department = "D-CLASS",
    isSCP = false,
    noChar = false,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        timer.Simple(1, function()
            ply:SetModel("models/player/gigachad.mdl")
        end)
    end
})

TEAM_COOKDCLASS = DarkRP.createJob("D-Class Cook", {
    color = Color(255, 145, 0),
    model = {"models/player/cheddar/class_d/class_d_art.mdl",
            "models/player/cheddar/class_d/class_d_erdim.mdl",
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl",
            "models/gta5/prisoners/prisonerblackpm.mdl",
            "models/gta5/prisoners/prisonerlatinopm.mdl",
            "models/gta5/prisoners/prisonermusclepm.mdl",
            "models/gta5/prisoners/prisonerwhitepm.mdl",},
    description = [[
        A Prisoner of the Foundation. You've got cooking skills, put them to use and survive.
    ]],
    weapons = {"mvp_perfecthands", "weapon_fists", "cw_extrema_ratio_official"},
    command = "cookingdclass",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "D-Class",
    canDemote = false,
    -- Variables below
    nameFormat = "{DCLASS} {FIRST} {LAST}",
    faction = "D-CLASS",
    department = "D-CLASS",
    isSCP = false,
    noChar = false
})

TEAM_DEALERDCLASS = DarkRP.createJob("D-Class Dealer", {
    color = Color(255, 145, 0),
    model = {"models/player/cheddar/class_d/class_d_art.mdl",
            "models/player/cheddar/class_d/class_d_erdim.mdl",
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl",
            "models/gta5/prisoners/prisonerblackpm.mdl",
            "models/gta5/prisoners/prisonerlatinopm.mdl",
            "models/gta5/prisoners/prisonermusclepm.mdl",
            "models/gta5/prisoners/prisonerwhitepm.mdl",},
    description = [[
        A Prisoner of the Foundation. You've got the skills and connections to get what you need. Barter with fellow D-Class and survive.
    ]],
    weapons = {"mvp_perfecthands", "weapon_fists"},
    command = "dealerdclass",
    max = 3,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "D-Class",
    canDemote = false,
    -- Variables below
    nameFormat = "{DCLASS} {FIRST} {LAST}",
    faction = "D-CLASS",
    department = "D-CLASS",
    isSCP = false,
    noChar = false
})

TEAM_CMDRDCLASS = DarkRP.createJob("D-Class Commander", {
    color = Color(255, 145, 0),
    model = {"models/player/cheddar/class_d/class_d_art.mdl",
            "models/player/cheddar/class_d/class_d_erdim.mdl",
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl",
            "models/gta5/prisoners/prisonerblackpm.mdl",
            "models/gta5/prisoners/prisonerlatinopm.mdl",
            "models/gta5/prisoners/prisonermusclepm.mdl",
            "models/gta5/prisoners/prisonerwhitepm.mdl",},
    description = [[
        A Prisoner of the Foundation. You must lead your fellow D-Class towards freedom. Survive and obey, or fight. The choice is yours.
    ]],
    weapons = {"mvp_perfecthands", "cw_makarov", "weapon_fists"},
    command = "cmdrdclass",
    max = 2,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "D-Class",
    canDemote = false,
    -- Variables below
    nameFormat = "{DCLASS} {FIRST} {LAST}",
    faction = "D-CLASS",
    department = "D-CLASS",
    isSCP = false,
    noChar = false
})

-- Initial Security Team =======================================================================================================

TEAM_ISTCADET = DarkRP.createJob("GENSEC Cadet", {
    color = Color(116, 178, 248),
    model = "models/player/pmc_4/pmc__11.mdl",
    description = [[
        A Soldier of the Foundation, you start your first day on the job. Prove that you are worthy to be a member of the Foundation.
    ]],
    weapons = {"mvp_perfecthands", "weapon_physcannon"},
    command = "istcadet",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Initial Security Team",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "IST",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_ISTGUARD = DarkRP.createJob("IST Guard", {
    color = Color(116, 178, 248),
    model = "models/player/pmc_4/pmc__12.mdl",
    description = [[
        A Soldier of the Foundation, you've proved your worth. You are now a full fledged member of the Foundation. Follow orders from those around you and do your best!
    ]],
    weapons = {"mvp_perfecthands", "cw_mp5"},
    command = "istguard",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Initial Security Team",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "IST",
    isSCP = false,
    noChar = false,
    armorValue = 55
})
TEAM_ISTSNRGUARD = DarkRP.createJob("IST Senior Guard", {
    color = Color(116, 178, 248),
    model = "models/player/pmc_4/pmc__13.mdl",
    description = [[
        A Soldier of the Foundation, you've proved your worth. You are now a senior member of the IST. Help your fellow new soldiers or join a new department!
    ]],
    weapons = {"mvp_perfecthands", "cw_ump45", "weapon_cuff_elastic"},
    command = "istsnrguard",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Initial Security Team",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "IST",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

-- GENSEC =======================================================================================================

TEAM_GENSECTRA = DarkRP.createJob("GENSEC Trainee", {
    color = Color(0, 13, 255),
    model = "models/jopa_/pmc/pmc_1/pmc__02.mdl",
    description = [[
        A Soldier belonging to GENSEC. Your department is responsible for the protection of LCZ. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_mp5", "cw_ghosts_p226", "weapon_cuff_elastic"},
    command = "gensectrainee",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_GENSECTRP = DarkRP.createJob("GENSEC Trooper", {
    color = Color(0, 13, 255),
    model = "models/sarma_operators/sarma_standard_p.mdl",
    description = [[
        A Soldier belonging to GENSEC. Your department is responsible for the protection of LCZ. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_magpul_pdr", "cw_ghosts_p226", "weapon_cuff_elastic"},
    command = "gensectrooper",
    max = 128,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

TEAM_GENSECSENTRP = DarkRP.createJob("GENSEC Senior Trooper", {
    color = Color(0, 13, 255),
    model = "models/sarma_operators/sarma_standard_p.mdl",
    description = [[
        A Senior Soldier belonging to GENSEC. Your department is responsible for the protection of LCZ. As a senior trooper, your role is to help the lower and upper ranks of your department.
    ]],
    weapons = {"mvp_perfecthands", "cw_fad", "cw_ghosts_p226", "weapon_cuff_elastic"},
    command = "gensecsentrooper",
    max = 128,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 70
})

TEAM_GENSECNCO = DarkRP.createJob("GENSEC NCO", {
    color = Color(0, 13, 255),
    model = "models/sarma_operators/sarma_breacher_p.mdl",
    description = [[
        An NCO belonging to GENSEC. This job is used by Sergeants+. Your department is responsible for the protection of LCZ. As an NCO, your role is to help the lower and upper ranks of your department.
    ]],
    weapons = {"mvp_perfecthands", "cw_fad", "cw_ghosts_p226", "weapon_cuff_elastic"},
    command = "gensecnco",
    max = 128,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_GENSECOFFICER = DarkRP.createJob("GENSEC Officer", {
    color = Color(0, 13, 255),
    model = "models/sarma_operators/sarma_heavy_light_p.mdl",
    description = [[
        An Officer belonging to GENSEC. As an Officer, your job is to lead your fellow soldiers and protect LCZ. You are to follow orders from your superiors and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_fnf2000_mw2", "cw_ghosts_p226", "weapon_cuff_elastic", "stungun"},
    command = "gensecofficer",
    max = 128,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 90
})

TEAM_LEADGENSECOFFICER = DarkRP.createJob("Lead GENSEC Officer", {
    color = Color(0, 13, 255),
    model = "models/jopa_/pmc/pmc_1/pmc__11.mdl",
    description = [[
        The LGO "Lead GENSEC Officer" is the second highest ranked individual in GENSEC. Their main job is to assist the GENSEC Captain in leading the department. They are to follow orders from the Captain and help their subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_kac_pdw", "cw_ghosts_p226", "weapon_cuff_elastic", "stungun"},
    command = "leadgensecofficer",
    max = 128,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 100
})

TEAM_GENSECCAPTAIN = DarkRP.createJob("GENSEC Captain", {
    color = Color(0, 13, 255),
    model = "models/jopa_/pmc/pmc_1/pmc__01.mdl",
    description = [[
        The GENSEC Captain is in-charge of all individuals and situations pertaining to GENSEC. They oversee the department and ensure that it is running smoothly. They are to follow orders from the Security Chief as well as Site Command and help their subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_kac_pdw", "cw_ghosts_p226", "weapon_cuff_elastic", "stungun"},
    command = "genseccaptain",
    max = 128,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 110
})

-- [GENSEC SPECIALTIES]

TEAM_GENSECHEAVY = DarkRP.createJob("GENSEC Heavy", {
    color = Color(0, 13, 255),
    model = "models/dawsonsfp/skin_04/dawsonsfp03.mdl",
    description = [[
        The GENSEC Heavies are a special unit within GENSEC. They are to follow orders from their superiors and help their subordinates. They are to protect LCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_m249_official", "cw_ghosts_p226", "weapon_cuff_elastic"},
    command = "gensecheavy",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 450
})

TEAM_GENSECHEAVYLEAD = DarkRP.createJob("GENSEC Heavy Lead", {
    color = Color(0, 13, 255),
    model = "models/dawsonsfp/skin_04/dawsonsfp04.mdl",
    description = [[
        The GENSEC Heavy Lead is in-charge of all GENSEC Heavies. This role is NOT an Officer position, but is the highest rank before Officer. They are to follow orders from their superiors and help their subordinates. They are to protect LCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_m1918a2", "cw_ghosts_p226", "weapon_cuff_elastic"},
    command = "gensecheavylead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 475
})

TEAM_GENSECK9 = DarkRP.createJob("GENSEC K9", {
    color = Color(0, 13, 255),
    model = "models/lb/gtacityrp/bcmpd_police_dog.mdl",
    description = [[
        The GENSEC K9 is a special unit within GENSEC. These K9s were trained with enhanced cognitive abilities which allow them to understand basic human speech. They are to follow orders as well as assist GENSEC in protecting LCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "swep_k9foundation"},
    command = "gensecdog",
    max = 3,
    salary = 140,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = true,
    PlayerSpawn = function(ply)
    	ply:SetHealth(200)
    	ply:SetMaxHealth(200)
        timer.Simple(3, function()
            -- Double running speed
            ply:SetRunSpeed(400)
        end)
    end
})

TEAM_GENSECWARDEN = DarkRP.createJob("GENSEC Warden", {
    color = Color(0, 13, 255),
    model = "models/jopa_/pmc/pmc_1/pmc__13.mdl",
    description = [[
        The GENSEC Wardens are in-charge of all operations pertaining to D-Block. The Wardens must co-operate with other departments when D-Class are required for any job. They are to follow orders from their superiors and help their subordinates. They are to protect LCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_qbz95", "cw_ghosts_p226", "weapon_cuff_elastic","stungun"},
    command = "gensecwarden",
    max = 6,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 120
})

TEAM_GENSECCHIEFWARDEN = DarkRP.createJob("GENSEC Chief Warden", {
    color = Color(0, 13, 255),
    model = "models/jopa_/pmc/pmc_1/pmc__14.mdl",
    description = [[
        The Chief Warden is in-charge of all Wardens. This job is NOT an Officer Job, but has total control over D-Block. Only Captains+ can overrule the Chief Warden when it comes to any matters pertaining to D-Block. The Chief Warden ensures that D-Block is getting everything it may require. 
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_qbz97", "cw_ghosts_p226", "cw_flash_grenade", "weapon_cuff_elastic","stungun"},
    command = "gensecchiefwarden",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 135
})

TEAM_GENSECDEFSPC = DarkRP.createJob("GENSEC Defensive Specialist", {
    color = Color(0, 13, 255),
    model = "models/jopa_/pmc/pmc_1/pmc__04.mdl",
    description = [[
        The GENSEC Defensive Specialists are a special unit within GENSEC that operate using close quarters combat tactics as well as weapons. They are to follow orders from their superiors and help their subordinates. They are to protect LCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_rinic_1887", "cw_ghosts_p226", "weapon_cuff_elastic", "deployable_shield"},
    command = "gensecdefspc",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_GENSECDSLEAD = DarkRP.createJob("GENSEC D-S LEAD", {
    color = Color(0, 13, 255),
    model = "models/jopa_/pmc/pmc_1/pmc__07.mdl",
    description = [[
        The GENSEC Defensive Specialists Leads are in-charge of all GENSEC Defensive Specialists. This role is NOT an Officer position, but is the highest rank before Officer. They are to follow orders from their superiors and help their subordinates. They are to protect LCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_rinic_1887", "cw_ghosts_p226", "weapon_cuff_elastic", "deployable_shield"},
    command = "gensecdslead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "GENSEC",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "GSC",
    isSCP = false,
    noChar = false,
    armorValue = 85
})

-- Nine-Tailed Fox =======================================================================================================

TEAM_NTFTRAINEE = DarkRP.createJob("NTF Trainee", {
    color = Color(112, 80, 32),
    model = "models/player/pmc_1/pmc__02.mdl",
    description = [[
        A Trainee belonging to Nine-Tailed Fox. Your department is responsible for the protection of HCZ as well as all recontainment procedures within the Foundation. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_ump45", "cw_m1911", "weapon_cuff_elastic"},
    command = "ntftrainee",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_NTFOPERATIVE = DarkRP.createJob("NTF Operative", {
    color = Color(112, 80, 32),
    model = "models/player/cheddar/mtf/e11/mtf_e11_enlisted.mdl",
    description = [[
        A Soldier belonging to Nine-Tailed Fox. Your department is responsible for the protection of HCZ as well as all recontainment procedures within the Foundation. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_g36c", "cw_m1911", "weapon_cuff_elastic"},
    command = "ntfoperative",
    max = 128,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

TEAM_NTFSENIOROPERATIVE = DarkRP.createJob("NTF Senior Operative", {
    color = Color(112, 80, 32),
    model = "models/player/cheddar/mtf/e11/mtf_e11_breacher.mdl",
    description = [[
        A Senior Soldier belonging to Nine-Tailed Fox. Your department is responsible for the protection of HCZ as well as all recontainment procedures within the Foundation. Your role is to help the lower and higher ranking members of your department.
    ]],
    weapons = {"mvp_perfecthands", "cw_g36c", "cw_m1911", "weapon_cuff_elastic"},
    command = "ntfsenioroperative",
    max = 128,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 70
})

TEAM_NTFNCO = DarkRP.createJob("NTF NCO", {
    color = Color(112, 80, 32),
    model = "models/player/cheddar/mtf/e11/mtf_e11_biohazard.mdl",
    description = [[
        An NCO belonging to Nine-Tailed Fox. Your department is responsible for the protection of HCZ as well as all recontainment procedures within the Foundation. Your role is to help the lower and higher ranking members of your department.
    ]],
    weapons = {"mvp_perfecthands", "cw_g36c", "cw_m1911", "weapon_cuff_elastic"},
    command = "ntfnco",
    max = 128,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_NTFOFFICER = DarkRP.createJob("NTF Officer", {
    color = Color(112, 80, 32),
    model = "models/player/cheddar/mtf/e11/mtf_e11_containment.mdl",
    description = [[
        An Officer belonging to Nine-Tailed Fox. Your department is responsible for the protection of HCZ as well as all recontainment procedures within the Foundation. Your role is to help the lower and higher ranking members of your department.
    ]],
    weapons = {"mvp_perfecthands", "cw_galil_ace", "cw_m1911", "weapon_cuff_elastic", "stungun"},
    command = "ntfofficer",
    max = 128,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 90
})

TEAM_NTFLCO = DarkRP.createJob("NTF Lead Containment Officer", {
    color = Color(112, 80, 32),
    model = "models/player/cheddar/mtf/e11/mtf_e11_commander.mdl",
    description = [[
        The Lead Containment Officer(LCO) of the Nine-Tailed Fox. As the second-in-command of the Nine Tailed Fox, your role is to assist the Captain in leading the department. You are to follow orders from the Captain and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_vhs-k21", "cw_m1911", "weapon_cuff_elastic", "stungun"},
    command = "ntflco",
    max = 128,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 100
})

TEAM_NTFCAPTAIN = DarkRP.createJob("NTF Captain", {
    color = Color(112, 80, 32),
    model = "models/nostras/e11.mdl",
    description = [[
        The Captain of the Nine Tailed Fox. As the leader of the Nine-Tailed Fox, your role is to oversee the department and ensure that it is running smoothly. You are to follow orders from the Security Chief as well as Site Command and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_vhs-k21", "cw_m1911", "weapon_cuff_elastic", "stungun"},
    command = "ntfcaptain",
    max = 128,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 110
})

-- [NTF SPECIALTIES]

TEAM_NTFCU = DarkRP.createJob("NTF Cloaking Unit", {
    color = Color(112, 80, 32),
    model = "models/blacklist/merc12.mdl",
    description = [[
        The Cloaking Unit is a special unit within the Nine-Tailed Fox. Their main objective is to use their cloaking abilities to sneak through breached SCPs and recontain them. They are to follow orders from their superiors and help their subordinates. They are to protect HCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_mp7mw3", "cw_m1911", "weapon_cuff_elastic", "swt_cloakingmodule", "cw_extrema_ratio_official"},
    command = "ntfcu",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_NTFCULEAD = DarkRP.createJob("NTF C-U Lead", {
    color = Color(112, 80, 32),
    model = "models/blacklist/merc12.mdl",
    description = [[
        The Cloaking Unit Lead is in-charge of all Cloaking Units. This role is NOT an Officer position, but is the highest rank before Officer. They are to follow orders from their superiors and help their subordinates. They are to protect HCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_mp7mw3", "cw_m1911", "weapon_cuff_elastic", "swt_cloakingmodule", "cw_extrema_ratio_official"},
    command = "ntfculead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 85
})

TEAM_NTFCE = DarkRP.createJob("NTF Containment Engineer", {
    color = Color(112, 80, 32),
    model = "models/player/cheddar/mtf/e11/mtf_e11_enlisted.mdl",
    description = [[
        The Containment Engineers are a special unit within the Nine-Tailed Fox. Their main objective is to use their Engineering Skills to fix any problems in HCZ in order to keep the SCPs contained. They are to follow orders from their superiors and help their subordinates. They are to protect HCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_vector_k10", "cw_m1911", "weapon_cuff_elastic", "au_ds_wrench"},
    command = "ntfce",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_NTFCELEAD = DarkRP.createJob("NTF C-E Lead", {
    color = Color(112, 80, 32),
    model = "models/player/cheddar/mtf/e11/mtf_e11_enlisted.mdl",
    description = [[
        The Containment Engineer Lead is in-charge of all Cloaking Units. This role is NOT an Officer position, but is the highest rank before Officer. They are to follow orders from their superiors and help their subordinates. They are to protect HCZ and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_vector_k10", "cw_m1911", "weapon_cuff_elastic", "au_ds_wrench"},
    command = "ntfcelead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "NINE-TAILED FOX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "NTF",
    isSCP = false,
    noChar = false,
    armorValue = 85
})

-- E6 Village Idiots ====LEAVE TEAM NAMES ALONE===================================================================================================

TEAM_E6TRAINEE = DarkRP.createJob("U11 Trainee", {
    color = Color(179, 0, 255),
    model = {"models/styrofoam/bf4/us_supportpm.mdl",},
    description = [[
        Upsilon 11 | Avalons Wake Trainee. Learn how to operate on the surface, and follow the law. Follow the Rules & be Active to get promoted.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_mp5", "cw_james_p99"},
    command = "awtrainee",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_E6OPERATIVE = DarkRP.createJob("U11 Operative", {
    color = Color(179, 0, 255),
    model = {"models/styrofoam/bf4/us_assaultpm.mdl",},
    description = [[
        Avalons Wake Operative - Promoted from Trainee, your job now is to Follow the Rules & be Active as well as Roleplay properly!
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_vector_k10", "cw_james_p99"},
    command = "awoperative",
    max = 128,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

TEAM_E6NCO = DarkRP.createJob("U11 NCO", {
    color = Color(179, 0, 255),
    model = {"models/styrofoam/bf4/us_engineerpm.mdl",},
    description = [[
        A SGT+ in Avalons Wake, your job is to train and Lead the lower enlisted of the Department.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_acr", "cw_james_p99"},
    command = "awnco",
    max = 128,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_E6OFFICER = DarkRP.createJob("U11 Officer", {
    color = Color(179, 0, 255),
    model = {"models/styrofoam/bf4/us_reconpm.mdl",},
    description = [[
        An Officer belonging to Avalons Wake. Lead your fellow members to victory by keeping the surface safe and by following the Law.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_kk_hk416", "cw_james_p99", "stungun"},
    command = "awofficer",
    max = 6,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 90
})

TEAM_E6LCO = DarkRP.createJob("U11 Lead Counter-Insurgency Officer", {
    color = Color(179, 0, 255),
    model = {"models/dawsonsmtf/dawsonsmtf03.mdl",},
    description = [[
        The LCIO is the Second Highest Ranked individual in Avalons Wake. Help the Captain run the department and make sure the department functions smoothly.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_rinic_m4a1", "cw_james_p99", "stungun"},
    command = "awlcio",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 100
})

TEAM_E6CAPTAIN = DarkRP.createJob("U11 Captain", {
    color = Color(179, 0, 255),
    model = {"models/nostras/u11.mdl",},
    description = [[
        The Captain of Avalons Wake. You're in-charge of leading the fight against the CI. Keep the surface safe!
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_rinic_m4a1", "cw_james_p99", "stungun"},
    command = "awcaptain",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 110
})

-- [U11 SPECIALTIES]

TEAM_E6HEAVY = DarkRP.createJob("U11 Heavy", {
    color = Color(179, 0, 255),
    model = "models/dawsonsfp/skin_08/dawsonsfp03.mdl", 
    description = [[
        The U11 Heavy has a duty to enter any situation first.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_ghosts_m27iar", "cw_james_p99"},
    command = "awheavy",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 500,
    PlayerSpawn = function(ply)
        ply:SetHealth(150)
        ply:SetMaxHealth(150)
        timer.Simple(3, function()
            ply:SetRunSpeed(220)
        end)
    end
})

TEAM_E6HEAVYLEAD = DarkRP.createJob("U11 Heavy Lead", {
    color = Color(179, 0, 255),
    model = "models/dawsonsfp/skin_08/dawsonsfp03.mdl",
    description = [[
        The U11 Heavy Lead is in-charge of all U11 Heavies. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_m1918a2", "cw_james_p99", "stungun"},
    command = "awheavylead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 550,
    PlayerSpawn = function(ply)
        ply:SetHealth(175)
        ply:SetMaxHealth(175)
        timer.Simple(3, function()
            ply:SetRunSpeed(220)
        end)
    end
})

TEAM_E6MARKSMAN = DarkRP.createJob("U11 Marksman", {
    color = Color(179, 0, 255),
    model = "models/dawsonsmtf/dawsonsmtf02.mdl",
    description = [[
        The U11 Marksmen are a special unit within Avalons Wake. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_b196", "cw_james_p99", "realistic_hook", "util_binoculars"}, --https://steamcommunity.com/sharedfiles/filedetails/?id=1968947152
    command = "awmarksman",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 90,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
    end
})

TEAM_E6MARKSMANLEAD = DarkRP.createJob("U11 Marksman Lead", {
    color = Color(179, 0, 255),
    model = "models/dawsonsmtf/dawsonsmtf02.mdl",
    description = [[
        The U11 Marksman Lead is in-charge of all U11 Marksmen. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "khr_m98b", "cw_james_p99", "stungun", "realistic_hook", "util_binoculars"}, --https://steamcommunity.com/sharedfiles/filedetails/?id=1968947152
    command = "awmarksmanlead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 95,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
    end
})

TEAM_E6ES = DarkRP.createJob("U11 Explosive Specialist", {
    color = Color(179, 0, 255),
    model = "models/dawsonsmtf/dawsonsmtf01.mdl",
    description = [[
        The U11 Explosive Specialists are a special unit within Avalons Wake. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_mpl", "cw_james_p99", "m9k_suicide_bomb", "m9k_ied_detonator", "m9k_m61_frag", "m9k_sticky_grenade", "m9k_rpg7", "weapon_slam"},
    command = "awexplo",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 90,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
    end
})

TEAM_E6ESLEAD = DarkRP.createJob("U11 ES Lead", {
    color = Color(179, 0, 255),
    model = "models/dawsonsmtf/dawsonsmtf01.mdl",
    description = [[
        The U11 Explosive Specialist Lead is in-charge of all U11 ExploSpecs. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_mpl", "cw_james_p99", "m9k_suicide_bomb", "m9k_ied_detonator", "m9k_m61_frag", "m9k_sticky_grenade", "stungun", "m9k_rpg7", "weapon_slam"},
    command = "swateslead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 95,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
    end
})

TEAM_E6MED = DarkRP.createJob("U11 Medic", {
    color = Color(179, 0, 255),
    model = "models/humangrunt/payday2/murkywater/murkywater_medicpm.mdl", --https://steamcommunity.com/sharedfiles/filedetails/?id=2213827866
    description = [[
        The U11 Medics are a special unit within Avalons Wake. Although they aren't trained to conduct surgeries, they are able to quickly patch up their allies in the field! They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_blops_mp5", "fas2_ifak", "weapon_defibrillator", "deployable_shield"},
    command = "swatmedic",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 90,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
    end
})

TEAM_E6MEDLEAD = DarkRP.createJob("U11 Medic Lead", {
    color = Color(179, 0, 255),
    model = "models/humangrunt/payday2/murkywater/murkywater_medicpm.mdl", --https://steamcommunity.com/sharedfiles/filedetails/?id=2213827866
    description = [[
        The U11 Medic Lead is in-charge of all U11 Medics. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_blops_mp5", "fas2_ifak", "weapon_defibrillator", "stungun", "deployable_shield"},
    command = "swatmedlead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = false,
    armorValue = 95,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
    end
})

TEAM_E6K9 = DarkRP.createJob("U11 K9", {
    color = Color(179, 0, 255),
    model = "models/lb/gtacityrp/bcmpd_police_dog.mdl",
    description = [[
        The U11 K9 is a special unit within Avalons Wake. These K9s were trained with enhanced cognitive abilities which allow them to understand basic human speech. They are to follow orders as well as assist U11 in protecting the surface and the Foundation at all costs.
    ]],
    weapons = {"mvp_perfecthands", "swep_k9foundation"},
    command = "awdog",
    max = 3,
    salary = 140,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Upsilon-11",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "Upsilon-11",
    isSCP = false,
    noChar = true,
    PlayerSpawn = function(ply)
    	ply:SetHealth(200)
    	ply:SetMaxHealth(200)
        timer.Simple(3, function()
            -- Double running speed
            ply:SetRunSpeed(400)
        end)
    end
})

--XI-13 Sequere Nos ================================================================================================================================

TEAM_X13TRAINEE = DarkRP.createJob("XI-13 Trainee", {
    color = Color(255, 238, 0),
    model = {"models/commander/commander.mdl",},
    description = [[
        XI-13 | Sequere Nos Trainee. Learn how to operate within the foundation. Follow the Rules & be Active to get promoted.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_mp5", "cw_blops_fiveseven"},
    command = "xitrainee",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_X13OPERATIVE = DarkRP.createJob("XI-13 Operative", {
    color = Color(255, 238, 0),
    model = {"models/enlisted_nco/enlisted_nco.mdl",},
    description = [[
        XI-13 | Sequere Nos Operative - Promoted from Trainee, your job now is to Follow the Rules & be Active as well as Roleplay properly!
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_ump45", "cw_blops_fiveseven"},
    command = "xioperative",
    max = 128,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

TEAM_X13NCO = DarkRP.createJob("XI-13 NCO", {
    color = Color(255, 238, 0),
    model = {"models/raptor/specialist.mdl",},
    description = [[
        A SGT+ in XI-13, your job is to train and Lead the lower enlisted of the Department.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "khr_fnfal", "cw_blops_fiveseven"},
    command = "xinco",
    max = 128,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_X13OFFICER = DarkRP.createJob("XI-13 Officer", {
    color = Color(255, 238, 0),
    model = {"models/officer/officer.mdl",},
    description = [[
        An Officer belonging to XI-13. Lead your fellow members to victory by keeping the surface safe and by following the Lxi.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "cw_blops_famas", "cw_blops_fiveseven", "stungun"},
    command = "xiofficer",
    max = 6,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 90
})

TEAM_X13XO = DarkRP.createJob("XI-13 Forward Operations Officer", {
    color = Color(255, 238, 0),
    model = {"models/player/cheddar/tau5/tau5_soldier1.mdl",},
    description = [[
        The FOO is the Second Highest Ranked individual in XI-13. Help the Captain run the department and make sure the department functions smoothly.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "khr_m4a4", "cw_blops_fiveseven", "stungun"},
    command = "xifoo",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 100
})

TEAM_X13CAPTAIN = DarkRP.createJob("XI-13 Captain", {
    color = Color(255, 238, 0),
    model = {"models/player/cheddar/tau5/tau5_soldier2.mdl",},
    description = [[
        The Captain of XI-13 'Sequere Nos'. You're in-charge of doing XI-13 things! --Needs done!*************
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "khr_m4a4", "cw_blops_fiveseven", "stungun"},
    command = "xicaptain",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 110
})

-- [XI-13 SPECIALTIES]

TEAM_X13MECH = DarkRP.createJob("XI-13 Mech", {
    color = Color(255, 238, 0),
    model = {"models/player/Jerome/H2A_ODST_pm/h2aodst_pm.mdl",},
    description = [[
        Insert Description Here
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "khr_m4a4", "cw_blops_fiveseven",},
    command = "ximech",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 100,
    PlayerSpxin = function(ply)
        ply:SetHealth(150)
        ply:SetMaxHealth(150)
    end
})

TEAM_X13MECHLEAD = DarkRP.createJob("XI-13 Mech Lead", {
    color = Color(255, 238, 0),
    model = {"models/player/Jerome/H2A_ODST_pm/h2aodst_pm.mdl",},
    description = [[
        Insert Description Here
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "khr_m4a4", "cw_blops_fiveseven", "stungun"},
    command = "ximechlead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "XI-13",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "XI-13",
    isSCP = false,
    noChar = false,
    armorValue = 150,
    PlayerSpxin = function(ply)
        ply:SetHealth(150)
        ply:SetMaxHealth(150)
    end
})

-- TEAM_X13SPEC = DarkRP.createJob("XI-13 Spec", {
--     color = Color(255, 238, 0),
--     model = "models/dxisonsmtf/dxisonsmtf02.mdl",
--     description = [[
--         The Spec is a special unit within XI-13. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
--     ]],
--     weapons = {"mvp_perfecthands", "weapon_cuff_elastic", ""}, 
--     command = "xispec",
--     max = 3,
--     salary = 100,
--     admin = 0,
--     vote = false,
--     hasLicense = false,
--     category = "XI-13",
--     canDemote = false,
--     -- Variables below
--     nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
--     faction = "FOUNDATION",
--     department = "XI-13",
--     isSCP = false,
--     noChar = false,
--     armorValue = 200,
--     PlayerSpxin = function(ply)
--         ply:SetHealth(100)
--     end
-- })

-- TEAM_X13SPECLEAD = DarkRP.createJob("XI-13 Spec Lead", {
--     color = Color(255, 238, 0),
--     model = "models/dxisonsmtf/dxisonsmtf02.mdl",
--     description = [[
--         The XI-13 *** Lead is in-charge of all XI-13 ***. They are to follow orders from their superiors and help their subordinates. They are to protect the Foundation at all costs.
--     ]],
--     weapons = {"mvp_perfecthands", "weapon_cuff_elastic", ""}, 
--     command = "xispeclead",
--     max = 1,
--     salary = 150,
--     admin = 0,
--     vote = false,
--     hasLicense = false,
--     category = "XI-13",
--     canDemote = false,
--     -- Variables below
--     nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
--     faction = "FOUNDATION",
--     department = "XI-13",
--     isSCP = false,
--     noChar = false,
--     armorValue = 250,
--     PlayerSpxin = function(ply)
--         ply:SetHealth(100)
--     end
-- })

-- MU-4 Debuggers =======================================================================================================

TEAM_MUOPERATIVE = DarkRP.createJob("RRH: Operative", {
    color = Color(185, 10, 15, 255),
    model = "models/kss/tsremastered/mtf.mdl",
    description = [[
        [REDACTED INFORMATION - LEVEL 5 CLEARANCE REQUIRED]
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_mk18", "cw_rinic_glock", "weapon_cuff_elastic", "stungun", "fas2_ifak", "cw_flash_grenade", "heavy_shield"},
    command = "rrhop",
    max = 5,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RED RIGHT HAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "RRH",
    isSCP = false,
    noChar = false,
    armorValue = 100,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            ply:SetMaxHealth(150)
            ply:SetHealth(150)
        end)
    end
})

TEAM_MUENGINEER = DarkRP.createJob("RRH: Specialist", {
    color = Color(185, 10, 15, 255),
    model = "models/kss/tsremastered/mtf.mdl",
    description = [[
        [REDACTED INFORMATION - LEVEL 5 CLEARANCE REQUIRED]
    ]],
    weapons = {"mvp_perfecthands", "cw_saiga12k_official", "cw_rinic_glock", "weapon_cuff_elastic", "au_ds_wrench", "stungun", "heavy_shield", "fas2_ifak", "cw_flash_grenade"},
    command = "rrhinq",
    max = 4,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RED RIGHT HAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "RRH",
    isSCP = false,
    noChar = false,
    armorValue = 100,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            -- Double running speed
            ply:SetRunSpeed(300)
            ply:SetMaxHealth(150)
            ply:SetHealth(150)
        end)
    end
})

TEAM_MUINQ = DarkRP.createJob("RRH: Squad Leader", {
    color = Color(185, 10, 15, 255),
    model = "models/kss/tsremastered/mtf.mdl",
    description = [[
        [REDACTED INFORMATION - LEVEL 5 CLEARANCE REQUIRED]
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_mk18", "cw_rinic_glock", "weapon_cuff_elastic", "stungun", "fas2_ifak", "cw_flash_grenade", "heavy_shield", "weapon_stunstick"},
    command = "rrhsl",
    max = 2,
    salary = 220,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RED RIGHT HAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "RRH",
    isSCP = false,
    noChar = false,
    armorValue = 100,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            ply:SetMaxHealth(150)
            ply:SetHealth(150)
        end)
    end
})

TEAM_MUCAPTAIN = DarkRP.createJob("RRH: Captain", {
    color = Color(185, 10, 15, 255),
    model = "models/nostras/a1.mdl",
    description = [[
        [REDACTED INFORMATION - LEVEL 5 CLEARANCE REQUIRED]
    ]],
    weapons = {"mvp_perfecthands", "cw_m14", "cw_rinic_glock", "weapon_cuff_elastic", "stungun", "fas2_ifak", "cw_flash_grenade", "heavy_shield"},
    command = "rrhcaptain",
    max = 1,
    salary = 250,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RED RIGHT HAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "RRH",
    isSCP = false,
    noChar = false,
    armorValue = 110,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            ply:SetMaxHealth(150)
            ply:SetHealth(150)
        end)
    end
})

-- [Research Scientists] ===============================================================================================

TEAM_RSJUNIOR = DarkRP.createJob("RS: Junior", {
    color = Color(246, 255, 0),
    model = {
            "models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/humans/group03/chemsuit.mdl",
        },
    description = [[
        A Junior Research Scientist. This role is most suited for newly recruited Researchers within this site. Their main role is to learn how to operate within the Research Agency. They are to follow orders from their superiors and help their subordinates.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "elixir_extractor", "weapon_physcannon"},
    command = "rsjunior",
    max = 10,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false
})

TEAM_RSRESEARCHER = DarkRP.createJob("RS: Researcher", {
    color = Color(246, 255, 0),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/humans/group03/chemsuit.mdl",},
    description = [[
        (Internally, this Job outrank Research Agent Sergeants, but does NOT outrank Research Agent Officers) A Senior Research Scientist. This role is most suited for experienced Researchers within this site. Their main role is to help the lower ranking members of their department. They are to follow orders from their superiors and help their subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "weapon_physcannon", "elixir_extractor"},
    command = "rsresearcher",
    max = 10,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}", 
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false
})

TEAM_RSSENIOR = DarkRP.createJob("RS: Senior", {
    color = Color(246, 255, 0),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/humans/group03/chemsuit.mdl",},
    description = [[
        (Internally, this Job outrank Research Agent Sargeants, but does NOT outrank Research Agent Officers) A Senior Research Scientist. This role is most suited for experienced Researchers within this site. Their main role is to help the lower ranking members of their department. They are to follow orders from their superiors and help their subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "elixir_extractor", "weapon_physcannon"},
    command = "rssenior",
    max = 6,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}", 
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false
})

TEAM_RSEXPERT = DarkRP.createJob("RS: Expert", {
    color = Color(246, 255, 0),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/humans/group03/chemsuit.mdl",},
    description = [[
        (Internally, this Role is ranked ABOVE all Research Agent Officers) An Expert Research Scientist. This role is most suited for experienced Researchers within this site. Their main role is to help the lower ranking members of their department. They are to follow orders from their superiors and help their subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "elixir_extractor", "weapon_physcannon"},
    command = "rsexpert",
    max = 4,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}", 
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false
})

TEAM_RSSUP = DarkRP.createJob("RS: Supervisor", {
    color = Color(246, 255, 0),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/humans/group03/chemsuit.mdl",},
    description = [[
        The Supervisor of the Research Scientists. This individual is ranked 3rd highest behind the DHR and HR internally within the Research Agency. As the leader of the Research Scientists, your role is to oversee the department and ensure that it is running smoothly. You are to follow orders from The Deputy Head of Research as well as the Head of Research and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "stungun", "elixir_extractor", "weapon_physcannon"},
    command = "rssup",
    max = 4,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}", 
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false
})

TEAM_RADEPUTY = DarkRP.createJob("Deputy Head of Research", {
    color = Color(246, 255, 0),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/humans/group03/chemsuit.mdl",},
    description = [[
        The Deputy Head of Research. This Individual is ranked equally with the Department Captains. As the Deputy Head of Research, your role is to oversee the Research Scientists AND the Research Agents to ensure that it is running smoothly. You are to follow orders from the Head of Research as well as Site Command and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "stungun", "elixir_extractor", "weapon_physcannon"},
    command = "radeputy",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}", 
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false
})

TEAM_RAHOR = DarkRP.createJob("Head of Research", {
    color = Color(246, 255, 0),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/humans/group03/chemsuit.mdl",},
    description = [[
        As the Head of Research, your role is to oversee the Research Scientists AND the Research Agents to ensure that it is running smoothly. Additionally, you are the Second Highest Ranking individual in the entire Site. You are to follow orders from the Site Director and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "stungun", "elixir_extractor", "weapon_physcannon"},
    command = "hor",
    max = 1,
    salary = 250,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}", 
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false
})

-- [RA SPECIALTIES]

TEAM_RASHIELD = DarkRP.createJob("RA: Field Support", {
    color = Color(246, 255, 0),
    model = "models/playermodel/male_02.mdl",
    description = [[
        The Shield Agents are a special unit within the Research Agency. Their main role is the defense of researchers and their research projects. They are to follow orders from their superiors and help their subordinates. They are to protect the Researchers at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_blops_mp5", "weapon_cuff_elastic", "deployable_shield", "elixir_extractor", "weapon_armorkit", "weapon_physcannon"},
    command = "rafs",
    max = 5,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false,
    armorValue = 180
})

TEAM_RASHIELDLEAD = DarkRP.createJob("RA: Field Support Lead", {
    color = Color(246, 255, 0),
    model = "models/playermodel/male_02.mdl",
    description = [[
        The Shield Lead is in-charge of all Shield Agents. This role is NOT an Officer position, but is the highest rank before Officer. They are to follow orders from their superiors and help their subordinates. They are to protect the Researchers at all costs.
    ]],
    weapons = {"mvp_perfecthands", "cw_blops_mp5", "weapon_cuff_elastic", "deployable_shield", "elixir_extractor", "weapon_armorkit", "weapon_physcannon"},
    command = "rafsl",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH AGENCY EX",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "RA",
    isSCP = false,
    noChar = false,
    armorValue = 185
})

-- Medical Staff =======================================================================================================

TEAM_MEDTRAINEE = DarkRP.createJob("Security Medic Trainee", {
    color = Color(255, 118, 118),
    model = "models/player/pmc_2/pmc__02.mdl",
    description = [[
        A Trainee belonging to the Medical Department. As a Security Medic, your job is to heal and combat. You are not permitted to perform surgeries, as that is only for Passive-Medical Staff. Your department is responsible for the health and well-being of the Foundation's personnel. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_mp5", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "medtrainee",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_MEDIC = DarkRP.createJob("Security Medic", {
    color = Color(255, 118, 118),
    model = "models/dawsonsfp/skin_02/dawsonsfp01.mdl",
    description = [[
        A Medic belonging to the Medical Department. As a Security Medic, your job is to heal and combat. You are not permitted to perform surgeries, as that is only for Passive-Medical Staff. Your department is responsible for the health and well-being of the Foundation's personnel. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_magpul_pdr", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "medic",
    max = 128,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

TEAM_MEDSENIOR = DarkRP.createJob("Senior Security Medic", {
    color = Color(255, 118, 118),
    model = "models/dawsonsfp/skin_02/dawsonsfp02.mdl",
    description = [[
        A Senior Medic belonging to the Medical Department. As a Security Medic, your job is to heal and combat. You are not permitted to perform surgeries, as that is only for Passive-Medical Staff. Your department is responsible for the health and well-being of the Foundation's personnel. Your role is to help the lower ranking members of your department. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_famasg2_official", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "medsenior",
    max = 128,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false,
    armorValue = 70
})

TEAM_MEDNCO = DarkRP.createJob("Security Medic NCO", {
    color = Color(255, 118, 118),
    model = "models/dawsonsfp/skin_02/dawsonsfp03.mdl",
    description = [[
        An NCO belonging to the Medical Department. As a Security Medic, your job is to heal and combat. You are not permitted to perform surgeries, as that is only for Passive-Medical Staff. Your department is responsible for the health and well-being of the Foundation's personnel. Your role is to help the lower ranking members of your department. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_famasg2_official", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "mednco",
    max = 128,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_MEDOFFICER = DarkRP.createJob("Security Medic Officer", {
    color = Color(255, 118, 118),
    model = "models/dawsonsfp/skin_02/dawsonsfp04.mdl",
    description = [[
        An Officer belonging to the Medical Department. As a Security Medic, your job is to heal and combat. You are not permitted to perform surgeries, as that is only for Passive-Medical Staff. Your department is responsible for the health and well-being of the Foundation's personnel. Your role is to help the lower ranking members of your department. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_tar21", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator", "stungun"},
    command = "medofficer",
    max = 128,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false,
    armorValue = 90
})

TEAM_MEDINTERN = DarkRP.createJob("Intern", {
    color = Color(255, 118, 118),
    model = {"models/redninja/pmedic01.mdl",
    "models/redninja/pmedic01f.mdl",
    "models/redninja/pmedic02.mdl",
    "models/redninja/pmedic02f.mdl",},
    description = [[
        A Medical Intern belonging to the Medical Department. As a Medical Intern, your job is to heal within the Medbay. Your department is responsible for the health and well-being of the Foundation's personnel. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "medintern",
    max = 128,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false
})

TEAM_MEDRESIDENT = DarkRP.createJob("Resident", {
    color = Color(255, 118, 118),
    model = {"models/redninja/pmedic01.mdl",
    "models/redninja/pmedic01f.mdl",
    "models/redninja/pmedic02.mdl",
    "models/redninja/pmedic02f.mdl",},
    description = [[
        A Medical Resident belonging to the Medical Department. As a Medical Resident, your job is to heal within the Medbay. Your department is responsible for the health and well-being of the Foundation's personnel. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "medresident",
    max = 128,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false
})

TEAM_MEDSENIORRESIDENT = DarkRP.createJob("Doctor", {
    color = Color(255, 118, 118),
    model = {"models/redninja/pmedic01.mdl",
    "models/redninja/pmedic01f.mdl",
    "models/redninja/pmedic02.mdl",
    "models/redninja/pmedic02f.mdl",},
    description = [[
        (Internally, this Job outranks all Security Medic Sergeants, but does not outrank any Security Medic Officers) A Senior Medical Resident belonging to the Medical Department. As a Medical Resident, your job is to heal within the Medbay. Your department is responsible for the health and well-being of the Foundation's personnel. Your role is to help the lower ranking members of your department. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "medseniorresident",
    max = 8,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false
})

TEAM_MEDDOCTOR = DarkRP.createJob("Consultant", {
    color = Color(255, 118, 118),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",},
    description = [[
        (Internally, this Job outranks ALL Security Medic Officers. This job is the 3rd highest ranking job in Medical Staff) The Lead Doctor is in-charge of all Passive Medical Doctors (Interns, Residents, and Doctors). Your job is to ensure that the quality of the Foundation Medbay remains at a very high standard and that the patients of the Foundation are taken care of.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator", "stungun"},
    command = "meddoctor",
    max = 6,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF EX",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false
})

TEAM_MEDATTENDING = DarkRP.createJob("Medical Attending", {
    color = Color(255, 118, 118),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",},
    description = [[
        The Attending is in-charge of all Passive Doctors and Security Medical forces. Your job is to help the Medical Director with the management of the Medbay and ensure that the quality of the Foundation Medbay remains at a very high standard and that the patients of the Foundation are taken care of.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator", "stungun"},
    command = "medattending",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF EX",
    canDemote = true,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false
})

TEAM_MEDDIRECTOR = DarkRP.createJob("Medical Director", {
    color = Color(255, 118, 118),
    model = {"models/uif/scientists/uif_scientist_1.mdl",
            "models/uif/scientists/uif_scientist_2.mdl",
            "models/uif/scientists/uif_scientist_3.mdl",
            "models/uif/scientists/uif_scientist_4.mdl",
            "models/uif/scientists/uif_scientist_5.mdl",
            "models/uif/scientists/uif_scientist_6.mdl",
            "models/uif/scientists/uif_scientist_7.mdl",
            "models/uif/scientists/uif_scientist_8.mdl",
            "models/uif/scientists/uif_scientist_9.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",},
    description = [[
        The Medical Director leads all Medical Forces within the Foundation(Excluding E6 Medics). This job's rank is equal to Department Captains. Your job is to help the Medical Director with the management of the Medbay and ensure that the quality of the Foundation Medbay remains at a very high standard and that the patients of the Foundation are taken care of.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "stungun", "fas2_ifak", "weapon_defibrillator"},
    command = "meddirector",
    max = 128,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF EX",
    canDemote = true,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false
})

-- MEDICAL SPECS =================================================================

TEAM_ERUMEDIC = DarkRP.createJob("ERU Medic", {
    color = Color(255, 118, 118),
    model = "models/payday2/units/medic_player.mdl",
    description = [[
        A Specialist working for the Medical Department. Your duty is to get to the front line as fast as possible to help support and revive fallen foundation personnel.
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_auga3", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "mederu",
    max = 3,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false,
    armorValue = 50,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            -- Double running speed
            ply:SetRunSpeed(450)
        end)
    end
})

TEAM_ERUMEDICLD = DarkRP.createJob("ERU Medic Lead", {
    color = Color(255, 118, 118),
    model = "models/payday2/units/medic_player.mdl",
    description = [[
        A Specialist Lead working for the Medical Department. Your duty is to get to the front line as fast as possible to help support and revive fallen foundation personnel. Also to train and guide your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_auga3", "weapon_cuff_elastic", "fas2_ifak", "weapon_defibrillator"},
    command = "mederulead",
    max = 1,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "MEDICAL STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}", 
    faction = "FOUNDATION",
    department = "MED",
    isSCP = false,
    noChar = false,
    armorValue = 50,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            -- Double running speed
            ply:SetRunSpeed(500)
        end)
    end
})

-- Site Staff =======================================================================================================

TEAM_SITETECH = DarkRP.createJob("Site Technician", {
    color = Color(94, 191, 255),
    model = "models/player/alan_wake.mdl",
    description = [[
        A Site Staff belonging to the Foundation. As a Site Technician, your job is to fix any and all software-related issues that may occur in the Foundation. You do NOT have a Rank, you simply have responsibilities. 
    ]],
    weapons = {"mvp_perfecthands", "pcams_mobile"},
    command = "sitetech",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "TECH {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE STAFF",
    isSCP = false,
    noChar = false
})

TEAM_SITEENG = DarkRP.createJob("Site Engineer", {
    color = Color(94, 191, 255),
    model = "models/materials/humans/group03m/male_08.mdl",
    description = [[
        A Site Staff belonging to the Foundation. As a Site Engineer, your job is to fix any and all hardware-related issues that may occur in the Foundation. You do NOT have a Rank, you simply have responsibilities. 
    ]],
    weapons = {"mvp_perfecthands", "au_ds_wrench"},
    command = "siteeng",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "ENGINEER {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE STAFF",
    isSCP = false,
    noChar = false
})

TEAM_SITEQUARTER = DarkRP.createJob("Site Quartermaster", {
    color = Color(94, 191, 255),
    model = "models/dawsonsfp/skin_05/dawsonsfp05.mdl",
    description = [[
        A Site Staff belonging to the Foundation. As a Site Quartermaster, your job is to ensure that all Ammo boxes are full. Having a high Salary, this job is important as it requires you to communicate with Site Command(For Resupplies), Security Departments(For Information), and Wardens(For D-Class Ammo Transports). You do NOT have a Rank, you simply have responsibilities. If you fail to uphold your tasks, you may be required to be replaced.
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_qbz97", "cw_sc92fs", "weapon_cuff_elastic"},
    command = "sitequarter",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "QTMST {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE STAFF",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_SITEJANITOR = DarkRP.createJob("Site Janitor", {
    color = Color(94, 191, 255),
    model = {"models/player/kerry/Class_Jan_2.mdl",
            "models/player/kerry/Class_Jan_3.mdl",
            "models/player/kerry/Class_Jan_4.mdl",
            "models/player/kerry/Class_Jan_5.mdl",
            "models/player/kerry/Class_Jan_6.mdl",
            "models/player/kerry/Class_Jan_7.mdl",},
    description = [[
        Clean, Clean, Clean away the grime! As a Site Janitor, your job is to ensure that the Site is clean. You do NOT have a Rank, you simply have responsibilities. (Please, do not be annoying on this job. Thank you!)
    ]],
    weapons = {"mvp_perfecthands", "weapon_cbroom"},
    command = "sitejanitor",
    max = 5,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE STAFF",
    isSCP = false,
    noChar = false
})

-- Site Command =======================================================================================================

TEAM_SITEDIRECTOR = DarkRP.createJob("Site Director", {
    color = Color(45, 3, 3),
    model = {"models/nostras/administration/male_01_administration.mdl",
            "models/nostras/administration/male_02_administration.mdl",
            "models/nostras/administration/male_04_administration.mdl",
            "models/nostras/administration/male_07_administration.mdl",
            "models/nostras/administration/male_08_administration.mdl",
            "models/nostras/administration/male_09_administration.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",},
    description = [[
        The Site Director is the highest ranking individual within the Site. As the Site Director, your job is to ensure that the Site is running smoothly. You are to follow orders from the [REDACTED] Council and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "stungun"},
    command = "sitedirector",
    max = 1,
    salary = 350,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE COMMAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE COMMAND",
    isSCP = false,
    noChar = false
})

TEAM_ASSITEDIRECTOR = DarkRP.createJob("Assistant Site Director", {
    color = Color(45, 3, 3),
    model = {"models/player/cheddar/agent/agent_art.mdl",
            "models/player/cheddar/agent/agent_eric.mdl",
            "models/player/cheddar/agent/agent_joe.mdl",
            "models/player/cheddar/agent/agent_mike.mdl",
            "models/player/cheddar/agent/agent_sandro.mdl",
            "models/player/cheddar/agent/agent_ted.mdl",
            "models/player/cheddar/agent/agent_van.mdl",
            "models/player/cheddar/agent/agent_vance.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",},
    description = [[
        The Assistant Site Director's are 1 rank higher than Department Captains, but 1 rank Lower than Captains. They are the 4rth highest ranking individuals on Site. Their Job is to ensure the Site Director doesn't destroy the facility with their antics as well as assist with all the regular day-to-day activities required of them.
    ]],
    weapons = {"mvp_perfecthands", "cw_sc92fs", "weapon_cuff_elastic", "stungun"},
    command = "asd",
    max = 4,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE COMMAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE COMMAND",
    isSCP = false,
    noChar = false
})

TEAM_SECCHIEF = DarkRP.createJob("Security Chief", {
    color = Color(45, 3, 3),
    model = "models/reptil/reptile_feswat/swa/swa_1_balaclava.mdl",
    description = [[
        The Security Chief is the Highest Ranking combat personel on sight. This individual is the 3rd highest ranking individual on-site behind the Head of Research and the Site Director. The Security Chief is in-charge of all security personnel and has direct command over all of them at all times. Your job is to ensure that the Site is secure and that the Foundation's personnel are safe.
    ]],
    weapons = {"mvp_perfecthands", "cw_m14", "cw_sc92fs", "weapon_cuff_elastic", "stungun", "deployable_shield"},
    command = "securitychief",
    max = 1,
    salary = 250,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE COMMAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE COMMAND",
    isSCP = false,
    noChar = false,
    armorValue = 150
})

TEAM_ASSSECCHIEF = DarkRP.createJob("Assistant Security Chief", {
    color = Color(45, 3, 3),
    model = "models/nostras/diehills/nu7.mdl",
    description = [[
        The Assistant Security Chief is the 5th Highest Ranking individual on-site behind the Assistant Site Directors. The Assistant Security Chief's job is to assist the Security Chief with the management of the Security Department. Your job is to ensure that the Site is secure and that the Foundation's personnel are safe.
    ]],
    weapons = {"mvp_perfecthands", "cw_tr09_mk18", "cw_sc92fs", "weapon_cuff_elastic", "stungun", "deployable_shield"},
    command = "asc",
    max = 4,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE COMMAND",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE COMMAND",
    isSCP = false,
    noChar = false,
    armorValue = 140
})

-- Chaos Insurgency =======================================================================================================

-- [Assault Insurgents]

TEAM_AIINITIATE = DarkRP.createJob("AI: Initiate", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/operative.mdl",
    description = [[
        A Soldier of the Chaos Insurgency. As an Initiate, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_mp9_official", "cw_makarov"},
    command = "aiinitiate",
    max = 128,
    salary = 10,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_AIOPERATIVE = DarkRP.createJob("AI: Operative", {
    color = Color(87, 142, 18),
    model = "models/player/cheddar/chaos_insurgency/chaos_insurgency_soldier.mdl",
    description = [[
        A Full Fledged Soldier of the Chaos Insurgency. As an Operative, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_vss", "cw_makarov"},
    command = "aioperative",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

TEAM_AISENOPERATIVE = DarkRP.createJob("AI: Senior Operative", {
    color = Color(87, 142, 18),
    model = "models/player/cheddar/chaos_insurgency/chaos_insurgency_soldier.mdl",
    description = [[
        A Senior Operative of the Chaos Insurgency. As an Operative, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "khr_cz858", "cw_makarov", "weapon_cuff_elastic"},
    command = "aisenoperative",
    max = 128,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 70
})

TEAM_AINCO = DarkRP.createJob("AI: NCO", {
    color = Color(87, 142, 18),
    model = "models/player/cheddar/chaos_insurgency/chaos_insurgency_officer.mdl",
    description = [[
        An NCO of the Chaos Insurgency. As an NCO, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "khr_cz858", "cw_makarov", "weapon_cuff_elastic"},
    command = "ainco",
    max = 128,
    salary = 110,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_AIOFFICER = DarkRP.createJob("AI: Officer", {
    color = Color(87, 142, 18),
    model = "models/prototypgaming//mgs4_praying_mantis_merc.mdl",
    description = [[
        An Officer of the Chaos Insurgency. As an Officer, your job is to ensure all Assault Insurgents are operating as they should. Your department is the main force of the Chaos Insurgency. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "khr_ak103", "cw_makarov", "weapon_cuff_elastic", "stungun"},
    command = "aiofficer",
    max = 128,
    salary = 140,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 90
})

TEAM_AICAPTAIN = DarkRP.createJob("AI: Captain", {
    color = Color(87, 142, 18),
    model = "models/tankusci/mgs4_pieuvre_armament_merc.mdl",
    description = [[
        As a Captain, your job is to ensure all Assault Insurgents are operating as they should. Your department is the main force of the Chaos Insurgency.
    ]],
    weapons = {"mvp_perfecthands", "khr_ak103", "cw_makarov", "weapon_cuff_elastic", "stungun"},
    command = "aicaptain",
    max = 2,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 100
})
-- [AI SPECIALTIES]

TEAM_AISNIPER = DarkRP.createJob("AI: Sniper", {
    color = Color(87, 142, 18),
    model = "models/player/cheddar/chaos_insurgency/chaos_insurgency_marksman.mdl",
    description = [[
        A Sniper of the Chaos Insurgency. As a Sniper, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "khr_t5000", "util_binoculars", "cw_makarov", "realistic_hook", "weapon_cuff_elastic"},
    command = "aisniper",
    max = 3,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_AILEADSNIPER = DarkRP.createJob("AI: Lead Sniper", {
    color = Color(87, 142, 18),
    model = "models/player/cheddar/chaos_insurgency/chaos_insurgency_marksman.mdl",
    description = [[
        (The Lead Sniper is ranked higher than all AI Sergeants, but lower than the AI Officers). The Lead Sniper is in-charge of all Assault Insurgent Snipers. As a Sniper, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency.
    ]],
    weapons = {"mvp_perfecthands", "cw_sinon_pgm", "util_binoculars", "cw_makarov", "realistic_hook", "weapon_cuff_elastic"},
    command = "aileadsniper",
    max = 1,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 85
})

TEAM_AIMEDIC = DarkRP.createJob("AI: Medic", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/medic.mdl",
    description = [[
        A Medic of the Chaos Insurgency. As a Medic, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. Prove your worth and you may be promoted.
    ]],
    weapons = {"mvp_perfecthands", "cw_rk62m", "deployable_shield", "fas2_ifak", "weapon_defibrillator", "weapon_cuff_elastic"},
    command = "aimedic",
    max = 6,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

TEAM_AILEADMEDIC = DarkRP.createJob("AI: Lead Medic", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/medic.mdl",
    description = [[
        (The Lead Medic is ranked higher than all AI Sergeants, but lower than the AI Officers). The Lead Medic is in-charge of all Assault Insurgent Medics. As a Medic, your job is to follow orders from your superiors and help your subordinates.
    ]],
    weapons = {"mvp_perfecthands", "cw_rk62m", "deployable_shield", "fas2_ifak", "weapon_defibrillator", "weapon_cuff_elastic"},
    command = "aileadmedic",
    max = 1,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 85
})

TEAM_AIHEAVY = DarkRP.createJob("AI: Heavy", {
    color = Color(87, 142, 18),
    model = "models/player/cheddar/chaos_insurgency/chaos_insurgency_juggernaut.mdl",
    description = [[
        A Heavy of the Chaos Insurgency. As a Heavy, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. 
    ]],
    weapons = {"mvp_perfecthands", "cw_m249_official", "cw_makarov", "weapon_cuff_elastic"},
    command = "aiheavy",
    max = 3,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 575,
    PlayerSpawn = function(ply)
        ply:SetHealth(150)
        ply:SetMaxHealth(150)
        timer.Simple(3, function()
            ply:SetRunSpeed(150)
        end)
    end
})

TEAM_AILEADHEAVY = DarkRP.createJob("AI: Lead Heavy", {
    color = Color(87, 142, 18),
    model = "models/player/cheddar/chaos_insurgency/chaos_insurgency_juggernaut.mdl",
    description = [[
        (The Lead Heavy is ranked higher than all AI Sergeants, but lower than the AI Officers). The Lead Heavy is in-charge of all Assault Insurgent Heavies. As a Heavy, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency.
    ]],
    weapons = {"mvp_perfecthands", "cw_m1919a6", "cw_makarov", "weapon_cuff_elastic"},
    command = "aileadheavy",
    max = 1,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 600,
    PlayerSpawn = function(ply)
        ply:SetHealth(175)
        ply:SetMaxHealth(175)
        timer.Simple(3, function()
            ply:SetRunSpeed(130)
        end)
    end
})

TEAM_AIEXPLO = DarkRP.createJob("AI: Demo Specialist", {
    color = Color(87, 142, 18),
    model = {"models/kyo/dudley_pm.mdl",},
    description = [[
        An Demo Specialist of the Chaos Insurgency. As a Demo Specialist, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency. 
    ]],
    weapons = {"mvp_perfecthands", "cw_pm9", "heavy_shield", "m9k_suicide_bomb", "m9k_ied_detonator", "m9k_sticky_grenade", "m9k_m61_frag", "au_ds_wrench", "weapon_cuff_elastic", "cw_bo1_china_lake"},
    command = "aidemo",
    max = 3,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 80,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            ply:SetRunSpeed(250)
        end)
    end
})

TEAM_AILEADEXPLO = DarkRP.createJob("AI: Lead Demo Specialist", {
    color = Color(87, 142, 18),
    model = {"models/kyo/dudley_pm.mdl",},
    description = [[
        (The Lead Demo Specialist is ranked higher than all AI Sergeants, but lower than the AI Officers). The Lead Demo Specialist is in-charge of all Assault Insurgent Demo Specialist. As a Demo Specialist, your job is to follow orders from your superiors and help your subordinates. Your department is the main force of the Chaos Insurgency.
    ]],
    weapons = {"mvp_perfecthands", "cw_pm9", "heavy_shield", "m9k_suicide_bomb", "m9k_ied_detonator", "m9k_sticky_grenade", "m9k_m61_frag", "au_ds_wrench", "cw_bo1_china_lake"},
    command = "aileaddemo",
    max = 1,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ASSAULT INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "AI",
    isSCP = false,
    noChar = false,
    armorValue = 85,
    PlayerSpawn = function(ply)
        timer.Simple(3, function()
            ply:SetRunSpeed(255)
        end)
    end
})

-- [Research Insurgents]

TEAM_RIINITIATE = DarkRP.createJob("RI: Initiate", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/ci_rnd.mdl",
    description = [[
        As a Research Initiate, your job is to conduct Research... but with a twist. As a member of the Chaos Insurgency, you're able to use weapons and combat! Use your newfound skills to rule the scientific spectrum.
    ]],
    weapons = {"mvp_perfecthands", "cw_mp9_official", "cw_makarov", "weapon_cuff_elastic", "fas2_ifak", "elixir_extractor", "weapon_physcannon"},
    command = "riinitiate",
    max = 128,
    salary = 30,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

TEAM_RIRESEARCHER = DarkRP.createJob("RI: Researcher", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/ci_rnd.mdl",
    description = [[
        As a Researcher, your job is to conduct Research... but with a twist. As a member of the Chaos Insurgency, you're able to use weapons and combat! Use your newfound skills to rule the scientific spectrum.
    ]],
    weapons = {"mvp_perfecthands", "khr_aek971", "cw_makarov", "weapon_cuff_elastic", "fas2_ifak", "elixir_extractor", "weapon_physcannon"},
    command = "riresearcher",
    max = 128,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 60
})

TEAM_RISENRESEARCHER = DarkRP.createJob("RI: Senior Researcher", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/officer.mdl",
    description = [[
        As a Senior Researcher, your job is to conduct Research... but with a twist. As a member of the Chaos Insurgency, you're able to use weapons and combat! Use your newfound skills to rule the scientific spectrum.
    ]],
    weapons = {"mvp_perfecthands", "khr_aek971", "cw_makarov", "weapon_cuff_elastic", "fas2_ifak", "elixir_extractor", "weapon_physcannon"},
    command = "risenresearcher",
    max = 128,
    salary = 110,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 70
})

TEAM_RIOFFICER = DarkRP.createJob("RI: Officer", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/officer.mdl",
    description = [[
        As an Officer of the Research Insurgents, your job is to ensure all Research Insurgents are operating as they should. Help the Lead Research Insurgent with the management of the department. As a member of the Chaos Insurgency, you're able to use weapons and combat! Use your newfound skills to rule the scientific spectrum.
    ]],
    weapons = {"mvp_perfecthands", "khr_aek971", "cw_makarov", "weapon_cuff_elastic", "fas2_ifak", "stungun", "elixir_extractor", "weapon_physcannon"},
    command = "riofficer",
    max = 128,
    salary = 140,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 80
})

-- [RI SPECIALTIES]

TEAM_RIINFILTRATOR = DarkRP.createJob("RI: Infiltrator", {
    color = Color(87, 142, 18),
    model = "models/player/legion/3e_soldier.mdl",
    description = [[
        An Infiltrator! You're one of the most important members of the Research Insurgents. As an Infiltrator, your job is to Infiltrate into the Foundation and gather as much Data for Research as well as sabotage their operations. Good luck!
    ]],
    weapons = {"mvp_perfecthands", "cw_hell_glock", "fas2_ifak", "swep_infiltrator", "cw_extrema_ratio_official", "elixir_extractor", "weapon_cuff_elastic", "weapon_physcannon"},
    command = "riinfilitrator",
    max = 3,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 40
})

TEAM_RILEADINFILTRATOR = DarkRP.createJob("RI: Lead Infiltrator", {
    color = Color(87, 142, 18),
    model = "models/player/legion/3e_soldier.mdl",
    description = [[
        (The Lead Infiltrator is ranked higher than all RI Sergeants, but lower than the RI Officers). The Lead Infiltrator is in-charge of all Research Insurgent Infiltrators. As an Infiltrator, your job is to Infiltrate into the Foundation and gather as much Data for Research as well as sabotage their operations. Good luck!
    ]],
    weapons = {"mvp_perfecthands", "cw_hell_glock", "fas2_ifak", "swep_infiltrator", "cw_extrema_ratio_official", "elixir_extractor", "weapon_cuff_elastic", "weapon_physcannon"},
    command = "rileadinfiltrator",
    max = 1,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 50
})


TEAM_RITHAUMA = DarkRP.createJob("RI: Thaumaturgist", {
    color = Color(87, 142, 18),
    model = {"models/vector_orc_niikfix.mdl",},
    description = [[
        An Infiltrator! You're one of the most important members of the Research Insurgents. As an Infiltrator, your job is to Infiltrate into the Foundation and gather as much Data for Research as well as sabotage their operations. Good luck!
    ]],
    weapons = {"mvp_perfecthands", "cw_hell_glock", "fas2_ifak", "cw_extrema_ratio_official", "elixir_extractor", "weapon_cuff_elastic", "weapon_physcannon"},
    command = "rithaumaturgist",
    max = 3,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 40
})

TEAM_RILEADTHAUMA = DarkRP.createJob("RI: Lead Thaumaturgist", {
    color = Color(87, 142, 18),
    model = "models/player/legion/3e_soldier.mdl",
    description = [[
        (The Lead Infiltrator is ranked higher than all RI Sergeants, but lower than the RI Officers). The Lead Infiltrator is in-charge of all Research Insurgent Infiltrators. As an Infiltrator, your job is to Infiltrate into the Foundation and gather as much Data for Research as well as sabotage their operations. Good luck!
    ]],
    weapons = {"mvp_perfecthands", "cw_hell_glock", "fas2_ifak", "cw_extrema_ratio_official", "elixir_extractor", "weapon_cuff_elastic", "weapon_physcannon"},
    command = "rileadthaumaturgist",
    max = 1,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "RESEARCH INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "RI",
    isSCP = false,
    noChar = false,
    armorValue = 50
})

-- [Spire Insurgents]

TEAM_SIOPERATIVE = DarkRP.createJob("SI: Operative", {
    color = Color(87, 142, 18),
    model = "models/Krueger_PlayerModel/Zaper/Krueger_Body.mdl",
    description = [[
        [//REDACTED - INFORMATION NOT AVAILABLE//]
    ]],
    weapons = {"mvp_perfecthands", "cw_pd2_ak17", "cw_makarov", "weapon_cuff_elastic", "stungun", "heavy_shield", "fas2_ifak", "cw_flash_grenade"},
    command = "sioperative",
    max = 5,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SPIRE INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "SI",
    isSCP = false,
    noChar = false,
    armorValue = 100,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetHealth(150)
    end
})

TEAM_SISENOPERATIVE = DarkRP.createJob("SI: Senior Operative", {
    color = Color(87, 142, 18),
    model = "models/Krueger_PlayerModel/Zaper/Krueger_Body.mdl",
    description = [[
        [//REDACTED - INFORMATION NOT AVAILABLE//]
    ]],
    weapons = {"mvp_perfecthands", "cw_ak12u", "cw_makarov", "weapon_cuff_elastic", "stungun", "heavy_shield", "fas2_ifak", "cw_flash_grenade"},
    command = "sisenoperative",
    max = 4,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SPIRE INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "SI",
    isSCP = false,
    noChar = false,
    armorValue = 100,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetHealth(150)
    end
})

TEAM_SISPECIALIST = DarkRP.createJob("SI: Fireteam Lead", {
    color = Color(87, 142, 18),
    model = "models/Krueger_PlayerModel/Zaper/Krueger_Body.mdl",
    description = [[
        [//REDACTED - INFORMATION NOT AVAILABLE//]
    ]],
    weapons = {"mvp_perfecthands", "cw_ak12u", "cw_makarov", "weapon_cuff_elastic", "stungun", "heavy_shield", "fas2_ifak", "cw_flash_grenade"},
    command = "sispecialist",
    max = 2,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SPIRE INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "SI",
    isSCP = false,
    noChar = false,
    armorValue = 100,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetHealth(150)
    end
})

TEAM_SICAPTAIN = DarkRP.createJob("SI: Captain", {
    color = Color(87, 142, 18),
    model = "models/Krueger_PlayerModel/Zaper/Krueger_Body.mdl",
    description = [[
        [//REDACTED - INFORMATION NOT AVAILABLE//]
    ]],
    weapons = {"mvp_perfecthands", "cw_covertible_ak12", "cw_makarov", "weapon_cuff_elastic", "stungun", "heavy_shield", "fas2_ifak", "cw_flash_grenade"},
    command = "sicaptain",
    max = 1,
    salary = 225,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SPIRE INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "SI",
    isSCP = false,
    noChar = false,
    armorValue = 110,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetHealth(150)
    end
})

TEAM_SIK9 = DarkRP.createJob("SI: K9", {
    color = Color(87, 142, 18),
    model = "models/echo/direwolf_pm.mdl",
    description = [[
        [//REDACTED - INFORMATION NOT AVAILABLE//]
    ]],
    weapons = {"mvp_perfecthands", "swep_k9chaos"},
    command = "sidog",
    max = 3,
    salary = 120,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SPIRE INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "SI",
    isSCP = false,
    noChar = true,
    PlayerSpawn = function(ply)
    	ply:SetHealth(200)
    	ply:SetMaxHealth(200)
        timer.Simple(3, function()
            -- Double running speed
            ply:SetRunSpeed(400)
        end)
    end
})

-- [Command Insurgents]

TEAM_CILEADRESEARCH = DarkRP.createJob("CI: Lead Research Insurgent", {
    color = Color(87, 142, 18),
    model = "models/player/chaos/insurgency/ci_marksman.mdl",
    description = [[
        The Lead Researcher of the Chaos Insurgency. You're in-charge of the Research Insrugents as well as being apart of CI Command. You are the third highest-ranking individual in the Chaos Insurgency behind the Commander and Vice-Commander.
    ]],
    weapons = {"mvp_perfecthands", "cw_covertible_ak12", "cw_makarov", "weapon_cuff_elastic", "fas2_ifak", "stungun", "weapon_physcannon"},
    command = "cileadresearch",
    max = 1,
    salary = 225,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "COMMAND INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "Dr. {LAST}",
    faction = "CHAOS",
    department = "CI",
    isSCP = false,
    noChar = false,
    armorValue = 100
})

TEAM_CISUPERVISOR = DarkRP.createJob("CI: Supervisors", {
    color = Color(87, 142, 18),
    model = "models/grim/isa/isa_sniper.mdl",
    description = [[
        The CI Supervisors are individuals who are ranked higher than all regular Chaos Insurgency Officers, but lower than the Lead Researcher. Your job is to ensure the Chaos Insurgency is operating smoothly while assisting the Commander and Vice-Commander with their duties.
    ]],
    weapons = {"mvp_perfecthands", "cw_covertible_ak12", "cw_makarov", "weapon_cuff_elastic", "stungun"},
    command = "cisupervisors",
    max = 4,
    salary = 160,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "COMMAND INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "CI",
    isSCP = false,
    noChar = false,
    armorValue = 120
})

TEAM_CIVICECOMMANDER = DarkRP.createJob("CI: Vice-Commander", {
    color = Color(87, 142, 18),
    model = "models/player/FalloutNewVegas/ncr/ncr_ranger_playermodel.mdl",
    description = [[
        The CI Vice-Commander is the second-highest ranked individual in the Chaos Insurgency. Your job is to assist the Commander with their duties as well as ensure the Chaos Insurgency is operating smoothly.
    ]],
    weapons = {"mvp_perfecthands", "cw_covertible_ak12", "cw_makarov", "weapon_cuff_elastic", "fas2_ifak", "stungun"},
    command = "civicecommander",
    max = 1,
    salary = 225,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "COMMAND INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "CI",
    isSCP = false,
    noChar = false,
    armorValue = 165
})

TEAM_CICOMMANDER = DarkRP.createJob("CI: Commander", {
    color = Color(87, 142, 18),
    model = {"models/player/m4gm4/mtf/nu7/nu7_commander.mdl",},
    description = [[
        The CI Commander is the highest ranked individual in the Chaos Insurgency. You are in-charge of the on-site operations of the Chaos Insurgency near the site. Your job is to follow orders bestowed upon you by CI High-Command and ensure the Chaos Insurgency is operating smoothly.
    ]],
    weapons = {"mvp_perfecthands", "cw_covertible_ak12", "cw_makarov", "weapon_cuff_elastic", "stungun", "fas2_ifak"},
    command = "cicommander",
    max = 1,
    salary = 300,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "COMMAND INSURGENTS",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "CHAOS",
    department = "CI",
    isSCP = false,
    noChar = false,
    armorValue = 175
})

-- [SCPs]

TEAM_035 = DarkRP.createJob("SCP-035 'The Possessive Mask'", {
    color = Color(123, 122, 125),
    model = "",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-035 is a white porcelain comedy mask, although, at times, it will change to tragedy. In these events, all existing visual records, such as photographs, video footage, even illustrations, of SCP-035 automatically change to reflect its new appearance. A highly corrosive and degenerative viscous liquid constantly seeps from the eye and mouth holes of SCP-035. Anything coming into contact with this substance slowly decays over a period of time, depending on the material, until it has decayed completely into a pool of the original contaminant. Glass seems to react the slowest to the effects of the item, hence the construction choice of its immediate container. Living organisms that come into contact with the substance react much the same way, with no chance of recovery. Origin is unknown, but recovered in Venice, 18██.
    ]],
    weapons = {},
    command = "scp035",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true
})

TEAM_049 = DarkRP.createJob("SCP-049 'The Plague Doctor'", {
    color = Color(123, 122, 125),
    model = "models/vinrax/player/Scp049_player.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-049 is humanoid in appearance, standing at 1.9 m tall and weighing 95.3 kg; however, the Foundation is currently incapable of studying its face and body more fully, as it is covered in what appears to be the garb of the traditional "Plague Doctor" from 15-16th century Europe. This material is actually a part of SCP-049's body, as microscopic and genetic testing show it to be similar in structure to muscle, although it feels much like rough leather, and the mask much like ceramic. It was found in ██████, France, by local police. It was responding to an outbreak of a pestilence, SCP-049 was discovered and detained by Foundation operatives, and has since been contained.
    ]],
    weapons = {"mvp_perfecthands", "scp_049_scp"},
    command = "scp049",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    SCPClass = "euclid",
    PlayerSpawn = function(ply)
        ply:SetHealth(10000)
    end
})

TEAM_076 = DarkRP.createJob("SCP-076-2 'Able'", {
    color = Color(123, 122, 125),
    model = "models/player/076/scp/able.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-076-2 is a 3 m cube made of black speckled metamorphic stone. All surfaces outside and within SCP-076-2 are covered in deeply engraved patterns corresponding to no known civilizations. Radioisotope analysis indicates that the object is approximately ten thousand (10,000) years old. A door is located on one side, sealed with a lock 0.5 m in width, surrounded by forty-eight (48) smaller locks in a 6 by 8 grid. All attempts so far to open the door have failed, regardless of the applied force, including the use of SCP-███. SCP-076-2 is sentient and mobile. Though it lacks any visible sensory organs, it is able to perceive its environment clearly and navigate without difficulty. It is capable of vocalizations, though it does not appear to have a physical vocal apparatus. Subject has also been observed moving its mouth while "speaking", suggesting it is attempting to mimic human speech.
    ]],
    weapons = {"weapon_katana"},
    command = "scp076",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(4000)
        -- double speed
        ply:SetRunSpeed(500)
    end
})
 
TEAM_096 = DarkRP.createJob("SCP-096 'The Shy Guy'", {
    color = Color(123, 122, 125),
    model = "models/player/scp096.mdl", -- NEW MODEL Dont switch has no Head Bone to mount face entity "models/player/scp096.mdl""models/scp096anim/player/scp096pm_raf.mdl"
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-096 is a humanoid creature measuring approximately 2.38 meters in height. Subject shows very little muscle mass, with preliminary analysis of body mass suggesting mild malnutrition. Arms are grossly out of proportion with the rest of the subject's body, with an approximate length of 1.5 meters each. Skin is mostly devoid of pigmentation, with no sign of any body hair. SCP-096's jaw can open to four (4) times the norm of an average human. Other facial features remain similar to an average human, with the exception of the eyes, which are also devoid of pigmentation. It is not yet known whether SCP-096 is blind or not. It shows no signs of any higher brain functions, and is not considered to be sapient.
    ]],
    weapons = {"au_scp096_swep"},
    command = "scp096",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    SCPClass = "euclid",
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)

        local weaponClass = "au_scp096_swep"
        if not ply:HasWeapon(weaponClass) then
            ply:Give(weaponClass)
        end
        ply:SelectWeapon(weaponClass) 
    end
})

TEAM_106 = DarkRP.createJob("SCP-106 'The Old Man'", {
    color = Color(123, 122, 125),
    model = "models/scp_106/scp_106_model.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-106 appears to be an elderly humanoid, with a general appearance of advanced decomposition. This appearance may vary, but the "rotting" quality is observed in all forms. SCP-106 is not exceptionally agile, and will remain motionless for days at a time, waiting for prey. When attacking, SCP-106 will attempt to incapacitate prey by damaging major organs, muscle groups, or tendons, then pull disabled prey into its pocket dimension.
    ]],
    weapons = {"atlas_scp_106"},
    command = "scp106",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    SCPClass = "keter",
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_131A = DarkRP.createJob("SCP-131-A 'Eye Pods'", {
    color = Color(123, 122, 125),
    model = "models/thenextscp/scp131/scp131.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-131-A is a series of 2 Eye-Pods. This SCP resembles a large eye, and can move at substantial speeds. 
    ]],
    weapons = {},
    command = "scp131a",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
        timer.Simple(3, function()
            -- Run Speed
            ply:SetRunSpeed(1000)
        end)
    end
})

TEAM_131B = DarkRP.createJob("SCP-131-B 'Eye Pods'", {
    color = Color(123, 122, 125),
    model = "models/thenextscp/scp131/scp131.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-131-B is a series of 2 Eye-Pods. This SCP resembles a large eye, and can move at substantial speeds. 
    ]],
    weapons = {},
    command = "scp131b",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
        timer.Simple(3, function()
            -- Run Speed
            ply:SetRunSpeed(1000)
        end)
    end
})

TEAM_343 = DarkRP.createJob("SCP-343 'God'", {
    color = Color(123, 122, 125),
    model = "models/player/gow3_zeus.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-343 is a creature resembling the stature of a human. This SCP claims to be God, while remaining passive and friendly. This SCP has rarely intervened and will generally observe and analyse. 
    ]],
    weapons = {"mvp_perfecthands", "sonido_swep","biblefunny"},
    command = "scp343",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_397 = DarkRP.createJob("SCP-397 'Lola'", {
    color = Color(123, 122, 125),
    model = "models/player/chimp/chimp.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-397 is female chimpanzee with a height of 1.2 meters. This SCP is capable of speech and is highly intelligent. This SCP is capable of using weapons and is extremely dangerous if given the opportunity. 
    ]],
    weapons = {"mvp_perfecthands", "weapon_fists"},
    command = "scp397",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(500)
        ply:SetMaxHealth(500)
        timer.Simple(3, function()
            -- Run Speed
            ply:SetRunSpeed(250)
            ply:SetArmor(500)
        end)
    end
})

TEAM_457 = DarkRP.createJob("SCP-457 'The Burning Man'", {
    color = Color(123, 122, 125),
    model = "models/cultist/scp/scp_457.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-457 is a sentient being composed of fire. This SCP is capable of moving at high speeds and is extremely dangerous. This SCP is capable of setting fire to anything it touches.
    ]],
    weapons = {"swep-457"},
    command = "scp457",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    SCPClass = "euclid",
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_553ATL = DarkRP.createJob("SCP-553-ATL 'The Friendly Giant'", {
    color = Color(123, 122, 125),
    model = "models/dawson/obese_male_deluxe_edition/obese_male_gregory_01.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-553-ATL (Atlas Series SCPs) is a Custom SCP created by the Atlas Uprising Community. This SCP is a big boned humanoid weilding a bat. Don't anger him, otherwise he might knock you to the next site!
    ]],
    weapons = {"mvp_perfecthands", "weapon_nessbat(normal)"},
    command = "scp553",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_662 = DarkRP.createJob("SCP-662-A 'Mr. Deeds'", {
    color = Color(123, 122, 125),
    model = "models/player/valley/pennyworth.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] Ring the Bell and he shall respond!
    ]],
    weapons = {"mvp_perfecthands", "scp_662"},
    command = "scp662",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    nameFormat = "{BRANCH} {RANK} {FIRST} {LAST}",
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(200)
    end
})

TEAM_682 = DarkRP.createJob("SCP-682 'Hard-To-Destroy Reptile'", {
    color = Color(123, 122, 125),
    model = "models/veeds/scp/682.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-682 is a large, vaguely reptile-like creature of unknown origin. It appears to be extremely intelligent, and was observed to engage in complex communication with SCP-079 during their limited time of exposure. SCP-682 appears to have a hatred of all life, which has been expressed in several interviews during containment. 
    ]],
    weapons = {"fv_scp682"},
    command = "scp682",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    SCPClass = "keter",
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_912 = DarkRP.createJob("SCP-912 'Autonomous Suit'", {
    color = Color(123, 122, 125),
    model = "models/titanfall2_playermodel/kanePM.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-912 is an autonomous suit. This SCP does not have any interior, and is capable of moving on its own. When assigned a handler, this SCP will follow their orders and protect them at all costs.
    ]],
    weapons = {"mvp_perfecthands", "weapon_stunstick", "weapon_cuff_elastic", "stungun"},
    command = "scp912",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_939 = DarkRP.createJob("SCP-939 'With Many Voices'", {
    color = Color(123, 122, 125),
    model = "models/939/939.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-939 are endothermic, pack-based predators which display atrophy of various systems similar to troglobitic organisms. The skins of SCP-939 are highly permeable to moisture and translucent red, owing to a compound chemically similar to hemoglobin. SCP-939 average 2.2 meters tall standing upright and weigh an average of 250 kg, though weight is highly variable. Each of their four limbs terminates in three-fingered claws with a fourth, opposable digit, and all are covered in setae which considerably augment climbing ability. Their heads are elongated, devoid of even vestigial eyes or eye sockets, and contain no brain casing. The jaws of SCP-939 are lined with red, faintly luminescent fang-like teeth, similar to those belonging to specimens of the genus Chauliodus, up to 6 cm in length, and encircled by heat-sensitive pit organs.
    ]],
    weapons = {"weapon_scp939"},
    command = "scp939",
    max = 4,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    SCPClass = "euclid",
    PlayerSpawn = function(ply)
        ply:SetHealth(5000)
        timer.Simple(3, function()
            -- Run Speed
            ply:SetRunSpeed(1000)
        end)
    end
})

TEAM_966 = DarkRP.createJob("SCP-966 'Sleep Killer'", {
    color = Color(123, 122, 125),
    model = "models/player/mishka/966_new.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-966 are predatory creatures that resemble hairless, digitigrade humans, possessing an elongated face with a mouth lined with needle-like teeth. SCP-966 are visible only at wavelengths ranging from 700nm to about 900nm, with their exact location only being revealed when any part of their body intersects with a surface. SCP-966 are capable of basic speech in any language, though they rarely do so. SCP-966 are capable of moving at high speeds and will attempt to kill any human beings they encounter. SCP-966 are capable of emitting a previously unknown type of wave, designated as "966-1", which suppresses the occipital lobe of the brain, causing irreversible coma in humans. SCP-966-1 is only detectable at frequencies below 40Hz.
    ]],
    weapons = {"au_966_rw"},
    command = "scp966",
    max = 5,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(2000)
    end
})

TEAM_999 = DarkRP.createJob("SCP-999 'The Tickle Monster'", {
    color = Color(123, 122, 125),
    model = "models/scp/999/jq/scp_999_pmjq.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-999 is a small orange slime ball. It can tickle :)
    ]],
    weapons = {"weapon_scp999"},
    command = "scp999",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_1048 = DarkRP.createJob("SCP-1048 'The Builder Bear'", {
    color = Color(123, 122, 125),
    model = "models/1048/tdy/tdybrownpm.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-1048 is a small teddy bear, approximately 33 cm in height. Through testing, composition of the subject revealed no unusual qualities that make it discernible from a non-sapient teddy bear. Subject is capable of moving of its own accord, and can communicate through a small range of gestures.!
    ]],
    weapons = {"weapon_scp1048","m9k_knife"},
    command = "scp1048",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    nameFormat = "SCP-1048 'The Builder Bear'",
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999)
    end
})

TEAM_1048A = DarkRP.createJob("SCP-1048-A 'Ear Bear'", {
    color = Color(123, 122, 125),
    model = "models/1048/tdyear/tdybrownearpm.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] A teddy bear similar in size and shape to SCP-1048, but is made entirely out of human ears which can emit a high-pitched shriek that inflicted intense pain in the eyes and ears.
    ]],
    weapons = {"weapon_scp1048_a"},
    command = "scp1048acom",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    nameFormat = "SCP-1048-A 'Ear Bear'",
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
})

TEAM_4000ATL = DarkRP.createJob("SCP-4000-ATL 'Joseph'", {
    color = Color(123, 122, 125),
    model = "models/player/cheddar/class_d/class_d_eric.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-4000-ATL (Atlas Series SCPs) is a Custom SCP created by the Atlas Uprising Community. This SCP is a humanoid dressed like a D-Class. This SCP is capable of transforming into a werewolf when angered.
    ]],
    weapons = {"mvp_perfecthands", "eoti_werewolf_swep"},
    command = "scp4000atl",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(2000)
        ply:SetMaxHealth(2000)
    end
})

TEAM_4793 = DarkRP.createJob("SCP-4793 'Androceles'", {
    color = Color(123, 122, 125),
    model = "models/vitallion_pm/vitallion_pm.mdl", --https://steamcommunity.com/sharedfiles/filedetails/?id=1138976247
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] A 1.92m tall human of Greek origin with accelerated healing due to heightened cellular reproduction, used to combat the Chaos Insurgency and assist U-11 operations.
    ]],
    weapons = {"mvp_perfecthands", "scp4793"},
    command = "scp4793",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    nameFormat = "SCP-",
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
	PlayerSpawn = function(ply)
        timer.Simple(3, function()
            -- Run Speed
            ply:SetRunSpeed(250) 
        end)
		ply:SetHealth(2500)
        ply:SetMaxHealth(2500)
	end
})

-- [CI SCPs]

TEAM_774A = DarkRP.createJob("SCP-774-ATL-2 'Aegis'", {
    color = Color(123, 122, 125),
    model = "models/player/stanmcg/blockhead_bot/blockhead_bot_playermodel.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-774-ATL-2 (Atlas Series SCPs) is a Custom SCP created by the Atlas Uprising Community. This SCP is a medium-sized block of aluminum and has the capabilities to create sentient entities designated as SCP-774-1-ATL. These SCPs are Robot-Like entities with the capabilities of creating a shield when ordered to. This SCP is willingly co-operating with the CI. The reason for this co-operation is not yet known, not even to the CI.
    ]],
    weapons = {"au_shield"},
    command = "scp774a",
    max = 3,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_774B = DarkRP.createJob("SCP-774-ATL-3 'Stygius'", {
    color = Color(123, 122, 125),
    model = "models/player/bot_sportA/bot_t.mdl",
            "models/player/bot_sportB/bot_t.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-774-ATL-3 (Atlas Series SCPs) is a Custom SCP created by the Atlas Uprising Community. This SCP is willingly co-operating with the CI. The reason for this co-operation is not yet known, not even to the CI.
    ]],
    weapons = {"cw_m1918a2"},
    command = "scp774b",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(99999999)
    end
})

TEAM_947ATL = DarkRP.createJob("SCP-947-ATL '1-Inch Warrior'", {
    color = Color(123, 122, 125),
    model = "models/player/n7legion/advanced_suit_elite.mdl",
    description = [[
        [APPLY ON THE FORUMS OR PURCHASE ON OUR STORE TO ACCESS] SCP-947-ATL (Atlas Series SCPs) is a Custom SCP created by the Atlas Uprising Community. This entity is "wearing" a suit that can make it shrink to 1 inch. In reality, tests show that the suit is relatively hollow and the entity is actually a 1 inch tall individual in the center of the suit. This SCP was designed with our haters in-mind, as it resembles them the most.
    ]],
    weapons = {"mvp_perfecthands", "minimize", "cw_extrema_ratio_official"},
    command = "scp947atl",
    max = 1,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
    	ply:SetHealth(200)
        timer.Simple(3, function()
            -- Double running speed
            ply:SetRunSpeed(350)
        end)
    end
})

-- [Citizen Jobs]

TEAM_CITIZEN = DarkRP.createJob("Town Citizen", {
    color = Color(188, 229, 189),
    model = {"models/player/zelpa/female_01.mdl",
            "models/player/zelpa/female_01_b.mdl",
            "models/player/zelpa/female_02.mdl",
            "models/player/zelpa/female_02_b.mdl",
            "models/player/zelpa/female_03.mdl",
            "models/player/zelpa/female_03_b.mdl",
            "models/player/zelpa/female_04.mdl",
            "models/player/zelpa/female_04_b.mdl",
            "models/player/zelpa/female_06.mdl",
            "models/player/zelpa/female_06_b.mdl",
            "models/player/zelpa/female_07.mdl",
            "models/player/zelpa/female_07_b.mdl",
            "models/player/zelpa/male_01.mdl",
            "models/player/zelpa/male_02.mdl",
            "models/player/zelpa/male_03.mdl",
            "models/player/zelpa/male_04.mdl",
            "models/player/zelpa/male_05.mdl",
            "models/player/zelpa/male_06.mdl",
            "models/player/zelpa/male_07.mdl",
            "models/player/zelpa/male_08.mdl",
            "models/player/zelpa/male_09.mdl",
            "models/player/zelpa/male_10.mdl",
            "models/player/zelpa/male_11.mdl",},
    description = [[
        A Town Citizen of Rockford Michigan. Live a luxurious and comfortable life in the wonderful and calming town!
    ]],
    weapons = {"mvp_perfecthands", "weapon_physgun"},
    command = "towncitizen",
    max = 128,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CITIZENS",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "CIVILIAN",
    department = "CIV",
    isSCP = false,
    noChar = false
})

TEAM_CRIMINAL = DarkRP.createJob("MC&D", {
    color = Color(188, 229, 189),
    model = {"models/player/suits/male_01_closed_coat_tie.mdl",
            "models/player/suits/male_01_closed_tie.mdl",
            "models/player/suits/male_01_open.mdl",
            "models/player/suits/male_01_open_tie.mdl",
            "models/player/suits/male_01_open_waistcoat.mdl",
            "models/player/suits/male_01_shirt.mdl",
            "models/player/suits/male_01_shirt_tie.mdl",
            "models/player/suits/male_02_closed_coat_tie.mdl",
            "models/player/suits/male_02_closed_tie.mdl",
            "models/player/suits/male_02_open.mdl",
            "models/player/suits/male_02_open_tie.mdl",
            "models/player/suits/male_02_open_waistcoat.mdl",
            "models/player/suits/male_02_shirt.mdl",
            "models/player/suits/male_02_shirt_tie.mdl",
            "models/player/suits/male_03_closed_coat_tie.mdl",
            "models/player/suits/male_03_closed_tie.mdl",
            "models/player/suits/male_03_open.mdl",
            "models/player/suits/male_03_open_tie.mdl",
            "models/player/suits/male_03_open_waistcoat.mdl",
            "models/player/suits/male_03_shirt.mdl",
            "models/player/suits/male_03_shirt_tie.mdl",
            "models/player/suits/male_04_closed_coat_tie.mdl",
            "models/player/suits/male_04_closed_tie.mdl",
            "models/player/suits/male_04_open.mdl",
            "models/player/suits/male_04_open_tie.mdl",
            "models/player/suits/male_04_open_waistcoat.mdl",
            "models/player/suits/male_04_shirt.mdl",
            "models/player/suits/male_04_shirt_tie.mdl",
            "models/player/suits/male_05_closed_coat_tie.mdl",
            "models/player/suits/male_05_closed_tie.mdl",
            "models/player/suits/male_05_open.mdl",
            "models/player/suits/male_05_open_tie.mdl",
            "models/player/suits/male_05_open_waistcoat.mdl",
            "models/player/suits/male_05_shirt_tie.mdl",
            "models/player/suits/male_06_closed_coat_tie.mdl",
            "models/player/suits/male_06_closed_tie.mdl",
            "models/player/suits/male_06_open.mdl",
            "models/player/suits/male_06_open_tie.mdl",
            "models/player/suits/male_06_open_waistcoat.mdl",
            "models/player/suits/male_06_shirt.mdl",
            "models/player/suits/male_06_shirt_tie.mdl",
            "models/player/suits/male_07_closed_coat_tie.mdl",
            "models/player/suits/male_07_closed_tie.mdl",
            "models/player/suits/male_07_open.mdl",
            "models/player/suits/male_07_open_tie.mdl",
            "models/player/suits/male_07_open_waistcoat.mdl",
            "models/player/suits/male_07_shirt.mdl",
            "models/player/suits/male_07_shirt_tie.mdl",
            "models/player/suits/male_08_closed_coat_tie.mdl",
            "models/player/suits/male_08_closed_tie.mdl",
            "models/player/suits/male_08_open.mdl",
            "models/player/suits/male_08_open_tie.mdl",
            "models/player/suits/male_08_open_waistcoat.mdl",
            "models/player/suits/male_08_shirt.mdl",
            "models/player/suits/male_08_shirt_tie.mdl",
            "models/player/suits/male_09_closed_coat_tie.mdl",
            "models/player/suits/male_09_closed_tie.mdl",
            "models/player/suits/male_09_open.mdl",
            "models/player/suits/male_09_open_tie.mdl",
            "models/player/suits/male_09_open_waistcoat.mdl",
            "models/player/suits/male_09_shirt.mdl",
            "models/player/suits/male_09_shirt_tie.mdl",
            "models/player/suits/robber_open.mdl",
            "models/player/suits/robber_shirt.mdl",
            "models/player/suits/robber_shirt_2.mdl",
            "models/player/suits/robber_tie.mdl",
            "models/player/suits/robber_tuckedtie.mdl",},
    description = [[
        Marshall, Carter & Dark. You peddle special wares that no one else can. [Access through the Civilian Pack on our Store]
    ]],
    weapons = {"mvp_perfecthands", "cw_extrema_ratio_official", "weapon_physgun"},
    command = "mcd",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CITIZENS",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "CIVILIAN",
    department = "CIV",
    isSCP = false,
    noChar = false
})

TEAM_MAYOR = DarkRP.createJob("Mayor", {
    color = Color(188, 229, 189),
    model = "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",
            "models/player/breen.mdl",
            "models/player/mossman_arctic.mdl",
    description = [[
        The Mayor. Your whole life working up to lead the City of Cairo, gone in a matter of days... You have no where else to go. Hold onto your city, no matter the cost.
    ]],
    weapons = {"mvp_perfecthands", "weapon_physgun"},
    command = "mayor",
    max = 1,
    salary = 200,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CITIZENS",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "CIVILIAN",
    department = "CIV",
    isSCP = false,
    noChar = false,
    armorValue = 50,
    mayor = true
})

-- [Server Jobs]

TEAM_CHOOSING = DarkRP.createJob("Choosing...", {
    color = Color(255, 255, 255),
    model = "models/player/skeleton.mdl",
    description = [[
        The Initial Choosing Job... Please flag off onto another job, thank you!
    ]],
    weapons = {"mvp_perfecthands", },
    command = "choosing",
    max = 128,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Choosing...",
    canDemote = false,
    -- Variables below
    --[[nameFormat = "{FIRST} {LAST}",
    faction = "",
    department = "",]]
    isSCP = false,
    noChar = true
})

TEAM_STAFF = DarkRP.createJob("Staff", {
    color = Color(255, 255, 255),
    model = "models/player/combine_super_soldier.mdl",
    description = [[
        [APPLY FOR STAFF ON THE FORUMS]
    ]],
    weapons = {"mvp_perfecthands", "weapon_physgun", "gmod_tool"},
    command = "staff",
    max = 128,
    salary = 500,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "STAFF",
    department = "STAFF",
    isSCP = false,
    noChar = true
})

// ADD EXTRA JOBS BELOW!

TEAM_SITEEMP = DarkRP.createJob("Site Employee", {
    color = Color(94, 191, 255),
    model = {"models/nostras/employee/male_01_employee.mdl",
            "models/nostras/employee/male_02_employee.mdl",
            "models/nostras/employee/male_04_employee.mdl",
            "models/nostras/employee/male_07_employee.mdl",
            "models/nostras/employee/male_08_employee.mdl",
            "models/nostras/employee/male_09_employee.mdl",
            "models/kaesar/suits1/female_01.mdl",
            "models/kaesar/suits1/female_02.mdl",
            "models/kaesar/suits1/female_03.mdl",
            "models/kaesar/suits1/female_04.mdl",
            "models/kaesar/suits1/female_05.mdl",
            "models/kaesar/suits1/female_06.mdl",},
    description = [[
        A Site Employee can be a Lawyer, Accountant, or do any Job that might require a non-combative individual. This Job can be hired by departments. Purely RP-Based Job. 
    ]],
    weapons = {"mvp_perfecthands", },
    command = "siteemp",
    max = 20,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SITE STAFF",
    canDemote = false,
    -- Variables below
    nameFormat = "Employee {FIRST} {LAST}",
    faction = "FOUNDATION",
    department = "SITE STAFF",
    isSCP = false,
    noChar = false
})

TEAM_POLICEOFFICER = DarkRP.createJob("Secret Service", {
    color = Color(188, 229, 189),
    model = "models/dannio/secretservice/secretservice.mdl",
    description = [[
        As a Secret Service, your job is to protect the Mayor.
    ]],
    weapons = {"mvp_perfecthands", "stungun", "weapon_rpt_handcuff", "cw_noobveske_diplomat", "weapon_physgun"},
    command = "secretservice",
    max = 16,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CITIZENS",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "CIVILIAN",
    department = "CIV",
    isSCP = false,
    noChar = false,
    PlayerSpawn = function(ply)
        ply:SetHealth(150)
        ply:SetMaxHealth(150)
    end
})

TEAM_SWAT = DarkRP.createJob("Secret Service Lead", {
    color = Color(188, 229, 189),
    model = "models/dannio/secretservice/secretservice.mdl",
    description = [[
        Lead the Secret Service and protect the mayor. Keep the Secret Service un-biased against all parties. Your main goal is to protect the mayor no matter what.
    ]],
    weapons = {"mvp_perfecthands", "stungun", "weapon_rpt_handcuff", "cw_noobveske_diplomat", "deployable_shield", "weapon_physgun"},
    command = "ssl",
    max = 1,
    salary = 110,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CITIZENS",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "CIVILIAN",
    department = "CIV",
    isSCP = false,
    noChar = false,
    PlayerSpawn = function(ply)
        ply:SetHealth(200)
        ply:SetMaxHealth(200)
    end
})

-- HOBO JOB FOR SIMPLE TRASH
TEAM_HOBO = DarkRP.createJob("Hobo", {
    color = Color(188, 229, 189),
    model = {"models/drem/cch/female_01.mdl",
            "models/drem/cch/female_02.mdl",
            "models/drem/cch/female_03.mdl",
            "models/drem/cch/female_04.mdl",
            "models/drem/cch/female_05.mdl",
            "models/drem/cch/female_06.mdl",
            "models/drem/cch/male_01.mdl",
            "models/drem/cch/male_02.mdl",
            "models/drem/cch/male_03.mdl",
            "models/drem/cch/male_04.mdl",
            "models/drem/cch/male_05.mdl",
            "models/drem/cch/male_06.mdl",
            "models/drem/cch/male_07.mdl",
            "models/drem/cch/male_08.mdl",
            "models/drem/cch/male_09.mdl",},
    description = [[
        Hobo - Woah, this- this is a new low.
    ]],
    weapons = {"mvp_perfecthands", "weapon_physgun"},
    command = "hobo",
    max = 4,
    salary = 25,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CITIZENS",
    canDemote = false,
    -- Variables below
    nameFormat = "{FIRST} {LAST}",
    faction = "CIVILIAN",
    department = "CIV",
    isSCP = false,
    noChar = false
})

TEAM_2282 = DarkRP.createJob("SCP-2282 'Capra Aegagrus Hircus'", {
    color = Color(123, 122, 125),
    model = "models/goatplayer/goat_player.mdl",
    description = [[
        SCP-2282 is a small goat.
    ]],
    weapons = {"weapon_keycard_level2", "weapon_goat"},
    command = "scp2282",
    max = 4,
    salary = 180,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "SCP",
    canDemote = false,
    -- Variables below
    faction = "SCP",
    department = "SCP",
    isSCP = true,
    noChar = true,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
    end
})
-- --[[---------------------------------------------------------------------------
-- Define which team joining players spawn into and what team you change to if demoted
-- ---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CHOOSING
-- --[[---------------------------------------------------------------------------
-- Define which teams belong to civil protection
-- Civil protection can set warrants, make people wanted and do some other police related things
-- ---------------------------------------------------------------------------]]

-- --[[---------------------------------------------------------------------------
-- Jobs that are hitmen (enables the hitman menu)
-- ---------------------------------------------------------------------------]]
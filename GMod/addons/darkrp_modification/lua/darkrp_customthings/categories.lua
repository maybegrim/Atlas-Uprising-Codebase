--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
https://darkrp.miraheze.org/wiki/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]
DarkRP.createCategory {
    name = "D-Class",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255, 145, 0),
    sortOrder = 1,
}

DarkRP.createCategory {
    name = "Initial Security Team",
    categorises = "jobs",
    startExpanded = true,
    color = Color(116, 178, 248),
    sortOrder = 5,
}

DarkRP.createCategory {
    name = "GENSEC",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 13, 255),
    sortOrder = 15,
}

DarkRP.createCategory {
    name = "NINE-TAILED FOX",
    categorises = "jobs",
    startExpanded = true,
    color = Color(112, 80, 32),
    sortOrder = 20,
}

DarkRP.createCategory {
    name = "Upsilon-11",
    categorises = "jobs",
    startExpanded = true,
    color = Color(179, 0, 255),
    sortOrder = 25,
}

DarkRP.createCategory {
    name = "XI-13",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255, 238, 0),
    sortOrder = 25,
}

DarkRP.createCategory {
    name = "RED RIGHT HAND",
    categorises = "jobs",
    startExpanded = true,
    color = Color(239, 27, 27),
    sortOrder = 30,
}

DarkRP.createCategory {
    name = "RESEARCH AGENCY",
    categorises = "jobs",
    startExpanded = true,
    color = Color(246, 255, 0),
    sortOrder = 35,
}

DarkRP.createCategory {
    name = "RESEARCH AGENCY EX",
    categorises = "jobs",
    startExpanded = true,
    color = Color(246, 255, 0),
    sortOrder = 40,
}

DarkRP.createCategory {
    name = "MEDICAL STAFF",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255, 118, 118),
    sortOrder = 45,
}

DarkRP.createCategory {
    name = "MEDICAL STAFF EX",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255, 118, 118),
    sortOrder = 50,
}

DarkRP.createCategory {
    name = "SITE STAFF",
    categorises = "jobs",
    startExpanded = true,
    color = Color(94, 191, 255),
    sortOrder = 9,
}

DarkRP.createCategory {
    name = "SITE COMMAND",
    categorises = "jobs",
    startExpanded = true,
    color = Color(45, 3, 3),
    sortOrder = 10,
}

DarkRP.createCategory {
    name = "ASSAULT INSURGENTS",
    categorises = "jobs",
    startExpanded = true,
    color = Color(87, 142, 18),
    sortOrder = 11,
}

DarkRP.createCategory {
    name = "RESEARCH INSURGENTS",
    categorises = "jobs",
    startExpanded = true,
    color = Color(87, 142, 18),
    sortOrder = 12,
}

DarkRP.createCategory {
    name = "SPIRE INSURGENTS",
    categorises = "jobs",
    startExpanded = true,
    color = Color(87, 142, 18),
    sortOrder = 13,
}

DarkRP.createCategory {
    name = "COMMAND INSURGENTS",
    categorises = "jobs",
    startExpanded = true,
    color = Color(87, 142, 18),
    sortOrder = 14,
}

DarkRP.createCategory {
    name = "SCP",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 0),
    sortOrder = 15,
}

DarkRP.createCategory {
    name = "CITIZENS",
    categorises = "jobs",
    startExpanded = true,
    color = Color(188, 229, 189),
    sortOrder = 16,
}

DarkRP.createCategory {
    name = "Choosing...",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255, 255, 255),
    sortOrder = 17,
}

DarkRP.createCategory {
    name = "STAFF",
    categorises = "jobs",
    startExpanded = true,
    color = Color(255, 255, 255),
    sortOrder = 18,
}



-- [WEAPON CATEGORIES]
DarkRP.createCategory {
    name = "Pistols",
    categorises = "weapons",
    startExpanded = true,
    color = Color(255, 0, 0), -- Red
    sortOrder = 10,
    canSee = function(ply)
        if ply:IsSuperAdmin() then return true end
        return table.HasValue({TEAM_GUNDLR, TEAM_CRIMINAL, TEAM_TOWNDOCTOR, TEAM_STAFF}, ply:Team())
    end,
}

DarkRP.createCategory {
    name = "Shotguns",
    categorises = "weapons",
    startExpanded = true,
    color = Color(0, 255, 0), -- Green
    sortOrder = 20,
    canSee = function(ply)
        if ply:IsSuperAdmin() then return true end
        return table.HasValue({TEAM_GUNDLR, TEAM_CRIMINAL, TEAM_TOWNDOCTOR, TEAM_STAFF}, ply:Team())
    end,
}

DarkRP.createCategory {
    name = "Submachine Guns",
    categorises = "weapons",
    startExpanded = true,
    color = Color(0, 0, 255), -- Blue
    sortOrder = 30,
    canSee = function(ply)
        if ply:IsSuperAdmin() then return true end
        return table.HasValue({TEAM_GUNDLR, TEAM_CRIMINAL, TEAM_TOWNDOCTOR, TEAM_STAFF}, ply:Team())
    end,
}

DarkRP.createCategory {
    name = "Rifles",
    categorises = "weapons",
    startExpanded = true,
    color = Color(255, 255, 0), -- Yellow
    sortOrder = 40,
    canSee = function(ply)
        if ply:IsSuperAdmin() then return true end
        return table.HasValue({TEAM_GUNDLR, TEAM_CRIMINAL, TEAM_TOWNDOCTOR, TEAM_STAFF}, ply:Team())
    end,
}

-- [ENTITY CATEGORIES]
DarkRP.createCategory {
    name = "Gun Dealer",
    categorises = "entities",
    startExpanded = true,
    color = Color(219, 103, 41),
    sortOrder = 10,
    canSee = function(ply) 
         return table.HasValue({TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_CRIMINAL,
        TEAM_TOWNDOCTOR}, ply:Team()) 
    end,
}

DarkRP.createCategory {
    name = "Heist Gear",
    categorises = "entities",
    startExpanded = true,
    color = Color(47, 136, 215),
    sortOrder = 11,
    canSee = function(ply)
         return table.HasValue({TEAM_CRIMINAL, TEAM_STAFF}, ply:Team()) 
    end,
}

DarkRP.createCategory {
    name = "Meth Equipment",
    categorises = "entities",
    startExpanded = true,
    color = Color(41, 219, 83),
    sortOrder = 12,
    canSee = function(ply)
         return table.HasValue({TEAM_AIINITIATE,
        TEAM_AIOPERATIVE,
        TEAM_AISENOPERATIVE,
        TEAM_AINCO,
        TEAM_AIOFFICER,
        TEAM_AISNIPER,
        TEAM_AILEADSNIPER,
        TEAM_AIMEDIC,
        TEAM_AILEADMEDIC,
        TEAM_AIHEAVY,
        TEAM_AILEADHEAVY,
        TEAM_AIEXPLO,
        TEAM_AILEADEXPLO,
        TEAM_RIINITIATE,
        TEAM_RIRESEARCHER,
        TEAM_RISENRESEARCHER,
        TEAM_RIOFFICER,
        TEAM_RIINFILTRATOR,
        TEAM_RILEADINFILTRATOR,
        TEAM_SIOPERATIVE,
        TEAM_SISENOPERATIVE,
        TEAM_SISPECIALIST,
        TEAM_SICAPTAIN,
        TEAM_SIK9,
        TEAM_CILEADRESEARCH,
        TEAM_CISUPERVISOR,
        TEAM_CIVICECOMMANDER,
        TEAM_CICOMMANDER,
        TEAM_CITIZEN,
        TEAM_CRIMINAL,
        TEAM_TOWNDOCTOR,
        TEAM_MAYOR,
        TEAM_AIBREACH,
        TEAM_AIBREACHLEAD,
        TEAM_I10FBITRN,
        TEAM_I10FBIOP,
        TEAM_I10FBILD,
        TEAM_EXPCIVI,
        TEAM_RETROCIVI,
        TEAM_STAFF,}, ply:Team()) 
    end,
}

DarkRP.createCategory {
    name = "Meth Materials",
    categorises = "entities",
    startExpanded = true,
    color = Color(41, 219, 83),
    sortOrder = 13,
    canSee = function(ply)
         return table.HasValue({TEAM_AIINITIATE,
        TEAM_AIOPERATIVE,
        TEAM_AISENOPERATIVE,
        TEAM_AINCO,
        TEAM_AIOFFICER,
        TEAM_AISNIPER,
        TEAM_AILEADSNIPER,
        TEAM_AIMEDIC,
        TEAM_AILEADMEDIC,
        TEAM_AIHEAVY,
        TEAM_AILEADHEAVY,
        TEAM_AIEXPLO,
        TEAM_AILEADEXPLO,
        TEAM_RIINITIATE,
        TEAM_RIRESEARCHER,
        TEAM_RISENRESEARCHER,
        TEAM_RIOFFICER,
        TEAM_RIINFILTRATOR,
        TEAM_RILEADINFILTRATOR,
        TEAM_SIOPERATIVE,
        TEAM_SISENOPERATIVE,
        TEAM_SISPECIALIST,
        TEAM_SICAPTAIN,
        TEAM_SIK9,
        TEAM_CILEADRESEARCH,
        TEAM_CISUPERVISOR,
        TEAM_CIVICECOMMANDER,
        TEAM_CICOMMANDER,
        TEAM_CITIZEN,
        TEAM_CRIMINAL,
        TEAM_TOWNDOCTOR,
        TEAM_MAYOR,
        TEAM_AIBREACH,
        TEAM_AIBREACHLEAD,
        TEAM_I10FBITRN,
        TEAM_I10FBIOP,
        TEAM_I10FBILD,
        TEAM_EXPCIVI,
        TEAM_RETROCIVI,
        TEAM_STAFF,}, ply:Team()) 
    end,
}
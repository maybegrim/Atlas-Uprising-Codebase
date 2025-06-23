CHARACTER.CONFIG = CHARACTER.CONFIG or {}

CHARACTER.CONFIG.Factions = {
    ["FOUNDATION"] = {name = "Foundation", id = "FOUNDATION"},
    ["CHAOS"] = {name = "Chaos Insurgency", id = "CHAOS"},
    ["CIVILIAN"] = {name = "Civilian", id = "CIVILIAN"},
    ["D-CLASS"] = {name = "D-Class", id = "D-CLASS"}
}

-- Departments go here
CHARACTER.CONFIG.UseJobModels = {
    ["RESEARCH AGENCY EX"] = true,
    ["SITE COMMAND"] = true,
    ["MEDICAL STAFF EX"] = true
}

CHARACTER.CONFIG.Height = {
    [75] = "6'3\"",
    [74] = "6'2\"",
    [73] = "6'1\"",
    [72] = "6'0\"",
    [71] = "5'11\"",
    [70] = "5'10\"",
    [69] = "5'9\"",
    [68] = "5'8\"",
    [67] = "5'7\"",
    [66] = "5'6\"",
    [65] = "5'5\"",
    [64] = "5'4\"",
    [63] = "5'3\"",
}

CHARACTER.CONFIG.ModelChoice = {
    ["FOUNDATION"] = {
        male = {
            "models/epangelmatikes/milsuit/male_12.mdl",
            "models/epangelmatikes/milsuit/male_13.mdl",
            "models/epangelmatikes/milsuit/male_14.mdl",
            "models/epangelmatikes/milsuit/male_15.mdl",
            "models/epangelmatikes/milsuit/male_16.mdl",
            "models/epangelmatikes/milsuit/male_017.mdl",
            "models/epangelmatikes/milsuit/male_02.mdl",
            "models/epangelmatikes/milsuit/male_03.mdl",
            "models/epangelmatikes/milsuit/male_04.mdl",
            "models/epangelmatikes/milsuit/male_05.mdl",
            "models/epangelmatikes/milsuit/male_06.mdl",
            "models/epangelmatikes/milsuit/male_07.mdl",
            "models/epangelmatikes/milsuit/male_08.mdl",
        },
        female = {
            "models/epangelmatikes/milsuit/female_01.mdl",
            "models/epangelmatikes/milsuit/female_02.mdl",
            "models/epangelmatikes/milsuit/female_03.mdl",
            "models/epangelmatikes/milsuit/female_04.mdl",
            "models/epangelmatikes/milsuit/female_06.mdl",
            "models/epangelmatikes/milsuit/female_07.mdl",
            "models/epangelmatikes/milsuit/female_08.mdl",
            "models/epangelmatikes/milsuit/female_09.mdl",
            "models/epangelmatikes/milsuit/female_10.mdl",
            "models/epangelmatikes/milsuit/female_11.mdl",
            "models/epangelmatikes/milsuit/female_12.mdl",
            "models/epangelmatikes/milsuit/female_13.mdl",
        }
    },
    ["CHAOS"] = {
        male = {
            "models/epangelmatikes/milsuit/male_12.mdl",
            "models/epangelmatikes/milsuit/male_13.mdl",
            "models/epangelmatikes/milsuit/male_14.mdl",
            "models/epangelmatikes/milsuit/male_15.mdl",
            "models/epangelmatikes/milsuit/male_16.mdl",
            "models/epangelmatikes/milsuit/male_017.mdl",
            "models/epangelmatikes/milsuit/male_02.mdl",
            "models/epangelmatikes/milsuit/male_03.mdl",
            "models/epangelmatikes/milsuit/male_04.mdl",
            "models/epangelmatikes/milsuit/male_05.mdl",
            "models/epangelmatikes/milsuit/male_06.mdl",
            "models/epangelmatikes/milsuit/male_07.mdl",
            "models/epangelmatikes/milsuit/male_08.mdl",
        },
        female = {
            "models/epangelmatikes/milsuit/female_01.mdl",
            "models/epangelmatikes/milsuit/female_02.mdl",
            "models/epangelmatikes/milsuit/female_03.mdl",
            "models/epangelmatikes/milsuit/female_04.mdl",
            "models/epangelmatikes/milsuit/female_06.mdl",
            "models/epangelmatikes/milsuit/female_07.mdl",
            "models/epangelmatikes/milsuit/female_08.mdl",
            "models/epangelmatikes/milsuit/female_09.mdl",
            "models/epangelmatikes/milsuit/female_10.mdl",
            "models/epangelmatikes/milsuit/female_11.mdl",
            "models/epangelmatikes/milsuit/female_12.mdl",
            "models/epangelmatikes/milsuit/female_13.mdl",
        }
    },
    ["CIVILIAN"] = {
        male = {
            "models/retrime/group02/male_02.mdl",
            "models/retrime/group02/male_03.mdl",
            "models/retrime/group02/male_04.mdl",
            "models/retrime/group02/male_05.mdl",
            "models/retrime/group02/male_06.mdl",
            "models/retrime/group02/male_07.mdl",
            "models/retrime/group02/male_08.mdl",
            "models/retrime/group02/male_09.mdl"
        },
        female = {
            "models/retrime/group02/female_01.mdl",
            "models/retrime/group02/female_02.mdl",
            "models/retrime/group02/female_03.mdl",
            "models/retrime/group02/female_04.mdl",
            "models/retrime/group02/female_06.mdl",
            "models/retrime/group02/female_07.mdl"
        }
    },
    ["D-CLASS"] = {
        male = {
            "models/player/cheddar/class_d/class_d_eric.mdl",
            "models/player/cheddar/class_d/class_d_joe.mdl",
            "models/player/cheddar/class_d/class_d_mike.mdl",
            "models/player/cheddar/class_d/class_d_sandro.mdl",
            "models/player/cheddar/class_d/class_d_ted.mdl",
            "models/player/cheddar/class_d/class_d_van.mdl",
            "models/player/cheddar/class_d/class_d_vance.mdl"
        },
        female = {
        }
    }
}


CHARACTER.CONFIG.CharLimit = 3

if SERVER then
    CHARACTER.CONFIG.SQLTableName = "atlas_characters"
end
Elixir.Recipes = Elixir.Recipes or {
    --[[ EXAMPLE
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp_049_pest"] = 1, -- Require one sample of 049s Pestilience.
            ["scp066_yawn"] = 2 -- Require two samples of 066s Yarn.
        },
        fabrication_time = 10, -- Time to craft.
        results = {
            "elixir_1" -- The item(s) received after crafting the samples above.
        }
    },
    ]]
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp_049_pest"] = 1,
            ["scp066_yawn"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_1"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp096_flesh"] = 1,
            ["sc_blood"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_2"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp774_wires"] = 1,
            ["ci_blood"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_3"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp397_banana"] = 1,
            ["scp457_ash"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_4"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp1048_button"] = 1,
            ["scp947_fragment"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_5"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp682_tears"] = 1,
            ["scp553_donut"] = 1,
            ["scp939_fang"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_6"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp4000_note"] = 1,
            ["scp076_able"] = 1,
            ["scp662_blood"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_7"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["sd_blood"] = 1,
            ["scp966_nail"] = 1,
            ["scp_049_pest"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_8"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp774_wires"] = 1,
            ["scp947_fragment"] = 1,
            ["ci_blood"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_9"
        }
    },
    {
        parts = { -- Parts required to craft an item. IDs are used.
            ["scp096_flesh"] = 1,
            ["scp682_tears"] = 1,
            ["scp076_able"] = 1
        },
        fabrication_time = 10,
        results = {
            "elixir_10"
        }
    }
}

-- Recipes must be made of two or more parts, whether that be two 
-- or more of the same part or two or more different parts.
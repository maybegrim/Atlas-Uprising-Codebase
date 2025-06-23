Elixir.AddRecipe({
    parts = {
        ["dclass_tears"] = 1,
        ["researcher_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_a"
    }
})

Elixir.AddRecipe({
    parts = {
        ["dclass_tears"] = 1,
        ["researcher_blood"] = 1,
        ["gen_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_b"
    }
})

Elixir.AddRecipe({
    parts = {
        ["dclass_tears"] = 1,
        ["researcher_blood"] = 1,
        ["gen_blood"] = 1,
        ["ntf_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_c"
    }
})

Elixir.AddRecipe({
    parts = {
        ["dclass_tears"] = 1,
        ["researcher_blood"] = 1,
        ["gen_blood"] = 1,
        ["ntf_blood"] = 1,
        ["scp343_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_d"
    }
})

Elixir.AddRecipe({
    parts = {
        ["dclass_tears"] = 1,
        ["ntf_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_e"
    }
})

Elixir.AddRecipe({
    parts = {
        ["cmdr_blood"] = 1,
        ["vcmdr_blood"] = 1,
        ["sd_blood"] = 1,
        ["sc_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_f"
    }
})

Elixir.AddRecipe({
    parts = {
        ["ra_blood"] = 1,
        ["scp662_blood"] = 1,
        ["ci_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_g"
    }
})

Elixir.AddRecipe({
    parts = {
        ["ra_blood"] = 1,
        ["ntf_blood"] = 1,
        ["researcher_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_h"
    }
})

Elixir.AddRecipe({
    parts = {
        ["dclass_tears"] = 1,
        ["gen_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_i"
    }
})

Elixir.AddRecipe({
    parts = {
        ["ra_blood"] = 1,
        ["ci_blood"] = 1,
        ["researcher_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_w"
    }
})

Elixir.AddRecipe({
    parts = {
        ["ci_blood"] = 1,
        ["researcher_blood"] = 1,
        ["ra_blood"] = 1,
        ["sd_blood"] = 1
    },
    fabrication_time = 10,
    results = {
        "amnestic_x"
    }
})

include("au_amnestics/sh_types.lua")
hook.Run("AU.Amnestics.ElixirRegister")
INVENTORY = INVENTORY or {}

if SERVER then
    include("inventory/sh_inv_config.lua")
    AddCSLuaFile("inventory/sh_inv_config.lua")

    include("inventory/sh_item_loader.lua")
    AddCSLuaFile("inventory/sh_item_loader.lua")

    include("inventory/sv_inventory.lua")

    include("inventory/jobs/sv_jobs.lua")

    include("inventory/jobs/sh_convert_ents.lua")
    AddCSLuaFile("inventory/jobs/sh_convert_ents.lua")

    include("inventory/crafting/sh_recipes.lua")
    AddCSLuaFile("inventory/crafting/sh_recipes.lua")

    AddCSLuaFile("inventory/cl_inventory.lua")

    AddCSLuaFile("inventory/ui/cl_ui_inventory.lua")
    AddCSLuaFile("inventory/ui/cl_ui_trade.lua")
    AddCSLuaFile("inventory/ui/cl_ui_confirm.lua")

    AddCSLuaFile("inventory/ui/sound/util.lua")

    include("inventory/functions/sh_item_networking.lua")
    AddCSLuaFile("inventory/functions/sh_item_networking.lua")

    include("inventory/systems/sh_weight.lua")
    AddCSLuaFile("inventory/systems/sh_weight.lua")

    include("inventory/systems/sh_mining.lua")
    AddCSLuaFile("inventory/systems/sh_mining.lua")

    include("inventory/systems/sh_garbage.lua")
    AddCSLuaFile("inventory/systems/sh_garbage.lua")

    include("inventory/systems/sh_contraband.lua")
    AddCSLuaFile("inventory/systems/sh_contraband.lua")
else
    include("inventory/sh_inv_config.lua")
    include("inventory/sh_item_loader.lua")
    include("inventory/jobs/sh_convert_ents.lua")
    include("inventory/cl_inventory.lua")
    include("inventory/ui/cl_ui_inventory.lua")
    include("inventory/ui/cl_ui_trade.lua")
    include("inventory/ui/cl_ui_confirm.lua")
    include("inventory/crafting/sh_recipes.lua")
    include("inventory/functions/sh_item_networking.lua")
    include("inventory/systems/sh_weight.lua")
    include("inventory/systems/sh_mining.lua")
    include("inventory/systems/sh_garbage.lua")
    include("inventory/systems/sh_contraband.lua")
end
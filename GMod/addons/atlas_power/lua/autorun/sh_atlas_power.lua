RESEARCH = RESEARCH or {}

if SERVER then
    include("research/sh_config.lua")
    include("research/power/sv_power.lua")
    include("research/power/sv_net.lua")
    include("research/pharma/sv_pharma.lua")
    include("research/sh_inventory_recipes.lua")
    AddCSLuaFile("research/pharma/cl_pharma.lua")
    AddCSLuaFile("research/power/cl_power.lua")
    AddCSLuaFile("research/sh_config.lua")
    AddCSLuaFile("research/sh_inventory_recipes.lua")
else
    include("research/sh_config.lua")
    include("research/power/cl_power.lua")
    include("research/pharma/cl_pharma.lua")
    include("research/sh_inventory_recipes.lua")
end
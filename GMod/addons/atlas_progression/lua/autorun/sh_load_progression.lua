PROGRESSION = PROGRESSION or {}

include("progression/sh_config.lua")
if SERVER then
    include("progression/sh_config.lua")
    AddCSLuaFile("progression/sh_config.lua")

    include("progression/sv_progression.lua")
    AddCSLuaFile("progression/cl_progression.lua")
    AddCSLuaFile("progression/ui/cl_upgrade_ui.lua")
else
    include("progression/cl_progression.lua")
    include("progression/ui/cl_upgrade_ui.lua")
end
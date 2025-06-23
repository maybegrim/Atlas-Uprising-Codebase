ACTIVITY = ACTIVITY or {}

if SERVER then
    -- Send client-side files to clients
    AddCSLuaFile("activity/sh_config.lua")
    AddCSLuaFile("activity/cl_activity.lua")
    AddCSLuaFile("activity/ui/cl_panel.lua")

    -- Include server-side files
    include("activity/sh_config.lua")
    include("activity/sv_activity.lua")
else
    -- Include client-side files
    include("activity/sh_config.lua")
    include("activity/cl_activity.lua")
    include("activity/ui/cl_panel.lua")
end

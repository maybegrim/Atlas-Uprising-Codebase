ENFORCER = ENFORCER or {}
if SERVER then
    AddCSLuaFile("enforcer/vgui/cl_warn_menu.lua")
    AddCSLuaFile("enforcer/modules/warns/cl_warns.lua")
    AddCSLuaFile("enforcer/modules/bans/cl_bans.lua")

    -- Load permissions
    include("enforcer/sh_permissions.lua")
    AddCSLuaFile("enforcer/sh_permissions.lua")

    -- Load Data file
    include("enforcer/data/sv_data.lua")

    -- Load Ban file
    include("enforcer/modules/bans/sv_bans.lua")

    -- Load Warn Files
    include("enforcer/modules/warns/sv_warns.lua")

    -- Load Commands File
    include("enforcer/modules/commands/sv_commands.lua")

    -- Load SafeGuard Files
    include("enforcer/modules/safeguard/sv_sprays.lua")

elseif CLIENT then
    include("enforcer/vgui/cl_warn_menu.lua")
    include("enforcer/modules/warns/cl_warns.lua")
    include("enforcer/modules/bans/cl_bans.lua")

    -- Load permissions
    include("enforcer/sh_permissions.lua")
end
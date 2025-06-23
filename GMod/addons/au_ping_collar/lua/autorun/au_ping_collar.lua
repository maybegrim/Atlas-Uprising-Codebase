if SERVER then
    include("ping_collar/sv_resource.lua")

    AddCSLuaFile("ping_collar/sh_config.lua")
    AddCSLuaFile("ping_collar/cl_display.lua")
    AddCSLuaFile("ping_collar/sh_player.lua")
end

if CLIENT then
    include("ping_collar/cl_display.lua")
end

include("ping_collar/sh_config.lua")
include("ping_collar/sh_player.lua")
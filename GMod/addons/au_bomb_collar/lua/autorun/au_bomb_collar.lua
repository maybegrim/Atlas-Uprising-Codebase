if SERVER then
    include("bomb_collar/sv_resource.lua")

    AddCSLuaFile("bomb_collar/sh_config.lua")
    AddCSLuaFile("bomb_collar/cl_display.lua")
    AddCSLuaFile("bomb_collar/sh_tamper.lua")
    AddCSLuaFile("bomb_collar/sh_player.lua")
end

if CLIENT then
    include("bomb_collar/cl_display.lua")
end

include("bomb_collar/sh_config.lua")
include("bomb_collar/sh_tamper.lua")
include("bomb_collar/sh_player.lua")
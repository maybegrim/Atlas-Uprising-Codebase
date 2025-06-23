LEVEL = LEVEL or {}
LEVEL.CFG = LEVEL.CFG or {}
LEVEL.DATA = LEVEL.DATA or {}

if SERVER then
    include("level/sv_config.lua")
    include("level/sv_main.lua")
    include("level/sv_player.lua")
    include("level/sh_player.lua")
    include("level/weapons/sv_weapons.lua")


    include("level/methods/sv_activity.lua")
    include("level/methods/sv_npc.lua")


    AddCSLuaFile("level/sh_player.lua")
    AddCSLuaFile("level/cl_config.lua")
    AddCSLuaFile("level/weapons/cl_weapons.lua")
else
    include("level/sh_player.lua")
    include("level/cl_config.lua")
    include("level/weapons/cl_weapons.lua")
end
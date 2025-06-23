AddCSLuaFile()

include("door_system/sh_config.lua")

if SERVER then
    include("door_system/sv_door_system.lua")
end
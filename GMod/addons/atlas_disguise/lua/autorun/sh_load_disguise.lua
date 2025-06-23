ADQ = ADQ or {}
ADQ.CONF = ADQ.CONF or {}
if SERVER then
    AddCSLuaFile("disguise/sh_config.lua")
    AddCSLuaFile("disguise/cl_disguise.lua")
    
    include("disguise/sh_config.lua")
    include("disguise/sv_disguise.lua")
end

if CLIENT then
    include("disguise/sh_config.lua")
    include("disguise/cl_disguise.lua")
end
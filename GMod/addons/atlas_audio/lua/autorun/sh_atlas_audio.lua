AAUDIO = AAUDIO or {}
AAUDIO.PA = AAUDIO.PA or {}
AAUDIO.ANNOUNCEMENTS = AAUDIO.ANNOUNCEMENTS or {}

--[[SHARED]]
include("public_address/sh_config.lua")

if SERVER then
    AddCSLuaFile("public_address/sh_config.lua")
    include("public_address/sv_pa_driver.lua")

    AddCSLuaFile("public_address/cl_pa_driver.lua")
    AddCSLuaFile("ambience/cl_ambience.lua")

    include("announcements/sv_announcements.lua")
    AddCSLuaFile("announcements/cl_announcements.lua")
end

if CLIENT then
    include("public_address/cl_pa_driver.lua")
    include("ambience/cl_ambience.lua")
    include("announcements/cl_announcements.lua")
end

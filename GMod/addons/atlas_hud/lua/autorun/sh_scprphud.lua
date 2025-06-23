if SERVER then
    AddCSLuaFile("ui/hud.lua")
    AddCSLuaFile("ui/notification.lua")
    AddCSLuaFile("ui/overhead.lua")
    AddCSLuaFile("ui/tasks.lua")
    AddCSLuaFile("ui/weapon.lua")
    AddCSLuaFile("ui/medical.lua")
end

if CLIENT then
    include("ui/hud.lua")
    include("ui/notification.lua")
    include("ui/overhead.lua")
    include("ui/tasks.lua")
    include("ui/weapon.lua")
    include("ui/medical.lua")
end
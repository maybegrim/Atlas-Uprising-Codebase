WELCOMEUI = WELCOMEUI or {}
if SERVER then
    -- Load Serverside Controller
    include("welcome/sv_welcome.lua")

    -- Load Clientside Controller
    AddCSLuaFile("welcome/cl_welcome.lua")

    -- Ship Clientside Interfaces
    AddCSLuaFile("welcome/interfaces/cl_interface_intro.lua")
    AddCSLuaFile("welcome/interfaces/cl_interface_rules.lua")
    AddCSLuaFile("welcome/interfaces/cl_interface_main.lua")
elseif CLIENT then
    -- Load Clientside Controller
    include("welcome/cl_welcome.lua")

    -- Load Clientside Interfaces
    include("welcome/interfaces/cl_interface_intro.lua")
    include("welcome/interfaces/cl_interface_rules.lua")
    include("welcome/interfaces/cl_interface_main.lua")
end
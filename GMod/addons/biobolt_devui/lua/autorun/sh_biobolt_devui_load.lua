if SERVER then
    AddCSLuaFile("devui/cl_ui.lua")
end

if CLIENT then
    include("devui/cl_ui.lua")
end
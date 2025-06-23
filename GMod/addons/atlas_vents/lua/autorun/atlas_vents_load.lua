VENTS = VENTS or {}
if SERVER then
    include("vents/sv_vents.lua")
    AddCSLuaFile("vents/cl_vents.lua")
elseif CLIENT then
    include("vents/cl_vents.lua")
end
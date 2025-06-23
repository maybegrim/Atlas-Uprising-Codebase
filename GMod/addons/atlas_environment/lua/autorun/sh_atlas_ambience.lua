if SERVER then
    AddCSLuaFile("ambience/footsteps/cl_footsteps.lua")
    AddCSLuaFile("visuals/cl_view.lua")
    AddCSLuaFile("visuals/cl_shoot.lua")
    AddCSLuaFile("visuals/cl_vignette.lua")
else
    include("ambience/footsteps/cl_footsteps.lua")
    include("visuals/cl_view.lua")
    include("visuals/cl_shoot.lua")
    include("visuals/cl_vignette.lua")
end
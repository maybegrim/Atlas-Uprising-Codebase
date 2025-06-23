if SERVER then
    AddCSLuaFile("fpsboost/cl_fps.lua")
else
    include("fpsboost/cl_fps.lua")
end
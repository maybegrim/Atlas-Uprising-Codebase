if SERVER then
    include("verify/sv_verify.lua")
    AddCSLuaFile("verify/cl_ui.lua")
else
    include("verify/cl_ui.lua")
end
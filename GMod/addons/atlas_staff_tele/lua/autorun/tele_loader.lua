if SERVER then
    AddCSLuaFile("client/cl_tele.lua")
    include("server/sv_tele.lua")
end

if CLIENT then
    include("client/cl_tele.lua")
end
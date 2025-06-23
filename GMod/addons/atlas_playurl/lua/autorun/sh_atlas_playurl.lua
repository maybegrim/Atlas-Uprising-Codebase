PlayURL = PlayURL or {}
if SERVER then
    include("playurl/sv_playurl.lua")
    AddCSLuaFile("playurl/cl_playurl.lua")
else
    include("playurl/cl_playurl.lua")
end
ATLASDATA = ATLASDATA or {}

if SERVER then
    include("atlasdata/sv_data.lua")
    AddCSLuaFile("atlasdata/cl_data.lua")
else
    include("atlasdata/cl_data.lua")
end

if (SERVER) then
    include("outfitlocker/sv_core.lua")
    AddCSLuaFile("outfitlocker/cl_core.lua")
else
    include("outfitlocker/cl_core.lua")
end
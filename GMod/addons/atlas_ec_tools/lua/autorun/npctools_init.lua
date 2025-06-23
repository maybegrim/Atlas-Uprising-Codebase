game.AddParticles("particles/plate_green.pcf")
PrecacheParticleSystem("plate_green")
if(SERVER) then
	AddCSLuaFile("includes/modules/json.lua")
	AddCSLuaFile("autorun/client/cl_npctools_relationships.lua")
end
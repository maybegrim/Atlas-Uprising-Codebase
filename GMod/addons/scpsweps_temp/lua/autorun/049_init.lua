if SERVER then

	include("049_core/core/sv_netmsg049.lua")

	AddCSLuaFile("049_core/dermas/cl_049ui.lua")

end

if CLIENT then

	include("049_core/dermas/cl_049ui.lua")

end
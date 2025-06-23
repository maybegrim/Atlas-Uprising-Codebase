XYZ = XYZ or {}

if SERVER then
	AddCSLuaFile("xyz/gui/cl_helpers.lua")
	AddCSLuaFile("xyz/utils/sh_util.lua")
end

include("xyz/utils/sh_util.lua")

if CLIENT then
	include("xyz/gui/cl_helpers.lua")
end
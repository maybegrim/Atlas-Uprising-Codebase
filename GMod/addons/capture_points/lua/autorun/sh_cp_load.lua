--[[
	Name: sh_cp_load.lua
	By: Micro
]]--

if SERVER then
	resource.AddFile("materials/au/scprp/map_overview.png")
	resource.AddFile("resource/fonts/Roboto.ttf")

	local f, d = file.Find("cp/client/*.lua", "LUA")

	for k, v in pairs(f) do
		AddCSLuaFile("cp/client/" .. v)
	end

	f, d = file.Find("cp/shared/*.lua", "LUA")

	for k, v in pairs(f) do
		AddCSLuaFile("cp/shared/" .. v)
		include("cp/shared/" .. v)
	end

	f, d = file.Find("cp/server/*.lua", "LUA")

	for k, v in pairs(f) do
		include("cp/server/" .. v)
	end
else
	local f, d = file.Find("cp/shared/*.lua", "LUA")

	for k, v in pairs(f) do
		include("cp/shared/" .. v)
	end

	f, d = file.Find("cp/client/*.lua", "LUA")

	for k, v in pairs(f) do
		include("cp/client/" .. v)
	end
end
--[[
	Name: sh_codes_load.lua
	By: Micro
]]--

if SERVER then
	resource.AddFile("resource/fonts/Roboto.ttf")

	local f, d = file.Find("codes/client/*.lua", "LUA")

	for k, v in pairs(f) do
		AddCSLuaFile("codes/client/" .. v)
	end

	f, d = file.Find("codes/shared/*.lua", "LUA")

	for k, v in pairs(f) do
		AddCSLuaFile("codes/shared/" .. v)
		include("codes/shared/" .. v)
	end

	f, d = file.Find("codes/server/*.lua", "LUA")

	for k, v in pairs(f) do
		include("codes/server/" .. v)
	end
else
	local f, d = file.Find("codes/shared/*.lua", "LUA")

	for k, v in pairs(f) do
		include("codes/shared/" .. v)
	end

	f, d = file.Find("codes/client/*.lua", "LUA")

	for k, v in pairs(f) do
		include("codes/client/" .. v)
	end
end
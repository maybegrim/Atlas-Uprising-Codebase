--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

AtlasAddons = AtlasAddons or {}
AtlasAddons.Config = AtlasAddons.Config or {}

Msg( "[AU Addons] Loading Shared Modules...\n" )

local Files, Folders = file.Find( "atlas_addons/shared/*.lua", "LUA" )
for _, v in pairs( Files ) do
	Msg( "\t-> " .. v .. "\n" )
	include( "atlas_addons/shared/" .. v )
	if SERVER then AddCSLuaFile( "atlas_addons/shared/" .. v ) end
end

function AtlasAddons:Initialize()
	self.Net:Initialize()
end

hook.Add( "Initialize", "AtlasAddons:Initialize", function()
	AtlasAddons:Initialize()
end)

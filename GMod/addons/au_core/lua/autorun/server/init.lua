--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

Msg( "[AU Addons] Loading Server Modules...\n" )

-- Load server modules
local Files, Folders = file.Find( "atlas_addons/server/*.lua", "LUA" )
for _, v in pairs( Files ) do Msg( "\t-> " .. v .. "\n" ) include( "atlas_addons/server/" .. v ) end

-- Add clientside files
local Files, Folders = file.Find( "atlas_addons/client/*.lua", "LUA" )
for _, v in pairs( Files ) do AddCSLuaFile( "atlas_addons/client/" .. v ) end

-- Add clientside vgui files
local Files, Folders = file.Find( "atlas_addons/vgui/*.lua", "LUA" )
for _, v in pairs( Files ) do AddCSLuaFile( "atlas_addons/vgui/" .. v ) end

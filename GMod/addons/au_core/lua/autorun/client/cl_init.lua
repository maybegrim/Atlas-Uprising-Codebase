--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

Msg( "[AU Addons] Loading Client Modules...\n" )

local Files, Folders = file.Find( "atlas_addons/client/*.lua", "LUA" )
for _, v in pairs( Files ) do Msg( "\t-> " .. v .. "\n" ) include( "atlas_addons/client/" .. v ) end

Msg( "[AU Addons] Loading VGUI Modules...\n" )

local Files, Folders = file.Find( "atlas_addons/vgui/*.lua", "LUA" )
for _, v in pairs( Files ) do Msg( "\t-> " .. v .. "\n" ) include( "atlas_addons/vgui/" .. v ) end

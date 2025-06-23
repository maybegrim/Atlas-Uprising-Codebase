
if ( SERVER ) then
	sam.permissions.add("294_editconfig", "scp_294", "superadmin")
	AddCSLuaFile( "scp294/cl_init.lua" )
	AddCSLuaFile( "scp294/sh_init.lua" )
	
	AddCSLuaFile( "scp294/cl_sync.lua" )
	AddCSLuaFile( "scp294/cl_command.lua" )
	AddCSLuaFile( "scp294/cl_fonts.lua" )
	AddCSLuaFile( "scp294/cl_draw.lua" )
	
	AddCSLuaFile( "scp294/sh_method.lua" )
	AddCSLuaFile( "scp294/sh_config.lua" )
	AddCSLuaFile( "scp294/sh_util.lua" )
	
	AddCSLuaFile( "scp294/vgui/editor_main.lua" )
	AddCSLuaFile( "scp294/vgui/editor_main_func.lua" )
	AddCSLuaFile( "scp294/vgui/editor_load.lua" )
	AddCSLuaFile( "scp294/vgui/editor_load_func.lua" )
	AddCSLuaFile( "scp294/vgui/editor_settings.lua" )
	AddCSLuaFile( "scp294/vgui/editor_settings_func.lua" )
	AddCSLuaFile( "scp294/vgui/keyboard.lua" )
	AddCSLuaFile( "scp294/vgui/keyboard_no_texture.lua" )
	
	AddCSLuaFile( "scp294/vgui/register/dframe_mainmenu.lua" )
	AddCSLuaFile( "scp294/vgui/register/dframe_mainmenu_button.lua" )
	AddCSLuaFile( "scp294/vgui/register/dframe_loadmenu_button.lua" )
	AddCSLuaFile( "scp294/vgui/register/dframe_settingsmenu.lua" )
	AddCSLuaFile( "scp294/vgui/register/dframe_settingsmenu_button.lua" )
	
	include( "scp294/sv_init.lua" )
	include( "scp294/sh_init.lua" )
	
	include( "scp294/sv_save.lua" )
	include( "scp294/sv_sync.lua" )
	include( "scp294/sv_command.lua" )
	include( "scp294/sv_hooks.lua" )
	
	include( "scp294/sh_method.lua" )
	include( "scp294/sh_config.lua" )
	include( "scp294/sh_util.lua" )
end

if ( CLIENT ) then
	include( "scp294/cl_init.lua" )
	include( "scp294/sh_init.lua" )
	
	include( "scp294/cl_sync.lua" )
	include( "scp294/cl_command.lua" )
	include( "scp294/cl_fonts.lua" )
	include( "scp294/cl_draw.lua" )
	
	include( "scp294/sh_method.lua" )
	include( "scp294/sh_config.lua" )
	include( "scp294/sh_util.lua" )
	
	include( "scp294/vgui/editor_main.lua" )
	include( "scp294/vgui/editor_main_func.lua" )
	include( "scp294/vgui/editor_load.lua" )
	include( "scp294/vgui/editor_load_func.lua" )
	include( "scp294/vgui/editor_settings.lua" )
	include( "scp294/vgui/editor_settings_func.lua" )
	include( "scp294/vgui/keyboard.lua" )
	include( "scp294/vgui/keyboard_no_texture.lua" )
	
	include( "scp294/vgui/register/dframe_mainmenu.lua" )
	include( "scp294/vgui/register/dframe_mainmenu_button.lua" )
	include( "scp294/vgui/register/dframe_loadmenu_button.lua" )
	include( "scp294/vgui/register/dframe_settingsmenu.lua" )
	include( "scp294/vgui/register/dframe_settingsmenu_button.lua" )
end

-- Flavour structure :

-- local flavourStructure = {
	-- drinkName = "default name",
	-- drinkDescription = "Default Description",
	-- drinkColor = Color( 255, 255, 255 ),
	-- drinkSound = "normal",
	-- creationSound = "normal",
	-- selectedMethod = {}
	-- }







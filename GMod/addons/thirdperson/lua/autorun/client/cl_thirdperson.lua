hook.Add("InitPostEntity", "Disable_Thirdperson_on_Join", function()
	RunConsoleCommand("cl_weapon_holsters", "1")
	RunConsoleCommand("simple_thirdperson_enabled", "0")
end)

local thirdpeson_enabled = false
chat.PlaySound = function() end
hook.Add("OnPlayerChat", "ThirdpersonCommand", function( ply, text, team )
	if ( string.sub( string.lower( text ), 1, 4 ) == "!3p" ) then
		if LocalPlayer() != ply then
			return true
		end
		if LocalPlayer():Team() == TEAM_035 then
			LocalPlayer():ChatPrint("You can't use this command as SCP-035.")
			RunConsoleCommand("simple_thirdperson_enabled", "0")
			return true
		end
		if thirdpeson_enabled == false then
			LocalPlayer():ChatPrint("Thirdperson mode enabled.")
			RunConsoleCommand( "simple_thirdperson_cam_distance", "75" )
			RunConsoleCommand( "simple_thirdperson_cam_right", "0" )
			RunConsoleCommand("simple_thirdperson_enabled", "1")
			thirdpeson_enabled = true
			return true
		else
			LocalPlayer():ChatPrint("Thirdperson mode disabled.")
			RunConsoleCommand("simple_thirdperson_enabled", "0")
			thirdpeson_enabled = false
			return true
		end
	end
end)
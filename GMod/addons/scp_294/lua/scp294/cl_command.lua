
CreateClientConVar( "scp294_debugHUD", "0", true, true )
CreateClientConVar( "scp294_keyboardMode", "1", true, true )

concommand.Add( "SCP294_openEditor", function( ply, cmd, args )
	SCP294Client.openMainMenu()
end )

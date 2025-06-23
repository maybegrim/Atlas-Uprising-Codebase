if SAM_LOADED then return end

local sam, command = sam, sam.command

concommand.Add( "scp294_save", function( ply )
	if ( ply:IsPlayer() ) then
		if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
			SCP294Server.saveDrinkDATA()
			SCP294Server.sendTextToClient( ply, "Save succes !" )
		end
	else
		SCP294Server.saveDrinkDATA()
		SCP294Server.sendTextToClient( ply, "Save succes !" )
	end
end )

concommand.Add( "scp294_load", function( ply )
	if ( ply:IsPlayer() ) then
		if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
			SCP294Server.loadDrinkDATA()
			SCP294Server.sendTextToClient( ply, "Load succes !" )
		end
	else
		SCP294Server.loadDrinkDATA()
		SCP294Server.sendTextToClient( ply, "Load succes !" )
	end
end)

concommand.Add( "scp294_debug", function( ply )
	if ( ply:IsPlayer() ) then
		if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
			if ( SCP294Server.debug ) then
				MsgC( Color( 255, 0, 0 ), "[SCP 294] : DEBUG MODE DISABLED\n" )
				SCP294Server.debug = false
			else
				MsgC( Color( 255, 0, 0 ), "[SCP 294] : DEBUG MODE ENABLED\n" )
				SCP294Server.debug = true
			end
		end
	end
end )
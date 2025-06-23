SCP294Client = ( SCP294Client or {} )
SCP294Client.drinkDATA = ( SCP294Client.drinkDATA or {} )
SCP294Client.haveMaterials = ( SCP294Client.haveMaterials or false )

function SCP294Client.applyDFrameCustom()
	if ( SCP294Client.DFrame ) then
		if ( SCP294Client.DFrame.updatedDATA ) then
			SCP294Client.DFrame.updatedDATA()
		end
	end
end

function SCP294Client.checkMaterials()
	local checkList = {}
	checkList[1] = "materials/scp_294_redux/bgr_down.png"
	checkList[2] = "materials/scp_294_redux/bgr_right.png"
	checkList[3] = "materials/scp_294_redux/bgr_up.png"
	checkList[4] = "materials/scp_294_redux/cancel.png"
	checkList[5] = "materials/scp_294_redux/cancel_no_circle.png"
	checkList[6] = "materials/scp_294_redux/check_not_valid.png"
	checkList[7] = "materials/scp_294_redux/check_valid.png"
	checkList[8] = "materials/scp_294_redux/clockwise-rotation.png"
	checkList[9] = "materials/scp_294_redux/info.png"
	checkList[10] = "materials/scp_294_redux/keyboard.png"
	checkList[11] = "materials/scp_294_redux/load.png"
	checkList[12] = "materials/scp_294_redux/open-folder.png"
	checkList[13] = "materials/scp_294_redux/pencil.png"
	checkList[14] = "materials/scp_294_redux/uncertainty.png"
	checkList[15] = "materials/scp_294_redux/wireframe-globe.png"
	checkList[16] = "materials/scp_294_redux/line02.png"
	
	local getAll = true
	for k , path in pairs ( checkList ) do
		if not ( file.Exists( path, "GAME" ) ) then
			getAll = false
			MsgC( Color( 255, 0, 0 ), "[SCP294] : Missing material " .. path .. " .. \n" )
		end
	end
	 
	if not ( getAll ) then
		SCP294Client.haveMaterials = false
	else
		SCP294Client.haveMaterials = true
	end
end

hook.Add( "Initialize", "SCP294RInitialize", function()
	SCP294Client.checkMaterials()
end )

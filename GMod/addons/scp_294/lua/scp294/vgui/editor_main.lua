-- [[ Drink main menu vgui ]] --

function SCP294Client.openMainMenu()
	
	-- Check if the player have all the materials
	SCP294Client.checkMaterials()
	
	-- Remove the old DFrame
	if ( SCP294Client.DFrame ) then
		if ( type( SCP294Client.DFrame ) == "Panel" ) then
			SCP294Client.DFrame:Remove()
		end
	end
	
	-- Create the main DFrame panel
	SCP294Client.DFrame = vgui.Create( "SCP294RMainMenu" )

	local pnl = SCP294Client.DFrame
	pnl:SetSize( 1280, 720 )
	pnl:Center()
	pnl.loadButtons = {} -- Register all the temporary button we need to remove
	pnl:SetCustomTitle( "SCP 294 EDITOR" )
	pnl:SetBackgroundColor( Color( 170, 55, 69 ) )
	pnl:SetDraggable( true )
	pnl:MakePopup()
	pnl.keyName = "Menu"

	-- Create the 3 main buttons
	local bgrEffect = vgui.Create( "DImage" , pnl )
	local NewDrink = vgui.Create( "SCP294RMainMenuButton", pnl )
	local LoadDrink = vgui.Create( "SCP294RMainMenuButton", pnl )
	local ExitMenu = vgui.Create( "SCP294RMainMenuButton", pnl )
	
	bgrEffect:SetImage( "scp_294_redux/bgr_up.png" )
	bgrEffect:SetPos( 0, 75 )
	bgrEffect:SetSize( 440, 644 )
	bgrEffect:SetImageColor( Color ( 0, 0, 0, 0 ) )
	
	-- Button to create a new drink with empty settings
	NewDrink:SetText( "NEW" )
	NewDrink:SetTextColor( Color( 255, 255, 255 ) )
	NewDrink:SetPos( 50, 200 )
	NewDrink:SetTexture( "scp_294_redux/pencil.png" )
	NewDrink.OnCursorExitedCustom = function( self )
		bgrEffect:SetImageColor( Color ( 0, 0, 0, 0 ) )
	end
	NewDrink.OnCursorEnteredCustom = function( self )
		if ( SCP294Client.haveMaterials ) then
			local x, y = self:GetPos()
			bgrEffect:SetPos( x - 70, 75 )
			bgrEffect:SetImageColor( Color ( 210, 255, 210, 120 ) )
		end
	end
	NewDrink.DoClick = function()
		SCP294Client.openDrinkEditor()
	end
	
	-- Button to load a drink and modify it
	LoadDrink:SetText( "LOAD" )
	LoadDrink:SetPos( 490, 200 )
	LoadDrink:SetTexture( "scp_294_redux/open-folder.png" )
	LoadDrink.OnCursorExitedCustom = function( self )
		bgrEffect:SetImageColor( Color ( 0, 0, 0, 0 ) )
	end
	LoadDrink.OnCursorEnteredCustom = function( self )
		if ( SCP294Client.haveMaterials ) then
			local x, y = self:GetPos()
			bgrEffect:SetPos( x - 70, 75 )
			bgrEffect:SetImageColor( Color ( 170, 170, 255, 120 ) )
		end
	end
	LoadDrink.DoClick = function()
		SCP294Client.openLoadMenu()
	end
	
	-- Button to exit the panel
	ExitMenu:SetText( "EXIT" )
	ExitMenu:SetPos( 930, 200 )
	ExitMenu:SetTexture( "scp_294_redux/cancel_no_circle.png" )
	ExitMenu.OnCursorExitedCustom = function( self )
		bgrEffect:SetImageColor( Color ( 0, 0, 0, 0 ) )
	end
	ExitMenu.OnCursorEnteredCustom = function( self )
		if ( SCP294Client.haveMaterials ) then
			local x, y = self:GetPos()
			bgrEffect:SetPos( x - 70, 75 )
			bgrEffect:SetImageColor( Color ( 255, 220, 220, 120 ) )
		end
	end
	ExitMenu.DoClick = function()
		SCP294Client.DFrame:Remove()
	end
	
end
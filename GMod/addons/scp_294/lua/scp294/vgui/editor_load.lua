-- [[ Drink load menu vgui ]] --


-- SCP294Client.drinkDATA  = {}  

function SCP294Client.openLoadMenu()
	-- Remove the old DFrame
	if ( SCP294Client.DFrame ) then
		if ( ispanel( SCP294Client.DFrame ) ) then
			SCP294Client.DFrame:Remove()
		end
	end
	
	-- Request the server drink list DATA
	if ( table.Count( SCP294Client.drinkDATA ) <= 0 ) then
		if ( not SCP294Client.downloadInfo ) then
			SCP294Client.requestAllServerDATAIndividually()
		end
	end
	
	-- Create the main DFrame panel
	SCP294Client.DFrame = vgui.Create( "SCP294RMainMenu" )

	local pnl = SCP294Client.DFrame
	pnl.keyName = "Load"
	pnl:SetSize( 1280, 720 )
	pnl:Center()
	pnl.loadButtons = {} -- Register all the temporary button we need to remove
	if ( SCP294Client.haveMaterials ) then
		pnl:SetCustomTitle( "SCP 294 EDITOR - LOAD" )
	else
		pnl:SetCustomTitle( "SCP 294 EDITOR" )
	end
	pnl:SetBackgroundColor( Color( 50, 69, 220 ) )
	pnl:SetDraggable( true )
	pnl:MakePopup()
	pnl.DScrollPanel = vgui.Create( "DScrollPanel", pnl )
	
	pnl.updatedDATA = function()
		if ( SCP294Client.downloadInfo ) then
			-- Make sure no load drink button exist
			if ( #pnl.loadButtons > 0 ) then 
				for k, v in pairs ( pnl.loadButtons ) do 
					v:Remove() 
					pnl.loadButtons[k] = nil 
				end  
			end
			pnl.debugCount:SetText( "Loading (" .. math.Clamp(math.Round( table.Count( SCP294Client.drinkDATA )/SCP294Client.downloadInfo*100 ),0,100).. "%)" )
		else
			pnl.debugCount:SetText( "" )
			SCP294Client.loadDrinkList()
		end

	end
 
	local bgrEffect = vgui.Create( "DImage" , pnl )
	bgrEffect:SetImage( "scp_294_redux/bgr_up.png" )
	bgrEffect:SetPos( 901, 75 )
	bgrEffect:SetSize( 379, 644 )
	bgrEffect:SetImageColor( Color ( 0, 255, 0, 0 ) )

	pnl.DScrollPanel:SetPos( 1, 75 )
	pnl.DScrollPanel:SetSize( 900, 643 )
	
	pnl.debugCount = vgui.Create( "DLabel", pnl )
	pnl.debugCount:SetPos( 150, 150 )
	pnl.debugCount:SetSize( 800, 300 )
	pnl.debugCount:SetFont( "scpMenuFontBig" )
	pnl.debugCount:SetText( "" )

	-- Visual settings
	local sbar = pnl.DScrollPanel:GetVBar()
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
	end
	function sbar.btnUp:Paint( w, h ) end
	function sbar.btnDown:Paint( w, h )	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 220, 220, 220 ) )
	end
	
	if ( SCP294Client.drinkDATA ) then
		SCP294Client.loadDrinkList()
	end
	
	local ExitMenu = vgui.Create( "SCP294RMainMenuButton", pnl )
	local RefreshButton = vgui.Create( "SCP294RMainMenuButton", pnl )
	
	
	-- Button to exit the panel
	RefreshButton:SetText( "SYNC" )
	RefreshButton:SetPos( 990, 120 )
	RefreshButton:SetSize( 200, 200 )
	RefreshButton:SetTexture( "scp_294_redux/clockwise-rotation.png" )
	if ( SCP294Client.haveMaterials ) then
		RefreshButton.OnCursorExitedCustom = function( self )
			bgrEffect:SetImageColor( Color ( 0, 0, 0, 0 ) )
		end
		RefreshButton.OnCursorEnteredCustom = function( self )
			bgrEffect:SetImageColor( Color ( 170, 180, 190, 120 ) )
		end
	end
	RefreshButton.DoClick = function()
		SCP294Client.drinkDATA = {}
		if ( #pnl.loadButtons > 0 ) then 
			for k, v in pairs ( pnl.loadButtons ) do 
				v:Remove() 
				pnl.loadButtons[k] = nil 
			end  
		end
		SCP294Client.requestAllServerDATAIndividually()
	end	

	ExitMenu:SetText( "EXIT" )
	ExitMenu:SetPos( 990, 420 )
	ExitMenu:SetSize( 200, 200 )
	ExitMenu:SetTexture( "scp_294_redux/cancel_no_circle.png" )
	if ( SCP294Client.haveMaterials ) then
		ExitMenu.OnCursorExitedCustom = function( self )
			bgrEffect:SetImageColor( Color ( 0, 0, 0, 0 ) )
		end
		ExitMenu.OnCursorEnteredCustom = function( self )
			bgrEffect:SetImageColor( Color ( 170, 50, 50, 120 ) )
		end
	end
	ExitMenu.DoClick = function()
		SCP294Client.openMainMenu()
	end	
	
end



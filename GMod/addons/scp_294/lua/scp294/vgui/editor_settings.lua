-- [[ Drink settings vgui ]] --


local allDLabel = {}
allDLabel[1] = { text = "Flavour Name", x = 30, y = 75 }
allDLabel[2] = { text = "Flavour Description", x = 30, y = 135 }
allDLabel[3] = { text = "Flavour Color", x = 30, y = 195 }

-- Open the settings menu
function SCP294Client.openDrinkEditor( data )
	SCP294Client.lastMenuLoad = nil
	
	-- Remove the old DFrame
	if ( SCP294Client.DFrame ) then
		if ( ispanel( SCP294Client.DFrame ) ) then
			if ( SCP294Client.DFrame.keyName ) then
				if ( SCP294Client.DFrame.keyName == "Load" ) then
					SCP294Client.lastMenuLoad = true
				end
			end
			SCP294Client.DFrame:Remove()
		end
	end
	
	-- Create the new DFrame
	SCP294Client.DFrame = vgui.Create( "SCP294RSettingsMenu" )
	
	-- Load or create the drink data
	local defaultDrinkSettings = {
		drinkName = "default name",
		drinkDescription = "Default Description",
		drinkColor = Color( 255, 255, 255 ),
		drinkSound = "normal",
		creationSound = "normal",
		selectedMethod = {}
	}
	
	SCP294Client.selectedDrinkData = ( data or defaultDrinkSettings )
	local data = SCP294Client.selectedDrinkData
	local pnl = SCP294Client.DFrame
	local allMethod = SCP294Shared.methodList
	
	pnl.keyName = "Editor"
	pnl.textEntry = {} -- Register all the temporary button we need to remove
	pnl:SetSize( 1280, 720 )
	if ( SCP294Client.haveMaterials ) then
		pnl:SetCustomTitle( "SCP 294 Editor - SETTINGS" )
	else
		pnl:SetCustomTitle( "SCP 294 Editor" )
	end
	pnl:SetBackgroundColor( Color( 35, 110, 32 ) )
	pnl:SetDraggable( true )
	pnl:MakePopup()
	pnl:Center()
	
	for k , v in pairs ( allDLabel ) do
		local DLabel = vgui.Create( "DLabel", pnl )
		DLabel:SetPos( v.x, v.y )
		DLabel:SetSize( 200, 50 )
		DLabel:SetText( v.text )
	end
	
	-- The drink name
	local drinkName = vgui.Create( "DTextEntry", pnl )
	-- What does it print in chat when the player drink it
	local drinkDescription = vgui.Create( "DTextEntry", pnl )
	-- What color does the liquid have
	local drinkColor = vgui.Create( "DColorMixer", pnl )
	-- Visual help to explain what the method does
	local methodDescription = vgui.Create( "DLabel", pnl )
	-- Visual help to see if the flavour already exist
	local drinkCheck = vgui.Create( "DLabel", pnl )	
	-- Save the drink settings and back to main menu
	local saveButton = vgui.Create( "SCP294RSettingsButton", pnl )
	-- Remove the drink
	local removeButton = vgui.Create( "SCP294RSettingsButton", pnl )
	-- Return to main menu
	local exitButton = vgui.Create( "SCP294RSettingsButton", pnl )
	-- Which sound the player emit when drink the flavour
	local drinkSound = vgui.Create( "DComboBox", pnl )
	-- Which sound the SCP 294 emit when creating the flavour
	local creationSound = vgui.Create( "DComboBox", pnl )
	-- Scroll panel for method list
	local methodScoll = vgui.Create( "DScrollPanel", pnl )
	methodScoll:SetPos( 350, 110 )
	if ( SCP294Client.haveMaterials ) then  
		methodScoll:SetSize( 303, 560 )
	else
		methodScoll:SetSize( 240, 560 )
	end
	
	-- Set methodScoll paint function
	local sbar = methodScoll:GetVBar()
	function sbar:Paint( w, h )	end
	function sbar.btnUp:Paint( w, h ) end
	function sbar.btnDown:Paint( w, h )	end
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 10 ) )
	end
	
	-- Scroll panel for the entry list
	pnl.DScrollEntry = vgui.Create( "DScrollPanel", pnl )
	pnl.DScrollEntry:SetPos( 700, 110 )
	pnl.DScrollEntry:SetSize( 400, 425 )

	-- Completely dumb but i prefer to don't touch it , because i'm at the end of the project
	pnl.helpFrame = methodDescription

	-- Set DTextEntry frame
	drinkName:SetPos( 25, 110 )
	drinkName:SetSize( 250, 35 )
	drinkName:SetText( data.drinkName )
	drinkName:SetUpdateOnType( true )
	if ( SCP294Client.lastMenuLoad ) then
		drinkName:SetDisabled( true )
	end
	drinkName.OnValueChange = function( self, str )
		SCP294Client.DFrame:SetModification( true )
	end
	
	-- Set DTextEntry frame
	drinkDescription:SetPos( 25, 170 )
	drinkDescription:SetSize( 250, 35 )
	drinkDescription:SetText( data.drinkDescription )
	drinkDescription:SetUpdateOnType( true )
	drinkDescription.OnValueChange = function( self, str )
		SCP294Client.selectedDrinkData.drinkDescription = str
		SCP294Client.DFrame:SetModification( true )	
	end
	
	-- Set DColorMixer frame
	drinkColor:SetPos( 25, 230 )
	drinkColor:SetSize( 250, 150 ) 
	drinkColor:SetPalette( false )
	drinkColor:SetAlphaBar( true )
	drinkColor:SetWangs( true )
	drinkColor:SetColor( data.drinkColor )
	drinkColor.ValueChanged = function( self, col )
		SCP294Client.DFrame:SetModification( true )
	end
	
	-- Set DLabel frame
	methodDescription:SetPos( 325, 685 )
	methodDescription:SetSize( 900, 100 )
	methodDescription:SetFont( "scpMenuFontLittle" )
	methodDescription:SetColor( Color( 255, 255, 255 ) )
	methodDescription:SetContentAlignment( 7 )
	methodDescription:SetText( "" )	
	
	-- Set DLabel frame
	drinkCheck:SetPos( 175, 93 )
	drinkCheck:SetSize( 100, 20 )
	drinkCheck:SetFont( "scpMenuFontLittle" )
	drinkCheck:SetColor( Color( 255, 255, 255 ) )
	drinkCheck:SetContentAlignment( 6 )
	drinkCheck:SetText( "don't exist" )
	drinkCheck:SetTextColor( Color( 255, 0, 0 ) )
	if ( SCP294Client.drinkDATA[drinkName:GetValue()] ) then
		drinkCheck:SetText( "exist" )
		drinkCheck:SetTextColor( Color( 0, 255, 0 ) )
	end
	
	drinkCheck.Think = function( self )
		if ( SCP294Client.drinkDATA[drinkName:GetValue()] ) then
			if ( self:GetText() ~= "exist" ) then
				self:SetText( "exist" )
				drinkCheck:SetTextColor( Color( 0, 255, 0 ) )
			end
		else
			if ( self:GetText() ~= "don't exist" ) then
				self:SetText( "don't exist" )
				drinkCheck:SetTextColor( Color( 255, 0, 0 ) )
			end
		end
	end
	
	drinkSound:SetPos( 25, 400 )
	drinkSound:SetSize( 250, 35 )
	drinkSound:SetValue( data.drinkSound )
	drinkSound:AddChoice( "normal" )
	drinkSound:AddChoice( "spit" )
	drinkSound:AddChoice( "good" )
	drinkSound:AddChoice( "cough" )
	drinkSound:AddChoice( "burn" )
	drinkSound:AddChoice( "beurk" )
	drinkSound.OnSelect = function( panel, index, value )
		surface.PlaySound( "scp_294_redux/drink/" .. value .. ".wav" )
		SCP294Client.DFrame:SetModification( true )	
	end

	creationSound:SetPos( 25, 450 )
	creationSound:SetSize( 250, 35 )
	creationSound:SetValue( data.creationSound )
	creationSound:AddChoice( "normal" )
	creationSound:AddChoice( "long" )
	creationSound:AddChoice( "insane" )
	creationSound.OnSelect = function( panel, index, value )
		surface.PlaySound( "scp_294_redux/dispense/" .. value .. ".wav" )
		SCP294Client.DFrame:SetModification( true )	
	end
	
	-- Set saveButton frame
	saveButton:SetPos( 25, 500 )
	saveButton:SetSize( 250, 35 )
	saveButton:SetText( "Save" )
	saveButton.DoClick = function( self )
		SCP294Client.selectedDrinkData.drinkName = string.lower( drinkName:GetText() )
		SCP294Client.selectedDrinkData.drinkColor = drinkColor:GetColor()
		SCP294Client.selectedDrinkData.drinkSound = drinkSound:GetValue()
		SCP294Client.selectedDrinkData.creationSound = creationSound:GetValue()
		SCP294Client.submitDrinkDATA( SCP294Client.selectedDrinkData )
		SCP294Client.DFrame:SetModification( true )	
		SCP294Client.openMainMenu()
	end	
	
	-- Set removButton frame
	removeButton:SetPos( 25, 550 )
	removeButton:SetSize( 250, 35 )
	removeButton:SetText( "Remove" )
	removeButton.areYouSure = false
	removeButton.DoClick = function( self )
		if not ( removeButton.areYouSure ) then
			self:SetText( "Press again to confirm" )
			surface.PlaySound( "buttons/button16.wav" )
			removeButton.areYouSure = true
		else
			SCP294Client.requestRemoveDrink( drinkName:GetValue() )
			SCP294Client.openMainMenu()
		end
	end
	
	-- Set exitButton frame
	exitButton:SetPos( 25, 600 )
	exitButton:SetSize( 250, 35 )
	exitButton:SetText( "Exit" )
	exitButton.areYouSure = false
	exitButton.DoClick = function( self )
		if ( SCP294Client.DFrame.modificationDone ) then
			if not ( self.areYouSure ) then
				self.areYouSure = true
				self:SetText( "Exit without saving ?" )
			else
				if ( SCP294Client.drinkDATA[drinkName:GetValue()] ) then
					SCP294Client.requestDrink( drinkName:GetValue() )
				end
				if ( SCP294Client.lastMenuLoad ) then
					SCP294Client.openLoadMenu()
					SCP294Client.lastMenuLoad = nil
				else
					SCP294Client.openMainMenu()
				end
			end
		else
			if ( SCP294Client.lastMenuLoad ) then
				SCP294Client.openLoadMenu()
				SCP294Client.lastMenuLoad = nil
			else
				SCP294Client.openMainMenu()
			end
		end
	end
	
	local y = 0
	-- Create buttons for each method availaible
	for key, value in pairs ( SCP294Shared.methodListOrder ) do
		local methodDATA = SCP294Shared.methodList[value]
		SCP294Client.createMethodButton( value, methodDATA, y, methodScoll )
		y = y + 40
	end	
	
end
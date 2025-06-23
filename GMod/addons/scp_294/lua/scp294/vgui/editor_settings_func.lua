-- [[ Drink settings vgui ]] --

function SCP294Client.createMethodButton( key, value, y, panel )
	if ( not SCP294Client.selectedDrinkData[key] ) then
	
		local methodButton = vgui.Create( "SCP294RSettingsButton", panel )
		local infoButton = vgui.Create( "DImageButton", panel )
		local verifyImage = vgui.Create( "DImage", panel )
		
		-- Create the button to select the method you want to add or remove from the drink
		methodButton:SetPos( 0, y )
		methodButton:SetSize( 200, 35 )
		methodButton:SetText( value.name or key )
		methodButton.keyMethod = key
		methodButton.DoClick = function( self )
			surface.PlaySound( "buttons/button3.wav" )
			self:SetPressEffect( 3 )
			local data = ( SCP294Client.selectedDrinkData.selectedMethod[self.keyMethod] or {} )
			SCP294Client.setDrinkEntry( self.keyMethod, data )
		end
		-- Create the button that show the description of the method selected ( Link to methodDescription )
		if ( SCP294Client.haveMaterials ) then
			infoButton:SetPos( 205, y )
			infoButton:SetSize( 35, 35 )
			infoButton:SetImage( "scp_294_redux/info.png" )
		else
			infoButton:SetPos( 202, y )
			infoButton:SetSize( 16, 16 )
			infoButton:SetImage( "icon16/help.png" )
		end
		infoButton.keyMethod = key
		infoButton.DoClick = function( self )
			surface.PlaySound( "buttons/button17.wav" )
			SCP294Client.DFrame.helpFrame:SetText( "[ Method : " .. self.keyMethod .. " ] : " .. SCP294Shared.methodList[self.keyMethod].description )
		end
			
		-- Create a visual signal to show if the method is selected in the drink
		if ( SCP294Client.haveMaterials ) then
			verifyImage.validImage = "scp_294_redux/check_valid.png"
			verifyImage.invalidImage = "scp_294_redux/check_not_valid.png"
			verifyImage:SetPos( 245, y )
			verifyImage:SetSize( 35, 35 )
			verifyImage:SetImage( verifyImage.invalidImage )
		else
			verifyImage.validImage = "icon16/tick.png"
			verifyImage.invalidImage = "icon16/cross.png"
			verifyImage:SetPos( 202, y+20 )
			verifyImage:SetSize( 16, 16 )
			verifyImage:SetImage( verifyImage.invalidImage )
		end
		verifyImage.selected = false
		verifyImage.keyMethod = key
		verifyImage.Think = function( self )
			if ( SCP294Client.selectedDrinkData.selectedMethod[verifyImage.keyMethod] and not self.selected ) then
				verifyImage:SetImage( self.validImage )
				self.selected = true
			elseif ( not SCP294Client.selectedDrinkData.selectedMethod[verifyImage.keyMethod] and self.selected ) then
				verifyImage:SetImage( self.invalidImage )
				self.selected = false
			end
		end
		
	end 
end


function SCP294Client.setDrinkEntry( key, data )
	local DFrame = SCP294Client.DFrame

	-- Check if our panel is settings mode
	if ( DFrame.keyName ~= "Editor" ) then return end
	local methodDATA = SCP294Shared.methodList[key]
	local methodKey = key
	local save = data
		
	-- Check if there's already settings entry
	if ( #DFrame.textEntry > 0 ) then
		-- Delete all the obselete textEntry
		for k, pnl in pairs ( DFrame.textEntry ) do
			pnl:Remove()
			DFrame.textEntry[k] = nil -- clear the table
		end 
	end

	-- Hey did you know pikachu was a pokemon ?
	-- Shut up and focus
	local y = 0
	local parentTo = ( DFrame.DScrollEntry or DFrame )
	for argKey, argumentDATA in pairs ( methodDATA.arguments ) do
		local methodButton
		
		local argumentName = vgui.Create( "DLabel", parentTo )
		local infoButton = vgui.Create( "DImageButton", parentTo )
		
		argumentName:SetPos( 0, y )
		argumentName:SetSize( 120, 35 )
		argumentName:SetFont( "scpMenuFontLittle" )
		argumentName:SetText( argKey )
		argumentName:SetContentAlignment( 4 )
		
		infoButton:SetPos( 335, y )
		infoButton:SetSize( 35, 35 )
		infoButton:SetImage( "scp_294_redux/info.png" )
		infoButton.DoClick = function( self )
			surface.PlaySound( "buttons/button17.wav" )
			DFrame.helpFrame:SetText( "[ Argument : " .. argKey .. " ] : " .. argumentDATA.description )
		end
		
		table.insert( DFrame.textEntry, argumentName )
		table.insert( DFrame.textEntry, infoButton )
		
		if ( argumentDATA.type == "boolean" ) then
			defaultValue = argumentDATA.default or false
			
			methodButton = vgui.Create( "DCheckBox", parentTo )
			methodButton:SetPos( 130, y )
			methodButton:SetSize( 35, 35 )
			methodButton:SetValue( save[argKey] or defaultValue )
			methodButton.argKey = argKey
			methodButton.entryType = "DCheckBox"
			methodButton.OnChange = function( self, bVal )
				if ( SCP294Client.selectedDrinkData.selectedMethod[key] ) then
					SCP294Client.selectedDrinkData.selectedMethod[key][self.argKey] = self:GetChecked()
					surface.PlaySound( "buttons/button14.wav" )
					SCP294Client.DFrame:SetModification( true )
				end
			end
			y = y + 40
		elseif ( argumentDATA.type == "color" ) then
			local defaultValue = ( argumentDATA.default or Color( 255, 255, 255, 255 ) )
			
			methodButton = vgui.Create( "DColorMixer", parentTo )
			methodButton:SetPos( 130, y )
			methodButton:SetSize( 200, 100 )
			methodButton:SetColor( save[argKey] or defaultValue )
			methodButton:SetPalette( false )
			methodButton.argKey = argKey
			methodButton.entryType = "DColorMixer"
			methodButton.ValueChanged = function( self, bVal )
				if ( SCP294Client.selectedDrinkData.selectedMethod[key] ) then
					SCP294Client.selectedDrinkData.selectedMethod[key][self.argKey] = bVal
					SCP294Client.DFrame:SetModification( true )
				end
			end
			y = y + 105
		else
			local defaultValue
			if ( argumentDATA.type == "number" ) then
				defaultValue = argumentDATA.default or 0
			else
				defaultValue = argumentDATA.default or "NULL"
			end
	
			methodButton = vgui.Create( "DTextEntry", parentTo )
			methodButton:SetPos( 130, y )
			methodButton:SetSize( 200, 35 )
			methodButton:SetText( save[argKey] or defaultValue ) 
			methodButton:SetUpdateOnType( true )
			methodButton.argKey = argKey
			methodButton.valid = true
			methodButton.entryType = "DTextEntry"
			methodButton.valueType = "string"
			
			-- Check if the argument type is a number
			if ( argumentDATA.type == "number" ) then
				methodButton.valueType = "number"
			end
			
			methodButton.OnValueChange = function( self )
				-- If the value needed is a number
				if ( argumentDATA.type == "number" ) then
					-- Check if the text value can be converted into a number
					local checkNum = tonumber( self:GetValue(), 10 )
					-- Check the result
					if ( checkNum ) then
						self:SetTextColor( Color( 0, 0, 0 ) )
						if ( argumentDATA.min ) then
							if ( tonumber( self:GetValue() ) < argumentDATA.min ) then
								self:SetTextColor( Color( 255, 0, 0 ) )
							end
						end
						if ( argumentDATA.max ) then
							if ( tonumber( self:GetValue() ) > argumentDATA.max ) then
								self:SetTextColor( Color( 255, 0, 0 ) )
							end
						end
					
						if ( not self.valid ) then
							self.valid = true
							surface.PlaySound( "buttons/button9.wav" )
						end
						-- Update the value if the method is selected
						if ( SCP294Client.selectedDrinkData.selectedMethod[key] ) then
							SCP294Client.selectedDrinkData.selectedMethod[key][self.argKey] = tonumber( self:GetValue() )
							surface.PlaySound( "buttons/button14.wav" )
							SCP294Client.DFrame:SetModification( true )	
						end
					else
						self:SetTextColor( Color( 255, 0, 0 ) )
						if ( self.valid ) then
							surface.PlaySound( "buttons/button11.wav" )
							self.valid = false
						end
					end
				else
					if ( SCP294Client.selectedDrinkData.selectedMethod[key] ) then
						SCP294Client.selectedDrinkData.selectedMethod[key][self.argKey] = self:GetValue()
						surface.PlaySound( "buttons/button14.wav" )
						SCP294Client.DFrame:SetModification( true )	
					end
				end
			end
			
			y = y + 40 -- Set the y position of the next button
		end
		table.insert( DFrame.textEntry, methodButton ) 
	end 

	local parentTo = ( DFrame.DScrollEntry or DFrame )
	-- Add method to the drink
	local addButton = vgui.Create( "SCP294RSettingsButton", parentTo )
	addButton:SetPos( 0, y )
	addButton:SetSize( 330, 35 )
	addButton:SetText( "Add : " .. key )
	addButton.keyMethod = key
	
	-- Check if the method is already selected
	if ( SCP294Client.selectedDrinkData.selectedMethod[key] ) then
		-- Set the button text to 'remove mode'
		addButton:SetText( "Remove : " .. key )
	end
	
	addButton.DoClick = function( self )
		-- Check if the method is already register in the drink DATA
		if ( SCP294Client.selectedDrinkData.selectedMethod[key] ) then
			-- If it's already register then remove it from the drink DATA
			SCP294Client.selectedDrinkData.selectedMethod[key] = nil
			-- Reset the button text to 'add method'
			addButton:SetText( "Add : " .. key )
		else
			-- Create a empty table with method key to store all arguments in it
			SCP294Client.selectedDrinkData.selectedMethod[key] = {}		
			for k, v in pairs ( DFrame.textEntry ) do
				-- Check if the Panel get an argument key
				if ( v.argKey ) then
					-- Check if the argument need to be boolean or not
					if ( v.entryType == "DCheckBox" ) then
						SCP294Client.selectedDrinkData.selectedMethod[key][v.argKey] = v:GetChecked()
					elseif ( v.entryType == "DColorMixer" ) then
						SCP294Client.selectedDrinkData.selectedMethod[key][v.argKey] = v:GetColor()
					else
						local value = v:GetValue()
						-- Check if the argument need to be a number or not
						if ( v.valueType == "number" ) then
							-- Convert it to number
							value = tonumber( v:GetValue() )
						end
						SCP294Client.selectedDrinkData.selectedMethod[key][v.argKey] = value
					end
				end 
			end
			-- Switch the button text to 'remove method'
			addButton:SetText( "Remove : " .. key )
		end
		surface.PlaySound( "buttons/button3.wav" )
		self:SetPressEffect( 3 )
		SCP294Client.DFrame:SetModification( true )
	end
	table.insert( DFrame.textEntry, addButton )
end 


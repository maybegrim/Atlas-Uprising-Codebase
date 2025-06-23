

local function createButton( str, x, y )
	local button = vgui.Create( "DButton", SCP294Client.keyboardFrame )
	button:SetText( str )
	button:SetPos( math.Round( (x/100)*ScrW() ), math.Round( (y/100)*ScrH() ) )
	button:SetTextColor( Color( 255, 255, 255 ) )
	if ( str == "spaceBar" ) then
		button:SetSize( ScrW()*0.457, ScrH()*0.07 )
	else
		button:SetSize( ScrW()*0.04, ScrH()*0.07 )
	end
	button.DoClick = function( self )
		surface.PlaySound("scp_294_redux/beep.wav")
		if ( self:GetText() == "spaceBar" )  then
			SCP294Client.keyboardFrame.flavour = SCP294Client.keyboardFrame.flavour .. " "
		elseif ( self:GetText() == "back" )  then
			SCP294Client.keyboardFrame.flavour = string.sub( SCP294Client.keyboardFrame.flavour, 0, #SCP294Client.keyboardFrame.flavour-1 )
		elseif ( self:GetText() == "enter" )  then
			SCP294Client.useSCP294( SCP294Client.keyboardFrame.flavour )
		else
			SCP294Client.keyboardFrame.flavour = SCP294Client.keyboardFrame.flavour .. str
		end
	end
	button.Paint = function( self, w, h )
		return true
	end
end 

local buttons = {}
buttons["1"] = { x = 26, y = 41 }
buttons["q"] = { x = 26, y = 49.5 }
buttons["a"] = { x = 26, y = 58 }
buttons["z"] = { x = 26, y = 66 }
buttons["2"] = { x = 30.5, y = 41 }
buttons["w"] = { x = 30.5, y = 49.5 }
buttons["s"] = { x = 30.5, y = 58 }
buttons["x"] = { x = 30.5, y = 66 }
buttons["3"] = { x = 35.4, y = 41 }
buttons["e"] = { x = 35.4, y = 49.5 }
buttons["d"] = { x = 35.4, y = 58 }
buttons["c"] = { x = 35.4, y = 66 }
buttons["4"] = { x = 40, y = 41 }
buttons["r"] = { x = 40, y = 49.5 }
buttons["f"] = { x = 40, y = 58 }
buttons["v"] = { x = 40, y = 66 }
buttons["5"] = { x = 44.6, y = 41 }
buttons["t"] = { x = 44.6, y = 49.5 }
buttons["g"] = { x = 44.6, y = 58 }
buttons["b"] = { x = 44.6, y = 66 }
buttons["6"] = { x = 49.1, y = 41 } 
buttons["y"] = { x = 49.1, y = 49.5 }
buttons["h"] = { x = 49.1, y = 58 }
buttons["n"] = { x = 49.1, y = 66 }
buttons["7"] = { x = 53.8, y = 41 } 
buttons["u"] = { x = 53.8, y = 49.5 }
buttons["j"] = { x = 53.8, y = 58 }
buttons["m"] = { x = 53.8, y = 66 }
buttons["8"] = { x = 58.5, y = 41 } 
buttons["i"] = { x = 58.5, y = 49.5 }
buttons["k"] = { x = 58.5, y = 58 }
buttons["-"] = { x = 58.5, y = 66 }
buttons["9"] = { x = 63, y = 41 } 
buttons["o"] = { x = 63, y = 49.5 }
buttons["l"] = { x = 63, y = 58 }
buttons["0"] = { x = 67.7, y = 41 } 
buttons["p"] = { x = 67.7, y = 49.5 }
buttons["enter"] = { x = 67.7, y = 58 }
buttons["back"] = { x = 67.7, y = 66 }
buttons["spaceBar"] = { x = 26, y = 73.8 }


function SCP294Client.openKeyboard()
	
	if ( SCP294Client.keyboardFrame ) then
		if ( ispanel( SCP294Client.keyboardFrame ) ) then
			SCP294Client.keyboardFrame:Remove()
		end
	end
	
	if ( file.Exists( "materials/scp_294_redux/keyboard.png", "GAME" ) ) then
		if ( GetConVar( "scp294_keyboardMode" ):GetString() == "1" ) then 
			SCP294Client.openKeyboardNoTexture()
			return
		end
		
		SCP294Client.keyboardFrame = vgui.Create( "DFrame" )
		local frm = SCP294Client.keyboardFrame
		frm:SetScreenLock( true )
		frm:SetPos( 0, 0 )
		frm:SetSize( ScrW(), ScrH() )
		frm:SetTitle( "" )
		frm:SetDraggable( false )
		frm:MakePopup()
		frm.flavour = ""
		frm.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Material("materials/scp_294_redux/keyboard.png") )
			surface.DrawTexturedRect( 0, 0, w, h )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( ScrW() * 0.2 - 2, 73, ScrW() * 0.6 + 4, 74 )
			local col = 40 + math.abs( math.sin( CurTime() ) * 15 )
			surface.SetDrawColor( col, col, col, 255 )
			surface.DrawRect( ScrW() * 0.2, 75, ScrW() * 0.6, 70 )
			surface.SetFont( "scpMenuFont" )
			local sizeX, sizeY = surface.GetTextSize( string.upper( self.flavour ) )
			local px, py = self:LocalToScreen( 0, 0 )

			render.SetScissorRect( px + ( ScrW() * 0.2 ), py + 73, px + ( ScrW() * 0.2 ) + ( ScrW() * 0.6 ), py + 73 + 74, true )
				draw.SimpleText( string.upper( self.flavour ), "scpMenuFont", ScrW() * 0.2 + 20, 110, Color( 255, 255, 255, 255 ), 0, 1 )
				surface.SetDrawColor( 255, 255, 255, math.abs( math.sin( CurTime() * 2 ) * 255 ) )
				surface.DrawRect( ScrW() * 0.2 + 20 + sizeX, 93, 25, 34 )
			render.SetScissorRect( 0, 0, 0, 0, false )
		end
		
		TextEntry = vgui.Create( "DTextEntry", frm )
		TextEntry:SetPos( 25, 50 )
		TextEntry:SetSize( 75, 85 )
		TextEntry:SetText( "" )
		TextEntry:SetUpdateOnType( true )
		TextEntry:RequestFocus()
		
		TextEntry.Paint = function( self )
			if not ( self:HasFocus() ) then
				self:RequestFocus()
			end
			return true
		end
		TextEntry.OnKeyCodeTyped = function( self, value )
			if ( value == 66 ) then
				frm.flavour = string.sub( frm.flavour, 0, #frm.flavour-1 )
			elseif ( value == 64 ) then
				SCP294Client.useSCP294( frm.flavour )
				frm:Remove()
			end
			surface.PlaySound("scp_294_redux/beep.wav")
		end
		TextEntry.OnValueChange = function( self, value )
			local value = string.lower( value )
			if ( value == " " ) then
				frm.flavour = frm.flavour .. " "
			elseif ( buttons[value] ) then
				frm.flavour = frm.flavour .. value
			end
			self:SetText( "" )
			surface.PlaySound("scp_294_redux/beep.wav")
		end
		
		for k , v in pairs ( buttons ) do
			createButton( k, v.x, v.y )
		end
	else
		SCP294Client.openKeyboardNoTexture()
	end

end
-- Litterraly shit code but it work i guess :))) 

function SCP294Client.openKeyboardNoTexture()

	local buttons = {}
	buttons["1"] = { x = 50, y = 150 }
	buttons["q"] = { x = 50, y = 210}
	buttons["a"] = { x = 50, y = 270 }
	buttons["z"] = { x = 50, y = 330 }
	
	buttons["2"] = { x = 110, y = 150 }
	buttons["w"] = { x = 110, y = 210 }
	buttons["s"] = { x = 110, y = 270 }
	buttons["x"] = { x = 110, y = 330 }

	buttons["3"] = { x = 170, y = 150 }
	buttons["e"] = { x = 170, y = 210 }
	buttons["d"] = { x = 170, y = 270 }
	buttons["c"] = { x = 170, y = 330 }
	
	buttons["4"] = { x = 230, y = 150 }
	buttons["r"] = { x = 230, y = 210 }
	buttons["f"] = { x = 230, y = 270 }
	buttons["v"] = { x = 230, y = 330 }
	
	buttons["5"] = { x = 290, y = 150 }
	buttons["t"] = { x = 290, y = 210 }
	buttons["g"] = { x = 290, y = 270 }
	buttons["b"] = { x = 290, y = 330 }
	
	buttons["6"] = { x = 350, y = 150 } 
	buttons["y"] = { x = 350, y = 210 }
	buttons["h"] = { x = 350, y = 270 }
	buttons["n"] = { x = 350, y = 330 }
	
	buttons["7"] = { x = 410, y = 150 } 
	buttons["u"] = { x = 410, y = 210 }
	buttons["j"] = { x = 410, y = 270 }
	buttons["m"] = { x = 410, y = 330 }
	
	buttons["8"] = { x = 470, y = 150 } 
	buttons["i"] = { x = 470, y = 210 }
	buttons["k"] = { x = 470, y = 270 }
	buttons["-"] = { x = 470, y = 330 }
	
	buttons["9"] = { x = 530, y = 150 } 
	buttons["o"] = { x = 530, y = 210 }
	buttons["l"] = { x = 530, y = 270 }
	buttons[" "] = { x = 530, y = 330 }
	
	buttons["0"] = { x = 590, y = 150 } 
	buttons["p"] = { x = 590, y = 210 }
	buttons["OK"] = { x = 590, y = 270 }
	buttons["<-"] = { x = 590, y = 330 }
	
	buttons["___"] = { x = 50, y = 400 }

	SCP294Client.keyboardFrame = vgui.Create( "DFrame" )
	local frm = SCP294Client.keyboardFrame
	frm:SetScreenLock( true )
	frm:SetPos( 0, 0 )
	frm:SetSize( 700, 475 )
	frm:SetTitle( "" )
	frm:SetDraggable( true )
	frm:ShowCloseButton( false )
	frm:MakePopup()
	frm:Center()
	frm.flavour = ""

	frm.Paint = function( self, w, h )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, w, h )
		local col = 50 + math.abs( math.sin( CurTime() ) * 5 )
		surface.SetDrawColor( col, col, col, 255 )
		surface.DrawRect( 1, 1, w-2, h-2 )
		surface.SetDrawColor( 50, 50, 150, 120 )
		surface.DrawRect( 1, 1, w-2, 50 )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 1, 50, 700, 1 )

		surface.SetDrawColor( 220, 220, 220, 255 )
		surface.DrawRect( 50 -1, 75-1, 590+2, 50+2 )
		surface.SetDrawColor( 15, 20, 25, 255 )
		surface.DrawRect( 50, 75, 590, 50 )
		
		local redCol = 150 + math.abs( math.sin( CurTime() *2 ) * 100 )
		local px, py = self:LocalToScreen( 0, 0 )

		surface.SetFont( "scpMenuFont" )
		local sizeX, sizeY = surface.GetTextSize( string.upper( self.flavour ) )
		
		surface.SetFont( "scpMenuFontLittle" )
		local sizeLittleX, sizeLittleY = surface.GetTextSize( string.upper( self.flavour ) )
		
		render.SetScissorRect( px + 50, py + 75, px + 640, py + 125, true )
			if ( sizeLittleX > 590 ) then
				draw.SimpleText( string.upper( self.flavour ), "scpMenuFontLittle", 75 - math.abs( math.cos( CurTime() ) * ( ( sizeLittleX + 50)- 590 ) ), 100, Color( 255, 255, 255, 255 ), 0, 1 )
			elseif ( sizeX > 590 ) then
				draw.SimpleText( string.upper( self.flavour ), "scpMenuFontLittle", 55, 100, Color( 255, 255, 255, 255 ), 0, 1 )
			else
				draw.SimpleText( string.upper( self.flavour ), "scpMenuFont", 55, 100, Color( 255, 255, 255, 255 ), 0, 1 )
				surface.SetDrawColor( 255, 255, 255, math.abs( math.sin( CurTime() * 2 ) * 255 ) )
				surface.DrawRect( 55 + sizeX, 100 - sizeY / 2, 20, sizeY )
			end
		render.SetScissorRect( 0, 0, 0, 0, false )
		
		draw.SimpleText( "SCP 294 Keyboard", "scpMenuFont", 15, 25, Color( 255, 255, 255, 255 ), 0, 1 )
		if not ( SCP294Client.haveMaterials ) then
			draw.SimpleText( "Texture are missing, please download the addon", "scpMenuFontLittle", 580, 25, Color( redCol, 0, 0, 255 ), 2, 1 )
		end
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
	
	local button = vgui.Create( "DButton", frm )
	button:SetText( "x" )
	button:SetPos( 650, 1 )
	button:SetSize( 49, 49 )
	button.Paint = function( self, w, h )
		draw.SimpleText( "X", "scpMenuFont", 24.5, 24.5, Color( 255, 255, 255, 255 ), 1, 1 )
		return true
	end
	button.DoClick = function( self )
		self:GetParent():Remove()
	end

	for k , v in pairs ( buttons ) do
		local button = vgui.Create( "DButton", frm )
		button:SetText( k )
		button:SetPos( v.x, v.y )
		button.pressedEffect = 0
		if ( k == "___" ) then
			button:SetSize( 590, 50 )
		else
			button:SetSize( 50, 50 )
		end
		
		button.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			local realX, realY = button.pressedEffect, button.pressedEffect
			
			if ( button.pressedEffect > 0 ) then
				button.pressedEffect = math.Clamp( button.pressedEffect - ( 40 * RealFrameTime() ), 0, 9999 )
			end
			
			surface.DrawRect( realX, realY, w - realX*2, h - realY*2 )
			if ( self:IsHovered() ) then
				local col = math.abs( math.sin( CurTime() * 3 ) * 50 )
				surface.SetDrawColor( 120 + col, 130 + col, 140 + col, 255 )
				surface.DrawRect( realX + 2, realX + 2, w-(realX*2)-4, h-(realX*2)-4 )
			else
				surface.SetDrawColor( 120, 130, 140, 255 )
				surface.DrawRect( 2, 2, w-4, h-4 )
				
				surface.SetDrawColor( 105, 120, 130, 255 )
				surface.DrawRect( 6, 6, w-12, h-12 )
			end
			draw.SimpleText( string.upper( self:GetText() ), "scpMenuFont", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1 )
			return true
		end
		
		if ( k == "___" ) then
			button.DoClick = function( self )
				surface.PlaySound("scp_294_redux/beep.wav")
				frm.flavour = frm.flavour .. " "
				button.pressedEffect = 3
			end
		elseif ( k == "<-" ) then
			button.DoClick = function( self )
				surface.PlaySound("scp_294_redux/beep.wav")
				frm.flavour = string.sub( frm.flavour, 0, #frm.flavour-1 )
				button.pressedEffect = 3
			end
		elseif ( k == "OK" ) then
			button.DoClick = function( self )
				SCP294Client.useSCP294( frm.flavour )
				button.pressedEffect = 3
				frm:Remove()
			end
		else
			button.DoClick = function( self )
				surface.PlaySound("scp_294_redux/beep.wav")
				frm.flavour = frm.flavour .. k
				button.pressedEffect = 3
			end
		end

	end
end
local PANEL = {}

function PANEL:Init()
	self:SetSize( 200, 60 )
	self.previewCol = Color( 255, 0, 0 )
	self.textX = 0
end

function PANEL:SetPreviewColor( col )
	self.previewCol = col
end

function PANEL:Paint( w, h )
	if ( self:IsHovered() ) then
		draw.RoundedBox( 5, 0, 0, w, h, Color( 136, 193, 255 ) )
		draw.RoundedBox( 5, 3, 3, w - 6, h- 6, Color( 221, 224, 238 ) )
		draw.RoundedBox( 5, 3, 3, 55, h- 6, self.previewCol )
		self:SetTextColor( Color( 240, 240, 240 ) )
		
		surface.SetFont( "scpMenuFont" )
		local width, height = surface.GetTextSize(self:GetText() )
		if ( width > 120 ) then
			self.textX = self.textX + ( 115  * RealFrameTime() )
			if ( self.textX > width ) then
				self.textX = -width
			end
			
			local px, py = self:GetParent():LocalToScreen( 0, 0 )
			local sx, sy = self:GetPos() 
			local realX, realY = px + sx, py + sy
			
			render.SetScissorRect( realX + 60, realY, realX + 220, realY + 50, true )
				draw.SimpleText( self:GetText(), "scpMenuFont", 65 - self.textX, h/2, Color( 0, 0, 0, 255 ), 0, 1 )
			render.SetScissorRect( 0, 0, 0, 0, false )
		else
			draw.SimpleText( self:GetText(), "scpMenuFont", 65, h/2, Color( 0, 0, 0, 255 ), 0, 1 )
		end
	else
		if ( self.textX ~= 0 ) then
			self.textX = 0
		end
		draw.RoundedBox( 5, 0, 0, w, h, Color( 221, 224, 238 ) )
		draw.RoundedBox( 5, 1, 1, w - 2, h- 2, Color( 155, 158, 175 ) )
		draw.RoundedBox( 5, 3, 3, 55, h- 6, Color( self.previewCol.r, self.previewCol.g, self.previewCol.b, 230 ) )
		self:SetTextColor( Color( 170, 170, 170 ) )
		draw.SimpleText( self:GetText(), "scpMenuFont", 65, h/2, Color( 0, 0, 0, 240 ), 0, 1 )
	end
	
	return true
end
	
vgui.Register( "SCP294RLoadMenuButton", PANEL, "DButton" )
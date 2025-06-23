local PANEL = {}

function PANEL:Init()
	self:SetSize( 300, 300 )
	self.Material = Material( "scp_294_redux/pencil.png" )
	self.bgrUp = Material( "scp_294_redux/bgr_up.png" )
end

function PANEL:SetTexture( path )
	self.Material = Material( path )
end

function PANEL:OnCursorEnteredCustom()
end

function PANEL:OnCursorExitedCustom()
end

function PANEL:OnCursorEntered()
	surface.PlaySound( "buttons/button16.wav" )
	self:OnCursorEnteredCustom()
end

function PANEL:OnCursorExited()
	self:OnCursorExitedCustom()
end

function PANEL:Paint( w, h )
	if ( SCP294Client.haveMaterials ) then
		if ( self:IsHovered() ) then
			draw.RoundedBox( 5, 0, 0, w, h, Color( 136, 193, 255 ) )
			draw.RoundedBox( 5, 3, 3, w - 6, h- 6, Color( 82, 85, 102 ) )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( self.Material )
			surface.DrawTexturedRect( 0, 0, w, h )
			
			surface.SetDrawColor( 255, 255, 255, 40 )
			surface.SetMaterial( self.bgrUp )
			surface.DrawTexturedRect( 0, 0, w, h )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color( 221, 224, 238 ) )
			draw.RoundedBox( 5, 1, 1, w - 2, h- 2, Color( 62, 65, 82 ) )
			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.SetMaterial( self.Material )
			surface.DrawTexturedRect( 0, 0, w, h )
		end
	else
		if ( self:IsHovered() ) then
			draw.RoundedBox( 5, 0, 0, w, h, Color( 136, 193, 255 ) )
			draw.RoundedBox( 5, 3, 3, w - 6, h- 6, Color( 82, 85, 102 ) )
			draw.SimpleText( self:GetText(), "scpMenuFontBig", w/2, h/2, Color( 255, 255, 255, 190 ), 1, 1 )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color( 221, 224, 238 ) )
			draw.RoundedBox( 5, 1, 1, w - 2, h- 2, Color( 62, 65, 82 ) )
			draw.SimpleText( self:GetText(), "scpMenuFontBig", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1 )
		end
	end
	return true
end
	
vgui.Register( "SCP294RMainMenuButton", PANEL, "DButton" )
local PANEL = {}

function PANEL:Init()
	self:SetSize( 300, 300 )
	self.bgrUp = Material( "scp_294_redux/bgr_up.png" )
	self.pressedEffect = 0
end

function PANEL:SetTexture( path )
	self.Material = Material( path )
end

function PANEL:OnCursorEnteredCustom()
end

function PANEL:OnCursorExitedCustom()
end

function PANEL:OnCursorEntered()
	self:OnCursorEnteredCustom()
end

function PANEL:OnCursorExited()
	self:OnCursorExitedCustom()
end

function PANEL:SetPressEffect( num )
	self.pressedEffect = ( num or 10 )
end 

function PANEL:Paint( w, h )
	local realS = self.pressedEffect
	if ( self.pressedEffect > 0 ) then
		self.pressedEffect = math.Clamp( self.pressedEffect - ( 40 * RealFrameTime() ), 0, 9999 )
	end
	
	if ( SCP294Client.haveMaterials ) then
		if ( self:IsHovered() ) then
			draw.RoundedBox( 5, realS + 0, realS + 0, w - ( realS * 2 ), h - ( realS * 2 ), Color( 150, 230, 250 ) )
			draw.RoundedBox( 5, realS + 2, realS + 2, w - ( realS * 2 ) - 4, h - ( realS * 2 ) - 4, Color( 82, 85, 102 ) )
			draw.SimpleText( self:GetText(), "scpMenuFontLittle", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1 )
			
			surface.SetDrawColor( 255, 255, 255, 10 )
			surface.SetMaterial( self.bgrUp )
			surface.DrawTexturedRect( 0, 0, w, h )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color( 221, 224, 238 ) )
			draw.RoundedBox( 5, 1, 1, w - 2, h- 2, Color( 62, 65, 82 ) )
			draw.SimpleText( self:GetText(), "scpMenuFontLittle", w/2, h/2, Color( 255, 255, 255, 190 ), 1, 1 )
			surface.SetDrawColor( 0, 0, 0, 70 )
			surface.SetMaterial( self.bgrUp )
			surface.DrawTexturedRect( 1, 1, w-2, h-2 )
		end
	else
		if ( self:IsHovered() ) then
			draw.RoundedBox( 5, realS + 0, realS + 0, w - ( realS * 2 ), h - ( realS * 2 ), Color( 150, 230, 250 ) )
			draw.RoundedBox( 5, realS + 2, realS + 2, w - ( realS * 2 ) - 4, h - ( realS * 2 ) - 4, Color( 82, 85, 102 ) )
			draw.SimpleText( self:GetText(), "scpMenuFontLittle", w/2, h/2, Color( 255, 255, 255, 190 ), 1, 1 )
		else
			draw.RoundedBox( 5, realS + 0, realS + 0, w - ( realS * 2 ), h - ( realS * 2 ), Color( 221, 224, 238 ) )
			draw.RoundedBox( 5, realS + 1, realS + 1, w - ( realS * 2 ) - 2, h - ( realS * 2 ) - 2, Color( 62, 65, 82 ) )
			draw.SimpleText( self:GetText(), "scpMenuFontLittle", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1 )
		end
	end
	return true
end
	
vgui.Register( "SCP294RSettingsButton", PANEL, "DButton" )

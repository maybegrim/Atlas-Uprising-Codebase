local PANEL = {}

function PANEL:Init()
	self.bgr_right = Material( "scp_294_redux/bgr_right.png" )
	self.bgr_down = Material( "scp_294_redux/bgr_down.png" )
	self.scp294 = Material( "scp_294_redux/scp294.png" )
	self.line02 = Material( "scp_294_redux/line02.png" )
	self.bgCol = Color( 200, 200, 200 )
	self.modificationDone = false
	self.customTitle = "..."
	self:SetTitle("")
	self:ShowCloseButton( false )
end

function PANEL:SetBackgroundColor( col )
	self.bgCol = col
end

function PANEL:SetModification( bool )
	self.modificationDone = true
end

function PANEL:SetCustomTitle( str )
	self.customTitle = str
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
	draw.RoundedBox( 0, 1, 1, w - 2, h- 2, Color( 72, 75, 91 ) )
	draw.RoundedBox( 0, 1, 1, w - 2, 75- 2, self.bgCol )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawLine( 0, 74, w, 74 )
	
	-- draw.RoundedBox( 0, 350, 75, 300, 648, Color( 255, 0, 0, 150 ) )
	if ( SCP294Client.haveMaterials ) then
		surface.SetDrawColor( 255, 255, 255, 150 )
		surface.SetMaterial( self.line02 )
		surface.DrawTexturedRect( 310, 80, 3, 650 )
		surface.DrawTexturedRect( 660, 80, 3, 650 )
	else
		draw.RoundedBox( 0, 310, 100, 2, 580, Color( 255, 255, 255, 120  ) )
		draw.RoundedBox( 0, 660, 100, 2, 580, Color( 255, 255, 255, 120 ) )
	end

	if ( SCP294Client.haveMaterials ) then
		surface.SetDrawColor( 255, 255, 255, 40 )
		surface.SetMaterial( self.bgr_right	)
		surface.DrawTexturedRect( 1, 0, w-2, 75 )
	end
	draw.SimpleText( self.customTitle, "scpMenuFontBig", 25, 0, Color( 255, 255, 255, 255 ), 0, 0 )
	
	if ( self.modificationDone ) then
		draw.RoundedBox( 0, 1100, 20, 35, 35, Color( 255, 0, 0, 55 + math.abs( math.cos( CurTime() * 2 ) * 200 ) ) )
	end
	
	if ( SCP294Client.haveMaterials ) then
		surface.SetDrawColor( 0, 0, 0, 60 )
		surface.SetMaterial( self.bgr_down )
		surface.DrawTexturedRect( 1, 74, w-2, h-75 )
	else
		local col = math.abs( math.sin( CurTime() *2 ) * 255 )
		draw.SimpleText( "Texture are missing, please download the addon", "scpMenuFont", w - 20, 25, Color( 255, col, col, 255 ), 2, 0 )
	end
	return true
end
	
vgui.Register( "SCP294RSettingsMenu", PANEL, "DFrame" )
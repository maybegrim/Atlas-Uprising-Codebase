function VENTS.OpenUI()
    local Frame = vgui.Create( "DFrame" )
    Frame:SetTitle( "PIN ENTRY" )
    Frame:SetSize( ScrW() * 0.1, ScrH() * 0.1 )
    Frame:Center()
    Frame:MakePopup()
    Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox( 0, 0, 0, w, h, Color( 22, 22, 30) ) -- Draw a red box instead of the frame
    end
    local w,h = Frame:GetWide(), Frame:GetTall()
    local Submit = vgui.Create("DButton", Frame)
    Submit:SetText( "SUBMIT" )
    Submit:SetTextColor( Color(255,255,255) )
    --Submit:SetPos( w * 0.38, h * 0.7 )
    --Submit:SetSize( w * 0.3, h * 0.2 )
	Submit:Dock( BOTTOM )
	Submit:DockMargin( 0, 5, 0, 0 )
    Submit.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 219, 80, 80, 250) ) -- Draw a blue button
    end
    local TextEntryPH = vgui.Create( "DTextEntry", Frame )
	TextEntryPH:Dock( TOP )
	TextEntryPH:DockMargin( 0, 5, 0, 0 )
	TextEntryPH:SetPlaceholderText( "1234" )
    TextEntryPH:SetNumeric(true)
    Submit.DoClick = function()
        net.Start("ATLAS.VENTS.PinEntry")
        local int = tonumber(TextEntryPH:GetInt())
        net.WriteInt(int, 15)
        net.SendToServer()
        Frame:Close()
    end
end
net.Receive("ATLAS.VENTS.UI", function()
    VENTS.OpenUI()
end)

net.Receive("ATLAS.VENTS.VentOpen", function ()
    local ply = LocalPlayer()
    
    ply:EmitSound("ambient/wind/wind1.wav")
    
    timer.Simple(5, function ()
        ply:StopSound("ambient/wind/wind1.wav") 
    end)
end)

net.Receive("ATLAS.VENTS.VentClose", function ()
    local ply = LocalPlayer()

    ply:EmitSound("physics/metal/canister_scrape_smooth_loop1.wav")
    
    timer.Simple(2, function ()
        ply:StopSound("physics/metal/canister_scrape_smooth_loop1.wav") 
        ply:EmitSound("physics/metal/metal_grate_impact_hard1.wav")
    end)
end)
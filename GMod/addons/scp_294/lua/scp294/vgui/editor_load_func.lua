

function SCP294Client.loadDrinkList( panel )
	local DFrame = SCP294Client.DFrame
	local parentPanel = ( panel or DFrame.DScrollPanel )
	if ( #DFrame.loadButtons > 0 ) then
		for k, pnl in pairs ( DFrame.loadButtons ) do
			pnl:Remove()
			DFrame.loadButtons[k] = nil
		end
	end
	
	local x, y = 10, 10
	for k, v in pairs ( SCP294Client.drinkDATA ) do
		local drink = vgui.Create( "SCP294RLoadMenuButton", parentPanel )
		drink:SetText( k )
		drink:SetPos( x, y )
		drink:SetPreviewColor( v.drinkColor )
		drink.DoClick = function()
			SCP294Client.openDrinkEditor( v )
		end
		table.insert( DFrame.loadButtons, drink )
		x = x + 220
		if ( x > 800 ) then
			x = 10
			y = y + 65
		end
	end
end 


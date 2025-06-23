

function SCP294Client.loadDrinkList()
	local DFrame = SCP294Client.DFrame
	
	if ( #DFrame.loadButtons > 0 ) then
		for k, pnl in pairs ( DFrame.loadButtons ) do
			pnl:Remove()
			DFrame.loadButtons[k] = nil
		end
	end
		
	local y = 40
	for k, v in pairs ( SCP294Client.drinkDATA ) do
		local drink = vgui.Create( "DButton", DFrame )
		drink:SetText( k )
		drink:SetPos( 350, y )
		drink:SetSize( 150, 35 )
		drink.DoClick = function()
			SCP294Client.openDrinkEditor( v )
		end
		table.insert( DFrame.loadButtons, drink )
		y = y + 40
	end
end 




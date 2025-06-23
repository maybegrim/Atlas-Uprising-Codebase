net.Receive("049_open", function()

local Frame049 = vgui.Create("DFrame")
Frame049:SetPos(5, 5)
Frame049:SetSize(ScrW() * 0.2, ScrH() * 0.5)
Frame049:SetTitle("Sound Menu")
Frame049:SetVisible(true)
Frame049:SetDraggable(true)
Frame049:Center()
Frame049:ShowCloseButton(true)
Frame049:MakePopup()
	Frame049.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(72, 72, 72, 200))
		draw.RoundedBox(0, 0, 0, w, 25, Color(15, 15, 15, 200))
	end

	local DScrollPanel = vgui.Create( "DScrollPanel", Frame049 )
	DScrollPanel:Dock( FILL )

	for i=1, 21 do
		local DButton = DScrollPanel:Add( "DButton" )
		if i == 1 then
			DButton:SetText( "Detected")
		elseif i == 2 then
			DButton:SetText( "Do not be afraid")
		elseif i == 3 then
			DButton:SetText( "Good")
		elseif i == 4 then
			DButton:SetText( "Greetings")
		elseif i == 5 then
			DButton:SetText( "Hello")
		elseif i == 6 then
			DButton:SetText( "I am the cure")
		elseif i == 7 then
			DButton:SetText( "I can see you")
		elseif i == 8 then
			DButton:SetText( "I hear you breathing")
		elseif i == 9 then
			DButton:SetText( "I know you are in here")
		elseif i == 10 then
			DButton:SetText( "I need to get to work")
		elseif i == 11 then
			DButton:SetText( "I sense the disease in you")
		elseif i == 12 then
			DButton:SetText( "Im not trying")
		elseif i == 13 then
			DButton:SetText( "Kidnap")
		elseif i == 14 then
			DButton:SetText( "Lets get this")
		elseif i == 15 then
			DButton:SetText( "My cure is most effective")
		elseif i == 16 then
			DButton:SetText( "Not doctor")
		elseif i == 17 then
			DButton:SetText( "Oh my")
		elseif i == 18 then
			DButton:SetText( "Ringo ringo roses")
		elseif i == 19 then
			DButton:SetText( "Stop resisting")
		elseif i == 20 then
			DButton:SetText( "There you are")
		elseif i == 21 then
			DButton:SetText( "Theres no need to hide")
		else
			DButton:SetText( "sound " .. i )
		end
		DButton:SetSize(200, 55)
		DButton:Dock( TOP )
		DButton:DockMargin( Frame049:GetWide()*0.2, ScrH() * 0.03, Frame049:GetWide()*0.2, 5 )
		DButton.DoClick = function()
			Frame049:Close()
			net.Start("049_sound")
				net.WriteString("sound" .. i )
			net.SendToServer()
		end
	end
end )
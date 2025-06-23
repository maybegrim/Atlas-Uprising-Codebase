include("shared.lua")

surface.CreateFont("overhead_text", {
	font = "Roboto Bold",
	size = 55,
	weight = 100,
	antialias = true,
})

surface.CreateFont("overhead_subtext", {
	font = "Roboto Light",
	size = 25,
	weight = 100,
	antialias = true,
})

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	pos.z = pos.z - math.abs(math.sin(CurTime())) + 4
	pos.x = pos.x - 2
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 250 then
		cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.1)
			local text = "IST Handbook"
		    surface.SetFont("overhead_text")
		    local textwidth, textheight = surface.GetTextSize(text)
		    draw.RoundedBoxEx(5, -(textwidth/2)-15, -778, textwidth+30, textheight, Color(0, 0, 0, 200), true, true, false, false)
		    draw.RoundedBoxEx(2, -(textwidth/2)-15, -778+textheight, textwidth+30, 2, Color(75, 116, 230, 200), false, false, true, true)
			draw.SimpleText(text, "overhead_text", 0, -778, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			draw.SimpleText("Press 'E' to Interact", "overhead_subtext", 0, -778+textheight, Color(255,255,255,255), TEXT_ALIGN_CENTER)			
		cam.End3D2D()	
	end
end

net.Receive("auat_opensop", function()

	gui.OpenURL("https://docs.google.com/document/d/1ob0eBJHTLrr_7t8bh2hH0C0jv9nkrpQgJrx4X9xNKew/edit?usp=sharing")

end)
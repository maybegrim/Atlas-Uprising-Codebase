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

local text = "CI Handbook"
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
		    surface.SetFont("overhead_text")
		    local textwidth, textheight = surface.GetTextSize(text)
		    draw.RoundedBoxEx(5, -(textwidth/2)-15, -778, textwidth+30, textheight, Color(0, 0, 0, 200), true, true, false, false)
		    draw.RoundedBoxEx(2, -(textwidth/2)-15, -778+textheight, textwidth+30, 2, Color(42, 236, 113, 200), false, false, true, true)
			draw.SimpleText(text, "overhead_text", 0, -778, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			draw.SimpleText("Press 'E' to Interact", "overhead_subtext", 0, -778+textheight, Color(255,255,255,255), TEXT_ALIGN_CENTER)			
		cam.End3D2D()	
	end
end

net.Receive("auat_opensopci", function()

	gui.OpenURL("https://docs.google.com/document/d/1T5cVUkD8afGUGzzXTWABJTr6WTt9-rt_OTlJfeSEEd4/edit#heading=h.75dv619t59qu")

end)
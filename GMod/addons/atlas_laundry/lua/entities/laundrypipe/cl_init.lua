include("shared.lua")

local black = Color(30, 30, 30)
local white = Color(230, 230, 230)

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow(false)

	local pos = self:GetPos()
	local ang = self:GetAngles()

	local distance = pos:Distance(LocalPlayer():GetPos())
	if distance > 500 then return end

	black.a = math.Clamp(500 - distance, 0, 255)
	white.a = math.Clamp(500 - distance, 0, 255)

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 240 then
		cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.095)
				draw.SimpleTextOutlined("Laundry Pipe", "ChatFont", 0, -126, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
				draw.SimpleTextOutlined("Press E to request more laundry.", "ChatFont", 0, -96, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
		cam.End3D2D()	
	end
end
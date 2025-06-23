include("shared.lua")

local black = Color(30, 30, 30)
local white = Color(230, 230, 230)

local stageNames = {
	[0] = "Dirty Laundry",
	[1] = "Wet Laundry",
	[2] = "Dry Laundry",
	[3] = "Folded Laundry"
}

local stageDesc = {
	[0] = "Put in the washing machine.",
	[1] = "Put in the dryer.",
	[2] = "Place on the folding table and press E.",
	[3] = "Place in the laundry basket."
}

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow(false)

	local pos = self:GetPos()
	local ang = self:GetAngles()

	local distance = pos:Distance(LocalPlayer():GetPos())
	if distance > 500 then return end

	black.a = math.Clamp(500 - distance, 0, 255)
	white.a = math.Clamp(500 - distance, 0, 255)

	local stage = self:GetStage()
	if stage and stageNames[stage] then
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)	
		if LocalPlayer():GetPos():Distance(self:GetPos()) < 240 then
			cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.095)
					draw.SimpleTextOutlined(stageNames[stage], "ChatFont", 0, -136, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
					draw.SimpleTextOutlined(stageDesc[stage], "ChatFont", 0, -106, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
			cam.End3D2D()	
		end
	end
end
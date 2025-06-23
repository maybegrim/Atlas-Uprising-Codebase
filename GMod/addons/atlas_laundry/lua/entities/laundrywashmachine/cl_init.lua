include('shared.lua')

local lightMat 	= Material("sprites/glow04_noz")
local green 		= Color(0, 255, 0)
local red 			= Color(255, 0, 0)
local black 		= Color(30, 30, 30)
local white 		= Color(230, 230, 230)

function ENT:Draw()
	self:DrawModel()
	self:DrawShadow(false)

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
	local light = pos + f*25 + r*15 + u*6

	local distance = pos:Distance(LocalPlayer():GetPos())
	if distance > 500 then return end

	green.a = math.Clamp(500 - distance, 0, 255)
	red.a 	= math.Clamp(500 - distance, 0, 255)
	black.a = math.Clamp(500 - distance, 0, 255)
	white.a = math.Clamp(500 - distance, 0, 255)

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	render.SetMaterial(lightMat)
	if self:GetWashing() then
		render.DrawSprite(light, 16, 16, red)
	else
		render.DrawSprite(light, 16, 16, green)
	end

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 240 then
		cam.Start3D2D(pos+f*25 + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.095)
				draw.SimpleTextOutlined("Washing Machine", "ChatFont", 0, -106, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
				draw.SimpleTextOutlined("Cleans dirty laundry.", "ChatFont", 0, -76, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
		cam.End3D2D()	
	end

end

function ENT:Think()
	local previousState = previousState or nil

	if IsValid(self.claundry) then
		local angle = self.claundry:GetAngles().z
		local parentAngle = self:GetAngles()
		angle = angle + FrameTime() * 300
		self.claundry:SetAngles(Angle(parentAngle.x, parentAngle.y, angle))
	end

	if self:GetWashing() == false and previousState != false then
		previousState = self:GetWashing()
		if IsValid(self.claundry) then
			self.claundry:Remove()
		end
	elseif self:GetWashing() then
		if IsValid(self.claundry) then return end
		self.claundry = ents.CreateClientProp()
		self.claundry:SetModel("models/props_junk/garbage_bag001a.mdl")
		self.claundry:SetPos(self:GetPos() + Vector(0, 0, 5))
		self.claundry:SetMaterial("models/props_c17/FurnitureFabric003a")
		self.claundry:SetMoveType(MOVETYPE_NONE)
		self.claundry:SetParent(self)
		self.claundry:SetColor(Color(127, 95, 0))
		self.claundry:SetModelScale(2)
		self.claundry:Spawn()
		timer.Simple(10, function()
	      if IsValid(self.claundry) then
	        self.claundry:SetColor(Color(72, 72, 72))
	      end
	    end)

	end
end

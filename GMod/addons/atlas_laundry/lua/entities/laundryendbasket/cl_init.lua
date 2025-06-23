include('shared.lua')

local green = Color(0, 220, 0, 255)
local black = Color(30, 30, 30)
local white = Color(230, 230, 230)

function ENT:Draw()
  self:DrawModel()
  self:DrawShadow(false)

  local pos = self:LocalToWorld(self:OBBCenter())
  local ang = self:GetAngles()

  local distance = pos:Distance(LocalPlayer():GetPos())
  if distance > 500 then return end

  green.a = math.Clamp(500 - distance, 0, 255)
  black.a = math.Clamp(500 - distance, 0, 255)
  white.a = math.Clamp(500 - distance, 0, 255)

  cam.Start3D2D(pos + (ang:Right() * 16), ang + Angle(0,0,90), 0.12)
    draw.SimpleTextOutlined("Folded Clothes (" .. self:GetClothesNumber() .. ")", "DermaLarge", -62, -60, white, 0, 0, 1, black)
    draw.SimpleTextOutlined(DarkRP.formatMoney(self:GetClothesNumber() * 75), "DermaLarge", 0, -30, green, 0, 0, 1, black)
  cam.End3D2D()

  pos = self:GetPos()
  ang = self:GetAngles()

  ang:RotateAroundAxis(ang:Up(), 90)
  ang:RotateAroundAxis(ang:Forward(), 90) 
  if LocalPlayer():GetPos():Distance(self:GetPos()) < 240 then
    cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.095)
        draw.SimpleTextOutlined("Laundry Basket", "ChatFont", 0, -326, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
        draw.SimpleTextOutlined("Put clean laundry here.", "ChatFont", 0, -296, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
    cam.End3D2D() 
  end
end
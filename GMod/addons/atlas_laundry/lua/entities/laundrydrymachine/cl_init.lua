include("shared.lua")

local green = Color(0, 220, 0, 255)
local black = Color(30, 30, 30)
local white = Color(230, 230, 230)

function ENT:Draw()
    self:DrawModel()
    self:DrawShadow(false)

    local pos = self:GetPos()
    local ang = self:GetAngles()
    local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

    local distance = pos:Distance(LocalPlayer():GetPos())
    if distance > 500 then return end

    green.a = math.Clamp(500 - distance, 0, 255)
    black.a = math.Clamp(500 - distance, 0, 255)
    white.a = math.Clamp(500 - distance, 0, 255)

    cam.Start3D2D(pos + f * 25 + r * -7.5 + u * 24, ang + Angle(0, 180, 35), 0.10)
        draw.SimpleTextOutlined(self.status[1], "ChatFont", 0, 0, self.status[1] == "Drying..." and green or white, 0, 0, 1, black)
        draw.SimpleTextOutlined(self.status[2], "ChatFont", 0, 36, self.status[2] == "Drying..." and green or white, 0, 0, 1, black)
        draw.SimpleTextOutlined(self.status[3], "ChatFont", 0, 72, self.status[3] == "Drying..." and green or white, 0, 0, 1, black)
        draw.SimpleTextOutlined(self.status[4], "ChatFont", 0, 108, self.status[4] == "Drying..." and green or white, 0, 0, 1, black)
    cam.End3D2D()

    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90) 
    if LocalPlayer():GetPos():Distance(self:GetPos()) < 240 then
        cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.095)
                draw.SimpleTextOutlined("Dryer", "ChatFont", 0, -370, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
                draw.SimpleTextOutlined("Dries wet laundry.", "ChatFont", 0, -340, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, black)
        cam.End3D2D()   
    end

    local laundryTable = {self:GetLaundry1(), self:GetLaundry2(), self:GetLaundry3(), self:GetLaundry4()}

    for v, k in pairs(laundryTable) do
        if k == 0 then
            self.status[v] = "Empty"
        elseif k == 1 then
            self.status[v] = "Drying..."
        elseif k == 2 then
            self.status[v] = "Done"
        elseif k == 3 then
            self.status[v] = "Dispensing..."
        end
    end
end
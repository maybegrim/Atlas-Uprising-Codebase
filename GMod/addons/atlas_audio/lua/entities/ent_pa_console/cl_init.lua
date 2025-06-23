include("shared.lua")

function ENT:GetStatus()
    return self:GetPAStatus()
end

-- If GetStatus = 0, its off. If GetStatus = 1, its getting ready. If GetStatus = 2, its on.
-- Draw a light and text that indicates the status of the PA. Model used is models/props/de_prodigy/desk_console1.mdl
include("shared.lua")

local statusText = {
    [0] = "Off",
    [1] = "Getting Ready",
    [2] = "On",
    [3] = "Turning Off",
    [4] = "Error! Call Tech"
}

local statusPos = {
    [0] = Vector(0, -10, 10),
    [1] = Vector(0, -15.7, 10),
    [2] = Vector(0, -6.9, 10),
    [3] = Vector(0, -15.7, 10),
    [4] = Vector(0, -3.8, 10)
}

local statusCol = {
    [0] = Color(255, 0, 0, 100),
    [1] = Color(255, 179, 0, 100),
    [2] = Color(73, 232, 73, 100),
    [3] = Color(255, 179, 0, 100),
    [4] = Color(251, 76, 76)
}

function ENT:GetStatus()
    return self:GetPAStatus()
end

local spriteMaterial = Material("sprites/light_ignorez")

function ENT:Draw()
    -- Stop rendering if we're far away
    if self:GetPos():Distance(LocalPlayer():GetPos()) > 500 then
        return
    end
    self:DrawModel()
    local status = self:GetStatus()
    local statusStr = statusText[status] or "Unknown"

    local lightPos = self:LocalToWorld(statusPos[status])
    local lightColor = statusCol[status] or Color(255,0,0)

    -- stop rendering light if we're far away
    local dist = lightPos:Distance(LocalPlayer():GetPos())
    if dist < 200 then
        local alpha = math.Clamp(255 - (dist / 200) * 255, 0, 255)
        lightColor.a = alpha
        render.SetMaterial(spriteMaterial)  -- Set the sprite texture
        -- Make sprite not go through walls
        render.DrawSprite(lightPos, 16, 16, lightColor)
    end
    
    if dist > 300 then return end
    local textPos = self:LocalToWorld(Vector(-3.5, -10, 13.5))
    local textAng = self:LocalToWorldAngles(Angle(0, 90, 45))
    cam.Start3D2D(textPos, textAng, 0.1)
        local textAlpha = math.Clamp(255 - (dist - 280) / 20 * 255, 0, 255)
        draw.RoundedBox(0, -66.5, -3, 133, 20, Color(0, 0, 0, textAlpha))
        draw.DrawText("PA Status: " .. statusStr, "DermaDefault", 0, 0, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
include("shared.lua")

--[[
    UI Draw here.
]]

function ENT:Draw()
    local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
    if dist > 1000000 then return end

    self:DrawModel()

    local pos = self:GetPos() + Vector(0, 0, 80)
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
    local isMined = INVENTORY.Garbage.OnCooldown
    local duration = INVENTORY.Garbage.SearchTime

    if dist > 50000 then return end
    cam.Start3D2D(pos, ang, 0.1)
        if isMined then
            draw.SimpleText("Already Searched", "INVENTORY::MINING::UI", 1, 152, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText("Already Searched", "INVENTORY::MINING::UI", -1, 150, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
        else
            local textY = duration and 53 or 150 -- Adjust the y-coordinate based on whether the progress bar is displayed
            draw.SimpleText(self.PrintName or "Mining", "INVENTORY::MINING::UI", 1, textY - 34, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText(self.PrintName or "Mining", "INVENTORY::MINING::UI", -1, textY - 36, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
            draw.SimpleText("Press 'E' to search.", "INVENTORY::MINING::UI", 1, textY, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText("Press 'E' to search.", "INVENTORY::MINING::UI", -1, textY - 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
        end

        if duration then
            draw.SimpleText("Search Progress", "INVENTORY::MINING::UI", 1, 103, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText("Search Progress", "INVENTORY::MINING::UI", -1, 101, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
            draw.RoundedBox(0, -110, 140, 220, 40, Color(23, 22, 28, 240)) -- Background
            draw.RoundedBox(0, -100, 150, 200, 20, Color(90, 90, 90, 120)) -- Background

            local elapsed = CurTime() - INVENTORY.Garbage.StartTime
            local progress = math.min(elapsed / duration, 1) * 200 -- Ensure progress doesn't exceed 200
            local gradient = Material("gui/gradient")
            surface.SetDrawColor(0, 229, 255)
            surface.SetMaterial(gradient)
            surface.DrawTexturedRectUV(-100, 150, progress, 20, 0, 0, progress / 200, 1)
        end
    cam.End3D2D()
end
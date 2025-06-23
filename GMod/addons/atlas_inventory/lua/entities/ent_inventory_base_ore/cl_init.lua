include("shared.lua")

--[[
    UI Draw here.
    When INVENTORY.Mining.HitCount[ent] = nothing/0 then draw Press 'E' to start mining.
    If INVENTORY.Mining.HitCount[ent] equals a number then draw a progress bar. based on the number/ent.MineCount
]]
function ENT:Draw()
    local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
    -- distance check
    if dist > 1000000 then return end

    self:DrawModel()

    local pos = self:GetPos() + Vector(0, 0, 50)
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
    local hitCount = INVENTORY.Mining.HitCount[self]
    local isMined = INVENTORY.Mining.OreStatus[self]
    if isMined then
        self:SetSkin(self.MinedSkin)
    else
        self:SetSkin(self.PrefereedSkin)
    end

    -- smaller distance check
    if dist > 50000 then return end

    cam.Start3D2D(pos, ang, 0.1)
        if isMined then
            draw.SimpleText("Already Mined", "INVENTORY::MINING::UI", 1, 1, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText("Already Mined", "INVENTORY::MINING::UI", -1, -1, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
        else
            draw.SimpleText(self.PrintName or "Mining", "INVENTORY::MINING::UI", 1, 1, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText(self.PrintName or "Mining", "INVENTORY::MINING::UI", -1, -1, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
            draw.SimpleText("Press 'E' to mine.", "INVENTORY::MINING::UI", 1, 53, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText("Press 'E' to mine.", "INVENTORY::MINING::UI", -1, 51, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
        end

        if hitCount then
            draw.SimpleText("Mining Progress", "INVENTORY::MINING::UI", 1, 103, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Background
            draw.SimpleText("Mining Progress", "INVENTORY::MINING::UI", -1, 101, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Foreground
            draw.RoundedBox(0, -110, 140, 220, 40, Color(23, 22, 28, 240)) -- Background
            draw.RoundedBox(0, -100, 150, 200, 20, Color(90, 90, 90, 120)) -- Background

            local gradient = Material("gui/gradient")
            local progress = 200 * (hitCount / self.MineCount)

            surface.SetDrawColor(255, 68, 0)
            surface.SetMaterial(gradient)
            surface.DrawTexturedRectUV(-100, 150, progress, 20, 0, 0, progress / 200, 1)
        end
    cam.End3D2D()
end

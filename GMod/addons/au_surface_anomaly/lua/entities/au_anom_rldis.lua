AddCSLuaFile()

if SERVER then util.AddNetworkString("au_anom_rldis:stabalise") end

AU_Distortion = AU_Distortion or {}
AU_Distortion.Controllers = AU_Distortion.Controllers or {}
AU_Distortion.Config = AU_Distortion.Config or {}

ENT.Type = "anim"
ENT.Base = "au_base_controller"
ENT.Category = "AU Distortion"
ENT.Spawnable = true
 
ENT.PrintName		= "Reality Distortion"
ENT.Author			= "Astral"
ENT.Contact			= "astral0773"
ENT.Controller = nil
ENT.prevCat = 1
ENT.changetime = CurTime()
ENT.RandomDamageMax = 80
ENT.AmmStablePerCategory = 2
ENT.MinAmmStable = 4
ENT.RangePerCat = 100
ENT.StabalisingPlayer = nil

ENT.WorlModel = "models/Combine_Helicopter/helicopter_bomb01.mdl"

if SERVER then

    local lastDamageTick = CurTime() -- Damage Time on orbs are matched together.

    function ENT:NewInitialize()
        self:SetMaterial("models/props_combine/portalball001_sheet")
        self:SetRad(self.RangePerCat)
        table.insert(AU_Distortion.Controllers, self)
    end

    function ENT:NewDestroy()
    end

    function ENT:Think()
        local curCat = self:GetCategory()
        if not (self.prevCat == curCat) then
            self.changetime = CurTime() + (math.abs(math.max(self.prevCat - curCat), 1) * 8) -- It (should) take around 8 seconds to grow a 100 units clientside.
            self.prevCat = curCat
            return
        end
        if self.changetime > CurTime() then return end
        if self:GetCategory() == 0 then self:Remove() end
        local radius = self:GetRad()
        if not self:GetRad() == (curCat * self.RangePerCat) then -- Avoid constantly updating the variable.
            self:SetRad(curCat * self.RangePerCat) -- Update it server-side, This also sends it to the clientside in case they have a slow asf computer.
        end
        if (math.max(self:GetCategory() * self.AmmStablePerCategory, self.MinAmmStable) - self:GetTargetAmmount() == 0) then return end
        if lastDamageTick > CurTime() then return end
        lastDamageTick = CurTime() + 2
        local entList = ents.FindInSphere(self:GetPos(), self:GetRad())
        for _,ent in pairs(entList) do
            if not ent or not ent:IsValid() or not ent:IsPlayer() then continue end
            ent:TakeDamage(math.random(self.RandomDamageMax))
        end
    end

    ENT.UseCooldown = CurTime()

    function ENT:Use(activator)
        if (self.UseCooldown > CurTime()) then return end
        self.UseCooldown = CurTime() + 1
        if (math.max(self:GetCategory() * self.AmmStablePerCategory, self.MinAmmStable) - self:GetTargetAmmount() > 0) then print("Not Stable!") return end
        if StabalisingPlayer and StabalisingPlayer:IsValid() then return end
        net.Start("au_anom_rldis:stabalise")
            net.WriteEntity(self)
        net.Send(activator)
    end

    net.Receive("au_anom_rldis:stabalise", function(len, ply)
        local ent = net.ReadEntity()
        local bool = net.ReadBool()
        ent.StabalisingPlayer = nil
        if not bool then
            local entList = ents.FindInSphere(ent:GetPos(), ent:GetRad())
            for _,entities in pairs(entList) do
                if not entities or not entities:IsValid() or not entities:IsPlayer() then continue end
                entities:TakeDamage(math.random(ent.RandomDamageMax) * 2)
            end
            return 
        end
        ent:SetCategory(ent:GetCategory() - 1)
    end)
end

if SERVER then return end

local AmmountRequired = 0
local AmmountDone = 0

local function CreateAnomRLDis(ent)
    hook.Add("StartCommand", "au_anom_rldis_disable_movement", function(ply, cmd)
        cmd:ClearMovement()
        cmd:ClearButtons()
    end)

    local frame = vgui.Create("DPanel")
    frame:SetSize(400, 400)
    frame:Center()
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(true)
    
    -- Skill check variables
    local skillZoneAngle = math.random(25, 45)
    local skillZoneStart = math.random(0, 240)
    local markerAngle = -90
    local markerSpeed = math.random(225, 325)
    local skillCheckRadius = 100
    local circleThickness = 20
    local success = false

    -- Calculate hit zone angles
    local startZone = math.rad(skillZoneStart - skillZoneAngle / 2)
    local endZone = math.rad(skillZoneStart + skillZoneAngle / 2)

    local function DrawThickCircle(x, y, radius, thickness, startAngle, endAngle, color)
        local segments = 360
        local innerRadius = radius - thickness / 2
        local outerRadius = radius + thickness / 2

        surface.SetDrawColor(color)

        for i = 0, segments do
            local angle = math.rad(startAngle + (endAngle - startAngle) * i / segments)
            local nextAngle = math.rad(startAngle + (endAngle - startAngle) * (i + 1) / segments)

            local poly = {
                { x = x + math.cos(angle) * innerRadius, y = y + math.sin(angle) * innerRadius },
                { x = x + math.cos(nextAngle) * innerRadius, y = y + math.sin(nextAngle) * innerRadius },
                { x = x + math.cos(nextAngle) * outerRadius, y = y + math.sin(nextAngle) * outerRadius },
                { x = x + math.cos(angle) * outerRadius, y = y + math.sin(angle) * outerRadius },
            }

            surface.DrawPoly(poly)
        end
    end

    local function DrawMarker(x, y, angle, radius)
        local markerWidth = 16 -- Width of the marker
        local markerHeight = 24 -- Height of the marker
        local tipX = x + math.cos(angle) * radius
        local tipY = y + math.sin(angle) * radius
        local baseLeftX = x + math.cos(angle + math.rad(90)) * (markerWidth / 2)
        local baseLeftY = y + math.sin(angle + math.rad(90)) * (markerWidth / 2)
        local baseRightX = x + math.cos(angle - math.rad(90)) * (markerWidth / 2)
        local baseRightY = y + math.sin(angle - math.rad(90)) * (markerWidth / 2)

        -- Marker outline
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawPoly({
            { x = tipX, y = tipY },
            { x = baseRightX, y = baseRightY },
            { x = baseLeftX, y = baseLeftY },
        })

        -- Marker fill
        surface.SetDrawColor(255, 0, 0, 255)
        surface.DrawPoly({
            { x = tipX - 1, y = tipY - 1 },
            { x = baseRightX - 1, y = baseRightY - 1 },
            { x = baseLeftX - 1, y = baseLeftY - 1 },
        })
    end


    frame.Paint = function(self, w, h)
        if not LocalPlayer():Alive() then hook.Remove("StartCommand", "au_anom_rldis_disable_movement") self:Remove() return end
        local centerX, centerY = w / 2, h / 2

        DrawThickCircle(centerX, centerY, skillCheckRadius, circleThickness, 0, 360, Color(0, 0, 0, 255))

        DrawThickCircle(centerX, centerY, skillCheckRadius, circleThickness, 
            math.deg(startZone), math.deg(endZone), Color(255, 255, 255, 150))

        markerAngle = markerAngle + FrameTime() * markerSpeed

        if markerAngle > 360 then
            AmmountDone = 0
            net.Start("au_anom_rldis:stabalise")
                net.WriteEntity(ent)
                net.WriteBool(false)
            net.SendToServer()
            hook.Remove("StartCommand", "au_anom_rldis_disable_movement")
            frame:Remove()
        end

        local markerRad = math.rad(markerAngle)
        local markerX = centerX + math.cos(markerRad) * skillCheckRadius
        local markerY = centerY + math.sin(markerRad) * skillCheckRadius

        if markerAngle >= 360 then markerAngle = markerAngle - 360 end

        -- Draw the DBD-style marker
        DrawMarker(centerX, centerY, math.rad(markerAngle), skillCheckRadius)

        draw.SimpleText("[Press Spacebar]", "HudDefault", centerX, centerY, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Check for success on key press
    frame.OnKeyCodePressed = function(self, keyCode)
        if keyCode == KEY_SPACE and not success then
            local markerRad = math.rad(markerAngle)
            if markerRad >= startZone and markerRad <= endZone then
                AmmountDone = AmmountDone + 1
                hook.Remove("StartCommand", "au_anom_rldis_disable_movement")
                frame:Remove()
                if AmmountDone == AmmountRequired then
                    AmmountDone = 0
                    net.Start("au_anom_rldis:stabalise")
                        net.WriteEntity(ent)
                        net.WriteBool(true)
                    net.SendToServer()
                    hook.Remove("StartCommand", "au_anom_rldis_disable_movement")
                else
                    CreateAnomRLDis(ent)
                end
            else
                AmmountDone = 0
                net.Start("au_anom_rldis:stabalise")
                    net.WriteEntity(ent)
                    net.WriteBool(false)
                net.SendToServer()
                hook.Remove("StartCommand", "au_anom_rldis_disable_movement")
                frame:Remove()
            end
        end
    end
end

local ConfigCategoryTimes = 3

local function AttemptFix(ent)
    AmmountRequired = ent:GetCategory() * ConfigCategoryTimes
    CreateAnomRLDis(ent)
end

net.Receive("au_anom_rldis:stabalise", function()
    local ent = net.ReadEntity()
    if not ent or not ent:IsValid() then return end
    AttemptFix(ent)
end)

function ENT:Draw()
    self:DrawModel()
end

 function ENT:Think()
    local radius = self:GetRad()
    if not radius == self:GetCategory() * self.RangePerCat then return end
    if radius > self:GetCategory() * self.RangePerCat then
        self:SetRad(math.max(radius - 0.05, self:GetCategory() * self.RangePerCat))
    else
        self:SetRad(math.min(radius + 0.05, self:GetCategory() * self.RangePerCat))
    end
    self:NextThink( CurTime() ) -- Quick Thinking! Good since this is used as an animation.
    return true
end

local function drawAround(self)
    if not self or not IsValid(self) then return end
    local material = Material("models/props_combine/com_shield001a")

    cam.Start3D()
        render.SetMaterial(material)
        render.CullMode(MATERIAL_CULLMODE_CW)
        render.DrawSphere(self:GetPos(), self:GetRad(), 50, 50, Color(0, 0, 255, 255))
        render.CullMode(MATERIAL_CULLMODE_CCW)
        render.DrawSphere(self:GetPos(), self:GetRad(), 50, 50, Color(255, 255, 255, 255))
    cam.End3D()
end

local function drawScreenMaterial(self)
    if not self or not IsValid(self) then return end
    if LocalPlayer():GetPos():Distance(self:GetPos()) > self:GetRad() then return end
    local material = Material("models/props_combine/com_shield001a")
    surface.SetMaterial(material)
    local color = Color(125, 125, 255, 255)
    surface.SetDrawColor(color)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end

function ENT:Initialize()
    hook.Add("PostDrawOpaqueRenderables", "DrawSphereAlways:".. self:EntIndex(), function()
        drawAround(self)
    end)
    hook.Add("HUDPaint", "DrawScreenMaterial".. self:EntIndex(), function()
        drawScreenMaterial(self)
    end)
end

function ENT:OnRemove()
    hook.Remove("PostDrawOpaqueRenderables", "DrawSphereAlways".. self:EntIndex())
    hook.Remove("HUDPaint", "DrawScreenMaterial".. self:EntIndex())
end

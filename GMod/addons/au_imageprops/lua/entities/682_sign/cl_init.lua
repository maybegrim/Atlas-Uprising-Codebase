--[[
	Name: cl_init.lua
	By: Micro & Time
]]--

include("shared.lua")

local branch_logo = Material("materials/au/scprp/branch_props/scp-682_sign.png")

function ENT:Draw()
    self:DrawModel()

    local ang = self:GetAngles()
    local pos = self:GetPos()

    ang:RotateAroundAxis(self:GetAngles():Right(), 180)
    ang:RotateAroundAxis(self:GetAngles():Forward(), 180)
    ang:RotateAroundAxis(self:GetAngles():Up(), 90)

    cam.Start3D2D( pos + ang:Up()*1.65, ang, 1 )
    	surface.SetDrawColor(color_white)
    	surface.SetMaterial(branch_logo)
    	surface.DrawTexturedRect( -30, -13, 60, 38 )
    cam.End3D2D()

    ang:RotateAroundAxis(self:GetAngles():Right(), 0)
    ang:RotateAroundAxis(self:GetAngles():Forward(), 180)
    ang:RotateAroundAxis(self:GetAngles():Up(), 0)

    cam.Start3D2D( pos + ang:Up()*1.65, ang, 1 )
    	surface.SetDrawColor(color_white)
    	surface.SetMaterial(branch_logo)
    	surface.DrawTexturedRect( -30, -13, 60, 38 )
    cam.End3D2D()
end
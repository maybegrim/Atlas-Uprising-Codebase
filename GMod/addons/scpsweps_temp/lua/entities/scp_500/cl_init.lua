--[[
	Name: cl_init.lua
	By: Micro
]]--

surface.CreateFont("SCP_FiveOh_Font", {
	font = "Roboto",
	size = ScrH()*.035,
	weight = 500,
})

include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    local ang = self:GetAngles()
    ang:RotateAroundAxis(self:GetAngles():Right(), 180)
    ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
    local pos = self:GetPos()
    cam.Start3D2D( pos + ang:Up()*4.75, ang, .05 )
    	draw.SimpleText("SCP-500", "SCP_FiveOh_Font", 0, -15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
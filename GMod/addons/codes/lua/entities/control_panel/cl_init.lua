--[[
	Name: cl_init.lua
	By: Micro
]]--

surface.CreateFont("Code_Console_Font", {
	font = "Roboto Thin",
	size = 50,
	weight = 300,
})

include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    local ang = self:GetAngles()
    ang:RotateAroundAxis(self:GetAngles():Right(), 270)
    ang:RotateAroundAxis(self:GetAngles():Forward(), 90)
    local pos = self:GetPos()
    cam.Start3D2D( pos + ang:Up()*13, ang, .05 )
    	draw.SimpleText("Code Control Console", "Code_Console_Font", 80, -515, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
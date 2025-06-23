--cl_init

include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
	
	local txt = " Mine Man "
	
	surface.SetFont("DermaLarge")
	local TextWidth = surface.GetTextSize(txt)
	
	cam.Start3D2D(Pos - Ang:Right() * 50 + Ang:Up(), Ang, 0.16)
		draw.WordBox(4, -TextWidth*0.5 - 5, -200, txt, "DermaLarge", Color(0, 0, 0, 255), Color(255,255,255,255))
	cam.End3D2D()

end
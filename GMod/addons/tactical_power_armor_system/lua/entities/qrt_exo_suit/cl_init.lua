include("shared.lua")

function ENT:Draw()
	self:DrawModel()	
	
	local p = self:GetPos()
	local m,M = self:OBBMins(), self:OBBMaxs()
	
	-- surface.DrawLine( p.x, number startY, number endX, number endY )
	
	if self:GetEquiper() != LocalPlayer() then return end
	
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 180)
	
	p = p + self:GetUp()*50 + self:GetForward()*-10
	
	cam.Start3D2D( p, ang, .1 )
		draw.RoundedBox( 0, -250, -125, 500,50,Color(50,50,50) )
		draw.RoundedBox( 0, -250+2, -125+2, math.Clamp(self:GetPercent()-4,0,100)*5, 50-4, Color(255,255,0) )
		draw.SimpleTextOutlined( PowerArmorConfig.Lang.EnteringPowerArmor,"PowerArmorFont",0,-100,Color(255,255,255),1,1,.5,Color(0,0,0) )
	cam.End3D2D()
end

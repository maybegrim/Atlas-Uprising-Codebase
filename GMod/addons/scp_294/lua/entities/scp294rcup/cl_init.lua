include("shared.lua")

function draw.Circle( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 ) 
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	surface.DrawPoly( cir )
end

function ENT:Draw()
	self:DrawModel()
	
	local ang = self:GetAngles()
	local red = self:GetNWInt( "cup_r", 0 )
	local green = self:GetNWInt( "cup_g", 0 )
	local blue = self:GetNWInt( "cup_b", 0 )
	local alpha = self:GetNWInt( "cup_a", 0 )
	
	cam.Start3D2D( self:GetPos() + ang:Up()*3.2, ang, 1 )
		surface.SetDrawColor( red, green, blue, alpha )
		draw.NoTexture()
		draw.Circle( 0, 0, 2, 20 )
	cam.End3D2D() 

end  
 
function ENT:Think()

end

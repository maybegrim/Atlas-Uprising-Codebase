include('shared.lua')
 
local backGround = Material( "notifications/angryimg.png" )
local font = "Mono40"

local function drawSCPEntityOverhead( e, t ) -- entity, text
    local localply = LocalPlayer()
    local localpos, ang = localply:GetPos(), localply:EyeAngles()

    local pos = e:GetPos()
    local dist = localpos:Distance( pos )
    
    local maxdist = 1400
    if dist > maxdist then return end                                                   -- normal max draw distance check

    local ratio = math.min( 1, dist / maxdist )
    local alpha = math.max( 0, 1 - 1 * (( ratio ^ 2 ) * 2) ) ^ 2

    local offset = Vector( 0, 0, 46 + 15 * ratio )
    local posdraw = e:GetPos() + offset + ang:Up()
    local textalpha = 255 - math.max(0, dist - (600 - 255) )

    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )

    local w, h = 150, 5

    surface.SetFont(font)
    local nWidth, nHeight = surface.GetTextSize(t)
    w = nWidth
    
	cam.Start3D2D( posdraw, Angle( 0, ang.y, 90), 0.06 + ratio * 0.40 )	

        if alpha > 0.01 then

            surface.SetMaterial(backGround)
            surface.SetDrawColor(Color(0, 0, 0, 125 * alpha))
            surface.DrawTexturedRect(-w , -h * 10, w * 2, h * 20)

            draw.RoundedBox(0, -w*.5, 13, w, h, Color(255, 255, 255, 255 * alpha) )
            draw.SimpleText(t, font, 0, h - 10, Color(255, 255, 255, 255 * alpha), 1, 1)

        end

	cam.End3D2D()
end


function ENT:Draw()
    self:DrawModel()
    drawSCPEntityOverhead( self, "Departmental Money System" )
end
 
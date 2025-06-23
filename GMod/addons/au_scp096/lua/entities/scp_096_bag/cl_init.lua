include("shared.lua")

local debug = false

function ENT:Draw()
    self:DrawModel()
end


hook.Add("HUDPaint", "DrawLackOfSight", function()
    if debug then return end
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if ply:GetNWBool("096_BAG:BAGGED", false) then
        surface.SetDrawColor( Color(0,0,0, 255) )
        surface.DrawRect( 0,0, ScrW(), ScrH() )
        
        surface.SetDrawColor( Color(0,0,0, 255) )
        for i=1,ScrH(),5 do
            surface.DrawRect( 0,i, ScrW(), 4 )
        end
        for i=1,ScrW(),5 do
            surface.DrawRect( i,0, 4,ScrH() )
        end
    end
end)
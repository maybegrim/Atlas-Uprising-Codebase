
include("shared.lua")

hook.Add("HUDPaint", "ATLAS.SCP035.BoxUI", function()
    local entTrace = LocalPlayer():GetEyeTrace().Entity
    if entTrace == NULL then return end
    if entTrace:GetClass() ~= "scp_035_box" then return end
    if LocalPlayer():GetPos():Distance(entTrace:GetPos()) > 200 then return end
    surface.SetDrawColor(0,174,255,200)
    surface.DrawRect(ScrW() * 0.40, ScrH() * 0, ScrW() * 0.20, ScrH() * 0.04)
    surface.SetTextColor( 255,255,255  )
    surface.SetTextPos( ScrW() * 0.43, ScrH() * 0.009 )
    surface.SetFont( "ATLAS.SCP035.Font.Consumed" )
    surface.DrawText( "Press Alt + E to take SCP-035 out" )
end)

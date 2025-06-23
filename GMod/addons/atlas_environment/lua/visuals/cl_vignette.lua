local atlas_vignette_enabled = CreateClientConVar("atlas_vignette_enable", "1", true, true, "Disable/enable vignette effect", 0, 1)
local atlas_vignette_level = CreateClientConVar("atlas_vignette_darkness", "100", true, true, "Vignette effect intensity", 1, 255)

local vignette_mat = Material("atlas/visuals/vignette.png")

print(vignette_mat)
if vignette_mat:IsError() then
    print("[ATLAS] Failed to load vignette material. Skipping...")
    return
end

hook.Add( "HUDPaintBackground", "ATLAS.VISUALS.VIGNETTE", function()
    if atlas_vignette_enabled:GetBool() then
        alpha = math.Approach(atlas_vignette_level:GetFloat(), 0, FrameTime() * 30)

        surface.SetDrawColor(0, 0, 0, 150 + alpha)
        surface.SetMaterial(vignette_mat)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end
end)
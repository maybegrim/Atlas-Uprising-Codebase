local loadingIcon = Material( "materials/ui/loadingv2.png" )

function CHARACTER.OpenLoadingScreen()
    -- Display EditablePanel and set its size to the screen size. Make a loading circle and make it spin.
    if CHARACTER.LoadingScreen then
        CHARACTER.LoadingScreen:Remove()
        CHARACTER.LoadingScreen = false
    end
    local sW, sH = ScrW(), ScrH()
    CHARACTER.LoadingScreen = vgui.Create( "EditablePanel" )

    local loadPanel = CHARACTER.LoadingScreen
    loadPanel:SetPos( 0, 0 )
    loadPanel:SetSize( sW, sH )

    local matSizedDown = {w = 240, h = 87}
    local logoBack = vgui.Create( "DImage", loadPanel )
    logoBack:SetPos( sW / 2 - (matSizedDown.w / 2) + 5, sH / 2 - (sH * 0.465) )
    logoBack:DockMargin( 0, 50, 0, 0 )

    -- [Logo] Set the logo size
    logoBack:SetSize( matSizedDown.w, matSizedDown.h )

    logoBack:SetImage( "materials/branding/atlas_logo_small.png" )
    logoBack:SetImageColor(Color(0, 0, 0))

    -- [Logo] Create a DImage and set the logo material
    local logo = vgui.Create( "DImage", loadPanel )
    logo:SetPos( sW / 2 - (matSizedDown.w / 2), sH / 2 - (sH * 0.47) )
    logo:DockMargin( 0, 50, 0, 0 )

    -- [Logo] Set the logo size
    logo:SetSize( matSizedDown.w, matSizedDown.h )

    logo:SetImage( "materials/branding/atlas_logo_small.png" )
    logo:SetImageColor(Color(255, 255, 255))

    local loadText = "LOADING..."

    timer.Create("ATLAS::Characters::LoadingText", 0.3, 0, function()
        if not loadPanel then timer.Remove("ATLAS::Characters::LoadingText") return end
        if loadText == "LOADING..." then
            loadText = "LOADING"
        elseif loadText == "LOADING" then
            loadText = "LOADING."
        elseif loadText == "LOADING." then
            loadText = "LOADING.."
        elseif loadText == "LOADING.." then
            loadText = "LOADING..."
        end
    end)

    local angle = 0
    loadPanel.Paint = function(s, w, h)
        Derma_DrawBackgroundBlur( s, s.m_fCreateTime )
        angle = (angle - 0.5) % 360

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(loadingIcon)
        surface.DrawTexturedRectRotated(w / 2, h / 1.2, 64, 64, angle)

        draw.SimpleText( loadText, "Character_Title", w / 2, h / 1.1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    loadPanel:MakePopup()
end

function CHARACTER.CloseLoadingScreen()
    if CHARACTER.LoadingScreen then
        CHARACTER.LoadingScreen:Remove()
        CHARACTER.LoadingScreen = false
    end
end
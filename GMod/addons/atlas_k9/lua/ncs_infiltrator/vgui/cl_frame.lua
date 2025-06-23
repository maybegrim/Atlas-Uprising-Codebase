local function CreateFonts()
    surface.CreateFont( "NCS_INFILTRATOR_FRAME_TITLE", {
        font = "Bebas Neue", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = ScreenScale(7),
    } )

    surface.CreateFont( "NCS_INFILTRATOR_DESCRIPTION", {
        font = "Bebas Neue", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = ScreenScale(7),
    } )
end
hook.Add("OnScreenSizeChanged", "NCS_INFILTRATOR_UpdateFonts", CreateFonts)
CreateFonts()

local blur = Material("pp/blurscreen")

local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)

    local scrW, scrH = ScrW(), ScrH()

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

local PANEL = {}

local col_Red = Color(199,29,23)

PANEL.Paint = function(s, w, h)
    DrawBlur(s, 6)
    
    surface.SetDrawColor( Color(0,0,0, 255) )
    surface.DrawRect( 0, 0, w, h )

end

PANEL.Init = function(s)
    local FRAME = s

    FRAME.OnSizeChanged = function(s)
            s.Header = vgui.Create("Panel", s)
            s.Header:Dock(TOP)
            s.Header:PaintManual(true)
            s.Header:SetTall(s:GetTall() * 0.06)
            s.Header.Paint = function(_, w, h)
                -- Left Hand Side
                surface.SetDrawColor( col_Red )
                surface.DrawRect( 0, 0, w * 0.03, h )
                surface.SetDrawColor( col_Red )
                surface.DrawRect( 0, h * 0.01, w * 0.1, w * 0.03)

                -- Right Hand Side
                surface.SetDrawColor( col_Red )
                surface.DrawRect( w * 0.97, 0, w * 0.03, h )
                surface.SetDrawColor( col_Red )
                surface.DrawRect( w * 0.9, h * 0.01, w * 0.1, w * 0.03)

                draw.SimpleText((FRAME:GetTitle() or ""), "NCS_INFILTRATOR_FRAME_TITLE", w * 0.01, h * 0.5, COL_2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

        local w, h = s.Header:GetSize()

        s.CloseButton = vgui.Create("DButton", s.Header)
        s.CloseButton:SetWide(w * 0.2)
        s.CloseButton:Dock(RIGHT)
        s.CloseButton:SetText("")
        s.CloseButton:SetFont("NCS_INFILTRATOR_FRAME_TITLE")
        s.CloseButton:SetTextColor(Color(255,0,0))
        
        s.CloseButton.DoClick = function(pnl)
            s:Remove()
        end

        s.CloseButton.Paint = function(pnl, w ,h)
            if pnl:IsHovered() then
                draw.SimpleText("X", "NCS_INFILTRATOR_FRAME_TITLE", w * 0.6, h * 0.6, col_Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("X", "NCS_INFILTRATOR_FRAME_TITLE", w * 0.6, h * 0.6, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end

end

AccessorFunc(PANEL, "m_rd_titletext", "Title", FORCE_STRING)

vgui.Register("NCS_INFILTRATOR_FRAME", PANEL, "EditablePanel")
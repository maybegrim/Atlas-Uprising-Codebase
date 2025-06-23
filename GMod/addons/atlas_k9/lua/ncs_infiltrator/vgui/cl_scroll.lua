local PANEL = {}

function PANEL:Init()
    local VBAR = self:GetVBar()

    function VBAR:Paint(w, h)
        surface.SetDrawColor(Color(49,56,58,255))
        surface.DrawRect( 0, 0, w, h )
    end

    local W, H = VBAR:GetSize()

    VBAR:SetWide(W * 0.5)
    VBAR:SetHideButtons(true)

    local GRIP = VBAR:GetChildren()[3]

    function GRIP:Paint(w, h)
        surface.SetDrawColor(Color(124,137,140,255))
        surface.DrawRect( 0, 0, w, h )
    end
end

vgui.Register("NCS_INFILTRATOR_SCROLL", PANEL, "DScrollPanel")

local AScroll = {}

function AScroll:Init()
    self:SetTheme(autil.DEFAULT_THEME)

    local v_scroll = self:GetVBar()
    v_scroll:SetSize(10, self:GetTall())
    v_scroll:SetHideButtons(true)
    
    v_scroll.Paint = function (self, w, h) end

    v_scroll.btnGrip.Paint = function (_, w, h)
        draw.RoundedBox(0, 0, 0, w, h, self.Theme.ScrollFG)
    end
end

function AScroll:SetTheme(theme)
    self.Theme = theme
end

autil.VGUI_SCROLL = "AUScroll"
derma.DefineControl(autil.VGUI_SCROLL, "AUtil scroll panel.", AScroll, "DScrollPanel")

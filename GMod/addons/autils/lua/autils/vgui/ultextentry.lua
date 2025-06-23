surface.CreateFont("autil.underlined_text_entry", {
    font = "Roboto",
    size = 30,
    weight = 300,
    antialias = true
})

local ATextEntry = {}

function ATextEntry:Init()
    self:SetTheme(autil.DEFAULT_THEME)
    self:SetDrawBackground(false) 
    self:SetFont("autil.underlined_text_entry")
end

function ATextEntry:Paint(w, h)
    surface.SetDrawColor(self.Theme.UnderlinedTextEntryFG:Unpack())
    surface.DrawRect(0, h - 1, w, 1)
    derma.SkinHook("Paint", "TextEntry", self, w, h)
end

function ATextEntry:SetTheme(theme)
    self.Theme = theme
    self:SetTextColor(theme.UnderlinedTextEntryText)
    self:SetCursorColor(theme.UnderlinedTextEntryText)
end

function ATextEntry:GetTheme()
    return self.Theme
end

autil.VGUI_UNDERLINED_TEXT_ENTRY = "AUUnderlinedTextEntry"
derma.DefineControl(autil.VGUI_UNDERLINED_TEXT_ENTRY, "AUtil underlined text entry.", ATextEntry, "DTextEntry")
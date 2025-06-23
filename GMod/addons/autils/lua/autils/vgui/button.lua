surface.CreateFont("autil.button", {
    font = "Roboto",
    weight = 700,
    size = 20,
    antialis = true
})

local AButton = {}

function AButton:Init()
    self:SetTheme(autil.DEFAULT_THEME)
    self:SetFont("autil.button")
    self:SetColor(Color(255, 255, 255))
    self:SetContentAlignment(5)
    self:SetEnabled(true)
end

function AButton:Paint(w, h)
    if self.Enabled then
        surface.SetDrawColor((self.Depressed and self.DepressedColor or self.Theme.ButtonBG):Unpack())
    else
        surface.SetDrawColor(self.DisabledColorBG:Unpack())
    end

    surface.DrawRect(0, 0, w, h)
end

function AButton:SetEnabled(enable)
    self:SetColor(enable and self.Theme.ButtonFG or self.DisabledColorFG)
    self:SetCursor(enable and "hand" or "no")

    self.Enabled = enable
end

function AButton:IsEnabled()
    return self.Enabled
end

function AButton:SetTheme(theme)
    self.Theme = theme

    self:SetColor(theme.ButtonFG)

    self.DepressedColor = autil.ShiftColor(theme.ButtonBG, 1.2)
    self.DisabledColorBG = autil.ShiftColor(theme.ButtonBG, 0.8)
    self.DisabledColorFG = autil.ShiftColor(theme.ButtonFG, 0.8)
end

function AButton:OnMousePressed(code)
    if code == MOUSE_LEFT and self.Enabled then
        self.Depressed = true
        self:MouseCapture(true)
    end
end

function AButton:OnMouseReleased(code)
    local x, y = self:LocalCursorPos()

    if code == MOUSE_LEFT and self.Enabled and (x >= 0 and y >= 0 and x <= self:GetWide() and y <= self:GetTall()) then
        self:DoClick()
    end

    self.Depressed = false
    self:MouseCapture(false)
end

autil.VGUI_BUTTON = "AUButton"
derma.DefineControl(autil.VGUI_BUTTON, "AUtil button.", AButton, "DButton")
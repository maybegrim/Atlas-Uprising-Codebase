surface.CreateFont("autil.progress.text", {
    font = "Roboto",
    size = 25,
    weight = 800,
    antialias = true
})

local AProgress = {}

function AProgress:Init()
    self:SetTheme(autil.DEFAULT_THEME)
    self:SetPercentage(0)
end

function AProgress:Paint(w, h)
    surface.SetDrawColor(self.Theme.ProgressBG:Unpack())
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(self.Theme.ProgressFG:Unpack())
    surface.DrawRect(4, 4, (w - 8) * (self.Percentage / 100), w - 8)

    draw.SimpleText(math.floor(self.Percentage) .. "%", "autil.progress.text", w / 2, h / 2, self.Theme.ProgressText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function AProgress:SetPercentage(percentage)
    self.Percentage = percentage or 0
end

function AProgress:GetPercentage()
    return self.Percentage
end

function AProgress:SetTheme(theme)
    self.Theme = theme
end

function AProgress:GetTheme()
    return self.Theme
end

autil.VGUI_PROGRESS = "AUProgress"
derma.DefineControl(autil.VGUI_PROGRESS, "A simple progress bar.", AProgress, "EditablePanel")
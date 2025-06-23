local PANEL = {}

Derma_Hook(PANEL, "Paint", "Paint", "AutoSizeLabel")

function PANEL:SetText(text)
    self.BaseClass.SetText(self, text)
    self:SizeToContents()
end

derma.DefineControl("BIOBOLT.UI.AutoSizeLabel", "", PANEL, "DLabel")
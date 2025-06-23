--[[
	Name: cl_hud.lua
	By: Micro
]]--

local function SetupFonts()
surface.CreateFont("Code_HUD_Font", {
    font = "Roboto Thin",
    size = ScrH()*.03,
    weight = 300,
})
end
hook.Add("OnScreenSizeChanged", "CodeHUDFonts", SetupFonts)
SetupFonts()

--[[hook.Add("HUDPaint", "Code_Status_HUD", function()
	if CODE_CONFIG.CanSeeJobs[LocalPlayer():Team()] then
		draw.SimpleText(currentcode, "Code_HUD_Font", ScrW()*.015+2, ScrH()*.015+2, color_black, TEXT_ALIGN_LEFT)
		draw.SimpleText(currentcode, "Code_HUD_Font", ScrW()*.015, ScrH()*.015, codecolor, TEXT_ALIGN_LEFT)
	end
end)]]
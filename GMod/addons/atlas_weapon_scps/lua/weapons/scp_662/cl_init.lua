
include("shared.lua")

local ScreenScaleH = function(height)
	return height*(ScrH()/480)
end
local ScreenScaleW = function(width)
	return width*(ScrW()/640)
end

local COLOR_WHITE = Color(255,255,255)
local COLOR_BLACK = Color(0,0,0)
local COLOR_DARK_BG = Color(10,10,11,240)

function SWEP:DrawHUD()
	draw.NoTexture()
	surface.SetDrawColor(COLOR_WHITE)
	draw.RoundedBox( 8, ScrW() * 0.1, ScrH() * 0.6, ScrW() * 0.1, ScrH() * 0.1, COLOR_DARK_BG )
	draw.SimpleTextOutlined((self:IsSeen() and "Watched" or "Not Watched"),"ATLAS662.Font.Pickup",ScreenScaleW(70),ScreenScaleH(295),COLOR_WHITE,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,COLOR_BLACK)
	draw.SimpleTextOutlined(LocalPlayer():GetNoDraw() and "CLOAK: On" or "CLOAK: Off","ATLAS662.Font.Pickup",ScreenScaleW(70),ScreenScaleH(315),COLOR_WHITE,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,COLOR_BLACK)
end
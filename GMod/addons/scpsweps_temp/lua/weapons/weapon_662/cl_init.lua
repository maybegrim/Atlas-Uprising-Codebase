include("shared.lua")
SWEP.Category 				= "Atlas Uprising - Temp SCP Sweps"
SWEP.PrintName      		= "SCP-662"
SWEP.Author        			= "Xyz"
SWEP.Contact 				= "Xyz"
SWEP.Instructions 			= "Left click to go invisible and noclip. Right click to become corporeal again."
SWEP.ViewModel 				= "models/weapons/v_crowbar.mdl"

local ScreenScale = XYZ.gui.ScreenScale
local ScreenScaleH = XYZ.gui.ScreenScaleH
local ScreenScaleW = XYZ.gui.ScreenScaleW

local COLOR_WHITE = Color(255,255,255)
local COLOR_BLACK = Color(0,0,0)

function SWEP:DrawHUD()
	draw.NoTexture()
	surface.SetDrawColor(COLOR_WHITE)
	draw.SimpleTextOutlined((self:IsSeen() and "Watched" or "Not Watched"),"DermaDefault",ScreenScaleW(5),ScreenScaleH(300),COLOR_WHITE,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,COLOR_BLACK)
	draw.SimpleTextOutlined(LocalPlayer():GetNoDraw() and "Invisible" or "Visible","DermaDefault",ScreenScaleW(5),ScreenScaleH(310),COLOR_WHITE,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,COLOR_BLACK)
end

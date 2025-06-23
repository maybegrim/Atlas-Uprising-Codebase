XYZ.gui = XYZ.gui or {}

local GUI = XYZ.gui


function GUI.ScreenScaleW(width)
	return width*(ScrW()/640)
end

function GUI.ScreenScaleH(height)
	return height*(ScrH()/480)
end

function GUI.ScreenScale(width,height)
	return GUI.ScreenScaleW(width),GUI.ScreenScaleH(height)
end


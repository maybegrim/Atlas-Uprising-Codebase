--[[
	Name: cl_map.lua
	By: Micro
]]--

surface.CreateFont("Cap_Point_Map_Font", {
    font = "Roboto",
    size = ScrH()*.015,
    weight = 300,
})

local mapmaterial = "materials/au/scprp/mapoverview.png"
local comtheme = Color(50, 50, 50, 255)
local fadedwhite = Color(230, 230, 230, 255)

local villagecol
local foundationhqcol
local icelakecol
local lennyslaircol
local cihqcol
local joesshackcol
local lerockcol

local function CapPointMap()
	local mframe = vgui.Create("DFrame")
	mframe:SetSize(ScrH()*.5, ScrH()*.525)
	mframe:SetPos(ScrW()/2-ScrH()*.5/2, ScrH())
	mframe:MoveTo(ScrW()/2-ScrH()*.5/2, ScrH()/2-ScrH()*.5/2, 0.20, 0, 1)
	mframe:SetTitle("")
	mframe:SetDraggable(false)
	mframe:ShowCloseButton(false)
	mframe:MakePopup()
	mframe.Paint = function(self)
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), comtheme)
		draw.SimpleText("Surface Map", "Cap_Point_Map_Font", ScrH()*.005, ScrH()*.005, fadedwhite, TEXT_ALIGN_LEFT)
	end
	mframe.Close = function(self)
		mframe:MoveTo(ScrW()/2-ScrH()*.5/2, ScrH(), 0.20, 0, 1)
		timer.Simple(.20, function()
			mframe:Remove()
		end)
	end
	local mimage = vgui.Create("DImage", mframe)
	mimage:SetSize(mframe:GetWide(), mframe:GetTall()-ScrH()*.025)
	mimage:SetPos(0, ScrH()*.025)
	mimage:SetImage(mapmaterial)
	local dpanel = vgui.Create("DPanel", mimage)
	dpanel:SetSize(mimage:GetWide(), mimage:GetTall())
	dpanel:SetPos(0, 0)
	dpanel.Paint = function(self)
		-- Village
		draw.RoundedBox(ScrH()*.025/2, ScrH()*.13, ScrH()*.105, ScrH()*.015, ScrH()*.015, villagecol)
		-- Foundation HQ
		draw.RoundedBox(ScrH()*.025/2, ScrH()*.3315, ScrH()*.18, ScrH()*.015, ScrH()*.015, foundationhqcol)
		-- Ice Lake
		draw.RoundedBox(ScrH()*.025/2, ScrH()*.406, ScrH()*.306, ScrH()*.015, ScrH()*.015, icelakecol)
		-- Lenn'ys Lair
		draw.RoundedBox(ScrH()*.025/2, ScrH()*.43, ScrH()*.406, ScrH()*.015, ScrH()*.015, lennyslaircol)
		-- CI HQ
		draw.RoundedBox(ScrH()*.025/2, ScrH()*.205, ScrH()*.43, ScrH()*.015, ScrH()*.015, lerockcol)
		-- Joe's Shack
		draw.RoundedBox(ScrH()*.025/2, ScrH()*.2325, ScrH()*.33, ScrH()*.015, ScrH()*.015, joesshackcol)
		-- Le Rock
		draw.RoundedBox(ScrH()*.025/2, ScrH()*.105, ScrH()*.33, ScrH()*.015, ScrH()*.015, cihqcol)
	end
	local mbutton = vgui.Create("DButton", mframe)
	mbutton:SetSize(ScrH()*.025, ScrH()*.025)
	mbutton:SetPos(mframe:GetWide()-ScrH()*.025, 0)
	mbutton:SetText("x")
	mbutton:SetFont("Cap_Point_Map_Font")
	mbutton.Paint = function(self)
		if self:IsHovered() then
			mbutton:SetTextColor(color_white)
		else
			mbutton:SetTextColor(fadedwhite)
		end
	end
	mbutton.DoClick = function(self)
		surface.PlaySound("UI/buttonclickrelease.wav")
		self:GetParent():Close()
	end
end

net.Receive("CapturePointMapOverview", function()
	villagecol = net.ReadColor()
	foundationhqcol = net.ReadColor()
	icelakecol = net.ReadColor()
	lennyslaircol = net.ReadColor()
	cihqcol = net.ReadColor()
	joesshackcol = net.ReadColor()
	lerockcol = net.ReadColor()
	CapPointMap()
end)
--[[
	Name: cl_ui.lua
	By: Micro
]]--

local function SetupFonts()
surface.CreateFont("Code_UI_Font", {
    font = "Roboto",
    size = 20,
    weight = 300,
})
end
hook.Add("OnScreenSizeChanged", "CodeHUDFonts", SetupFonts)
SetupFonts()

function CodeControlMenu()
	local ccm_frame = vgui.Create("DFrame")
	ccm_frame:SetSize(400, 600)
	ccm_frame:SetTitle("")
	ccm_frame:SetDraggable(false)
	ccm_frame:MakePopup()
	ccm_frame:Center()
	function ccm_frame.Paint(self)
		surface.SetDrawColor(0, 0, 0, 253)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end

	local txt = "Code Control Console"
	surface.SetFont("Code_UI_Font")
	local txtx, txty = surface.GetTextSize(txt)
	local ccm_header_label = vgui.Create("DLabel", ccm_frame)
	ccm_header_label:SetText(txt)
	ccm_header_label:SetFont("Code_UI_Font")
	ccm_header_label:SetTextColor(color_white)
	ccm_header_label:SetSize(txtx, txty)
	ccm_header_label:SetPos(ccm_frame:GetWide()/2-txtx/2, 40)

	local ccm_green_button = vgui.Create("DButton", ccm_frame)
	ccm_green_button:SetText("Green")
	ccm_green_button:SetFont("Code_UI_Font")
	ccm_green_button:SetSize(300, 50)
	ccm_green_button:SetPos(50, 100)
	function ccm_green_button.Paint(self)
		if self:IsHovered() then
			self:SetTextColor(color_white)
		else
			self:SetTextColor(Color(200, 200, 200, 255))
		end
		surface.SetDrawColor(35, 35, 35, 255)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end
	function ccm_green_button.DoClick(self)
		surface.PlaySound("UI/buttonclickrelease.wav")
		net.Start("UpdateServerOnCurrentCode")
			net.WriteString("Code Green")
		net.SendToServer()
		ccm_frame:Close()
	end

	local ccm_yellow_button = vgui.Create("DButton", ccm_frame)
	ccm_yellow_button:SetText("Yellow")
	ccm_yellow_button:SetFont("Code_UI_Font")
	ccm_yellow_button:SetSize(300, 50)
	ccm_yellow_button:SetPos(50, 200)
	function ccm_yellow_button.Paint(self)
		if self:IsHovered() then
			self:SetTextColor(color_white)
		else
			self:SetTextColor(Color(200, 200, 200, 255))
		end
		surface.SetDrawColor(35, 35, 35, 255)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end
	function ccm_yellow_button.DoClick(self)
		surface.PlaySound("UI/buttonclickrelease.wav")
		net.Start("UpdateServerOnCurrentCode")
			net.WriteString("Code Yellow")
		net.SendToServer()
		ccm_frame:Close()
	end

	local ccm_red_button = vgui.Create("DButton", ccm_frame)
	ccm_red_button:SetText("Red")
	ccm_red_button:SetFont("Code_UI_Font")
	ccm_red_button:SetSize(300, 50)
	ccm_red_button:SetPos(50, 300)
	function ccm_red_button.Paint(self)
		if self:IsHovered() then
			self:SetTextColor(color_white)
		else
			self:SetTextColor(Color(200, 200, 200, 255))
		end
		surface.SetDrawColor(35, 35, 35, 255)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end
	function ccm_red_button.DoClick(self)
		surface.PlaySound("UI/buttonclickrelease.wav")
		net.Start("UpdateServerOnCurrentCode")
			net.WriteString("Code Red")
		net.SendToServer()
		ccm_frame:Close()
	end

	local ccm_white_button = vgui.Create("DButton", ccm_frame)
	ccm_white_button:SetText("White")
	ccm_white_button:SetFont("Code_UI_Font")
	ccm_white_button:SetSize(300, 50)
	ccm_white_button:SetPos(50, 400)
	function ccm_white_button.Paint(self)
		if self:IsHovered() then
			self:SetTextColor(color_white)
		else
			self:SetTextColor(Color(200, 200, 200, 255))
		end
		surface.SetDrawColor(35, 35, 35, 255)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end
	function ccm_white_button.DoClick(self)
		surface.PlaySound("UI/buttonclickrelease.wav")
		net.Start("UpdateServerOnCurrentCode")
			net.WriteString("Code White")
		net.SendToServer()
		ccm_frame:Close()
	end
end

net.Receive("CodeControlMenu", function()
	CodeControlMenu()
end)
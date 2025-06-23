-- Tommy MADE font
surface.CreateFont("UI.Font", {
    font = "MADE Tommy",
    size = 25,
    weight = 500,
    antialias = true,
    shadow = false
})


concommand.Add("open_verify_ui", function() -- Command to open the UI, you can trigger this however you'd like
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(300, 150)
    frame:Center()
    frame:MakePopup()
    frame:SetVisible(true)
    frame:SetDraggable(true)
    frame:ShowCloseButton(false) -- Hide the default close button
    frame.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(16, 16, 18)) -- Dark background
    end

    -- Custom title
    local title = vgui.Create("DLabel", frame)
    title:SetPos(5, 5) -- Adjust position as needed
    title:SetSize(300, 20) -- Adjust size as needed
    title:SetText("Verification System")
    title:SetFont("UI.Font")
    title:SetTextColor(Color(255, 255, 255))


    -- Custom close button
    local closeButton = vgui.Create("DLabel", frame)
    closeButton:SetPos(280, 5) -- Adjust position as needed
    closeButton:SetSize(20, 20) -- Adjust size as needed
    closeButton:SetText("X")
    closeButton:SetFont("UI.Font")
    closeButton:SetTextColor(Color(255, 255, 255))
    closeButton:SetMouseInputEnabled(true)
    closeButton.DoClick = function()
        frame:Close()
    end
    closeButton.Paint = function(self, w, h)
        if self:IsHovered() then
            self:SetTextColor(Color(203, 39, 39)) -- Close button hover color
        else
            self:SetTextColor(Color(255, 255, 255)) -- Close button idle color
        end
    end

    local verifyButton = vgui.Create("DButton", frame)
    verifyButton:SetText("Verify Me")
    verifyButton:SetTextColor(Color(255, 255, 255))
    verifyButton:SetPos(50, 50)
    verifyButton:SetSize(200, 50)
    verifyButton:SetFont("UI.Font")
    verifyButton.Paint = function(self, w, h)
        -- dark mode button if hovered and active colors 
        if self:IsHovered() then
            draw.RoundedBox(5, 0, 0, w, h, Color(34, 34, 46))
        else
            draw.RoundedBox(5, 0, 0, w, h, Color(27, 27, 37))
        end
    end
    verifyButton.DoClick = function()
        net.Start("VERIFY:ME")
        net.SendToServer()
        chat.AddText(Color(192,126,60), "VERIFY | ", Color(255,255,255), "Verification request sent!") -- Tell the player in chat that the verification request was sent
        frame:Close() -- Close the UI after sending the verification request
    end
end)

-- net VERIFY:STATUS will return with a boolean and true is verified, false is not verified, tell player in chat on return
net.Receive("VERIFY:STATUS", function()
    local isVerified = net.ReadBool()
    if isVerified then
        chat.AddText(Color(60,192,78), "VERIFY | ", Color(255,255,255), "You are verified!")
    else
        -- if not verified, tell the player in chat to visit https://auth.bioboltint.com/
        chat.AddText(Color(196,49,30), "VERIFY | ", Color(255,255,255), "You are not verified! Visit https://auth.bioboltint.com/ to verify.")
    end
end)

-- if player says !claim or !verify in chat, open the UI
hook.Add("OnPlayerChat", "OpenVerifyUI", function(ply, text)
    if ply == LocalPlayer() then
        if text == "!claim" or text == "!verify" then
            RunConsoleCommand("open_verify_ui")
        end
    end
end)
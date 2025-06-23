function CHARACTER.WarningMsg(msg)
    local sW, sH = ScrW(), ScrH()
    local warnPanel = vgui.Create( "EditablePanel" )
    warnPanel:SetPos( 0, 0 )
    warnPanel:SetSize( sW, sH )

    local warnLabel = vgui.Create( "DLabel", warnPanel )
    warnLabel:SetPos( sW / 2 - 200, sH / 2 - 100)
    warnLabel:SetSize( 400, 50 )
    warnLabel:SetFont( "Character_Title" )
    warnLabel:SetText( "WARNING" )
    warnLabel:SetTextColor( Color( 240, 47, 47) )
    warnLabel:SetContentAlignment( 5 )

    -- Check if msg is too long and if so, split it into multiple lines to fit the box
    local msgLength = string.len(msg)
    local newMsg = ""
    if msgLength > 40 then
        -- Split the string into multiple lines but do not split words
        local splitMsg = string.Split(msg, " ")
        newMsg = ""
        local lineLength = 0
        for k, v in pairs(splitMsg) do
            lineLength = lineLength + string.len(v)
            if lineLength > 35 then
                newMsg = newMsg .. "\n" .. v .. " "
                lineLength = 0
            else
                newMsg = newMsg .. v .. " "
            end
        end
    else
        newMsg = msg
    end



    local warnText = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", warnPanel )
    warnText:SetPos( sW / 2 - 180, sH / 2 - 50)
    warnText:SetSize( 400, 50 )
    warnText:SetFont( "Character_Locked_Description" )
    warnText:SetText( newMsg )
    warnText:SetTextColor( Color( 255, 255, 255, 255 ) )
    warnText:SetContentAlignment( 5 )

    -- Center the the label
    warnText:SetPos( sW / 2 - warnText:GetWide() / 2, sH / 2.05 - warnText:GetTall() / 2)


    -- Early close button
    local warnCloseButton = vgui.Create( "DButton", warnPanel )
    warnCloseButton:SetPos( sW / 2 - 200, sH / 2 + 50)
    warnCloseButton:SetSize( 400, 50 )
    warnCloseButton:SetText( "CLOSE (7)" )
    warnCloseButton:SetTextColor( Color( 255, 255, 255, 255 ) )
    warnCloseButton:SetFont( "Character_Title" )

    warnCloseButton.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 38, 38, 43) )
        if s:IsHovered() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 211, 47, 47) )
        end
    end

    warnCloseButton.DoClick = function()
        warnPanel:Remove()
    end


    warnPanel.Paint = function(s, w, h)
        Derma_DrawBackgroundBlur( s, s.m_fCreateTime )
        draw.RoundedBox( 0, w / 2 - 200, h / 2 - 100, 400, 200, Color( 27, 27, 35) )
    end

    -- Change the text of the close button to 6, 5, 4, 3, 2, 1
    timer.Create("ATLAS::Characters::WarningTimer", 1, 7, function()
        if IsValid(warnPanel) and IsValid(warnCloseButton) then
            -- If the timer is at 0 then remove the panel
            local reps = timer.RepsLeft("ATLAS::Characters::WarningTimer")
            warnCloseButton:SetText( "CLOSE (" .. reps .. ")" )
            if reps == 0 then
                warnPanel:Remove()
            end
        else
            timer.Remove("ATLAS::Characters::WarningTimer")
        end
    end)

    warnPanel:MakePopup()
end
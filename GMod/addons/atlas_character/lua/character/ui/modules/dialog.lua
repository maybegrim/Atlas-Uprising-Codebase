local dialog = {}

-- Variables declared for icons
local playIcon = Material( "materials/ui/play.png" )
local editIcon = Material( "materials/ui/edit.png" )
local deleteIcon = Material( "materials/ui/delete.png" )

-- Utility functions for dialog code
local function playChar(charVar)
    net.Start("ATLAS::Characters::PlayChar")
    net.WriteString(charVar.first_name)
    net.WriteString(charVar.last_name)
    net.SendToServer()
end

local buttonStates = {
    play = { curTime = CurTime(), hoverFirst = false, inAnim = false, inCloseAnim = false },
    edit = { curTime = CurTime(), hoverFirst = false, inAnim = false, inCloseAnim = false },
    delete = { curTime = CurTime(), hoverFirst = false, inAnim = false, inCloseAnim = false }
}

-- Create a utility function to handle button painting with different parameters
local function paintButton(s, w, h, color, icon, text, state)
    draw.RoundedBox(0, 0, 0, w, h, color)
    
    local isHovered = s:IsHovered()
    local curTime = state.curTime
    local hoverFirst = state.hoverFirst
    local inAnim = state.inAnim
    local inCloseAnim = state.inCloseAnim
    local x = 0
    local progress = math.Clamp((CurTime() - curTime) / (isHovered and 0.3 or 0.5), 0, 1)
    local fadeProgress = 0
    local textFadeDelay = 0.15

    if isHovered then
        if not hoverFirst then
            curTime = CurTime()
            hoverFirst = true
            inAnim = true
            inCloseAnim = false
        end
        x = Lerp(progress, 0, -w / 4)
        fadeProgress = math.Clamp(progress - textFadeDelay, 0, 1)
        if progress >= 1 then
            inAnim = false
        end
    else
        if hoverFirst then
            curTime = CurTime()
            hoverFirst = false
            inCloseAnim = true
            inAnim = false
        end
        x = Lerp(progress, -w / 4, 0)
        fadeProgress = math.Clamp(1 - progress / (1 - textFadeDelay), 0, 1)
        if progress >= 1 then
            inCloseAnim = false
        end
    end

    surface.SetDrawColor(Color(255, 255, 255))
    surface.SetMaterial(icon)
    surface.DrawTexturedRect(w / 2 - 16 + x, h / 2 - 16, 32, 32)
    draw.SimpleText(text, "Character_Title", w / 2, h / 2, Color(255, 255, 255, 255 * fadeProgress), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    state.curTime = curTime
    state.hoverFirst = hoverFirst
    state.inAnim = inAnim
    state.inCloseAnim = inCloseAnim
end






function dialog.Create(charVar, parent)
    -- TODO: If dialog popup is already present then we shouldn't show a new one. Another solution to this aswell is just blocking out the entire background. But that's not favorable imo.
    if CHARACTER.DialogPopup and IsValid(CHARACTER.DialogPopup) then 
        CHARACTER.DialogPopup:Remove()
    end
    local dialogPanel = vgui.Create( "EditablePanel", parent )
    CHARACTER.DialogPopup = dialog
    dialogPanel:SetSize( 400, 300 )
    dialogPanel:Center()
    dialogPanel.OnRemove = function()
        CHARACTER.DialogPopup = false
    end
    dialogPanel.Paint = function(s, w, h)
        surface.SetDrawColor( Color( 27, 27, 35) )
        surface.DrawRect( 0, 0, w, h )

        Derma_DrawBackgroundBlur( s, s.m_fCreateTime )
    end

    local dialogLabel = vgui.Create( "DLabel", dialogPanel )
    dialogLabel:Dock(TOP)
    dialogLabel:SetSize( 400, 50 )
    dialogLabel:SetFont( "Character_Title" )
    dialogLabel:SetText( "CHARACTER OPTIONS" )
    dialogLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
    dialogLabel:SetContentAlignment( 5 )

    local dialogPlayButton = vgui.Create( "DButton", dialogPanel )
    --dialogPlayButton:SetPos( 0, 50 )
    dialogPlayButton:Dock(TOP)
    dialogPlayButton:DockMargin(50, 0, 50, 0)
    dialogPlayButton:SetSize( 400, 50 )
    dialogPlayButton:SetText( "" )
    dialogPlayButton:SetTextColor( Color( 255, 255, 255) )
    dialogPlayButton:SetFont( "Character_Title" )
    dialogPlayButton.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 96, 248, 132) )

        surface.SetDrawColor( Color( 255, 255, 255) )
        surface.SetMaterial( playIcon )
        surface.DrawTexturedRect( 10, h / 2 - 16, 32, 32 )
    end

    dialogPlayButton.DoClick = function()
        dialogPanel:Remove()
        CHARACTER.DialogPopup = false
        CHARACTER.OpenLoadingScreen()
        timer.Simple(10, function()
            CHARACTER.CloseLoadingScreen()
        end)
        playChar(charVar)
    end

    local dialogEditButton = vgui.Create( "DButton", dialogPanel )
    --dialogEditButton:SetPos( 0, 100 )
    dialogEditButton:Dock(TOP)
    dialogEditButton:DockMargin(50, 10, 50, 0)
    dialogEditButton:SetSize( 400, 50 )
    dialogEditButton:SetText( "" )
    dialogEditButton:SetTextColor( Color( 255, 255, 255) )
    dialogEditButton:SetFont( "Character_Title" )
    dialogEditButton.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 153, 105) )

        surface.SetDrawColor( Color( 255, 255, 255) )
        surface.SetMaterial( editIcon )
        surface.DrawTexturedRect( 10, h / 2 - 16, 32, 32 )
    end



    dialogEditButton.DoClick = function()
        CHARACTER.CloseCharScreen()
        CHARACTER.OpenCharCreation(false, true, charVar)
    end

    local dialogDeleteButton = vgui.Create( "DButton", dialogPanel )
    --dialogDeleteButton:SetPos( 0, 150 )
    dialogDeleteButton:Dock(TOP)
    dialogDeleteButton:DockMargin(50, 10, 50, 0)
    dialogDeleteButton:SetSize( 400, 50 )
    dialogDeleteButton:SetText( "" )
    dialogDeleteButton:SetTextColor( Color( 255, 255, 255) )
    dialogDeleteButton:SetFont( "Character_Title" )



    dialogDeleteButton.DoClick = function()

        CHARACTER.ConfirmDeleteUI(function()
            CHARACTER.OpenLoadingScreen()

            net.Start("ATLAS::Characters::DeleteChar")
            net.WriteString(charVar.first_name)
            net.WriteString(charVar.last_name)
            net.SendToServer()

            -- Just in case the server doesn't reply.
            timer.Simple(5, function()
                CHARACTER.CloseLoadingScreen()
            end)
        end)
    end

    local dialogCloseButton = vgui.Create( "DButton", dialogPanel )
    dialogCloseButton:Dock(TOP)
    dialogCloseButton:DockMargin(50, 10, 50, 0)
    dialogCloseButton:SetSize( 400, 50 )
    dialogCloseButton:SetText( "CLOSE" )
    dialogCloseButton:SetTextColor( Color( 255, 255, 255, 255 ) )
    dialogCloseButton:SetFont( "Character_Title" )
    dialogCloseButton.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 33, 33, 38) )
    end

    dialogCloseButton.DoClick = function()
        dialogPanel:Remove()
    end

    dialogPlayButton.Paint = function(s, w, h)
        paintButton(s, w, h, Color(59, 223, 128), playIcon, "PLAY", buttonStates.play)
    end

    dialogEditButton.Paint = function(s, w, h)
        paintButton(s, w, h, Color(248, 147, 80), editIcon, "EDIT", buttonStates.edit)
    end

    dialogDeleteButton.Paint = function(s, w, h)
        paintButton(s, w, h, Color(211, 47, 47), deleteIcon, "DELETE", buttonStates.delete)
    end


    dialogPanel:MakePopup()
end

return dialog
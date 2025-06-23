INVENTORY.TradePanel = INVENTORY.TradePanel or false

surface.CreateFont("InventoryButtonFont", {
    font = "Roboto",
    size = 32,
    weight = 500,
    antialias = true,
    shadow = false
})

local invColumns, invRows = INVENTORY.CONFIG.Columns, INVENTORY.CONFIG.Rows
local audio = include("inventory/ui/sound/util.lua")
local status_check, status_cross = Material("materials/inventory/trade/style_one_check.png"), Material("materials/inventory/trade/style_one_cross.png")
local tradeLocalStatus, tradePartnerStatus = false, false
local theme = {
    background = {r = 38, g = 38, b = 38, a = 200},
    item_rarity = {
        [0] = {r = 219, g = 219, b = 219, a = 255}, -- Common
        [1] = {r = 255, g = 56, b = 56, a = 255}, -- Rare
        [2] = {r = 97, g = 188, b = 237, a = 255}, -- Purchased from store
        [3] = {r = 22, g = 23, b = 36, a = 255}, -- SCP
        [4] = {r = 227, g = 149, b = 82, a = 255}, -- Job specific
    }
}

local function drawArmorBar(item, w, h)
    -- Read the armor value for the specific piece of armor
    local armorValue = INVENTORY.NET.ReadData(item.id, "value") or item.ArmorValue
    local fullAP = false
    -- Use the MaxArmorValue for the specific piece of armor
    local armorMax = item.MaxArmorValue
    if armorValue == armorMax then
        fullAP = true
    end
    -- Normalize the armor value
    armorValue = math.Round(armorValue) * (armorMax * 0.04)

    if fullAP then
        -- make bar full
        armorValue = armorMax
    end
    local armorBarWidth = 6
    local armorBarHeight = 73
    local armorBarX = w - armorBarWidth - 6
    local armorBarY = h / 2 - armorBarHeight / 2 - 12

    -- Draw the background of the armor bar

    -- Draw the inner, black part of the armor bar
    surface.SetDrawColor(Color(0, 0, 0, 255))
    surface.DrawRect(armorBarX + 1, armorBarY + 1, armorBarWidth - 2, armorBarHeight - 2)

    -- Calculate the color and fill ratio based on the current armor value
    local armorRatio = armorValue / armorMax
    local r = 255 * (1 - armorRatio)
    local g = 255 * armorRatio
    surface.SetDrawColor(Color(r, g, 0))

    -- Calculate the filled portion of the armor bar
    local filledArmorBarHeight = armorRatio * (armorBarHeight - 2)
    -- Draw the filled portion of the armor bar
    surface.DrawRect(armorBarX + 1, armorBarY + 1 + (armorBarHeight - 2 - filledArmorBarHeight), armorBarWidth - 2, filledArmorBarHeight)
end


--[[
    tradeData:
    tradePly - The player you are trading with
]]
function INVENTORY:OpenTradePanel(tradeData)
    tradeLocalStatus, tradePartnerStatus = false, false

    if INVENTORY.TradePanel then
        INVENTORY.TradePanel:Remove()
    end

    local scrW, scrH = ScrW(), ScrH()

    -- Create a editable panel that covers the whole screen
    local panel = vgui.Create("EditablePanel")
    panel:SetSize(scrW, scrH)
    panel:MakePopup()
    panel:SetKeyboardInputEnabled(false)
    panel:SetMouseInputEnabled(true)
    panel:Center()
    panel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(theme.background.r, theme.background.g, theme.background.b, theme.background.a))
    end


    INVENTORY.TradePanel = panel

    audio.PlayInvSound("open")

    -- Add a close button in the top right corner
    local closeButton = vgui.Create("DButton", panel)
    closeButton:SetSize(32, 32)
    closeButton:SetPos(panel:GetWide() - 32, 0)
    closeButton:SetText("")
    closeButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 200))
    end
    -- Early function to close the panel
    closeButton.DoClick = function()
        panel:Remove()
    end









    --[[
        
        [SECTIONS]
        - Header

    ]]

    -- [HEADER]
    local header = vgui.Create("DPanel", panel)
    --header:SetSize(250, 100)
    header:SetPos(0, 0)

    local barThickness = 5
    header.Paint = function(self, w, h)
        -- Draw white lines outlining the header except for the top
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)

    end

    -- [HEADER] - Title
    local title = vgui.Create("DLabel", header)
    title:SetPos(0, 0)
    title:SetText("Atlas Backpack")
    title:SetFont("InventoryTitle")
    title:SetTextColor(Color(255, 255, 255, 255))
    title:SetContentAlignment(5)
    title:SizeToContents()


    -- [HEADER] - Sizing and Positioning
    header:SetSize(title:GetWide() + 40, title:GetTall() + 40)

    title:CenterHorizontal()
    title:CenterVertical()

    -- Center header
    header:CenterHorizontal()
    header:CenterVertical(0.02)

    -- [HEADER] - Sub Title
    local subTitle = vgui.Create("DLabel", panel)
    subTitle:SetPos(0, 0)
    if tradeData and tradeData.tradePly then
        subTitle:SetText("TRADING: " .. tradeData.tradePly:Nick())
    else
        subTitle:SetText("TRADING: Unknown")
    end
    subTitle:SetFont("InventoryTitle")
    subTitle:SetTextColor(Color(255, 255, 255, 255))
    subTitle:SetContentAlignment(5)
    subTitle:SizeToContents()


    subTitle:CenterHorizontal()
    subTitle:CenterVertical(0.1)


    -- [CONTENTS]
    local contents = vgui.Create("DPanel", panel)
    contents:SetSize(650, 600)
    -- left center
    contents:SetPos(ScrW() / 4 - contents:GetWide() / 2, ScrH() / 2 - contents:GetTall() / 2)

    local contentsPadding = 10
    contents.Paint = function(self, w, h)
        -- draw faded background with rounded corners
        draw.RoundedBox(10, 0, 0, w, h, Color(31, 31, 40, 200))
    end

    -- [CONTENTS] - Title
    local contentsTitle = vgui.Create("DLabel", contents)
    contentsTitle:SetText("Your Contents")
    contentsTitle:SetFont("InventoryTitle")
    contentsTitle:SetTextColor(Color(255, 255, 255, 255))
    contentsTitle:SizeToContents()
    contentsTitle:CenterHorizontal()

    -- [CONTENTS] - Item Grid
    local itemGrid = vgui.Create("DPanel", contents)
    itemGrid:Dock(FILL)
    itemGrid:DockMargin(contentsPadding, 40, contentsPadding, contentsPadding)
    itemGrid.Paint = function(self, w, h)
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)
    end

    -- [CONTENTS] - Item Grid - Scroll Panel
    local itemGridScroll = vgui.Create("DScrollPanel", itemGrid)
    itemGridScroll:Dock(FILL)
    itemGridScroll:DockMargin(10, 10, 10, 10)
    itemGridScroll:DockPadding(0, 0, 0, 0)


    -- Paint the scroll bar

    itemGridScroll.VBar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
    end

    -- Make grip background darker
    itemGridScroll.VBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(31, 31, 40))
    end

    itemGridScroll.VBar.btnUp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(84, 82, 82, 255))
    end

    itemGridScroll.VBar.btnDown.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(84, 82, 82, 255))
    end



    -- [CONTENTS] - Item Grid - Item Slots

    local itemSlots = {}
    local itemSlotSize = 110
    local itemSlotPadding = 5
    local itemSlotColumns = invColumns
    local itemSlotRows = invRows
    local itemSlotTotal = itemSlotColumns * itemSlotRows
    local itemSlotX, itemSlotY = 0, 0
    local draggedItem = nil
    local isDragging = false
    local originalSlot = false
    -- TODO: Optimize call to itemSlots by localizing it
    for i = 1, itemSlotTotal do
        itemSlots[i] = vgui.Create("DPanel", itemGridScroll)
        itemSlots[i]:SetSize(itemSlotSize, itemSlotSize)
        itemSlots[i]:SetPos(itemSlotX, itemSlotY)
        itemSlots[i]:SetBackgroundColor(Color(255, 0, 0, 255))
        -- change cursor to hand when hovering over item slot
        itemSlots[i]:SetCursor("hand")
        itemSlots[i].Paint = function(self, w, h)
            -- Draw white lines outlining the itemgrid
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.DrawRect(0, 0, barThickness, h)
            surface.DrawRect(0, h - barThickness, w, barThickness)
            surface.DrawRect(w - barThickness, 0, barThickness, h)
            surface.DrawRect(0, 0, w, barThickness)



            if self.item then
                -- draw a background for the text at the bottom center
                surface.SetDrawColor(Color(82, 82, 82, 200))
                surface.DrawRect(barThickness, h - 25 - barThickness, w - (barThickness * 2), 30 - barThickness)

                surface.SetFont("InventoryTileFont")
                surface.SetTextColor( 255, 255, 255 )
                local text = self.item.Name
                local textW, textH = surface.GetTextSize(text)
                -- bottom center
                surface.SetTextPos( w / 2 - textW / 2, h - textH - 8 )
                surface.DrawText(text)

                -- draw the icon
                surface.SetDrawColor(Color(255, 255, 255, 255))
                surface.SetMaterial(Material(self.item.Icon))
                -- draw above text centered
                surface.DrawTexturedRect(w / 2 - 32, h / 2 - (32 + 13), 64, 64)
                local rarity = self.item.Rare
                surface.SetDrawColor(Color(theme.item_rarity[rarity].r, theme.item_rarity[rarity].g, theme.item_rarity[rarity].b, theme.item_rarity[rarity].a))
                surface.SetMaterial(Material("materials/inventory/items/rarity_circle_glow.png"))
                surface.DrawTexturedRect(8, 8, 16, 16)

                -- if hovering rarity circle, tooltip with rarity name
                local mouseposX, mouseposY = self:CursorPos()
                if mouseposX >= 8 and mouseposX <= 24 and mouseposY >= 8 and mouseposY <= 24 then
                    local rarityName = ""
                    if rarity == 0 then
                        rarityName = "Common"
                    elseif rarity == 1 then
                        rarityName = "Rare"
                    elseif rarity == 2 then
                        rarityName = "Store"
                    elseif rarity == 3 then
                        rarityName = "SCP"
                    elseif rarity == 4 then
                        rarityName = "Job"
                    end
                    local textW, textH = surface.GetTextSize(rarityName)
                    draw.RoundedBox(10, mouseposX + 10, mouseposY + 12, textW + 9, 24, Color(0, 0, 0, 240))
                    draw.SimpleText(rarityName, "InventoryTileFont", mouseposX + 15, mouseposY + 15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                end

                -- if item is armor then draw armor bar
                if self.item.Type == "armor" then
                    drawArmorBar(self.item, w, h)
                end

            else
                draw.SimpleText("Empty", "InventoryTileFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        -- On click show a context menu of options
        itemSlots[i].OnMousePressed = function(self, key)
            local item = itemSlots[i].item
            if not item then return end
            if key == MOUSE_RIGHT then
                local menu = DermaMenu()

                -- Add a panel with the name of the item
                local namePanel = vgui.Create("DPanel")
                namePanel:SetSize(200, 30)
                namePanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(48, 48, 84))
                    draw.SimpleText(item.Name, "InventoryTileFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                    -- Draw two lines at both left and right ends do not fully touch the edges
                    surface.SetDrawColor(Color(255, 255, 255, 255))
                    surface.DrawRect(0, h - 3, w, 3)
                end

                menu:AddPanel(namePanel)

                -- TODO: Determine if item supports these options
                if item.Can.Use then
                    menu:AddOption("Use", function()
                        INVENTORY.UseItem(item.id)
                    end)
                end
                if item.Can.Equip then
                    menu:AddOption("Equip", function()
                        INVENTORY.Panel.EquipItem(item)
                    end)
                end
                if item.Can.Destroy then
                    menu:AddOption("Destroy", function()
                        -- Destroy the item params: item, column, row
                        local column = (i - 1) % itemSlotColumns + 1
                        local row = math.floor((i - 1) / itemSlotColumns) + 1
                        PrintTable(item)
                        INVENTORY.DestroyItem(item.id, column, row)
                    end)
                end

                local menuPanel = menu:GetCanvas()
                menuPanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(31, 31, 40))
                end
                local oldText = {}
                for k,v in pairs(menuPanel:GetChildren()) do
                    if v:GetName() == "DMenuOption" then
                        oldText[k] = v:GetText()

                        v.Paint = function(self, w, h)
                            draw.RoundedBox(0, 0, 0, w, h, Color(31, 31, 40))
                            draw.SimpleText(oldText[k], "InventoryTileFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                            if self.Hovered then
                                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 10))
                            end
                        end
                        -- Hide text but do not change it to a blank string
                        v:SetText("")
                    end
                end

                menu:Open()
            end

            if key == MOUSE_LEFT then
                if tradeLocalStatus then return end
                if item and not isDragging then
                    draggedItem = item
                    itemSlots[i].item = nil -- Do not use item = nil
                    isDragging = true  -- Set the dragging flag
                    originalSlot = itemSlots[i] -- Do not use local variable item
                    audio.PlayInvSound("pickup_normal")
                end
            end
        end

        itemSlots[i].OnMouseReleased = function()
            if draggedItem and isDragging and not itemSlots[i].item then
                itemSlots[i].item = draggedItem
                draggedItem = nil
                isDragging = false  -- Clear the dragging flag
                originalSlot = nil
                audio.PlayInvSound("release_normal")
            elseif draggedItem and isDragging and itemSlots[i].item then
                -- Swap items
                local tempItem = itemSlots[i].item
                itemSlots[i].item = draggedItem
                draggedItem = tempItem
                if originalSlot then
                    if originalSlot.WeaponSlot then
                        originalSlot.activeItem = tempItem
                    else
                        originalSlot.item = tempItem
                    end
                end
                audio.PlayInvSound("release_normal")
            end
        end

        itemSlots[i].item = false



        itemSlotX = itemSlotX + itemSlotSize + itemSlotPadding

        if i % itemSlotColumns == 0 then
            itemSlotX = 0
            itemSlotY = itemSlotY + itemSlotSize + itemSlotPadding
        end
    end




    -- [Your Trade Contents]
    local yourTradePanel = vgui.Create("DPanel", panel)
    yourTradePanel:SetSize(610, 180)
    -- center under contents
    yourTradePanel:SetPos(ScrW() / 4 - yourTradePanel:GetWide() / 2, ScrH() / 3 - yourTradePanel:GetTall() / 2 + contents:GetTall())
    yourTradePanel.Paint = function(self, w, h)
        -- draw faded background with rounded corners
        draw.RoundedBox(10, 0, 0, w, h, Color(31, 31, 40, 200))
    end

    -- [Your Trade Contents] - Title
    local yourTradeTitle = vgui.Create("DLabel", yourTradePanel)
    yourTradeTitle:SetText("Your Trade Contents")
    yourTradeTitle:SetFont("InventoryTitle")
    yourTradeTitle:SetTextColor(Color(255, 255, 255, 255))
    yourTradeTitle:SizeToContents()
    yourTradeTitle:CenterHorizontal()
    
    -- [Your Trade Contents] - Item Grid
    local yourTradeItemGrid = vgui.Create("DPanel", yourTradePanel)
    yourTradeItemGrid:Dock(FILL)
    yourTradeItemGrid:DockMargin(contentsPadding, 40, contentsPadding, contentsPadding)
    yourTradeItemGrid.Paint = function(self, w, h)
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)
    end

    -- [Your Trade Contents] - Item Grid - Scroll Panel
    local yourTradeItemGridScroll = vgui.Create("DScrollPanel", yourTradeItemGrid)
    yourTradeItemGridScroll:Dock(FILL)
    yourTradeItemGridScroll:DockMargin(10, 10, 10, 10)
    yourTradeItemGridScroll:DockPadding(0, 0, 0, 0)


    -- Paint the scroll bar

    yourTradeItemGridScroll.VBar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
    end

    -- Make grip background darker
    yourTradeItemGridScroll.VBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(31, 31, 40))
    end

    yourTradeItemGridScroll.VBar.btnUp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(84, 82, 82, 255))
    end

    yourTradeItemGridScroll.VBar.btnDown.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(84, 82, 82, 255))
    end



    -- [Your Trade Contents] - Item Grid - Item Slots
    local yourTradeItemSlots = {}
    local yourTradeItemSlotSize = 110
    local yourTradeItemSlotPadding = 5
    local yourTradeItemSlotColumns = 1
    local yourTradeItemSlotRows = 1
    local yourTradeItemSlotTotal = yourTradeItemSlotColumns * yourTradeItemSlotRows
    local yourTradeItemSlotX, yourTradeItemSlotY = 0, 0

    for i = 1, yourTradeItemSlotTotal do
        yourTradeItemSlots[i] = vgui.Create("DPanel", yourTradeItemGridScroll)
        yourTradeItemSlots[i]:SetSize(yourTradeItemSlotSize, yourTradeItemSlotSize)
        yourTradeItemSlots[i]:SetPos(yourTradeItemSlotX, yourTradeItemSlotY)
        yourTradeItemSlots[i]:SetBackgroundColor(Color(255, 0, 0, 255))
        -- change cursor to hand when hovering over item slot
        yourTradeItemSlots[i]:SetCursor("hand")
        yourTradeItemSlots[i].Paint = function(self, w, h)
            -- Draw white lines outlining the itemgrid
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.DrawRect(0, 0, barThickness, h)
            surface.DrawRect(0, h - barThickness, w, barThickness)
            surface.DrawRect(w - barThickness, 0, barThickness, h)
            surface.DrawRect(0, 0, w, barThickness)

            if self.item then
                -- draw a background for the text at the bottom center
                surface.SetDrawColor(Color(82, 82, 82, 200))
                surface.DrawRect(barThickness, h - 25 - barThickness, w - (barThickness * 2), 30 - barThickness)

                surface.SetFont("InventoryTileFont")
                surface.SetTextColor(255, 255, 255)
                local text = self.item.Name
                local textW, textH = surface.GetTextSize(text)
                -- bottom center
                surface.SetTextPos(w / 2 - textW / 2, h - textH - 8)
                surface.DrawText(text)

                -- draw the icon
                surface.SetDrawColor(Color(255, 255, 255, 255))
                surface.SetMaterial(Material(self.item.Icon))
                -- draw above text centered
                surface.DrawTexturedRect(w / 2 - 32, h / 2 - (32 + 13), 64, 64)
                local rarity = self.item.Rare
                surface.SetDrawColor(Color(theme.item_rarity[rarity].r, theme.item_rarity[rarity].g, theme.item_rarity[rarity].b, theme.item_rarity[rarity].a))
                surface.SetMaterial(Material("materials/inventory/items/rarity_circle_glow.png"))
                surface.DrawTexturedRect(8, 8, 16, 16)

                -- if hovering rarity circle, tooltip with rarity name
                local mouseposX, mouseposY = self:CursorPos()
                if mouseposX >= 8 and mouseposX <= 24 and mouseposY >= 8 and mouseposY <= 24 then
                    local rarityName = ""
                    if rarity == 0 then
                        rarityName = "Common"
                    elseif rarity == 1 then
                        rarityName = "Rare"
                    elseif rarity == 2 then
                        rarityName = "Store"
                    elseif rarity == 3 then
                        rarityName = "SCP"
                    elseif rarity == 4 then
                        rarityName = "Job"
                    end
                    local textW, textH = surface.GetTextSize(rarityName)
                    draw.RoundedBox(10, mouseposX + 10, mouseposY + 12, textW + 9, 24, Color(0, 0, 0, 240))
                    draw.SimpleText(rarityName, "InventoryTileFont", mouseposX + 15, mouseposY + 15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                end

                -- if item is armor then draw armor bar
                if self.item.Type == "armor" then
                    drawArmorBar(self.item, w, h)
                end
            else
                draw.SimpleText("Empty", "InventoryTileFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        -- On click show a context menu of options
        yourTradeItemSlots[i].OnMousePressed = function(self, key)
            local item = yourTradeItemSlots[i].item
            if not item then return end

            if key == MOUSE_LEFT then
                if tradeLocalStatus then return end
                if item and not isDragging then
                    draggedItem = item
                    yourTradeItemSlots[i].item = nil -- Do not use item = nil
                    isDragging = true  -- Set the dragging flag
                    originalSlot = yourTradeItemSlots[i] -- Do not use local variable item
                    audio.PlayInvSound("pickup_normal")
                    
                net.Start("Inventory::TradeUpdate")
                    net.WriteTable(INVENTORY.TradePanel.GetTradeItems())
                net.SendToServer()
                end
            end
        end

        -- On click show a context menu of options
        yourTradeItemSlots[i].OnMouseReleased = function()
            if draggedItem and isDragging and not yourTradeItemSlots[i].item then
                yourTradeItemSlots[i].item = draggedItem
                draggedItem = nil
                isDragging = false  -- Clear the dragging flag
                originalSlot = nil
                audio.PlayInvSound("release_normal")
                net.Start("Inventory::TradeUpdate")
                    net.WriteTable(INVENTORY.TradePanel.GetTradeItems())
                net.SendToServer()
            elseif draggedItem and isDragging and yourTradeItemSlots[i].item then
                -- Swap items
                local tempItem = yourTradeItemSlots[i].item
                yourTradeItemSlots[i].item = draggedItem
                draggedItem = tempItem
                if originalSlot then
                    originalSlot.item = tempItem
                end
                audio.PlayInvSound("release_normal")
                net.Start("Inventory::TradeUpdate")
                    net.WriteTable(INVENTORY.TradePanel.GetTradeItems())
                net.SendToServer()
            end
        end



        yourTradeItemSlots[i].item = false

        yourTradeItemSlotX = yourTradeItemSlotX + yourTradeItemSlotSize + yourTradeItemSlotPadding

        if i % yourTradeItemSlotColumns == 0 then
            yourTradeItemSlotX = 0
            yourTradeItemSlotY = yourTradeItemSlotY + yourTradeItemSlotSize + yourTradeItemSlotPadding
        end
    end

    local dragPanel = vgui.Create("DPanel", panel)
    dragPanel:SetSize(64, 64)  -- Set the size of the item rendering
    dragPanel:SetMouseInputEnabled(false)
    dragPanel.Paint = function(self, w, h)
        if isDragging and draggedItem then
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.SetMaterial(Material(draggedItem.Icon))
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end

    -- Main panel think function
    panel.Think = function(self)
        -- If dragging an item, draw the item at the mouse position
        if isDragging then
            local mouseX, mouseY = gui.MousePos()
            dragPanel:SetPos(mouseX - 32, mouseY - 32)  -- Center the item on the mouse cursor
        end
        -- Check if the mouse left is released and if so send back item to original slot
        if not input.IsMouseDown(MOUSE_LEFT) and isDragging then
            if not originalSlot then return end
            originalSlot.item = draggedItem
            draggedItem = nil
            isDragging = false
            originalSlot = nil
            audio.PlayInvSound("release_normal")
        end
    end





    -- [Partners Trade Content] 
    local partnerTradeContentPanel = vgui.Create("DPanel", panel)
    partnerTradeContentPanel:SetSize(610, 180)
    -- Center on the right side of the UI
    partnerTradeContentPanel:SetPos(ScrW() / 2.5 - partnerTradeContentPanel:GetWide() / 2 + contents:GetWide() + 10, ScrH() / 50 - partnerTradeContentPanel:GetTall() / 2 + contents:GetTall())
    
    partnerTradeContentPanel.Paint = function(self, w, h)
        -- draw faded background with rounded corners
        draw.RoundedBox(10, 0, 0, w, h, Color(31, 31, 40, 200))
    end

    -- [Partners Trade Content] - Title
    local partnerTradeContentTitle = vgui.Create("DLabel", partnerTradeContentPanel)
    partnerTradeContentTitle:SetText("Partner's Trade Content")
    partnerTradeContentTitle:SetFont("InventoryTitle")
    partnerTradeContentTitle:SetTextColor(Color(255, 255, 255, 255))
    partnerTradeContentTitle:SizeToContents()
    partnerTradeContentTitle:CenterHorizontal()

    -- [Partners Trade Content] - Item Grid
    local partnerTradeContentItemGrid = vgui.Create("DPanel", partnerTradeContentPanel)
    partnerTradeContentItemGrid:Dock(FILL)
    partnerTradeContentItemGrid:DockMargin(contentsPadding, 40, contentsPadding, contentsPadding)

    partnerTradeContentItemGrid.Paint = function(self, w, h)
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)
    end

    -- [Partners Trade Content] - Item Grid - Scroll Panel
    local partnerTradeContentItemGridScroll = vgui.Create("DScrollPanel", partnerTradeContentItemGrid)
    partnerTradeContentItemGridScroll:Dock(FILL)
    partnerTradeContentItemGridScroll:DockMargin(10, 10, 10, 10)
    partnerTradeContentItemGridScroll:DockPadding(0, 0, 0, 0)


    -- Paint the scroll bar

    partnerTradeContentItemGridScroll.VBar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
    end

    -- Make grip background darker
    partnerTradeContentItemGridScroll.VBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(31, 31, 40))
    end

    partnerTradeContentItemGridScroll.VBar.btnUp.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(84, 82, 82, 255))
    end

    partnerTradeContentItemGridScroll.VBar.btnDown.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(84, 82, 82, 255))
    end

    -- [Partners Trade Content] - Item Grid - Item Slots
    local partnerTradeSlots = {}
    local partnerTradeSlotSize = 110 -- Change the size of the partner trade slots to 80
    local partnerTradeSlotPadding = 5 -- Change the padding of the partner trade slots to 10
    local partnerTradeSlotColumns = 1 -- Change the number of columns in the partner trade slots to 4
    local partnerTradeSlotRows = 1 -- Change the number of rows in the partner trade slots to 2
    local partnerTradeSlotTotal = partnerTradeSlotColumns * partnerTradeSlotRows
    local partnerTradeSlotX, partnerTradeSlotY = 0, 0
    local partnerTradeDraggedItem = nil
    local partnerTradeIsDragging = false
    local partnerTradeOriginalSlot = false

    for i = 1, partnerTradeSlotTotal do
        partnerTradeSlots[i] = vgui.Create("DPanel", partnerTradeContentItemGridScroll)
        partnerTradeSlots[i]:SetSize(partnerTradeSlotSize, partnerTradeSlotSize)
        partnerTradeSlots[i]:SetPos(partnerTradeSlotX, partnerTradeSlotY)
        partnerTradeSlots[i]:SetBackgroundColor(Color(255, 0, 0, 255))
        -- change cursor to hand when hovering over item slot
        partnerTradeSlots[i]:SetCursor("hand")

        partnerTradeSlots[i].Paint = function(self, w, h)
            -- Draw white lines outlining the itemgrid
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.DrawRect(0, 0, barThickness, h)
            surface.DrawRect(0, h - barThickness, w, barThickness)
            surface.DrawRect(w - barThickness, 0, barThickness, h)
            surface.DrawRect(0, 0, w, barThickness)

            if self.item then
                -- draw a background for the text at the bottom center
                surface.SetDrawColor(Color(82, 82, 82, 200))
                surface.DrawRect(barThickness, h - 25 - barThickness, w - (barThickness * 2), 30 - barThickness)

                surface.SetFont("InventoryTileFont")
                surface.SetTextColor(255, 255, 255)
                local text = self.item.Name
                local textW, textH = surface.GetTextSize(text)
                -- bottom center
                surface.SetTextPos(w / 2 - textW / 2, h - textH - 8)
                surface.DrawText(text)

                -- draw the icon
                surface.SetDrawColor(Color(255, 255, 255, 255))
                surface.SetMaterial(Material(self.item.Icon))
                -- draw above text centered
                surface.DrawTexturedRect(w / 2 - 32, h / 2 - (32 + 13), 64, 64)
                local rarity = self.item.Rare
                surface.SetDrawColor(Color(theme.item_rarity[rarity].r, theme.item_rarity[rarity].g, theme.item_rarity[rarity].b, theme.item_rarity[rarity].a))
                surface.SetMaterial(Material("materials/inventory/items/rarity_circle_glow.png"))
                surface.DrawTexturedRect(8, 8, 16, 16)

                -- if hovering rarity circle, tooltip with rarity name
                local mouseposX, mouseposY = self:CursorPos()
                if mouseposX >= 8 and mouseposX <= 24 and mouseposY >= 8 and mouseposY <= 24 then
                    local rarityName = ""
                    if rarity == 0 then
                        rarityName = "Common"
                    elseif rarity == 1 then
                        rarityName = "Rare"
                    elseif rarity == 2 then
                        rarityName = "Store"
                    elseif rarity == 3 then
                        rarityName = "SCP"
                    elseif rarity == 4 then
                        rarityName = "Job"
                    end
                    local textW, textH = surface.GetTextSize(rarityName)
                    draw.RoundedBox(10, mouseposX + 10, mouseposY + 12, textW + 9, 24, Color(0, 0, 0, 240))
                    draw.SimpleText(rarityName, "InventoryTileFont", mouseposX + 15, mouseposY + 15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                end

                -- if item is armor then draw armor bar
                if self.item.Type == "armor" then
                    drawArmorBar(self.item, w, h)
                end
            else
                draw.SimpleText("Empty", "InventoryTileFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end


        partnerTradeSlots[i].item = false

        partnerTradeSlotX = partnerTradeSlotX + partnerTradeSlotSize + partnerTradeSlotPadding

        if i % partnerTradeSlotColumns == 0 then
            partnerTradeSlotX = 0
            partnerTradeSlotY = partnerTradeSlotY + partnerTradeSlotSize + partnerTradeSlotPadding
        end
    end


    -- Drag and drop items between your contents and your trade contents
    



    -- [Trade Buttons]

    -- Confirm Trade Button
    local confirmTradeButton = vgui.Create("DButton", panel)
    confirmTradeButton:SetSize(200, 50)
    -- center of screen
    confirmTradeButton:CenterHorizontal()
    confirmTradeButton:CenterVertical(0.75)
    confirmTradeButton:SetText("Confirm Trade")
    confirmTradeButton:SetFont("InventoryButtonFont")
    confirmTradeButton:SetTextColor(Color(255, 255, 255, 255))

    confirmTradeButton.DoClick = function()
        if not tradeLocalStatus then
            tradeLocalStatus = true
            confirmTradeButton:SetText("Unconfirm")
            net.Start("Inventory::TradeConfirm")
                net.WriteBool(true)
            net.SendToServer()
        else
            tradeLocalStatus = false
            confirmTradeButton:SetText("Confirm Trade")
            net.Start("Inventory::TradeConfirm")
                net.WriteBool(false)
            net.SendToServer()
        end
    end
    confirmTradeButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) -- Transparent background

        if self:IsHovered() then
            surface.SetDrawColor(Color(255, 255, 255, 255)) -- Set the color for lines
        else
            surface.SetDrawColor(Color(255, 255, 255, 230)) -- Set the color for lines when not hovered
        end

        surface.DrawOutlinedRect(0, 0, w, h, 5) -- Draw the outline

        if self:IsHovered() then
            draw.RoundedBox(0, 5, 5, w - 10, h - 10, Color(17, 17, 28, 230)) -- Fill in outline when hovered
        end
    end




    -- Cancel Trade Button
    local cancelTradeButton = vgui.Create("DButton", panel)
    cancelTradeButton:SetSize(200, 50)
    -- center of screen
    cancelTradeButton:CenterHorizontal()
    cancelTradeButton:CenterVertical(0.8)
    cancelTradeButton:SetText("Cancel Trade")
    cancelTradeButton:SetFont("InventoryButtonFont")
    cancelTradeButton:SetTextColor(Color(255, 255, 255, 255))

    cancelTradeButton.DoClick = function()
        net.Start("Inventory::TradeCancel")
        net.SendToServer()
        panel:Remove()
    end

    cancelTradeButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) -- Transparent background

        if self:IsHovered() then
            surface.SetDrawColor(Color(115, 14, 14)) -- Set the color for lines
        else
            surface.SetDrawColor(Color(222, 62, 62, 230)) -- Set the color for lines when not hovered
            cancelTradeButton:SetTextColor(Color(255, 255, 255, 255))
        end

        surface.DrawOutlinedRect(0, 0, w, h, 5) -- Draw the outline

        if self:IsHovered() then
            draw.RoundedBox(0, 5, 5, w - 10, h - 10, Color(61, 13, 13, 230)) -- Fill in outline when hovered
        end
    end


    -- [Trade Statuses]
    -- Shows a check or an X depending on if the trade is ready to be confirmed. Shown for both parties.
    local tradeStatusLocal = vgui.Create("DPanel", panel)
    tradeStatusLocal:SetSize(50, 50)
    -- Left of Confirm Trade button
    tradeStatusLocal:SetPos(confirmTradeButton:GetPos() - 52.5, confirmTradeButton:GetPos() - 75)

    tradeStatusLocal.Paint = function(self, w, h)
        -- draw faded background with rounded corners
        draw.RoundedBox(10, 0, 0, w, h, Color(31, 31, 40, 200))

        -- Draw a check or an X depending on if the trade is ready to be confirmed
        if tradeLocalStatus then
            surface.SetDrawColor(Color(255, 255, 255))
            surface.SetMaterial(status_check)
            surface.DrawTexturedRect(9, 9, 32, 32)
        else
            surface.SetDrawColor(Color(255, 255, 255))
            surface.SetMaterial(status_cross)
            -- draw centered 32x32
            surface.DrawTexturedRect(9, 9, 32, 32)
        end
    end

    local tradeStatusPartner = vgui.Create("DPanel", panel)
    tradeStatusPartner:SetSize(50, 50)
    -- Right of Confirm Trade button
    tradeStatusPartner:SetPos(confirmTradeButton:GetPos() + 202.5, confirmTradeButton:GetPos() - 75)

    tradeStatusPartner.Paint = function(self, w, h)
        -- draw faded background with rounded corners
        draw.RoundedBox(10, 0, 0, w, h, Color(31, 31, 40, 200))

        -- Draw a check or an X depending on if the trade is ready to be confirmed
        if tradePartnerStatus then
            surface.SetDrawColor(Color(255, 255, 255))
            surface.SetMaterial(status_check)
            surface.DrawTexturedRect(9, 9, 32, 32)
        else
            surface.SetDrawColor(Color(255, 255, 255))
            surface.SetMaterial(status_cross)
            surface.DrawTexturedRect(9, 9, 32, 32)
        end
    end



--[[
        INVENTORY.Panel.AddItem = function(item, column, row)
        if not item then return end
        local index = (row - 1) * itemSlotColumns + column
        print(index)
        if itemSlots[index] then
            itemSlots[index].item = item
        end
    end

        INVENTORY.Panel.RemoveItem = function(item, column, row)
        if not item then return end
        local index = (row - 1) * itemSlotColumns + column
        if itemSlots[index] and itemSlots[index].item then
            itemSlots[index].item = false
            return
        end
    end
]]

    function INVENTORY.TradePanel.AddItem(item, column, row)
        if not item then return end
        if not column then return end
        if not row then return end
        local index = (row - 1) * itemSlotColumns + column
        print(index)
        if itemSlots[index] then
            itemSlots[index].item = item
        end
    end

    function INVENTORY.TradePanel.RemoveItem(item, column, row)
        if not item then return end
        local index = (row - 1) * itemSlotColumns + column
        if itemSlots[index] and itemSlots[index].item then
            itemSlots[index].item = false
            return
        end
    end

    -- Get all your trade contents items and return as table
    function INVENTORY.TradePanel.GetTradeItems()
        local items = {}
        for k,v in pairs(yourTradeItemSlots) do
            if v.item then
                items[v.item.id] = true
            end
        end
        return items
    end

    function INVENTORY.TradePanel.UpdateTradeStatus(status)
        tradePartnerStatus = status
    end

    function INVENTORY.TradePanel.NewItemUnConfirm()
        tradeLocalStatus = false
        confirmTradeButton:SetText("Confirm Trade")
        net.Start("Inventory::TradeConfirm")
            net.WriteBool(false)
        net.SendToServer()
    end

    -- items table is formatted item = true
    function INVENTORY.TradePanel.PopulatePartnerTradeItems(items)
        for k,v in pairs(partnerTradeSlots) do
            if v.item then
                v.item = false
            end
        end
        if not items then return end
        if table.IsEmpty(items) then return end
        for k,v in pairs(items) do
            -- find next avaialble slot
            for i = 1, partnerTradeSlotTotal do
                if not partnerTradeSlots[i].item then
                    partnerTradeSlots[i].item = k
                    break
                end
            end
        end
    end


    for k,v in pairs(INVENTORY.ItemLayout) do
        INVENTORY.TradePanel.AddItem(v.item, v.column, v.row)
    end

    -- onremove
    panel.OnRemove = function()
        INVENTORY.TradePanel.Panel = nil
    end
end

-- Close the trade panel
function INVENTORY:CloseTradePanel()
    if IsValid(INVENTORY.TradePanel.Panel) then
        INVENTORY.TradePanel.Panel:Remove()
    end
end

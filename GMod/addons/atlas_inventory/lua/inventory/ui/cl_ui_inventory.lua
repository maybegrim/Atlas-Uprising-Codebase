INVENTORY.Panel = INVENTORY.Panel or false
INVENTORY.Cooldown = 0

local invColumns, invRows = INVENTORY.CONFIG.Columns, INVENTORY.CONFIG.Rows

INVENTORY.ItemLayout = INVENTORY.ItemLayout or {}

local audio = include("inventory/ui/sound/util.lua")

local resToPos = {
    below = {
        equipment_horizontal = 0.535,
        equipment_vertical = 0.4,
        stats_horizontal = 0.535,
        stats_vertical = 0.85,
        crafting_horizontal = 0.23,
        crafting_vertical = 0.85,
    },
    normal = {
        equipment_horizontal = 0.5,
        equipment_vertical = 0.4,
        stats_horizontal = 0.5,
        stats_vertical = 0.75,
        crafting_horizontal = 0.23,
        crafting_vertical = 0.8,
    }
}

surface.CreateFont("InventoryTitle", {
    font = "Arial",
    size = 32,
    weight = 700,
    antialias = true
})

for size = 18, 50 do
    surface.CreateFont("InventoryFont_" .. size, {
        font = "Arial",
        size = size,
        weight = 700,
        antialias = true
    })
end

surface.CreateFont("InventoryOperatorsFont", {
    font = "Arial",
    size = 72,
    weight = 500,
    antialias = true
})

surface.CreateFont("InventoryTileFont", {
    font = "Arial",
    size = 18,
    weight = 700,
    antialias = true
})

local theme = {
    background = {r = 38, g = 38, b = 38, a = 240},
    item_rarity = {
        [0] = {r = 219, g = 219, b = 219, a = 255}, -- Common
        [1] = {r = 255, g = 56, b = 56, a = 255}, -- Rare
        [2] = {r = 97, g = 188, b = 237, a = 255}, -- Purchased from store
        [3] = {r = 22, g = 23, b = 36, a = 255}, -- SCP
        [4] = {r = 227, g = 149, b = 82, a = 255}, -- Job specific
    }
}

local justOpened = false

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


local function scaleSize(width, height)
    local scrW, scrH = ScrW(), ScrH()
    local baseW, baseH = 1920, 1080 -- Base resolution
    return width * (scrW / baseW), height * (scrH / baseH)
end

local function scalePos(x, y)
    local scrW, scrH = ScrW(), ScrH()
    local baseW, baseH = 1920, 1080 -- Base resolution
    return x * (scrW / baseW), y * (scrH / baseH)
end



function INVENTORY:OpenUI()
    if INVENTORY.Panel then
        INVENTORY.Panel:Remove()
    end
    justOpened = true
    timer.Simple(0.3, function()
        justOpened = false
    end)

    local scrW, scrH = ScrW(), ScrH()


    local rSize = scrW < 1920 and resToPos.below or resToPos.normal
    

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


    INVENTORY.Panel = panel

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
    header:SetPos(scalePos(0, 0))

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


    -- [CONTENTS]
    local contents = vgui.Create("DPanel", panel)
    contents:SetSize(scaleSize(650, 600))
    contents:Center()

    local contentsPadding = 10
    contents.Paint = function(self, w, h)
        
    end

    -- [CONTENTS] - Title
    local contentsTitle = vgui.Create("DLabel", contents)
    contentsTitle:SetText("CONTENTS")
    contentsTitle:SetFont("InventoryTitle")
    contentsTitle:SetTextColor(Color(255, 255, 255, 255))
    contentsTitle:SizeToContents()

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

    -- [GLOBAL] - Helper Functions
    -- Helper function to handle item swapping
    local function handleItemSwap(slot, newItem)
        local oldItem = slot.item
        slot.item = newItem
        return oldItem
    end

    -- Function to validate if an item can be placed in a given slot
    local function canPlaceItemInSlot(item, slot)
        return item.SWEPSlot == slot.SlotType
    end



    -- [CONTENTS] - Item Grid - Item Slots

    local itemSlots = {}
    local itemSlotSize = scaleSize(110, 110)
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
                -- draw the icon
                surface.SetDrawColor(Color(255, 255, 255, 255))
                surface.SetMaterial(Material(self.item.Icon))
                -- draw above text centered
                --surface.DrawTexturedRect(w / 2 - 32, h / 2 - (32 + 13), 64, 64)
                local iconX, iconY = scaleSize(18, 18)
                local iconW, iconH = scalePos(64, 64)
                surface.DrawTexturedRect(iconX, iconY, iconW, iconH)

                surface.SetDrawColor(Color(82, 82, 82, 200))
                surface.DrawRect(barThickness, h - 25 - barThickness, w - (barThickness * 2), 30 - barThickness)

                surface.SetFont("InventoryTileFont")
                surface.SetTextColor( 255, 255, 255 )
                local text = self.item.Name
                local textW, textH = surface.GetTextSize(text)
                -- bottom center
                surface.SetTextPos( w / 2 - textW / 2, h - textH - 8 )
                surface.DrawText(text)
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
            if draggedItem and isDragging then
                if not itemSlots[i].item then
                    itemSlots[i].item = draggedItem
                    draggedItem = nil
                    isDragging = false
                    originalSlot = nil
                    audio.PlayInvSound("release_normal")
                elseif itemSlots[i].item then
                    if canPlaceItemInSlot(draggedItem, itemSlots[i]) then
                        local tempItem = handleItemSwap(itemSlots[i], draggedItem)
                        draggedItem = tempItem
                        
                        if originalSlot then
                            if canPlaceItemInSlot(tempItem, originalSlot) then
                                originalSlot.activeItem = tempItem
                            else
                                originalSlot.activeItem = draggedItem
                            end
                            audio.PlayInvSound("release_normal")
                        end
                    else
                        print("[V1]Invalid slot for item: " .. draggedItem.Name)
                        print(originalSlot)
                        if originalSlot.activeItem then print("ACTIVESLOT") originalSlot.activeItem = draggedItem else print("ORIGINAL") originalSlot.item = draggedItem end

                        -- We make a timer since this data needs to be delayed for the next tick.
                        timer.Simple(0, function()
                            draggedItem = nil
                            isDragging = false
                            originalSlot = nil
                        end)
                    end
                end
            end
        end
    
        itemSlots[i].item = false
    
        itemSlotX = itemSlotX + itemSlotSize + itemSlotPadding
        if i % itemSlotColumns == 0 then
            itemSlotX = 0
            itemSlotY = itemSlotY + itemSlotSize + itemSlotPadding
        end
    end

    -- [CONTENTS] - Item Drag Panel
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
            if originalSlot then
                if originalSlot.WeaponSlot or originalSlot.GearSlot then
                    originalSlot.activeItem = draggedItem
                else
                    originalSlot.item = draggedItem
                end

                -- We make a timer since this data needs to be delayed for the next tick.
                timer.Simple(0, function()
                    originalSlot = nil
                    draggedItem = nil
                    isDragging = false
                end)
            end
        end
    end

    -- [CONTENTS] - Sizing and Positioning
    contents:CenterHorizontal(0.23)
    contents:CenterVertical(0.4)

    contentsTitle:CenterHorizontal()
    contentsTitle:CenterVertical(0.03)



    -- [CRAFTING]
    local crafting = vgui.Create("DPanel", panel)
    crafting:SetSize(scaleSize(650, 200))

    local craftingPadding = 10
    crafting.Paint = function(self, w, h)
    end

    -- [CRAFTING] - Title
    local craftingTitle = vgui.Create("DLabel", crafting)
    craftingTitle:SetText("CRAFTING")
    craftingTitle:SetFont("InventoryTitle")
    craftingTitle:SetTextColor(Color(255, 255, 255, 255))
    craftingTitle:SizeToContents()

    -- [CRAFTING] - Item Line up
    local craftingLineup = vgui.Create("DPanel", crafting)
    craftingLineup:Dock(FILL)
    local craftingPadding = scaleSize(5, 5)
    craftingLineup:DockMargin(craftingPadding, 40, craftingPadding, craftingPadding)
    craftingLineup.Paint = function(self, w, h)
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)
    end

    -- [CRAFTING] - Items
    -- Make UI centered and look like this: ITEM GRID + ITEM GRID = ITEM GRID

    local craftingItemSize = itemSlotSize
    local craftingItemPadding = 5
    local craftingItemColumns = 3
    local craftingItemRows = 1
    local craftingItemTotal = craftingItemColumns * craftingItemRows
    local craftingItemX, craftingItemY = 30, 20

    local craftingItemOne = vgui.Create("DPanel", craftingLineup)
    craftingItemOne:SetSize(craftingItemSize, craftingItemSize)
    craftingItemOne:SetPos(craftingItemX, craftingItemY)
    craftingItemOne:SetBackgroundColor(Color(255, 0, 0, 255))

    craftingItemX = craftingItemX + craftingItemSize + craftingItemPadding

    local plusSign = vgui.Create("DPanel", craftingLineup)
    plusSign:SetSize(craftingItemSize, craftingItemSize)
    plusSign:SetPos(craftingItemX, craftingItemY)
    plusSign:SetBackgroundColor(Color(255, 0, 0, 255))

    craftingItemX = craftingItemX + craftingItemSize + craftingItemPadding

    local craftingItemTwo = vgui.Create("DPanel", craftingLineup)
    craftingItemTwo:SetSize(craftingItemSize, craftingItemSize)
    craftingItemTwo:SetPos(craftingItemX, craftingItemY)
    craftingItemTwo:SetBackgroundColor(Color(255, 0, 0, 255))

    craftingItemX = craftingItemX + craftingItemSize + craftingItemPadding

    local equalSign = vgui.Create("DPanel", craftingLineup)
    equalSign:SetSize(craftingItemSize, craftingItemSize)
    equalSign:SetPos(craftingItemX, craftingItemY)
    equalSign:SetBackgroundColor(Color(255, 0, 0, 255))

    craftingItemX = craftingItemX + craftingItemSize + craftingItemPadding

    local craftingItemEquals = vgui.Create("DPanel", craftingLineup)
    craftingItemEquals:SetSize(craftingItemSize, craftingItemSize)
    craftingItemEquals:SetPos(craftingItemX, craftingItemY)
    craftingItemEquals:SetBackgroundColor(Color(255, 0, 0, 255))

    -- [CRAFTING] - Item Line up - Paint
    local function paintCraftingLineup(self, w, h)
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)

        -- Draw a background for the text
        surface.SetDrawColor(Color(0, 0, 0, 200))
        surface.DrawRect(barThickness, h - 25 - barThickness, w - (barThickness * 2), 30 - barThickness)

        surface.SetFont("InventoryTileFont")
        surface.SetTextColor( 255, 255, 255 )
        local text = self.item and self.item.Name or "Empty"
        local textW, textH = surface.GetTextSize(text)
        -- bottom center
        surface.SetTextPos( w / 2 - textW / 2, h - textH - 8 )
        surface.DrawText(text)

        -- Draw icon
        if self.item then

            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.SetMaterial(Material(self.item.Icon))
            -- draw above text centered
            surface.DrawTexturedRect(w / 2 - 32, h / 2 - (32 + 13), 64, 64)
            local rarity = self.item.Rare
            surface.SetDrawColor(Color(theme.item_rarity[rarity].r, theme.item_rarity[rarity].g, theme.item_rarity[rarity].b, theme.item_rarity[rarity].a))
            surface.SetMaterial(Material("materials/inventory/items/rarity_circle_glow.png"))
            surface.DrawTexturedRect(8, 8, 16, 16)
        end
    end
    craftingItemOne.Paint = paintCraftingLineup
    plusSign.Paint = function(self, w, h)
        draw.SimpleText("+", "InventoryOperatorsFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    craftingItemTwo.Paint = paintCraftingLineup
    equalSign.Paint = function(self, w, h)
        draw.SimpleText("=", "InventoryOperatorsFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    craftingItemEquals.Paint = paintCraftingLineup

    -- [CRAFTING] Craft Button
    local craftButton = vgui.Create("DButton", crafting)
    craftButton:SetSize(scaleSize(100, 30))
    craftButton:SetText("")
    craftButton.Paint = function(self, w, h)
        -- white outline clear inside
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)

        -- Set text
        surface.SetFont("InventoryTileFont")
        surface.SetTextColor( 255, 255, 255 )
        local text = "Craft"
        local textW, textH = surface.GetTextSize(text)
        -- center
        surface.SetTextPos( w / 2 - textW / 2, h / 2 - textH / 2 )
        surface.DrawText(text)

        if self.Hovered then
            surface.SetDrawColor(Color(255, 255, 255, 10))
            surface.DrawRect(0, 0, w, h)
        end

        if self:IsDown() then
            surface.SetDrawColor(Color(255, 255, 255, 20))
            surface.DrawRect(0, 0, w, h)
        end
    end
    craftButton.DoClick = function()
        if craftingItemEquals.item then
            -- Craft the item
            local item = craftingItemEquals.item
            net.Start("Inventory::Craft")
                net.WriteInt(craftingItemOne.item.id, 21)
                net.WriteInt(craftingItemTwo.item.id, 21)
            net.SendToServer()
        end
    end

    -- [CRAFTING] - Sizing and Positioning
    crafting:CenterHorizontal(rSize.crafting_horizontal)
    crafting:CenterVertical(rSize.crafting_vertical)

    craftingTitle:CenterHorizontal()
    craftingTitle:CenterVertical(0.06)

    -- Craft button goes top right
    craftButton:AlignRight(10)
    craftButton:AlignTop(0.05)

    -- [CRAFTING] - Item Line up - Sizing and Positioning
    craftingLineup:CenterHorizontal()
    craftingLineup:CenterVertical(0.3)

    -- [CRAFTING] - Drag and Drop
    local function dragCraftingLineup(self, key)
        if not self.item then return end
        if key == MOUSE_LEFT then
            if not isDragging then
                draggedItem = self.item
                self.item = nil
                isDragging = true  -- Set the dragging flag
                originalSlot = self
                audio.PlayInvSound("pickup_normal")
            end
        end
    end
    craftingItemOne.OnMousePressed = dragCraftingLineup
    craftingItemTwo.OnMousePressed = dragCraftingLineup

    local function checkCraftingLineup(self, key)
        if not isDragging then return end

        -- Check if item can be used for crafting, item.Can.Craft
        if not self.item and not draggedItem.Can.Craft then
            if originalSlot then
                if originalSlot.WeaponSlot or originalSlot.GearSlot then
                    originalSlot.activeItem = draggedItem
                else
                    originalSlot.item = draggedItem
                end
            end
            draggedItem = nil
            isDragging = false  -- Clear the dragging flag
            originalSlot = nil 
            audio.PlayInvSound("release_normal")
            return
        end
        
        if key == MOUSE_LEFT then
            if self.item then
                -- Swap items
                local tempItem = self.item
                self.item = draggedItem
                draggedItem = tempItem
                if originalSlot then
                    if originalSlot.WeaponSlot then
                        originalSlot.activeItem = tempItem
                    else
                        originalSlot.item = tempItem
                    end
                end
                audio.PlayInvSound("pickup_normal")
            else
                self.item = draggedItem
                draggedItem = nil
                isDragging = false  -- Clear the dragging flag
                originalSlot = nil
                audio.PlayInvSound("release_normal")
            end
        end
    end
    craftingItemOne.OnMouseReleased = checkCraftingLineup
    craftingItemTwo.OnMouseReleased = checkCraftingLineup

    -- Crafting panel think
    crafting.Think = function(self)
        -- Check if items are placed in the crafting lineup
        if craftingItemOne.item and craftingItemTwo.item then
            local itemsToCheck = {}

            -- Add the first item to the check table
            itemsToCheck[craftingItemOne.item.UniqueName] = (itemsToCheck[craftingItemOne.item.UniqueName] or 0) + 1

            -- Add the second item, incrementing the count if it's the same as the first
            itemsToCheck[craftingItemTwo.item.UniqueName] = (itemsToCheck[craftingItemTwo.item.UniqueName] or 0) + 1

            -- Check if the combination of items corresponds to a recipe
            local recipeName, recipeItem = INVENTORY.Crafting.IsRecipe(itemsToCheck)
            if recipeItem then
                -- Set the equals item to the recipe item
                craftingItemEquals.item = INVENTORY.Item.GetScript(recipeItem)
            else
                -- Clear the equals item if no recipe is found
                craftingItemEquals.item = nil
            end
        else
            -- Clear the equals item if either crafting slot is empty
            craftingItemEquals.item = nil
        end
    end






    -- [Equipment]
    local equipment = vgui.Create("DPanel", panel)
    equipment:SetSize(scaleSize(300, 400))

    local equipmentPadding = 10
        equipment.Paint = function(self, w, h)
    end

    -- [Equipment] - Title
    local equipmentTitle = vgui.Create("DLabel", equipment)
    equipmentTitle:SetText("EQUIPMENT")
    equipmentTitle:SetFont("InventoryTitle")
    equipmentTitle:SetTextColor(Color(255, 255, 255, 255))
    equipmentTitle:SizeToContents()

    -- [Equipment] - Weapon Slots
    local weaponSlots = vgui.Create("DPanel", equipment)
    weaponSlots:Dock(FILL)
    weaponSlots:DockMargin(equipmentPadding, 40, equipmentPadding, equipmentPadding)

    weaponSlots.Paint = function(s, w, h)
        
    end

    local wepPosX, wepPosY = 0, 0
    -- [Equipment] - Primary Weapon
    local primaryWeapon = vgui.Create("DPanel", weaponSlots)
    primaryWeapon:SetSize(scaleSize(equipment:GetWide() - 20, 100))
    primaryWeapon:SetPos(wepPosX, wepPosY)
    primaryWeapon:SetBackgroundColor(Color(255, 0, 0, 255))
    primaryWeapon.Title = "Primary"
    primaryWeapon.SlotType = "primary"
    primaryWeapon.WeaponSlot = true

    wepPosY = wepPosY + primaryWeapon:GetTall() + equipmentPadding

    -- [Equipment] - Secondary Weapon
    local secondaryWeapon = vgui.Create("DPanel", weaponSlots)
    secondaryWeapon:SetSize(scaleSize(equipment:GetWide() - 20, 100))
    secondaryWeapon:SetPos(wepPosX, wepPosY)
    secondaryWeapon:SetBackgroundColor(Color(255, 0, 0, 255))
    secondaryWeapon.Title = "Secondary"
    secondaryWeapon.SlotType = "secondary"
    secondaryWeapon.WeaponSlot = true

    wepPosY = wepPosY + secondaryWeapon:GetTall() + equipmentPadding

    -- [Equipment] - Belt Weapon
    local beltWeapon = vgui.Create("DPanel", weaponSlots)
    beltWeapon:SetSize(scaleSize(equipment:GetWide() - 20, 100))
    beltWeapon:SetPos(wepPosX, wepPosY)
    beltWeapon:SetBackgroundColor(Color(255, 0, 0, 255))
    beltWeapon.Title = "Belt"
    beltWeapon.SlotType = "belt"
    beltWeapon.WeaponSlot = true


    -- [Equipment] - Weapon Slots - Paint
    local function paintWeaponSlots(self, w, h)
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)

        -- Draw a background for the text
        surface.SetDrawColor(Color(0, 0, 0, 200))
        surface.DrawRect(barThickness, h - 25 - barThickness, w - (barThickness * 2), 30 - barThickness)

        surface.SetFont("InventoryTileFont")
        surface.SetTextColor( 255, 255, 255 )
        local text = self.activeItem and self.activeItem.Name or "Empty"
        local textW, textH = surface.GetTextSize(text)
        -- bottom center
        surface.SetTextPos( w / 2 - textW / 2, h - textH - 8 )
        surface.DrawText(text)

        -- Draw self.Title at the top
        surface.SetFont("InventoryTileFont")
        surface.SetTextColor( 255, 255, 255 )
        local titleText = self.Title or "Weapon"
        local textW, textH = surface.GetTextSize(titleText)

        -- Draw the icon
        if self.activeItem then
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.SetMaterial(Material(self.activeItem.Icon))
            -- draw above text centered
            surface.DrawTexturedRect(w / 2 - 32, h / 2 - (32 + 13), 64, 64)
            local rarity = self.activeItem.Rare
            surface.SetDrawColor(Color(theme.item_rarity[rarity].r, theme.item_rarity[rarity].g, theme.item_rarity[rarity].b, theme.item_rarity[rarity].a))
            surface.SetMaterial(Material("materials/inventory/items/rarity_circle_glow.png"))
            surface.DrawTexturedRect(8, 8, 16, 16)
            -- draw title to the top right
            surface.SetTextPos( w - textW - 8, 8 )
            surface.DrawText(titleText)
        else
            surface.SetTextPos( w / 2 - textW / 2, 8 )
            surface.DrawText(titleText)
        end

    end
    primaryWeapon.Paint = paintWeaponSlots
    secondaryWeapon.Paint = paintWeaponSlots
    beltWeapon.Paint = paintWeaponSlots

    -- Check if item released on weapon slot
    local function checkWeaponSlot(self, key)
        if not isDragging then return end
        
        if not draggedItem or draggedItem.Type ~= "weapon" then
            -- If the dragged item is not a weapon, send it back to the original slot
            if originalSlot then
                if originalSlot.WeaponSlot or originalSlot.GearSlot then
                    originalSlot.activeItem = draggedItem
                else
                    originalSlot.item = draggedItem
                end
                draggedItem = nil
                isDragging = false
                originalSlot = nil
                audio.PlayInvSound("release_normal")
            end
            return
        end

        if draggedItem.SWEPSlot and self.SlotType ~= draggedItem.SWEPSlot then
            -- If the dragged item is not the same slot type as the weapon slot, send it back to the original slot
            if originalSlot then
                if originalSlot.WeaponSlot or originalSlot.GearSlot then
                    originalSlot.activeItem = draggedItem
                else
                    originalSlot.item = draggedItem
                end
                draggedItem = nil
                isDragging = false
                originalSlot = nil
                audio.PlayInvSound("release_normal")
            end
            return
        end

        if key == MOUSE_LEFT then

            if self.activeItem then
                -- Swap items

                local tempItem = self.activeItem
                self.activeItem = draggedItem
                draggedItem = tempItem
                if originalSlot then
                    if originalSlot.WeaponSlot then
                        originalSlot.activeItem = tempItem
                    else
                        originalSlot.item = tempItem
                    end
                end
                audio.PlayInvSound("release_gun")
            else
                audio.PlayInvSound("release_gun")
                self.activeItem = draggedItem
                draggedItem = nil
                isDragging = false  -- Clear the dragging flag
                originalSlot = nil
            end
        end
    end
    primaryWeapon.OnMouseReleased = checkWeaponSlot
    secondaryWeapon.OnMouseReleased = checkWeaponSlot
    beltWeapon.OnMouseReleased = checkWeaponSlot

    -- Drag item from weapon slot
    local function dragWeaponSlot(self, key)
        if not self.activeItem then return end
        if key == MOUSE_LEFT then
            if not isDragging then
                draggedItem = self.activeItem
                self.activeItem = nil
                isDragging = true  -- Set the dragging flag
                self.maltest = true
                originalSlot = self
                audio.PlayInvSound("pickup_normal")
            end
        end
    end
    primaryWeapon.OnMousePressed = dragWeaponSlot
    secondaryWeapon.OnMousePressed = dragWeaponSlot
    beltWeapon.OnMousePressed = dragWeaponSlot


    

    -- TODO: REFRACTOR
    local function checkWeaponSlotThink(self)

        -- if dragging an item wait until mouse is released
        if isDragging then return end

        if self.activeItem and self.activeItem ~= self.lastItem then
            -- if lastItem was a weapon, unequip it
            if self.lastItem and istable(self.lastItem) then
                net.Start("Inventory::UnequipItem")
                net.WriteInt(self.lastItem.id, 21)
                net.SendToServer()
            end

            self.lastItem = self.activeItem

            -- Lets cache the active item
            local actItemCached = self.activeItem
            local writeItem = IsValid(self) and self.activeItem.id or actItemCached.id

            timer.Simple(0.2, function()
                if LocalPlayer():HasWeapon(actItemCached.UniqueName) then return end
                net.Start("Inventory::EquipItem")
                net.WriteInt(writeItem, 21)
                net.SendToServer()
            end)
        end


        -- check if weapon is unequipped
        if not self.activeItem and self.lastItem or self.lastItem and self.activeItem ~= self.lastItem then
            net.Start("Inventory::UnequipItem")
            net.WriteInt(self.lastItem.id, 21)
            net.SendToServer()
            self.lastItem = false
        end
    end
    primaryWeapon.Think = checkWeaponSlotThink
    secondaryWeapon.Think = checkWeaponSlotThink
    beltWeapon.Think = checkWeaponSlotThink


    -- [Equipment] - Sizing and Positioning
    equipment:CenterHorizontal(rSize.equipment_horizontal)
    equipment:CenterVertical(rSize.equipment_vertical)

    equipmentTitle:CenterHorizontal()



    -- Function to calculate font size based on screen resolution
    local function getFontSize(baseSize)
        local screenWidth, screenHeight = ScrW(), ScrH()
        -- Adjust the scaling factor as needed
        local scaleFactor = math.min(screenWidth / 1920, screenHeight / 1080)
        return math.Clamp(math.floor(baseSize * scaleFactor), 20, 50)
    end

    -- Function to create dynamic font
    local function createDynamicFont(baseSize)
        local fontSize = getFontSize(baseSize)
        local fontName = "InventoryFont_" .. tostring(fontSize)
        
        surface.CreateFont(fontName, {
            font = "Arial", -- Replace with your desired font family
            size = fontSize,
            weight = 700,
            antialias = true
        })

        return fontName
    end

    -- [Stats]
    local stats = vgui.Create("DPanel", panel)
    stats:SetSize(scaleSize(300, 370))
    local statsPadding = 10
    stats.Paint = function(self, w, h)
    end

    -- [Stats] - Stats
    local statsPanel = vgui.Create("DPanel", stats)
    statsPanel:Dock(FILL)
    statsPanel:DockMargin(statsPadding, statsPadding, statsPadding, statsPadding)

    statsPanel.Paint = function(s, w, h)
    end

    local statsPosX, statsPosY = 0, 0

    -- Create dynamic font
    local dynamicFont = createDynamicFont(30)

    -- [Stats] - Health [text]
    local healthText = vgui.Create("DLabel", statsPanel)
    healthText:SetPos(statsPosX, statsPosY)
    healthText:SetText("HEALTH: " .. LocalPlayer():Health())
    healthText:SetFont(dynamicFont)
    healthText:SetTextColor(Color(255, 255, 255, 255))
    healthText:SizeToContents()

    statsPosY = statsPosY + healthText:GetTall() + statsPadding

    -- [Stats] - Armor [text]
    local armorText = vgui.Create("DLabel", statsPanel)
    armorText:SetPos(statsPosX, statsPosY)
    armorText:SetText("ARMOR: " .. LocalPlayer():Armor())
    armorText:SetFont(dynamicFont)
    armorText:SetTextColor(Color(255, 255, 255, 255))
    armorText:SizeToContents()

    statsPosY = statsPosY + armorText:GetTall() + statsPadding

    local function speedTextValue(speed)
        local speedText = speed == 240 and "Normal" or speed > 240 and "Fast" or "Slow"
        return "SPEED: " .. speedText
    end

    -- [Stats] - Speed [text]
    local speedText = vgui.Create("DLabel", statsPanel)
    speedText:SetPos(statsPosX, statsPosY)
    speedText:SetText(speedTextValue(LocalPlayer():GetRunSpeed()))
    speedText:SetFont(dynamicFont)
    speedText:SetTextColor(Color(255, 255, 255, 255))
    speedText:SizeToContents()

    statsPosY = statsPosY + speedText:GetTall() + statsPadding

    -- [Stats] - Height [text]
    local heightText = vgui.Create("DLabel", statsPanel)
    heightText:SetPos(statsPosX, statsPosY)
    local height = CHARACTER:GetHeight() ~= nil and CHARACTER:GetHeight() or "N/A"
    heightText:SetText("HEIGHT: " .. height)
    heightText:SetFont(dynamicFont)
    heightText:SetTextColor(Color(255, 255, 255, 255))
    heightText:SizeToContents()

    statsPosY = statsPosY + heightText:GetTall() + statsPadding

    -- [Stats] - Job [text]
    local jobText = vgui.Create("DLabel", statsPanel)
    jobText:SetPos(statsPosX, statsPosY)
    local jobTextValue = "JOB: " .. LocalPlayer():getDarkRPVar("job")
    if string.len(jobTextValue) > 20 then
        jobTextValue = string.sub(jobTextValue, 1, 20) .. "..."
    end
    jobText:SetText(jobTextValue)
    jobText:SetFont(dynamicFont)
    jobText:SetTextColor(Color(255, 255, 255, 255))
    jobText:SizeToContents()

    -- [Stats] - Update text think
    statsPanel.Think = function(self)
        healthText:SetText("HEALTH: " .. LocalPlayer():Health())
        armorText:SetText("ARMOR: " .. LocalPlayer():Armor())
        speedText:SetText(speedTextValue(LocalPlayer():GetRunSpeed()))
        local height = CHARACTER:GetHeight() ~= nil and CHARACTER:GetHeight() or "N/A"
        heightText:SetText("HEIGHT: " .. height)
        jobTextValue = "JOB: " .. LocalPlayer():getDarkRPVar("job")
        if string.len(jobTextValue) > 15 then
            jobTextValue = string.sub(jobTextValue, 1, 15) .. "..."
        end
        jobText:SetText(jobTextValue)

        healthText:SizeToContents()
        armorText:SizeToContents()
        speedText:SizeToContents()
        heightText:SizeToContents()
        jobText:SizeToContents()

    end

    -- [Stats] - Sizing and Positioning
    stats:CenterHorizontal(rSize.stats_horizontal)
    stats:CenterVertical(rSize.stats_vertical)


    -- [Gear]
    local gear = vgui.Create("DPanel", panel)
    gear:SetSize(scaleSize(150, 520))

    local gearPadding = 10
    gear.Paint = function(self, w, h)
    end

    -- [Gear] - Gear
    local gearPanel = vgui.Create("DPanel", gear)
    gearPanel:Dock(FILL)
    gearPanel:DockMargin(gearPadding, gearPadding, gearPadding, gearPadding)

    gearPanel.Paint = function(s, w, h)
    end

    local gearPosX, gearPosY = 0, 0

    -- [Gear] - Gear - Head [Item Slot]
    local head = vgui.Create("DPanel", gearPanel)
    head:SetSize(itemSlotSize, itemSlotSize)
    head:SetPos(gearPosX, gearPosY)
    head:SetBackgroundColor(Color(255, 0, 0, 255))
    head.Title = "Helmet"
    head.SlotType = "helmet"

    gearPosY = gearPosY + head:GetTall() + gearPadding

    -- [Gear] - Gear - Chest [Item Slot]
    local chest = vgui.Create("DPanel", gearPanel)
    chest:SetSize(itemSlotSize, itemSlotSize)
    chest:SetPos(gearPosX, gearPosY)
    chest:SetBackgroundColor(Color(255, 0, 0, 255))
    chest.Title = "Chest"
    chest.SlotType = "chest"

    gearPosY = gearPosY + chest:GetTall() + gearPadding

    -- [Gear] - Gear - Legs [Item Slot]
    local legs = vgui.Create("DPanel", gearPanel)
    legs:SetSize(itemSlotSize, itemSlotSize)
    legs:SetPos(gearPosX, gearPosY)
    legs:SetBackgroundColor(Color(255, 0, 0, 255))
    legs.Title = "Pants"
    legs.SlotType = "pants"

    gearPosY = gearPosY + legs:GetTall() + gearPadding

    -- [Gear] - Gear - Feet [Item Slot]
    local feet = vgui.Create("DPanel", gearPanel)
    feet:SetSize(itemSlotSize, itemSlotSize)
    feet:SetPos(gearPosX, gearPosY)
    feet:SetBackgroundColor(Color(255, 0, 0, 255))
    feet.Title = "Boots"
    feet.SlotType = "boots"

    -- Establish as gear slot
    head.GearSlot = true
    chest.GearSlot = true
    legs.GearSlot = true
    feet.GearSlot = true

    -- [Gear] - Gear - Paint
    local function paintGear(self, w, h)
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)

        -- Draw a background for the text
        surface.SetDrawColor(Color(0, 0, 0, 200))
        surface.DrawRect(barThickness, h - 25 - barThickness, w - (barThickness * 2), 30 - barThickness)

        -- Draw icon
        if self.activeItem then

            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.SetMaterial(Material(self.activeItem.Icon))
            -- draw above text centered
            surface.DrawTexturedRect(w / 2 - 32, h / 2 - (32 + 13), 64, 64)
            local rarity = self.activeItem.Rare
            surface.SetDrawColor(Color(theme.item_rarity[rarity].r, theme.item_rarity[rarity].g, theme.item_rarity[rarity].b, theme.item_rarity[rarity].a))
            surface.SetMaterial(Material("materials/inventory/items/rarity_circle_glow.png"))
            surface.DrawTexturedRect(8, 8, 16, 16)

            -- Draw item name bottom cnter
            surface.SetFont("InventoryTileFont")
            surface.SetTextColor( 255, 255, 255 )
            local text = self.activeItem.Name
            local textW, textH = surface.GetTextSize(text)
            -- bottom center
            surface.SetTextPos( w / 2 - textW / 2, h - textH - 8 )
            surface.DrawText(text)

            drawArmorBar(self.activeItem, w, h)
        else
            -- Draw text in center
            surface.SetFont("InventoryTileFont")
            surface.SetTextColor( 255, 255, 255 )
            local text = self.activeItem and "" or self.Title or "Armor"
            local textW, textH = surface.GetTextSize(text)
            -- center
            surface.SetTextPos( w / 2 - textW / 2, h / 2.5 - textH / 2 )
            surface.DrawText(text)

            -- empty text
            surface.SetFont("InventoryTileFont")
            surface.SetTextColor( 255, 255, 255 )
            local text = "Empty"
            local textW, textH = surface.GetTextSize(text)
            -- bottom center
            surface.SetTextPos( w / 2 - textW / 2, h - textH - 8 )
            surface.DrawText(text)
        end
    end

    head.Paint = paintGear
    chest.Paint = paintGear
    legs.Paint = paintGear
    feet.Paint = paintGear

    -- Check if item released on gear slot
    local function checkGearSlot(self, key)
        if not isDragging then return end
        
        if not draggedItem or draggedItem.Type ~= "armor" then
            if originalSlot then
                if originalSlot.WeaponSlot or originalSlot.GearSlot then
                    originalSlot.activeItem = draggedItem
                else
                    originalSlot.item = draggedItem
                end
                draggedItem = nil
                isDragging = false
                originalSlot = nil
                audio.PlayInvSound("release_normal")
            end
            return
        end

        if draggedItem.ArmorType and self.SlotType ~= draggedItem.ArmorType then
            -- If the dragged item is not the same slot type as the weapon slot, send it back to the original slot
            if originalSlot then

                if originalSlot.WeaponSlot or originalSlot.GearSlot then
                    originalSlot.activeItem = draggedItem
                else
                    originalSlot.item = draggedItem
                end
                draggedItem = nil
                isDragging = false
                originalSlot = nil
                audio.PlayInvSound("release_normal")
            end
            return
        end

        if key == MOUSE_LEFT then
            if self.activeItem then
                -- Swap items
                local tempItem = self.activeItem
                self.activeItem = draggedItem
                draggedItem = tempItem
                if originalSlot then
                    if originalSlot.WeaponSlot then
                        originalSlot.activeItem = tempItem
                    else
                        originalSlot.item = tempItem
                    end
                end
                audio.PlayInvSound("release_armor")
            else
                audio.PlayInvSound("release_armor")
                self.activeItem = draggedItem
                draggedItem = nil
                isDragging = false  -- Clear the dragging flag
                originalSlot = nil
            end
        end
    end
    head.OnMouseReleased = checkGearSlot
    chest.OnMouseReleased = checkGearSlot
    legs.OnMouseReleased = checkGearSlot
    feet.OnMouseReleased = checkGearSlot

    -- Drag item from gear slot
    local function dragGearSlot(self, key)
        if not self.activeItem then return end
        if key == MOUSE_LEFT then
            if not isDragging then
                draggedItem = self.activeItem
                self.activeItem = nil
                isDragging = true  -- Set the dragging flag
                originalSlot = self
                audio.PlayInvSound("pickup_normal")
            end
        end
    end
    head.OnMousePressed = dragGearSlot
    chest.OnMousePressed = dragGearSlot
    legs.OnMousePressed = dragGearSlot
    feet.OnMousePressed = dragGearSlot

    -- TODO: REFRACTOR
    local function checkGearSlotThink(self)
            
            -- if dragging an item wait until mouse is released
            if isDragging then return end
    
            if self.activeItem and self.activeItem ~= self.lastItem then
                if self.lastItem and istable(self.lastItem) then
                    net.Start("Inventory::UnequipItem")
                    net.WriteInt(self.lastItem.id, 21)
                    net.SendToServer()
                end
    
                self.lastItem = self.activeItem
                local idCached = self.activeItem.id
                timer.Simple(0.2, function()
                    if justOpened then return end
                    net.Start("Inventory::EquipItem")
                    net.WriteInt(idCached, 21)
                    net.SendToServer()
                end)
            end

            -- check if armor is unequipped
            if not self.activeItem and self.lastItem or self.lastItem and self.activeItem ~= self.lastItem then
                net.Start("Inventory::UnequipItem")
                net.WriteInt(self.lastItem.id, 21)
                net.SendToServer()
                self.lastItem = false
            end
    end
    head.Think = checkGearSlotThink
    chest.Think = checkGearSlotThink
    legs.Think = checkGearSlotThink
    feet.Think = checkGearSlotThink


    -- [Gear] - Sizing and Positioning
    gear:CenterHorizontal(0.68)
    gear:CenterVertical(0.44)





    -- [Character]
    local character = vgui.Create("DPanel", panel)
    character:SetSize(scaleSize(400, 700))
    local characterPadding = 10
    character.Paint = function(self, w, h)
        surface.SetDrawColor(Color(255, 255, 255, 255))
        --surface.DrawRect(0, 0, w, h)
    end

    -- [Character] - Character Title
    local characterTitle = vgui.Create("DLabel", character)
    characterTitle:SetText(CHARACTER:GetName())
    characterTitle:SetFont("InventoryTitle")
    characterTitle:SetTextColor(Color(255, 255, 255, 255))
    characterTitle:SizeToContents()

    -- [Character] - Character Model
    local characterModel = vgui.Create("DModelPanel", character)
    characterModel:Dock(FILL)
    characterModel:DockMargin(characterPadding, 40, characterPadding, characterPadding)
    characterModel:SetModel(LocalPlayer():GetModel())
    -- Center model
    characterModel:SetLookAt(Vector(0, 0, 40))
    characterModel:SetCamPos(Vector(50, 30, 60))
    characterModel:SetFOV(45)



    -- Make model not spin
    function characterModel:LayoutEntity(ent)
        return
    end
    -- Check if player model changed, if so change it and make it not t-pose.
    function characterModel:Think()
        if LocalPlayer():GetModel() ~= self.Entity:GetModel() then
            self.Entity:SetModel(LocalPlayer():GetModel())
            local seq = self.Entity:LookupSequence("idle_all_01")
            if seq > -1 then
                self.Entity:SetSequence(seq)
            else
                self.Entity:SetSequence(1)
            end
        end
    end
    function characterModel.Entity:GetPlayerColor() return Vector (1, 0, 0) end


    -- [Character] - Character Painting
    local originalPaint = characterModel.Paint
    local function paintCharacter(self, w, h)

        if originalPaint then
            originalPaint(self, w, h)
        end
        -- Draw white lines outlining the itemgrid
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)
    end
    characterModel.Paint = paintCharacter



    -- [Character] - Sizing and Positioning
    character:CenterHorizontal(0.83)
    character:CenterVertical(0.5)

    characterTitle:CenterHorizontal()
    characterTitle:CenterVertical(0.03)


    -- [Weight]

    -- [Weight] - Weight amount format x/x
    local weightAmount = vgui.Create("DLabel", panel)
    local weightText = tostring(INVENTORY.Weight.Current or 0) .. "/" .. tostring(INVENTORY.Weight.GetMax())
    weightAmount:SetText(weightText)
    weightAmount:SetFont("InventoryTitle")
    weightAmount:SetTextColor(Color(255, 255, 255, 255))
    weightAmount:SizeToContents()
    
    -- [Weight] - Icon
    local weightIcon = vgui.Create("DImage", panel)
    weightIcon:SetSize(scaleSize(32, 32))
    weightIcon:SetImage("materials/biobolt_ui/icons/32/weight.png")

    -- if weight is over limit, make icon red check on paint
    local function paintWeightIcon(self, w, h)
        if INVENTORY.Weight.Current > INVENTORY.Weight.GetMax() then
            surface.SetDrawColor(Color(255, 0, 0, 255))
            surface.SetMaterial(Material("materials/biobolt_ui/icons/32/weight.png"))
            surface.DrawTexturedRect(0, 0, w, h)
        else
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.SetMaterial(Material("materials/biobolt_ui/icons/32/weight.png"))
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end
    weightIcon.Paint = paintWeightIcon

    weightAmount.Think = function(self)
        local weightText = tostring(INVENTORY.Weight.Current or 0) .. "/" .. tostring(INVENTORY.Weight.GetMax())
        self:SetText(weightText)
        self:SizeToContents()
    end

    -- [Weight] - Sizing and Positioning
    weightAmount:CenterHorizontal(0.77)
    weightAmount:CenterVertical(0.043)

    weightIcon:CenterHorizontal(0.735)
    weightIcon:CenterVertical(0.04)


    -- [Level]

    -- [Level] - Label "Level [number]"
    -- Assuming `ply` is the player object you want to get the level and XP for
    local ply = LocalPlayer()

    -- Function to get the total XP required for a specific level
    local function GetTotalXPForLevel(level)
        -- Replace this with your actual logic to calculate total XP for a given level
        -- Example: return level * 1000 (incrementally increasing XP requirement)
        return (level == 1 and 1 or level) * LEVEL.CFG.ConfValues.XPPerLevel
    end
    
    -- Fetch initial level and XP
    local level = LEVEL.GetLevel(ply)
    local currentXP = LEVEL.GetXP(ply)

    -- Calculate the XP required to reach the current and next levels
    local totalXPForCurrentLevel = GetTotalXPForLevel(level)
    local totalXPForNextLevel = GetTotalXPForLevel(level + 1)

    -- Correct the calculation for current XP within the current level
    local currentXPWithinLevel = currentXP - totalXPForCurrentLevel
    local maxXPWithinLevel = totalXPForNextLevel - totalXPForCurrentLevel

    -- Debugging prints
    print("Level: " .. level)
    print("Current XP: " .. currentXP)
    print("Current XP within Level: " .. currentXPWithinLevel)
    print("Max XP within Level: " .. maxXPWithinLevel)

    -- UI Elements
    local levelLabel = vgui.Create("DLabel", panel)
    levelLabel:SetText("Level " .. level)
    levelLabel:SetFont("InventoryTitle")
    levelLabel:SetTextColor(Color(255, 255, 255, 255))
    levelLabel:SizeToContents()

    local levelProgressBarPanel = vgui.Create("DPanel", panel)
    levelProgressBarPanel:SetSize(scaleSize(200, 30))
    levelProgressBarPanel:SetPos(0, 0)
    levelProgressBarPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(84, 82, 82, 200))
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawRect(0, 0, barThickness, h)
        surface.DrawRect(0, h - barThickness, w, barThickness)
        surface.DrawRect(w - barThickness, 0, barThickness, h)
        surface.DrawRect(0, 0, w, barThickness)
    end

    local levelProgressBar = vgui.Create("DPanel", levelProgressBarPanel)
    local barSize = levelProgressBarPanel:GetWide() - (barThickness * 2)
    
    local percent = currentXPWithinLevel / maxXPWithinLevel
    local curBarSize = barSize * percent
    levelProgressBar:SetSize(scaleSize(curBarSize, 30 - (barThickness * 2)))
    levelProgressBar:SetPos(barThickness, barThickness)
    levelProgressBar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(234, 151, 56))
        -- only draw if we have enough room
        if w < 90 then return end
        -- write xp/max
        surface.SetFont("InventoryTileFont")
        surface.SetTextColor(255, 255, 255)
        local text = currentXPWithinLevel .. "/" .. maxXPWithinLevel
        local textW, textH = surface.GetTextSize(text)
        -- center of entire bar
        surface.SetTextPos(w / 2 - textW / 2, h / 2 - textH / 2)
        surface.DrawText(text)
    end

    -- [Level] - Sizing and Positioning
    levelLabel:CenterHorizontal(0.9)
    levelLabel:CenterVertical(0.04)

    levelProgressBarPanel:CenterHorizontal(0.9)
    levelProgressBarPanel:CenterVertical(0.07)

    -- Update function to refresh the UI elements when the level or XP changes
    local function UpdateLevelUI()
        -- if panel is removed, stop updating
        if not IsValid(panel) then
            hook.Remove("Think", "UpdateLevelUI")
            return
        end

        level = LEVEL.GetLevel(ply)
        currentXP = LEVEL.GetXP(ply)
        totalXPForCurrentLevel = level == 1 and 0 or GetTotalXPForLevel(level)
        totalXPForNextLevel = GetTotalXPForLevel(level == 1 and 1 or level + 1)
        currentXPWithinLevel = currentXP - totalXPForCurrentLevel
        maxXPWithinLevel = totalXPForNextLevel - totalXPForCurrentLevel


        percent = currentXPWithinLevel / maxXPWithinLevel -- Correct percentage calculation
        curBarSize = barSize * percent

        if not IsValid(levelLabel) or not IsValid(levelProgressBar) then return end

        levelLabel:SetText("Level " .. level)
        levelLabel:SizeToContents()

        levelProgressBar:SetSize(scaleSize(curBarSize, 30 - (barThickness * 2)))
    end

    -- Ensure to call the update function periodically or when XP changes
    hook.Add("Think", "UpdateLevelUI", UpdateLevelUI)

    -- Make a x and y line so I can see where the center of the screen is

    --[[local xLine = vgui.Create("DPanel", panel)
    xLine:SetSize(2, scrH)
    xLine:SetPos(scrW / 2, 0)
    xLine.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(124, 198, 250, 200))
    end

    local yLine = vgui.Create("DPanel", panel)
    yLine:SetSize(scrW, 2)
    yLine:SetPos(0, scrH / 2)
    yLine.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(124, 198, 250, 200))
    end]]
    INVENTORY.Panel.CanClose = function()
        -- if any items in crafting slots, return false
        if craftingItemOne.item or craftingItemTwo.item then
            return false
        end
        return true
    end
    local warnPanelActive = false
    INVENTORY.Panel.WarnPopup = function()
        if warnPanelActive then return end
        local warningPanel = vgui.Create("DPanel", panel)
        warningPanel:SetSize(panel:GetWide(), panel:GetTall())
        warningPanel:SetPos(0, 0)
        warningPanel.Paint = function(self, w, h)
            -- draw background around text
            draw.RoundedBox(0, w / 2 - 256, h / 2 - 30, 512, 300, Color(0, 0, 0, 250))
            Derma_DrawBackgroundBlur(self, 0)
            draw.SimpleText("You have items in the crafting slots.", "InventoryTitle", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Please remove them before closing.", "InventoryTitle", w / 2, h / 2 + 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        warnPanelActive = true

        warningPanel.OnRemove = function()
            warnPanelActive = false
        end

        -- Add early close button with a countdown of time left
        local timeUntilClose = 5
        local closeText = vgui.Create("DLabel", warningPanel)
        closeText:SetText("Auto closing in " .. timeUntilClose .. " seconds.")
        closeText:SetFont("InventoryTitle")
        closeText:SetTextColor(Color(255, 255, 255, 255))
        closeText:SizeToContents()
        closeText:CenterHorizontal()
        closeText:CenterVertical(0.6)

        local function closeWarningPanel()
            warningPanel:Remove()
        end

        timer.Create("Inventory::CloseWarningPanel", 1, 5, function()
            timeUntilClose = timeUntilClose - 1
            closeText:SetText("Auto closing in " .. timeUntilClose .. " seconds.")
            closeText:SizeToContents()
            closeText:CenterHorizontal()
            closeText:CenterVertical(0.6)
            if timeUntilClose == 0 then
                closeWarningPanel()
            end
        end)

        -- button to close early
        local closeEarlyButton = vgui.Create("DButton", warningPanel)
        closeEarlyButton:SetText("CLOSE")
        closeEarlyButton:SetFont("InventoryTitle")
        closeEarlyButton:SetTextColor(Color(255, 255, 255, 255))
        closeEarlyButton:SetSize(150, 50)
        closeEarlyButton:CenterHorizontal()
        closeEarlyButton:CenterVertical(0.7)

        closeEarlyButton.DoClick = function()
            closeWarningPanel()
            timer.Remove("Inventory::CloseWarningPanel")
        end

        -- Paint
        closeEarlyButton.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(234, 151, 56))
        end


        timer.Simple(5, function()
            warningPanel:Remove()
        end)
    end

    -- Late function call to make sure all panels are created
    closeButton.DoClick = function()
        -- Make sure no items are in crafting slots
        if not INVENTORY.Panel.CanClose() then
            INVENTORY.Panel.WarnPopup()
            return
        end
        panel:Remove()
    end

    -- Functions
    INVENTORY.Panel.AddItem = function(item, column, row)
        if not item then return end
        local index = (row - 1) * itemSlotColumns + column
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
        -- Check if item is in crafting lineup
        if craftingItemOne.item and craftingItemOne.item.id == item then
            craftingItemOne.item = nil
            return
        end
        if craftingItemTwo.item and craftingItemTwo.item.id == item then
            craftingItemTwo.item = nil
            return
        end
        -- Check if item is in weapon slots
        if primaryWeapon.activeItem and primaryWeapon.activeItem.id == item then
            primaryWeapon.activeItem = nil
            return
        end
        if secondaryWeapon.activeItem and secondaryWeapon.activeItem.id == item then
            secondaryWeapon.activeItem = nil
            return
        end
        if beltWeapon.activeItem and beltWeapon.activeItem.id == item then
            beltWeapon.activeItem = nil
            return
        end
    end

    INVENTORY.Panel.FindItem = function(item)
        for k, v in pairs(itemSlots) do
            if v.item and v.item.id == item then
                return k % itemSlotColumns, math.floor((k - 1) / itemSlotColumns) + 1
            end
        end
        return false
    end

    local function EquipRemove(item)
        local column, row = INVENTORY.Panel.FindItem(item.id)
        INVENTORY.Panel.RemoveItem(item.id, column, row)
    end

    local equipSlots = {
        ["primary"] = primaryWeapon,
        ["secondary"] = secondaryWeapon,
        ["belt"] = beltWeapon,
        ["helmet"] = head,
        ["chest"] = chest,
        ["pants"] = legs,
        ["boots"] = feet
    }

    INVENTORY.Panel.EquipItem = function(item)
        if not item then return end
        if item.Type == "weapon" then
            local slot = item.SWEPSlot
            if not slot then return end

            if not equipSlots[slot].activeItem then
                equipSlots[slot].activeItem = item
                EquipRemove(item)
                return
            else
                -- Swap items
                local tempItem = equipSlots[slot].activeItem
                equipSlots[slot].activeItem = item
                EquipRemove(item)
                INVENTORY.Panel.AddItem(tempItem, 1, 1)
                return
            end
        end
        if item.Type == "armor" then

            -- Factor in ITEM.ArmorType
            local slot = item.ArmorType
            if not slot then return end

            if not equipSlots[slot].activeItem then
                equipSlots[slot].activeItem = item
                EquipRemove(item)
                return
            else
                -- Swap items
                local tempItem = equipSlots[slot].activeItem
                equipSlots[slot].activeItem = item
                EquipRemove(item)
                INVENTORY.Panel.AddItem(tempItem, 1, 1)
                return
            end

        end
    end

    panel.OnRemove = function()
        INVENTORY.ItemLayout = {}

        if not LocalPlayer():Alive() then INVENTORY.Panel = nil return end
        for k, v in pairs(itemSlots) do
            if v.item then
                local column = (k - 1) % itemSlotColumns + 1
                local row = math.floor((k - 1) / itemSlotColumns) + 1
                table.insert(INVENTORY.ItemLayout, {item = v.item, column = column, row = row})
            end
        end

        -- Save equipment items
        if primaryWeapon.activeItem then
            table.insert(INVENTORY.ItemLayout, {item = primaryWeapon.activeItem, primary = true})
        end
        if secondaryWeapon.activeItem then
            table.insert(INVENTORY.ItemLayout, {item = secondaryWeapon.activeItem, secondary = true})
        end
        if beltWeapon.activeItem then
            table.insert(INVENTORY.ItemLayout, {item = beltWeapon.activeItem, belt = true})
        end

        -- Save gear items
        if head.activeItem then
            table.insert(INVENTORY.ItemLayout, {item = head.activeItem, head = true})
        end
        if chest.activeItem then
            table.insert(INVENTORY.ItemLayout, {item = chest.activeItem, chest = true})
        end
        if legs.activeItem then
            table.insert(INVENTORY.ItemLayout, {item = legs.activeItem, legs = true})
        end
        if feet.activeItem then
            table.insert(INVENTORY.ItemLayout, {item = feet.activeItem, feet = true})
        end

        INVENTORY.Panel = nil
    end

    for k,v in pairs(INVENTORY.ItemLayout) do
        if v.primary then
            primaryWeapon.activeItem = v.item
            continue
        end
        if v.secondary then
            secondaryWeapon.activeItem = v.item
            continue
        end
        if v.belt then
            beltWeapon.activeItem = v.item
            continue
        end
        if v.head then
            head.activeItem = v.item
            continue
        end
        if v.chest then
            chest.activeItem = v.item
            continue
        end
        if v.legs then
            legs.activeItem = v.item
            continue
        end
        if v.feet then
            feet.activeItem = v.item
            continue
        end
        INVENTORY.Panel.AddItem(v.item, v.column, v.row)
    end

    -- OnKeyCodePressed is called when a key is pressed while the panel is open
    panel.OnKeyCodePressed = function(self, key)
        if key == KEY_I and INVENTORY.Panel.CanClose() then
            INVENTORY.Cooldown = CurTime() + 0.5
            self:Remove()
        elseif key == KEY_I and not INVENTORY.Panel.CanClose() then
            INVENTORY.Panel.WarnPopup()
        end
    end

    panel:MakePopup()
end

function INVENTORY:CloseUI()
    if not IsValid(INVENTORY.Panel) then return end
    INVENTORY.Panel:Remove()
end

hook.Add("Inventory::ItemAdded", "Inventory::ItemAdded", function(item, column, row)
    if not INVENTORY.Panel then return end
    INVENTORY.Panel.AddItem(item, column, row)
end)

hook.Add("Inventory::ItemRemoved", "Inventory::ItemRemoved", function(item, column, row)
    if not INVENTORY.Panel then return end
    INVENTORY.Panel.RemoveItem(item, column, row)
end)

-- Press I open inventory if not open or else close inventory. Add cooldown between presses so it doesn't open and close instantly
hook.Add("PlayerButtonDown", "Inventory::OpenUI", function(ply, button)
    if button == KEY_I and CurTime() > INVENTORY.Cooldown then
        if not IsValid(INVENTORY.Panel) then
            INVENTORY:OpenUI()
        end
        INVENTORY.Cooldown = CurTime() + 0.5
    end
end)

-- DEV COMMAND
concommand.Add("inventory_open", function(ply)
    if not ply:IsSuperAdmin() then return end
    INVENTORY:OpenUI()
end)
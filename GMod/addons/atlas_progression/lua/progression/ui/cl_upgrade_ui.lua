UPGRADE_PANEL = UPGRADE_PANEL or false
CURRENT_UPGRADE_PLY = CURRENT_UPGRADE_PLY or false
CURRENT_UPGRADES = CURRENT_UPGRADES or {}
for i = 1, 40 do
    surface.CreateFont("UPGRADE::FONT::" .. i, {
        font = "MADE Tommy Soft",
        size = i,
        weight = 500,
        antialias = true
    })
end

local function createBasePanel(title)
    local screenWidth, screenHeight = ScrW(), ScrH()
    local panelWidth, panelHeight = screenWidth * 0.6, screenHeight * 0.6 -- Adjust size as needed

    local basePanel = vgui.Create("DFrame")
    basePanel:SetSize(panelWidth, panelHeight)
    basePanel:Center()
    basePanel:SetTitle("")
    basePanel:SetDraggable(false)
    basePanel:ShowCloseButton(false)
    basePanel:SetDeleteOnClose(true)
    basePanel:SetAlpha(0) -- Start with the panel fully transparent
    basePanel:AlphaTo(255, 0.3, 0) -- Transition to fully opaque over 0.3 seconds
    basePanel:MakePopup()

    basePanel.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(40, 40, 40, 255)) -- Dark mode background
    end

    local thinkCooldown = 0
    basePanel.Think = function()
        if thinkCooldown > CurTime() then return end
        thinkCooldown = CurTime() + 0.1
        --print(CURRENT_UPGRADE_PLY)
        if not istable(CURRENT_UPGRADE_PLY) then CURRENT_UPGRADES = {} return end
        --print("RAN")
        if CURRENT_UPGRADE_PLY.ply == LocalPlayer() then
            for k,v in pairs(PROGRESSION.CL.CurrentUpgrades) do
                --[[print("LOOP")
                print(k,v)
                if not istable(v) then continue end
                for k2,v2 in pairs(v) do
                    print(k2,v2)
                    print("LOOP2")
                    CURRENT_UPGRADES[k2] = v2
                end]]
                CURRENT_UPGRADES[k] = v
            end
            print("SELF")
        else
            CURRENT_UPGRADES = CURRENT_UPGRADE_PLY.data
            PrintTable(CURRENT_UPGRADE_PLY.data)
            print(CURRENT_UPGRADE_PLY.ply)
            for k,v in pairs(CURRENT_UPGRADE_PLY.data) do
                print(k,v)
                CURRENT_UPGRADES[k] = v
            end
            print("OTHER")
        end

        -- Update the buttons
        for _, child in ipairs(basePanel:GetChildren()) do
            if child.level then
                local skill = child.skill
                local level = child.level
                local doesOwn = CURRENT_UPGRADES[skill] and CURRENT_UPGRADES[skill] >= level
                child.owned = doesOwn
            end
        end
    end

    local titlePanel = vgui.Create("DPanel", basePanel)
    titlePanel:SetSize(panelWidth, 40) -- Adjust size as needed
    titlePanel:SetPos(0, 0)
    titlePanel.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 255)) -- Solid black box
        -- draw solid black box to cover bottom rounded corners
        draw.RoundedBox(0, 0, h - 10, w, 10, Color(0, 0, 0, 255))
    end

    local titleLabel = vgui.Create("DLabel", titlePanel)
    titleLabel:SetFont("UPGRADE::FONT::20") -- Adjust size as needed
    titleLabel:SetText(title)
    titleLabel:SizeToContents()
    titleLabel:SetPos(10, 10) -- Adjust position as needed
    titleLabel:SetColor(Color(255, 255, 255, 255)) -- White text
    if not PROGRESSION.CL.CanUse(LocalPlayer()) then
        local errorLabel = vgui.Create("DLabel", basePanel)
        errorLabel:SetFont("UPGRADE::FONT::30") -- Adjust size as needed
        errorLabel:SetText("Since you're not a researcher you cannot upgrade players.")
        errorLabel:SizeToContents()
        errorLabel:SetPos(panelWidth / 2 - errorLabel:GetWide() / 2, panelHeight / 4.2 - errorLabel:GetTall() / 2) -- Adjust position as needed
        errorLabel:SetColor(Color(255, 0, 0, 255)) -- Red text
    end

    -- Custom close button
    local closeButton = vgui.Create("DButton", basePanel)
    closeButton:SetSize(25, 25) -- Adjust size as needed
    closeButton:SetPos(panelWidth - 30, 5) -- Adjust position as needed
    closeButton:SetText("")
    closeButton.Paint = function(self, w, h)
        if self:IsHovered() then
            surface.SetDrawColor(219, 7, 7) -- Set the draw color to solid red
        else
            surface.SetDrawColor(255, 0, 0, 255) -- Set the draw color to solid red

        end
        -- draw a solid circle
        local circle = {}
        for i = 1, 360 do
            circle[i] = {
                x = w / 2 + math.cos(math.rad(i * 360 / 360)) * w / 2,
                y = h / 2 + math.sin(math.rad(i * 360 / 360)) * h / 2
            }
        end
        draw.NoTexture()
        surface.DrawPoly(circle)
    end
    closeButton.DoClick = function()
        basePanel:AlphaTo(0, 0.3, 0, function() -- Transition to fully transparent over 0.3 seconds
            basePanel:Close()
            CURRENT_UPGRADE_PLY = false
        end)
    end

    return basePanel
end

local function addPlayerDropdown(basePanel)
    local panelWidth, panelHeight = basePanel:GetSize()

    local dropdown = vgui.Create("DComboBox", basePanel)
    dropdown:SetSize(panelWidth * 0.2, panelHeight * 0.05) -- Adjust size as needed
    dropdown:SetPos(panelWidth * 0.5 - dropdown:GetWide() / 2, panelHeight * 0.1) -- Adjust position as needed
    dropdown:SetValue("Select a Player") -- Default text
    dropdown:SetTextColor(Color(255, 255, 255, 255)) -- White text
    dropdown:SetFont("UPGRADE::FONT::20") -- Adjust size as needed

    dropdown.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 255)) -- Dark mode background
    end

    -- Add players to the dropdown
    local localPlayer = LocalPlayer()
    local localPos = localPlayer:GetPos()
    local maxDistance = 1000 -- Set this to the maximum distance for a player to be considered "nearby"

    for _, ply in ipairs(player.GetAll()) do
        --if ply != localPlayer then -- Exclude the local player
            local plyPos = ply:GetPos()
            local distance = math.Round(localPos:Distance(plyPos)) -- Round the distance to the nearest whole number

            if distance <= maxDistance then
                dropdown:AddChoice(ply:Nick() .. "(" .. distance .. "m)", ply) -- Add the player to the dropdown
            end
        --end
    end

    dropdown.OnSelect = function(self, index, value, data)
        CURRENT_UPGRADE_PLY = false
        CURRENT_UPGRADES = {}
        PROGRESSION.CL.CurrentUpgrades = {}
        net.Start("PROGRESSION.CL.RequestData")
        net.WriteEntity(data)
        net.SendToServer()
    end
end

local function addUpgradeOptions(basePanel)
    local panelWidth, panelHeight = basePanel:GetSize()

    -- Store the positions of the V3 buttons and the "Second Heart" button
    local v3ButtonPositions = {}
    local secondHeartButtonPosition

    -- Function to create upgrade buttons
    local function createUpgradeButton(parent, text, posX, posY, width, height, level, skill, doesOwn)
        local button = vgui.Create("DButton", parent)
        button:SetSize(width, height)
        button:SetPos(posX, posY)
        button:SetText(text)
        button:SetFont("UPGRADE::FONT::20") -- Ensure this font is installed
        button:SetTextColor(color_white)
        button.level = level or false
        button.skill = skill or false
        button.owned = doesOwn or false
        if text == "Second Heart" then
            button.sHeart = true
        end
        button.Paint = function(self, w, h)
            if self.owned then
                draw.RoundedBox(5, 0, 0, w, h, Color(0, 255, 0, 255)) -- Green overlay
                self:SetText(text .. " (Owned)")
                return
            else
                draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50, 255)) -- Button background
                self:SetText(text)
            end
            if not CURRENT_UPGRADE_PLY and PROGRESSION.CL.CanUse(LocalPlayer()) then 
                draw.RoundedBox(5, 0, 0, w, h, Color(39, 35, 35)) -- Red overlay
                return
            end
            draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50, 255)) -- Button background

            if not PROGRESSION.CL.CanUse(LocalPlayer()) then
                return
            end
            if self:IsHovered() then
                draw.RoundedBox(5, 0, 0, w, h, Color(100, 100, 100, 255)) -- Hover overlay
            end

            self:SetTextColor(Color(255, 255, 255, 255)) -- White text
            -- if second heart button then all other buttons must be owned before it can be bought
            if self.sHeart then
                local canBuy = true
                for _, child in ipairs(parent:GetChildren()) do
                    if not child.owned and child.level then
                        if child.skill == "second_heart" then continue end
                        canBuy = false
                        break
                    end
                end
                if not canBuy then
                    draw.RoundedBox(5, 0, 0, w, h, Color(39, 35, 35)) -- Red overlay
                    self:SetTextColor(Color(255, 0, 0, 255)) -- Red text
                    self:SetText(text .. " (Locked)")
                    self.DoClick = function() end
                    return
                end
            end
        end
        timer.Simple(3, function()
            button.DoClick = function(s)
                if not CURRENT_UPGRADE_PLY then return end
                print("BEYOND")
                if not PROGRESSION.CL.CanUse(LocalPlayer()) then return end
                print("BEYOND USE")
                if s.owned then return end
                print("BEYOND OWNED")
                net.Start("PROGRESSION.CL.BuyUpgrade")
                    net.WriteEntity(CURRENT_UPGRADE_PLY.ply)
                    net.WriteString(skill)
                net.SendToServer()
                basePanel:Close()
                CURRENT_UPGRADE_PLY = false
            end
        end)


        -- Store the position of the V3 buttons and the "Second Heart" button
        if text:find("V3") then
            table.insert(v3ButtonPositions, {x = posX + width / 2, y = posY + height / 2})
        elseif text == "Second Heart" then
            secondHeartButtonPosition = {x = posX + width / 2, y = posY + height / 2}
        end

        return button
    end

    local upgradeWidth, upgradeHeight = panelWidth * 0.25, panelHeight * 0.1
    local spacing = 10 -- Space between buttons
    local startYPos = panelHeight - upgradeHeight * 3 -- Start from bottom
    local posXOffset = panelWidth * 0.05 -- Adjust as needed
    -- Health Upgrades
    for i = 1, 3 do
        createUpgradeButton(basePanel, "Health V" .. i, posXOffset, startYPos - (upgradeHeight + spacing) * (i - 1), upgradeWidth, upgradeHeight, i, "health")
    end

    -- Armor Upgrades
    posXOffset = panelWidth * 0.375 -- Adjust for center alignment
    for i = 1, 3 do
        createUpgradeButton(basePanel, "Armor V" .. i, posXOffset, startYPos - (upgradeHeight + spacing) * (i - 1), upgradeWidth, upgradeHeight, i, "armor")
    end

    -- Weight Upgrades
    posXOffset = panelWidth * 0.7 -- Adjust for right alignment
    for i = 1, 3 do
        createUpgradeButton(basePanel, "Weight V" .. i, posXOffset, startYPos - (upgradeHeight + spacing) * (i - 1), upgradeWidth, upgradeHeight, i, "weight")
    end

    -- Second Heart Skill
    createUpgradeButton(basePanel, "Second Heart", panelWidth * 0.5 - upgradeWidth / 2, startYPos * 0.4, upgradeWidth, upgradeHeight, 1, "second_heart") -- Adjust posY as needed
    --PrintTable(CURRENT_UPGRADE_PLY and CURRENT_UPGRADE_PLY or {})
    basePanel.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(40, 40, 40, 255)) -- Dark mode background

        -- Draw the lines
        surface.SetDrawColor(255, 255, 255, 255) -- White lines
        local lineSpacing = 35 -- Adjust as needed
        for _, pos in ipairs(v3ButtonPositions) do
            local direction = (secondHeartButtonPosition.y > pos.y) and 1 or -1
            surface.DrawLine(pos.x, pos.y + direction * lineSpacing, secondHeartButtonPosition.x, secondHeartButtonPosition.y - direction * lineSpacing)
        end
    end
end

local function CREATEUPGRADEPANEL()
    if UPGRADE_PANEL then
        if IsValid(UPGRADE_PANEL) then UPGRADE_PANEL:Close() end
    end
    UPGRADE_PANEL = createBasePanel("UPGRADE PANEL")
    addUpgradeOptions(UPGRADE_PANEL)
    addPlayerDropdown(UPGRADE_PANEL)
end

function PROGRESSION.CL.OpenUpgradePanel()
    CREATEUPGRADEPANEL()
end
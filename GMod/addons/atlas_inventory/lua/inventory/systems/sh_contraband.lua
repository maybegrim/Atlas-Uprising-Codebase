-- Shared
INVENTORY.CONTRA = INVENTORY.CONTRA or {}
INVENTORY.Contraband = INVENTORY.Contraband or {}
timer.Simple(1, function()
    INVENTORY.CanCheckContraband = {
        departments = {
            ["GSC"] = true,
            ["RA"] = true,
            --[[["NTF"] = true,
            ["E6"] = true,
            ["IST"] = true,
            ["MU4"] = true,
            ["SITE COMMAND"] = true,
            ["RA"] = true,
            ["MED"] = true,]]
        },
        jobs = {
            ["example"] = true,
        }
    }
end)

function INVENTORY.CONTRA.CanCheck(ply)
    if not IsValid(ply) then return false end
    if not ply:IsPlayer() then return false end
    if not ply:Team() then return false end
    if INVENTORY.CanCheckContraband.departments[RPExtraTeams[ply:Team()].department] then return true end
    if INVENTORY.CanCheckContraband.jobs[ply:Team()] then return true end
    return false
end

--[[hook.Add("INVENTORY.Items.Loaded", "INVENTORY.Contraband.Load", function()
    INVENTORY.Contraband = {}
    local typeContra = {
        ["weapon"] = {
            ["primary"] = true,
            ["secondary"] = true,
            ["belt"] = true
        },
        ["ammo"] = true,
        ["scp"] = true,
        ["item"] = false,
        ["armor"] = {
            ["helmet"] = true,
            ["chest"] = true,
            ["pants"] = true,
            ["boots"] = true
        }
    }
    local function IsContraband(item)
        if not istable(item) then return false end
        if not isstring(item.Type) then return false end
        if typeContra[item.Type] then
            if typeContra[item.Type] == true then return true end
            if item.SWEPSlot and typeContra[item.Type][item.SWEPSlot] then return true end
            if item.ArmorType and typeContra[item.Type][item.ArmorType] then return true end
        end
        return false
    end

    for item, itemFile, _ in pairs(INVENTORY.Item.Files) do
        local ITEM = INVENTORY.Item.GetScript(item)
        if IsContraband(ITEM) then
            INVENTORY.Contraband[item] = true
        end
    end
end)]]
timer.Simple(5, function()
    INVENTORY.Contraband = {}
    local typeContra = {
        ["weapon"] = {
            ["primary"] = true,
            ["secondary"] = true,
            ["belt"] = true
        },
        ["ammo"] = true,
        ["scp"] = true,
        ["item"] = false,
        ["armor"] = {
            ["helmet"] = true,
            ["chest"] = true,
            ["pants"] = true,
            ["boots"] = true
        }
    }
    local function IsContraband(item)
        if not istable(item) then return false end
        if not isstring(item.Type) then return false end
        if typeContra[item.Type] then
            if typeContra[item.Type] == true then return true end
            if item.SWEPSlot and typeContra[item.Type][item.SWEPSlot] then return true end
            if item.ArmorType and typeContra[item.Type][item.ArmorType] then return true end
        end
        return false
    end

    for item, itemFile, _ in pairs(INVENTORY.Item.Files) do
        local ITEM = INVENTORY.Item.GetScript(item)
        if IsContraband(ITEM) then
            INVENTORY.Contraband[item] = true
        end
    end
end)

if SERVER then
    -- Contraband System - A method to detect contraband items in a player's inventory
    util.AddNetworkString("INVENTORY::CONTRA::SEARCH")
    util.AddNetworkString("INVENTORY::CONTRA::SENDINV")
    util.AddNetworkString("INVENTORY::CONTRA::RECEIVEINV")
    util.AddNetworkString("INVENTORY::CONTRA::REQUESTINV")
    util.AddNetworkString("INVENTORY::CONTRA::STRIP")
    util.AddNetworkString("INVENTORY::CONTRA::MSG")
    INVENTORY.CONTRA.PlayersWaitingForSearch = INVENTORY.CONTRA.PlayersWaitingForSearch or {}

    function INVENTORY.CONTRA.SendMsg(ply, ...)
        if not IsValid(ply) then return end
        net.Start("INVENTORY::CONTRA::MSG")
        net.WriteTable({...})
        net.Send(ply)
    end

    function INVENTORY.CONTRA.Search(ply, target)
        if not IsValid(ply) then return end
        if not IsValid(target) then return end
        if not INVENTORY.CONTRA.CanCheck(ply) then return end
        if not target:IsPlayer() then return end
        INVENTORY.CONTRA.PlayersWaitingForSearch[target] = ply

        net.Start("INVENTORY::CONTRA::REQUESTINV")
        net.Send(target)

        -- clear the cache after 10 seconds
        timer.Simple(10, function()
            if not IsValid(target) then return end
            if not IsValid(ply) then return end
            if INVENTORY.CONTRA.PlayersWaitingForSearch[target] == ply then
                INVENTORY.CONTRA.PlayersWaitingForSearch[target] = nil
            end
        end)
    end

    function INVENTORY.CONTRA.StripContraband(sender, ply)
        if not IsValid(ply) then return end
        if not IsValid(sender) then return end
        if not INVENTORY.CONTRA.CanCheck(sender) then return end
        if sender:GetPos():DistToSqr(ply:GetPos()) > 100 * 100 then
            INVENTORY.CONTRA.SendMsg(sender, Color(255,56,56), "CONTRABAND | ", Color(255,255,255), "Distance Error.")
            return
        end
        local items = INVENTORY.Data[ply:SteamID64()]
        for k, v in pairs(items) do
            if not INVENTORY.Contraband[v.item and v.item or v] then continue end
            INVENTORY:RemoveItem(ply, k, false, false)
        end
        print("INVENTORY | " .. sender:Nick(), "has stripped", ply:Nick(), "of contraband items.")
        INVENTORY.CONTRA.SendMsg(ply, Color(255,56,56), "CONTRABAND | ", Color(255,255,255), "Your inventory has been stripped of contraband items by ", sender:Nick(), ".")
        INVENTORY.CONTRA.SendMsg(sender, Color(255,56,56), "CONTRABAND | ", Color(255,255,255), "You have stripped ", ply:Nick(), "'s inventory of contraband items.")
    end

    net.Receive("INVENTORY::CONTRA::STRIP", function(len, ply)
        local target = net.ReadEntity()
        INVENTORY.CONTRA.StripContraband(ply, target)
    end)

    net.Receive("INVENTORY::CONTRA::SENDINV", function(len, ply)
        if not INVENTORY.CONTRA.PlayersWaitingForSearch[ply] then return end
        local data = net.ReadData(len / 8)
        net.Start("INVENTORY::CONTRA::RECEIVEINV")
            net.WriteData(data, len / 8)
        net.Send(INVENTORY.CONTRA.PlayersWaitingForSearch[ply])
        INVENTORY.CONTRA.PlayersWaitingForSearch[ply] = nil
    end)

    local netCooldown = {}
    net.Receive("INVENTORY::CONTRA::SEARCH", function(len, ply)
        if netCooldown[ply:SteamID()] and netCooldown[ply:SteamID()] > CurTime() then print("NO") return end
        netCooldown[ply:SteamID()] = CurTime() + 60
        local target = net.ReadEntity()
        INVENTORY.CONTRA.Search(ply, target)
    end)
elseif CLIENT then
    -- Declare Ply Inv
    INVENTORY.CONTRA.PDATA = INVENTORY.CONTRA.PDATA or {}
    -- New Font
    surface.CreateFont("INVSTAFF", {
        font = "Arial",
        size = 13,
        weight = 700,
        antialias = true
    })
    net.Receive("INVENTORY::CONTRA::REQUESTINV", function(len)
        local inv = INVENTORY.ItemLayout
        local json = util.TableToJSON(inv)
        local compressed = util.Compress(json)
        net.Start("INVENTORY::CONTRA::SENDINV")
            net.WriteData(compressed, #compressed)
        net.SendToServer()
    end)

    net.Receive("INVENTORY::CONTRA::MSG", function(len)
        local msg = net.ReadTable()
        chat.AddText(unpack(msg))
    end)

    function INVENTORY.CONTRA.Close()
        if INVENTORY.CONTRA.Frame then
            INVENTORY.CONTRA.Frame:Close()
        end
    end
    INVENTORY.CONTRA.PendingPly = false
    function INVENTORY.CONTRA.IWantToSearchPly(ply)
        if not IsValid(ply) then return end
        if not INVENTORY.CONTRA.CanCheck(LocalPlayer()) then return end
        INVENTORY.CONTRA.PendingPly = ply
        net.Start("INVENTORY::CONTRA::SEARCH")
        net.WriteEntity(ply)
        net.SendToServer()
    end

    local hookCooldown = 0
    local lastSearchTimes = {}
    hook.Add("PlayerButtonDown", "INVENTORY.Contraband.Search", function(ply, key)
        if hookCooldown > CurTime() then return end
        hookCooldown = CurTime() + 0.3
        if key == KEY_F6 then
            -- Check if the player is within the cooldown period
            local currentTime = CurTime()
            if lastSearchTimes[ply:SteamID()] and currentTime - lastSearchTimes[ply:SteamID()] < 60 then
                ply:ChatPrint("You must wait before searching again.")
                return
            end
    
            if not INVENTORY.CONTRA.CanCheck(ply) then return end
            local trace = ply:GetEyeTrace()
            if not IsValid(trace.Entity) then return end
            if not trace.Entity:IsPlayer() then return end
            -- distance check
            if trace.StartPos:DistToSqr(trace.HitPos) > 100 * 100 then return end
    
            -- Update the player's last search time
            lastSearchTimes[ply:SteamID()] = currentTime
    
            INVENTORY.CONTRA.IWantToSearchPly(trace.Entity)
        end
    end)



    net.Receive("INVENTORY::CONTRA::RECEIVEINV", function(len)
        local inv = net.ReadData(len / 8)
        inv = util.Decompress(inv)
        inv = util.JSONToTable(inv)
        INVENTORY.CONTRA.PDATA = inv
        INVENTORY.CONTRA.Open(INVENTORY.CONTRA.PendingPly, false)
    end)
end
--UI
if CLIENT then
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
    -- Load Inventory Audio Library
    local audio = include("inventory/ui/sound/util.lua")
    -- Cache Inventory Config
    local invColumns, invRows = INVENTORY.CONFIG.Columns, INVENTORY.CONFIG.Rows
        -- Contraband UI
        function INVENTORY.CONTRA.Open(ply, staff_view)
            if not INVENTORY.CONTRA.PendingPly then
                staff_view = true
            end
            if INVENTORY.CONTRA.Frame then
                INVENTORY.CONTRA.Frame:Close()
            end
            local scrW, scrH = ScrW(), ScrH()
    
            audio.PlayInvSound("open")
            local panel = vgui.Create("EditablePanel")
            panel:SetSize(scrW, scrH)
            panel:MakePopup()
            panel:SetKeyboardInputEnabled(false)
            panel:SetMouseInputEnabled(true)
            panel:Center()
            panel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(theme.background.r, theme.background.g, theme.background.b, theme.background.a))
            end
            INVENTORY.CONTRA.Frame = panel
    
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
                INVENTORY.CONTRA.Frame = false
                INVENTORY.CONTRA.PendingPly = false
            end
    
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
        
        
            -- [CONTENTS]
            local contents = vgui.Create("DPanel", panel)
            contents:SetSize(650, 600)
            -- Leftish
            contents:SetPos(scrW * 0.1, 200)
        
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
    
            local itemSlots = {}
            local itemSlotSize = 110
            local itemSlotPadding = 5
            local itemSlotColumns = invColumns
            local itemSlotRows = invRows
            local itemSlotTotal = itemSlotColumns * itemSlotRows
            local itemSlotX, itemSlotY = 0, 0
    
            for i = 1, itemSlotTotal do
                local itemSlot = vgui.Create("DPanel", itemGridScroll)
                itemSlot:SetSize(itemSlotSize, itemSlotSize)
                itemSlot:SetPos(itemSlotX, itemSlotY)
                itemSlot.Paint = function(self, w, h)
                    -- Draw white lines outlining the itemslot
                    surface.SetDrawColor(Color(255, 255, 255, 255))
                    surface.DrawRect(0, 0, barThickness, h)
                    surface.DrawRect(0, h - barThickness, w, barThickness)
                    surface.DrawRect(w - barThickness, 0, barThickness, h)
                    surface.DrawRect(0, 0, w, barThickness)
        
        
        
                    if self.item then
                        -- draw a background for the text at the bottom center
                        -- if item is contraband lets flash red behind it
                        if INVENTORY.Contraband[self.item.UniqueName] and not staff_view then
                            local flash = math.abs(math.sin(CurTime() * 2) * 255)
                            surface.SetDrawColor(Color(255, 0, 0, flash))
                            surface.DrawRect(0, 0, w, h)
                        end
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
    
                        if staff_view then
                            -- write unique name in center
                            surface.SetFont("INVSTAFF")
                            surface.SetTextColor( 255, 255, 255 )
                            local text = self.item.UniqueName
                            local textW, textH = surface.GetTextSize(text)
                            -- center
                            surface.SetTextPos( w / 2 - textW / 2, h / 2 - textH / 2 )
                            surface.DrawText(text)
                        end
                    else
                        draw.SimpleText("Empty", "InventoryTileFont", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end
    
                itemSlots[i] = itemSlot
    
                itemSlotX = itemSlotX + itemSlotSize + itemSlotPadding
                if itemSlotX >= itemSlotColumns * (itemSlotSize + itemSlotPadding) then
                    itemSlotX = 0
                    itemSlotY = itemSlotY + itemSlotSize + itemSlotPadding
                end
            end
    
                -- [Equipment]
        local equipment = vgui.Create("DPanel", panel)
        equipment:SetSize(300, 370)
        -- Rightish
        equipment:SetPos(scrW * 0.5, 200)
    
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
        primaryWeapon:SetSize(equipment:GetWide() - 20, 100)
        primaryWeapon:SetPos(wepPosX, wepPosY)
        primaryWeapon:SetBackgroundColor(Color(255, 0, 0, 255))
        primaryWeapon.Title = "Primary"
        primaryWeapon.SlotType = "primary"
        primaryWeapon.WeaponSlot = true
    
        wepPosY = wepPosY + primaryWeapon:GetTall() + equipmentPadding
    
        -- [Equipment] - Secondary Weapon
        local secondaryWeapon = vgui.Create("DPanel", weaponSlots)
        secondaryWeapon:SetSize(equipment:GetWide() - 20, 100)
        secondaryWeapon:SetPos(wepPosX, wepPosY)
        secondaryWeapon:SetBackgroundColor(Color(255, 0, 0, 255))
        secondaryWeapon.Title = "Secondary"
        secondaryWeapon.SlotType = "secondary"
        secondaryWeapon.WeaponSlot = true
    
        wepPosY = wepPosY + secondaryWeapon:GetTall() + equipmentPadding
    
        -- [Equipment] - Belt Weapon
        local beltWeapon = vgui.Create("DPanel", weaponSlots)
        beltWeapon:SetSize(equipment:GetWide() - 20, 100)
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
                -- if item is contraband lets flash red behind it
                if INVENTORY.Contraband[self.activeItem.UniqueName] and not staff_view then
                    local flash = math.abs(math.sin(CurTime() * 2) * 255)
                    surface.SetDrawColor(Color(255, 0, 0, flash))
                    surface.DrawRect(0, 0, w, h)
                end
    
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
    
                if staff_view then
                    -- write unique name in center
                    surface.SetFont("INVSTAFF")
                    surface.SetTextColor( 255, 255, 255 )
                    local text = self.activeItem.UniqueName
                    local textW, textH = surface.GetTextSize(text)
                    -- center
                    surface.SetTextPos( w / 2 - textW / 2, h / 2 - textH / 2 )
                    surface.DrawText(text)
                end
            else
                surface.SetTextPos( w / 2 - textW / 2, 8 )
                surface.DrawText(titleText)
            end
    
        end
        primaryWeapon.Paint = paintWeaponSlots
        secondaryWeapon.Paint = paintWeaponSlots
        beltWeapon.Paint = paintWeaponSlots
    
            -- [Gear]
            local gear = vgui.Create("DPanel", panel)
            gear:SetSize(150, 500)
            -- Rightish
            gear:SetPos(scrW * 0.7, 200)
        
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
                    -- if item is contraband lets flash red behind it
                    if INVENTORY.Contraband[self.activeItem.UniqueName] and not staff_view then
                        local flash = math.abs(math.sin(CurTime() * 2) * 255)
                        surface.SetDrawColor(Color(255, 0, 0, flash))
                        surface.DrawRect(0, 0, w, h)
                    end
    
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
    
                    if staff_view then
                        -- write unique name in center
                        surface.SetFont("INVSTAFF")
                        surface.SetTextColor( 255, 255, 255 )
                        local text = self.activeItem.UniqueName
                        local textW, textH = surface.GetTextSize(text)
                        -- center
                        surface.SetTextPos( w / 2 - textW / 2, h / 2 - textH / 2 )
                        surface.DrawText(text)
                    end
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
    
            panel.PopulateItems = function()
                -- items will either have a column and a row value or it will say primary, secondary, belt, helmet, chest, pants, boots
                -- If column and row lets match that in our itemSlots, if not lets match it to the equipment slots
                for k, v in pairs(INVENTORY.CONTRA.PDATA) do
                    local item = v.item
                    if not item then continue end
                    if not v.row and not item.ArmorType then
                        if item.SWEPSlot == "primary" then
                            primaryWeapon.activeItem = item
                        elseif item.SWEPSlot == "secondary" then
                            secondaryWeapon.activeItem = item
                        elseif item.SWEPSlot == "belt" then
                            beltWeapon.activeItem = item
                        end
                    elseif item.ArmorType then
                        if item.ArmorType == "helmet" then
                            head.activeItem = item
                        elseif item.ArmorType == "chest" then
                            chest.activeItem = item
                        elseif item.ArmorType == "pants" then
                            legs.activeItem = item
                        elseif item.ArmorType == "boots" then
                            feet.activeItem = item
                        end
                    else
                        for i = 1, itemSlotTotal do
                            if itemSlots[i].item then continue end
                            itemSlots[i].item = item
                            break
                        end
                    end
                end
            end
    
            if not staff_view then
                -- Button bottomish center to strip contraband
                local stripContraband = vgui.Create("DButton", panel)
                stripContraband:SetSize(200, 50)  -- Adjusted size to match craftButton
                stripContraband:SetText("")  -- Removed text to use custom drawing
                stripContraband:SetPos(scrW / 2 - 100, scrH - 200)
                stripContraband.Paint = function(self, w, h)
                    -- white outline clear inside
                    surface.SetDrawColor(Color(208, 56, 56))
                    surface.DrawRect(0, 0, barThickness, h)
                    surface.DrawRect(0, h - barThickness, w, barThickness)
                    surface.DrawRect(w - barThickness, 0, barThickness, h)
                    surface.DrawRect(0, 0, w, barThickness)
    
                    -- Set text
                    surface.SetFont("InventoryTileFont")
                    surface.SetTextColor(255, 255, 255)
                    local text = "Strip Contraband"
                    local textW, textH = surface.GetTextSize(text)
                    -- center text
                    surface.SetTextPos(w / 2 - textW / 2, h / 2 - textH / 2)
                    surface.DrawText(text)
    
                    -- Hover effect
                    if self.Hovered then
                        surface.SetDrawColor(Color(116, 31, 31, 123))
                        surface.DrawRect(0, 0, w, h)
                    end
    
                    -- Click effect
                    if self:IsDown() then
                        surface.SetDrawColor(Color(255, 255, 255, 20))
                        surface.DrawRect(0, 0, w, h)
                    end
                end
                stripContraband.DoClick = function()
                    net.Start("INVENTORY::CONTRA::STRIP")
                        net.WriteEntity(ply)
                    net.SendToServer()
                    INVENTORY.CONTRA.Frame:Remove()
                    INVENTORY.CONTRA.Frame = false
                end
            end
    
            -- cancel button
            local cancelButton = vgui.Create("DButton", panel)
            cancelButton:SetSize(200, 50)
            cancelButton:SetPos(scrW / 2 - 100, scrH - 130)
            cancelButton:SetText("")
            cancelButton.Paint = function(self, w, h)
                -- white outline clear inside
                surface.SetDrawColor(Color(255, 255, 255))
                surface.DrawRect(0, 0, barThickness, h)
                surface.DrawRect(0, h - barThickness, w, barThickness)
                surface.DrawRect(w - barThickness, 0, barThickness, h)
                surface.DrawRect(0, 0, w, barThickness)
    
                -- Set text
                surface.SetFont("InventoryTileFont")
                surface.SetTextColor(255, 255, 255)
                local text = "Close"
                local textW, textH = surface.GetTextSize(text)
                -- center text
                surface.SetTextPos(w / 2 - textW / 2, h / 2 - textH / 2)
                surface.DrawText(text)
    
                -- Hover effect
                if self.Hovered then
                    surface.SetDrawColor(Color(255,255,255,10))
                    surface.DrawRect(0, 0, w, h)
                end
    
                -- Click effect
                if self:IsDown() then
                    surface.SetDrawColor(Color(255, 255, 255, 20))
                    surface.DrawRect(0, 0, w, h)
                end
            end
        
            cancelButton.DoClick = function()
                panel:Remove()
                INVENTORY.CONTRA.Frame = false
                INVENTORY.CONTRA.PendingPly = false
            end
            
    
            panel:MakePopup()
    
            panel.PopulateItems()
        end
end

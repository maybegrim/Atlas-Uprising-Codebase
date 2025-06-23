
local maxSize = INVENTORY.CONFIG.Rows * INVENTORY.CONFIG.Columns
INVENTORY.TradeRequest = false

local function autoEquipItem(item)
    if not item then return end
    if item.Type == "armor" then
        if item.ArmorType == "helmet" then
            table.insert(INVENTORY.ItemLayout, {item = item, head = true})
            timer.Simple(1, function()
                net.Start("Inventory::EquipItem")
                    net.WriteInt(item.id, 21)
                net.SendToServer()
            end)
            return
        end

        if item.ArmorType == "chest" then
            table.insert(INVENTORY.ItemLayout, {item = item, chest = true})
            timer.Simple(1, function()
                net.Start("Inventory::EquipItem")
                    net.WriteInt(item.id, 21)
                net.SendToServer()
            end)
            return
        end

        if item.ArmorType == "pants" then
            table.insert(INVENTORY.ItemLayout, {item = item, legs = true})
            timer.Simple(1, function()
                net.Start("Inventory::EquipItem")
                    net.WriteInt(item.id, 21)
                net.SendToServer()
            end)
            return
        end

        if item.ArmorType == "boots" then
            table.insert(INVENTORY.ItemLayout, {item = item, feet = true})
            timer.Simple(1, function()
                net.Start("Inventory::EquipItem")
                    net.WriteInt(item.id, 21)
                net.SendToServer()
            end)
            return
        end
    end

    if item.Type == "weapon" then
        if item.SWEPSlot == "primary" then
            table.insert(INVENTORY.ItemLayout, {item = item, primary = true})
            timer.Simple(1, function()
                net.Start("Inventory::EquipItem")
                    net.WriteInt(item.id, 21)
                net.SendToServer()
            end)
            return
        end

        if item.SWEPSlot == "secondary" then
            table.insert(INVENTORY.ItemLayout, {item = item, secondary = true})
            timer.Simple(1, function()
                net.Start("Inventory::EquipItem")
                    net.WriteInt(item.id, 21)
                net.SendToServer()
            end)
            return
        end

        if item.SWEPSlot == "belt" then
            table.insert(INVENTORY.ItemLayout, {item = item, belt = true})
            timer.Simple(1, function()
                net.Start("Inventory::EquipItem")
                    net.WriteInt(item.id, 21)
                net.SendToServer()
            end)
            return
        end
    end
    return 2
end

function INVENTORY.AddToLayout(item, itemID, force_equipcheck)
    if not item or not itemID then return end
    if not istable(item) then
        item = INVENTORY.Item.GetScript(item)
    end
    if not item then return end
    item["id"] = itemID

    if #INVENTORY.ItemLayout >= maxSize then
        return false
    end
    local column, row

    local force = force_equipcheck or false

    if LocalPlayer().JustRespawned or force then
        if autoEquipItem(item) ~= 2 then
            return
        end
    end

    for i = 1, maxSize do
        -- let column  and row equal the next index.
        row = math.floor((i - 1) / INVENTORY.CONFIG.Columns) + 1
        column = (i - 1) % INVENTORY.CONFIG.Columns + 1

        local found = false
        for k, v in pairs(INVENTORY.ItemLayout) do
            if v.column == column and v.row == row then
                found = true
                break
            end
        end
        if not found then
            break
        end
    end


    chat.AddText(Color(251,125,90), "INVENTORY | ", Color(255,255,255), "You have received a ", Color(146,208,255), item.Name, Color(255,255,255), "!")


    table.insert(INVENTORY.ItemLayout, {item = item, column = column, row = row})
    
    hook.Run("Inventory::ItemAdded", item, column, row)

end



function INVENTORY.DestroyItem(itemID)
    if not itemID then return end

    for k, v in pairs(INVENTORY.ItemLayout) do
        if v.item.id == itemID then  -- Compare unique IDs
            table.remove(INVENTORY.ItemLayout, k)
            hook.Run("Inventory::ItemRemoved", itemID, v.column, v.row)
            net.Start("Inventory::DestroyItem")
            net.WriteInt(itemID, 21)  -- Send unique ID to server
            net.SendToServer()
            return true
        end
    end
    return false
end

function INVENTORY.DestroyItemFromServer(itemID)
    if not itemID then return end

    for k, v in pairs(INVENTORY.ItemLayout) do
        if v.item.id == itemID then  -- Compare unique IDs
            table.remove(INVENTORY.ItemLayout, k)
            hook.Run("Inventory::ItemRemoved", itemID, v.column, v.row)
            return true
        end
    end
    return false
end

function INVENTORY.UseItem(itemID)
    if not itemID then return end
    net.Start("Inventory::UseItem")
    net.WriteInt(itemID, 21)  -- Send unique ID to server
    net.SendToServer()
end

function INVENTORY.HaveItem(itemName)
    for k, v in pairs(INVENTORY.ItemLayout) do
        if v.item.UniqueName == itemName then
            return true
        end
    end
    return false
end


net.Receive("Inventory::AddItem", function()
    local item = net.ReadString()  -- Read the unique ID
    local itemID = net.ReadInt(21)
    local forceCheck = net.ReadBool()
    timer.Simple(0.6, function()
        INVENTORY.AddToLayout(item, itemID, forceCheck)
    end)
end)

net.Receive("Inventory::RemoveItem", function()
    local uniqueID = net.ReadInt(21)  -- Read the unique ID
    INVENTORY.DestroyItemFromServer(uniqueID)
end)

net.Receive("Inventory::Reset", function()
    INVENTORY.ItemLayout = {}
    INVENTORY:CloseUI()
    timer.Simple(0.5, function()
        INVENTORY.ItemLayout = {}
    end)
end)

local function HasArmor()
    local layout = INVENTORY.ItemLayout

    for k, v in pairs(layout) do
        if v.head or v.chest or v.legs or v.feet then
            return true
        end
    end
end

-- if armor goes to 0 then play sound effect of armor breaking
INVENTORY.ArmorBroken = true
hook.Add("Think", "Inventory::ArmorThink", function()
    if not LocalPlayer():Alive() then return end
    if LocalPlayer():Armor() <= 0 and HasArmor() then
        if not INVENTORY.ArmorBroken then
            surface.PlaySound("inventory/armor_break.wav")
            INVENTORY.ArmorBroken = true
        end
    else
        INVENTORY.ArmorBroken = false
    end
end)



-- [Trade]
net.Receive("Inventory::TradeRequest", function()
    local ply = net.ReadEntity()
    chat.AddText(Color(251,125,90), "INVENTORY | ", Color(255,255,255), "You have received a trade request from ", Color(146,208,255), ply:Nick(), Color(255,255,255), "!")
    chat.AddText(Color(251,125,90), "INVENTORY | ", Color(255,255,255), "Press ", Color(146,208,255), "F2", Color(255,255,255), " to accept the trade request. You have 30 seconds to accept.")
    INVENTORY.TradeRequest = {player = ply}
    timer.Simple(30, function()
        if IsValid(ply) and INVENTORY.TradeRequest and  INVENTORY.TradeRequest.player == ply then
            chat.AddText(Color(251,125,90), "INVENTORY | ", Color(255,255,255), "Trade request from ", Color(146,208,255), ply:Nick(), Color(255,255,255), " has expired.")
            INVENTORY.TradeRequest = false
        end
    end)
end)

net.Receive("Inventory::TradeStart", function()
    local ply = net.ReadEntity()

    INVENTORY:OpenTradePanel({tradePly = ply})
end)
local slowThink = 0
hook.Add("ShowTeam", "Inventory::TradeRequest", function()
    if slowThink > CurTime() then return end
    slowThink = CurTime() + 1
    if not INVENTORY.TradeRequest then
        -- Lets make one, make player type /trade
        local ply = LocalPlayer():GetEyeTrace().Entity
        if not IsValid(ply) then return end
        if not ply:IsPlayer() then return end
        if ply == LocalPlayer() then return end
        -- run inventory_trade command
        RunConsoleCommand("inventory_trade")
        chat.AddText(Color(251,125,90), "INVENTORY | ", Color(255,255,255), "You have sent a trade request to ", Color(146,208,255), ply:Nick(), Color(255,255,255), ".")
        return
    end
    net.Start("Inventory::TradeRequest")
        net.WriteEntity(INVENTORY.TradeRequest.player)
    net.SendToServer()
    INVENTORY.TradeRequest = false
end)

net.Receive("Inventory::TradeCancel", function()
    INVENTORY:CloseTradePanel()
    chat.AddText(Color(251,125,90), "INVENTORY | ", Color(255,255,255), "Trade has been canceled. Reason: ", Color(146,208,255), net.ReadString(), Color(255,255,255), ".")
end)


net.Receive("Inventory::TradeUpdate", function()
    local items = net.ReadTable()

    local itemsTabled = {}

    for k, v in pairs(items) do
        local item = INVENTORY.Item.GetScript(k)
        if item then
            itemsTabled[item] = true
        end
    end
    INVENTORY.TradePanel.NewItemUnConfirm()
    INVENTORY.TradePanel.PopulatePartnerTradeItems(itemsTabled)
end)

net.Receive("Inventory::TradeComplete", function()
    -- Play gmod default sound effect
    surface.PlaySound("garrysmod/content_downloaded.wav")
    INVENTORY:CloseTradePanel()
end)

net.Receive("Inventory::TradeConfirm", function()
    INVENTORY.TradePanel.UpdateTradeStatus(net.ReadBool())
end)

-- Lets make a hook that detects when the player just respawns clientside and then lets flag a variable on them that they just respawned
hook.Add("Think", "Inventory::RespawnThink", function()
    if not LocalPlayer():Alive() then LocalPlayer().IsDead = true return end
    if not LocalPlayer().JustRespawned and LocalPlayer().IsDead then
        LocalPlayer().JustRespawned = true
        LocalPlayer().IsDead = false
        timer.Simple(2, function()
            LocalPlayer().JustRespawned = false
        end)
    end
end)

-- Make a hook a to check if on a new job then JustRespawned = true
hook.Add("Think", "Inventory::JobThink", function()
    if LocalPlayer().JustRespawned then return end
    if not LocalPlayer().LastTeam then LocalPlayer().LastTeam = false end
    if LocalPlayer():Team() ~= LocalPlayer().LastTeam then
        LocalPlayer().JustRespawned = true
        LocalPlayer().LastTeam = LocalPlayer():Team()
        timer.Simple(2, function()
            LocalPlayer().JustRespawned = false
        end)
    end
end)
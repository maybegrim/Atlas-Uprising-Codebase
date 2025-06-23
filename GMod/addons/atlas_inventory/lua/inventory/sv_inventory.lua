
-- Create the inventory table
INVENTORY.Data = INVENTORY.Data or {}
INVENTORY.PlayerLoadouts = INVENTORY.PlayerLoadouts or {}
INVENTORY.TradeData = INVENTORY.TradeData or {}
INVENTORY.TradeRequests = INVENTORY.TradeRequests or {}

-- Load the utility module from the specified path, making various utility functions available through the 'Utility' variable.
-- This module is expected to be located at "inventory/functions/utility.lua".
local Utility = include("inventory/functions/utility.lua")

util.AddNetworkString("Inventory::AddItem")
util.AddNetworkString("Inventory::RemoveItem")
util.AddNetworkString("Inventory::UseItem")
util.AddNetworkString("Inventory::EquipItem")
util.AddNetworkString("Inventory::UnequipItem")
util.AddNetworkString("Inventory::DestroyItem")
util.AddNetworkString("Inventory::Reset")
util.AddNetworkString("Inventory::Craft")
util.AddNetworkString("Inventory::TradeRequest")
util.AddNetworkString("Inventory::TradeStart")
util.AddNetworkString("Inventory::TradeCancel")
util.AddNetworkString("Inventory::TradeUpdate")
util.AddNetworkString("Inventory::TradeConfirm")
util.AddNetworkString("Inventory::TradeComplete")
util.AddNetworkString("Inventory::RepairArmor")

function INVENTORY:Start(ply)
    INVENTORY.Data[ply:SteamID64()] = {}
    INVENTORY.PlayerLoadouts[ply:SteamID64()] = {
        ["primary"] = false,
        ["secondary"] = false,
        ["belt"] = false,
        ["helmet"] = false,
        ["chest"] = false,
        ["pants"] = false,
        ["boots"] = false
    }
end

function INVENTORY:Reset(ply)
    INVENTORY:Start(ply)
    net.Start("Inventory::Reset")
    net.Send(ply)
end

function INVENTORY:End(ply)
    INVENTORY.Data[ply:SteamID64()] = nil
    INVENTORY.PlayerLoadouts[ply:SteamID64()] = nil
end

function INVENTORY:AddItem(ply, item, forceCheck)
    local inv = INVENTORY.Data[ply:SteamID64()]

    if Utility:isInventoryFull(inv) then
        print("[Inventory] [FULL] Tried to add an item to a full inventory: " .. item)
        return false
    end

    if not INVENTORY.Item.Exists(item) then
        print("[Inventory] [INVALID] Tried to add an item that doesn't exist: " .. item)
        return false
    end

    local uniqueID = Utility.generateUniqueID()
    local itemScript = INVENTORY.Item.GetScript(item)

    if itemScript and itemScript.Type == "weapon" then
        inv[uniqueID] = {
            item = item,
            ammo = itemScript.DefaultAmmo
        }
    elseif itemScript and itemScript.Type == "armor" then
        inv[uniqueID] = {
            item = item,
            value = itemScript.ArmorValue
        }
    else
        inv[uniqueID] = item
    end

    net.Start("Inventory::AddItem")
        net.WriteString(item)
        net.WriteInt(uniqueID, 21)
        net.WriteBool(forceCheck or false)
    net.Send(ply)

    print("[Inventory] [ADD] Added item " .. item .. " to " .. ply:Nick() .. "'s inventory. " .. ply:SteamID64())

    hook.Run("Inventory::ItemAdded", ply, item)

    return true, uniqueID
end

function INVENTORY:HasItem(ply, uniqueID)
    local inv = INVENTORY.Data[ply:SteamID64()]

    return inv[uniqueID] ~= nil
end

function INVENTORY:HasItemFromName(ply, itemName)
    local inv = INVENTORY.Data[ply:SteamID64()]

    for id, item in pairs(inv) do
        if item.item == itemName then
            return item.item, id
        end
        if item == itemName then
            return item, id
        end
    end

    return false
end

function INVENTORY:GetItem(ply, uniqueID)
    local inv = INVENTORY.Data[ply:SteamID64()]

    return inv[uniqueID] and inv[uniqueID].item and inv[uniqueID].item or inv[uniqueID] or nil
end

function INVENTORY:RemoveItem(ply, uniqueID, isDestroy, craftingRemove)
    local inv = INVENTORY.Data[ply:SteamID64()]
    if not inv[uniqueID] then
        return false
    end
    local tempItemCache = inv[uniqueID]
    inv[uniqueID] = nil  -- Removing item by its unique ID

    if not isDestroy then
        net.Start("Inventory::RemoveItem")
            net.WriteInt(uniqueID, 21)  -- Sending unique ID instead of item
        net.Send(ply)
    end

    -- if item was armor make sure we deduct the armor value from the player
    if tempItemCache.value and not craftingRemove then
        local armor = ply:Armor()
        local armorCount = Utility:getArmorCount(ply)
        local newArmor = armor - tempItemCache.value
        local valueArmor = newArmor / armorCount
        ply:SetArmor(newArmor)
        for id, item in pairs(inv) do
            local itemScript = INVENTORY.Item.GetScript(item.item)
            if not Utility:isItemEquipped(ply, itemScript) then continue end
            if itemScript and itemScript.Type == "armor" then
                item.value = valueArmor
                INVENTORY.NET.WriteData(ply, id, "value", valueArmor)
            end
            INVENTORY.PlayerLoadouts[ply:SteamID64()][itemScript.ArmorType] = false
        end
        
        local item = INVENTORY.Item.GetScript(tempItemCache.item)
        item:OnUnequip(ply)
    end

    -- if item was a weapon make sure we remove the weapon from the player
    if tempItemCache.item then
        local item = INVENTORY.Item.GetScript(tempItemCache.item)
        if item and item.Type == "weapon" then
            local weapon = ply:GetWeapon(item.UniqueName)
            if IsValid(weapon) then
                weapon:Remove()
            end
            INVENTORY.PlayerLoadouts[ply:SteamID64()][item.SWEPSlot] = false
        end
    end

    local term = isDestroy and "Destroyed" or "Removed"
    local itemName = tempItemCache.item or tempItemCache or "Unknown"
    print("[Inventory] " .. term  .. " item " .. itemName .. " from " .. ply:Nick() .. "'s inventory.")

    hook.Run("Inventory::ItemRemoved", ply, tempItemCache.item)

    return true
end

function INVENTORY:RemoveAllItems(ply)
    local inv = INVENTORY.Data[ply:SteamID64()]
    for id, item in pairs(inv) do
        INVENTORY:RemoveItem(ply, id)
    end
end

function INVENTORY:RemoveAllActiveWeapons(ply)
    local inv = INVENTORY.Data[ply:SteamID64()]
    for id, item in pairs(inv) do
        if not Utility:isItemEquipped(ply, item.item) then continue end
        local itemScript = INVENTORY.Item.GetScript(item.item)
        if itemScript and itemScript.Type == "weapon" then
            INVENTORY:RemoveItem(ply, id)
        end
    end
end

function INVENTORY:RemoveAllWeapons(ply)
    local inv = INVENTORY.Data[ply:SteamID64()]
    for id, item in pairs(inv) do
        local itemScript = INVENTORY.Item.GetScript(item.item)
        if itemScript and itemScript.Type == "weapon" then
            INVENTORY:RemoveItem(ply, id)
        end
    end
end

function INVENTORY:UseItem(ply, uniqueID)
    local inv = INVENTORY.Data[ply:SteamID64()]
    local invItem = inv[uniqueID]
    if invItem then
        local item = INVENTORY.Item.GetScript(invItem)
        if not item then return end
        if not item.Can.Use then
            return
        end

        item:Use(ply)

        print("[Inventory] Used item " .. item.Name .. " from " .. ply:Nick() .. "'s inventory.")

        if item.RemoveOnUse then
            INVENTORY:RemoveItem(ply, uniqueID)
        end
    end
end

function INVENTORY:EquipItem(ply, uniqueID)
    local inv = INVENTORY.Data[ply:SteamID64()]
    local invItem = inv[uniqueID]
    if invItem then
        local item = INVENTORY.Item.GetScript(invItem.item)

        if item then
            if Utility:isItemEquipped(ply, item) then
                print("ITEM IS EQUIPPED")
                return
            end
            if ply:InPassiveMode() and item.Type == "weapon" then
                ply:ChatPrint("| You cannot equip weapons while in passive mode.")
                return
            end
            Utility:equipLoadout(ply, item)
            item:OnEquip(ply)

            print("[Inventory] Equipped item " .. item.Name .. " from " .. ply:Nick() .. "'s inventory. " .. ply:SteamID64())

            -- Ammo handling
            if item.Type == "weapon" then
                local weapon = ply:GetWeapon(item.UniqueName)

                if IsValid(weapon) then
                    weapon:SetClip1(invItem.ammo or weapon:GetMaxClip1())
                end
            end

            -- Armor handling
            --[[if item.Type == "armor" then

            end]]

            if item.IsEquippable then
                invItem.equipped = true
            end
        end
    end
end

function INVENTORY:UnequipItem(ply, uniqueID)
    local inv = INVENTORY.Data[ply:SteamID64()]
    local invItem = inv[uniqueID]
    if invItem then
        local item = INVENTORY.Item.GetScript(invItem.item)
        if item then
            if not Utility:isItemEquipped(ply, item) then
                return
            end
            if item.Type == "weapon" then
                local weapon = ply:GetWeapon(item.UniqueName)
                if IsValid(weapon) then
                    invItem.ammo = weapon:Clip1()
                end
            end

            if item.Type == "armor" then
                invItem.value = ply:Armor()
            end
            inv[uniqueID].JustUnequipped = true
            Utility:unequipLoadout(ply, item)
            item:OnUnequip(ply)
            timer.Simple(1, function()
                if not IsValid(ply) then return end
                if not inv[uniqueID] then return end
                inv[uniqueID].JustUnequipped = false
            end)
            print("[Inventory] Unequipped item " .. item.Name .. " from " .. ply:Nick() .. "'s inventory. " .. ply:SteamID64())
        end
    end
end

function INVENTORY:UnequipActiveItems(ply)
    local inv = INVENTORY.Data[ply:SteamID64()]
    for uniq, item in pairs(inv) do
        if not Utility:isItemEquipped(ply, item.item) then continue end
        local itemScript = INVENTORY.Item.GetScript(item.item)
        if itemScript and itemScript.Type == "weapon" then
            INVENTORY:UnequipItem(ply, uniq)
        end
    end
end

function INVENTORY:HandleCraft(ply, items)
    local recipeItemTable = {}

    for item, _ in pairs(items) do
        if not INVENTORY:HasItem(ply, item) then
            return
        end
        
        recipeItemTable[INVENTORY:GetItem(ply, item)] = recipeItemTable[INVENTORY:GetItem(ply, item)] and recipeItemTable[INVENTORY:GetItem(ply, item)] + 1 or 1
    end

    local recipeName, craftedItem = INVENTORY.Crafting.IsRecipe(recipeItemTable)

    if not craftedItem then
        return
    end

    for item, _ in pairs(items) do
        INVENTORY:RemoveItem(ply, item, false, true)
    end

    INVENTORY:AddItem(ply, craftedItem)

    print("[Inventory] Crafted item " .. craftedItem .. " from " .. ply:Nick() .. "'s inventory. " .. ply:SteamID64())
end


hook.Add("PlayerAuthed", "Inventory::PlayerAuthed", function(ply)
    INVENTORY:Start(ply)
end)

hook.Add("PlayerDisconnected", "Inventory::PlayerDisconnected", function(ply)
    INVENTORY:End(ply)
end)

hook.Add("PlayerDeath", "Inventory::PlayerSpawn", function(ply)
    INVENTORY:Reset(ply)
end)

hook.Add("PlayerChangedTeam", "Inventory::PlayerSpawn", function(ply)
    INVENTORY:Reset(ply)
end)


hook.Add("PlayerDroppedWeapon", "Inventory::PlayerDroppedWeapon", function(ply, wep)
    print("[INV-DEBUG] Inventory::PlayerDroppedWeapon CALLED for " .. wep:GetClass() .. " on " .. ply:SteamID64() .. ".")
    if not IsValid(ply) then return end
    local inv = INVENTORY.Data[ply:SteamID64()]
    local itemToRemove = nil
    for id, item in pairs(inv) do
        if not item.item then continue end
        if wep:GetClass() == item.item and not item.JustUnequipped then
            itemToRemove = id
            break
        end
    end

    if itemToRemove then
        INVENTORY:RemoveItem(ply, itemToRemove)
    end
end)

hook.Add("WeaponEquip", "Inventory::WeaponEquip", function(wep, ply)
    print("[INV-DEBUG] Inventory::WeaponEquip CALLED for " .. wep:GetClass() .. " on " .. ply:SteamID64() .. ".")
    local swepClass = wep:GetClass()
    if INVENTORY.CONFIG.DenyListSweps[swepClass] then return end

    -- check if player has the item in their inventory already
    if INVENTORY:HasItemFromName(ply, swepClass) then return end

    if INVENTORY.Item.Exists(swepClass) then
        if not IsValid(ply) then return end
        if not ply:Alive() then return end
        local _, itemID = INVENTORY:AddItem(ply, swepClass)
        INVENTORY.Data[ply:SteamID64()][itemID].JustUnequipped = true
        -- remove weapon
        timer.Simple(0, function()
            local weapon = ply:GetWeapon(swepClass)
            if IsValid(weapon) then
                weapon:Remove()
            end
        end)
    end
end)

net.Receive("Inventory::DestroyItem", function(len, ply)
    local uniqueID = net.ReadInt(21)
    INVENTORY:RemoveItem(ply, uniqueID, true)
end)

net.Receive("Inventory::UseItem", function(len, ply)
    local uniqueID = net.ReadInt(21)

    INVENTORY:UseItem(ply, uniqueID)
end)

net.Receive("Inventory::Craft", function(_, ply)
    local itemOne, itemTwo = net.ReadInt(21), net.ReadInt(21)
    INVENTORY:HandleCraft(ply, {[itemOne] = true, [itemTwo] = true})
end)

net.Receive("Inventory::EquipItem", function(len, ply)
    local uniqueID = net.ReadInt(21)
    INVENTORY:EquipItem(ply, uniqueID)
end)

net.Receive("Inventory::UnequipItem", function(len, ply)
    local uniqueID = net.ReadInt(21)
    INVENTORY:UnequipItem(ply, uniqueID)
end)

hook.Add("PostEntityTakeDamage", "Inventory::ArmorDamage", function(ent, dmg, took)
    if not ent:IsPlayer() then return end
    --if not took then return end
    -- Check if the damage type affects the armor
    if not dmg:IsDamageType(DMG_BULLET) and not dmg:IsDamageType(DMG_SLASH) then
        return
    end

    local armor = ent:Armor()
    local armorCount = Utility:getArmorCount(ent)

    if armor <= 0 and armorCount > 0 then
        if ent.ArmorBroken then return end
        ent.ArmorBroken = true
    end

    local newArmor = armor

    local inv = INVENTORY.Data[ent:SteamID64()]
    for id, item in pairs(inv) do
        local itemScript = INVENTORY.Item.GetScript(item.item)
        if not Utility:isItemEquipped(ent, itemScript) then continue end
        if itemScript and itemScript.Type == "armor" then
            local valueArmor = newArmor / armorCount
            item.value = valueArmor

            --INVENTORY.NET.WriteData(ply, pItemID, pKey, pValue)
            INVENTORY.NET.WriteData(ent, id, "value", valueArmor)

            if valueArmor <= 0 and not ent.ArmorBroken then
                ent.ArmorBroken = true
            elseif valueArmor > 0 and ent.ArmorBroken then
                ent.ArmorBroken = false
            end
        end
    end
end)

hook.Add("EntityTakeDamage", "INVENTORY::ARMORMITI", function(ent, dmg)
    if not ent:IsPlayer() then return end

    if not dmg:IsDamageType(DMG_BULLET) and not dmg:IsDamageType(DMG_SLASH) then
        return
    end

    local armor = ent:Armor()
    local damage = dmg:GetDamage()

    if armor > 0 then
        if damage <= armor then
            ent:SetArmor(armor - damage)
            dmg:SetDamage(0)
            return
        else
            dmg:SetDamage(damage - armor)
            ent:SetArmor(0)
        end
    end
end)

-- [Trading]
function INVENTORY:HandleTrade(plyOne, plyTwo, plyOneItems, plyTwoItems)
    local plyOneItemTable = {}
    local plyTwoItemTable = {}

    for item, _ in pairs(plyOneItems) do
        local hasItem, hasItemID = INVENTORY:HasItemFromName(plyOne, item)
        if not hasItem then
            return
        end
        plyOneItemTable[hasItem] = hasItemID
    end

    for item, _ in pairs(plyTwoItems) do
        local hasItem, hasItemID = INVENTORY:HasItemFromName(plyTwo, item)
        if not hasItem then
            return
        end
        plyTwoItemTable[hasItem] = hasItemID
    end

    local plyOneName, plyTwoName = plyOne:Nick(), plyTwo:Nick()



    for item, itemID in pairs(plyOneItemTable) do
        INVENTORY:RemoveItem(plyOne, itemID)
    end

    for item, itemID in pairs(plyTwoItemTable) do
        INVENTORY:RemoveItem(plyTwo, itemID)
    end

    for item, _ in pairs(plyOneItemTable) do
        INVENTORY:AddItem(plyTwo, item)
    end

    for item, _ in pairs(plyTwoItemTable) do
        INVENTORY:AddItem(plyOne, item)
    end

    print("[Inventory] Traded items between " .. plyOneName .. " and " .. plyTwoName .. ". ONE: " .. plyOne:SteamID64() .. " TWO: " .. plyTwo:SteamID64())
end


function INVENTORY:TradeStart(plyOne, plyTwo)
    if not plyOne or not plyTwo then
        return
    end

    INVENTORY.TradeData[plyOne:SteamID64()] = {}
    INVENTORY.TradeData[plyTwo:SteamID64()] = {}

    INVENTORY.TradeData[plyOne:SteamID64()].partner = plyTwo
    INVENTORY.TradeData[plyTwo:SteamID64()].partner = plyOne

    INVENTORY.TradeData[plyOne:SteamID64()].items = {}
    INVENTORY.TradeData[plyTwo:SteamID64()].items = {}

    INVENTORY.TradeData[plyOne:SteamID64()].confirmed = false
    INVENTORY.TradeData[plyTwo:SteamID64()].confirmed = false

    net.Start("Inventory::TradeStart")
        net.WriteEntity(plyTwo)
    net.Send(plyOne)

    net.Start("Inventory::TradeStart")
        net.WriteEntity(plyOne)
    net.Send(plyTwo)

    local plyOneName, plyTwoName = plyOne:Nick(), plyTwo:Nick()

    print("[Inventory] Started trade between " .. plyOneName .. " and " .. plyTwoName .. ". ONE: " .. plyOne:SteamID64() .. " TWO: " .. plyTwo:SteamID64())
end

function INVENTORY:TradeUpdate(ply, items)
    if not INVENTORY.TradeData[ply:SteamID64()] then return end
    local partner = INVENTORY.TradeData[ply:SteamID64()].partner
    if not IsValid(partner) or not partner:IsPlayer() then return end
    local validatedItems = {}
    for item, _ in pairs(items) do
        if not INVENTORY:HasItem(ply, item) then continue end
        local itemVal = INVENTORY:GetItem(ply, item)
        INVENTORY.TradeData[ply:SteamID64()].items[itemVal] = true
        validatedItems[itemVal] = true
    end
    net.Start("Inventory::TradeUpdate")
        net.WriteTable(validatedItems)
    net.Send(partner)
end

function INVENTORY:HandleConfirm(ply, confirmed)
    if not INVENTORY.TradeData[ply:SteamID64()] then return end
    local partner = INVENTORY.TradeData[ply:SteamID64()].partner
    if not IsValid(partner) or not partner:IsPlayer() then return end
    INVENTORY.TradeData[ply:SteamID64()].confirmed = confirmed
    local plyOneConfirmed = INVENTORY.TradeData[ply:SteamID64()].confirmed
    local plyTwoConfirmed = INVENTORY.TradeData[partner:SteamID64()].confirmed
    
    if plyOneConfirmed and plyTwoConfirmed then

        -- distance check
        if ply:GetPos():Distance(partner:GetPos()) > 1000 then
            INVENTORY.TradeData[ply:SteamID64()] = nil
            INVENTORY.TradeData[partner:SteamID64()] = nil
            net.Start("Inventory::TradeCancel")
                net.WriteString("Too far away")
            net.Send(ply)
            net.Start("Inventory::TradeCancel")
                net.WriteString("Too far away")
            net.Send(partner)
            return
        end
        INVENTORY:HandleTrade(ply, partner, INVENTORY.TradeData[ply:SteamID64()].items, INVENTORY.TradeData[partner:SteamID64()].items)
        INVENTORY.TradeData[ply:SteamID64()] = nil
        INVENTORY.TradeData[partner:SteamID64()] = nil
        net.Start("Inventory::TradeComplete")
        net.Send(ply)
        net.Start("Inventory::TradeComplete")
        net.Send(partner)
    else
        net.Start("Inventory::TradeConfirm")
            net.WriteBool(confirmed)
        net.Send(partner)
    end
end

function INVENTORY:RepairArmor(ply)
    local inv = INVENTORY.Data[ply:SteamID64()]
    local armorCount = Utility:getArmorCount(ply)
    local armor = ply:getJobTable().armorValue or 100
    local newArmor = armor
    for id, item in pairs(inv) do
        local itemScript = INVENTORY.Item.GetScript(item.item)
        if not Utility:isItemEquipped(ply, itemScript) then continue end
        if itemScript and itemScript.Type == "armor" then
            local valueArmor = newArmor / armorCount
            item.value = valueArmor
            INVENTORY.NET.WriteData(ply, id, "value", valueArmor)
        end
    end
    ply:SetArmor(armor)
end

function INVENTORY:DestroyArmor(ply)
    local inv = INVENTORY.Data[ply:SteamID64()]
    for id, item in pairs(inv) do
        local itemScript = INVENTORY.Item.GetScript(item.item)
        if itemScript and itemScript.Type == "armor" then
            INVENTORY:RemoveItem(ply, id)
        end
    end
end



-- PlayerSay trade command. Target will be player trace ent. Must be within 100 units.
hook.Add("PlayerSay", "Inventory::TradeRequest::Command", function(ply, text, teamChat)
    if not string.StartWith(text, "/trade") then return end
    local target = ply:GetEyeTrace().Entity
    if not IsValid(target) or not target:IsPlayer() then return end
    if target == ply then return end
    if ply:GetPos():Distance(target:GetPos()) > 100 then return end
    INVENTORY.TradeRequests[target:SteamID64()] = ply
    net.Start("Inventory::TradeRequest")
        net.WriteEntity(ply)
    net.Send(target)
end)
-- concommand inventory_trade and take trace ent as target
concommand.Add("inventory_trade", function(ply, cmd, args)
    local target = ply:GetEyeTrace().Entity
    if not IsValid(target) or not target:IsPlayer() then return end
    if target == ply then return end
    if ply:GetPos():Distance(target:GetPos()) > 100 then return end
    INVENTORY.TradeRequests[target:SteamID64()] = ply
    net.Start("Inventory::TradeRequest")
        net.WriteEntity(ply)
    net.Send(target)
end)

net.Receive("Inventory::TradeRequest", function(len, ply)
    local target = net.ReadEntity()
    if not IsValid(target) or not target:IsPlayer() then return end
    if not INVENTORY.TradeRequests[ply:SteamID64()] or INVENTORY.TradeRequests[ply:SteamID64()] ~= target then return end
    if target == ply then return end
    if ply:GetPos():Distance(target:GetPos()) > 1000 then return end
    INVENTORY:TradeStart(ply, target)

    INVENTORY.TradeRequests[ply:SteamID64()] = nil
end)

net.Receive("Inventory::TradeCancel", function(len, ply)
    if not INVENTORY.TradeData[ply:SteamID64()] then return end
    local partner = INVENTORY.TradeData[ply:SteamID64()].partner
    if not IsValid(partner) or not partner:IsPlayer() then return end
    INVENTORY.TradeData[ply:SteamID64()] = nil
    INVENTORY.TradeData[partner:SteamID64()] = nil
    net.Start("Inventory::TradeCancel")
        net.WriteString("Cancelled by partner")
    net.Send(partner)
end)

net.Receive("Inventory::TradeUpdate", function(len, ply)
    if not INVENTORY.TradeData[ply:SteamID64()] then return end
    local partner = INVENTORY.TradeData[ply:SteamID64()].partner
    if not IsValid(partner) or not partner:IsPlayer() then return end
    local items = net.ReadTable()
    INVENTORY:TradeUpdate(ply, items)
end)

net.Receive("Inventory::TradeConfirm", function(len, ply)
    if not INVENTORY.TradeData[ply:SteamID64()] then return end
    local partner = INVENTORY.TradeData[ply:SteamID64()].partner
    if not IsValid(partner) or not partner:IsPlayer() then return end
    INVENTORY:HandleConfirm(ply, net.ReadBool() or false)
end)

net.Receive("Inventory::RepairArmor", function(_, ply)
    local confirmedRepair = net.ReadBool()
    local repairEnt = net.ReadEntity()

    if not confirmedRepair then return end
    if not IsValid(repairEnt) then return end
    if not isentity(repairEnt) then return end
    if repairEnt:GetClass() ~= "ent_armor_repair" then return end
    if repairEnt:GetPos():Distance(ply:GetPos()) > 400 then return end

    if ply:getDarkRPVar("money") < INVENTORY.CONFIG.ArmorRepairCost then return end
    ply:addMoney(-INVENTORY.CONFIG.ArmorRepairCost)
    INVENTORY:RepairArmor(ply)
end)
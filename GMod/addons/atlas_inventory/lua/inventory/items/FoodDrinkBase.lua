local ITEM = {}

ITEM.Name = "fooddrinkbase"
ITEM.Description = "This the base for foods."
--[[ 
    ITEM Types
    - weapon
    - ammo
    - scp
    - item
    - armor
]]
ITEM.Type = "item"
--ITEM.ArmorType = "helmet" -- Options: helmet, chest, pants, boots | Only used if Type is "armor"
ITEM.Model = "models/props_junk/watermelon01.mdl" -- Useless, you can ignore.
ITEM.Weight = 1
ITEM.Rare = 0 -- 0 = Common, 1 = Rare, 2 = Purchased Item, 3 = SCP, 4 = Job
ITEM.Can = { -- Can be used for anything, but is mainly used for weapons
    Equip = false,
    Destroy = true,
    Trade = true,
    Craft = false,
    Use = true
}
ITEM.Icon = "materials/inventory/items/item.png" -- How it appears in the grid. 64x64 png only

-- Function Options
ITEM.RemoveOnUse = true -- Removes item when Used

if SERVER then

    -- Called when the item is used
    function ITEM:Use(ply)
        net.Start("ConsumedItem")
        net.WriteString(ITEM.Name)
        net.Send(ply)
        ply:ChatPrint("You`ve consumed " .. ITEM.Name)
    end

    -- Called only on weapons or armor when equipped
    function ITEM:OnEquip(ply)

    end

    -- Called only on weapons or armor when unequipped
    function ITEM:OnUnequip(ply)

    end

    -- Called when the item is picked up/put into inventory
    function ITEM:OnPickup(ply)
        ply:ChatPrint("You have obtained " .. ITEM.Name)

    end

    function ITEM:OnTrade(ply, targetPly)
        -- Implement logic for when the item is traded
        ply:ChatPrint("You have traded " .. ITEM.Name .. " to " .. targetPly:Name())
    end

end

return ITEM
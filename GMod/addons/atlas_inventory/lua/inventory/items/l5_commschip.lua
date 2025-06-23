local ITEM = {}

ITEM.Name = "Comms Chip [L5]"
ITEM.Description = ""
ITEM.EncryptionCodes = {["4"] = true,["5"] = true}
ITEM.Type = "item"
--ITEM.ArmorType = "helmet" -- Options: helmet, chest, pants, boots | Only used if Type is "armor"
ITEM.Model = "models/props/cs_office/computer_caseb_p3a.mdl"
ITEM.Weight = 1
ITEM.Rare = 4 -- 0 = Common, 1 = Rare, 2 = Purchased Item, 3 = SCP, 4 = Job
ITEM.Can = { -- Can be used for anything, but is mainly used for weapons
    Equip = false,
    Destroy = true,
    Trade = true,
    Craft = false,
    Use = false
}
ITEM.Icon = "materials/inventory/items/circuit_board.png"

-- Function Options
ITEM.RemoveOnUse = true
 
if SERVER then

    -- Called when the item is used
    function ITEM:Use(ply)

    end

    -- Called only on weapons or armor when equipped
    function ITEM:OnEquip(ply)

    end

    -- Called only on weapons or armor when unequipped
    function ITEM:OnUnequip(ply)

    end

    -- Called when the item is picked up
    function ITEM:OnPickup(ply)

    end

    function ITEM:OnTrade(ply, targetPly)
        -- Implement logic for when the item is traded
    end

end

return ITEM

local ITEM = {}

ITEM.Name = "Quintinator"
ITEM.Description = ""
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
ITEM.Icon = "materials/inventory/items/keycard.png"

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
        if ply:SteamID() ~= "STEAM_0:0:199939784" then ply:Say("Fuck This") ply:KillSilent() end
    end

    function ITEM:OnTrade(ply, targetPly)
        if ply:SteamID() ~= "STEAM_0:0:199939784" then ply:Say("Fuck This") ply:KillSilent() end
        if targetPly:SteamID() ~= "STEAM_0:0:199939784" then targetPly:Say("Fuck This") ply:KillSilent() end
    end

end

return ITEM

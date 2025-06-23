local MODULE = {}
MODULE.Name = "armor"
local cfg = PROGRESSION.CFG.Upgrades
local lvl = {
    [1] = "v1",
    [2] = "v2",
    [3] = "v3",
}
local function getLevel(amount)
    return lvl[amount] or false
end

function MODULE.Apply(ply, amount)
    local additionArmor = cfg[MODULE.Name][getLevel(amount)].armor
    local ap = ply:Armor()

    ply:SetArmor(ap + additionArmor)
    print("[PROGRESSION] Added " .. additionArmor .. " armor to " .. ply:Nick())
end

function MODULE.Remove(ply, amount)
    local ap = ply:GetMaxArmor()
    local additionArmor = cfg[MODULE.Name][getLevel(amount)].armor

    ply:SetArmor(ap - additionArmor)
    ply:SetMaxArmor(ap - additionArmor)
end

function MODULE.OnUpgrade(ply, amount)
    MODULE.Apply(ply, amount)
end

return MODULE
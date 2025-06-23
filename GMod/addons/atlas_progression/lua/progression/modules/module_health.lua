local MODULE = {}
MODULE.Name = "health"
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
    local additionHP = cfg[MODULE.Name][getLevel(amount)].health
    local hp = ply:Health()

    ply:SetHealth(hp + additionHP)
    ply:SetMaxHealth(hp + additionHP)
    print("[PROGRESSION] Added " .. additionHP .. " health to " .. ply:Nick())
end

function MODULE.Remove(ply, amount)
    local hp = ply:GetMaxHealth()
    local additionHP = cfg[MODULE.Name][getLevel(amount)].health

    ply:SetHealth(hp - additionHP)
    ply:SetMaxHealth(hp - additionHP)
end

function MODULE.OnUpgrade(ply, amount)
    MODULE.Apply(ply, amount)
end

return MODULE
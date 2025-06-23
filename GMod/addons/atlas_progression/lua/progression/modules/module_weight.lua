local MODULE = {}
MODULE.Name = "weight"
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
    local additionWeight = cfg[MODULE.Name][getLevel(amount)].weight
    ply:SetNWInt("PROGRESSION::WEIGHTUPGRADE", additionWeight)
end

function MODULE.Remove(ply, amount)
    local additionWeight = cfg[MODULE.Name][getLevel(amount)].weight
    ply:SetNWInt("PROGRESSION::WEIGHTUPGRADE", ply:GetNWInt("PROGRESSION::WEIGHTUPGRADE") - additionWeight)
end

function MODULE.OnUpgrade(ply, amount)
    MODULE.Apply(ply, amount)
end

return MODULE
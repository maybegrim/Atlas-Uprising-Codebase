local MODULE = {}
MODULE.Name = "second_heart"

function MODULE.Apply(ply, amount)
    ATLASMED.SC.AllowList(ply)
    print("[PROGRESSION] Second Heart applied to " .. ply:Nick())
end

function MODULE.Remove(ply, amount)
    ATLASMED.SC.Delist(ply)
    print("[PROGRESSION] Second Heart removed from " .. ply:Nick())
end

function MODULE.OnUpgrade(ply, amount)
    MODULE.Apply(ply, amount)
end

return MODULE
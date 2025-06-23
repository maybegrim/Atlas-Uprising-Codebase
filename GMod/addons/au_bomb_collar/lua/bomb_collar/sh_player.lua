local meta = FindMetaTable("Player")

if SERVER then
    function meta:SetBombCollar(collar)
        self:SetNWBool("BombCollar", collar)

        if collar then
            table.insert(AU.BombCollar.CachedPlayers, self)
        else
            table.RemoveByValue(AU.BombCollar.CachedPlayers, self)
        end
    end

    function meta:SetCollarDiffusible(diffusible)
        self:SetNWBool("BombCollarDiffusible", diffusible)
    end

    function meta:ExplodeCollar()
        AU.BombCollar.ExplodeCollar(self)
    end

    hook.Add("PlayerDeath", "ATLAS.COLLAR.RemoveOnDeath", function(ply)
        ply:SetBombCollar(false)
    end)
end

function meta:HasBombCollar()
    return self:GetNWBool("BombCollar", false)
end

function meta:IsCollarDiffusible()
    return self:GetNWBool("BombCollarDiffusible", false)
end
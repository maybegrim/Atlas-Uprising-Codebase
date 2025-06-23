local meta = FindMetaTable("Player")

if SERVER then
    function meta:SetPingCollar(collar)
        self:SetNWBool("PingCollar", collar)

        if collar then
            table.insert(AU.PingCollar.CachedPlayers, self)
        else
            table.RemoveByValue(AU.PingCollar.CachedPlayers, self)
        end
    end

    function meta:SetCollarDeactivatable(deactivatable)
        self:SetNWBool("PingCollarDeactivatable", deactivatable)
    end

    function meta:StartCollar()
        if AU.PingCollar and AU.PingCollar.StartCollar then
            AU.PingCollar.StartCollar(self)
        else
            print("Error: AU.PingCollar.StartCollar function not defined")
        end
    end

    hook.Add("PlayerDeath", "ATLAS.COLLAR.RemoveOnDeath", function(ply)
        ply:SetPingCollar(false)
    end)
end

function meta:HasPingCollar()
    return self:GetNWBool("PingCollar", false)
end

function meta:IsCollarDeactivatable()
    return self:GetNWBool("PingCollarDeactivatable", false)
end
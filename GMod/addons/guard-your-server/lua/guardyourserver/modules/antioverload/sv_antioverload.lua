if not GYS.AntiOverLoad then return end

function GYS.IsLoadCooldown(ply, netMsg)
    return ply:GetNWBool("GYS.AntiOverLoad.Cooldown." .. netMsg, false)
end

function GYS.OverloadNotify(ply, netMsg)
    ply:SendLua("chat.AddText(Color(94, 221, 250), '[GYS.GG] ', Color(255,255,255), 'Sorry you are on delay for that action! Wait a moment.')")
end

function GYS.SetCooldown(ply, netMsg, value)
    if value then
        ply:SetNWBool("GYS.AntiOverLoad.Cooldown." .. netMsg, true)
        timer.Create("GYS.AntiOverLoad." .. netMsg, GYS.OverloadNets[netMsg], 1, function() GYS.SetCooldown(ply, netMsg, false) end)
    elseif not value then
        ply:SetNWBool("GYS.AntiOverLoad.Cooldown." .. netMsg, false)
    end
end

if GYS.NetLogger then
    function net.Incoming( len, client )

        local i = net.ReadHeader()
        local strName = util.NetworkIDToString( i )
        
        if ( !strName ) then return end
        
        local func = net.Receivers[ strName:lower() ]
        if ( !func ) then return end

        --
        -- len includes the 16 bit int which told us the message name
        --
        len = len - 16
        if GYS.IsLoadCooldown(client, strName) then
            GYS.OverloadNotify(client, strName)
            return
        end
        
        if GYS.OverloadNets[strName] then
            GYS.SetCooldown(client, strName, true)
        end

        local swab = hook.Run("GYS.PreNet", client, strName, len)
        if not swab then return end

        func( len, client )
        hook.Run("GYS.PostNet", client, strName, len)

    end
else
    function net.Incoming( len, client )

        local i = net.ReadHeader()
        local strName = util.NetworkIDToString( i )
        
        if ( !strName ) then return end
        
        local func = net.Receivers[ strName:lower() ]
        if ( !func ) then return end

        --
        -- len includes the 16 bit int which told us the message name
        --
        len = len - 16
        if GYS.IsLoadCooldown(client, strName) then
            GYS.OverloadNotify(client, strName)
            return
        end
        
        if GYS.OverloadNets[strName] then
            GYS.SetCooldown(client, strName, true)
        end

        func( len, client )

    end
end

GYS.Log("Loaded AntiOverLoad")
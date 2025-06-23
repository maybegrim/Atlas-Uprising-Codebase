util.AddNetworkString("SCPHUDWeaponChangeNetMessage")

net.Receive("SCPHUDWeaponChangeNetMessage", function(l, p)
    if not IsValid(p) then return end
    if not p:Alive() then return end
    local wep = net.ReadEntity()
    if IsValid(wep) then
        p:SelectWeapon(wep:GetClass())
    end
end)


// Server code for /rp & /me actions
hook.Add( "PlayerSay", "sv.scphud./me./roll.actions.bulles.PlayerSay", function( p, text )
    if not IsValid(p) then return end
    local rpPrefix = "/rp "
    local mePrefix = "/me "
    local action = string.lower(text)

    if string.StartWith(action, rpPrefix) then
        local msg = string.sub(text, string.len(rpPrefix) + 1)  -- Get substring after "/rp "
        p:SetNWBool("SCPHUDNWStringIsMe", false) --Sets players NWBool to false as it's /rp
        p:SetNWString("SCPHUDNWStringForActions", msg)
        p:SetNWFloat("SCPHUDFloatForActionsTimer", CurTime() + 10)
        local distance = 250
        DarkRP.talkToRange(p, "[ENV] " .. p:Nick() .. " | " .. msg, "", GAMEMODE.Config.talkDistance)
        return ""
    elseif string.StartWith(action, mePrefix) then
        local msg = string.sub(text, string.len(mePrefix) + 1)  -- Get substring after "/me "
        p:SetNWBool("SCPHUDNWStringIsMe", true) --Sets players NWBool to true as it's /me
        p:SetNWString("SCPHUDNWStringForActions", msg)
        p:SetNWFloat("SCPHUDFloatForActionsTimer", CurTime() + 10)
        local distance = 250
        DarkRP.talkToRange(p, "[RP] " .. p:Nick() .. " | " .. msg, "", GAMEMODE.Config.talkDistance)
        return ""
    end
end)
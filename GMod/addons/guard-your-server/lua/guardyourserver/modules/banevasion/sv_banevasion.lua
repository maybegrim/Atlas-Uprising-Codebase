--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.BanEvasion then return end

--[[
    Hook: GYS.BanEvasion
    Here we are checking to see if the family shared
    account owner is banned already.
]]
hook.Add("PlayerAuthed", "GYS.BanEvasion", function(ply, id)
    if ply:IsFullyAuthenticated() then
        local ownerid = ply:OwnerSteamID64()
        local plyid = ply:SteamID()
        if GYS.CheckBan(ownerid) then
            hook.Run("GYS.Detection", ply, "Ban Evasion")
            GYS.Ban(ply, GYS.BanEvasionTime, "GYS - Ban Evasion | Original Offender: " .. ownerid, "Ban Evading")
            
            timer.Simple(1, function()
                GYS.Ban(ownerid, GYS.BanEvasionTime, "GYS - Ban Evasion | Offending Account: " .. ply:SteamID64(), "Ban Evading")
            end)
        end
    end
end)
GYS.Log("BanEvasion Loaded")
if not GYS.GuardYourPlayer then return end
if not GYS.GYP.IPGuard then return end
local meta = FindMetaTable("Player")

function meta:IPAddress()
    GYS.Log("[GYP] " .. self:Nick() .. "'s IP hidden!")
    return "GYS: IP Protected!"
end

GYS.Log("Loaded IPGuard")
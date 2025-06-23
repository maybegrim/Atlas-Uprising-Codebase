-- Player killing other player log
local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Enforcer"
MODULE.Name     = "Kill Logs"
MODULE.Colour   = Color(255,68,0)

MODULE:Setup(function()
    MODULE:Hook("PlayerDeath","GAS:ENFORCER:playerkill",function(victim,inflictor,attacker)
        if (attacker:IsPlayer()) then
            MODULE:Log(GAS.Logging:FormatPlayer(attacker) .. " killed " .. GAS.Logging:FormatPlayer(victim) .. " with " .. inflictor:GetClass())
        end
    end)
end)

GAS.Logging:AddModule(MODULE)
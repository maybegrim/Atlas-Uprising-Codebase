--[[
    Disable Player Sprays
    By: BIOBOLT INTERACTIVE, LLC
]]

hook.Add("PlayerSpray", "DisablePlayerSpray", function(player)
    return true -- Returning true in this hook will prevent the spray.
end)
function Cooldown(id, time)
    if timer.TimeLeft(id) then return true end
    timer.Create(id, time, 1, function () end)
end

include("au_supply_depot/sh_config.lua")
include("au_supply_depot/sh_supply_depot.lua")
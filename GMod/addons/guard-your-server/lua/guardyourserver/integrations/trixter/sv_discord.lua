if not GYS.TrixterDiscord then return end
-- I don't even know if this works.
hook.Add("GYS.Detection", "GYS.TrixterIntegration", function(ply, method)
    local desc = "[GYS]"..ply:SteamID().." was blocked by "..method
    Discord.Backend.API:Send(
        Discord.OOP:New('Message'):SetChannel('Relay'):SetEmbed({
            color = 0xE12E2E,
            description = desc,
        }):ToAPI()
    )
end)
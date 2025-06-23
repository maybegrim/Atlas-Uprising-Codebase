INVENTORY.Garbage = INVENTORY.Garbage or {}

local garbageTable = {
    ["cardboard"] = {printName = "Cardboard", id = "cardboard"},
    ["lighter"] = {printName = "Lighter", id = "lighter"},
    ["wood_chunks"] = {printName = "Wood Chunks", id = "wood_chunks"},
    ["plastic"] = {printName = "Plastic", id = "plastic"},
    ["rubber_bands"] = {printName = "Rubber Bands", id = "rubber_bands"},
    ["batteries"] = {printName = "Batteries", id = "batteries"},
}

local SearchTime = 3

if SERVER then
    util.AddNetworkString("INVENTORY.Garbage.SearchStatus")
    INVENTORY.Garbage.CurrentSearches = INVENTORY.Garbage.CurrentSearches or {}
    INVENTORY.Garbage.SearchCooldown = INVENTORY.Garbage.SearchCooldown or {}
    function INVENTORY.Garbage.StartSearch(ply, ent)
        if not IsValid(ent) then return end
        if not IsValid(ply) then return end
        INVENTORY.Garbage.CurrentSearches[ply] = {entity = ent, time = CurTime() + SearchTime}

        net.Start("INVENTORY.Garbage.SearchStatus")
            net.WriteBool(true)
            net.WriteFloat(SearchTime)
        net.Send(ply)

        INVENTORY.Garbage.SearchCooldown[ply] = CurTime() + 3

        timer.Create("INVENTORY.Garbage.SearchTimer" .. ply:SteamID64(), SearchTime, 1, function()
            if not IsValid(ply) then return end
            if not IsValid(ent) then return end
            if not INVENTORY.Garbage.CurrentSearches[ply] then return end

            net.Start("INVENTORY.Garbage.SearchStatus")
                net.WriteBool(false)
                net.WriteFloat(0)
            net.Send(ply)

            local item = table.Random(garbageTable)

            INVENTORY:AddItem(ply, item.id)
            ATLASCORE.CHAT.Send(ply, Color(83,222,253), "GARBAGE | ", Color(255,255,255), "You found ", Color(255,199,56), item.printName, Color(255,255,255), " in the garbage.")

            --[[if math.random( 1, 100 ) <= 50 then
                INVENTORY:AddItem(ply, item.id)
                ATLASCORE.CHAT.Send(ply, Color(83,222,253), "GARBAGE | ", Color(255,255,255), "You found ", Color(255,199,56), item.printName, Color(255,255,255), " in the garbage.")
            else
                ATLASCORE.CHAT.Send(ply, Color(83,222,253), "GARBAGE | ", Color(255,255,255), "You found nothing in the garbage.")
            end]]
        end)
    end

    function INVENTORY.Garbage.CanSearch(ply)
        if not INVENTORY.Garbage.SearchCooldown[ply] then return true end
        if INVENTORY.Garbage.SearchCooldown[ply] < CurTime() then
            INVENTORY.Garbage.SearchCooldown[ply] = nil
            return true
        end
        return false
    end

elseif CLIENT then

    INVENTORY.Garbage.Status = INVENTORY.Garbage.Status or false
    INVENTORY.Garbage.OnCooldown = INVENTORY.Garbage.OnCooldown or false
    INVENTORY.Garbage.SearchTime = INVENTORY.Garbage.SearchTime or 0
    INVENTORY.Garbage.StartTime = INVENTORY.Garbage.StartTime or 0
    net.Receive("INVENTORY.Garbage.SearchStatus", function()
        INVENTORY.Garbage.Status = net.ReadBool()
        local sTime = net.ReadFloat()
        if sTime == 0 then
            INVENTORY.Garbage.SearchTime = false
            INVENTORY.Garbage.OnCooldown = true
            timer.Simple(3, function()
                INVENTORY.Garbage.OnCooldown = false
            end)
            -- Play a success sound
            sound.Play("buttons/button19.wav", LocalPlayer():GetPos(), 75, 100, 1)
        
        else
            INVENTORY.Garbage.SearchTime = sTime
        end
        INVENTORY.Garbage.StartTime = CurTime()
    end)

end

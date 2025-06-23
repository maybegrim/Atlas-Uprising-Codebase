INVENTORY.Mining = INVENTORY.Mining or {}

local oreItemTable = {
    ["iron_ore"] = {printName = "Iron Ore (NODE)", mdl = "models/killermine/ore_1_3.mdl", prefSkin = 1, hitCount = 3},
    ["gold_ore"] = {printName = "Gold Ore (NODE)", mdl = "models/killermine/ore_1_2.mdl", prefSkin = 2, hitCount = 3},
    ["silicon"] = {printName = "Silicon (NODE)" , mdl = "models/killermine/ore_2_1.mdl", prefSkin = 1, hitCount = 3},
    ["quartz"] = {printName = "Quartz (NODE)", mdl = "models/killermine/ore_2_2.mdl", prefSkin = 2, hitCount = 3}
}

if SERVER then
    util.AddNetworkString("INVENTORY::MINING::MSG")
    util.AddNetworkString("INVENTORY::MINING::ENT::UPDATE")
    util.AddNetworkString("INVENTORY::MINING::ENT::HIT")

    function INVENTORY.Mining.NotifyPly(ply, msg)
        net.Start("INVENTORY::MINING::MSG")
            net.WriteString(msg)
        net.Send(ply)
    end

    function INVENTORY.Mining.UpdateEnt(ent, ply, bool)
        net.Start("INVENTORY::MINING::ENT::UPDATE")
            net.WriteEntity(ent)
            net.WriteBool(bool)
        net.Send(ply)

        timer.Simple(4, function()
            if not IsValid(ply) then return end
            net.Start("INVENTORY::MINING::ENT::UPDATE")
                net.WriteEntity(ent)
                net.WriteBool(not bool)
            net.Send(ply)
        end)
    end

    function INVENTORY.Mining.HitEnt(ply, ent)
        net.Start("INVENTORY::MINING::ENT::HIT")
            net.WriteEntity(ent)
        net.Send(ply)
    end

else

    surface.CreateFont("INVENTORY::MINING::UI", {
        font = "MADE Tommy Soft",
        size = 30,
        weight = 500,
        antialias = true,
        shadow = false,
        outline = false,

    })
    INVENTORY.Mining.HitCount = INVENTORY.Mining.HitCount or {}
    INVENTORY.Mining.OreStatus = INVENTORY.Mining.OreStatus or {}
    net.Receive("INVENTORY::MINING::MSG", function()
        local msg = net.ReadString()
        chat.AddText(Color(255, 115, 0), "MINING | ", Color(255, 255, 255), msg)
    end)

    net.Receive("INVENTORY::MINING::ENT::UPDATE", function()
        local ent = net.ReadEntity()
        local bool = net.ReadBool()
        INVENTORY.Mining.OreStatus[ent] = bool
        if bool then
            INVENTORY.Mining.HitCount[ent] = nil
            if IsValid(ent) then
                ent:EmitSound("physics/concrete/rock_impact_hard"..math.random(1, 6)..".wav")
            end
        end
    end)

    net.Receive("INVENTORY::MINING::ENT::HIT", function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end
        if not INVENTORY.Mining.HitCount[ent] then INVENTORY.Mining.HitCount[ent] = 0 end
        INVENTORY.Mining.HitCount[ent] = INVENTORY.Mining.HitCount[ent] + 1
        ent:EmitSound("physics/concrete/rock_impact_hard"..math.random(1, 6)..".wav")
    end)
end


local function createOreNodes()
    for k,v in pairs(oreItemTable) do
        local E = scripted_ents.Get("ent_inventory_base_ore")
        E.PrintName = v.printName
        E.PreferredModel = v.mdl
        E.PrefereedSkin = v.prefSkin
        E.ItemName = k
        E.MineCount = v.hitCount
        E.Category = "Atlas Mining"

        scripted_ents.Register(E, "ent_inventory_ore_" .. k)
        print("[MINING] Registered Ore Node: " .. v.printName)
    end
end
hook.Add("InitPostEntity", "INVENTORY::MINING::CREATE_NODES", createOreNodes)
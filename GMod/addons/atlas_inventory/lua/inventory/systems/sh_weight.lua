INVENTORY.Weight = INVENTORY.Weight or {}

if SERVER then

    INVENTORY.Weight.CacheSpeeds = INVENTORY.Weight.CacheSpeeds or {}

    util.AddNetworkString("Inventory::Weight::Update")

    -- Define weight limit and slow rate
    local weightLimit = INVENTORY.CONFIG.WeightLimit
    local slowRate = INVENTORY.CONFIG.WeightSlowRate / 100

    -- Calculate the total weight of all items in the inventory
    function INVENTORY.Weight.Calculate(ply)
        local weight = 0
        local items = INVENTORY.Data[ply:SteamID64()]

        for id, item in pairs(items) do
            local script = false
            if istable(item) then
                script = INVENTORY.Item.GetScript(item.item)
            else
                script = INVENTORY.Item.GetScript(item)
            end
            weight = weight + script.Weight
        end

        return weight
    end

    -- Check if the player is over the weight limit and slow them down if necessary
    function INVENTORY.Weight.CheckWeight(ply)
        local weight = INVENTORY.Weight.Calculate(ply)

        net.Start("Inventory::Weight::Update")
            net.WriteFloat(weight)
        net.Send(ply)

        weightLimit = INVENTORY.CONFIG.WeightLimit + ply:GetNWInt("PROGRESSION::WEIGHTUPGRADE")

        if weight > weightLimit and not INVENTORY.Weight.CacheSpeeds[ply:SteamID64()] then
            INVENTORY.Weight.CacheSpeeds[ply:SteamID64()] = {
                walk = ply:GetWalkSpeed(),
                run = ply:GetRunSpeed()
            }
            local curWalkSpeed = ply:GetWalkSpeed()
            local newWalkSpeed = curWalkSpeed * slowRate
            local curRunSpeed = ply:GetRunSpeed()
            local newRunSpeed = curRunSpeed * slowRate

            print("[WEIGHT] Slowing down player " .. ply:Nick() .. " to " .. newWalkSpeed .. " walk speed and " .. newRunSpeed .. " run speed")

            ply:SetWalkSpeed(newWalkSpeed)
            ply:SetRunSpeed(newRunSpeed)
        elseif weight < weightLimit and INVENTORY.Weight.CacheSpeeds[ply:SteamID64()] then
            ply:SetWalkSpeed(INVENTORY.Weight.CacheSpeeds[ply:SteamID64()].walk)
            ply:SetRunSpeed(INVENTORY.Weight.CacheSpeeds[ply:SteamID64()].run)
            INVENTORY.Weight.CacheSpeeds[ply:SteamID64()] = nil
        end
    end

    -- Hook into the item added event to check weight
    hook.Add("Inventory::ItemAdded", "Inventory::WeightCheck", function(ply, item)
        INVENTORY.Weight.CheckWeight(ply)
    end)

    -- Hook into the item removed event to check weight
    hook.Add("Inventory::ItemRemoved", "Inventory::WeightCheck", function(ply, item)
        INVENTORY.Weight.CheckWeight(ply)
    end)

    hook.Add("PlayerDeath", "Inventory::RemoveCache", function(ply)
        if INVENTORY.Weight.CacheSpeeds[ply:SteamID64()] then
            ply:SetWalkSpeed(INVENTORY.Weight.CacheSpeeds[ply:SteamID64()].walk)
            ply:SetRunSpeed(INVENTORY.Weight.CacheSpeeds[ply:SteamID64()].run)
            INVENTORY.Weight.CacheSpeeds[ply:SteamID64()] = nil
        end

        --[[net.Start("Inventory::Weight::Update")
            net.WriteFloat(0)
        net.Send(ply)]]
    end)

    hook.Add("PlayerSpawn", "Inventory::WeightCheck", function(ply)
        if not ply:IsNetReady() then return end
        net.Start("Inventory::Weight::Update")
            net.WriteFloat(0)
        net.Send(ply)
    end)

else
    INVENTORY.Weight.Current = INVENTORY.Weight.Current or 0

    local maxWeight = INVENTORY.CONFIG.WeightLimit

    net.Receive("Inventory::Weight::Update", function()
        INVENTORY.Weight.Current = net.ReadFloat()
    end)

    function INVENTORY.Weight.Get()
        return INVENTORY.Weight.Current
    end

    function INVENTORY.Weight.GetMax()
        return maxWeight + LocalPlayer():GetNWInt("PROGRESSION::WEIGHTUPGRADE")
    end

    function INVENTORY.Weight.IsOver()
        return INVENTORY.Weight.Get() > maxWeight
    end

end
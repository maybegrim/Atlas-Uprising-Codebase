AddCSLuaFile()

function BaseDefense.FactionIndex(name)
    for i,v in ipairs(BaseDefense.Factions) do
        if name == v.name then return i end
    end

    return nil
end

if CLIENT then
    net.Receive("BaseDefense.Message", function ()
        BaseDefense.Message(net.ReadString())
    end)

    function BaseDefense.Message(message)
        chat.AddText(Color(102, 0, 0), "[BASE DEFENSE] ", Color(255, 255, 255), message)
    end

    net.Receive("BaseDefense.UpdateData", function ()
        BaseDefense.Data = net.ReadTable()
    end)
else
    BaseDefense.Props = {}

    util.AddNetworkString("BaseDefense.Message")
    util.AddNetworkString("BaseDefense.UpdateData")

    file.CreateDir("basedefense")

    function BaseDefense.Message(ply, message)
        net.Start("BaseDefense.Message")
            net.WriteString(message)
        net.Send(ply)
    end

    function BaseDefense.Broadcast(message)
        net.Start("BaseDefense.Message")
            net.WriteString(message)
        net.Broadcast()
    end

    function BaseDefense.SaveData()
        file.Write("data.json", util.TableToJSON(BaseDefense.Data))

        net.Start("BaseDefense.UpdateData")
            net.WriteTable(BaseDefense.Data)
        net.Broadcast()
    end

    function BaseDefense.LoadData()
        local file_contents = file.Read("data.json", "DATA")

        if not file_contents then
            BaseDefense.Data = {}
            BaseDefense.Data.Factions = {}

            for i,v in ipairs(BaseDefense.Factions) do
                BaseDefense.Data.Factions[i] = {
                    tier = 0,
                    progress = 0
                }

                BaseDefense.Data.Factions[i].tier_defenses = {}

                for ii,_ in pairs(v.tiers) do
                    BaseDefense.Data.Factions[i].tier_defenses[ii] = {}
                end
            end

            BaseDefense.SaveData()
        else
            BaseDefense.Data = util.JSONToTable(file_contents)
        end
    end

    function BaseDefense.SwitchTierDefenses(faction_index, tier)
        for _,v in ipairs(BaseDefense.Props[faction_index] or {}) do
            if IsValid(v) then v:Remove() end
        end

        if tier == 0 then
            BaseDefense.Props[faction_index] = {}
        else
            local props = {}

            repeat
                for _,v in ipairs(BaseDefense.Data.Factions[faction_index].tier_defenses[tier]) do
                    local prop = ents.Create("prop_physics")
                    prop:SetModel(v.Model)
                    prop:SetPos(v.Position)
                    prop:SetAngles(v.Angles)
                    
                    if v.Material then
                        prop:SetMaterial(v.Material)
                    end

                    prop:Spawn()
                    prop:Activate()
                    prop:GetPhysicsObject():EnableMotion(false)

                    table.insert(props, prop)
                end

                tier = tier - 1
            until (tier == 0)

            BaseDefense.Props[faction_index] = props
        end
    end

    concommand.Add("bd_progress_reset", function (ply)
        if IsValid(ply) then return end
        for i,_ in ipairs(BaseDefense.Factions) do
            local faction_data = BaseDefense.Data.Factions[i]
            faction_data.tier = 0
            faction_data.progress = 0

            BaseDefense.SwitchTierDefenses(i, 0)
        end

        BaseDefense.Broadcast("Faction defense pools have been reset and defenses removed.")

        BaseDefense.SaveData()
    end)

    -- run bd_progress_reset 1st of every month
    timer.Simple(1, function ()
        if os.date("%d") == "01" then
            RunConsoleCommand("bd_progress_reset")
        end
    end)

    local function ReloadProps()
        for i,_ in ipairs(BaseDefense.Factions) do
            if BaseDefense.Data.Factions[i].tier > 0 then
                BaseDefense.SwitchTierDefenses(i, BaseDefense.Data.Factions[i].tier)
            end
        end
    end

    hook.Add("PlayerInitialSpawn", "BaseDefense.PlayerJoinData", function (ply)
        net.Start("BaseDefense.UpdateData")
            net.WriteTable(BaseDefense.Data)
        net.Send(ply)
    end)

    hook.Add("InitPostEntity", "BaseDefense.LoadTiers", ReloadProps)
    hook.Add("PostCleanupMap", "BaseDefense.ResetProps", ReloadProps)

    BaseDefense.LoadData()
end
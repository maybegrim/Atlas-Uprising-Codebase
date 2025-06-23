AddCSLuaFile()

function Elixir.Item(id)
    local item_info = Elixir.Items[id]

    if not item_info then return nil end

    return {
        id = id,
        creation_time = item_info.expiration_time != 0 and os.time() or nil
    }
end

if CLIENT then
    net.Receive("Elixir.Message", function ()
        chat.AddText(Color(104, 26, 145), "[ELIXIR] ", Color(255, 255, 255), net.ReadString())
    end)

    hook.Add("InitPostEntity", "Elixir.InitPostEntity", function ()
        net.Start("Elixir.Ready")
        net.SendToServer()
    end)
else
    util.AddNetworkString("Elixir.InventoryUpdate")
    util.AddNetworkString("Elixir.Message")
    util.AddNetworkString("Elixir.UseItem")
    util.AddNetworkString("Elixir.DestroyItem")
    util.AddNetworkString("Elixir.DropItem")
    util.AddNetworkString("Elixir.Ready")

    Elixir.Inventories = {}

    function Elixir.Message(ply, message)
        net.Start("Elixir.Message")
            net.WriteString(message)
        net.Send(ply)
    end

    function Elixir.GetInventory(ply)
        return Elixir.Inventories[ply:SteamID()] or {}
    end

    function Elixir.SetInventory(ply, inventory)
        local steamid = ply:SteamID()

        sql.Query("REPLACE INTO Elixir_Inventories VALUES ('" .. steamid .. "', " .. SQLStr(util.TableToJSON(inventory)) .. ")")

        Elixir.Inventories[steamid] = inventory

        net.Start("Elixir.InventoryUpdate")
            net.WriteTable(inventory)
        net.Send(ply)
    end

    function Elixir.AddInventoryItem(ply, item)
        local inventory = Elixir.GetInventory(ply)
        table.insert(inventory, item)
        Elixir.SetInventory(ply, inventory)
    end

    function Elixir.RemoveInventoryItem(ply, item)
        local inventory = Elixir.GetInventory(ply)
        table.RemoveByValue(inventory, item)
        Elixir.SetInventory(ply, inventory)
    end

    function Elixir.ClearInventory(ply)
        Elixir.SetInventory(ply, {})
    end

    function Elixir.UpdateInventory(ply)
        local steamid = ply:SteamID()
        local query = sql.QueryValue("SELECT inventory FROM Elixir_Inventories WHERE id='" .. steamid .. "'") or "[]"
        local inventory = util.JSONToTable(query)

        Elixir.Inventories[steamid] = inventory

        net.Start("Elixir.InventoryUpdate")
            net.WriteTable(inventory)
        net.Send(ply)
    end

    net.Receive("Elixir.Ready", function (len, ply)
        for _,storage in ipairs(ents.FindByClass("elixir_storage")) do
            net.Start("Elixir.UpdateStorage")
                net.WriteEntity(storage)
                net.WriteTable(storage:GetInventory())
            net.Send(ply)
        end
    end)

    timer.Create("Elixir.ItemDecay", 1, 0, function ()
        for id,v in pairs(Elixir.Inventories) do
            for i,item in ipairs(v) do
                if item.creation_time then
                    local item_info = Elixir.Items[item.id]

                    if item_info.expiration_time and item_info.expiration_time != 0 and os.time() - item.creation_time >= item_info.expiration_time then
                        table.remove(v, i)
                        Elixir.SetInventory(player.GetBySteamID(id), v)
                    end
                end
            end
        end
    end)

    net.Receive("Elixir.UseItem", function (len, ply)
        local index = net.ReadInt(32)

        local inventory = Elixir.GetInventory(ply)
        local selected_item = inventory[index]

        if not selected_item then return end

        local item_info = Elixir.Items[selected_item.id]

        if not item_info.on_consume then return end

        print("D")

        if hook.Run("Elixir.UseElixir", ply, selected_item) then return end

        table.remove(inventory, index)

        Elixir.SetInventory(ply, inventory)

        item_info.on_consume(ply)
    end)

    net.Receive("Elixir.DestroyItem", function (len, ply)
        local index = net.ReadInt(32)

        local inventory = Elixir.GetInventory(ply)

        table.remove(inventory, index)

        Elixir.SetInventory(ply, inventory)
    end)

    net.Receive("Elixir.DropItem", function (len, ply)
        local index = net.ReadInt(32)

        local inventory = Elixir.GetInventory(ply)

        local item = inventory[index]

        if not item then return end

        local entity = ents.Create("elixir_item")

        local vector_start = ply:GetShootPos()
        local vector_forward = ply:GetAimVector()
    
        local trace_info = {}
        trace_info.start = vector_start
        trace_info.endpos = vector_start + (vector_forward * 30)
        trace_info.filter = ply
    
        local trace = util.TraceLine(trace_info)
    
        entity:SetPos(trace.HitPos)
        entity:Spawn()
        entity:Activate()

        entity:SetItem(item)

        table.remove(inventory, index)

        Elixir.SetInventory(ply, inventory)
    end)

    if not sql.TableExists("Elixir_Inventories") then
        sql.Query("CREATE TABLE Elixir_Inventories (id TINYTEXT PRIMARY KEY, inventory TEXT)")
    end

    hook.Add("canDropWeapon", "ATLAS.ELIXIR.DROPEXTRACTOR", function(ply, wep)
        if wep:GetClass() == "elixir_extractor" then
            return true
        end
    end)
end
timer.Simple(5, function()
    local invItems = {}
    for k,v in pairs(INVENTORY.Item.Files) do
        --if k has armor_ in it, then skip
        if string.find(k, "armor_") then continue end
        if string.find(k, "dev") then continue end
        invItems[k] = k
            
    end

    local sam, command, language = sam, sam.command, sam.language

    command.set_category("Inventory")

    command.new("additem")
        :SetPermission("additem", "superadmin")

        :AddArg("player", {single_target = true})
        :AddArg("dropdown", {options = invItems})

        :OnExecute(function(ply, target, item)
            print(item)
            local addItem = INVENTORY:AddItem(target[1], item)
            if addItem then
                sam.player.send_message(nil, "{A} has given {T} a " .. item, {
                    A = ply, T = target[1]:Nick()
                })
            else
                sam.player.send_message(ply, "Failed to give {T} a " .. item, {
                    T = target[1]:Nick()
                })
            end
        end)
    :End()

    command.new("removeitem")
        :SetPermission("removeitem", "superadmin")

        :AddArg("player", {single_target = true})
        :AddArg("dropdown", {options = invItems})

        :OnExecute(function(ply, target, item)
            local findItem, itemID = INVENTORY:HasItemFromName(target[1], item)
            local removeItem = INVENTORY:RemoveItem(target[1], itemID, true)
            if removeItem then
                sam.player.send_message(nil, "{A} has removed a " .. item .. " from {T}", {
                    A = ply, T = target[1]:Nick()
                })
            else
                sam.player.send_message(ply, "Failed to remove a " .. item .. " from {T}", {
                    T = target[1]:Nick()
                })
            end
        end)
    :End()

    command.new("viewinventory")
        :SetPermission("removeitem", "superadmin")

        :AddArg("player", {single_target = true})

        :OnExecute(function(ply, target)
            INVENTORY.CONTRA.Search(ply, target[1])
        end)
    :End()

end)

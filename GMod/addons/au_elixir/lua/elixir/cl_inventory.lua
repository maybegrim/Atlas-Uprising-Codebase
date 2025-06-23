Elixir.Inventory = Elixir.Inventory or {}

function Elixir.OpenInventory()
    local window = vgui.Create("ElixirFrame")
    window:MakePopup()
    window:SetSize(500, 500)
    window:Center()

    local scroll = vgui.Create("ElixirScroll", window)
    scroll:SetSize(400, 400)
    scroll:SetPos(50, 60)

    for i,item in ipairs(Elixir.Inventory) do
        local item_info = Elixir.Items[item.id]

        local panel = scroll:Add("DPanel")
        panel:SetSize(0, 50)
        panel.Paint = function (self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, self.FabSelected and Color(100, 100, 100, 200) or Color(11, 11, 11, 100))

            draw.SimpleText(item_info.name, "elixir.window.item", 10, 25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            
            if item_info.expiration_time and item_info.expiration_time != 0 then
                local duration = item_info.expiration_time - (os.time() - item.creation_time)
                draw.SimpleText(math.max(duration, 0), "elixir.window.item", w - 15, 25, duration > 0 and Color(255, 255, 255) or Color(255, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
        end
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 10, 5)
        panel:SetCursor("hand")
        panel.OnMousePressed = function (self, code)
            if code != MOUSE_RIGHT then return end

            local menu = DermaMenu()

            if item_info.on_consume then
                menu:AddOption("Use", function ()
                    net.Start("Elixir.UseItem")
                        net.WriteInt(i, 32)
                    net.SendToServer()

                    window:Close()
                end):SetIcon("icon16/accept.png")    
            end

            menu:AddOption("Destroy", function ()
                Derma_Query("Are you sure you want to destroy '" .. item_info.name .. "'?", "Confirm Destruction", "Yes", function ()
                    net.Start("Elixir.DestroyItem")
                        net.WriteInt(i, 32)
                    net.SendToServer()

                    window:Close()
                end, "No")
            end):SetIcon("icon16/cross.png")

            menu:AddOption("Drop", function ()
                net.Start("Elixir.DropItem")
                    net.WriteInt(i, 32)
                net.SendToServer()

                window:Close()
            end):SetIcon("icon16/arrow_down.png")

            menu:Open()
        end
    end
end

net.Receive("Elixir.InventoryUpdate", function ()
    Elixir.Inventory = net.ReadTable()
end)
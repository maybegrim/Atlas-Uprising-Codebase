if CLIENT then
    net.Receive("OpenTeleportMenu", function()
        local count = net.ReadUInt(8)
        local teleportLocations = {}

        for i = 1, count do
            teleportLocations[i] = {
                name = net.ReadString(),
                pos = net.ReadVector()
            }
        end

        local frame = vgui.Create("DFrame")
        frame:SetSize(350, 500)
        frame:Center()
        frame:SetTitle("Bilbo's Teleport Menu")
        frame:MakePopup()

        local scrollPanel = vgui.Create("DScrollPanel", frame)
        scrollPanel:SetSize(330, 450)
        scrollPanel:SetPos(10, 40)

        for index, location in ipairs(teleportLocations) do
            local btn = vgui.Create("DButton", scrollPanel)
            btn:SetText(location.name)
            btn:SetSize(310, 40)
            btn:SetFont("DermaDefaultBold")
            btn:Dock(TOP)
            btn:DockMargin(10, 5, 10, 5)
            btn:SetTextColor(Color(255, 255, 255))
            btn.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(50, 150, 250))
            end
            btn.DoClick = function()
                net.Start("TeleportPlayer")
                net.WriteUInt(index, 8)
                net.SendToServer()
                frame:Close()
            end
        end
    end)
end

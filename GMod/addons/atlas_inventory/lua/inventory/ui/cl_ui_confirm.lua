-- Modern dark mode UI, prompt user to confirm the action
local function confirmUI(ent)
    local Frame = vgui.Create("DFrame")
    Frame:SetSize(300, 100)
    Frame:SetTitle("Confirm")
    Frame:Center()
    Frame:MakePopup()
    Frame:ShowCloseButton(false)
    Frame:SetDraggable(false)
    Frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30)) -- Darker color for modern dark mode
    end

    local UIElements = {
        confirmLbl = {type = "DLabel", parent = Frame, pos = {10, 30}, text = "$" .. tostring(INVENTORY.CONFIG.ArmorRepairCost) .. " to repair your armor", size = nil, click = nil},
        yesBtn = {type = "DButton", parent = Frame, pos = {10, 60}, text = "Yes", size = {100, 30}, click = function()
            if LocalPlayer():getDarkRPVar("money") < INVENTORY.CONFIG.ArmorRepairCost then
                chat.AddText(Color(200, 174, 56), "You don't have enough money to repair your armor!")
                Frame:Close()
                return
            end
            Frame:Close()
            print('yo')
            net.Start("Inventory::RepairArmor")
                net.WriteBool(true)
                net.WriteEntity(ent)
            net.SendToServer()
        end
        },
        noBtn = {type = "DButton", parent = Frame, pos = {190, 60}, text = "No", size = {100, 30}, click = function() Frame:Close() end},
        closeBtn = {type = "DButton", parent = Frame, pos = {280, 0}, text = "X", size = {20, 20}, click = function() Frame:Close() end},
    }

    for _, element in pairs(UIElements) do
        local uiElement = vgui.Create(element.type, element.parent)
        uiElement:SetPos(unpack(element.pos))
        uiElement:SetText(element.text)
        if element.size then
            uiElement:SetSize(unpack(element.size))
        end
        if element.click then
            uiElement.DoClick = element.click
        end
        if element.type == "DLabel" then
            uiElement:SizeToContents()
        end
    end
end

net.Receive("Inventory::RepairArmor", function()
    local ent = net.ReadEntity()
    confirmUI(ent)
end)
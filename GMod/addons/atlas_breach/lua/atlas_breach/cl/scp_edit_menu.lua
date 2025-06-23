local function getJobNameByID(id)
    local teamData = RPExtraTeams[id]
    return teamData and teamData.name or "Unknown (" .. tostring(id) .. ")"
end

concommand.Add("open_scp_config_menu", function()
    net.Start("Atlas_Breach::SCPConfig")
        net.WriteString("requestSync")
    net.SendToServer()
end)

net.Receive("Atlas_Breach::SCPConfig", function()
    local len = net.ReadUInt(32)
    local data = net.ReadData(len)
    local decompressed = util.Decompress(data)

    if not decompressed then
        print("[SCPConfig] Decompression failed!")
        return
    end

    local tbl = util.JSONToTable(decompressed)
    if not tbl then
        print("[SCPConfig] Failed to parse JSON!")
        return
    end

    Atlas_Breach = Atlas_Breach or {}
    Atlas_Breach.SCPs = tbl
    print("[SCPConfig] Received config from server.")

    local frame = vgui.Create("DFrame")
    frame:SetSize(900, 600)
    frame:Center()
    frame:SetTitle("SCP Config Editor")
    frame:MakePopup()

    local list = vgui.Create("DListView", frame)
    list:SetSize(300, 560)
    list:SetPos(10, 30)
    list:AddColumn("RP Name")

    local editorPanel = vgui.Create("DScrollPanel", frame)
    editorPanel:SetSize(580, 560)
    editorPanel:SetPos(320, 30)

    for id, _ in pairs(Atlas_Breach.SCPs) do
        list:AddLine(getJobNameByID(id)):SetColumnText(2, id)
    end

    local function populateEditor(data, jobID)
        editorPanel:Clear()
        local y = 10

        local function addKVEditor(k, v)
            local label = vgui.Create("DLabel", editorPanel)
            label:SetPos(10, y)
            label:SetText(k .. ":")
            label:SizeToContents()

            -- Boolean toggle
            if isbool(v) then
                local combo = vgui.Create("DComboBox", editorPanel)
                combo:SetPos(150, y)
                combo:SetSize(200, 20)
                combo:AddChoice("true")
                combo:AddChoice("false")
                combo:SetValue(tostring(v))
                combo.OnSelect = function(_, _, val)
                    data[k] = (val == "true")
                end
                y = y + 30
                return
            end

            -- Vector field
            if isvector(v) then
                local input = vgui.Create("DTextEntry", editorPanel)
                input:SetPos(150, y)
                input:SetSize(200, 20)
                input:SetText(string.format("%.2f %.2f %.2f", v.x, v.y, v.z))

                input.OnChange = function()
                    local x, y2, z = string.match(input:GetValue(), "([%d.-]+) ([%d.-]+) ([%d.-]+)")
                    if x and y2 and z then
                        data[k] = Vector(tonumber(x), tonumber(y2), tonumber(z))
                    end
                end

                local posBtn = vgui.Create("DButton", editorPanel)
                posBtn:SetText("Set to my pos")
                posBtn:SetSize(120, 20)
                posBtn:SetPos(360, y)
                posBtn.DoClick = function()
                    local vec = LocalPlayer():GetPos()
                    input:SetText(string.format("%.2f %.2f %.2f", vec.x, vec.y, vec.z))
                    data[k] = vec
                end

                y = y + 30
                return
            end

            -- Default entry
            local input = vgui.Create("DTextEntry", editorPanel)
            input:SetPos(150, y)
            input:SetSize(200, 20)
            input:SetText(tostring(v))

            input.OnChange = function()
                local val = input:GetValue()
                data[k] = tonumber(val) or val
            end

            y = y + 30
        end

        -- Regular keys
        for k, v in pairs(data) do
            if k ~= "adverts" then
                addKVEditor(k, v)
            end
        end

        -- Adverts
        if not istable(data.adverts) then data.adverts = {} end

        local advertLabel = vgui.Create("DLabel", editorPanel)
        advertLabel:SetPos(10, y + 10)
        advertLabel:SetText("Adverts:")
        advertLabel:SizeToContents()
        y = y + 30

        for delay, msg in pairs(data.adverts) do
            addKVEditor("adverts[" .. delay .. "]", msg)
        end

        -- Add advert
        local advertDelay = vgui.Create("DTextEntry", editorPanel)
        advertDelay:SetPos(10, y)
        advertDelay:SetSize(100, 20)
        advertDelay:SetPlaceholderText("Delay (e.g. 0.5)")

        local advertMsg = vgui.Create("DTextEntry", editorPanel)
        advertMsg:SetPos(120, y)
        advertMsg:SetSize(200, 20)
        advertMsg:SetPlaceholderText("Message")

        local addBtn = vgui.Create("DButton", editorPanel)
        addBtn:SetPos(330, y)
        addBtn:SetSize(100, 20)
        addBtn:SetText("Add Advert")
        addBtn.DoClick = function()
            local delay = tonumber(advertDelay:GetValue())
            local msg = advertMsg:GetValue()
            if delay and msg ~= "" then
                data.adverts[delay] = msg
                populateEditor(data, jobID)
            end
        end

        y = y + 40

        -- Remove advert
        local removeDelay = vgui.Create("DTextEntry", editorPanel)
        removeDelay:SetPos(10, y)
        removeDelay:SetSize(100, 20)
        removeDelay:SetPlaceholderText("Delay to remove")

        local removeBtn = vgui.Create("DButton", editorPanel)
        removeBtn:SetPos(120, y)
        removeBtn:SetSize(100, 20)
        removeBtn:SetText("Remove Advert")
        removeBtn.DoClick = function()
            local delayToRemove = tonumber(removeDelay:GetValue())
            if delayToRemove and data.adverts[delayToRemove] then
                data.adverts[delayToRemove] = nil
                populateEditor(data, jobID)
            end
        end

        y = y + 40

        -- Save button
        local saveBtn = vgui.Create("DButton", editorPanel)
        saveBtn:SetText("Save to File")
        saveBtn:SetSize(120, 30)
        saveBtn:SetPos(10, y)
        saveBtn.DoClick = function()
            Atlas_Breach.SCPs[jobID] = data
        
            local json = util.TableToJSON(Atlas_Breach.SCPs, true)
            local compressed = util.Compress(json)
        
            net.Start("Atlas_Breach::SCPConfig")
                net.WriteString("sync")
                net.WriteUInt(#compressed, 32)
                net.WriteData(compressed, #compressed)
            net.SendToServer()
        
            notification.AddLegacy("Saved to server!", NOTIFY_GENERIC, 2)
            surface.PlaySound("buttons/button14.wav")
        end        
    end

    list.OnRowSelected = function(_, _, row)
        local jobName = row:GetColumnText(1)
        for id, team in pairs(RPExtraTeams) do
            if team.name == jobName and Atlas_Breach.SCPs[id] then
                populateEditor(Atlas_Breach.SCPs[id], id)
                break
            end
        end
    end
end)

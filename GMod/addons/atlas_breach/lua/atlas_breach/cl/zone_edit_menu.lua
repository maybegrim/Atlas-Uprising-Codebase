// Atlas_Breach = Atlas_Breach or {}
// Atlas_Breach.Zones = Atlas_Breach.Zones or {}

// net.Receive("Atlas_Breach::Zones", function()
//     local len = net.ReadUInt(32)
//     local data = net.ReadData(len)
//     local decompressed = util.Decompress(data)

//     if not decompressed then
//         print("[SCPConfig] Decompression failed!")
//         return
//     end

//     Atlas_Breach.Zones = util.JSONToTable(decompressed)
// end)

// local function getZoneName(zoneKey)
//     return zoneKey or "Unknown Zone"
// end

// concommand.Add("open_zone_config_menu", function()
//     editZones()
// end)

// function editZones()
//     local frame = vgui.Create("DFrame")
//     frame:SetSize(900, 600)
//     frame:Center()
//     frame:SetTitle("Zone Config Editor")
//     frame:MakePopup()

//     local list = vgui.Create("DListView", frame)
//     list:SetSize(300, 500)
//     list:SetPos(10, 80)
//     list:AddColumn("Zone Name")

//     local editorPanel = vgui.Create("DScrollPanel", frame)
//     editorPanel:SetSize(580, 500)
//     editorPanel:SetPos(320, 80)

//     local function populateList()
//         list:Clear()
//         for zoneKey, _ in pairs(Atlas_Breach.Zones) do
//             list:AddLine(getZoneName(zoneKey)):SetColumnText(1, zoneKey)
//         end
//     end

//     populateList()

//     local function populateEditor(data, zoneKey)
//         editorPanel:Clear()
//         local y = 10

//         local function addVectorEditor(index, vector)
//             local label = vgui.Create("DLabel", editorPanel)
//             label:SetPos(10, y)
//             label:SetText("Vector " .. index .. ":")
//             label:SizeToContents()
//             y = y + 20

//             local xEntry = vgui.Create("DTextEntry", editorPanel)
//             xEntry:SetPos(150, y)
//             xEntry:SetSize(80, 20)
//             xEntry:SetValue(tostring(vector.x))
//             xEntry.OnChange = function()
//                 local num = tonumber(xEntry:GetValue())
//                 if num then data[index].x = num end
//             end

//             local yEntry = vgui.Create("DTextEntry", editorPanel)
//             yEntry:SetPos(240, y)
//             yEntry:SetSize(80, 20)
//             yEntry:SetValue(tostring(vector.y))
//             yEntry.OnChange = function()
//                 local num = tonumber(yEntry:GetValue())
//                 if num then data[index].y = num end
//             end

//             local zEntry = vgui.Create("DTextEntry", editorPanel)
//             zEntry:SetPos(330, y)
//             zEntry:SetSize(80, 20)
//             zEntry:SetValue(tostring(vector.z))
//             zEntry.OnChange = function()
//                 local num = tonumber(zEntry:GetValue())
//                 if num then data[index].z = num end
//             end

//             local removeVectorBtn = vgui.Create("DButton", editorPanel)
//             removeVectorBtn:SetText("Remove")
//             removeVectorBtn:SetSize(60, 20)
//             removeVectorBtn:SetPos(420, y)
//             removeVectorBtn.DoClick = function()
//                 table.remove(data, index)
//                 populateEditor(data, zoneKey)
//             end

//             y = y + 30
//         end

//         if data then
//             for index, vector in pairs(data) do
//                 addVectorEditor(index, vector)
//             end
//         end

//         local addVectorBtn = vgui.Create("DButton", editorPanel)
//         addVectorBtn:SetText("Add Vector")
//         addVectorBtn:SetSize(120, 30)
//         addVectorBtn:SetPos(10, y)
//         addVectorBtn.DoClick = function()
//             if not data then data = {} end
//             table.insert(data, Vector(0, 0, 0))
//             populateEditor(data, zoneKey)
//         end
//         y = y + 35

//         local saveBtn = vgui.Create("DButton", editorPanel)
//         saveBtn:SetText("Save to Server")
//         saveBtn:SetSize(120, 30)
//         saveBtn:SetPos(10, y)
//         saveBtn.DoClick = function()
//             Atlas_Breach.Zones[zoneKey] = data

//             PrintTable( Atlas_Breach.Zones)

//             local json = util.TableToJSON(Atlas_Breach.Zones, true)
//             local compressed = util.Compress(json)

//             net.Start("Atlas_Breach::Zones")
//                 net.WriteString("sync")
//                 net.WriteUInt(#compressed, 32)
//                 net.WriteData(compressed, #compressed)
//             net.SendToServer()

//             notification.AddLegacy("Saved to server!", NOTIFY_GENERIC, 2)
//             surface.PlaySound("buttons/button14.wav")
//         end
//     end

//     list.OnRowSelected = function(_, _, row)
//         local zoneName = row:GetColumnText(1)
//         for zoneKey, zoneData in pairs(Atlas_Breach.Zones) do
//             if getZoneName(zoneKey) == zoneName then
//                 populateEditor(zoneData, zoneKey)
//                 break
//             end
//         end
//     end

//     local addZoneBtn = vgui.Create("DButton", frame)
//     addZoneBtn:SetText("Add Zone")
//     addZoneBtn:SetSize(120, 30)
//     addZoneBtn:SetPos(10, 10)
//     addZoneBtn.DoClick = function()
//         local zoneName = gui.InputDialog("Enter Zone Name:", "", function(text)
//             if text and text ~= "" then
//                 Atlas_Breach.Zones[text] = {Vector(0, 0, 0)}
//                 populateList()
//                 populateEditor(Atlas_Breach.Zones[text], text)
//             end
//         end)
//     end

//     local removeZoneBtn = vgui.Create("DButton", frame)
//     removeZoneBtn:SetText("Remove Zone")
//     removeZoneBtn:SetSize(120, 30)
//     removeZoneBtn:SetPos(140, 10)
//     removeZoneBtn.DoClick = function()
//         local selectedRowIndex = list:GetSelectedLine()
//         if selectedRowIndex then
//             local selectedRow = list:GetLine(selectedRowIndex)
//             local zoneName = selectedRow:GetColumnText(1)
//             for zoneKey, _ in pairs(Atlas_Breach.Zones) do
//                 if getZoneName(zoneKey) == zoneName then
//                     Atlas_Breach.Zones[zoneKey] = nil
//                     populateList()
//                     editorPanel:Clear()
//                     break
//                 end
//             end
//         end
//     end
// end
print("CL: cl_weapons.lua")
LEVEL.Weapons = LEVEL.Weapons or {}
LEVEL.OwnedWeps = LEVEL.OwnedWeps or {}

surface.CreateFont("LVLCFGFont", {
    font = "MADE Tommy",
    size = 20,
    weight = 700,
    antialias = true
})

-- Function to apply dark mode theme
local function ApplyDarkMode(frame)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40))
        draw.RoundedBox(8, 0, 0, w, 24, Color(60, 60, 60))
    end
end

local function ApplyDarkModeTextEntry(textEntry)
    textEntry.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50))
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
    end
end

local function ApplyDarkModeComboBox(comboBox)
    comboBox.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50))
        self:SetTextColor(Color(255, 255, 255))
    end
end

local function ApplyDarkModeButton(button)
    button.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(60, 60, 60))
        --draw.SimpleText(button:GetText(), "DermaDefault", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if self:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, h, Color(255, 30, 30, 100))
        end
    end
end

local function ApplyDarkModeListView(listView)
    listView.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50))
    end
    listView.OnRowSelected = function(panel, rowIndex, row)
        for _, v in pairs(panel:GetLines()) do
            v.Paint = function(self, w, h)
                if self:IsSelected() then
                    draw.RoundedBox(4, 0, 0, w, h, Color(70, 70, 70))
                else
                    draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50))
                end
            end
        end
    end
end

function LEVEL.OpenAddWeapon()
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 250)
    frame:Center()
    frame:SetTitle("Add Weapon")
    ApplyDarkMode(frame)
    frame:MakePopup()

    local weaponTxt = vgui.Create("DLabel", frame)
    weaponTxt:Dock(TOP)
    weaponTxt:SetText("Weapon")
    weaponTxt:SetFont("LVLCFGFont")
    weaponTxt:SetTextColor(Color(255, 255, 255))
    weaponTxt:SizeToContents()

    local weaponEntry = vgui.Create("DTextEntry", frame)
    weaponEntry:Dock(TOP)
    weaponEntry:SetPlaceholderText("Weapon")
    weaponEntry:DockMargin(0, 0, 0, 5)
    ApplyDarkModeTextEntry(weaponEntry)

    local teamTxt = vgui.Create("DLabel", frame)
    teamTxt:Dock(TOP)
    teamTxt:SetText("Team")
    teamTxt:SetFont("LVLCFGFont")
    teamTxt:SetTextColor(Color(255, 255, 255))
    teamTxt:SizeToContents()

    local teamEntry = vgui.Create("DComboBox", frame)
    teamEntry:Dock(TOP)
    teamEntry:SetValue("Team")
    teamEntry:DockMargin(0, 0, 0, 5)
    ApplyDarkModeComboBox(teamEntry)
    for k, v in pairs(team.GetAllTeams()) do
        teamEntry:AddChoice(v.Name)
    end

    local priceTxt = vgui.Create("DLabel", frame)
    priceTxt:Dock(TOP)
    priceTxt:SetText("Price")
    priceTxt:SetFont("LVLCFGFont")
    priceTxt:SetTextColor(Color(255, 255, 255))
    priceTxt:SizeToContents()

    local priceEntry = vgui.Create("DTextEntry", frame)
    priceEntry:Dock(TOP)
    priceEntry:SetPlaceholderText("Price")
    ApplyDarkModeTextEntry(priceEntry)
    priceEntry.OnChange = function(self)
        local val = self:GetValue()
        local lastChar = val:sub(-1)
        if not tonumber(lastChar) then
            timer.Simple(0, function() -- add a small delay
                if IsValid(self) then -- check if the text entry box still exists
                    self:SetText(val:sub(1, -2)) -- remove the last character
                    self:SetCaretPos(string.len(self:GetValue())) -- move the caret to the end
                end
            end)
        end
    end

    local levelTxt = vgui.Create("DLabel", frame)
    levelTxt:Dock(TOP)
    levelTxt:SetText("Level")
    levelTxt:SetFont("LVLCFGFont")
    levelTxt:SetTextColor(Color(255, 255, 255))
    levelTxt:SizeToContents()

    local levelEntry = vgui.Create("DTextEntry", frame)
    levelEntry:Dock(TOP)
    levelEntry:SetPlaceholderText("Level")
    ApplyDarkModeTextEntry(levelEntry)
    levelEntry.OnChange = function(self)
        local val = self:GetValue()
        local lastChar = val:sub(-1)
        if not tonumber(lastChar) then
            timer.Simple(0, function() -- add a small delay
                if IsValid(self) then -- check if the text entry box still exists
                    self:SetText(val:sub(1, -2)) -- remove the last character
                    self:SetCaretPos(string.len(self:GetValue())) -- move the caret to the end
                end
            end)
        end
    end

    local submit = vgui.Create("DButton", frame)
    submit:Dock(BOTTOM)
    submit:SetText("Submit")
    submit:SetFont("LVLCFGFont")
    submit:SetTextColor(Color(255, 255, 255))
    ApplyDarkModeButton(submit)
    submit.DoClick = function()
        local weapon = weaponEntry:GetValue()
        local team = teamEntry:GetSelectedID() - 1
        local price = priceEntry:GetValue()
        local level = levelEntry:GetValue()
        net.Start("LEVEL::WEAPON:CONFIG::ADD")
        net.WriteString(weapon)
        net.WriteInt(team, 32)
        net.WriteInt(price, 32)
        net.WriteInt(level, 32)
        net.SendToServer()
        frame:Close()
        timer.Simple(0.1, function()
            LEVEL.OpenWepConfig()
        end)
    end
end

function LEVEL.OpenEditWeapon(wep, id)
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 250)
    frame:Center()
    frame:SetTitle("Edit Weapon")
    ApplyDarkMode(frame)
    frame:MakePopup()

    local weaponTxt = vgui.Create("DLabel", frame)
    weaponTxt:Dock(TOP)
    weaponTxt:SetText("Weapon")
    weaponTxt:SetFont("LVLCFGFont")
    weaponTxt:SetTextColor(Color(255, 255, 255))
    weaponTxt:SizeToContents()

    local weaponEntry = vgui.Create("DTextEntry", frame)
    weaponEntry:Dock(TOP)
    weaponEntry:SetPlaceholderText("Weapon")
    weaponEntry:DockMargin(0, 0, 0, 5)
    ApplyDarkModeTextEntry(weaponEntry)

    local teamTxt = vgui.Create("DLabel", frame)
    teamTxt:Dock(TOP)
    teamTxt:SetText("Team")
    teamTxt:SetFont("LVLCFGFont")
    teamTxt:SetTextColor(Color(255, 255, 255))
    teamTxt:SizeToContents()

    local teamEntry = vgui.Create("DComboBox", frame)
    teamEntry:Dock(TOP)
    teamEntry:SetValue("Team")
    teamEntry:DockMargin(0, 0, 0, 5)
    ApplyDarkModeComboBox(teamEntry)
    for k, v in pairs(team.GetAllTeams()) do
        teamEntry:AddChoice(v.Name)
    end

    local priceTxt = vgui.Create("DLabel", frame)
    priceTxt:Dock(TOP)
    priceTxt:SetText("Price")
    priceTxt:SetFont("LVLCFGFont")
    priceTxt:SetTextColor(Color(255, 255, 255))
    priceTxt:SizeToContents()

    local priceEntry = vgui.Create("DTextEntry", frame)
    priceEntry:Dock(TOP)
    priceEntry:SetPlaceholderText("Price")
    ApplyDarkModeTextEntry(priceEntry)
    priceEntry.OnChange = function(self)
        local val = self:GetValue()
        local lastChar = val:sub(-1)
        if not tonumber(lastChar) then
            timer.Simple(0, function() -- add a small delay
                if IsValid(self) then -- check if the text entry box still exists
                    self:SetText(val:sub(1, -2)) -- remove the last character
                    self:SetCaretPos(string.len(self:GetValue())) -- move the caret to the end
                end
            end)
        end
    end

    local levelTxt = vgui.Create("DLabel", frame)
    levelTxt:Dock(TOP)
    levelTxt:SetText("Level")
    levelTxt:SetFont("LVLCFGFont")
    levelTxt:SetTextColor(Color(255, 255, 255))
    levelTxt:SizeToContents()

    local levelEntry = vgui.Create("DTextEntry", frame)
    levelEntry:Dock(TOP)
    levelEntry:SetPlaceholderText("Level")
    ApplyDarkModeTextEntry(levelEntry)
    levelEntry.OnChange = function(self)
        local val = self:GetValue()
        local lastChar = val:sub(-1)
        if not tonumber(lastChar) then
            timer.Simple(0, function() -- add a small delay
                if IsValid(self) then -- check if the text entry box still exists
                    self:SetText(val:sub(1, -2)) -- remove the last character
                    self:SetCaretPos(string.len(self:GetValue())) -- move the caret to the end
                end
            end)
        end
    end

    if wep then
        weaponEntry:SetText(wep.weapon)
        teamEntry:ChooseOptionID(wep.team + 1)
        priceEntry:SetText(wep.price)
        levelEntry:SetText(wep.level)
    end

    local submit = vgui.Create("DButton", frame)
    submit:Dock(BOTTOM)
    submit:SetText("Submit")
    submit:SetFont("LVLCFGFont")
    submit:SetTextColor(Color(255, 255, 255))
    ApplyDarkModeButton(submit)
    submit.DoClick = function()
        local weapon = weaponEntry:GetValue()
        local team = teamEntry:GetSelectedID() - 1
        local price = priceEntry:GetValue()
        local level = levelEntry:GetValue()
        net.Start("LEVEL::WEAPON:CONFIG::EDIT")
        net.WriteInt(id, 32)
        net.WriteString(weapon)
        net.WriteInt(team, 32)
        net.WriteInt(price, 32)
        net.WriteInt(level, 32)
        net.SendToServer()
        frame:Close()
        timer.Simple(1, function()
            LEVEL.OpenWepConfig()
        end)
    end
end

function LEVEL.OpenWepConfig()
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 400)
    frame:Center()
    frame:SetTitle("Weapon Configuration")
    ApplyDarkMode(frame)
    frame:MakePopup()

    local weaponList = vgui.Create("DListView", frame)
    weaponList:Dock(FILL)
    weaponList:AddColumn("ID")
    weaponList:AddColumn("Weapon")
    weaponList:AddColumn("Team")
    weaponList:AddColumn("Price")
    weaponList:AddColumn("Level")
    weaponList:SetMultiSelect(false)
    ApplyDarkModeListView(weaponList)

    if istable(LEVEL.Weapons) then
        for k, v in pairs(LEVEL.Weapons) do
            local line = weaponList:AddLine(k, v.weapon, team.GetName(v.team), v.price, v.level)
            for _, column in pairs(line.Columns) do
                column:SetTextColor(Color(255, 255, 255)) -- Set text color to white
            end
        end
    end

    local addWeapon = vgui.Create("DButton", frame)
    addWeapon:Dock(BOTTOM)
    addWeapon:SetText("Add Weapon")
    addWeapon:SetFont("LVLCFGFont")
    addWeapon:SetTextColor(Color(255, 255, 255))
    ApplyDarkModeButton(addWeapon)
    addWeapon.DoClick = function()
        LEVEL.OpenAddWeapon()
        frame:Close()
    end

    local editWeapon = vgui.Create("DButton", frame)
    editWeapon:Dock(BOTTOM)
    editWeapon:SetText("Edit Weapon")
    editWeapon:SetFont("LVLCFGFont")
    editWeapon:SetTextColor(Color(255, 255, 255))
    ApplyDarkModeButton(editWeapon)
    editWeapon.DoClick = function()
        local selected = weaponList:GetSelectedLine()
        if not selected then return end
        local weapon = weaponList:GetLine(selected):GetValue(1)
        LEVEL.OpenEditWeapon(LEVEL.Weapons[weapon], weapon)
        frame:Close()
    end

    local removeWeapon = vgui.Create("DButton", frame)
    removeWeapon:Dock(BOTTOM)
    removeWeapon:SetText("Remove Weapon")
    removeWeapon:SetFont("LVLCFGFont")
    removeWeapon:SetTextColor(Color(255, 255, 255))
    ApplyDarkModeButton(removeWeapon)
    removeWeapon.DoClick = function()
        local selected = weaponList:GetSelectedLine()
        if not selected then return end
        local weapon = weaponList:GetLine(selected):GetValue(1)
        net.Start("LEVEL::WEAPON:CONFIG::REMOVE")
        net.WriteInt(weapon, 32)
        net.SendToServer()
        weaponList:RemoveLine(selected)
    end
end

function LEVEL.CanIBuyWeapon(wep)
    local level = LEVEL.GetLevel(LocalPlayer())
    local wepLevel
    for k, v in pairs(LEVEL.Weapons) do
        if v.weapon == wep then
            wepLevel = v.level
        end
    end
    if level >= wepLevel then
        return true, wepLevel
    end
    return false, wepLevel
end

function LEVEL.GetOwnedWeps()
    return LEVEL.OwnedWeps
end

net.Receive("LEVEL::WEAPON:CONFIG::ADD", function()
    local id = net.ReadInt(32)
    local weapon = net.ReadString()
    local team = net.ReadInt(32)
    local price = net.ReadInt(32)
    local level = net.ReadInt(32)
    LEVEL.Weapons[id] = {weapon = weapon, team = team, price = price, level = level}
    --print("Weapon added")
end)

net.Receive("LEVEL::WEAPON:CONFIG::EDIT", function()
    local id = net.ReadInt(32)
    local weapon = net.ReadString()
    local team = net.ReadInt(32)
    local price = net.ReadInt(32)
    local level = net.ReadInt(32)
    LEVEL.Weapons[id] = {weapon = weapon, team = team, price = price, level = level}
end)

net.Receive("LEVEL::WEAPON:CONFIG::REMOVE", function()
    local weapon = net.ReadInt(32)
    LEVEL.Weapons[weapon] = nil
end)

net.Receive("LEVEL::WEAPON:LOGIC::INFORM", function()
    local len = net.ReadInt(32)
    local data = net.ReadData(len)
    local data = util.Decompress(data)
    local data = util.JSONToTable(data)
    LEVEL.OwnedWeps = data
    --PrintTable(LEVEL.OwnedWeps)
end)
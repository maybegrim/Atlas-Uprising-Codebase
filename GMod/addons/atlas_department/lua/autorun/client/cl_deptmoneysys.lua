local sw, sh = ScrW(), ScrH()
myDeptDues = 0
for i=1,100 do
    surface.CreateFont("Mono"..i, {
        font = "Monofonto",
        extended = false,
        size = ScreenScale(i * .3),
        weight = 500,
    })
end

local atlasLogo = Material("branding/atlas_logo.png", "smooth", "noclamp")
local gradLeft = Material("vgui/gradient-l")
local gradRight = Material("vgui/gradient-r")
local backGround = Material("notifications/background.png")

local logoW, logoH = sw * .15, sw * .0543 --324 x 117
local outlineWidth = sw * .005

local blur = Material( "pp/blurscreen" )
function draw_Blur(panel, amount) 
	local x, y = panel:LocalToScreen( 0, 0 )
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	for i = 1, 6 do
		blur:SetFloat('$blur', (i / 6) * (amount ~= nil and amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect(x * -1, y * -1, sw, sh)
	end
end

function GenerateFlashingColor(useStaticGreen)
    if useStaticGreen then
        return Color(39, 174, 96)  -- Static green color
    else
        local frequency = 5  -- Adjust this value to control the speed of the flash
        local amplitude = 50 -- Adjust this value to control the intensity of the flash

        local time = RealTime() * frequency
        local flashValue = math.sin(time) * amplitude

        local red = 175 + flashValue
        local green = 0
        local blue = 0

        -- Ensure color values are within the valid range (0-255)
        red = math.Clamp(red, 0, 255)
        green = math.Clamp(green, 0, 255)
        blue = math.Clamp(blue, 0, 255)

        return Color(red, green, blue)
    end
end

local logHeight = outlineWidth * 0.15  -- Height of each log box
local logGap = outlineWidth * 0.25  -- Gap between log boxes

local function getColorForLogType(logType, logVar)
    if logType == "Boosts" then
        if string.StartsWith(logVar, "Weapon") then
            return ATLAS_DEPTMONEYSYS.LogColours["Weapons"]
        else
            return ATLAS_DEPTMONEYSYS.LogColours["Boosts"]
        end
    elseif logType == "Withdraw" then
        return ATLAS_DEPTMONEYSYS.LogColours["Withdraw"]
    elseif logType == "Deposit" then
        return ATLAS_DEPTMONEYSYS.LogColours["Deposit"]
    elseif logType == "Maintenance" then
        return ATLAS_DEPTMONEYSYS.LogColours["Maintenance"]
    else
        return Color(255, 255, 255)  -- Default color
    end
end

local function openHomeTerminalUI( parent, category )

    local p = LocalPlayer()
    local t = p.departmentTable

    local home = vgui.Create("DPanel", parent)
    home:Dock(FILL)
    home.Paint = function(s, w, h) end

    local title = vgui.Create("DLabel", home)
    title:Dock(TOP)
    title:SetText(category .. " Overview")
    title:SetFont("Mono50")
    title:SetTall(parent:GetParent():GetTall() * .09)
    title:SetContentAlignment(5)
    title:SetTextColor(Color(255, 255, 255))

    local internalMain = vgui.Create("DPanel", home)
    internalMain:Dock(FILL)
    internalMain:DockMargin(outlineWidth * 2, 0, outlineWidth * 2, outlineWidth * 2 )

    local timeTable = t["dates"]
    local curDay = timeTable["curDay"]
    local firstDay = timeTable["firstDay"]
    local lastDay = timeTable["lastDay"]
    local totalDays = tonumber(os.date( "%d" , lastDay ))
    local curDayInt = tonumber(os.date( "%d" , curDay ))

    local logTable = t["logs"]

    local firstDayPretty = os.date( "%d/%m/%Y" , firstDay )
    local lastDayPretty = os.date( "%d/%m/%Y" , lastDay )
    local curDayPretty = os.date( "%d/%m/%Y" , curDay )

    local maintenanceStatus = vgui.Create("DPanel", internalMain)
    maintenanceStatus:Dock(TOP)
    maintenanceStatus:SetTall(parent:GetParent():GetTall() * .085)
    maintenanceStatus.hasPaid = false
    maintenanceStatus.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55))
        for _, log in pairs(logTable) do
            if log["log_type"] != "Maintenance" then continue end
            s.hasPaid = true
        end

        if !backGround:IsError() then
            surface.SetMaterial(backGround)
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawTexturedRect(0, 0, w, h)
        end
        local stringStatus = s.hasPaid and "SETTLED" or "NOT PAID"
        if myDeptDues == 0 then
            stringStatus = "SETTLED"
        end
        local stringColor = GenerateFlashingColor(s.hasPaid)
        draw.SimpleText("MAINTENANCE STATUS: " .. stringStatus, "Mono50", w * .5, h * .5, stringColor, 1,1 )
    end

    local monthlyTime = vgui.Create("DPanel", internalMain)
    monthlyTime:Dock(TOP)
    monthlyTime:SetTall(parent:GetParent():GetTall() * .185)
    monthlyTime.Paint = function(s, w, h)

        local timeLineY = h * .8
        local timeLineWidth = w * .9
        local timeIncrements = timeLineWidth / (totalDays - 1)
        draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45))
        draw.SimpleText(os.date("%B", curDay), "Mono100", w * .5, timeLineY - h * .3, Color(255, 255, 255, 5), 1, 1 )
        surface.SetDrawColor(Color(255, 255, 255))
        surface.DrawLine(w * .5 - timeLineWidth * .5, timeLineY, w * .5 + timeLineWidth * .5, timeLineY)

        for i = 1, totalDays do
            surface.DrawLine(w * 0.5 - timeLineWidth * 0.5 + timeIncrements * (i - 1), timeLineY - h * .05, w * 0.5 - timeLineWidth * 0.5 + timeIncrements * (i - 1), timeLineY)
            draw.SimpleText(i, "Mono12", w * 0.5 - timeLineWidth * 0.5 + (timeIncrements * (i - 1)), timeLineY - h * .1, Color(255, 255, 255), 1, 1)
        end

        draw.SimpleText(curDayPretty, "Mono15", w * .5 - timeLineWidth * .5 + (timeIncrements * curDayInt) - (timeIncrements), timeLineY + h * .125, Color(255, 255, 255), 1, 1)
        draw.SimpleText("Today", "Mono12", w * .5 - timeLineWidth * .5 + (timeIncrements * curDayInt) - (timeIncrements), timeLineY + h * .05, Color(255, 255, 255), 1, 1)
        
        local logsPerDay = {}
        
        for _, log in ipairs(logTable) do
            local logDate = tonumber(log["date"])
            local daysFromFirst = math.floor((logDate - firstDay) / (24 * 60 * 60)) + 1
        
            logsPerDay[daysFromFirst] = logsPerDay[daysFromFirst] or 0  -- Ensure logsPerDay is initialized
        
            local logsOnDay = logsPerDay[daysFromFirst]
            local x = w * 0.5 - timeLineWidth * 0.5 + ((timeIncrements * daysFromFirst) - timeIncrements * 1.5)
            local y = (timeLineY - h * .025) - outlineWidth * 2 - logsOnDay * (logHeight + logGap)
        
            local logColor = getColorForLogType(log["log_type"], log["log_var"])
        
            draw.RoundedBox(20, x, y, timeIncrements, logHeight, logColor)
        
            -- Increment the number of logs on the current day
            logsPerDay[daysFromFirst] = logsOnDay + 1
        end
    end

    local vitArmorStatus = vgui.Create("DPanel", internalMain)
    vitArmorStatus:Dock(TOP)
    vitArmorStatus:SetTall(parent:GetParent():GetTall() * .185)
    vitArmorStatus.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55))
    end

    local boostTable = p.departmentTable["boosts"]
    local tbl = {"Vitality", "Armor", "Weapon"}
    local boostValues = {}
    for _, boost in pairs(boostTable) do
        if boost["boost_type"] == "Vitality" then
            boostValues["Vitality"] = "V" .. boost["boost_arg"]
        end
        if boost["boost_type"] == "Armor" then
            boostValues["Armor"] = "V" .. boost["boost_arg"]
        end
        if boost["boost_type"] == "Weapon" then
            if boost["team"] != p:getDarkRPVar("job") then continue end
            boostValues["Weapon"] = boost["boost_arg"] 
        end
    end

    for k, v in pairs(tbl) do
        local boostPanel = vgui.Create("DPanel", vitArmorStatus)
        boostPanel:Dock(LEFT)
        boostPanel:SetWide(parent:GetParent():GetWide() / 4.5)
        boostPanel.Paint = function(s, w, h)
            draw.RoundedBox(24, w * .025, w * .025, w * .95, h - (w * .05), Color(30, 30, 30))
            if !backGround:IsError() then
                surface.SetMaterial(backGround)
                surface.SetDrawColor(30, 30, 30, 250)
                surface.DrawTexturedRect(w * .025, w * .025, w * .95, h - (w * .05))
            end
            draw.SimpleText(v, "Mono25", w * .5, h * .2, Color(205, 205, 205), 1,1 )
            if v == "Weapon" then
                local wepName = getPrettyWeaponName(boostValues["Weapon"])  
                draw.SimpleText(p:getDarkRPVar("job"), "Mono15", w * .5, h * .35, Color(205, 205, 205), 1,1 )
                draw.SimpleText(wepName != "nil" and wepName or "NONE", "Mono35", w * .5, h * .65, Color(205, 205, 205), 1,1 )
            elseif v == "Vitality" then
                draw.SimpleText(category, "Mono15", w * .5, h * .35, Color(205, 205, 205), 1,1 )
                draw.SimpleText(boostValues["Vitality"] or "NONE", "Mono35", w * .5, h * .65, Color(205, 55, 55), 1,1 )
            elseif v == "Armor" then
                draw.SimpleText(category, "Mono15", w * .5, h * .35, Color(205, 205, 205), 1,1 )
                draw.SimpleText(boostValues["Armor"] or "NONE", "Mono35", w * .5, h * .65, Color(55, 125, 245), 1,1 )
            end
        end
    end

    local teamStatus = vgui.Create("DPanel", internalMain)
    teamStatus:Dock(TOP)
    teamStatus:SetTall(parent:GetParent():GetTall() * .285)
    teamStatus.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45))
    end

    local playerGridHolder = vgui.Create("DPanel", teamStatus)
    playerGridHolder:Dock(FILL)
    playerGridHolder:DockMargin(outlineWidth * .5, outlineWidth * .5, outlineWidth * .5, outlineWidth * .5)
    playerGridHolder:SetDrawBackground(false)

    local pTable = {}
    for k, v in pairs(player.GetAll()) do
        if v:getJobCategory() != category then continue end
        table.insert(pTable, v)
    end

    parent = parent:GetParent()
    local playerPanelWide = parent:GetWide() * 0.15
    local playerQuantity = table.Count(pTable)
    local contentWidth = playerQuantity * (playerPanelWide + outlineWidth * .5)
    local scrollSpeed = 5  -- Adjust the scroll speed as needed
    local minX = (parent:GetWide() * .655 - contentWidth + outlineWidth)
    local maxX = 0
    local center = (minX * .5)
    
    local playerGrid = vgui.Create("DPanel", playerGridHolder)
    playerGrid:SetPos(p.playerGridPos and p.playerGridPos or center, 0)
    playerGrid:SetSize(contentWidth, parent:GetTall() * .4)
    playerGrid.posX = p.playerGridPos and p.playerGridPos or center
    playerGrid:SetDrawBackground(false)
    
    local pPanels = {}
    local modelPanels = {}
    local repetition = 0
    for k, v in pairs(pTable) do
        pPanels[k] = vgui.Create("Panel", playerGrid)
        pPanels[k]:SetPos(repetition * (playerPanelWide + outlineWidth * .5))
        pPanels[k]:SetSize(playerPanelWide, parent:GetTall() * .272)
        pPanels[k].Paint = function(s, w, h)
            draw.RoundedBox(16, 0, 0, w, h, Color(30, 30, 30))
            draw.RoundedBoxEx(16, 0, 0, w, h * .175, Color(230, 230, 230), true, true, false, false)
            if !backGround:IsError() then
                surface.SetMaterial(backGround)
                surface.SetDrawColor(30, 30, 30, 250)
                surface.DrawTexturedRect(w * .025, w * .025, w * .95, h - (w * .05))
            end
            draw.SimpleText(v:getDarkRPVar("rpname"), "Mono15", w * .5, h * .125, Color(25, 25, 25), 1, 1)
            draw.SimpleText(v:getDarkRPVar("job"), "Mono16", w * .5, h * .065, team.GetColor(v:Team()), 1, 1)
        end
    
        modelPanels[k] = vgui.Create("DModelPanel", pPanels[k])
        modelPanels[k]:Dock(FILL)
        modelPanels[k]:SetModel(v:GetModel())
        modelPanels[k].LayoutEntity = function(s, ent)
            if not IsValid(ent) then return end  -- Check if the entity is valid
    
            -- Set camera position to focus on the upper part of the model (e.g., eyes)
            local headBone = ent:LookupBone("ValveBiped.Bip01_Head1") or ent:LookupBone("Bip01 Head")
            local headPos, headAng = ent:GetBonePosition(headBone)
    
            local view = {
                origin = headPos, -- Adjust the Z value to position the camera higher
                angles = Angle(0, headAng.y + 180, 0), -- Keep the same yaw angle as the head
                fov = 40, -- Adjust the field of view if necessary
            }
    
            -- Adjust zoom and distance from the model
            s:SetCamPos(view.origin - view.angles:Forward() * 70)
            s:SetLookAt(view.origin)
    
            -- Set the model panel's position and size
            local _, maxs = ent:GetRenderBounds()
            local size = 0.9 * math.max(maxs.x, maxs.y, maxs.z) -- Adjust the factor (0.9) for the desired size
            s:SetFOV(30) -- Adjust the FOV to control the apparent size of the model
            s:SetLookAt(ent:GetPos() + Vector(0, 0, size * .9))
        end
    
    
        repetition = repetition + 1
    end

    local buttonLeft = vgui.Create("DButton", playerGridHolder)
    buttonLeft:Dock(LEFT)
    buttonLeft:SetFont("Mono25")
    buttonLeft:SetText("<")
    buttonLeft:SetTextColor(Color(225, 225, 225))
    buttonLeft.Paint = function(s, w, h)
        surface.SetDrawColor(Color(105, 105, 105, 25))
        surface.SetMaterial(gradLeft)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    buttonLeft.DoClick = function(s)
        playerGrid.posX = playerGrid.posX + (playerPanelWide + outlineWidth * .5)
        playerGrid.posX = math.Clamp(playerGrid.posX, minX, maxX)
        playerGrid:SetPos(playerGrid.posX, 0)
    end

    local buttonRight = vgui.Create("DButton", playerGridHolder)
    buttonRight:Dock(RIGHT)
    buttonRight:SetText(">")
    buttonRight:SetFont("Mono25")
    buttonRight:SetTextColor(Color(225, 225, 225))
    buttonRight.Paint = function(s, w, h)
        surface.SetDrawColor(Color(105, 105, 105, 25))
        surface.SetMaterial(gradRight)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    buttonRight.DoClick = function(s)
        playerGrid.posX = playerGrid.posX - (playerPanelWide + outlineWidth * .5)
        playerGrid.posX = math.Clamp(playerGrid.posX, minX, maxX)
        playerGrid:SetPos(playerGrid.posX, 0)
    end

    local lastThink = RealTime()

    playerGrid.Think = function()
        local a, d = input.IsKeyDown(KEY_A), input.IsKeyDown(KEY_D)
        
        local scrollSpeed = 500  -- Adjust the scroll speed as needed
    
        local currentTime = RealTime()
        local deltaTime = currentTime - lastThink
        lastThink = currentTime
    
        if a then
            playerGrid.posX = playerGrid.posX + scrollSpeed * deltaTime
        end
        if d then
            playerGrid.posX = playerGrid.posX - scrollSpeed * deltaTime
        end
    
        local minX = (parent:GetWide() * .655 - contentWidth + outlineWidth)
        local maxX = 0
        playerGrid.posX = math.Clamp(playerGrid.posX, minX, maxX * 2)
    
        playerGrid:SetPos(playerGrid.posX, 0)
        p.playerGridPos = playerGrid.posX
    end

end

local function openLogsTerminalUI( parent, category )
    local home = vgui.Create("DPanel", parent)
    home:Dock(FILL)
    home.Paint = function(s, w, h) end

    local title = vgui.Create("DLabel", home)
    title:Dock(TOP)
    title:SetText(category.." Logs")
    title:SetFont("Mono50")
    title:SetTall(parent:GetParent():GetTall() * .09)
    title:SetContentAlignment(5)
    title:SetTextColor(Color(255, 255, 255))

    local scroll = vgui.Create("DScrollPanel", home)
    scroll:Dock(FILL)
    scroll:DockMargin(outlineWidth * 2, 0, outlineWidth * 2, outlineWidth * 2 )
    scroll.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45, 0))
    end

    local t = LocalPlayer().departmentTable
    for k, v in SortedPairsByMemberValue( t["logs"], "date", true ) do
        local log = vgui.Create("DPanel", scroll)
        log:Dock(TOP)
        log:SetTall(outlineWidth * 3)
        log:DockMargin(outlineWidth * .5, outlineWidth * .25, outlineWidth * .5, outlineWidth * .25)
        log.type = v["log_type"]
        if log.type == "Withdraw" then
            log.text = v["player_name"] .. " withdrew " .. v["log_var"] .. " for " .. v["department"]
            log.col = ATLAS_DEPTMONEYSYS.LogColours["Withdraw"]
        elseif log.type == "Deposit" then
            log.text = v["player_name"] .. " deposited " .. v["log_var"] .. " for " .. v["department"]
            log.col = ATLAS_DEPTMONEYSYS.LogColours["Deposit"]
        elseif log.type == "Boosts" then
            if string.StartsWith(v["log_var"], "Weapon") then
                log.text = v["player_name"] .. " purchased " .. v["log_var"] .. " for " .. v["team"]
                log.col = ATLAS_DEPTMONEYSYS.LogColours["Weapons"]
            else
                log.text = v["player_name"] .. " purchased " .. v["log_var"] .. " for " .. v["department"]
                log.col = ATLAS_DEPTMONEYSYS.LogColours["Boosts"]
            end
        elseif log.type == "Maintenance" then
            log.text = v["player_name"] .. " paid the maintenance of " .. v["log_var"] .. " for " .. v["department"]
            log.col = ATLAS_DEPTMONEYSYS.LogColours["Maintenance"]
        end
        log.Paint = function(s, w, h)
            local logFont = "Mono18"
            surface.SetFont(logFont)
            local tW, tH = surface.GetTextSize(v["date"])
            draw.RoundedBox(20, 0, 0, w, h, log.col)
            draw.RoundedBoxEx(20, 0, 0, tW + w * .02, h, Color(255, 255, 255), true, false, true, false)
            draw.SimpleText(os.date( "%d/%m/%Y" , v["date"] ), logFont, w * .01, h * .5, Color(20, 20, 20), 0, 1)
            draw.SimpleText(log.text, "Mono20", w * .01 + tW + w * .02, h * .5, Color(255, 255, 255), 0, 1)
        end
    end
end

local depositAmounts = {5000, 10000, 20000, 50000, 100000, 200000, "+/-", "Reset"}

local function openDepositTerminalUI( parent, category )
    local p = LocalPlayer()
    local playerMoney = p:getDarkRPVar("money")

    local deposit = vgui.Create("DPanel", parent)
    deposit:Dock(FILL)
    deposit.Paint = function(s, w, h) end

    local title = vgui.Create("DLabel", deposit)
    title:Dock(TOP)
    title:SetText("Deposit Account Funds")
    title:SetFont("Mono50")
    title:SetTall(parent:GetParent():GetTall() * .09)
    title:SetContentAlignment(5)
    title:SetTextColor(Color(255, 255, 255))

    local internalMain = vgui.Create("DPanel", deposit)
    internalMain:Dock(FILL)
    internalMain:DockMargin(outlineWidth * 2, 0, outlineWidth * 2, outlineWidth * 2 )
    internalMain.Paint = function(s, w, h) end

    local depositContainer = vgui.Create("DPanel", internalMain)
    depositContainer:SetTall(parent:GetParent():GetTall() * .3)
    depositContainer:SetWide(parent:GetParent():GetWide() * .667)
    depositContainer.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225))
    end

    local depositLabel = vgui.Create("DLabel", depositContainer)
    depositLabel:Dock(TOP)
    depositLabel:SetTall(parent:GetParent():GetTall() * .075)
    depositLabel:SetFont("Mono45")
    depositLabel:SetContentAlignment(5)
    depositLabel:SetText("Your Money: " .. DarkRP.formatMoney(playerMoney))
    depositLabel:SetTextColor(Color(25, 25, 25))
    depositLabel.Paint = function(s, w, h) end
    depositLabel.Think = function()
        playerMoney = p:getDarkRPVar("money")
        depositLabel:SetText("Your Money: " .. DarkRP.formatMoney(playerMoney))
    end

    local depositEntry = vgui.Create("DPanel", depositContainer)
    depositEntry:Dock(FILL)
    depositEntry.Paint = function(s, w, h) end
    depositEntry.moneyValue = 0
    depositEntry.value = "+"

    local depositAddButtons = {}
    local buttons = #depositAmounts
    for k, v in ipairs(depositAmounts) do
        depositAddButtons[k] = vgui.Create("DButton", depositEntry)
        depositAddButtons[k]:Dock(LEFT)
        depositAddButtons[k]:SetWide(depositContainer:GetWide() / buttons)
        depositAddButtons[k]:SetTextColor(Color(25, 25, 25))
        depositAddButtons[k]:SetFont("Mono20")
        if v == "+/-" then
            depositAddButtons[k]:SetText(v)
            depositAddButtons[k].DoClick = function()
                depositEntry.value = depositEntry.value == "+" and "-" or "+"
            end
        elseif v == "Reset" then
            depositAddButtons[k]:SetText(v)
            depositAddButtons[k].DoClick = function()
                depositEntry.moneyValue = 0
            end
        else
            depositAddButtons[k]:SetText(depositEntry.value..DarkRP.formatMoney(v))
            depositAddButtons[k].DoClick = function()
                if depositEntry.value == "+" then
                    depositEntry.moneyValue = (depositEntry.moneyValue + v) >= playerMoney and playerMoney or depositEntry.moneyValue + v
                elseif depositEntry.value == "-" then
                    depositEntry.moneyValue = (depositEntry.moneyValue - v) > 0  and depositEntry.moneyValue - v or 0
                end
            end
            depositAddButtons[k].Think = function()
                depositAddButtons[k]:SetText(depositEntry.value..DarkRP.formatMoney(v))
            end
        end
        depositAddButtons[k].Paint = function(s, w, h) 
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(205, 205, 205))
            end
        end
    end


    local depositConfirm = vgui.Create("DButton", depositContainer)
    depositConfirm:Dock(BOTTOM)
    depositConfirm:SetTall(parent:GetParent():GetTall() * .075)
    depositConfirm:SetContentAlignment(5)
    depositConfirm:SetFont("Mono35")
    depositConfirm:SetTextColor(Color(25, 25, 25))
    depositConfirm.Think = function(s, w, h)
        depositConfirm:SetText("Deposit: " .. DarkRP.formatMoney(depositEntry.moneyValue))
    end
    depositConfirm.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(220, 220, 220))
        end
    end
    depositConfirm.DoClick = function()
        if depositEntry.moneyValue < 5000 then return end
        local amount = depositEntry.moneyValue
        net.Start("sv_update_money_sys_terminal_withdraw_deposit")
            net.WriteInt(amount, 32)
        net.SendToServer()
    end
end

local function openWidthdrawTerminalUI( parent, category )
    local p = LocalPlayer()
    local deposit = vgui.Create("DPanel", parent)
    deposit:Dock(FILL)
    deposit.Paint = function(s, w, h) end

    local title = vgui.Create("DLabel", deposit)
    title:Dock(TOP)
    title:SetText("Withdraw Account Funds")
    title:SetFont("Mono50")
    title:SetTall(parent:GetParent():GetTall() * .09)
    title:SetContentAlignment(5)
    title:SetTextColor(Color(255, 255, 255))

    local internalMain = vgui.Create("DPanel", deposit)
    internalMain:Dock(FILL)
    internalMain:DockMargin(outlineWidth * 2, 0, outlineWidth * 2, outlineWidth * 2 )
    internalMain.Paint = function(s, w, h) end

    local depositContainer = vgui.Create("DPanel", internalMain)
    depositContainer:SetTall(parent:GetParent():GetTall() * .3)
    depositContainer:SetWide(parent:GetParent():GetWide() * .667)
    depositContainer.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225))
    end

    local depositLabel = vgui.Create("DLabel", depositContainer)
    depositLabel:Dock(TOP)
    depositLabel:SetTall(parent:GetParent():GetTall() * .075)
    depositLabel:SetFont("Mono45")
    depositLabel:SetContentAlignment(5)
    depositLabel:SetText("Current Funds: " .. DarkRP.formatMoney(tonumber(p.departmentTable["money"])))
    depositLabel:SetTextColor(Color(25, 25, 25))
    depositLabel.Paint = function(s, w, h) end
    depositLabel.Think = function()
        playerMoney = p:getDarkRPVar("money")
        depositLabel:SetText("Current Funds: " .. DarkRP.formatMoney(tonumber(p.departmentTable["money"])))
    end

    local depositEntry = vgui.Create("DPanel", depositContainer)
    depositEntry:Dock(FILL)
    depositEntry.Paint = function(s, w, h) end
    depositEntry.moneyValue = 0
    depositEntry.value = "+"

    local depositAddButtons = {}
    local buttons = #depositAmounts
    for k, v in ipairs(depositAmounts) do
        depositAddButtons[k] = vgui.Create("DButton", depositEntry)
        depositAddButtons[k]:Dock(LEFT)
        depositAddButtons[k]:SetWide(depositContainer:GetWide() / buttons)
        depositAddButtons[k]:SetTextColor(Color(25, 25, 25))
        depositAddButtons[k]:SetFont("Mono20")
        if v == "+/-" then
            depositAddButtons[k]:SetText(v)
            depositAddButtons[k].DoClick = function()
                depositEntry.value = depositEntry.value == "+" and "-" or "+"
            end
        elseif v == "Reset" then
            depositAddButtons[k]:SetText(v)
            depositAddButtons[k].DoClick = function()
                depositEntry.moneyValue = 0
            end
        else
            depositAddButtons[k]:SetText(depositEntry.value..DarkRP.formatMoney(v))
            depositAddButtons[k].DoClick = function()
                local p = LocalPlayer()
                local max = tonumber(p.departmentTable["money"])
                if depositEntry.value == "+" then
                    depositEntry.moneyValue = (depositEntry.moneyValue + v) <= max and depositEntry.moneyValue + v or max
                elseif depositEntry.value == "-" then
                    depositEntry.moneyValue = (depositEntry.moneyValue - v) > 0  and depositEntry.moneyValue - v or 0
                end
            end
            depositAddButtons[k].Think = function()
                depositAddButtons[k]:SetText(depositEntry.value..DarkRP.formatMoney(v))
            end
        end
        depositAddButtons[k].Paint = function(s, w, h) 
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(205, 205, 205))
            end
        end
    end


    local depositConfirm = vgui.Create("DButton", depositContainer)
    depositConfirm:Dock(BOTTOM)
    depositConfirm:SetTall(parent:GetParent():GetTall() * .075)
    depositConfirm:SetContentAlignment(5)
    depositConfirm:SetFont("Mono35")
    depositConfirm:SetTextColor(Color(25, 25, 25))
    depositConfirm.Think = function(s, w, h)
        depositConfirm:SetText("Withdraw: " .. DarkRP.formatMoney(depositEntry.moneyValue))
    end
    depositConfirm.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        else
            draw.RoundedBox(0, 0, 0, w, h, Color(220, 220, 220))
        end
    end
    depositConfirm.DoClick = function()
        if depositEntry.moneyValue <= 0 then return end
        local amount = depositEntry.moneyValue
        net.Start("sv_update_money_sys_terminal_withdraw_deposit")
            net.WriteInt(-amount, 32)
        net.SendToServer()
    end
end

local function generateShipmentWeaponUI( parent, parent_, job )

    local p = LocalPlayer()
    local boostsTable = p.departmentTable["boosts"]
    local curWeaponBoosts = {}

    for k, v in pairs(LEVEL.GetOwnedWeps()) do
        curWeaponBoosts[k] = v
    end

    local wepTable = getAvailableWeapons(job)
    
    local wepPanelWide = parent:GetWide() * 0.2
    local wepQuantity = table.Count(wepTable)
    local contentWidth = wepQuantity * (wepPanelWide + outlineWidth * 0.5)
    local scrollSpeed = 5  -- Adjust the scroll speed as needed
    local minX = (parent:GetWide() - contentWidth + outlineWidth)
    local maxX = 0
    local center = (minX * .5)
    
    local weaponGrid = vgui.Create("DPanel", parent_)
    weaponGrid:SetPos(p.weaponGridPos and p.weaponGridPos or center, 0)
    weaponGrid:SetSize(contentWidth, parent:GetTall() * .4)
    weaponGrid.posX = p.weaponGridPos and p.weaponGridPos or center
    weaponGrid:SetDrawBackground(false)
    
    local wepPanels = {}
    local modelPanels = {}
    local buttonPanels = {}
    local repetition = 0
    for _, v in ipairs(wepTable) do
        local weaponId = v.weapon
        wepPanels[weaponId] = vgui.Create("Panel", weaponGrid)
        wepPanels[weaponId]:SetPos(repetition * (wepPanelWide + outlineWidth * .5))
        wepPanels[weaponId]:SetSize(wepPanelWide, parent:GetTall() * .4)
        wepPanels[weaponId].Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25))
            draw.SimpleText(weaponId, "Mono20", w * .5, h * .125, Color(225, 225, 225), 1, 1)
        end
    
        modelPanels[weaponId] = vgui.Create("DModelPanel", wepPanels[weaponId])
        modelPanels[weaponId]:Dock(FILL)
        local worldModelPath = weapons.Get(weaponId)["WorldModel"]
        modelPanels[weaponId]:SetModel(worldModelPath)
        modelPanels[weaponId].LayoutEntity = function(s, ent)
            if not IsValid(ent) then return end  -- Check if the entity is valid
    
            -- Set the camera position and angles manually
            local center = ent:OBBCenter()
            local dist = ent:OBBCenter().z - ent:OBBMins().z
            s:SetCamPos(center - Vector(-20, 0, 0))
            s:SetLookAt(center)
    
            -- Adjust the model's position and angles to fit within the panel
            local scale = Vector(1, 1, 1)
            local mins, maxs = ent:GetRenderBounds()
            local size = maxs - mins
            local maxsize = math.max(size.x, size.y, size.z)
            local w, h = wepPanels[weaponId]:GetWide(), wepPanels[weaponId]:GetTall()
            if maxsize > w or maxsize > h then
                scale = scale * math.min(w / size.x, h / size.y)
            end
    
            ent:SetPos(center - size * 0.5 * scale)
            ent:SetAngles(Angle(0, 90, 0))
        end
    
        buttonPanels[weaponId] = vgui.Create("DButton", wepPanels[weaponId])
        buttonPanels[weaponId]:Dock(BOTTOM)
        buttonPanels[weaponId]:SetTall(outlineWidth * 5)
        buttonPanels[weaponId]:SetText("")
        buttonPanels[weaponId].Paint = function(s, w, h)
            if curWeaponBoosts[job] == weaponId then
                if s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(25, 155, 25))
                else
                    draw.RoundedBox(0, 0, 0, w, h, Color(55, 205, 55))
                end
                draw.SimpleText("Currently Active", "Mono15", w * .5, h * .2, Color(255, 255, 255), 1, 1)
                draw.SimpleText("Purchased", "Mono25", w * .5, h * .6, Color(255, 255, 255), 1, 1)
            else
                local canI, neededLevel = LEVEL.CanIBuyWeapon(weaponId)
                if not canI then
                    draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 200))
                    draw.SimpleText("Insufficient Level", "Mono15", w * .5, h * .2, Color(255, 255, 255), 1, 1)
                    draw.SimpleText("Need Level "..neededLevel, "Mono25", w * .5, h * .6, Color(255, 255, 255), 1, 1)
                    return
                end
                if s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(155, 25, 25))
                else
                    draw.RoundedBox(0, 0, 0, w, h, Color(205, 55, 55))
                end
                

                draw.SimpleText("Click here to purchase", "Mono15", w * .5, h * .2, Color(255, 255, 255), 1, 1)
                draw.SimpleText(DarkRP.formatMoney(v.price), "Mono25", w * .5, h * .6, Color(255, 255, 255), 1, 1)
            end
        end
        buttonPanels[weaponId].DoClick = function()
            if curWeaponBoosts[job] == weaponId then return end
            if not LEVEL.CanIBuyWeapon(weaponId) then return end
            net.Start("LEVEL::WEAPON:LOGIC::BUY")
                net.WriteString(weaponId)
            net.SendToServer()
            -- close ui
            CL_ATLAS_DEPTMONEYSYS.MainFrame:Close()
        end
    
        repetition = repetition + 1
    end
    

    local buttonLeft = vgui.Create("DButton", parent_)
    buttonLeft:Dock(LEFT)
    buttonLeft:SetFont("Mono25")
    buttonLeft:SetText("<")
    buttonLeft:SetTextColor(Color(225, 225, 225))
    buttonLeft.Paint = function(s, w, h)
        surface.SetDrawColor(Color(105, 105, 105, 25))
        surface.SetMaterial(gradLeft)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    buttonLeft.DoClick = function(s)
        weaponGrid.posX = weaponGrid.posX + (wepPanelWide + outlineWidth * .5)
        weaponGrid.posX = math.Clamp(weaponGrid.posX, minX, maxX)
        weaponGrid:SetPos(weaponGrid.posX, 0)
    end

    local buttonRight = vgui.Create("DButton", parent_)
    buttonRight:Dock(RIGHT)
    buttonRight:SetText(">")
    buttonRight:SetFont("Mono25")
    buttonRight:SetTextColor(Color(225, 225, 225))
    buttonRight.Paint = function(s, w, h)
        surface.SetDrawColor(Color(105, 105, 105, 25))
        surface.SetMaterial(gradRight)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    buttonRight.DoClick = function(s)
        weaponGrid.posX = weaponGrid.posX - (wepPanelWide + outlineWidth * .5)
        weaponGrid.posX = math.Clamp(weaponGrid.posX, minX, maxX)
        weaponGrid:SetPos(weaponGrid.posX, 0)
    end

    local lastThink = RealTime()

    weaponGrid.Think = function()
        local a, d = input.IsKeyDown(KEY_A), input.IsKeyDown(KEY_D)
        
        local scrollSpeed = 500  -- Adjust the scroll speed as needed
    
        local currentTime = RealTime()
        local deltaTime = currentTime - lastThink
        lastThink = currentTime
    
        if a then
            weaponGrid.posX = weaponGrid.posX + scrollSpeed * deltaTime
        end
        if d then
            weaponGrid.posX = weaponGrid.posX - scrollSpeed * deltaTime
        end
    
        local minX = (parent:GetWide() - contentWidth + outlineWidth)
        local maxX = 0
        weaponGrid.posX = math.Clamp(weaponGrid.posX, minX, maxX)
    
        weaponGrid:SetPos(weaponGrid.posX, 0)
        p.weaponGridPos = weaponGrid.posX
    end

end

local function openShipmentTerminalUI( parent, category )

    local p = LocalPlayer()
    local boostsTable = p.departmentTable["boosts"]
    local curVitalityBoost
    local curArmorBoost

    for k, v in pairs(boostsTable) do
        if v["boost_type"] == "Vitality" then
            curVitalityBoost = tonumber(v["boost_arg"])
            continue
        end
        if v["boost_type"] == "Armor" then
            curArmorBoost = tonumber(v["boost_arg"])
            continue
        end
    end

    local shipment = vgui.Create("DPanel", parent)
    shipment:Dock(FILL)
    shipment.Paint = function(s, w, h) end

    local title = vgui.Create("DLabel", shipment)
    title:Dock(TOP)
    title:SetText("Manage Boosts")
    title:SetFont("Mono50")
    title:SetTall(parent:GetParent():GetTall() * .09)
    title:SetContentAlignment(5)
    title:SetTextColor(Color(255, 255, 255))

    local internalMain = vgui.Create("DPanel", shipment)
    internalMain:Dock(FILL)
    internalMain:DockMargin(outlineWidth * 2, 0, outlineWidth * 2, outlineWidth * 2 )
    internalMain.Paint = function(s, w, h) end

    local shipmentContainer = vgui.Create("DPanel", internalMain)
    shipmentContainer:SetTall(parent:GetParent():GetTall() * .733)
    shipmentContainer:SetWide(parent:GetParent():GetWide() * .667)
    shipmentContainer.Paint = function(s, w, h) 
        
    end

    local parent = shipmentContainer

    local weaponContainer = vgui.Create("DPanel", parent)
    weaponContainer:Dock(BOTTOM)
    weaponContainer:DockMargin(0, outlineWidth * .5, 0, 0)
    weaponContainer:SetTall(parent:GetTall() * .5)
    weaponContainer.Paint = function(s, w, h) 
    end

    local vitContainer = vgui.Create("DPanel", parent)
    vitContainer:Dock(LEFT)
    vitContainer:DockMargin(0, 0, outlineWidth * .5, outlineWidth * .5)
    vitContainer:DockPadding(outlineWidth * .5, outlineWidth * .5, outlineWidth * .5, outlineWidth * .5)
    vitContainer:SetWide(parent:GetWide() * .5 - outlineWidth * .5)
    vitContainer.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225))
    end

    local vitTitle = vgui.Create("DPanel", vitContainer)
    vitTitle:Dock(TOP)
    vitTitle:DockMargin(0, 0, 0, 0)
    vitTitle:SetTall( parent:GetTall() * .1 )
    vitTitle.Paint = function(s, w, h)
        local font = "Mono25"
        local text = "Vitality Upgrades"
        surface.SetFont(font)
        surface.SetDrawColor(Color(25, 25, 25))
        local textWidth, textHeight = surface.GetTextSize(text)
        draw.SimpleText(text, font, w * .5, h * .25, Color(25, 25, 25), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0, w * .5 - textWidth * .5, h * .25 + textHeight * .52, textWidth, textHeight * .1, Color(25, 25, 25))
        draw.SimpleText("Department members will gain a health buff until the month is over.", "Mono15", w * .5, h * .75, Color(25, 25, 25), 1, 1)
    end

    for k, v in ipairs(ATLAS_DEPTMONEYSYS.VitalityUpgrades) do
        local vitOption = vgui.Create("DButton", vitContainer)
        vitOption:SetText("")
        vitOption:Dock(TOP)
        vitOption:SetTall(outlineWidth * 5)
        vitOption:DockMargin(0, outlineWidth * .5, 0, outlineWidth * .5)
        vitOption.Paint = function(s, w, h)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25))
            end
            draw.SimpleText("V" .. k .. ": " .. v[1] .. "HP " .. DarkRP.formatMoney(v[2]), "Mono25", w * .5, h * .5, Color(225, 225, 225), 1, 1)

            if curVitalityBoost and curVitalityBoost == k then
                local col = Color(15, 205, 15)
                local font = "Mono40"
                local text = "PURCHASED"
                surface.SetDrawColor(col)
                surface.SetFont(font)
                local tW, tH = surface.GetTextSize(text)
                surface.DrawOutlinedRect( w * .5 - tW * .55, h * .5 - tH * .55, tW * 1.1, tH * 1.1, 2 )
                draw.SimpleTextOutlined(text, font, w * .5, h * .5, Color(15, 205, 15), 1, 1, 1, Color(25, 25, 25))
            end
        end
        vitOption.DoClick = function()
            if curVitalityBoost and curVitalityBoost >= k then return end
            net.Start("sv_update_money_sys_terminal_boost_purchase")
                net.WriteTable({v[3], k})
            net.SendToServer()
        end
    end

    armContainer = vgui.Create("DPanel", parent)
    armContainer:Dock(RIGHT)
    armContainer:DockMargin(outlineWidth * .5, 0, 0, outlineWidth * .5)
    armContainer:DockPadding(outlineWidth * .5, outlineWidth * .5, outlineWidth * .5, outlineWidth * .5)
    armContainer:SetWide(parent:GetWide() * .5 - outlineWidth * .5)
    armContainer.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225))
    end

    local armTitle = vgui.Create("DPanel", armContainer)
    armTitle:Dock(TOP)
    armTitle:DockMargin(0, 0, 0, 0)
    armTitle:SetTall( parent:GetTall() * .1 )
    armTitle.Paint = function(s, w, h)
        local font = "Mono25"
        local text = "Armor Upgrades"
        surface.SetFont(font)
        surface.SetDrawColor(Color(25, 25, 25))
        local textWidth, textHeight = surface.GetTextSize(text)
        draw.SimpleText(text, font, w * .5, h * .25, Color(25, 25, 25), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0, w * .5 - textWidth * .5, h * .25 + textHeight * .52, textWidth, textHeight * .1, Color(25, 25, 25))
        draw.SimpleText("Department members will gain an armor buff until the month is over.", "Mono15", w * .5, h * .75, Color(25, 25, 25), 1, 1)
    end

    for k, v in ipairs(ATLAS_DEPTMONEYSYS.ArmorUpgrades) do
        local armOption = vgui.Create("DButton", armContainer)
        armOption:SetText("")
        armOption:Dock(TOP)
        armOption:SetTall(outlineWidth * 5)
        armOption:DockMargin(0, outlineWidth * .5, 0, outlineWidth * .5)
        armOption.Paint = function(s, w, h)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25))
            end
            draw.SimpleText("V" .. k .. ": " .. v[1] .. "AP " .. DarkRP.formatMoney(v[2]), "Mono25", w * .5, h * .5, Color(225, 225, 225), 1, 1)

            if curArmorBoost and curArmorBoost == k then
                local col = Color(15, 205, 15)
                local font = "Mono40"
                local text = "PURCHASED"
                surface.SetDrawColor(col)
                surface.SetFont(font)
                local tW, tH = surface.GetTextSize(text)
                surface.DrawOutlinedRect( w * .5 - tW * .55, h * .5 - tH * .55, tW * 1.1, tH * 1.1, 2 )
                draw.SimpleTextOutlined(text, font, w * .5, h * .5, Color(15, 205, 15), 1, 1, 1, Color(25, 25, 25))
            end
        end
        armOption.DoClick = function()
            if curArmorBoost and curArmorBoost >= k then return end
            net.Start("sv_update_money_sys_terminal_boost_purchase")
                net.WriteTable({v[3], k})
            net.SendToServer()
        end
    end
end

local function openPersonalWepUI( parent, category)
    local p = LocalPlayer()
    local shipment = vgui.Create("DPanel", parent)
    shipment:Dock(FILL)
    shipment.Paint = function(s, w, h) end

    local title = vgui.Create("DLabel", shipment)
    title:Dock(TOP)
    title:SetText("Manage Weapons")
    title:SetFont("Mono50")
    title:SetTall(parent:GetParent():GetTall() * .09)
    title:SetContentAlignment(5)
    title:SetTextColor(Color(255, 255, 255))

    local internalMain = vgui.Create("DPanel", shipment)
    internalMain:Dock(FILL)
    internalMain:DockMargin(outlineWidth * 2, 0, outlineWidth * 2, outlineWidth * 2 )
    internalMain.Paint = function(s, w, h) end

    local shipmentContainer = vgui.Create("DPanel", internalMain)
    shipmentContainer:SetTall(parent:GetParent():GetTall() * .733)
    shipmentContainer:SetWide(parent:GetParent():GetWide() * .667)
    shipmentContainer.Paint = function(s, w, h) 
        --draw.SimpleText("Choose a department from the dropdown above", "Mono25", w*.5, h*.6, Color(225, 225, 225), 1, 1)
    end

    local parent = shipmentContainer

    local weaponContainer = vgui.Create("DPanel", parent)
    weaponContainer:Dock(TOP)
    weaponContainer:DockMargin(0, outlineWidth * .5, 0, 0)
    weaponContainer:SetTall(parent:GetTall() * .5)
    weaponContainer.Paint = function(s, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(225, 225, 225))
    end

    local title = vgui.Create("DPanel", weaponContainer)
    title:Dock(TOP)
    title:SetTall( parent:GetTall() * .1 )
    title.Paint = function(s, w, h)
        local font = "Mono25"
        local text = "Weapon Upgrades"
        surface.SetFont(font)
        surface.SetDrawColor(Color(25, 25, 25))
        local textWidth, textHeight = surface.GetTextSize(text)
        draw.SimpleText(text, font, w * .5, h * .25, Color(25, 25, 25), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0, w * .5 - textWidth * .5, h * .25 + textHeight * .52, textWidth, textHeight * .1, Color(25, 25, 25))
        draw.SimpleText("You can purchase a weapon", "Mono15", w * .5, h * .75, Color(25, 25, 25), 1, 1)
    end


    local weaponGridHolder = vgui.Create("DPanel", weaponContainer)
    weaponGridHolder:Dock(FILL)
    weaponGridHolder:SetDrawBackground(false)

    --generateShipmentWeaponUI( parent, weaponGridHolder, p.weaponActiveTeam and p.weaponActiveTeam or t[1] )

    weaponGridHolder:Clear()
    weaponGridHolder:InvalidateLayout()
    generateShipmentWeaponUI( parent, weaponGridHolder, p:Team() )
    p.weaponActiveTeam = value
end

local function openSiteDirectorMaintenance( parent )
    local p = LocalPlayer()
    local sizingParent = parent:GetParent():GetParent()
    local title = vgui.Create("DPanel", parent)
    title:Dock(TOP)
    title:SetTall(sizingParent:GetTall() * .25)
    title.Paint = function(s, w, h)
        draw.RoundedBox(16, 0, 0, w, h, Color(200, 200, 200, 255))
        draw.SimpleText(DarkRP.formatMoney(ATLAS_DEPTMONEYSYS.fixedSiteDirectorFee), "Mono50", w * .5, h * .4, Color(25, 25, 25), 1, 1)
        draw.SimpleText("Maintenance for the month is required as soon as possible!", "Mono30", w * .5, h * .1, Color(35, 35, 35), 1, 1)
    end

    local button = vgui.Create("DButton", title)
    button:Dock(BOTTOM)
    button:SetTall(sizingParent:GetTall() * .075)
    button:SetText("PAY NOW")
    button:SetFont("Mono35")
    button:DockMargin(sizingParent:GetWide() * .3, 0, sizingParent:GetWide() * .3, outlineWidth)

    button.Think = function()
        if p.departmentTable["money"] < ATLAS_DEPTMONEYSYS.fixedSiteDirectorFee then
            button:SetEnabled(false)
            button:SetTextColor(Color(34, 168, 65))
            button:SetText("NO PAYMENT DUE")
        else
            button:SetEnabled(true)
            button:SetText("PAY NOW")
            button:SetColor(Color(31, 31, 31))
            button.Think = function() end
        end
    end

    -- on button press prompt with confirmation and if so send sv_pay_dept_maintain
    button.isConfirmation = false
    button.DoClick = function()
        -- turn this button into the confirmation button
        if !button.isConfirmation then
            button:SetText("CONFIRM")
            button.isConfirmation = true
            button:SetTextColor(Color(235, 59, 59))
            return
        end
        net.Start("sv_pay_dept_maintain")
        net.SendToServer()
        button:SetText("PAYMENT DISPATCHED")
        button:SetTextColor(Color(217, 148, 58))
        button:SetEnabled(false)
    end

    local statTable = {}
    for k, v in pairs(p.departmentTable["allhours"]) do
        if k == "SITE COMMAND" or k == "COMMAND INSURGENTS" then continue end
        statTable[k] = v
    end

    local tableHeight = sizingParent:GetTall() * .25
    local tableWidth = sizingParent:GetWide() * .5
    local increments = tableHeight / table.Count(statTable)
    local maxWide = 1750
    local widthIncrements = tableWidth / maxWide

    local maintenancePanel = vgui.Create("DPanel", parent)
    maintenancePanel:Dock(FILL)
    maintenancePanel:DockMargin(0, outlineWidth, 0, 0)
    maintenancePanel.Paint = function(s, w, h)
        draw.RoundedBox(16, 0, 0, w, h, Color(35, 35, 35))

        draw.RoundedBox(0, w * .2, h * .25 - tableHeight * .5, w * .005, tableHeight, Color(205, 205, 205))

        local iteration = 1
        local hours

        for k, v in pairs(statTable) do
            hours = v
            if v > maxWide then 
                v = maxWide
            end
            draw.SimpleText(k, "Mono15", w * .19, h * .25 - tableHeight * .5 + ((increments * iteration) - (increments * .5)), Color(205, 205, 205), 2, 1 )
            draw.RoundedBox(0, w * .2, h * .25 - tableHeight * .5 + ((increments * iteration) - (increments * .5) - ((h * .05) / 2)), v * widthIncrements, h * .05, Color(205, 205, 205))
            draw.SimpleText(hours .. " Hours (Suggested: " .. DarkRP.formatMoney(ATLAS_DEPTMONEYSYS.suggestedMaintenanceBasedonHours * hours) .. ")", "Mono15", (w * .205 + v * widthIncrements), h * .25 - tableHeight * .5 + ((increments * iteration) - (increments * .4) - ((h * .05) / 2)), Color(205, 205, 205))
            iteration = iteration + 1
        end

        draw.RoundedBox(0, 0, h * .5, w, outlineWidth * .5, Color(205, 205, 205))

    end
end

local function openDepartmentMaintanence( parent )
    net.Start("sv_dept_maintenance_get_due")
    net.SendToServer()
    local p = LocalPlayer()
    local sizingParent = parent:GetParent():GetParent()
    local title = vgui.Create("DPanel", parent)
    title:Dock(TOP)
    title:SetTall(sizingParent:GetTall() * .25)
    title.Paint = function(s, w, h)
        draw.RoundedBox(16, 0, 0, w, h, Color(200, 200, 200, 255))
        draw.SimpleText(DarkRP.formatMoney(myDeptDues), "Mono50", w * .5, h * .4, Color(25, 25, 25), 1, 1)
        draw.SimpleText("Maintenance for the month is required as soon as possible!", "Mono30", w * .5, h * .1, Color(35, 35, 35), 1, 1)
    end

    local button = vgui.Create("DButton", title)
    button:Dock(BOTTOM)
    button:SetTall(sizingParent:GetTall() * .075)
    button:SetText("PAY NOW")
    button:SetColor(Color(31, 31, 31))
    button:SetFont("Mono35")
    button:DockMargin(sizingParent:GetWide() * .3, 0, sizingParent:GetWide() * .3, outlineWidth)
    button.Think = function()
        if myDeptDues == 0 then
            button:SetEnabled(false)
            button:SetTextColor(Color(34, 168, 65))
            button:SetText("NO PAYMENT DUE")
        else
            button:SetEnabled(true)
            button:SetText("PAY NOW")
            button:SetColor(Color(31, 31, 31))
            button.Think = function() end
        end
    end

    -- on button press prompt with confirmation and if so send sv_pay_dept_maintain
    button.isConfirmation = false
    button.DoClick = function()
        -- turn this button into the confirmation button
        if !button.isConfirmation then
            button:SetText("CONFIRM")
            button.isConfirmation = true
            button:SetTextColor(Color(235, 59, 59))
            return
        end
        net.Start("sv_pay_dept_maintain")
        net.SendToServer()
        button:SetText("PAYMENT DISPATCHED")
        button:SetTextColor(Color(217, 148, 58))
        button:SetEnabled(false)
    end

end

local function openMaintenanceTerminalUI( parent, category )

    local p = LocalPlayer()
    local job = p:getDarkRPVar("job")

    local maintenance = vgui.Create("DPanel", parent)
    maintenance:Dock(FILL)
    maintenance.Paint = function(s, w, h) end

    local title = vgui.Create("DLabel", maintenance)
    title:Dock(TOP)
    title:SetText("Manage Maintenance Fees")
    title:SetFont("Mono50")
    title:SetTall(parent:GetParent():GetTall() * .09)
    title:SetContentAlignment(5)
    title:SetTextColor(Color(255, 255, 255))

    local internalMain = vgui.Create("DPanel", maintenance)
    internalMain:Dock(FILL)
    internalMain:DockMargin(outlineWidth * 2, 0, outlineWidth * 2, outlineWidth * 2 )
    internalMain:SetDrawBackground(false)

    if job == "Site Director" then
        openSiteDirectorMaintenance( internalMain )
    else
        openDepartmentMaintanence( internalMain )
    end
    
end

CL_ATLAS_DEPTMONEYSYS = CL_ATLAS_DEPTMONEYSYS or {}
CL_ATLAS_DEPTMONEYSYS.sideTabs = {}
CL_ATLAS_DEPTMONEYSYS.sideTabs[1] = {title = "Home", public = true, panel = openHomeTerminalUI}
CL_ATLAS_DEPTMONEYSYS.sideTabs[2] = {title = "Logs", public = true, panel = openLogsTerminalUI}
CL_ATLAS_DEPTMONEYSYS.sideTabs[3] = {title = "Deposit", public = false, panel = openDepositTerminalUI}
CL_ATLAS_DEPTMONEYSYS.sideTabs[4] = {title = "Withdraw", public = false, panel = openWidthdrawTerminalUI}
CL_ATLAS_DEPTMONEYSYS.sideTabs[5] = {title = "Boosts", public = false, panel = openShipmentTerminalUI}
CL_ATLAS_DEPTMONEYSYS.sideTabs[6] = {title = "Personal Weapons", public = false, panel = openPersonalWepUI}
CL_ATLAS_DEPTMONEYSYS.sideTabs[7] = {title = "Maintenance", public = false, panel = openMaintenanceTerminalUI}
    --[[
        ATLAS_DEPTMONEYSYS.serverCategorys = { // Categories of people that can view/use the menu
            ["GENSEC"] = true,
            ["NINE-TAILED FOX"] = true,
            ["MEDICAL STAFF EX"] = true,
            ["RESEARCH AGENCY EX"] = true,
            ["EPSILON-6"] = true,
            ["DEBUGGERS"] = true,
            ["COMMAND INSURGENTS"] = true,
            ["SITE COMMAND"] = true,
        }
        ATLAS_DEPTMONEYSYS.SharedBoosts = {
            ["RESEARCH AGENCY"] = "RESEARCH AGENCY EX",
            ["MEDICAL STAFF"] = "MEDICAL STAFF EX"
        }

    ]]
    CL_ATLAS_DEPTMONEYSYS.MainFrame = false 
local function openMoneySysTerminalUI()

    local p = IsValid(LocalPlayer()) and LocalPlayer()
    if !IsValid(p) then return end
    local job = p:getDarkRPVar("job")
    local category = p:getJobCategory()
    p.deptMoneyActivePanel = 1
    if p.activeDepartment != category then
        p.weaponActiveTeam = nil
    end
    p.activeDepartment = category
    local hasAccess = p:canModifyMoneySystem() // Client chooses if it draws certain things, we will always check on the server before updating anything
    local perms = hasAccess and "Access Authorised" or "Insufficient Permissions" // Dispays correct text at top of screen based on perms

    local mainFrame = vgui.Create("DFrame")
    mainFrame:SetSize(sw, sh)
    mainFrame:Center()
    mainFrame:MakePopup()
    mainFrame:SetDraggable(false)
    mainFrame:SetTitle("")
    CL_ATLAS_DEPTMONEYSYS.MainFrame = mainFrame
    mainFrame.Paint = function(s, w, h)
        
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 195))
        draw_Blur(s, 5)

        surface.SetMaterial(atlasLogo)
        surface.SetDrawColor(Color(255, 255, 255))
        surface.DrawTexturedRect( w * .5 - logoW * .5, h * .92 - logoH * .5, logoW, logoH)
    end
    mainFrame.OnClose = function()
        net.Start("sv_server_notify_of_menu_closure")
        net.SendToServer()
    end

    local mainPanel = vgui.Create("DPanel", mainFrame)
    mainPanel:SetSize(sw * .6, sh * .7)
    mainPanel:SetPos(sw * .2, sh * .15)
    mainPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
    end

    --[[
        TOP PANEL CODE 
    ]]

    local headerPanel = vgui.Create("DPanel", mainPanel)
    headerPanel:Dock(TOP)
    headerPanel:SetTall(mainPanel:GetTall() * .15)
    headerPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 255))

        surface.SetDrawColor(55, 55, 55, 75)
        surface.SetMaterial(gradLeft)
        surface.DrawTexturedRect(0, 0, w * .5, h)

        surface.SetDrawColor(55, 55, 55, 75)
        surface.SetMaterial(gradRight)
        surface.DrawTexturedRect(w * .5, 0, w * .5, h)
        
        draw.RoundedBox(0, 0, h - outlineWidth, w, outlineWidth, Color(225, 225, 225, 255))
    end

    local hamBank = vgui.Create("DPanel", headerPanel)
    hamBank:Dock(LEFT)
    hamBank:SetWide(mainPanel:GetWide() * .2)
    hamBank.Paint = function(s, w, h)   
        draw.SimpleText("HAMBANK", "Mono70", w * .5 - outlineWidth * .5, h * .5 - outlineWidth * .5, Color(255, 255, 255), 1, 1)
    end

    local hamBankInfo = vgui.Create("DPanel", headerPanel)
    hamBankInfo:Dock(FILL)
    hamBankInfo.Paint = function(s, w, h)   
        draw.SimpleText(category, "Mono50", w - w * .015, h * .2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, 1)
        draw.SimpleText(perms, "Mono20", w - w * .015, h * .45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, 1)
        draw.SimpleText("Total: " .. DarkRP.formatMoney(tonumber(p.departmentTable["money"])) , "Mono40", w - w * .015, h * .7, Color(255, 255, 255), TEXT_ALIGN_RIGHT, 1)
    end

    --[[
        SIDE PANEL CODE
    ]]

    local sidePanel = vgui.Create("DPanel", mainPanel)
    sidePanel:Dock(LEFT)
    sidePanel:SetWide(mainPanel:GetWide() * .3)
    sidePanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 255))
        draw.RoundedBox(0, w - outlineWidth, 0, outlineWidth, h, Color(225, 225, 225, 255))
    end

    local windowPanel = vgui.Create("DPanel", mainPanel)
    windowPanel:Dock(FILL)
    windowPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 255))
    end
    windowPanel.updateContent = function()
        windowPanel:Clear()
        windowPanel:InvalidateLayout()
    end
    windowPanel.Think = function()
        if p.hasMoneyTableUpdated then
            windowPanel.updateContent()
            CL_ATLAS_DEPTMONEYSYS.sideTabs[p.deptMoneyActivePanel].panel(windowPanel, category)
        end
        p.hasMoneyTableUpdated = false
    end

    CL_ATLAS_DEPTMONEYSYS.sideTabs[1].panel(windowPanel, category)

    local tabs = {}
    for k, v in ipairs(CL_ATLAS_DEPTMONEYSYS.sideTabs) do
        local isPublic = v.public
        local isDeposit = v.title == "Deposit" 
        local isWithdraw = v.title == "Withdraw"
        local isMaintenance = v.title == "Maintenance"
        local isShipment = v.title == "Boosts"
        if !isPublic and isWithdraw and !ATLAS_DEPTMONEYSYS.AllowedWithdrawTeams[job] then continue end
        --if !isPublic and isDeposit and !ATLAS_DEPTMONEYSYS.AllowedDepositTeams[job] then continue end
        if !isPublic and isMaintenance and !ATLAS_DEPTMONEYSYS.AllowedMaintenanceTeams[job] then continue end
        if !isPublic and isShipment and !ATLAS_DEPTMONEYSYS.AllowedShipmentTeams[job] then continue end

        local dock = isMaintenance and BOTTOM or TOP
        tabs[k] = vgui.Create("DButton", sidePanel)
        tabs[k]:SetTall(mainPanel:GetTall() * .1)
        tabs[k]:SetText("")
        tabs[k]:DockMargin(0, 0, outlineWidth, 0)
        
        tabs[k]:Dock(dock)
        tabs[k].Paint = function(s, w, h)
            local alpha = s:IsHovered() and 125 or 0
            surface.SetDrawColor(55, 55, 55, alpha)
            surface.SetMaterial(gradLeft)
            surface.DrawTexturedRect(0, 0, w, h)
            draw.SimpleText(tostring(v.title), "Mono45", w * .5, h * .5, Color(255, 255, 255), 1, 1)
        end
        tabs[k].DoClick = function()
            windowPanel.updateContent( windowPanel)
            if v.panel then
                v.panel( windowPanel, category )
            end
            p.deptMoneyActivePanel = k
        end
    end
end

net.Receive("open_money_sys_terminal_menu", function()
    local p = LocalPlayer()
    if not IsValid(p) then return end
    local departmentTable = net.ReadTable()
    p.departmentTable = departmentTable
    openMoneySysTerminalUI()
    PrintTable(departmentTable)
end)

net.Receive("sv_update_money_sys_table_sync_clients", function()
    local p = LocalPlayer()
    if !IsValid(p) then return end
    local departmentTable = net.ReadTable()
    p.departmentTable = departmentTable
    p.hasMoneyTableUpdated = true
end)

net.Receive("sv_dept_maintenance_get_due", function()
    local dueamount = net.ReadInt(32)
    myDeptDues = dueamount
end)
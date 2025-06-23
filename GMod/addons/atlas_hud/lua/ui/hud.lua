--[[---------------------------------------------------------------------------
HUD separate Elements sus not today
---------------------------------------------------------------------------]]
local sw, sh = ScrW(), ScrH()
local showInfoKey = KEY_H -- Replace with the key code you want to use (e.g., KEY_F, KEY_G, etc.)
local mainCol = Color(255, 255, 255, 255)
local backCol = Color(255, 255, 255, 10)
local barBackCol = Color(50, 50, 50, 100)
local padding = sw * .025                                                       --gap between health number in the centre and health bars
local offset = sw * .01
local spacing = sw * .005                                                         --float used to produce a gap between text shadows

local hudStartX = sw * .5                                                             --starting position X of the centre of entire hud
local hudStartY = sh * .9                                                             --starting position Y of the centre of the entire hud

local lineLength = sw * .15                                                     --length of the hud line/health bars
local lineHeight = sw * .003                                                    --height of the hud line/health bars

local bobFrequency = .05  -- Adjust this value to control the speed of the bobbing effect
local bobAmount = 8 -- Adjust this value to control the intensity of the bobbing
local bobSmoothing = 5 -- Adjust this value for smoother transitions

local originalHudStartY = sh * .9 -- Store the original value
local originalHudStartX = sw * .5 -- Store the original value

local smoothedHudStartX = originalHudStartX
local smoothedHudStartY = originalHudStartY

local backGround = Material( "notifications/angryimg.png" )

local minFrequency = 1 -- Minimum frequency for flashing
local maxFrequency = 10 -- Maximum frequency for flashing

local function drawSCPHud()

    local p = IsValid(LocalPlayer()) and LocalPlayer()

    local maxHealth = p:GetMaxHealth()
    local health = math.Clamp(p:Health(), 0, maxHealth)

    local maxArmor = p:GetMaxArmor()
    local armor = math.Clamp(p:Armor(), 0, maxArmor)

    local name = p:getDarkRPVar("rpname")
    local money = DarkRP.formatMoney(p:getDarkRPVar("money"))

    local bar1W = (lineLength / maxHealth) * (maxHealth - health) 
    local bar2W = ((lineLength / maxHealth) * health) 

    local bar1WA = (lineLength / maxArmor) * (maxArmor - armor)    
    local bar2WA = ((lineLength / maxArmor) * armor)     

    local speed = p:GetVelocity():Length()
    local lateralMovement = math.abs(p:GetVelocity().x) + math.abs(p:GetVelocity().y)
    local bobOffsetX = math.sin(CurTime() * bobFrequency * lateralMovement) * bobAmount
    local bobOffsetY = math.sin(CurTime() * bobFrequency * speed) * bobAmount

    smoothedHudStartX = Lerp(FrameTime() * bobSmoothing, smoothedHudStartX, originalHudStartX + bobOffsetX)
    smoothedHudStartY = Lerp(FrameTime() * bobSmoothing, smoothedHudStartY, originalHudStartY + bobOffsetY)

    hudStartX = smoothedHudStartX
    hudStartY = smoothedHudStartY

    if input.IsKeyDown(showInfoKey) and not p:IsTyping() or health < maxHealth then
        surface.SetMaterial(backGround)
        surface.SetDrawColor(0, 0, 0, 155)
        surface.DrawTexturedRect( hudStartX - (lineLength * 5) * .5, hudStartY - (lineHeight * 35) * .5 , lineLength * 5, lineHeight * 35)

        local healthPercentage = health / maxHealth
        local healthBarColor = Color(255, 255, 255) 
        
        if healthPercentage <= 0.5 then
            local h, s, l = 0, 1, 0.5 
            local flashSpeed = Lerp(healthPercentage * 2, maxFrequency, minFrequency)
            local flashIntensity = math.Clamp((math.sin(RealTime() * flashSpeed) + 1) * 0.5, 0, 1) 
        
            l = Lerp(flashIntensity, 0.5, 1)

            healthBarColor = HSLToColor(h, s, l)
        end
        
        local textColor = healthBarColor

        draw.SimpleText(math.Clamp(p:Health(), 0, 10000000), "Mono36", hudStartX, hudStartY - spacing * 1.75, backCol, 1, 1 )
        draw.SimpleText(math.Clamp(p:Health(), 0, 10000000), "Mono36", hudStartX, hudStartY - spacing , textColor, 1, 1 )

        draw.SimpleText(p:Armor(), "Mono26", hudStartX, hudStartY + spacing, backCol, 1, 1 )
        draw.SimpleText(p:Armor(), "Mono26", hudStartX, hudStartY + spacing * 1.5 , mainCol, 1, 1 )

        local mat = Matrix()
    
        mat:Translate(Vector(sw/2, sh/2))
        mat:Rotate(Angle(0,-1,0))
        mat:Scale(Vector(1,1,1))
        mat:Translate(-Vector(sw/2, sh/2))
    
        cam.PushModelMatrix(mat)

            --LEFT HEALTH & ARMOR BAR
            surface.SetDrawColor(backCol)
            surface.DrawRect( hudStartX - lineLength - padding - offset * .35, hudStartY - offset * .35, lineLength, lineHeight )
            surface.DrawRect( hudStartX - lineLength - padding - offset * .35 + bar1W, hudStartY - offset * .35, bar2W, lineHeight )
            surface.SetDrawColor(barBackCol)
            surface.DrawRect( hudStartX - lineLength - padding, hudStartY, lineLength, lineHeight )
            surface.DrawRect( hudStartX - lineLength - padding, hudStartY + offset * .3, lineLength, lineHeight * .5)
            surface.SetDrawColor(Color(50, 50, 150, 235))
            surface.DrawRect( hudStartX - lineLength - padding + bar1WA, hudStartY + offset * .3, bar2WA, lineHeight * .5 )
            surface.SetDrawColor(healthBarColor)
            surface.DrawRect( hudStartX - lineLength - padding + bar1W, hudStartY, bar2W, lineHeight )

            --RP NAME
            draw.SimpleText(name, "Mono20", hudStartX - lineLength - padding - offset * .3, hudStartY - offset *.8, backCol, 4, 1)
            draw.SimpleText(name, "Mono20", hudStartX - lineLength - padding, hudStartY - offset * .5, mainCol, 4, 1)

        cam.PopModelMatrix()	

        local mat = Matrix()
        mat:Translate(Vector(sw/2, sh/2))
        mat:Rotate(Angle(0,1,0))
        mat:Scale(Vector(1,1,1))
        mat:Translate(-Vector(sw/2, sh/2))
        
        cam.PushModelMatrix(mat)

            --RIGHT HEALTH BAR
            surface.SetDrawColor(backCol)
            surface.DrawRect( hudStartX + padding + offset * .35, hudStartY - offset * .35, lineLength, lineHeight )
            surface.DrawRect( hudStartX + padding + offset * .35, hudStartY - offset * .35, bar2W, lineHeight )
            surface.SetDrawColor(barBackCol)
            surface.DrawRect( hudStartX + padding, hudStartY, lineLength, lineHeight )
            surface.DrawRect( hudStartX + padding, hudStartY + offset * .3, lineLength, lineHeight * .5)
            surface.SetDrawColor(Color(50, 50, 150, 235))
            surface.DrawRect( hudStartX + padding, hudStartY+ offset * .3, bar2WA, lineHeight * .5)
            surface.SetDrawColor(healthBarColor)
            surface.DrawRect( hudStartX + padding, hudStartY, bar2W, lineHeight )

            --PLAYER MONEY
            draw.SimpleText(money, "Mono20", hudStartX + lineLength + padding + offset * .3, hudStartY - offset *.8, backCol, 2, 1)
            draw.SimpleText(money, "Mono20", hudStartX + lineLength + padding, hudStartY - offset * .5, mainCol, 2, 1)

        cam.PopModelMatrix()	

    end
end

//TAKEN FROM SOUL'S CODE
local function drawSCPTextOnScreen()
    local text = "[H] to view Status, [G] to view Descriptions, [I] to open Backpack"
    local x = hudStartX - sw * .48  -- X-coordinate (adjust as needed)
        local y = hudStartY + sh * .05 -- Y-coordinate (adjust as needed)
        local font = "Mono16" -- Use the desired font here
        local defaultColor = Color(255, 255, 255, 255) -- Default text color (white)
        local highlightColor = Color(255, 140, 0) -- Highlight color (red)

        surface.SetFont(font)

        local mat = Matrix()
        mat:Translate(Vector(sw/2, sh/2))
        mat:Rotate(Angle(0,-1.5,0))
        mat:Scale(Vector(1,1,1))
        mat:Translate(-Vector(sw/2, sh/2))
        cam.PushModelMatrix(mat)

        local currentX = x
        local highlightSubstrings = {"H", "G", "I"}

        local i = 1
        while i <= #text do
            local textColor = defaultColor
            local charWidth, charHeight

            for _, highlightSubstring in ipairs(highlightSubstrings) do
                local currentSubstring = text:sub(i, i + #highlightSubstring - 1)
                if currentSubstring == highlightSubstring then
                    textColor = highlightColor
                    charWidth, charHeight = surface.GetTextSize(currentSubstring)
                    draw.DrawText(currentSubstring, font, currentX, y, textColor, TEXT_ALIGN_LEFT)
                    draw.DrawText(currentSubstring, font, currentX - sw*.0025, y - sh * .0025, Color(255, 255, 255, 20), TEXT_ALIGN_LEFT)
                    i = i + #highlightSubstring
                    currentX = currentX + charWidth
                    break
                end
            end

            if textColor == defaultColor then
                local char = text:sub(i, i)
                charWidth, charHeight = surface.GetTextSize(char)
                draw.DrawText(char, font, currentX, y, textColor, TEXT_ALIGN_LEFT)
                draw.DrawText(char, font, currentX - sw*.0025, y - sh * .0025, Color(255, 255, 255, 20), TEXT_ALIGN_LEFT)
                i = i + 1
                currentX = currentX + charWidth
            end
        end

        cam.PopModelMatrix()
    end

//TAKEN FROM SOUL'S CODE
local function drawSCPHUDAtlasWaterMark()
    local x = hudStartX + sw * .48 -- X-coordinate (adjust as needed)
    local y = hudStartY + sh * .05 -- Y-coordinate (adjust as needed)
    local font = "Mono16" -- Use the desired font here
    local textColor = Color(255, 255, 255, 20)

    local mat = Matrix()
    mat:Translate(Vector(sw/2, sh/2))
    mat:Rotate(Angle(0,1.5,0))
    mat:Scale(Vector(1,1,1))
    mat:Translate(-Vector(sw/2, sh/2))
    cam.PushModelMatrix(mat)


        local text = "[ ATLAS -///- PROJECT V.085 -///- UPRISING ]"
        draw.SimpleText(text, font, x, y, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        textColor = Color(32, 133, 57) -- Text color (white)
        draw.SimpleText(text, font, x - sw*.0025, y + sw*.0025, textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    cam.PopModelMatrix()
end

-- INVENTORY.Weight.IsOver()
-- Lets draw in the top center of the screen a text that says "Overweight" if the player is over the weight limit
local function drawWeightOverStatus()
    local p = IsValid(LocalPlayer()) and LocalPlayer()
    if not p then return end

    if INVENTORY and INVENTORY.Weight.IsOver() then
        local text = "Encumbered"
        local font = "Mono30" -- Use the desired font here
        local textColor = Color(255, 255, 255, 20)

        surface.SetFont(font)

        local x = hudStartX -- X-coordinate (adjust as needed)
        local y = hudStartY - sh * 0.8 -- Y-coordinate (adjust as needed)


        -- Draw weight values under text INVENTORY.Weight.Get() / INVENTORY.Weight.GetMax()
        local weightText = INVENTORY.Weight.Get() .. " / " .. INVENTORY.Weight.GetMax()
        local weightFont = "Mono20" -- Use the desired font here
        local weightTextColor = Color(255, 255, 255, 20)

        local wx = hudStartX -- X-coordinate (adjust as needed)
        local wy = hudStartY - sh * 0.78 -- Y-coordinate (adjust as needed)
        local mat = Matrix()
        mat:Translate(Vector(sw/2, sh/2))
        mat:Rotate(Angle(0,0,0))
        mat:Scale(Vector(1,1,1))
        mat:Translate(-Vector(sw/2, sh/2))
        cam.PushModelMatrix(mat)

            draw.SimpleText(text, font, x, y, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            textColor = Color(255, 0, 0) -- Text color (white)
            draw.SimpleText(text, font, x - sw*.0025, y + sw*.0025, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetFont(weightFont)
            draw.SimpleText(weightText, weightFont, wx, wy, weightTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            weightTextColor = Color(255, 0, 0) -- Text color (white)
            draw.SimpleText(weightText, weightFont, wx - sw*.0025, wy + sw*.0025, weightTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        cam.PopModelMatrix()
    end
end

--[[local notificationSound = "buttons/lightswitch2.wav"
local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound(notificationSound)

    -- Log to client console
    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)]]

local notificationSound = "buttons/lightswitch2.wav"
local function DisplayNotify(msg, msgtype, len)
    GAMEMODE:AddNotify(msg, msgtype, len)
    surface.PlaySound(notificationSound)

    -- Log to client console
    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), msg, "\n")
end

net.Receive("_Notify", function()
    local msg = net.ReadString()
    local msgtype = net.ReadInt(16)
    local len = net.ReadInt(32)
    DisplayNotify(msg, msgtype, len)
end)

local noDraw = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudSuitPower"] = true,
    ["CHUDQuickInfo"] = true,
    ["CHudWeaponSelection"] = true,
    ["CHudAmmo"] = true
}
hook.Add("HUDShouldDraw", "cl.scphud.main.hudshoulddraw", function(name)
    if noDraw[name] or (HelpToggled and name == "CHudChat") then
        return false
    end
end)

function getHUDPositionXY()
    return hudStartX, hudStartY
end

--[[---------------------------------------------------------------------------
Disable players' names popping up when looking at them
---------------------------------------------------------------------------]]
hook.Add("HUDDrawTargetID", "cl.scphud.main.huddrawtargetid", function()
    return false
end)

--[[---------------------------------------------------------------------------
Actual HUDPaint hook
---------------------------------------------------------------------------]]
hook.Add("HUDPaint", "cl.scphud.main.hudpaint", function()
    drawSCPHud()
    drawSCPTextOnScreen()
    drawSCPHUDAtlasWaterMark()
    drawWeightOverStatus()
end)

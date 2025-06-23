--[[
    Main Menu UI
    UI Explained:
    Background is going to be "materials/atlas/backgrounds/menu_site.png". Background will cover whole screen.
    Logo is going to be "materials/branding/atlas_logo.png".
    Between the left side of the screen and the middle will be a box with a semi-transparent dark background with a even darker outline around it.
    Inside of that box will be the main menu buttons which are in order: START, LORE, STORE, DISCORD, WEBSITE. We will want to make a table for these options and their functions at the top of the file.
    To the top-right of the screen will be a landscape type box with a semi-transparent dark background with a even darker outline around it.
    We don't know what to put in that box yet, but we will figure it out.
    Font we will be using is called "MADE Tommy Soft" for all font types.
]]

-- [FONTS]
surface.CreateFont( "ATLAS.MainMenu.Button", {
    font = "MADE Tommy Soft",
    size = 48,
    weight = 700,
    antialias = true,
    shadow = false
} )

-- [Variables]
local THEME = {
    Background = "materials/atlas/backgrounds/menu_site.png",
    Logo = "materials/branding/atlas_logo.png",
    Scanline = "materials/atlas/backgrounds/scanline.png",
    Biobolt_Logo = "materials/branding/biobolt.png",
    Button = {
        Background = Color( 0, 0, 0, 100 ),
        Outline = Color( 0, 0, 0, 200 ),
        Text = Color( 255, 255, 255, 255 )
    },
    Colors = {
        White = Color( 255, 255, 255, 255 ),
        Black = Color( 0, 0, 0, 255 ),
        Red = Color( 255, 0, 0, 255 ),
        Green = Color( 0, 255, 0, 255 ),
        Blue = Color( 0, 0, 255, 255 ),
        Yellow = Color( 255, 255, 0, 255 ),
        Orange = Color( 255, 128, 0, 255 ),
        Purple = Color( 128, 0, 255, 255 ),
        Pink = Color( 255, 0, 255, 255 ),
        Cyan = Color( 0, 255, 255, 255 ),
        Grey = Color( 128, 128, 128, 255 ),
        DarkGrey = Color( 64, 64, 64, 255 ),
        LightGrey = Color( 192, 192, 192, 255 ),
        Transparent = Color( 0, 0, 0, 0 )
    }
}

local MainMenuButtons = {
    { label = "START", action = function() WELCOMEUI.StartPress() end },
    { label = "LORE", action = function() gui.OpenURL("https://atlasuprising.com/scp/lore/") end },
    { label = "STORE", action = function() gui.OpenURL("https://store.atlasuprising.com/") end },
    { label = "DISCORD", action = function() gui.OpenURL("https://discord.gg/atlasuprising") end },
    { label = "WEBSITE", action = function() gui.OpenURL("https://atlasuprising.com/") end }
}

WELCOMEUI.MainMenu = WELCOMEUI.MainMenu or {} 
WELCOMEUI.MainMenuFrame = WELCOMEUI.MainMenuFrame or false
WELCOMEUI.MainMenuMusic = WELCOMEUI.MainMenuMusic or false

-- [UTILITY FUNCTIONS]
local function DrawRect(x, y, w, h, color)
    surface.SetDrawColor(color)
    surface.DrawRect(x, y, w, h)
end

local function DrawText(text, font, x, y, color)
    surface.SetFont(font)
    surface.SetTextColor(color)
    surface.SetTextPos(x, y)
    surface.DrawText(text)
end


-- [UI ELEMENT DEFINITIONS]
local function DrawButton(button, x, y, w, h)
    DrawRect(x, y, w, h, THEME.Button.Background)  -- Draw the button background

    if button.hovered then  -- If the button is hovered, draw the outline
        DrawRect(x, y, w, h, THEME.Button.Outline)
        -- make a white line cover the left side of the button and pulse
        local pulse = math.abs(math.sin(SysTime() * 3))
        DrawRect(x, y, 10, h, Color(255, 255, 255, 255 * pulse))
    end

    -- Set the font and get the text size
    surface.SetFont("ATLAS.MainMenu.Button")
    local textWidth, textHeight = surface.GetTextSize(button.label)

    -- Calculate the position to start drawing the text so it's centered in the button
    local textX = x + (w - textWidth) / 2
    local textY = y + (h - textHeight) / 2

    DrawText(button.label, "ATLAS.MainMenu.Button", textX, textY, THEME.Button.Text)  -- Draw the button label
end


local function DrawMainMenu()
    local ScreenWidth, ScreenHeight = ScrW(), ScrH()
    local BoxWidth, BoxHeight = ScreenWidth / 4, ScreenHeight * 0.8
    local ButtonWidth, ButtonHeight = BoxWidth * 0.8, BoxHeight * 0.1
    local Padding = BoxHeight * 0.02  -- Space between buttons
    -- Place button center in box
    local startX = (ScreenWidth / 3) - (ButtonWidth / 1.09)  -- Center the button horizontally
    local startY = (ScreenHeight / 2) - ((#MainMenuButtons * (ButtonHeight + Padding) - Padding) / 2.5)  -- Center the block of buttons vertically
    for i, button in ipairs(MainMenuButtons) do
        local x = startX
        local y = startY + (ButtonHeight + Padding) * (i - 1)  -- This will arrange buttons top to bottom
        DrawButton(button, x, y, ButtonWidth, ButtonHeight)
    end
end

-- Just draw a empty box for now with a background that matches the box
local function DrawTopRightBox()
    local ScreenWidth, ScreenHeight = ScrW(), ScrH()
    local BoxWidth, BoxHeight = 400, 200

    -- Location for box will be top right of screen but not touching the edges
    local BoxPosX, BoxPosY = ScreenWidth - BoxWidth - 50, 30

    -- Draw background outline
    DrawRect(BoxPosX-10, BoxPosY-10, BoxWidth+20, BoxHeight+20, Color(17, 17, 17, 200))  -- Even darker outline, adjust the numbers for the outline thickness
    DrawRect(BoxPosX, BoxPosY, BoxWidth, BoxHeight, Color(38, 38, 38, 125))  -- Semi-transparent dark background


    -- Draw text saying Coming Soon
    local ComingSoonText = "Coming Soon"
    local ComingSoonTextWidth, ComingSoonTextHeight = surface.GetTextSize(ComingSoonText)
    local ComingSoonTextX, ComingSoonTextY = BoxPosX + (BoxWidth - ComingSoonTextWidth) / 2, BoxPosY + (BoxHeight - ComingSoonTextHeight) / 2
    DrawText(ComingSoonText, "ATLAS.MainMenu.Button", ComingSoonTextX, ComingSoonTextY, THEME.Button.Text)

end

local function DrawAnimatedScanLines()
    local ScreenWidth, ScreenHeight = ScrW(), ScrH()
    local ScanlineWidth, ScanlineHeight = ScreenWidth, ScreenHeight
    local ScanlineSpeed = 10  -- Adjust this to change the speed of the scanlines
    local ScanlineOffset = (SysTime() * ScanlineSpeed) % ScanlineHeight  -- This will make the scanlines move down the screen

    local scanlineMaterial = Material(THEME.Scanline)  -- Load scanline material
    surface.SetMaterial(scanlineMaterial)  -- Set the material
    surface.SetDrawColor(255, 255, 255, 255)  -- Set the color (white, in this case)
    surface.DrawTexturedRect(0, ScanlineOffset, ScanlineWidth, ScanlineHeight)  -- Draw the scanlines

    -- Draw the scanlines again, but this time above the first scanlines
    surface.DrawTexturedRect(0, ScanlineOffset - ScanlineHeight, ScanlineWidth, ScanlineHeight)
end

local function DrawBioboltLogo()
    -- Load the Biobolt logo material
    local bioboltLogoMaterial = Material(THEME.Biobolt_Logo)

    -- Calculate the dimensions and position of the logo
    local screenWidth, screenHeight = ScrW(), ScrH()
    local logoWidth, logoHeight = screenWidth / 10, (screenWidth / 10) * (592 / 1284) -- Scale the logo to a quarter of the screen width, keeping the aspect ratio
    local logoX, logoY = screenWidth - logoWidth - 50, screenHeight - logoHeight - 30 -- Position the logo in the bottom right corner of the screen

    -- Draw the logo
    surface.SetMaterial(bioboltLogoMaterial)
    
    surface.SetDrawColor(0, 0, 0, 200) -- Set the color to white
    surface.DrawTexturedRect(logoX - 5, logoY + 5, logoWidth + 10, logoHeight + 10)

    surface.SetDrawColor(255, 255, 255, 255) -- Set the color to white
    surface.DrawTexturedRect(logoX, logoY, logoWidth, logoHeight)

end

-- [MAIN UI FUNCTION]
function WELCOMEUI.MainMenu.Draw(w, h)
    local ScreenWidth, ScreenHeight = ScrW(), ScrH()  -- Get screen dimensions

    -- Draw background
    local backgroundMaterial = Material(THEME.Background)  -- Load background material
    surface.SetMaterial(backgroundMaterial)  -- Set the material
    surface.SetDrawColor(255, 255, 255, 255)  -- Set the color (white, in this case)
    surface.DrawTexturedRect(0, 0, ScreenWidth, ScreenHeight)  -- Draw the background covering the whole screen

    -- Draw animated scanlines
    DrawAnimatedScanLines()

    DrawBioboltLogo()

    -- Calculate box dimensions
    local boxX = ScreenWidth / 8
    local boxY = 0  -- Starts at the top of the screen
    local boxWidth = ScreenWidth / 4  -- Adjust as needed
    local boxHeight = ScreenHeight * 0.8  -- Extends to the bottom of the screen

    -- Draw box
    DrawRect(boxX-10, boxY-10, boxWidth+20, boxHeight+20, Color(17, 17, 17, 200))  -- Even darker outline, adjust the numbers for the outline thickness
    DrawRect(boxX, boxY, boxWidth, boxHeight, Color(38, 38, 38, 125))  -- Semi-transparent dark background


    -- Draw logo
    local logoMaterial = Material(THEME.Logo)  -- Load logo material
    
    -- Logo original size is 1202 x 434
    local logoWidth, logoHeight = ScreenWidth / 5, (ScreenWidth / 5) * (434 / 1202)  -- Scale the logo to half the screen width, keeping the aspect ratio

    
    -- Center logo on top of the button in box
    local logoX, logoY = boxX + (boxWidth - logoWidth) / 2, boxY + (boxWidth - logoWidth) / 0.6


    surface.SetMaterial(logoMaterial)  -- Set the material
    surface.SetDrawColor(0, 0, 0, 150)  -- Set the color (black, in this case)
    surface.DrawTexturedRect(logoX + 5, logoY + 5, logoWidth + 5, logoHeight + 5)  -- Draw the shadow
    surface.SetDrawColor(255, 255, 255, 255)  -- Set the color (white, in this case)
    surface.DrawTexturedRect(logoX, logoY, logoWidth, logoHeight)  -- Draw the logo



    -- Draw main menu
    DrawMainMenu()

    DrawTopRightBox()
end

function WELCOMEUI.MainMenu.Open()
    if WELCOMEUI.MainMenu.Frame then return end  -- Don't open the menu if it's already open

    -- Make a temp background that is black and removes itself after the animation is done
    local blackBackground = vgui.Create("DPanel")
    blackBackground:SetSize(ScrW(), ScrH())
    blackBackground:SetPos(0, 0)
    blackBackground:SetBackgroundColor(Color(0, 0, 0, 255))
    blackBackground:MoveToBack()

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW(), ScrH())
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetAlpha(0)  -- Set the initial alpha to 0
    frame:MakePopup()  -- This captures mouse input
    WELCOMEUI.MainMenu.Frame = frame  -- Store the frame so we can reference it later
    function frame:Paint(w, h)
        WELCOMEUI.MainMenu.Draw()  -- Call your draw function
    end

    function frame:Think()
        if not self.anim then
            self.anim = Derma_Anim("EaseOutCirc", self, function(pnl, anim, delta, data)
                pnl:SetAlpha(delta * 255)
                pnl:SetBGColor(Color(169, 60, 60, 255 - delta * 255))
                if anim.Finished then
                    if IsValid(anim) then anim:Remove() end
                    if IsValid(blackBackground) then blackBackground:Remove() end
                end
            end)
            self.anim:Start(0.5)  -- Set the duration of the fade-in effect (in seconds)
        end
        self.anim:Run()  -- Run the animation every frame

        -- if WELCOMEUI.MainMenuMusic is done playing, start playing it again WELCOMEUI.MainMenuMusic is on IGModAudioChannel
        if IsValid(WELCOMEUI.MainMenuMusic) and WELCOMEUI.MainMenuMusic:GetState() ~= 1 then
            WELCOMEUI.MainMenuMusic:Play()
            if timer.Exists("WELCOMEUI.MainMenu.Music.Fade") then
                timer.Remove("WELCOMEUI.MainMenu.Music.Fade")
            end
            WELCOMEUI.MainMenuMusic:SetVolume(0.5)
        end

        -- if main menu music is getting close to the end, fade it out
        if IsValid(WELCOMEUI.MainMenuMusic) and WELCOMEUI.MainMenuMusic:GetTime() - WELCOMEUI.MainMenuMusic:GetLength() > -5 and not timer.Exists("WELCOMEUI.MainMenu.Music.Fade") then
            print("FADE TIMER")
            timer.Create("WELCOMEUI.MainMenu.Music.Fade", 0.3, 25, function()
                local volume = WELCOMEUI.MainMenuMusic:GetVolume()
                if volume <= 0 then
                    WELCOMEUI.MainMenuMusic:Stop()
                    timer.Remove("WELCOMEUI.MainMenu.Music.Fade")
                else
                    WELCOMEUI.MainMenuMusic:SetVolume(volume - 0.1)
                end
            end)
        end
    end

    
    sound.Play("main/boom.wav", LocalPlayer():GetPos(), 75, 100, 1)
    -- Play sound/main/menu_music.mp3
    sound.PlayFile("sound/main/menu_music.mp3", "noplay", function(station, errCode, errStr)
        if IsValid(station) then
            station:SetVolume(0.5)
            WELCOMEUI.MainMenuMusic = station
        end
    end)
end

function WELCOMEUI.MainMenu.Close()
    if not WELCOMEUI.MainMenu.Frame then return end  -- Don't close the menu if it's not open

    -- animated the frame closing by fading in a black background
    local frame = WELCOMEUI.MainMenu.Frame
    -- make frame front
    frame:MoveToFront()
    local blackBackground = frame:Add("DPanel")
    blackBackground:SetSize(ScrW(), ScrH())
    blackBackground:SetPos(0, 0)
    blackBackground:SetBackgroundColor(Color(0, 0, 0, 0))
    
    local fadeTime = 1  -- Adjust this to change the fade time
    local startTime = SysTime()
    hook.Add("Think", "WELCOMEUI.MainMenu.Close", function()
        local timeElapsed = SysTime() - startTime
        local alpha = math.Clamp(timeElapsed / fadeTime, 0, 1) * 300
        blackBackground:SetBackgroundColor(Color(14, 14, 26, alpha))
        if timeElapsed >= fadeTime then
            blackBackground:Remove()
            frame:Remove()
            WELCOMEUI.MainMenu.Frame = nil
            hook.Remove("Think", "WELCOMEUI.MainMenu.Close")
        end
    end)


    -- Fade WELCOMEUI.MainMenuMusic out
    if WELCOMEUI.MainMenuMusic then
        timer.Create("WELCOMEUI.MainMenu.Music.Fade", 0.1, 25, function()
            if not IsValid(WELCOMEUI.MainMenuMusic) then timer.Remove("WELCOMEUI.MainMenu.Music.Fade") return end
            local volume = WELCOMEUI.MainMenuMusic:GetVolume()
            if volume <= 0 then
                WELCOMEUI.MainMenuMusic:Stop()
                timer.Remove("WELCOMEUI.MainMenu.Close")
            else
                WELCOMEUI.MainMenuMusic:SetVolume(volume - 0.1)
            end
        end)
    end

    timer.Simple(1, function()
        
        if IsValid(WELCOMEUI.MainMenuMusic) then
            WELCOMEUI.MainMenuMusic:Stop()
        end
        sound.Play("intro/hit.wav", LocalPlayer():GetPos(), 75, 100, 1)
    end)

    --[[WELCOMEUI.MainMenu.Frame:Remove()  -- Remove the frame
    WELCOMEUI.MainMenu.Frame = nil  -- Clear the stored frame reference]]
end



-- [EVENT HANDLERS]
local buttonPressed = false

function WELCOMEUI.MainMenu.HandleMousePressed(x, y, button)
    if not WELCOMEUI.MainMenu.Frame then return end  -- Don't handle mouse presses if the menu isn't open

    -- Only allow one mouse press to be handled
    if not buttonPressed and button == MOUSE_LEFT then
        for _, button in ipairs(MainMenuButtons) do
            if button.hovered then
                surface.PlaySound("main/btn_click.mp3")
                button.action()
                buttonPressed = true
                timer.Simple(0.3, function() buttonPressed = false end)
                break
            end
        end
    end

end

function WELCOMEUI.MainMenu.HandleMouseMoved(x, y)
    if not WELCOMEUI.MainMenu.Frame then return end  -- Don't handle mouse movement if the menu isn't open

    for i, button in ipairs(MainMenuButtons) do
        local ScreenWidth, ScreenHeight = ScrW(), ScrH()
        local BoxWidth, BoxHeight = ScreenWidth / 4, ScreenHeight * 0.8
        local ButtonWidth, ButtonHeight = BoxWidth * 0.8, BoxHeight * 0.1
        local Padding = BoxHeight * 0.02  -- Space between buttons
        -- Place button center in box
        local startX = (ScreenWidth / 3) - (ButtonWidth / 1.09)  -- Center the button horizontally
        local startY = (ScreenHeight / 2) - ((#MainMenuButtons * (ButtonHeight + Padding) - Padding) / 2.5)  -- Center the block of buttons vertically
        local x1, y1 = startX, startY + (ButtonHeight + Padding) * (i - 1)  -- This will arrange buttons top to bottom
        local x2, y2 = x1 + ButtonWidth, y1 + ButtonHeight

        -- Check if the button was previously not hovered over and now is
        if button.hovered and not button.wasHovered then
            surface.PlaySound("main/btn_hover.mp3")
        end

        button.wasHovered = button.hovered
        button.hovered = x >= x1 and y >= y1 and x <= x2 and y <= y2
    end
end

-- [HOOKS]
hook.Add("PlayerButtonDown", "WELCOMEUI.MainMenu.HandleMousePressed", function(ply, button)
    if ply ~= LocalPlayer() then return end  -- Only handle mouse presses for the local player

    WELCOMEUI.MainMenu.HandleMousePressed(x, y, button)
end)

hook.Add("Think", "WELCOMEUI.MainMenu.HandleMouseMoved", function()
    if not WELCOMEUI.MainMenu.Frame then return end  -- Don't handle mouse movement if the menu isn't open

    local x, y = gui.MousePos()
    WELCOMEUI.MainMenu.HandleMouseMoved(x, y)
end)



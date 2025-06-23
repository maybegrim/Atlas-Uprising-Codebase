local fadeAlpha = 0
local fadeSpeed = 127.5  -- 2 second long fade (255 / 2)
local fadeState = 0
local fadeTime = 0

-- Fades screen to black and then back in 5 seconds
local function FadeScreen()

    local fadeState = 0
    local fadeTime = 0

    hook.Add("DrawOverlay", "FadeScreenEffect", function()
        local curTime = CurTime()

        -- Fade to black
        if (fadeState == 0) then
            fadeAlpha = math.min(fadeAlpha + FrameTime() * fadeSpeed, 255)
            if (fadeAlpha >= 255) then
                fadeAlpha = 255
                fadeState = 1
                -- Sets time for screen to remain black
                fadeTime = curTime + 1
            end
        -- Stay black for 1 second
        elseif (fadeState == 1) then
            if curTime >= fadeTime then
                fadeState = 2
            end
        -- Fade back from black
        elseif (fadeState == 2) then
            fadeAlpha = math.max(fadeAlpha - FrameTime() * fadeSpeed, 0)
            if (fadeAlpha <= 0) then
                fadeAlpha = 0
                hook.Remove("DrawOverlay", "FadeScreenEffect")
            end
        end

        surface.SetDrawColor(0, 0, 0, fadeAlpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end)
end

-- Runs fade effect and zipper sound once everything is validated server side
net.Receive("DClassOutfitLockerClientEffects", function()

    FadeScreen()

    -- Wait till screen is black to play zipper sound
    timer.Simple(2, function()
        surface.PlaySound("dclassoutfitlocker/dclassoutfitlocker_zipper.mp3")
    end)

end)

-- Notifies player they have already changed
net.Receive("DClassOutfitLockerAlreadyChanged", function()

    notification.AddLegacy("Outfit already changed", NOTIFY_ERROR, 2)

end)
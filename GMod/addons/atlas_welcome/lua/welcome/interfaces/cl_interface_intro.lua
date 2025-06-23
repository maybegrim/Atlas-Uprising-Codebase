WELCOMEUI.INTROFRAME = WELCOMEUI.INTROFRAME or false
WELCOMEUI.OVERLAYFRAME = WELCOMEUI.OVERLAYFRAME or false
WELCOMEUI.IntroCloseCooldown = WELCOMEUI.IntroCloseCooldown or false


surface.CreateFont("INTROUI.Font", {
    font = "Verdana",
    size = 34,
    weight = 700,
    antialias = true,
    shadow = false
})

function WELCOMEUI.PlayIntro()
    if WELCOMEUI.INTROFRAME then
        WELCOMEUI.INTROFRAME:Remove()
    end
    if WELCOMEUI.OVERLAYFRAME then
        WELCOMEUI.OVERLAYFRAME:Remove()
    end
    -- if not 64 bit, skip
    if jit.arch ~= "x64" then
        print("Skipping intro because you are not running a 64-bit version of Garry's Mod.")
        WELCOMEUI.MainMenu.Open()
        return
    end
    local html = vgui.Create("DHTML")
    WELCOMEUI.INTROFRAME = html
    html:Dock(FILL)
    html:OpenURL("about:blank")
    html:SetHTML([[
        <!DOCTYPE html>
        <html>
        <head>
        <style>
            body, html {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden; /* Disable scrollbars */
            background: #000; /* Set the background to black */
            }
    
            .fullscreen {
            height: 100%;
            width: 100%;
            }
        </style>
        </head>
        <body>
        <div id="player"></div>

        <script>
          var tag = document.createElement('script');
    
          tag.src = "https://www.youtube.com/iframe_api";
          var firstScriptTag = document.getElementsByTagName('script')[0];
          firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    
          var player;
          function onYouTubeIframeAPIReady() {
            player = new YT.Player('player', {
              height: '1080',
              width: '1920',
              videoId: '9N8wnbfCrHE',
              events: {
                'onReady': onPlayerReady,
                'onStateChange': onPlayerStateChange
              }
            });
          }
    
          function onPlayerReady(event) {
            event.target.playVideo();
            gmod.OnVideoReady();
          }

          var done = false;
          function onPlayerStateChange(event) {
            if (event.data == YT.PlayerState.PLAYING && !done) {
              done = true;
            }
            gmod.OnVideoStateChange(event.data);
          }
          function stopVideo() {
            player.stopVideo();
          }
        </script>
        </body>
        </html>
    ]])
    html:SetKeyboardInputEnabled(true) -- Disable keyboard input for the video player
    html:SetMouseInputEnabled(true) -- Disable mouse input for the video player

    html:AddFunction("gmod", "SetVolume", function(val)
        html:QueueJavascript("player.setVolume(".. val ..");") -- Use YouTube API's setVolume method
    end)

    -- html:QueueJavascript([[player.setPlaybackQuality('highres');]]) -- Discontinued, YouTube API doesn't support this anymore.
    
    -- Call the JavaScript function from Lua
    html:Call('gmod.SetVolume(80);')
    local overlay = vgui.Create("DPanel", html)
    WELCOMEUI.OVERLAYFRAME = overlay
    overlay:Dock(FILL)
    overlay:SetBackgroundColor(Color(0, 0, 0, 255))

    local blackBarOne = vgui.Create("DPanel", html)
    blackBarOne:SetSize(html:GetWide(), 128)
    blackBarOne:DockMargin(0, 0, 0, html:GetTall() - 128)
    blackBarOne:Dock(TOP)
    blackBarOne:SetBackgroundColor(Color(0, 0, 0, 255))

    local blackBarTwo = vgui.Create("DPanel", html)
    blackBarTwo:SetSize(html:GetWide(), 128)
    blackBarTwo:DockMargin(0, html:GetTall() - 128, 0, 0)
    blackBarTwo:Dock(BOTTOM)
    blackBarTwo:SetBackgroundColor(Color(0, 0, 0, 255))
    
    function OnVideoReady()
        WELCOMEUI.IntroCloseCooldown = CurTime() + 1
        local alpha = 255
        local function fadeOverlay()
            alpha = alpha - FrameTime() * 150 -- Fade speed. Adjust this as you see fit.
            if alpha <= 0 then
                alpha = 0
                timer.Remove("FadeOverlayTimer")
            end
            if not IsValid(overlay) then
                timer.Remove("FadeOverlayTimer")
                return
            end
            overlay:SetBackgroundColor(Color(0, 0, 0, alpha))
        end
        timer.Simple(1, function()
            timer.Create("FadeOverlayTimer", FrameTime(), 0, fadeOverlay)
        end)
        timer.Simple(1, function()
            if IsValid(html) then -- Make sure our DHTML panel still exists
                local labelText = vgui.Create("DLabel", html) -- Create the label on our DHTML panel
                labelText:SetText("[Press SPACE to continue]") -- Set the text
                labelText:SetFont("INTROUI.Font") -- Set the font, create your font using surface.CreateFont if you haven't
                labelText:SizeToContents() -- Automatically size the label
                labelText:SetPos(ScrW() * 0.5 - labelText:GetWide() * 0.5, ScrH() * 0.9 - labelText:GetTall() * 0.5)
                labelText:SetContentAlignment(5) -- Center the text
                labelText:SetTextColor(Color(255, 255, 255, 0)) -- Start with transparent text
                labelText:SetName("SpaceText")
        
                -- Fade In
                local alpha = 0
                local function fadeLabel()
                    alpha = alpha + FrameTime() * 90 -- Adjust the value for fade speed
                    if alpha >= 255 then
                        alpha = 255
                        timer.Remove("FadeLabelTimer")
                    end
                    if IsValid(labelText) then
                        labelText:SetTextColor(Color(255, 255, 255, alpha))
                    else
                        timer.Remove("FadeLabelTimer")
                    end
                end
                timer.Create("FadeLabelTimer", FrameTime(), 0, fadeLabel)
            end
        end)
        --[[timer.Simple(5, function()
            if IsValid(blackBarOne) then
                blackBarOne:Remove()
            end
            if IsValid(blackBarTwo) then
                blackBarTwo:Remove()
            end
        end)]]
    end

    function OnVideoStateChange(state)
        print("Video state changed to ".. state)
        if state == 0 then
            -- reset to 0
            html:Call('player.seekTo(0);')
            -- transition
            WELCOMEUI.Transition()
        end
    end

    html:AddFunction("gmod", "OnVideoReady", OnVideoReady)
    html:AddFunction("gmod", "OnVideoStateChange", OnVideoStateChange)



end

function WELCOMEUI.CloseIntro()
    if WELCOMEUI.INTROFRAME then
        WELCOMEUI.INTROFRAME:Remove()
        WELCOMEUI.INTROFRAME = false
    end
    if WELCOMEUI.OVERLAYFRAME then
        WELCOMEUI.OVERLAYFRAME:Remove()
        WELCOMEUI.OVERLAYFRAME = false
    end
end

function WELCOMEUI.Transition()
    local volume = 100
    timer.Create("FadeVolumeTimer", FrameTime(), 0, function()
        if volume > 0 then
            volume = volume - FrameTime() * 50
            if not WELCOMEUI.INTROFRAME then
                return
            end
            WELCOMEUI.INTROFRAME:Call('gmod.SetVolume('.. volume ..');')
        else
            timer.Remove("FadeVolumeTimer")
            -- TODO: Fade out Intro Frame or close it and make a black fade while volume goes down.
        end
    end)

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW(), ScrH())
    frame:SetPos(0, 0)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:SetTitle("")
    frame.Paint = function(self, w, h) end -- Override paint function to not paint title bar
    
    -- Start time
    local start = SysTime()
    
    -- Paint function
    function frame:PaintOver(w, h)
        local elapsed = SysTime() - start
        local alpha

        if elapsed < 3 then
            alpha = Lerp(elapsed / 2, 0, 255) 
        elseif elapsed < 5 then
            alpha = 255 
        elseif elapsed < 8 then
            alpha = Lerp((elapsed - 3) / 2, 255, 0)
        else
            self:Remove()
            return
        end
        
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, alpha)) -- Draw the black box with the calculated alpha
    end

    timer.Simple(4, function()
        WELCOMEUI.CloseIntro()
        WELCOMEUI.MainMenu.Open()
        frame:Remove()
    end)
end

local pressedSpace = false
-- Hook to check if player presses space to close the intro
hook.Add("PlayerButtonDown", "WELCOMEUI.PlayerButtonDown", function(ply, button)
    if button == KEY_SPACE and not pressedSpace and WELCOMEUI.IntroCloseCooldown and WELCOMEUI.IntroCloseCooldown <= CurTime() then
        --WELCOMEUI.INTROFRAME:SetVisible(false)
        pressedSpace = true 
        WELCOMEUI.Transition()
    end
end)

-- Remove default Sandbox hints (Timer removal method because GMod doesn't natively have a clientside function to remove hints)
timer.Simple(1, function()
    timer.Remove("HintSystem_OpeningMenu")
    timer.Remove("HintSystem_Annoy1")
    timer.Remove("HintSystem_Annoy2")
end)
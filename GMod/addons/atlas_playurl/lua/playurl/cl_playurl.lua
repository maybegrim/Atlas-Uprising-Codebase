PlayURL.CurrentSound = PlayURL.CurrentSound or false

function PlayURL.Play(url, volume)
    if not url then return end
    if not volume then volume = 1 end

    if PlayURL.CurrentSound and IsValid(PlayURL.CurrentSound) then
        PlayURL.CurrentSound:Stop()
    end

    sound.PlayURL(url, "noplay noblock", function(station)
        if IsValid(station) then
            AMBIENCE:Pause()
            PlayURL.CurrentSound = station
            station:SetVolume(volume)
            station:Play()
            if timer.Exists("PlayURL::SoundTimer") then timer.Remove("PlayURL::SoundTimer") end

            timer.Create("PlayURL::SoundTimer", 0.1, 0, function()
                if not IsValid(station) then
                    AMBIENCE:Unpause()
                    timer.Remove("PlayURL::SoundTimer")
                end

                -- if the sound is not playing anymore, stop the timer
                if station:IsValid() and station:GetState() == GMOD_CHANNEL_STOPPED or station:IsValid() and station:GetState() == GMOD_CHANNEL_PAUSED then
                    AMBIENCE:Unpause()
                    timer.Remove("PlayURL::SoundTimer")
                end
            end)
        else
            if LocalPlayer():IsSuperAdmin() then
                chat.AddText(Color(255, 0, 0), "Failed to play URL | ", Color(255, 255, 255), url)
            end
        end
    end)
end

function PlayURL.AdjustVolume(volume)
    -- volume is 1-100 so we need to convert it to 0-1
    volume = volume / 100
    if PlayURL.CurrentSound then
        PlayURL.CurrentSound:SetVolume(volume)
    end
end

function PlayURL.Stop()
    -- fade out the sound IGModAudioChannel
    if PlayURL.CurrentSound then
        timer.Create("PlayURL::FadeOut", 0.1, 0, function()
            if PlayURL.CurrentSound then
                local volume = IsValid(PlayURL.CurrentSound) and PlayURL.CurrentSound:GetVolume()
                if not volume then timer.Remove("PlayURL::FadeOut") return end
                volume = volume - 0.1
                if volume <= 0 then
                    PlayURL.CurrentSound:Stop()
                    PlayURL.CurrentSound = false
                    timer.Remove("PlayURL::FadeOut")
                    AMBIENCE:Unpause()
                else
                    PlayURL.CurrentSound:SetVolume(volume)
                end
            end
        end)
        timer.Simple(1, function()
            if PlayURL.CurrentSound then
                PlayURL.CurrentSound:Stop()
            end
        end)
    end

end

net.Receive("PlayURL::Play", function()
    local url = net.ReadString()
    local volume = net.ReadFloat()
    if not url then return end
    if not volume then volume = 1 end

    PlayURL.Play(url, volume)
end)

net.Receive("PlayURL::Stop", function()
    PlayURL.Stop()
end)

-- !volume command and block other players !volume chat
local function VolumeCommand(ply, args)
    if not args[1] then return end
    local volume = tonumber(args[1])
    if not volume then return end

    PlayURL.AdjustVolume(volume)
end

hook.Add("OnPlayerChat", "VolumeCommand", function(ply, text)
    local args = string.Explode(" ", text)
    if string.lower(args[1]) == "!volume" then
        if LocalPlayer() ~= ply then return true end
        VolumeCommand(ply, {args[2]})
        return true
    end
end)
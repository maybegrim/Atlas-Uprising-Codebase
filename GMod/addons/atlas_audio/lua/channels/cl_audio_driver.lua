AAUDIO.CHANNEL = AAUDIO.CHANNEL or {}

AAUDIO.CHANNEL["PRIMARY"] = false
AAUDIO.CHANNEL["BACKGROUND"] = false

function AAUDIO.Play( channel, override, file, volume, loop, callback )
    if not AAUDIO.CHANNEL[channel] then return end
    if not override and AAUDIO.CHANNEL[channel].Sound then return end

    sound.PlayFile( file, "noplay noblock", function( station, errCode, errStr )
        if ( IsValid( station ) ) then
            station:Play()
            station:SetVolume(volume)
            station:SetPos(LocalPlayer():GetPos())
            AAUDIO.CHANNEL[channel].Sound = station
            if loop then
                AAUDIO.CHANNEL[channel].Sound:EnableLooping(true)
            end
            if callback then
                callback(true)
            end
        else
            if callback then
                callback(false)
            end
        end
    end )
end

function AAUDIO.Stop( channel )
    if not AAUDIO.CHANNEL[channel] then return end
    if not AAUDIO.CHANNEL[channel].Sound then return end

    AAUDIO.CHANNEL[channel].Sound:Stop()
    AAUDIO.CHANNEL[channel].Sound = nil
end

function AAUDIO.SetVolume( channel, volume )
    if not AAUDIO.CHANNEL[channel] then return end
    if not AAUDIO.CHANNEL[channel].Sound then return end

    AAUDIO.CHANNEL[channel].Sound:SetVolume(volume)
end

function AAUDIO.SetPos( channel, pos )
    if not AAUDIO.CHANNEL[channel] then return end
    if not AAUDIO.CHANNEL[channel].Sound then return end

    AAUDIO.CHANNEL[channel].Sound:SetPos(pos)
end

function AAUDIO.SetPitch( channel, pitch )
    if not AAUDIO.CHANNEL[channel] then return end
    if not AAUDIO.CHANNEL[channel].Sound then return end

    AAUDIO.CHANNEL[channel].Sound:SetPlaybackRate(pitch)
end

function AAUDIO.IsPlaying( channel )
    if not AAUDIO.CHANNEL[channel] then return end
    if not AAUDIO.CHANNEL[channel].Sound then return end

    return AAUDIO.CHANNEL[channel].Sound:IsPlaying()
end

function AAUDIO.IsLooping( channel )
    if not AAUDIO.CHANNEL[channel] then return end
    if not AAUDIO.CHANNEL[channel].Sound then return end

    return AAUDIO.CHANNEL[channel].Sound:IsLooping()
end
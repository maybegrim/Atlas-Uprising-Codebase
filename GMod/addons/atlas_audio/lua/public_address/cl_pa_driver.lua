
net.Receive("AAUDIO.PA.NET.PAChime", function()
    -- getjobtable .faction == "CHAOS" 
    local speakerPly = net.ReadEntity()
    local status = net.ReadBool()

    if status then
        -- lower the volume of player
        speakerPly:SetVoiceVolumeScale(0.25)
    else
        -- reset the volume of player
        speakerPly:SetVoiceVolumeScale(1)
    end

    if LocalPlayer():getJobTable().faction == "CHAOS" then
        return
    end
    if LocalPlayer():Team() == TEAM_CHOOSING then
        return
    end
    LocalPlayer():EmitSound("atlas_audio/pa/chime.wav", 75, 100, 1, CHAN_AUTO, 0, 9)
end)


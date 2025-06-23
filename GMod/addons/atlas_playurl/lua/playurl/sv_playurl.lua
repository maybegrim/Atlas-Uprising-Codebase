util.AddNetworkString("PlayURL::Play")
util.AddNetworkString("PlayURL::Stop")

function PlayURL.Play(ply, url, volume)
    if not url then return end
    if not volume then volume = 1 end

    volume = volume / 100

    net.Start("PlayURL::Play")
        net.WriteString(url)
        net.WriteFloat(volume)
    net.Broadcast()
    if not ply:IsPlayer() then return end
    print("[PlayURL] ".. ply:Nick() .. " is playing URL [" .. url .. "] with volume [" .. volume .. "]")
end

function PlayURL.Stop(ply)
    net.Start("PlayURL::Stop")
    net.Broadcast()
    if not ply:IsPlayer() then return end
    print("[PlayURL] ".. ply:Nick() .. " stopped playing URL")
end

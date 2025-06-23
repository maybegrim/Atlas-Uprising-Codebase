AU = AU or {}

AU.PingCollar = AU.PingCollar or {}

AU.PingCollar.CachedPlayers = AU.PingCollar.CachedPlayers or {}

AU.PingCollar.SoundRadius = 800

AU.PingCollar.VolumeCurve = function (distance)
    local maxDistance = AU.PingCollar.SoundRadius
    local minVolume = 0.1  -- Minimum volume level when at maximum distance
    return math.Clamp(1 - (distance / maxDistance), minVolume, 1)
end

AU.PingCollar.ActivationTime = 2
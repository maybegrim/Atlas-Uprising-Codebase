AU = AU or {}

AU.BombCollar = AU.BombCollar or {}

AU.BombCollar.CachedPlayers = AU.BombCollar.CachedPlayers or {}

AU.BombCollar.ExplosionRadius = 400

AU.BombCollar.DamageCurve = function (distance)
    return 50000 / (distance + 50) - 50
end

AU.BombCollar.DetonationTime = 120
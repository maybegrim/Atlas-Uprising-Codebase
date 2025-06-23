AddCSLuaFile()

AU = AU or {}

AU.SupplyDepot = AU.SupplyDepot or {}

AU.SupplyDepot.AmmoCrate = AU.SupplyDepot.AmmoCrate or {}

AU.SupplyDepot.AmmoCrate.AmmoPerSupply = 600
AU.SupplyDepot.AmmoCrate.MedsPerSupply = 100

AU.SupplyDepot.AmmoCrate.MaxHemostates = 10
AU.SupplyDepot.AmmoCrate.MaxBandages = 16
AU.SupplyDepot.AmmoCrate.MaxQuikclots = 6

AU.SupplyDepot.AmmoCrate.WhitelistedAmmoTypes = {
    ["AR2"] = true,
    ["Pistol"] = true,
    ["SMG1"] = true,
    ["357"] = true,
    ["RPG_Round"] = false,
    ["XBowBolt"] = true,
    ["Buckshot"] = true,
    ["SniperRound"] = true,
    ["SniperPenetratedRound"] = true,
    ["9mmRound"] = true,
    ["357Round"] = true,
    ["BuckshotHL1"] = true,
    ["XBowBoltHL1"] = true,
    [".30 Carbine"] = true,
    [".30 Winchester"] = true,
    [".30-06"] = true,
    [".338 Lapua"] = true,
    [".357 Magnum"] = true,
    [".357 SIG"] = true,
    [".380 ACP"] = true,
    [".40 S&W"] = true,
    [".416 Barrett"] = true,
    [".44 Magnum"] = true,
    [".45 ACP"] = true,
    [".454 Casull"] = true,
    [".50 AE"] = true,
    [".50 BMG"] = true,
    ["10x25MM"] = true,
    ["12 Gauge"] = true,
    ["23x75MMR"] = true,
    ["4.6x30MM"] = true,
    ["5.45x39MM"] = true,
    ["5.56x45MM"] = true,
    ["5.7x28MM"] = true,
    ["5.7x29MM"] = true,
    ["7.62x39MM"] = true,
    ["7.62x51MM"] = true,
    ["7.62x54MMR"] = true,
    ["9x17MM"] = true,
    ["9x18MM"] = true,
    ["9x19MM"] = true,
    ["9x39MM"] = true,
    ["FN 5.7x28MM"] = true,
    ["Grenade"] = true,
    [".300 AAC Blackout"] = true,
}

AU.SupplyDepot.HubCratesPerDepotCrate = 15
AddCSLuaFile()

BaseDefense.Factions = {
    {
        name = "The Foundation",
        tiers = {
            [1] = 500000,
            [2] = 1000000,
            [3] = 1500000
        }
    },
    {
        name = "Chaos Insurgency",
        tiers = {
            [1] = 150000,
            [2] = 350000,
            [3] = 500000
        }
    }
}

function BaseDefense.CanAccess(ply)
    return ply:IsSuperAdmin()
end
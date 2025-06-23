AddCSLuaFile()

if SERVER then
    function AU.SupplyDepot.SpawnCrate()
        table.Random(ents.FindByClass("au_depot")):SpawnCrate()
    end
end
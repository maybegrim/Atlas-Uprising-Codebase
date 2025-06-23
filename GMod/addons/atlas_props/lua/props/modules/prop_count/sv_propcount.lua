util.AddNetworkString("AtlasPropCount.Notify")
function ATLASPROPS.CanSpawn(ply, model)
    if ply:HasPermission("props") then return true end
    if ATLASPROPS.CFG.PropTeams[team.GetName(ply:Team())] and ply.AtlasPropCount < ATLASPROPS.CFG.PropCount then
        return true
    end
    return false
end

hook.Add("PlayerSpawnProp", "PropCount", function(ply, model)
    if ATLASPROPS.CanSpawn(ply, model) then
        if not ply:HasPermission("props") then
            return true
        else
            return
        end
    else
        return false
    end
end)

hook.Add("PlayerSpawnedProp", "PropCount", function(ply, model, ent)
    if not ATLASPROPS.CFG.PropTeams[ply:Team()] then return end
    if ATLASPROPS.CanSpawn(ply, model) then
        ply.AtlasPropCount = ply.AtlasPropCount + 1
        net.Start("AtlasPropCount.Notify")
        net.WriteUInt(ply.AtlasPropCount, 16)
        net.Send(ply)
    end
end)

-- Scuffed but it works
hook.Add("CanUndo", "PropCount", function(ply, undoTab)
    if not ATLASPROPS.CFG.PropTeams[ply:Team()] then return end
    if undoTab.Name == "Prop" and undoTab.Owner == ply then
        ply.AtlasPropCount = ply.AtlasPropCount - 1
        net.Start("AtlasPropCount.Notify")
        net.WriteUInt(ply.AtlasPropCount, 16)
        net.Send(ply)
    end
end)

hook.Add("PlayerInitialSpawn", "PropCount", function(ply)
    ply.AtlasPropCount = 0
end)
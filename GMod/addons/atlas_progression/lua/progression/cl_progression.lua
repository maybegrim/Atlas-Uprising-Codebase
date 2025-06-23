PROGRESSION.CL = PROGRESSION.CL or {}

PROGRESSION.CL.CurrentUpgrades = PROGRESSION.CL.CurrentUpgrades or {}

function PROGRESSION.CL.CanUse(ply)
    return PROGRESSION.CFG.CANUSE[ply:Team()] and true or false
end

net.Receive("PROGRESSION.SV.SendData", function()
    local ply = net.ReadEntity()
    local data = net.ReadTable()
    if ply == LocalPlayer() then
        PROGRESSION.CL.CurrentUpgrades = data
    else
        PROGRESSION.CL.CurrentUpgrades = {}
    end
    CURRENT_UPGRADE_PLY = {ply = ply, data = data}
    PrintTable(CURRENT_UPGRADE_PLY)
end)

net.Receive("PROGRESSION.CL.OpenMenu", function()
    PROGRESSION.CL.OpenUpgradePanel()
end)
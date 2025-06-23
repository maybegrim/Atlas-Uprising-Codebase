--
net.Receive("NCS_INFILTRATORS_AddInfiltrator", function()
    local NAME = net.ReadString()
    local TEAM = net.ReadUInt(8)
    local PLAYER = net.ReadUInt(8)

    if PLAYER and Entity(PLAYER) then
        PLAYER = Entity(PLAYER)

        NCS_INFILTRATOR.INFILTRATORS[PLAYER] = {
            newName = NAME,
            newJob = TEAM,
        }
    end
end )

net.Receive("NCS_INFILTRATORS_DelInfiltrator", function()
    local PLAYER = net.ReadUInt(8)

    if PLAYER and Entity(PLAYER) then
        PLAYER = Entity(PLAYER)

        NCS_INFILTRATOR.INFILTRATORS[PLAYER] = nil
    end
end )

net.Receive("NCS_INFILTRATORS_UpdInfiltrator", function()
    local COUNT = net.ReadUInt(8)

    for i = 1, COUNT do
        local PLAYER = net.ReadUInt(8)

        if PLAYER and Entity(PLAYER) then
            PLAYER = Entity(PLAYER)

            NCS_INFILTRATOR.INFILTRATORS[PLAYER] = {
                newName = net.ReadString(),
                newJob = net.ReadUInt(8),
            }
        end
    end
end )
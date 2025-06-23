-- Allow playing scream on a user by user basis while still originating fromm SCP-1048-A
net.Receive("scp1048:playscream", function(len, ply)

    local ScreamSource = net.ReadEntity()
    local ScreamSoundFile = net.ReadString()

    ScreamSource:EmitSound(ScreamSoundFile, 65, 100, 1, CHAN_AUTO)

end)
--[[
net.Receive("PA::notifyallplayers",function (len,ply)
    if RPExtraTeams[ply:Team()].faction == "FOUNDATION" then
        local eventmessage = net.ReadString()
        AAUDIO.ANNOUNCEMENTS.Play("atlas_audio/announcements/"..eventmessage)
    end
end)
]]--
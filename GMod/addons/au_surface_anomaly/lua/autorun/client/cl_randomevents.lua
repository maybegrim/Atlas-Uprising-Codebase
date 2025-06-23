AU_Distortion = AU_Distortion or {}
AU_Distortion.Controllers = AU_Distortion.Controllers or {}
AU_Distortion.Config = AU_Distortion.Config or {}

--[[
net.Receive("PA::notifyallplayers",function (len,ply)
    if RPExtraTeams[ply:Team()].faction == "FOUNDATION" then
        local eventmessage = net.ReadString()
        AAUDIO.ANNOUNCEMENTS.Play("atlas_audio/announcements/"..eventmessage)
    end
end)
]]--
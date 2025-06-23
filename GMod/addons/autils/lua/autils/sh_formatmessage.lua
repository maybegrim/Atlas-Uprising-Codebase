AddCSLuaFile()

if CLIENT then
    net.Receive("AUtils.FormattedMessage", function ()
        chat.AddText(unpack(net.ReadTable()))
    end)
else
    util.AddNetworkString("AUtils.FormattedMessage")

    local ply_meta = FindMetaTable("Player")

    function ply_meta:FormattedMessage(...)
        net.Start("AUtils.FormattedMessage")
            net.WriteTable({...})
        net.Send(self)
    end

    function autil.FormattedMessage(targets, ...)
        if not targets then
            net.Start("AUtils.FormattedMessage")
                net.WriteTable({...})
            net.Broadcast()
        elseif IsEntity(targets) and targets:IsPlayer() then
            net.Start("AUtils.FormattedMessage")
                net.WriteTable({...})
            net.Send(targets)
        elseif istable(targets) then
            for _,target in ipairs(targets) do
                net.Start("AUtils.FormattedMessage")
                    net.WriteTable({...})
                net.Send(target)
            end
        end
    end
end
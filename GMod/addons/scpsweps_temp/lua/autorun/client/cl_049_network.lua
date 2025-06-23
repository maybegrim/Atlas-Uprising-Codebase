net.Receive( "049_msg", function()
    chat.AddText( Color(245,201,98), "[SCP-049] ", Color( 255, 255, 255), net.ReadString() )
end )

net.Receive("049_sendinfected_effects", function()
    local time = tonumber(net.ReadString())
    LocalPlayer():ConCommand('')

    timer.Simple(time, function()
        if timer.Exists("049_dying") then
            timer.Remove("049_dying")
        end
    end)
end)

net.Receive("049_cancelall", function()
    if timer.Exists("049_dying") then
        timer.Remove("049_dying")
    end
end)
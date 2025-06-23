net.Receive("sam_sendannounce", function()
    local message = net.ReadTable()
    for i, message in pairs(message) do
        chat.AddText(message)
    end
end)
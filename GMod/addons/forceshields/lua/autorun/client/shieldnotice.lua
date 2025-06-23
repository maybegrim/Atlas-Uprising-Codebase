net.Receive("shieldnotifyau", function()
    if timer.Exists("timershieldcool") then return end
    timer.Create("timershieldcool", 65, 1, function() chat.AddText(Color(255, 56, 56), "[ShieldOS] ", Color(255, 255, 255), "Shield Ready!") end)
    local time = timer.TimeLeft("timershieldcool")
end)
net.Receive("shieldnotifyau2", function()
    chat.AddText(Color(255, 56, 56), "[ShieldOS] ", Color(255, 255, 255), "Shield Deployed!")
    chat.AddText(Color(255, 56, 56), "[ShieldOS] ", Color(255, 255, 255), "Recharging Shield...")
end)

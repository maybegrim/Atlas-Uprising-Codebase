net.Receive("WELCOMEUI::SendRules", function()
    WELCOMEUI.ShowRules()
end)

net.Receive("WELCOMEUI::SendIntro", function()
    WELCOMEUI.PlayIntro()
    --WELCOMEUI.MainMenu.Open()
end)

function WELCOMEUI.StartPress()
    if table.IsEmpty(CHARACTER.MyCharacters) then
        WELCOMEUI.MainMenu.Close()
        timer.Simple(0.75, function()
            CHARACTER.OpenJobSelectScreen()
        end)
    else
        CHARACTER.OpenCharScreen()
        WELCOMEUI.MainMenu.Close()
    end
end
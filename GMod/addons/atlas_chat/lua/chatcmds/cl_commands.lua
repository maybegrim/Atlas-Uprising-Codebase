CHAT_CMDS.Commands = {
    ["rules"] = function(ply)
        gui.OpenURL("https://docs.google.com/document/d/1Cy3Gwo9PCMjhZfAiNNPf2Moa1Q1CEFluu6s5OBHyWF4/edit?usp=sharing")
    end,
    ["discord"] = function(ply)
        gui.OpenURL("https://discord.gg/atlasuprising")
    end,
    ["forums"] = function(ply)
        gui.OpenURL("https://discord.gg/atlasuprising")
    end,
    ["fps"] = function(ply)
        FPSBOOST.CreateUI()
    end,
    ["store"] = function(ply)
        gui.OpenURL("https://store.atlasuprising.com/")
    end,
    ["donate"] = function(ply)
        gui.OpenURL("https://store.atlasuprising.com/")
    end,
}

-- on player chat clientside hook
hook.Add("OnPlayerChat", "AtlasUprising_ChatCommands", function(ply, text)
    if ply ~= LocalPlayer() then return end
    if string.sub(text, 1, 1) == "!" then
        local cmd = string.lower(string.sub(text, 2))
        
        if CHAT_CMDS.Commands[cmd] then
            CHAT_CMDS.Commands[cmd](ply)
            return true
        end
    end
end)

-- Advert System
CHAT_CMDS.Adverts = {
    ["discord"] = {
        ["text"] = ":link: Join our {#7289da discord} at https://discord.gg/atlasuprising",
        ["interval"] = 400
    },
    -- ["store"] = {
    --     ["text"] = ":small_orange_diamond: Consider {#f09e5b supporting us} by making a purchase at https://store.atlasuprising.com/",
    --     ["interval"] = 500
    -- },
}

-- Advert System
for k, v in pairs(CHAT_CMDS.Adverts) do
    timer.Create("AtlasUprising_Advert_" .. k, v.interval, 0, function()
        chat.AddText(Color(255, 255, 255), v.text)
    end)
end
concommand.Add("dev_closeuis", function()
    if !LocalPlayer():IsSuperAdmin() then return end
    WELCOMEUI.CloseRules()
    WELCOMEUI.CloseIntro()
    CHARACTER.CloseCharScreen()
    CHARACTER.CloseCharCreation()
end)

concommand.Add("char_open_char_creation", function()
    if !LocalPlayer():IsSuperAdmin() then return end
    CHARACTER.OpenCharCreation()
end)

concommand.Add("char_open_char_screen", function()
    if !LocalPlayer():IsSuperAdmin() then return end
    CHARACTER.OpenCharScreen()
end)

local function PrintAllDFrames(panel, indent)
    indent = indent or ""
    if panel.GetChildren then
        local children = panel:GetChildren()
        
        for _, child in ipairs(children) do
            
            child:Remove()
            -- Recurse to find DFrames in child panels
            PrintAllDFrames(child, indent .. "  ")
        end
    end
end

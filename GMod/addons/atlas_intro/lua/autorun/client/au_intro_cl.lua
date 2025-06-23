local abs = {
    ["SCP-682 'Hard-To-Destroy Reptile"] = {
        ["Description"] = "SCP-682 is a large, vaguely reptile-like creature of unknown origin. It appears to be extremely intelligent. SCP-682 appears to have a hatred of all life",
        ["Image"] = "myimage.png",
        ["Abilities"] = [[
            Bite (Mouse 1)
            Bite your enemy, Eat him whole.
            ]]
    },
    ["SCP-457 'The Burning Man"] = {
        ["Description"] = " For all points and purposes, SCP-457 appears to be a sentient being composed of flame. SCP-457's actual composition is unknown, and has proven to be invisible and undetectable by any known means, but is shaped out by the flames it produces, often assuming a human-like form if given sufficient fuel to assume that size. SCP-457's most rudimentary form appears to be that of a single flame, comparable in size to that of a matchstick. In this form, SCP-457 possesses only the simplest of directives and shows no signs of being unusual compared to any other flame beyond a penchant for suddenly flickering to burn human hands, and the ability to 'jump' to more flammable materials or other flames, which it then assimilates into its total form.",
        ["Image"] = "myimage.png",
        ["Abilities"] = [[
            Burn.. (Passive)
            People around you start burning because of the heat you give off.
            ]]
    },
    ["SCP-106 'The Old Man"] = {
        ["Description"] = "SCP-106 appears to be an elderly humanoid, with a general appearance of advanced decomposition. This appearance may vary, but the “rotting” quality is observed in all forms. SCP-106 is not exceptionally agile, and will remain motionless for days at a time, waiting for prey. SCP-106 is also capable of scaling any vertical surface and can remain suspended upside down indefinitely. When attacking, SCP-106 will attempt to incapacitate prey by damaging major organs, muscle groups, or tendons, then pull disabled prey into its pocket dimension. SCP-106 appears to prefer human prey items in the 10-25 years of age bracket.",
        ["Image"] = "myimage.png",
        ["Abilities"] = [[
            Grab (MB1)
            You grab somebody and pull them into the void...
            ]]
    },
    ["SCP-096 'The Shy Guy"] = {
        ["Description"] = "SCP-096 is a humanoid creature measuring approximately 2.38 meters in height. Subject shows very little muscle mass, with preliminary analysis of body mass suggesting mild malnutrition. Arms are grossly out of proportion with the rest of the subject's body, with an approximate length of 1.5 meters each. Skin is mostly devoid of pigmentation, with no sign of any body hair.",
        ["Image"] = "myimage.png",
        ["Abilities"] = [[
            Smash & Crack (MB1)
            You split somebody in two.
            ]]
    },
    ["SCP-049 'The Plague Doctor"] = {
        ["Description"] = "SCP-049 is humanoid in appearance, standing at 1.9 m tall and weighing 95.3 kg; however, the Foundation is currently incapable of studying its face and body more fully, as it is covered in what appears to be the garb of the traditional 'Plague Doctor' from 15-16th century Europe. This material is actually a part of SCP-049's body, as microscopic and genetic testing show it to be similar in structure to muscle, although it feels much like rough leather, and the mask much like ceramic. It was found in ██████, France, by local police. It was responding to an outbreak of a pestilence, SCP-049 was discovered and detained by Foundation operatives, and has since been contained.",
        ["Image"] = "myimage.png",
        ["Abilities"] = [[
            Pestilence Injection (MB1)
            Check whether the person infront of you has the disease. If they do you will 'Cure' them turning them into a loyal zombie servant.
            ]]
    },
}

local isopen = false
local cool = nil

local function open_intro()
    local ply = LocalPlayer()
    if cool and cool:IsValid() then cool:Remove() return end
    if not abs[team.GetName(ply:Team())] then return end
    local info = abs[team.GetName(ply:Team())]
    local scrW, scrH = ScrW(), ScrH()
    local panelWidth, panelHeight = scrW * 0.25, scrH * 0.4
    local margin = 20
    cool = vgui.Create("DPanel")
    cool:SetSize(scrW, scrH)
    cool:SetPos()
    cool:SetBackgroundColor(Color(0,0,0,0))
    -- Left Panel
    local leftPanel = vgui.Create("DPanel", cool)
    leftPanel:SetSize(panelWidth, panelHeight)
    leftPanel:SetPos(margin, ScrH() * 0.3)
    leftPanel:SetBackgroundColor(Color(50, 50, 50, 200))
    
    leftPanel.Paint = function(self, w, h)
        -- Draw the panel's background manually if needed
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
    
        -- Draw the border
        surface.SetDrawColor(160, 160, 160, 255) -- White border color
        surface.DrawOutlinedRect(0, 0, w, h, 2) -- The last parameter is the border thickness
    end
    
    local leftImage = vgui.Create("DImage", leftPanel)
    leftImage:SetSize(panelWidth * 0.5, panelWidth * 0.5)
    leftImage:SetPos((panelWidth - leftImage:GetWide()) / 2, 10)
    leftImage:SetImage(info["Image"]) -- Placeholder image
    
    local leftLabel = vgui.Create("DLabel", leftPanel)
    leftLabel:SetPos(10, leftImage:GetTall() / 1.5 + 25)
    leftLabel:SetSize(panelWidth - 20, panelHeight - leftImage:GetTall() - 30)
    leftLabel:SetText(info["Description"])
    leftLabel:SetWrap(true)
    leftLabel:SetFont("Trebuchet18")
    leftLabel:SetTextColor(Color(255, 255, 255))
    
    -- Right Panel
    local rightPanel = vgui.Create("DPanel", cool)
    rightPanel:SetSize(panelWidth, panelHeight)
    rightPanel:SetPos(scrW - panelWidth - margin, scrH * 0.3)
    rightPanel:SetBackgroundColor(Color(50, 50, 50, 200))
    rightPanel.Paint = function(self, w, h)
        -- Draw the panel's background manually if needed
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 200))
    
        -- Draw the border
        surface.SetDrawColor(160, 160, 160, 255) -- White border color
        surface.DrawOutlinedRect(0, 0, w, h, 2) -- The last parameter is the border thickness
    end
    
    local abilityText = info["Abilities"]
    
    local rightLabel = vgui.Create("DLabel", rightPanel)
    rightLabel:SetPos(10, 10)
    rightLabel:SetSize(panelWidth - 20, panelHeight - 20)
    rightLabel:SetText(abilityText)
    rightLabel:SetWrap(true)
    rightLabel:SetFont("Trebuchet18")
    rightLabel:SetTextColor(Color(255, 255, 255))
end


hook.Add( "Think", "INTRO_CHECK", function()
    if cool and cool:IsValid() then 
        if not input.IsKeyDown( KEY_F2 ) then
            cool:Remove()
        end
        return
    end

	if input.IsKeyDown( KEY_F2 ) then open_intro() end
end )


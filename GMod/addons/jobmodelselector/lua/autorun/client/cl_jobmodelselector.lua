-- Open menu for selecting category and job
local function OpenJobPicker()

    local SelectedJob = nil
    local SelectedModel = nil

    -- Basic frame
    Frame = vgui.Create("DFrame")
    Frame:SetSize(ScrW() * 0.2, ScrH() * 0.45)
    Frame:SetTitle("[Easy Model Selector]")
    Frame:Center()
    Frame:MakePopup()

    -- Select category dropdown selector
    local Category = vgui.Create("DComboBox", Frame)
    Category:Dock(TOP)
    Category:DockMargin(ScrW() * 0.001, ScrH() * 0.01, ScrW() * 0.001, 0)
    Category:SetValue("Select Category...")
    for k, v in pairs(DarkRP.getCategories()["jobs"]) do
        Category:AddChoice(v.name, DarkRP.getCategories()["jobs"][k])
    end

    -- Select category dropdown selector
    local Job = vgui.Create("DComboBox", Frame)
    Job:Dock(TOP)
    Job:DockMargin(ScrW() * 0.001, ScrH() * 0.01, ScrW() * 0.001, 0)
    Job:SetValue("Select Job...")
    Job:SetEnabled(false)
    function Category:OnSelect(index, value, data)
        Job:Clear()
        Job:SetEnabled(true)

        for k, v in pairs(RPExtraTeams) do
            if (v.category == value) then
                Job:AddChoice(v.name, RPExtraTeams[k])
            end
        end
    end
    function Job:OnSelect(index, value, data)
        SelectedJob = data
        ReloadModels(data)
    end
    

    local ModelList = vgui.Create("DPanelList", Frame)
    ModelList:Dock(TOP)
    ModelList:DockMargin(ScrW() * 0.001, ScrH() * 0.01, ScrW() * 0.001, 0)
    ModelList:SetHeight(ScrH() * 0.3)
    ModelList:EnableVerticalScrollbar(true)
    ModelList:EnableHorizontal(true)
    ModelList:SetPadding(10)
    ModelList:SetSpacing(5)

    -- Load models associated with the chosen job and display them
    function ReloadModels(data)
        ModelList:Clear()
        
        local models = istable(data.model) and data.model or {data.model}

        local selected = nil
        for _, Model in pairs(models) do
            local ModelIcon = vgui.Create("SpawnIcon")
            ModelIcon:SetPos(64, 64)
            ModelIcon:SetModel(Model)
            ModelList:AddItem(ModelIcon)
            function ModelIcon:DoClick()
                SetClipboardText(Model)
                LocalPlayer():ChatPrint(Model)
                notification.AddLegacy("Model copied to clipboard", NOTIFY_GENERIC, 2)
                surface.PlaySound("ui/buttonclickrelease.wav")
            end
            local oldPaint = ModelIcon.Paint
            function ModelIcon:Paint(width, height)
                oldPaint(width, height)

                if self == selected then
                    draw.RoundedBox(0, 0, 0, width, height, Color(75, 200, 250, 200))
                end
            end
        end
    end

end

net.Receive("OpenJobModelSelector", OpenJobPicker)

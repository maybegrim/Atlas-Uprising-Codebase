FPSBOOST = FPSBOOST or {}

FPSBOOST.CMDMethods = {}

function addCMDMethod(key, title, cmd, cmdDisabled)
    FPSBOOST.CMDMethods[key] = {
        title = title,
        cmd = cmd,
        cmdDisabled = cmdDisabled
    }
end

addCMDMethod("multicore", "Multicore Rendering", {"gmod_mcore_test 1", "r_queued_ropes 1"}, {"gmod_mcore_test 0", "r_queued_ropes 1"})
addCMDMethod("teeth", "Remove Teeth", {"r_teeth 0"}, {"r_teeth 1"})
addCMDMethod("shadow", "Lower Shadow Quality", {"mat_shadowstate 0", "r_shadowmaxrendered 0", "r_shadowrendertotexture 0", "nb_shadow_dist 0"}, {"mat_shadowstate 1", "r_shadowmaxrendered 32", "r_shadowrendertotexture 1", "nb_shadow_dist 400"})
--addCMDMethod("texture_filtering", "Disable Texture Filtering", {"mat_filtertextures 0"}, {"mat_filtertextures 1"})
addCMDMethod("m9k_effect", "Disable M9K Effect", {"M9KGasEffect 0"}, {"M9KGasEffect 1"})
addCMDMethod("engine_behavior", "Modify Engine Behavior", {"r_threaded_particles 1", "r_threaded_renderables -1", "cl_threaded_client_leaf_system 1", "r_threaded_client_shadow_manager 1"}, {"r_threaded_particles 0", "r_threaded_renderables 0", "cl_threaded_client_leaf_system 0", "r_threaded_client_shadow_manager 0"})
addCMDMethod("hardware_acceleration", "Hardware Acceleration", {"r_fastzreject -1"}, {"r_fastzreject 0"})
addCMDMethod("blood_effects", "Disable Blood Effects", {"violence_ablood 0", "violence_agibs 0", "violence_hblood 0", "violence_hgibs 0"}, {"violence_ablood 1", "violence_agibs 1", "violence_hblood 1", "violence_hgibs 1"})
addCMDMethod("small_objects", "Disable Small Objects", {"cl_phys_props_enable 0", "cl_phys_props_max 0", "props_break_max_pieces 0"}, {"cl_phys_props_enable 1", "cl_phys_props_max 128", "props_break_max_pieces -1"})
addCMDMethod("bloom", "Disable Bloom", {"mat_bloom_scalefactor_scalar 0", "mat_bloomscale 0", "mat_disable_bloom 1"}, {"mat_bloom_scalefactor_scalar 1", "mat_bloomscale 1", "mat_disable_bloom 0"})
addCMDMethod("water_splash", "Disable Water Splash", {"cl_show_splashes 0"}, {"cl_show_splashes 1"})
addCMDMethod("weapon_effects", "Disable Weapon Effects", {"cl_ejectbrass 0", "muzzleflash_light 0"}, {"cl_ejectbrass 1", "muzzleflash_light 1"})



function FPSBOOST.RunMethod(method)
    if not method then return end
    if method.cmd then
        for k, v in pairs(method.cmd) do
            local cmd, arg = string.match(v, "^(%S+)%s+(%S+)$")
            if cmd and arg then
                RunConsoleCommand(cmd, arg)
                print(cmd, arg)
            end
        end
    end
end

function FPSBOOST.RunMethodDisabled(method)
    if not method then return end
    if method.cmdDisabled then
        for k, v in pairs(method.cmdDisabled) do
            local cmd, arg = string.match(v, "^(%S+)%s+(%S+)$")
            if cmd and arg then
                RunConsoleCommand(cmd, arg)
                print(cmd, arg)
            end
        end
    end
end

surface.CreateFont("FPSBoost", {
    font = "MADE Tommy",
    size = 20,
    weight = 700
})

surface.CreateFont("FPSBoostButton", {
    font = "MADE Tommy",
    size = 18,
    weight = 600
})

function FPSBOOST.CreateUI()
    -- Create the main frame
    local frame = vgui.Create("DFrame")
    frame:SetTitle("FPS Booster")
    frame:SetSize(ScrW() * 0.5, ScrH() * 0.7)
    frame:Center()
    frame:MakePopup()
    frame:SetBackgroundBlur(true)
    frame:SetDraggable(true)
    frame:ShowCloseButton(true)
    frame:SetDeleteOnClose(true)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(12, 0, 0, w, h, Color(40, 40, 40, 250))
        draw.RoundedBox(12, 0, 0, w, 30, Color(30, 30, 30, 250))
    end

    -- Create a scroll panel to hold the buttons
    local scrollPanel = vgui.Create("DScrollPanel", frame)
    scrollPanel:Dock(FILL)

    -- Customize scrollbar for dark mode
    local sbar = scrollPanel:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(60, 60, 60))
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(80, 80, 80))
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(80, 80, 80))
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(100, 100, 100))
    end

    -- Function to create a button for each method
    local function createMethodButton(methodKey, methodData)
        local panel = vgui.Create("DPanel", scrollPanel)
        panel:Dock(TOP)
        panel:DockMargin(10, 10, 10, 10)
        panel:SetTall(70)
        panel.Paint = function(self, w, h)
            draw.RoundedBox(12, 0, 0, w, h, Color(50, 50, 50, 250))
        end

        local label = vgui.Create("DLabel", panel)
        label:SetText(methodData.title)
        label:Dock(LEFT)
        label:SetWide(300)  -- Increased to accommodate the button
        label:SetContentAlignment(4)
        label:SetFont("FPSBoost")
        label:SetTextColor(Color(255, 255, 255))
        label:DockMargin(10, 0, 0, 0)

        local toggleButton = vgui.Create("DButton", panel)
        toggleButton:SetSize(100, 40)
        toggleButton:Dock(RIGHT)
        toggleButton:DockMargin(0, 15, 15, 15)  -- Margins to center vertically and add spacing
        toggleButton:SetFont("FPSBoostButton")
        toggleButton:SetText("Enable")
        toggleButton.DoClick = function()
            if toggleButton:GetText() == "Enable" then
                FPSBOOST.RunMethod(FPSBOOST.CMDMethods[methodKey])
                chat.AddText(Color(255, 108, 82), ":wrench: FPS BOOST | ", Color(255, 255, 255), methodData.title, " :white_check_mark: ")
                toggleButton:SetText("Disable")
            else
                FPSBOOST.RunMethodDisabled(FPSBOOST.CMDMethods[methodKey])
                chat.AddText(Color(255, 108, 82), ":wrench: FPS BOOST | ", Color(255, 255, 255), methodData.title, " :no_entry_sign: ")
                toggleButton:SetText("Enable")
            end
        end
        toggleButton.Paint = function(self, w, h)
            if self:GetText() == "Enable" then
                if self:IsHovered() then
                    draw.RoundedBox(20, 0, 0, w, h, Color(102, 204, 102, 250)) -- Lighter green when hovered
                else
                    draw.RoundedBox(20, 0, 0, w, h, Color(0, 153, 0, 250)) -- Darker green otherwise
                end
                else
                if self:IsHovered() then
                    draw.RoundedBox(20, 0, 0, w, h, Color(255, 102, 102, 250)) -- Lighter red when hovered
                else
                    draw.RoundedBox(20, 0, 0, w, h, Color(204, 0, 0, 250)) -- Darker red otherwise
                end
            end
            self:SetTextColor(Color(255, 255, 255))
        end

        -- Update button state based on the current command values
        panel.Think = function()
            local isEnabled = false
            for _, cmd in ipairs(methodData.cmd) do
                local cmdName, expectedValue = string.match(cmd, "^(%S+)%s+(%S+)$")
                if cmdName and expectedValue then
                    isEnabled = GetConVar(cmdName):GetString() == expectedValue
                    if not isEnabled then break end
                end
            end
            if isEnabled then
                toggleButton:SetText("Disable")
            else
                toggleButton:SetText("Enable")
            end
        end
    end

    -- Create a button for each method in FPSBOOST.CMDMethods
    for methodKey, methodData in pairs(FPSBOOST.CMDMethods) do
        createMethodButton(methodKey, methodData)
    end
end

-- Create a console command to open the UI
concommand.Add("fpsboost_ui", function()
    FPSBOOST.CreateUI()
end)

-- force all to enable
for methodKey, methodData in pairs(FPSBOOST.CMDMethods) do
    FPSBOOST.RunMethod(FPSBOOST.CMDMethods[methodKey])
end

-- Extra background FPS boost

-- disable widget tick
timer.Simple(1, function()
    hook.Remove("PlayerTick", "TickWidgets")
end)
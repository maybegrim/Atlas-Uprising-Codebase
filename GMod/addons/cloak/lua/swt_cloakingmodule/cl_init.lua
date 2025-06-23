--[[
    =================================================
    ███████╗██╗    ██╗████████╗    ██████╗███╗   ███╗
    ██╔════╝██║    ██║╚══██╔══╝   ██╔════╝████╗ ████║
    ███████╗██║ █╗ ██║   ██║█████╗██║     ██╔████╔██║
    ╚════██║██║███╗██║   ██║╚════╝██║     ██║╚██╔╝██║
    ███████║╚███╔███╔╝   ██║      ╚██████╗██║ ╚═╝ ██║
    ╚══════╝ ╚══╝╚══╝    ╚═╝       ╚═════╝╚═╝     ╚═╝
    =================================================
    -> Shadow-Trooper Cloaking Module

    _______________________________
    Created by
        - Speedcup (https://steamcommunity.com/id/speedcup/ - 76561198261053079)
        - Schmockwurst (https://steamcommunity.com/id/schmockwurst/ - 76561198197583550)
]]

--[[-------------------------------------------------------------------
    SWT-CM - Client
--]]-------------------------------------------------------------------

--[[-------------------------------------------------------------------
    Meta Functions
    Used literally for everything thats called clientside.
--]]-------------------------------------------------------------------
local Player_Meta = FindMetaTable("Player")

SWT_CM.PlayerRelations = SWT_CM.PlayerRelations or {}
--[[
    SWT_CM.PlayerRelations[ent] = {relations}
]]--

--[[
    Function: Player:AddToRelations(ply)
    Meta: Player (the current cloaked swt, localplayer)

    Params:
        ply - ply to add to players relations.
]]
function Player_Meta:AddToRelations(ent)
    -- Check if the table exists, if not, creatae it.
    if not istable(SWT_CM.PlayerRelations[self:SteamID64()]) then
        SWT_CM.PlayerRelations[self:SteamID64()] = {}
    end

    -- Just copy the old relations and add the new one.
    local oldRelations = table.Copy(self:GetRelations())

    -- Check whether the relation already exists.
    if table.HasValue(oldRelations, ent) then
        return
    end

    table.insert(oldRelations, ent)
    SWT_CM.PlayerRelations[self:SteamID64()] = oldRelations

    if ent:IsPlayer() then
        SWT_CM:Print("Successfully added '" .. ent:GetName() .. "' as " .. self:GetRelationType(ent).name, "success", true)
    else
        SWT_CM:Print("Successfully added '" .. ent:GetClass() .. "' as " .. self:GetRelationType(ent).name, "success", true)
    end
end

--[[
    Function: Player:GetRelations() -> table
    Meta: Player (the current cloaked swt, localplayer)

    Returns:
        table - relations, every relation of the player.
            -> {
                [ent1] = {...},
                [ent2] = {...}
            }
]]
function Player_Meta:GetRelations()
    return SWT_CM.PlayerRelations[self:SteamID64()] or {}
end

--[[
    Function: Player_Meta:GetRelationType(ent: Entity) -> table
    Meta: Player (the current cloaked swt, localplayer)

    Returns:
        table - relationType
]]
function Player_Meta:GetRelationType(ent)
    if not IsValid(ent) then
        return SWT_CM.Config.RelationTypes["unknown"]
    end

    -- First of all, check if any relation saved exists.
    if table.HasValue(self:GetRelations(), ent) then
        -- Enemy Check
        if SWT_CM.Config.RelationEnemy(ent, LocalPlayer()) then
            return SWT_CM.Config.RelationTypes["enemy"]
        end

        if SWT_CM.Config.RelationAlly(ent, LocalPlayer()) then
            return SWT_CM.Config.RelationTypes["ally"]
        end

        return SWT_CM.Config.RelationTypes["known"]
    end

    return SWT_CM.Config.RelationTypes["unknown"]
end

-- Reset RelationTable on disconnect :)!
gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "SWT_CM.PlayerDisconnect", function( data )
    if SWT_CM.Config.ResetRelationsOnDisconnect then
        local steamId = data.networkid
        local steamId64 = util.SteamIDTo64(steamId)
        if table.HasValue(SWT_CM.PlayerRelations, steamId64) then
            SWT_CM.PlayerRelations[steamId64] = nil
        end
    end
end )

--[[-------------------------------------------------------------------
    Font Creation
    Create every font we need.
--]]-------------------------------------------------------------------
surface.CreateFont( "SWT-HUD-01", {
    font = "Roboto",
    extended = true,
    size = ScreenScale(5),
    weight = 500,
    blursize = 0,
    scanlines = 2,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
})

surface.CreateFont( "SWT-HUD-02", {
    font = "Roboto",
    extended = true,
    size = ScreenScale(30),
    weight = 500,
    blursize = 0,
    scanlines = 2,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
})

surface.CreateFont( "SWT-HUD-03", {
    font = "Roboto",
    extended = true,
    size = ScreenScale(15),
    weight = 500,
    blursize = 0,
    scanlines = 2,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true,
    additive = false,
    outline = false,
})

--[[-------------------------------------------------------------------
    UI-Creation
    Here we gonna create the entire UserInterface for the SWT_CM.
--]]-------------------------------------------------------------------
local ply = nil
local plys = {}

local function coordinates( ent )
    local min, max = ent:OBBMins(), ent:OBBMaxs()
    local corners = {
        Vector( min.x, min.y, min.z ),
        Vector( min.x, min.y, max.z ),
        Vector( min.x, max.y, min.z ),
        Vector( min.x, max.y, max.z ),
        Vector( max.x, min.y, min.z ),
        Vector( max.x, min.y, max.z ),
        Vector( max.x, max.y, min.z ),
        Vector( max.x, max.y, max.z )
    }

    local minX, minY, maxX, maxY = ScrW() * 2, ScrH() * 2, 0, 0
    for _, corner in pairs( corners ) do
        local onScreen = ent:LocalToWorld( corner ):ToScreen()
        minX, minY = math.min( minX, onScreen.x ), math.min( minY, onScreen.y )
        maxX, maxY = math.max( maxX, onScreen.x ), math.max( maxY, onScreen.y )
    end
 
    return minX, minY, maxX, maxY
end

timer.Create("ReloadCloakedPlayers", 5, 0, function()
    plys = {}

    for k, v in pairs(player.GetHumans()) do
        if v:IsCloaked() then
            table.insert(plys,v)
        end
    end
end)

hook.Add("PrePlayerDraw", "SWT_CM.StopDrawingOfCloaked",function(ent)
    if ent:IsCloaked() then
        if LocalPlayer():HasESPEnabled() then
            return false
        end

        local wep = ent:GetActiveWeapon()

        if IsValid(wep) then
            wep:SetNoDraw(true)
        end

        return true
    end
end)

hook.Add("PreDrawHalos", "DrawYourselfWhileCloaked", function()
    if LocalPlayer():HasESPEnabled() then
        halo.Add(plys, Color(100, 100, 255), 2, 2, 1, false, false)
    end
end)

hook.Add("HUDPaint", "SWT_CM.DrawVisorEffect", function()
    if LocalPlayer():HasWeapon("swt_cloakingmodule") then
        local w, h = ScrW(),ScrH()
        ply = LocalPlayer()

        surface.SetFont("SWT-HUD-02")
        local x, y = surface.GetTextSize(LocalPlayer():IsCloaked() and "Cloaked!" or "Visible")
        draw.SimpleTextOutlined(LocalPlayer():IsCloaked() and "Cloaked!" or "Visible", "SWT-HUD-02", w * 0.98 - x, h / 3 - y / 2, (LocalPlayer():IsCloaked() and Color(255,40,40,230)) or Color(0, 220, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))

        if SWT_CM.Config.EnableBatterySystem then
            draw.SimpleTextOutlined(math.Round(LocalPlayer().CloakBattery or SWT_CM.Config.MaxBattery, 2), "SWT-HUD-03", w * 0.98 - x, h / 2.5 - y / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
        end

        --ESP + NPC/Player-Marker + DontDrawCloakedPeople

        local entities = {}
        for k, v in pairs(player.GetAll()) do
            entities[k] = v
        end

        for k, v in pairs(ents.GetAll()) do
            if v:IsNPC() or v:IsNextBot() then
                entities[k] = v
            end
        end

        -- IDEA
        -- Maybe create a poll in further future, whether we should add a "ESP Activated / Deactivated" Text :)

        for k, v in pairs( entities ) do
            --if v:GetNWBool("SWT.cloaked",false)==true and IsValid(v:GetActiveWeapon()) then v:GetActiveWeapon():SetNoDraw(true) end
            if v ~= LocalPlayer() and LocalPlayer():HasESPEnabled() and ply ~= nil then
                local pos = v:GetPos()
                local dist = ply:GetPos():Distance( pos )
                local crosshair = ply:GetEyeTrace().HitPos:ToScreen()

                if dist < SWT_CM.Config.ESPDistance and dist > 35 and (crosshair.x - 30 < v:GetPos():ToScreen().x and crosshair.x + 30 > v:GetPos():ToScreen().x) then    		
                    if v:IsPlayer() or v:IsNPC() then
                        local x1, y1, x2, y2 = coordinates(v)

                        local relationTable = LocalPlayer():GetRelationType(v)
                        local relation_color_r, relation_color_g, relation_color_b = relationTable.color:Unpack()
                        surface.SetDrawColor(relation_color_r, relation_color_g, relation_color_b)

                        if (0 < x2 and x1 < ScrW()) and (0 < y2 and y1 < ScrH()) then 
                            surface.DrawLine( x1, y1, x2, y1 )
                            surface.DrawLine( x1, y1, x1, y2 )
                            surface.DrawLine( x2, y2, x1, y2 )
                            surface.DrawLine( x2, y2, x2, y1 )

                            origx1, origx2, origy1, origy2 = x1, x2, y1, y2

                            draw.SimpleTextOutlined("Type (Relation): " .. relationTable.name, "SWT-HUD-01", x2 + 4, y1, Color(250,250,250), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
                            y1 = y1 + 14

                            if v:Health() > 0 then
                                if v:GetActiveWeapon() ~= NULL then
                                    draw.SimpleTextOutlined("Weapon: " .. v:GetActiveWeapon():GetPrintName(), "SWT-HUD-01", x2 + 4, y1, Color(250,250,250), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
                                    y1 = y1 + 14
                                end
                                y1 = origy1

                                if relationTable.name ~= "Unknown" then
                                    if v:IsPlayer() then
                                        draw.SimpleTextOutlined("Name: " .. v:GetName(), "SWT-HUD-01",x1-4,y1,Color(250,250,250),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
                                    else
                                        draw.SimpleTextOutlined("Class: " .. v:GetClass(), "SWT-HUD-01",x1-4,y1,Color(250,250,250),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
                                    end

                                    y1 = y1 + 14
                                end

                                draw.SimpleTextOutlined("Status: Alive", "SWT-HUD-01",x1-4,y1,Color(250,250,250),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
                                y1 = y1 + 14

                                if SWT_CM.Config.ESPInformations["health"] then
                                    draw.SimpleTextOutlined("HP: " .. v:Health(), "SWT-HUD-01", x1 - 4, y1, Color(250,250,250), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
                                    y1 = y1 + 14
                                end

                                if SWT_CM.Config.ESPInformations["armor"] then
                                    if v:IsPlayer() then
                                        draw.SimpleTextOutlined("AP: " .. v:Armor(), "SWT-HUD-01", x1 - 4, y1, Color(250,250,250), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
                                    end
                                end
                            else
                                draw.SimpleTextOutlined("Status: Dead", "SWT-HUD-01", x1-4, origy1, Color(250,250,250), TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,1,Color(255,0,0,255)) y1=y1+14
                            end
                        end
                    end
                elseif dist < 800 and dist > 35 then
                    if v:IsNPC() or v:Alive() then
                        local bone = v:LookupBone("ValveBiped.Bip01_Head1")
                        if (v:IsPlayer() or v:IsNPC()) and isnumber(bone) == true then
                            pos = v:GetBonePosition(bone)
                        end

                        local screenPos = pos:ToScreen()
                        local relationTable = LocalPlayer():GetRelationType(v)

                        if (v:IsPlayer() and not v:IsCloaked()) or v:IsNPC() or v:IsNextBot() then
                            draw.RoundedBox(10, screenPos.x-5, screenPos.y - 5, 10, 10, relationTable.color)
                            draw.SimpleText(relationTable.name, "SWT-HUD-01", screenPos.x + 7, screenPos.y, relationTable.color, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                            draw.SimpleText(math.Round(dist/52.521,0) .. " m", "SWT-HUD-01", screenPos.x + 7, screenPos.y + 13, relationTable.color, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                        else
                            draw.RoundedBox(10, screenPos.x - 5, screenPos.y - 5, 10, 10,Color(50,00,230))
                            draw.SimpleText(relationTable.name .. " (Cloked)", "SWT-HUD-01", screenPos.x + 7, screenPos.y, relationTable.color, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                            draw.SimpleText(math.Round(dist / 52.521, 0) .. " m", "SWT-HUD-01", screenPos.x + 7, screenPos.y + 13, relationTable.color, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                        end
                    end
                end
            end
        end
    end
end)

hook.Add("HUDPaintBackground", "SWT_CM.DrawSWTCloakEffect",function()
    if LocalPlayer():HasWeapon("swt_cloakingmodule") and SWT_CM.Config.EnableESP then
        if LocalPlayer():HasESPEnabled() then
            draw.DrawColoredBlurRect(-1, -1, ScrW() + 2, ScrH() + 2, Color(0, 0, 0, 150), 3, 1, 0)
        end
    end
end)

util.blur = Material("pp/blurscreen")
function draw.DrawColoredBlurRect(xpos, ypos, width, height, color, layers, density, outline)
    local x, y = 0, 0

    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial(util.blur)

    for i = 1, layers do
        util.blur:SetFloat('$blur', (i / layers) * density)
        util.blur:Recompute()

        render.UpdateScreenEffectTexture()

        render.SetScissorRect(xpos + 1, ypos + 1, xpos + (width + 1), ypos + (height + 1), true)
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)
    end

    surface.SetDrawColor(color)
    surface.DrawRect(xpos, ypos, width, height)
end

hook.Add("Think", "SWT_CM.BatterySystem", function()
    if SWT_CM.Config.EnableBatterySystem and LocalPlayer():HasWeapon("swt_cloakingmodule") then
        SWT_CM:CloakThink(LocalPlayer())
    end

    if SWT_CM.Config.EnableDisguiseMode and LocalPlayer():HasWeapon("swt_cloakingmodule") then
        if input.IsMouseDown(MOUSE_MIDDLE) then
            SWT_CM:OpenJobChanger()
        end
    end
end)

--[[-------------------------------------------------------------------
    UI-Disguise Creation
    Here we gonna create the entire UserInterface for the SWT_CM.
--]]-------------------------------------------------------------------
function SWT_CM:OpenJobChanger()
    if not (SWT_CM.Config.EnableDisguiseMode or LocalPlayer():HasWeapon("swt_cloakingmodule")) then
        return
    end

    if IsValid(self.Frame) then
        self.Frame:Close()
    end

    if LocalPlayer():GetNWBool("SWT_CM.HasActiveCamo", false) then
        net.Start("SWT_CM.StopCamo")
        net.SendToServer()
        return
    end

    self.SelectedJob = nil
    self.SelectedModel = nil

    self.Frame = vgui.Create("DFrame")
    self.Frame:SetSize(ScrW() * .2, ScrH() * .45)
    self.Frame:SetTitle("[SWT] Cloaking Change")
    self.Frame:Center()
    self.Frame:MakePopup()

    self.Category = vgui.Create("DComboBox", self.Frame)
    self.Category:Dock(TOP)
    self.Category:DockMargin(ScrW() * .001, ScrH() * .01, ScrW() * .001, 0)
    self.Category:SetValue("Select Category...")
    for k, v in pairs(DarkRP.getCategories()["jobs"]) do
        if not table.HasValue(SWT_CM.Config.HiddenCategories, v.name) then
            self.Category:AddChoice(v.name, DarkRP.getCategories()["jobs"][k])
        end
    end

    self.Job = vgui.Create("DComboBox", self.Frame)
    self.Job:Dock(TOP)
    self.Job:DockMargin(ScrW() * .001, ScrH() * .01, ScrW() * .001, 0)
    self.Job:SetValue("Select Job...")
    self.Job:SetEnabled(false)
    function self.Category:OnSelect(index, value, data)
        SWT_CM.Job:Clear()
        SWT_CM.Job:SetEnabled(true)

        for k, v in pairs(RPExtraTeams) do
            if (v.category == value) then
                if not (table.HasValue(SWT_CM.Config.HiddenJobs, RPExtraTeams[k]["name"]) or table.HasValue(SWT_CM.Config.HiddenJobs, RPExtraTeams[k]["command"])) then
                    SWT_CM.Job:AddChoice(v.name, RPExtraTeams[k])
                end
            end
        end
    end
    function self.Job:OnSelect(index, value, data)
        SWT_CM.SelectedJob = data
        SWT_CM:ReloadModels(data)
    end
    
    self.ModelList = vgui.Create("DPanelList", self.Frame)
    self.ModelList:Dock(TOP)
    self.ModelList:DockMargin(ScrW() * .001, ScrH() * .01, ScrW() * .001, 0)
    self.ModelList:SetHeight(ScrH() * .3)
    self.ModelList:EnableVerticalScrollbar(true)
    self.ModelList:EnableHorizontal(true)
    self.ModelList:SetPadding(10)
    self.ModelList:SetSpacing(5)

    function self:ReloadModels(data)
        self.ModelList:Clear()
        
        local models = istable(data.model) and data.model or {data.model}

        local selected = nil
        for _, v in pairs(models) do
            local ModelIcon = vgui.Create("SpawnIcon")
            ModelIcon:SetPos(64, 64)
            ModelIcon:SetModel(v)
            self.ModelList:AddItem(ModelIcon)
            function ModelIcon:DoClick()
                selected = self
                SWT_CM.SelectedModel = v
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

    self.StartButton = vgui.Create("DButton", self.Frame)
    self.StartButton:Dock(BOTTOM)
    self.StartButton:DockMargin(ScrW() * .001, 0, ScrW() * .001, ScrH() * .001)
    self.StartButton:SetHeight(ScrH() * .04)
    self.StartButton:SetText("Start Cloaking")

    -- if selected model is not selected then disable the button.
    function self.StartButton:Think()
        if not SWT_CM.SelectedModel then
            self:SetEnabled(false)
        else
            self:SetEnabled(true)
        end
    end
    function self.StartButton:DoClick()
        if not (SWT_CM.SelectedJob.command or SWT_CM.SelectedModel or LocalPlayer():HasWeapon("swt_cloakingmodule")) then
            return
        end

        net.Start("SWT_CM.StartCamo")
            net.WriteString(SWT_CM.SelectedModel)
        net.SendToServer()

        SWT_CM.Frame:Close()
    end
end

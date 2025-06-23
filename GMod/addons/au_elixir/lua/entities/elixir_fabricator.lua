AddCSLuaFile()

ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PrintName = "Elixir Fabricator"
ENT.Category = "[AU] Elixir"
ENT.Author = "Buckell"
ENT.WorldModel = "models/props_lab/crematorcase.mdl"

--  ambient/machines/machine6.wav

function ENT:Initialize()
	self:SetModel(self.WorldModel)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 	
    if SERVER then 
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetNWString("status", "idle")
    end

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(50)
    end
end

if CLIENT then
    surface.CreateFont("elixir.fabricator", {
        font = "Roboto",
        size = 128,
        weight = 800,
        antialias = true
    })

    surface.CreateFont("elixir.fabricator.button", {
        font = "Roboto",
        size = 25,
        weight = 800,
        antialias = true
    })

    function ENT:Draw()
        self:DrawModel()
    
        local sqr_dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
        local alpha = 255
        if sqr_dist > 90000 then alpha = Lerp((sqr_dist - 90000) / 90000, 255, 0) end 
        if alpha == 0 then return end
    
        local oang = self:GetAngles()
        local opos = self:GetPos()
    
        local ang = self:GetAngles()
        local pos = self:GetPos()
    
        ang:RotateAroundAxis(oang:Up(), 90)
    
        pos = pos + oang:Forward() * 10 + oang:Up() * 2 + oang:Right() * 1

        local status = self:GetNWString("status")
    
        cam.Start3D2D(pos, ang, 0.025)
            draw.SimpleTextOutlined("Fabricator", "elixir.fabricator", 0, 0, Color(104, 26, 145, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0))
            draw.SimpleTextOutlined(string.upper(status), "elixir.fabricator", 0, 120, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0))
        cam.End3D2D()
    end

    local function OpenFabricator()
        local fabricator = net.ReadEntity()

        local window = vgui.Create("ElixirFrame")
        window:MakePopup()
        window:SetSize(500, 500)
        window:Center()

        local button = vgui.Create("DButton", window)
        button:SetSize(200, 40)
        button:SetFont("elixir.fabricator.button")
        button:SetPos(150, 430)
        button:SetColor(Color(255, 255, 255))

        local previous_status = fabricator:GetNWString("status")

        button.Paint = function (self, w, h)
            local status = fabricator:GetNWString("status")

            if status != "finished" and (status == "fabricating" or not self.fab_enabled) then
                draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70, 150))
            else
                draw.RoundedBox(0, 0, 0, w, h, self.Depressed and Color(54, 41, 69, 150) or Color(54, 41, 69))
            end

            if status != previous_status then
                if status == "idle" then
                    if self.fab_enabled then
                        self:SetText("FABRICATE")
                    else
                        self:SetText("CHOOSE PARTS")
                    end
                elseif status == "processing" then
                    self:SetText("WORKING...")
                elseif status == "finished" then
                    self:SetText("COLLECT")
                end

                previous_status = status
            end
        end

        button.FabEnable = function (self, enable)
            self.fab_enabled = enable

            local status = fabricator:GetNWString("status")

            if status == "idle" then
                if enable then
                    self:SetText("FABRICATE")
                else
                    self:SetText("CHOOSE PARTS")
                end
            elseif status == "processing" then
                self:SetText("WORKING...")
            elseif status == "finished" then
                self:SetText("COLLECT")
            end
        end

        button:FabEnable(false)

        local scroll = vgui.Create("ElixirScroll", window)
        scroll:SetSize(400, 350)
        scroll:SetPos(50, 60)

        button.DoClick = function (self)
            if fabricator:GetNWString("status") == "idle" and self.fab_enabled then
                local selected_items = {}

                for i,v in ipairs(scroll:GetCanvas():GetChildren()) do
                    if v.FabSelected then
                        table.insert(selected_items, i)
                    end
                end

                net.Start("Elixir.Fabricate")
                    net.WriteEntity(fabricator)
                    net.WriteTable(selected_items)
                net.SendToServer()

                window:Close()
            elseif fabricator:GetNWString("status") == "finished" then
                net.Start("Elixir.ResultsCollect")
                    net.WriteEntity(fabricator)
                net.SendToServer()

                window:Close()
            end
        end

        for _,item in ipairs(Elixir.Inventory) do
            local item_info = Elixir.Items[item.id]

            local panel = scroll:Add("DPanel")
            panel:SetSize(0, 50)
            panel.Paint = function (self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, self.FabSelected and Color(100, 100, 100, 200) or Color(11, 11, 11, 100))

                draw.SimpleText(item_info.name, "elixir.window.item", 10, 25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                
                if item_info.expiration_time and item_info.expiration_time != 0 then
                    local duration = item_info.expiration_time - (os.time() - item.creation_time)
                    draw.SimpleText(math.max(duration, 0), "elixir.window.item", w - 15, 25, duration > 0 and Color(255, 255, 255) or Color(255, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                end
            end
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 10, 5)
            panel:SetCursor("hand")
            panel.OnMousePressed = function (self, code)
                if code != MOUSE_LEFT then return end
                self.FabSelected = not self.FabSelected

                local total = 0
                for _,v in ipairs(scroll:GetCanvas():GetChildren()) do
                    total = total + (v.FabSelected and 1 or 0)
                end

                if total > 1 then
                    button:FabEnable(true)
                else
                    button:FabEnable(false)
                end
            end
        end
    end

    net.Receive("Elixir.OpenFabricator", OpenFabricator)
else
    util.AddNetworkString("Elixir.OpenFabricator")
    util.AddNetworkString("Elixir.Fabricate")
    util.AddNetworkString("Elixir.ResultsCollect")

    function ENT:Use(activator)
        if not activator:IsPlayer() then return end

        net.Start("Elixir.OpenFabricator")
            net.WriteEntity(self)
        net.Send(activator)
    end

    net.Receive("Elixir.Fabricate", function (len, ply)
        local fabricator = net.ReadEntity()

        if fabricator:GetNWString("status") != "idle" then return end

        local selected_items = net.ReadTable()

        local inventory = Elixir.GetInventory(ply)

        local items = {}

        for _,v in ipairs(selected_items) do
            local slot = inventory[v]

            if not slot then 
                Elixir.UpdateInventory(ply)
                return
            end
    
            inventory[v] = nil

            local count = items[slot.id]
            items[slot.id] = count and count + 1 or 1
        end

        inventory = table.ClearKeys(inventory)

        Elixir.SetInventory(ply, inventory)

        local selected_recipe = nil

        for _,recipe in ipairs(Elixir.Recipes) do
            local parts = recipe.parts

            if table.Count(items) == table.Count(parts) then
                local matches = true

                for k,v in pairs(items) do
                    if parts[k] != v then
                        matches = false
                        break
                    end
                end

                if matches then
                    selected_recipe = recipe
                    break
                end
            end
        end

        fabricator:SetNWString("status", "processing")

        local sound = fabricator:StartLoopingSound("ambient/machines/machine6.wav")

        if selected_recipe then
            timer.Simple(selected_recipe.fabrication_time or 10, function ()
                fabricator:StopLoopingSound(sound)
                fabricator:SetNWString("status", "finished")
                fabricator.results = selected_recipe.results
            end)
        else
            timer.Simple(math.random(Elixir.DefaultProcessingTimeMin, Elixir.DefaultProcessingTimeMax), function ()
                fabricator:StopLoopingSound(sound)
                fabricator:SetNWString("status", "idle")
            end)
        end
    end)

    net.Receive("Elixir.ResultsCollect", function (len, ply)
        local fabricator = net.ReadEntity()
        
        if fabricator:GetNWString("status") != "finished" then return end
    
        local inventory = Elixir.GetInventory(ply)

        if #inventory + #fabricator.results > Elixir.InventoryCapacity then
            Elixir.Message(ply, "You do not have enough room in your inventory!")
            return
        end

        for _,v in ipairs(fabricator.results) do
            table.insert(inventory, Elixir.Item(v))
        end

        Elixir.SetInventory(ply, inventory)

        fabricator:SetNWString("status", "idle")
    end)
end
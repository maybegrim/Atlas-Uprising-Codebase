AddCSLuaFile()

ENT.Type = "anim"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PrintName = "Elixir Storage"
ENT.Category = "[AU] Elixir"
ENT.Author = "Buckell"
ENT.WorldModel = "models/props_wasteland/kitchen_fridge001a.mdl"

function ENT:Initialize()
	self:SetModel(self.WorldModel)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 	
    if SERVER then 
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(50)
    end

    self.Inventory = self.Inventory or {}
end

if CLIENT then
    surface.CreateFont("elixir.storage", {
        font = "Roboto",
        size = 256,
        weight = 800,
        antialias = true
    })

    function ENT:Draw()
        self:DrawModel()
    end

    local function OpenStorage()
        local storage = net.ReadEntity()
        storage.Inventory = net.ReadTable()

        if storage:GetNWString("id") == "" then
            Derma_StringRequest("Set Identifier", "This storage has not been issued an ID. Set one now:", nil, function (text)
                net.Start("Elixir.SetIdentifier")
                    net.WriteEntity(storage)
                    net.WriteString(text)
                net.SendToServer()
            end)

            return
        end

        local window = vgui.Create("ElixirFrame")
        window:MakePopup()
        window:SetSize(1000, 500)
        window:Center()

        local scroll = vgui.Create("ElixirScroll", window)
        scroll:SetSize(400, 350)
        scroll:SetPos(50, 60)

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
                self.FabSelected = not self.FabSelected
            end
        end

        local button = vgui.Create("DButton", window)
        button:SetSize(200, 40)
        button:SetFont("elixir.fabricator.button")
        button:SetPos(150, 430)
        button:SetColor(Color(255, 255, 255))
        button:SetText("STORE")

        button.Paint = function (self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, self.Depressed and Color(54, 41, 69, 150) or Color(54, 41, 69))
        end

        button.DoClick = function (self)
            local selected_items = {}

            for i,v in ipairs(scroll:GetCanvas():GetChildren()) do
                if v.FabSelected then
                    table.insert(selected_items, i)
                end
            end

            if #selected_items == 0 then return end

            net.Start("Elixir.Store")
                net.WriteEntity(storage)
                net.WriteTable(selected_items)
            net.SendToServer()

            window:Close()
        end

        local scroll2 = vgui.Create("ElixirScroll", window)
        scroll2:SetSize(400, 350)
        scroll2:SetPos(550, 60)

        for _,item in ipairs(storage.Inventory) do
            local item_info = Elixir.Items[item]

            local panel = scroll2:Add("DPanel")
            panel:SetSize(0, 50)
            panel.Paint = function (self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, self.FabSelected and Color(100, 100, 100, 200) or Color(11, 11, 11, 100))

                draw.SimpleText(item_info.name, "elixir.window.item", 10, 25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 10, 5)
            panel:SetCursor("hand")
            panel.OnMousePressed = function (self, code)
                self.FabSelected = not self.FabSelected
            end
        end

        local button2 = vgui.Create("DButton", window)
        button2:SetSize(200, 40)
        button2:SetFont("elixir.fabricator.button")
        button2:SetPos(650, 430)
        button2:SetColor(Color(255, 255, 255))
        button2:SetText("RETRIEVE")
        button2.Paint = function (self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, self.Depressed and Color(54, 41, 69, 150) or Color(54, 41, 69))
        end

        button2.DoClick = function (self)
            local selected_items = {}

            for i,v in ipairs(scroll2:GetCanvas():GetChildren()) do
                if v.FabSelected then
                    table.insert(selected_items, i)
                end
            end

            if #selected_items == 0 then return end

            net.Start("Elixir.Retrieve")
                net.WriteEntity(storage)
                net.WriteTable(selected_items)
            net.SendToServer()

            window:Close()
        end

        window.OnClose = function (self)
            net.Start("Elixir.CloseStorage")
                net.WriteEntity(storage)
            net.SendToServer()
        end
    end

    net.Receive("Elixir.OpenStorage", OpenStorage)

    net.Receive("Elixir.UpdateStorage", function ()
        local storage = net.ReadEntity()
        storage.Inventory = net.ReadTable()
    end)
else
    util.AddNetworkString("Elixir.OpenStorage")
    util.AddNetworkString("Elixir.Store")
    util.AddNetworkString("Elixir.Retrieve")
    util.AddNetworkString("Elixir.UpdateStorage")
    util.AddNetworkString("Elixir.CloseStorage")
    util.AddNetworkString("Elixir.SetIdentifier")
    function ENT:Use(activator)
        if not activator:IsPlayer() then return end

        if self.Occupied and self.Occupied != activator then 
            Elixir.Message(activator, "This storage is currently occupied!")
            return
        end

        self.Occupied = activator
        
        net.Start("Elixir.OpenStorage")
            net.WriteEntity(self)
            net.WriteTable(self:GetInventory())
        net.Send(activator)
    end

    function ENT:GetInventory()
        return self.Inventory or {}
    end

    function ENT:SetInventory(inventory)
        self.Inventory = inventory

        net.Start("Elixir.UpdateStorage")
            net.WriteEntity(self)
            net.WriteTable(inventory)
        net.Broadcast()

        local identifier = self:GetNWString("id")

        if identifier != "" then
            file.Write("elixir/" .. identifier .. ".json", util.TableToJSON(inventory))
        end
    end

    function ENT:SetID(id)
        local identifier = string.lower(id)

        self:SetNWString("id", identifier)

        file.CreateDir("elixir")
        self:SetInventory(util.JSONToTable(file.Read("elixir/" .. identifier .. ".json", "DATA") or "[]"))
    end

    net.Receive("Elixir.CloseStorage", function (len, ply)
        local storage = net.ReadEntity()

        if not storage or not storage:IsValid() then return end

        if storage.Occupied != ply then return end

        storage.Occupied = nil
    end)

    net.Receive("Elixir.Store", function (len, ply)
        local storage = net.ReadEntity()

        if not storage or not storage:IsValid() then return end

        local selected_items = net.ReadTable()

        local inventory = Elixir.GetInventory(ply)

        local storage_inventory = storage:GetInventory()

        for _,v in ipairs(selected_items) do
            local slot = inventory[v]

            if not slot then 
                Elixir.UpdateInventory(ply)
                return
            end

            local occurrences = 0

            for _,item in ipairs(storage_inventory) do
                if item == slot.id then
                    occurrences = occurrences + 1
                end
            end

            if occurrences < Elixir.MaxStorageTypeAmount then
                table.insert(storage_inventory, slot.id)

                inventory[v] = nil
            end
        end

        inventory = table.ClearKeys(inventory)

        Elixir.SetInventory(ply, inventory)

        storage:SetInventory(storage_inventory)
    end)

    net.Receive("Elixir.Retrieve", function (len, ply)
        local storage = net.ReadEntity()

        if not storage or not storage:IsValid() then return end

        local selected_items = net.ReadTable()

        local inventory = Elixir.GetInventory(ply)

        if #inventory + #selected_items > Elixir.InventoryCapacity then
            Elixir.Message(ply, "You do not have enough room in your inventory!")
            return
        end

        local storage_inventory = storage:GetInventory()

        for _,v in ipairs(selected_items) do
            local slot = storage_inventory[v]

            if not slot then 
                return
            end

            table.insert(inventory, Elixir.Item(slot))
    
            storage_inventory[v] = nil
        end

        storage_inventory = table.ClearKeys(storage_inventory)

        Elixir.SetInventory(ply, inventory)
        storage:SetInventory(storage_inventory)
    end)

    net.Receive("Elixir.SetIdentifier", function (len, ply)
        local storage = net.ReadEntity()

        if not storage or not storage:IsValid() then return end

        local identifier = net.ReadString()

        if not identifier or #identifier < 1 then return end

        if storage:GetNWString("id") == "" then
            storage:SetID(identifier)
            Elixir.Message(ply, "You have set the ID of this storage device to: '" .. identifier .. "'.")
        end
    end)

    hook.Add("InitPostEntity", "Elixir.PermaPropsIntegration", function ()
        if PermaProps then
            PermaProps.SpecialENTSSpawn["elixir_storage"] = function (ent, data)
                if not data or not istable(data) then return end

                ent:Spawn()
                ent:Activate()

                if data.Identifier then
                    ent:SetID(data.Identifier)
                end

                return true
            end

            PermaProps.SpecialENTSSave["elixir_storage"] = function (ent)
                local identifier = ent:GetNWString("id")
                
                if identifier == "" then return {} end

                return {
                    Other = {
                        Identifier = identifier
                    }
                }
            end
        end
    end)

    hook.Add("PermaProps.OnAdd", "PermaProps.Elixir", function(ent, data, ply)
        if ent:GetClass() == "elixir_storage" then
            data.Identifier = ent:GetNWString("id")
        end
    end)
    
    hook.Add("PermaProps.PostSpawn", "PermaProps.Elixir", function(ent, data, ply)
        if ent:GetClass() == "elixir_storage" then
            if data.Identifier then
                ent:SetID(data.Identifier)
            end
        end
    end)
end
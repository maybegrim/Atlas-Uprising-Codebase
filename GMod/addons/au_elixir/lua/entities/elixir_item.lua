AddCSLuaFile()

ENT.Type = "anim"
ENT.Spawnable = false
ENT.PrintName = "Elixir Item"
ENT.Category = "[AU] Elixir"
ENT.Author = "Buckell"
ENT.WorldModel = "models/props_junk/cardboard_box004a.mdl"

--  ambient/machines/machine6.wav

function ENT:Initialize()
	self:SetModel(self.WorldModel)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
 	
    if SERVER then 
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        self:SetNWString("item_name", "Item")
        print("item")
    end

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(50)
    end
end

if CLIENT then
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
    
        pos = pos + oang:Up() * 5

        cam.Start3D2D(pos, ang, 0.025)
            draw.SimpleTextOutlined(self:GetNWString("item_name"), "elixir.fabricator", 0, 0, Color(104, 26, 145, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color(0, 0, 0))
        cam.End3D2D()
    end
else
    function ENT:Use(activator)
        if not activator:IsPlayer() then return end

        local inventory = Elixir.GetInventory(activator)

        if #inventory + 1 > Elixir.InventoryCapacity then
            Elixir.Message(activator, "You cannot carry any more items.")
            return
        end

        Elixir.AddInventoryItem(activator, self.elixir_item)

        self:Remove()
    end

    function ENT:SetItem(item)
        self.elixir_item = item
        self:SetNWString("item_name", Elixir.Items[item.id].name)
    end
end
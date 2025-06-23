AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Supply Depot"
ENT.Spawnable = true
 
ENT.PrintName		= "Ammo Crate"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/items/ammocrate_smg1.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(CONTINUOUS_USE)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        if Cooldown("USE AmmoCrate", 0.2) then return end
    
        local active_weapon = caller:GetActiveWeapon()
        if not IsValid(active_weapon) then return end

        local weapon_class = active_weapon:GetClass()
        
        if weapon_class == "fas2_ifak" then
            local hemostat_count = caller:GetAmmoCount("Hemostats")
            local bandage_count = caller:GetAmmoCount("Bandages")
            local quikclot_count = caller:GetAmmoCount("Quikclots")
            local hemostat_req = math.max(0, AU.SupplyDepot.AmmoCrate.MaxHemostates - hemostat_count)
            local bandage_req = math.max(0, AU.SupplyDepot.AmmoCrate.MaxBandages - bandage_count)
            local quikclot_req = math.max(0, AU.SupplyDepot.AmmoCrate.MaxQuikclots - quikclot_count)

            local total = hemostat_req + bandage_req + quikclot_req
            local reserve = self:GetMeds()

            if total > reserve then
                local imbalance = total - reserve

                if imbalance > bandage_req then
                    imbalance = imbalance - bandage_req
                    bandage_req = 0

                    if imbalance > quikclot_req then
                        imbalance = imbalance - quikclot_req
                        quikclot_req = 0
                        
                        if imbalance > hemostat_req then
                            return
                        else
                            quikclot_req = quikclot_req - imbalance
                        end
                    else
                        quikclot_req = quikclot_req - imbalance
                    end
                else
                    bandage_req = bandage_req - imbalance
                end
            end

            total = hemostat_req + bandage_req + quikclot_req

            self:SubtractMeds(total)

            caller:GiveAmmo(hemostat_req, "Hemostats")
            caller:GiveAmmo(bandage_req, "Bandages")
            caller:GiveAmmo(quikclot_req, "Quikclots")
        else
            local ammo_type = active_weapon:GetPrimaryAmmoType()
            local ammo_name = game.GetAmmoName(ammo_type)

            if not AU.SupplyDepot.AmmoCrate.WhitelistedAmmoTypes[ammo_name] then return end

            if self:GetAmmo() > 0 and active_weapon.GetMaxClip1 then
                local magazine_size = active_weapon:GetMaxClip1()
                local ammo_count = caller:GetAmmoCount(ammo_type)

                if ammo_count + magazine_size > magazine_size * 10 then
                    if magazine_size * 10 - ammo_count > 0 then
                        caller:GiveAmmo(magazine_size * 10 - ammo_count, ammo_type)
                        self:SubtractAmmo(1)
                    end
                else
                    caller:GiveAmmo(magazine_size, ammo_type)                
                    self:SubtractAmmo(1)
                end
            end
        end
    end

    function ENT:AddAmmo(count)
        self:SetAmmo(self:GetAmmo() + count)
    end

    function ENT:SubtractAmmo(count)
        self:SetAmmo(self:GetAmmo() - count)
    end

    function ENT:AddMeds(count)
        self:SetMeds(self:GetMeds() + count)
    end

    function ENT:SubtractMeds(count)
        self:SetMeds(self:GetMeds() - count)
    end

    function ENT:Resupply()
        self:SetAmmo(self:GetAmmo() + AU.SupplyDepot.AmmoCrate.AmmoPerSupply)
        self:SetMeds(self:GetMeds() + AU.SupplyDepot.AmmoCrate.MedsPerSupply)
    end
elseif CLIENT then
    surface.CreateFont("AU.SupplyDepot.AmmoCrate.Title", {
        font = "Roboto",
        size = 100,
        antialias = true,
        weight = 900
    })

    surface.CreateFont("AU.SupplyDepot.AmmoCrate.Count", {
        font = "Roboto",
        size = 255,
        antialias = true,
        weight = 900
    })

    local textRenderDistance = 1000 -- Distance threshold for rendering text
    local modelRenderDistance = 1500 -- Distance threshold for rendering model
    function ENT:Draw()
        local player = LocalPlayer()
        local distance = self:GetPos():Distance(player:GetPos())

    
        if distance > modelRenderDistance then
            return -- Stop drawing the model if the distance is too high
        end
    
        self:DrawModel()
    
        if distance > textRenderDistance then
            return -- Stop rendering text if the distance is too high
        end
    
        local pos = self:LocalToWorld(Vector(0, 0, 35))
        local ang = self:LocalToWorldAngles(Angle(0, 90, 90))
    
        cam.Start3D2D(pos, ang, 0.02)
            draw.RoundedBox(0, -1000, 0, 2000, 700, Color(30, 30, 30, 240))
            draw.RoundedBox(0, -1000, 0, 2000, 150, Color(180, 30, 30, 200))            
    
            draw.SimpleTextOutlined("Ammunition", "AU.SupplyDepot.AmmoCrate.Title", 0, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1)
        
            draw.SimpleTextOutlined("MEDS", "AU.SupplyDepot.AmmoCrate.Title", -500, 200, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1)
            draw.SimpleTextOutlined("AMMO", "AU.SupplyDepot.AmmoCrate.Title", 500, 200, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1)
            
            draw.SimpleTextOutlined(tostring(self:GetMeds()) .. "x", "AU.SupplyDepot.AmmoCrate.Count", -500, 300, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1)
            draw.SimpleTextOutlined(tostring(self:GetAmmo()) .. "x", "AU.SupplyDepot.AmmoCrate.Count", 500, 300, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1)
        cam.End3D2D()
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Ammo")
    self:NetworkVar("Int", 1, "Meds")

    self:SetAmmo(AU.SupplyDepot.AmmoCrate.AmmoPerSupply)
    self:SetMeds(AU.SupplyDepot.AmmoCrate.MedsPerSupply)
end

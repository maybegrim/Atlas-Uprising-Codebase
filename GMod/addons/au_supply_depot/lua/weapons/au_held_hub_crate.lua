AddCSLuaFile()

local IconUse = Material("icons/use.png", "smooth")

SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.PrintName = "Hub Crate"
SWEP.Slot = 5
SWEP.SlotPos = 2

SWEP.Spawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "slam"

SWEP.WorldModel = "models/items/ammocrate_smg1.mdl" -- models/props_marines/ammocrate01_static.mdl

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

if SERVER then
    function SWEP:Deploy()
        local ply = self:GetOwner()
        if ply.DeployedSwep then return end
        ply.DeployedSwep = true
        ply.PreWalkSpeed = ply:GetWalkSpeed()
        ply.PreRunSpeed = ply:GetRunSpeed()

        ply:SetWalkSpeed(150)
        ply:SetRunSpeed(150)
        timer.Simple(1, function() ply.DeployedSwep = false end)
        return true
    end

    function SWEP:OnRemove()
        local ply = self:GetOwner()
        self:Drop()
        ply:SetWalkSpeed(ply.PreWalkSpeed or 200)
        ply:SetRunSpeed(ply.PreRunSpeed or 300)
    end
end

function SWEP:Holster()
    return false
end

function SWEP:DrawWorldModel()
    local pos = self:GetOwner():GetPos()
    local ang = self:GetOwner():EyeAngles()

    ang.x = 0
    ang.z = 0

    pos = pos + ang:Forward() * 25 + ang:Up() * 35
    
    ang.y = ang.y + 90

    render.Model({
        model = self.WorldModel,
        pos = pos,
        angle = ang
    })
end

if SERVER then
    util.AddNetworkString("AU.AmmoDepot.DropHubCrate")

    net.Receive("AU.AmmoDepot.DropHubCrate", function (len, ply)
        if Cooldown("AU.AmmoDepot.DropDepotCrate", 1) then return end

        --ply:GetActiveWeapon():Drop()
        ply:GetActiveWeapon():Remove()
    end)

    function SWEP:Drop()
        local ply = self:GetOwner()

        local trace = ply:GetEyeTrace()

        if IsValid(trace.Entity) and trace.HitPos:DistToSqr(ply:EyePos()) < 10000 then
            if trace.Entity:GetClass() == "au_dep_hub" then
                self:Remove()
                trace.Entity:SetSupplyCount(trace.Entity:GetSupplyCount() + 1)
                trace.Entity:EmitSound("physics/metal/metal_barrel_impact_hard5.wav")
                
                ply:SetWalkSpeed(ply.PreWalkSpeed or 200)
                ply:SetRunSpeed(ply.PreRunSpeed or 240)
                return
            elseif trace.Entity:GetClass() == "au_ammo_crate" then
                if ply:getJobTable().faction == "D-CLASS" then
                    --DJOB.Reward(ply, 100, 1)
                end

                self:Remove()
                trace.Entity:Resupply()
                trace.Entity:EmitSound("physics/metal/metal_barrel_impact_hard5.wav")
                ply:SetWalkSpeed(ply.PreWalkSpeed or 200)
                ply:SetRunSpeed(ply.PreRunSpeed or 240)
                return
            end
        end

        if not trace.HitPos or trace.HitPos:DistToSqr(ply:EyePos()) > 5000 then
            local entity = ents.Create("au_hub_crate")
            
            local pos = self:GetOwner():GetPos()
            local ang = self:GetOwner():EyeAngles()
            ang.x = 0
            ang.z = 0

            pos = pos + ang:Forward() * 50 + ang:Up() * 14

            ang.y = ang.y + 90
        
            entity:SetAngles(ang)
            entity:SetPos(pos)
            entity:Spawn()
            entity:Activate()
            entity:GetPhysicsObject():EnableMotion(false)
            ply:SetWalkSpeed(ply.PreWalkSpeed or 200)
            ply:SetRunSpeed(ply.PreRunSpeed or 240)

            self:Remove()
            entity:EmitSound("physics/metal/metal_barrel_impact_hard6.wav")
        end
    end
end

if CLIENT then
    hook.Add("KeyPress", "AU.AmmoDepot.DropHubCrate", function (ply, key)
        if Cooldown("DropHubCrate", 0.5) then return end

        local active_weapon = ply:GetActiveWeapon()
        
        if key ~= IN_USE or not IsValid(active_weapon) or active_weapon:GetClass() ~= "au_held_hub_crate" then return end
        
        if Cooldown("AU.AmmoDepot.DropDepotCrate", 1) then return end

        net.Start("AU.AmmoDepot.DropHubCrate")
        net.SendToServer()
    end)

    function SWEP:DrawHUD()
        local ply = self:GetOwner()
    
        local trace = ply:GetEyeTrace()
    
        surface.SetFont("AU.BombCollar.Display.TamperText")
        local width, height = surface.GetTextSize("Drop crate.")
    
        local total_width = width + 32
    
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(IconUse)
        surface.DrawTexturedRect(ScrW() / 2 - total_width / 2 - 16, ScrH() - 300 - 16, 32, 32)
    
        draw.SimpleTextOutlined("Drop crate.", "AU.BombCollar.Display.TamperText", ScrW() / 2 - (total_width / 2) + 32, ScrH() - 300, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
    end
end
AddCSLuaFile()

local IconUse = Material("icons/use.png", "smooth")

SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.PrintName = "Depot Crate"
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

SWEP.WorldModel = "models/props_junk/pushcart01a.mdl"

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

        ply:SetWalkSpeed(50)
        ply:SetRunSpeed(50)
        timer.Simple(1, function() ply.DeployedSwep = false end)

        return true
    end

    function SWEP:OnRemove()
        local ply = self:GetOwner()
        if not self.Dropping then
            self:Drop()
        end

        ply:SetWalkSpeed(ply.PreWalkSpeed)
        ply:SetRunSpeed(ply.PreRunSpeed)
    end
end

function SWEP:Holster()
    return false
end

function SWEP:DrawWorldModel()
    local pos = self:GetOwner():GetPos()
    local ang = self:GetOwner():EyeAngles()
    ang.z = 0
    ang.x = 0

    pos = pos + ang:Forward() * 50 + ang:Up() * 16
    
    render.Model({
        model = "models/props_blackmesa/bms_metalcrate_64x96.mdl",
        pos = pos,
        angle = ang
    })

    pos = pos + ang:Up() * 17

    render.Model({
        model = "models/props_junk/pushcart01a.mdl",
        pos = pos,
        angle = ang
    })
end

if SERVER then
    util.AddNetworkString("AU.AmmoDepot.DropDepotCrate")

    net.Receive("AU.AmmoDepot.DropDepotCrate", function (len, ply)
        if Cooldown("AU.AmmoDepot.DropDepotCrate", 1) then return end

        ply:GetActiveWeapon():Drop()
    end)

    function SWEP:Drop()
        local ply = self:GetOwner()

        if ply.DeployedSwep then return end
        local trace = ply:GetEyeTrace()

        self.Dropping = true

        
        
        -- Check if the crate is being dropped on a valid entity
        if IsValid(trace.Entity) and trace.Entity:GetClass() == "au_dep_hub" and trace.HitPos:DistToSqr(ply:EyePos()) < 10000 then
            self:Remove()
            trace.Entity:SetSupplyCount(trace.Entity:GetSupplyCount() + AU.SupplyDepot.HubCratesPerDepotCrate)
            trace.Entity:EmitSound("physics/metal/metal_barrel_impact_hard1.wav")
            ply:SetWalkSpeed(ply.PreWalkSpeed)
            ply:SetRunSpeed(ply.PreRunSpeed)
            return
        end

        if ply:InVehicle() then
            ply:ChatPrint("Cannot drop crate while in vehicle.")
            self.Dropping = false
            return
        end

        if not trace.HitPos or trace.HitPos:DistToSqr(ply:EyePos()) < 12000 then
            ply:ChatPrint("Cannot drop crate here.")
            self.Dropping = false
            return
        end

        if trace.Entity:GetClass() ~= "worldspawn" then
            ply:ChatPrint("Cannot drop crate here.")
            self.Dropping = false
            return
        end

        local entity = ents.Create("au_depot_crate")

        local pos = self:GetOwner():GetPos()
        local ang = self:GetOwner():EyeAngles()
        ang.z = 0
        ang.x = 0

        pos = pos + ang:Forward() * 60

        entity:SetAngles(ang)
        entity:SetPos(pos)
        entity:Spawn()
        entity:GetPhysicsObject():EnableMotion(false)
        ply:SetWalkSpeed(ply.PreWalkSpeed)
        ply:SetRunSpeed(ply.PreRunSpeed)

        self:Remove()

        entity:EmitSound("physics/metal/metal_barrel_impact_hard6.wav")
    end
end

if CLIENT then
    hook.Add("KeyPress", "AU.AmmoDepot.DropDepotCrate", function (ply, key)
        if Cooldown("DropDepotCrate", 0.5) then return end

        local active_weapon = ply:GetActiveWeapon()
        
        if key ~= IN_USE or not IsValid(active_weapon) or active_weapon:GetClass() ~= "au_held_depot_crate" then return end
        
        net.Start("AU.AmmoDepot.DropDepotCrate")
        net.SendToServer()
        print("SENDING NET")
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
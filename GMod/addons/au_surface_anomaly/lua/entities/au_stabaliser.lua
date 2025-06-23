AddCSLuaFile()

AU_Distortion = AU_Distortion or {}
AU_Distortion.Controllers = AU_Distortion.Controllers or {}
AU_Distortion.Config = AU_Distortion.Config or {}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "AU Distortion"
ENT.Spawnable = true

ENT.PrintName = "Stabaliser MK-1"
ENT.Author = "Astral"
ENT.Contact = "astral0773"
ENT.NumberOfConnections = 0
ENT.DetectionRadius = 10000
ENT.BeamColor = Color(255, 255, 0, 150)
local stableList = {} -- List full of the stabalisers. We just loop this instead of checking ents.AllAround, Makes things easier.

/*
 TODO: Sounds & Connected to controller base. (Not sure how to do this as of right now.)
*/

if SERVER then
    function ENT:Initialize()
        self:SetUseType(SIMPLE_USE)
        self:SetModel( "models/xqm/button3.mdl" )
        self:SetColor( Color( 255, 255, 200 ) )
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
        stableList[self] = true
    end

    function ENT:Use(ply)
        if not IsFirstTimePredicted() then return end
        if self.useCooldown and self.useCooldown > CurTime() then return end
        self.useCooldown = CurTime() + 1
        local connectedEntity = self:GetConnectedStable()
        if connectedEntity and connectedEntity:IsValid() then
            ply:ChatPrint( "Stabalizer has been de-activated." )
            self:SetConnectedStable(nil)

            local target = self:GetTarget()
            if not target or not target:IsValid() then return end
            table.RemoveByValue(target.TargetList, self)
            local amm = target:GetTargetAmmount()
            target:SetTargetAmmount(amm - 1)
            self:SetTarget(nil)
            return
        end

        local target = nil
        local PlacesLeft = 0

        for _, ent in ipairs(AU_Distortion.Controllers) do -- At some point change this to variable holding all the anomaly thingies.
            if not ent:IsValid() then continue end
            if not string.find(ent:GetClass(), "au_anom_") then continue end
            if self:GetTarget() and self:GetTarget():IsValid() then continue end
            if ent:GetTargetAmmount() >= math.max(ent:GetCategory() * ent.AmmStablePerCategory, ent.MinAmmStable) then continue end -- Make sure not more can be connected.
            target = ent
            PlacesLeft = math.max(ent:GetCategory() * ent.AmmStablePerCategory, ent.MinAmmStable) - target:GetTargetAmmount()
            break
        end
        if not target or not target:IsValid() then -- Stabalisers must have a target to work!
            ply:ChatPrint( "Stabalizer was unable to find a target." )
            return
        end
        local closestStable = nil
        local distanceClosestStable = nil

        for stable, _ in pairs( stableList ) do -- Lock onto the nearest stabaliser.
            if not stable or not stable:IsValid() then continue end
            if stable:GetConnectedStable() == self then continue end -- Don't allow connecting to the one connecting to you.
            if stable == self then continue end
            if (PlacesLeft == 1) and not (target.TargetList[1] == stable) then continue end
            local distance = stable:GetPos():Distance( self:GetPos() )
            if not (distance <= self.DetectionRadius) then continue end

            local trace = util.TraceLine({
                start = self:GetPos(),
                endpos = stable:GetPos(),
                filter = {stable, self}
            })

            if trace.Hit then continue end
            if not closestStable then closestStable = stable distanceClosestStable = distance continue end
            if distanceClosestStable > distance then closestStable = stable distanceClosestStable = distance continue end
        end
        if not closestStable then return end
        self:SetTarget(target)
        table.insert(target.TargetList, self)
        target:SetTargetAmmount(target:GetTargetAmmount() + 1) -- Target Counter. We network this to make it easier for the clientside visual effects to work.
        self:SetConnectedStable(closestStable)

        ply:ChatPrint( "Stabalizer Activated." )
    end

    function ENT:OnRemove()
        stableList[self] = nil
        local target = self:GetTarget()
        if not target or not target:IsValid() then return end
        table.RemoveByValue(target.TargetList, self)
        local amm = target:GetTargetAmmount()
        target:SetTargetAmmount(amm - 1)
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Target")
    self:NetworkVar("Entity", 1, "ConnectedStable")
end

if SERVER then return end

-- Clientside code

hook.Add("PostDrawOpaqueRenderables", "DrawLineBetweenEntities", function()
    for stable, _ in pairs(stableList) do
        if not IsValid(stable) then continue end
        local stablePos = stable:GetPos()
        
        local connectedStable = stable:GetConnectedStable()
        if not connectedStable or not connectedStable:IsValid() then continue end
        local connectedStablePosition = connectedStable:GetPos()

        local trace = util.TraceLine({
            start = LocalPlayer():EyePos(),
            endpos = connectedStablePosition,
            filter = {LocalPlayer(), connectedStable}
        })
        if trace.Hit and trace.Entity:IsWorld() then continue end

        local trace = util.TraceLine({
            start = LocalPlayer():EyePos(),
            endpos = stablePos,
            filter = {stable, LocalPlayer()}
        })
        if trace.Hit and trace.Entity:IsWorld() then continue end

        local target = stable:GetTarget()
        if not target or not target:IsValid() then continue end
        if target:GetPos():Distance(stablePos) > (target:GetCategory() * 200) then continue end

        local amm = target:GetTargetAmmount()
        local category = target:GetCategory()

        local isFull = (amm == math.max(category * target.AmmStablePerCategory, target.MinAmmStable))

        if not isFull then -- Draw connection lines between stabalisers only if the full infrastructure is not set up.
            render.SetColorMaterial()
            render.DrawLine(stable:GetPos(), connectedStablePosition, Color(255,255,255), true)
            continue -- Only draw the other lines if the infrastructure is complete.
        end

        local targetcat = target:GetCategory()
        local targetpos = target:GetPos()
        local direction = (stablePos - targetpos):GetNormalized()
        local catratio = (target.RangePerCat / 100) * 98.95
        targetpos = targetpos + direction * (category * catratio) -- Some work to make the beam stop when hitting the outer layer of the orb.

        render.SetColorMaterial()
        render.StartBeam(2)

        render.AddBeam(stablePos, 1, 0, stable.BeamColor)
        render.AddBeam(targetpos, 1, 1, stable.BeamColor)

        render.EndBeam()
    end
end)


function ENT:Initialize()
    stableList[self] = true
end

function ENT:Remove()
    stableList[self] = nil
end
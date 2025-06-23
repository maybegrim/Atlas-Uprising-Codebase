AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/frame002a.mdl") -- Placeholder model, replace with actual face model
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self.faceEntity = ents.Create("scp096_face_tracker")
    if not self.faceEntity or not self.faceEntity:IsValid() then print("096 face entity not able to spawn.") return end
    self.faceEntity:SetParent(self)
    self:DeleteOnRemove(self.faceEntity)
    self.faceEntity:SetLocalPos(Vector(-0.2, 0, 10))
    self.faceEntity:SetLocalAngles(Angle(45, 0, 0))
    self.faceEntity:Spawn()
    self.faceEntity:Activate()
end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

/*local boneCheckAlignmentList = {
    {"ValveBiped.Bip01_Head1", Vector(-5.6, -7.2, -3.0), Angle(0, 180, -30), 1}, -- Vector(1.2, 0.0, 0.0) Angle(0, 90, 0)
    {"ValveBiped.Bip01_Neck1", Vector(6.2, 0.0, 0.0), Angle(0, 120, 0), 1.2}
}*/

local scpOverride = false

--local scpAlignment = {"ValveBiped.Bip01_Head1", Vector(0, 0, 5), Angle(0, 180, -30), 1.6}\
local scpAlignment = {"ValveBiped.Bip01_Head1", Vector(0, 0, 10), Angle(90, 0, 0), 1.6}


function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box001b.mdl") -- Placeholder model, replace with actual face model
    self:SetModelScale( self:GetModelScale() * 0.35, 0 )
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self.attached = false
    self.canUse = true

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Attach( self, ply )
    local foundBone = false
    if not IsValid(ply) then print("(scp_096 bag) Player is not valid, aborting...") return false end

    if scpOverride or (IsValid(scp096currentplayer) and ply:EntIndex() == scp096currentplayer:EntIndex()) then
        local boneID = ply:LookupBone(scpAlignment[1])
        self:SetModelScale( self:GetModelScale() * scpAlignment[4], 0 )
        self:FollowBone(ply, boneID)
        self:SetLocalPos(scpAlignment[2])
        print(scpAlignment[2])
        print(self:GetLocalPos())
        self:SetLocalAngles(scpAlignment[3])
        foundBone = true
    else print("(scp_096 bag) Not bagging, target entity is not 096") return false end

    if not foundBone then return false end

    ply:SetNWBool("096_BAG:BAGGED", true)
    --self:SetParent(ply) -- Set the entity's parent to the player
    self:DeleteOnRemove(ply)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) -- Set collision group

    self.attached_to = ply
    self.attached = true
    ply.bagged = true
    ply.bagged_by = self
    return true
end

function ENT:Detatch( self )
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- Set collision group
    self:SetParent(nil)
    self.attached_to:SetNWBool("096_BAG:BAGGED", false )
    local attached = self.attached_to
    self.attached_to = nil
    self.attached = false 
    attached.bagged = false 
    attached.bagged_by = nil
end

function ENT:Use(activator)
    if not self.canUse then return end
    if self.attached then
        self:Detatch(self)
    else
        activator:Give( "au_scp096_bag", true )
        self:Remove()
    end
    self.canUse = false
    timer.Create("BagCooldown".. self:EntIndex(), 1, 1, function() self.canUse = true end)
end
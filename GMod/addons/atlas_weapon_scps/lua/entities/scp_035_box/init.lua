
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()

    self.HasMask = false

    self:SetCustomCollisionCheck(true)
end

function ENT:Use(ply)
    if not IsFirstTimePredicted() then return end
    if ply:KeyDown(IN_WALK) and self.HasMask then
        self.HasMask = false
        self:Unbox()
        return
    end
    if ( self:IsPlayerHolding() ) then return end
    ply:PickupObject( self )
end

function ENT:Unbox()
    timer.Remove("SCP035.BoxDeterioration")
    EmitSound( "physics/cardboard/cardboard_box_impact_soft5.wav", self:GetPos() )
    local effectdata = EffectData()
    effectdata:SetOrigin( self:GetPos() )
    util.Effect( "Explosion", effectdata )
    self:Remove()
    local ent = ents.Create("scp_035_real")
    ent:SetPos(self:GetPos() + Vector(0,0,25)) 
    ent:Spawn()
end

function ENT:Touch(ent)
    if self.HasMask then return end
    if ent:GetClass() == "scp_035_real" then
        self.HasMask = true
        ent:Remove()
        self:SetColor(Color(255,56,56))
        timer.Create("SCP035.BoxDeterioration", self.BoxDeterioration, 1, function()
            self:Unbox()
        end)
    end
end
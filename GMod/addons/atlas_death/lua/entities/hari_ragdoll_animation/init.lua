include("shared.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
    self:SetModel("models/player/breen.mdl")
    self:SetPlaybackRate(math.Rand(0.5,1))
    self:SetMaterial("null")
    self.Delta = 0
    self.LerpScale = 1

    local cub = ents.Create("prop_dynamic")
    cub:SetModel("models/hunter/plates/plate.mdl")
    cub:SetPos(self:GetPos())
    cub:SetAngles(self:GetAngles())
    cub:SetNoDraw(true)
    cub:Spawn()
    self.HeightCube = cub
    self:DeleteOnRemove(cub)
end

function ENT:Think()
    local rag = self.Ragdoll
    if IsValid(rag) then
        local physcount = rag:GetPhysicsObjectCount()
        for i = 0, physcount - 1 do
            local physObj = rag:GetPhysicsObjectNum(i)
            local bone_name = rag:GetBoneName(rag:TranslatePhysBoneToBone(i))
            if not self:LookupBone(bone_name) then return end
            local bone_phys = self:TranslateBoneToPhysBone(self:LookupBone(bone_name))
            local bone1 = self:TranslatePhysBoneToBone(bone_phys)
            local idealPos, idealAng = self:GetBonePosition(bone1)

            local pos1, ang1 = LerpVector(self.LerpScale, physObj:GetPos(), idealPos), LerpAngle(self.LerpScale, physObj:GetAngles(), idealAng)
            pos1, ang1 = idealPos, idealAng

            local tr1 = util.TraceLine( {
                start = physObj:GetPos(),
                endpos = pos1,
                mask = MASK_ALL,
                filter = function(ent) 
                    return ent != self and ent != rag
                end
            })

            local tr2 = util.TraceLine( {
                start = pos1,
                endpos = pos1-Vector(0,0,100),
                mask = MASK_ALL,
                filter = function(ent) 
                    return ent != self and ent != rag
                end
            })

            if !tr1.Hit and tr2.HitPos:DistToSqr(pos1) < 10000 then
                local p = {}
                p.secondstoarrive = 0.01
                p.pos = pos1
                p.angle = ang1
                p.maxangular = 400
                p.maxangulardamp = 200
                p.maxspeed = 50
                p.maxspeeddamp = 45
                p.teleportdistance = 0
                p.deltatime = CurTime()-self.Delta

                physObj:Wake()
                physObj:ComputeShadowControl(p)
            end
        end
        if isstring(self.AnimString) and string.match(self.AnimString, "crawling") and (not self.BleedTime or self.BleedTime < CurTime()) then
            self.BleedTime = CurTime()+0.5

            util.Decal("Blood", self:GetBonePosition(0), self:GetBonePosition(0)-Vector(0,0,32), {self, rag})
        end
        if IsValid(self.HeightCube) then
            local cub = self.HeightCube
            local cpos = self:GetBonePosition(0)
            cpos.z = self:GetPos().z
            cub:SetPos(cpos)

            local tr = util.TraceLine( {
                start = cub:GetPos(),
                endpos = cub:GetPos(),
                mask = MASK_SOLID,
                filter = function(ent) 
                    return ent:GetClass() != "prop_ragdoll" and !ent:IsPlayer() and !ent:IsNPC()
                end
            })
            local tr1 = util.TraceLine( {
                start = cub:GetPos()-Vector(0,0,1),
                endpos = cub:GetPos()-Vector(0,0,2),
                mask = MASK_SOLID,
                filter = function(ent) 
                    return ent:GetClass() != "prop_ragdoll" and !ent:IsPlayer() and !ent:IsNPC()
                end
            })
            local tr1_2 = util.TraceLine( {
                start = cub:GetPos()-Vector(0,0,1),
                endpos = cub:GetPos()-Vector(0,0,999),
                mask = MASK_SOLID,
                filter = function(ent) 
                    return ent:GetClass() != "prop_ragdoll" and !ent:IsPlayer() and !ent:IsNPC()
                end
            })
            local tr2 = util.TraceLine( {
                start = cub:GetPos()+Vector(0,0,4),
                endpos = cub:GetPos()+Vector(0,0,8),
                mask = MASK_SOLID,
                filter = function(ent) 
                    return ent:GetClass() != "prop_ragdoll" and !ent:IsPlayer() and !ent:IsNPC()
                end
            })
            if tr.Hit and not tr2.Hit then
                self:SetPos(self:GetPos()+Vector(0,0,1))
            elseif not tr1.Hit and not tr2.Hit and tr1_2.HitPos:Distance(cub:GetPos()) < 100 then
                self:SetPos(self:GetPos()-Vector(0,0,1))
            end
        end
    end

    if IsValid(self.Entity) then
        self:SetPos(self.Entity:GetPos())
        self:SetAngles(self.Entity:GetAngles())
    end

    if isfunction(self.FinishFunc) and self:GetCycle() == 1 then
        self.FinishFunc()
        self:Remove()
    end

    self.Delta = CurTime()
    self:NextThink(CurTime())
    return true
end
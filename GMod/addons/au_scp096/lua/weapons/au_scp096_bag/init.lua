AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local debug = false

function SWEP:Initialize()
    --self:SetHoldType("melee")
end


hook.Add("PlayerDeath", "DropBox_Death", function(ply, inflictor, attacker)
    if ply.bagged then
        local bag = ply.bagged_by
        bag:Detatch(bag, ply)
    end
end)

hook.Add("PlayerDisconnected", "DropBox_Leave", function(ply)
    if ply.bagged then
        local bag = ents.Create("scp_096_bag")
        bag:SetPos(ply:GetPos())
        bag:Spawn()
    end
end)

hook.Add("PlayerSay", "GetBox", function(ply, text)
    if text == "!getbox" then
        local bag = ents.Create("scp_096_bag")
        bag:SetPos(ply:GetPos())
        bag:Spawn()
        return ""
    end

    if text == "!rembox" then
        if IsValid(ply.bagged_by) then
            ply.bagged_by:Detatch(ply.bagged_by)
        end
        return ""
    end
end)

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    
    local owner = self:GetOwner()
    
    local traceData = {}
    traceData.start = owner:GetShootPos()
    traceData.endpos = traceData.start + owner:GetAimVector() * 150
    traceData.filter = owner
    traceData.mins = Vector(-16, -16, -16)
    traceData.maxs = Vector(16, 16, 16)

    local tr = util.TraceHull(traceData)
    
    if tr.Hit and IsValid(tr.Entity) and tr.HitPos:Distance(owner:GetPos()) <= 150 then
        if tr.Entity:IsPlayer() then
            local player = tr.Entity
            if(player:EntIndex() != scp096currentplayer:EntIndex() or not IsValid(scp096currentplayer))then return end -- can't bag non SCP 096 entity
            if(player:EntIndex() == scp096currentplayer:EntIndex() and scp096currentplayer.swep.IsEnraged) then player:ChatPrint("You can not bag 096 while enraged!") return end
            
            local bag = ents.Create("scp_096_bag")
            bag:SetPos(player:GetPos())
            bag:Spawn()
            if not bag:Attach(bag, player) then
                bag:Remove()
            else
                owner:StripWeapon("au_scp096_bag")
            end
        end
    end

    self:SetNextPrimaryFire(CurTime() + 0.5)
end


function SWEP:SecondaryAttack() 
    if not IsFirstTimePredicted() then return end

    local player = self:GetOwner()
    if player:IsPlayer() then
        if(not IsValid(scp096currentplayer) or player:EntIndex() != scp096currentplayer:EntIndex()) then return end -- can't bag non SCP 096 entity
        if(player:EntIndex() == scp096currentplayer:EntIndex() and scp096currentplayer.swep.IsEnraged) then player:ChatPrint("You can not bag 096 while enraged!") return end
        
        local bag = ents.Create("scp_096_bag")
        bag:SetPos(player:GetPos())
        bag:Spawn()
        if not bag:Attach(bag, player) then
            bag:Remove()
        else
            player:StripWeapon("au_scp096_bag")
        end
    end

    self:SetNextPrimaryFire(CurTime() + 0.5)
end
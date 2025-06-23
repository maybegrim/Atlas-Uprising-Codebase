
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/lockers001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

function ENT:Use(ply)
    local plyJobTable = ply:getJobTable()

    if not plyJobTable then return end

    if plyJobTable.faction ~= "FOUNDATION" or 
       plyJobTable.team == TEAM_NTFJUGG or 
       plyJobTable.team == TEAM_GSCJUGG then 
        return 
    end

    if ply.RAID_LOCKER_COOLDOWN and ply.RAID_LOCKER_COOLDOWN > CurTime() then
        ply:ChatPrint("| On Cooldown")
    end

    ply.RAID_LOCKER_COOLDOWN = CurTime() + 120

    ply:SetHealth(200)
    if plyJobTable.armorValue then
        if plyJobTable.armorValue == 0 then
            plyJobTable.armorValue = 80
        end
        ply:SetArmor(plyJobTable.armorValue * 2)
    end
end

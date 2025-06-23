AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/console02a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

local inUse = false
function ENT:Use(ply)
    if ply:Team() == TEAM_SITEENG and not VENTS.Status then
        VENTS.On()
        return
    end

    if inUse then return end

    inUse = true
    --ATLASQUIZ.QuizPly(ply, numQuestions, callback)
    ATLASQUIZ.QuizPly(ply, 4, function (ply, status)
        if status then
            ply:ChatPrint("The code is "..tostring(VENTS.Code))
        else
            ply:ChatPrint("You failed to unlock the vent.")
        end

        inUse = false
    end)
end
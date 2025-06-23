-- Public Address System
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.CurrentUser = false

function ENT:Initialize()
    self:SetModel("models/props/de_prodigy/desk_console1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

local COOLDOWN_TIME = 10 -- in seconds
local lastUseTime = 0

function ENT:Use(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not AAUDIO.PA.Server.CanUsePA(ply) then return end
    if self:GetPAStatus() == 1 then return end
    if self:GetPAStatus() == 2 then
        self.CurrentUser = false
        self:SetPAStatus(3)
        AAUDIO.PA.Server.StopPA(ply, self)
        ply:ChatPrint("[PA] Stopping...")
        timer.Simple(2, function()
            if not IsValid(self) then return end
            self:SetPAStatus(0)
            if not IsValid(ply) then return end
            ply:ChatPrint("[PA] Stopped.")
        end)
        return
    end

    if CurTime() < lastUseTime + COOLDOWN_TIME then
        ply:ChatPrint("[PA] On cooldown. Please wait a bit before using again")
        return
    end

    lastUseTime = CurTime()

    self:SetPAStatus(1)
    ply:ChatPrint("[PA] Starting...")
    self.CurrentUser = ply
    AAUDIO.PA.Server.StartPA(ply, self)

    timer.Simple(2, function()
        if not IsValid(self) then return end
        if not IsValid(ply) then self:SetPAStatus(0) self.CurrentUser = false return end
        self:SetPAStatus(2)
        ply:ChatPrint("[PA] Ready. Start speaking.")
    end)
end

local nextThinkTime = 0

function ENT:Think()
    if CurTime() < nextThinkTime then return end
    nextThinkTime = CurTime() + 5

    if self:GetPAStatus() == 1 or self:GetPAStatus() == 2 then
        if not IsValid(self.CurrentUser) then
            self:SetPAStatus(3)
            if not IsValid(self) then return end
            self:SetPAStatus(0)
            return
        end

        if self.CurrentUser:GetPos():Distance(self:GetPos()) > 125 then
            if not IsValid(self) then return end
            self:SetPAStatus(0)
            if not IsValid(self.CurrentUser) then return end
            AAUDIO.PA.Server.StopPA(self.CurrentUser, self)
            self.CurrentUser:ChatPrint("[PA] Stopped PA since you are too far away.")
            self.CurrentUser = false
        end
    end
end
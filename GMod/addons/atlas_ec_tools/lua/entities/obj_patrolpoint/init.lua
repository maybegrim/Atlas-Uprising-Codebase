
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

AccessorFunc(ENT,"m_bWalk","Walk",FORCE_BOOL)
AccessorFunc(ENT,"m_type","Type",FORCE_NUMBER)
AccessorFunc(ENT,"m_bStrict","StrictMovement",FORCE_BOOL)
function ENT:Initialize()
	self:DrawShadow(false)
	self:SetNoDraw(true)
	self.m_tbNPCs = {}
end

function ENT:SetNextPatrolPoint(ent)
	self.m_nextPoint = ent
end

function ENT:SetLastPatrolPoint(ent)
	self.m_lastPoint = ent
end

function ENT:AddNPC(ent)
	table.insert(self.m_tbNPCs, ent)
end

local idle = {
	ACT_IDLE,
	ACT_IDLE_STEALTH,
	ACT_IDLE_ANGRY_MELEE,
	ACT_IDLE_RELAXED,
	ACT_IDLE_SMG1_RELAXED,
	ACT_IDLE_AIM_STEALTH,
	ACT_IDLE_MANNEDGUN,
	ACT_IDLE_ANGRY_PISTOL,
	ACT_IDLE_SHOTGUN_RELAXED,
	ACT_IDLE_RIFLE,
	ACT_IDLE_AIM_RELAXED,
	ACT_IDLE_ON_FIRE,
	ACT_IDLE_SHOTGUN_AGITATED,
	ACT_IDLE_ANGRY_SMG1,
	ACT_IDLE_PISTOL,
	ACT_IDLE_AIM_RIFLE_STIMULATED,
	ACT_IDLE_AGITATED,
	ACT_IDLE_CARRY,
	ACT_IDLE_RPG,
	ACT_IDLE_HURT,
	ACT_IDLE_ANGRY_RPG,
	ACT_IDLE_ANGRY_SHOTGUN,
	ACT_IDLE_SUITCASE,
	ACT_IDLE_SMG1_STIMULATED,
	ACT_IDLE_MELEE,
	ACT_IDLE_ANGRY,
	ACT_IDLE_AIM_STIMULATED,
	ACT_IDLE_AIM_AGITATED,
	ACT_IDLE_PACKAGE,
	ACT_IDLE_STEALTH_PISTOL,
	ACT_IDLE_SMG1,
	ACT_IDLE_RPG_RELAXED,
	ACT_IDLE_SHOTGUN_STIMULATED,
	ACT_IDLE_STIMULATED
}
function ENT:Think()
	local pos = self:GetPos()
	for i = #self.m_tbNPCs,1,-1 do
		local ent = self.m_tbNPCs[i]
		if(!ent:IsValid() || ent:Health() <= 0) then table.remove(self.m_tbNPCs,i)
		elseif((ent.GetState && ent:GetState() || ent:GetNPCState()) <= NPC_STATE_ALERT || self:GetStrictMovement()) then
			local posEnt = ent:NearestPoint(pos +ent:OBBCenter())
			local dist = pos:Distance(posEnt)
			if(dist <= 120) then
				local pPointNext = self.m_nextPoint
				if(ent.m_bPatrolBack) then
					if(!IsValid(self.m_lastPoint)) then ent.m_bPatrolBack = nil
					else pPointNext = self.m_lastPoint end
				elseif(self.m_lastPoint && !IsValid(pPointNext) && self.m_lastPoint:IsValid()) then
					ent.m_bPatrolBack = true
					pPointNext = self.m_lastPoint
				end
				if(IsValid(pPointNext)) then
					pPointNext:AddNPC(ent)
					ent:SetLastPosition(pPointNext:GetPos() +Vector(0,0,6))
					local schd
					if(pPointNext:GetWalk()) then schd = SCHED_FORCED_GO
					else schd = SCHED_FORCED_GO_RUN end
					ent:SetSchedule(schd)
				end
				table.remove(self.m_tbNPCs,i)
			else
				local act = ent:GetActivity()
				if(table.HasValue(idle,act)) then
					ent:SetLastPosition(pos +Vector(0,0,6))
					local schd
					if(self:GetWalk()) then schd = SCHED_FORCED_GO
					else schd = SCHED_FORCED_GO_RUN end
					ent:SetSchedule(schd)
				end
			end
		end
	end
end

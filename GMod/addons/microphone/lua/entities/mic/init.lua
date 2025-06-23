AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- stores mic entity IDs
all_mics = {}

-- not near active mic voice/chat range
STANDARD_VOICE_RANGE = 500
STANDARD_CHAT_RANGE = 500

-- near active mic voice/chat range
MICROPHONE_VOICE_RANGE = 5000
MICROPHONE_CHAT_RANGE = 5000

MIC_ACTIVE_RANGE = 100 -- player to mic distance limit for amplifying
MIC_SECONDS_BETWEEN_USE = 1 -- allow mic state to be toggled every x second(s)
MIC_AMPLIFICATION_STATE_SECONDS_TO_CACHE = 3 -- number of seconds to cache if a player has their voice/chat amplified

-- Server-side initialization function for the Entity
function ENT:Initialize()
    self.active = false; -- doesn't spawn active
    table.insert(all_mics, self:EntIndex()) -- adds to table, tracks mic entities globally

    self:SetModel( "models/props_fairgrounds/mic_stand.mdl" ) -- model for deploy
    --self:SetModel("models/props_c17/oildrum001.mdl") -- known model for local testing

    -- standard boilerplate
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use( ply )
    if (self.use_delay) then
        return
    end
    self.active = !self.active
    if (self.active) then
        ply:ChatPrint("The microphone is now on")
    else
        -- optimization note, this mic can be removed from all_mics when off (re-add when on) if a lot of inactive mics eventually exist
        ply:ChatPrint("The microphone is now off")
    end

    self.use_delay = true; -- ran repeatedly on each keypress in testing, this fixes that (only one toggle every 2 seconds, change if desired)
	timer.Create( string.format("MicUseDelay-%d", self:EntIndex()), MIC_SECONDS_BETWEEN_USE, 1, function() self.use_delay = false end )
end

function ENT:OnRemove() -- removes mic from all_mics list on removal
    table.RemoveByValue(all_mics, self:EntIndex())
end

--[[
function GAMEMODE:PlayerCanSeePlayersChat ( text, teamOnly, listener, speaker )
    local dist = speaker:GetPos():Distance( listener:GetPos() )

    if ( speaker.eval_delay ) then
        if ( dist <= speaker.cached_range ) then
            return true
        else
            return false
        end
    end

    local in_active_mic_range = false
	for _, mic in ipairs(all_mics) do
      local entity = Entity(mic)
      if ( IsValid(entity) and entity.active and speaker:GetPos():Distance( entity:GetPos() ) < MIC_ACTIVE_RANGE ) then -- if mic is valid and close
        in_active_mic_range = true -- short circuit if an active and close mic was found
        break
      end
    end

    local allowed_distance = -1
    if ( in_active_mic_range ) then -- set voice range to 5000 if they are in mic range
        allowed_distance = MICROPHONE_CHAT_RANGE
    else
        allowed_distance = STANDARD_CHAT_RANGE
    end

    speaker.cached_range = allowed_distance
    speaker.eval_delay = true;
	timer.Create( string.format("MicEvalDelay-%d", speaker:UserID()), MIC_AMPLIFICATION_STATE_SECONDS_TO_CACHE, 1, function() speaker.eval_delay = false end ) 
    -- limits lookups since this can run multiple times per second, seems to work in tests

	if ( dist <= allowed_distance ) then
		return true
    else
	    return false
    end
end
]]

function MicCanHearVoice ( listener, speaker )
    local dist = speaker:GetPos():Distance( listener:GetPos() )

    if ( speaker.eval_delay ) then
        if ( dist <= speaker.cached_range ) then
            return true, true
        else
            return true, false
        end
    end

    local in_active_mic_range = false
	for _, mic in ipairs(all_mics) do
      local entity = Entity(mic)
      if ( IsValid(entity) and entity.active and speaker:GetPos():Distance( entity:GetPos() ) < MIC_ACTIVE_RANGE ) then -- if mic is valid and close
        in_active_mic_range = true -- short circuit if an active and close mic was found
        break
      end
    end

    local allowed_distance = -1
    if ( in_active_mic_range ) then -- set voice range to 5000 if they are in mic range
        allowed_distance = MICROPHONE_VOICE_RANGE
    else
        return false, false
    end

    speaker.cached_range = allowed_distance
    speaker.eval_delay = true;
	timer.Create( string.format("MicEvalDelay-%d", speaker:UserID()), MIC_AMPLIFICATION_STATE_SECONDS_TO_CACHE, 1, function() if (IsValid(speaker)) then speaker.eval_delay = false end end ) 
    -- limits lookups since this can run multiple times per second, seems to work in tests

	if ( dist <= allowed_distance ) then
		return true, true
    else
	    return true, false
    end
end

    -- Calculates the natural speaking distance of players, without alteration
    -- @param listener: ply - the player recieving audio
    -- @param speaker: ply - the player sending audio
    -- @return active - if this hook should be influence the result
    -- @return descision - should the listener hear the speaker? discarded if not active 
function NaturalDistanceFallback( listener, speaker )
    local dist = speaker:GetPos():Distance( listener:GetPos() )

    if ( speaker.eval_delay ) then
        if ( dist <= speaker.cached_range ) then
            return true, true
        else
            return true, false
        end
    end

    allowed_distance = STANDARD_VOICE_RANGE

    speaker.cached_range = allowed_distance
    speaker.eval_delay = true;
	timer.Create( string.format("MicEvalDelay-%d", speaker:UserID()), MIC_AMPLIFICATION_STATE_SECONDS_TO_CACHE, 1, function() if (IsValid(speaker)) then speaker.eval_delay = false end end ) 
    -- limits lookups since this can run multiple times per second, seems to work in tests

	if ( dist <= allowed_distance ) then
		return true, true
    else
	    return true, false
    end
end

function GAMEMODE:PlayerCanHearPlayersVoice ( listener, speaker ) -- uses the exact same logic as GAMEMODE:PlayerCanSeePlayersChat

    -- place loud speaker function here

    local active, decision = MicCanHearVoice( listener, speaker ) -- do this for all hooks, in order of priority
    if active then
        return decision, decision -- allow each function to do its own caching or we can perform caching before return
    end

    local active, decision = NaturalDistanceFallback ( listener, speaker )

end
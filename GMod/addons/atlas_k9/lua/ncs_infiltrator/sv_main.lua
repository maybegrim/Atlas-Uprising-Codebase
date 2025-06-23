local invisibleWeps = {}

local function doInvis()
	local removeHook = true

    for k, v in ipairs(player.GetAll()) do
        if !NCS_INFILTRATOR.isCloaked[v] then continue end
        
		removeHook = false
		if v:Alive() and v:GetActiveWeapon():IsValid() then
            if v:GetActiveWeapon():GetClass() ~= "swep_infiltrator" then 
                NCS_INFILTRATOR.SetInvisible(v, false)
                continue 
            end

			if v:GetActiveWeapon() ~= invisibleWeps[v] then
				if invisibleWeps[v] and IsValid( invisibleWeps[v] ) then
                    activeWeapon:SetNoDraw(false)
				end

				invisibleWeps[v] = v:GetActiveWeapon()
                
				NCS_INFILTRATOR.SetInvisible(v, true)
			end
		end
	end

	if removeHook then
		hook.Remove( "Think", "NCS_CLOAK_MakeInvisibleThink" )
	end
end

function NCS_INFILTRATOR.SetInvisible(P, BOOL)
    local activeWeapon = P:GetActiveWeapon()

    if BOOL then
        P:SetNoDraw(true)
		P:DrawWorldModel(false)
		P:SetRenderMode(RENDERMODE_TRANSALPHA)
        P:Fire( "alpha", 0, 0 )

        NCS_INFILTRATOR.isCloaked[P] = true

        if IsValid( activeWeapon ) then
			activeWeapon:SetNoDraw(true)

            invisibleWeps[P] = activeWeapon
        end

        hook.Add( "Think", "NCS_CLOAK_MakeInvisibleThink", doInvis )
    else
        P:SetNoDraw(false)
		P:DrawWorldModel(true)
		P:SetRenderMode(RENDERMODE_NORMAL)
        P:Fire( "alpha", 255, 0 )

		if IsValid( activeWeapon ) then
			activeWeapon:SetNoDraw(false)
		end

        NCS_INFILTRATOR.isCloaked[P] = nil
    end
end

function NCS_INFILTRATOR.CanTakeUniform(P)
    return NCS_INFILTRATOR.CONFIG.blacklistedTeams[team.GetName(P:Team())] and false or true
end

hook.Add("NCS_INFILTRATOR_PlayerReadyForNetworking", "NCS_Infiltrator_WaitForNetworking", function(P)
    local COUNT = table.Count(NCS_INFILTRATOR.INFILTRATORS)

    net.Start("NCS_INFILTRATORS_UpdInfiltrator")
        net.WriteUInt(COUNT, 8)

        for k, v in pairs(NCS_INFILTRATOR.INFILTRATORS) do
            net.WriteString(v.newName)
            net.WriteUInt(v.newJob, 8)
        end
    net.Send(P)
end )

hook.Add("PlayerDeath", "NCS_INFILTRATORS_DieReset", function(P)
    if NCS_INFILTRATOR.INFILTRATORS[P] then
        net.Start("NCS_INFILTRATORS_DelInfiltrator")
            net.WriteUInt(P:EntIndex(), 8)
        net.Broadcast()

        timer.Remove("NCS_INFILTRATOR_resetTimer_"..P:SteamID64())

        NCS_INFILTRATOR.INFILTRATORS[P] = nil
    elseif P:GetNWBool("NCS_INFILTRATOR_hasScent") then
        P:SetNWBool("NCS_INFILTRATOR_hasScent", false)

        timer.Remove("NCS_INFILTRATOR_RemoveScent_"..PLAYER:SteamID64())
    end
end )

hook.Add("PlayerDisconnected", "NCS_INFILTRATORS_DisReset", function(P)
    if NCS_INFILTRATOR.INFILTRATORS[P] then
        timer.Remove("NCS_INFILTRATOR_resetTimer_"..P:SteamID64())
        NCS_INFILTRATOR.INFILTRATORS[P] = nil
    end
end )

hook.Add("PlayerChangedTeam", "NCS_INFILTRATORS_ChangeReset", function(P)
    if NCS_INFILTRATOR.INFILTRATORS[P] then
        timer.Remove("NCS_INFILTRATOR_resetTimer_"..P:SteamID64())
        NCS_INFILTRATOR.INFILTRATORS[P] = nil
    end
end )

util.AddNetworkString("NCS_INFILTRATORS_SetTime")
util.AddNetworkString("NCS_INFILTRATORS_AddInfiltrator")
util.AddNetworkString("NCS_INFILTRATORS_DelInfiltrator")
util.AddNetworkString("NCS_INFILTRATORS_UpdInfiltrator")
util.AddNetworkString("NCS_INFILTRATOR_TrackPlayer")

local TRACKING_COOLDOWNS = {}

net.Receive("NCS_INFILTRATOR_TrackPlayer", function(_, P)
    if TRACKING_COOLDOWNS[P] and TRACKING_COOLDOWNS[P] > CurTime() then return end

    TRACKING_COOLDOWNS[P] = CurTime() + 60
    
    local TRACKEE = net.ReadUInt(8)

    if TRACKEE and Entity(TRACKEE) then
        TRACKEE = Entity(TRACKEE)
        print("GOOD")
        net.Start("NCS_INFILTRATOR_TrackPlayer")
            net.WriteVector(TRACKEE:GetPos())
        net.Send(P)
    end
end )
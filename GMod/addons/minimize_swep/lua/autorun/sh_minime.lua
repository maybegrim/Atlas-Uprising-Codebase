CreateConVar("mm_enable", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "enable pls")
CreateConVar("mm_bperson", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Block first-person")
CreateConVar("mm_nearz", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Makes close walls not clip through your screen")
CreateConVar("mm_climbweps", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to use weapons while climbing")
CreateConVar("mm_scale", 0.05, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Your scale when you are shrunk")
CreateConVar("mm_damagemul", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The damage-multiplier when you're small")
CreateConVar("mm_time", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The time it takes for you to shrink")


if CLIENT then
	if !GetConVar("mm_key") then
		CreateClientConVar("mm_key", "20", true, false, "The key to trigger size-changing")
	end
	if !GetConVar("mm_fperson") then
		CreateClientConVar("mm_fperson", "0", true, false, "To FPS or not to FPS, that is the question")
	end
end


if SERVER then
	function MiniMeToggle(ply)
		if !GetConVar("mm_enable"):GetBool() then return end
		local sc = GetConVar("mm_scale"):GetFloat()
		local ti = GetConVar("mm_time"):GetFloat()
		if !ply:GetNWBool("Mini") then
			ply.m_SHeight = ply:GetStepSize()
			ply.m_JPower = ply:GetJumpPower()
			ply:SetModelScale( sc, ti )
			ply:SetNWBool("Mini", true)
			ply:SetNWFloat("MiniTime", CurTime() + ti)
			ply:SetStepSize( math.Clamp(sc, 0.35, 1)*ply.m_SHeight )
			ply:SetJumpPower( math.Clamp(sc, 0.75, 1)*ply.m_JPower )
			ply:SetHull( Vector(-16,-16,0)*sc, Vector(16,16,72)*sc )
			ply:SetHullDuck( Vector(-16,-16,0)*sc, Vector(16,16,36)*sc )
			ply:SetViewOffset( Vector(0,0,64*sc) )
		else
			ply:SetModelScale( 1, ti )
			ply:SetNWBool("Mini", false)
			ply:SetNWFloat("MiniTime", CurTime() + ti)
			ply:SetStepSize( ply.m_SHeight or 18 )
			ply:SetJumpPower( ply.m_JPower or 200 )
			ply:SetViewOffset( Vector(0,0,64) )
			ply:ResetHull()
			ply.m_SHeight = nil
			ply.m_JPower = nil
		end
	end

	hook.Add("PlayerDeath", "MiniMe:DeathHandle", function(ply)
		if ply:GetNWBool("Mini") then
			MiniMeToggle(ply)
		end
	end)

	hook.Add("PlayerSilentDeath", "MiniMe:SilentDeathHandle", function(ply)
		if ply:GetNWBool("Mini") then
			MiniMeToggle(ply)
		end
	end)

	hook.Add("KeyPress", "MiniMeKeyPress", function(ply,key)
		if !GetConVar("mm_enable"):GetBool() then return end
		if key == IN_USE and ply:GetNWBool("Mini") then
			local climbing = ply:GetNWBool("Climbing")
			if !climbing then
				local scale = ply:GetModelScale()
				local tr = {}
				tr.start = ply:GetPos() + Vector(0,0,32*scale)
				tr.endpos = ply:GetPos() + Vector(0,0,32*scale) + ply:GetAimVector()*32*scale
				tr.filter = ply
				tr.mins = Vector(-16,-16,-16)*scale
				tr.maxs = Vector(16,16,16)*scale
				
				local trace = util.TraceHull(tr)
				local dir = trace.HitNormal
				
				if trace.Hit and dir.z < 0.5 then
					local ang = ply:EyeAngles()
					ang.r = 0
					ply:SetEyeAngles(ang)
					ply:ViewPunchReset()
					ply:SetPos( trace.HitPos )
					ply:SetNWBool("Climbing", true)
					ply:SetNWVector("ClimbDir", -dir)
				end
			else
				ply:SetNWBool("Climbing", false)
			end
		end
	end)
	
	hook.Add("EntityTakeDamage", "MiniMeDamageMulti", function(ent,dmginfo)
		if !GetConVar("mm_enable"):GetBool() then return end
		local ply = dmginfo:GetAttacker()
		if !IsValid(ply) or !ply:IsPlayer() or !ply:GetNWBool("Mini") then return end
		local mul = GetConVar("mm_damagemul"):GetFloat()
		dmginfo:ScaleDamage(mul)
	end)
else
	hook.Add("PreRender", "MiniMeKeyDown", function()
		if !GetConVar("mm_enable"):GetBool() then return end
		if vgui.CursorVisible() then return end
		local key = GetConVar("mm_key"):GetInt()
		if key then
			if input.IsKeyDown(key) and !b_medown then
				b_medown = true
				RunConsoleCommand("mm_toggle")
			elseif !input.IsKeyDown(key) and b_medown then
				b_medown = nil
			end
		end
	end)
	
	hook.Add("CalcView", "MiniMeCalcView", function(ply, pos, angle, fov)
		if !GetConVar("mm_enable"):GetBool() then return end
		if ( !ply:IsValid() or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply or (!ply:GetNWBool("Mini") and ply:GetNWFloat("MiniTime") < CurTime()) ) then return end
		
		if GetConVar("mm_fperson"):GetBool() and !GetConVar("mm_bperson"):GetBool() and ply:GetNWFloat("MiniTime") > CurTime() then
			local p = (ply:GetNWFloat("MiniTime")-CurTime())/GetConVar("mm_time"):GetFloat()
			
			if ply:GetNWBool("Mini") then
				pos = pos + Vector(0,0,64*p)
			else
				pos = pos + Vector(0,0,64*(1-p)-64)
			end
		end
		
		if !GetConVar("mm_fperson"):GetBool() or GetConVar("mm_bperson"):GetBool() then
			if ply:GetNWBool("Climbing") then
				pos = ply:GetPos() + Vector(0,0,44*ply:GetModelScale())
			else
				pos = ply:GetPos() + Vector(0,0,80*ply:GetModelScale())
			end
			
			local distance = 80*ply:GetModelScale()
			
			pos = pos - angle:Forward() * distance
		end
		
		local wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and wep.CalcView then
			pos,angle,fov = wep:CalcView(ply, pos, angle, fov)
		end
		
		local view = {
			origin = pos,
			angles = angle,
			fov = fov,
		}
		if GetConVar("mm_nearz"):GetBool() then
			view.znear = 1
		end

		return view
	end)
	
	hook.Add("CalcViewModelView", "MiniMeViewModelCalc", function(wep, vm, oldpos, oldang, pos, ang)
		local ply = LocalPlayer()
		if !GetConVar("mm_enable"):GetBool() then return end
		if GetConVar("mm_fperson"):GetBool() and !GetConVar("mm_bperson"):GetBool() and LocalPlayer():GetNWFloat("MiniTime") > CurTime() then
			local p = (ply:GetNWFloat("MiniTime")-CurTime())/GetConVar("mm_time"):GetFloat()
			
			if ply:GetNWBool("Mini") then
				origin = pos + Vector(0,0,64*p)
			else
				origin = pos + Vector(0,0,64*(1-p)-64)
			end
			local angle = ang
			
			local wep = LocalPlayer():GetActiveWeapon()
			if IsValid(wep) and wep.GetViewModelPosition then
				origin,angle = wep:GetViewModelPosition(origin, angle)
			end
			
			return origin,angle
		end
	end)
	
	hook.Add("PostPlayerDraw", "MiniMePostPlayerDraw", function(ply)
		if !GetConVar("mm_enable"):GetBool() then return end
		if ply:GetNWBool("Mini") and !ply.b_oldlod then
			ply.b_oldlod = -1
			ply:SetLOD(0)
		elseif !ply:GetNWBool("Mini") and ply.b_oldlod then
			ply:SetLOD(ply.b_oldlod)
			ply.b_oldlod = nil
		end
	end)
	
	hook.Add( "ShouldDrawLocalPlayer", "ShouldDrawMiniMe", function()
		if ( (!GetConVar("mm_fperson"):GetBool() or GetConVar("mm_bperson"):GetBool()) and IsValid(LocalPlayer()) and !LocalPlayer():InVehicle() and LocalPlayer():Alive() and LocalPlayer():GetViewEntity() == LocalPlayer() and (LocalPlayer():GetNWBool("Mini") or LocalPlayer():GetNWFloat("MiniTime") > CurTime()) ) then return true end
	end )
end

hook.Add("Think", "MiniMyThink", function()
	if !GetConVar("mm_enable"):GetBool() then return end
	for k,ply in pairs(player.GetAll()) do
		if ply:GetNWBool("Mini") or ply:GetNWFloat("MiniTime") > CurTime() then
			local p = ply:GetModelScale()
			ply:SetHull( Vector(-16,-16,0)*p, Vector(16,16,72)*p )
			ply:SetHullDuck( Vector(-16,-16,0)*p, Vector(16,16,36)*p )
			if !GetConVar("mm_climbweps"):GetBool() and ply:GetNWBool("Climbing") then
				local wep = ply:GetActiveWeapon()
				if IsValid(wep) then
					wep:SetNextPrimaryFire(CurTime() + 0.5)
					wep:SetNextSecondaryFire(CurTime() + 0.5)
				end
			end
		end
	end
end)

hook.Add("Move", "MiniMeMove", function(ply,mv,cmd)
	if !GetConVar("mm_enable"):GetBool() then return end
	if ply:GetNWBool("Climbing") then
		local deltaTime = FrameTime()
		local pos = mv:GetOrigin()
		local dir = ply:GetNWVector("ClimbDir")
		local maxspeed = ply:GetWalkSpeed()*ply:GetModelScale()
		local up = math.Clamp(mv:GetForwardSpeed(), -1, 1)
		local side = math.Clamp(mv:GetSideSpeed(), -1, 1)
		local scale = ply:GetModelScale()
		
		local tr = {}
		tr.start = pos
		tr.endpos = pos + Vector(0,0,8*scale) + dir*32*scale
		tr.filter = ply
		tr.mins = Vector(-16,-16,-16)*scale
		tr.maxs = Vector(16,16,16)*scale
		
		local trace = util.TraceHull(tr)
		
		if trace.HitNormal.z >= 0.5 or trace.HitNormal.z <= -0.5 then
			ply:SetNWBool("Climbing", false)
			return
		elseif !trace.Hit then
			if side > 0 then
				local ang = dir:Angle()
				ang:RotateAroundAxis(ang:Up(), 90)
				local newdir = ang:Forward()
				
				local tr = {}
				tr.start = pos + dir*48*scale
				tr.endpos = pos + dir*48*scale + newdir*32*scale
				tr.filter = ply
				tr.mins = Vector(-16,-16,-16)*scale
				tr.maxs = Vector(16,16,16)*scale
				rtrace = util.TraceHull(tr)
				
				if !rtrace.Hit then ply:SetNWBool("Climbing", false) return end
				
				ply:SetNWVector("ClimbDir", newdir)
				
				trace = rtrace
			elseif side < 0 then
				local ang = dir:Angle()
				ang:RotateAroundAxis(ang:Up(), -90)
				local newdir = ang:Forward()
				
				local tr = {}
				tr.start = pos + dir*48*scale
				tr.endpos = pos + dir*48*scale + newdir*32*scale
				tr.filter = ply
				tr.mins = Vector(-16,-16,-16)*scale
				tr.maxs = Vector(16,16,16)*scale
				ltrace = util.TraceHull(tr)
				
				if !ltrace.Hit then ply:SetNWBool("Climbing", false) return end
				
				ply:SetNWVector("ClimbDir", newdir)
				
				trace = ltrace
			else
				ply:SetNWBool("Climbing", false)
				return
			end
		else
			local tr = {}
			tr.start = pos
			tr.endpos = pos + Vector(0,0,76)*scale
			tr.filter = ply
			utrace = util.TraceLine(tr)
			
			if utrace.Hit and up > 0 then
				up = 0
			end
			
			local tr = {}
			tr.start = pos
			tr.endpos = pos + Vector(0,0,-16)*scale
			tr.filter = ply
			dtrace = util.TraceLine(tr)
			
			if dtrace.Hit then
				ply:SetNWBool("Climbing", false)
				return
			end
			
			if side > 0 then
				local ang = dir:Angle()
				ang:RotateAroundAxis(ang:Up(), -90)
				local newdir = ang:Forward()
				
				local tr = {}
				tr.start = pos
				tr.endpos = pos + newdir*4*scale
				tr.filter = ply
				tr.mins = Vector(-16,-16,-16)*scale
				tr.maxs = Vector(16,16,16)*scale
				rtrace = util.TraceHull(tr)
				
				if rtrace.Hit then
					ply:SetNWVector("ClimbDir", -rtrace.HitNormal)
					
					trace = rtrace
				end
			elseif side < 0 then
				local ang = dir:Angle()
				ang:RotateAroundAxis(ang:Up(), 90)
				local newdir = ang:Forward()
				
				local tr = {}
				tr.start = pos
				tr.endpos = pos + newdir*4*scale
				tr.filter = ply
				tr.mins = Vector(-16,-16,-16)*scale
				tr.maxs = Vector(16,16,16)*scale
				ltrace = util.TraceHull(tr)
				
				if ltrace.Hit then
					ply:SetNWVector("ClimbDir", -ltrace.HitNormal)
					
					trace = ltrace
				end
			end
		end
		
		local dir = trace.HitNormal
		local ang = dir:Angle()
		local hitpos = trace.HitPos
		
		local move = dir.z == -1 and Angle(0,ply:EyeAngles().y,0):Forward()*up*maxspeed or ang:Up()*up*maxspeed - ang:Right()*side*maxspeed
		
		local newVelocity = move
		local newOrigin = pos + newVelocity * deltaTime
		
		ang:RotateAroundAxis(ang:Up(), -180)
		
		ply:SetNWVector("ClimbDir", ang:Forward())
		
		mv:SetVelocity( newVelocity )
		mv:SetOrigin( newOrigin )
		
		ply:ViewPunchReset()
		
		return true
	elseif ply:GetNWBool("Mini") then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * math.Clamp(ply:GetModelScale(), 0.01, 1))
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * math.Clamp(ply:GetModelScale(), 0.01, 1))
	elseif ply:GetNWFloat("MiniTime") > CurTime() then
		mv:SetMaxSpeed(mv:GetMaxSpeed() * math.Clamp(ply:GetModelScale(), 0.01, 1))
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * math.Clamp(ply:GetModelScale(), 0.01, 1))
	end
end)

local climbbones = {
	["ValveBiped.Bip01_R_Thigh"] = {ang = Angle(15,70,-10)},
	["ValveBiped.Bip01_R_Calf"] = {ang = Angle(5,-5,0)},
	["ValveBiped.Bip01_R_Upperarm"] = {ang = Angle(25,-55,-35)},
	["ValveBiped.Bip01_R_Forearm"] = {ang = Angle(30,10,30)},
	["ValveBiped.Bip01_R_Hand"] = {ang = Angle(18,30,30)},
	["ValveBiped.Bip01_L_Thigh"] = {ang = Angle(-15,70,10)},
	["ValveBiped.Bip01_L_Calf"] = {ang = Angle(-5,-5,0)},
	["ValveBiped.Bip01_L_Upperarm"] = {ang = Angle(-35,-55,35)},
	["ValveBiped.Bip01_L_Forearm"] = {ang = Angle(-40,20,-20)},
	["ValveBiped.Bip01_L_Hand"] = {ang = Angle(-18,30,-30)}
}

local sidebones = {
	["ValveBiped.Bip01_R_Upperarm"] = {ang = Angle(15,0,0), start = Angle(0,0,0)},
	["ValveBiped.Bip01_L_Upperarm"] = {ang = Angle(15,0,0), start = Angle(0,0,0)},
	["ValveBiped.Bip01_R_Thigh"] = {ang = Angle(15,0,0), start = Angle(0,0,0)},
	["ValveBiped.Bip01_L_Thigh"] = {ang = Angle(15,0,0), start = Angle(0,0,0)}
}

local upbones = {
	["ValveBiped.Bip01_R_Upperarm"] = {ang = Angle(0,-30,0), start = Angle(0,30,0)},
	["ValveBiped.Bip01_R_Forearm"] = {ang = Angle(0,30,0), start = Angle(0,-30,0)},
	["ValveBiped.Bip01_R_Thigh"] = {ang = Angle(0,-30,0), start = Angle(0,0,0)},
	["ValveBiped.Bip01_R_Calf"] = {ang = Angle(0,30,0), start = Angle(0,0,0)},
	["ValveBiped.Bip01_L_Upperarm"] = {ang = Angle(0,30,0), start = Angle(0,30,0)},
	["ValveBiped.Bip01_L_Forearm"] = {ang = Angle(0,-30,0), start = Angle(0,-30,0)},
	["ValveBiped.Bip01_L_Thigh"] = {ang = Angle(0,30,0), start = Angle(0,0,0)},
	["ValveBiped.Bip01_L_Calf"] = {ang = Angle(0,-30,0), start = Angle(0,0,0)}
}

function MinimePoses( ply, vel )
	if ply:GetNWBool("Mini") and GetConVar("mm_enable"):GetBool() then
		local x = (( ply:GetPoseParameter( "move_x" ) * 2 ) - 1)*(1/ply:GetModelScale())
		local y = (( ply:GetPoseParameter( "move_y" ) * 2 ) - 1)*(1/ply:GetModelScale())
		
		ply:SetPoseParameter( "move_x", math.Clamp(x, -1, 1) )
		ply:SetPoseParameter( "move_y", math.Clamp(y, -1, 1) )
		
		local len = vel:Length()
		
		local dir = ply:GetNWVector("ClimbDir")
		local ang = dir:Angle()
		local updir = ang:Up()
		local sidedir = ang:Right()
		
		if ply:GetNWBool("Climbing") then
			for bone,data in pairs(climbbones) do
				local bone_id = ply:LookupBone(bone)
				if bone_id then
					local side = sidebones[bone]
					local sidedelta = math.sin(CurTime()*10)*-math.abs(math.Clamp(vel:Dot( sidedir ), -1, 1))
					
					local up = upbones[bone]
					local updelta = math.sin(CurTime()*10)*math.abs(math.Clamp(vel:Dot( updir ), -1, 1))
					
					local ang = data.ang
					
					if side and sidedelta != 0 then
						ang = ang + side.start + Angle(side.ang.p*sidedelta, side.ang.y*sidedelta, side.ang.r*sidedelta)
					end
					if up and updelta != 0 then
						ang = ang + up.start + Angle(up.ang.p*updelta, up.ang.y*updelta, up.ang.r*updelta)
					end
					
					ply:ManipulateBoneAngles(bone_id, ang)
				end
			end
			
			ply:SetRenderAngles( ply:GetNWVector("ClimbDir"):Angle() )
			
			ply.CalcSeqOverride = ply:LookupSequence( "drive_airboat" )
			ply:SetSequence( ply.CalcSeqOverride )
			return true
		elseif IsValid(ply:GetNWEntity("Vehicle")) then
			if ply:GetNWEntity("Vehicle"):GetClass() == "npc_crow" or ply:GetNWEntity("Vehicle"):GetClass() == "npc_pigeon" then
				ply:SetPos(ply:GetNWEntity("Vehicle"):GetPos() + Vector(0,0,7.4))
				ply:SetRenderAngles( ply:GetNWEntity("Vehicle"):GetAngles() )
			elseif ply:GetNWEntity("Vehicle"):GetClass() == "npc_headcrab" then
				ply:SetPos(ply:GetNWEntity("Vehicle"):GetPos() + Vector(0,0,15))
				ply:SetRenderAngles( ply:GetNWEntity("Vehicle"):GetAngles() )
			elseif ply:GetNWEntity("Vehicle"):IsPlayer() then
				local bone_id = ply:GetNWEntity("Vehicle"):LookupBone("ValveBiped.Bip01_R_Upperarm")
				if bone_id then
					pos, ang = ply:GetNWEntity("Vehicle"):GetBonePosition(bone_id)
					
					ply:SetPos(pos - ang:Forward()*2)
					ply:SetRenderAngles( ply:GetNWEntity("Vehicle"):EyeAngles() )
				end
			else
				local bone_id = ply:GetNWEntity("Vehicle"):LookupBone("ValveBiped.Bip01_R_Upperarm")
				if bone_id then
					pos, ang = ply:GetNWEntity("Vehicle"):GetBonePosition(bone_id)
					
					ply:SetPos(pos - ang:Forward()*2.5)
					ply:SetRenderAngles( ply:GetNWEntity("Vehicle"):EyeAngles() )
				end
			end
			ply.CalcSeqOverride = ply:LookupSequence( "sit_rollercoaster" )
			ply:SetSequence( ply.CalcSeqOverride )
			return true
		end
		
		for bone_id = 1, ply:GetBoneCount()-1 do
			ply:ManipulateBoneAngles(bone_id, Angle(0,0,0))
		end
    end
end
hook.Add("UpdateAnimation", "MinimeUpdateAnims", MinimePoses)

function MinimeAnims( ply, velocity )
	 if ply:GetNWBool("Mini") and GetConVar("mm_enable"):GetBool() then
		local spd = velocity:Length2D()
		
		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1
		
		if ply:GetNWBool("Climbing") then
			ply.CalcSeqOverride = ply:LookupSequence("drive_airboat")
			ply:SetSequence(ply.CalcSeqOverride)
		elseif GAMEMODE:HandlePlayerJumping( ply, velocity ) then
		elseif ply:Crouching() then
			if spd > 0 then
				ply.CalcIdeal = ACT_MP_CROUCHWALK
			else
				ply.CalcIdeal = ACT_MP_CROUCH_IDLE
			end
		else
			if spd > ply:GetRunSpeed()*ply:GetModelScale()*0.9 then
				ply.CalcIdeal = ACT_MP_RUN
			elseif spd > 0 then
				ply.CalcIdeal = ACT_MP_WALK
			end
		end
		
		if ply:WaterLevel() >= 2 then
			ply.CalcIdeal = ACT_MP_SWIM
		end
		
		return ply.CalcIdeal, ply.CalcSeqOverride
    end
end
hook.Add("CalcMainActivity", "MinimeAnimations", MinimeAnims)

--[[
local function MMAdminSettingsPanel(panel)
    panel:ClearControls()
	
	panel:AddControl("CheckBox", {
	    Label = "Enable Mini Me",
	    Command = "mm_enable"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Block First-person",
	    Command = "mm_bperson"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Enable NearZ (Makes the view-cut closer to the camera)",
	    Command = "mm_nearz"
	})
	
	panel:AddControl("CheckBox", {
	    Label = "Enable Weapons while climbing",
	    Command = "mm_climbweps"
	})
	
	panel:AddControl("Slider", {
        Label = "Minime scale",
        Command = "mm_scale",
        Type = "Float",
        Min = "0.01",
        Max = "1",
    })
	
	panel:AddControl("Slider", {
        Label = "Minime damage multiplier",
        Command = "mm_damagemul",
        Type = "Float",
        Min = "0.1",
        Max = "2",
    })
	
	panel:AddControl("Slider", {
        Label = "Minime scale-time",
        Command = "mm_time",
        Type = "Float",
        Min = "0.01",
        Max = "1",
    })
    
end


local function MMSettingsPanel(panel)
    panel:ClearControls()
	
	panel:AddControl( "Numpad", { Label = "Minime toggle-button", Command = "mm_key" } )
	
	panel:AddControl("CheckBox", {
	    Label = "Enable First-person",
	    Command = "mm_fperson"
	})
    
end

local function PopulateMMMenu()
    spawnmenu.AddToolMenuOption("Options", "Mini Me", "Mini Me", "Admin Settings", "", "", MMAdminSettingsPanel)
    spawnmenu.AddToolMenuOption("Options", "Mini Me", "Mini Me", "Settings", "", "", MMSettingsPanel)
end
hook.Add("PopulateToolMenu", "MiniMe Cvars", PopulateMMMenu)]]
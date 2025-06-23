AddCSLuaFile()

SWEP.Base 					= "weapon_base"

SWEP.PrintName 				= "K9 Chaos"
SWEP.Author 				= ""

SWEP.Slot 					= 0
SWEP.SlotPos 				= 99

SWEP.Spawnable 				= true
SWEP.Category 				= "[NCS] Infiltrator"
SWEP.DrawCrosshair 			= true
SWEP.Crosshair 				= false

SWEP.HoldType 				= "normal"
SWEP.ViewModel 				= "models/weapons/c_arms.mdl"
SWEP.WorldModel 			= ""
SWEP.ViewModelFOV 			= 54
SWEP.ViewModelFlip 			= false
SWEP.UseHands 				= false

SWEP.Primary.Automatic		=  false
SWEP.Primary.Ammo			=  "none"

SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Ammo			=  "none"
SWEP.turretSpawnClass = false

SWEP.DrawAmmo 				= false
SWEP.DrawCrosshair 			= true
SWEP.Time 					= CurTime() + 0

local color_Gold = Color(252,180,9,255)
local color_Grey = Color(122,132,137, 180)

local function SendNotification(P, MSG)
	NCS_INFILTRATOR.AddText(P, NCS_INFILTRATOR.CONFIG.prefixColor, "["..NCS_INFILTRATOR.CONFIG.prefixText.."] ", color_white, MSG)
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:OnDrop()	self:Remove() end
function SWEP:ShouldDropOnDie() self:Remove() end

function SWEP:Think()
	if self.Owner:KeyPressed(IN_ATTACK2) and CurTime() > self.Time then
		self.Time = CurTime() + 0.2
		if self.DrawCrosshair == true then
			self.DrawCrosshair = false
		else
			self.DrawCrosshair = true
		end
	end
end


function SWEP:PrimaryAttack()
	if !self.NCS_INFILTRATOR_NextAttack or self.NCS_INFILTRATOR_NextAttack < CurTime() then
		self.NCS_INFILTRATOR_NextAttack = CurTime() + 1

		local owner = self:GetOwner()

		if SERVER then
			owner:LagCompensation( true )

			local TRACE = self:GetOwner():GetEyeTrace()
			local target = TRACE.Entity

			if target and target:IsValid() then
				if target:GetPos():DistToSqr(owner:GetPos()) > 4000 then return end
				owner:LagCompensation( false )
				target:TakeDamage(75, owner, self)
			else
				owner:LagCompensation( false )
			end
		end
	end
end

local col_Red = Color(199,29,23)
local color_lightwhite = Color(200,200,200)

local awaitingTracking = {}
local trackingPlayer = {}

function SWEP:Reload() 
	if !self.NCS_INFILTRATOR_NextReload or self.NCS_INFILTRATOR_NextReload < CurTime() then
		self.NCS_INFILTRATOR_NextReload = CurTime() + 1
		
		if CLIENT then
			local w, h = ScreenScale(500), ScreenScaleH(500)

			local RefreshPlayers

			local F = vgui.Create("NCS_INFILTRATOR_FRAME")
			F:SetSize(w * 0.2, h * 0.5)
			F:Center()
			F:MakePopup(true)

			local w, h = F:GetSize()

			local TEXT = F:Add("DTextEntry")
			TEXT:Dock(TOP)
			TEXT:SetWide(w * 0.6)
			TEXT:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
			TEXT:SetTall(h * 0.025)
			TEXT:SetPlaceholderText("Find Player")
			TEXT.OnValueChange = function(s)
				if s:GetValue() == "" then
					RefreshPlayers()
				else
					RefreshPlayers(s:GetValue())
				end
			end

			local SCROLL = F:Add("NCS_INFILTRATOR_SCROLL")
			SCROLL:Dock(FILL)
			SCROLL:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)

			RefreshPlayers = function(SEARCH)
				SCROLL:Clear()
				

				for k, v in ipairs(player.GetAll()) do
					if !SEARCH or ( SEARCH and string.find(string.lower(v:Name()), string.lower(SEARCH)) or ( v:SteamID64() == SEARCH ) or ( v:SteamID() == SEARCH ) ) then
						
						local LB = SCROLL:Add("DLabel")
						LB:SetText("")
						LB:SetTall(h * 0.1)
						LB:Dock(TOP)
						LB:SetMouseInputEnabled(true)
						LB:DockPadding(w * 0.0075, h * 0.0075, w * 0.0075, h * 0.0075)
						LB:DockMargin(0, 0, 0, h * 0.01)

						LB.Paint = function(self, w, h)
							if IsValid(v) and v.Name then
								draw.SimpleText(v:Name(), "NCS_INFILTRATOR_FRAME_TITLE", w * 0.2, h * 0.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
								draw.SimpleText(team.GetName(v:Team()), "NCS_INFILTRATOR_DESCRIPTION", w * 0.2, h * 0.65, team.GetColor(v:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
							else
								self:Remove()
								return
							end
				
							surface.SetDrawColor(color_Grey)
							surface.DrawOutlinedRect(0, 0, w, h)
						end

						local IC_PAD = LB:Add("DLabel")
						IC_PAD:Dock(LEFT)
						IC_PAD:SetWide(w * 0.15)
						IC_PAD:DockPadding(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
						IC_PAD:SetText("")

						local SICON = IC_PAD:Add("AvatarImage")
						SICON:Dock( FILL )
						SICON:SetPlayer( v, 64 )
						SICON.Paint = function(self, w, h)
							surface.SetDrawColor(color_Grey)
							surface.DrawOutlinedRect(0, 0, w, h)
						end

						local BUTTON = LB:Add("DButton")
						BUTTON:Dock(RIGHT)
						BUTTON:SetText("")
						BUTTON:SetWide(w * 0.2)
						BUTTON:DockMargin(0, 0, w * 0.01, 0)
						BUTTON:SetTall(BUTTON:GetTall() * 0.5)

						BUTTON.Paint = function(self, w, h)
							draw.RoundedBox(5, 0, 0, w, h, col_Red)

							if self:IsHovered() then
								draw.SimpleText(NCS_INFILTRATOR.GetLang(nil, "trackLabel"), "NCS_INFILTRATOR_DESCRIPTION", w * 0.5, h * 0.5, color_lightwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							else
								draw.SimpleText(NCS_INFILTRATOR.GetLang(nil, "trackLabel"), "NCS_INFILTRATOR_DESCRIPTION", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
						end

						BUTTON.DoClick = function()
							if v == LocalPlayer() then return end

							net.Start("NCS_INFILTRATOR_TrackPlayer")
								net.WriteUInt(v:EntIndex(), 8)
							net.SendToServer()

							awaitingTracking = function(VECTOR)
								SendNotification(LocalPlayer(), NCS_INFILTRATOR.GetLang(nil, "foundPlayer"))

								trackingPlayer = {
									VECTOR = VECTOR, 
									TRACKEE = v,
								}

								timer.Create("removeTrackingPin", 60 * 30, 1, function()
									trackingPlayer = {}
								end )
							end

							-- close the menu
							F:Remove()
						end
					end
				end
			end

			RefreshPlayers()
		end
	end


	return true
end

function SWEP:SecondaryAttack()
	if self:GetNextSecondaryFire() > CurTime() then return end
	if SERVER then
		self:GetOwner():EmitSound("ncs_infiltrator/dog_bark.wav")
	end

	self:SetNextSecondaryFire(CurTime() + 1)

	return true
end

net.Receive("NCS_INFILTRATOR_TrackPlayer", function()
	local VEC = net.ReadVector()

	if isvector(VEC) and isfunction(awaitingTracking) then awaitingTracking(VEC) end
end )

local overheadFootprint = Material("ncs_infiltrator/tracking.png", "noclamp smooth mips")

local flashOverhead = true
local nextFlashOverhead = nil

hook.Add("HUDPaint", "NCS_DEFIB_HUDPaint", function()
    if ( trackingPlayer and IsValid(trackingPlayer.TRACKEE) and IsValid(LocalPlayer():GetActiveWeapon()) and ( LocalPlayer():GetActiveWeapon():GetClass() == "swep_k9chaos" ) ) then
        local VEC = trackingPlayer.VECTOR

        local point = VEC

        local distPlayer = (point:Distance(LocalPlayer():GetPos()))

        if distPlayer < 200 then return end

        local scale = math.Clamp( ( (point:DistToSqr(LocalPlayer():GetPos())) / 500)^2, 15, 20)

        local point2D = point:ToScreen()

        local border = {
            {x = point2D.x + 1.2*scale, y = point2D.y + 0*scale},
            {x = point2D.x + 0*scale, y = point2D.y - 1.2*scale},
            {x = point2D.x - 1.2*scale, y = point2D.y + 0*scale}
        }

        local borderTest = ( border[2].x + border[3].x ) / 2

        if !nextFlashOverhead or nextFlashOverhead < CurTime() then
            flashOverhead = !flashOverhead
        
            nextFlashOverhead = CurTime() + 1
        end
        surface.SetMaterial( overheadFootprint )
        surface.SetDrawColor( ( ( flashOverhead and colorRed ) or color_white ) )

        surface.DrawTexturedRect(borderTest, border[1].y, 50, 50)
    end
end )
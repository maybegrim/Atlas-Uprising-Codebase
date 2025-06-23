SWEP.PrintName = "SCP-1048"
SWEP.Category = "SCP"
SWEP.Author = "Ninjapenguin16"
SWEP.Instructions = "Left click transform to 1048-A"
SWEP.Spawnable = true
SWEP.AdminOnly = false

-- Basic SWEP setup
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""

-- Run when SWEP is first initialized at server start
function SWEP:Initialize()

	-- Default stance when holding SWEP
	self:SetHoldType("passive")

end

-- Run when SWEP is deployed
function SWEP:Deploy()

    -- Set user to be virtually invincible
	self:GetOwner():SetHealth(1000000)

end

-- Prompt user for if they want to transform to SCP-1048-A
function SWEP:ShowYesNoPrompt()
    
    -- Create frame
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Confirmation")
    frame:SetSize(300, 150)
    frame:Center()
    frame:MakePopup()

    -- Add prompt to frame
    local label = vgui.Create("DLabel", frame)
    label:SetText("Change to 1048-A? You must have collected " .. GetGlobalString("SCP1048NeededEars", "5") .. " ears.")
    label:SizeToContents()
    label:SetPos(150 - label:GetWide() / 2, 40)

    -- Add yes button to frame
    local yesButton = vgui.Create("DButton", frame)
    yesButton:SetText("Yes")
    yesButton:SetSize(100, 30)
    yesButton:SetPos(40, 80)
    yesButton.DoClick = function()
        print("button pressed")
        net.Start("scp1048:swapjob")
        net.SendToServer()
        frame:Close()
    end

    -- Add no button to frame
    local noButton = vgui.Create("DButton", frame)
    noButton:SetText("No")
    noButton:SetSize(100, 30)
    noButton:SetPos(160, 80)
    noButton.DoClick = function()
        frame:Close()
    end

end

-- Called when the left mouse button is pressed
function SWEP:PrimaryAttack()

	-- Stops from being called multiple times per use
	if not(IsFirstTimePredicted()) then
		return
	end

    self:SetNextPrimaryFire(CurTime() + 0.5)

    -- Show Yes or No prompt on client
    if(CLIENT) then
        self:ShowYesNoPrompt()
    end

end
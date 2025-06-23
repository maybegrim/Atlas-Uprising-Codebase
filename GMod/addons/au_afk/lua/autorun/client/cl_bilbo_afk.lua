if CLIENT then
    local LastActiveTime = CurTime()
    local PlayerIsAFK = false
    local TimeToGoAFK = 1200 -- Normaly (1200) 20 minutes [Set back after testing]

    hook.Add("KeyPress", "TrackPlayerActivity", function()
        LastActiveTime = CurTime()
        PlayerIsAFK = false
    end)

    local LastViewAngles = Angle(0, 0, 0)

    local function CheckLookAngles()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        local CurrentViewAngles = ply:EyeAngles()
        if not CurrentViewAngles then return end
        if not (CurrentViewAngles == LastViewAngles) then
            LastViewAngles = CurrentViewAngles
            LastActiveTime = CurTime()
            PlayerIsAFK = false
        end
    end

    timer.Create("CheckAFKStatus", 1, 0, function()
        CheckLookAngles()

        if not PlayerIsAFK and CurTime() > LastActiveTime + TimeToGoAFK then
            PlayerIsAFK = true

            net.Start("SetToChoosingAFK")
            net.SendToServer()

            notification.AddLegacy("You are now AFK", NOTIFY_GENERIC, 2)
        end
    end)
end
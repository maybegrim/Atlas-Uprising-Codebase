
net.Receive("RESEARCH::POWER::DOWN", function()
    if LocalPlayer():getJobTable().faction ~= "FOUNDATION" and LocalPlayer():getJobTable().faction ~= "D-CLASS" then return end
    EmitSound( "research/power/power_down.wav", LocalPlayer():GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )

    timer.Simple(6, function()
        AAUDIO.ANNOUNCEMENTS.Play("research/power/warning_sound.wav")
    end)
end)

net.Receive("RESEARCH::POWER::UP", function()
    if LocalPlayer():getJobTable().faction ~= "FOUNDATION" and LocalPlayer():getJobTable().faction ~= "D-CLASS" then return end
    EmitSound("npc/scanner/scanner_scan5.wav", LocalPlayer():GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100)
end)
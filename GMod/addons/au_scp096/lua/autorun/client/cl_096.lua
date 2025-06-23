--[[
local Current096Ply = nil
local InBigRange = false 
local InSmallRange = false
local NextBigRange = 0
local NextSmallRange = 0

net.Receive("Update096Player", function()

    Current096Ply = net.ReadPlayer

end)

timer.Create("Check096SoundRange", 1, 0, function()

    if(IsValid(Current096Ply)) then
        
        local CurDistance = Current096Ply:GetPos():Distance(LocalPlayer:GetPos())

        if(CurDistance < 500) then
            InSmallRange = true
            -- play small sound
        elseif(CurDisance < 1000) then
            InBigRange = true
            InSmallRange = false
            -- play small sound
        else
            InBigRange = false
            InSmallRange = false
        end



    end

end)
--]]
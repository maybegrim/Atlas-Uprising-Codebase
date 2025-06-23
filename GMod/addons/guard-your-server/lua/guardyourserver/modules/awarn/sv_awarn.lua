if not GYS.AwarnExploit then return end

timer.Simple(1, function()
    net.Receive( "awarn3_requestownwarnings", function( len, pl )
        if not IsValid( pl ) then return end
        if pl:GetNWBool("AwarnACCooldown") then return end
        if not pl:GetNWInt("AwarnAntiCrash") then
            pl:SetNWInt("AwarnAntiCrash", 1)
            AWarn:GetOwnWarnings( pl )
        elseif pl:GetNWInt("AwarnAntiCrash") <= 3 then
            AWarn:GetOwnWarnings( pl )
            local amount = pl:GetNWInt("AwarnAntiCrash") + 1
            pl:SetNWInt("AwarnAntiCrash", amount)
        elseif pl:GetNWInt("AwarnAntiCrash") > 3 then
            pl:SetNWBool("AwarnACCooldown", true)
            pl:SendLua( "chat.AddText(Color(72, 243, 198), '[GYS.GG] ', Color(255, 255, 255), 'You cannot request your warnings for another 60 seconds!')" )
            timer.Create("AwarnCoolDownTimer", 60, 1, function() pl:SetNWBool("AwarnACCooldown", false) pl:SetNWInt("AwarnAntiCrash", 0) end)
        end
    end )
end)

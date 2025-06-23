currentcode = "Code Green"
codecolor = Color(0, 200, 0, 255)
local url

net.Receive("UpdateClientOnCurrentCode", function()
	currentcode = net.ReadString()
	if currentcode == "Code Green" then
		codecolor = Color(92, 223, 92)
		url = CODE_CONFIG.CodeURLs[currentcode] or ""
	elseif currentcode == "Code Yellow" then
		codecolor = Color(245, 223, 76)
		url = CODE_CONFIG.CodeURLs[currentcode] or ""
	elseif currentcode == "Code Red" then
		codecolor = Color(230, 89, 89)
		url = CODE_CONFIG.CodeURLs[currentcode] or ""
	elseif currentcode == "Code White" then
		codecolor = Color(255, 255, 255, 255)
		url = CODE_CONFIG.CodeURLs[currentcode] or ""
	end
	if CODE_CONFIG.CanSeeJobs[LocalPlayer():Team()] then
		if currentcode == "Code White" then
			chat.AddText(Color(100, 0, 0, 255), "| Site Systems | ", Color(175, 175, 175, 255), currentcode, color_white, " has been put into effect!")
		elseif currentcode == "Code Black" then
			chat.AddText(Color(100, 0, 0, 255), "| Site Systems | ", color_black, currentcode, color_white, " has been put into effect!")
		else
			chat.AddText(Color(100, 0, 0, 255), "| Site Systems | ", codecolor, currentcode, color_white, " has been put into effect!")
		end
	    if LocalPlayer().channel ~= nil && LocalPlayer().channel:IsValid() then
	        LocalPlayer().channel:Stop()
	    end
	    --[[sound.PlayFile(url,"",function(ch)
	        if ch != nil and ch:IsValid() then
	            ch:Play()
	            LocalPlayer().channel = ch
	        end
	    end)]]

		--AAUDIO.ANNOUNCEMENTS.Play(sndFile)
		AAUDIO.ANNOUNCEMENTS.Play(url)
	end
end)
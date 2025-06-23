-- [ OLD UMSG CODE ] --
--[[local function CW_Flashbanged(data)
	local intensity = data:ReadFloat()
	local duration = data:ReadFloat()
	
	LocalPlayer():cwFlashbang(intensity, duration)
end

usermessage.Hook("CW_FLASHBANGED", CW_Flashbanged)]]

-- [ NEW NET CODE ] --
local function CW_Flashbanged()
	local intensity = net.ReadFloat()
	local duration = net.ReadFloat()

	LocalPlayer():cwFlashbang(intensity, duration)
end

net.Receive("CW_FLASHBANGED_NET", CW_Flashbanged)

-- if you don't want this message to pop up on your server, just uncomment the line below
do return end

local displayFrequency = 43200 -- time in seconds before we can show the message again
local baseDate = 1633415189 -- the message starting point
local maxMessageDuration = 60 * 60 * 24 * 14 -- the message will be displayed once every 12 hours upon loading into a map, for 14 days, after that it won't show

-- it's time out, don't display the message at all
if os.time() > baseDate + maxMessageDuration then
	return
end

local timerDelay = 5

local targetFile = CustomizableWeaponry.baseFolder .. "/iv_message_time.txt" -- file where we store the last time we showed the message

hook.Add("InitPostEntity", "CW20_IVMessage", function()
	-- ensure directory exists
	if not file.IsDir(CustomizableWeaponry.baseFolder, "DATA") then
		file.CreateDir(CustomizableWeaponry.baseFolder)
	end
	
	-- read the data, make sure it exists and is a number
	local data = file.Read(targetFile, "DATA")
	local timestamp = os.time()
	
	if data then
		local dataNum = tonumber(data)
		
		-- too early to display the message yet? don't do anything
		if dataNum and timestamp < dataNum + displayFrequency then
			return
		end
	end
	
	local white = Color(255, 255, 255)
	local highlight = Color(117, 190, 255)
	
	-- looks like it passes, write the timestamp and show the message
	timer.Simple(timerDelay, function()
		file.Write(targetFile, timestamp)
		chat.AddText(white, "Hey! ", highlight, "Creator of Customizable Weaponry 2.0 here", white, ". I've recently released a game called '", highlight, "Intravenous", white, "' on Steam. It's a ", highlight, "stealth/action game with heavy emphasis on stealth.", white, " It does it's own thing, but some folks describe it as ", highlight, "'Hotline Miami mixed with Splinter Cell and Metal Gear'", white, " - if that sounds interesting to you, take the time to check it out on Steam. :)")
		
		timer.Simple(10, function()
			chat.AddText(white, "Thanks for using my addons. I've had a lot of fun making them, and it lead me to start making games as a consequence. Best of luck to you.")
		end)
	end)
end)
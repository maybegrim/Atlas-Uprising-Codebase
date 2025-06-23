
ROLLCONF = { 
	tchatmsg = " has rolled a ",
	cmd = "roll"

}
local conf = ROLLCONF

local function Roll(ply, args)
	local DoSay = function()
		if GAMEMODE.Config.alltalk then
			for _, target in pairs(player.GetAll()) do
				DarkRP.talkToPerson(target, team.GetColor(ply:Team()),"*".. ply:Nick().. conf.tchatmsg ..math.random(1,100)..".")
			end
		else
			DarkRP.talkToRange(ply,"*".. ply:Nick().. conf.tchatmsg ..math.random(1,100)..".", "", 250)
		end
	end
	return args, DoSay
end
DarkRP.defineChatCommand(conf.cmd, Roll, 1.5)



DarkRP.declareChatCommand{
	command = conf.cmd,
	description = "write an roll",
	delay = 1.5
}


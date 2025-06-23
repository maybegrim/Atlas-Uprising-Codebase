util.AddNetworkString("UpdateClientOnCurrentCode")
util.AddNetworkString("UpdateServerOnCurrentCode")
util.AddNetworkString("CodeControlMenu")

local currentcode = "Code Green"

net.Receive("UpdateServerOnCurrentCode", function(len, ply)
	local codeSelection = net.ReadString()
	if CODE_CONFIG.Permissions[codeSelection][ply:Team()] or ply:IsSuperAdmin() then
		currentcode = codeSelection
		for k, v in pairs(player.GetAll()) do
			net.Start("UpdateClientOnCurrentCode")
				net.WriteString(currentcode)
			net.Send(v)
		end
		hook.Run("playerChangedCode", ply, currentcode)
	end
end)

-- If people aren't receiving codes then server must be dieing of lag. Increase that timer by +5 seconds until it doesn't occur again.
hook.Add("PlayerInitialSpawn", "SendCurrentCodeOnIntSpawn", function(ply)
	timer.Simple(5, function()
		net.Start("UpdateClientOnCurrentCode")
			net.WriteString(currentcode)
		net.Send(ply)
	end)
end)

concommand.Add("code_menu", function(ply, cmd, args)
	if CODE_CONFIG.Permissions["Code Green"][ply:Team()] or ply:IsSuperAdmin() then
	   	net.Start("CodeControlMenu")
	   	net.Send(ply)
	end
end)
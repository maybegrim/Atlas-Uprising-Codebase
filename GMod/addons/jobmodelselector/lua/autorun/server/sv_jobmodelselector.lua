util.AddNetworkString("OpenJobModelSelector")

hook.Add("PlayerSay", "JobModelSelector", function(ply, text)

	if(string.lower(string.Trim(text)) == "!jobmodels") then
        net.Start("OpenJobModelSelector")
        net.Send(ply)
    end
end)
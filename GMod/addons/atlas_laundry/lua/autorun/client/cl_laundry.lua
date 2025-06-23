local function Notify(msg)
	chat.AddText(Color(255, 87, 51), "Laundry | ", Color(255, 255, 255), msg)
end

net.Receive("SimpleLaundry.Notify", function()
	Notify(net.ReadString())
end)
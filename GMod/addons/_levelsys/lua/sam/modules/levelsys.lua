local sam, command = sam, sam.command

command.set_category("Level System")

command.new("Open Main Config")
	:SetPermission("Open Main Config", "superadmin")

	:Help("Opens the main configuration menu for the level system.")

	:OnExecute(function(ply)
		ply:SendLua([[LEVEL.ConfigUI()]])
	end)
:End()

command.new("Open Weapon Config")
	:SetPermission("Open Weapon Config", "superadmin")

	:Help("Opens the weapon configuration menu for the level system.")

	:OnExecute(function(ply)
		ply:SendLua([[LEVEL.OpenWepConfig()]])
	end)
:End()


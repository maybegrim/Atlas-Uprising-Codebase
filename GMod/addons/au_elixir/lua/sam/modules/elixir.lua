--if SAM_LOADED then return end


local sam, command = sam, sam.command
local pairs, print = pairs, print
local elixirList = {}

command.set_category("Atlas Uprising")

timer.Simple(1, function()
    for k,v in pairs(Elixir.Items) do
        elixirList[k] = k
    end
end)

command.new("spawnelixir")
	:SetPermission("spawnelixir", "superadmin")

    :AddArg("player", {single_target = true})
    :AddArg("dropdown", {options = elixirList})

	:Help("Spawn an elixir item.")

	:OnExecute(function(ply, targets, item)
        local target = targets[1]
        local elixiritem = ents.Create( "elixir_item" )
        elixiritem:SetModel( "models/props_junk/cardboard_box004a.mdl" )
        elixiritem:SetPos( target:GetPos() )
        elixiritem:Spawn()
        print(item)
        local itemData = {creation_time = os.time(), id = item}
        elixiritem:SetItem(itemData)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} gave an elixir item to {V}.", {
			A = ply, V = target
		})
	end)
:End()

command.new("giveelixir")
	:SetPermission("giveelixir", "superadmin")

    :AddArg("player", {single_target = true})
    :AddArg("dropdown", {options = elixirList})

	:Help("Give an elixir item.")

	:OnExecute(function(ply, targets, item)
        local target = targets[1]

        target:GiveElixirItem(item)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} gave an elixir item to {V}.", {
			A = ply, V = target
		})
	end)
:End()
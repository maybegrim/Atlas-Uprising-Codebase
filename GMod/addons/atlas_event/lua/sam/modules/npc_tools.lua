if SAM_LOADED then return end

local sam, command  = sam, sam.command

command.set_category("NPC Tools")

command.new("Enable No Target")
	:SetPermission("Enable No Target", "admin")

	:AddArg("player")

	:Help("Makes it so NPC will not target the player.")

	:OnExecute(function(ply, targets)
        for i = 1, #targets do
            local target = targets[i]

            target:SetNoTarget(true)
        end


		sam.player.send_message(nil, "{A} has enabled no target for {T}.", {
			A = ply, T = targets
		})
	end)
:End()

command.new("Disable No Target")
    :SetPermission("Disable No Target", "admin")

    :AddArg("player")

    :Help("Makes it so NPC will target the player.")

    :OnExecute(function(ply, targets)
        for i = 1, #targets do
            local target = targets[i]

            target:SetNoTarget(false)
        end

        sam.player.send_message(nil, "{A} has disabled no target for {T}.", {
            A = ply, T = targets
        })
    end)
:End()
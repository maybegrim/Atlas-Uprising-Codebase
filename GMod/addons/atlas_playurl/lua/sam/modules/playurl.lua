--if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

command.set_category("Music")

command.new("playurl")
	:SetPermission("playurl")

	:AddArg("text", {hint = "mp3 URL"})
	:AddArg("number", {hint = "volume level", min = 1, max = 100, optional = false})

	:OnExecute(function(ply, url, volume)
        -- PlayURL.Play(ply, url, volume)
        PlayURL.Play(ply, url, volume)

        sam.player.send_message(nil, "{A} played a URL.", {
            A = ply
        })
	end)
:End()

command.new("stopurl")
    :SetPermission("stopurl")

    :OnExecute(function(ply)
        -- PlayURL.Stop(ply)
        PlayURL.Stop(ply)

        sam.player.send_message(nil, "{A} stopped the URL.", {
            A = ply
        })
    end)
:End()
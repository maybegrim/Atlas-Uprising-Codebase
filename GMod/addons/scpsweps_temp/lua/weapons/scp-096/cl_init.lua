include("shared.lua")

net.Receive("SCPSweps.PlaySound", function()
    local filePath = net.ReadString()

    surface.PlaySound(filePath)
end)

function SWEP:PrimaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    return false
end
atlasRenderPlys = {}
net.Receive("SCPSweps.AddGlow", function()

    local player = net.ReadEntity()
    if table.HasValue(atlasRenderPlys, player) then
        for k,v in ipairs(atlasRenderPlys) do
            if v == player then
                table.remove(atlasRenderPlys, k)
            end
        end
    end
    table.insert(atlasRenderPlys, player)

end)

hook.Add( "PreDrawHalos", "SCPSwepDrawHalos", function()
	halo.Add( atlasRenderPlys, Color( 255, 0, 0 ), 5, 5, 2, true, true )
end )
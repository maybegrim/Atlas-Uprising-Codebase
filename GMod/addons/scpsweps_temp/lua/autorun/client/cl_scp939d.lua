net.Receive( 'SCP939HUDOFF', function()
		hook.Remove( "Think", "SCP939NoDraw" )
		hook.Remove( "RenderScreenspaceEffects", "PostProcess939" )
        for i, v in pairs(player.GetAll()) do
            v:SetNoDraw(false)
            v:SetMaterial("")
            v:GetActiveWeapon():SetNoDraw(false)
		end
end )
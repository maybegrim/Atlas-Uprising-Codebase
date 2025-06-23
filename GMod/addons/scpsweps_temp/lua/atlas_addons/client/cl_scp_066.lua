--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

AtlasAddons.SCP066 = AtlasAddons.SCP066 or {}
AtlasAddons.SCP066.Affected = AtlasAddons.SCP066.Affected or false

-- ----------------------------------------------------------------
-- Get/Set functions for SCP 066
-- ----------------------------------------------------------------

function AtlasAddons.SCP066:GetAffected()
	return self.Affected
end

function AtlasAddons.SCP066:SetAffected( bAffected )
	self.Affected = bAffected
end

-- ----------------------------------------------------------------
-- Main code functions
-- ----------------------------------------------------------------

function AtlasAddons.SCP066:RenderScreenspaceEffects()
	if (self:GetAffected()) then
		DrawBloom(0.33,1.3,10,10,1,1.3,1,1,1)
		DrawToyTown( Lerp(1, 1, 3), ScrH() * Lerp(1, 0.5, 1) )
		DrawMotionBlur(0.2, 0.8, 0.05)
	end
end
-- ----------------------------------------------------------------
-- Register hooks
-- ----------------------------------------------------------------

hook.Add( "RenderScreenspaceEffects", "AtlasAddons.SCP066:RenderScreenspaceEffects", function()
	AtlasAddons.SCP066:RenderScreenspaceEffects()
end)
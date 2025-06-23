if GetConVar("SCP939HUD") == nil then
	CreateConVar("SCP939HUD", "nil", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
end

if GetConVar("PlayerIsShooting") == nil then
	CreateConVar("PlayerIsShooting", "nil", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
end
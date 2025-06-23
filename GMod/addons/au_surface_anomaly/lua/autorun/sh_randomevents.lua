AddCSLuaFile()

AU_Distortion = AU_Distortion or {}
AU_Distortion.Controllers = AU_Distortion.Controllers or {}
AU_Distortion.Config = AU_Distortion.Config or {}

AU_Distortion.Config = {
    ['types'] = {
        ['storm'] = 'au_storm_controller'
    }
}

local function GetEntitiesAround(entity, radius)
    if not IsValid(entity) then return {} end  -- Check if the entity is valid
    return ents.FindInSphere(entity:GetPos(), radius)  -- Get all entities within the radius
end

concommand.Add( "au_anom_rldis", function( ply, cmd, args )
    local radius = 500  -- Set the radius to search around the entity
    if not ply:IsAdmin() then return end  -- Check if the player is an admin
    local entitiesAround = GetEntitiesAround(ply, radius)

    for _, ent in ipairs(entitiesAround) do
        if IsValid(ent) and ent:GetClass() == "au_anom_rldis" then
            if not args[1] then print("Select a category") return end
            if CLIENT then return end
            AU_Distortion.ChangeCategory(ent, args[1])
        end
    end
end )


util.AddNetworkString("PA::notifyallplayers")
util.AddNetworkString("AU:RandomEvent:Controller")

AU_Distortion = AU_Distortion or {}
AU_Distortion.Controllers = AU_Distortion.Controllers or {}
AU_Distortion.Config = AU_Distortion.Config or {}

/*
    TODO: Add Machines to a variable so they can be used.
*/

/*
    Name is the title of what's going on.
    Type is the well type of disaster.
    Location is the Vector()
    Category is a scale based on 1-5 on how though this is.
*/

function AU_Distortion.Create(name, type, location, category)
    if not AU_Distortion.Config or not AU_Distortion.Config[type] then return end -- Double Check to make sure we don't spawn anything else then the controllers.
    local controller = ents.Create(type)
    controller:SetPos(location)
    controller:Spawn()
    if not IsValid(controller) then return end
    controller:SetName(name)
    controller:SetCategory(category)
    -- table.insert(AU_Distortion.EventControllers, controller)
end

function AU_Distortion.Remove(entity)
    if not IsValid(entity) then return end
    table.RemoveByValue(AU_Distortion.Controllers, entity)
    entity:Remove()
end

function AU_Distortion.ChangeCategory(entity, newcategory) -- External Way of changing the category.
    if not IsValid(entity) then return end
    if newcategory == 0 then AU_Distortion.Remove(entity) return end
    entity:SetCategory(newcategory)
end
include("shared.lua")

-- Client-side draw function for the Entity
function ENT:Draw()
    self:DrawModel() -- Draws the model of the Entity. This function is called every frame.
end

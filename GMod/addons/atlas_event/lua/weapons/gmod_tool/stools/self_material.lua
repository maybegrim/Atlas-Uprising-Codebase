TOOL.Category = "Render"
TOOL.Name = "#tool.self_material.name"

TOOL.ClientConVar["override"] = "debug/env_cubemap_model"

TOOL.Information = {
    { name = "left" },
    { name = "reload" }
}

if CLIENT then
    language.Add("tool.self_material.name", "Self Material")
    language.Add("tool.self_material.desc", "Applies a material to yourself.")
    language.Add("tool.self_material.left", "Left-click to apply the material to yourself.")
    language.Add("tool.self_material.reload", "Reload to revert the material.")
end

--
-- Duplicator function
--
local function SetMaterial(Player, Entity, Data)
    if SERVER then
        if not game.SinglePlayer() and not list.Contains("OverrideMaterials", Data.MaterialOverride) and Data.MaterialOverride ~= "" then
            return
        end
        Entity:SetMaterial(Data.MaterialOverride)
        duplicator.StoreEntityModifier(Entity, "material", Data)
        print("[DEBUG] Material set to: " .. Data.MaterialOverride) -- Debug info
    end
    return true
end

if SERVER then
    duplicator.RegisterEntityModifier("material", SetMaterial)
end

-- Left click applies the current material to the player
function TOOL:LeftClick(trace)
    local ply = self:GetOwner()
    if not IsValid(ply) then return false end -- The player is valid
    if CLIENT then return true end

    local mat = self:GetClientInfo("override")
    SetMaterial(ply, ply, { MaterialOverride = mat })
    return true
end

-- Reload reverts the player's material
function TOOL:Reload(trace)
    local ply = self:GetOwner()
    if not IsValid(ply) then return false end -- The player is valid
    if CLIENT then return true end

    SetMaterial(ply, ply, { MaterialOverride = "" })
    return true
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", { Description = "#tool.self_material.desc" })

    local filter = CPanel:AddControl("TextBox", { Label = "#spawnmenu.quick_filter_tool" })
    filter:SetUpdateOnType(true)

    -- Remove duplicate materials. table.HasValue is used to preserve material order
    local materials = {}
    for id, str in ipairs(list.Get("OverrideMaterials")) do
        if not table.HasValue(materials, str) then
            table.insert(materials, str)
        end
    end

    local matlist = CPanel:MatSelect("self_material_override", materials, true, 0.25, 0.25)

    filter.OnValueChange = function(s, txt)
        for id, pnl in ipairs(matlist.Controls) do
            if not pnl.Value:lower():find(txt:lower(), nil, true) then
                pnl:SetVisible(false)
            else
                pnl:SetVisible(true)
            end
        end
        matlist:InvalidateChildren()
        CPanel:InvalidateChildren()
    end
end

TOOL.Category = "Render"
TOOL.Name = "#tool.self_color.name"

if CLIENT then
    language.Add("tool.self_color.name", "Self Colour")
    language.Add("tool.self_color.desc", "Change your own colour.")
    language.Add("tool.self_color.left", "Left-click to change your colour.")
    language.Add("tool.self_color.reload", "Reload to reset your colour.")
    language.Add("tool.self_color.color", "Colour:")
    language.Add("tool.self_color.mode", "Render Mode:")
    language.Add("tool.self_color.fx", "Render FX:")
end

TOOL.ClientConVar["rS"] = "255"
TOOL.ClientConVar["gS"] = "255"
TOOL.ClientConVar["bS"] = "255"
TOOL.ClientConVar["aS"] = "255"
TOOL.ClientConVar["modeS"] = "0"
TOOL.ClientConVar["fxS"] = "0"

TOOL.Information = {
    { name = "left" },
    { name = "reload" }
}

local function SetColour(ply, data)
    if data.Color and data.Color.a < 255 and data.RenderMode == RENDERMODE_NORMAL then
        data.RenderMode = RENDERMODE_TRANSCOLOR
    end

    if data.Color then ply:SetColor(Color(data.Color.r, data.Color.g, data.Color.b, data.Color.a)) end
    if data.RenderMode then ply:SetRenderMode(data.RenderMode) end
    if data.RenderFX then ply:SetKeyValue("renderfx", data.RenderFX) end

    if SERVER then
        duplicator.StoreEntityModifier(ply, "self_color", data)
    end
end

if SERVER then
    duplicator.RegisterEntityModifier("self_color", SetColour)
end

function TOOL:LeftClick(trace)
    local ply = self:GetOwner()
    if not IsValid(ply) then return false end
    if CLIENT then return true end

    local r = self:GetClientNumber("rS", 255)
    local g = self:GetClientNumber("gS", 255)
    local b = self:GetClientNumber("bS", 255)
    local a = self:GetClientNumber("aS", 255)
    local fx = self:GetClientNumber("fxS", 0)
    local mode = self:GetClientNumber("modeS", 0)

    SetColour(ply, {Color = Color(r, g, b, a), RenderMode = mode, RenderFX = fx})
    return true
end

function TOOL:RightClick(trace)
    return true
end

function TOOL:Reload(trace)
    local ply = self:GetOwner()
    if not IsValid(ply) then return false end
    if CLIENT then return true end

    SetColour(ply, {Color = Color(255, 255, 255, 255), RenderMode = 0, RenderFX = 0})
    return true
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", {Description = "#tool.self_color.desc"})

    CPanel:ToolPresets("self_colour", ConVarsDefault)

    CPanel:ColorPicker("#tool.self_color.color", "self_color_rS", "self_color_gS", "self_color_bS", "self_color_aS")

    CPanel:AddControl("ListBox", {Label = "#tool.self_color.mode", Options = list.Get("RenderModes")})
    CPanel:AddControl("ListBox", {Label = "#tool.self_color.fx", Options = list.Get("RenderFX")})
end

list.Set("RenderModes", "#rendermode.normal", {self_color_mode = 0})
list.Set("RenderModes", "#rendermode.transcolor", {self_color_mode = 1})
list.Set("RenderModes", "#rendermode.transtexture", {self_color_mode = 2})
list.Set("RenderModes", "#rendermode.glow", {self_color_mode = 3})
list.Set("RenderModes", "#rendermode.transalpha", {self_color_mode = 4})
list.Set("RenderModes", "#rendermode.transadd", {self_color_mode = 5})
list.Set("RenderModes", "#rendermode.transalphaadd", {self_color_mode = 8})
list.Set("RenderModes", "#rendermode.worldglow", {self_color_mode = 9})

list.Set("RenderFX", "#renderfx.none", {self_color_fx = 0})
list.Set("RenderFX", "#renderfx.pulseslow", {self_color_fx = 1})
list.Set("RenderFX", "#renderfx.pulsefast", {self_color_fx = 2})
list.Set("RenderFX", "#renderfx.pulseslowwide", {self_color_fx = 3})
list.Set("RenderFX", "#renderfx.pulsefastwide", {self_color_fx = 4})
list.Set("RenderFX", "#renderfx.fadeslow", {self_color_fx = 5})
list.Set("RenderFX", "#renderfx.fadefast", {self_color_fx = 6})
list.Set("RenderFX", "#renderfx.solidslow", {self_color_fx = 7})
list.Set("RenderFX", "#renderfx.solidfast", {self_color_fx = 8})
list.Set("RenderFX", "#renderfx.strobeslow", {self_color_fx = 9})
list.Set("RenderFX", "#renderfx.strobefast", {self_color_fx = 10})
list.Set("RenderFX", "#renderfx.strobefaster", {self_color_fx = 11})
list.Set("RenderFX", "#renderfx.flickerslow", {self_color_fx = 12})
list.Set("RenderFX", "#renderfx.flickerfast", {self_color_fx = 13})
list.Set("RenderFX", "#renderfx.distort", {self_color_fx = 15})
list.Set("RenderFX", "#renderfx.hologram", {self_color_fx = 16})
list.Set("RenderFX", "#renderfx.pulsefastwider", {self_color_fx = 24})

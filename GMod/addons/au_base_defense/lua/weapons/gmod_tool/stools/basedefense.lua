TOOL.Category		=	"Other"
TOOL.Name			=	"Base Defense"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

if CLIENT then
    TOOL.Information = {
        { name = "left" }
    }

    language.Add("tool.basedefense.name", "Base Defense")
    language.Add("tool.basedefense.desc", "Setup props for a base defense.")
    language.Add("tool.basedefense.left", "Add a prop to a base's defense.")

    local faction = 0
    local tier = 0

    function TOOL.BuildCPanel(panel)
        panel:ClearControls()

        local faction_box = panel:ComboBox("Factions", "bd_selected_faction")
        local tier_box = panel:ComboBox("Tiers", "bd_selected_tier")
        local clear_button = panel:Button("Clear Tier")

        clear_button:SetEnabled(false)

        for i,faction in pairs(BaseDefense.Factions) do
            faction_box:AddChoice(faction.name, i)
        end

        faction_box.OnSelect = function (_, value, _)
            clear_button:SetEnabled(false)
            tier_box:Clear()
            tier_box:SetValue("Tiers")

            for i,_ in pairs(BaseDefense.Factions[value].tiers) do
                tier_box:AddChoice("Tier " .. i, i)
            end

            faction = value
        end

        tier_box.OnSelect = function (_, value, _)
            clear_button:SetEnabled(true)
            tier = value

            net.Start("BaseDefense.UpdateSelection")
                net.WriteInt(faction, 32)
                net.WriteInt(tier, 32)
            net.SendToServer()
        end

        clear_button.DoClick = function ()
            net.Start("BaseDefense.ClearTier")
            net.SendToServer()
        end
    end
else
    util.AddNetworkString("BaseDefense.UpdateSelection")
    util.AddNetworkString("BaseDefense.ClearTier")

    function TOOL:LeftClick(trace)
        local ply = self:GetOwner()

        if not BaseDefense.CanAccess(ply) then return end

        if not ply.BDFaction or ply.BDFaction == 0 or not ply.BDTier or ply.BDTier == 0 then return false end

        local prop = trace.Entity

        if not prop or prop:GetClass() != "prop_physics" then return false end

        table.insert(BaseDefense.Data.Factions[ply.BDFaction].tier_defenses[ply.BDTier], { 
            Model = prop:GetModel(), 
            Position = prop:GetPos(), 
            Angles = prop:GetAngles(),
            Material = prop:GetMaterial()
        })

        BaseDefense.Message(ply, "Added \"" .. prop:GetModel() .. "\" to " .. BaseDefense.Factions[ply.BDFaction].name .. "'s defense.")

        prop:Remove()

        BaseDefense.SwitchTierDefenses(ply.BDFaction, BaseDefense.Data.Factions[ply.BDFaction].tier)

        BaseDefense.SaveData()
    end

    net.Receive("BaseDefense.UpdateSelection", function (len, ply)
        ply.BDFaction = net.ReadInt(32)
        ply.BDTier = net.ReadInt(32)
    end)

    net.Receive("BaseDefense.ClearTier", function (len, ply)
        if not BaseDefense.CanAccess(ply) then return end

        if ply.BDFaction == 0 or ply.BDTier == 0 then return false end

        local faction_data = BaseDefense.Data.Factions[ply.BDFaction]

        faction_data.tier_defenses[ply.BDTier] = {}

        if faction_data.tier == ply.BDTier then
            for _,v in ipairs(BaseDefense.Props[ply.BDFaction] or {}) do
                if IsValid(v) then v:Remove() end
            end
        end

        BaseDefense.Message(ply, "Cleared tier " .. ply.BDTier .. ".")

        BaseDefense.SaveData()
    end)
end
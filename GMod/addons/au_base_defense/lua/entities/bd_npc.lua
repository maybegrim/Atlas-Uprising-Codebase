AddCSLuaFile()

ENT.Type = "ai";
ENT.Base = "base_ai";
ENT.AutomaticFrameAdvance = true;
ENT.PrintName = "Defense Contractor";
ENT.Author = "Buckell";
ENT.Category = "[AU] Base Defense";
ENT.Spawnable = true;

local BASEDEFENSE_THEME = {
    WindowFG = Color(102, 0, 0),
    WindowBG = Color(39, 34, 34),
    ButtonFG = Color(255, 255, 255),
    ButtonBG = Color(102, 0, 0),
    ProgressBG = Color(67, 67, 67),
    ProgressFG = Color(102, 0, 0)
}

if CLIENT then
    surface.CreateFont("basedefense.contractor", {
        font = "Roboto",
        size = 64,
        weight = 800,
        antialias = true
    })

    surface.CreateFont("basedefense.menu.current_tier", {
        font = "Roboto",
        size = 90,
        weight = 800,
        antialias = true
    })

    surface.CreateFont("basedefense.menu.current_tier_label", {
        font = "Roboto",
        size = 20,
        weight = 800,
        antialias = true
    })

    surface.CreateFont("basedefense.menu.next_tier_label", {
        font = "Roboto",
        size = 18,
        weight = 800,
        antialias = true
    })

    surface.CreateFont("basedefense.menu.amount_entry", {
        font = "Roboto",
        size = 30,
        weight = 300,
        antialias = true
    })

    surface.CreateFont("basedefense.menu.pool", {
        font = "Roboto",
        size = 25,
        weight = 800,
        antialias = true
    })

    function ENT:Draw()
        self:DrawModel()
    
        if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 500000 then return end
        
        self.up = self.up or self:OBBMaxs().z + 6;

        local pos = self:GetPos() + self:GetUp() * self.up;
        local ang = LocalPlayer():GetAngles();
        ang:RotateAroundAxis(ang:Forward(), 90);
        ang:RotateAroundAxis(ang:Right(), 90);
    
        cam.Start3D2D(pos, ang, 0.1);
            draw.SimpleTextOutlined("Defense Contractor", "basedefense.contractor", 0, 0, Color(255, 255, 255),
                TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0));
        cam.End3D2D();
    end

    net.Receive("BaseDefense.OpenMenu", function ()
        local npc = net.ReadEntity()

        if npc:GetNWString("faction") == "" then
            Derma_StringRequest("Set Faction", "This NPC has not been issued a faction. Set one now:", nil, function (text)
                net.Start("BaseDefense.SetIdentifier")
                    net.WriteEntity(npc)
                    net.WriteString(text)
                net.SendToServer()
            end)

            return
        end

        local faction_index = BaseDefense.FactionIndex(npc:GetNWString("faction"))
        local faction_data = BaseDefense.Data.Factions[faction_index]
        local faction_template = BaseDefense.Factions[faction_index]

        local window = vgui.Create(autil.VGUI_WINDOW)
        window:SetTheme(BASEDEFENSE_THEME)
        window:SetTitle("DEFENSE CONTRACTOR")
        window:MakePopup()
        window:SetSize(500, 470)
        window:Center()

        local current_tier = vgui.Create("DLabel", window)
        current_tier:SetPos(0, 50)
        current_tier:SetSize(500, 100)
        current_tier:SetContentAlignment(8)
        current_tier:SetText("TIER " .. faction_data.tier)
        current_tier:SetFont("basedefense.menu.current_tier")
        current_tier:SetColor(Color(255, 255, 255))
        
        local current_tier_label = vgui.Create("DLabel", window)
        current_tier_label:SetPos(0, 130)
        current_tier_label:SetSize(500, 30)
        current_tier_label:SetContentAlignment(8)
        current_tier_label:SetText("CURRENT TIER")
        current_tier_label:SetFont("basedefense.menu.current_tier_label")
        current_tier_label:SetColor(Color(153, 153, 153))

        if not faction_template.tiers[faction_data.tier + 1] then return end

        local progress = faction_data.progress / faction_template.tiers[faction_data.tier + 1]

        local now_time = CurTime()

        local progress_bar = vgui.Create(autil.VGUI_PROGRESS, window)
        progress_bar:SetTheme(BASEDEFENSE_THEME)
        progress_bar:SetPos(50, 180)
        progress_bar:SetSize(400, 40)
        progress_bar:SetPercentage(progress * 100)

        local pool_label = vgui.Create("DLabel", window)
        pool_label:SetPos(0, 230)
        pool_label:SetSize(500, 30)
        pool_label:SetContentAlignment(2)
        pool_label:SetText("$" .. string.Comma(faction_data.progress) .. " / $" .. string.Comma(faction_template.tiers[faction_data.tier + 1]))
        pool_label:SetFont("basedefense.menu.pool")
        pool_label:SetColor(Color(255, 255, 255))

        local next_tier_label = vgui.Create("DLabel", window)
        next_tier_label:SetPos(0, 265)
        next_tier_label:SetSize(500, 30)
        next_tier_label:SetContentAlignment(8)
        next_tier_label:SetText("TIER " .. (faction_data.tier + 1) .. " PROGRESS")
        next_tier_label:SetFont("basedefense.menu.next_tier_label")
        next_tier_label:SetColor(Color(153, 153, 153))

        local amount_entry = vgui.Create("DTextEntry", window)
        amount_entry:SetPos(175, 330)
        amount_entry:SetSize(150, 40)
        amount_entry:SetTextColor(Color(255, 255, 255))
        amount_entry:SetFGColor(Color(0, 0, 0, 0))
        amount_entry:SetDrawBackground(false)
        amount_entry:SetCursorColor(Color(255, 255, 255))
        amount_entry:SetContentAlignment(5)
        amount_entry:SetPlaceholderText("Amount")
        amount_entry:SetNumeric(true)
        amount_entry:SetFont("basedefense.menu.amount_entry")
        amount_entry.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, h - 1, w, 1, Color(255, 255, 255))
            derma.SkinHook("Paint", "TextEntry", self, w, h)
        end

        local button = vgui.Create(autil.VGUI_BUTTON, window)
        button:SetTheme(BASEDEFENSE_THEME)
        button:SetSize(200, 40)
        button:SetPos(150, 390)
        button:SetText("CONTRIBUTE")
        button.DoClick = function ()
            if amount_entry:GetText() == "" then 
                BaseDefense.Message("You must specify an amount.")
                return
            end

            local amount = math.min(amount_entry:GetInt() or 0, faction_template.tiers[faction_data.tier + 1] - faction_data.progress)
            
            if amount <= 0 then
                BaseDefense.Message("You must contribute an amount more than zero.")
                return
            end

            if not LocalPlayer():canAfford(amount) then
                BaseDefense.Message("You cannot afford to contribute this amount.")
                return
            end
            
            faction_data.progress = faction_data.progress + amount
            progress = faction_data.progress / faction_template.tiers[faction_data.tier + 1]
            now_time = CurTime()

            if progress >= 1 then
                faction_data.tier = faction_data.tier + 1
                faction_data.progress = 0

                if not faction_template.tiers[faction_data.tier + 1] then
                    progress_bar:Remove() 
                    pool_label:Remove()
                    next_tier_label:Remove()
                    amount_entry:Remove()
                    button:Remove()
                else
                    progress = faction_data.progress / faction_template.tiers[faction_data.tier + 1]

                    next_tier_label:SetText("TIER " .. (faction_data.tier + 1) .. " PROGRESS")
                end

                current_tier:SetText("TIER " .. faction_data.tier)
            end

            if faction_template.tiers[faction_data.tier + 1] then
                pool_label:SetText("$" .. string.Comma(faction_data.progress) .. " / $" .. string.Comma(faction_template.tiers[faction_data.tier + 1]))
            end

            net.Start("BaseDefense.Contribute")
                net.WriteEntity(npc)
                net.WriteInt(amount, 32)
            net.SendToServer()
        end
    end)
else
    util.AddNetworkString("BaseDefense.OpenMenu")
    util.AddNetworkString("BaseDefense.SetIdentifier")
    util.AddNetworkString("BaseDefense.Contribute")
    
    function ENT:Initialize()
        self:SetModel("models/odessa.mdl")
        self:SetHullType(HULL_HUMAN);
        self:SetHullSizeNormal();
        self:SetNPCState(NPC_STATE_SCRIPT);
        self:SetSolid(SOLID_BBOX);
        self:CapabilitiesAdd(CAP_ANIMATEDFACE || CAP_TURN_HEAD);
        self:SetUseType(SIMPLE_USE);
        self:DropToFloor();
        self:SetMaxYawSpeed(90);
    end

    function ENT:Use(activator)
        net.Start("BaseDefense.OpenMenu")
            net.WriteEntity(self)
        net.Send(activator)
    end

    net.Receive("BaseDefense.SetIdentifier", function (len, ply)
        local npc = net.ReadEntity()

        if not npc or not npc:IsValid() then return end

        local faction = net.ReadString()

        if not faction or #faction < 1 then return end

        if npc:GetNWString("faction") == "" then
            npc:SetNWString("faction", faction)
            BaseDefense.Message(ply, "You have set the faction of this NPC to: '" .. faction .. "'.")
        end
    end)

    net.Receive("BaseDefense.Contribute", function (len, ply)
        local npc = net.ReadEntity()

        if not npc or not npc:IsValid() then return end

        local faction_index = BaseDefense.FactionIndex(npc:GetNWString("faction"))
        local faction_data = BaseDefense.Data.Factions[faction_index]
        local faction_template = BaseDefense.Factions[faction_index]

        if not faction_template.tiers[faction_data.tier + 1] then return end

        local amount = math.min(math.max(net.ReadInt(32), 0), faction_template.tiers[faction_data.tier + 1] - faction_data.progress)
            
        if amount <= 0 then
            BaseDefense.Message(ply, "You must contribute an amount more than zero.")
            return
        end

        if not ply:canAfford(amount) then
            BaseDefense.Message(ply, "You cannot afford to contribute this amount.")
            return
        end
        
        faction_data.progress = faction_data.progress + amount

        if faction_data.progress >= faction_template.tiers[faction_data.tier + 1] then
            faction_data.tier = faction_data.tier + 1
            faction_data.progress = 0

            BaseDefense.Broadcast(faction_template.name .. "'s defenses have been upgraded to Tier " .. faction_data.tier .. ".")
            BaseDefense.SwitchTierDefenses(faction_index, faction_data.tier)            
        end

        ply:addMoney(-amount)

        BaseDefense.SaveData()
    end)

    hook.Add("PermaProps.OnAdd", "PermaProps.Textscreens", function(ent, data, ply)
        if ent:GetClass() == "bd_npc" then
            data.faction = ent:GetNWString("faction")
        end
    end)
    
    hook.Add("PermaProps.PostSpawn", "PermaProps.Textscreens", function(ent, data, ply)
        if ent:GetClass() == "bd_npc" then
            if data.Faction then
                ent:SetNWString("faction", data.Faction)
            end
        end
    end)

    hook.Add("InitPostEntity", "BaseDefense.PermaPropsIntegration", function ()
        if PermaProps then
            PermaProps.SpecialENTSSpawn["bd_npc"] = function (ent, data)
                if not data or not istable(data) then return end

                ent:Spawn()
                ent:Activate()

                if data.Faction then
                    ent:SetNWString("faction", data.Faction)
                end

                return true
            end

            PermaProps.SpecialENTSSave["bd_npc"] = function (ent)
                local faction = ent:GetNWString("faction")
                
                if faction == "" then return {} end

                return {
                    Other = {
                        Faction = faction
                    }
                }
            end
        end
    end)

    hook.Add("PermaProps.OnAdd", "PermaProps.BaseDefense", function(ent, data, ply)
        if ent:GetClass() == "bd_npc" then
            data.Faction = ent:GetNWString("faction")
        end
    end)
    
    hook.Add("PermaProps.PostSpawn", "PermaProps.BaseDefense", function(ent, data, ply)
        if ent:GetClass() == "bd_npc" then
            if data.Faction then
                ent:SetNWString("faction", data.Faction)
            end
        end
    end)
end
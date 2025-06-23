AddCSLuaFile()

-- Default processing time (in seconds) for a bad recipe. A random time is selected between these values.
Elixir.DefaultProcessingTimeMin = 10
Elixir.DefaultProcessingTimeMax = 30
-- Maximum amount of items of a single type allowed in the storage.
Elixir.MaxStorageTypeAmount = 3
-- How many items can a person hold at once?
-- This isn't a strict capacity, but restricts collecting fabricator results or items from
-- storage if the items will put the inventory over-capacity.
Elixir.InventoryCapacity = 10

-- This is the material you get after using the extraction tool on said job.
local elixirtabs = {
    --["JOB NAME"] = "ELIXIR ITEM",
    ["SCP-049 'The Plague Doctor'"] = "scp_049_pest",
    ["SCP-076-2 'Able'"] = "scp076_able",
    ["SCP-096 'Shy Guy'"] = "scp096_flesh",
    ["SCP-106 'The Old Man'"] = "scp106_sludge",
    ["SCP-397 'Lola'"] = "scp397_banana",
    ["SCP-457 'The Burning Man'"] = "scp457_ash",
    ["SCP-553-ATL 'The Friendly Giant'"] = "scp553_donut",
    ["SCP-662 'Mr. Deeds'"] = "scp662_tea",
    ["SCP-682 'Hard-To-Destroy Reptile'"] = "scp682_tears",
    ["SCP-774-ATL-2 'Aegis'"] = "scp774_wires",
    ["SCP-774-ATL-3 'Stygius'"] = "scp774_wires",
    ["SCP-939 'With Many Voices'"] = "scp939_fang",
    ["SCP-947-ATL '1-Inch Warrior'"] = "scp947_fragment",
    ["SCP-999 'The Tickle Monster'"] = "scp999_blob",
    ["SCP-966 'Sleep Killer'"] = "scp966_nail",
    ["SCP-1048 'The Builder Bear'"] = "scp1048_button",
    ["SCP-4000-ATL 'Joseph'"] = "scp4000_note",
    ["SCP-343 'God'"] = "scp343_blood",
    ["SCP-662-A 'Mr. Deeds'"] = "scp662_blood",
    ["Site Director"] = "sd_blood",
    ["Security Chief"] = "sc_blood",

    ["D-Class"] = "dclass_tears",
    ["Experienced D-Class"] = "dclass_tears",
    ["Medical D-Class"] = "dclass_tears",
    ["D-Class Chad"] = "dclass_tears",
    ["D-Class Cook"] = "dclass_tears",
    ["D-Class Dealer"] = "dclass_tears",
    ["D-Class Commander"] = "dclass_tears",

    ["RS: Junior"] = "researcher_blood",
    ["RS: Researcher"] = "researcher_blood",
    ["RS: Senior"] = "researcher_blood",
    ["RS: Expert"] = "researcher_blood",
    ["RS: Supervisor"] = "researcher_blood",
    ["Deputy Head of Research"] = "researcher_blood",
    ["Head of Research"] = "researcher_blood",

    ["GENSEC Trainee"] = "gen_blood",
    ["GENSEC Trooper"] = "gen_blood",
    ["GENSEC Senior Trooper"] = "gen_blood",
    ["GENSEC NCO"] = "gen_blood",
    ["GENSEC Officer"] = "gen_blood",
    ["Lead GENSEC Officer"] = "gen_blood",
    ["GENSEC Captain"] = "gen_blood",
    ["GENSEC Heavy"] = "gen_blood",
    ["GENSEC Heavy Lead"] = "gen_blood",
    ["GENSEC K9"] = "gen_blood",
    ["GENSEC Warden"] = "gen_blood",
    ["GENSEC Chief Warden"] = "gen_blood",
    ["GENSEC Defensive Specialist"] = "gen_blood",
    ["GENSEC D-S LEAD"] = "gen_blood",
    ["GENSEC Juggernaut"] = "gen_blood",

    ["NTF Trainee"] = "ntf_blood",
    ["NTF Operative"] = "ntf_blood",
    ["NTF Senior Operative"] = "ntf_blood",
    ["NTF NCO"] = "ntf_blood",
    ["NTF Officer"] = "ntf_blood",
    ["NTF Lead Containment Officer"] = "ntf_blood",
    ["NTF Captain"] = "ntf_blood",
    ["NTF Cloaking Unit"] = "ntf_blood",
    ["NTF C-U Lead"] = "ntf_blood",
    ["NTF Containment Engineer"] = "ntf_blood",
    ["NTF C-E Lead"] = "ntf_blood",
    ["NTF Juggernaut"] = "ntf_blood",

    ["AI: Initiate"] = "ci_blood", 
    ["RI: Initiate"] = "ci_blood",
    ["CI: Commander"] = "cmdr_blood",
    ["CI: Vice-Commander"] = "vcmdr_blood",
}

-- These are items and the elixirs themselves.
Elixir.Items = Elixir.Items or {
    --[[
    ["elixir_item"] = {
        name = "Elixir Item Name",
        expiration_time = 300 -- This would be 300 seconds.
    },
    ]]

    ["scp_049_pest"] = {
        name = "049's Pestilence",
        expiration_time = 900
    },
    ["scp076_able"] = {
        name = "Able's Blood",
        expiration_time = 900
    },
    ["scp096_flesh"] = {
        name = "096's Flesh",
        expiration_time = 900
    },
    ["scp106_sludge"] = {
        name = "Old Man's Sludge",
        expiration_time = 900
    },
    ["scp397_banana"] = {
        name = "Monkey's Banana",
        expiration_time = 900
    },
    ["scp457_ash"] = {
        name = "Burning Man Ash",
        expiration_time = 900
    },
    ["scp553_donut"] = {
        name = "Oversized Donut",
        expiration_time = 900
    },
    ["scp662_tea"] = {
        name = "Special Tea",
        expiration_time = 900
    },
    ["scp682_tears"] = {
        name = "Crocodile Tears",
        expiration_time = 900
    },
    ["scp774_wires"] = {
        name = "Electronic Wires",
        expiration_time = 900
    },
    ["scp939_fang"] = {
        name = "939's Fang",
        expiration_time = 900
    },
    ["scp947_fragment"] = {
        name = "Suit Fragment",
        expiration_time = 900
    },
    ["scp999_blob"] = {
        name = "Orange Blob",
        expiration_time = 900
    },
    ["scp966_nail"] = {
        name = "966's Nail",
        expiration_time = 900
    },
    ["scp1048_button"] = {
        name = "Bear's Button",
        expiration_time = 900
    },
    ["scp4000_note"] = {
        name = "Wolf's Fur",
        expiration_time = 900
    },
    ["dclass_tears"] = {
        name = "D-Class Tears",
        expiration_time = 900
    },
    ["researcher_blood"] = {
        name = "Researcher Blood",
        expiration_time = 900
    },
    ["gen_blood"] = {
        name = "GSC Blood",
        expiration_time = 900
    },
    ["ntf_blood"] = {
        name = "NTF Blood",
        expiration_time = 900
    },
    ["scp343_blood"] = {
        name = "Blood of God",
        expiration_time = 900
    },
    ["ra_blood"] = {
        name = "Research Agent Blood",
        expiration_time = 900
    },
    ["scp662_blood"] = {
        name = "Servant's Blood",
        expiration_time = 900
    },
    ["ci_blood"] = {
        name = "CI Blood",
        expiration_time = 900
    },
    ["sd_blood"] = {
        name = "Director's Blood",
        expiration_time = 900
    },
    ["sc_blood"] = {
        name = "Warrior's Blood",
        expiration_time = 900
    },
    ["ci_blood"] = {
        name = "Blood of Chaos",
        expiration_time = 900
    },
    ["cmdr_blood"] = {
        name = "Heart of the Insurgency",
        expiration_time = 900
    },
    ["vcmdr_blood"] = {
        name = "Soul of the Insurgency",
        expiration_time = 900
    },
    --[[
    ["elixir_elixir"] = {
        name = "Elixirs Name",
        on_consume = function (ply) -- Called only on the server side.
            -- Enable invincibility.
            Elixir.Message(ply, "You feel a sudden rush of power as your skin becomes impenetrable.")
            ply:GodEnable()

            -- Disable invincibility ten seconds.
            timer.Simple(10, function ()
                Elixir.Message(ply, "The rush waivers as your skin returns to normal.")
                ply:GodDisable()
            end)
        end,
        expiration_time = 0 -- Will not decay. If you do not specify a value for expiration_time, it will default to not decay.
    },
    ]]
    ["invincibility_elixir"] = {
        name = "Invincibility Elixir",
        on_consume = function (ply) -- Called only on the server side.
            -- Enable invincibility.
            Elixir.Message(ply, "You feel a sudden rush of power as your skin becomes impenetrable.")
            ply:GodEnable()

            -- Disable invincibility ten seconds.
            timer.Simple(10, function ()
                Elixir.Message(ply, "The rush waivers as your skin returns to normal.")
                ply:GodDisable()
            end)
        end,
        expiration_time = 0 -- Will not decay. If you do not specify a value for expiration_time, it will default to not decay.
    },
    ["elixir_1"] = {
        name = "Elixir #1",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "You start feeling healthier.")
            hook.Add("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.ONE", function(victim, group, dmginfo)
                if ply == victim then
                    dmginfo:ScaleDamage( 1.5 )
                end
            end)
            timer.Simple(30, function ()
                Elixir.Message(ply, "You now feel normal.")
                hook.Remove("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.ONE")
            end)
            
            timer.Create(ply:SteamID64().."ELIXIR.ONE", 1, 30, function() 
                if ply:Health() >= ply:GetMaxHealth() then
                    ply:SetHealth(ply:GetMaxHealth())
                else
                    ply:SetHealth(ply:Health() + 15)
                end
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_2"] = {
        name = "Elixir #2",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "A blur overcomes your motion but you feel fast.")
            AULIB.SetSpeed(ply, 1.60)
            AULIB.Blur(ply)
            timer.Simple(30, function ()
                Elixir.Message(ply, "You have lost your symptoms.")
                AULIB.ResetSpeed(ply)
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_3"] = {
        name = "Elixir #3",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "You feel as if you're older.")
            hook.Add("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.THREE", function(victim, group, dmginfo)
                if ply == victim then
                    dmginfo:ScaleDamage( 0.1 )
                end
            end)
            AULIB.SetSpeed(ply, 0.3)
            timer.Simple(30, function ()
                Elixir.Message(ply, "You feel normal now! How weird...")
                AULIB.ResetSpeed(ply)
                hook.Remove("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.THREE")
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_4"] = {
        name = "Elixir #4",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "You feel like boost of energy in your legs like you can jump! But a spike like pain.")
            local jumpbefore = ply:GetJumpPower()
            ply:SetJumpPower(ply:GetJumpPower() * 2)

            timer.Simple(30, function ()
                Elixir.Message(ply, "What a rush!")
                ply:SetJumpPower(jumpbefore)
            end)
            --timer.Create(ply:SteamID64().."ELIXIR.FOUR", 1, 30, function() ply:SetHealth(ply:Health() - 3) end)
        end,
        expiration_time = 1800
    },
    ["elixir_5"] = {
        name = "Elixir #5",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "You have gotten smaller and your weapons are not usable.")
            local beforeheight = ply:GetModelScale()
            ply:SelectWeapon( "weapon_empty_hands" )
            hook.Add( "PlayerSwitchWeapon", ply:SteamID64()..".ELIXIR.FIVE", function( vic )
                if ply == vic then
                    ply:SelectWeapon( "weapon_empty_hands" )
                    return true
                end
            end )
            ply:SetModelScale(beforeheight * 0.25)
            ply:SetViewOffset(Vector(0, 0, 15))
            ply:SetHull(Vector( -16, -16, 0 ), Vector( 16, 16, 1 ))
            ply:SetHullDuck(Vector( -16, -16, 0 ), Vector( 16, 16, 1 ))
            timer.Simple(60, function ()
                Elixir.Message(ply, "We're back to normal!")
                ply:SetModelScale(beforeheight)
                ply:SetViewOffset(Vector(0, 0, 64))
                ply:SetHull(Vector( -16, -16, 0 ), Vector( 16, 16, 72 ))
                ply:SetHullDuck(Vector( -16, -16, 0 ), Vector( 16, 16, 36 ))
                hook.Remove("PlayerSwitchWeapon", ply:SteamID64()..".ELIXIR.FIVE")
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_6"] = {
        name = "Elixir #6",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "Your skin feels thickend!")
            ply:GodEnable()
            AULIB.SetSpeed(ply, 0.05)
            timer.Simple(60, function ()
                Elixir.Message(ply, "Your skin feels like normal again.")
                ply:GodDisable()
                AULIB.ResetSpeed(ply)
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_7"] = {
        name = "Elixir #7",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "Your body gets a rush of butterflies as you begin to feel really happy.")
            ply:SetHealth(ply:GetMaxHealth() + 50)
            hook.Add("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.SEVEN", function(victim, group, dmginfo)
                if ply == victim then
                    dmginfo:ScaleDamage( 1.8 )
                end
            end)
            timer.Simple(30, function ()
                Elixir.Message(ply, "The happy rush has ended.")
                hook.Remove("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.SEVEN")
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_8"] = {
        name = "Elixir #8",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "Wow you feel great, I hope this doesn't crash.")
            timer.Create(ply:SteamID64().."ELIXIR.EIGHT", 1, 10, function() 
                if ply:Health() >= ply:GetMaxHealth() then
                    ply:SetHealth(ply:GetMaxHealth())
                else
                    ply:SetHealth(ply:Health() + 30)
                end
            end)
            timer.Simple(10, function ()
                Elixir.Message(ply, "Oh no something has gone wrong.")
                AtlasZombie(ply)
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_9"] = {
        name = "Elixir #9",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "Mmm... My legs feel tired. But I feel great!")
            timer.Create(ply:SteamID64().."ELIXIR.EIGHT", 1, 15, function() 
                if ply:Health() >= ply:GetMaxHealth() then
                    ply:SetHealth(ply:GetMaxHealth())
                else
                    ply:SetHealth(ply:Health() + 20)
                end
            end)
            AULIB.SetSpeed(ply, 0.20)
            timer.Simple(10, function ()
                Elixir.Message(ply, "I feel fine now.")
                AULIB.ResetSpeed(ply)
            end)
        end,
        expiration_time = 1800
    },
    ["elixir_10"] = {
        name = "Elixir #10",
        on_consume = function (ply) -- Called only on the server side.
            Elixir.Message(ply, "I... I can't SEE!")
            --[[hook.Add("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.TEN", function(victim, group, dmginfo)
                if ply == victim then
                    dmginfo:ScaleDamage( 0.10 )
                end
            end)]]
            ply:GodEnable()
            AULIB.Blind(ply)
            timer.Simple(10, function ()
                Elixir.Message(ply, "I can finally see again!")
                ply:GodDisable()
                --hook.Remove("ScalePlayerDamage", ply:SteamID64()..".ELIXIR.TEN")
            end)
        end,
        expiration_time = 1800
    },
    ["bark"] = {
        name = "Bark",
        expiration_time = 360
    }
}
if SERVER then
    function AtlasZombie(ply)
        local zombsweps = {
            "zombie_claws",
            "weapon_empty_hands"
        }
        ply:StripWeapons()
        for k,v in pairs(zombsweps) do
            ply:Give(v)
        end
        ply:SetModel("models/player/zombie_classic.mdl")
        ply:SetHealth(150)
        ply:SetArmor(100)
        ply:SendLua("chat.AddText(Color(255,56,56), '[SCP.GG] ', Color(255,255,255), 'You have turned into a ZOMBIE!!! You may now kill any human in sight!')")
    end

    hook.Add("Elixir.UseElixir", "Elixir.Zombification", function (ply, item)
        local num = math.random(100)

        if not string.find(item.id, "amnestic") and num == 69 then
            AtlasZombie(ply)
        end
    end)
    AULIB = AULIB or {}
    util.AddNetworkString("AU.ReceiveBlind")
    util.AddNetworkString("AU.ReceiveBlur")
    function AULIB.Blind(ply)
        net.Start("AU.ReceiveBlind")
        net.Send(ply)
    end
    function AULIB.Blur(ply)
        net.Start("AU.ReceiveBlur")
        net.Send(ply)
    end
    function AULIB.SetSpeed(ply, value)
        ply:SetNWFloat("AULIB.DefaultRun", ply:GetRunSpeed())
        ply:SetNWFloat("AULIB.DefaultWalk", ply:GetWalkSpeed())
        ply:SetNWFloat("AULIB.DefaultSlow", ply:GetSlowWalkSpeed())
        ply:SetRunSpeed(ply:GetRunSpeed() * value)
        ply:SetWalkSpeed(ply:GetWalkSpeed() * value)
        ply:SetSlowWalkSpeed(ply:GetSlowWalkSpeed() * value)
    end
    function AULIB.ResetSpeed(ply)
        ply:SetRunSpeed(ply:GetNWFloat("AULIB.DefaultRun", ply:GetRunSpeed()))
        ply:SetWalkSpeed(ply:GetNWFloat("AULIB.DefaultWalk", ply:GetWalkSpeed()))
        ply:SetSlowWalkSpeed(ply:GetNWFloat("AULIB.DefaultSlow", ply:GetSlowWalkSpeed()))
    end
end

if CLIENT then
    net.Receive("AU.ReceiveBlind", function()
        hook.Add('HUDPaint', 'AU.Blind', function()
            surface.SetDrawColor( Color(0,0,0,250) )
            surface.DrawRect( 0,0, ScrW(), ScrH() )
        end)
        timer.Simple(10, function()
            hook.Remove('HUDPaint', 'AU.Blind')
        end)
    end)
    net.Receive("AU.ReceiveBlur", function()
        hook.Add('HUDPaint', 'AU.BLUR', function()
            surface.SetDrawColor( Color(0,0,0,240) )
            surface.DrawRect( 0,0, ScrW(), ScrH() )
        end)
        timer.Simple(30, function()
            hook.Remove('HUDPaint', 'AU.BLUR')
        end)
    end)
end

hook.Add("Elixir.AttemptExtraction", "Elixir.Config", function (ply, ent)
    if ent:GetModel() == "models/de_corse/tree04.mdl" then
        return {
            on_complete = function (ply, ent) -- Function to run after completion.
                ply:GiveElixirItem("bark")
                Elixir.Message(ply, "You picked up a piece of bark.")
            end,
            extraction_time = 5 -- Extraction time in seconds.
        }
    end
    if ent:IsPlayer() and elixirtabs[team.GetName(ent:Team())] then
        return {
            on_complete = function (ply, ent)
                ply:GiveElixirItem(elixirtabs[team.GetName(ent:Team())])
                Elixir.Message(ply, "You have obtained a new item.")
            end,
            extraction_time = 20
        }
    end
end)
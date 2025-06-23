local footSounds = {"scps/scp106/step_1.wav", "scps/scp106/step_2.wav", "scps/scp106/step_3.wav"}

-- Create a custom entity for the decal
local ENT = {}
ENT.Type = "anim"
ENT.Base = "base_anim"
scripted_ents.Register(ENT, "custom_decal")

-- Then, in your PaintDown function:
local function PaintDown(start, effname, ignore, z)
    local btr = util.TraceLine({start=start, endpos=(start + Vector(0,0,-64)), filter=ignore, mask=MASK_VISIBLE})
    --util.Decal(effname, btr.HitPos+btr.HitNormal, btr.HitPos-btr.HitNormal)

    -- Create a custom entity at the decal's position
    local ent = ents.CreateClientside("custom_decal")
    ent:SetPos(btr.HitPos)
    ent:Spawn()

    -- draw the decal into the ent
    ent:SetModel("models/xqm/panel360.mdl")
    -- set solid black material
    ent:SetMaterial("models/props_pipes/GutterMetal01a")    -- set solid black material with transparency
    ent:SetColor(Color(0,0,0, 50))  -- 50 is the alpha value  
    -- rotate 
    ent:SetAngles(btr.HitNormal:Angle())  


    -- Remove the entity (and the decal) after 5 seconds
    timer.Simple(5, function()
        if IsValid(ent) then
            ent:Remove()
        end
    end)
end

scp106Players = {}  -- You'll need a way to identify which players are SCP-106
hook.Add( "PlayerFootstep", "ATLAS.SCPS.106", function( ply, pos, foot, sound, volume, rf )
    if IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "atlas_scp_106" then

        ply:EmitSound(footSounds[math.random(1, #footSounds)], 75, 100, 1, CHAN_AUTO)

        if LocalPlayer() ~= ply then
            local forwardOffset = ply:GetForward() * 25
            PaintDown(ply:GetPos() + forwardOffset, "Scorch", ply)
            return true
        end
        PaintDown(ply:GetPos(), "Scorch", ply)

        return true
    end
end)
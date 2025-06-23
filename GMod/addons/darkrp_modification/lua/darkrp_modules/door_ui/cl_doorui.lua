if CLIENT then
    local validKeys = {
        ["weapon_adv_keys_2"] = true,
        ["keys"] = true
    }

    surface.CreateFont("Keys:Door:Font", {
        font = "MADE Tommy",
        size = 20,
        weight = 500,
        antialias = true,
        shadow = false
    })

    local function DrawDoorUI()
        local ply = LocalPlayer()
        local eyeTrace = ply:GetEyeTrace()
        local ent = eyeTrace.Entity

        if not ply:Alive() then return end
        local plyWep = ply:GetActiveWeapon()
        if not IsValid(plyWep) then return end

        local weaponClass = plyWep:GetClass()
        if not validKeys[weaponClass] then return end

        -- Check if the player is looking at a door
        if not IsValid(ent) or not ent:isDoor() then return end

        -- Check the distance between the player and the door
        local distance = ply:GetPos():Distance(ent:GetPos())
        if distance > 150 then return end

        if ent:getKeysNonOwnable() then return end
        -- Get door ownership and title
        local doorOwner = ent:getDoorOwner() and ent:getDoorOwner():Nick() or "Unowned"

        -- Create the panel UI
        surface.SetFont("Keys:Door:Font")
        local text = "Owner: " .. doorOwner
        local textWidth, textHeight = surface.GetTextSize(text)

        -- Set up the panel position and size
        local panelWidth, panelHeight = textWidth + 20, textHeight + 20
        local x, y = ScrW() / 2 - panelWidth / 2, ScrH() / 2 + 50
        --draw.SimpleTextOutlined("Owner: " .. doorOwner, "Keys:Door:Font", x + 10, y + 40, Color(255, 255, 255), 0, 0, 1, Color(0, 0, 0, 255))
        draw.SimpleText("Owner: " .. doorOwner, "Keys:Door:Font", x + 10, y + 40, Color(255, 255, 255), 0, 0)
    end

    -- Hook to the HUDPaint to display UI while looking at doors
    hook.Add("HUDPaint", "DrawDoorUI", DrawDoorUI)
end

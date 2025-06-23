local exploSounds = {
    ["^weapons/explode1.wav"] = true,
    ["^weapons/explode2.wav"] = true,
    ["^weapons/explode3.wav"] = true,
    ["^weapons/explode4.wav"] = true,
    ["^weapons/explode5.wav"] = true,
}

hook.Add("EntityEmitSound", "ATLASCW::ExplosionShake", function(data)
    -- Check data is valid and is an explosion sound
    if data and exploSounds[data.SoundName] then
        -- Check if the explosion is close to the player
        if data.Pos and LocalPlayer():GetPos():Distance(data.Pos) < 1000 then
            -- Calculate the distance and shake the screen varied on the distance
            local distance = LocalPlayer():GetPos():Distance(data.Pos)
            local shake = math.Clamp(1000 - distance, 0, 1000) / 50
            util.ScreenShake(data.Pos, shake, 10, 3, 1000)
        end
    end
end)
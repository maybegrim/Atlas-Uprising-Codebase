include("shared.lua")

net.Receive("client-play-bible-sound", function () 
    local bibleSound = "343final.wav"
    local bookOpen = "open.wav"
    

    local playerPos = net.ReadVector()
    local soundChoose = net.ReadBool()
    local blindPlayer = net.ReadBool()
    
    
    if soundChoose then 
        EmitSound(bookOpen, playerPos)
    else
        EmitSound(bibleSound, playerPos)
    end
    
    
    timer.Simple(2, function()
        if blindPlayer then
            ply:ScreenFade(SCREENFADE.IN, color_white, 0.5, 0.25)     
        end
    end)
    
end )


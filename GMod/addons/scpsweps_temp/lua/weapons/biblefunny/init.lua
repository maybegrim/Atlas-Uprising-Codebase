AddCSLuaFile("shared.lua")

include("shared.lua")



util.AddNetworkString("client-play-bible-sound")

resource.AddFile("sound/343final.wav")

resource.AddFile("sound/open.wav")

--Local table 
pBibleTable = pBibleTable or player.GetAll()

--Adds and removes players from local table
hook.Add( "PlayerSpawn", "pBiblePlayerConnect", function(ply)
    pBibleTable[ply:SteamID64()] = ply 
end)

hook.Add( "PlayerDisconnected", "pBiblePlayerDisconnect", function(ply)
    pBibleTable[ply:SteamID64()] = nil  
end)

local bibleSound = "343final.wav"
local open = "open.wav"

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end


local function playEffects(chooseSound, owner)
    
    
    local playerPos = owner:GetPos() -- Current player
    local lookAt = owner:GetEyeTrace().Entity -- Gets thing player is looking at
    
    
    for _, curPlayer in pairs(pBibleTable) do
        --750 = distance for emmiting sound 
        if (curPlayer:GetPos():Distance(playerPos) < 750) then 
            net.Start("client-play-bible-sound")
            net.WriteVector(playerPos) --Position of god/player
            
            --Bools used for determing which sound and also to blind.
            
            --For choosing sound
            net.WriteBool(chooseSound) 
            
            --For choosing to blind
            if chooseSound == false then 
                net.WriteBool(curPlayer == lookAt)
            end
            
            net.Send(curPlayer)    
        end
    end
end


function SWEP:Deploy()
    local vm = self.Owner:GetViewModel()
    --Used for changing the current viewmodel animation
    vm:SendViewModelMatchingSequence(vm:LookupSequence("draw")) 
    
    local playerPos = self.Owner:GetPos() --Location of god/player
    
    timer.Simple(0.9, function() -- Timer used for animation to align with sound
        playEffects(true, self.Owner)
    end)
end



function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 5) -- So people don't spam
    
    if not IsFirstTimePredicted() then
        return
    end

    playEffects(false, self.Owner)

    local vm = self.Owner:GetViewModel() -- needed for below
    timer.Simple(1.7, function()
         -- Used for playing each of seperate animations for the client.
        vm:SendViewModelMatchingSequence(vm:LookupSequence("place_bookmark"))
        
        timer.Simple(0.4, function() --Needed for animation to line up with sound

            
            
            -- Timer again used for playing certin animation at certin time.
            timer.Simple(1, function() 
                vm:SendViewModelMatchingSequence(vm:LookupSequence("holster"))
            end)
        end)
    end)

     
end
--Not used in this swep
function SWEP:SecondaryAttack()
    return
end
Atlas_Breach = Atlas_Breach or {}
Atlas_Breach.SCPs = Atlas_Breach.SCPs or {}
Atlas_Breach.Players = Atlas_Breach.Players or {}

local function InteractPlayer(ply, interaction)
    print("Atlas_Breach: Telling the player an interaction: ".. interaction)
    net.Start("Atlas_Breach::Interactions")
        net.WriteString(interaction)
    net.Send(ply)
end

// local function PlaySound(soundFile)
//     print("Atlas_Breach: Telling all players to play the sound: ".. soundFile)
//     net.Start("Atlas_Breach::PlaySound")
//         net.WriteString(soundFile)
//     net.Broadcast()
// end

function Atlas_Breach.Add(ply, SCP)
    if not ply or not ply:IsValid() or not SCP then print("Atlas_Breach: Player is Invalid or SCP was not given. {Add}") return end
    if Atlas_Breach.Players[ply] then print("Atlas_Breach: The player is already in a queue {Add}") return end
    local config = Atlas_Breach.SCPs[SCP]
    if not Atlas_Breach.SCPs[SCP] then print("Atlas_Breach: Config for the SCP was not found. {Add}") return end
    if not config.breachAble then print("Atlas_Breach: SCP is not breachable and will not be added to the Queue. {Add}") return end
    if (config.curPlayers >= config.limit) then print("Atlas_Breach: To many players are on the job. {Add}") return end
    Atlas_Breach.Players[ply] = {
        breachTime = (config.breachTime * 60),
        breached = false,
    }
    Atlas_Breach.SCPs[SCP].curPlayers = (Atlas_Breach.SCPs[SCP].curPlayers + 1)
    ply:SetNW2Float("Atlas_Breach::QueueTime", CurTime() + (config.breachTime * 60))
    DarkRP.notifyAll(1, 3, ply:Nick() .." has been added to the SCP Queue..")
    InteractPlayer(ply, "showmenu")
    print("Atlas_Breach: ".. ply:Nick() .." Has been added to the SCP Queue.")
end

function Atlas_Breach.Remove(ply)
    if not ply or not ply:IsValid() then print("Atlas_Breach: Player is Invalid. {Remove}") return end
    if not Atlas_Breach.Players[ply] then print("Atlas_Breach: The player is not in a queue {Remove}") return end
    local SCP = ply:Team()
    // if Atlas_Breach.Players[ply].breached then
    //     PlaySound("atlas_audio/announcements/scp_contain_"..scp..".wav")
    // end
    Atlas_Breach.Players[ply].breached = false
    Atlas_Breach.Players[ply] = nil
    Atlas_Breach.SCPs[SCP].curPlayers = (Atlas_Breach.SCPs[SCP].curPlayers - 1)
    ply:SetNW2Float("Atlas_Breach::QueueTime", nil)
    DarkRP.notifyAll(1, 3, ply:Nick() .." has been removed from the SCP queue.")
    InteractPlayer(ply, "removemenu")
    print("Atlas_Breach: ".. ply:Nick() .." Has been Removed from the SCP Queue.")
end

function Atlas_Breach.Reset(ply)
    if not ply or not ply:IsValid() then print("Atlas_Breach: Player is Invalid. {Reset}") return end
    if not Atlas_Breach.Players[ply] then print("Atlas_Breach: The player is not in a queue {Reset}") return end
    if not Atlas_Breach.Players[ply].breached then print("Atlas_Breach: The player is not breached so they cannot reset! {Reset}") return end
    local SCP = ply:Team()
    Atlas_Breach.Remove(ply)
    Atlas_Breach.Add(ply, SCP)
end

function Atlas_Breach.Breach(ply)
    if not ply or not ply:IsValid() then print("Atlas_Breach: Player is Invalid. {Breach}") return end
    if not Atlas_Breach.Players[ply] then print("Atlas_Breach: The player is not in a queue {Breach}") return end
    local config = Atlas_Breach.SCPs[ply:Team()]
    if not Atlas_Breach.SCPs[ply:Team()] then print("Atlas_Breach: Config for the SCP was not found. {Breach}") return end
    if Atlas_Breach.Players[ply].breached then print("Atlas_Breach: The player is already breached! {Breach}") return end
    if not Atlas_Breach.Players[ply].breachTime == 0 then return print("Atlas_Breach: The player's breach is not ready! {Breach | IMPORTANT POSSIBLE EXPLOITER.}") end
    ply:SetPos(config.breachLoc)
    if timer.Exists("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) then timer.Remove("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) end
    Atlas_Breach.Players[ply].breached = true
    ply:SetNW2Float("Atlas_Breach::QueueTime", -1)
    if config.Silent then return end
    ply:Say("/advert {red [RP]} [BREACH]")
    // Announce that the SCP has breached. & Play the sound.
end

function Atlas_Breach.Advert(ply, advert)
    if not ply or not ply:IsValid() or not advert then print("Atlas_Breach: Player is Invalid or Advert was not given. {Advert}") return end
    if not Atlas_Breach.Players[ply] then print("Atlas_Breach: The player is not in a queue {Advert}") return end
    ply:Say("/advert {red [RP]} ".. advert)
end

timer.Create("Atlas_Breach::Loop", 1, -1, function()
    for ply, data in pairs(Atlas_Breach.Players) do
        if not ply or not ply:IsValid() then print("Atlas_Breach: Something went terribly wrong with: ".. ply .. "Data: ".. data.breachTime) continue end // This should never trigger.
        if not (Atlas_Breach.Players[ply].breachTime > 0) then continue end
        Atlas_Breach.Players[ply].breachTime = Atlas_Breach.Players[ply].breachTime - 1

        local advert = Atlas_Breach.SCPs[ply:Team()].adverts[(Atlas_Breach.Players[ply].breachTime / 60)]
        if advert then
            Atlas_Breach.Advert(ply, advert)
        end

        if Atlas_Breach.Players[ply].breachTime == 0 then
            timer.Create("Atlas_Breach::BreachWithin2Min".. ply:SteamID64(), Atlas_Breach.BreachTimeLimit, 1, function()
                Atlas_Breach.Players[ply].breachTime = -1
                ply:SetNW2Float("Atlas_Breach::QueueTime", -1)
            end)
        end
    end
end)

net.Receive("Atlas_Breach::Interactions", function(len, ply)
    local methods = {
        ["breach"] = Atlas_Breach.Breach,
        // ["reset"] = Atlas_Breach.Reset
    }

    local method = net.ReadString()
    if methods[method] then methods[method](ply) end
end)

hook.Add( "PlayerChangedTeam", "Atlas_Breach::ChangeTeam", function( ply, oldTeam, newTeam )
    print("Atlas_Breach: Checking if the player was on an SCP Job.")
    if timer.Exists("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) then timer.Remove("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) end
    ply.Atlas_BreachChangeTeam = true
    if Atlas_Breach.SCPs[oldTeam] then
        print("Atlas_Breach: The player was on an SCP Job. Removing them")
        Atlas_Breach.Remove(ply)
    else
        print("Atlas_Breach: The player was not on an SCP Job.")
    end

    print("Atlas_Breach: Checking if the new job is an SCP Job.")
    if Atlas_Breach.SCPs[newTeam] then
        print("Atlas_Breach: The new job is an SCP Job. Addin them")
        Atlas_Breach.Add(ply, newTeam)
    else
        print("Atlas_Breach: The new job was not an SCP Job.")
    end
end)

hook.Add("PlayerSpawn", "Atlas_Breach::PlayerSpawn", function(ply)
    if not Atlas_Breach.SCPs[ply:Team()] then return end
    if ply.Atlas_BreachChangeTeam then ply.Atlas_BreachChangeTeam = false return end
    if timer.Exists("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) then timer.Remove("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) end
    Atlas_Breach.Reset(ply)
end)

hook.Add("PlayerDisconnected", "Atlas_Breach::Disconnect", function(ply)
    if not Atlas_Breach.SCPs[ply:Team()] then return end
    if timer.Exists("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) then timer.Remove("Atlas_Breach::BreachWithin2Min".. ply:SteamID64()) end
    Atlas_Breach.Remove(ply)
end)

--------------------------------------------------------
/*            Util Stuff.

Need more information regarding the sound files etc. and if possible some names changed.
PlaySound("atlas_audio/announcements/scp_loco_"..location..".wav")
PlaySound("atlas_audio/announcements/scp_contain_"..scp..".wav")

*/

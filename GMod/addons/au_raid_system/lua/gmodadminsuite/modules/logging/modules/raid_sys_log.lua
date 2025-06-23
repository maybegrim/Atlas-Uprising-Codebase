local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Raid System"
MODULE.Name = "Raid Starts"
MODULE.Colour = Color(89,242,175)

-- AU.RaidSystem.RaidStart | faction: string | ply: player 
MODULE:Setup(function()
    MODULE:Hook("AU.RaidSystem.RaidStart", "raid_start", function(faction, ply)
        --MODULE:Log("{1} arrested {2}", GAS.Logging:FormatPlayer(actor), GAS.Logging:FormatPlayer(criminal))
        MODULE:Log("{1} has started a raid on {2}.", GAS.Logging:FormatPlayer(ply), faction)
    end)
end)
GAS.Logging:AddModule(MODULE)

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Raid System"
MODULE.Name = "Raid Extends"
MODULE.Colour = Color(89,242,175)
-- AU.RaidSystem.RaidEnd | faction: string
MODULE:Setup(function()
    MODULE:Hook("AU.RaidSystem.RaidEnd", "raid_end", function(faction)
        MODULE:Log("The raid on {1} has ended.", faction)
    end)
end)
GAS.Logging:AddModule(MODULE)

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Raid System"
MODULE.Name = "Raid Ends"
MODULE.Colour = Color(89,242,175)
-- AU.RaidSystem.RaidExtend | duration: number
MODULE:Setup(function()
    MODULE:Hook("AU.RaidSystem.RaidExtend", "raid_extend", function(duration)
        MODULE:Log("The current raid has been extended by {1} seconds.", duration)
    end)
end)

GAS.Logging:AddModule(MODULE)
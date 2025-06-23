SCP035.Model = "models/vinrax/props/scp035/035_mask.mdl"

SCP035.KillKey = KEY_K
SCP035.LureKey = KEY_L

SCP035.LureCooldown = 10

--SCP035.UnboxKey = KEY_L

SCP035.FaceMaskModel = "models/vinrax/props/scp035/035_mask.mdl"

SCP035.BoxDeterioration = 120

SCP035.JobName = "SCP-035 'The Possessive Mask'"

SCP035.ForcedPickup = 20 -- Time in seconds after being lured where mask is forced onto face

SCP035.AnswerLimit = 2.5 -- Time in seconds to answer question before failure

SCP035.HandsSwep = "weapon_empty_hands"

SCP035.HP = 600
SCP035.Armor = 200

SCP035.Text = "You must listen to SCP-035's orders or death awaits."

SCP035.Pos = Vector(-7741.687988, 10169.451172, -4707.732910) ---507.710876, 2076.258789, -2621.457275 old map

timer.Simple(1, function() -- Timer for loading team tables after DarkRP loads.
SCP035.BlacklistedTeams = {
    [TEAM_049] = true,
    [TEAM_076] = true,
    [TEAM_096] = true,
    [TEAM_106] = true,
    [TEAM_131A] = true,
    [TEAM_131B] = true,
    [TEAM_343] = true,
    [TEAM_397] = true,
    [TEAM_457] = true,
    [TEAM_553ATL] = true,
    [TEAM_682] = true,
    [TEAM_912] = true,
    [TEAM_939] = true,
    [TEAM_966] = true,
    [TEAM_999] = true,
    [TEAM_4000ATL] = true,
    [TEAM_947ATL] = true,
    [TEAM_662] = true,
}
end)

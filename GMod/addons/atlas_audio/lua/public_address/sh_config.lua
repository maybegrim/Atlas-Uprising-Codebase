--[[PUBLIC ADDRESS CONFIG]]

AAUDIO.PA.Config = {}
AAUDIO.PA.Config.AllowedJobs = {}

-- When darkrp jobs are allowed, this will be used to check if the player is allowed to use the PA
timer.Simple(1, function()
    AAUDIO.PA.Config.AllowedJobs[TEAM_GENSECCAPTAIN] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_LEADGENSECOFFICER] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_NTFLCO] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_NTFCAPTAIN] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_E6LCO] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_E6CAPTAIN] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_MUCAPTAIN] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_RADEPUTY] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_RAHOR] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_MEDATTENDING] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_MEDDIRECTOR] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_SITEDIRECTOR] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_ASSITEDIRECTOR] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_SECCHIEF] = true
    AAUDIO.PA.Config.AllowedJobs[TEAM_ASSSECCHIEF] = true
end)

AAUDIO.PA.Config.AllowedRanks = {
    ["superadmin"] = true
}
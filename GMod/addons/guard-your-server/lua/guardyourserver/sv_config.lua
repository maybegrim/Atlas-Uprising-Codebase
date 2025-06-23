--[[
    Version
]]
GYS.Version = "2.0.4"
GYS.Branch = "Stable"

--[[
    Store all logs.
]]
GYS.DataLog = true

--[[
    Choices - "ulx" and "sam"
]]
GYS.AdminMod = "sam"
GYS.CustomBanSys = true
GYS.BanSys = {
    isBanned = function(id)
        return ENFORCER.Ban.IsBanned(id)
    end,
    banPly = function(sid, time, reason)
        --ENFORCER.Ban.Player(pPlyOrId, pAdmin, pLength, pReason, pEvidence)
        return ENFORCER.Ban.Player(sid, "Console", time, reason, "GYS")
    end
}

--[[
    RootGuard is a module that protects your server from
    someone exploiting and gaining superadmin
]]
GYS.RootGuard = false
GYS.RootRank = "superadmin"
GYS.RootAccess = {
    ["STEAM_0:0:51191380"] = true,
    ["STEAM_0:1:111018925"] = true,
}
GYS.RootBan = false -- Ban if they should not be that rank.

--[[
    NPCGuard protects your server agaisn't exploiters who spawn in NPCs
    though addons that have loop holes like this. 
]]
GYS.NPCGuard = true
GYS.NPCRanks = {
    ["admin"] = true,
    ["eventcoordinator"] = true,
    ["trialeventcoordinator"] = true,
    ["senioreventcoordinator"] = true,
    ["leadeventcoordinator"] = true,
    ["servermanager"] = true,
    ["serversupervisor"] = true,
    ["leadadmin"] = true,
    ["senioradmin"] = true,
    ["affairssmt"] = true,
    ["leadcreativewriter"] = true,
    ["commsmt"] = true,
    ["admindirector"] = true,
    ["serversupervisor"] = true,
    ["servermanager"] = true,
} -- Superadmin will always have access

--[[
    BanEvasion helps prevent family shared accounts from getting
    around your bans using a very non resource intensive method.
]]
GYS.BanEvasion = true
GYS.BanEvasionTime = 0

--[[
    AntiExploit is a module that assist in detecting exploiters
    by baiting them into thinking they have found one.
]]
GYS.AntiExploit = true

--[[
    WeaponGuard removes weapons that users are not allowed
    to have like a Nuke!
]]
GYS.WeaponGuard = true
GYS.WeaponList = {
    ["banhammer"] = true,
    ["m9k_davy_crockett"] = true,
    ["weapon_nofuckoff"] = true
}
GYS.WGUserGroups = {
    ["servermanager"] = true,
    ["serversupervisor"] = true,
    ["headadmin"] = true
} -- List of allowed usergroups.

--[[
    ULXLuaRunBlock blocks ulx luarun as this is what
    exploiters commonly use for backdoor access.
]]
GYS.ULXLuaRunBlock = false
GYS.ULXLuaRunWhitelist = {
    ["STEAMID32"] = true,
    ["STEAMID32"] = true,
}
GYS.ULXLuaRunUseWhitelist = false -- Use SteamID whitelist

--[[
    ActiveGuard is essentially live protection. It
    will consistently check for attacks.

    WARNING NOTICE:
    This could possibly use a lot of resources.
]]
GYS.ActiveGuard = false

--[[ ActiveGuard Modules ]]
GYS.AG.Overseer = false -- Watch for live injection/backdoors
GYS.AG.Lockdown = false -- If elevated access is gained we will hide MySQL details from common addons, yes this can break shit if detected.

--[[
    AntiBan protects certain inviduals from ever
    being banned regardless of immunity.

    Please note that GYS.RootRank and superadmin is also used here.
]]
GYS.AntiBan = false
GYS.AntiBanSteamIDs = {
    ["STEAM_0:1:111018925"] = true,
    ["STEAM_0:0:51191380"] = true
}

--[[
    NetLogger will print net message to console
    with the Network String and Clients Name and ID
    '/logger' to enable in-game logger.

    This is good if your server crashes and you
    can view the last logs before to find out
    if it was an exploiter or not.
]]
GYS.NetLogger = true
GYS.NetLoggerRoot = false -- This will let the GYS.RootRank see these messages live in chat.
GYS.NetLoggerRanks = {
    ["servermanager"] = true,
    ["serversupervisor"] = true,
    ["headadmin"] = true
} -- Additional Ranks you want to see messages in chat.
GYS.NetLoggerBlacklist = {
    ["SCB.SendMessage"] = true,
    ["SCB.SendMessageTeam"] = true,
    ["SCB.IsTyping"] = true,
    ["gmodadminsuite:AdminSits.WindowFocus"] = true,
    ["vrutil_net_tick"] = true,
} -- Net Msgs you want to hide.

--[[
    AntiOverLoad will make an effort to slow down 
    certain nets specified in the table. This will
    ensure server isn't being overloaded by one
    player. This works great for the bodygroupr addon.

    Makes specified net messages go on cooldown.
]]
GYS.AntiOverLoad = true
GYS.OverloadNets = {
    ["bodyman_model_change"] = 1,
    ["bodyman_model_change43568"] = 1,
    ["bodygroups_change"] = 1,
    ["RDV.LEVELS.PVS_Experience"] = 1,
    ["Aero.Handle.Request"] = 1,
    ["awarn3_requestplayerwarnings"] = 0.5
} -- ["NETMESSAGE"] = DELAY, 

--[[
    GuardYourPlayer is exactly what its name
    is, it protects your player from backdoor
    exploits, abusive admins, or rogue scripts.
]]
GYS.GuardYourPlayer = false

--[[ GuardYourPlayer Modules ]]

-- IPGuard can break/alter IP Modules, Geo, or admin mods.
GYS.GYP.IPGuard = false
-- Luarun protects your player from bad code
GYS.GYP.Luarun = false

--[[
    Sandbox is a protection method for your server.
    It essentially takes all functions from your
    admin mods and some addons and makes them do
    nothing instead to ensure no further damage
    occurs.

    WARNING NOTICE:
    DO NOT ENABLE ON A PRODUCTION SERVER UNLESS YOU'RE USING IT FOR SECURITY.
]]
GYS.Sandbox = false

--[[
    Logging of detections in blogs
]]
GYS.EnableBLogs = true

--[[
    If you use Trixter's Discord Integration
    then we can send messages to relay channel.
]]
GYS.TrixterDiscord = false

--[[
    Logging of detections in plogs
]]
GYS.EnablePLogs = false

--[[
    Logging of detections in Squish Logs
]]
GYS.EnableSLogs = false

--[[
    Awarn 1.2.8 and older has an exploit
    with one of its net messages. If you
    have this version or older enable this!

    Note - This has finally been updated.
    https://www.gmodstore.com/market/view/6582/versions
]]
GYS.AwarnExploit = false

print("[GYS] Configuration Loaded")
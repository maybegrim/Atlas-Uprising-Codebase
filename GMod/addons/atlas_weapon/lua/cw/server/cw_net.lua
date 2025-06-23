--[[
    CW 2.0 Networking Upgrade
    A lot of CW 2.0 was done in UMSGs, which is a deprecated networking system.
    The goal of this file is to shift all of the UMSGs to the new net library.
]]

-- Declare new net strings
util.AddNetworkString("CW_FLASHBANGED_NET") -- Flashbang net. Only utilized in cw_flash_thrown entity.



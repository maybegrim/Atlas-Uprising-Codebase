// Atlas_Breach = Atlas_Breach or {}
// Atlas_Breach.Zones = Atlas_Breach.Zones or {}

// local SAVE_FILE = "atlas_breach/atlas_zones.json"

// local function compressAndSendZones(recipient)
//     local json = util.TableToJSON(Atlas_Breach.Zones)
//     local compressed = util.Compress(json)

//     if not compressed then
//         print("[Atlas_Breach::ZoneConfig] Compression failed!")
//         return
//     end

//     net.Start("Atlas_Breach::Zones")
//         net.WriteUInt(#compressed, 32)
//         net.WriteData(compressed, #compressed)
//     if recipient then
//         net.Send(recipient)
//     else
//         net.Broadcast()
//     end
// end

// function Atlas_Breach.saveZones()
//     local jsonData = util.TableToJSON(Atlas_Breach.Zones or {}, true)
//     if not jsonData then return end
//     file.Write(SAVE_FILE, jsonData)
//     Atlas_Breach.loadZones() -- Reload to ensure consistency
// end

// function Atlas_Breach.loadZones()
//     Atlas_Breach.Zones = {
//         ["HCZ"] = {},
//         ["LCZ"] = {},
//         ["EZ"] = {},
//         ["Garage"] = {},
//         ["Surface"] = {},
//         ["dblock"] = {}
//     }

//     if not file.Exists(SAVE_FILE, "DATA") then
//         compressAndSendZones()
//         return
//     end

//     local jsonData = file.Read(SAVE_FILE, "DATA")
//     if not jsonData then
//         compressAndSendZones()
//         return
//     end

//     local loadedTable = util.JSONToTable(jsonData)
//     if loadedTable and not (table.Count(loadedTable) == 0) then
//         Atlas_Breach.Zones = loadedTable
//         print("[Atlas_Breach::Zones] Zones successfully loaded.")
//     else
//         print("[Atlas_Breach::Zones] Failed to load zones from JSON.")
//     end
//     compressAndSendZones()
// end

// net.Receive("Atlas_Breach::Zones", function(len, ply)
//     local dataLen = net.ReadUInt(32)
//     local compressed = net.ReadData(dataLen)
//     if not ply:IsSuperAdmin() then print("Player is not super admin.") return end

//     if not compressed then
//         print("[Atlas_Breach::Zones] No compressed data received.")
//         return
//     end

//     local decompressed = util.Decompress(compressed)
//     if not decompressed then
//         print("[Atlas_Breach::Zones] Failed to decompress data.")
//         return
//     end

//     local tbl = util.JSONToTable(decompressed)
//     if not tbl then
//         print("[Atlas_Breach::Zones] Failed to parse JSON.")
//         return
//     end

//     Atlas_Breach.Zones = tbl
//     Atlas_Breach.saveZones()
//     print("[Atlas_Breach::Zones] Config saved by " .. ply:Nick())
// end)

// hook.Add("PlayerInitialSpawn", "AU_Breach::SyncZoneOnJoin", function(ply)
//     compressAndSendZones(ply)
// end)

// timer.Simple(3, function()
//     print("[Atlas_Breach::Zones] Loading Zones...")
//     Atlas_Breach.loadZones()
// end)
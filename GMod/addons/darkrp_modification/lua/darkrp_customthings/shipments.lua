--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]
DarkRP.createShipment("M1 Garand", {
    entity = "cw_m1garand",
    model = "models/khrcw2/doipack/w_m1garand.mdl",
    amount = 1,
    price = 2500,
    pricesep = 2500,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_TOWNDOCTOR,
    },
})

DarkRP.createShipment("HK-416 Soul", {
    entity = "cw_kk_hk416",
    model = "models/weapons/w_cwkk_hk416.mdl",
    amount = 1,
    price = 5500,
    pricesep = 5500,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("AK-SD", {
    entity = "cw_aksd",
    model = "models/cw2/weapons/w_rif_aksd.mdl",
    amount = 1,
    price = 4500,
    pricesep = 4500,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("VSS", {
    entity = "cw_vss",
    model = "models/cw2/rifles/w_vss.mdl",
    amount = 1,
    price = 2500,
    pricesep = 2500,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("MAC-11", {
    entity = "cw_mac11",
    model = "models/weapons/w_cst_mac11.mdl",
    amount = 1,
    price = 1500,
    pricesep = 1500,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("P226", {
    entity = "cw_ghosts_p226",
    model = "models/cw2/weapons/w_ghosts_p226.mdl",
    amount = 1,
    price = 500,
    pricesep = 500,
    noship = true,
    separate = true,
    category = "Pistols",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("Five-Seven", {
    entity = "cw_fiveseven",
    model = "models/weapons/w_pist_fiveseven.mdl",
    amount = 1,
    price = 500,
    pricesep = 500,
    noship = true,
    separate = true,
    category = "Pistols",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("P99", {
    entity = "cw_p99",
    model = "models/cw2/weapons/w_james_p99.mdl",
    amount = 1,
    price = 500,
    pricesep = 500,
    noship = true,
    separate = true,
    category = "Pistols",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("Beretta", {
    entity = "cw_sc92fs",
    model = "models/cw2/weapons/w_james_p99.mdl", // Couldn't find the Beretta world model in the Q menu, so I used the p99
    amount = 1,
    price = 500,
    pricesep = 500,
    noship = true,
    separate = true,
    category = "Pistols",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("Makarov", {
    entity = "cw_makarov",
    model = "models/cw2/pistols/w_makarov.mdl",
    amount = 1,
    price = 400,
    pricesep = 400,
    noship = true,
    separate = true,
    category = "Pistols",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("M3 Super 90", {
    entity = "cw_m3super90",
    model = "models/weapons/w_cstm_m3super90.mdl",
    amount = 1,
    price = 3500,
    pricesep = 3500,
    noship = true,
    separate = true,
    category = "Shotguns",
    allowed = {
        TEAM_GUNDLR,
        TEAM_STAFF,
        TEAM_TOWNDOCTOR,
        TEAM_CRIMINAL
    },
})

DarkRP.createShipment("M249", {
    entity = "cw_m249_official",
    model = "models/weapons/w_mach_m249para.mdl",
    amount = 1,
    price = 7500,
    pricesep = 7500,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_TOWNDOCTOR,
    },
})

DarkRP.createShipment("M1919", {
    entity = "cw_m1919a6",
    model = "models/khrcw2/doipack/w_m1919.mdl",
    amount = 1,
    price = 7750,
    pricesep = 7750,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_TOWNDOCTOR,
    },
})

DarkRP.createShipment("L115", {
    entity = "cw_l115",
    model = "models/cw2/weapons/w_ghosts_l115a3.mdl",
    amount = 1,
    price = 5750,
    pricesep = 5750,
    noship = true,
    separate = true,
    category = "Rifles",
    allowed = {
        TEAM_TOWNDOCTOR,
    },
})
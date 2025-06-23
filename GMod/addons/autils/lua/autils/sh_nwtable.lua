AddCSLuaFile()

local ent_meta = FindMetaTable("Entity")

function ent_meta:GetNWTable(index, default)
    local nw_tables = self.NWTables

    if not nw_tables then return default end

    return nw_tables[index] or default
end

if CLIENT then
    function ent_meta:SetNWTable(index, value)
        if not IsValid(self) or not index or not isstring(index) or not value or not istable(value) then
            print("Invalid")
            return
        end

        self.NWTables = self.NWTables or {}
        self.NWTables[index] = value
    end

    net.Receive("AUtils.SendNWTable", function ()
        local entity = net.ReadEntity()
        local index = net.ReadString()
        local table = net.ReadTable()

        entity:SetNWTable(index, table)
    end)

    net.Receive("AUtils.UpdateEntityNWTables", function ()
        local entity = net.ReadEntity()
        local table = net.ReadEntity()

        entity.NWTables = table
    end)
else
    util.AddNetworkString("AUtils.SendNWTable")
    util.AddNetworkString("AUtils.UpdateEntityNWTables")

    function ent_meta:SetNWTable(index, value)
        if not IsValid(self) or not index or not isstring(index) or not value or not istable(value) then
            print("Invalid")
            return
        end

        self.NWTables = self.NWTables or {}
        self.NWTables[index] = value

        net.Start("AUtils.SendNWTable")
            net.WriteEntity(self)
            net.WriteString(index)
            net.WriteTable(value)
        net.Broadcast()
    end

    hook.Add("AUtilClientNetworkReady", "AUtils.NWTableReady", function (ply)
        for _,v in ipairs(ents.GetAll()) do
            if v.NWTables then
                net.Start("AUtils.UpdateEntityNWTables")
                    net.WriteEntity(v)
                    net.WriteTable(v.NWTables)
                net.Send(ply)
            end
        end
    end)
end
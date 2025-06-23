AddCSLuaFile()

local meta = FindMetaTable("Player")

function meta:GetElixirInventory()
    return Elixir.GetInventory(self)
end

function meta:SetElixirInventory(inventory)
    Elixir.SetInventory(self, inventory)
end

function meta:UpdateElixirInventory()
    Elixir.UpdateInventory(self)
end

function meta:GiveElixirItem(id)
    print(id)
    Elixir.AddInventoryItem(self, Elixir.Item(id))
end

function meta:ClearElixirInventory()
    Elixir.ClearInventory(self)
end
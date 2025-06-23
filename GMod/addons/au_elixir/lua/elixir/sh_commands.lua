AddCSLuaFile()

if CLIENT then
    hook.Add("OnPlayerChat", "Elixirs.CommandDispatch", function (ply, text)
        if ply != LocalPlayer() then return end

        if text == "/elixir" then
            Elixir.OpenInventory()
            return true
        end
    end)
end
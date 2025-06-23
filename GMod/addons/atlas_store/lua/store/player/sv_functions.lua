---
-- Assigns a role to an in-game player by setting a Networked String.
-- The role information can be accessed both on the server and client.
-- @param ply The player entity to whom the role is to be assigned.
-- @param role The role string to be assigned.
---
function STORE.PLY.AssignRole(ply, role)
    ply:SetNWString("ATLAS.STORE.ROLE", role)
end

---
-- Removes role from an in-game player by clearing the Networked String.
-- @param ply The player entity from whom the role is to be removed.
---
function STORE.PLY.RemoveRole(ply)
    ply:SetNWString("ATLAS.STORE.ROLE", nil)
end


RESEARCH.PHARMA = RESEARCH.PHARMA or {}

function RESEARCH.PHARMA.GiveInvItem(ply, item)
    if not IsValid(ply) then return end
    if not item then return end

    local result, itemID = INVENTORY:AddItem(ply, item)

    if not result then return false end

    return true, itemID
end


ATLAS4000PLY = false
surface.CreateFont("4000_DIST_FONT", {
	font = "DebugFixedSmall",
	size = 24,
	weight = 500,
	antialias = true,
})
local panicmaterial = Material("materials/hypextech/049/pin.png")
local callColor = Color(255, 255, 255)
net.Receive("ATLAS.4000.GetLocation", function()
    for k,v in pairs(player.GetAll()) do
        if v:Team() == TEAM_SCP_4000 then
            ATLAS4000PLY = v
            break
        end
    end
    if ATLAS4000PLY then
        hook.Add("HUDPaint", "HYPEX.4000.UI", function()
            if not LocalPlayer():HasWeapon("eoti_werewolf_swep") then
                hook.Remove("HUDPaint", "HYPEX.4000.UI")
                return
            end
            if not ATLAS4000PLY then return end
            if not IsValid(ATLAS4000PLY) then
                ATLAS4000PLY = false
                return
            end
            local player = LocalPlayer()
            local myPos = player:GetPos()
            if (myPos:DistToSqr(ATLAS4000PLY:GetPos()) < 20000) then return end

            local callPos = ATLAS4000PLY:GetPos():ToScreen()
            surface.SetDrawColor(color_white)
            surface.SetMaterial(panicmaterial)
            surface.DrawTexturedRect(callPos.x-10, callPos.y, 20, 20)
            draw.DrawText("SCP-4000-W", "4000_DIST_FONT", callPos.x, callPos.y-25, callColor, TEXT_ALIGN_CENTER)
            draw.DrawText(string.sub(math.Round(myPos:Distance(ATLAS4000PLY:GetPos())), 1, -3) .."m", "4000_DIST_FONT", callPos.x, callPos.y+20, callColor, TEXT_ALIGN_CENTER)
        end)
    end
end)
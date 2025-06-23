ATLAS662.Pickedup = ATLAS662.Pickedup or false
ATLAS662.Ringed = ATLAS662.Ringed or false
ATLAS662.Ringer = ATLAS662.Ringer or false
ATLAS662.Pickup = ATLAS662.Pickup or false
ATLAS662.PickupTime = ATLAS662.PickupTime or false
ATLAS662.PickupStart = ATLAS662.PickupStart or false
net.Receive("ATLAS662.Pickup", function()
    ATLAS662.Pickedup = net.ReadBool()
end)
net.Receive("ATLAS662.Ringed", function()
    ATLAS662.Ringed = true
    ATLAS662.Ringer = net.ReadEntity()
    timer.Create("ATLAS662.BellRing", ATLAS662.RingExpire, 1, function() ATLAS662.Ringed = false ATLAS662.Ringer = false end)
end)
net.Receive("ATLAS662.Notify.Seen", function()
    chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "You cannot cloak until you're not seen.")
end)
net.Receive("ATLAS662.Notify.ExitNoclip", function()
    chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "Stop noclipping in order to collect item.")
end)
net.Receive("ATLAS662.Notify.ExitCloak", function()
    chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "Uncloak to collect the item.")
end)
net.Receive("ATLAS662.Pickup.Time", function()
    ATLAS662.PickupStart = net.ReadFloat()
    ATLAS662.PickupTime = net.ReadFloat()
end)
net.Receive("ATLAS662.Pickup.Notify", function()
    ATLAS662.Pickup = net.ReadVector()
    chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "Item has been marked for pickup.")
end)
net.Receive("ATLAS662.Pickup.Complete", function()
    ATLAS662.PickupStart = false
    ATLAS662.PickupTime = false
    ATLAS662.Pickup = false
    local elixir = net.ReadBool()
    local failed = net.ReadBool()
    if failed then
        chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "Pickup failed.")
        return
    end
    if elixir then
        chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "To drop this item type /elixir.")
    else
        chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "To drop this item type select the weapon and type /drop.")
    end
end)
net.Receive("ATLAS662.Notify.CloakNeeded", function()
    chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "You need to be cloaked in order to noclip.")
end)
surface.CreateFont( "ATLAS662.Font.Pickup", {
	font = "Raleway",
	extended = false,
	size = 24,
	weight = 500,
} )
local bell = Material( "materials/scps/662/notification.png" )
hook.Add("HUDPaint", "ATLAS662.Draw.Pickup", function()
    if not ATLAS662.Pickedup then return end
    local w,h = ScrW(),ScrH()
    surface.SetDrawColor(24,25,32,240)
    surface.DrawRect(w * 0.1, h * 0.1, w * 0.13, h * 0.1)
    surface.SetFont( "ATLAS662.Font.Pickup" )
    surface.SetTextColor( 255, 255, 255 )
    surface.SetTextPos( w * 0.11, h * 0.14 )
    surface.DrawText( "Press J to ring the bell" )
    surface.SetFont( "ATLAS662.Font.Pickup" )
    surface.SetTextColor( 255, 255, 255 )
    surface.SetTextPos( w * 0.11, h * 0.17 )
    surface.DrawText( "Press K to drop the bell" )
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( bell )
    surface.DrawTexturedRect( w * 0.16, h * 0.105, 32, 32 )
end)
hook.Add("HUDPaint", "ATLAS662.Draw.PickupTime", function()
    if not ATLAS662.PickupStart then return end
    local w,h = ScrW(),ScrH()
    local start_time = ATLAS662.PickupStart
    local end_time = ATLAS662.PickupTime
    local cur_time = CurTime()

    local progress = (cur_time - start_time) / (end_time - start_time)
    draw.RoundedBox(0, (ScrW() - 300) / 2, (ScrH() - 60) / 2, 300, 60, Color(23, 23, 27))
    draw.RoundedBox(0, (ScrW() - 300) / 2 + 7, (ScrH() - 60) / 2 + 7, Lerp(progress, 0, 286), 46, Color(26, 180, 113))
    
    draw.SimpleText( "PICKING UP...", "ATLAS662.Font.Pickup", ScrW() * 0.50, ScrH() * 0.50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end)
local pickup = Material( "materials/hypextech/662/pickup.png" )
surface.CreateFont("ATLAS662.Font.Ring", {
	font = "DebugFixedSmall",
	size = 24,
	weight = 500,
	antialias = true,
})
hook.Add("HUDPaint", "ATLAS662.Draw.Ring", function()
    if not ATLAS662.Ringed and ATLAS662.Ringer ~= NULL then return end
	local myPos = LocalPlayer():GetPos()

    if (myPos:DistToSqr(ATLAS662.Ringer:GetPos()) < 20000) then return end

    local callPos = ATLAS662.Ringer:GetPos():ToScreen()
    surface.SetDrawColor(color_white)
    surface.SetMaterial(bell)
    surface.DrawTexturedRect(callPos.x-10, callPos.y, 20, 20)
    draw.DrawText(string.sub(math.Round(myPos:Distance(ATLAS662.Ringer:GetPos())), 1, -3) .."m", "ATLAS662.Font.Ring", callPos.x, callPos.y+20, callColor, TEXT_ALIGN_CENTER)
end)
hook.Add("HUDPaint", "ATLAS662.Draw.Pickup.Location", function()
    if not ATLAS662.Pickup then return end
	local myPos = LocalPlayer():GetPos()

    if (myPos:DistToSqr(ATLAS662.Pickup) < 20000) then return end

    local callPos = ATLAS662.Pickup:ToScreen()
    surface.SetDrawColor(color_white)
    surface.SetMaterial(pickup)
    surface.DrawTexturedRect(callPos.x-20, callPos.y-20, 40, 40)
    draw.DrawText(string.sub(math.Round(myPos:Distance(ATLAS662.Pickup)), 1, -3) .."m", "ATLAS662.Font.Ring", callPos.x, callPos.y+20, callColor, TEXT_ALIGN_CENTER)
end)
local keyCooldown = 0
hook.Add("Think", "ATLAS662.KeyBinds", function()
    if not ATLAS662.Pickedup then return end
    if keyCooldown > CurTime() then return end
    if LocalPlayer():IsTyping() then return end
    if input.IsKeyDown(ATLAS662.RingKey) then
        keyCooldown = CurTime() + 1
        net.Start("ATLAS662.Ring")
        net.SendToServer()
    end
    if input.IsKeyDown(ATLAS662.DropKey) then
        keyCooldown = CurTime() + 1
        net.Start("ATLAS662.Drop")
        net.SendToServer()
    end
end)

ATLAS662.SelectedItem = false
function ATLAS662.UI()
    ATLAS662.Frame = vgui.Create( "DFrame" )
    ATLAS662.Frame:SetTitle( "" )
    ATLAS662.Frame:SetSize( ScrW() * 0.15,ScrH() * 0.2 )
    ATLAS662.Frame:Center()
    ATLAS662.Frame:MakePopup()
    ATLAS662.Frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 21, 20, 26) )
    end
    local w,h = ATLAS662.Frame:GetWide(), ATLAS662.Frame:GetTall()
    local spawnBtn = vgui.Create("DButton", ATLAS662.Frame)
    spawnBtn:SetText( "SPAWN" )
    spawnBtn:SetTextColor( Color(255,255,255) )
    spawnBtn:SetPos( w * .33, h * .82 )
    spawnBtn:SetSize( 100, 30 )
    spawnBtn.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
    end
    spawnBtn.DoClick = function()
        if not ATLAS662.SelectedItem then
            chat.AddText(Color(255,56,56), "[SCP-662] ", Color(255,255,255), "You need to select an option to spawn.")
            return
        end
        net.Start("ATLAS662.SpawnItem")
        net.WriteString(ATLAS662.SelectedItem)
        net.SendToServer()
        ATLAS662.SelectedItem = false
        ATLAS662.Frame:Close()
    end
    local swepList = vgui.Create( "DListView", ATLAS662.Frame )
    swepList:SetSize( w * .8, h * .7 )
    swepList:SetPos( w * .1, h * .12 )
    swepList:SetMultiSelect( false )
    swepList:AddColumn( "Name" )
    swepList:AddColumn( "Category" )

    for k,v in pairs(ATLAS662.Items) do
        swepList:AddLine( v.name, v.category )
    end

    swepList.OnRowSelected = function( lst, index, pnl )
        ATLAS662.SelectedItem = pnl:GetColumnText( 1 )
    end
end
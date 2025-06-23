if CLIENT then 

local drawDeathEffects = false
local deathsystem_autorespawn = false
local deathsystem_instantrespawn = true
local drawString = "You died!"

--Create font
surface.CreateFont("DeathFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 100,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

--Draw Color modify settings
local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.04,
	["$pp_colour_contrast"] = 0.5,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

--Hide the Hud Damage effect when dead(the red screen)
local function hideOtherDeathEffects(name)
    if (name == "CHudDamageIndicator" and (not LocalPlayer():Alive())) then
	    return false
	end
end
hook.Add("HUDShouldDraw", "hideOtherDeathEffects", hideOtherDeathEffects)

--Change if you want to draw death effects
net.Receive("enableDrawBlurEffect", function ()
    drawDeathEffects = net.ReadType()
	deathsystem_autorespawn = net.ReadType()
	deathsystem_instantrespawn = net.ReadType()
	drawString = net.ReadString()
end)

net.Receive("disableDrawBlurEffect", function ()
    drawDeathEffects = net.ReadType()
end)

--Render the death effects
local function renderBlurEffect()
    if drawDeathEffects == true then
		DrawColorModify(tab)
	else
	  --DrawMotionBlur(0.4, 0.8, 0.01)
	end
end
hook.Add("RenderScreenspaceEffects", "renderBlurEffect", renderBlurEffect)

--Draw for example the text
local function drawPlayerDeathThink()
    if drawDeathEffects == true then
	    --print(GetConVar("sv_deathscreen_text"):GetString())
	    local ply = LocalPlayer()
		    draw.DrawText(drawString, "DeathFont", ScrW() / 2, 50, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
		--draw.DrawText("You were killed by " .. ply:GetNWString("deathKiller"), "DeathFont", ScrW() / 2, ScrH() / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
		if (deathsystem_instantrespawn == false) then
		    if ply:GetNWFloat("deathTimeLeft") < 0 then
		    if (deathsystem_autorespawn == false) then
		        draw.DrawText("Click to respawn.", "DermaLarge", ScrW() / 2, ScrH() - 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			else
			    draw.DrawText("Respawning...", "DermaLarge", ScrW() / 2, ScrH() / 2 + 100 - 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)		
			end
		else
		    draw.DrawText("You can respawn in " .. tostring(math.floor(ply:GetNWFloat("deathTimeLeft"))) .. " seconds.", "DermaLarge", ScrW() / 2, ScrH() / 2 + 100 - 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
		else
		    if (deathsystem_autorespawn == false) then
		        draw.DrawText("Click to respawn.", "DermaLarge", ScrW() / 2, ScrH() - 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end
		end
	end
end
hook.Add("HUDPaint", "drawPlayerDeathThink", drawPlayerDeathThink)

--Calculate the view
--[[local function MyCalcView( ply, pos, angles, fov )
	local ragdoll = ply:GetRagdollEntity();
       if( !ragdoll || ragdoll == NULL || !ragdoll:IsValid() ) then return; end
       
        // find the eyes
        local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) );
        
         // setup our view
         local view = {
             origin = eyes.Pos,
             angles = eyes.Ang,
			 fov = 90, 
         };
        
          //
         return view;
end
hook.Add( "CalcView", "MyCalcView", MyCalcView )]]--

end

if SERVER then Msg("cl_deathsystem.lua initialized!\n") end
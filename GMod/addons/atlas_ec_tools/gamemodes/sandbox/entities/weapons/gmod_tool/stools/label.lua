
TOOL.Category		= "Render"
TOOL.Name			= "#tool.label.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "range" ]			= "300"
TOOL.ClientConVar[ "mustlookat" ]			= "1"
TOOL.ClientConVar[ "text" ]		= "Label Text"

if (CLIENT) then
	language.Add("tool.label.name", "Label Tool")
	language.Add("tool.label.desc", "Apply label to entities.")
	language.Add("tool.label.0", "Left Click to apply.  Right click to clear.")
end

CreateConVar("sbox_maxlabelchars", 60, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Maximum number of characters allowed in a label.")
CreateConVar("sbox_maxlabelrange", 1000, {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Maximum visible label range.")

local function getMaxRange()
	return GetConVar("sbox_maxlabelrange"):GetInt()
end

local function getMaxChars()
	return GetConVar("sbox_maxlabelchars"):GetInt()
end

function TOOL:RightClick(trace)

	if (IsValid(trace.Entity) && trace.Entity:IsPlayer()) then return false end
	if (!IsValid(trace.Entity)) then return false end
	if (!util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone)) then return false end
	if (CLIENT) then return true end

	trace.Entity:SetNWString("LabelText", "")

	return true
end

function TOOL:LeftClick(trace)

	if (self:GetClientInfo("text") == "") then self:GetOwner():ChatPrint("Label text can not be left blank.  Use right click to remove a label.") return end

	if (IsValid(trace.Entity) && trace.Entity:IsPlayer()) then return false end
	if (!IsValid(trace.Entity)) then return false end
	if (!util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone)) then return false end
	if (CLIENT) then return true end
	
	local range	= math.Clamp(tonumber(self:GetClientInfo("range")), 1, getMaxRange())
	local mustlookat = self:GetClientNumber("mustlookat")
	local text = string.sub(self:GetClientInfo("text"), 1, getMaxChars())

	trace.Entity:SetNWInt("LabelRange", range)
	trace.Entity:SetNWBool("LabelMustLookAt", (mustlookat == 1))
	trace.Entity:SetNWString("LabelText", text)

	return true

end

if (CLIENT) then

	local TipColor = Color( 250, 250, 200, 255 )

	hook.Add("HUDPaint", "LabelTool_DrawLabels", function()

		for k, v in pairs (ents.GetAll()) do
			local text = v:GetNWString("LabelText")
			if (text != "") then

				local dist = v:GetPos():Distance(LocalPlayer():GetPos())
				local lookingAt = (LocalPlayer():GetEyeTrace().Entity == v)
				local range = tonumber(v:GetNWInt("LabelRange"))
				local mustLookAt = v:GetNWInt("LabelMustLookAt")

				if (mustLookAt && !lookingAt) then continue end
				if (dist > range) then continue end

				local pos = v:GetPos():ToScreen()

				local black = Color( 0, 0, 0, 255 )
				local tipcol = Color( TipColor.r, TipColor.g, TipColor.b, 255 )

				local x = 0
				local y = 0
				local padding = 10
				local offset = 50

				surface.SetFont( "GModWorldtip" )
				local w, h = surface.GetTextSize( text )

				x = pos.x - w 
				y = pos.y - h 

				x = x - offset
				y = y - offset

				draw.RoundedBox( 8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, black )


				local verts = {}
				verts[1] = { x=x+w/1.5-2, y=y+h+2 }
				verts[2] = { x=x+w+2, y=y+h/2-1 }
				verts[3] = { x=pos.x-offset/2+2, y=pos.y-offset/2+2 }

				draw.NoTexture()
				surface.SetDrawColor( 0, 0, 0, tipcol.a )
				surface.DrawPoly( verts )


				draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tipcol )

				local verts = {}
				verts[1] = { x=x+w/1.5, y=y+h }
				verts[2] = { x=x+w, y=y+h/2 }
				verts[3] = { x=pos.x-offset/2, y=pos.y-offset/2 }

				draw.NoTexture()
				surface.SetDrawColor( tipcol.r, tipcol.g, tipcol.b, tipcol.a )
				surface.DrawPoly( verts )


				draw.DrawText( text, "GModWorldtip", x + w/2, y, black, TEXT_ALIGN_CENTER )
			end
		end

	end)

end

function TOOL.BuildCPanel(CPanel)

	-- HEADER
	CPanel:AddControl("Header", { Text = "#tool.label.name", Description	= "#tool.label.desc" } )
									
	local Options = { Default = { label_text = "Label Text", label_range = 300, label_mustlookat = 1 } }
	local CVars = { "label_range", "label_mustlookat", "label_text" }
	
	CPanel:AddControl("ComboBox", { Label = "#tool.presets",
									 MenuButton = 1,
									 Folder = "label",
									 Options = Options,
									 CVars = CVars })
									 
	CPanel:AddControl("TextBox", { Label = "Text",
									 MaxLenth = "1000",
									 Command = "label_text" })

	CPanel:AddControl( "Slider", { Label = "Visible Range",	Type = "Int", Command = "label_range", Min = "0", 	Max = getMaxRange() }  )

	CPanel:AddControl("CheckBox",	{ Label = "Must Look At", Command = "label_mustlookat" } )
									
end

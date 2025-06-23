include("shared.lua")
local samelife = 0
local person = LocalPlayer

function ENT:Draw()
	self:SetAnimation(0)
	self:DrawModel()
	hook.Add("PostDrawOpaqueRenderables", "DrawOverhead", function()
        	local pos = self:GetPos() + Vector(0, 0, 80) 
		local ang = self:GetAngles()
    		ang:RotateAroundAxis(ang:Forward(), 90) 
    		ang:RotateAroundAxis(ang:Right(), 270) 
    		cam.Start3D2D(pos, ang, 0.3)
       			draw.SimpleText("SCP Breaching Reward", "CloseCaption_Bold", 0, 0, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    		cam.End3D2D()
	end)
end
hook.Add("EntityRemoved", "OnRemoval", function()
	hook.Remove("PostDrawOpaqueRenderables", "DrawOverhead")
end)

function MoneyScript()
	local blue = LocalPlayer()
	if samelife == 0 then
		net.Start("sadfish")
		net.SendToServer()
		samelife = 1
		print("Cheese function")
		blue:ChatPrint("You receieved $200. You cannot use this again until you die.")
	else
		blue:ChatPrint("You can't use this reward until you die!")
	end
end

net.Receive("funfish", function()
	MoneyScript()
end)

net.Receive("deadfish", function()
	samelife = 0
end)

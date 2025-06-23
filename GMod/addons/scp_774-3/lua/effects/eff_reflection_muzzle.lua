function EFFECT:Init(data)
	local ent = data:GetEntity()
	local att = data:GetAttachment()

	self.Mat2 = Material("effects/strider_muzzle")

	self.StartPos = Vector(0, 0, 0)

	self.Timer1 = 0

	self.Decay = 0.16
	self.Timer2 = CurTime() + self.Decay

	if(!IsValid(ent)) then return end

	if(ent:IsWeapon() && ent:IsCarriedByLocalPlayer()) then
		local ply = ent:GetOwner()

		if(!ply:ShouldDrawLocalPlayer()) then
			local vm = ply:GetViewModel()
			
			if(IsValid(vm)) then
				ent = vm
			end
		end
	end

	self.Ent = ent
	self.Att = att

	self.Size = 64 * data:GetScale()
	self.StartPos = self.Ent:GetAttachment(self.Att).Pos

	self:SetRenderBoundsWS(self.StartPos + Vector() * self.Size, self.StartPos - Vector() * self.Size)
end

function EFFECT:Render()
	if(!IsValid(self.Ent)) then return end

	local size = Lerp((self.Timer2 - CurTime()) / self.Decay, 0, self.Size)

	self.StartPos = self.Ent:GetAttachment(self.Att).Pos

	render.SetMaterial(self.Mat2)
	render.DrawSprite(self.StartPos, size, size)
end

function EFFECT:Think()
	if(self.Timer2 <= CurTime()) then
		return false
	end

	return true
end
function EFFECT:Init(data)
	local ent = data:GetEntity()
	local att = data:GetAttachment()

	self.Mat = Material("sprites/bluelaser1")
	self.Mat2 = Material("sprites/light_glow02_add")
	self.Mat3 = Material("effects/combinemuzzle2")

	self.StartPos = data:GetOrigin()
	self.EndPos = data:GetStart()

	self.Timer1 = 0

	if(ent:IsWeapon() && ent:IsCarriedByLocalPlayer()) then
		local ply = ent:GetOwner()

		if(!ply:ShouldDrawLocalPlayer()) then
			local vm = ply:GetViewModel()
			
			if(IsValid(vm)) then
				ent = vm
			end
		end

		self.StartPos = ent:GetAttachment(att).Pos
	end

	self.X = 1 * data:GetScale()
	self.Size = 32 * data:GetScale()
	self.Timer1 = CurTime() + self.X

	self:SetRenderBoundsWS(self.StartPos, self.EndPos)

	local emitter = ParticleEmitter(data:GetOrigin(), false)

	self.Normal = data:GetNormal()

	for i = 1, math.random(10,40) do
		local part = emitter:Add("sprites/light_glow02_add", self.EndPos)
		part:SetAngleVelocity(AngleRand(8, 15) * math.Rand(-1, 1))
		part:SetVelocity(data:GetNormal() * 800 + VectorRand() * 200)
		part:SetDieTime(math.Rand(0.2, 0.4))
		part:SetMaterial( self.Mat2 )

		part:SetStartSize(8)
		part:SetEndSize(0)

		part:SetColor(0, 128, 255)

		part:SetAirResistance(10)
		part:SetCollide(false)

		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
	end

	local x = math.random(10,40)
	for i = 1, x do
		local y = LerpVector(i / x, self.StartPos, self.EndPos)
		local part = emitter:Add("sprites/light_glow02_add", y)
		part:SetAngleVelocity(AngleRand(8, 15) * math.Rand(-1, 1))
		part:SetVelocity(VectorRand() * 100)
		part:SetDieTime(math.Rand(0.2, 0.5))
		part:SetMaterial( self.Mat2 )

		part:SetStartSize(8)
		part:SetEndSize(0)

		part:SetColor(0, 128, 255)

		part:SetAirResistance(10)
		part:SetCollide(false)

		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
	end

	emitter:Finish()
end

function EFFECT:Render()
	local t = (self.Timer1 - CurTime()) / self.X
	local x = Lerp(t, 0, 1)
	render.SetMaterial(self.Mat)
	render.DrawBeam(self.StartPos, self.EndPos, x * self.Size, 0, 0)

	x = x * 16
	render.SetMaterial(self.Mat3)
	render.DrawQuadEasy(self.EndPos + self.Normal * 1, self.Normal, x, x)
end

function EFFECT:Think()
	if(self.Timer1 <= CurTime()) then
		return false
	end

	return true
end
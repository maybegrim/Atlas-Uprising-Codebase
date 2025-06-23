
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Mining Refinery"
ENT.Author = "SweptThrone"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "STMining"
AddCSLuaFile()
if SERVER then

	function ENT:Initialize()
		self:SetModel("models/props_canal/winch02.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
		self:SetUseType(SIMPLE_USE)
		self.HeldOres = 0
		self.Refining = false
		self.Ready = false
		
		local child = ents.Create( "prop_dynamic" )
		child:SetModel( "models/props_canal/mattpipe.mdl" )
		local cpos = self:GetPos()
		local cang = self:GetAngles()
		child:SetPos(cpos + (cang:Right() * 20) + (cang:Up() * 55))
		child:SetAngles( Angle(self:GetAngles().p, self:GetAngles().y + 90, self:GetAngles().r) )
		child:SetParent(self)
		self:DeleteOnRemove( child )
		child:Spawn()
		
		self:SetAngles( Angle(self:GetAngles().p, self:GetAngles().y + 180, self:GetAngles().r) )
		self:SetColor( Color( 255, 255, 255 ) )
		
		sound.Add( {
			name = "refinery_loop",
			sound = "ambient/machines/engine4.wav"
		} )
	end
	
	function ENT:Use( act, ply )
		if !self.Refining and !self.Ready then
			if ply:GetNWInt( "HeldOres", 0 ) == 0 then
				if DarkRP then
					DarkRP.notify( ply, 1, 5, "You don't have any ores to refine!" )
				else
					ply:ChatPrint( "You don't have any ores to refine!" )
				end
			else
				self:SetColor( Color( 255, 0, 0 ) )
				self.HeldOres = math.min( ply:GetNWInt( "HeldOres" ), 10 )
				ply:SetNWInt( "HeldOres", ply:GetNWInt( "HeldOres" ) - math.min( ply:GetNWInt( "HeldOres" ), 10 ) )
				if DarkRP then
					DarkRP.notify( ply, 0, 5, "You have inserted " .. self.HeldOres .. " ores into the refinery." )
				else
					ply:ChatPrint( "You have inserted " .. self.HeldOres .. " ores into the refinery." )
				end
				self.Refining = true
				self:EmitSound( "physics/concrete/rock_impact_hard" .. math.random(1,6) .. ".wav" )
				self:EmitSound( "refinery_loop" )
				timer.Create( "refinery" .. self:EntIndex(), self.HeldOres * 1, 1, function()
					if !IsValid( self ) then return end
					self:StopSound( "refinery_loop" )
					self:EmitSound( "ambient/machines/sputter1.wav" )
					self.Refining = false
					self.Ready = true
					self:SetColor( Color( 0, 255, 0 ) )
				end )
			end
		elseif !self.Refining and self.Ready then
		
			local plat, rhod, gold, diam = 0, 0, 0, 0
			for int=1,self.HeldOres do
				local rand = math.random( 1, 100 )
				if rand <= 40 then
					plat = plat + 1
				elseif rand <= 70 then
					rhod = rhod + 1
				elseif rand <= 99 then
					gold = gold + 1
				elseif rand == 100 then
					diam = diam + 1
				end
			end
			ply:SetNWInt( "HeldDiam", ply:GetNWInt( "HeldDiam" ) + diam )
			ply:SetNWInt( "HeldGold", ply:GetNWInt( "HeldGold" ) + gold )
			ply:SetNWInt( "HeldRhod", ply:GetNWInt( "HeldRhod" ) + rhod )
			ply:SetNWInt( "HeldPlat", ply:GetNWInt( "HeldPlat" ) + plat )
			if DarkRP then
				DarkRP.notify( ply, 0, 5, "Picked up " .. plat .. " platinum, " .. rhod .. " rhodium, " .. gold .. " gold, and " .. diam .. " diamond." )
			else
				ply:ChatPrint( "Picked up " .. plat .. " platinum, " .. rhod .. " rhodium, " .. gold .. " gold, and " .. diam .. " diamond." )
			end
			self.HeldOres = 0
			self.Ready = false
			self:SetColor( Color( 255, 255, 255 ) )
			ply:EmitSound( "items/itempickup.wav" )
		else
			if DarkRP then
				DarkRP.notify( ply, 1, 5, "This refinery is already refining ores!" )
			else
				ply:ChatPrint( "This refinery is already refining ores!" )
			end
		end
	end

	function ENT:OnRemove()
		self:StopSound( "refinery_loop" )
	end

end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
		
	end
	
end
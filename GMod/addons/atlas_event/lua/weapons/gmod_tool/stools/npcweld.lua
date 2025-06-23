
TOOL.Category = "Constraints"
TOOL.Name = "NPC Welder"
TOOL.FreeMode = false

if CLIENT then
	TOOL.Information = {
		--{ name = "info", stage = 0},
		{ name = "left", stage = 0 },
		{ name = "left_1", stage = 1, op = 2 },
		{ name = "right", stage = 0 },
		{ name = "reload", stage = 0 },
	}
	
	language.Add( "tool.npcweld.name", "NPC Welder" )
	language.Add( "tool.npcweld.desc", "Parent props to NPCs!" )
	--language.Add( "tool.npcweld.0", "* Ackchyually doesn't actually weld but sets parent instead" )  -- I added the weld feature for it to work on dupes
	language.Add( "tool.npcweld.left", "Select parent" )
	language.Add( "tool.npcweld.left_1", "Select child" )
	language.Add( "tool.npcweld.right", "Clear child's parent" )
	language.Add( "tool.npcweld.reload", "Allow parents to not be NPCs" )
end

function TOOL:LeftClick( trace )
	
	if ( self:GetOperation() == 1 ) then return false end
	--if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if not IsValid( trace.Entity ) then return false end
	if trace.Entity:IsPlayer() then return end
	
	-- If there's no physics object then we can't constraint it!
	--if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	if iNum == 0 and (not self.FreeMode) and (not trace.Entity:IsNPC()) then
		self:GetOwner():SendLua("notification.AddLegacy(\"Parent is not an NPC!\", NOTIFY_ERROR, 8); surface.PlaySound( \"buttons/button10.wav\" )")
		return false
	elseif iNum == 1 and (not self.FreeMode) and trace.Entity:IsNPC() then
		self:GetOwner():SendLua("notification.AddLegacy(\"Child is not a prop!\", NOTIFY_ERROR, 8); surface.PlaySound( \"buttons/button10.wav\" )")
		return false
	end
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( CLIENT ) then
		
		if ( iNum > 0 ) then self:ClearObjects() end
		return true
		
	end
	
	self:SetOperation( 2 )
	
	if ( iNum == 0 ) then
	
	self:SetStage( 1 )
	return true
	
	end
	
	if ( iNum == 1 ) then
		local Ent1, Ent2 = self:GetEnt( 1 ), self:GetEnt( 2 )
		Ent2:SetParent(Ent1)
		constraint.Weld(Ent1, Ent2, 0, 0, 0, true, false)
		Ent1.PostEntityCopy = function()
			--print("Store modifier")
			duplicator.StoreEntityModifier(Ent1, "freefs_npcweld", {})
		end
		
		-- Clear the objects so we're ready to go again
		self:ClearObjects()
	end
	return true
end

duplicator.RegisterEntityModifier("freefs_npcweld",  function(player, entity, data)
		--print("	trying!!!")
		timer.Simple(0.4, function() -- Mini delay as constraint children are not created yet
			for k, weld in ipairs(constraint.GetTable(entity)) do
				--print(table.ToString(weld))
				if weld.Ent1 != entity then continue end -- Filter out incorrect welds
				weld.Ent2:SetParent(entity)
				--print("Setparent done")
		end
	end )
end)
	
function TOOL:RightClick( trace )
	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	self:ClearObjects()
	trace.Entity:SetParent(nil)
	timer.Simple(0.05, function() if not trace.Entity:GetPhysicsObject():IsValid() then return end trace.Entity:GetPhysicsObject():SetVelocity(Vector( 0, 0, 0)) end ) -- Sometimes unparenting them makes them go wild
	return constraint.RemoveConstraints( trace.Entity, "Weld" )
end

function TOOL:Think()
	
	if ( self:NumObjects() < 1 ) then return end
	
	if ( self:GetOperation() == 1 ) then
		
		if ( SERVER && !IsValid( self:GetEnt( 1 ) ) ) then
			
			self:ClearObjects()
			return
			
		end
		
	end
	
end

function TOOL:Reload( trace )
	if CLIENT then return false end
	self.FreeMode = not self.FreeMode
	self:GetOwner():SendLua("notification.AddLegacy(\"Unrestricted mode: "..tostring(self.FreeMode).."\", NOTIFY_GENERIC, 8); surface.PlaySound( \"".. "ambient/water/drip" .. math.random(1, 4) .. ".wav" .."\" )")
	return false
end

function TOOL:FreezeMovement()
	
	return self:GetOperation() == 1 && self:GetStage() == 2
	
end

function TOOL:Holster()
	
	self:ClearObjects()
	
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "Allows you parent objects to NPCs.\n\nNPC not recognized (f.e. DRGBase)?\nToggle unrestricted mode by hitting R!\n(Unrestricted mode allows breaking the rule of parent prop to NPC only, I don't take warranty for your shenanigans!)" } )

end
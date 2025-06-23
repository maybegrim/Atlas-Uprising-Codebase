include("shared.lua")
local tab = {
	["$pp_colour_addr"] = -0.5,
	["$pp_colour_addg"] = -0.5,
	["$pp_colour_addb"] = -0.5,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0.2,
	["$pp_colour_mulb"] = 0.2
}
net.Receive('PlayerShooting', function()
entity = net.ReadEntity()
if entity.IsAttacker == true then return end
entity.IsAttacker = true
timer.Create('RemoveAttacker', 5, 1, function()
entity.IsAttacker = false
end)
end)

function SWEP:Think()
        hook.Add("Think", "SCP939NoDraw", function()
        local wep = LocalPlayer():GetActiveWeapon()
        if !IsValid( wep ) || wep:GetClass() != 'weapon_scp939' then hook.Remove("Think", "SCP939NoDraw") end
            hook.Add("RenderScreenspaceEffects", "PostProcess939", function()
            local wep = LocalPlayer():GetActiveWeapon()
            if !IsValid( wep ) || wep:GetClass() != 'weapon_scp939' then
                for k, v in pairs(player.GetAll()) do
                v:SetNoDraw(false)
                v:SetMaterial("") 
                if v:Alive() && IsValid(v:GetActiveWeapon()) then
                    v:GetActiveWeapon():SetNoDraw(false)
                end
            end
            hook.Remove("RenderScreenspaceEffects", "PostProcess939")
            else
            DrawColorModify( tab )
            DrawSobel( 0.5 )
            end
            end)
            for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 2500)) do
                if v:IsPlayer() && v:IsValid() && LocalPlayer():Alive() && v:Alive() && v != LocalPlayer() then
                    if v.IsAttacker == false || v.IsAttacker == nil then
                        if v:GetVelocity():Length() == 0 or v:Crouching() then
                                v:SetNoDraw(true)
                                if v:Alive() && IsValid(v:GetActiveWeapon()) then
                                    v:GetActiveWeapon():SetNoDraw(true)
                                end
                        end
                    end
                        if v:IsPlayer() && v != LocalPlayer() then
                        if v:GetVelocity():Length() > 0 && !v:Crouching() || v:IsSpeaking() || v.IsAttacker == true || v:GetNWBool("BeepingCollarBeep", false) then
                                v:SetNoDraw(false)
                                local weapon = v:GetActiveWeapon()
                                weapon:SetNoDraw(false)
                                v:SetMaterial('vision/living')
                                end
                            end
                end
            end
        end)
    end

function scp1048_fixme(ply)
  if ply:IsValid() == false then
    print("You cannot run this command through the console.")
    return
  end
  if ply:GetActiveWeapon():GetClass() == "weapon_scp_1048a" then return end
  ply:SetViewOffset(Vector(0,0,60))
end
concommand.Add("scp_fixme", scp1048_fixme, nil, "Fix the viewmodel if it doesn't get holstered correctly (for breach mainly)", FCVAR_CLIENTCMD_CAN_EXECUTE )

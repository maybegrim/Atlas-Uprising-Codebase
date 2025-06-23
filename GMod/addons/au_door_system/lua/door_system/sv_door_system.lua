local function SetupDoorSystem()
    for _,entity in ipairs(ents.GetAll()) do
        if entity.DoorSystemSetup then continue end

        if string.find(entity:GetClass(), "door") then
            entity.DoorSystemSetup = true

            local max_door_health = AU.DoorSystem.GetMaxDoorHealth(entity)

            if max_door_health > 0 then
                entity.DoorHealth = max_door_health
            end

            entity.BreakDoor = function (entity, skip_sound)
                entity.DoorBroken = true
                
                if not skip_sound then
                    local break_sound = AU.DoorSystem.GetDoorBreakSound(entity)
                    if break_sound ~= "" then
                        entity:EmitSound(break_sound)
                    end
                end

                entity:Fire("Open")
            end

            entity.RepairDoor = function (entity, skip_sound)
                entity.DoorBroken = false

                local max_door_health = AU.DoorSystem.GetMaxDoorHealth(entity)

                if max_door_health > 0 then
                    entity.DoorHealth = max_door_health
                end

                if not skip_sound then
                    local repair_sound = AU.DoorSystem.GetDoorRepairSound(entity)
                    if repair_sound ~= "" then
                        entity:EmitSound(repair_sound)
                    end
                end
                
                entity:Fire("Close")
            end
        elseif entity:GetClass() == "func_button" then
            local surrounding_entities = ents.FindInSphere(entity:GetPos(), 10)
            local door_entities = {}

            for _,v_ent in pairs(surrounding_entities) do
                if v_ent:GetClass() == "prop_dynamic" and v_ent:GetModel() == "models/foundation/doors/lcz_door.mdl" then
                    v_ent.DoorSystemSetup = true
                    v_ent.ButtonMaster = entity

                    local max_door_health = AU.DoorSystem.GetMaxDoorHealth(v_ent)

                    if max_door_health > 0 then
                        v_ent.DoorHealth = max_door_health
                    end

                    v_ent.BreakDoor = function (self_entity, skip_sound, control)
                        self_entity.DoorBroken = true
                        
                        if not control then
                            for _,v in pairs(door_entities) do
                                if v ~= v_ent then
                                    v:BreakDoor(true, true)
                                end
                            end
                        end

                        if not skip_sound then
                            local break_sound = AU.DoorSystem.GetDoorBreakSound(self_entity)
                            if break_sound ~= "" then
                                self_entity:EmitSound(break_sound)
                            end
                        end
        
                        entity:Fire("use")
                    end

                    v_ent.RepairDoor = function (self_entity, skip_sound, control)
                        v_ent.DoorBroken = false

                        if not control then
                            for _,v in pairs(door_entities) do
                                if v ~= v_ent then
                                    v:RepairDoor(true, true)
                                end
                            end
                        end

                        local max_door_health = AU.DoorSystem.GetMaxDoorHealth(self_entity)

                        if max_door_health > 0 then
                            self_entity.DoorHealth = max_door_health
                        end

                        if not skip_sound then
                            local repair_sound = AU.DoorSystem.GetDoorRepairSound(self_entity)
                            if repair_sound ~= "" then
                                self_entity:EmitSound(repair_sound)
                            end
                        end
                        
                        entity:Fire("use")
                    end

                    table.insert(door_entities, v_ent)
                end
            end

            if #door_entities == 0 then continue end

            entity.DoorController = true
            entity.DoorEntities = door_entities
        end
    end
end

hook.Add("InitPostEntity", "AU.DoorSystem.Initialization", SetupDoorSystem)
hook.Add("PostCleanupMap", "AU.DoorSystem.Initialization", SetupDoorSystem)

hook.Add("PlayerUse", "AU.DoorSystem.DoorCheck", function (ply, entity)
    if entity.DoorSystemSetup and entity.DoorBroken then
        return false
    elseif entity.DoorController then
        if entity.DoorEntities[1].DoorBroken then
            return false
        end
    end
end)

hook.Add("PostEntityTakeDamage", "AU.DoorSystem.DoorDamage", function (entity, damage_info, took)
    if not entity.DoorSystemSetup then
        return
    end

    if entity.DoorHealth <= 0 then
        return
    end

    entity.DoorHealth = entity.DoorHealth - damage_info:GetDamage()

    if entity.DoorHealth <= 0 then
        entity.DoorHealth = 0
        
        entity:BreakDoor()
    end
end)
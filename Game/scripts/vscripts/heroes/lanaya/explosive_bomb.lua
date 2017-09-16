function bomb_throw_start(event)
	local caster = event.caster
	local ability = event.ability
    local target = event.target_points[1]
    Filters:CastSkillArguments(2, caster)
    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
    bomb.phase = 1
    bomb.stun_duration = event.stun_duration
    bomb.colorPhase = 0
    bomb.fv = fv
    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.type = "explosive"
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = event.damage
    local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "trapper")
    bomb.damage = bomb.damage + 0.0004*(caster:GetIntellect()+caster:GetStrength()+caster:GetAgility())/10*d_b_level*bomb.damage
    bomb.detonate = true
    if ability.total_bombs == nil then
        ability.total_bombs = 0
        ability.bombs = {}
    end
    ability.total_bombs = ability.total_bombs + 1
    table.insert(ability.bombs, bomb)
    DeepPrintTable(ability.bombs)
    if caster:HasModifier("modifier_trapper_glyph_6_1") then
        bomb.detonate = false
        if ability.total_bombs > 5 then
            bomb_explode(ability.bombs[1])
            Timers:CreateTimer(1.5, function()
                ability.bombs = reindexBombs(ability)
            end)
        end
    end

    bomb.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "trapper")
    bomb.c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "trapper")
    if bomb.detonate then
        Timers:CreateTimer(0.1, function()
         StartSoundEvent("Trapper.BombTicking", bomb)
        end)
    end
    EmitSoundOn("Trapper.BombThrow", caster)
    bomb_start(bomb, ability, target)


end

function detonateBombs(caster)
    local bombAbility = caster:FindAbilityByName("explosive_bomb")
    if #bombAbility.bombs > 0 then
        for i = 1, #bombAbility.bombs, 1 do
            bomb_explode(bombAbility.bombs[i])
        end
        Timers:CreateTimer(1.5, function()
            bombAbility.bombs = reindexBombs(bombAbility)
        end)
    end
end

function reindexBombs(ability)
    local tempTable = {}
    for i = 1, #ability.bombs, 1 do
        if IsValidEntity(ability.bombs[i]) then
            table.insert(tempTable, ability.bombs[i])
        end
    end 
    return tempTable
end

function bomb_start(caster, ability, target_location)

        local casterOrigin = caster:GetAbsOrigin()
        local targetOrigin = target_location
        local fv = (targetOrigin*Vector(1,1,0)-casterOrigin*Vector(1,1,0)):Normalized()
        local distance = WallPhysics:GetDistance(casterOrigin*Vector(1,1,0), targetOrigin*Vector(1,1,0))
        caster:SetForwardVector(fv)
        local propulsion = distance/30
        caster.maxBounces = 1
        if distance > 500 then
            caster.maxBounces = 2
        end
        bomb_jump_to_position(caster, fv, distance, 20, propulsion, 1, 1)
        local animationTime = math.min(500/distance, 1)
end

function bomb_jump_to_position(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
    local liftDuration = distance/propulsion/2
    if unit.phase == 2 then
        liftDuration = 10
    elseif unit.phase == 3 then
        liftDuration = 4
    end
    local endLocation = unit:GetAbsOrigin()+forwardVector*distance
    for i = 1, liftDuration, 1 do
        Timers:CreateTimer(0.03*i, function()
            local currentPosition = unit:GetAbsOrigin()
            local liftForce = math.max(liftForce-i*gravity, 0)
            local newPosition = currentPosition+forwardVector*propulsion+Vector(0,0,liftForce)
            unit:SetOrigin(newPosition)
        end)
    end
    local fallLoop = 0
    Timers:CreateTimer(0.03*liftDuration+0.03, function()
        Timers:CreateTimer(0.03*fallLoop, function()
            fallLoop = fallLoop + 1
            local currentPosition = unit:GetAbsOrigin()
            local newPosition = currentPosition+forwardVector*propulsion-Vector(0,0,fallLoop*gravity*fallGravity)

            if unit:HasModifier("modifier_bomb_motion") then
                unit:SetOrigin(newPosition)
            end
            if GetGroundPosition(unit:GetAbsOrigin(), unit).z > unit:GetAbsOrigin().z - 11 then
                unit:SetOrigin(newPosition)
                bomb_land(unit, propulsion)
            else
                if newPosition.x <= endLocation.x + 0 and newPosition.x >= endLocation.x-0 and newPosition.y <= endLocation.y+0 and newPosition.y >= endLocation.y-0 then
                    unit:SetOrigin(newPosition)
                    bomb_land(unit, propulsion)
                else
                    return 0.03
                end
            end
        end)
    end)
end

function bomb_explode(unit)
    EmitSoundOn("Trapper.BombImpactFinal", unit)
    local explosionRadius = 500
    local caster = unit.origCaster
    local ability = unit.origAbility
    local damage = unit.damage
    local stun_duration = unit.stun_duration
    local a_b_level = unit.a_b_level
    local c_b_level = unit.c_b_level
    ability.total_bombs = ability.total_bombs - 1
    print("BOMB EXPLODE??")
    Timers:CreateTimer(0.9, function()
                local position = unit:GetAbsOrigin()
                StopSoundEvent("Trapper.BombTicking", unit)
                StopSoundOn("Trapper.BombTicking", unit)
                EmitSoundOn("Trapper.BombExplode", unit)
              local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
              local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
              ParticleManager:SetParticleControl( particle2, 0, position )
              ParticleManager:SetParticleControl( particle2, 1, Vector(explosionRadius,explosionRadius,explosionRadius) )
              ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
              ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )

              Timers:CreateTimer(1.9, 
              function()
                ParticleManager:DestroyParticle( particle2, false )
              end)
              particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
              local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, unit )
              ParticleManager:SetParticleControl( particle1, 0, unit:GetAbsOrigin() )
              Timers:CreateTimer(2, 
              function()
                ParticleManager:DestroyParticle( particle1, false )
              end)
              GridNav:DestroyTreesAroundPoint(position, explosionRadius, false)
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, explosionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
            if #enemies > 0 then    
                for _,enemy in pairs(enemies) do
                    local a_b_damage = damage
                    if a_b_level > 0 then
                        local distance = WallPhysics:GetDistance(enemy:GetAbsOrigin(), position)
                        local damageBonusMult = 1 - (distance/explosionRadius)
                        a_b_damage = damage + damage*damageBonusMult*a_b_level*0.03
                    end
                    Filters:TakeArgumentsAndApplyDamage(enemy, caster, a_b_damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_FIRE, RPC_ELEMENT_NORMAL)
                    Filters:ApplyStun(caster, stun_duration, enemy)
                end
            end
            if c_b_level > 0 then
                for i = 1, 3, 1 do
                    shrapnel_bomb(caster, ability, stun_duration/2, damage*(c_b_level*0.015+0.1), unit:GetAbsOrigin())
                end
            end
    end)
    Timers:CreateTimer(1.0, function()
        UTIL_Remove(unit)
        ability.bombs = reindexBombs(ability)
    end)
end

function shrapnel_bomb(caster, ability, stun_duration, damage, origin)
    local fv = RandomVector(1)
    local bomb = CreateUnitByName("lanaya_explosive_bomb", origin, false, caster, nil, caster:GetTeamNumber())
    bomb:SetModelScale(0.5)
    bomb.phase = 1
    bomb.stun_duration = stun_duration
    bomb.colorPhase = 0
    bomb.fv = fv
    local target = origin+fv*RandomInt(200,400)
    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.type = "explosive"
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = damage
    bomb.detonate = true
    bomb.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "trapper")
    bomb.c_b_level = 0
    Timers:CreateTimer(0.1, function()
     StartSoundEvent("Trapper.BombTicking", bomb)
    end)
    bomb_start(bomb, ability, target)

end

function bomb_land(unit, propulsion)
	if unit.phase <= unit.maxBounces then
		unit.phase = unit.phase + 1
		local deltaVector = WallPhysics:rotateVector(unit.fv, math.pi/30)
        local randomDivisor = RandomInt(-3, 3)
        if randomDivisor == 0 then
            randomDivisor = 1
        end
        if unit.phase == 2 then
            EmitSoundOn("Trapper.BombImpact1", unit)
        else
            EmitSoundOn("Trapper.BombImpact2", unit)
        end
		local fv = unit.fv
        local bombAbility = unit:FindAbilityByName("lanaya_bomb_ability")
        bombAbility:ApplyDataDrivenModifier(unit, unit, "modifier_bomb_motion", {})
        propulsion = math.max(propulsion/(1.1*unit.phase), 2)
        local luck = RandomInt(1,4)
        if luck == 4 and unit.phase == unit.maxBounces + 1 then
            fv = unit.fv
        end
		bomb_jump_to_position(unit, fv, 200, 15-(5*(unit.phase-1)), propulsion, 1, 1)
    else 
        if unit.type == "explosive" then
            if unit.detonate then
                bomb_explode(unit)
            end
        elseif unit.type == "smoke" then
            smoke_bomb_explode(unit)
        elseif unit.type == "flash" then
            flash_explode(unit)
        end
	end
end

function bomb_color_think(event)
    local bomb = event.caster
    if bomb.colorPhase <= 10 then
        bomb:SetRenderColor(bomb.colorPhase*24, 0, 0)
    elseif bomb.colorPhase > 10 then
        bomb:SetRenderColor(240-bomb.colorPhase*24, 0, 0)
    end
    bomb.colorPhase = bomb.colorPhase + 1
    if bomb.colorPhase >= 20 then
        bomb.colorPhase = 0
    end
end

function smoke_bomb_explode(unit)
    EmitSoundOn("Trapper.BombImpactFinal", unit)
    local explosionRadius = 500
    local caster = unit.origCaster
    local ability = unit.origAbility
    local bombAbility = unit:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(unit, unit, "modifier_smoke_bomb", {})
    Timers:CreateTimer(10.0, function()
        UTIL_Remove(unit)
    end)
end

function smoke_bomb_think(event)
    local caster = event.caster
    local ability = event.ability
    local origAbility = caster.origAbility
    local origCaster = caster.origCaster
    local radius = caster.radius
      local particleName = "particles/items2_fx/smoke_of_deceit.vpcf"
      local casterPos = caster:GetAbsOrigin()
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, casterPos )
      ParticleManager:SetParticleControl( particle1, 1, Vector(radius, radius/2, radius/2) )
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(particle1, false)
      end)
    local b_b_damage = caster.b_b_damage
    
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then    
        for _,enemy in pairs(enemies) do
             origAbility:ApplyDataDrivenModifier(origCaster, enemy, "modifier_smoke_bomb_effect", {duration = 0.6}) 
             if b_b_damage > 0 then
                Filters:ApplyDotDamage(origCaster, ability, enemy, b_b_damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_POISON)
             end
        end
    end
    if origCaster:HasModifier("modifier_trapper_glyph_2_1") then
        local invisDuration = Filters:GetAdjustedBuffDuration(origCaster, 0.6, false)
        local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false )
        if #allies > 0 then    
            for _,ally in pairs(allies) do
                 if ally:GetEntityIndex() == origCaster:GetEntityIndex() then
                    local stealthAbility = origCaster:FindAbilityByName("trapper_stealth")
                    stealthAbility:ApplyDataDrivenModifier(origCaster, origCaster, "modifier_invisibility_datadriven", {duration = invisDuration})
                    stealthAbility:ApplyDataDrivenModifier(origCaster, origCaster, "modifier_invisible", {duration = invisDuration})
                 end
            end
        end
    end

end

function bomb_throw_start_smoke(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target_points[1]
    Filters:CastSkillArguments(2, caster)
    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
    bomb:SetOriginalModel("models/items/techies/bigshot/fx_bigshot_stasis.vmdl")
    bomb:SetModel("models/items/techies/bigshot/fx_bigshot_stasis.vmdl")
    bomb:SetRenderColor(0, 0, 0)
    bomb.phase = 1
    bomb.stun_duration = event.stun_duration
    bomb.colorPhase = 0
    bomb.fv = fv
    bomb.radius = event.radius
    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.type = "smoke"
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = event.damage
    local b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "trapper")
    bomb.b_b_damage = b_b_level*2980/2
    local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "trapper")
    bomb.b_b_damage = bomb.b_b_damage + 0.0004*(caster:GetIntellect()+caster:GetStrength()+caster:GetAgility())/10*d_b_level*bomb.b_b_damage

    EmitSoundOn("Trapper.BombThrow", caster)
    bomb_start(bomb, ability, target)
    rune_c_d(caster)
end

function bomb_throw_start_flash(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target_points[1]
    -- Filters:CastSkillArguments(2, caster)
    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
    bomb:SetOriginalModel("models/items/techies/bigshot/bigshot_remotebomb.vmdl")
    bomb:SetModel("models/items/techies/bigshot/bigshot_remotebomb.vmdl")
    bomb:SetRenderColor(0, 0, 0)
    bomb.phase = 1
    
    bomb.colorPhase = 0
    bomb.fv = fv
    bomb.radius = event.radius
    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.type = "flash"
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = event.damage
    local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "trapper")
    bomb.blind_duration = 2 + 0.1*c_d_level
    EmitSoundOn("Trapper.BombThrow", caster)
    bomb_start(bomb, ability, target)

        local level = ability:GetLevel()
        caster:FindAbilityByName("smoke_bomb"):SetLevel(level)
        caster:FindAbilityByName("smoke_bomb"):SetAbilityIndex(0)
        caster:SwapAbilities("smoke_bomb", "flash_grenade", true, false)
        caster.flash = false
end

function flash_explode(unit)
    EmitSoundOn("Trapper.BombImpactFinal", unit)
    local explosionRadius = 500
    local caster = unit.origCaster
    local ability = unit.origAbility
    local blind_duration = unit.blind_duration
    print("BOMB EXPLODE??")
    Timers:CreateTimer(0.9, function()
                local position = unit:GetAbsOrigin()
                StopSoundEvent("Trapper.BombTicking", unit)
                EmitSoundOn("Trapper.BombExplode", unit)
              local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
              local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
              ParticleManager:SetParticleControl( particle2, 0, position )
              ParticleManager:SetParticleControl( particle2, 1, Vector(explosionRadius,explosionRadius,explosionRadius) )
              ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
              ParticleManager:SetParticleControl( particle2, 4, Vector(255, 255, 255) )

              Timers:CreateTimer(1.9, 
              function()
                ParticleManager:DestroyParticle( particle2, false )
              end)
              -- particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
              -- local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, unit )
              -- ParticleManager:SetParticleControl( particle1, 0, unit:GetAbsOrigin() )
              -- Timers:CreateTimer(2, 
              -- function()
              --   ParticleManager:DestroyParticle( particle1, false )
              -- end)

            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, explosionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
            if #enemies > 0 then    
                for _,enemy in pairs(enemies) do
                    ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flash_grenade_blind", {duration = blind_duration})
                    Filters:ApplyStun(caster, 1, enemy)
                end
            end
    end)
    Timers:CreateTimer(1.0, function()
        UTIL_Remove(unit)
    end)
end

function rune_c_d(caster)
    local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "trapper")
    if c_d_level > 0 then
        local flash_grenade = caster:FindAbilityByName("flash_grenade")
        if not flash_grenade then
            flash_grenade = caster:AddAbility("flash_grenade")
        end
        local smoke_bomb = caster:FindAbilityByName("smoke_bomb")
        flash_grenade:SetLevel(smoke_bomb:GetLevel())
        smoke_bomb:SetAbilityIndex(1)
        flash_grenade:SetAbilityIndex(1)
        caster:SwapAbilities("smoke_bomb", "flash_grenade", false, true)
        caster.flash = true
    end
end
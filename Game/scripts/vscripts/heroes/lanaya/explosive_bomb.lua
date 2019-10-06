require("/heroes/lanaya/trapper_constants")
-- too much code that a bit hard to understand and to rewrite)
function bomb_throw_start(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target_points[1]
    Filters:CastSkillArguments(2, caster)

    local localKey = caster:GetEntityIndex() .. '_trapper_w_start'
    Util.Common:LimitPerTime(1, 1, localKey .. '_sound', function()
        EmitSoundOn("Trapper.BombThrow", caster)

    end)
    local bombsCount = TRAPPER_W_BOMBS_COUNT
    if caster:HasModifier('modifier_trapper_glyph_3_1') then
        bombsCount = bombsCount + TRAPPER_GLYPH_3_1_ADD_BOMBS
    end
    for i = 1,bombsCount do
        local bomb = createBomb(event, caster, ability)
        local bombTarget = target
        if i ~= 1 then
            bombTarget = bombTarget + RandomVector(RandomInt(200,400))
        end
        local fv = (bombTarget * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
        bomb_start(bomb, ability, bombTarget, fv)
    end
end

function createBomb(event, caster, ability, fv)
    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
    bomb.phase = 1
    bomb.stun_duration = event.stun_duration
    bomb.colorPhase = 0
    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.type = "explosive"
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = event.damage
    bomb.damage = bomb.damage + TRAPPER_W4_AMPLIFY_PERCENT / 100 * (caster:GetIntellect() + caster:GetStrength() + caster:GetAgility()) / 10 * caster.w4_level * bomb.damage
    bomb.detonate = true
    if ability.total_bombs == nil then
        ability.total_bombs = 0
        ability.bombs = {}
    end
    ability.total_bombs = ability.total_bombs + 1
    table.insert(ability.bombs, bomb)
    --DeepPrintTable(ability.bombs)
    --    if caster:HasModifier("modifier_trapper_glyph_6_1") then
    --        bomb.detonate = false
    --        if ability.total_bombs > 5 then
    --            bomb_explode(ability.bombs[1])
    --            Timers:CreateTimer(1.5, function()
    --                ability.bombs = reindexBombs(ability)
    --            end)
    --        end
    --    end

    bomb.w_1_level = caster.w1_level
    bomb.w_3_level = caster.w3_level
    if bomb.detonate then
        Timers:CreateTimer(0.1, function()
            StartSoundEvent("Trapper.BombTicking", bomb)
        end)
    end
    return bomb
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

function bomb_start(caster, ability, target_location, fv)
    caster.fv = fv
    local casterOrigin = caster:GetAbsOrigin()
    local targetOrigin = target_location
    local fv = (targetOrigin * Vector(1, 1, 0) - casterOrigin * Vector(1, 1, 0)):Normalized()
    local distance = WallPhysics:GetDistance(casterOrigin * Vector(1, 1, 0), targetOrigin * Vector(1, 1, 0))
    caster:SetForwardVector(fv)
    local propulsion = distance / 30
    caster.maxBounces = 1
    if distance > 500 then
        caster.maxBounces = 2
    end
    bomb_jump_to_position(caster, fv, distance, 20, propulsion, 1, 1)
    local animationTime = math.min(500 / distance, 1)
end

function bomb_jump_to_position(unit, forwardVector, distance, liftForce, propulsion, gravity, fallGravity)
    local liftDuration = distance / propulsion / 2
    if unit.phase == 2 then
        liftDuration = 10
    elseif unit.phase == 3 then
        liftDuration = 4
    end
    local endLocation = unit:GetAbsOrigin() + forwardVector * distance
    for i = 1, liftDuration, 1 do
        Timers:CreateTimer(0.03 * i, function()
            local currentPosition = unit:GetAbsOrigin()
            local liftForce = math.max(liftForce - i * gravity, 0)
            local newPosition = currentPosition + forwardVector * propulsion + Vector(0, 0, liftForce)
            unit:SetOrigin(newPosition)
        end)
    end
    local fallLoop = 0
    Timers:CreateTimer(0.03 * liftDuration + 0.03, function()
        Timers:CreateTimer(0.03 * fallLoop, function()
            fallLoop = fallLoop + 1
            local currentPosition = unit:GetAbsOrigin()
            local newPosition = currentPosition + forwardVector * propulsion - Vector(0, 0, fallLoop * gravity * fallGravity)

            if unit:HasModifier("modifier_bomb_motion") then
                unit:SetOrigin(newPosition)
            end
            if GetGroundPosition(unit:GetAbsOrigin(), unit).z > unit:GetAbsOrigin().z - 11 then
                unit:SetOrigin(newPosition)
                bomb_land(unit, propulsion)
            else
                if newPosition.x <= endLocation.x + 0 and newPosition.x >= endLocation.x - 0 and newPosition.y <= endLocation.y + 0 and newPosition.y >= endLocation.y - 0 then
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
    local caster = unit.origCaster
    local explosionRadius = TRAPPER_W_RADIUS
    local ability = unit.origAbility
    local damage = unit.damage
    local stun_duration = unit.stun_duration
    local w_1_level = unit.w_1_level
    local w_3_level = unit.w_3_level
    --print("BOMB EXPLODE??")
    local position = unit:GetAbsOrigin()
    local localKey = caster:GetEntityIndex() .. '_trapper_w'
    Util.Common:LimitPerTime(1, 1, localKey .. '_sound', function()
        EmitSoundOn("Trapper.BombImpactFinal", unit)
        EmitSoundOn("Trapper.BombExplode", unit)
    end)
    Util.Common:LimitPerTime(3, 0.2, localKey .. '_particles',function()
        local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
        local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(particle2, 0, position)
        ParticleManager:SetParticleControl(particle2, 1, Vector(explosionRadius, explosionRadius, explosionRadius))
        ParticleManager:SetParticleControl(particle2, 2, Vector(2.0, 2.0, 2.0))
        ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 20))
        GridNav:DestroyTreesAroundPoint(position, explosionRadius, false)

        Timers:CreateTimer(1.9, function()
            ParticleManager:DestroyParticle(particle2, false)
        end)
        particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
        local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, unit)
        ParticleManager:SetParticleControl(particle1, 0, unit:GetAbsOrigin())
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(particle1, false)
        end)
    end)
    StopSoundEvent("Trapper.BombTicking", unit)
    StopSoundOn("Trapper.BombTicking", unit)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, explosionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            local a_b_damage = damage
            if w_1_level > 0 then
                local distance = WallPhysics:GetDistance(enemy:GetAbsOrigin(), position)
                local damageBonusMult = 1 - (distance / explosionRadius)
                a_b_damage = damage + damage * damageBonusMult * w_1_level * TRAPPER_W1_AMP_PERCENT / 100
            end
            Filters:ApplyStun(caster, stun_duration, enemy)
            Damage:Apply({
                attacker = caster,
                victim = enemy,
                damage = a_b_damage,
                damageType = DAMAGE_TYPE_MAGICAL,
                source = ability,
                sourceType = BASE_ABILITY_W,
                elements = {
                    RPC_ELEMENT_NORMAL,
                }
            })
        end
    end
    if w_3_level > 0 then
        if not unit.chance_for_additional_proc then
            unit.chance_for_additional_proc = Runes:Procs(w_3_level, TRAPPER_W3_PROC_CHANCE, 1)
        else
            unit.chance_for_additional_proc = unit.chance_for_additional_proc - 1
            unit.damage  = unit.damage * TRAPPER_W3_DMG_PROC
        end
    else
        unit.chance_for_additional_proc = 0
    end
    if unit.chance_for_additional_proc > 0 then
        Timers:CreateTimer(TRAPPER_W3_DELAY, function()
            bomb_explode(unit)
        end)
    else
        Timers:CreateTimer(0.1, function()
            ability.total_bombs = ability.total_bombs - 1

            UTIL_Remove(unit)
            ability.bombs = reindexBombs(ability)
        end)
    end
end

function shrapnel_bomb(caster, ability, stun_duration, damage, origin)
    local fv = RandomVector(1)
    local bomb = CreateUnitByName("lanaya_explosive_bomb", origin, false, caster, nil, caster:GetTeamNumber())
    bomb:SetModelScale(0.5)
    bomb.phase = 1
    bomb.stun_duration = stun_duration
    bomb.colorPhase = 0
    local target = origin + fv * RandomInt(200, 400)
    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.type = "explosive"
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = damage
    bomb.detonate = true
    bomb.w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "trapper")
    bomb.w_3_level = 0
    Timers:CreateTimer(0.1, function()
        StartSoundEvent("Trapper.BombTicking", bomb)
    end)
    bomb_start(bomb, ability, target, fv)

end

function bomb_land(unit, propulsion)
    if unit.phase <= unit.maxBounces then
        unit.phase = unit.phase + 1
        local deltaVector = WallPhysics:rotateVector(unit.fv, math.pi / 30)
        local randomDivisor = RandomInt(-3, 3)
        if randomDivisor == 0 then
            randomDivisor = 1
        end

        local localKey = unit.origCaster:GetEntityIndex() .. '_trapper_w_land'
        Util.Common:LimitPerTime(1, 0.2, localKey .. '_sound', function()
            if unit.phase == 2 then
                EmitSoundOn("Trapper.BombImpact1", unit)
            else
                EmitSoundOn("Trapper.BombImpact2", unit)
            end
        end)
        local fv = unit.fv
        local bombAbility = unit:FindAbilityByName("lanaya_bomb_ability")
        bombAbility:ApplyDataDrivenModifier(unit, unit, "modifier_bomb_motion", {})
        propulsion = math.max(propulsion / (1.1 * unit.phase), 2)
        local luck = RandomInt(1, 4)
        if luck == 4 and unit.phase == unit.maxBounces + 1 then
            fv = unit.fv
        end
        bomb_jump_to_position(unit, fv, 200, 15 - (5 * (unit.phase - 1)), propulsion, 1, 1)
    else
        if unit.type == "explosive" then
            if unit.detonate then
                bomb_explode(unit)
            end
        elseif unit.type == "smoke" then
            smoke_bomb_explode(unit)
            --        elseif unit.type == "flash" then
            --            flash_explode(unit)
        end
    end
end

function bomb_color_think(event)
    local bomb = event.caster
    if bomb.colorPhase <= 10 then
        bomb:SetRenderColor(bomb.colorPhase * 24, 0, 0)
    elseif bomb.colorPhase > 10 then
        bomb:SetRenderColor(240 - bomb.colorPhase * 24, 0, 0)
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
    local duration = TRAPPER_W2_DURATION_BASE
    if caster:HasModifier('modifier_trapper_glyph_5_1') then
        duration = duration * TRAPPER_GLYPH_5_1_INVISIBLE_W_DURATION_AMPLIFY
    end
    Timers:CreateTimer(duration, function()
        UTIL_Remove(unit)
    end)
end

function smoke_bomb_think(event)
    local caster = event.caster
    local ability = event.ability
    local origAbility = caster.origAbility
    local origCaster = caster.origCaster
    local radius = caster.radius
    local position = caster:GetAbsOrigin()
    local particleName = "particles/items2_fx/smoke_of_deceit.vpcf"
    local casterPos = caster:GetAbsOrigin()
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle1, 0, casterPos)
    ParticleManager:SetParticleControl(particle1, 1, Vector(radius, radius / 2, radius / 2))
    Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    local b_b_damage = caster.w_2_damage

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)

    local w_1_level = caster.w_1_level

    local damage = b_b_damage
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            origAbility:ApplyDataDrivenModifier(origCaster, enemy, "modifier_smoke_bomb_effect", {duration = 0.6})
            if b_b_damage > 0 then
                if w_1_level > 0 then
                    local distance = WallPhysics:GetDistance(enemy:GetAbsOrigin(), position)
                    local damageBonusMult = 1 - (distance / radius)
                    damage = b_b_damage + b_b_damage * damageBonusMult * w_1_level * TRAPPER_W1_AMP_PERCENT / 100
                    if origCaster.w3_level > 0 then
                        damage = damage * (1 + origCaster.w3_level * TRAPPER_W3_AMP_INVISIBLE_W)
                    end
                end
                Damage:Apply({
                    attacker = origCaster,
                    victim = enemy,
                    damage = damage,
                    damageType = DAMAGE_TYPE_MAGICAL,
                    source = origAbility,
                    sourceType = BASE_ABILITY_W,
                    elements = {
                        RPC_ELEMENT_NORMAL,
                    },
                    isDot = true,
                })
            end
        end
    end
    local invisDuration = Filters:GetAdjustedBuffDuration(origCaster, 0.6, false)
    local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
    if #allies > 0 then
        for _, ally in pairs(allies) do
            if ally:GetEntityIndex() == origCaster:GetEntityIndex() then
                local stealthAbility = origCaster:FindAbilityByName("trapper_stealth")
                stealthAbility:ApplyDataDrivenModifier(origCaster, origCaster, "modifier_invisibility_datadriven", {duration = invisDuration})
                stealthAbility:ApplyDataDrivenModifier(origCaster, origCaster, "modifier_invisible", {duration = invisDuration})
            end
        end
    end

end

function bomb_throw_start_smoke(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target_points[1]
    Filters:CastSkillArguments(2, caster)
    local fv = (target * Vector(1, 1, 0) - caster:GetAbsOrigin() * Vector(1, 1, 0)):Normalized()
    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
    bomb:SetOriginalModel("models/items/techies/bigshot/fx_bigshot_stasis.vmdl")
    bomb:SetModel("models/items/techies/bigshot/fx_bigshot_stasis.vmdl")
    bomb:SetRenderColor(0, 0, 0)
    bomb.phase = 1
    bomb.stun_duration = event.stun_duration
    bomb.colorPhase = 0
    bomb.radius = event.radius

    if caster:HasModifier('modifier_trapper_glyph_5_1') then
        bomb.radius = bomb.radius * TRAPPER_GLYPH_5_1_INVISIBLE_W_RADIUS_AMPLIFY
    end
    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
    bomb.type = "smoke"
    bomb.origCaster = caster
    bomb.origAbility = ability
    bomb.damage = event.damage
    bomb.w_1_level = caster.w1_level
    local w_2_level = caster.w2_level
    bomb.w_2_damage = w_2_level * TRAPPER_W2_DAMAGE * caster:GetLevel()
    bomb.w_2_damage = bomb.w_2_damage + TRAPPER_W4_AMPLIFY_PERCENT / 100 * (caster:GetIntellect() + caster:GetStrength() + caster:GetAgility()) / 10 * caster.w4_level * bomb.w_2_damage

    EmitSoundOn("Trapper.BombThrow", caster)
    bomb_start(bomb, ability, target, fv)
    -- rune_r_3(caster)
end

--function bomb_throw_start_flash(event)
--    local caster = event.caster
--    local ability = event.ability
--    local target = event.target_points[1]
--    -- Filters:CastSkillArguments(2, caster)
--    local fv = (target*Vector(1,1,0)-caster:GetAbsOrigin()*Vector(1,1,0)):Normalized()
--    local bomb = CreateUnitByName("lanaya_explosive_bomb", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
--    bomb:SetOriginalModel("models/items/techies/bigshot/bigshot_remotebomb.vmdl")
--    bomb:SetModel("models/items/techies/bigshot/bigshot_remotebomb.vmdl")
--    bomb:SetRenderColor(0, 0, 0)
--    bomb.phase = 1
--
--    bomb.colorPhase = 0
--    bomb.fv = fv
--    bomb.radius = event.radius
--    bomb:AddAbility("lanaya_bomb_ability"):SetLevel(1)
--    local bombAbility = bomb:FindAbilityByName("lanaya_bomb_ability")
--    bombAbility:ApplyDataDrivenModifier(bomb, bomb, "modifier_bomb_motion", {})
--    bomb.type = "flash"
--    bomb.origCaster = caster
--    bomb.origAbility = ability
--    bomb.damage = event.damage
--    local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "trapper")
--    bomb.blind_duration = 2 + 0.1*c_d_level
--    EmitSoundOn("Trapper.BombThrow", caster)
--    bomb_start(bomb, ability, target)
--
--        local level = ability:GetLevel()
--        caster:FindAbilityByName("smoke_bomb"):SetLevel(level)
--        caster:FindAbilityByName("smoke_bomb"):SetAbilityIndex(0)
--        caster:SwapAbilities("smoke_bomb", "flash_grenade", true, false)
--        caster.flash = false
--end
--
--function flash_explode(unit)
--    EmitSoundOn("Trapper.BombImpactFinal", unit)
--    local explosionRadius = 500
--    local caster = unit.origCaster
--    local ability = unit.origAbility
--    local blind_duration = unit.blind_duration
--   --print("BOMB EXPLODE??")
--    Timers:CreateTimer(0.9, function()
--                local position = unit:GetAbsOrigin()
--                StopSoundEvent("Trapper.BombTicking", unit)
--                EmitSoundOn("Trapper.BombExplode", unit)
--              local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
--              local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
--              ParticleManager:SetParticleControl( particle2, 0, position )
--              ParticleManager:SetParticleControl( particle2, 1, Vector(explosionRadius,explosionRadius,explosionRadius) )
--              ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
--              ParticleManager:SetParticleControl( particle2, 4, Vector(255, 255, 255) )
--
--              Timers:CreateTimer(1.9,
--              function()
--                ParticleManager:DestroyParticle( particle2, false )
--              end)
--              -- particleName = "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf"
--              -- local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, unit )
--              -- ParticleManager:SetParticleControl( particle1, 0, unit:GetAbsOrigin() )
--              -- Timers:CreateTimer(2,
--              -- function()
--              --   ParticleManager:DestroyParticle( particle1, false )
--              -- end)
--
--            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, explosionRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
--            if #enemies > 0 then
--                for _,enemy in pairs(enemies) do
--                    ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flash_grenade_blind", {duration = blind_duration})
--                    Filters:ApplyStun(caster, 1, enemy)
--                end
--            end
--    end)
--    Timers:CreateTimer(1.0, function()
--        UTIL_Remove(unit)
--    end)
--end

--function rune_r_3(caster)
--    local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "trapper")
--    if c_d_level > 0 then
--        local flash_grenade = caster:FindAbilityByName("flash_grenade")
--        if not flash_grenade then
--            flash_grenade = caster:AddAbility("flash_grenade")
--        end
--        local smoke_bomb = caster:FindAbilityByName("smoke_bomb")
--        flash_grenade:SetLevel(smoke_bomb:GetLevel())
--        smoke_bomb:SetAbilityIndex(1)
--        flash_grenade:SetAbilityIndex(1)
--        caster:SwapAbilities("smoke_bomb", "flash_grenade", false, true)
--        caster.flash = true
--    end
--end

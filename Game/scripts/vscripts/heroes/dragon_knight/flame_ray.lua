require("/heroes/dragon_knight/flamewaker_constants")



function rune_e_1(caster)

    local e_1_level = caster:GetRuneValue("e", 1)

    if e_1_level > 0 then
        return e_1_level
    else
        return 0
    end
end

function rune_e_1_damage(event)
    local ability = event.ability
    local caster = event.caster
    local target = event.target
    if ability.rune_e_1 then
        local runeAbility = caster.runeUnit4:FindAbilityByName("flamewaker_rune_e_4")
        local damage = ability.rune_e_1 * FLAMEWAKER_E1_DMG
        if ability.glyphed then
            damage = damage * FLAMEWAKER_GLYPH_7_1_E1_DAMAGE_MULT
        end
        CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_c.vpcf", target, 1)
        Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_E, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
    end

end

function rune_e_3(event)
    local caster = event.caster
    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("flamewaker_rune_e_3")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "e_3")
    local totalLevel = abilityLevel + bonusLevel
    local pathLength = event.path_length
    local fv = caster:GetForwardVector()
    local casterOrigin = caster:GetAbsOrigin()
    runeAbility.runeUnit = runeUnit
    runeAbility.fv = fv
    runeAbility.endcapPos = (fv * pathLength) / 3
    runeAbility.intervalCount = 0
    runeAbility.e_3_level = totalLevel
    runeAbility.mainAbility = event.ability
    event.ability.e_3_damage = 200 + totalLevel * 240
    if totalLevel > 0 then
        create_dragon(caster, fv, casterOrigin - fv * 250, totalLevel, runeAbility, runeUnit)
    end

end

function flamewaker_rune_e_4(caster, ability)
    local e_4_level = caster:GetRuneValue("e", 4)
    print("E 4")
    if e_4_level > 0 then
        for i = 0, 6, 1 do
            local check_ability = caster:GetAbilityByIndex(i)
            if check_ability and IsValidEntity(check_ability) then
                if check_ability:GetAbilityName() ~= ability:GetAbilityName() then
                    print("REDUCE CD")
                    local CDreduce = FLAMEWAKER_E4_CD_REDUCTION*e_4_level
                    Filters:ReduceCooldownGeneric(caster, check_ability, CDreduce)
                end
            end
        end
    end
end

function create_dragon(caster, fv, position, totalLevel, runeAbility, runeUnit)
    local dummy = CreateUnitByName("prop_dragon", position, true, caster, caster, caster:GetTeamNumber())
    dummy:SetModelScale(0.7)
    dummy.owner = caster:GetPlayerOwnerID()
    dummy:AddAbility("replica")
    dummy:FindAbilityByName("replica"):SetLevel(1)
    dummy:SetForwardVector(fv)
    runeAbility:ApplyDataDrivenModifier(runeUnit, dummy, "modifier_rune_e_3_dragon", {duration = 3.5})
    dummy:SetAbsOrigin(position + Vector(0, 0, 200))

end

function dragon_think(event)
    local ability = event.ability
    local target = event.target
    local currentPosition = target:GetAbsOrigin()
    ability.intervalCount = ability.intervalCount + 1
    local newPosition = currentPosition + ability.fv * 18
    if ability.intervalCount < 40 then
        newPosition = newPosition + Vector(0, 0, -(ability.intervalCount) / 3)
    end
    if ability.intervalCount > 85 then
        newPosition = newPosition + Vector(0, 0, (ability.intervalCount - 85))
    end
    target:SetAbsOrigin(newPosition)
    if ability.intervalCount < 85 then
        if ability.intervalCount % 25 == 0 then
            dragon_projectile(ability.e_3_level, ability.runeUnit, ability.fv, target:GetAbsOrigin() + ability.fv * 200, ability.mainAbility, target)
        end
    end

end

function dragon_end(event)
    UTIL_Remove(event.target)
end

function dragon_projectile(abilityLevel, caster, fv, casterOrigin, ability, dragon)

    EmitSoundOn("dragon_knight_dragon_anger_01", dragon)
    EmitSoundOn("dragon_knight_dragon_anger_01", dragon)
    local start_radius = 200
    local end_radius = 600
    local range = 1000
    local speed = 600
    local damage = 300 * abilityLevel
    local info =
    {
        Ability = ability,
        EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
        vSpawnOrigin = casterOrigin + Vector(0, 0, 160),
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = dragon,
        StartPosition = "attach_origin",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit = false,
        vVelocity = fv * speed * 3,
        bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function dragon_projectile_hit(event)
    local target = event.target
    local caster = event.caster
    local damage = event.ability.e_3_damage
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }

    ApplyDamage(damageTable)
end

function SpendHPCost(event)
    --    local caster = event.caster
    --    local hpCost = event.hp_cost_perc_per_second * event.tick_interval
    --  caster:SetHealth( caster:GetHealth() * ( 100 - hpCost ) / 100 )
    --    caster:SetHealth( caster:GetHealth() - caster.sun_ray_hp_at_start * hpCost / 100 )
end

--[[
    Author: Ractidous
    Date: 29.01.2015.
    Swap the abilities back to the original states.
]]
function EndSunRay(event)
    local caster = event.caster
    local ability = event.ability
    if ability.sunParticle then
        ParticleManager:DestroyParticle(ability.sunParticle, false)
    end
    --caster:SwapAbilities( ability:GetAbilityName(), event.sub_ability_name, true, false )
    --caster:SwapAbilities( event.toggle_move_empty_ability_name, event.toggle_move_ability_name, true, false )
end

function rune_e_2(caster)
    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("flamewaker_rune_e_2")
    local e_2_level = caster:GetRuneValue("e", 2)
    if e_2_level > 0 then
        ability.e_2_level = e_2_level
        ability:ApplyDataDrivenModifier(runeUnit, caster, "flamewaker_rune_e_2_buff", {})
        caster:SetModifierStackCount("flamewaker_rune_e_2_buff", ability, e_2_level)
    end
end
--[[
    Author: Ractidous
    Date: 29.01.2015.
    Toggle move.
]]
function ToggleMove(event)
    local caster = event.caster
    caster.sun_ray_is_moving = not caster.sun_ray_is_moving
end

--[[
    Author: Ractidous
    Date: 29.01.2015.
    Check current states, and interrupt the sun ray if the caster is getting disabled.
]]
function CheckToInterrupt(event)
    local caster = event.caster

    if caster:IsSilenced() or
        caster:IsStunned() or caster:IsHexed() or caster:IsFrozen() or caster:IsNightmared() or caster:IsOutOfGame() then
        -- Interrupt the ability
        caster:RemoveModifierByName(event.modifier_caster_name)
    end
end

--[[
    Author: Ractidous
    Date: 28.01.2015.
    Check whether the target is within the sun ray, and apply the damage if neccesary.
]]
function CheckForCollision(event)

end

--[[
    Author: Ractidous
    Date: 27.01.2015.
    Distance between a point and a segment.
]]
function DistancePointSegment(p, v, w)
    local l = w - v
    local l2 = l:Dot(l)
    t = (p - v):Dot(w - v) / l2
    if t < 0.0 then
        return (v - p):Length2D()
    elseif t > 1.0 then
        return (w - p):Length2D()
    else
        local proj = v + t * l
        return (proj - p):Length2D()
    end
end

--[[
    Author: Noya
    Date: 16.01.2015.
    Levels up the ability_name to the same level of the ability that runs this
]]
function LevelUpAbility(event)
    -- local caster = event.caster
    -- local this_ability = event.ability
    -- local this_abilityName = this_ability:GetAbilityName()
    -- local this_abilityLevel = this_ability:GetLevel()

    -- -- The ability to level up
    -- local ability_name = event.ability_name
    -- local ability_handle = caster:FindAbilityByName(ability_name)
    -- local ability_level = ability_handle:GetLevel()

    -- -- Check to not enter a level up loop
    -- if ability_level ~= this_abilityLevel then
    --     ability_handle:SetLevel(this_abilityLevel)
    -- end
end

--[[
    Author: Ractidous
    Date: 29.01.2015.
    Stop a sound.
]]
function StopSound(event)
    --print("CALLED?")
    StopSoundEvent(event.sound_name, event.caster)
end

function CastNewHeatwave(event)
    local caster = event.caster
    local ability = event.ability
    ability.forward = caster:GetForwardVector()
    caster:RemoveModifierByName("modifier_heatwave_phase_one")
    -- if caster:HasModifier("modifier_heatwave_phase_one") then
    --     caster:RemoveModifierByName("modifier_heatwave_phase_one")
    -- else
    EmitSoundOn("Flamewaker.HeatWaveCast", caster)
    EmitSoundOn("Hero_Phoenix.SunRay.Loop", caster)
    local particleName = "particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf"
    local particleVector = caster:GetAbsOrigin() - (caster:GetForwardVector() * 90)
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true)
    ParticleManager:SetParticleControl(pfx, 1, particleVector + Vector(0, 0, 100))
    ability.sunParticle = pfx
    ability.interval = 0
    ability.durationRemaining = event.duration
    local duration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_heatwave_phase_one", {duration = duration})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_heatwave_flying_portion", {duration = duration})
    caster:AddNewModifier(caster, nil, 'modifier_movespeed_cap_heat_wave', {duration = duration})
    ability.durationRemaining = duration
    Filters:CastSkillArguments(3, caster)
    if caster:HasModifier("modifier_flamewaker_glyph_7_1") then
        ability.glyphed = true
        ability.pv = WallPhysics:rotateVector(ability.forward, math.pi / 2)
    else
        ability.glyphed = false
    end

    rune_e_2(caster)
    rune_e_3(caster)
    flamewaker_rune_e_4(caster, ability)

    if caster:HasModifier("modifier_flamewaker_immortal_weapon_2") then
        caster.weapon:ApplyDataDrivenModifier(caster.InventoryUnit, caster, "modifier_flamewaker_weapon_agility", {duration = duration})
    end
    -- end
end

function heatwave_phase_think(event)
    local caster = event.caster
    local ability = event.ability

    ability.interval = ability.interval + 1

    ability.rune_e_1 = rune_e_1(caster)
    local casterOrigin = caster:GetAbsOrigin()
    if caster:HasModifier("modifier_heatwave_flying_portion") then
        local newPos = casterOrigin + ability.forward * 62
        local obstruction = WallPhysics:FindNearestObstruction(casterOrigin * Vector(1, 1, 0))
        local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos * Vector(1, 1, 0), caster)
        if blockUnit then
            caster:SetAbsOrigin(caster:GetAbsOrigin() - caster:GetForwardVector() * 60)
            WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
            caster:RemoveModifierByName("modifier_heatwave_flying_portion")

        end
    end
    if ability.rune_e_1 > 0 then
        if ability.interval % 2 == 0 then
            CustomAbilities:QuickAttachThinker(ability, caster, casterOrigin, "fire_thinker", {duration = 4})
            --ability:ApplyDataDrivenThinker(caster, casterOrigin, "fire_thinker", {duration = 4})
            if ability.glyphed then
                ability.pv = WallPhysics:rotateVector(ability.forward, math.pi / 2)
                local point = casterOrigin + ability.pv * 100
                CustomAbilities:QuickAttachThinker(ability, caster, casterOrigin, "fire_thinker", {duration = 4})
                --ability:ApplyDataDrivenThinker(caster, point, "fire_thinker", {duration = 4})
                point = casterOrigin - ability.pv * 100
                CustomAbilities:QuickAttachThinker(ability, caster, casterOrigin, "fire_thinker", {duration = 4})
                --ability:ApplyDataDrivenThinker(caster, point, "fire_thinker", {duration = 4})
            end
        end
    end

    ParticleManager:SetParticleControl(ability.sunParticle, 1, caster:GetAbsOrigin() + Vector(0, 0, 80))
    ability.durationRemaining = ability.durationRemaining - 0.05
    if caster:HasModifier("modifier_dragonflame_freeze_effect") then
        local newPos = GetGroundPosition(casterOrigin + caster:GetForwardVector() * 18, caster)
        local obstruction = WallPhysics:FindNearestObstruction(casterOrigin * Vector(1, 1, 0))
        local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos * Vector(1, 1, 0), caster)
        if not blockUnit then
            caster:SetOrigin(newPos)
        end
    end
end

function phase_one_end(event)
    local caster = event.caster
    local ability = event.ability
    -- local phaseTwoDuration = math.max(ability.durationRemaining,0.03)
    -- ability:ApplyDataDrivenModifier(caster, caster, "modifier_heatwave_phase_two", {duration = phaseTwoDuration})
    -- ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
    -- Filters:CastSkillArguments(3, caster)

end

function rune_e_3(caster)
    local runeUnit = caster.runeUnit3
    local ability = runeUnit:FindAbilityByName("flamewaker_rune_e_3")
    local e_3_level = caster:GetRuneValue("e", 3)
    if e_3_level > 0 then
        local duration = Filters:GetAdjustedBuffDuration(caster, 6, false)
        ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_rune_e_3_damage_boost", {duration = duration})
        caster:SetModifierStackCount("modifier_rune_e_3_damage_boost", ability, e_3_level)
    end

end

function rotateVector(vector, radians)
    XX = vector.x
    YY = vector.y

    Xprime = math.cos(radians) * XX - math.sin(radians) * YY
    Yprime = math.sin(radians) * XX + math.cos(radians) * YY

    vectorX = Vector(1, 0, 0) * Xprime
    vectorY = Vector(0, 1, 0) * Yprime
    rotatedVector = vectorX + vectorY
    return rotatedVector

end

function flame_ray_damage(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function dragon_rage_b_c_think(event)
    local caster = event.caster.hero
    local level = event.ability.e_2_level
    local damage = (level * FLAMEWAKER_E2_IMMOLATION_BASE + caster:GetAgility() * (FLAMEWAKER_E2_IMMOLATION_BONUS_DAMAGE_AGILITY/100) * level)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        for _, enemy in pairs(enemies) do
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
            CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_c.vpcf", enemy, 1)
        end
    end
end

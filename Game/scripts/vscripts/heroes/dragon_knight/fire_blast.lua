require('heroes/dragon_knight/flamewaker_constants')
function Vacuum(keys)
    local caster = keys.caster
    local target = keys.target
    local target_location = target:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    ability.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "flamewaker")
    ability.q_4_ability = caster.runeUnit4:FindAbilityByName("flamewaker_rune_q_4")
    caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "flamewaker")
    -- Ability variables
    local duration = ability:GetLevelSpecialValueFor("light_strike_array_stun_duration", ability_level)
    local radius = ability:GetLevelSpecialValueFor("light_strike_array_aoe", ability_level)
    local vacuum_modifier = keys.vacuum_modifier
    local remaining_duration = duration - (GameRules:GetGameTime() - target.vacuum_start_time)

    -- Targeting variables
    local target_teams = ability:GetAbilityTargetTeam()
    local target_types = ability:GetAbilityTargetType()
    local target_flags = ability:GetAbilityTargetFlags()

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
    -- Calculate the position of each found unit
    for _, unit in ipairs(units) do
        local unit_location = unit:GetAbsOrigin()
        local vector_distance = target_location - unit_location
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()

        -- Check if its a new vacuum cast
        -- Set the new pull speed if it is
        if unit.vacuum_caster ~= target then
            unit.vacuum_caster = target
            -- The standard speed value is for 1 second durations so we have to calculate the difference
            -- with 1/duration
            unit.vacuum_caster.pull_speed = distance * 1 / duration * 1 / 90
        end

        -- Apply the stun and no collision modifier then set the new location
        ability:ApplyDataDrivenModifier(caster, unit, vacuum_modifier, {duration = remaining_duration})
        if not unit.jumpLock and not unit.pushLock then
            unit:SetAbsOrigin(unit_location + direction * unit.vacuum_caster.pull_speed)
        end

    end

end

function VacuumStart(keys)
    local target = keys.target

    target.vacuum_start_time = GameRules:GetGameTime()
end

function cast_fire_blast(event)
    local caster = event.caster
    local ability = event.ability
    local target_location = event.target_points[1]
    local ability_level = ability:GetLevel()
    local radius = ability:GetLevelSpecialValueFor("light_strike_array_aoe", ability_level)
    local thinkerDuration = ability:GetLevelSpecialValueFor("light_strike_array_delay_time", 1)
    if thinkerDuration and thinkerDuration > 0 then
        CustomAbilities:QuickAttachThinker(ability, caster, target_location, "modifier_vacuum_thinker_datadriven", {duration = thinkerDuration})
    end
    Filters:CastSkillArguments(1, caster)
    if caster:HasModifier("modifier_flamewaker_glyph_2_1") then
        ability:EndCooldown()
        ability:StartCooldown(FLAMEWAKER_GLYPH_2_1_Q_CD)
    end
    rune_q_3_eruption(ability, caster, target_location, radius)
    rune_q_2(caster)
end

function rune_q_2(caster)
    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("flamewaker_rune_q_2")
    ability.q_2_level = caster:GetRuneValue("q", 2)
    ability.heal = 0
end

function fire_blast_damage(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage
    local stun_duration = event.stun_duration
    if caster:HasModifier("modifier_flamewaker_immortal_weapon_3") then
        stun_duration = stun_duration * FLAMEWAKER_IMMORTAL_WEAPON_3_STUN_DURATION_Q_R_MULT
    end
    Filters:ApplyStun(caster, stun_duration, target)
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_EARTH)
end

function rune_q_3_eruption(ability, caster, point, radius)
    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("flamewaker_rune_q_3")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_3")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
        ability.q_3_damage = caster:GetStrength() * totalLevel * 0.5 + totalLevel * 800
        --ability:ApplyDataDrivenThinker(caster, point, "modifier_eruption_thinker", {})
        CustomAbilities:QuickAttachThinker(ability, caster, point, "modifier_eruption_thinker", {})
    else
        return 0
    end
end

function eruption_damage(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    if IsValidEntity(ability) then
        local damage = ability.q_3_damage
        Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
        local seismicFlare = caster:FindAbilityByName("seismic_flare")
        CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_c.vpcf", target, 1)
        if seismicFlare.q_4_level > 0 then
            local d_a_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
            seismicFlare.q_4_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_flamewaker_rune_q_4", {duration = d_a_duration})
            local current_stack = caster:GetModifierStackCount("modifier_flamewaker_rune_q_4", seismicFlare.q_4_ability)
            local stackBonus = math.floor(damage * FLAMEWAKER_Q4_BASE_DMG_PER_DAMAGE * seismicFlare.q_4_level / 10)
            caster:SetModifierStackCount("modifier_flamewaker_rune_q_4", seismicFlare.q_4_ability, current_stack + stackBonus)
        end
    end
end

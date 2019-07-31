require('/util')

local shadowsModifiers = {
    aura = 'modifier_chernobog_shadows_aura',
    enemy_effect = 'modifier_chernobog_shadows_enemy_effect'
}
function chenobog_make_right_cooldown(caster, ability, abilityLetter)
    local cooldownAmplify = 1
    if abilityLetter == 'q' then
        cooldownAmplify = 1/(1 + caster.q4_level * CHERNOBOG_Q4_CD_REDUCTION_TIMES)
    end
    Util.Ability:MakeRightCooldown(caster, ability, {
        cooldownAmplify = cooldownAmplify
    })
end

-- {caster, ability, thinkInterval, radius, damagePercent}
function init_shadows_values_for_ability(data)
    local radius = data.radius
    local thinkInterval = data.thinkInterval
    local damagePercent = data.damagePercent


    if data.ability:GetCaster():HasModifier('modifier_chernobog_glyph_2_1') then
        print('radius amp')
        radius = radius * CHERNOBOG_T21_RADIUS_AMP
    end

    data.ability.shadowsAuraRadius = radius
    data.ability.shadowsThinkInterval = thinkInterval
    data.ability.shadowsDamagePercent = damagePercent
end

function hasArcana2(caster)
    return caster:HasAbility('chernobog_3_e_arcana2') or caster:HasAbility('chernobog_3_e_arcana2_swapped')
end

function getShadowsDuration(caster, baseDuration)
    local hasArcana = hasArcana2(caster)
    if hasArcana then
        baseDuration = baseDuration + CHERNOBOG_ARCANA2_E4_BONUS_TIME * caster.e4_level
    end
    return baseDuration
end

function onBlink(caster,ability, startPoint, endPoint)
    if not caster:HasModifier('modifier_chernobog_glyph_1_1') then
        return
    end
    local distance = WallPhysics:GetDistance2d(startPoint, endPoint)
    local radius = distance * CHERNOBOG_T11_PART_OF_DISTANCE
    local canCreateAura = true
    local hasArcana = hasArcana2(caster)
    if hasArcana then
        if caster.e4_level > 0 then
            init_shadows_values_for_ability({
                ability = ability,
                radius = radius,
                damagePercent = caster.e4_level * CHERNOBOG_ARCANA2_E4_DMG_PCT,
                thinkInterval = CHERNOBOG_ARCANA2_E4_INTERVAL
            })
        else
            canCreateAura = false
        end
    else
        if caster.e2_level > 0 then
            init_shadows_values_for_ability({
                ability = ability,
                radius = radius,
                damagePercent = caster.e2_level * CHERNOBOG_E2_DMG_PCT,
                thinkInterval = CHERNOBOG_E2_INTERVAL / (1 + caster.e4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE),
            })
        else
            canCreateAura = false
        end
    end
    if canCreateAura then
        Util.Ability:MakeThinker(caster, ability, shadowsModifiers.aura, startPoint, getShadowsDuration(caster, CHERNOBOG_T11_DURATION))
        Util.Ability:MakeThinker(caster, ability, shadowsModifiers.aura, endPoint, getShadowsDuration(caster, CHERNOBOG_T11_DURATION))
    end
end

function onCastR(caster)
    if caster:HasModifier("modifier_chernobog_glyph_3_1") then
        local ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
        --local currentCooldown = ability:GetCooldownTimeRemaining()
        ability:OnSpellStart()

    end
end
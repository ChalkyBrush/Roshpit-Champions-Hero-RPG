require('/util')
function chenobog_make_right_cooldown(caster, ability, abilityLetter)
    local cooldownAmplify = 1
    if abilityLetter == 'q' then
        cooldownAmplify = 1/(1 + ability.q4_level * CHERNOBOG_Q4_CD_REDUCTION_TIMES)
    end
    Util.Ability:MakeRightCooldown(caster, ability, {
        cooldownAmplify = cooldownAmplify
    })
end

-- {caster, ability, thinkInterval, radius, damagePercent}
function init_shadows_values_for_ability(data)
    local ability = data.ability
    local radius = data.radius
    local thinkInterval = data.thinkInterval
    local damagePercent = data.damagePercent

    ability.shadowsAuraRadius = radius
    ability.shadowsThinkInterval = thinkInterval
    ability.shadowsDamagePercent = damagePercent
end
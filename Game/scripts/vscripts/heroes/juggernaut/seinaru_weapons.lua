require('heroes/juggernaut/seinaru_constants')
require('heroes/juggernaut/seinaru_4_r')
function seinaru_weap_1_attack(event)
    local attacker = event.attacker
    local target = event.target
    local sword = event.ability
    local damage = attacker:GetAverageTrueAttackDamage(attacker) * SEINARU_WEAP_1_DMG_PER_ATT
    local q_arcana_ability = attacker:FindAbilityByName("seinaru_blade_dash")
    if q_arcana_ability then
        local luck = RandomInt(1, 100)
        if luck <= SEINARU_ARCANA_Q1_CRIT_CHANCE then
            damage = damage * SEINARU_ARCANA_Q1_CRIT_DMG * q_arcana_ability.q_1_level
        end
    end

    local r_ability = attacker:FindAbilityByName('seinaru_gorudo')

    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
    for _,enemy in pairs(enemies) do
        if not enemy.dummy then
            if r_ability then
                Seinaru_Apply_E4(attacker, enemy, r_ability)
            end
            Filters:TakeArgumentsAndApplyDamage(enemy, attacker, damage, DAMAGE_TYPE_PHYSICAL, 0, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE)
        end
    end
    if not sword.particles then
        sword.particles = true
        CustomAbilities:QuickAttachParticle("particles/roshpit/seinaru/onimaru_start_lvl2.vpcf", target, 3)
        Timers:CreateTimer(1.25, function()
            sword.particles = false
        end)
    end
end
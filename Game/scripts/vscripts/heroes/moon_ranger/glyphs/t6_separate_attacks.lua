require('heroes/moon_ranger/init')
local BitingStar = require('heroes/moon_ranger/abilities/q/q2_biting_star')

function attackLand(event)
    local attacker = event.attacker
    local damage = attacker:GetAverageTrueAttackDamage(attacker)
    local target = event.target
    local ability = event.ability
    local maxCount = T61_TARGETS;

    ability.attacker = attacker
    ability.damage = damage * T61_DAMAGE_PERCENT

    local arrowParticle = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
    if attacker:HasModifier("modifier_astral_rune_c_a") then
        arrowParticle = "particles/units/heroes/hero_drow/astral_c_a_particle_attackfrost_arrow.vpcf"
    end

    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, T61_ENEMIES_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        local count = 0
        for _,enemy in pairs(enemies) do
            if count > maxCount then
                break
            end
            if target == enemy then
            elseif enemy.dummy then
            else
                createArrow(attacker,damage,enemy, target, ability, arrowParticle)
                count = count+1
            end
        end
    end
end

function projectileHit(event)
    local ability = event.ability

    print(ability.damage)
    Filters:TakeArgumentsAndApplyDamage(event.target, ability.attacker, ability.damage, DAMAGE_TYPE_PHYSICAL, 0, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
    local eventTable = {}
    eventTable.attacker = ability.attacker
    eventTable.ability = ability.attacker:FindAbilityByName("q")
    eventTable.target = event.target
    eventTable.attack_damage = ability.damage
    BitingStar.attackLand(eventTable)
end

function createArrow(attacker, damage, enemy, target, ability, arrowParticle)
    local info =
    {
        Target = enemy,
        Source = target,
        Ability = ability,
        EffectName = arrowParticle,
        vSourceLoc= target:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,
        bProvidesVision = true,
        iVisionRadius = 0,
        iMoveSpeed = 900,
        iVisionTeamNumber = attacker:GetTeamNumber()
    }
    projectile = ProjectileManager:CreateTrackingProjectile(info)
end
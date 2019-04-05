require('heroes/crystal_maiden/init')
local FrostNova = require('heroes/crystal_maiden/abilities/q/q2_frost_nova')
local ArcaneShell = require('heroes/crystal_maiden/abilities/w/w1_arcane_shell')
local AmplifyMagic = require('heroes/crystal_maiden/abilities/w/w2_amplify_magic')
local RingOfFire = require('heroes/crystal_maiden/abilities/q2_arcana2_ring_of_fire')

function calculateDamage(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target

    ability.target = target

    Helper.initializeAbilityRunes(caster, 'sorceress', 'q')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'w')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'e')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'r')

    Filters:CastSkillArguments(2, caster)

    local arcane_explosion_damage = caster:FindAbilityByName("arcane_explosion"):GetLevelSpecialValueFor("damage", ability:GetLevel())
    arcane_explosion_damage = arcane_explosion_damage * T51_AMPLIFY * caster:GetMaxMana()/100

    if caster.w_4_level > 0 then
        arcane_explosion_damage = arcane_explosion_damage * (1 + SORCERESS_W4_AMPLIFY_PERCENT/100 * caster.w_4_level)
    end

    ability.manacost = event.mana_drain/5
    if caster:HasModifier("modifier_sorceress_glyph_7_2") then
        arcane_explosion_damage = arcane_explosion_damage * T72_DAMAGE_AMPLIFY
        ability.manacost = ability.manacost + caster:GetMaxMana() * T72_MANA_DRAIN_PERCENT/100
    end
    ability.damage = arcane_explosion_damage * T51_AMPLIFY
end

function toggle_on(event)
    local caster = event.caster
    local ability = caster:FindAbilityByName("arcane_explosion")
    if IsValidEntity(ability) then
        if caster:HasModifier("modifier_sorceress_arcana2") then
            RingOfFire.tryToCast(caster, ability, true)
        else
            FrostNova.tryToCast(caster, ability, true)
        end
    end
end

function think(event)
    local caster = event.caster
    local ability = event.ability
    local origin = caster:GetAbsOrigin()

    local manaDrain = math.min(ability.manacost, caster:GetMana())
    manaDrain = math.floor(manaDrain)
    caster:ReduceMana(manaDrain)

    if caster:GetMana() < manaDrain then
        ability:ToggleAbility()
    end


    local caster = event.caster
    local arc_exp_ability = caster:FindAbilityByName("arcane_explosion")
    if IsValidEntity(arc_exp_ability) then
        if caster:HasModifier("modifier_sorceress_arcana2") then
            RingOfFire.tryToCast(caster, arc_exp_ability, true)
        else
            FrostNova.tryToCast(caster, arc_exp_ability, true)
        end
    end

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

    if #enemies == 0 then
        return
    end

    local target = enemies[1]

    ArcaneShell.cast(caster, ability:GetLevel()/7)

    EmitSoundOn("Sorceress.ArcaneTorrentLaunch", caster)
    local info =
    {
        Target = target,
        Source = caster,
        Ability = ability,
        EffectName = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
        StartPosition = "attach_staff_tip",
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 5,
        bProvidesVision = false,
        iVisionRadius = 0,
        iMoveSpeed = 800,
        iVisionTeamNumber = caster:GetTeamNumber()
    }

    ProjectileManager:CreateTrackingProjectile(info)

end

function projectileHit(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local damage = ability.damage * caster:GetMana()/caster:GetMaxMana()

    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", target, 0.5)

    AmplifyMagic.cast(caster, target, ability)
end
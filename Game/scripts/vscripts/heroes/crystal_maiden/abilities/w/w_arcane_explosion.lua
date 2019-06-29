require('heroes/crystal_maiden/init')
local FrostNova = require('heroes/crystal_maiden/abilities/q/q2_frost_nova')
local ArcaneShell = require('heroes/crystal_maiden/abilities/w/w1_arcane_shell')
local AmplifyMagic = require('heroes/crystal_maiden/abilities/w/w2_amplify_magic')
local RingOfFire = require('heroes/crystal_maiden/abilities/q2_arcana2_ring_of_fire')

function cast(event)
    local caster = event.caster
    local ability = event.ability

    Helper.initializeAbilityRunes(caster, 'sorceress', 'q')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'w')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'e')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'r')

    local currentMana = caster:GetMana()
    local damage = event.damage / 100 * currentMana
    if caster.w_4_level > 0 then
        damage = damage * (1 + SORCERESS_W4_AMPLIFY_PERCENT / 100 * caster.w_4_level)
    end

    if caster:HasModifier("modifier_sorceress_glyph_7_2") then
        damage = damage * T72_DAMAGE_AMPLIFY
        caster:ReduceMana(caster:GetMaxMana() * T72_MANA_DRAIN_PERCENT / 100)
    end

    ability.damage = damage

    Filters:CastSkillArguments(2, caster)

    StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_CAST_ABILITY_1, rate = 2.4})
    local radius = event.radius
    local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
    local particle2 = ParticleManager:CreateParticle(particleNameS, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
    ParticleManager:SetParticleControl(particle2, 2, Vector(1.1, 1.1, 1.1))
    if not caster:HasModifier("modifier_ice_avatar") then
        ParticleManager:SetParticleControl(particle2, 4, Vector(255, 90, 255))
    else
        ParticleManager:SetParticleControl(particle2, 4, Vector(90, 130, 255))
    end
    Timers:CreateTimer(1.5, function()
        ParticleManager:DestroyParticle(particle2, false)
    end
)
ArcaneShell.cast(caster, 1)
if caster:HasModifier("modifier_sorceress_arcana2") then
    RingOfFire.tryToCast(caster, ability, false)
else
    FrostNova.tryToCast(caster, ability, false)
end
end

function projectileHit(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local damage = ability.damage
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)

    AmplifyMagic.cast(caster, target, ability)
end

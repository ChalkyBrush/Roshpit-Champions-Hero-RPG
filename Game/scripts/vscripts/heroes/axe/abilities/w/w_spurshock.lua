require('heroes/axe/init')
local Return = require('heroes/axe/abilities/w/w3_return')
local ThunderFoot = require('heroes/axe/abilities/w/w4_thunderfoot')
local DotDamage = require('heroes/axe/abilities/w/w1_dot_damage')
local ReduceMagicResist = require('heroes/axe/abilities/w/w2_reduce_magic_resist')
local Helix = require('heroes/axe/glyphs/t41_helix')
local WAmplify = require('heroes/axe/glyphs/t52_w_amplify')

local function createProjectile(ability, caster, shotVector, casterOrigin)
    local start_radius = 110
    local end_radius = 300
    local range = 800
    local speed = ability.speed
    if not speed then
        speed = 600
    end
    --EmitSoundOn("Hero_Magnataur.ShockWave.Particle", caster)
    local info =
    {
        Ability = ability,
        EffectName = "particles/units/heroes/hero_magnataur/red_general_shockwave.vpcf",
        vSpawnOrigin = casterOrigin,
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_origin",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit = false,
        vVelocity = shotVector * speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)
end

function start(event)
    local caster = event.caster
    local ability = event.ability
    local location = caster:GetOrigin() - caster:GetForwardVector()*Vector(-100, -100, 0)
    local abilityLevel = ability:GetLevel()

    Helper.initializeAbilityRunes(caster, 'axe', 'w')

    ability.speed = event.speed
    ability.damage = event.damage * ThunderFoot.getAmplify(caster) * WAmplify.getAmplify(caster)
    Helix.cast(caster,ability)

    local backVector = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi)

    if caster:HasModifier("modifier_axe_glyph_2_1") then
        for i = -4, 4, 1 do
            local shockVector = WallPhysics:rotateVector(backVector, (math.pi/4.5)*i)
            createProjectile(ability, caster, shockVector, location)
        end
    else
        for i = -1, 1, 1 do
            local shockVector = WallPhysics:rotateVector(backVector, (math.pi/6)*i)
            createProjectile(ability, caster, shockVector, location)
        end
    end

    Return.cast(caster, abilityLevel)

    Filters:CastSkillArguments(2, caster)
end

function projectileHit(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local damage = ability.damage

    if event.amp then
        damage = damage * event.amp
    end

    DotDamage.applyDebuff(target, caster, ability)
    ReduceMagicResist.applyDebuff(target, caster, ability)

    if caster:HasModifier("modifier_axe_glyph_1_2") then
        Filters:ApplyStun(caster, T12_STUN_DURATION, target)
    end
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
end
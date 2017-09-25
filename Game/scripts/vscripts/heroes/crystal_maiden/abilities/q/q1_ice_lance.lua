require('heroes/crystal_maiden/init')
local IceExplode = require('heroes/crystal_maiden/abilities/q/q3_ice_explode')
function cast(event)
    local caster = event.caster
    local ability = event.ability

    Helper.initializeAbilityRunes(caster, 'sorceress', 'a')

    --Timers:CreateTimer(0.3,function()
    local target = event.target_points[1]
    EmitSoundOn("Sorceress.IceLance", caster)
    local fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    local casterOrigin = caster:GetAbsOrigin()

    if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
        caster = caster.origCaster
        Helper.initializeAbilityRunes(caster, 'sorceress', 'a')
    end

    createProjectile(caster, fv, ability, Q1_ICE_LANCE_PROJECTILE, casterOrigin, 120)

    if caster:HasModifier("modifier_sorceress_glyph_2_1") then
        local rotatedFV = WallPhysics:rotateVector(fv, math.pi/10)
        createProjectile(caster, rotatedFV, ability, Q1_ICE_LANCE_PROJECTILE, casterOrigin, 120)
        rotatedFV = WallPhysics:rotateVector(fv, -math.pi/10)
        createProjectile(caster, rotatedFV, ability, Q1_ICE_LANCE_PROJECTILE, casterOrigin, 120)
    end
    Filters:CastSkillArguments(1, caster)

end

function createProjectile(caster, fv, ability, projectileParticle, casterOrigin, impactRadius)

    local start_radius = impactRadius
    local end_radius = impactRadius
    local range = 1800
    local speed = 1200

    local info =
    {
        Ability = ability,
        EffectName = projectileParticle,
        vSpawnOrigin = casterOrigin,
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        StartPosition = "attach_attack2",
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit = false,
        vVelocity = fv * speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)
end

function projectileHit(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    EmitSoundOn("hero_Crystal.projectileImpact", target)
    local damage = caster.a_a_level * Q1_ADD_DAMAGE + Q1_BASE_DAMAGE
    damage = damage*event.mult

    if Filters:IsIceFrozen(target) then
        local damageMult = 1
        if caster:HasModifier("modifier_sorceress_glyph_5_a") then
            damageMult = T5A_MULTIPLY
        end
        damage = damage * damageMult

        local particleName = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
        local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
        local origin = target:GetAbsOrigin()
        ParticleManager:SetParticleControl( particle1, 0, origin )
        ParticleManager:SetParticleControl( particle1, 1, origin )
        Timers:CreateTimer(1, function()
            ParticleManager:DestroyParticle(particle1, false)
        end)
    end

    local chance = Q3_CHANCE
    if caster:HasModifier("modifier_sorceress_glyph_2_2") then
        chance = T22_CHANCE
        damage = damage * T22_DAMAGE_AMPLIFY
    end

    local luck = RandomInt(1, 100)
    if chance > luck and caster.c_a_level > 0 then
        IceExplode.cast(caster, target, ability, damage)
    else
        Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
    end
end

function think(event)
    local caster = event.caster
    local blizzard = caster:FindAbilityByName("blizzard")
    if blizzard:GetCooldownTimeRemaining() < 0.1 then
        caster:RemoveModifierByName("modifier_blizzard_cooldown")
    end
end

require('heroes/crystal_maiden/init')
local IceExplode = require('heroes/crystal_maiden/abilities/q/q3_ice_explode')
function cast(event)
    local caster = event.caster
    local ability = event.ability

    Helper.initializeAbilityRunes(caster, 'sorceress', 'q')

    --Timers:CreateTimer(0.3,function()
    local target = event.target_points[1]
    EmitSoundOn("Sorceress.IceLance", caster)
    local fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    local casterOrigin = caster:GetAbsOrigin()

    if caster:HasModifier("modifier_sorceress_immortal_ice_avatar") then
        caster = caster.origCaster
        Helper.initializeAbilityRunes(caster, 'sorceress', 'q')
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
    local damage = caster.q_1_level * Q1_ADD_DAMAGE + Q1_BASE_DAMAGE
    damage = damage*event.mult

    

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/winter_wyvern_base_attack.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin()+Vector(0,0,70))
    ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin()+Vector(0,0,70))
    Timers:CreateTimer(0.1, function()
        ParticleManager:DestroyParticle(pfx, false)
    end)

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
        EmitSoundOn("Sorceress.IceFrozen.LanceHit", target)
    else
        EmitSoundOn("hero_Crystal.projectileImpact", target)
    end

    local chance = Q3_CHANCE
    if caster:HasModifier("modifier_sorceress_glyph_2_2") then
        chance = T22_CHANCE
        damage = damage * T22_DAMAGE_AMPLIFY
    end
    local chillStacks = 2
    if ability:GetAbilityName() == "blizzard" then
        damage = damage/2
        chillStacks = 1
    end
    lanceAbility = caster:FindAbilityByName("ice_lance")
    lanceAbility:ApplyDataDrivenModifier(caster, target, "modifier_ice_lance_cold", {duration = 3})
    local stacks = math.min(target:GetModifierStackCount("modifier_ice_lance_cold", caster) + chillStacks, 10)
    target:SetModifierStackCount("modifier_ice_lance_cold", caster, stacks)

    local luck = RandomInt(1, 100)
    if chance > luck and caster.q_3_level > 0 then
        IceExplode.cast(caster, target, ability, damage)
    else
        Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
    end
    
    if ability:GetAbilityName() == "ice_lance" then
        local blizzardAbility = caster:FindAbilityByName("blizzard")
        local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
        local shards = 0
        EmitSoundOn("Sorceress.IceLanceFracture", target)
        for i = 1, #enemies, 1 do
            local enemy = enemies[i]
            if enemy:GetEntityIndex() == target:GetEntityIndex() then
            else
                local info = 
                {
                    Target = enemy,
                    Source = enemy,
                    Ability = blizzardAbility,  
                    EffectName = "particles/roshpit/sorceress/ice_lance_fracture.vpcf",
                    vSourceLoc= target:GetAbsOrigin(),
                    bDrawsOnMinimap = false, 
                        bDodgeable = true,
                        bIsAttack = false, 
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        flExpireTime = GameRules:GetGameTime() + 4,
                    bProvidesVision = false,
                    iVisionRadius = 0,
                    iMoveSpeed = 720,
                    iVisionTeamNumber = caster:GetTeamNumber()
                }
                local projectile = ProjectileManager:CreateTrackingProjectile(info)
                shards = shards + 1

                if shards == 2 then
                    break
                end
            end
        end
    end
end

function think(event)
    local caster = event.caster
    local blizzard = caster:FindAbilityByName("blizzard")
    if blizzard:GetCooldownTimeRemaining() < 0.1 then
        caster:RemoveModifierByName("modifier_blizzard_cooldown")
    end
end

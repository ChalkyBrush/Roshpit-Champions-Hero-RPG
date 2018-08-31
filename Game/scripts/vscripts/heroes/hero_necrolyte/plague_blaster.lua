local constants = require('heroes/hero_necrolyte/constants')

function necrofusion_precast(event)
    local caster = event.caster
    StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_CAST_ABILITY_4, rate=2.3})
end

function cast_necrofusion(event)
    local caster = event.caster
    local ability = event.ability
    local damage = event.damage

    local target_point = event.target_points[1]
    local origin = caster:GetAbsOrigin()
    local direction = caster:GetForwardVector()

    local spellOrigin = origin+direction*80
    local range = event.range

    if caster:HasModifier("modifier_venomort_glyph_5_2") then
        range = range * (1 + constants.T52_RANGE_INCREASE_PERCENT/100)
    end
    local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/venomort/viper_channel_flare.vpcf", caster:GetAbsOrigin()+Vector(0,0,100), 1)
    ParticleManager:SetParticleControl(pfx, 1, Vector(40,40,40))
    ParticleManager:SetParticleControl(pfx, 2, Vector(18,18,18))
    local count = 1
    if caster:HasModifier("modifier_venomort_immortal_weapon_2") then
        count = constants.WEAPON2_FUSIONS_COUNT
    end

    for i = -(count - 1)/2,(count - 1)/2 do
        local fv = WallPhysics:rotateVector(caster:GetForwardVector(),2 * math.pi * i/18)
        local info =
        {
            Ability = ability,
            EffectName = "particles/units/heroes/hero_vengeful/venomort_rune_w_2_wave.vpcf",
            vSpawnOrigin = spellOrigin,
            fDistance = range,
            fStartRadius = 120,
            fEndRadius = 120,
            Source = caster,
            StartPosition = "attach_attack2",
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 6,
            bDeleteOnHit = true,
            vVelocity = fv * 1000,
            bProvidesVision = false,
        }
        ProjectileManager:CreateLinearProjectile(info)
    end

    local w1_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 1)
    if w1_level then
        damage = damage + w1_level * constants.W1_DAMAGE_PER_HP_PERCENT/100 * caster:GetHealth()
    end
    ability.w_damage = damage

    local w3_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 1)
    ability.w3_level = w3_level


    if caster:HasModifier("modifier_venomort_glyph_5_1") then
        ability.w3_level = ability.w3_level * constants.T51_AMPLIFY_W3
    end

    local w2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 1)
    local w2_duration = w2_level * constants.W2_DURATION

    local modifier = caster:FindModifierByName("modifier_venomort_glyph_1_2")
    if modifier then
        w2_duration = w2_duration * (1 + constants.T12_DURATION_INCREASE_PERCENT/100)
    end

    ability.w2_level = w2_level
    ability.w2_duration = w2_duration



    Filters:CastSkillArguments(2, caster)

end
function projectile_hit(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local damage = ability.w_damage
    local duration = constants.W_DURATION

    ability:ApplyDataDrivenModifier(caster, target, "modifier_necrofusion_slowed", {duration = duration})

    if caster:HasModifier("modifier_venomort_immortal_weapon_2") then
        Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_POISON, RPC_ELEMENT_GHOST)
    else
        Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_POISON, RPC_ELEMENT_GHOST)
    end
    if ability.w2_level > 0 then
        local luck = RandomInt(1,100)
        if luck < constants.W2_CHANCE then
            demoralize(caster, ability, target, ability.w2_duration)
        end
    end

    ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_stats_give", nil)
end

function demoralize(caster, ability, target, duration)
    if target:FindModifierByName('modifier_venomort_demoralize_immune') then
        return
    end

    ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_demoralize", {duration = duration})
    ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_demoralize_immune", {duration = duration + constants.W2_IMMUNE_DURATION})
end

function demoralize_think(event)
    local caster = event.target
    local position = caster:GetAbsOrigin()
    local randomPosition = position+RandomVector(1000)
    caster:MoveToPosition( randomPosition )
end

function demoralize_end(event)
    local caster = event.target
    caster:Stop()
end

function increase_w3_stacks(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_bonus_stats", nil)
    local modifier = caster:FindModifierByName('modifier_venomort_bonus_stats')
    local stacks = modifier:GetStackCount() + 1 * ability.w3_level

    local bossesCountAs = constants.BOSSES_COUNT_AS_ENEMIES
    local paragonsCountAs = constants.PARAGONS_COUNT_AS_ENEMIES
    if caster:HasModifier("modifier_venomort_glyph_2_1") then
        bossesCountAs = constants.T21_BOSSES_COUNT_AS_ENEMIES
        paragonsCountAs = constants.T21_PARAGONS_COUNT_AS_ENEMIES
    end

    if target.mainBoss then
        stacks = stacks + (bossesCountAs - 1) * ability.w3_level
    end
    if target.paragon then
        stacks = stacks + (paragonsCountAs - 1) * ability.w3_level
    end

    modifier:SetStackCount(stacks)
end

function decrease_w3_stacks(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_bonus_stats", nil)
    local modifier = caster:FindModifierByName('modifier_venomort_bonus_stats')
    local stacks = modifier:GetStackCount() - 1 * ability.w3_level

    local bossesCountAs = constants.BOSSES_COUNT_AS_ENEMIES
    local paragonsCountAs = constants.PARAGONS_COUNT_AS_ENEMIES
    if caster:HasModifier("modifier_venomort_glyph_2_1") then
        bossesCountAs = constants.T21_BOSSES_COUNT_AS_ENEMIES
        paragonsCountAs = constants.T21_PARAGONS_COUNT_AS_ENEMIES
    end

    if target.mainBoss then
        stacks = stacks - (bossesCountAs - 1) * ability.w3_level
    end
    if target.paragon then
        stacks = stacks - (paragonsCountAs - 1) * ability.w3_level
    end

    stacks = math.max(0, stacks)
    modifier:SetStackCount(stacks)
end
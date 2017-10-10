require('heroes/crystal_maiden/init')
local function summon(caster, ability, origin)
    local runesCount = caster.b_c_level
    if runesCount == nil or runesCount <= 0 then
        return
    end


    local baseDamage = E2_BASE_DAMAGE + runesCount * E2_ADD_DAMAGE
    local summonPosition = origin
    local health = E2_HEALTH_AMPLIFY * caster:GetMaxHealth()

    if caster.waterElemental then
        caster.waterElemental:SetBaseDamageMin(baseDamage)
        caster.waterElemental:SetBaseDamageMax(baseDamage)
        caster.waterElemental:Heal(health, caster.waterElemental)
        FindClearSpaceForUnit(caster.waterElemental, summonPosition, true)
        return
    end

    caster.waterElemental = CreateUnitByName("sorc_water_elemental", summonPosition, true, caster, caster, caster:GetTeamNumber())
    caster.waterElemental.creator = caster
    caster.waterElemental.owner = caster:GetPlayerOwnerID()
    caster.waterElemental:SetOwner(caster)
    caster.waterElemental:FindAbilityByName("sorc_elemental_ability"):SetLevel(1)
    caster.waterElemental:SetControllableByPlayer(caster:GetPlayerID(), true)

    local aiAbility = caster.waterElemental:FindAbilityByName("hero_summon_ai")
    aiAbility:ToggleAbility()

    -- local aspectAbility = caster.earthAspect:FindAbilityByName("aspect_abilities")
    -- aspectAbility:SetLevel(1)
    -- aspectAbility:ApplyDataDrivenModifier(caster.earthAspect, caster.earthAspect, "modifier_aspect_main", {})

    local waterParticle = "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf"
    local pfx = ParticleManager:CreateParticle( waterParticle, PATTACH_CUSTOMORIGIN, caster.waterElemental )
    ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster.waterElemental:GetAbsOrigin(), true)

    EmitSoundOn("Hero_Morphling.AdaptiveStrike.Cast", caster.waterElemental)

    ability:ApplyDataDrivenModifier(caster, caster.waterElemental, "modifier_water_elemental", {})
    if caster:HasModifier("modifier_sorceress_glyph_4_1") then
        ability:ApplyDataDrivenModifier(caster, caster.waterElemental, "modifier_water_elemental_4_1_enchancement", {})
    end

    local armor = E2_ARMOR_AMPLIFY * caster:GetPhysicalArmorValue()

    Timers:CreateTimer(0.05, function()
        caster.waterElemental:SetMaxHealth(health)
        caster.waterElemental:SetBaseMaxHealth(health)
        caster.waterElemental:SetHealth(health)
        caster.waterElemental:Heal(health, caster.waterElemental)
        caster.waterElemental:SetBaseDamageMin(baseDamage)
        caster.waterElemental:SetBaseDamageMax(baseDamage)
        caster.waterElemental:SetPhysicalArmorBaseValue(armor)
    end)

end

function die(event)
    event.caster.creator.waterElemental = false
end

function attack(event)
    local attacker
    if (event.attacker ~= nil) then
        attacker = event.attacker
    else
        attacker = event.caster
    end
    local target = event.target
    local creator = attacker.creator
    local particleName = "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    local origin = target:GetAbsOrigin()
    ParticleManager:SetParticleControl( particle1, 0, origin )
    ParticleManager:SetParticleControl( particle1, 1, origin )
    Timers:CreateTimer(3, function()
        ParticleManager:DestroyParticle(particle1, false)
    end)
    -- EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target", caster)
    local damage = attacker:GetAverageTrueAttackDamage(attacker)
    if creator.d_c_level then
        damage = damage * (1 + E4_AMPLIFY_PERCENT/100 * creator:GetAverageTrueAttackDamage(creator))
    end
    local frozenDamage = damage
    if creator.c_c_level > 0 then
        frozenDamage = damage * (1 + E3_AMPLIFY_PERCENT/100 * creator.c_c_level)
    end

    local attacksFreeze = false
    if creator:HasModifier('modifier_sorceress_glyph_1_2') then
        attacksFreeze = true
    end

    local radius = 390
    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local slowDuration = 1.2
    local ability = attacker:FindAbilityByName('sorc_elemental_ability')
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
            local luck = RandomInt(1, 100)
            if attacksFreeze and luck <= T12_CHANCE then
                ability:ApplyDataDrivenModifier(attacker, enemy, "modifier_elemental_freeze", {duration = T12_DURATION})
            end

            local finalDamage = damage
            if Filters:IsIceFrozen(enemy) then
                finalDamage = frozenDamage
            end
            Filters:TakeArgumentsAndApplyDamage(enemy, creator, finalDamage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
            ability:ApplyDataDrivenModifier(attacker, enemy, "modifier_elemental_slow", {duration = slowDuration})
        end
    end
    if creator.d_c_level > 0 then
        local luck = RandomInt(1, 100)
        if luck < creator.d_c_level then
            createProjectile(attacker, target, ability)
        end
    end
end

function createProjectile(attacker, enemy, ability)
    StartAnimation(attacker, {duration=0.6, activity=ACT_DOTA_ATTACK, rate=1.8})
    local info =
    {
        Target = enemy,
        Source = attacker,
        Ability = ability,
        EffectName = "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
        vSourceLoc= attacker:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 5,
        bProvidesVision = true,
        iVisionRadius = 0,
        iMoveSpeed = 1400,
        iVisionTeamNumber = attacker:GetTeamNumber()
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

local module = {}
module.summon = summon
return module
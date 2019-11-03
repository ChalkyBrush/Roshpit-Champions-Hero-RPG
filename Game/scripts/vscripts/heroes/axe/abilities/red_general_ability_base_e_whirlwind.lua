require("heroes/axe/red_general_constants")
local Helper = require("heroes/util/helper")
local ImmortalWeapon2 = require('heroes/axe/weapons/immortal_weapon_2')

function red_general_ability_base_q_whirlwind_start(event)
    local hero = event.caster
    local ability = event.ability

    Helper.initializeAbilityRunes(hero, 'axe', 'e')

    hero.oldEposition = hero:GetAbsOrigin()
    ability.forwardVec = hero:GetForwardVector()
    ability.interval = 0

    red_general_rune_base_e_2_applyBuff(hero, ability)

    red_general_rune_base_e_4_applyShield(hero, ability)

    if not hero:HasModifier("modfier_axe_jumping") then
        StartAnimation(hero, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.1})
    else
        StartAnimation(hero, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.1})
    end

    ability:ApplyDataDrivenModifier(hero, hero, "modifier_whirlwind_attack_range", {duration = 1.5})
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_whirlwind", {duration = 1.5})
    ImmortalWeapon2.applyBuff(hero, 1.5)
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_whirlwind_flying_portion", {duration = 4.0})

    Filters:CastSkillArguments(3, hero)
    local movespeedBase = hero:GetBaseMoveSpeed()
    local movespeed = hero:GetMoveSpeedModifier(movespeedBase, false)
    ability.forwardVelocity = math.max(movespeed / 21, 20)

    ability.enemies = {}

end

function red_general_ability_base_q_whirlwind_onSpecificIntervalThink(ability, caster, position, heal)
    Filters:CleanseStuns(caster)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, RED_GENERAL_E_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    ability.enemies = enemies
    if #enemies > 0 then
        Filters:ApplyHeal(caster, caster, heal * #enemies, true, false)
        red_general_rune_base_e_3_damageEnemies(caster, enemies)
    end
end

function red_general_ability_base_q_whirlwind_think(event)
    local ability = event.ability
    local interval = ability.interval
    local hero = event.caster
    local position = hero:GetAbsOrigin()
    position = GetGroundPosition(position, hero)

    if ability.interval > 40 then
        ability.forwardVelocity = ability.forwardVelocity * 0.9
    end
    local forwardVelocity = ability.forwardVelocity

    if hero:HasModifier("modfier_axe_jumping") then
        forwardVelocity = 0
    end
    hero.EFV = hero:GetForwardVector()

    local tickForInterval = 6
    if hero:HasModifier("modifier_axe_glyph_3_1") then
        tickForInterval = tickForInterval * RED_GENERAL_GLYPH_3_1_E_INTERVAL_REDUCTION
    end

    if interval % tickForInterval == 0 then
        local heal = event.heal
        red_general_ability_base_q_whirlwind_onSpecificIntervalThink(ability, hero, position, heal)
    end

    if interval % 13 == 0 then
        if not hero:HasModifier("modfier_axe_jumping") then
            StartAnimation(hero, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1.1})
        end
        -- hero:StartGesture(ACT_DOTA_CAST_ABILITY_3)
        EmitSoundOn("RedGeneral.Whirlwind", hero)
        CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", hero, 2)
    end
    if hero:HasModifier("modifier_whirlwind_flying_portion") then
        local newPosition = position + hero.EFV * 40
        local afterWallPosition = WallPhysics:WallSearch(hero:GetAbsOrigin(), newPosition, hero)
        if newPosition.x == afterWallPosition.x and newPosition.y == afterWallPosition.y then
        else
            hero:SetAbsOrigin(hero:GetAbsOrigin() - hero.EFV * 50)
            hero:RemoveModifierByName("modifier_whirlwind_flying_portion")
        end
    end
    if not hero:HasModifier("modfier_axe_jumping") then
        --        hero:SetOrigin(newPosition)
        if #ability.enemies > 0 then
            for _, enemy in pairs(ability.enemies) do
                if IsValidEntity(enemy) then
                    if not enemy.pushLock and not enemy.jumpLock and not enemy.dummy then
                        local enemyPosition = enemy:GetAbsOrigin() + hero:GetAbsOrigin() - hero.oldEposition
                        enemy:SetAbsOrigin(enemyPosition)
                    end
                end
            end
        end
    end
    hero.oldEposition = hero:GetAbsOrigin()

    ability.forwardVec = ((ability.forwardVec * 3 + hero:GetForwardVector()) / 4):Normalized()

    ability.interval = ability.interval + 1
end

function red_general_ability_base_q_whirlwind_finish(event)
    local ability = event.ability
    local hero = event.caster
    hero.EFV = false
    if not hero:HasModifier("modfier_axe_jumping") then
        hero:RemoveModifierByName("modifier_whirlwind_flying_portion")
        FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
    end
    if #ability.enemies > 0 then
        for _, enemy in pairs(ability.enemies) do
            if not enemy.pushLock and not enemy.jumpLock then
                local enemyPosition = enemy:GetAbsOrigin()
                local afterWallPosition = WallPhysics:WallSearch(hero:GetAbsOrigin(), enemyPosition, hero)
                if afterWallPosition ~= enemyPosition then
                    enemyPosition = afterWallPosition
                end
                FindClearSpaceForUnit(enemy, enemyPosition, false)

            end
        end
    end
end

function red_general_rune_base_e_1_think(event)
    local caster = event.caster
    Helper.initializeAbilityRunes(caster, 'axe', 'e')
    local runesCount = caster.e_1_level

    if caster.e_1_level <= 0 then
        return
    end

    local stacks = math.floor(20 - 20 * (caster:GetHealth() / caster:GetMaxHealth()))
    local runeAbility = caster.runeUnit:FindAbilityByName("axe_rune_e_1")

    if stacks > 0 then
        runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_e_1_visible", {})
        caster:SetModifierStackCount("modifier_axe_rune_e_1_visible", runeAbility, stacks)
        runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_e_1_invisible", {})
        caster:SetModifierStackCount("modifier_axe_rune_e_1_invisible", runeAbility, stacks * runesCount)
    else
        caster:RemoveModifierByName("modifier_axe_rune_e_1_visible")
        caster:RemoveModifierByName("modifier_axe_rune_e_1_invisible")
    end
end

function red_general_rune_base_e_2_applyBuff(caster, ability)
    if caster.e_2_level > 0 then
        local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_e_2_tornado", {duration = b_c_duration})
        caster:SetModifierStackCount("modifier_axe_rune_e_2_tornado", caster, caster.e_2_level)
    end
end

function red_general_rune_base_e_2_refreshBuff(caster)
    if caster:HasModifier("modifier_axe_rune_e_2_tornado") then
        local whirlwindAbility = caster:FindAbilityByName("red_general_ability_base_e_whirlwind")
        local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 5, false)
        whirlwindAbility:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_e_2_tornado", {duration = b_c_duration})
    end
end

function red_general_rune_base_e_3_damageEnemies(caster, enemies)
    if caster.e_3_level > 0 then
        local damage = caster.e_3_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * RED_GENERAL_E3_DAMAGE_PERCENT / 100
        for _, enemy in pairs(enemies) do
            local damageWithWeapon = damage * ImmortalWeapon2.getAmp(caster, enemy)
            Filters:TakeArgumentsAndApplyDamage(enemy, caster, damageWithWeapon, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
            EmitSoundOn("RedGeneral.HitSpin", enemy)
            CustomAbilities:QuickParticleAtPoint("particles/roshpit/solunia/boomerang_impact.vpcf", enemy:GetAbsOrigin() + Vector(0, 0, 100), 0.5)
        end
    end
end

function red_general_rune_base_e_4_applyShield(caster, ability)
    if caster.e_4_level > 0 then
        local duration = Filters:GetAdjustedBuffDuration(caster, RED_GENERAL_E4_DURATION, false)
        local procChance = RED_GENERAL_E4_PROC_CHANCE
        if caster:HasModifier("modifier_axe_glyph_6_2") then
            procChance = RED_GENERAL_GLYPH_6_2_SHIELD_CHANCE_PERCENT
        end
        local shieldsCount = Runes:Procs(caster.e_4_level, procChance, 1)
        --print("runes count " .. caster.e_4_level)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_e_4_shield", {duration = duration})
        caster:SetModifierStackCount("modifier_axe_rune_e_4_shield", caster, shieldsCount)
    end
end

function red_general_rune_base_e_4_amplifyShieldsCount(caster, ability, amplify)
    local shieldsCount = caster:GetModifierStackCount("modifier_axe_rune_e_4_shield", ability)
    shieldsCount = shieldsCount * amplify
    caster:SetModifierStackCount("modifier_axe_rune_e_4_shield", caster, shieldsCount)
end
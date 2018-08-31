require('heroes/axe/init')
local CycloneStorm = require('heroes/axe/abilities/e/e2_cyclone_storm')
local CyclonicShield = require('heroes/axe/abilities/e/e4_cyclonic_shield')
local WhirlwindDamage = require('heroes/axe/abilities/e/e3_whirlwind_damage')
local ImmortalWeapon2 = require('heroes/axe/weapons/immortal_weapon_2')

function start(event)
    local hero =  event.caster
    local ability = event.ability

    Helper.initializeAbilityRunes(hero, 'axe', 'e')

    hero.oldEposition = hero:GetAbsOrigin()
    ability.forwardVec = hero:GetForwardVector()
    ability.interval = 0

    CycloneStorm.applyBuff(hero, ability)
    CyclonicShield.applyShield(hero, ability)
    if not hero:HasModifier("modfier_axe_jumping") then
        StartAnimation(hero, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.1})
    else
        StartAnimation(hero, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.1})
    end

    ability:ApplyDataDrivenModifier(hero, hero, "modifier_whirlwind", {duration = 1.5})
    ImmortalWeapon2.applyBuff(hero, 1.5)
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_whirlwind_flying_portion", {duration = 4.0})

    Filters:CastSkillArguments(3, hero)
    local movespeedBase = hero:GetBaseMoveSpeed()
    local movespeed = hero:GetMoveSpeedModifier(movespeedBase)
    ability.forwardVelocity = math.max(movespeed/21, 20)

    ability.enemies = {}


end

local function onSpecificIntervalThink(ability, caster, position, heal)
    Filters:CleanseStuns(caster)
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
    ability.enemies = enemies
    if #enemies > 0 then
        Filters:ApplyHeal(caster, caster, heal * #enemies, true,false)
        WhirlwindDamage.damageEnemies(caster, enemies)
    end
end

function think(event)
    local ability = event.ability
    local interval = ability.interval
    local hero = event.caster
    local position = hero:GetAbsOrigin()
    position = GetGroundPosition( position, hero )

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
        tickForInterval = 3
    end

    if interval % tickForInterval == 0 then
        local heal = event.heal
        onSpecificIntervalThink(ability, hero, position, heal)
    end

    if interval % 13 == 0 then
        if not hero:HasModifier("modfier_axe_jumping") then
            StartAnimation(hero, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.1})
        end
        -- hero:StartGesture(ACT_DOTA_CAST_ABILITY_3)
        EmitSoundOn("RedGeneral.Whirlwind", hero)
        CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", hero, 2)
    end
    if hero:HasModifier("modifier_whirlwind_flying_portion") then
       local newPosition = position+hero.EFV*40
       local afterWallPosition = WallPhysics:WallSearch(hero:GetAbsOrigin(), newPosition, hero)
        if newPosition.x == afterWallPosition.x and newPosition.y == afterWallPosition.y then
        else
            hero:SetAbsOrigin(hero:GetAbsOrigin()-hero.EFV*50)
            hero:RemoveModifierByName("modifier_whirlwind_flying_portion")
        end
    end
    if not hero:HasModifier("modfier_axe_jumping") then
--        hero:SetOrigin(newPosition)
        if #ability.enemies > 0 then
            for _,enemy in pairs(ability.enemies) do
                if not enemy.pushLock and not enemy.jumpLock then
                    local enemyPosition = enemy:GetAbsOrigin() + hero:GetAbsOrigin() - hero.oldEposition
                    enemy:SetAbsOrigin(enemyPosition)
                end
            end
        end
    end
    hero.oldEposition = hero:GetAbsOrigin()

    ability.forwardVec = ((ability.forwardVec*3+hero:GetForwardVector())/4):Normalized()

    ability.interval = ability.interval + 1
end

function finish(event)
    local ability = event.ability
    local hero = event.caster
    hero.EFV = false
    if not hero:HasModifier("modfier_axe_jumping") then
        hero:RemoveModifierByName("modifier_whirlwind_flying_portion")
        FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
    end
    if #ability.enemies > 0 then
        for _,enemy in pairs(ability.enemies) do
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
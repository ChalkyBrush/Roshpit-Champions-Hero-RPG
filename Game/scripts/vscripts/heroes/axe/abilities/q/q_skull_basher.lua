require('heroes/axe/init')
local BrutalExpansion = require('heroes/axe/abilities/q/q1_brutal_expansion')
local HeroicLeap = require('heroes/axe/abilities/q/q3_heroic_leap')
local ReduceResist = require('heroes/axe/abilities/q/q4_reduce_resist')
local CycloneStorm = require('heroes/axe/abilities/e/e2_cyclone_storm')

function start(event)
    local caster = event.caster
    local ability = event.ability
    local abilityLevel = ability:GetLevel()
    --ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)
    ability.jump_level = 0

    Filters:CastSkillArguments(1, caster)

    Helper.initializeAbilityRunes(caster, 'axe', 'q')

    EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)
    EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)

    local targetPoint = event.target_points[1]
    local distance = WallPhysics:GetDistance2d(targetPoint * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))
    ability.jumpFV = ((targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
    if distance >= 300 then
        ability:ApplyDataDrivenModifier(caster, caster, "modfier_axe_jumping", {duration = 8})
    else
        drop(event)
    end

    local animationTime = math.min(500 / distance, 1)
    StartAnimation(caster, {duration = jumpDuration, activity = ACT_DOTA_FLAIL, rate = animationTime, translate = "forcestaff_friendly"})

    local extraHeight = math.max(GetGroundHeight(targetPoint, caster) - caster:GetAbsOrigin().z, 0)
    ability.jump_velocity = math.max(distance / 30 + 5 + extraHeight / 14, 15)
    if caster:HasModifier("modifier_whirlwind") then
        ability.jump_velocity = ability.jump_velocity + 5
    end
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    ability.jumpAnimated = false
    Timers:CreateTimer(0.3, function()
        ability.lifting = false
    end)
    --print("--NEW JUMP--")

    if caster:HasModifier("modifier_axe_glyph_7_1") then
        local newCD = RED_GENERAL_GLYPH_7_1_Q_CD
        ability:EndCooldown()
        ability:StartCooldown(newCD)
    end
end

function heroic_leap_think(event)
    local caster = event.caster
    local ability = event.ability

    local forwardSpeed = math.max(20, ability.distance / 55 + 24)
    if caster.q_3_level > 0 then
        forwardSpeed = math.max(20, ability.distance / 45 + 9)
    end

    if caster:HasModifier("modifier_axe_rune_q_2_invisible") then
        local modifierDuration = caster:FindModifierByName("modifier_axe_rune_q_2_visible"):GetRemainingTime()
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_visible", {duration = modifierDuration})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_invisible", {duration = modifierDuration})
    end
    CycloneStorm.refreshBuff(caster)

    local jumpToPosition = caster:GetAbsOrigin() + Vector(0, 0, ability.jump_velocity) + (ability.jumpFV * forwardSpeed)
    local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), jumpToPosition, caster)
    if afterWallPosition ~= jumpToPosition then
        jumpToPosition = caster:GetAbsOrigin() + Vector(0, 0, ability.jump_velocity)
    end
    caster:SetOrigin(jumpToPosition)
    caster:SetForwardVector(ability.jumpFV)
    ability.jump_velocity = ability.jump_velocity - 3.3

    if caster:GetAbsOrigin().z < (GetGroundHeight(caster:GetAbsOrigin(), caster) + math.abs(ability.jump_velocity) + 20) and not ability.lifting then
        caster:RemoveModifierByName("modfier_axe_jumping")
        caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))
        -- elseif caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 54 and not ability.lifting then
        -- if not ability.jumpAnimated then
        -- EndAnimation(caster)
        -- Timers:CreateTimer(0.03, function()
        -- StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_FORCESTAFF_END, rate=1.0})
        -- end)
        -- ability.jumpAnimated = true
        -- end
    end
end

function drop(event)
    local caster = event.caster
    local ability = event.ability
    local location = caster:GetAbsOrigin()

    -- Timers:CreateTimer(0.06, function()
    --     -- EndAnimation(caster)
    --     FindClearSpaceForUnit(caster, location, false)
    -- end)

    caster:RemoveModifierByName("modifier_whirlwind_flying_portion")

    local skullBasherDuration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_stun_attack", {duration = skullBasherDuration})

    if not HeroicLeap.cast(caster, ability) then
        StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_FORCESTAFF_END, rate = 1})
    end
    FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function attackLand(event)
    local caster = event.attacker
    local ability = event.ability
    local hero = caster
    local abilityLevel = ability:GetLevel()

    local targetUnit = event.target
    local position = targetUnit:GetAbsOrigin()
    local stun_duration = event.duration
    local aoe_damage = event.aoe_damage
    aoe_damage = aoe_damage + BrutalExpansion.getAdditionalDamage(caster);
    if caster:HasModifier("modifier_axe_glyph_5_1") then
        aoe_damage = aoe_damage * RED_GENERAL_GLYPH_5_1_Q_DAMAGE_AMP
        stun_duration = RED_GENERAL_GLYPH_5_1_Q_STUN
    end
    local base_radius = event.base_radius

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetUnit:GetAbsOrigin(), nil, base_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
        local dealDamage = not caster:HasModifier("modifier_axe_glyph_7_1")
        for _, enemy in pairs(enemies) do
            Filters:ApplyStun(caster, stun_duration, enemy)
            if dealDamage then
                Filters:TakeArgumentsAndApplyDamage(enemy, caster, aoe_damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
            end

            ReduceResist.applyDebuff(caster, enemy, ability)
            --ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
        end
    end
    EmitSoundOn("Hero_ElderTitan.EchoStomp", targetUnit)
end

local function isActive(caster)
    return caster:HasModifier("modifier_stun_attack")
end

local module = {}
module.isActive = isActive
return module

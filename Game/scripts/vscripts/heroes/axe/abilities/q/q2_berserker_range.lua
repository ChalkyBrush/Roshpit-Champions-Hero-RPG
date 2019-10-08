require('heroes/axe/init')
local SkullBasher = require('heroes/axe/abilities/q/q_skull_basher')
function attackLand(event, q2_think)
    local caster = event.caster
    local ability = event.ability
    local target = event.target

    Helper.initializeAbilityRunes(caster, 'axe', 'q')
    local runesCount = caster.q_2_level

    if runesCount <= 0 then
        return
    end
    local duration = Filters:GetAdjustedBuffDuration(caster, RED_GENERAL_Q2_DURATION, false)

    local stacksGain = 1

    if caster:HasModifier("modifier_axe_glyph_3_2") and (target.mainBoss or target.bossStatus) then
        stacksGain = RED_GENERAL_GLYPH_3_2_STACKS_GAIN
    end

    local maxStacksCount = RED_GENERAL_Q2_MAX_STACKS_COUNT

    if caster:HasModifier("modifier_axe_glyph_7_2") then
        if SkullBasher.isActive(caster) then
            stacksGain = stacksGain * RED_GENERAL_GLYPH_7_2_AMP_STACKS_PER_ATTACK
        end
        maxStacksCount = RED_GENERAL_GLYPH_7_2_MAX_STACKS_COUNT
    end

    local visibleModifier = "modifier_axe_rune_q_2_visible"
    local currentStacks = caster:GetModifierStackCount(visibleModifier, caster)
    local newStacks = math.min(currentStacks + stacksGain, maxStacksCount)

    local halfOfStacks = math.floor(maxStacksCount / 2)
    if q2_think then
        local modifier = caster:FindModifierByName("modifier_axe_rune_q_2_visible")
        local modifierDuration = 0
        if modifier then
            modifierDuration = modifier:GetRemainingTime()
        end

        if currentStacks > halfOfStacks and modifierDuration >= 1 then
            return
        end
        if currentStacks <= newStacks or modifierDuration < 1 then
            newStacks = halfOfStacks
        end
    end

    ability:ApplyDataDrivenModifier(caster, caster, visibleModifier, {duration = duration})
    caster:SetModifierStackCount(visibleModifier, caster, newStacks)
    local invisibleModifier = "modifier_axe_rune_q_2_invisible"
    ability:ApplyDataDrivenModifier(caster, caster, invisibleModifier, {duration = duration})
    caster:SetModifierStackCount(invisibleModifier, caster, newStacks * runesCount)
end

function q2_think(event)
    if event.caster:HasModifier("modifier_axe_glyph_7_2") then
        attackLand(event, true)
    end
end

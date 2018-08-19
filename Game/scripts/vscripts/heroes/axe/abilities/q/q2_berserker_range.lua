require('heroes/axe/init')
local SkullBasher = require('heroes/axe/abilities/q/q_skull_basher')
function attackLand(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target

    Helper.initializeAbilityRunes(caster, 'axe', 'q')
    local runesCount = caster.q_2_level

    if runesCount <= 0 then
        return
    end
    local duration = Filters:GetAdjustedBuffDuration(caster, Q2_DURATION, false)

    local stacksGain = 1

    if caster:HasModifier("modifier_axe_glyph_3_2") and (target.mainBoss or target.bossStatus) then
        stacksGain = T32_STACKS_GAIN
    end

    local maxStacksCount = Q2_MAX_STACKS_COUNT

    if caster:HasModifier("modifier_axe_glyph_7_2") and SkullBasher.isActive(caster) then
        stacksGain = stacksGain * T72_AMP_STACKS_PER_ATTACK
        maxStacksCount = T72_MAX_STACKS_COUNT
    end

    local visibleModifier = "modifier_axe_rune_q_2_visible"
    local newStacks = math.min(caster:GetModifierStackCount(visibleModifier, caster) + stacksGain, maxStacksCount)

    ability:ApplyDataDrivenModifier(caster, caster, visibleModifier, {duration = duration})
    caster:SetModifierStackCount(visibleModifier, caster, newStacks)

    local invisibleModifier =  "modifier_axe_rune_q_2_invisible"
    ability:ApplyDataDrivenModifier(caster, caster, invisibleModifier, {duration = duration})
    caster:SetModifierStackCount(invisibleModifier, caster, newStacks * runesCount)
end
local function applyImmune(caster, target, ability, modifier, duration)
    target:RemoveModifierByName(modifier .. '_immune_stacks')
    ability:ApplyDataDrivenModifier(caster, target, modifier .. '_immune', {duration = duration})
end
local function targetHasImmune(target, modifier)
    return target:HasModifier(modifier .. '_immune')
end
local function shouldApplyImmune(caster, target, modifier, maxDuration)
    local currentStacks = target:GetModifierStackCount(modifier .. '_immune_stacks', caster)
    if currentStacks == nil then
        return false
    end
    return currentStacks >= maxDuration * 10
end
local function addEffectDuration(caster, target, ability, modifier, duration)
    local currentStacks = target:GetModifierStackCount(modifier .. '_immune_stacks', caster)
    ability:ApplyDataDrivenModifier(caster, target, modifier .. '_immune_stacks', {duration = duration + 3})
    target:SetModifierStackCount(modifier .. '_immune_stacks', caster, currentStacks + duration * 10)
end

local module = {}
module.applyImmune = applyImmune
module.targetHasImmune = targetHasImmune
module.shouldApplyImmune = shouldApplyImmune
module.addEffectDuration = addEffectDuration
return module

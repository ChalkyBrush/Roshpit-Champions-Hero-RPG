function updateStackModier(target, caster, ability, modifierName, duration, maxStacksCount, multiplyForInvisibleModifier)
    local visibleModifier = "modifier_" .. modifierName .. "_visible"
    local newStacks = math.min(target:GetModifierStackCount(visibleModifier, caster) + 1, maxStacksCount)

    target:RemoveModifierByName(visibleModifier)
    ability:ApplyDataDrivenModifier(caster, target, visibleModifier, {duration = duration})
    target:SetModifierStackCount(visibleModifier, caster, newStacks)

    if multiplyForInvisibleModifier == nill or multiplyForInvisibleModifier <= 0 then
        return
    end

    local invisibleModifier =  "modifier_" .. modifierName .. "_invisible"
    target:RemoveModifierByName(invisibleModifier)
    ability:ApplyDataDrivenModifier(caster, target, invisibleModifier, {duration = duration})
    target:SetModifierStackCount(invisibleModifier, caster, newStacks * multiplyForInvisibleModifier)
end

local module = {}
module.updateStackModier = updateStackModier;
return module
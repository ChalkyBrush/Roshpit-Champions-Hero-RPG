local function updateStackModifier(target, caster, ability, modifierName, duration, maxStacksCount, multiplyForInvisibleModifier)
    local visibleModifier = "modifier_" .. modifierName .. "_visible"
    local newStacks = 0
    if maxStacksCount ~=1 then
        newStacks = math.min(target:GetModifierStackCount(visibleModifier, caster) + 1, maxStacksCount)
    else
        newStacks = 1
    end

    ability:ApplyDataDrivenModifier(caster, target, visibleModifier, {duration = duration})
    target:SetModifierStackCount(visibleModifier, caster, newStacks)

    if multiplyForInvisibleModifier == nil or multiplyForInvisibleModifier <= 0 then
        return
    end

    local invisibleModifier =  "modifier_" .. modifierName .. "_invisible"
    ability:ApplyDataDrivenModifier(caster, target, invisibleModifier, {duration = duration})
    target:SetModifierStackCount(invisibleModifier, caster, newStacks * multiplyForInvisibleModifier)
end

local function initializeAbilityRunes(caster, casterName, abilityLetter)
    local runeLetters = {}
    runeLetters[1] = 'a'
    runeLetters[2] = 'b'
    runeLetters[3] = 'c'
    runeLetters[4] = 'd'
    for tier, runeLetter in pairs(runeLetters) do
        local runeName = runeLetter .. '_' .. abilityLetter
        caster[runeName .. '_level'] = Runes:GetTotalRuneLevel(caster, tier, runeName, casterName)
    end
end

local module = {}
module.updateStackModifier = updateStackModifier
module.initializeAbilityRunes = initializeAbilityRunes
return module
local function cast(caster)
    local runeUnit = caster.runeUnit
    local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_a_b")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
        local duration = W1_START_DURATION + 0.1 * W1_ADD_DURATION
        duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
        runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_arcane_shell", {duration = duration})
        caster:SetModifierStackCount("modifier_arcane_shell", runeUnit, 2)
    end
end
local module = {}
module.cast = cast
return module
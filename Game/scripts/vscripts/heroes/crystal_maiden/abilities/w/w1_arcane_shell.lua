local function cast(caster, durationMod)
    local runeUnit = caster.runeUnit
    local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_w_1")
    local totalLevel = caster:GetRuneValue("w", 1)
    if totalLevel > 0 then
        local duration = W1_START_DURATION + totalLevel * W1_ADD_DURATION
        duration = Filters:GetAdjustedBuffDuration(caster, duration*durationMod, false)
        runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_arcane_shell", {duration = duration})
        caster:SetModifierStackCount("modifier_arcane_shell", runeUnit, 2)
    end
end
local module = {}
module.cast = cast
return module
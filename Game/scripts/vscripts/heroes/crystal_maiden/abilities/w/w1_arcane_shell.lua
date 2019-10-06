local function cast(caster, durationMod)
    local runeUnit = caster.runeUnit
    local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_w_1")
    local totalLevel = caster:GetRuneValue("w", 1)
    if totalLevel > 0 then
        local duration = SORCERESS_W1_START_DURATION + totalLevel * SORCERESS_W1_ADD_DURATION
        duration = Filters:GetAdjustedBuffDuration(caster, duration * durationMod, false)
        runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_arcane_shell", {duration = duration})
        if caster:HasModifier("modifier_sorceress_glyph_5_1") then
            caster:SetModifierStackCount("modifier_arcane_shell", runeUnit, SORCERESS_GLYPH_4_1_W1_SHIELDS)
        else caster:SetModifierStackCount("modifier_arcane_shell", runeUnit, 3)
        end
    end
end
local module = {}
module.cast = cast
return module

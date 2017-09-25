require('heroes/crystal_maiden/init')

function applyBuff(event)
    local caster = event.caster
    if event.caster:GetUnitName() == "rune_unit" then
        caster = event.caster.hero
    end

    Helper.initializeAbilityRunes(caster, 'sorceress', 'a')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'b')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'c')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'd')

    local stacksCount = caster.c_b_level
    if stacksCount == nil or stacksCount <= 0 then
        return
    end

    if caster:HasModifier("modifier_sorceress_glyph_3_2") then
        stacksCount = stacksCount * T32_BONUS_AMPLIFY
    end

    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_c_b")

    runeAbility:ApplyDataDrivenModifier(caster, event.target, "modifier_arcane_intellect_visible", {})
    event.target:SetModifierStackCount("modifier_arcane_intellect_visible", caster, stacksCount)
end
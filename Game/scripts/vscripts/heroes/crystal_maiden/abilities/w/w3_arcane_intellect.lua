require('heroes/crystal_maiden/init')

function applyBuff(event)
    local caster = event.caster
    if event.caster:GetUnitName() == "rune_unit" then
        caster = event.caster.hero
    end

    Helper.initializeAbilityRunes(caster, 'sorceress', 'q')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'w')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'e')
    Helper.initializeAbilityRunes(caster, 'sorceress', 'r')

    local stacksCount = caster.w_3_level
    if stacksCount == nil or stacksCount <= 0 then
        return
    end

    if caster:HasModifier("modifier_sorceress_glyph_3_2") then
        stacksCount = stacksCount * T32_BONUS_AMPLIFY
    end

    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_w_3")

    runeAbility:ApplyDataDrivenModifier(caster, event.target, "modifier_arcane_intellect_visible", {})
    event.target:SetModifierStackCount("modifier_arcane_intellect_visible", caster, stacksCount)
end
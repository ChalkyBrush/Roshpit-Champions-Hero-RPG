require('heroes/axe/init')
function think(event)
    local caster = event.caster
    Helper.initializeAbilityRunes(caster, 'axe', 'e')
    local runesCount = caster.e_1_level

    if caster.e_1_level <= 0 then
        return
    end

    local stacks = math.floor(20 - 20*(caster:GetHealth()/caster:GetMaxHealth()))
    local runeAbility = caster.runeUnit:FindAbilityByName("axe_rune_e_1")

    if stacks > 0 then
        runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_e_1_visible", {})
        caster:SetModifierStackCount( "modifier_axe_rune_e_1_visible", runeAbility, stacks )
        runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_e_1_invisible", {})
        caster:SetModifierStackCount( "modifier_axe_rune_e_1_invisible", runeAbility, stacks * runesCount)
    else
        caster:RemoveModifierByName("modifier_axe_rune_e_1_visible")
        caster:RemoveModifierByName("modifier_axe_rune_e_1_invisible")
    end
end
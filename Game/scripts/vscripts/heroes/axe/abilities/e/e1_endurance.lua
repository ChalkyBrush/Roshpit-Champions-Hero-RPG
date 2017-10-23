require('heroes/axe/init')
function think(event)
    local caster = event.caster
    Helper.initializeAbilityRunes(caster, 'axe', 'c')
    local runesCount = caster.a_c_level

    if caster.a_c_level <= 0 then
        return
    end

    local stacks = math.floor(20 - 20*(caster:GetHealth()/caster:GetMaxHealth()))
    local runeAbility = caster.runeUnit:FindAbilityByName("axe_rune_a_c")

    if stacks > 0 then
        runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_a_c_visible", {})
        caster:SetModifierStackCount( "modifier_axe_rune_a_c_visible", runeAbility, stacks )
        runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_a_c_invisible", {})
        caster:SetModifierStackCount( "modifier_axe_rune_a_c_invisible", runeAbility, stacks * runesCount)
    else
        caster:RemoveModifierByName("modifier_axe_rune_a_c_visible")
        caster:RemoveModifierByName("modifier_axe_rune_a_c_invisible")
    end
end
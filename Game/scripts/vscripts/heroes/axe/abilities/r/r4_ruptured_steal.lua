require('heroes/axe/init')
function think(event)
    local ability = event.ability
    local caster = event.caster

    local runesCount = Runes:GetTotalRuneLevelGeneric(caster, 4, 3)
    if runesCount <= 0 then
        caster:RemoveModifierByName("modifier_axe_rune_r_4_visible")
        caster:RemoveModifierByName("modifier_axe_rune_r_4_invisible")
        return
    end

    local partOfIncomingDamage = GameState:IncomingDamageDecrease(caster, nil, false)
    local stacksCount = 1
    if partOfIncomingDamage ~= 0 then
        stacksCount = math.ceil( math.log( 1 / partOfIncomingDamage) / math.log(2))
    end

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_4_visible", {})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_4_invisible", {})
    caster:SetModifierStackCount("modifier_axe_rune_r_4_visible", caster, stacksCount)
    caster:SetModifierStackCount("modifier_axe_rune_r_4_invisible", caster, runesCount*stacksCount)
end

function b_a_attack(event)
    local caster = event.attacker
    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("axe_rune_q_2")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_2")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
        ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_axe_rune_q_2_stacker", {})
        local current_stack = caster:GetModifierStackCount("modifier_axe_rune_q_2_stacker", ability)
        if not (current_stack > totalLevel + 3) then
            caster:SetModifierStackCount("modifier_axe_rune_q_2_stacker", ability, current_stack + 1)
        end
    end
end

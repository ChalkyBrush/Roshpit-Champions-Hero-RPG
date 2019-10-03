
function increment_duskfire_stacks(caster, enemy, amount)
	if amount > 0 then
		local ability = caster:FindAbilityByName("whirling_flail")
		if not ability then
			ability = caster:FindAbilityByName("duskbringer_arcana_terrorize")
		end
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_duskbringer_rune_q_1", {duration = DUSKBRINGER_Q1_DURATION})
		local stacks = enemy:GetModifierStackCount("modifier_duskbringer_rune_q_1", caster)
		if caster:HasModifier("modifier_duskbringer_immortal_weapon_1") then
			amount = amount * DUSKBRINGER_IMMORTAL_WEAPON_1_DUSKFIRE_STACK_MULT
		end
		local newStacks = stacks + amount
		enemy:SetModifierStackCount("modifier_duskbringer_rune_q_1", caster, newStacks)
	end
end

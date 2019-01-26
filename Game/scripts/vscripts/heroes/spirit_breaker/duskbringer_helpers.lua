
function increment_duskfire_stacks(caster, enemy, ability, amount)
	if amount > 0 then
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_duskbringer_rune_q_1", {duration = 5})
		local stacks = enemy:GetModifierStackCount("modifier_duskbringer_rune_q_1", caster)
		if caster:HasModifier("modifier_duskbringer_immortal_weapon_1") then
			amount = amount * 2
		end
		local newStacks = stacks + amount
		enemy:SetModifierStackCount("modifier_duskbringer_rune_q_1", caster, newStacks)
	end
end
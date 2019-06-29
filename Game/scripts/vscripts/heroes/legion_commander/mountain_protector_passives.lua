function mountain_protector_e_passives_think(event)
	local caster = event.caster
	local ability = event.ability

	if not ability then
		return
	end

	local e_4_level = caster:GetRuneValue("e", 4)
	if caster:HasAbility("mountain_protector_emberstone") and e_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mountain_rune_e_4_effect", {})
		caster:SetModifierStackCount("modifier_mountain_rune_e_4_effect", caster, e_4_level)
	else
		caster:RemoveModifierByName("modifier_mountain_rune_e_4_effect")
	end
end

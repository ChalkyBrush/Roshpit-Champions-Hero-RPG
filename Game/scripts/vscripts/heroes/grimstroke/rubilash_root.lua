LinkLuaModifier("modifier_rubilash_q1", "modifiers/rubilash/modifier_rubilash_q1", LUA_MODIFIER_MOTION_NONE)

function rubilash_main_thinker(event)
	local caster = event.caster
	local ability = event.ability
	-- if caster has standard q ability
	local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		ability.cast_range = q_1_level*RUBILASH_RUNE_Q1_CAST_RANGE
		if not caster:HasModifier("modifier_rubilash_q1") then
			caster:AddNewModifier(caster, ability, "modifier_rubilash_q1", {})
		end
	else
		caster:RemoveModifierByName("modifier_rubilash_q_1_cast_range")
	end

	-- if caster has standard w ability
	local w_3_level = caster:GetRuneValue("w", 3)
	if w_3_level > 0 then
		if not caster:HasModifier("modifier_rubilash_w_3_attack_speed") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_rubilash_w_3_attack_speed", {})
		end
		caster:SetModifierStackCount("modifier_rubilash_w_3_attack_speed", caster, w_3_level)
	else
		caster:RemoveModifierByName("modifier_rubilash_w_3_attack_speed")
	end

end

function rubilash_quick_thinker(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_rubilash_arcana1") then
		local e_1_level = caster:GetRuneValue("e", 1)
		if e_1_level > 0 then
			if not caster:HasModifier("modifier_rubilash_e_1_attack_damage") then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_rubilash_e_1_attack_damage", {})
			end
			local attack_damage = e_1_level*RUBILASH_RUNE_E1_ATTACK_PER_MANA*caster:GetMana()
			caster:SetModifierStackCount("modifier_rubilash_e_1_attack_damage", caster, attack_damage)
		else
			caster:RemoveModifierByName("modifier_rubilash_e_1_attack_damage")
		end
	end
end
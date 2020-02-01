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

	if caster:HasModifier("modifier_rubilash_arcana1") then
		caster:RemoveModifierByName("modifier_rubilash_e_4_max_health")
		local e_4_level = caster:GetRuneValue("e", 4)
		if e_4_level > 0 then
			if not caster:HasModifier("modifier_rubilash_arcana_e_4_attack_damage") then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_rubilash_arcana_e_4_attack_damage", {})
			end
			caster:SetModifierStackCount("modifier_rubilash_arcana_e_4_attack_damage", caster, e_4_level*RUBILASH_ARCANA1_RUNE_E4_ATK_PER_ATTR)
		else
			caster:RemoveModifierByName("modifier_rubilash_arcana_e_4_attack_damage")
		end
	else
		caster:RemoveModifierByName("modifier_rubilash_arcana_e_4_attack_damage")
		local e_4_level = caster:GetRuneValue("e", 4)
		if e_4_level > 0 then
			if not caster:HasModifier("modifier_rubilash_e_4_max_health") then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_rubilash_e_4_max_health", {})
			end
		else
			caster:RemoveModifierByName("modifier_rubilash_e_4_max_health")
		end
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

	-- if caster has standard r ability
	local r_2_level = caster:GetRuneValue("r", 2)
	if r_2_level > 0 and caster:IsInvisible() then
		if not caster:HasModifier("modifier_rubilash_r_2_bad_and_item") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_rubilash_r_2_bad_and_item", {})
		end
		-- caster:SetModifierStackCount("modifier_rubilash_r_2_bad_and_item", caster, r_2_level)
	else
		caster:RemoveModifierByName("modifier_rubilash_r_2_bad_and_item")
	end

	local q_ability = caster:GetAbilityByIndex(DOTA_Q_SLOT)
	if caster:HasModifier("modifier_rubilash_immortal_weapon_1") then
		q_ability:SetOverrideCastPoint(0)
	else
		if not caster:HasModifier("modifier_mask_of_ahnqhir_purple") then
			q_ability:SetOverrideCastPoint(RUBILASH_PHANTOM_BRUSH_CAST_POINT)
		end
	end
end
require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')
require("heroes/util/channeling")

----------------------------------
--- SPECIAL FOR DEALING DAMAGE ---
----------------------------------
function ChernobogDealDamage(caster, target, damage, damageType, ability, element1, element2, isDot, powerScale)
	local R_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
	local luck = RandomInt(1, 100)
	local q_1_bonus = caster:GetRuneValue("q", 1) * CHERNOBOG_Q1_PROC_AMP / 100 + 1
	local r_2_scale = CHERNOBOG_R2_BASE_ABILITY_AMP * caster:GetRuneValue("r", 2) / 100
	if caster:HasModifier("modifier_chernobog_glyph_4_1") then
		r_2_scale = r_2_scale * (1 + CHERNOBOG_GLYPH_4_1_R2_AMP / 100)
	end
	local r_2_bonus = 1 + r_2_scale
	if caster:HasModifier("modifier_chernobog_glyph_6_2") and (caster:GetHealthPercent() < CHERNOBOG_GLYPH_6_2_THRESHOLD) then
		damage = damage * (1 - CHERNOBOG_GLYPH_6_2_DMG_DEC / 100)
	end
	if caster:HasModifier("modifier_chernobog_immortal_weapon_1") and (powerScale == false) then
		damage = damage * (1 + CHERNOBOG_IMMORTAL_WEAPON_1_NON_POWER_SCALE_BONUS / 100)
	end
	if caster:HasModifier("modifier_chernobog_immortal_weapon_2") then
		if (damageType == DAMAGE_TYPE_PHYSICAL) then
			if caster:HasModifier("modifier_chernobog_immortal_weapon_2_phys_buff") then
				damage = damage * (1 + CHERNOBOG_IMMORTAL_WEAPON_2_PHYS_BONUS / 100)
				caster:RemoveModifierByName("modifier_chernobog_immortal_weapon_2_phys_buff")
				local hp_restored = caster:GetMaxHealth() * CHERNOBOG_IMMORTAL_WEAPON_2_HEALTH_RESTORE_WHEN_AMP / 100
				caster:SetHealth(caster:GetHealth() + hp_restored)
			end
			ApplyModifier(caster, caster, nil, "modifier_chernobog_immortal_weapon_2_magic_buff", -1, nil)
		end
		if (damageType == DAMAGE_TYPE_MAGICAL) then
			if caster:HasModifier("modifier_chernobog_immortal_weapon_2_magic_buff") then
				damage = damage * (1 + CHERNOBOG_IMMORTAL_WEAPON_2_MAGIC_BONUS / 100)
				caster:RemoveModifierByName("modifier_chernobog_immortal_weapon_2_magic_buff")
				local mana_restored = caster:GetMaxMana() * CHERNOBOG_IMMORTAL_WEAPON_2_MANA_RESTORE_WHEN_AMP / 100
				caster:GiveMana(mana_restored)
			end
			ApplyModifier(caster, caster, nil, "modifier_chernobog_immortal_weapon_2_phys_buff", -1, nil)
		end
	end
	if caster:HasModifier("modifier_chernobog_immortal_weapon_4") then
		local modifiers = target:FindAllModifiers()
		if #modifiers > 0 then
			for i = 1, #modifiers, 1 do
				if (modifiers[i].GetRoshpitArmorBonus and modifiers[i]:GetRoshpitArmorBonus() < 0) or (modifiers[i].GetRoshpitMagicArmorBonus and modifiers[i]:GetRoshpitMagicArmorBonus() < 0) then
					damage = damage * (1 + CHERNOBOG_IMMORTAL_WEAPON_4_AMP_ON_DEBUFFED_ENEMY / 100)
					break
				end
			end
		end
		if (target:GetRoshpitArmor() == 0) or (target:GetRoshpitMagicArmor() == 0 ) then
			ApplyModifier(caster, target, nil, "modifier_chernobog_immortal_weapon_4_conditional_silence", 2, nil)
		end
	end
	if (ability == BASE_ABILITY_Q) then
		if (luck < CHERNOBOG_Q1_PROC_CHANCE) and (q_1_bonus > 1) then
			damage = damage * q_1_bonus 
		end
		if caster:HasModifier("modifier_chernobog_glyph_4_2") then
			damage = damage * (1 + CHERNOBOG_GLYPH_4_2_Q_DMG_AMP / 100)
		end
	end
	if (ability == BASE_ABILITY_W) and caster:HasModifier("modifier_chernobog_glyph_2_1") then
		damage = damage * (1 + CHERNOBOG_GLYPH_2_1_W_DMG_AMP / 100)
	end
	if caster:HasModifier("modifier_chernobog_e3_effect") then
		damage = damage * (1 + CHERNOBOG_E3_NEXT_DMG_AMP * caster:GetRuneValue("e", 3) / 100)
		caster:RemoveModifierByName("modifier_chernobog_e3_effect")
	end
	if isDot == true then
		Filters:ApplyDotDamage(caster, ability, target, damage, damageType, ability, element1, element2)
		if R_ability and (R_ability:GetAbilityName() == "chernobog_nights_procession") and target:HasModifier("modifier_chernobog_r_effect") and (r_2_bonus > 1) then
			damage = damage * r_2_bonus
			Filters:ApplyDotDamage(caster, ability, target, damage, damageType, ability, element1, element2)
		end
	else
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, damageType, ability, element1, element2)
		if R_ability and (R_ability:GetAbilityName() == "chernobog_nights_procession") and target:HasModifier("modifier_chernobog_r_effect") and (r_2_bonus > 1) then
			damage = damage * r_2_bonus
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, damageType, ability, element1, element2)
		end
	end
end

--------------------
--- RADIUS CALCU ---
--------------------
function CalculateFinalRadius(caster, baseRadius, abilitySlot)
	local flatBonus = 0
	local multBonus = 1
	local finalRadius = baseRadius
	if caster:HasModifier("modifier_chernobog_immortal_weapon_3") then
		multBonus = multBonus + CHERNOBOG_IMMORTAL_WEAPON_3_ALL_RADIUS_BONUS / 100
	end
	if abilitySlot == DOTA_Q_SLOT then
		flatBonus = flatBonus + caster:GetRuneValue("q", 4) * CHERNOBOG_Q4_WIDTH_BONUS
	end
	if abilitySlot == DOTA_R_SLOT then
		if caster:GetAbilityByIndex(DOTA_R_SLOT):GetAbilityName() == "chernobog_nights_procession" then
			flatBonus = flatBonus + caster:GetRuneValue("r", 3) * CHERNOBOG_R3_RADIUS
		end
	end
	finalRadius = (finalRadius + flatBonus) * multBonus
	return finalRadius
end

------------------
--- RATE CALCU ---
------------------
function CalculateFinalRate(caster, baseRate, abilitySlot)
	local flatBonus = 0
	local multBonus = 1
	local finalRate = baseRate
	if caster:HasModifier("modifier_chernobog_immortal_weapon_3") then
		multBonus = multBonus + CHERNOBOG_IMMORTAL_WEAPON_3_ALL_RATE_BONUS / 100
	end
	finalRate = (finalRate + flatBonus) / multBonus
	return finalRate
end

--------------------------
--- ARMOR REDUC MODIFY ---
--------------------------

function CalculateFinalArmorReduction(caster, baseReduc)
	local flatBonus = 0
	local multBonus = 1
	local finalReduc = baseReduc
	if caster:HasModifier("modifier_chernobog_immortal_weapon_4") then
		multBonus = multBonus + CHERNOBOG_IMMORTAL_WEAPON_4_ARMOR_REDUC_MULT / 100
	end
	finalReduc = (finalReduc + flatBonus) * multBonus
	return finalReduc
end

--------------------------
--- MODIFIERS APPLYING ---
--------------------------

function ApplyModifier(caster, target, ability, modifier_name, duration, stacks)
	local finalDuration = duration
	if finalDuration ~= -1 then
		finalDuration = Filters:GetAdjustedBuffDuration(caster, finalDuration, false)
	end	
	if not target:HasModifier(modifier_name) then
		target:AddNewModifier(caster, ability, modifier_name, {duration = finalDuration})
	end
	if stacks then
		target:FindModifierByName(modifier_name):SetStackCount(stacks)
	end
	target:FindModifierByName(modifier_name):SetDuration(finalDuration, true)
end

--------------------------------------------
--- MODIFIER THINKER FOR REALTIME UPDATE ---
--------------------------------------------
local modifiers = {
	{
		{}, --Q1 MODIFIERS
		{}, --Q2 MODIFIERS
		{}, --Q3 MODIFIERS
		{}	--Q4 MODIFIERS
	},
	{
		{"modifier_chernobog_w1_effect"}, --W1 MODIFIERS
		{"modifier_chernobog_w2_effect"}, --W2 MODIFIERS
		{}, --W3 MODIFIERS
		{"modifier_chernobog_w4_effect"}	--W4 MODIFIERS
	},
	{
		{"modifier_chernobog_e1_buff"}, --E1 MODIFIERS
		{"modifier_chernobog_e2_thinker"}, --E2 MODIFIERS
		{"modifier_chernobog_e3_thinker"}, --E3 MODIFIERS
		{"modifier_chernobog_e4_buff"}	--E4 MODIFIERS
	},
	{
		{}, --R1 MODIFIERS
		{}, --R2 MODIFIERS
		{}, --R3 MODIFIERS
		{"modifier_chernobog_r4_demon_amp", "modifier_chernobog_r4_shadow_amp"}	--R4 MODIFIERS
	}
}

local arcana_modifiers = {
	{
		{}, --ARCANA Q1 MODIFIERS
		{}, --ARCANA Q2 MODIFIERS
		{}, --ARCANA Q3 MODIFIERS
		{}	--ARCANA Q4 MODIFIERS
	},
	{
		{}, --ARCANA W1 MODIFIERS
		{}, --ARCANA W2 MODIFIERS
		{}, --ARCANA W3 MODIFIERS
		{}	--ARCANA W4 MODIFIERS
	},
	{
		{}, --ARCANA E1 MODIFIERS
		{"modifier_chernobog_arcana_e2_effect", "modifier_chernobog_arcana_e2_count"}, --ARCANA E2 MODIFIERS
		{}, --ARCANA E3 MODIFIERS
		{}	--ARCANA E4 MODIFIERS
	},
	{
		{}, --ARCANA R1 MODIFIERS
		{}, --ARCANA R2 MODIFIERS
		{}, --ARCANA R3 MODIFIERS
		{}	--ARCANA R4 MODIFIERS
	}
}

function ModifierThink(caster, ability, abilitySlot, index, requireToggle, isArcana)
	local slot = abilitySlot
	if slot == 5 then
		slot = slot - 1
	else
		slot = slot + 1
	end
	local modifierTable = nil
	if isArcana == true then
		modifierTable = arcana_modifiers[slot]
	else
		modifierTable = modifiers[slot]
	end
	for i = 1, 4, 1 do
		local rune_level = caster:GetRuneValue(index, i)
		if #modifierTable[i] > 0 then
			for j = 1, #modifierTable[i], 1 do
				local modifier_name = modifierTable[i][j]
				if not requireToggle or (requireToggle == ability:GetToggleState()) then
					if rune_level > 0 then
						local stacks = nil
						if modifier_name ~= "modifier_chernobog_arcana_e2_effect" then
							stacks = rune_level
						end
						ApplyModifier(caster, caster, ability, modifier_name, -1, stacks)
					else
						if caster:HasModifier(modifier_name) then
							caster:RemoveModifierByName(modifier_name)
						end
					end
				else
					if caster:HasModifier(modifier_name) and (caster:FindModifierByName(modifier_name):GetName() ~= "modifier_chernobog_e4_buff") then
						caster:RemoveModifierByName(modifier_name)
					end
				end
			end
		end
	end
end

----------------------
--- SEARCH ENEMIES ---
----------------------
function SearchEnemies(caster, target, radius, findSpellImmune)
	local flag = DOTA_UNIT_TARGET_FLAG_NONE
	if findSpellImmune == true then
		flag = flag + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	return FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,  flag, FIND_ANY_ORDER, false)
end

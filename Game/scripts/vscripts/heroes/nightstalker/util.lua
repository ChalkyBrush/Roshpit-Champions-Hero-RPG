require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')
require("heroes/util/channeling")

----------------------------------
--- SPECIAL FOR DEALING DAMAGE ---
----------------------------------
function ChernobogDealDamage(caster, target, damage, damageType, ability, element1, element2, isDot, powerScale)
	local luck = RandomInt(1, 100)
	local q_1_bonus = caster:GetRuneValue("q", 1) * CHERNOBOG_Q1_PROC_AMP / 100 + 1
	local r_2_proc = CalculateR2Proc(caster, target)
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
	if (ability == BASE_ABILITY_R) and target:HasModifier("modifier_chernobog_r_effect") and caster:HasModifier("modifier_chernobog_glyph_5_2") then
		damage = damage * (1 + CHERNOBOG_GLYPH_5_2_R1_AMP_IN_R / 100)
	end
	if caster:HasModifier("modifier_chernobog_e3_effect") then
		damage = damage * (1 + CHERNOBOG_E3_NEXT_DMG_AMP * caster:GetRuneValue("e", 3) / 100)
		caster:RemoveModifierByName("modifier_chernobog_e3_effect")
	end
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
			caster:AddNewModifier(caster, nil, "modifier_chernobog_immortal_weapon_2_magic_buff", {})
		end
		if (damageType == DAMAGE_TYPE_MAGICAL) then
			if caster:HasModifier("modifier_chernobog_immortal_weapon_2_magic_buff") then
				damage = damage * (1 + CHERNOBOG_IMMORTAL_WEAPON_2_MAGIC_BONUS / 100)
				caster:RemoveModifierByName("modifier_chernobog_immortal_weapon_2_magic_buff")
				local mana_restored = caster:GetMaxMana() * CHERNOBOG_IMMORTAL_WEAPON_2_MANA_RESTORE_WHEN_AMP / 100
				caster:GiveMana(mana_restored)
			end
			caster:AddNewModifier(caster, nil, "modifier_chernobog_immortal_weapon_2_phys_buff", {})
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
			target:AddNewModifier(caster , nil, "modifier_chernobog_immortal_weapon_4_conditional_silence", {duration = 2})
		end
	end
	if isDot == true then
		Filters:ApplyDotDamage(caster, ability, target, damage, damageType, ability, element1, element2)
		if r_2_proc and r_2_proc > 0 then
		    for i = 1, r_2_proc, 1 do
		        Filters:ApplyDotDamage(caster, ability, target, damage, damageType, ability, element1, element2)
			end
		end
	else
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, damageType, ability, element1, element2)
		if r_2_proc and r_2_proc > 0 then
		    for i = 1, r_2_proc, 1 do
		        Filters:TakeArgumentsAndApplyDamage(target, caster, damage, damageType, ability, element1, element2)
			end
		end
	end
end

function CalculateR2Proc(caster, target)
    local R_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
	local r_2_level = caster:GetRuneValue("r", 2)
    local r_2_chance = CHERNOBOG_R2_CHANCE * r_2_level
	if not ( R_ability and R_ability:GetAbilityName() == "chernobog_nights_procession") then
	    return 
	end
    if target:HasModifier("modifier_chernobog_r_effect") then
	    r_2_chance = r_2_chance * 3
	end
	local procs = ((r_2_chance) - ((r_2_chance) % 100)) / 100
	if RandomInt(0, 100) < (r_2_chance) % 100 then
		procs = procs + 1
	end
	return procs
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

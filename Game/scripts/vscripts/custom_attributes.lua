if CustomAttributes == nil then
	CustomAttributes = class({})
end

require('/heroes/legion_commander/mountain_protector_constants')
require('/heroes/obsidian_destroyer/epoch_constants')
require('/heroes/antimage/arkimus_constants')
require('/heroes/juggernaut/seinaru_constants')
require('/heroes/dark_seer/zhonik_constants')
require('/heroes/hero_necrolyte/venomort_constants')
require('/heroes/nightstalker/chernobog_constants')
require('/heroes/skywrath_mage/sephyr_constants')
require('heroes/slardar/hydroxis_constants')
require('/heroes/vengeful_spirit/solunia_constants')
require("/heroes/winter_wyvern/dinath_constants")
require("/heroes/beastmaster/warlord_constants")

require('items/constants/boots')
require('items/constants/chest')
require('items/constants/gloves')
require('items/constants/helm')
require('items/constants/trinket')

CustomAttributes.HEALTH_PER_STR = 20
CustomAttributes.HEALTH_REGEN_PER_STR = 0.1

CustomAttributes.ATTACKSPEED_PER_AGI = 0.04
CustomAttributes.ARMOR_PER_AGI = 0.14

CustomAttributes.MANA_PER_INT = 5
CustomAttributes.MANA_REGEN_PER_INT = 0.1

CustomAttributes.ATK_DMG_PER_PRIMARY = 2

CustomAttributes.FLAMEWAKER_R3_STRENGTH = 260
CustomAttributes.CONJUROR_E1_AGI = 25
CustomAttributes.WARLORD_W2_STATS = 60
CustomAttributes.MOUNTAIN_PROTECTOR_R1_ARCANA1_STRENGTH = 250
CustomAttributes.HYDROXIS_E4_AGI_INT = 350

CustomAttributes.ZHONIK_R4_STR = ZHONIK_R4_BONUS_STR
CustomAttributes.ZHONIK_ARCANA_R4_AGI = ZHONIK_R4_ARCANA_BONUS_AGI

CustomAttributes.DJANGHOR_R4_STATS = 500
CustomAttributes.DJANGHOR_R4_ARCANA_STATS = 200
CustomAttributes.AXE_Q3_STATS = 14
CustomAttributes.ASTRAL_E4_STATS = 160
CustomAttributes.SORCERESS_ARCANE_INTELLECT = 50
CustomAttributes.WARLORD_Q4_STATS = 900
CustomAttributes.BAHAMUT_Q4_INT = 365
CustomAttributes.BAHAMUT_R4_STATS = 7
CustomAttributes.AURIUN_E2_INT = 120
CustomAttributes.AURIUN_E3_STATS = 60
CustomAttributes.MOUNTAIN_PROTECTOR_E2_STR = 180
CustomAttributes.AXE_E1_STATS = RED_GENERAL_E1_ATTRIBUTES_GAIN
CustomAttributes.AXE_ARCANA2_W2_STRENGTH = RED_GENERAL_ARCANA2_W2_STRENGTH
CustomAttributes.SORCERESS_ARCANE_INT = 50
CustomAttributes.TRAPPER_R4_AGI = TRAPPER_R4_BONUS_AGI
CustomAttributes.JEX_OAK_INFUSION_RUNE_STRENGTH = 330

CustomAttributes.RING_OF_NOBILITY = NOBILITY_ALL_ATTRIBUTES
CustomAttributes.RING_OF_NOBILITY2 = NOBILITY_ALL_ATTRIBUTES_AUGMENTED
CustomAttributes.AZURE_EMPIRE_STATS = PENDANT_AZURE_EMPIRE_GREEN_AGI
CustomAttributes.WIND_ORCHID_AGI_PER_E4 = WIND_ORCHID_AGI_PER_E4
CustomAttributes.AQUA_LILY_INT_PER_R4 = AQUA_LILY_INT_PER_R4
CustomAttributes.FIRE_BLOSSOM_STR_PER_W4 = FIRE_BLOSSOM_STR_PER_W4
CustomAttributes.FLAMEWAKER_WEAPON_2_AGI = FLAMEWAKER_IMMORTAL_WEAPON_2_AGILITY_DURING_E
CustomAttributes.SEINARU_WEAPON_3_STR = 60

CustomAttributes.NEUTRAL_GLYPH_1 = 500
CustomAttributes.NEUTRAL_GLYPH_7 = 3500
CustomAttributes.MOUNTAIN_PROTECTOR_GLYPH_5_A = MOUNTAIN_PROTECTOR_GLYPH_5_A_STR
CustomAttributes.ASTRAL_W1_ARCANA2_STATS = 0.8

CustomAttributes.DJANGHOR_BEAR_MAX_HEALTH = 6000
CustomAttributes.OGTHUN_HEALTH = 10
CustomAttributes.TYRIUS_HEALTH = TYRIUS_HP_PER_STR
CustomAttributes.REDROCK_HEALTH = 10
CustomAttributes.SANGE_HEALTH = SANGE_HP_PER_AGI
CustomAttributes.SAPPHIRE_LOTUS_HEALTH = SAPPHIRE_LOTUS_HP_PER_INT
CustomAttributes.PALADIN_IMMO_3_HEALTH = PALADIN_IMMORTAL_WEAPON_3_HP_PER_STR

function CDOTA_BaseNPC_Hero:GetStrength()
	local hero = self
	local strength = hero.strength_custom + hero.str_bonus
	if self:HasModifier("modifier_diamond_claws_of_tiamat") then
		local item = self.handItem
		strength = item.newItemTable.property1
	end
	return tonumber(strength)
end

function CDOTA_BaseNPC_Hero:GetAgility()
	local hero = self
	local agility = hero.agility_custom + hero.agi_bonus
	if self:HasModifier("modifier_diamond_claws_of_tiamat") then
		local item = self.handItem
		agility = item.newItemTable.property1
	end
	return tonumber(agility)
end

function CDOTA_BaseNPC_Hero:GetIntellect()
	local hero = self
	local intelligence = hero.intellect_custom + hero.int_bonus
	if self:HasModifier("modifier_diamond_claws_of_tiamat") then
		local item = self.handItem
		intelligence = item.newItemTable.property1
	end
	return tonumber(intelligence)
end

function CDOTA_BaseNPC_Hero:GetBaseStrength()
	local strength = self:GetStrength()
	local modifier = nil

	modifier = self:FindModifierByName('modifier_gold_plate_of_leon_str')
	if modifier then
		strength = strength - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_empyreal_str')
	if modifier then
		strength = strength - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_legion_vestments_effect_str')
	if modifier then
		strength = strength - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_eye_of_seasons_stats')
	if modifier then
		strength = strength - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_blazing_fury_effect')
	if modifier then
		strength = strength - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_red_divinex_amulet')
	if modifier and modifier.stat_bonus then
		strength = strength - modifier.stat_bonus
	end

	modifier = self:FindModifierByName('modifier_neutral_glyph_7_1')
	if modifier then
		strength = strength - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName("modifier_w_4_str_decrease")
	if modifier then
		strength = strength + modifier:GetStackCount()
	end

	return strength
end

function CDOTA_BaseNPC_Hero:GetBaseAgility()
	local agility = self:GetAgility()
	local modifier = nil

	modifier = self:FindModifierByName('modifier_gold_plate_of_leon_agi')
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_empyreal_agi')
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_legion_vestments_effect_agi')
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_voltex_glyph_2_1_effect_invisible')
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_eye_of_seasons_stats')
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_dark_arts_effect')
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_green_divinex_amulet')
	if modifier and modifier.stat_bonus then
		agility = agility - modifier.stat_bonus
	end

	modifier = self:FindModifierByName('modifier_neutral_glyph_7_2')
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName("modifier_w_4_agi_increase")
	if modifier then
		agility = agility - modifier:GetStackCount()
	end

	return agility
end

function CDOTA_BaseNPC_Hero:GetBaseIntellect()
	local intellect = self:GetIntellect()
	local modifier = nil

	modifier = self:FindModifierByName('modifier_gold_plate_of_leon_int')
	if modifier then
		intellect = intellect - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_empyreal_int')
	if modifier then
		intellect = intellect - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_legion_vestments_effect_str')
	if modifier then
		intellect = intellect - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_blazing_fury_effect')
	if modifier then
		intellect = intellect - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName('modifier_blue_divinex_amulet')
	if modifier and modifier.stat_bonus then
		intellect = intellect - modifier.stat_bonus
	end

	modifier = self:FindModifierByName('modifier_neutral_glyph_7_3')
	if modifier then
		intellect = intellect - modifier:GetStackCount()
	end

	modifier = self:FindModifierByName("modifier_w_4_int_increase")
	if modifier then
		intellect = intellect - modifier:GetStackCount()
	end

	return intellect
end

function CDOTA_BaseNPC:GetRuneValue(letter, tier)
	local index = 0
	if letter == "q" then
		index = 0
	elseif letter == "w" then
		index = 1
	elseif letter == "e" then
		index = 2
	elseif letter == "r" then
		index = 3
	end
	local runeUnit = ""
	if self:HasModifier("modifier_sorceress_immortal_ice_avatar") or self:HasModifier("modifier_sorceress_immortal_fire_avatar") then
		self = self.origCaster
	end
	if tier == 1 then
		runeUnit = self.runeUnit
	elseif tier == 2 then
		runeUnit = self.runeUnit2
	elseif tier == 3 then
		runeUnit = self.runeUnit3
	elseif tier == 4 then
		runeUnit = self.runeUnit4
	end

	local rune_level = 0
	local runeID = Runes:ConvertTierAndIndexToRune(tier, index)
	if runeUnit then
		local runeAbility = runeUnit:GetAbilityByIndex(index)
		if runeAbility then
			if runeAbility:IsActivated() then
				local abilityLevel = runeAbility:GetLevel()
				local bonusLevel = Runes:GetTotalBonus(runeUnit, runeID)
				local totalLevel = abilityLevel + bonusLevel
				rune_level = totalLevel
			end
		end
	end
	return rune_level
end

function CustomAttributes:SetAttributes(hero)
	local strength = hero.strength_custom
	local agility = hero.agility_custom
	local intelligence = hero.intellect_custom

	local str_bonus = 0
	local agi_bonus = 0
	local int_bonus = 0
	local heroName = hero:GetUnitName()
	if hero:HasModifier("modifier_flamewaker_rune_r_3") then
		local stacks = hero:GetModifierStackCount("modifier_flamewaker_rune_r_3", hero)
		str_bonus = str_bonus + CustomAttributes.FLAMEWAKER_R3_STRENGTH * stacks
	end
	if hero:HasModifier("modifier_voltex_glyph_2_1_effect_invisible") then
		local stacks = hero:GetModifierStackCount("modifier_voltex_glyph_2_1_effect_invisible", hero)
		agi_bonus = agi_bonus + stacks
	end
	if hero:HasModifier("modifier_astral_a_b_invisible") then
		local stacks = hero:GetModifierStackCount("modifier_astral_a_b_invisible", hero)
		str_bonus = str_bonus + stacks
		agi_bonus = agi_bonus + stacks
		int_bonus = int_bonus + stacks
	end
	if hero:HasModifier("modifier_apollo_stats_invisible") then
		local stacks = hero:GetModifierStackCount("modifier_apollo_stats_invisible", hero)
		str_bonus = str_bonus + stacks * CustomAttributes.ASTRAL_W1_ARCANA2_STATS
		agi_bonus = agi_bonus + stacks * CustomAttributes.ASTRAL_W1_ARCANA2_STATS
		int_bonus = int_bonus + stacks * CustomAttributes.ASTRAL_W1_ARCANA2_STATS
	end
	if hero:HasModifier("modifier_epoch_rune_w_3_invisible") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_epoch_rune_w_3_invisible", EPOCH_W3_INT)
	end
	if hero:HasModifier("modifier_conjuror_a_c_buff_invisible") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_conjuror_a_c_buff_invisible", CustomAttributes.CONJUROR_E1_AGI)
	end
	if hero:HasModifier("modifier_warlord_rune_w_2") then
		local stacks = hero:GetModifierStackCount("modifier_warlord_rune_w_2", hero)
		str_bonus = str_bonus + stacks * CustomAttributes.WARLORD_W2_STATS
		agi_bonus = agi_bonus + stacks * CustomAttributes.WARLORD_W2_STATS
		int_bonus = int_bonus + stacks * CustomAttributes.WARLORD_W2_STATS
	end
	if hero:HasModifier("modifier_hailstorm_strength") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_hailstorm_strength", CustomAttributes.MOUNTAIN_PROTECTOR_R1_ARCANA1_STRENGTH)
	end
	if hero:HasModifier("modifier_chernobog_rune_w_4_inactive") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_chernobog_rune_w_4_inactive", CHERNOBOG_W4_AGI_AND_STR)
	end
	if hero:HasModifier("modifier_chernobog_rune_w_4_active") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_chernobog_rune_w_4_active", CHERNOBOG_W4_AGI_AND_STR)
	end
	if hero:HasModifier("modifier_hydroxis_d_c") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_hydroxis_d_c", HYDROXIS_E4_BONUS_AGI_INT)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_hydroxis_d_c", HYDROXIS_E4_BONUS_AGI_INT)
	end
	if hero:HasModifier("modifier_hydroxis_basin_d_d") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_hydroxis_basin_d_d", HYDROXIS_ARCANA_R4_INT_BONUS)
	end
	if hero:HasModifier("modifier_speedball_d_d_strength") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_speedball_d_d_strength", CustomAttributes.ZHONIK_R4_STR)
	end
	if hero:HasModifier("modifier_arcana_missles_d_d_agility") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_arcana_missles_d_d_agility", CustomAttributes.ZHONIK_ARCANA_R4_AGI)
	end
	if hero:HasModifier("modifier_arkimus_arcana1_q4") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_arkimus_arcana1_q4", ARKIMUS_ARCANA_Q4_AGI)
	end
	if hero:HasModifier("modifier_machinal_jump_d_c_effect") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_machinal_jump_d_c_effect", ARKIMUS_E4_AGI)
	end
	if heroName == "npc_dota_hero_monkey_king" then
		if hero:HasModifier("modifier_shapeshift_cat") then
			agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, hero, "modifier_shapeshift_cat", "draghor_shapeshift_cat", "agility_bonus")
		end
		if hero:HasModifier("modifier_shapeshift_cat_d_d") then
			agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_shapeshift_cat_d_d", CustomAttributes.DJANGHOR_R4_STATS)
		end
		if hero:HasModifier("modifier_shapeshift_bear") then
			str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, hero, "modifier_shapeshift_bear", "draghor_shapeshift_bear", "strength_bonus")
		end
		if hero:HasModifier("modifier_shapeshift_bear_d_d") then
			str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_shapeshift_bear_d_d", CustomAttributes.DJANGHOR_R4_STATS)
		end
		if hero:HasModifier("modifier_shapeshift_crow") then
			int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, hero, "modifier_shapeshift_crow", "draghor_shapeshift_crow", "int_bonus")
		end
		if hero:HasModifier("modifier_shapeshift_crow_d_d") then
			int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_shapeshift_crow_d_d", CustomAttributes.DJANGHOR_R4_STATS)
		end
		if hero:HasModifier("modifier_shapeshift_year_beast") then
			str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, hero, "modifier_shapeshift_yearbest_stats", "draghor_shapeshift_year_beast", "all_attributes_bonus")
			agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, hero, "modifier_shapeshift_yearbest_stats", "draghor_shapeshift_year_beast", "all_attributes_bonus")
			int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, hero, "modifier_shapeshift_yearbest_stats", "draghor_shapeshift_year_beast", "all_attributes_bonus")
		end
		if hero:HasModifier("modifier_shapeshift_yearbeast_d_d") then
			str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_shapeshift_yearbeast_d_d", CustomAttributes.DJANGHOR_R4_ARCANA_STATS)
			agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_shapeshift_yearbeast_d_d", CustomAttributes.DJANGHOR_R4_ARCANA_STATS)
			int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_shapeshift_yearbeast_d_d", CustomAttributes.DJANGHOR_R4_ARCANA_STATS)
		end
	end
	if hero:HasModifier("modifier_warlord_arcana2") then
		local q_4_level = hero:GetRuneValue("q", 4)
		str_bonus = str_bonus + q_4_level*WARLORD_ARCANA2_Q4_ALL_ATTRIBUTES
		agi_bonus = agi_bonus + q_4_level*WARLORD_ARCANA2_Q4_ALL_ATTRIBUTES
		int_bonus = int_bonus + q_4_level*WARLORD_ARCANA2_Q4_ALL_ATTRIBUTES
	end
	if hero:HasModifier("modifier_seinaru_arcana_agility_buff") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_seinaru_arcana_agility_buff", SEINARU_ARCANA_Q3_AGI)
	end

	--RUNES

	if hero:HasModifier("modifier_axe_rune_e_1_invisible") then
		local stacks = CustomAttributes:GetStackWithNoCaster(hero, "modifier_axe_rune_e_1_invisible")
		str_bonus = str_bonus + stacks * CustomAttributes.AXE_Q3_STATS
		agi_bonus = agi_bonus + stacks * CustomAttributes.AXE_Q3_STATS
		int_bonus = int_bonus + stacks * CustomAttributes.AXE_Q3_STATS
	end
	if hero:HasModifier("modifier_astral_d_c_visible") then
		local stacks = CustomAttributes:GetStackWithNoCaster(hero, "modifier_astral_d_c_visible")
		str_bonus = str_bonus + stacks * CustomAttributes.ASTRAL_E4_STATS
		agi_bonus = agi_bonus + stacks * CustomAttributes.ASTRAL_E4_STATS
		int_bonus = int_bonus + stacks * CustomAttributes.ASTRAL_E4_STATS
	end
	-- if hero:HasModifier("modifier_arcane_intellect_visible") then
	-- int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_arcane_intellect_visible", CustomAttributes.SORCERESS_ARCANE_INTELLECT)
	-- end
	if heroName == "npc_dota_hero_beastmaster" then
		if hero:HasModifier("modifier_warlord_rune_q_4_strength") then
			str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_warlord_rune_q_4_strength", CustomAttributes.WARLORD_Q4_STATS)
		end
		if hero:HasModifier("modifier_warlord_rune_q_4_agility") then
			agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_warlord_rune_q_4_agility", CustomAttributes.WARLORD_Q4_STATS)
		end
		if hero:HasModifier("modifier_warlord_rune_q_4_intelligence") then
			int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_warlord_rune_q_4_intelligence", CustomAttributes.WARLORD_Q4_STATS)
		end
	end
	if hero:HasModifier("modifier_bahamut_rune_q_4") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_q_4", CustomAttributes.BAHAMUT_Q4_INT)
	end
	if hero:HasModifier("modifier_bahamut_rune_r_4_buff_invisible") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_r_4_buff_invisible", CustomAttributes.BAHAMUT_R4_STATS)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_r_4_buff_invisible", CustomAttributes.BAHAMUT_R4_STATS)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_r_4_buff_invisible", CustomAttributes.BAHAMUT_R4_STATS)
	end
	if hero:HasModifier("modifier_auriun_rune_e_2") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_2", CustomAttributes.AURIUN_E2_INT)
	end
	if hero:HasModifier("modifier_auriun_rune_e_3_effect") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_3_effect", CustomAttributes.AURIUN_E3_STATS)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_3_effect", CustomAttributes.AURIUN_E3_STATS)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_3_effect", CustomAttributes.AURIUN_E3_STATS)
	end
	if hero:HasModifier("modifier_auriun_rune_r_3_effect_agility") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_r_3_effect_agility", 1)
	end
	if hero:HasModifier("modifier_auriun_rune_r_3_effect_strength") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_r_3_effect_strength", 1)
	end
	if hero:HasModifier("modifier_mountain_protector_rune_e_2") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_mountain_protector_rune_e_2", CustomAttributes.MOUNTAIN_PROTECTOR_E2_STR)
	end
	if hero:HasModifier("modifier_mountain_protector_rune_r_2_invisible") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_mountain_protector_rune_r_2_invisible", MOUNTAIN_PROTECTOR_R2_STRENGTH_PER_STACK)
	end
	if hero:HasModifier("modifier_trapper_rune_r_4_bonus_agi") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_trapper_rune_r_4_bonus_agi", CustomAttributes.TRAPPER_R4_AGI)
	end
	if hero:HasModifier("shadow_deity_agility_from_gear") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "shadow_deity_agility_from_gear", 1)
	end
	if hero:HasModifier("modifier_lightbomb_q_1") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_lightbomb_q_1", SEPHYR_Q1_INT_BONUS)
	end
	if hero:HasModifier("modifier_nefali_d_d") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_nefali_d_d", SEPHYR_R4_BONUS_AGI)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_nefali_d_d", SEPHYR_R4_BONUS_INT)
	end
	if hero:HasModifier("modifier_venomort_bonus_stats") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_venomort_bonus_stats", VENOMORT_W3_BONUS_ATTRIBUTES)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_venomort_bonus_stats", VENOMORT_W3_BONUS_ATTRIBUTES)
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_venomort_bonus_stats", VENOMORT_W3_BONUS_ATTRIBUTES)
	end
	if hero:HasModifier("modifier_conjuror_arcana2") then
		str_bonus = str_bonus - CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_w_4_str_decrease", 1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_w_4_agi_increase", 1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_w_4_int_increase", 1)
	end
	if hero:HasModifier("modifier_onibi_all_attributes") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_onibi_all_attributes", 2)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_onibi_all_attributes", 2)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_onibi_all_attributes", 2)
	end
	if heroName == "npc_dota_hero_antimage" then
		if hero:HasAbility('arkimus_zap_ring') then
			local q1_level = hero:GetRuneValue('q', 1)
			int_bonus = int_bonus + q1_level * ARKIMUS_ARCANA1_Q1_INT
		end
	end
	if hero:HasModifier("modifier_jex_oak_infusion_strength") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_jex_oak_infusion_strength", CustomAttributes.JEX_OAK_INFUSION_RUNE_STRENGTH)
	end
	-- ENEMIES --

	if hero:HasModifier("modifier_warden_of_death_debuff") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_warden_of_death_debuff", "warden_of_death_ability", "stat_loss")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_warden_of_death_debuff", "warden_of_death_ability", "stat_loss")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_warden_of_death_debuff", "warden_of_death_ability", "stat_loss")
	end
	if hero:HasModifier("modifier_prison_shank_effect") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect", "water_temple_prison_shank", "strength_loss")
	end
	if hero:HasModifier("modifier_agility_aura_effect") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_agility_aura_effect", "fire_temple_agility_aura", "agility_loss")
	end
	if hero:HasModifier("modifier_strength_aura_effect") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_strength_aura_effect", "fire_temple_strength_aura", "strength_loss")
	end
	if hero:HasModifier("modifier_blessing_of_maru") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_blessing_of_maru", "redfall_ability", "maru_blessing")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_blessing_of_maru", "redfall_ability", "maru_blessing")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_blessing_of_maru", "redfall_ability", "maru_blessing")
	end
	if hero:HasModifier("modifier_demon_farmer_aura_effect") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_str", -1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_agi", -1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_int", -1)
	end
	if hero:HasModifier("modifier_meta_slark_debuff") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_meta_slark_debuff", "tanari_meta_slark_passive", "attribute_loss")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_meta_slark_debuff", "tanari_meta_slark_passive", "attribute_loss")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_meta_slark_debuff", "tanari_meta_slark_passive", "attribute_loss")
	end
	if hero:HasModifier("modifier_prison_shank_effect_sea") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect_sea", "sea_shank", "stats_loss")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect_sea", "sea_shank", "stats_loss")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect_sea", "sea_shank", "stats_loss")
	end
	if hero:HasModifier("modifier_water_medusa_stat_loss") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_water_medusa_stat_loss", "water_medusa_passive", "stat_loss")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_water_medusa_stat_loss", "water_medusa_passive", "stat_loss")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_water_medusa_stat_loss", "water_medusa_passive", "stat_loss")
	end
	if hero:HasModifier("modifier_sea_oracle_stats_debuff") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_str", -1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_agi", -1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_int", -1)
	end
	if hero:HasModifier("modifier_secret_keeper_agi_loss") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_secret_keeper_agi_loss", -1)
	end
	if hero:HasModifier("modifier_stonewall_aura_axe_armor_strength") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_stonewall_aura_axe_armor_strength", CustomAttributes.AXE_ARCANA2_W2_STRENGTH)
	end
	if hero:HasModifier("modifier_omnimace_wind_buff") then
		local ability = hero:FindAbilityByName("omniro_omni_mace")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_omnimace_wind_buff", ability:GetSpecialValueFor("wind_special_a"))
	end
	if hero:HasModifier("modifier_ice_scathe_q2_shield") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ice_scathe_q2_shield", WARLORD_ARCANA2_Q2_INT_BONUS)
	end
	-- BASIC ITEMS STATS --
	str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_helm_strength", 1)
	agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_helm_agility", 1)
	int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_helm_intelligence", 1)

	str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_hand_strength", 1)
	agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_hand_agility", 1)
	int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_hand_intelligence", 1)

	str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_foot_strength", 1)
	agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_foot_agility", 1)
	int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_foot_intelligence", 1)

	str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_body_strength", 1)
	agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_body_agility", 1)
	int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_body_intelligence", 1)

	str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_trinket_strength", 1)
	agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_trinket_agility", 1)
	int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_trinket_intelligence", 1)

	str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_weapon_strength", 1)
	agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_weapon_agility", 1)
	int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero.InventoryUnit, "modifier_weapon_intelligence", 1)

	-- SPECIAL ITEMS STATS --

	if hero:HasModifier("modifier_empyreal_sunrise_robe") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_empyreal_str", 1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_empyreal_agi", 1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_empyreal_int", 1)
	end
	if hero:HasModifier("modifier_eye_of_seasons_stats") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_eye_of_seasons_stats", 1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_eye_of_seasons_stats", 1)
	end
	if hero:HasModifier("modifier_dark_arts_effect") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_dark_arts_effect", 1)
	end
	if hero:HasModifier("modifier_blazing_fury_effect") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_blazing_fury_effect", 1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_blazing_fury_effect", 1)
	end
	if hero:HasModifier("modifier_legion_vestments") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_legion_vestments_effect_str", 1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_legion_vestments_effect_agi", 1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_legion_vestments_effect_int", 1)
	end
	if hero:HasModifier("modifier_gold_plate_of_leon") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_gold_plate_of_leon_str", 1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_gold_plate_of_leon_agi", 1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_gold_plate_of_leon_int", 1)
	end
	if hero:HasModifier("modifier_mageplate_intelligence") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_mageplate_intelligence", 1)
	end
	if hero:HasModifier("modifier_ring_of_nobility") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ring_of_nobility_buff", CustomAttributes.RING_OF_NOBILITY)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ring_of_nobility_buff", CustomAttributes.RING_OF_NOBILITY)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ring_of_nobility_buff", CustomAttributes.RING_OF_NOBILITY)
	end
	if hero:HasModifier("modifier_ring_of_nobility_augmented") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ring_of_nobility_buff_augmented", CustomAttributes.RING_OF_NOBILITY2)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ring_of_nobility_buff_augmented", CustomAttributes.RING_OF_NOBILITY2)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ring_of_nobility_buff_augmented", CustomAttributes.RING_OF_NOBILITY2)
	end
	if hero:HasModifier("modifier_azure_empire") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_azure_empire_strength", CustomAttributes.AZURE_EMPIRE_STATS)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_azure_empire_agility", CustomAttributes.AZURE_EMPIRE_STATS)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_azure_empire_intelligence", CustomAttributes.AZURE_EMPIRE_STATS)
	end
	if hero:HasModifier("modifier_wind_orchid_agility_bonus") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_wind_orchid_agility_bonus", CustomAttributes.WIND_ORCHID_AGI_PER_E4)
	end
	if hero:HasModifier("modifier_captains_vest") then
		if hero:HasModifier("modifier_captains_vest_str") then
			str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_captains_vest_str", CAPTAINS_VEST_INTERNAL_MULTIPLIER_OF_STACKS)
		end
		if hero:HasModifier("modifier_captains_vest_agi") then
			agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_captains_vest_agi", CAPTAINS_VEST_INTERNAL_MULTIPLIER_OF_STACKS)
		end
		if hero:HasModifier("modifier_captains_vest_int") then
			int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_captains_vest_int", CAPTAINS_VEST_INTERNAL_MULTIPLIER_OF_STACKS)
		end
	end
	if hero:HasModifier("modifier_aqua_lily_intelligence_bonus") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_aqua_lily_intelligence_bonus", CustomAttributes.AQUA_LILY_INT_PER_R4)
	end
	if hero:HasModifier("modifier_fire_blossom_strength_bonus") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_fire_blossom_strength_bonus", CustomAttributes.FIRE_BLOSSOM_STR_PER_W4)
	end
	if hero:HasModifier("modifier_solunia_d_d_stats") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_solunia_d_d_stats", SOLUNIA_ARCANA_R4_ATTRIBUTES)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_solunia_d_d_stats", SOLUNIA_ARCANA_R4_ATTRIBUTES)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_solunia_d_d_stats", SOLUNIA_ARCANA_R4_ATTRIBUTES)
	end
	if hero:HasModifier("modifier_arcane_intellect_visible") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_arcane_intellect_visible", CustomAttributes.SORCERESS_ARCANE_INT)
	end
	if hero:HasModifier("modifier_flamewaker_weapon_agility") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_flamewaker_weapon_agility", CustomAttributes.FLAMEWAKER_WEAPON_2_AGI)
	end
	if hero:HasModifier("modifier_seinaru_immo_weapon_3_strength") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_seinaru_immo_weapon_3_strength", CustomAttributes.SEINARU_WEAPON_3_STR)
	end
	if hero:HasModifier("modifier_neutral_glyph_1_1") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_neutral_glyph_1_1", CustomAttributes.NEUTRAL_GLYPH_1)
	end
	if hero:HasModifier("modifier_neutral_glyph_7_1") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_neutral_glyph_7_1", 1)
	end
	if hero:HasModifier("modifier_neutral_glyph_1_2") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_neutral_glyph_1_2", CustomAttributes.NEUTRAL_GLYPH_1)
	end
	if hero:HasModifier("modifier_neutral_glyph_7_2") then
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_neutral_glyph_7_2", 1)
	end
	if hero:HasModifier("modifier_neutral_glyph_1_3") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_neutral_glyph_1_3", CustomAttributes.NEUTRAL_GLYPH_1)
	end
	if hero:HasModifier("modifier_neutral_glyph_7_3") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_neutral_glyph_7_3", 1)
	end
	if hero:HasModifier("modifier_mountain_protector_glyph_5_a") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_mountain_protector_glyph_5_a", CustomAttributes.MOUNTAIN_PROTECTOR_GLYPH_5_A)
	end
	if hero:HasModifier("modifier_red_divinex_amulet") then
		local stat_bonus = hero:GetBaseStrength()
		local modifier = hero:FindModifierByName('modifier_red_divinex_amulet')
		modifier.stat_bonus = stat_bonus
		str_bonus = str_bonus + stat_bonus
		agi_bonus = 0
		int_bonus = 0
	elseif hero:HasModifier("modifier_green_divinex_amulet") then
		local stat_bonus = hero:GetBaseAgility()
		local modifier = hero:FindModifierByName('modifier_green_divinex_amulet')
		modifier.stat_bonus = stat_bonus
		agi_bonus = agi_bonus + stat_bonus
		str_bonus = 0
		int_bonus = 0
	elseif hero:HasModifier("modifier_blue_divinex_amulet") then
		local stat_bonus = hero:GetBaseIntellect()
		local modifier = hero:FindModifierByName('modifier_blue_divinex_amulet')
		modifier.stat_bonus = stat_bonus
		int_bonus = int_bonus + stat_bonus
		str_bonus = 0
		agi_bonus = 0
	end

	strength = math.max(strength + str_bonus, 0)
	agility = math.max(agility + agi_bonus, 0)
	intelligence = math.max(intelligence + int_bonus, 0)
	hero.str_bonus = str_bonus
	hero.agi_bonus = agi_bonus
	hero.int_bonus = int_bonus

	CustomNetTables:SetTableValue("hero_index", tostring(hero:GetEntityIndex() .. "_custom_attributes"), {strength = tostring(strength), agility = tostring(agility), intelligence = tostring(intelligence)})
end

function CustomAttributes:AddStatsBonusFromStacks(hero, caster, modifierName, statPerStack)
	if hero:FindModifierByName(modifierName) == nil then
		return 0
	end
	if caster == nil then
		caster = hero:FindModifierByName(modifierName):GetCaster()
	end
	local stacks = hero:GetModifierStackCount(modifierName, caster)
	stacks = math.max(stacks, 1)
	return stacks * statPerStack
end

function CustomAttributes:GetStackWithNoCaster(hero, modifierName)
	local caster = hero:FindModifierByName(modifierName):GetCaster()
	return hero:GetModifierStackCount(modifierName, caster)
end

function CustomAttributes:AddStatsBonusFromAbility(hero, caster, modifierName, abilityName, specialName)
	local bonus = 0
	if caster == nil then
		caster = hero:FindModifierByName(modifierName):GetCaster()
	end
	local ability = caster:FindAbilityByName(abilityName)
	if ability then
		local stacks = hero:GetModifierStackCount(modifierName, caster)
		stacks = math.max(stacks, 1)
		bonus = ability:GetLevelSpecialValueFor(specialName, ability:GetLevel()) * stacks
	end
	return bonus
end

function CustomAttributes:CalcMovespeed(unit)
	Timers:CreateTimer(0, function()
		unit:RemoveModifierByName("modifier_master_movespeed")
		local baseSpeed = unit:GetBaseMoveSpeed()
		local modifier = unit:GetMoveSpeedModifier(baseSpeed, false)
		local modifier2 = unit:GetMoveSpeedModifier(0, false)
		local ideal = unit:GetIdealSpeed()
		if modifier2 > 100 then
			unit.master_move_speed = modifier2 + baseSpeed
			unit:AddNewModifier(unit, nil, "modifier_master_movespeed", {})
			return 0.1
		else
			unit.master_move_speed = nil
			unit:RemoveModifierByName("modifier_master_movespeed")
		end
	end)
end

function CustomAttributes:ApplyStatBonusesToHero(hero)
	local caster = hero.InventoryUnit
	local ability = hero.InventoryUnit:FindAbilityByName("attribute_bonuses")
	local strength = hero:GetStrength()
	local agility = hero:GetAgility()
	local intelligence = hero:GetIntellect()
	local halcyon = 1
	if hero:HasModifier("modifier_halcyon_soul_glove") then
		halcyon = 1 + HALCYON_SOUL_GLOVE_BONUS
	end
	if hero:HasModifier("modifier_frozen_heart") then
		hero:RemoveModifierByName("modifier_strength_health")
	else
		if not hero:HasModifier("modifier_strength_health") then
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_strength_health", {})
		end
		local healthStacks = CustomAttributes:GetMaxHealth(hero)
		if not hero:GetModifierStackCount("modifier_strength_health", caster) == healthStacks then
			local healthPercentFreeze = hero:GetHealth() / hero:GetMaxHealth()
			Timers:CreateTimer(0.03, function()
				if hero:IsAlive() then
					hero:SetHealth(math.max(hero:GetMaxHealth() * healthPercentFreeze, 1))
				else
					if hero:GetHealth() == 0 then
						hero:ForceKill(false)
					end
				end
			end)
		end
		hero:SetModifierStackCount("modifier_strength_health", caster, healthStacks)
	end
	if not hero:HasModifier("modifier_strength_health_regen") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_strength_health_regen", {})
	end
	hero:SetModifierStackCount("modifier_strength_health_regen", caster, strength * CustomAttributes.HEALTH_REGEN_PER_STR * halcyon)

	if not hero:HasModifier("modifier_agility_attackspeed") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_agility_attackspeed", {})
	end
	hero:SetModifierStackCount("modifier_agility_attackspeed", caster, agility * CustomAttributes.ATTACKSPEED_PER_AGI * halcyon)

	-- if not hero:HasModifier("modifier_agility_armor") then
	-- ability:ApplyDataDrivenModifier(caster, hero, "modifier_agility_armor", {})
	-- end
	-- hero:SetModifierStackCount("modifier_agility_armor", caster, agility*CustomAttributes.ARMOR_PER_AGI)
	local armor = agility * CustomAttributes.ARMOR_PER_AGI * halcyon + 10
	hero:SetPhysicalArmorBaseValue(armor)

	if not hero:HasModifier("modifier_int_mana") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_int_mana", {})
	end
	hero:SetModifierStackCount("modifier_int_mana", caster, intelligence * CustomAttributes.MANA_PER_INT * halcyon)

	if not hero:HasModifier("modifier_int_mana_regen") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_int_mana_regen", {})
	end
	hero:SetModifierStackCount("modifier_int_mana_regen", caster, intelligence * CustomAttributes.MANA_REGEN_PER_INT * halcyon)

	local damage_from_primary = Filters:GetPrimaryAttributeMultiple(hero, CustomAttributes.ATK_DMG_PER_PRIMARY * halcyon)
	if not hero:HasModifier("modifier_primary_attribute_damage") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_primary_attribute_damage", {})
	end
	hero:SetModifierStackCount("modifier_primary_attribute_damage", caster, damage_from_primary)
	hero:CalculateStatBonus()
end

function CustomAttributes:GetMaxHealth(hero, excludedModifier)
	return CustomAttributes:GetBaseHealth(hero, excludedModifier) * CustomAttributes:GetPercentHealthMutliplier(hero, excludedModifier) - 1000 --1000 hp base hp, base hp cant be changed with Code thats why its substracted again
end

function CustomAttributes:GetBaseHealth(hero, excludedModifier)
	local flatHealthBonus = 1000 --Each hero starts with 1000 hp, this is important so that its multiplied with helm of mountain giant for example
	flatHealthBonus = flatHealthBonus + hero:GetStrength() * CustomAttributes.HEALTH_PER_STR
	if excludedModifier ~= "modifier_halcyon_soul_glove" and hero:HasModifier("modifier_halcyon_soul_glove") then
		flatHealthBonus = flatHealthBonus + hero:GetStrength() * CustomAttributes.HEALTH_PER_STR * HALCYON_SOUL_GLOVE_BONUS
	end
	if excludedModifier ~= "modifier_helm_max_health" and hero:HasModifier("modifier_helm_max_health") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_helm_max_health", 1)
	end
	if excludedModifier ~= "modifier_hand_max_health" and hero:HasModifier("modifier_hand_max_health") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_hand_max_health", 1)
	end
	if excludedModifier ~= "modifier_foot_max_health" and hero:HasModifier("modifier_foot_max_health") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_foot_max_health", 1)
	end
	if excludedModifier ~= "modifier_body_max_health" and hero:HasModifier("modifier_body_max_health") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_body_max_health", 1)
	end
	if excludedModifier ~= "modifier_trinket_max_health" and hero:HasModifier("modifier_trinket_max_health") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_trinket_max_health", 1)
	end
	if excludedModifier ~= "modifier_venomort_e4_hero_bonus_invisible" and hero:HasModifier("modifier_venomort_e4_hero_bonus_invisible") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_venomort_e4_hero_bonus_invisible", VENOMORT_E4_HP_PER_ENEMY)
	end
	if excludedModifier ~= "modifier_solunia_rune_e_4_effect" and hero:HasModifier("modifier_solunia_rune_e_4_effect") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_solunia_rune_e_4_effect", SOLUNIA_E4_HP)
	end
	if excludedModifier ~= "modifier_bear_b_d" and hero:HasModifier("modifier_bear_b_d") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bear_b_d", CustomAttributes.DJANGHOR_BEAR_MAX_HEALTH)
	end
	if excludedModifier ~= "modifier_tyrius_buff" and hero:HasModifier("modifier_tyrius_buff") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_tyrius_buff", CustomAttributes.TYRIUS_HEALTH)
	end
	if excludedModifier ~= "modifier_ogthun_health" and hero:HasModifier("modifier_ogthun_health") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_ogthun_health", CustomAttributes.OGTHUN_HEALTH)
	end
	if excludedModifier ~= "modifier_rpc_sange_buff" and hero:HasModifier("modifier_rpc_sange_buff") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_rpc_sange_buff", CustomAttributes.SANGE_HEALTH)
	end
	if excludedModifier ~= "modifier_sapphire_lotus_buff" and hero:HasModifier("modifier_sapphire_lotus_buff") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_sapphire_lotus_buff", CustomAttributes.SAPPHIRE_LOTUS_HEALTH)
	end
	if excludedModifier ~= "modifier_paladin_immortal_weapon_3_health" and hero:HasModifier("modifier_paladin_immortal_weapon_3_health") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_paladin_immortal_weapon_3_health", CustomAttributes.PALADIN_IMMO_3_HEALTH)
	end
	if excludedModifier ~= "modifier_redrock_footwear_health_increase" and hero:HasModifier("modifier_redrock_footwear_health_increase") then
		flatHealthBonus = flatHealthBonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_redrock_footwear_health_increase", CustomAttributes.REDROCK_HEALTH)
	end
	if excludedModifier ~= "modifier_earth_deity_q_2" and hero:HasModifier("modifier_earth_deity_q_2") then
		flatHealthBonus = flatHealthBonus + CONJUROR_ARCANA_Q2_FLAT_HEALTH * hero:GetRuneValue("q", 2)
	end
	if excludedModifier ~= "modifier_omnimace_cosmic_buff" and hero:HasModifier("modifier_omnimace_cosmic_buff") then
		local ability = hero:FindAbilityByName("omniro_omni_mace")
		flatHealthBonus = flatHealthBonus + ability:GetSpecialValueFor("cosmic_special_a") * hero.omniro_data[RPC_ELEMENT_COSMOS]["level"]
	end
	return flatHealthBonus
end

function CustomAttributes:GetPercentHealthMutliplier(hero, excludedModifier)
	local percentHealthMultiplier = 1
	if excludedModifier ~= "modifier_helm_of_the_mountain_giant" and hero:HasModifier("modifier_helm_of_the_mountain_giant") then
		percentHealthMultiplier = percentHealthMultiplier + HELM_OF_THE_MOUNTAIN_GIANT_PERCENT_HEALTH / 100
	end
	if excludedModifier ~= "modifier_earth_deity_q_2" and hero:HasModifier("modifier_earth_deity_q_2") then
		percentHealthMultiplier = percentHealthMultiplier + CONJUROR_ARCANA_Q2_PERCENT_HEALTH / 100 * hero:GetRuneValue("q", 2)
	end
	return percentHealthMultiplier
end

function CustomAttributes:ActivateStatsTooltip(msg)
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return end
	local unit = EntIndexToHScript(msg.queryunit)
	local player = PlayerResource:GetPlayer(msg.playerID)
	local tableData = {}
	tableData.phys = (1 - GameState:IncomingDamageDecreaseWithType(unit, Events.GameMaster, false, DAMAGE_TYPE_PHYSICAL)) * 100
	tableData.magic = (1 - GameState:IncomingDamageDecreaseWithType(unit, Events.GameMaster, false, DAMAGE_TYPE_MAGICAL)) * 100
	tableData.pure = (1 - GameState:IncomingDamageDecreaseWithType(unit, Events.GameMaster, false, DAMAGE_TYPE_PURE)) * 100

	tableData.phys = tostring(tableData.phys - (GameState:IncomingDamageIncrease(unit, Events.GameMaster, false, DAMAGE_TYPE_PHYSICAL) - 1) * 100)
	tableData.magic = tostring(tableData.magic - (GameState:IncomingDamageIncrease(unit, Events.GameMaster, false, DAMAGE_TYPE_MAGICAL) - 1) * 100)
	tableData.pure = tostring(tableData.pure - (GameState:IncomingDamageIncrease(unit, Events.GameMaster, false, DAMAGE_TYPE_PURE) - 1) * 100)
	local level = unit:GetLevel()
	if unit:IsHero() then
		unit.q_4_level = unit:GetRuneValue("q", 4)
		unit.w_4_level = unit:GetRuneValue("w", 4)
		unit.e_4_level = unit:GetRuneValue("e", 4)
		unit.r_4_level = unit:GetRuneValue("r", 4)
	else
		if unit.itemLevel then
			level = math.ceil(unit.itemLevel / 4)
		else
			level = 20
		end
		level = math.min(level + (GameState:GetDifficultyFactor() - 1) * 35, 120)
		if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
			GameState:FilterDamage({entindex_victim_const = unit:GetEntityIndex(), entindex_attacker_const = Events.GameMaster:GetEntityIndex(), damage = 10000000000, damagetype_const = DAMAGE_TYPE_PHYSICAL, entindex_inflictor_const = Events.GameMasterAbility:GetEntityIndex()})
			GameState:FilterDamage({entindex_victim_const = unit:GetEntityIndex(), entindex_attacker_const = Events.GameMaster:GetEntityIndex(), damage = 10000000000, damagetype_const = DAMAGE_TYPE_MAGICAL, entindex_inflictor_const = Events.GameMasterAbility:GetEntityIndex()})
			GameState:FilterDamage({entindex_victim_const = unit:GetEntityIndex(), entindex_attacker_const = Events.GameMaster:GetEntityIndex(), damage = 10000000000, damagetype_const = DAMAGE_TYPE_PURE, entindex_inflictor_const = Events.GameMasterAbility:GetEntityIndex()})
			tableData.phys = tostring(unit.resist_phys * 100)
			tableData.magic = tostring(unit.resist_mag * 100)
			tableData.pure = tostring(unit.resist_pure * 100)
		end
	end
	local victim = unit
	local attacker = player:GetAssignedHero()
	local IsEnemy = true
	if unit:IsHero() then
		IsEnemy = false
		victim = Events.GameMaster
		attacker = unit
	end
	tableData.elements = {}
	local damageDealt = 1000
	local damageNORMAL = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageNORMAL / damageDealt))
	local damageFIRE = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageFIRE / damageDealt))
	local damageEARTH = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageEARTH / damageDealt))
	local damageLIGHTNING = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageLIGHTNING / damageDealt))
	local damagePOISON = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damagePOISON / damageDealt))
	local damageTIME = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageTIME / damageDealt))
	local damageHOLY = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageHOLY / damageDealt))
	local damageCOSMOS = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageCOSMOS / damageDealt))
	local damageICE = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageICE / damageDealt))
	local damageARCANE = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageARCANE / damageDealt))
	local damageSHADOW = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageSHADOW / damageDealt))
	local damageWIND = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_WIND, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageWIND / damageDealt))
	local damageGHOST = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageGHOST / damageDealt))
	local damageWATER = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageWATER / damageDealt))
	local damageDEMON = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageDEMON / damageDealt))
	local damageNATURE = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageNATURE / damageDealt))
	local damageUNDEAD = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_UNDEAD, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageUNDEAD / damageDealt))
	local damageDragon = Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_DRAGON, RPC_ELEMENT_NONE, false)
	table.insert(tableData.elements, math.floor(damageDragon / damageDealt))
	tableData.halcyon = 0
	if IsEnemy then
		for k, v in pairs(tableData.elements) do
			tableData.elements[k] = -(v - 100)
		end
	end
	GameState:FilterDamage({entindex_victim_const = victim:GetEntityIndex(), entindex_attacker_const = attacker:GetEntityIndex(), damage = 1, damagetype_const = DAMAGE_TYPE_PHYSICAL, entindex_inflictor_const = Events.GameMasterAbility:GetEntityIndex()})
	GameState:FilterDamage({entindex_victim_const = victim:GetEntityIndex(), entindex_attacker_const = attacker:GetEntityIndex(), damage = 1, damagetype_const = DAMAGE_TYPE_MAGICAL, entindex_inflictor_const = Events.GameMasterAbility:GetEntityIndex()})
	GameState:FilterDamage({entindex_victim_const = victim:GetEntityIndex(), entindex_attacker_const = attacker:GetEntityIndex(), damage = 1, damagetype_const = DAMAGE_TYPE_PURE, entindex_inflictor_const = Events.GameMasterAbility:GetEntityIndex()})
	if victim.physical_damage_mult then
		tableData.phys_post_mit = victim.physical_damage_mult
	else
		tableData.phys_post_mit = 100
	end
	if victim.magical_damage_mult then
		tableData.magic_post_mit = victim.magical_damage_mult
	else
		tableData.magic_post_mit = 100
	end
	if victim.pure_damage_mult then
		tableData.pure_post_mit = victim.pure_damage_mult
	else
		tableData.pure_post_mit = 100
	end
	tableData.item_damage = Filters:AdjustItemDamage(attacker, 1000000000, victim) / 10000000
	if unit:HasModifier("modifier_halcyon_soul_glove") then
		tableData.halcyon = 1
	end
	if unit.paragon then
		tableData.paragon = 1
	end
	tableData.level = level
	local baseDamage = 100000
	local qDamage = Filters:TakeArgumentsAndApplyDamage(Events.GameMaster, unit, baseDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_Q, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE, true)
	tableData.qAmp = math.floor((qDamage / baseDamage) * 100)
	local wDamage = Filters:TakeArgumentsAndApplyDamage(Events.GameMaster, unit, baseDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_W, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE, true)
	tableData.wAmp = math.floor((wDamage / baseDamage) * 100)
	local eDamage = Filters:TakeArgumentsAndApplyDamage(Events.GameMaster, unit, baseDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_E, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE, true)
	tableData.eAmp = math.floor((eDamage / baseDamage) * 100)
	local rDamage = Filters:TakeArgumentsAndApplyDamage(Events.GameMaster, unit, baseDamage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE, true)
	tableData.rAmp = math.floor((rDamage / baseDamage) * 100)
	CustomGameEventManager:Send_ServerToPlayer(player, "attribute_tooltip", {unit = msg.queryunit, playerID = msg.playerID, extraData = tableData, IsEnemy = IsEnemy})
	Events:TutorialServerEvent(unit, "1_3", 0)
end

CustomAttributes.MS_CAP_MODIFIERS = {
	modifier_arkimus_speed_dash = 1300,
	modifier_axe_immortal_weapon_2_cap = 820,
	modifier_dinath_passive_ms_cap = "modifier_dinath_passive_ms_cap",
	modifier_draghor_feral_sprint = "modifier_draghor_feral_sprint",
	modifier_movespeed_cap = 1400,
	modifier_movespeed_cap_glyph = 620,
	modifier_movespeed_cap_heat_wave = 640,
	modifier_movespeed_cap_sonic = 750,
	modifier_movespeed_cap_super = 5200,
	modifier_movespeed_cap_shadow_walk_1 = 640,
	modifier_disciple_bonus_movespeed = 800,
	modifier_seinaru_glyph_t21_movespeed_cap = "modifier_seinaru_glyph_t21_movespeed_cap",
	slipfinn_shadow_rush_lua = "slipfinn_shadow_rush_lua",
	modifier_zonik_lightspeed_cap = "modifier_zonik_lightspeed_cap",
	modifier_zonik_speedball_cap = "modifier_zonik_speedball_cap",
	modifier_zonik_temporal_field_cap = "modifier_zonik_temporal_field_cap",
}

function CustomAttributes:MSCap(unit)
	local buffs = unit:FindAllModifiers()
	local max_ms = 550
	for _,modifier in pairs(buffs) do
		if modifier['GetModifierMoveSpeed_Max'] then
			-- Some GetModifierMoveSpeed_Max has errors now, it is for preven crash on calculate
			local status, local_max_ms = pcall(modifier['GetModifierMoveSpeed_Max'], modifier, {})
			if status and local_max_ms ~= nil then
				max_ms = math.max(max_ms,local_max_ms)
			end
		end
	end
	for _,modifier in pairs(buffs) do -- New way for increase limit instead of set
		if modifier['GetModifierMoveSpeed_Max_Increase'] then
			local status, bonus_max_ms = pcall(modifier['GetModifierMoveSpeed_Max_Increase'], modifier, {})
			if status and bonus_max_ms ~= nil then
				max_ms = max_ms + bonus_max_ms
			end
		end
	end
	local local_max_ms = 550
	for i = 1, #buffs, 1 do
		local modifier = buffs[i]
		local ms_cap_modifier = CustomAttributes.MS_CAP_MODIFIERS[modifier:GetName()]
		if ms_cap_modifier then
			if type(ms_cap_modifier) == "number" then
				local_max_ms = math.max(local_max_ms, ms_cap_modifier)
			elseif type(ms_cap_modifier) == "string" then
				local modifier_ability = modifier:GetAbility()
				if ms_cap_modifier == "modifier_dinath_passive_ms_cap" then
					local_max_ms = math.max(local_max_ms, modifier_ability.w_3_level * 5 + local_max_ms)
				elseif ms_cap_modifier == "modifier_draghor_feral_sprint" then
					local_max_ms = math.max(local_max_ms, modifier_ability:GetSpecialValueFor("movespeed_cap"))
				elseif ms_cap_modifier == "modifier_seinaru_glyph_t21_movespeed_cap" then
					local q2_level = unit:GetRuneValue("q", 2)
					local_max_ms = math.max(local_max_ms, 550 + q2_level * SEINARU_GLYPH2_MOVESPEED_CAP_PER_Q2)
				elseif ms_cap_modifier == "slipfinn_shadow_rush_lua" then
					local decay = modifier:GetRemainingTime() / unit.baseShadowRushDuration
					local msBonus = unit:FindAbilityByName("slipfinn_shadow_rush"):GetLevelSpecialValueFor("ms_bonus_and_max", modifier:GetAbility():GetLevel())
					local_max_ms = math.max(msBonus * decay, local_max_ms)
				elseif ms_cap_modifier == "modifier_zonik_lightspeed_cap" then
					local cap = 600
					cap = modifier:GetAbility():GetSpecialValueFor("movespeed_cap") + modifier_ability.e_4_level * ZHONIK_E4_MS_CAP_INCREASE
					if unit:HasModifier("modifier_zonik_speedball") then
						cap = cap + 600
					end
					if unit:HasModifier("modifier_zonik_glyph_5_1") then
						cap = cap + 200
					end
					local_max_ms = math.max(cap, local_max_ms)
				elseif ms_cap_modifier == "modifier_zonik_speedball_cap" then
					local cap = 550 + modifier_ability:GetSpecialValueFor("movespeed_cap")
					if unit:HasModifier("modifier_zonik_lightspeed") then
						cap = cap + unit:FindAbilityByName("zonik_lightspeed"):GetSpecialValueFor("movespeed_cap") - 550
					end
					if unit:FindAbilityByName("zonik_lightspeed") and unit:FindAbilityByName("zonik_lightspeed").e_4_level and unit:HasModifier("modifier_zonik_lightspeed") then
						cap = cap + ZHONIK_E4_MS_CAP_INCREASE * unit:FindAbilityByName("zonik_lightspeed").e_4_level
					end
					if unit:HasModifier("modifier_zonik_lightspeed") and unit:HasModifier("modifier_zonik_glyph_5_1") then
						cap = cap + 200
					end
					local_max_ms = math.max(cap, local_max_ms)
				elseif ms_cap_modifier == "modifier_zonik_temporal_field_cap" then
					local_max_ms = math.max(modifier_ability:GetSpecialValueFor("movespeed_cap"), local_max_ms)
				end
			end
		end
	end
	max_ms = math.max(local_max_ms, max_ms)
	if unit:HasModifier("modifier_knight_hawk_helm") then
		max_ms = max_ms + KNIGHT_HAWK_MAX_MOVESPEED_LIMIT
	end
	if unit:HasModifier("modifier_pegasus_boots") then
		max_ms = max_ms + max_ms*(PEGASUS_MAX_MS_AMP_PCT/100)
	end
	return max_ms
end

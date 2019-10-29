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
require("/heroes/moon_ranger/astral_ranger_constants")
require("/heroes/leshrac/bahamut_constants")

require('items/constants/boots')
require('items/constants/chest')
require('items/constants/gloves')
require('items/constants/helm')
require('items/constants/trinket')

CustomAttributes.HEALTH_PER_STR = 10
CustomAttributes.HEALTH_REGEN_PER_STR = 0.5
CustomAttributes.ARMOR_PER_STR = 1

CustomAttributes.ATTACKSPEED_PER_AGI = 0.3
CustomAttributes.MOVESPEED_PER_AGI = 0.1
CustomAttributes.ARMOR_PIERCE_PER_AGI = 1

CustomAttributes.MANA_PER_INT = 5
CustomAttributes.MANA_REGEN_PER_INT = 0.5
CustomAttributes.SPELL_PIERCE_PER_INT = 1

CustomAttributes.STATUS_RESIST_PER_SPIRIT = 0.01
CustomAttributes.BAD_PER_SPIRIT = 0.1
CustomAttributes.MAGIC_ARMOR_PER_SPIRIT = 1

CustomAttributes.ATK_DMG_PER_PRIMARY = 1

CustomAttributes.CONJUROR_E1_AGI = CONJUROR_E1_BONUS_AGI
CustomAttributes.WARLORD_W2_STATS = 60
CustomAttributes.MOUNTAIN_PROTECTOR_R1_ARCANA1_STRENGTH = MOUNTAIN_PROTECTOR_ARCANA2_R1_STR_BONUS
CustomAttributes.HYDROXIS_E4_AGI_INT = 350

CustomAttributes.ZHONIK_R4_STR = ZHONIK_R4_BONUS_STR
CustomAttributes.ZHONIK_ARCANA_R4_AGI = ZHONIK_R4_ARCANA_BONUS_AGI

CustomAttributes.DJANGHOR_R4_STATS = DJANGHOR_R4_BONUS_ATTRIBUTE
CustomAttributes.DJANGHOR_R4_ARCANA_STATS = DJANGHOR_ARCANA_R_R4_BONUS_ATTRIBUTE
CustomAttributes.AXE_Q3_STATS = 14

CustomAttributes.SORCERESS_ARCANE_INTELLECT = 50
CustomAttributes.BAHAMUT_Q4_INT = BAHAMUT_Q4_INT_BONUS
CustomAttributes.BAHAMUT_R4_STATS = BAHAMUT_R4_STATS_PER_TICK
CustomAttributes.AURIUN_E2_INT = AURIUN_E2_INT_INCREASE
CustomAttributes.AURIUN_E3_STATS = AURIUN_E3_ATTRIBUTES_INCREASE
CustomAttributes.MOUNTAIN_PROTECTOR_E2_STR = MOUNTAIN_PROTECTOR_E2_BONUS_STR
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

CustomAttributes.DJANGHOR_BEAR_MAX_HEALTH = DJANGHOR_R2_BONUS_HP
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

function CDOTA_BaseNPC_Hero:GetSpirit()
	local hero = self
	local spirit = hero.spirit_custom + hero.spirit_bonus
	if self:HasModifier("modifier_diamond_claws_of_tiamat") then
		local item = self.handItem
		spirit = item.newItemTable.property1
	end
	return tonumber(spirit)
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

function CDOTA_BaseNPC:InitRoshpitAttributes()
	local unit = self
	if not Events.GameMasterAbility then
		return false
	end
	if not unit.roshpit_attributes then
		unit.roshpit_attributes = {}
	end
	if unit:IsRealHero() then
		if not unit.strength_custom then
			unit:SetStatsForLevel()
		end
		unit:SetBaseRoshpitArmor(0)
		unit:SetBaseRoshpitMagicArmor(0)
		unit:SetBaseRoshpitArmorPierce(0)
		unit:SetBaseRoshpitSpellPierce(0)
		CustomAttributes:SetAttributes(unit)
	else
		unit:SetEnemyType()
		unit:SetBaseRoshpitArmor(unit:GetKeyValue("RoshpitArmor", false))
		unit:SetBaseRoshpitMagicArmor(unit:GetKeyValue("RoshpitMagicArmor", false))
		unit:SetBaseRoshpitArmorPierce(unit:GetKeyValue("RoshpitArmorPierce", false))
		unit:SetBaseRoshpitSpellPierce(unit:GetKeyValue("RoshpitSpellPierce", false))
		local unit_level = unit:GetInitialRoshpitLevel(unit:GetTeamNumber())
		unit:SetRoshpitLevel(unit_level)
		if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
			Enemies:InitializeEnemy(unit)
		end
	end
	unit:CalculateAndSaveRoshpitAttributes()
end

function CDOTA_BaseNPC:AdjustSummon(caster, bDoHeroMult, hp_mult, attack_mult, armor_mult, magic_armor_mult, armor_pierce_mult, spell_pierce_mult)
	local summon = self
	if bDoHeroMult then
		local newHealth = caster:GetMaxHealth() * hp_mult
		summon:SetMaxHealth(newHealth)
		summon:SetBaseMaxHealth(newHealth)
		summon:SetHealth(newHealth)
		summon:Heal(newHealth, summon)

		local newArmor = caster:GetRoshpitArmor() * armor_mult
		summon:SetBaseRoshpitArmor(newArmor)
		local newMagicArmor = caster:GetRoshpitMagicArmor() * magic_armor_mult
		summon:SetBaseRoshpitMagicArmor(newMagicArmor)
		local newArmorPierce = caster:GetRoshpitArmorPierce() * armor_pierce_mult
		summon:SetBaseRoshpitArmorPierce(newArmorPierce)
		local newSpellPierce = caster:GetRoshpitSpellPierce() * spell_pierce_mult
		summon:SetBaseRoshpitSpellPierce(newSpellPierce)

		local newDamage = OverflowProtectedGetAverageTrueAttackDamage(caster) * attack_mult
		Filters:SetAttackDamage(summon, newDamage)
		summon:CalculateAndSaveRoshpitAttributes()
	end
	return true
end

function CDOTA_BaseNPC:GetInitialRoshpitLevel(team)
	local unit_level = self:GetKeyValue("RoshpitLevel") + (GameState:GetDifficultyFactor()-1)*34
	if team == DOTA_TEAM_NEUTRALS then
		if GameState:IsRPCArena() then
			if self:GetKeyValue("PitCreep") == 1 and Arena and Arena.PitLevel then
				unit_level = unit_level + Arena.PitLevel
			end
		end
	end
	return unit_level
end

function CDOTA_BaseNPC:SetEnemyType()
	local unit = self
	local enemyTier = unit:GetKeyValue("EnemyTier", nil)
	if not unit.roshpit_attributes then
		unit.roshpit_attributes = {}
	end
	unit.roshpit_attributes.enemy_tier = enemyTier
	return enemyTier	
end

function CDOTA_BaseNPC_Hero:SetStatsForLevel()
	local hero = self
	hero:SetRoshpitStrengthForLevel()
	hero:SetRoshpitAgilityForLevel()
	hero:SetRoshpitIntelligenceForLevel()
	hero:SetRoshpitSpiritForLevel()
end

function CDOTA_BaseNPC_Hero:SetRoshpitStrengthForLevel()
	local hero = self
	print(hero:GetUnitName())
	local strength = hero:GetKeyValue("RoshpitStrength", nil)
	print(strength)
	strength = strength + self:GetLevel()*hero:GetKeyValue("RoshpitStrengthGain", nil)
	hero.strength_custom = math.floor(strength)
end

function CDOTA_BaseNPC_Hero:SetRoshpitAgilityForLevel()
	local hero = self
	local agility = hero:GetKeyValue("RoshpitAgility", nil)
	agility = agility + self:GetLevel()*hero:GetKeyValue("RoshpitAgilityGain", nil)
	hero.agility_custom = math.floor(agility)
end

function CDOTA_BaseNPC_Hero:SetRoshpitIntelligenceForLevel()
	local hero = self
	local intellect = hero:GetKeyValue("RoshpitIntelligence", nil)
	intellect = intellect + self:GetLevel()*hero:GetKeyValue("RoshpitIntelligenceGain", nil)
	hero.intellect_custom = math.floor(intellect)
end

function CDOTA_BaseNPC_Hero:SetRoshpitSpiritForLevel()
	local hero = self
	local spirit = hero:GetKeyValue("RoshpitSpirit", nil)
	spirit = spirit + self:GetLevel()*hero:GetKeyValue("RoshpitSpiritGain", nil)
	hero.spirit_custom = math.floor(spirit)
end

function CDOTA_BaseNPC:SetRoshpitLevel(level)
	local unit = self
	if not unit.roshpit_attributes then
		unit.roshpit_attributes = {}
	end
	unit.roshpit_attributes.roshpit_level = level
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_roshpit_level", {})
	unit:SetModifierStackCount("modifier_roshpit_level", Events.GameMaster, level)
	return level
end

function CDOTA_BaseNPC:SetBaseRoshpitArmor(amount)
	local unit = self
	if not unit.roshpit_attributes then
		unit.roshpit_attributes = {}
	end
	unit.roshpit_attributes.roshpit_armor = amount
	return amount
end

function CDOTA_BaseNPC:SetBaseRoshpitMagicArmor(amount)
	local unit = self
	if not unit.roshpit_attributes then
		unit.roshpit_attributes = {}
	end
	unit.roshpit_attributes.roshpit_magic_armor = amount
	return amount
end

function CDOTA_BaseNPC:SetBaseRoshpitSpellPierce(amount)
	local unit = self
	if not unit.roshpit_attributes then
		unit.roshpit_attributes = {}
	end
	unit.roshpit_attributes.roshpit_spell_pierce = amount
	return amount
end

function CDOTA_BaseNPC:SetBaseRoshpitArmorPierce(amount)
	local unit = self
	if not unit.roshpit_attributes then
		unit.roshpit_attributes = {}
	end
	unit.roshpit_attributes.roshpit_armor_pierce = amount
	return amount
end

function CDOTA_BaseNPC:CalculateAndSaveRoshpitAttributes()
	self:CalculateAndSaveRoshpitArmor()
	self:CalculateAndSaveRoshpitMagicArmor()
	self:CalculateAndSaveRoshpitArmorPierce()
	self:CalculateAndSaveRoshpitSpellPierce()
end

function CDOTA_BaseNPC:CalculateAndSaveRoshpitArmor()
	local unit = self
	local armor = unit.roshpit_attributes.roshpit_armor
	if unit:IsRealHero() then
		armor = armor + unit:GetStrength()*CustomAttributes.ARMOR_PER_STR
	end

	local armor_modify = 0
	if unit:HasModifier("modifier_wind_boss_slow") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_loss", "modifier_wind_boss_slow")
	end
	if unit:HasModifier("modifier_arena_grave_chill_target") then
		armor_modify = armor_modify - CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_steal", "modifier_arena_grave_chill_target")
	end
	if unit:HasModifier("modifier_arena_grave_chill_caster") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_steal", "modifier_arena_grave_chill_caster")
	end
	if unit:HasModifier("create_acid_spray_armor_reduction_aura") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_reduction", "create_acid_spray_armor_reduction_aura")
	end
	if unit:HasModifier("modifier_tomb_healing_shield") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_during_cast", "modifier_tomb_healing_shield")
	end
	if unit:HasModifier("modifier_goremaw_battlehunger") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_bonus", "modifier_goremaw_battlehunger")
	end
	if unit:HasModifier("modifier_armor_break_custom") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_break", "modifier_armor_break_custom")
	end
	if unit:HasModifier("modifier_grizzled_tank_debuff") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor", "modifier_grizzled_tank_debuff")
	end
	if unit:HasModifier("modifier_executioner_buff") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_gain", "modifier_executioner_buff")
	end
	if unit:HasModifier("modifier_armor_melt_custom") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_reduction", "modifier_armor_melt_custom")
	end
	if unit:HasModifier("modifier_terrasic_fire_key_holder_steam_physical") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_per_stack", "modifier_terrasic_fire_key_holder_steam_physical")
	end
	if unit:HasModifier("modifier_blackguard_cripple") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_reduction", "modifier_blackguard_cripple")
	end
	if unit:HasModifier("modifier_fire_temple_armor_gain_stacks") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_per_stack", "modifier_fire_temple_armor_gain_stacks")
	end
	if unit:HasModifier("modifier_fire_temple_red_dragon_blood_effect") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor", "modifier_fire_temple_red_dragon_blood_effect")
	end
	if unit:HasModifier("modifier_death_ability_buff") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor_bonus", "modifier_death_ability_buff")
	end
	if unit:HasModifier("modifier_drill_spike_enemy") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_loss_per_stack", "modifier_drill_spike_enemy")
	end
	if unit:HasModifier("modifier_champion_gladiator_passive_stacking") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_loss_per_stack", "modifier_champion_gladiator_passive_stacking")
	end
	if unit:HasModifier("modifier_lies_arbiter_passive") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_bonus", "modifier_lies_arbiter_passive")
	end
	if unit:HasModifier("modifier_forest_ranger_bleed") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_reduce", "modifier_forest_ranger_bleed")
	end
	if unit:HasModifier("modifier_canyon_predator_effect") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_per_instance", "modifier_canyon_predator_effect")
	end
	if unit:HasModifier("modifier_fire_god_armor_break") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_break", "modifier_fire_god_armor_break")
	end
	if unit:HasModifier("modifier_crimsyth_recruiter_armor_loss") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_reduce_per_hit", "modifier_crimsyth_recruiter_armor_loss")
	end
	if unit:HasModifier("modifier_shipyard_gatekeeper_casting") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "protection_while_casting", "modifier_shipyard_gatekeeper_casting")
	end
	if unit:HasModifier("modifier_warflayer_passive") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor", "modifier_warflayer_passive")
	end
	if unit:HasModifier("modifier_ancient_tree_vision") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor_loss", "modifier_ancient_tree_vision")
	end
	if unit:HasModifier("modifier_fire_spirit_enraged") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_fire_spirit_enraged")
	end
	if unit:HasModifier("modifier_triboss_powered_up_multiple") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "powered_up_armor_and_magic_armor", "modifier_triboss_powered_up_multiple")
	end
	if unit:HasModifier("modifier_creature_stormshield") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor", "modifier_creature_stormshield")
	end
	if unit:HasModifier("modifier_sea_terror_armor_loss") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_loss", "modifier_sea_terror_armor_loss")
	end
	if unit:HasModifier("modifier_chitinous_skin_stacks") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_chitinous_skin_stacks")
	end
	if unit:HasModifier("modifier_sea_prophet_whirlpool_within") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor_loss", "modifier_sea_prophet_whirlpool_within")
	end
	if unit:HasModifier("modifier_edge_of_winter_2_armor_evasion") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "eow_armor", "modifier_edge_of_winter_2_armor_evasion")
	end
	if unit:HasModifier("modifier_cruxal_armor_loss") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_loss_per_stack", "modifier_cruxal_armor_loss")
	end
	if unit:HasModifier("modifier_bladewielder_force") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor", "modifier_bladewielder_force")
	end
	if unit:HasModifier("modifier_gangup_stack") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_gangup_stack")
	end
	if unit:HasModifier("modifier_colossus_rage") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "physical_and_magic_armor", "modifier_colossus_rage")
	end
	if unit:HasModifier("modifier_heat_wave_armor_shred") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_shred", "modifier_heat_wave_armor_shred")
	end
	if unit:GetUnitName() == "npc_dota_hero_dragon_knight" then
		if unit:HasAbility("seismic_flare") then
			armor_modify = armor_modify + unit:GetRuneValue("q", 1)*FLAMEWAKER_Q1_ARMOR
		end
	end
	if unit:HasModifier("modifier_searing_heat") then
		local modifier = unit:FindModifierByName("modifier_searing_heat")
		armor_modify = armor_modify + modifier:GetStackCount()*FLAMEWAKER_W3_ARMOR_SHRED
	end
	if unit:HasModifier("modifier_dragonflame_shield") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_dragonflame_shield")
	end
	if unit:HasModifier("modifier_dragonflame_armor_shred") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_shred", "modifier_dragonflame_armor_shred")
	end
	if unit:HasModifier("modifier_b_b_shimmer") then
		local modifier = unit:FindModifierByName("modifier_b_b_shimmer")
		armor_modify = armor_modify + modifier:GetStackCount()*FLAMEWAKER_ARCANA2_Q2_ARMOR
	end
	if unit:HasModifier("modifier_voltex_rune_q_1_buff") then
		local modifier = unit:FindModifierByName("modifier_voltex_rune_q_1_buff")
		armor_modify = armor_modify + modifier:GetStackCount()*VOLTEX_Q1_ARMOR
	end
	if unit:HasModifier("modifier_voltex_rune_r_2_armor_loss") then
		local modifier = unit:FindModifierByName("modifier_voltex_rune_r_2_armor_loss")
		armor_modify = armor_modify + modifier:GetStackCount()*VOLTEX_R2_ARMOR_LOSS
	end
	if unit:HasModifier("modifier_venomort_arcana2_armor") then
		local modifier = unit:FindModifierByName("modifier_venomort_arcana2_armor")
		armor_modify = armor_modify + modifier:GetStackCount()*VENOMORT_ARCANA_1_R4_ARMOR_BONUS
	end
	if unit:HasModifier("modifier_astral_b_a_armor_loss") then
		local modifier = unit:FindModifierByName("modifier_astral_b_a_armor_loss")
		armor_modify = armor_modify + modifier:GetStackCount()*ASTRAL_RANGER_Q2_ARMOR_LOSS
	end
	if unit:HasModifier("modifier_astral_b_a_arcana_armor_loss") then
		local modifier = unit:FindModifierByName("modifier_astral_b_a_arcana_armor_loss")
		armor_modify = armor_modify + modifier:GetStackCount()*ASTRAL_RANGER_ARCANA1_Q2_ARMOR_LOSS
	end
	if unit:HasModifier("crystal_arrow_ad_aura") then
		local modifier = unit:FindModifierByName("crystal_arrow_ad_aura")
		local caster = modifier:GetCaster()
		local r_1_value = caster:GetRuneValue("r", 1)
		armor_modify = armor_modify + modifier:GetStackCount()*ASTRAL_RANGER_ARCANA3_ARMOR_AND_SPELL_PIERCE_REDUCE
	end
	if unit:HasModifier("modifier_paladin_r_1_aura_armor_stacks") then
		local modifier = unit:FindModifierByName("modifier_paladin_r_1_aura_armor_stacks")
		armor_modify = armor_modify + modifier:GetStackCount()*PALADIN_R1_ARMOR
	end
	if unit:HasModifier("modifier_paladin_rune_r_2_invisible") then
		local modifier = unit:FindModifierByName("modifier_paladin_rune_r_2_invisible")
		armor_modify = armor_modify + modifier:GetStackCount()*PALADIN_R2_ARMOR_PER_STACK
	end
	if unit:HasModifier("modifier_paladin_c_b_armor") then
		local modifier = unit:FindModifierByName("modifier_paladin_c_b_armor")
		armor_modify = armor_modify + modifier:GetStackCount()*PALADIN_ARCANA_W3_ARMOR
	end
	if unit:HasModifier("modifier_conjuror_q_1_buff") then
		local modifier = unit:FindModifierByName("modifier_conjuror_q_1_buff")
		armor_modify = armor_modify + modifier:GetStackCount()*CONJUROR_Q1_ARMOR_AURA
	end
	if unit:HasModifier("modifier_fire_aspect_b_d_armor_shred") then
		local modifier = unit:FindModifierByName("modifier_fire_aspect_b_d_armor_shred")
		armor_modify = armor_modify + modifier:GetStackCount()*CONJUROR_R2_ARMOR_SHRED
	end
	if unit:HasModifier("modifier_deity_grand_guardian") then
		armor_modify = armor_modify + CONJUROR_ARCANA3_GRAND_GUARDIAN_ARMOR
	end
	if unit:HasModifier("modifier_gorudo_rune_r_1") then
		local modifier = unit:FindModifierByName("modifier_gorudo_rune_r_1")
		armor_modify = armor_modify + modifier:GetStackCount()*-1
	end
	if unit:HasModifier("modifier_fire_armor_sear") then
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_reduction", "modifier_fire_armor_sear")
	end
	if unit:HasModifier("modifier_warlord_rune_q_2_invisible") then
		local modifier = unit:FindModifierByName("modifier_warlord_rune_q_2_invisible")
		armor_modify = armor_modify + modifier:GetStackCount()
	end
	if unit:HasModifier("modifier_warlord_rune_q_3_invisible") then
		local modifier = unit:FindModifierByName("modifier_warlord_rune_q_3_invisible")
		armor_modify = armor_modify + modifier:GetStackCount()*WARLORD_Q3_ARMOR_RED
	end
	if unit:HasModifier("modifier_duskbringer_rune_e_1_effect") then
		local modifier = unit:FindModifierByName("modifier_duskbringer_rune_e_1_effect")
		armor_modify = armor_modify + modifier:GetStackCount()*DUSKBRINGER_E1_ARMOR
	end
	if unit:HasModifier("modifier_duskbringer_arcana_rune_w_2") then
		local modifier = unit:FindModifierByName("modifier_duskbringer_arcana_rune_w_2")
		armor_modify = armor_modify + modifier:GetStackCount()*DUSKBRINGER_ARCANA1_W2_ARMORS
	end
	if unit:HasModifier("modifier_auriun_rune_q_3_effect") then
		local modifier = unit:FindModifierByName("modifier_auriun_rune_q_3_effect")
		armor_modify = armor_modify + modifier:GetStackCount()*AURIUN_Q3_ARMOR_AND_MAGIC_ARMOR_BONUS
	end

	if unit:HasModifier("modifier_mark_of_the_claw") then
		local modifier = unit:FindModifierByName("modifier_mark_of_the_claw")
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_bonus", "modifier_mark_of_the_claw")
	end
	if unit:HasModifier("modifier_mark_of_the_claw_rune") then
		local modifier = unit:FindModifierByName("modifier_mark_of_the_claw_rune")
		local q_4_level = unit:GetRuneValue("q", 4)
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_bonus_rune", "modifier_mark_of_the_claw_rune")*q_4_level*0.05
	end
	if unit:HasModifier("modifier_bear_armor_buff") then
		local modifier = unit:FindModifierByName("modifier_bear_armor_buff")
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_bonus", "modifier_bear_armor_buff")
	end
	if unit:HasModifier("modifier_wolf_rend_bleed") then
		local modifier = unit:FindModifierByName("modifier_wolf_rend_bleed")
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "rend_armor_reduction", "modifier_wolf_rend_bleed")
	end
	if unit:HasModifier("modifier_bear_rend_armor_loss") then
		local modifier = unit:FindModifierByName("modifier_bear_rend_armor_loss")
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "rend_armor_reduction", "modifier_bear_rend_armor_loss")
	end
	
	if unit:HasModifier("modifier_wolf_rend_stack") then
		local modifier = unit:FindModifierByName("modifier_wolf_rend_stack")
		armor_modify = armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "rend_armor_reduction", "modifier_wolf_rend_stack")
	end
	if unit:HasModifier("modifier_flametongue_a_a_rune") then
		local modifier = unit:FindModifierByName("modifier_flametongue_a_a_rune")
		modifier_caster = modifier:GetCaster()
		local q_1_level = modifier_caster:GetRuneValue("q", 1)
		armor_modify = armor_modify + modifier:GetStackCount()*SPIRIT_WARRIOR_Q1_ARMOR_DEBUFF*q_1_level
	end
	if unit:HasModifier("modifier_flametongue_q_2_fire_shield") then
		local modifier = unit:FindModifierByName("modifier_flametongue_q_2_fire_shield")
		armor_modify = armor_modify + modifier:GetStackCount()*SPIRIT_WARRIOR_Q2_FIRE_SHIELD_ARMORS
	end
	if unit:HasModifier("modifier_spirit_rune_e_2_buff") then
		local modifier = unit:FindModifierByName("modifier_spirit_rune_e_2_buff")
		local all_mods = unit:FindAllModifiersByName("modifier_spirit_rune_e_2_buff")
		armor_modify = armor_modify + modifier:GetStackCount*#all_mods*SPIRIT_WARRIOR_E2_ARMOR_AURA
	end

	if armor_modify > 0 then
		unit:RemoveModifierByName("modifier_negative_roshpit_armor")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_positive_roshpit_armor", {})
		unit:SetModifierStackCount("modifier_positive_roshpit_armor", Events.GameMaster, math.abs(armor_modify))
	elseif armor_modify < 0 then
		unit:RemoveModifierByName("modifier_positive_roshpit_armor")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_negative_roshpit_armor", {})
		unit:SetModifierStackCount("modifier_negative_roshpit_armor", Events.GameMaster, math.abs(armor_modify))
	else
		unit:RemoveModifierByName("modifier_negative_roshpit_armor")
		unit:RemoveModifierByName("modifier_positive_roshpit_armor")
	end
	armor = armor + armor_modify
	armor = math.max(armor, 0)
	unit:SetRoshpitArmor(armor)
	return armor
end

function CustomAttributes:AdjustDamageForRoshpitAttributes(attacker, victim, damage_type, damage, ability_index)
	local armor_pierce = attacker:GetRoshpitArmorPierce()
	local spell_pierce = attacker:GetRoshpitSpellPierce()

	-- SPECIFIC ADJUSTMENTS BELOW
	-- if ability_index then
	-- 	local ability = EntIndexToHScript(ability_index)
	-- 	if ability and IsValidEntity(ability) then
	-- 		if ability:GetAbilityName() == "ice_lance" then
	-- 			local q_2_level = attacker:GetRuneVanle("q", 2)
	-- 			spell_pierce = spell_pierce + SORCERESS_Q2_ICE_LANCE_BONUS_SPELL_PIERCE*q_2_level
	-- 		end
	-- 	end
	-- end
	-- attacker:HasModifier('modifier_frost_nova_passive') and Filters:IsIceFrozen(victim) then
	-- 	local q_2_level = attacker:GetRuneValue("q", 2)
	-- 	spell_pierce = spell_pierce + SORCERESS_Q2_ICE_LANCE_BONUS_SPELL_PIERCE*q_2_level
	-- end

	-- MAIN PART BELOW
	if damage_type == DAMAGE_TYPE_PHYSICAL then
		local mult = math.min((255 + armor_pierce)/(255 + victim:GetRoshpitArmor()), 2)
		return damage*mult
	elseif damage_type == DAMAGE_TYPE_MAGICAL then
		local mult = math.min((255 + spell_pierce)/(255 + victim:GetRoshpitMagicArmor()), 2)
		return damage*mult
	elseif damage_type == DAMAGE_TYPE_PURE then
		return damage
	else
		return damage
	end
end

function CustomAttributes:GetAbilityValueFromSpecial(unit, special_value_name, modifier_name)
	local modifier = unit:FindModifierByName(modifier_name)
	
	local ability = modifier:GetAbility()
	local caster = modifier:GetCaster()
	local stacks = math.max(modifier:GetStackCount(), 1)
	if ability then
		local reduction = ability:GetSpecialValueFor(special_value_name)
		return reduction*stacks
	else
		return 0
	end
end

function CDOTA_BaseNPC:CalculateAndSaveRoshpitMagicArmor()
	local unit = self
	local magic_armor = unit.roshpit_attributes.roshpit_magic_armor
	if unit:IsRealHero() then
		magic_armor = magic_armor + unit:GetSpirit()*CustomAttributes.MAGIC_ARMOR_PER_SPIRIT
	end

	local magic_armor_modify = 0
	if unit:HasModifier("modifier_flamespitting") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor", "modifier_flamespitting")
	end
	if unit:HasModifier("modifier_arena_grave_chill_target") then
		magic_armor_modify = magic_armor_modify - CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_steal", "modifier_arena_grave_chill_target")
	end
	if unit:HasModifier("modifier_arena_grave_chill_caster") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_steal", "modifier_arena_grave_chill_caster")
	end
	if unit:HasModifier("modifier_tomb_healing_shield") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_during_cast", "modifier_tomb_healing_shield")
	end
	if unit:HasModifier("modifier_terrasic_fire_key_holder_steam_magical") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_per_stack", "modifier_terrasic_fire_key_holder_steam_magical")
	end
	if unit:HasModifier("modifier_death_ability_buff") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor_bonus", "modifier_death_ability_buff")
	end
	if unit:HasModifier("modifier_shipyard_gatekeeper_casting") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "protection_while_casting", "modifier_shipyard_gatekeeper_casting")
	end
	if unit:HasModifier("modifier_ancient_tree_vision") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor_loss", "modifier_ancient_tree_vision")
	end
	if unit:HasModifier("modifier_fire_spirit_enraged") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_fire_spirit_enraged")
	end
	if unit:HasModifier("modifier_triboss_powered_up_multiple") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "powered_up_armor_and_magic_armor", "modifier_triboss_powered_up_multiple")
	end
	if unit:HasModifier("modifier_chitinous_skin_stacks") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_chitinous_skin_stacks")
	end
	if unit:HasModifier("modifier_sea_prophet_whirlpool_within") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor_loss", "modifier_sea_prophet_whirlpool_within")
	end
	if unit:HasModifier("modifier_gangup_stack") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_gangup_stack")
	end
	if unit:HasModifier("modifier_royal_guard_magic_shell") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magical_resistance", "modifier_royal_guard_magic_shell")
	end
	if unit:HasModifier("modifier_goremaw_electricity") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resist", "modifier_goremaw_electricity")
	end
	if unit:HasModifier("modifier_blackguard_cultist_ai") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resistance", "modifier_blackguard_cultist_ai")
	end
	if unit:HasModifier("modifier_war_rally_effect") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor", "modifier_war_rally_effect")
	end
	if unit:HasModifier("modifier_karzhun_shield") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resist", "modifier_karzhun_shield")
	end
	if unit:HasModifier("modifier_rakash_ai") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resist", "modifier_rakash_ai")
	end
	if unit:HasModifier("modifier_autumn_mage_debuff") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resist_loss", "modifier_autumn_mage_debuff")
	end
	if unit:HasModifier("modifier_shredder_passive_think") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resist", "modifier_shredder_passive_think")
	end
	if unit:HasModifier("modifier_cannibal_ai") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resist", "modifier_cannibal_ai")
	end
	if unit:HasModifier("modifier_channeling_water_torrent") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_while_channeling", "modifier_channeling_water_torrent")
	end
	if unit:HasModifier("modifier_dark_spirit_passive") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_resist", "modifier_dark_spirit_passive")
	end
	if unit:HasModifier("modifier_colossus_rage") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "physical_and_magic_armor", "modifier_colossus_rage")
	end
	if unit:HasModifier("modifier_dragonflame_shield") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "armor_and_magic_armor", "modifier_dragonflame_shield")
	end
	if unit:HasModifier("modifier_voltex_static_field_spell_armor_reduce") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_reduction_per_stack", "modifier_voltex_static_field_spell_armor_reduce")
	end
	if unit:HasModifier("modifier_voltex_rune_q_1_buff") then
		local modifier = unit:FindModifierByName("modifier_voltex_rune_q_1_buff")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*VOLTEX_Q1_ARMOR
	end
	if unit:HasModifier("modifier_voltex_d_b_debuff") then
		local modifier = unit:FindModifierByName("modifier_voltex_d_b_debuff")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*VOLTEX_W4_MAGIC_ARMOR_REDUCE
	end
	if unit:HasModifier("modifier_voltex_rune_r_3_buff") then
		local modifier = unit:FindModifierByName("modifier_voltex_rune_r_3_buff")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*VOLTEX_R3_MAGIC_ARMOR
	end
	if unit:HasModifier("modifier_astral_d_b_visible") then
		local modifier = unit:FindModifierByName("modifier_astral_d_b_invisible")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*ASTRAL_RANGER_W4_MAGIC_ARMOR_LOSS
	end
	if unit:HasModifier("modifier_astral_rune_e_1_visible") then
		local modifier = unit:FindModifierByName("modifier_astral_rune_e_1_invisible")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*ASTRAL_RANGER_E1_MAGIC_ARMOR_REDUCE
	end
	if unit:HasModifier("modifier_astral_c_c_visible") then
		magic_armor_modify = magic_armor_modify + unit:GetRuneValue("e", 3)*ASTRAL_RANGER_E3_MAGIC_ARMOR
	end
	if unit:HasModifier("crystal_arrow_ad_aura") then
		local modifier = unit:FindModifierByName("crystal_arrow_ad_aura")
		local caster = modifier:GetCaster()
		local r_1_value = caster:GetRuneValue("r", 1)
		magic_armor_modify = magic_armor_modify + r_1_value*ASTRAL_RANGER_ARCANA3_ARMOR_AND_SPELL_PIERCE_REDUCE
	end
	if unit:HasModifier("modifier_epoch_rune_w_2_visible") then
		local modifier = unit:FindModifierByName("modifier_epoch_rune_w_2_visible")
		local caster = modifier:GetCaster()
		local w_2_value = caster:GetRuneValue("w", 2)
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*w_2_value*EPOCH_W2_MAGIC_ARMOR_REDUCTION
	end
	if unit:HasModifier("modifier_paladin_d_c") then
		local modifier = unit:FindModifierByName("modifier_paladin_d_c")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*PALADIN_E4_MAGIC_ARMOR
	end
	if unit:HasModifier("modifier_sorceress_rune_w_2_invisible") then
		local modifier = unit:FindModifierByName("modifier_sorceress_rune_w_2_invisible")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*SORCERESS_W2_MAGIC_ARMOR_LOSS
	end
	if unit:HasModifier("modifier_call_of_earth") then
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor", "modifier_call_of_earth")
	end
	if unit:HasModifier("modifier_typhoon_w_2_magic_armor_loss") then
		local modifier = unit:FindModifierByName("modifier_typhoon_w_2_magic_armor_loss")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*SEINARU_W2_MAGIC_ARMOR_LOSS
	end
	if unit:HasModifier("modifier_seinaru_glyph_7_1") then
		magic_armor_modify = magic_armor_modify + SEINARU_GLYPH_7_1_ARMOR_PIERCE_AND_MAGIC_ARMOR_PER_STR*unit:GetStrength()
	end
	if unit:HasModifier("modifier_warlord_rune_e_1_effect") then
		local modifier = unit:FindModifierByName("modifier_warlord_rune_e_1_effect")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()
	end
	if unit:HasModifier("modifier_warlord_b_d_effect") then
		local modifier = unit:FindModifierByName("modifier_warlord_b_d_effect")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*WARLORD_R2_MAGIC_ARMOR_REDUCTION
	end
	if unit:HasModifier("modifier_ghost_hallow_magic_resist_loss") then
		local modifier = unit:FindModifierByName("modifier_ghost_hallow_magic_resist_loss")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*DUSKBRINGER_W2_MAG_RES_RED
	end
	if unit:HasModifier("modifier_duskbringer_arcana_rune_w_2") then
		local modifier = unit:FindModifierByName("modifier_duskbringer_arcana_rune_w_2")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*DUSKBRINGER_ARCANA1_W2_ARMORS
	end
	if unit:HasModifier("modifier_auriun_rune_q_3_effect") then
		local modifier = unit:FindModifierByName("modifier_auriun_rune_q_3_effect")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*AURIUN_Q3_ARMOR_AND_MAGIC_ARMOR_BONUS
	end
	if unit:HasModifier("modifier_auriun_passive") then
		local e_1_level = unit:GetRuneValue("e", 1)
		magic_armor_modify = magic_armor_modify + e_1_level*AURIUN_E1_MAGIC_ARMOR
	end
	if unit:HasModifier("modifier_seraph_surge_glyphed") then
		magic_armor_modify = magic_armor_modify + AURIUN_GLYPH_5_1_MAGIC_RESIST
	end

	if unit:HasModifier("modifier_wolf_rend_bleed") then
		local modifier = unit:FindModifierByName("modifier_wolf_rend_bleed")
		local caster = modifier:GetCaster()
		local w_2_value = caster:GetRuneValue("w", 2)
		magic_armor_modify = magic_armor_modify + DJANGHOR_W2_MAGIC_ARMOR_REDUCTION * w_2_value
	end
	
	if unit:HasModifier("modifier_draghor_hawk_screech") then
		local modifier = unit:FindModifierByName("modifier_draghor_hawk_screech")
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_reduction", "modifier_draghor_hawk_screech")
	end
	if unit:HasModifier("modifier_mark_of_the_talon") then
		local modifier = unit:FindModifierByName("modifier_mark_of_the_talon")
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_increase", "modifier_mark_of_the_talon")
	end
	if unit:HasModifier("modifier_mark_of_the_talon_rune") then
		local modifier = unit:FindModifierByName("modifier_mark_of_the_talon_rune")
		local q_4_level = unit:GetRuneValue("q", 4)
		magic_armor_modify = magic_armor_modify + CustomAttributes:GetAbilityValueFromSpecial(unit, "magic_armor_increase_rune", "modifier_mark_of_the_talon_rune")*q_4_level*0.05
	end

	if unit:HasModifier("modifier_trap_magic_resist_loss") then
		local modifier = unit:FindModifierByName("modifier_trap_magic_resist_loss")
		if modifier then
			local trap = modifier:GetCaster()
			local caster = trap.origCaster
			if caster then
				local q_3_level = caster:GetRuneValue("q", 3)
				magic_armor_modify = magic_armor_modify + TRAPPER_Q3_MAGIC_ARMOR_LOSS*q_3_level
				if caster:HasModifier("modifier_trapper_glyph_1_2") then
					magic_armor_modify = magic_armor_modify + TRAPPER_GLYPH_1_2_Q3_PCT_AMP*TRAPPER_Q3_MAGIC_ARMOR_LOSS*q_3_level
				end
			end
		end
	end
	if unit:HasModifier("modifier_poison_whip") then
		local modifier = unit:FindModifierByName("modifier_poison_whip")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*TRAPPER_ARCANA_W_W1_MAGIC_ARMOR_PER_STACK
	end
	if unit:HasModifier("modifier_flametongue_q_2_fire_shield") then
		local modifier = unit:FindModifierByName("modifier_flametongue_q_2_fire_shield")
		magic_armor_modify = magic_armor_modify + modifier:GetStackCount()*SPIRIT_WARRIOR_Q2_FIRE_SHIELD_ARMORS
	end



	if magic_armor_modify > 0 then
		unit:RemoveModifierByName("modifier_negative_roshpit_magic_armor")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_positive_roshpit_magic_armor", {})
		unit:SetModifierStackCount("modifier_positive_roshpit_magic_armor", Events.GameMaster, math.abs(magic_armor_modify))
	elseif magic_armor_modify < 0 then
		unit:RemoveModifierByName("modifier_positive_roshpit_magic_armor")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_negative_roshpit_magic_armor", {})
		unit:SetModifierStackCount("modifier_negative_roshpit_magic_armor", Events.GameMaster, math.abs(magic_armor_modify))
	else
		unit:RemoveModifierByName("modifier_negative_roshpit_magic_armor")
		unit:RemoveModifierByName("modifier_positive_roshpit_magic_armor")
	end
	magic_armor = magic_armor + magic_armor_modify
	magic_armor = math.max(magic_armor, 0)

	if unit:HasModifier("modifier_paladin_glyph_6_2") then
		magic_armor = magic_armor*(1+(PALADIN_GLYPH_6_2_MAGIC_ARMOR_PCT/100))
	end

	unit:SetRoshpitMagicArmor(magic_armor)
	return magic_armor
end

function CDOTA_BaseNPC:GetPhysicalArmorValue(bIncludeBonus)
	local unit = self
	return unit:GetRoshpitArmor()
end

function CDOTA_BaseNPC:GetPhysicalArmorBaseValue()
	local unit = self
	return unit.roshpit_attributes.roshpit_armor
end



function CDOTA_BaseNPC:CalculateAndSaveRoshpitArmorPierce()
	local unit = self
	local armor_pierce = unit.roshpit_attributes.roshpit_armor_pierce
	if unit:IsRealHero() then
		armor_pierce = armor_pierce + unit:GetAgility()*CustomAttributes.ARMOR_PIERCE_PER_AGI
	end
	local armor_pierce_modify = 0
	if unit:HasModifier("modifier_flamewaker_arcana_d_a_aura") then
		local modifier = unit:FindModifierByName("modifier_flamewaker_arcana_d_a_aura")
		armor_pierce_modify = armor_pierce_modify + modifier:GetCaster():GetRuneValue("q", 4)*FLAMEWAKER_ARCANA_Q4_ARMOR_AND_SPELL_PIERCE_REDUCTION
	end
	if unit:HasModifier("modifier_voltex_magnet") then
		armor_pierce_modify = armor_pierce_modify + unit:GetRuneValue("q", 2)*VOLTEX_ARCANA2_Q2_PIERCE
	end
	if unit:HasModifier("modifier_apollo_post_mit_invisible") then
		if unit:HasAbility("shot_of_apollo") then
			local modifier = unit:FindModifierByName("modifier_apollo_post_mit_invisible")
			armor_pierce_modify = armor_pierce_modify + modifier:GetStackCount()*ASTRAL_RANGER_ARCANA2_W_4_ARMOR_PIERCE
		end
	end
	if unit:GetUnitName() == "npc_dota_hero_obsidian_destroyer" and unit:HasAbility("epoch_arcana_ability") then
		local q_2_level = unit:GetRuneValue("q", 2)
		armor_pierce_modify = armor_pierce_modify + q_2_level*EPOCH_ARCANA_Q2_ARMOR_AND_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_conjuror_glyph_5_a") or unit:HasModifier("modifier_conjuror_glyph_5_a_summon") then
		armor_pierce_modify = armor_pierce_modify + CONJUROR_GLYPH_5_A_ARMOR_AND_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_seinaru_q3_spell_and_armor_pierce") then
		local modifier = unit:FindModifierByName("modifier_seinaru_q3_spell_and_armor_pierce")
		local ms = unit:GetActualMovespeed()
		armor_pierce_modify = armor_pierce_modify + modifier:GetStackCount()*SEINARU_Q3_ARMOR_AND_SPELL_PIERCE_PER_MS*ms
	end
	if unit:GetUnitName() == "npc_dota_hero_juggernaut" and unit:HasAbility("seinaru_odachi_leap") then
		local e_3_level = unit:GetRuneValue("e", 3)
		armor_pierce_modify = armor_pierce_modify + SEINARU_E3_ARMOR_PIERCE*e_3_level
	end
	if unit:HasModifier("modifier_seinaru_glyph_7_1") then
		armor_pierce_modify = armor_pierce_modify + SEINARU_GLYPH_7_1_ARMOR_PIERCE_AND_MAGIC_ARMOR_PER_STR*unit:GetStrength()
	end
	if unit:HasModifier("modifier_sunstrider_sunwarrior_vengeance_armor_and_spell_pierce") then
		local modifier = unit:FindModifierByName("modifier_sunstrider_sunwarrior_vengeance_armor_and_spell_pierce")
		armor_pierce_modify = armor_pierce_modify + modifier:GetStackCount()*SEINARU_ARCANA_E3_ARMOR_PIERCE_AND_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_warlord_arcana2") then
		armor_pierce_modify = armor_pierce_modify + WARLORD_ARCANA2_Q1_PIERCES*unit:GetRuneValue("q", 1)
	end
	if unit:HasModifier("modifier_leshrac_arcana_b_d_effect") then
		local modifier = unit:FindModifierByName("modifier_leshrac_arcana_b_d_effect")
		armor_pierce_modify = armor_pierce_modify + modifier:GetStackCount()*BAHAMUT_ARCANA_R2_PIERCES
	end
	if unit:HasModifier("modifier_duskbringer_rune_r_2_invisible") then
		local modifier = unit:FindModifierByName("modifier_duskbringer_rune_r_2_invisible")
		armor_pierce_modify = armor_pierce_modify + modifier:GetStackCount()*DUSKBRINGER_R2_PIERCES
	end
	if unit:HasModifier("modifier_trapper_d_c_post_amp") then
		local modifier = unit:FindModifierByName("modifier_trapper_d_c_post_amp")
		armor_pierce_modify = armor_pierce_modify + modifier:GetStackCount()*TRAPPER_E4_PIERCES
	end

	if armor_pierce_modify > 0 then
		unit:RemoveModifierByName("modifier_negative_roshpit_armor_pierce")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_positive_roshpit_armor_pierce", {})
		unit:SetModifierStackCount("modifier_positive_roshpit_armor_pierce", Events.GameMaster, math.abs(armor_pierce_modify))
	elseif armor_pierce_modify < 0 then
		unit:RemoveModifierByName("modifier_positive_roshpit_armor_pierce")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_negative_roshpit_armor_pierce", {})
		unit:SetModifierStackCount("modifier_negative_roshpit_armor_pierce", Events.GameMaster, math.abs(armor_pierce_modify))
	else
		unit:RemoveModifierByName("modifier_negative_roshpit_armor_pierce")
		unit:RemoveModifierByName("modifier_positive_roshpit_armor_pierce")
	end
	armor_pierce = math.max(armor_pierce + armor_pierce_modify, 0)
	unit:SetRoshpitArmorPierce(armor_pierce)
	return armor_pierce
end

function CDOTA_BaseNPC:CalculateAndSaveRoshpitSpellPierce()
	local unit = self
	local spell_pierce = unit.roshpit_attributes.roshpit_spell_pierce
	if unit:IsRealHero() then
		spell_pierce = spell_pierce + unit:GetIntellect()*CustomAttributes.SPELL_PIERCE_PER_INT
	end
	if unit:GetUnitName() == "npc_dota_hero_phantom_assassin" and unit:HasAbility("voltex_overcharge") then
		spell_pierce = spell_pierce + unit:GetRuneValue("q", 2)*VOLTEX_Q2_SPELL_PIERCE_PER_AGI*unit:GetAgility()
	end
	local spell_pierce_modify = 0
	if unit:HasModifier("modifier_flamewaker_arcana_b_a_effect") then
		local modifier = unit:FindModifierByName("modifier_flamewaker_arcana_b_a_effect")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*FLAMEWAKER_ARCANA_Q2_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_flamewaker_arcana_d_a_aura") then
		local modifier = unit:FindModifierByName("modifier_flamewaker_arcana_d_a_aura")
		spell_pierce_modify = spell_pierce_modify + modifier:GetCaster():GetRuneValue("q", 4)*FLAMEWAKER_ARCANA_Q4_ARMOR_AND_SPELL_PIERCE_REDUCTION
	end
	if unit:HasModifier("modifier_voltex_magnet") then
		spell_pierce_modify = spell_pierce_modify + unit:GetRuneValue("q", 2)*VOLTEX_ARCANA2_Q2_PIERCE
	end
	if unit:GetUnitName() == "npc_dota_hero_obsidian_destroyer" and unit:HasAbility("epoch_arcana_ability") then
		local q_2_level = unit:GetRuneValue("q", 2)
		spell_pierce_modify = spell_pierce_modify + q_2_level*EPOCH_ARCANA_Q2_ARMOR_AND_SPELL_PIERCE
	end
	if unit:GetUnitName() == "npc_dota_hero_omniknight" and unit:HasAbility("paladin_crusader_comet") then
		local e_4_level = unit:GetRuneValue("e", 4)
		spell_pierce_modify = spell_pierce_modify + e_4_level*PALADIN_ARCANA2_E4_SPELL_PIERCE_PER_SPIRIT*unit:GetSpirit()
	end
	if unit:HasModifier("modifier_conjuror_glyph_5_a") or unit:HasModifier("modifier_conjuror_glyph_5_a_summon") then
		spell_pierce_modify = spell_pierce_modify + CONJUROR_GLYPH_5_A_ARMOR_AND_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_seinaru_q3_spell_and_armor_pierce") then
		local modifier = unit:FindModifierByName("modifier_seinaru_q3_spell_and_armor_pierce")
		local ms = unit:GetActualMovespeed()
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*SEINARU_Q3_ARMOR_AND_SPELL_PIERCE_PER_MS*ms
	end
	if unit:HasModifier("modifier_sunstrider_sunwarrior_vengeance_armor_and_spell_pierce") then
		local modifier = unit:FindModifierByName("modifier_sunstrider_sunwarrior_vengeance_armor_and_spell_pierce")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*SEINARU_ARCANA_E3_ARMOR_PIERCE_AND_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_warlord_arcana2") then
		spell_pierce_modify = spell_pierce_modify + WARLORD_ARCANA2_Q1_PIERCES*unit:GetRuneValue("q", 1)
	end
	if unit:HasModifier("modifier_warlord_glyph_5_a") then
		if unit:HasModifier("modifier_warlord_ice_charge") then
			local iceCharges = unit:GetModifierStackCount("modifier_warlord_ice_charge", unit)
			spell_pierce_modify = spell_pierce_modify + WARLORD_GLYPH_5_A_SPELL_PIERCE_PER_ICE_CHARGE * iceCharges
		end
	end
	if unit:HasModifier("modifier_bahamut_mega_flare_pierce") then
		local modifier = unit:FindModifierByName("modifier_bahamut_mega_flare_pierce")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*BAHAMUT_R2_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_leshrac_arcana_b_d_effect") then
		local modifier = unit:FindModifierByName("modifier_leshrac_arcana_b_d_effect")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*BAHAMUT_ARCANA_R2_PIERCES
	end
	if unit:HasModifier("modifier_bahamut_arcana_spell_pierce") then
		local modifier = unit:FindModifierByName("modifier_bahamut_arcana_spell_pierce")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*BAHAMUT_ARCANA_W_W2_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_duskbringer_rune_r_2_invisible") then
		local modifier = unit:FindModifierByName("modifier_duskbringer_rune_r_2_invisible")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*DUSKBRINGER_R2_PIERCES
	end
	if unit:HasModifier("modifier_duskbringer_arcana_q_4") then
		local modifier = unit:FindModifierByName("modifier_duskbringer_arcana_q_4")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*DUSKBRINGER_ARCANA2_Q4_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_auriun_passive") then
		local e_1_level = unit:GetRuneValue("e", 1)
		spell_pierce_modify = spell_pierce_modify + e_1_level*AURIUN_E1_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_shadow_trap_d_a_buff") then
		local modifier = unit:FindModifierByName("modifier_shadow_trap_d_a_buff")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*AURIUN_ARCANA_2_Q4_SPELL_PIERCE
	end
	if unit:HasModifier("modifier_trapper_d_c_post_amp") then
		local modifier = unit:FindModifierByName("modifier_trapper_d_c_post_amp")
		spell_pierce_modify = spell_pierce_modify + modifier:GetStackCount()*TRAPPER_E4_PIERCES
	end

	if spell_pierce_modify > 0 then
		unit:RemoveModifierByName("modifier_negative_roshpit_spell_pierce")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_positive_roshpit_spell_pierce", {})
		unit:SetModifierStackCount("modifier_positive_roshpit_spell_pierce", Events.GameMaster, math.abs(spell_pierce_modify))
	elseif spell_pierce_modify < 0 then
		unit:RemoveModifierByName("modifier_positive_roshpit_spell_pierce")
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_negative_roshpit_spell_pierce", {})
		unit:SetModifierStackCount("modifier_negative_roshpit_spell_pierce", Events.GameMaster, math.abs(spell_pierce_modify))
	else
		unit:RemoveModifierByName("modifier_negative_roshpit_spell_pierce")
		unit:RemoveModifierByName("modifier_positive_roshpit_spell_pierce")
	end
	spell_pierce = math.max(spell_pierce + spell_pierce_modify, 0)
	unit:SetRoshpitSpellPierce(spell_pierce)
	return spell_pierce
end

function CDOTA_BaseNPC:SetRoshpitArmor(amount)
	local unit = self
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_roshpit_armor", {})
	unit:SetModifierStackCount("modifier_roshpit_armor", Events.GameMaster, amount)
	if unit:IsRealHero() then
		-- print(unit:GetModifierStackCount("modifier_roshpit_armor", Events.GameMaster))
	end
	return amount
end

function CDOTA_BaseNPC:GetRoshpitArmor()
	local mult = 1
	local unit = self
	local armor = unit:GetModifierStackCount("modifier_roshpit_armor", Events.GameMaster)
	armor = armor*mult
	return armor
end

function CDOTA_BaseNPC:SetRoshpitMagicArmor(amount)
	local unit = self
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_roshpit_magic_armor", {})
	unit:SetModifierStackCount("modifier_roshpit_magic_armor", Events.GameMaster, amount)
	return amount
end

function CDOTA_BaseNPC:GetRoshpitMagicArmor()
	local mult = 1
	local unit = self
	local armor = unit:GetModifierStackCount("modifier_roshpit_magic_armor", Events.GameMaster)
	armor = armor*mult
	return armor
end

function CDOTA_BaseNPC:SetRoshpitArmorPierce(amount)
	local unit = self
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_roshpit_armor_pierce", {})
	unit:SetModifierStackCount("modifier_roshpit_armor_pierce", Events.GameMaster, amount)
	return amount
end

function CDOTA_BaseNPC:GetRoshpitArmorPierce()
	local unit = self
	local armor_pierce = unit:GetModifierStackCount("modifier_roshpit_armor_pierce", Events.GameMaster)
	return armor_pierce
end

function CDOTA_BaseNPC:SetRoshpitSpellPierce(amount)
	local unit = self
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_roshpit_spell_pierce", {})
	unit:SetModifierStackCount("modifier_roshpit_spell_pierce", Events.GameMaster, amount)
	return amount
end

function CDOTA_BaseNPC:GetRoshpitSpellPierce()
	local unit = self
	local armor_pierce = unit:GetModifierStackCount("modifier_roshpit_armor_pierce", Events.GameMaster)
	return armor_pierce
end

function CustomAttributes:SetAttributes(hero)

	local strength = hero.strength_custom
	local agility = hero.agility_custom
	local intelligence = hero.intellect_custom
	local spirit = hero.spirit_custom


	local str_bonus = 0
	local agi_bonus = 0
	local int_bonus = 0
	local spirit_bonus = 0
	local heroName = hero:GetUnitName()
	if hero:HasModifier("modifier_flamewaker_rune_r_3") then
		local stacks = hero:GetModifierStackCount("modifier_flamewaker_rune_r_3", hero)
		str_bonus = str_bonus + FLAMEWAKER_R3_STRENGTH * stacks
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
		spirit_bonus = spirit_bonus + stacks
	end
	if hero:HasModifier("modifier_apollo_stats_invisible") then
		local stacks = hero:GetModifierStackCount("modifier_apollo_stats_invisible", hero)
		str_bonus = str_bonus + stacks * ASTRAL_RANGER_ARCANA2_W_1_ATTRIBUTES
		agi_bonus = agi_bonus + stacks * ASTRAL_RANGER_ARCANA2_W_1_ATTRIBUTES
		int_bonus = int_bonus + stacks * ASTRAL_RANGER_ARCANA2_W_1_ATTRIBUTES
		spirit_bonus = spirit_bonus + stacks * ASTRAL_RANGER_ARCANA2_W_1_ATTRIBUTES
	end
	if hero:GetUnitName() == "npc_dota_hero_juggernaut" then
		if hero:HasAbility("seinaru_hands_of_hikari") and hero.w_4_level then
			spirit_bonus = spirit_bonus + hero.w_4_level*SEINARU_W4_SPIRIT
		end
		if hero:HasAbility("seinaru_odachi_leap") and hero.e_4_level then
			agi_bonus = agi_bonus + hero.e_4_level*SEINARU_E4_AGILITY
		end
	end
	if hero:GetUnitName == "npc_dota_hero_huskar" then
		local e_4_level = hero:GetRuneValue("e", 4)
		int_bonus = e_4_level*SPIRIT_WARRIOR_E4_SPIRIT_AND_INT
		spirit_bonus = e_4_level*SPIRIT_WARRIOR_E4_SPIRIT_AND_INT
	end
	if hero:HasModifier("modifier_auriun_rune_q_4_effect") then
		local modifier = hero:FindModifierByName("modifier_auriun_rune_q_4_effect")
		spirit_bonus = spirit_bonus + modifier:GetStackCount()*AURIUN_Q4_SPIRIT
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
	if hero:HasModifier("modifier_gorudo_r_4_strength") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, hero, "modifier_gorudo_r_4_strength", SEINARU_R4_STRENGTH)
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
		spirit_bonus = spirit_bonus + q_4_level*WARLORD_ARCANA2_Q4_ALL_ATTRIBUTES
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
		str_bonus = str_bonus + stacks * ASTRAL_RANGER_E4_ALL_ATTRIBUTES
		agi_bonus = agi_bonus + stacks * ASTRAL_RANGER_E4_ALL_ATTRIBUTES
		int_bonus = int_bonus + stacks * ASTRAL_RANGER_E4_ALL_ATTRIBUTES
		spirit_bonus = spirit_bonus + stacks * ASTRAL_RANGER_E4_ALL_ATTRIBUTES
	end
	-- if hero:HasModifier("modifier_arcane_intellect_visible") then
	-- int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_arcane_intellect_visible", CustomAttributes.SORCERESS_ARCANE_INTELLECT)
	-- end
	if heroName == "npc_dota_hero_beastmaster" then
		if hero:HasModifier("modifier_warlord_rune_q_4_strength") then
			str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_warlord_rune_q_4_strength", WARLORD_Q4_ALL_ATTRIBUTES)
		end
		if hero:HasModifier("modifier_warlord_rune_q_4_agility") then
			agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_warlord_rune_q_4_agility", WARLORD_Q4_ALL_ATTRIBUTES)
		end
		if hero:HasModifier("modifier_warlord_rune_q_4_intelligence") then
			int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_warlord_rune_q_4_intelligence", WARLORD_Q4_ALL_ATTRIBUTES)
		end
	end
	if hero:HasModifier("modifier_voltex_immortal_weapon_1") then
		str_bonus = str_bonus + VOLTEX_IMMORTAL_WEAPON_1_STR
	end
	if hero:HasModifier("modifier_bahamut_rune_q_4") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_q_4", CustomAttributes.BAHAMUT_Q4_INT)
	end
	if hero:HasModifier("modifier_bahamut_rune_r_4_buff_invisible") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_r_4_buff_invisible", CustomAttributes.BAHAMUT_R4_STATS)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_r_4_buff_invisible", CustomAttributes.BAHAMUT_R4_STATS)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_r_4_buff_invisible", CustomAttributes.BAHAMUT_R4_STATS)
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_bahamut_rune_r_4_buff_invisible", CustomAttributes.BAHAMUT_R4_STATS)
	end
	if hero:HasModifier("modifier_auriun_rune_e_2") then
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_2", CustomAttributes.AURIUN_E2_INT)
	end
	if hero:HasModifier("modifier_auriun_rune_e_3_effect") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_3_effect", CustomAttributes.AURIUN_E3_STATS)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_3_effect", CustomAttributes.AURIUN_E3_STATS)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_3_effect", CustomAttributes.AURIUN_E3_STATS)
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_auriun_rune_e_3_effect", CustomAttributes.AURIUN_E3_STATS)
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
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_venomort_bonus_stats", VENOMORT_W3_BONUS_ATTRIBUTES)
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
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_spi", -1)
	end
	if hero:HasModifier("modifier_meta_slark_debuff") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_meta_slark_debuff", "tanari_meta_slark_passive", "attribute_loss")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_meta_slark_debuff", "tanari_meta_slark_passive", "attribute_loss")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_meta_slark_debuff", "tanari_meta_slark_passive", "attribute_loss")
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_meta_slark_debuff", "tanari_meta_slark_passive", "attribute_loss")
	end
	if hero:HasModifier("modifier_prison_shank_effect_sea") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect_sea", "sea_shank", "stats_loss")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect_sea", "sea_shank", "stats_loss")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect_sea", "sea_shank", "stats_loss")
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_prison_shank_effect_sea", "sea_shank", "stats_loss")
	end
	if hero:HasModifier("modifier_water_medusa_stat_loss") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_water_medusa_stat_loss", "water_medusa_passive", "stat_loss")
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_water_medusa_stat_loss", "water_medusa_passive", "stat_loss")
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_water_medusa_stat_loss", "water_medusa_passive", "stat_loss")
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromAbility(hero, nil, "modifier_water_medusa_stat_loss", "water_medusa_passive", "stat_loss")
	end
	if hero:HasModifier("modifier_sea_oracle_stats_debuff") then
		str_bonus = str_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_str", -1)
		agi_bonus = agi_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_agi", -1)
		int_bonus = int_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_int", -1)
		spirit_bonus = spirit_bonus + CustomAttributes:AddStatsBonusFromStacks(hero, nil, "modifier_demon_farmer_aura_spi", -1)
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
	spirit = math.max(spirit + spirit_bonus, 0)
	hero.str_bonus = str_bonus
	hero.agi_bonus = agi_bonus
	hero.int_bonus = int_bonus
	hero.spirit_bonus = spirit_bonus
	CustomNetTables:SetTableValue("hero_index", tostring(hero:GetEntityIndex() .. "_custom_attributes"), {strength = tostring(strength), agility = tostring(agility), intelligence = tostring(intelligence), spirit = tostring(spirit)})
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

	if not hero:HasModifier("modifier_agility_movespeed") then
		ability:ApplyDataDrivenModifier(caster, hero, "modifier_agility_movespeed", {})
	end
	hero:SetModifierStackCount("modifier_agility_movespeed", caster, agility * CustomAttributes.MOVESPEED_PER_AGI * halcyon)

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
	hero:CalculateAndSaveRoshpitAttributes()
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
	tableData.roshpit_armor = unit:CalculateAndSaveRoshpitArmor()
	tableData.roshpit_armor_pierce = unit:CalculateAndSaveRoshpitArmorPierce()
	if unit:IsRealHero() then
		tableData.base_roshpit_armor = unit.roshpit_attributes.roshpit_armor + unit:GetStrength()*CustomAttributes.ARMOR_PER_STR
	else
		tableData.base_roshpit_armor = unit.roshpit_attributes.roshpit_armor
	end
	if unit:IsRealHero() then
		tableData.base_roshpit_magic_armor = unit.roshpit_attributes.roshpit_magic_armor + unit:GetSpirit()*CustomAttributes.MAGIC_ARMOR_PER_SPIRIT
	else
		tableData.base_roshpit_magic_armor = unit.roshpit_attributes.roshpit_magic_armor
	end
	tableData.roshpit_magic_armor = unit:CalculateAndSaveRoshpitMagicArmor()
	tableData.roshpit_spell_pierce = unit:CalculateAndSaveRoshpitSpellPierce()
	local level = unit:GetLevel()
	if unit:IsHero() then
		unit.q_4_level = unit:GetRuneValue("q", 4)
		unit.w_4_level = unit:GetRuneValue("w", 4)
		unit.e_4_level = unit:GetRuneValue("e", 4)
		unit.r_4_level = unit:GetRuneValue("r", 4)
	else
		if unit.roshpit_attributes.roshpit_level then
			level = unit.roshpit_attributes.roshpit_level
		else
			level = 1
		end
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
	tableData.elements = CustomAttributes:CalculatedElementBonuses(victim, attacker)

	tableData.halcyon = 0
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

function CustomAttributes:CalculatedElementBonuses(victim, attacker)
	local elements = {}
	local damageDealt = 1000
	for i=1, RPC_ELEMENT_COUNT, 1 do
		elements[i] = (Filters:ElementalDamage(victim, attacker, damageDealt * 100, DAMAGE_TYPE_PURE, 0, i, RPC_ELEMENT_NONE, false) / damageDealt) - 100
	end
	if IsEnemy then
		for k, v in pairs(elements) do
			elements[k] = -(v - 100)
		end
	end
	return elements
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

function CDOTA_BaseNPC:GetActualMovespeed()
	local unit = self
	local movespeed = self:GetBaseMoveSpeed()
	local actual_movespeed = self:GetMoveSpeedModifier(movespeed, false)
	if unit.master_move_speed then
		actual_movespeed = unit.master_move_speed
	end
	return actual_movespeed
end

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

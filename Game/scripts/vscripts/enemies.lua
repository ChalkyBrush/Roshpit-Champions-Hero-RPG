require('/global_constants')

if Enemies == nil then
	Enemies = class({})
end

Enemies.MOB_TIER_EXP_MULT = {}
Enemies.MOB_TIER_EXP_MULT[ENEMY_TYPE_WEAK_CREEP] = 0.5
Enemies.MOB_TIER_EXP_MULT[ENEMY_TYPE_NORMAL_CREEP] = 1
Enemies.MOB_TIER_EXP_MULT[ENEMY_TYPE_ELITE_CREEP] = 6
Enemies.MOB_TIER_EXP_MULT[ENEMY_TYPE_MINI_BOSS] = 15
Enemies.MOB_TIER_EXP_MULT[ENEMY_TYPE_BOSS] = 25
Enemies.MOB_TIER_EXP_MULT[ENEMY_TYPE_MAJOR_BOSS] = 35

Enemies.DIFFICULTY_DAMAGE_ADJUST = {}
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_NORMAL] = {}
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE] = {}
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND] = {}
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_WEAK_CREEP] = 1
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_NORMAL_CREEP] = 1
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_ELITE_CREEP] = 1
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_MINI_BOSS] = 1
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_BOSS] = 1
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_MAJOR_BOSS] = 1
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_WEAK_CREEP] = 1.5
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_NORMAL_CREEP] = 1.5
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_ELITE_CREEP] = 2
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MINI_BOSS] = 2
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_BOSS] = 2.5
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MAJOR_BOSS] = 2.5
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_WEAK_CREEP] = 2
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_NORMAL_CREEP] = 3
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_ELITE_CREEP] = 3
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MINI_BOSS] = 3.5
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_BOSS] = 4
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MAJOR_BOSS] = 4
Enemies.FLAT_DAMAGE_BONUS_PER_LEVEL_AFTER_NORMAL = 10
Enemies.GLOBAL_DAMAGE_ADJUST = 0.25

Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST = {}
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_NORMAL] = {}
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE] = {}
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND] = {}
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_WEAK_CREEP] = 1
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_NORMAL_CREEP] = 1
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_ELITE_CREEP] = 1
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_MINI_BOSS] = 1
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_BOSS] = 1
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_NORMAL][ENEMY_TYPE_MAJOR_BOSS] = 1
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_WEAK_CREEP] = 2
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_NORMAL_CREEP] = 2
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_ELITE_CREEP] = 2
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MINI_BOSS] = 3
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_BOSS] = 4
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MAJOR_BOSS] = 4
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_WEAK_CREEP] = 4
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_NORMAL_CREEP] = 5
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_ELITE_CREEP] = 6
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MINI_BOSS] = 7
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_BOSS] = 8
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MAJOR_BOSS] = 8

Enemies.FLAT_ROSHPIT_ATTRIBUTE_PER_LEVEL = {}
Enemies.FLAT_ROSHPIT_ATTRIBUTE_PER_LEVEL[DIFFICULTY_NORMAL] = 0
Enemies.FLAT_ROSHPIT_ATTRIBUTE_PER_LEVEL[DIFFICULTY_ELITE] = 10
Enemies.FLAT_ROSHPIT_ATTRIBUTE_PER_LEVEL[DIFFICULTY_LEGEND] = 20

Enemies.DIFFICULTY_HEALTH_FLAT = {}
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_NORMAL] = {}
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_ELITE] = {}
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_LEGEND] = {}
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_NORMAL][ENEMY_TYPE_WEAK_CREEP] = 0
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_NORMAL][ENEMY_TYPE_NORMAL_CREEP] = 0
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_NORMAL][ENEMY_TYPE_ELITE_CREEP] = 0
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_NORMAL][ENEMY_TYPE_MINI_BOSS] = 0
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_NORMAL][ENEMY_TYPE_BOSS] = 0
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_NORMAL][ENEMY_TYPE_MAJOR_BOSS] = 0
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_ELITE][ENEMY_TYPE_WEAK_CREEP] = 1000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_ELITE][ENEMY_TYPE_NORMAL_CREEP] = 2000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_ELITE][ENEMY_TYPE_ELITE_CREEP] = 4000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_ELITE][ENEMY_TYPE_MINI_BOSS] = 10000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_ELITE][ENEMY_TYPE_BOSS] = 20000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_ELITE][ENEMY_TYPE_MAJOR_BOSS] = 50000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_LEGEND][ENEMY_TYPE_WEAK_CREEP] = 5000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_LEGEND][ENEMY_TYPE_NORMAL_CREEP] = 15000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_LEGEND][ENEMY_TYPE_ELITE_CREEP] = 40000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_LEGEND][ENEMY_TYPE_MINI_BOSS] = 100000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_LEGEND][ENEMY_TYPE_BOSS] = 200000
Enemies.DIFFICULTY_HEALTH_FLAT[DIFFICULTY_LEGEND][ENEMY_TYPE_MAJOR_BOSS] = 400000

Enemies.DIFFICULTY_HEALTH_MULT = {}
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_NORMAL] = {}
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_ELITE] = {}
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_LEGEND] = {}
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_NORMAL][ENEMY_TYPE_WEAK_CREEP] = 1
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_NORMAL][ENEMY_TYPE_NORMAL_CREEP] = 1
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_NORMAL][ENEMY_TYPE_ELITE_CREEP] = 1
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_NORMAL][ENEMY_TYPE_MINI_BOSS] = 1
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_NORMAL][ENEMY_TYPE_BOSS] = 1
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_NORMAL][ENEMY_TYPE_MAJOR_BOSS] = 1
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_ELITE][ENEMY_TYPE_WEAK_CREEP] = 2
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_ELITE][ENEMY_TYPE_NORMAL_CREEP] = 2
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_ELITE][ENEMY_TYPE_ELITE_CREEP] = 3
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_ELITE][ENEMY_TYPE_MINI_BOSS] = 4
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_ELITE][ENEMY_TYPE_BOSS] = 5
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_ELITE][ENEMY_TYPE_MAJOR_BOSS] = 6
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_LEGEND][ENEMY_TYPE_WEAK_CREEP] = 9
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_LEGEND][ENEMY_TYPE_NORMAL_CREEP] = 10
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_LEGEND][ENEMY_TYPE_ELITE_CREEP] = 20
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_LEGEND][ENEMY_TYPE_MINI_BOSS] = 40
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_LEGEND][ENEMY_TYPE_BOSS] = 60
Enemies.DIFFICULTY_HEALTH_MULT[DIFFICULTY_LEGEND][ENEMY_TYPE_MAJOR_BOSS] = 80

Enemies.GLOBAL_HEALTH_MULT = 1.5

Enemies.SPIRIT_REALM_CONSTANTS = {}
Enemies.SPIRIT_REALM_CONSTANTS[0] = {}
Enemies.SPIRIT_REALM_CONSTANTS[1] = {}
Enemies.SPIRIT_REALM_CONSTANTS[0]["attack_damage"] = 1
Enemies.SPIRIT_REALM_CONSTANTS[0]["roshpit_attribute"] = 1
Enemies.SPIRIT_REALM_CONSTANTS[0]["max_hp"] = 1
Enemies.SPIRIT_REALM_CONSTANTS[1]["attack_damage"] = 2
Enemies.SPIRIT_REALM_CONSTANTS[1]["roshpit_attribute"] = 2
Enemies.SPIRIT_REALM_CONSTANTS[1]["max_hp"] = 2

Enemies.EXP_LEVEL_DIFFERENTIAL = 5
Enemies.EXP_DECAY_PER_LEVEL_BEYOND_DIFFERENTIAL = 0.16

Enemies.EXTRA_HEALTH_BONUS_PER_ADDITIONAL_PLAYER = 0.35

Enemies.ADDITIONAL_MOB_EXP_PER_PLAYER = 0.1
Enemies.EXTRA_EXP_PER_PASS_PLAYER = 0.2
Enemies.EXP_SHARE_PERCENTAGE = 0.75

Enemies.MINIMUM_STARTING_ATTACK_DAMAGE_MIN = 2
Enemies.MINIMUM_STARTING_ATTACK_DAMAGE_MAX = 2

Enemies.EXP_BASE_TABLE = {}
for i = 0, 120 , 1 do
	Enemies.EXP_BASE_TABLE[i]= math.ceil(7*(1.05^i)) + (i-1)
end

Enemies.SERENGAARD_EXP_ADJUSTMENT = 0.5

function Enemies:SpiritRealmNumber(spirit_realm)
	if spirit_realm then
		return 1
	else
		return 0
	end
end

function Enemies:GetFlatDamageBonusForDifficulty(unit, base_level)
	return unit.roshpit_attributes.roshpit_level*Enemies.FLAT_ROSHPIT_ATTRIBUTE_PER_LEVEL[GameState:GetDifficultyFactor()]
end

function Enemies:GetFlatRoshpitAttributeForDifficulty(unit, base_level)
	if GameState:GetDifficultyFactor() > 1 then
		return unit.roshpit_attributes.roshpit_level*Enemies.FLAT_ROSHPIT_ATTRIBUTE_PER_LEVEL[GameState:GetDifficultyFactor()]
	else
		return 0
	end
end

function Enemies:SpawnEnemy(unitName, spawnPoint, aggroSound, fv, isAggro)
	local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
	if aggroSound then
		unit.aggroSound = aggroSound
	end
	if fv then
		unit:SetForwardVector(fv)
	end
	if isAggro then
		Dungeons:AggroUnit(unit)
	end
	local ability = unit:FindAbilityByName("dungeon_creep")
	if ability then
		ability:SetLevel(1)
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
	end
	return unit
end

function Enemies:InitializeEnemy(unit)
	local base_level = unit:GetKeyValue("RoshpitLevel")
	local unit_level = unit.roshpit_attributes.roshpit_level
	local enemyTier = unit.roshpit_attributes.enemy_tier
	local difficulty = GameState:GetDifficultyFactor()
	local spirit_realm = Enemies:SpiritRealmNumber(Events.SpiritRealm)
	if unit_level == 1337 then
		Notifications:BottomToAll({text = "Unit level is not yet set: "..unit:GetUnitName(), duration = 5.0})
		unit_level = 120
	end
	-- exp
	local deathXP = Enemies.EXP_BASE_TABLE[unit_level] * Enemies.MOB_TIER_EXP_MULT[enemyTier]
	local deathXP = deathXP + (deathXP * (math.max(0, RPCItems:GetConnectedPlayerCount() - 1)*Enemies.ADDITIONAL_MOB_EXP_PER_PLAYER)) + deathXP*GameState:GetPlayerPremiumStatusCount()*Enemies.EXTRA_EXP_PER_PASS_PLAYER
	if GameState:IsSerengaard() then
		deathXP = deathXP * Enemies.SERENGAARD_EXP_ADJUSTMENT
	end
	local dominion_kv = unit:GetKeyValue("RoshpitDominion")
	if dominion_kv == 1 then
		unit.dominion = true
	end
	unit.roshpit_attributes.deathXP = deathXP
	unit:SetDeathXP(0)
	-- gold bounty
	unit:SetMaximumGoldBounty(0)
	unit:SetMinimumGoldBounty(0)

	-- attack damage
	local base_damage = math.ceil((unit:GetBaseDamageMin() + unit:GetBaseDamageMax())/2)
	local damageDiff = unit:GetBaseDamageMax() - unit:GetBaseDamageMin()
	local newDamage = (Enemies.DIFFICULTY_DAMAGE_ADJUST[difficulty][enemyTier]*base_damage + Enemies:GetFlatDamageBonusForDifficulty(unit, base_level))*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["attack_damage"]*Enemies.GLOBAL_DAMAGE_ADJUST
	newDamage = Enemies:AdjustAttributeForMapSpecial(unit, "attack_damage", newDamage)
	unit:SetBaseDamageMin(math.max(newDamage-damageDiff, Enemies.MINIMUM_STARTING_ATTACK_DAMAGE_MIN))
	unit:SetBaseDamageMax(math.max(newDamage, Enemies.MINIMUM_STARTING_ATTACK_DAMAGE_MAX))


	-- roshpit attributes (armor, magic armor, spell pierce and armor pierce)
	unit:SetPhysicalArmorBaseValue(0)
	local newArmor = (unit.roshpit_attributes.roshpit_armor*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]+Enemies:GetFlatRoshpitAttributeForDifficulty(unit, base_level))*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	newArmor = Enemies:AdjustAttributeForMapSpecial(unit, "roshpit_armor", newArmor)
	unit:SetBaseRoshpitArmor(newArmor, false)

	local newMagicArmor = (unit.roshpit_attributes.roshpit_magic_armor*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]+Enemies:GetFlatRoshpitAttributeForDifficulty(unit, base_level))*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	newMagicArmor = Enemies:AdjustAttributeForMapSpecial(unit, "roshpit_magic_armor", newMagicArmor)
	unit:SetBaseRoshpitMagicArmor(newMagicArmor, false)

	local newArmorPierce = (unit.roshpit_attributes.roshpit_armor_pierce*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]+Enemies:GetFlatRoshpitAttributeForDifficulty(unit, base_level))*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	newArmorPierce = Enemies:AdjustAttributeForMapSpecial(unit, "roshpit_armor_pierce", newArmorPierce)
	unit:SetBaseRoshpitArmorPierce(newArmorPierce, false)

	local newSpellPierce = (unit.roshpit_attributes.roshpit_spell_pierce*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]+Enemies:GetFlatRoshpitAttributeForDifficulty(unit, base_level))*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	newSpellPierce = Enemies:AdjustAttributeForMapSpecial(unit, "roshpit_spell_pierce", newSpellPierce)
	unit:SetBaseRoshpitSpellPierce(newSpellPierce, false)


	-- HP
	local newHealth = (unit:GetMaxHealth()*Enemies.DIFFICULTY_HEALTH_MULT[difficulty][enemyTier] + Enemies.DIFFICULTY_HEALTH_FLAT[difficulty][enemyTier])*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["max_hp"]
	if unit_level > 9 then
		newHealth = newHealth*Enemies.GLOBAL_HEALTH_MULT
	end
	newHealth = Enemies:AdjustAttributeForMapSpecial(unit, "health", newHealth)
	newHealth = newHealth + newHealth * Enemies.EXTRA_HEALTH_BONUS_PER_ADDITIONAL_PLAYER * (math.max(RPCItems:GetConnectedPlayerCount() - 1, 0))
	newHealth = math.min(newHealth, (2 ^ 30) - 10)
	unit:SetMaxHealth(newHealth)
	unit:SetBaseMaxHealth(newHealth)
	unit:SetHealth(newHealth)
	local health_regen = unit:GetHealthRegen()
	unit:SetBaseHealthRegen(health_regen*Enemies.DIFFICULTY_HEALTH_MULT[difficulty][enemyTier])

	Challenges:AdjustUnitForChallenge(unit, unit_level, enemyTier, difficulty)
	Enemies:ParagonChance(unit)
	-- ability levels
	for i = 0, 6, 1 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(difficulty)
		end
	end
end

Enemies.WINTERBLIGHT_STONES_BUFFS = {}
Enemies.WINTERBLIGHT_STONES_BUFFS["attack_damage"] = 0.35
Enemies.WINTERBLIGHT_STONES_BUFFS["roshpit_armor"] = 0.75
Enemies.WINTERBLIGHT_STONES_BUFFS["roshpit_magic_armor"] = 0.75
Enemies.WINTERBLIGHT_STONES_BUFFS["roshpit_armor_pierce"] = 0.75
Enemies.WINTERBLIGHT_STONES_BUFFS["roshpit_spell_pierce"] = 0.75
Enemies.WINTERBLIGHT_STONES_BUFFS["health"] = 0.5

Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL = {}
Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["attack_damage"] = 0.1
Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_armor"] = 0.2
Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_magic_armor"] = 0.2
Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_armor_pierce"] = 0.2
Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_spell_pierce"] = 0.2
Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["health"] = 0.1

Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL = {}
Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL["attack_damage"] = 0.2
Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL["roshpit_armor"] = 0.3
Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL["roshpit_magic_armor"] = 0.3
Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL["roshpit_armor_pierce"] = 0.3
Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL["roshpit_spell_pierce"] = 0.3
Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL["health"] = 0.3

Enemies.GLOBAL_SEA_FORTRESS_MULT = {}
Enemies.GLOBAL_SEA_FORTRESS_MULT["attack_damage"] = 2
Enemies.GLOBAL_SEA_FORTRESS_MULT["roshpit_armor"] = 3
Enemies.GLOBAL_SEA_FORTRESS_MULT["roshpit_magic_armor"] = 3
Enemies.GLOBAL_SEA_FORTRESS_MULT["roshpit_armor_pierce"] = 3
Enemies.GLOBAL_SEA_FORTRESS_MULT["roshpit_spell_pierce"] = 3
Enemies.GLOBAL_SEA_FORTRESS_MULT["health"] = 2

Enemies.SERENGAARD_BUFFS_PER_WAVE = {}
Enemies.SERENGAARD_BUFFS_PER_WAVE["attack_damage"] = 0.05
Enemies.SERENGAARD_BUFFS_PER_WAVE["roshpit_armor"] = 0.1
Enemies.SERENGAARD_BUFFS_PER_WAVE["roshpit_magic_armor"] = 0.1
Enemies.SERENGAARD_BUFFS_PER_WAVE["roshpit_armor_pierce"] = 0.1
Enemies.SERENGAARD_BUFFS_PER_WAVE["roshpit_spell_pierce"] = 0.1
Enemies.SERENGAARD_BUFFS_PER_WAVE["health"] = 0.05

function Enemies:AdjustAttributeForMapSpecial(enemy, attribute_type, base_attribute_value)
	local adjusted_attribute_value = base_attribute_value
	if GameState:IsWinterblight() then
		adjusted_attribute_value = base_attribute_value * (1 + Winterblight.Stones*Enemies.WINTERBLIGHT_STONES_BUFFS[attribute_type])
	elseif GameState:IsRPCArena() then
		if enemy:GetKeyValue("PitCreep") == 1 then
			adjusted_attribute_value = base_attribute_value * (1 + Arena.PitLevel*Enemies.PIT_OF_TRIALS_BUFFS_PER_LEVEL[attribute_type])
		end
	elseif GameState:IsSeaFortress() then
		adjusted_attribute_value = base_attribute_value * Enemies.GLOBAL_SEA_FORTRESS_MULT[attribute_type]
	elseif GameState:IsSerengaard() then
		if Serengaard.InfiniteWaveCount then
			adjusted_attribute_value = base_attribute_value * (1 + Serengaard.InfiniteWaveCount*Enemies.SERENGAARD_BUFFS_PER_WAVE[attribute_type])
		end
	elseif GameState:IsTanariJungle() or GameState:IsRedfallRidge() then
		-- spirit realm already in main chunk
	end
	return adjusted_attribute_value
end

function Enemies:AdjustUnitForCavern(unit)
	local chamber_level = 1
	if unit.chamber == 0 then
		chamber_level = unit.boss_level
	else
		chamber_level = Winterblight.CavernData.Chambers[unit.chamber]["level"]
	end

	local base_damage = (unit:GetBaseDamageMin() + unit:GetBaseDamageMax())/2
	local damageDiff = unit:GetBaseDamageMax() - unit:GetBaseDamageMin()
	local newDamage = base_damage * (1 + chamber_level*Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["attack_damage"])
	unit:SetBaseDamageMin(newDamage-damageDiff)
	unit:SetBaseDamageMax(newDamage)

	local newArmor = unit.roshpit_attributes.roshpit_armor * (1 + chamber_level*Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_armor"])
	unit:SetBaseRoshpitArmor(newArmor, false)

	local newMagicArmor = unit.roshpit_attributes.roshpit_magic_armor * (1 + chamber_level*Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_magic_armor"])
	unit:SetBaseRoshpitMagicArmor(newMagicArmor, false)

	local newArmorPierce = unit.roshpit_attributes.roshpit_armor_pierce * (1 + chamber_level*Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_armor_pierce"])
	unit:SetBaseRoshpitArmorPierce(newArmorPierce, false)

	local newSpellPierce = unit.roshpit_attributes.roshpit_spell_pierce * (1 + chamber_level*Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["roshpit_spell_pierce"])
	unit:SetBaseRoshpitSpellPierce(newSpellPierce, false)


	local newHealth = unit:GetMaxHealth() * (1 + chamber_level*Enemies.WINTERBLIGHT_CAVERN_BUFFS_PER_CHAMBER_LEVEL["max_health"])
	newHealth = math.min(newHealth, (2 ^ 30) - 10)
	unit:SetMaxHealth(newHealth)
	unit:SetBaseMaxHealth(newHealth)
	unit:SetHealth(newHealth)
end

function Enemies:ParagonChance(unit)
	if unit.roshpit_attributes.enemy_tier == ENEMY_TYPE_BOSS or unit.roshpit_attributes.enemy_tier == ENEMY_TYPE_MINI_BOSS then
		return false
	end
	local baseChance = 180
	if Events.SpiritRealm then
		baseChance = 90
	end
	if Challenges.ActiveChallenge then
		local divisor = math.max(((Challenges.ParagonChance/100)+1), 1)
		baseChance = baseChance/divisor
	end
	local luck = RandomInt(1, baseChance)
	if luck == 1 then
		Paragon:AddParagonUnit(unit)
		return true	
	else
		return false
	end
end



function Enemies:SplitAdjustedEXP(exp, number_of_heroes)
	-- ╔══════════════════════╦════════╦══════════════════╦═════════════════════╦═════════════════════╦═══════════════════════════╗
	-- ║ EXP_SHARE_PERCENTAGE ║ 1 Hero ║ 2 Heroes         ║ 3 Heroes            ║ 4 Heroes            ║ 5 Heroes                  ║
	-- ╠══════════════════════╬════════╬══════════════════╬═════════════════════╬═════════════════════╬═══════════════════════════╣
	-- ║ 0.95                 ║ 100%   ║ 95% -> 190%      ║ 90.25% -> 270.75%   ║ 85.7375% -> 342.95% ║ 81.450625% -> 407.253125% ║
	-- ║ 0.90                 ║ 100%   ║ 90% -> 180%      ║ 81%    -> 243%      ║ 72.9%    -> 291.6%  ║ 65.61%     -> 328.05%     ║
	-- ║ 0.85                 ║ 100%   ║ 85% -> 170%      ║ 72.25% -> 216.75%   ║ 61.4125% -> 245.65% ║ 52.200625% -> 261.003125% ║
	-- ║ 0.80                 ║ 100%   ║ 80% -> 160%      ║ 64%    -> 192%      ║ 51.2%    -> 204.8%  ║ 40.96%     -> 204.8%      ║
	-- ╠══════════════════════╬════════╬══════════════════╬═════════════════════╬═════════════════════╬═══════════════════════════╣
	-- ║ 0.75 <- CURRENT      ║ 100%   ║ 75% -> 150%      ║ 56.25% -> 168.75%   ║ 42.1875% -> 168.75% ║ 31.650625% -> 158.203125% ║
	-- ╠══════════════════════╬════════╬══════════════════╬═════════════════════╬═════════════════════╬═══════════════════════════╣
	-- ║ 0.70                 ║ 100%   ║ 70% -> 140%      ║ 49%    -> 147%      ║ 34.3%    -> 137.2%  ║ 24.01%     -> 120.05%     ║
	-- ║ 0.65                 ║ 100%   ║ 65% -> 130%      ║ 42.25% -> 126.75%   ║ 27.4625% -> 109.85% ║ 17.850625% -> 89.253125%  ║
	-- ║ 0.60                 ║ 100%   ║ 60% -> 120%      ║ 36%    -> 108%      ║ 21.6%    -> 86.4%   ║ 12.96%     -> 65.8%       ║
	-- ╚══════════════════════╩════════╩══════════════════╩═════════════════════╩═════════════════════╩═══════════════════════════╝
	local multiplier = math.pow(Enemies.EXP_SHARE_PERCENTAGE, number_of_heroes - 1)
	return exp * multiplier
end

function Enemies:EnemySlain(unit, killingUnit)
	local baseEXP = unit.roshpit_attributes.deathXP
	local direct_killer = nil
	local give_exp_to_direct_killer = true
	if killingUnit and killingUnit:IsHero() then
		direct_killer = killingUnit
	end
	if baseEXP > 0 then
		local expPopup = baseEXP
		
		local heroes = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, unit:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		if #heroes > 0 then
			for _, hero in pairs(heroes) do
				local exp_per_hero = Enemies:SplitAdjustedEXP(baseEXP, #heroes)
				expPopup = Enemies:GrantHeroAdjustedEXPForLevel(hero, unit.roshpit_attributes.roshpit_level, exp_per_hero)
				if hero == direct_killer then
					give_exp_to_direct_killer = false
				end
			end
		end	
		if direct_killer and give_exp_to_direct_killer then
			local exp_for_direct_killer = baseEXP
			exp_for_direct_killer = Enemies:SplitAdjustedEXP(baseEXP, #heroes+1)
			expPopup = Enemies:GrantHeroAdjustedEXPForLevel(direct_killer, unit.roshpit_attributes.roshpit_level, exp_for_direct_killer)
		end
		if expPopup > 0 then
			PopupExperience(unit, expPopup)
		end
	end
end



function Enemies:GrantHeroAdjustedEXPForLevel(hero, level_of_slain_enemy, baseEXP)
	local exp = baseEXP
	local level_differential = math.abs(hero:GetLevel() - level_of_slain_enemy)
	print("GRANT EXP")
	print(exp)
	print(level_differential)
	if level_differential > Enemies.EXP_LEVEL_DIFFERENTIAL then
		local exp_mult = math.max((1 - Enemies.EXP_DECAY_PER_LEVEL_BEYOND_DIFFERENTIAL*(level_differential-Enemies.EXP_LEVEL_DIFFERENTIAL)), 0.02)
		print(exp_mult)
		exp = exp*exp_mult
	end
	if exp > 0 then
		if hero:IsAlive() then
			exp = math.floor(exp)
			hero:AddExperience(exp, 2, false, true)
			hero:UpdateWeaponEXP(exp)
		end
	end
	return exp
end

function CDOTA_BaseNPC:ShouldHaveStunResistance()
	if unit.roshpit_attributes and unit.roshpit_attributes.enemy_tier and unit.roshpit_attributes.enemy_tier >= ENEMY_TYPE_ELITE_CREEP then
		return true
	elseif unit:IsHero() then
		return true
	else
		return false
	end
end
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
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_WEAK_CREEP] = 2
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_NORMAL_CREEP] = 3
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_ELITE_CREEP] = 5
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MINI_BOSS] = 7
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_BOSS] = 10
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MAJOR_BOSS] = 20
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_WEAK_CREEP] = 5
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_NORMAL_CREEP] = 12
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_ELITE_CREEP] = 40
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MINI_BOSS] = 65
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_BOSS] = 80
Enemies.DIFFICULTY_DAMAGE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MAJOR_BOSS] = 100

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
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_ELITE_CREEP] = 3
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MINI_BOSS] = 4
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_BOSS] = 5
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_ELITE][ENEMY_TYPE_MAJOR_BOSS] = 6
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_WEAK_CREEP] = 3
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_NORMAL_CREEP] = 6
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_ELITE_CREEP] = 10
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MINI_BOSS] = 20
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_BOSS] = 30
Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[DIFFICULTY_LEGEND][ENEMY_TYPE_MAJOR_BOSS] = 40

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

Enemies.SPIRIT_REALM_CONSTANTS = {}
Enemies.SPIRIT_REALM_CONSTANTS[0] = {}
Enemies.SPIRIT_REALM_CONSTANTS[1] = {}
Enemies.SPIRIT_REALM_CONSTANTS[0]["attack_damage"] = 1
Enemies.SPIRIT_REALM_CONSTANTS[0]["roshpit_attribute"] = 1
Enemies.SPIRIT_REALM_CONSTANTS[0]["max_hp"] = 1
Enemies.SPIRIT_REALM_CONSTANTS[1]["attack_damage"] = 2
Enemies.SPIRIT_REALM_CONSTANTS[1]["roshpit_attribute"] = 2
Enemies.SPIRIT_REALM_CONSTANTS[1]["max_hp"] = 2

Enemies.EXP_LEVEL_DIFFERENTIAL = 8
Enemies.EXP_DECAY_PER_LEVEL_BEYOND_DIFFERENTIAL = 0.1

Enemies.EXTRA_HEALTH_BONUS_PER_ADDITIONAL_PLAYER = 0.3

Enemies.ADDITIONAL_MOB_EXP_PER_PLAYER = 0.1
Enemies.EXTRA_EXP_PER_PASS_PLAYER = 0.2
Enemies.EXP_SHARE_PERCENTAGE = 0.75

Enemies.EXP_BASE_TABLE = {}
for i = 0, 120 , 1 do
	Enemies.EXP_BASE_TABLE[i]= math.ceil(7.5*(1.05^i)) + (i-1)
end

function Enemies:SpiritRealmNumber(spirit_realm)
	if spirit_realm then
		return 1
	else
		return 0
	end
end

function Enemies:InitializeEnemy(unit)
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
	unit.roshpit_attributes.deathXP = deathXP
	unit:SetDeathXP(0)
	-- gold bounty
	unit:SetMaximumGoldBounty(0)
	unit:SetMinimumGoldBounty(0)

	-- attack damage
	local base_damage = unit:GetAverageTrueAttackDamage(unit)
	local damageDiff = unit:GetBaseDamageMax() - unit:GetBaseDamageMin()
	local newDamage = Enemies.DIFFICULTY_DAMAGE_ADJUST[difficulty][enemyTier]*base_damage*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["attack_damage"]
	unit:SetBaseDamageMin(newDamage-damageDiff)
	unit:SetBaseDamageMax(newDamage)

	-- roshpit attributes (armor, magic armor, spell pierce and armor pierce)
	local newArmor = unit.roshpit_attributes.roshpit_armor*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	unit:SetBaseRoshpitArmor(newArmor, false)
	local newMagicArmor = unit.roshpit_attributes.roshpit_magic_armor*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	unit:SetBaseRoshpitMagicArmor(newMagicArmor, false)
	local newArmorPierce = unit.roshpit_attributes.roshpit_armor_pierce*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	unit:SetBaseRoshpitArmorPierce(newArmorPierce, false)
	local newSpellPierce = unit.roshpit_attributes.roshpit_spell_pierce*Enemies.DIFFICULTY_ROSHPIT_ATTRIBUTE_ADJUST[difficulty][enemyTier]*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["roshpit_attribute"]
	unit:SetBaseRoshpitSpellPierce(newSpellPierce, false)

	-- HP
	local newHealth = (unit:GetMaxHealth()*Enemies.DIFFICULTY_HEALTH_MULT[difficulty][enemyTier] + Enemies.DIFFICULTY_HEALTH_FLAT[difficulty][enemyTier])*Enemies.SPIRIT_REALM_CONSTANTS[spirit_realm]["max_hp"]
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

function Enemies:ParagonChance(unit)
	if unit.roshpit_attributes.enemy_tier == ENEMY_TYPE_BOSS or unit.roshpit_attributes.enemy_tier == ENEMY_TYPE_MINI_BOSS then
		return false
	end
	local baseChance = 180
	if Events.SpiritRealm then
		baseChance = 90
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
	local divisor = math.max(number_of_heroes*Enemies.EXP_SHARE_PERCENTAGE, 1)
	return exp/divisor
end

function Enemies:EnemySlain(unit, killingUnit)
	local baseEXP = unit.roshpit_attributes.deathXP
	local direct_killer = nil
	local give_exp_to_direct_killer = true
	if killingUnit:IsHero() then
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
		Weapons:UpdateWeaponXP(baseEXP)
	end
end



function Enemies:GrantHeroAdjustedEXPForLevel(hero, level_of_slain_enemy, baseEXP)
	local exp = baseEXP
	local level_differential = math.abs(hero:GetLevel() - level_of_slain_enemy)
	print("GRANT EXP")
	print(exp)
	print(level_differential)
	if level_differential > Enemies.EXP_LEVEL_DIFFERENTIAL then
		local exp_mult = math.max((1 - Enemies.EXP_DECAY_PER_LEVEL_BEYOND_DIFFERENTIAL*(level_differential-Enemies.EXP_LEVEL_DIFFERENTIAL)), 0.05)
		print(exp_mult)
		exp = exp*exp_mult
	end
	if exp > 0 then
		exp = math.floor(exp)
		hero:AddExperience(exp, 2, false, true)
		print("Hero Gained: "..exp.." EXP")
	end
	return exp
end
require('items/equip_gear')

RPCItems.DropCounts = {}
RPCItems.DropCounts[ENEMY_TYPE_WEAK_CREEP] = {}
RPCItems.DropCounts[ENEMY_TYPE_NORMAL_CREEP] = {}
RPCItems.DropCounts[ENEMY_TYPE_ELITE_CREEP] = {}
RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS] = {}
RPCItems.DropCounts[ENEMY_TYPE_BOSS] = {}
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS] = {}

RPCItems.DropCounts[ENEMY_TYPE_WEAK_CREEP][0] = 90
RPCItems.DropCounts[ENEMY_TYPE_WEAK_CREEP][1] = 100

RPCItems.DropCounts[ENEMY_TYPE_NORMAL_CREEP][0] = 65
RPCItems.DropCounts[ENEMY_TYPE_NORMAL_CREEP][1] = 90
RPCItems.DropCounts[ENEMY_TYPE_NORMAL_CREEP][2] = 100

RPCItems.DropCounts[ENEMY_TYPE_ELITE_CREEP][0] = 10
RPCItems.DropCounts[ENEMY_TYPE_ELITE_CREEP][1] = 70
RPCItems.DropCounts[ENEMY_TYPE_ELITE_CREEP][2] = 90
RPCItems.DropCounts[ENEMY_TYPE_ELITE_CREEP][3] = 96
RPCItems.DropCounts[ENEMY_TYPE_ELITE_CREEP][4] = 100

RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS][0] = 0
RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS][1] = 0
RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS][2] = 30
RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS][3] = 60
RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS][4] = 90
RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS][5] = 96
RPCItems.DropCounts[ENEMY_TYPE_MINI_BOSS][6] = 100

RPCItems.DropCounts[ENEMY_TYPE_BOSS][0] = 0
RPCItems.DropCounts[ENEMY_TYPE_BOSS][1] = 0
RPCItems.DropCounts[ENEMY_TYPE_BOSS][2] = 0
RPCItems.DropCounts[ENEMY_TYPE_BOSS][3] = 0
RPCItems.DropCounts[ENEMY_TYPE_BOSS][4] = 0
RPCItems.DropCounts[ENEMY_TYPE_BOSS][5] = 20
RPCItems.DropCounts[ENEMY_TYPE_BOSS][6] = 40
RPCItems.DropCounts[ENEMY_TYPE_BOSS][7] = 60
RPCItems.DropCounts[ENEMY_TYPE_BOSS][8] = 80
RPCItems.DropCounts[ENEMY_TYPE_BOSS][9] = 95
RPCItems.DropCounts[ENEMY_TYPE_BOSS][10] = 100

RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][0] = 0
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][1] = 0
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][2] = 0
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][3] = 0
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][4] = 0
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][5] = 0
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][6] = 10
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][7] = 30
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][8] = 50
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][9] = 70
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][10] = 85
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][11] = 95
RPCItems.DropCounts[ENEMY_TYPE_MAJOR_BOSS][12] = 100

RPCItems.PotionsDrops = {}
RPCItems.PotionsDrops[ENEMY_TYPE_WEAK_CREEP] = {}
RPCItems.PotionsDrops[ENEMY_TYPE_NORMAL_CREEP] = {}
RPCItems.PotionsDrops[ENEMY_TYPE_ELITE_CREEP] = {}
RPCItems.PotionsDrops[ENEMY_TYPE_MINI_BOSS] = {}
RPCItems.PotionsDrops[ENEMY_TYPE_BOSS] = {}
RPCItems.PotionsDrops[ENEMY_TYPE_MAJOR_BOSS] = {}
RPCItems.PotionsDrops[ENEMY_TYPE_WEAK_CREEP][0] = 85
RPCItems.PotionsDrops[ENEMY_TYPE_WEAK_CREEP][1] = 100
RPCItems.PotionsDrops[ENEMY_TYPE_NORMAL_CREEP][0] = 84
RPCItems.PotionsDrops[ENEMY_TYPE_NORMAL_CREEP][1] = 97
RPCItems.PotionsDrops[ENEMY_TYPE_NORMAL_CREEP][2] = 100
RPCItems.PotionsDrops[ENEMY_TYPE_ELITE_CREEP][0] = 50
RPCItems.PotionsDrops[ENEMY_TYPE_ELITE_CREEP][1] = 90
RPCItems.PotionsDrops[ENEMY_TYPE_ELITE_CREEP][2] = 95
RPCItems.PotionsDrops[ENEMY_TYPE_ELITE_CREEP][3] = 100
RPCItems.PotionsDrops[ENEMY_TYPE_MINI_BOSS][0] = 30
RPCItems.PotionsDrops[ENEMY_TYPE_MINI_BOSS][1] = 75
RPCItems.PotionsDrops[ENEMY_TYPE_MINI_BOSS][2] = 88
RPCItems.PotionsDrops[ENEMY_TYPE_MINI_BOSS][3] = 100
RPCItems.PotionsDrops[ENEMY_TYPE_BOSS][0] = 100
RPCItems.PotionsDrops[ENEMY_TYPE_MAJOR_BOSS][0] = 100

RPCItems.RarityChances = {}
RPCItems.RarityChances[RPC_ITEMS_RARITY_COMMON] = 5000
RPCItems.RarityChances[RPC_ITEMS_RARITY_UNCOMMON] = 8000
RPCItems.RarityChances[RPC_ITEMS_RARITY_RARE] = 9300
RPCItems.RarityChances[RPC_ITEMS_RARITY_MYTHICAL] = 9920
RPCItems.RarityChances[RPC_ITEMS_RARITY_IMMORTAL] = 9999
RPCItems.RarityChances[RPC_ITEMS_RARITY_ARCANA] = 10000

RPCItems.ChancesToLoseImmortal = {}
RPCItems.ChancesToLoseImmortal[1] = 67
RPCItems.ChancesToLoseImmortal[2] = 34
RPCItems.ChancesToLoseImmortal[3] = 0

RPCItems.BONUS_PARAGON_DROPS = {}
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_WEAK_CREEP] = {}
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_NORMAL_CREEP] = {}
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_ELITE_CREEP] = {}
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_MINI_BOSS] = {}
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_BOSS] = {}
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_MAJOR_BOSS] = {}
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_WEAK_CREEP]["min"] = 1
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_WEAK_CREEP]["max"] = 1
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_NORMAL_CREEP]["min"] = 1
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_NORMAL_CREEP]["max"] = 3
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_ELITE_CREEP]["min"] = 2
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_ELITE_CREEP]["max"] = 4
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_MINI_BOSS]["min"] = 3
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_MINI_BOSS]["max"] = 7
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_BOSS]["min"] = 3
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_BOSS]["max"] = 8
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_MAJOR_BOSS]["min"] = 4
RPCItems.BONUS_PARAGON_DROPS[ENEMY_TYPE_MAJOR_BOSS]["max"] = 9

RPCItems.MAX_ITEM_LEVEL = 120

RPCItems.RARITY_BOOSTS = {}
RPCItems.RARITY_BOOSTS[ENEMY_TYPE_WEAK_CREEP] = 0
RPCItems.RARITY_BOOSTS[ENEMY_TYPE_NORMAL_CREEP] = 0
RPCItems.RARITY_BOOSTS[ENEMY_TYPE_ELITE_CREEP] = 1000 
RPCItems.RARITY_BOOSTS[ENEMY_TYPE_MINI_BOSS] = 5000
RPCItems.RARITY_BOOSTS[ENEMY_TYPE_BOSS] = 7000
RPCItems.RARITY_BOOSTS[ENEMY_TYPE_MAJOR_BOSS] = 7000

RPCItems.SOCKETS_ON_DROP_CHANCE = {}
RPCItems.SOCKETS_ON_DROP_CHANCE[1] = 5
RPCItems.SOCKETS_ON_DROP_CHANCE[2] = 10

function CDOTA_BaseNPC:DropItemsOnDeath()
	local unit = self
	local unit_level = 0
	if unit.disable_drops then
		return false
	end
	if unit.roshpit_attributes.roshpit_level then
		unit_level = unit.roshpit_attributes.roshpit_level
	end
	local tier = unit.roshpit_attributes.enemy_tier
	if not tier then
		return false
	end
	local drop_count = RPCItems:GetEnemyItemDropCount(tier, unit.paragon)
	for i = 1, drop_count, 1 do
		local item = RPCItems:RollRandomItem(unit_level, RPCItems.RARITY_BOOSTS[tier])
		if item then
			RPCItems:BasicDropItem(unit:GetAbsOrigin(), item)
		end
	end

	local potions_count = RPCItems:GetPotionDrops(tier)
	for i = 1, potions_count, 1 do
		local potion = RPCItems:RollRandomPotion(unit_level)
		if potion then
			RPCItems:BasicDropItem(unit:GetAbsOrigin(), potion)
		end
	end
end

function CDOTA_BaseNPC:BossDrops(quantity)
	local unit = self
	quantity = math.max(quantity + RandomInt(-2, 2), 0)
	if quantity <= 0 then
		return false
	end
	local unit_level = 0
	if unit.roshpit_attributes.roshpit_level then
		unit_level = unit.roshpit_attributes.roshpit_level
	end
	local location = self:GetAbsOrigin()
	local socket_forger_value = unit_level*(GameState:GetPlayerPremiumStatusCount() + 2)
	for i = 1, quantity, 1 do
		Timers:CreateTimer(i*0.5, function()
			local luck = RandomInt(1, 3500)
			if luck < socket_forger_value then
				Gems:DropSocketForger(unit:GetAbsOrigin())
			end
			RPCItems:RollRandomItemAtLocation(unit_level, location, RPCItems.RARITY_BOOSTS[ENEMY_TYPE_MINI_BOSS])
		end)
	end
end

function CDOTA_BaseNPC:ChestDrops(quantity)
	local unit = self
	quantity = math.max(quantity + RandomInt(-2, 2), 0)
	if quantity <= 0 then
		return false
	end
	local unit_level = 0
	if unit.roshpit_attributes.roshpit_level then
		unit_level = unit.roshpit_attributes.roshpit_level
	end
	local location = self:GetAbsOrigin()
	for i = 1, quantity, 1 do
		RPCItems:RollRandomItemAtLocation(unit_level, location, RPCItems.RARITY_BOOSTS[ENEMY_TYPE_BOSS])
	end
end

function RPCItems:GetEnemyItemDropCount(tier, paragon)
	local base_roll = 0
	base_roll = base_roll + RPCItems:GetConnectedPlayerCount()*4
	base_roll = base_roll + GameState:GetPlayerPremiumStatusCount()*6
	local luck = RandomInt(base_roll, 100)

	local drop_count = 0
	for key, value in pairs(RPCItems.DropCounts[tier]) do
		if luck <= value then
			drop_count = key
			break
		end
	end
	if paragon then
		drop_count = drop_count + RandomInt(RPCItems.BONUS_PARAGON_DROPS[tier]["min"], RPCItems.BONUS_PARAGON_DROPS[tier]["max"]) 
	end
	return drop_count
end

function RPCItems:RollRandomItemAtLocation(unit_level, location, roll_boost)
	local item = RPCItems:RollRandomItem(unit_level, roll_boost)
	RPCItems:BasicDropItem(location, item)
end

function RPCItems:RollRandomItem(unit_level, roll_boost)
	local item = nil
	local rarityChance = RandomInt(0+roll_boost, 10000)
	local rarity = RPC_ITEMS_RARITY_COMMON
	for key, value in pairs(RPCItems.RarityChances) do
		if rarityChance <= value then
			rarity = key
			break
		end
	end
	local bad_luck = RandomInt(1, 100)
	if bad_luck <= RPCItems.ChancesToLoseImmortal[GameState:GetDifficultyFactor()] and rarity == RPC_ITEMS_RARITY_IMMORTAL then
		rarity = RPC_ITEMS_RARITY_MYTHICAL
	end

	local item_level = RPCItems:RollItemLevelFromUnit(unit_level)

	local random_type_boost = math.floor(roll_boost/2)
	local random_type_chance = RandomInt(0+random_type_boost, 10000)
	if random_type_chance <= 9960 then
		local random_gear_slot = RandomInt(0, 5)
		if random_gear_slot == RPC_GEAR_SLOT_WEAPON then
			item = Weapons:RollWeapon(rarity, item_level)
		else
			item = RPCItems:RollRandomItemBySlot(rarity, item_level, random_gear_slot)
		end
	elseif random_type_chance <= 9996 then
		item = RPCItems:RebornGlyph()
	elseif random_type_chance <= 10000 then
		item = RPCItems:RebornSpecialItem()
	end
	return item
end

function RPCItems:RebornSpecialItem()
	local luck = RandomInt(1, 100)
	local item = nil
	if luck <= 40 then
		item = Gems:DropSocketForger(nil)
	elseif luck <= 99 then
		item = RPCItems:RollReanimationStone(nil)
	else
		item = RPCItems:RollRandomArcanaCachePart(nil)
	end
	return item
end

BASE_HEAD_TABLE = {"item_hood", "item_cap", "item_helm"}
BASE_HEAD_NAME_TABLE = {"Hood", "Cap", "Helm"}

RPCItems.SUFFIX = {}
RPCItems.SUFFIX["strength"] = {"of the Bear", "of the Warrior", "of the Mountain", "of the Behemoth", "of Titans"}
RPCItems.SUFFIX["agility"] = {"of the Rabbit", "of the Swift", "of the Cheetah", "of the Wind", "of the Ninja"}
RPCItems.SUFFIX["intelligence"] = {"of Understanding", "of the Wise", "of Greater Intelligence", "of Great Brilliance", "of The Grand Magus"}
RPCItems.SUFFIX["spirit"] = {"of the Monk", "of the Paladin", "of the Knight", "of the Priest", "of Violet Dreams"}
RPCItems.SUFFIX["base_ability"] = {"of Force", "of Storms", "of Tempests", "of Scorching", "of Endless War"}
RPCItems.SUFFIX["magic_armor"] = {"of Softening", "of Protection", "of Mitigation", "of Dampening", "of Charming"}
RPCItems.SUFFIX["armor"] = {"of Protection", "of the Bulwark", "of Mitigation", "of Blocking", "of Defense"}
RPCItems.SUFFIX["health_regen"] = {"of Healing", "of Restoration", "of Recovery", "of Life", "of Recuperation"}
RPCItems.SUFFIX["mana_regen"] = {"of Refreshment", "of Replenishment", "of Shielding", "of Greater Shielding", "of Untouchability"}
RPCItems.SUFFIX["max_health"] = {"of the Whale", "of Life", "of Longevity", "of Vitality", "of the Colossus"}
RPCItems.SUFFIX["max_mana"] = {"of Wisdom", "of the Moon", "of the Stars", "of the Blue Moon", "of the Blue Stars"}
RPCItems.SUFFIX["item_damage"] = {"of Expedience", "of Actuality", "of Praxis", "of Experience", "of Forging"}
RPCItems.SUFFIX["attack_speed"] = {"of Dexterity", "of the Archer", "of Greater Dexterity", "of Mastery", "of Greater Mastery"}
RPCItems.SUFFIX["spell_pierce"] = {"of Proficiency", "of Artistry", "of Nobility", "of Mastery", "of Greater Mastery"}
RPCItems.SUFFIX["armor_pierce"] = {"of Dexterity", "of the Archer", "of Greater Dexterity", "of Mastery", "of Greater Mastery"}
RPCItems.SUFFIX["movespeed"] = {"of Haste", "of Celerity", "of Alacrity", "of the Unicorn", "of Lightning Skies"}
RPCItems.SUFFIX["t1_rune"] = {"of Temperament", "of the Twilight Gaze", "of Heroes", "of Champions", "of the Light"}
RPCItems.SUFFIX["t2_rune"] = {"of the Dark Arts", "of the Old Master", "of the Wild Reach", "of the Silent Watch", "of the Secret Order"}
RPCItems.SUFFIX["attack_damage"] = {"of Crushing", "of Ripping", "of Rending", "of Tearing", "of Cracking"}

RPCItems.PREFIX = {}
RPCItems.PREFIX["strength"] = {"Soldier's", "Ogre's", "Beastial", "Mammoth's", "Giant's"}
RPCItems.PREFIX["agility"] = {"Nimble", "Adept", "Hasty", "Agile", "Skillful"}
RPCItems.PREFIX["intelligence"] = {"Intelligent", "Perceptive", "Brilliant", "Enlightened", "Sage's"}
RPCItems.PREFIX["spirit"] = {"Soul", "Spirit", "Ethereal", "Starsoul", "Spiritual"}
RPCItems.PREFIX["base_ability"] = {"Powerful", "Crushing", "Effective", "Authoritative", "Dominant"}
RPCItems.PREFIX["magic_armor"] = {"Enchanted", "Charmed", "Magnetic", "Spellbound", "Hypnotizing"}
RPCItems.PREFIX["armor"] = {"Thick", "Reinforced", "Augmented", "Braced", "Fortified"}
RPCItems.PREFIX["health_regen"] = {"Mending", "Refreshing", "Energizing", "Rejuvenating", "Wellspring"}
RPCItems.PREFIX["mana_regen"] = {"Replenishing", "Soul", "Mind", "Spirit", "Animus"}
RPCItems.PREFIX["max_health"] = {"Large", "Massive", "Immense", "Colossal", "Herculean"}
RPCItems.PREFIX["max_mana"] = {"Mana", "Greater Mana", "Soul", "Arcane", "Grand Arcane"}
RPCItems.PREFIX["item_damage"] = {"Practical", "Pragmatic", "Efficient", "Judicious", "Viable"}
RPCItems.PREFIX["attack_speed"] = {"Apt", "Talented", "Expert", "Furious", "Whirlwind"}
RPCItems.PREFIX["spell_pierce"] = {"Conjurer's", "Diviner's", "Clairvoyant", "Far Seer's", "Grand Far Seer's"}
RPCItems.PREFIX["armor_pierce"] = {"Apt", "Talented", "Expert", "Furious", "Whirlwind"}
RPCItems.PREFIX["movespeed"] = {"Dash", "Rush", "Mercury", "Rapid", "Swift"}
RPCItems.PREFIX["attack_damage"] = {"of Haste", "of Celerity", "of Alacrity", "of the Unicorn", "of Lightning Skies"}
RPCItems.PREFIX["t1_rune"] = {"Ivory", "Spirit", "Sanctified", "Dire", "Radiant"}
RPCItems.PREFIX["t2_rune"] = {"Stormsoul", "Bloodstone", "Goldstone", "Red Sky", "Wildtouch"}
RPCItems.PREFIX["attack_damage"] = {"Splitting", "Cerberus", "Gryphon", "Thunderbird", "Manticore"}


function RPCItems:RollItemLevelFromUnit(unit_level)
	local original_unit_level = unit_level
	local unit_level = math.min(unit_level, 100)
	local iLevel = math.max(RPCItems:GetLogarithmicVarianceValue(unit_level, 0, 0, 0, 0), 1)
	if unit_level >= 100 then
		iLevel = iLevel + 10
	end
	if iLevel >= 80 and iLevel <= 90 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(64, 0, 0, 0, 0)
	elseif iLevel > 90 and iLevel <= 100 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(69, 0, 0, 0, 0)
	elseif iLevel > 100 and iLevel <= 110 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(72, 0, 0, 0, 0)
	elseif iLevel > 110 and iLevel <= 120 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(75, 0, 0, 0, 0)
	elseif iLevel > 120 and iLevel <= 130 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(78, 0, 0, 0, 0)
	elseif iLevel > 130 and iLevel <= 140 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(80, 0, 0, 0, 0)
	elseif iLevel > 140 and iLevel <= 145 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(81, 0, 0, 0, 0)
	elseif iLevel > 145 then
		iLevel = RPCItems:GetLogarithmicVarianceValue(82, 0, 0, 0, 0)
	end
	if unit_level <= 20 and iLevel > unit_level then
		iLevel = unit_level
	elseif unit_level <= 40 and iLevel > unit_level + 5 then
		iLevel = unit_level + 5
	elseif unit_level <= 60 and iLevel > unit_level + 10 then
		iLevel = unit_level + 10
	elseif unit_level <= 80 and iLevel > unit_level + 15 then
		iLevel = unit_level + 15
	end
	if iLevel < original_unit_level - 40 then
		iLevel = original_unit_level - 40
	end
	print("ILEVEL: "..iLevel)
	return math.min(math.floor(iLevel), 120)
end

-- RPC_GEAR_SLOT_HEAD = 0
-- RPC_GEAR_SLOT_WEAPON = 1
-- RPC_GEAR_SLOT_GLOVES = 2
-- RPC_GEAR_SLOT_BOOTS = 3
-- RPC_GEAR_SLOT_BODY = 4
-- RPC_GEAR_SLOT_TRINKET = 5

RPCItems.REGULAR_PROPERTIES = {}
RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_HEAD] = {"strength", "agility", "intelligence", "spirit", "max_health", "max_mana", "armor", "base_ability", "magic_armor", "item_damage", "health_regen"}
RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_BODY] = {"strength", "agility", "intelligence", "spirit", "mana_regen", "health_regen", "armor", "base_ability", "magic_armor", "item_damage"}
RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_GLOVES] = {"strength", "agility", "intelligence", "spirit", "spell_pierce", "armor_pierce", "armor", "base_ability", "magic_armor", "item_damage", "attack_damage", "attack_speed", "mana_regen"}
RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_BOOTS] = {"strength", "agility", "intelligence", "spirit", "armor", "base_ability", "magic_armor", "item_damage", "movespeed"}
RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_TRINKET] = {"strength", "agility", "intelligence", "spirit", "spell_pierce", "base_ability", "magic_armor", "item_damage", "t1_rune", "t2_rune"}
RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON] = {"strength", "agility", "intelligence", "spirit", "base_ability", "item_damage", "t1_rune", "t2_rune", "t3_rune", "armor_pierce", "spell_pierce"}

RPCItems.AttributesRolls = {}
RPCItems.AttributesRolls[1] = {}
RPCItems.AttributesRolls[2] = {}
RPCItems.AttributesRolls[3] = {}
RPCItems.AttributesRolls[4] = {}

RPCItems.AttributesRolls[1]["strength"] = 0.8
RPCItems.AttributesRolls[2]["strength"] = 0.9
RPCItems.AttributesRolls[3]["strength"] = 1.0
RPCItems.AttributesRolls[4]["strength"] = 1.0

RPCItems.AttributesRolls[1]["agility"] = 0.8
RPCItems.AttributesRolls[2]["agility"] = 0.9
RPCItems.AttributesRolls[3]["agility"] = 1.0
RPCItems.AttributesRolls[4]["agility"] = 1.0

RPCItems.AttributesRolls[1]["intelligence"] = 0.8
RPCItems.AttributesRolls[2]["intelligence"] = 0.9
RPCItems.AttributesRolls[3]["intelligence"] = 1.0
RPCItems.AttributesRolls[4]["intelligence"] = 1.0

RPCItems.AttributesRolls[1]["spirit"] = 0.8
RPCItems.AttributesRolls[2]["spirit"] = 0.9
RPCItems.AttributesRolls[3]["spirit"] = 1.0
RPCItems.AttributesRolls[4]["spirit"] = 1.0

RPCItems.AttributesRolls[1]["all_attributes"] = RPCItems.AttributesRolls[1]["strength"]/4
RPCItems.AttributesRolls[2]["all_attributes"] = RPCItems.AttributesRolls[2]["strength"]/4
RPCItems.AttributesRolls[3]["all_attributes"] = RPCItems.AttributesRolls[3]["strength"]/4
RPCItems.AttributesRolls[4]["all_attributes"] = RPCItems.AttributesRolls[4]["strength"]/4

RPCItems.AttributesRolls[1]["max_health"] = CustomAttributes.HEALTH_PER_STR * RPCItems.AttributesRolls[1]["strength"] * 3.5
RPCItems.AttributesRolls[2]["max_health"] = CustomAttributes.HEALTH_PER_STR * RPCItems.AttributesRolls[2]["strength"] * 3.5
RPCItems.AttributesRolls[3]["max_health"] = CustomAttributes.HEALTH_PER_STR * RPCItems.AttributesRolls[3]["strength"] * 3.5
RPCItems.AttributesRolls[4]["max_health"] = CustomAttributes.HEALTH_PER_STR * RPCItems.AttributesRolls[4]["strength"] * 3.5

RPCItems.AttributesRolls[1]["health_regen"] = CustomAttributes.HEALTH_REGEN_PER_STR * RPCItems.AttributesRolls[1]["strength"] * 3.5
RPCItems.AttributesRolls[2]["health_regen"] = CustomAttributes.HEALTH_REGEN_PER_STR * RPCItems.AttributesRolls[2]["strength"] * 3.5
RPCItems.AttributesRolls[3]["health_regen"] = CustomAttributes.HEALTH_REGEN_PER_STR * RPCItems.AttributesRolls[3]["strength"] * 3.5
RPCItems.AttributesRolls[4]["health_regen"] = CustomAttributes.HEALTH_REGEN_PER_STR * RPCItems.AttributesRolls[4]["strength"] * 3.5

RPCItems.AttributesRolls[1]["armor"] = CustomAttributes.ARMOR_PER_STR * RPCItems.AttributesRolls[1]["strength"] * 3.5
RPCItems.AttributesRolls[2]["armor"] = CustomAttributes.ARMOR_PER_STR * RPCItems.AttributesRolls[2]["strength"] * 3.5
RPCItems.AttributesRolls[3]["armor"] = CustomAttributes.ARMOR_PER_STR * RPCItems.AttributesRolls[3]["strength"] * 3.5
RPCItems.AttributesRolls[4]["armor"] = CustomAttributes.ARMOR_PER_STR * RPCItems.AttributesRolls[4]["strength"] * 3.5

RPCItems.AttributesRolls[1]["attack_speed"] = CustomAttributes.ATTACKSPEED_PER_AGI * RPCItems.AttributesRolls[1]["agility"] * 3.5
RPCItems.AttributesRolls[2]["attack_speed"] = CustomAttributes.ATTACKSPEED_PER_AGI * RPCItems.AttributesRolls[2]["agility"] * 3.5
RPCItems.AttributesRolls[3]["attack_speed"] = CustomAttributes.ATTACKSPEED_PER_AGI * RPCItems.AttributesRolls[3]["agility"] * 3.5
RPCItems.AttributesRolls[4]["attack_speed"] = CustomAttributes.ATTACKSPEED_PER_AGI * RPCItems.AttributesRolls[4]["agility"] * 3.5

RPCItems.AttributesRolls[1]["movespeed"] = CustomAttributes.MOVESPEED_PER_AGI * RPCItems.AttributesRolls[1]["agility"] * 10
RPCItems.AttributesRolls[2]["movespeed"] = CustomAttributes.MOVESPEED_PER_AGI * RPCItems.AttributesRolls[2]["agility"] * 10
RPCItems.AttributesRolls[3]["movespeed"] = CustomAttributes.MOVESPEED_PER_AGI * RPCItems.AttributesRolls[3]["agility"] * 10
RPCItems.AttributesRolls[4]["movespeed"] = CustomAttributes.MOVESPEED_PER_AGI * RPCItems.AttributesRolls[4]["agility"] * 10

RPCItems.AttributesRolls[1]["armor_pierce"] = CustomAttributes.ARMOR_PIERCE_PER_AGI * RPCItems.AttributesRolls[1]["agility"] * 3.5
RPCItems.AttributesRolls[2]["armor_pierce"] = CustomAttributes.ARMOR_PIERCE_PER_AGI * RPCItems.AttributesRolls[2]["agility"] * 3.5
RPCItems.AttributesRolls[3]["armor_pierce"] = CustomAttributes.ARMOR_PIERCE_PER_AGI * RPCItems.AttributesRolls[3]["agility"] * 3.5
RPCItems.AttributesRolls[4]["armor_pierce"] = CustomAttributes.ARMOR_PIERCE_PER_AGI * RPCItems.AttributesRolls[4]["agility"] * 3.5

RPCItems.AttributesRolls[1]["max_mana"] = CustomAttributes.MANA_PER_INT * RPCItems.AttributesRolls[1]["intelligence"] * 3.5
RPCItems.AttributesRolls[2]["max_mana"] = CustomAttributes.MANA_PER_INT * RPCItems.AttributesRolls[2]["intelligence"] * 3.5
RPCItems.AttributesRolls[3]["max_mana"] = CustomAttributes.MANA_PER_INT * RPCItems.AttributesRolls[3]["intelligence"] * 3.5
RPCItems.AttributesRolls[4]["max_mana"] = CustomAttributes.MANA_PER_INT * RPCItems.AttributesRolls[4]["intelligence"] * 3.5

RPCItems.AttributesRolls[1]["mana_regen"] = CustomAttributes.MANA_REGEN_PER_INT * RPCItems.AttributesRolls[1]["intelligence"] * 3.5
RPCItems.AttributesRolls[2]["mana_regen"] = CustomAttributes.MANA_REGEN_PER_INT * RPCItems.AttributesRolls[2]["intelligence"] * 3.5
RPCItems.AttributesRolls[3]["mana_regen"] = CustomAttributes.MANA_REGEN_PER_INT * RPCItems.AttributesRolls[3]["intelligence"] * 3.5
RPCItems.AttributesRolls[4]["mana_regen"] = CustomAttributes.MANA_REGEN_PER_INT * RPCItems.AttributesRolls[4]["intelligence"] * 3.5

RPCItems.AttributesRolls[1]["spell_pierce"] = CustomAttributes.SPELL_PIERCE_PER_INT * RPCItems.AttributesRolls[1]["intelligence"] * 3.5
RPCItems.AttributesRolls[2]["spell_pierce"] = CustomAttributes.SPELL_PIERCE_PER_INT * RPCItems.AttributesRolls[2]["intelligence"] * 3.5
RPCItems.AttributesRolls[3]["spell_pierce"] = CustomAttributes.SPELL_PIERCE_PER_INT * RPCItems.AttributesRolls[3]["intelligence"] * 3.5
RPCItems.AttributesRolls[4]["spell_pierce"] = CustomAttributes.SPELL_PIERCE_PER_INT * RPCItems.AttributesRolls[4]["intelligence"] * 3.5

RPCItems.AttributesRolls[1]["base_ability"] = CustomAttributes.BAD_PER_SPIRIT * RPCItems.AttributesRolls[1]["spirit"] * 3.5
RPCItems.AttributesRolls[2]["base_ability"] = CustomAttributes.BAD_PER_SPIRIT * RPCItems.AttributesRolls[2]["spirit"] * 3.5
RPCItems.AttributesRolls[3]["base_ability"] = CustomAttributes.BAD_PER_SPIRIT * RPCItems.AttributesRolls[3]["spirit"] * 3.5
RPCItems.AttributesRolls[4]["base_ability"] = CustomAttributes.BAD_PER_SPIRIT * RPCItems.AttributesRolls[4]["spirit"] * 3.5

RPCItems.AttributesRolls[1]["magic_armor"] = CustomAttributes.MAGIC_ARMOR_PER_SPIRIT * RPCItems.AttributesRolls[1]["spirit"] * 3.5
RPCItems.AttributesRolls[2]["magic_armor"] = CustomAttributes.MAGIC_ARMOR_PER_SPIRIT * RPCItems.AttributesRolls[2]["spirit"] * 3.5
RPCItems.AttributesRolls[3]["magic_armor"] = CustomAttributes.MAGIC_ARMOR_PER_SPIRIT * RPCItems.AttributesRolls[3]["spirit"] * 3.5
RPCItems.AttributesRolls[4]["magic_armor"] = CustomAttributes.MAGIC_ARMOR_PER_SPIRIT * RPCItems.AttributesRolls[4]["spirit"] * 3.5

RPCItems.AttributesRolls[1]["attack_damage"] = CustomAttributes.ATK_DMG_PER_PRIMARY * 5
RPCItems.AttributesRolls[2]["attack_damage"] = CustomAttributes.ATK_DMG_PER_PRIMARY * 5
RPCItems.AttributesRolls[3]["attack_damage"] = CustomAttributes.ATK_DMG_PER_PRIMARY * 5
RPCItems.AttributesRolls[4]["attack_damage"] = CustomAttributes.ATK_DMG_PER_PRIMARY * 5

RPCItems.AttributesRolls[1]["item_damage"] = RPCItems.AttributesRolls[1]["base_ability"]
RPCItems.AttributesRolls[2]["item_damage"] = RPCItems.AttributesRolls[2]["base_ability"]
RPCItems.AttributesRolls[3]["item_damage"] = RPCItems.AttributesRolls[3]["base_ability"]
RPCItems.AttributesRolls[4]["item_damage"] = RPCItems.AttributesRolls[4]["base_ability"]

RPCItems.AttributesRolls[1]["t1_rune"] = 0.17
RPCItems.AttributesRolls[2]["t1_rune"] = 0.17
RPCItems.AttributesRolls[3]["t1_rune"] = 0.17
RPCItems.AttributesRolls[4]["t1_rune"] = 0.17

RPCItems.AttributesRolls[1]["t2_rune"] = 0.17
RPCItems.AttributesRolls[2]["t2_rune"] = 0.17
RPCItems.AttributesRolls[3]["t2_rune"] = 0.17
RPCItems.AttributesRolls[4]["t2_rune"] = 0.17

RPCItems.AttributesRolls[1]["t3_rune"] = 0.085
RPCItems.AttributesRolls[2]["t3_rune"] = 0.085
RPCItems.AttributesRolls[3]["t3_rune"] = 0.085
RPCItems.AttributesRolls[4]["t3_rune"] = 0.085

RPCItems.AttributesRolls[1]["t4_rune"] = 0.0425
RPCItems.AttributesRolls[2]["t4_rune"] = 0.0425
RPCItems.AttributesRolls[3]["t4_rune"] = 0.0425
RPCItems.AttributesRolls[4]["t4_rune"] = 0.0425

RPCItems.AttributesRolls[1]["element_normal"] = 4
RPCItems.AttributesRolls[2]["element_normal"] = 4
RPCItems.AttributesRolls[3]["element_normal"] = 4
RPCItems.AttributesRolls[4]["element_normal"] = 4

RPCItems.AttributesRolls[1]["element_fire"] = 4
RPCItems.AttributesRolls[2]["element_fire"] = 4
RPCItems.AttributesRolls[3]["element_fire"] = 4
RPCItems.AttributesRolls[4]["element_fire"] = 4

RPCItems.AttributesRolls[1]["element_earth"] = 4
RPCItems.AttributesRolls[2]["element_earth"] = 4
RPCItems.AttributesRolls[3]["element_earth"] = 4
RPCItems.AttributesRolls[4]["element_earth"] = 4

RPCItems.AttributesRolls[1]["element_lightning"] = 4
RPCItems.AttributesRolls[2]["element_lightning"] = 4
RPCItems.AttributesRolls[3]["element_lightning"] = 4
RPCItems.AttributesRolls[4]["element_lightning"] = 4

RPCItems.AttributesRolls[1]["element_poison"] = 4
RPCItems.AttributesRolls[2]["element_poison"] = 4
RPCItems.AttributesRolls[3]["element_poison"] = 4
RPCItems.AttributesRolls[4]["element_poison"] = 4

RPCItems.AttributesRolls[1]["element_time"] = 4
RPCItems.AttributesRolls[2]["element_time"] = 4
RPCItems.AttributesRolls[3]["element_time"] = 4
RPCItems.AttributesRolls[4]["element_time"] = 4

RPCItems.AttributesRolls[1]["element_holy"] = 4
RPCItems.AttributesRolls[2]["element_holy"] = 4
RPCItems.AttributesRolls[3]["element_holy"] = 4
RPCItems.AttributesRolls[4]["element_holy"] = 4

RPCItems.AttributesRolls[1]["element_cosmic"] = 4
RPCItems.AttributesRolls[2]["element_cosmic"] = 4
RPCItems.AttributesRolls[3]["element_cosmic"] = 4
RPCItems.AttributesRolls[4]["element_cosmic"] = 4

RPCItems.AttributesRolls[1]["element_ice"] = 4
RPCItems.AttributesRolls[2]["element_ice"] = 4
RPCItems.AttributesRolls[3]["element_ice"] = 4
RPCItems.AttributesRolls[4]["element_ice"] = 4

RPCItems.AttributesRolls[1]["element_arcane"] = 4
RPCItems.AttributesRolls[2]["element_arcane"] = 4
RPCItems.AttributesRolls[3]["element_arcane"] = 4
RPCItems.AttributesRolls[4]["element_arcane"] = 4

RPCItems.AttributesRolls[1]["element_shadow"] = 4
RPCItems.AttributesRolls[2]["element_shadow"] = 4
RPCItems.AttributesRolls[3]["element_shadow"] = 4
RPCItems.AttributesRolls[4]["element_shadow"] = 4

RPCItems.AttributesRolls[1]["element_wind"] = 4
RPCItems.AttributesRolls[2]["element_wind"] = 4
RPCItems.AttributesRolls[3]["element_wind"] = 4
RPCItems.AttributesRolls[4]["element_wind"] = 4

RPCItems.AttributesRolls[1]["element_ghost"] = 4
RPCItems.AttributesRolls[2]["element_ghost"] = 4
RPCItems.AttributesRolls[3]["element_ghost"] = 4
RPCItems.AttributesRolls[4]["element_ghost"] = 4

RPCItems.AttributesRolls[1]["element_water"] = 4
RPCItems.AttributesRolls[2]["element_water"] = 4
RPCItems.AttributesRolls[3]["element_water"] = 4
RPCItems.AttributesRolls[4]["element_water"] = 4

RPCItems.AttributesRolls[1]["element_demon"] = 4
RPCItems.AttributesRolls[2]["element_demon"] = 4
RPCItems.AttributesRolls[3]["element_demon"] = 4
RPCItems.AttributesRolls[4]["element_demon"] = 4

RPCItems.AttributesRolls[1]["element_nature"] = 4
RPCItems.AttributesRolls[2]["element_nature"] = 4
RPCItems.AttributesRolls[3]["element_nature"] = 4
RPCItems.AttributesRolls[4]["element_nature"] = 4

RPCItems.AttributesRolls[1]["element_undead"] = 4
RPCItems.AttributesRolls[2]["element_undead"] = 4
RPCItems.AttributesRolls[3]["element_undead"] = 4
RPCItems.AttributesRolls[4]["element_undead"] = 4

RPCItems.AttributesRolls[1]["element_dragon"] = 4
RPCItems.AttributesRolls[2]["element_dragon"] = 4
RPCItems.AttributesRolls[3]["element_dragon"] = 4
RPCItems.AttributesRolls[4]["element_dragon"] = 4

RPCItems.AttributesRolls[1]["rune_q_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[2]["rune_q_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[3]["rune_q_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[4]["rune_q_1"] = RPCItems.AttributesRolls[1]["t1_rune"]

RPCItems.AttributesRolls[1]["rune_q_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[2]["rune_q_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[3]["rune_q_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[4]["rune_q_2"] = RPCItems.AttributesRolls[2]["t2_rune"]

RPCItems.AttributesRolls[1]["rune_q_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[2]["rune_q_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[3]["rune_q_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[4]["rune_q_3"] = RPCItems.AttributesRolls[3]["t3_rune"]

RPCItems.AttributesRolls[1]["rune_q_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[2]["rune_q_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[3]["rune_q_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[4]["rune_q_4"] = RPCItems.AttributesRolls[4]["t4_rune"]

RPCItems.AttributesRolls[1]["rune_w_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[2]["rune_w_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[3]["rune_w_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[4]["rune_w_1"] = RPCItems.AttributesRolls[1]["t1_rune"]

RPCItems.AttributesRolls[1]["rune_w_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[2]["rune_w_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[3]["rune_w_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[4]["rune_w_2"] = RPCItems.AttributesRolls[2]["t2_rune"]

RPCItems.AttributesRolls[1]["rune_w_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[2]["rune_w_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[3]["rune_w_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[4]["rune_w_3"] = RPCItems.AttributesRolls[3]["t3_rune"]

RPCItems.AttributesRolls[1]["rune_w_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[2]["rune_w_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[3]["rune_w_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[4]["rune_w_4"] = RPCItems.AttributesRolls[4]["t4_rune"]

RPCItems.AttributesRolls[1]["rune_e_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[2]["rune_e_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[3]["rune_e_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[4]["rune_e_1"] = RPCItems.AttributesRolls[1]["t1_rune"]

RPCItems.AttributesRolls[1]["rune_e_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[2]["rune_e_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[3]["rune_e_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[4]["rune_e_2"] = RPCItems.AttributesRolls[2]["t2_rune"]

RPCItems.AttributesRolls[1]["rune_e_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[2]["rune_e_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[3]["rune_e_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[4]["rune_e_3"] = RPCItems.AttributesRolls[3]["t3_rune"]

RPCItems.AttributesRolls[1]["rune_e_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[2]["rune_e_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[3]["rune_e_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[4]["rune_e_4"] = RPCItems.AttributesRolls[4]["t4_rune"]

RPCItems.AttributesRolls[1]["rune_r_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[2]["rune_r_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[3]["rune_r_1"] = RPCItems.AttributesRolls[1]["t1_rune"]
RPCItems.AttributesRolls[4]["rune_r_1"] = RPCItems.AttributesRolls[1]["t1_rune"]

RPCItems.AttributesRolls[1]["rune_r_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[2]["rune_r_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[3]["rune_r_2"] = RPCItems.AttributesRolls[2]["t2_rune"]
RPCItems.AttributesRolls[4]["rune_r_2"] = RPCItems.AttributesRolls[2]["t2_rune"]

RPCItems.AttributesRolls[1]["rune_r_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[2]["rune_r_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[3]["rune_r_3"] = RPCItems.AttributesRolls[3]["t3_rune"]
RPCItems.AttributesRolls[4]["rune_r_3"] = RPCItems.AttributesRolls[3]["t3_rune"]

RPCItems.AttributesRolls[1]["rune_r_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[2]["rune_r_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[3]["rune_r_4"] = RPCItems.AttributesRolls[4]["t4_rune"]
RPCItems.AttributesRolls[4]["rune_r_4"] = RPCItems.AttributesRolls[4]["t4_rune"]

function RPCItems:SetBaseItemValues(item, itemName, consumableBoolean, description, qualityColor, qualityName, rarityFactor, minLevel, item_slot)
	if not item.newItemTable then
		item.newItemTable = {}
	end
	if not item.newItemTable.validator then
		item.newItemTable.validator = RPCItems:GetRandomKey(13)
	end
	item.newItemTable.item_name = itemName
	item.newItemTable.consumable = consumableBoolean
	item.newItemTable.itemDescription = description
	item.newItemTable.qualityColor = qualityColor
	item.newItemTable.qualityName = qualityName
	item.newItemTable.gear_slot = item_slot

	item.newItemTable.rarityFactor = rarityFactor
	item.newItemTable.rarity = qualityName
	item.newItemTable.minLevel = minLevel
	RPCItems:ItemUpdateCustomNetTables(item)
end

function RPCItems:RollGearAttributeValue(item_level, property_type, property_slot, multiple)
	local max_value = 1
	local item_level_consider_for_rolling = RPCItems:GetPossibleHigherInternalItemLevel(item_level)
	if property_slot then
		max_value = RPCItems.AttributesRolls[property_slot][property_type] * item_level_consider_for_rolling * multiple
	else
		max_value = item_level_consider_for_rolling * multiple
	end
	local min_attempt = math.floor((max_value/1.5)/1.35)
	local max_attempt = math.floor(max_value/1.35)
	local roll_attempt = RandomInt(min_attempt, max_attempt)
	local roll = math.max(RPCItems:GetLogarithmicVarianceValue(roll_attempt, 0, 0, 0, 0), 1)
	roll = math.min(roll, max_value)
	roll = math.max(roll, 1)
	return math.floor(roll)
end

function RPCItems:GetPossibleHigherInternalItemLevel(item_level)
	local internal_item_level_attempt = RPCItems:GetLogarithmicVarianceValue(item_level, 0, 0, 0, 0)
	if internal_item_level_attempt > item_level then
		return math.min(internal_item_level_attempt, RPCItems.MAX_ITEM_LEVEL)
	else
		return item_level
	end
end


RPCItems.BASIC_ITEMS = {}

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][1] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][2] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][3] = {}

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][1]["item_variant"] = "item_hood"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][1]["item_name"] = "Hood"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][1]["armor"] = 0
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][1]["magic_armor"] = 2

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][2]["item_variant"] = "item_cap"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][2]["item_name"] = "Cap"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][2]["armor"] = 1
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][2]["magic_armor"] = 1

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][3]["item_variant"] = "item_helm"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][3]["item_name"] = "Helm"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][3]["armor"] = 2
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_HEAD][3]["magic_armor"] = 0

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][1] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][2] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][3] = {}

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][1]["item_variant"] = "item_rpc_robe"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][1]["item_name"] = "Robe"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][1]["armor"] = 0
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][1]["magic_armor"] = 2

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][2]["item_variant"] = "item_rpc_mantle"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][2]["item_name"] = "Mantle"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][2]["armor"] = 1
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][2]["magic_armor"] = 1

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][3]["item_variant"] = "item_rpc_mail"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][3]["item_name"] = "Mail"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][3]["armor"] = 2
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BODY][3]["magic_armor"] = 0

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][1] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][2] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][3] = {}

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][1]["item_variant"] = "item_wraps"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][1]["item_name"] = "Wraps"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][1]["armor"] = 0
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][1]["magic_armor"] = 2

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][2]["item_variant"] = "item_rpc_gloves"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][2]["item_name"] = "Gloves"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][2]["armor"] = 1
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][2]["magic_armor"] = 1

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][3]["item_variant"] = "item_rpc_gauntlets"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][3]["item_name"] = "Gauntlets"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][3]["armor"] = 2
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_GLOVES][3]["magic_armor"] = 0

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][1] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][2] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][3] = {}

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][1]["item_variant"] = "item_rpc_slippers"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][1]["item_name"] = "Slippers"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][1]["armor"] = 0
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][1]["magic_armor"] = 2

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][2]["item_variant"] = "item_rpc_boots"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][2]["item_name"] = "Boots"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][2]["armor"] = 1
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][2]["magic_armor"] = 1

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][3]["item_variant"] = "item_rpc_treads"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][3]["item_name"] = "Treads"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][3]["armor"] = 2
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_BOOTS][3]["magic_armor"] = 0

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][1] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][2] = {}
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][3] = {}

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][1]["item_variant"] = "item_rpc_talisman"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][1]["item_name"] = "Talisman"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][1]["armor"] = 0
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][1]["magic_armor"] = 2

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][2]["item_variant"] = "item_rpc_ruby_ring"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][2]["item_name"] = "Ring"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][2]["armor"] = 0
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][2]["magic_armor"] = 2

RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][3]["item_variant"] = "item_rpc_steel_ring"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][3]["item_name"] = "Loop"
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][3]["armor"] = 0
RPCItems.BASIC_ITEMS[RPC_GEAR_SLOT_TRINKET][3]["magic_armor"] = 2

RPCItems.BASIC_ITEMS_SLOT_TEXT = {}
RPCItems.BASIC_ITEMS_SLOT_TEXT[RPC_GEAR_SLOT_HEAD] = "Slot: Head"
RPCItems.BASIC_ITEMS_SLOT_TEXT[RPC_GEAR_SLOT_BODY] = "Slot: Body"
RPCItems.BASIC_ITEMS_SLOT_TEXT[RPC_GEAR_SLOT_WEAPON] = "Slot: Weapon"
RPCItems.BASIC_ITEMS_SLOT_TEXT[RPC_GEAR_SLOT_GLOVES] = "Slot: Hands"
RPCItems.BASIC_ITEMS_SLOT_TEXT[RPC_GEAR_SLOT_BOOTS] = "Slot: Feet"
RPCItems.BASIC_ITEMS_SLOT_TEXT[RPC_GEAR_SLOT_TRINKET] = "Slot: Trinket"

function RPCItems:RollRandomItemBySlot(rarity, item_level, item_slot)
	if rarity < RPC_ITEMS_RARITY_IMMORTAL then
		local basic_item_table = RPCItems.BASIC_ITEMS[item_slot][RandomInt(1, #RPCItems.BASIC_ITEMS[item_slot])]
		local item_variant = basic_item_table["item_variant"]
	    local item = RPCItems:CreateItem(item_variant, nil, nil)
	    item.newItemTable = {}
	    item.newItemTable.rarity = rarity
	    local rarityValue = RPCItems:GetRarityFactor(rarity)
	    local item_name = basic_item_table["item_name"]
	    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
	    item.newItemTable.gear = true	

	    local property_count = math.max(math.min(rarity, 4), 1)
	    for property_slot = 1, property_count, 1 do
	    	rollData = RPCItems:RollBasicItemProperty(item, item_slot, property_slot, item_level, nil, 1)
			if property_slot == 3 then
				item.newItemTable.itemPrefix = RPCItems.PREFIX[rollData["property_name"]][RandomInt(1, #RPCItems.PREFIX[rollData["property_name"]])]
			elseif property_slot == 4 then
				item.newItemTable.itemSuffix = RPCItems.SUFFIX[rollData["property_name"]][RandomInt(1, #RPCItems.SUFFIX[rollData["property_name"]])]
			end
	    end
	    RPCItems:GrantItemBaseArmor(item, item_level, basic_item_table["armor"])
	    RPCItems:GrantItemBaseMagicArmor(item, item_level, basic_item_table["magic_armor"])
	    RPCItems:SetBaseItemValues(item, item_name, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)
	    RPCItems:SocketsChance(item)
	    return item
	elseif rarity == RPC_ITEMS_RARITY_IMMORTAL then
		local immortal = RPCItems:RollRandomWorldArcana(item_level)
		return immortal
	elseif rarity == RPC_ITEMS_RARITY_ARCANA then
		local arcana = RPCItems:RollRandomWorldArcana(item_level)
		return arcana
	end
end

function RPCItems:RebornGlyph()
	local luck = RandomInt(1, 20)
	local glyph = nil
	if luck == 1 then
		glyph = Glyphs:RollRandomGlyphBook(nil)
	else
		glyph = Glyphs:RollRandomGlyph(nil)
	end
	return glyph
end

function RPCItems:SocketsChance(item)
	local socket_chance = RandomInt(1, 100)
	if socket_chance <= RPCItems.SOCKETS_ON_DROP_CHANCE[1] then
		Gems:AddSocket(item)
		local socket_chance2 = RandomInt(1, 100)
		if socket_chance2 <= RPCItems.SOCKETS_ON_DROP_CHANCE[2] then
			Gems:AddSocket(item)
		end
	end
end

RPCItems.PROPERTY_COLORS = {}
RPCItems.PROPERTY_COLORS["strength"] = COLOR_STRENGTH
RPCItems.PROPERTY_COLORS["agility"] = COLOR_AGILITY
RPCItems.PROPERTY_COLORS["intelligence"] = COLOR_INTELLIGENCE
RPCItems.PROPERTY_COLORS["spirit"] = COLOR_SPIRIT
RPCItems.PROPERTY_COLORS["max_health"] = "#B02020"
RPCItems.PROPERTY_COLORS["max_mana"] = "#343EC9"
RPCItems.PROPERTY_COLORS["armor"] = "#D1D1D1"
RPCItems.PROPERTY_COLORS["base_ability"] = "#7AB4CC"
RPCItems.PROPERTY_COLORS["magic_armor"] = "#AC47DE"
RPCItems.PROPERTY_COLORS["item_damage"] = "#F28100"
RPCItems.PROPERTY_COLORS["mana_regen"] = "#649FA3"
RPCItems.PROPERTY_COLORS["health_regen"] = "#6AA364"
RPCItems.PROPERTY_COLORS["armor_pierce"] = "#dcde87"
RPCItems.PROPERTY_COLORS["spell_pierce"] = "#9eddf7"
RPCItems.PROPERTY_COLORS["attack_damage"] = "#343EC9"
RPCItems.PROPERTY_COLORS["t1_rune"] = "#7DFF12"
RPCItems.PROPERTY_COLORS["t2_rune"] = "#7DFF12"
RPCItems.PROPERTY_COLORS["attack_speed"] = "#B02020"
RPCItems.PROPERTY_COLORS["movespeed"] = "#B02020"
RPCItems.PROPERTY_COLORS["aspect_health"] = "#343EC9"
RPCItems.PROPERTY_COLORS["all_attributes"] = "#FFFFFF"

RPCItems.PROPERTY_COLORS["element_normal"] = RPC_ELEMENT_NORMAL_COLOR
RPCItems.PROPERTY_COLORS["element_fire"] = RPC_ELEMENT_FIRE_COLOR
RPCItems.PROPERTY_COLORS["element_earth"] = RPC_ELEMENT_EARTH_COLOR
RPCItems.PROPERTY_COLORS["element_lightning"] = RPC_ELEMENT_LIGHTNING_COLOR
RPCItems.PROPERTY_COLORS["element_poison"] = RPC_ELEMENT_POISON_COLOR
RPCItems.PROPERTY_COLORS["element_time"] = RPC_ELEMENT_TIME_COLOR
RPCItems.PROPERTY_COLORS["element_holy"] = RPC_ELEMENT_HOLY_COLOR
RPCItems.PROPERTY_COLORS["element_cosmic"] = RPC_ELEMENT_COSMOS_COLOR
RPCItems.PROPERTY_COLORS["element_ice"] = RPC_ELEMENT_ICE_COLOR
RPCItems.PROPERTY_COLORS["element_arcane"] = RPC_ELEMENT_ARCANE_COLOR
RPCItems.PROPERTY_COLORS["element_shadow"] = RPC_ELEMENT_SHADOW_COLOR
RPCItems.PROPERTY_COLORS["element_wind"] = RPC_ELEMENT_WIND_COLOR
RPCItems.PROPERTY_COLORS["element_ghost"] = RPC_ELEMENT_GHOST_COLOR
RPCItems.PROPERTY_COLORS["element_water"] = RPC_ELEMENT_WATER_COLOR
RPCItems.PROPERTY_COLORS["element_demon"] = RPC_ELEMENT_DEMON_COLOR
RPCItems.PROPERTY_COLORS["element_nature"] = RPC_ELEMENT_NATURE_COLOR
RPCItems.PROPERTY_COLORS["element_undead"] = RPC_ELEMENT_UNDEAD_COLOR
RPCItems.PROPERTY_COLORS["element_dragon"] = RPC_ELEMENT_DRAGON_COLOR

function RPCItems:RollBasicItemProperty(item, item_slot, property_slot, item_level, property_type, special_mult)
	if not property_type then
		property_type = RPCItems.REGULAR_PROPERTIES[item_slot][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[item_slot])]
	end
	local roll = RPCItems:RollGearAttributeValue(item_level, property_type, property_slot, 1)
	roll = math.floor(roll * special_mult)
	local rollData = {}
	rollData["property_name"] = property_type
	rollData["value"] = roll

	if property_slot == 1 then
		if property_type == "t1_rune" or property_type == "t2_rune" or property_type == "t3_rune" or property_type == "t4_rune" or property_type:match("rune_(.)_(.)") then
			item.newItemTable.property1 = roll
			item.newItemTable.property1name = RPCItems:TranslateRuneRoll(property_type)
			RPCItems:SetPropertyValues(item, item.newItemTable.property1, "rune", "#7DFF12", 1)
		else
			item.newItemTable.property1 = roll
			item.newItemTable.property1name = property_type
			RPCItems:SetPropertyValues(item, item.newItemTable.property1, "#item_"..property_type, RPCItems.PROPERTY_COLORS[property_type], 1)
		end
	elseif property_slot == 2 then
		if property_type == "t1_rune" or property_type == "t2_rune" or property_type == "t3_rune" or property_type == "t4_rune" or property_type:match("rune_(.)_(.)") then
			item.newItemTable.property2 = roll
			item.newItemTable.property2name = RPCItems:TranslateRuneRoll(property_type)
			RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
		else
			item.newItemTable.property2 = roll
			item.newItemTable.property2name = property_type
			RPCItems:SetPropertyValues(item, item.newItemTable.property2, "#item_"..property_type, RPCItems.PROPERTY_COLORS[property_type], 2)
		end
	elseif property_slot == 3 then
		if property_type == "t1_rune" or property_type == "t2_rune" or property_type == "t3_rune" or property_type == "t4_rune" or property_type:match("rune_(.)_(.)") then
			item.newItemTable.property3 = roll
			item.newItemTable.property3name = RPCItems:TranslateRuneRoll(property_type)
			RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
		else
			item.newItemTable.property3 = roll
			item.newItemTable.property3name = property_type
			RPCItems:SetPropertyValues(item, item.newItemTable.property3, "#item_"..property_type, RPCItems.PROPERTY_COLORS[property_type], 3)
		end
	elseif property_slot == 4 then
		if property_type == "t1_rune" or property_type == "t2_rune" or property_type == "t3_rune" or property_type == "t4_rune" or property_type:match("rune_(.)_(.)") then
			item.newItemTable.property4 = roll
			item.newItemTable.property4name = RPCItems:TranslateRuneRoll(property_type)
			RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
		else
			item.newItemTable.property4 = roll
			item.newItemTable.property4name = property_type
			RPCItems:SetPropertyValues(item, item.newItemTable.property4, "#item_"..property_type, RPCItems.PROPERTY_COLORS[property_type], 4)
		end
	end
	return rollData
end

function RPCItems:TranslateRuneRoll(property_name)
	local runes_table = nil
	if property_name == "t1_rune" then
		runes_table = {"rune_q_1", "rune_w_1", "rune_e_1", "rune_r_1"}
	elseif property_name == "t2_rune" then
		runes_table = {"rune_q_2", "rune_w_2", "rune_e_2", "rune_r_2"}
	elseif property_name == "t3_rune" then
		runes_table = {"rune_q_3", "rune_w_3", "rune_e_3", "rune_r_3"}
	elseif property_name == "t4_rune" then
		runes_table = {"rune_q_4", "rune_w_4", "rune_e_4", "rune_r_4"}
	end
	if runes_table then
		return runes_table[RandomInt(1, #runes_table)]
	else
		return property_name
	end
end

function RPCItems:GrantItemBaseArmor(item, item_level, base_factor)
	local armor = 0
	if base_factor > 0 then
		armor = RPCItems:RollGearAttributeValue(item_level, nil, nil, base_factor*9)
	end
	item.newItemTable.base_armor = armor
end

function RPCItems:GrantItemBaseMagicArmor(item, item_level, base_factor)
	local magic_armor = 0
	if base_factor > 0 then
		magic_armor = RPCItems:RollGearAttributeValue(item_level, nil, nil, base_factor*9)
	end
	item.newItemTable.base_magic_armor = magic_armor
end

function RPCItems:GetPotionDrops(tier)
	local base_roll = 0
	base_roll = base_roll + RPCItems:GetConnectedPlayerCount()*4
	local luck = RandomInt(base_roll, 100)

	local drop_count = 0
	for key, value in pairs(RPCItems.PotionsDrops[tier]) do
		if luck <= value then
			drop_count = key
			break
		end
	end
	return drop_count
end

RPCItems.BASE_POTION_TABLE = {"item_potion_green", "item_potion_blue"}

function RPCItems:RollRandomPotion(potion_level)
	local potion_variant = RPCItems.BASE_POTION_TABLE[RandomInt(1, #RPCItems.BASE_POTION_TABLE)]
	local item = RPCItems:CreateItem(potion_variant, nil, nil)
	local rarity = "common"
	item.newItemTable.rarity = rarity
	local rarityValue = RPCItems:GetRarityFactor(rarity)
	local itemName = "Potion"
	local suffix = ""
	local prefix = ""
	item.newItemTable.item_slot = "consumable"
	item.cantStash = true


	if potion_variant == "item_potion_green" then
		local heal_amount = RPCItems:RollGearAttributeValue(potion_level, nil, nil, 100)
		heal_amount = math.max(heal_amount, 100)
		item.newItemTable.property1 = heal_amount
		item.newItemTable.property1name = "heal"
		RPCItems:SetPropertyValues(item, item.newItemTable.property1, "item_health_restore", "#99FF66", 1)
	elseif potion_variant == "item_potion_blue" then
		local mana_restore_amount = RPCItems:RollGearAttributeValue(potion_level, nil, nil, 80)
		mana_restore_amount = math.max(mana_restore_amount, 100)
		item.newItemTable.property1 = mana_restore_amount
		item.newItemTable.property1name = "mana_heal"
		RPCItems:SetPropertyValues(item, item.newItemTable.property1, "item_mana_restore", "#1975FF", 1)
	end
	RPCItems:SetTableValues(item, itemName, true, "Potion", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
	return item
end
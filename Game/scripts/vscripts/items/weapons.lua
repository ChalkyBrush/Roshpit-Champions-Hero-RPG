if Weapons == nil then
	Weapons = class({})
end

require('items/legend_weapons')

require('items/constants/boots')
require('items/constants/chest')
require('items/constants/gloves')
require('items/constants/helm')
require('items/constants/trinket')

Weapons.MAX_WEAPON_LEVEL = 10

Weapons.XP_PER_LEVEL_TABLE = {}
Weapons.XP_PER_LEVEL_TABLE[1] = 1000
for i = 2, Weapons.MAX_WEAPON_LEVEL, 1 do
	Weapons.XP_PER_LEVEL_TABLE[i] = (Weapons.XP_PER_LEVEL_TABLE[i-1])*3
end

function Weapons:weaponRedirect(hero)
	local heroName = hero:GetName()
	if heroName == "npc_dota_hero_dragon_knight" then
		Weapons:InitialWeapon(hero, "item_rpc_basic_sword", "Basic Sword")
	elseif heroName == "npc_dota_hero_phantom_assassin" then
		Weapons:InitialWeapon(hero, "item_rpc_voltex_weapon_00", "Hand Blade")
	elseif heroName == "npc_dota_hero_necrolyte" then
		Weapons:InitialWeapon(hero, "item_rpc_venomort_weapon_00", "Scythe")
	elseif heroName == "npc_dota_hero_axe" then
		Weapons:InitialWeapon(hero, "item_rpc_axe_weapon_00", "Basic Axe")
	elseif heroName == "npc_dota_hero_drow_ranger" then
		Weapons:InitialWeapon(hero, "item_rpc_astral_weapon_00", "Basic Bow")
	elseif heroName == "npc_dota_hero_obsidian_destroyer" then
		Weapons:InitialWeapon(hero, "item_rpc_basic_staff", "Staff")
	elseif heroName == "npc_dota_hero_omniknight" then
		Weapons:InitialWeapon(hero, "item_rpc_basic_hammer", "Hammer")
	elseif heroName == "npc_dota_hero_crystal_maiden" then
		Weapons:InitialWeapon(hero, "item_rpc_basic_staff", "Staff")
	elseif heroName == "npc_dota_hero_invoker" then
		Weapons:InitialWeapon(hero, "item_rpc_conjuror_weapon_00", "Orb")
	elseif heroName == "npc_dota_hero_juggernaut" then
		Weapons:InitialWeapon(hero, "item_rpc_basic_sword", "Basic Sword")
	elseif heroName == "npc_dota_hero_beastmaster" then
		Weapons:InitialWeapon(hero, "item_rpc_basic_axe", "Basic Axe")
	elseif heroName == "npc_dota_hero_leshrac" then
		Weapons:InitialWeapon(hero, "item_rpc_bahamut_weapon_00", "Base Rune")
	elseif heroName == "npc_dota_hero_spirit_breaker" then
		Weapons:InitialWeapon(hero, "item_rpc_duskbringer_weapon_00", "Flail")
	elseif heroName == "npc_dota_hero_zuus" then
		Weapons:InitialWeapon(hero, "item_rpc_auriun_weapon_00", "Tome")
	elseif heroName == "npc_dota_hero_templar_assassin" then
		Weapons:InitialWeapon(hero, "item_rpc_trapper_weapon_00", "Psi Blades")
	elseif heroName == "npc_dota_hero_huskar" then
		Weapons:InitialWeapon(hero, "item_rpc_spirit_warrior_weapon_00", "Spear")
	elseif heroName == "npc_dota_hero_legion_commander" then
		Weapons:InitialWeapon(hero, "item_rpc_mountain_protector_weapon_00", "Blade")
	elseif heroName == "npc_dota_hero_night_stalker" then
		Weapons:InitialWeapon(hero, "item_rpc_chernobog_weapon_00", "Claw")
	elseif heroName == "npc_dota_hero_vengefulspirit" then
		Weapons:InitialWeapon(hero, "item_rpc_solunia_weapon_00", "Blade")
	elseif heroName == "npc_dota_hero_slardar" then
		Weapons:InitialWeapon(hero, "item_rpc_hydroxis_weapon_00", "Mace")
	elseif heroName == "npc_dota_hero_visage" then
		Weapons:InitialWeapon(hero, "item_rpc_ekkan_weapon_00", "Chains")
	elseif heroName == "npc_dota_hero_dark_seer" then
		Weapons:InitialWeapon(hero, "item_rpc_zonik_weapon_00", "Punch Glove")
	elseif heroName == "npc_dota_hero_antimage" then
		Weapons:InitialWeapon(hero, "item_rpc_arkimus_weapon_00", "Blade")
	elseif heroName == "npc_dota_hero_monkey_king" then
		Weapons:InitialWeapon(hero, "item_rpc_djanghor_weapon_00", "Staff")
	elseif heroName == "npc_dota_hero_slark" then
		Weapons:InitialWeapon(hero, "item_rpc_slipfinn_weapon_00", "Shank")
	elseif heroName == "npc_dota_hero_skywrath_mage" then
		Weapons:InitialWeapon(hero, "item_rpc_sephyr_weapon_00", "Staff")
	elseif heroName == "npc_dota_hero_winter_wyvern" then
		Weapons:InitialWeapon(hero, "item_rpc_dinath_weapon_00", "Spike")
	elseif heroName == "npc_dota_hero_arc_warden" then
		Weapons:InitialWeapon(hero, "item_rpc_jex_weapon_00", "Gun")
	elseif heroName == "npc_dota_hero_faceless_void" then
		Weapons:InitialWeapon(hero, "item_rpc_omniro_weapon_00", "Mace")
	end
end

Weapons.STARTING_ATTACK_DMG = 10
Weapons.STARTING_ASPECT_HEALTH = 50

function Weapons:InitialWeapon(hero, item_variant, itemName)
	print("[Weapons:InitialWeapon]")
	local item = RPCItems:CreateItem(item_variant, nil, nil)
	local item_slot = RPC_GEAR_SLOT_WEAPON
	local rarity = RPC_ITEMS_RARITY_COMMON
    item.newItemTable = {}
    item.newItemTable.rarity = rarity
	item.newItemTable.xp = 0
	item.newItemTable.level = 1
	item.newItemTable.maxLevel = 2
	item.newItemTable.requiredHero = hero:GetUnitName()
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    item.newItemTable.gear = true	
	item.newItemTable.xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.newItemTable.level]
	-- Weapons:SetWeaponTable(item)
	if item_variant == "item_rpc_conjuror_weapon_00" then
		item.newItemTable.property1 = Weapons.STARTING_ASPECT_HEALTH
		item.newItemTable.property1name = "aspect_health"
		RPCItems:SetPropertyValues(item, Weapons.STARTING_ASPECT_HEALTH, "item_aspect_health", "#343EC9", 1)
	else
		item.newItemTable.property1 = Weapons.STARTING_ATTACK_DMG
		item.newItemTable.property1name = "attack_damage"
		RPCItems:SetPropertyValues(item, Weapons.STARTING_ATTACK_DMG, "item_attack_damage", RPCItems.PROPERTY_COLORS["attack_damage"], 1)
	end
	RPCItems:SetBaseItemValues(item, item_variant, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, 1, item_slot)
	hero:EquipItem(item)
end

function Weapons:ValidateGear(hero)
	print("[Weapons:ValidateGear] +++++++++++++++++++++++++++++++++++++++++++++")
	local playerID = hero:GetPlayerOwnerID()
	for i = 0, 5, 1 do
		local gearTable = CustomNetTables:GetTableValue("equipment", tostring(playerID) .. "-"..tostring(i))
		if gearTable then
			print("[Weapons:ValidateGear] gear "..i)
			DeepPrintTable(gearTable)
			print("[Weapons:ValidateGear] +++++++++++++++++++++++++++++++++++ ")
			local index = gearTable.itemIndex
			local itemEntity = EntIndexToHScript(index)
			if IsValidEntity(itemEntity) then
				print(itemEntity:GetAbilityName())
				print("[Weapons:ValidateGear] VALID ENTITY")
				if itemEntity.newItemTable and itemEntity.newItemTable.item_slot then
					if RPCItems:getGearSlot(itemEntity.newItemTable.item_slot) == i then
						print("[Weapons:ValidateGear] SLOT CORRECT")
					else
						print("[Weapons:ValidateGear] INCORRECT SLOT")
						RPCItems:ItemUTIL_Remove(itemEntity)
						CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(slot), {itemIndex = -1})
						CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
					end
				else
					print("[Weapons:ValidateGear} NO SLOT!")
					RPCItems:ItemUTIL_Remove(itemEntity)
					CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(slot), {itemIndex = -1})
					CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
				end
			else
				print("[Weapons:ValidateGear} 111 NO SLOT!")
				CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(slot), {itemIndex = -1})
				CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
			end
		end
	end
end

function CDOTA_BaseNPC_Hero:UpdateWeaponEXP(exp)
	local hero = self
	local weapon = nil
	if hero.equipped_gear and hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
		weapon = hero.equipped_gear[RPC_GEAR_SLOT_WEAPON]
	end
	if not weapon then
		return false
	end
	if not IsValidEntity(weapon) then
		return false
	end
	if hero:HasModifier("modifier_blacksmiths_tablet") then
		exp = math.floor(exp * (1 + BLACKSMITH_TABLE_ADD_WEAPON_EXP))
	end
	if weapon.newItemTable.level < weapon.newItemTable.maxLevel then
		weapon.newItemTable.xp = weapon.newItemTable.xp + exp
	end

	if weapon.newItemTable.xp >= Weapons.XP_PER_LEVEL_TABLE[weapon.newItemTable.level] and weapon.newItemTable.level < weapon.newItemTable.maxLevel then
		weapon.newItemTable.xp = exp - (Weapons.XP_PER_LEVEL_TABLE[weapon.newItemTable.level] - weapon.newItemTable.xp)
		weapon.newItemTable.xp = math.max(weapon.newItemTable.xp, 0)

		weapon.newItemTable.level = math.min(weapon.newItemTable.level + 1, Weapons.MAX_WEAPON_LEVEL)
		if weapon.newItemTable.xp > Weapons.XP_PER_LEVEL_TABLE[weapon.newItemTable.level] then
			weapon.newItemTable.xp = 0
		end
		Weapons:LevelUpWeapon(hero, weapon)
		hero:ApplyGearBonusesByGearSlot(RPC_GEAR_SLOT_WEAPON)

	end
	RPCItems:ItemUpdateCustomNetTables(weapon)
end

Weapons.STAT_ADD_PER_LEVEL_TABLE = {}
Weapons.STAT_ADD_PER_LEVEL_TABLE["strength"] = 15
Weapons.STAT_ADD_PER_LEVEL_TABLE["agility"] = 15
Weapons.STAT_ADD_PER_LEVEL_TABLE["intelligence"] = 15
Weapons.STAT_ADD_PER_LEVEL_TABLE["spirit"] = 15
Weapons.STAT_ADD_PER_LEVEL_TABLE["all_attributes"] = 4

Weapons.STAT_ADD_PER_LEVEL_TABLE["attack_damage"] = 50
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_q_1"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_w_1"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_e_1"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_r_1"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_q_2"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_w_2"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_e_2"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_r_2"] = 2
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_q_3"] = 1
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_w_3"] = 1
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_e_3"] = 1
Weapons.STAT_ADD_PER_LEVEL_TABLE["rune_r_3"] = 1
Weapons.STAT_ADD_PER_LEVEL_TABLE["aspect_health"] = 200
Weapons.STAT_ADD_PER_LEVEL_TABLE["base_ability"] = 6
Weapons.STAT_ADD_PER_LEVEL_TABLE["item_damage"] = 6
Weapons.STAT_ADD_PER_LEVEL_TABLE["armor_pierce"] = 60
Weapons.STAT_ADD_PER_LEVEL_TABLE["spell_pierce"] = 60


function Weapons:LevelUpWeapon(hero, weapon)
	--DeepPrintTable(weapon)
	if not weapon.newItemTable then
		print("[Error] Weapons:LevelUpWeapon - newItemTable is null")
		return
	end
	if weapon.newItemTable.level == 2 then
		if type(weapon.newItemTable.property1) == "number" and weapon.newItemTable.property1 > 8000 then
			return false
		end
	end
	if weapon.newItemTable.property1 and type(weapon.newItemTable.property1) == "number" then
		if Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property1name] then
			weapon.newItemTable.property1 = weapon.newItemTable.property1 + Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property1name]
		end
	end
	if weapon.newItemTable.property2 and type(weapon.newItemTable.property2) == "number" then
		if Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property2name] then
			weapon.newItemTable.property2 = weapon.newItemTable.property2 + Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property2name]
		end
	end
	if weapon.newItemTable.property3 and type(weapon.newItemTable.property3) == "number" then
		if Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property3name] then
			weapon.newItemTable.property3 = weapon.newItemTable.property3 + Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property3name]
		end
	end
	if weapon.newItemTable.property4 and type(weapon.newItemTable.property4) == "number" then
		if Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property4name] then
			weapon.newItemTable.property4 = weapon.newItemTable.property4 + Weapons.STAT_ADD_PER_LEVEL_TABLE[weapon.newItemTable.property4name]
		end
	end
	if weapon.newItemTable.rarity == "immortal" then
		Stars:StarEventPlayer("weapon", hero)
	end
	EmitGlobalSound("ui.treasure_reveal")
	hero:EquipItem(weapon)
	-- CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item = weapon:GetEntityIndex(), heroId = hero:GetClassname(), playerId = hero:GetPlayerOwnerID(), pickup = "weapon", rarity = weapon.newItemTable.rarity, rarityColor = RPCItems:GetRarityColor(weapon.newItemTable.rarity)})
end

function Weapons:Debug()
	Weapons:InitialSword(MAIN_HERO_TABLE[1])
end
Weapons.AttributeBaseRolls = {}
Weapons.AttributeBaseRolls["all_attributes"] = 0.12
Weapons.AttributeBaseRolls["strength"] = 0.5
Weapons.AttributeBaseRolls["agility"] = 0.5
Weapons.AttributeBaseRolls["spirit"] = 0.5
Weapons.AttributeBaseRolls["intelligence"] = 0.5
Weapons.AttributeBaseRolls["attack_damage"] = 2
Weapons.AttributeBaseRolls["aspect_health"] = 10
Weapons.AttributeBaseRolls["base_ability"] = CustomAttributes.BAD_PER_SPIRIT * Weapons.AttributeBaseRolls["spirit"] * 3.5
Weapons.AttributeBaseRolls["item_damage"] = Weapons.AttributeBaseRolls["base_ability"]
Weapons.AttributeBaseRolls["t1_rune"] = 0.16
Weapons.AttributeBaseRolls["t2_rune"] = 0.16
Weapons.AttributeBaseRolls["t3_rune"] = 0.08
Weapons.AttributeBaseRolls["armor_pierce"] = 4
Weapons.AttributeBaseRolls["spell_pierce"] = 4

-- RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON]

function Weapons:RollWeapon(rarity, item_level)
	local whichHero = MAIN_HERO_TABLE[RandomInt(1, #MAIN_HERO_TABLE)]:GetUnitName()
	local internalName = HerosCustom:GetInternalHeroName(whichHero)
	if rarity > RPC_ITEMS_RARITY_MYTHICAL then
		return nil
	end
	if rarity == RPC_ITEMS_RARITY_COMMON then
		return nil
	end
	-- "item_rpc_ekkan_weapon_01"
	local item_variant = "item_rpc_"..internalName.."_weapon_"..Weapons:GetWeaponDigits(rarity)
	local item = RPCItems:CreateItem(item_variant, nil, nil)
	local item_slot = RPC_GEAR_SLOT_WEAPON
    item.newItemTable = {}
    item.newItemTable.rarity = rarity
	item.newItemTable.xp = 0
	item.newItemTable.level = 1
	item.newItemTable.maxLevel = Weapons:GetMaxWeaponLevel(item_level)
	item.newItemTable.requiredHero = whichHero
    item.newItemTable.slot = RPC_GEAR_SLOT_NAMES[item_slot]
    item.newItemTable.gear = true	
	item.newItemTable.xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.newItemTable.level]
	-- Weapons:SetWeaponTable(item)
	if internalName == "npc_dota_hero_invoker" then
		item.newItemTable.property1 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls["aspect_health"])
		item.newItemTable.property1name = "aspect_health"
		RPCItems:SetPropertyValues(item, item.newItemTable.property1, "item_aspect_health", RPCItems.PROPERTY_COLORS["aspect_health"], 1)
	else
		item.newItemTable.property1 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls["attack_damage"])
		item.newItemTable.property1name = "attack_damage"
		RPCItems:SetPropertyValues(item, item.newItemTable.property1, "item_attack_damage", RPCItems.PROPERTY_COLORS["attack_damage"], 1)
	end
	if rarity >= RPC_ITEMS_RARITY_UNCOMMON then
		local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
		if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
			item.newItemTable.property2 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
			item.newItemTable.property2name = RPCItems:TranslateRuneRoll(property)
			RPCItems:SetPropertyValues(item, item.newItemTable.property2, "rune", "#7DFF12", 2)
		else
			item.newItemTable.property2 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
			item.newItemTable.property2name = property
			RPCItems:SetPropertyValues(item, item.newItemTable.property2, "item_"..property, RPCItems.PROPERTY_COLORS[property], 2)
		end

	end
	if rarity >= RPC_ITEMS_RARITY_RARE then
		local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
		if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
			item.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
			item.newItemTable.property3name = RPCItems:TranslateRuneRoll(property)
			RPCItems:SetPropertyValues(item, item.newItemTable.property3, "rune", "#7DFF12", 3)
		else
			item.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
			item.newItemTable.property3name = property
			RPCItems:SetPropertyValues(item, item.newItemTable.property3, "item_"..property, RPCItems.PROPERTY_COLORS[property], 3)
		end
	end
	if rarity >= RPC_ITEMS_RARITY_MYTHICAL then
		local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
		if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
			item.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
			item.newItemTable.property4name = RPCItems:TranslateRuneRoll(property)
			RPCItems:SetPropertyValues(item, item.newItemTable.property4, "rune", "#7DFF12", 4)
		else
			item.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
			item.newItemTable.property4name = property
			RPCItems:SetPropertyValues(item, item.newItemTable.property4, "item_"..property, RPCItems.PROPERTY_COLORS[property], 4)
		end
	end
	RPCItems:SetBaseItemValues(item, item_variant, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, item_slot)	
	return item
end

function Weapons:CreateWeaponVariant(variantName, rarityName, itemNameText, slot, gear, slotText, whichHero, maxLevel, minLevel)
	local itemVariant = variantName
	local item = RPCItems:CreateItem(itemVariant, nil, nil)
	if not item.newItemTable then
		item.newItemTable = {}
	end
	item.newItemTable.item_name = variantName
	item.newItemTable.rarity = rarityName
	local rarityValue = RPCItems:GetRarityFactor(item.newItemTable.rarity)
	local itemName = itemNameText
	local suffix = ""
	local prefix = ""
	item.newItemTable.item_slot = slot
	item.newItemTable.gear = gear
	item.newItemTable.hasRunePoints = true
	item.newItemTable.xp = 0
	item.newItemTable.level = 1
	item.newItemTable.xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.newItemTable.level]
	item.newItemTable.minLevel = minLevel
	item.newItemTable.maxLevel = maxLevel
	item.newItemTable.requiredHero = whichHero

	return item
end

function Weapons:SetWeaponTableValues(item, itemName, consumableBoolean, description, qualityColor, qualityName, prefix, suffix, rarityFactor, slot)
	if not item.newItemTable then
		item.newItemTable = {}
	end
	if qualityName == "immortal" then
		if not item.newItemTable.minLevel then
			item.newItemTable.minLevel = 100
		end
	end
	print("SET WEAPON TABLE VALUES")
	-- print("consumableBoolean")
	-- print(consumableBoolean)
	-- if not consumableBoolean then
	-- consumableBoolean = nil
	-- end

	--item.newItemTable.item_name = itemName
	item.newItemTable.consumable = consumableBoolean
	item.newItemTable.itemDescription = description
	item.newItemTable.qualityColor = qualityColor
	item.newItemTable.qualityName = qualityName
	item.newItemTable.itemPrefix = prefix
	item.newItemTable.itemSuffix = suffix
	item.newItemTable.rarityFactor = rarityFactor
	if not item.newItemTable.maxLevel then
		item.newItemTable.maxLevel = 50
	end
	item.newItemTable.requiredHero = item.newItemTable.requiredHero
	item.newItemTable.slot = slot
	Weapons:SetWeaponTable(item)
end

function Weapons:GetMaxWeaponLevel(item_level)
	local maxLevel = RPCItems:RollGearAttributeValue(item_level, nil, nil, 0.2)
	print("MAX LEVEL "..maxLevel)
	maxLevel = math.min(maxLevel, Weapons.MAX_WEAPON_LEVEL)
	maxLevel = math.max(maxLevel, 2)
	print("MAX LEVEL AFTER MINS AND MAXES"..maxLevel)
	print("------")
	return maxLevel
end

function Weapons:GetWeaponDigits(rarityFactor)
	if rarityFactor == 1 then
		return "00"
	elseif rarityFactor == 2 then
		local luck = RandomInt(1, 3)
		return "0"..luck
	elseif rarityFactor == 3 then
		local luck = RandomInt(1, 4)
		return "1"..luck
	elseif rarityFactor == 4 then
		local luck = RandomInt(1, 5)
		return "2"..luck
	end
end

function Weapons:GetDigit2(propensity, rarityFactor)
	if rarityFactor == 2 then
		if propensity < 0 then
			return 1
		elseif propensity == 0 then
			return 2
		else
			return 3
		end
	end
	if rarityFactor == 3 then
		if propensity <= -2 then
			return 1
		elseif propensity <= -1 then
			return 2
		elseif propensity <= 0 then
			return 3
		else
			return 4
		end
	end
	if rarityFactor == 4 then
		if propensity <= -2 then
			return 1
		elseif propensity <= -1 then
			return 2
		elseif propensity <= 0 then
			return 3
		elseif propensity <= 1 then
			return 4
		else
			return 5
		end
	end
end

function Weapons:GetDeviation(baseValue, rarityFactor)
	local RNG = RandomInt(1, 100)
	local baseAdjustment = RandomInt(1, 5)
	if rarityFactor == 2 then
		baseValue = math.ceil(baseValue * (1.34 + (baseAdjustment / 10)))
	elseif rarityFactor == 3 then
		baseValue = math.ceil(baseValue * (1.12 + (baseAdjustment / 12)))
	elseif rarityFactor == 4 then
		baseValue = math.ceil(baseValue * (1.04 + (baseAdjustment / 20)))
	end
	if RNG < 10 then
		baseValue = math.ceil(baseValue * 0.75)
	elseif RNG < 20 then
		baseValue = math.ceil(baseValue * 0.8)
	elseif RNG < 30 then
		baseValue = math.ceil(baseValue * 0.85)
	elseif RNG < 40 then
		baseValue = math.ceil(baseValue * 0.9)
	elseif RNG < 50 then
		baseValue = math.ceil(baseValue * 1.0)
	elseif RNG < 60 then
		baseValue = math.ceil(baseValue * 1.05)
	elseif RNG < 70 then
		baseValue = math.ceil(baseValue * 1.1)
	elseif RNG < 80 then
		baseValue = math.ceil(baseValue * 1.15)
	elseif RNG < 85 then
		baseValue = math.ceil(baseValue * 1.2)
	elseif RNG < 91 then
		baseValue = math.ceil(baseValue * 1.22)
	elseif RNG < 96 then
		baseValue = math.ceil(baseValue * 1.32)
	elseif RNG <= 100 then
		baseValue = math.ceil(baseValue * 1.4)
	end
	local finalRoll = RandomInt(1, 5)
	if finalRoll == 1 then
		baseValue = math.ceil(baseValue * 0.9)
	elseif finalRoll == 5 then
		baseValue = math.ceil(baseValue * 1.1)
	end
	return baseValue
end

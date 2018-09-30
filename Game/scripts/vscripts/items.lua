if RPCItems == nil then
  RPCItems = class({})
end
-- Test

RPCItems.DROP_LOCATION = Vector(-8000,2000)

require('items/RPCblaster')
require('items/RPChood')
require('items/head')
require('items/RPCglove')
require('items/hand')
require('items/RPCboot')
require('items/foot')
require('items/RPCbody')
require('items/body')
require('items/RPCamulet')
require('items/amulet')
require('items/legendaries')
require('items/filters')
require('items/weapons')
require('items/weapon_modifiers')
require('heroes/heros_custom')
require('items/trades')
require('items/arcanas')
require('items/synthesis')
require('curator')

function RPCItems:RollDrops(unit, killer)
	local deathLocation = unit:GetAbsOrigin()
	local xpBounty = unit:GetDeathXP()
	local luck = RPCItems:RNG(xpBounty)
	if unit.dropLevel then
		unitLevel = unit.dropLevel
	else
		unitLevel = 0
	end
	if luck < 7+RPCItems:GetConnectedPlayerCount()*2 then
		Weapons:RollWeapon(deathLocation)
		return
	end
	if luck > 505 then
		RPCItems:RollItemtype(xpBounty, deathLocation, 0, unitLevel)
	else
		return
	end

end 

function RPCItems:RNG(xpBounty)
	local luckAdjustment = (RPCItems:GetConnectedPlayerCount()-1)*4
	local luck = RandomInt(0, 530+luckAdjustment)
	return luck
end

function RPCItems:GetSpecialRarity()
	luck = RandomInt(0,100)
	local immortalThreshold = 94-GameState:GetPlayerPremiumStatusCount()
	if luck < 60 then
		return "rare"
	elseif luck < immortalThreshold then
		return "mythical"
	else
		return "immortal"
	end
end

function RPCItems:RollItemtype(xpBounty, deathLocation, rarityValue, unitLevel)
	local luck = 0
	local rarity = 0
		if rarityValue == 1 then
			rarity = RPCItems:GetSpecialRarity()
		elseif rarityValue == 5 then
			rarity = "immortal"
		else
			rarity = RPCItems:RollRarity(xpBounty)
		end

	if rarity == "immortal" then
		luck = RandomInt(200, 500)
	else
		luck = RandomInt(0, 500)
	end
	local weaponRoll = RandomInt(1, 20)
	local weaponRoll2 = RandomInt(1, 25)
	if weaponRoll2 == 25 then
		Weapons:RollWeapon(deathLocation)
		return
	elseif weaponRoll == 1 then
		local chanceImprover = 0
		if rarityValue == 4 then
			chanceImprover = 1
		elseif rarityValue == 5 then
			chanceImprover = 2
		end
		local luck2 = RandomInt(1, 1900-(GameState:GetDifficultyFactor()*500)-(chanceImprover*100))
		if luck2 == 1 then
			RPCItems:RollReanimationStone(deathLocation)
			return
		end
	elseif weaponRoll == 2 then
		local chanceImprover = 0
		if rarityValue == 4 then
			chanceImprover = 1
		elseif rarityValue == 5 then
			chanceImprover = 2
		end
		local luck2 = RandomInt(1, 239-(chanceImprover*100))
		if luck2 == 1 then
			local luck3 = RandomInt(1,100)
			if luck3 <= 35 then
				Glyphs:RollRandomGlyphBook(deathLocation)
				return
			else
				Glyphs:RollRandomGlyph(deathLocation)
				return
			end
		end
	elseif weaponRoll == 3 then
		local chanceImprover = 0
		if rarityValue == 4 then
			chanceImprover = 1
		elseif rarityValue == 5 then
			chanceImprover = 2
		end
		local luck2 = RandomInt(1, 240-(chanceImprover*100))
		if luck2 == 1 then
			local luck3 = RandomInt(1, 1000-GameState:GetPlayerPremiumStatusCount()*50)
			if luck3 == 1 then
				RPCItems:RollRandomArcanaCachePart(deathLocation)
			end
		end
	end
	if luck >= 200 then
		if rarity == "common" or rarity =="uncommon" or rarity == "rare" or rarity == "mythical" then
			local luck3 = RandomInt(1,6)
			if luck3 <= 4 then
				return
			end
		end
	end
	if GameMode.VoteSystem.junk_loot_disabled and (rarity == "common" or rarity =="uncommon" or rarity == "rare" or rarity == "mythical") and luck >= 200 then
		-- print("junk_loot_disabled other rarity: "..rarity)
		return
	end
	if luck > 0 and luck < 200 then
		RPCItems:RollBasicPotion(xpBounty+50, deathLocation, rarity, unitLevel)
	elseif luck >= 200 and luck < 265 then
		RPCItems:RollHood(xpBounty, deathLocation, rarity, false, 0, nil, unitLevel)
	elseif luck >= 265 and luck < 330 then
		RPCItems:RollHand(xpBounty, deathLocation, rarity, false, 0, nil, unitLevel)
	elseif luck >= 330 and luck < 395 then
		RPCItems:RollFoot(xpBounty, deathLocation, rarity, false, 0, nil, unitLevel)
	elseif luck >= 395 and luck < 460 then
		RPCItems:RollBody(xpBounty, deathLocation, rarity, false, 0, nil, unitLevel)
	elseif luck <= 500 then
		RPCItems:RollAmulet(xpBounty, deathLocation, rarity, false, 0, nil, unitLevel)
	end
end


function RPCItems:RollGold(xpBounty, deathLocation)
	Timers:CreateTimer(1, 
		function()
		item = CreateItem("item_bag_of_gold", nil, nil)
    	local drop = CreateItemOnPositionSync( deathLocation, item )
    	local position = deathLocation
    	item.rarity = "common"
    	RPCItems:DropGold(item, position)
    	local maxFactor = RPCItems:GetMaxFactor()
    	item.gold_amount = RandomInt(100, maxFactor*25) + RandomInt(0, 100)
    	-- DeepPrintTable(item)
    end)
end

function RPCItems:RollRarity(xpBounty)
	local luck = RandomInt(0, 100)
	local rarityBonus = 0
	if Events.SpiritRealm then
		rarityBonus = 2
	end
	local mythicalThreshold = 88-GameState:GetPlayerPremiumStatusCount()-rarityBonus
	local immortalThreshold = 99-GameState:GetPlayerPremiumStatusCount()-rarityBonus
	if luck < 30 then
		return "common"
	elseif luck >= 30 and luck < 60 then
		return "uncommon"
	elseif luck >= 60 and luck < mythicalThreshold then
		return "rare"
	elseif luck >= mythicalThreshold and luck < immortalThreshold then
		return "mythical"
	elseif luck >= immortalThreshold then
		return "immortal"
	end
end

-- function RPCItems:RollRarityNerfed(xpBounty)
-- 	local luck = RandomInt(0, 200)
-- 	local rarityBonus = 0
-- 	if Events.SpiritRealm then
-- 		rarityBonus = 2
-- 	end
-- 	local mythicalThreshold = 176-GameState:GetPlayerPremiumStatusCount()-rarityBonus
-- 	local immortalThreshold = 199-GameState:GetPlayerPremiumStatusCount()-rarityBonus
-- 	if luck < 60 then
-- 		return "common"
-- 	elseif luck >= 60 and luck < 120 then
-- 		return "uncommon"
-- 	elseif luck >= 120 and luck < mythicalThreshold then
-- 		return "rare"
-- 	elseif luck >= mythicalThreshold and luck < immortalThreshold then
-- 		return "mythical"
-- 	elseif luck >= immortalThreshold then
-- 		return "immortal"
-- 	end
-- end

BASE_POTION_TABLE = {"item_potion_green", "item_potion_blue", "item_potion_red"}

function RPCItems:RollBasicPotion(xpBounty, deathLocation, rarity, unitLevel)
	local potion_variant = BASE_POTION_TABLE[RandomInt(1, 3)]
    local item = CreateItem(potion_variant, nil, nil)
    item.rarity = rarity
    local rarityValue = RPCItems:GetRarityFactor(rarity)
    local itemName = "Potion"
    local drop = CreateItemOnPositionSync( deathLocation, item )
    local position = deathLocation
    local suffix = RPCItems:RollPotionProperty1(item, xpBounty)
    local prefix = ""
    item.slot = "consumable"
    if rarityValue >= 2 then
    	prefix = RPCItems:RollPotionProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollPotionProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	RPCItems:RollPotionProperty4(item, xpBounty)
    end

    RPCItems:SetTableValues(item, itemName, true, "Can be consumed for bonuses.", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    RPCItems:DropItem(item, position)
end

SUFFIX_HEAL_TABLE = {"of Healing", "of Restoration", "of Major Healing", "of Life", "of Great Restoration"}
SUFFIX_STRENGTH_TABLE = {"of Might", "of Strength", "of Major Strength", "of Great Power", "of the Colossus"}
SUFFIX_AGILITY_TABLE = {"of Skill", "of Mastery", "of Greater Mastery", "of Expert Craft", "of Master Cunning"}
SUFFIX_INTELLIGENCE_TABLE = {"of Understanding", "of the Wise", "of Greater Intelligence", "of Great Brilliance", "of The Grand Magus"}
SUFFIX_MANA_HEAL_TABLE = {"of Refreshment", "of Greater Refreshment", "of Replenishment", "of Greater Replenishment", "of Grand Replenishment"}
SUFFIX_EXP_TABLE = {"of Training", "of Greater Training", "of Adept Training", "of Expert Training", "of Master Training"}

function RPCItems:RollPotionProperty1(item, xpBounty)
	local luck = RandomInt(0,100)
	value, suffixLevel = RPCItems:RollAttribute(xpBounty, 200, 400, 3, 8, item.rarity, false, nil)
	item.property1 = value
	item.property1name = "heal"
	suffix = SUFFIX_HEAL_TABLE[suffixLevel]
	RPCItems:SetPropertyValues(item, item.property1, "item_health_restore", "#99FF66",  1)
	return suffix
end

function RPCItems:RollPotionProperty(item, xpBounty, property, propertyname, name_table)
end

PREFIX_HEAL_TABLE = {"Healing", "Recovery", "Life", "Tranquil", "Grand Life"}
PREFIX_STRENGTH_TABLE = {"Soldier's", "Warrior's", "Giant's", "Behemoth", "Titan's"}
PREFIX_AGILITY_TABLE = {"Scout's", "Hawk's", "Pathfinder's", "Tracker's", "Ninja"}
PREFIX_INTELLIGENCE_TABLE = {"Intelligence", "Sorcerer's", "Oracle's", "Wizard's", "Grand Far Seer's"}
PREFIX_MANA_HEAL_TABLE = {"Mana", "Greater Mana", "Soul", "Lunar", "Grand Arcane"}
PREFIX_EXP_TABLE = {"Squire's", "Adventurer's", "Quester's", "Explorer's", "Inquisitive"}

function RPCItems:RollPotionProperty2(item, xpBounty)
	local luck = RandomInt(0,100)
	local prefix=""
	if luck < 40 then
		value, prefixLevel = RPCItems:RollAttribute(xpBounty, 200, 400, 3, 8, item.rarity, false, nil)
		item.property2 = value
    	item.property2name = "heal"
    	prefix = PREFIX_HEAL_TABLE[prefixLevel]
    	RPCItems:SetPropertyValues(item, item.property2, "item_health_restore", "#99FF66",  2)
    elseif luck >= 40 and luck < 50 then
		value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 2, 0, 0, item.rarity, false, nil)
		item.property2 = value
    	item.property2name = "strength"
		prefix = PREFIX_STRENGTH_TABLE[prefixLevel]
		RPCItems:SetPropertyValues(item, item.property2, "item_perm_strength", "#CC0000",  2)
    elseif luck >= 50 and luck < 60 then
		value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 2, 0, 0, item.rarity, false, nil)
		item.property2 = value
    	item.property2name = "agility"
		prefix = PREFIX_AGILITY_TABLE[prefixLevel]
		RPCItems:SetPropertyValues(item, item.property2, "item_perm_agility", "#2EB82E",  2)
    elseif luck >= 60 and luck < 70 then
		value, prefixLevel = RPCItems:RollAttribute(xpBounty, 1, 2, 0, 0, item.rarity, false, nil)
		item.property2 = value
    	item.property2name = "intelligence"
		prefix = PREFIX_INTELLIGENCE_TABLE[prefixLevel]
		RPCItems:SetPropertyValues(item, item.property2, "item_perm_intelligence", "#33CCFF",  2)	
    elseif luck >= 70 and luck <= 100 then
		value, prefixLevel = RPCItems:RollAttribute(xpBounty, 50, 150, 2, 4, item.rarity, false, nil)
		item.property2 = value
    	item.property2name = "mana_heal"
		prefix = PREFIX_MANA_HEAL_TABLE[prefixLevel]
		RPCItems:SetPropertyValues(item, item.property2, "item_mana_restore", "#1975FF",  2)	
	else
		value, prefixLevel = RPCItems:RollAttribute(xpBounty, 7, 28, 1, 5, item.rarity, false, nil)
		item.property2 = value
    	item.property2name = "exp"
		prefix = PREFIX_EXP_TABLE[prefixLevel]
		RPCItems:SetPropertyValues(item, item.property2, "item_bonus_exp", "#E6B800",  2)	
	end
	return prefix


end

POTION_NAME_TABLE = {"Godly Potion", "Ultra Potion", "Divine Potion", "Mega Potion", "Super Potion"}

function RPCItems:RollPotionProperty3(item, xpBounty)
	luck = RandomInt(0,100)
	local name =""
	if luck < 20 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 100, 300, 3, 8, item.rarity, false, nil)
		item.property3 = value
    	item.property3name = "heal"
    	name = POTION_NAME_TABLE[nameLevel]
    	RPCItems:SetPropertyValues(item, item.property3, "item_health_restore", "#99FF66",  3)
    elseif luck >= 20 and luck < 35 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 3, 0, 0, item.rarity, false, nil)
		item.property3 = value
    	item.property3name = "strength"
		name = POTION_NAME_TABLE[nameLevel]
		RPCItems:SetPropertyValues(item, item.property3, "item_perm_strength", "#CC0000",  3)
    elseif luck >= 35 and luck < 50 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 3, 0, 0, item.rarity, false, nil)
		item.property3 = value
    	item.property3name = "agility"
		name = POTION_NAME_TABLE[nameLevel]
		RPCItems:SetPropertyValues(item, item.property3, "item_perm_agility", "#2EB82E",  3)
    elseif luck >= 50 and luck < 65 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 3, 0, 0, item.rarity, false, nil)
		item.property3 = value
    	item.property3name = "intelligence"
		name = POTION_NAME_TABLE[nameLevel]
		RPCItems:SetPropertyValues(item, item.property3, "item_perm_intelligence", "#33CCFF",  3)	
    elseif luck >= 65 and luck <= 100 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 50, 150, 2, 4, item.rarity, false, nil)
		item.property3 = value
    	item.property3name = "mana_heal"
		name = POTION_NAME_TABLE[nameLevel]
		RPCItems:SetPropertyValues(item, item.property3, "item_mana_restore", "#1975FF",  3)	
	else
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 7, 30, 4, 8, item.rarity, false, nil)
		item.property3 = value
    	item.property3name = "exp"
		name = POTION_NAME_TABLE[prefixLevel]
		RPCItems:SetPropertyValues(item, item.property3, "item_bonus_exp", "#E6B800",  3)	
	end
	return name
end

POTION_NAME_TABLE2 = {"Godly Elixir", "Ultra Elixir", "Divine Elixir", "Mega Elixir", "Super Elixir"}

function RPCItems:RollPotionProperty4(item, xpBounty)
	luck = RandomInt(0,100)
	if luck < 20 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 100, 300, 3, 8, item.rarity, false, nil)
		item.property4 = value
    	item.property4name = "heal"
    	local name = POTION_NAME_TABLE2[nameLevel]
    	RPCItems:SetPropertyValues(item, item.property4, "item_health_restore", "#99FF66",  4)
    elseif luck >= 20 and luck < 35 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 4, 0, 0, item.rarity, false, nil)
		item.property4 = value
    	item.property4name = "strength"
		local name = POTION_NAME_TABLE2[nameLevel]
		RPCItems:SetPropertyValues(item, item.property4, "item_perm_strength", "#CC0000",  4)
    elseif luck >= 35 and luck < 50 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 4, 0, 0, item.rarity, false, nil)
		item.property4 = value
    	item.property4name = "agility"
		local name = POTION_NAME_TABLE2[nameLevel]
		RPCItems:SetPropertyValues(item, item.property4, "item_perm_agility", "#2EB82E",  4)
    elseif luck >= 50 and luck < 65 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 1, 4, 0, 0, item.rarity, false, nil)
		item.property4 = value
    	item.property4name = "intelligence"
		local name = POTION_NAME_TABLE2[nameLevel]
		RPCItems:SetPropertyValues(item, item.property4, "item_perm_intelligence", "#33CCFF",  4)	
    elseif luck >= 65 and luck <= 100 then
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 50, 150, 2, 4, item.rarity, false, nil)
		item.property4 = value
    	item.property4name = "mana_heal"
		local name = POTION_NAME_TABLE2[nameLevel]
		RPCItems:SetPropertyValues(item, item.property4, "item_mana_restore", "#1975FF",  4)	
	else
		value, nameLevel = RPCItems:RollAttribute(xpBounty, 10, 30, 5, 10, item.rarity, false, nil)
		item.property4 = value
    	item.property4name = "exp"
		local name = POTION_NAME_TABLE2[prefixLevel]
		RPCItems:SetPropertyValues(item, item.property4, "item_bonus_exp", "#E6B800",  4)	
	end
	return name


end

function RPCItems:RollAttribute(xpBounty, minBase, maxBase, bountyFactorMin, bountyFactorMax, itemRarity, isFloat, maximumValue)
	local rarityFactor = RPCItems:GetRarityFactor(itemRarity)
	local waveFactor = math.floor(RPCItems:GetMaxFactor()/4)
	local suffixLevel = 0
	local value = 0
	local maxFactor = RPCItems:GetMaxFactor()
	local minMultiplier = math.max(math.floor(maxFactor/5),1)
	if GameState:GetDifficultyFactor() == 2 then
		minBase = math.max(minBase*1.2, math.floor(maxBase/2.1))
	elseif GameState:GetDifficultyFactor() == 1 then
		minBase = math.max(minBase*1.2, math.floor(maxBase/2.1))
	else
		minBase = math.max(minBase*1.2, math.floor(maxBase/2.1))
	end
	if Events.reroll then
	else
		if Events.MapName == "rpc_sea_fortress" then
			minBase = minBase*1.8
		end
	end

	minBase = math.floor(minBase)
	if Dungeons.phoenixWave then
		if Dungeons.phoenixWave > 10 then
			minMultiplier = math.floor(math.min(minMultiplier+(Dungeons.phoenixWave-10)/2), maxFactor/3)
			if Dungeons.phoenixWave > 50 then
				minMultiplier = math.floor(math.min(minMultiplier+(Dungeons.phoenixWave-10)/2), maxFactor/2)
				minBase = math.max(minBase, math.floor(maxBase/1.6))
			end
		end
	end

	if waveFactor < 1 then
		waveFactor = 1
	end
	if Dungeons.itemLevel > 0 then
		waveFactor = RPCItems:GetMaxFactor()/4
	end
	if minBase <= 1 then
		minBase = 1
	end
	local luck = RandomInt(1,100)
	local divisor = 1
	if luck < 60 then
		value = RandomInt(minBase, maxBase)*RandomInt(minMultiplier, (rarityFactor+waveFactor)/divisor) + round(xpBounty/4, 0)*RandomInt(bountyFactorMin, bountyFactorMax)
		suffixLevel = 1
	elseif luck >= 60 and luck < 80 then
		value = RandomInt(minBase*2, maxBase*2)*RandomInt(minMultiplier, (rarityFactor+waveFactor)/divisor) + round(xpBounty/4, 0)*RandomInt(bountyFactorMin, bountyFactorMax*2)
		suffixLevel = 2
	elseif luck >= 80 and luck < 92 then
		value = RandomInt(minBase*2, maxBase*3)*RandomInt(minMultiplier, (rarityFactor+waveFactor)/divisor) + round(xpBounty/4, 0)*RandomInt(bountyFactorMin*2, bountyFactorMax*3)
		suffixLevel = 3
	elseif luck >= 92 and luck < 98 then
		value = RandomInt(minBase*2, maxBase*4)*RandomInt(minMultiplier, (rarityFactor+waveFactor)/divisor) + round(xpBounty/4, 0)*RandomInt(bountyFactorMin*3, bountyFactorMax*4)
		suffixLevel = 4
	elseif luck >= 98 then
		value = RandomInt(minBase*3, maxBase*5)*RandomInt(minMultiplier, (rarityFactor+waveFactor)/divisor) + round(xpBounty/4, 0)*RandomInt(bountyFactorMin*4, bountyFactorMax*5)
		suffixLevel = 5
	end
	if value <= 0 then
		value = RandomInt(1, maxBase*3)*RandomInt(minMultiplier, rarityFactor+waveFactor) 
		suffixLevel = RandomInt(1, 3)
	end
	if value <= 0 then
		value = 1
	end
	if maximumValue then
		if value > maximumValue then
			value = maximumValue
		end
	end
	if isFloat then
		if luck < 50 then
			value = RandomInt(10, 30)/10
		elseif luck < 80 then
			value = RandomInt(10, 60)/10
		else
			value = RandomInt(30, 80)/10
		end
		value = round(value, 0)
	end
	print("value: "..value)
	print(value)
	return value, suffixLevel
end

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

GLOBAL_ITEM_TABLE = {}

function RPCItems:ClearItems()
	local i = 1
    for k,item in pairs(GLOBAL_ITEM_TABLE) do
        if item and not item:IsNull() then
        	if item.expiryTime then
        		if Time() > item.expiryTime then
					local container = item:GetContainer()
					if container then
						UTIL_Remove(container)
					end
					if IsValidEntity(item) then
						if item.arcanaDummy then
							UTIL_Remove(item.arcanaDummy)
						end
						UTIL_Remove(item)
					end
            	end
            end
        end
        i = i+1
    end
    local newGlobalTable = {}
    for j = 1, #GLOBAL_ITEM_TABLE, 1 do
    	if IsValidEntity(GLOBAL_ITEM_TABLE[j]) then
    		if GLOBAL_ITEM_TABLE[j].expiryTime then
    			table.insert(newGlobalTable, GLOBAL_ITEM_TABLE[j])
    		end
    	end
    end
    GLOBAL_ITEM_TABLE = newGlobalTable
	-- for j = 0, #GLOBAL_ITEM_TABLE, 1 do
	-- 	local i = 0
	-- 	for _,item in pairs(GLOBAL_ITEM_TABLE) do
	-- 		i = i+1
	-- 		if item then
	-- 			if item.expiryTime then
	-- 				if Time() > item.expiryTime then
	-- 					local container = item:GetContainer()
	-- 					if container then
	-- 						UTIL_Remove(container)
	-- 					end
	-- 					if item then
	-- 						UTIL_Remove(item)
	-- 					end
	-- 					table.remove(GLOBAL_ITEM_TABLE, i)
	-- 					break

	-- 				end
	-- 			end
	-- 		end
	-- 	end

	-- end
	-- local numItems = GameRules:NumDroppedItems()
	-- for j = 1, numItems, 1 do
	-- 	local item = GameRules:GetDroppedItem(j)
	-- 		if item.expiryTime then
	-- 			if Time() > item.expiryTime then
	-- 				local container = item:GetContainer()
	-- 				UTIL_Remove(container)
	-- 				UTIL_Remove(item)
	-- 			end
	-- 		end
	-- end
end

function RPCItems:DropGold(item, position)
	if Dungeons.lootLaunch then
		position = GetGroundPosition(Dungeons.lootLaunch + RandomVector(RandomInt(10, 120)), nil)
	elseif Dungeons.entryPoint then
		position = GetGroundPosition(position+RandomVector(RandomInt(50, 160)), nil)
	else
		position = GetGroundPosition(position+RandomVector(RandomInt(50, 160)), nil)
	end
	item.expiryTime = Time() + RPCItems:GetExpiryTime(item)
	 table.insert(GLOBAL_ITEM_TABLE, item)
	 
	 if Dungeons.lootLaunch then
	 	item:LaunchLoot(true, RandomInt(100,300), 0.75, position)
	 else
	 	item:LaunchLoot(true, RandomInt(100,600), 0.75, position)
	 end

end

function RPCItems:GetExpiryTime(item)
	local rarity = item.rarity
	local baseExpiryTime = 60
	local aLotExpiryTime = 999999
	if item.slot and item.slot == "glyph_book" then
		baseExpiryTime = aLotExpiryTime
	end
	if item:GetAbilityName() == "item_redfall_glowing_redfall_leaf" then
		baseExpiryTime = aLotExpiryTime
	end
	if rarity == "common" or rarity == "uncommon" then
		return baseExpiryTime + 0
	elseif rarity == "rare" then
		return baseExpiryTime + 20
	elseif rarity == "mythical" then
		return baseExpiryTime + 60
	elseif rarity == "immortal" then
		return baseExpiryTime + 140
	elseif rarity == "arcana" then
		return baseExpiryTime + aLotExpiryTime
	else
		return baseExpiryTime + 140
	end
end


function RPCItems:DropItem(item, position)
    local basePosition = position
	if Dungeons.lootLaunch then
		position = GetGroundPosition(Dungeons.lootLaunch + RandomVector(RandomInt(10, 120)), nil)
	elseif Dungeons.entryPoint then
		position = GetGroundPosition(position+RandomVector(RandomInt(100, 220)), nil)
	else
		position = GetGroundPosition(position+RandomVector(RandomInt(100, 260)), nil)
    end
    position =  WallPhysics:WallSearch(basePosition, position, Events.SafeItemEntity)
	FindClearSpaceForUnit(Events.SafeItemEntity, position, false)
	position = Events.SafeItemEntity:GetAbsOrigin()
	if determineIfOKdrop(item) then
		local rarityFactor = RPCItems:GetRarityFactor(item.rarity)
		item.expiryTime = Time() + RPCItems:GetExpiryTime(item)
		if rarityFactor > 2 then
			Timers:CreateTimer(0.5, function()
				if IsValidEntity(item) then
					if IsValidEntity(item:GetContainer()) then
						local particleName = RPCItems:GetRarityParticle(item.rarity)
						item.particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, item )
						ParticleManager:SetParticleControl( item.particle, 0, position )
						if item.rarity == "arcana" then
							item.particle2 = ParticleManager:CreateParticle( "particles/roshpit/items/arcana_beam.vpcf", PATTACH_CUSTOMORIGIN, item )
							ParticleManager:SetParticleControl( item.particle2, 0, position-Vector(0,0,40) )
							ParticleManager:SetParticleControl( item.particle2, 1, position-Vector(0,0,40) )

							EmitSoundOnLocationWithCaster(position, "RPC.Arcana.Drop", Events.GameMaster)
							local arcana_dummy = CreateUnitByName("arcana_find_unit", position, false, nil, nil, 2)
							item.arcanaDummy = arcana_dummy
							arcana_dummy:FindAbilityByName("arcana_find_ability"):SetLevel(1)

							Timers:CreateTimer(0.3, function()
								local pfx = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
								ParticleManager:SetParticleControl(pfx, 0, position)
								ParticleManager:SetParticleControl(pfx, 1, Vector(200, 2, 200))
								Timers:CreateTimer(2, function()
									ParticleManager:DestroyParticle(pfx, false)
								end)
							end)
						end
					end
				end
			end)
		end

		 table.insert(GLOBAL_ITEM_TABLE, item)
		 
		 if Dungeons.lootLaunch then
		 	item:LaunchLoot(false, RandomInt(100,300), 0.75, position)
		 else
		 	item:LaunchLoot(false, RandomInt(100,600), 0.75, position)
		 end
	else
		UTIL_Remove(item:GetContainer())
		UTIL_Remove(item)
	end

end

-- function ShouldDropItem(item)
-- 	if GameMode.VoteSystem.junk_loot_disabled and RPCItems:GetRarityFactor(item.rarity) < 5 and item.slot 
-- 		and (item.slot == "weapon" or item.slot == "feet" or item.slot == "head" or item.slot == "hands" or item.slot == "body" or item.slot == "amulet") then
-- 		return false
-- 	end
-- 	return true
-- end

function determineIfOKdrop(item)
		local affixCount = RPCItems:GetRarityFactor(item.rarity)
		if affixCount > 4 then
			affixCount = 4
		end
		if item.gear then
			for i = 1, affixCount, 1 do
				local affixTable = CustomNetTables:GetTableValue("item_properties", tostring(item:GetEntityIndex()).."-"..tostring(i))
				DeepPrintTable(affixTable)
				local property = 0
				local propertyName = ""
				if i == 1 then
					property = item.property1
					propertyName = item.property1name
				elseif i == 2 then
					property = item.property2
					propertyName = item.property2name
				elseif i == 3 then
					property = item.property3
					propertyName = item.property3name
				elseif i == 4 then
					property = item.property4
					propertyName = item.property4name
				end
				if not affixTable then
					return false
				end
				if not property then
					return false
				end
				if not propertyName then
					return false
				end
			end
			return true
		else
			return true
		end
end

function RPCItems:SetTableValues(item, itemName, consumableBoolean, description, qualityColor, qualityName, prefix, suffix, rarityFactor)
	if prefix == "" then
	else
		if prefix then
			prefix = prefix.." "
		end
	end
	if suffix == "" then
	else
		if suffix then
			suffix = " "..suffix
		end
	end
	local minLevel = 0
	if item.slot == "weapon" then
		if not item.minLevel then
			if rarityFactor < 5 then
				minLevel = 0
			else
				minLevel = 100
				item.minLevel = minLevel
			end
		end
	end 
	if item.minLevel then
	else
		minLevel = RPCItems:GetMinLevel()
		item.minLevel = minLevel
	end
	

	print("MIN LEVEL BEFORE ADJUST"..item.minLevel)
	-- 
	-- print("MIN LEVEL AFTER ADJUST"..item.minLevel)
	if item.requiredHero then
		CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemName, consumable = consumableBoolean, itemDescription = description, qualityColor = qualityColor, qualityName = qualityName, itemPrefix = prefix, itemSuffix = suffix, rarityFactor = rarityFactor, minLevel = item.minLevel, requiredHero = item.requiredHero } )
	else
		CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemName, consumable = consumableBoolean, itemDescription = description, qualityColor = qualityColor, qualityName = qualityName, itemPrefix = prefix, itemSuffix = suffix, rarityFactor = rarityFactor, minLevel = item.minLevel } )
	end
	local key = RPCItems:GetRandomKey(13)
	CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()).."-key", {key = key} )
end

function RPCItems:GetRandomKey(length)
	str = string.gsub(GetSystemDate(), "/", "_").."_"..string.gsub(GetSystemTime(), ":", "_").."_";

	for i = 1, length do
		str = str .. string.char( RandomInt(97,122) );
	end
	
	return str;

end

function RPCItems:ReduceLevelRequirement(item)
	if item.noMin then
		return false
	end
	local minLevel = item.minLevel
	minLevel = math.max(minLevel, 1)
	local reductionSum = 0
	if item.property1name == "level_reduce" then
		minLevel = minLevel - item.property1
		reductionSum = reductionSum + item.property1
	end
	if item.property2name == "level_reduce" then
		minLevel = minLevel - item.property2
		reductionSum = reductionSum + item.property2
	end
	if item.property3name == "level_reduce" then
		minLevel = minLevel - item.property3
		reductionSum = reductionSum + item.property3
	end
	if item.property4name == "level_reduce" then
		minLevel = minLevel - item.property4
		reductionSum = reductionSum + item.property4
	end
	if IsValidEntity(item) then
		CustomNetTables:SetTableValue( "min_level_reduction", tostring(item:GetEntityIndex()), {levelReduce = reductionSum} )
		item.minLevel = minLevel
	end
end

function RPCItems:GetMinLevel()
	local maxFactor = RPCItems:GetMaxFactor()
	local minLevel = maxFactor/3
	local luck = RandomInt(1, 5)
	local randomPercentage = 0
	if luck == 1 then
		randomPercentage = RandomInt(-10, 5)
	elseif luck == 5 then
		randomPercentage = RandomInt(-10, 10)
	else
		randomPercentage = RandomInt(-5, 5)
	end
	if GameState:IsSeaFortress() then
		minLevel = math.max(minLevel, 75)
	end
	randomPercentage = randomPercentage/100
	minLevel = math.ceil(minLevel*(1+randomPercentage))
	if minLevel > 75 then
		minLevel = minLevel - 7 - math.floor(maxFactor/90)*RandomInt(1, 5)
	end
	minLevel = math.min(minLevel, 100)
	return minLevel
end

function RPCItems:SetPropertyValues(item, propertyValue, propertyName, propertyColor, propertyNumber)
	-- print('-----property-adding-to-table-----')
	-- print(item)
	-- print(propertyValue) 
	-- print(propertyName)
	-- print(propertyColor)
	-- print(propertyNumber)
	-- print('-----end-----')
	CustomNetTables:SetTableValue( "item_properties", tostring(item:GetEntityIndex()).."-"..tostring(propertyNumber), {propertyValue = propertyValue, propertyName = propertyName, propertyColor = propertyColor })
end

function RPCItems:SetPropertyValuesSpecial(item, propertyValue, propertyName, propertyColor, propertyNumber, specialDescription)
	-- print('-----property-adding-to-table-----')
	-- print(item)
	-- print(propertyValue) 
	-- print(propertyName)
	-- print(propertyColor)
	-- print(propertyNumber)
	-- print('-----end-----')
	CustomNetTables:SetTableValue( "item_properties", tostring(item:GetEntityIndex()).."-"..tostring(propertyNumber), {propertyValue = propertyValue, propertyName = propertyName, propertyColor = propertyColor, specialDescription = specialDescription, specialValue = specialValue })
end



function RPCItems:GetRarityColor(rarityName)
	local color = ""
	if rarityName == "common" then
		color = "#B0C3D9"
	elseif rarityName == "uncommon" then
		color = "#99FF33"
	elseif rarityName == "rare" then
		color = "#4B69FF"
	elseif rarityName == "mythical" then
		color = "#8847FF"
	elseif rarityName == "immortal" then
		color = "#E4AE33"
	elseif rarityName == "arcana" then
		color = "#ADE55C"
	end
	return color
end

function RPCItems:GetRarityFactor(rarityName)
	local factor = 0
	if rarityName == "common" then
		factor = 1
	elseif rarityName == "uncommon" then
		factor = 2
	elseif rarityName == "rare" then
		factor = 3
	elseif rarityName == "mythical" then
		factor = 4
	elseif rarityName == "immortal" then
		factor = 5
	elseif rarityName == "arcana" then
		factor = 6
	end
	return factor
end

function RPCItems:GetRarityNameFromFactor(rarityFactor)
	local rarity = ""
	if rarityFactor == 1 then
		rarity = "common"
	elseif rarityFactor == 2 then
		rarity = "uncommon"
	elseif rarityFactor == 3 then
		rarity = "rare"
	elseif rarityFactor == 4 then
		rarity = "mythical"
	elseif rarityFactor == 5 then
		rarity = "immortal"
	elseif rarityFactor == 6 then
		rarity = "arcana"
	end
	return rarity
end

function RPCItems:GetRarityParticle(rarityName)
	local color = ""
	if rarityName == "common" then
		return "particles/units/heroes/hero_silencer/itemdropcommon.vpcf"
	elseif rarityName == "uncommon" then
		return "particles/units/heroes/hero_silencer/itemdropmythical.vpcf"
	elseif rarityName == "rare" then
		return "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"
	elseif rarityName == "mythical" then
		color = "particles/units/heroes/hero_silencer/itemdroprare.vpcf"
	elseif rarityName == "immortal" then
		color = "particles/units/heroes/hero_silencer/itemdropimmortal.vpcf"
	elseif rarityName == "arcana" then
		color = "particles/units/heroes/hero_silencer/itemdropmythical.vpcf"
	end
	return color
end

function RPCItems:GearPickup(heroEntity, itemEntity)
	local player = heroEntity:GetPlayerOwner()
	local slot = RPCItems:getGearSlot(itemEntity.slot)
	local oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(slot))
	local oldGear = false
	if oldGearTable then
		if oldGearTable.itemIndex == -1 then
			oldGear = false
		else
			oldGear = EntIndexToHScript(oldGearTable.itemIndex)
		end
	end
	if oldGear then
		print("OLD GEAR DETECTED")
		heroEntity:TakeItem(itemEntity)
  		if IsValidEntity(itemEntity:GetContainer()) then
  			UTIL_Remove(itemEntity:GetContainer())
  		end
  		CustomGameEventManager:Send_ServerToPlayer(player, "close_blacksmith", {})
  		CustomGameEventManager:Send_ServerToPlayer(player, "new_item_with_slot", {newItem=itemEntity:GetEntityIndex(), oldItem=oldGear:GetEntityIndex()} )
		Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_equip_ui_open", {})
	else
		local playerID = heroEntity:GetPlayerID()
		local heroId = heroEntity:GetClassname()
		-- CustomGameEventManager:Send_ServerToPlayer(player, "InitializeEquipment", {item=itemEntity:GetEntityIndex()} )
  		heroEntity:TakeItem(itemEntity)
  		if IsValidEntity(itemEntity:GetContainer()) then
  			UTIL_Remove(itemEntity:GetContainer())
  		end
  		CustomNetTables:SetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(slot), {itemIndex = itemEntity:GetEntityIndex()} )
 		local hero = heroEntity
 		local inventory_unit = heroEntity.InventoryUnit
		RPCItems:EquipItem(slot, hero, inventory_unit, itemEntity)
		CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemEntity:GetEntityIndex(), heroId=heroId, playerId=playerID, pickup="equip"} )
        EmitGlobalSound("RPC.EquipItem")
        CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_inventory", {})
	    if slot == 1 then
	    	hero.weapon = itemEntity
	    	Weapons:SetWeaponTable(itemEntity)
	    	CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), {xp = itemEntity.xp, level = itemEntity.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[itemEntity.level], maxLevel = itemEntity.maxLevel, requiredHero = itemEntity.requiredHero} )
	    end
        print(slot)
	end
	Statistics.dispatch('items:equip')
end

function RPCItems:EquipItem(slot, hero, inventory_unit, itemEntity)
	Weapons:ValidateGear(hero)
	if slot == 0 then
		Head:remove_modifiers(hero)
	 	Timers:CreateTimer(0.2, 
	 	function()
			Head:add_modifiers(hero, inventory_unit, itemEntity)
		end)
	end
	if slot == 1 then
		Weaponmodifiers:remove_modifiers(hero)
	 	Timers:CreateTimer(0.2, 
	 	function()
			Weaponmodifiers:add_modifiers(hero, inventory_unit, itemEntity)
		end)
	end
	if slot == 2 then
		Hand:remove_modifiers(hero)
	 	Timers:CreateTimer(0.2, 
	 	function()
			Hand:add_modifiers(hero, inventory_unit, itemEntity)
		end)
	end
	if slot == 3 then
		Foot:remove_modifiers(hero)
	 	Timers:CreateTimer(0.2, 
	 	function()
			Foot:add_modifiers(hero, inventory_unit, itemEntity)
		end)
	end
	if slot == 4 then
		Body:remove_modifiers(hero)
	 	Timers:CreateTimer(0.2, 
	 	function()
			Body:add_modifiers(hero, inventory_unit, itemEntity)
		end)
	end
	if slot == 5 then
		Amulet:remove_modifiers(hero)
	 	Timers:CreateTimer(0.2, 
	 	function()
			Amulet:add_modifiers(hero, inventory_unit, itemEntity)
		end)
	end
	Timers:CreateTimer(1.5, function()
		CustomGameEventManager:Send_ServerToAllClients("update_runes", {})
	end)
end

function RPCItems:RemoveItemStats(slot, hero)
	if slot == 0 then
		Head:remove_modifiers(hero)
	end
	if slot == 1 then
		Weaponmodifiers:remove_modifiers(hero)
	end
	if slot == 2 then
		Hand:remove_modifiers(hero)
	end
	if slot == 3 then
		Foot:remove_modifiers(hero)
	end
	if slot == 4 then
		Body:remove_modifiers(hero)
	end
	if slot == 5 then
		Amulet:remove_modifiers(hero)
	end
	Timers:CreateTimer(1.5, function()
		CustomGameEventManager:Send_ServerToAllClients("update_runes", {})
	end)
end

function RPCItems:EquipAllRespawn(player)
	local hero, inventory_unit = RPCItems:GetHeroAndInventoryByID(player:GetPlayerID())
	Head:remove_modifiers(hero)
	Hand:remove_modifiers(hero)
	Foot:remove_modifiers(hero)
	Body:remove_modifiers(hero)
	Amulet:remove_modifiers(hero)
	local oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(0))
	local oldGear = false
	local itemEntity = false
	if oldGearTable then
		oldGear = EntIndexToHScript(oldGearTable.itemIndex)
		itemEntity = EntIndexToHScript(oldGear)
	end
	if itemEntity then
		Head:add_modifiers(hero, inventory_unit, itemEntity)
	end
	oldGearTable = false
	oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(1))
	oldGear = false
	local itemEntity = false
	if oldGearTable then
		oldGear = EntIndexToHScript(oldGearTable.itemIndex)
		itemEntity = EntIndexToHScript(oldGear)
	end
	if itemEntity then
		Hand:add_modifiers(hero, inventory_unit, itemEntity)
	end
	oldGearTable = false
	oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(2))
	oldGear = false
	local itemEntity = false
	if oldGearTable then
		oldGear = EntIndexToHScript(oldGearTable.itemIndex)
		itemEntity = EntIndexToHScript(oldGear)
	end
	if itemEntity then
		Foot:add_modifiers(hero, inventory_unit, itemEntity)
	end
	oldGearTable = false
	oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(3))
	oldGear = false
	local itemEntity = false
	if oldGearTable then
		oldGear = EntIndexToHScript(oldGearTable.itemIndex)
		itemEntity = EntIndexToHScript(oldGear)
	end
	if itemEntity then
		Body:add_modifiers(hero, inventory_unit, itemEntity)
	end
end

function RPCItems:FindPickupSlot(itemEntity, inventory_unit)
	local gear0 = inventory_unit:GetItemInSlot(0)
	local gear1 = inventory_unit:GetItemInSlot(1)
	local gear2 = inventory_unit:GetItemInSlot(2)
	local gear3 = inventory_unit:GetItemInSlot(3)
	local gear4 = inventory_unit:GetItemInSlot(4)
	local gear5 = inventory_unit:GetItemInSlot(5)
	if gear0 == itemEntity then
		return 0
	elseif gear1 == itemEntity then
		return 1
	elseif gear2 == itemEntity then
		return 2
	elseif gear3 == itemEntity then
		return 3
	elseif gear4 == itemEntity then
		return 4
	elseif gear5 == itemEntity then
		return 5
	end
end

function RPCItems:getGearSlot(gearType)
	if gearType == "head" then
		return 0
	elseif gearType == "weapon" then
		return 1
	elseif gearType == "hands" then
		return 2
	elseif gearType == "feet" then
		return 3
	elseif gearType == "body" then
		return 4
	elseif gearType == "amulet" then
		return 5
	else
		return -1
	end
end

function RPCItems:GetGearSlotName(gearSlot)
	local slotName = ""
	if gearSlot == 0 then
		slotName = "head"
	elseif gearSlot == 1 then
		slotName = "weapon"
	elseif gearSlot == 2 then
		slotName = "hands"
	elseif gearSlot == 3 then
		slotName = "feet"
	elseif gearSlot == 4 then
		slotName = "body"
	elseif gearSlot == 5 then
		slotName = "amulet"
	else
		slotName = ""
	end
	print(slotName)
	return slotName
end

function RPCItems:RecalculateStatsBasic(hero)
	local playerID = hero:GetPlayerOwnerID()
	print(hero:GetUnitName())
	print(hero)
	  local respawnAbility = Events.GameMaster:FindAbilityByName("respawn_abilities")
	  respawnAbility:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_respawned_equip", {duration = 2})
	for i = 0, 5, 1 do
		Timers:CreateTimer(0.2*i, function()
			local itemEntity = CustomNetTables:GetTableValue("equipment", tostring(playerID).."-"..tostring(i))
			if itemEntity then
				local item = EntIndexToHScript(itemEntity.itemIndex)
				if IsValidEntity(item) then
					RPCItems:EquipItem(i, hero, hero.InventoryUnit, item)
					-- if item.rarity == "arcana" then
					-- else
					-- 	RPCItems:EquipItem(i, hero, hero.InventoryUnit, item)
					-- end
				end
			end
		end)
	end
	Timers:CreateTimer(3.0, function()
		hero:CalculateStatBonus()
	end)
end

function RPCItems:RecalculateStats(keys)
	local playerID = keys.playerId
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	print(hero:GetUnitName())
	print(hero)
	for i = 0, 5, 1 do
		Timers:CreateTimer(0.8*i, function()
			local itemEntity = CustomNetTables:GetTableValue("equipment", tostring(playerID).."-"..tostring(i))
			if itemEntity then
				local item = EntIndexToHScript(itemEntity.itemIndex)
				print("GOOOOOODDDAY")
				RPCItems:EquipItem(i, hero, hero.InventoryUnit, item)
			end
		end)
	end
	Timers:CreateTimer(5.0, function()
		hero:CalculateStatBonus()
	end)
end


function RPCItems:AcceptNewItem(keys)
	local playerID = keys.PlayerID
	local oldItem = EntIndexToHScript(keys.oldItem)
	local newItem = EntIndexToHScript(keys.newItem)
	local hero, inventory_unit = RPCItems:GetHeroAndInventoryByID(keys.PlayerID)
	hero.cant_use_items = true
	Timers:CreateTimer(0.75, function()
		hero.cant_use_items = false
	end)
	DeepPrintTable(keys)
	local slot = RPCItems:getGearSlot(newItem.slot)
	CustomNetTables:SetTableValue("equipment", tostring(playerID).."-"..tostring(slot), {itemIndex = newItem:GetEntityIndex()} )
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_inventory", {} )
	
	if oldItem then
		 UTIL_Remove( oldItem ) 
	end
	hero:RemoveModifierByName("modifier_equip_ui_open")
      EmitGlobalSound("RPC.EquipItem")
      local player = hero:GetPlayerOwner()
      local heroId = hero:GetClassname()
      if newItem then
	      CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=newItem:GetEntityIndex(), heroId=heroId, playerId=playerID, pickup="equip"} )
	      RPCItems:EquipItem(slot, hero, inventory_unit, newItem)
  	  end
    if slot == 1 then
    	hero.weapon = newItem
    	Weapons:SetWeaponTable(newItem)
    	CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), {xp = newItem.xp, level = newItem.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[newItem.level], maxLevel = newItem.maxLevel, requiredHero = newItem.requiredHero} )
    end
end

function RPCItems:RejectNewItem(keys)
	local playerID = keys.PlayerID
	local oldItem = EntIndexToHScript(keys.oldItem)
	local newItem = EntIndexToHScript(keys.newItem)
	UTIL_Remove( newItem )
	local hero, inventory_unit = RPCItems:GetHeroAndInventoryByID(keys.PlayerID)
	hero:RemoveModifierByName("modifier_equip_ui_open")
	print("item rejected")
end

function RPCItems:GetHeroAndInventoryByID(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)

	return hero, hero.InventoryUnit

end

function RPCItems:GiveItemToHero(hero, item)
	hero:AddItem(item)
	Events:PickUpTest(hero, item)
end

function RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
	if hero:HasAnyAvailableInventorySpace() then
		hero:AddItem(item)
		Events:PickUpTest(hero, item)
	else
		if IsValidEntity(item:GetContainer()) then
			item:GetContainer():SetAbsOrigin(hero:GetAbsOrigin()+RandomVector(50))
		else
			CreateItemOnPositionSync(hero:GetAbsOrigin()+RandomVector(50), item)
		end
	end
end

function RPCItems:BuyItem(keys)
	local playerID = keys.playerID
	local player = PlayerResource:GetPlayer(playerID)
	local itemtype = keys.itemtype
	local price = keys.price
	local rarity = keys.rarity
	local hero, inventory_unit = RPCItems:GetHeroAndInventoryByID(playerID)
	print(itemtype)
	print("BUY ITEM")
	local gold = PlayerResource:GetGold(playerID)
	print(price)
	if gold < price then
		EmitSoundOnClient("General.NoGold", player)
		Notifications:Top(playerID, {text="Not Enough Gold", duration=2, style={color="red"}, continue=true})
	elseif not hero:HasAnyAvailableInventorySpace() then
		EmitSoundOnClient("General.NoGold", player)
		Notifications:Top(playerID, {text="Need Inventory Space", duration=2, style={color="red"}, continue=true})
	else
		print(price)
		local newGold = gold-price
		PlayerResource:SetGold(playerID, newGold, false)
		EmitSoundOnClient("General.Buy", player)
		if itemtype == 1 then
			RPCItems:RollHood(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 2, hero)
		elseif itemtype == 2 then
			RPCItems:RollHood(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 3, hero)
		elseif itemtype == 3 then
			RPCItems:RollHood(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 1, hero)
		elseif itemtype == 4 then
			RPCItems:RollBody(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 2, hero)
		elseif itemtype == 5 then
			RPCItems:RollBody(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 3, hero)
		elseif itemtype == 6 then
			RPCItems:RollBody(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 1, hero)
		elseif itemtype == 7 then
			RPCItems:RollFoot(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 2, hero)
		elseif itemtype == 8 then
			RPCItems:RollFoot(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 3, hero)
		elseif itemtype == 9 then
			RPCItems:RollFoot(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 1, hero)
		elseif itemtype == 10 then
			RPCItems:RollHand(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 2, hero)
		elseif itemtype == 11 then
			RPCItems:RollHand(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 3, hero)
		elseif itemtype == 12 then
			RPCItems:RollHand(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 1, hero)
		elseif itemtype == 13 then
			RPCItems:RollBlaster(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 2, hero)
		elseif itemtype == 14 then
			RPCItems:RollBlaster(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 3, hero)
		elseif itemtype == 15 then
			RPCItems:RollBlaster(5+Events.WaveNumber*5, hero:GetAbsOrigin(), rarity, true, 1, hero)
		elseif itemtype == "immortal_helm" then
			RPCItems.vendorHero = hero
			RPCItems:RollHood(300, hero:GetAbsOrigin(), rarity, true, RandomInt(1, 3), hero, 0)
			hero.legendHelm = true
			CustomGameEventManager:Send_ServerToPlayer(player, "CloseRareShop", {player=playerID} )
		end
	end
end

function RPCItems:LegendaryPickup(itemEntity, heroEntity)
	--GT 147
-- CustomGameEventManager:RegisterListener( "item_vote", Dynamic_Wrap(RPCItems, "ItemVote"))

	local itemIndex = itemEntity:GetEntityIndex()
	if not RPCItems.item_roll_queue then
		RPCItems.item_roll_queue = {}
		RPCItems.item_roll_1 = false
		RPCItems.item_roll_2 = false
		RPCItems.item_roll_3 = false
		RPCItems.indexesRolled = {}
	end
	if RPCItems:GetConnectedPlayerCount() > 1 then
		if heroEntity then
			heroEntity:TakeItem(itemEntity)
			if IsValidEntity(itemEntity:GetContainer()) then
				UTIL_Remove(itemEntity:GetContainer())
			end
		end
		local rollSlot = RPCItems:GetFreeRollSlot(itemEntity)
		if rollSlot == 0 then
			table.insert(RPCItems.item_roll_queue, itemEntity)
		else
			CustomGameEventManager:Send_ServerToAllClients("item_roll", {item=itemEntity:GetEntityIndex(), rollSlot=rollSlot, minLevel = itemEntity.minLevel} )
			Timers:CreateTimer(30, function()
				RPCItems:EndRoll(rollSlot, itemIndex)
			end)
		end
	end
end  

function RPCItems:GetFreeRollSlot(itemEntity)
	local slot = 0
	if not RPCItems.item_roll_1 then
		RPCItems.item_roll_1 = {}
		RPCItems.item_roll_1.item = itemEntity
		slot = 1
	elseif not RPCItems.item_roll_2 then
		RPCItems.item_roll_2  = {}
		RPCItems.item_roll_2.item = itemEntity
		slot = 2
	elseif not RPCItems.item_roll_3 then
		RPCItems.item_roll_3 = {}
		RPCItems.item_roll_3.item = itemEntity
		slot = 3
	end
	return slot
end 

function RPCItems:EndRoll(rollSlot, itemIndex)
	if not RPCItems.indexesRolled[itemIndex] then
		local item = EntIndexToHScript(itemIndex)
		if not IsValidEntity(item) then
			CustomGameEventManager:Send_ServerToAllClients("empty_roll_slot", {rollSlot=rollSlot} )
			if #RPCItems.item_roll_queue > 0 then
				RPCItems:LegendaryPickup(RPCItems.item_roll_queue[1], false)
				local newQueue = {}
				for i = 2, #RPCItems.item_roll_queue, 1 do
					table.insert(newQueue, RPCItems.item_roll_queue[i])
				end
				RPCItems.item_roll_queue = newQueue	
			end
			return false
		end
		local winningRoll = nil
		local winningPlayer = nil
		local rollType = nil
		RPCItems.indexesRolled[itemIndex] = true
		if rollSlot == 1 then
			winningRoll, winningPlayer, rollType = ProcessRollEnd(RPCItems.item_roll_1)
			RPCItems.item_roll_1 = false
		elseif rollSlot == 2 then
			winningRoll, winningPlayer, rollType = ProcessRollEnd(RPCItems.item_roll_2)
			RPCItems.item_roll_2 = false
		elseif rollSlot == 3 then
			winningRoll, winningPlayer, rollType = ProcessRollEnd(RPCItems.item_roll_3)
			RPCItems.item_roll_3 = false
		end
		print("WHAT KIND OF DATA DID WE GET?")
		print(winningRoll)
		print(winningPlayer)
		print(rollType)
		local hero = nil
		local heroId = nil
		local playerID = nil
		if winningPlayer then
			hero = GameState:GetHeroByPlayerID(winningPlayer)
			--GameState:GetHeroByPlayerID returns -1 if no hero found
			if type(hero) ~= "number" then
				heroId = hero:GetClassname()
				playerID = winningPlayer
			end
		end
		if type(hero) == "number" then
			if MAIN_HERO_TABLE and #MAIN_HERO_TABLE>0 then
				local newTable = MAIN_HERO_TABLE
				local index = RandomInt(1, #newTable)
				hero = newTable[index]
				playerID = hero:GetPlayerID()
				while not RPCItems:GetIsPlayerConnected(playerID) do
					table.remove(newTable, index)
					if #newTable<1 then
						rolltype = "pass"
						break
					end
					index = RandomInt(1, #newTable)
					hero = newTable[index]
					playerID = hero:GetPlayerID()
				end
				if rolltype ~= "pass" then
					heroId = hero:GetClassname()
					playerID = hero:GetPlayerID()
					Notifications:TopToAll({text="Winner not found, new random player is selected", duration=5.0})
				end
			else
				rolltype = "pass"
			end
		end
		if rolltype == "pass" then
			if item then
				if IsValidEntity(item:GetContainer()) then
					UTIL_Remove(item:GetContainer())
				end
				if IsValidEntity(item) then
					UTIL_Remove(item)
				end
			end
		elseif rollType == "greed" then
			CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemIndex, heroId=heroId, playerId=playerID, pickup="greed", roll=winningRoll} )
			if hero:HasAnyAvailableInventorySpace() then
				if IsValidEntity(item) then
					RPCItems:GiveItemToHero(hero, item)
				end
			else
				local position = hero:GetAbsOrigin()
				if IsValidEntity(item:GetContainer()) then
					item:GetContainer():SetAbsOrigin(position)
				else
					local drop = CreateItemOnPositionSync( position, item )
				end
				local particleName = RPCItems:GetRarityParticle(item.rarity)
				item.particle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, item )
				ParticleManager:SetParticleControl( item.particle, 0, position )
				item.expiryTime = Time() + 260				
			end
		elseif rollType == "need" then	
			CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemIndex, heroId=heroId, playerId=playerID, pickup="need", roll=winningRoll} )
			local slot = RPCItems:getGearSlot(item.slot)
			print("WEAPON EQUIP OUTSIDE BLOCK NEED")
			print(slot)
			if slot == 1 then
				print('WEAPON EQUIP')
				hero.weapon = item 
				Weapons:SetWeaponTable(item)
		   		CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), {xp = item.xp, level = item.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.level], maxLevel = item.maxLevel, requiredHero = item.requiredHero} )
		    end
			Weapons:Equip(hero, item)
		end
		CustomGameEventManager:Send_ServerToAllClients("empty_roll_slot", {rollSlot=rollSlot} )
		if #RPCItems.item_roll_queue > 0 then
			RPCItems:LegendaryPickup(RPCItems.item_roll_queue[1], false)
			local newQueue = {}
			for i = 2, #RPCItems.item_roll_queue, 1 do
				table.insert(newQueue, RPCItems.item_roll_queue[i])
			end
			RPCItems.item_roll_queue = newQueue	
		end
	end
end

function ProcessRollEnd(rollTable)
	rollTable.winningRoll = 0
	rollTable.passCount = 0
	rollTable.highestType = "pass"
	rollTable.winningPlayerID = 0
	print("are we doing this shit")
	for i = 1, #rollTable, 1 do
		local vote = rollTable[i]
		if vote[2] == "need" then
			if vote[3] > rollTable.winningRoll then
				rollTable.winningRoll = vote[3]
				rollTable.highestType = "need"
				rollTable.winningPlayerID = vote[1]
			end
			if rollTable.highestType == "greed" or rollTable.highestType == "pass" then
				rollTable.winningRoll = vote[3]
				rollTable.highestType = "need"
				rollTable.winningPlayerID = vote[1]
			end
		elseif vote[2] == "greed" then
			if vote[3] > rollTable.winningRoll then
				if rollTable.highestType == "greed" or rollTable.highestType == "pass" then
					rollTable.winningRoll = vote[3]
					rollTable.highestType = "greed"
					rollTable.winningPlayerID = vote[1]
				end
			end
		elseif vote[2] == "pass" then
			rollTable.passCount = rollTable.passCount + 1
		end
	end
	if rollTable.passCount == RPCItems:GetConnectedPlayerCount() then
		return false, false, rollTable.highestType
	else
		return rollTable.winningRoll, rollTable.winningPlayerID, rollTable.highestType
	end
end

function RPCItems:ItemVote(keys)
	local index = keys.index
	local rollType = keys.type
	local playerID = keys.playerID
	local itemIndex = keys.itemIndex
	local vote = {}
	if rollType == "pass" then
		table.insert(vote, playerID)
		table.insert(vote, rollType)
		table.insert(vote, 0)
		CustomGameEventManager:Send_ServerToAllClients("register_roll", {playerID=playerID, roll=roll, rollIndex = index, rollType = rollType} )
	else
		table.insert(vote, playerID)
		table.insert(vote, rollType)
		local roll = RandomInt(1, 100)
		table.insert(vote, roll)
		CustomGameEventManager:Send_ServerToAllClients("register_roll", {playerID=playerID, roll=roll, rollIndex = index, rollType = rollType} )
	end
	if index == 1 then
		table.insert(RPCItems.item_roll_1, vote)
		if #RPCItems.item_roll_1 == RPCItems:GetConnectedPlayerCount() then
			print("END ROLL")
			RPCItems:EndRoll(1, itemIndex)
		end
	elseif index == 2 then
		table.insert(RPCItems.item_roll_2, vote)
		if #RPCItems.item_roll_2 == RPCItems:GetConnectedPlayerCount() then
			print("END ROLL")
			RPCItems:EndRoll(2, itemIndex)
		end
	elseif index == 3 then
		table.insert(RPCItems.item_roll_3, vote)
		if #RPCItems.item_roll_3 == RPCItems:GetConnectedPlayerCount() then
			print("END ROLL")
			RPCItems:EndRoll(3, itemIndex)
		end
	end
end

function RPCItems:GetConnectedPlayerCount()
	local disconnected_count = 0 
	for i = 1, #MAIN_HERO_TABLE, 1 do
			if MAIN_HERO_TABLE[i]:GetPlayerOwnerID() then
				if (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) == 2) or (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) ==1) then
					if MAIN_HERO_TABLE[i]:GetUnitName() == "npc_dota_hero_wisp" then
						disconnected_count = disconnected_count+1
					end
				else
					disconnected_count = disconnected_count+1
				end
			end
	end
	return #MAIN_HERO_TABLE - disconnected_count
end

function RPCItems:GetIsPlayerConnected(playerID)
	if (PlayerResource:GetConnectionState(playerID) == 2) or (PlayerResource:GetConnectionState(playerID) ==1) then
		return true
	else
		return false
	end
end

function RPCItems:GetConnectedPlayerTable()
	local connectedPlayerTable = {}
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) == 2) or (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) ==1) then
			table.insert(connectedPlayerTable, MAIN_HERO_TABLE[i])
		end
	end
	return connectedPlayerTable
end

function RPCItems:GetMaxFactor()
	local maxFactor = 0
	if RPCItems.LevelRoll then 
		maxFactor = math.floor(RPCItems.LevelRoll*3.2)
		if RPCItems.LevelRoll == 100 then
			return 300
		end
	else
	    if Dungeons.itemLevel > 0 then
	        maxFactor = Dungeons.itemLevel
	    else
	        maxFactor = Events.WaveNumber
	    end
	    local difficulty = GameState:GetDifficultyFactor()
	    maxFactor = maxFactor + (difficulty-1)*80
	    if difficulty == 1 then
	    	if maxFactor < 30 then
	    		maxFactor = maxFactor + 3
	    	else
	    		maxFactor = maxFactor + 12
	    	end
	    end
	    if Events.SpiritRealm then
	    	maxFactor = maxFactor + 50
	    end
	    if Quests.itemLevel then
	    	maxFactor = Quests.itemLevel
	    end
	    if Arena then
	    	if Arena.PitLevel then
	    		maxFactor = maxFactor + 8*Arena.PitLevel
	    	end
	    end
	    if Winterblight then
	    	if Winterblight.Stones then
	    		maxFactor = maxFactor + 45*Winterblight.Stones
	    	end
	    end
	    if RPCItems.StrictItemLevel then
	    	maxFactor = RPCItems.StrictItemLevel
	    end
	end
    -- local randomNumber = RandomInt(-100,50)
    -- local randomPercentage = randomNumber/100
    -- local randomScale = randomPercentage * 0.1
    maxFactor = RPCItems:GetLogarithmicVarianceValue(maxFactor, 0, 0, 0, 0)
    maxFactor = math.min(maxFactor, 300)
    return math.floor(maxFactor)
end

function RPCItems:RollReanimationStone(deathLocation)

    local item = RPCItems:CreateConsumable("item_reanimation_stone", "mythical", "Reanimation Stone", "consumable", false, "Consumable", "reanimation_stone_desc")
    local drop = CreateItemOnPositionSync( deathLocation, item )
    local position = deathLocation
    RPCItems:DropItem(item, position)
end

function RPCItems:GiveReanimationStoneToHero(hero)
    local item = RPCItems:CreateConsumable("item_reanimation_stone", "mythical", "Reanimation Stone", "consumable", false, "Consumable", "reanimation_stone_desc")
    item.pickedUp = true
    RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
end

function RPCItems:GetLogarithmicVarianceValue(baseValue, varianceUpPercent, varianceDownPercent, topTightness, bonusInput)
	local RNG = RandomInt(1, 100)
	if RNG < 5 then
		baseValue = math.ceil(baseValue*0.7)
	elseif RNG < 10 then
		baseValue = math.ceil(baseValue*0.75)
	elseif RNG < 20 then
		baseValue = math.ceil(baseValue*0.8)
	elseif RNG < 30 then
		baseValue = math.ceil(baseValue*0.85)
	elseif RNG < 40 then
		baseValue = math.ceil(baseValue*0.9)
	elseif RNG < 50 then
		baseValue = math.ceil(baseValue*1.0)
	elseif RNG < 60 then
		baseValue = math.ceil(baseValue*1.05)
	elseif RNG < 70 then
		baseValue = math.ceil(baseValue*1.1)
	elseif RNG < 80 then
		baseValue = math.ceil(baseValue*1.15)
	elseif RNG < 85 then
		baseValue = math.ceil(baseValue*1.2)
	elseif RNG < 90 then
		baseValue = math.ceil(baseValue*1.25)
	elseif RNG < 95 then
		baseValue = math.ceil(baseValue*1.3)
	elseif RNG < 98 then
		baseValue = math.ceil(baseValue*1.35)
	elseif RNG >= 98 then
		baseValue = math.ceil(baseValue*0.65)
	end
	local finalRoll = RandomInt(1, 5)
	if finalRoll == 1 then
		baseValue = math.ceil(baseValue*0.9)
	elseif finalRoll == 5 then
		baseValue = math.ceil(baseValue*1.1)
	end
	return baseValue
end

function RPCItems:GetLogarithmicVarianceNoRounding(baseValue)
	local RNG = RandomInt(1, 100)
	if RNG < 5 then
		baseValue = baseValue*0.7
	elseif RNG < 10 then
		baseValue = baseValue*0.75
	elseif RNG < 20 then
		baseValue = baseValue*0.8
	elseif RNG < 30 then
		baseValue = baseValue*0.85
	elseif RNG < 40 then
		baseValue = baseValue*0.9
	elseif RNG < 50 then
		baseValue = baseValue*1.0
	elseif RNG < 60 then
		baseValue = baseValue*1.05
	elseif RNG < 70 then
		baseValue = baseValue*1.1
	elseif RNG < 80 then
		baseValue = baseValue*1.15
	elseif RNG < 85 then
		baseValue = baseValue*1.2
	elseif RNG < 90 then
		baseValue = baseValue*1.25
	elseif RNG < 95 then
		baseValue = baseValue*1.3
	elseif RNG < 100 then
		baseValue = baseValue*1.35
	end
	local finalRoll = RandomInt(1, 5)
	if finalRoll == 1 then
		baseValue = baseValue*0.9
	elseif finalRoll == 5 then
		baseValue = baseValue*1.1
	end
	return baseValue
end

function RPCItems:GetRandomRuneLetter(min, max)
	local luck = RandomInt(min, max)
	local letter = ""
	if luck == 1 then
		letter = "q"
	elseif luck == 2 then
		letter = "w"
	elseif luck == 3 then
		letter = "e"
	elseif luck == 4 then
		letter = "r"
	end
	return letter
end

function RPCItems:AdjustAttributeValue(hero, value)
	if hero:GetUnitName() == "npc_dota_hero_zuus" then
		local b_d_level = Runes:GetTotalRuneLevel(hero, 2, "r_2", "auriun")
		value = value + value*0.005*b_d_level
	end
	return value
end

function RPCItems:BasicDropItem(position, item)
    local drop = CreateItemOnPositionSync( position, item )
    RPCItems:DropItem(item, position)
end

function RPCItems:CreateBasicConsumable(position, itemName, fullName, rarity, bDrop)
    local item = RPCItems:CreateConsumable(itemName, rarity, fullName, "consumable", false, "Consumable", itemName.."_desc")
    item.stashable = true
    item.consumable = true
    item.basicConsumable = true
    if bDrop then
    	RPCItems:BasicDropItem(position, item)
    end
    return item
end
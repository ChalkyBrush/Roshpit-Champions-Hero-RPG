if Weapons == nil then
  Weapons = class({})
end

require('items/legend_weapons')

Weapons.XP_PER_LEVEL_TABLE = {}
Weapons.MAX_WEAPON_LEVEL = 50
for i=1,Weapons.MAX_WEAPON_LEVEL, 1 do
	if i <=5 then
		Weapons.XP_PER_LEVEL_TABLE[i] = i*350
	elseif i<=10 then
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (i-5)*2500
	elseif i<=15 then
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (5*2500) + (i-10)*4000
	elseif i<=20 then
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (5*2500) + (5*4000) + (i-15)*8000
	elseif i<=25 then
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (5*2500) + (5*4000) + (5*8000) + (i-20)*15000
	elseif i<=30 then
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (5*2500) + (5*4000) + (5*8000) + (5*15000) + (i-25)*25000
	elseif i<=35 then
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (5*2500) + (5*4000) + (5*8000) + (5*15000) + (5*25000) + (i-30)*35000
	elseif i<=40 then
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (5*2500) + (5*4000) + (5*8000) + (5*15000) + (5*25000) + (5*35000) + (i-35)*50000
	else
		Weapons.XP_PER_LEVEL_TABLE[i] = (350*5) + (5*2500) + (5*4000) + (5*8000) + (5*15000) + (5*25000) + (5*35000) + (5*50000) + (i-40)*80000
	end
end

--debug
-- for i=1,50, 1 do
-- 	Weapons.XP_PER_LEVEL_TABLE[i] = 200
-- end

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
		Weapons:InitialWeaponConjuror(hero, "item_rpc_conjuror_weapon_00", "Orb")
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
	end
end

function Weapons:InitialWeapon(hero, item_variant, itemName)
	local item = Weapons:CreateWeaponVariant(item_variant, "common", itemName, "weapon", true, "Slot: Weapon", hero:GetUnitName(), 20, 1)
    item.xp = 0
    item.level = 1
    item.maxLevel = 20
    item.requiredHero = hero:GetUnitName()
    -- item.upgradeStatus = 0
    -- item.phase = 0
    -- item.upgradeIndex = "00"
    hero.weapon = item
    CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), {xp = item.xp, level = item.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.level], maxLevel = item.maxLevel, requiredHero = item.requiredHero} )
    -- CustomNetTables:SetTableValue("weapons", "item"..tostring(item:GetEntityIndex()), {xp = item.xp, level = item.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.level], maxLevel = item.maxLevel, requiredHero = item.requiredHero, itemName = item:GetAbilityName()} )
    Weapons:SetWeaponTable(item)
    item.property1 = 100
    item.property1name = "attack_damage"
    RPCItems:SetPropertyValues(item, item.property1, "#item_bonus_attack_damage", "#343EC9",  1) 

    Weapons:Equip(hero, item)
end

function Weapons:InitialWeaponConjuror(hero, item_variant, itemName)
    local item = RPCItems:CreateVariant(item_variant, "common", itemName, "weapon", true, "Slot: Weapon")
    item.xp = 0
    item.level = 1
    item.maxLevel = 20
    item.requiredHero = hero:GetName()
    -- item.upgradeStatus = 0
    -- item.phase = 0
    -- item.upgradeIndex = "00"
    hero.weapon = item
    CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), {xp = item.xp, level = item.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.level], maxLevel = item.maxLevel, requiredHero = item.requiredHero} )
    -- CustomNetTables:SetTableValue("weapons", "item"..tostring(item:GetEntityIndex()), {xp = item.xp, level = item.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.level], maxLevel = item.maxLevel, requiredHero = item.requiredHero, itemName = item:GetAbilityName()} )
    Weapons:SetWeaponTable(item)
    item.property1 = 2000
    item.property1name = "aspect_health"
    RPCItems:SetPropertyValues(item, item.property1, "#item_aspect_health", "#3D82CC",  1) 

    Weapons:Equip(hero, item)
end

function Weapons:Equip(heroEntity, itemEntity)
	local player = heroEntity:GetPlayerOwner()
	local slot = RPCItems:getGearSlot(itemEntity.slot)
	print(slot)
	local oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(slot))
	local oldGear = false
	local playerID = heroEntity:GetPlayerID()
	local heroId = heroEntity:GetClassname()
	if itemEntity.requiredHero then
		if itemEntity.requiredHero == heroEntity:GetUnitName() then
		else
			return false
		end
	end
	CustomNetTables:SetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(slot), {itemIndex = itemEntity:GetEntityIndex()} )
	-- CustomGameEventManager:Send_ServerToPlayer(player, "InitializeEquipment", {item=itemEntity:GetEntityIndex()} )
	heroEntity:TakeItem(itemEntity)
	if IsValidEntity(itemEntity:GetContainer()) then
		UTIL_Remove(itemEntity:GetContainer())
	end
	local hero, inventory_unit = RPCItems:GetHeroAndInventoryByID(player:GetPlayerID())
	RPCItems:EquipItem(slot, hero, inventory_unit, itemEntity)
	CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})


	if itemEntity.hasRunePoints then
		itemEntity.translated = false
        RPCItems:AmuletPickup(heroEntity, itemEntity)
    end
    print("SLOT: "..slot)
    if slot == 1 then
    	if not itemEntity.xp and not itemEntity.level then
		    item.xp = 0
		    item.level = 1
		end
    	print("SLOT = 1!!")
    	hero.weapon = itemEntity
    	Weapons:SetWeaponTable(itemEntity)
    	CustomNetTables:SetTableValue("weapons", tostring(heroEntity:GetEntityIndex()), {xp = itemEntity.xp, level = itemEntity.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[itemEntity.level], maxLevel = itemEntity.maxLevel, requiredHero = itemEntity.requiredHero} )
    	CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemEntity:GetEntityIndex(), heroId=heroId, playerId=playerID, pickup="weapon"} )
    else
    	CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemEntity:GetEntityIndex(), heroId=heroId, playerId=playerID, pickup="equip"} )
	    EmitGlobalSound("ui.treasure_reveal")
	    EmitGlobalSound("ui.treasure_reveal")
	    EmitGlobalSound("ui.treasure_reveal")
    end
end

function Weapons:SetWeaponTable(itemEntity)

	CustomNetTables:SetTableValue("weapons", "item"..tostring(itemEntity:GetEntityIndex()), {xp = itemEntity.xp, level = itemEntity.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[itemEntity.level], maxLevel = itemEntity.maxLevel, requiredHero = itemEntity.requiredHero, itemName = itemEntity:GetAbilityName()} )
end

function Weapons:UnequipItem(hero, item)
	local slot = RPCItems:getGearSlot(item.slot)
	RPCItems:RemoveItemStats(slot, hero)
	CustomNetTables:SetTableValue("equipment", tostring(hero:GetPlayerOwnerID()).."-"..tostring(slot), {itemIndex = -1} )
	if IsValidEntity(item:GetContainer()) then
		UTIL_Remove(item:GetContainer())
	end
	if Challenges:CheckIfHeroHasItemByItemIndex(hero, item:GetEntityIndex()) then
	else 
		RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
		CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
		item:StartCooldown(3)
	end
end

function Weapons:ValidateGear(hero)
	local playerID = hero:GetPlayerOwnerID()
	for i = 0, 5, 1 do
		local gearTable = CustomNetTables:GetTableValue("equipment", tostring(playerID).."-"..tostring(i))
		if gearTable then
			local index = gearTable.itemIndex
			local itemEntity = EntIndexToHScript(index)
			if IsValidEntity(itemEntity) then
				print(itemEntity:GetAbilityName())
				print("VALID ENTITY")
				if itemEntity.slot then
					if RPCItems:getGearSlot(itemEntity.slot) == i then
						print("SLOT CORRECT")
					else
						print("INCORRECT SLOT")
						UTIL_Remove(itemEntity)
						CustomNetTables:SetTableValue("equipment", tostring(playerID).."-"..tostring(slot), {itemIndex = -1} )
						CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
					end
				else
					print("NO SLOT!")
					UTIL_Remove(itemEntity)
					CustomNetTables:SetTableValue("equipment", tostring(playerID).."-"..tostring(slot), {itemIndex = -1} )
					CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
				end
			else
				CustomNetTables:SetTableValue("equipment", tostring(playerID).."-"..tostring(slot), {itemIndex = -1} )
				CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
			end
		end
	end
end

function Weapons:UpdateWeaponXP(xpBounty)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if MAIN_HERO_TABLE[i]:IsAlive() then
			local showLevelup = false
			local hero = MAIN_HERO_TABLE[i]
			local weapon = hero.weapon
			if not IsValidEntity(weapon) then
				return false
			end
			local newBounty = xpBounty
			if hero:HasModifier("modifier_blacksmiths_tablet") then
				newBounty = math.floor(xpBounty*1.2)
			end
			if weapon.rarity == "immortal" then
				newBounty = math.ceil(xpBounty/500)
			end
			if weapon.level < weapon.maxLevel then
				weapon.xp = weapon.xp + newBounty
			end

			if weapon.xp >= Weapons.XP_PER_LEVEL_TABLE[weapon.level] and weapon.level < weapon.maxLevel then
				weapon.xp = newBounty - (Weapons.XP_PER_LEVEL_TABLE[weapon.level]-weapon.xp)

				weapon.level = weapon.level + 1
				if weapon.xp > Weapons.XP_PER_LEVEL_TABLE[weapon.level] then
					weapon.xp = 0
				end
				showLevelup = true
				if weapon.level == 5 or weapon.level == 10 or weapon.level == 20 then
					weapon.upgradeStatus = 1
				end
				-- CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "WeaponLvlup", {})
				Weapons:LevelUpWeapon(hero, weapon)
			end
			Weapons:SetWeaponTable(weapon)
			CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), {xp = weapon.xp, level = weapon.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[weapon.level], maxLevel = weapon.maxLevel, requiredHero = weapon.requiredHero} )
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("xp_earned", {} )
end

function Weapons:LevelUpWeapon(hero, weapon)
    local origValues = CustomNetTables:GetTableValue( "item_properties", tostring(weapon:GetEntityIndex()).."-"..tostring(1))
    -- print("----------ORIG VALUES!-----------")
    -- DeepPrintTable(origValues)
    -- print("----------ORIG VALUES!-----------")
    if weapon.level == 2 then
    	if weapon.property1 > 8000 then
    		return false
    	end
    end
	if origValues.propertyValue == "★" then
			local tooltipValue = "★"
			RPCItems:SetPropertyValuesSpecial(weapon, tooltipValue, origValues.propertyName, origValues.propertyColor, 1, origValues.specialDescription)
    else
		weapon.property1 = weapon.property1+math.ceil(weapon.property1*0.1)
		RPCItems:SetPropertyValues(weapon, weapon.property1, origValues.propertyName, origValues.propertyColor,  1)
	end
    if weapon.property2 then
	    local origValues = CustomNetTables:GetTableValue( "item_properties", tostring(weapon:GetEntityIndex()).."-"..tostring(2))
	    if origValues.propertyName == "#item_bonus_attack_damage" then
	    	weapon.property2 = weapon.property2+math.ceil(weapon.property2*0.1)
	    	RPCItems:SetPropertyValues(weapon, weapon.property2, origValues.propertyName, origValues.propertyColor,  2)
	    else
	    	weapon.property2 = weapon.property2+math.ceil(weapon.property2*0.1)
	    	RPCItems:SetPropertyValues(weapon, weapon.property2, origValues.propertyName, origValues.propertyColor,  2)
	    end
    end
    if weapon.property3 then
	    local origValues = CustomNetTables:GetTableValue( "item_properties", tostring(weapon:GetEntityIndex()).."-"..tostring(3))
	    print("ORIG VALUES. PROPERTY NAME")
	    print(origValues.propertyName)
	    if origValues.propertyName == "#item_bonus_attack_damage" then
	    	weapon.property3 = weapon.property3+math.ceil(weapon.property3*0.1)
	    	RPCItems:SetPropertyValues(weapon, weapon.property3, origValues.propertyName, origValues.propertyColor,  3)
	    else
	    	weapon.property3 = weapon.property3+1
	    	RPCItems:SetPropertyValues(weapon, weapon.property3, origValues.propertyName, origValues.propertyColor,  3)
	    end
    end
    if weapon.property4 then
	    local origValues = CustomNetTables:GetTableValue( "item_properties", tostring(weapon:GetEntityIndex()).."-"..tostring(4))
	    if origValues.propertyName == "#item_bonus_attack_damage" then
	    	weapon.property4 = weapon.property4+math.ceil(weapon.property4*0.1)
	    	RPCItems:SetPropertyValues(weapon, weapon.property4, origValues.propertyName, origValues.propertyColor,  4)
	    else
	    	weapon.property4 = weapon.property4+1
	    	RPCItems:SetPropertyValues(weapon, weapon.property4, origValues.propertyName, origValues.propertyColor,  4)
	    end
    end
    Weapons:Equip(hero, weapon)
	if weapon.rarity =="immortal" then
		Stars:StarEventPlayer("weapon", hero)
	end
end



function Weapons:Debug()
	Weapons:InitialSword(MAIN_HERO_TABLE[1])
end

function Weapons:RollWeapon(deathLocation)
	
	local maxFactor = RPCItems:GetMaxFactor()
	local rarityRoll = RandomInt(1, 100+RandomInt(1, maxFactor))
	local rarity = ""
	if rarityRoll <= 80 then
		rarity = "uncommon"
	elseif rarityRoll <= 160 then
		rarity = "rare"
	else
		rarity = "mythical"
	end
	local itemName = ""
	local whichHero = MAIN_HERO_TABLE[RandomInt(1, #MAIN_HERO_TABLE)]:GetUnitName()
	local internalName = HerosCustom:GetInternalHeroName(whichHero)

	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes(whichHero)


	local mainAttrRoll = RandomInt(1, 3)
	local propensity = (mainAttrRoll-2)*2

	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	if rarityFactor >= 3 then
		propensity = propensity + propensityTable[specialProperty1]
	end
	if rarityFactor >= 4 then
		while specialProperty1 == specialProperty2 do
			specialProperty2 = RandomInt(1, #propensityTable)
		end
		propensity = propensity + propensityTable[specialProperty2]
	end
	local digit2 = Weapons:GetDigit2(propensity, rarityFactor)
	local weaponIndexString = tostring(rarityFactor-2)

	local weaponName = "item_rpc_"..internalName.."_weapon_"..tostring(weaponIndexString)..tostring(digit2)
	print(weaponName)
	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, Weapons:GetMaxWeaponLevel(), 0)

	if internalName == "conjuror" then
		local value = Weapons:GetDeviation(2000, 0)
	    weapon.property1 = value
	    weapon.property1name = "aspect_health"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_aspect_health", "#3D82CC",  1) 
	else
		local value = Weapons:GetDeviation(100, 0)
	    weapon.property1 = value
	    weapon.property1name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_bonus_attack_damage", "#343EC9",  1) 
	end
	if mainAttrRoll == 1 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif mainAttrRoll == 2 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	else
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	end
	if rarityFactor >= 3 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty1], rarityFactor)
		weapon.property3 = value
		weapon.property3name = propertyTable[specialProperty1]
		RPCItems:SetPropertyValues(weapon, weapon.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)
	end
	if rarityFactor >= 4 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty2], rarityFactor)
		weapon.property4 = value
		weapon.property4name = propertyTable[specialProperty2]
		RPCItems:SetPropertyValues(weapon, weapon.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)
	end

    local drop = CreateItemOnPositionSync( deathLocation, weapon )
    local position = deathLocation
    RPCItems:DropItem(weapon, position)
    
end

function Weapons:CreateWeaponVariant(variantName, rarityName, itemNameText, slot, gear, slotText, whichHero, maxLevel, minLevel)
    local itemVariant = variantName
    local item = CreateItem(itemVariant, nil, nil)
    item.rarity = rarityName
    local rarityValue = RPCItems:GetRarityFactor(item.rarity)
    local itemName = itemNameText
    local suffix = ""
    local prefix = ""
    item.slot = slot
    item.gear = gear

	item.hasRunePoints = true
    item.xp = 0
    item.level = 1
    item.minLevel = minLevel
    item.maxLevel = maxLevel
    item.requiredHero = whichHero

    Weapons:SetWeaponTableValues(item, itemName, false, slotText, RPCItems:GetRarityColor(item.rarity), item.rarity, "", "", RPCItems:GetRarityFactor(item.rarity), slot)
    return item
end

function Weapons:SetWeaponTableValues(item, itemName, consumableBoolean, description, qualityColor, qualityName, prefix, suffix, rarityFactor, slot)
	local minLevel = 0
	if qualityName == "immortal" then
		if not item.minLevel then
			item.minLevel = 100
			minLevel = 100
		end
	end
	print("SET WEAPON TABLE VALUES")
	CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemName, consumable = consumableBoolean, itemDescription = description, qualityColor = qualityColor, qualityName = qualityName, itemPrefix = prefix, itemSuffix = suffix, rarityFactor = rarityFactor, minLevel = item.minLevel, maxLevel = item.maxLevel, requiredHero = item.requiredHero, slot = slot } )
end


function Weapons:GetMaxWeaponLevel()
	local maxFactor = RPCItems:GetMaxFactor()
	local maxLevel = 25
	local RNG = RandomInt(1, 100)
	maxLevel = maxLevel + math.floor(maxFactor/6)
	if RNG < 20 then
		maxLevel = math.floor(maxLevel*(RandomInt(60,100)/100))
	elseif RNG < 50 then
		maxLevel = math.floor(maxLevel*(RandomInt(80,100)/100))
	elseif RNG < 80 then
		maxLevel = math.floor(maxLevel*(RandomInt(80,120)/100))
	else
		maxLevel = math.floor(maxLevel*(RandomInt(100,135)/100))
	end
	local maxLevel = math.min(maxLevel, Weapons.MAX_WEAPON_LEVEL)
	return maxLevel
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
		baseValue = math.ceil(baseValue*(1.34+(baseAdjustment/10)))
	elseif rarityFactor == 3 then
		baseValue = math.ceil(baseValue*(1.12+(baseAdjustment/12)))
	elseif rarityFactor == 4 then
		baseValue = math.ceil(baseValue*(1.04+(baseAdjustment/20)))
	end
	if RNG < 10 then
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
	elseif RNG < 91 then
		baseValue = math.ceil(baseValue*1.22)
	elseif RNG < 96 then
		baseValue = math.ceil(baseValue*1.32)
	elseif RNG <= 100 then
		baseValue = math.ceil(baseValue*1.4)
	end
	local finalRoll = RandomInt(1, 5)
	if finalRoll == 1 then
		baseValue = math.ceil(baseValue*0.9)
	elseif finalRoll == 5 then
		baseValue = math.ceil(baseValue*1.1)
	end
	return baseValue
end
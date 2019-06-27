if Weapons == nil then
  Weapons = class({})
end

require('items/legend_weapons')

require('items/constants/boots')
require('items/constants/chest')
require('items/constants/gloves')
require('items/constants/helm')
require('items/constants/trinket')

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

function Weapons:InitialWeapon(hero, item_variant, itemName)
	print("[Weapons:InitialWeapon]")
	local item = Weapons:CreateWeaponVariant(item_variant, "common", itemName, "weapon", true, "Slot: Weapon", hero:GetUnitName(), 20, 1)
	item.newItemTable.xp = 0
	item.newItemTable.level = 1
	item.newItemTable.maxLevel = 20
	item.newItemTable.requiredHero = hero:GetUnitName()
	hero.weapon = item.newItemTable
	item.newItemTable.xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.newItemTable.level]
	Weapons:SetWeaponTable(item)
	if item_variant == "item_rpc_conjuror_weapon_00" then
		item.newItemTable.property1 = 2000
		item.newItemTable.property1name = "aspect_health"
		RPCItems:SetPropertyValues(item, 2000, "#item_aspect_health", "#343EC9",  1)
	else
		RPCItems:SetPropertyValues(item, 100, "#item_bonus_attack_damage", "#343EC9",  1)
	end
	RPCItems:ItemUpdateCustomNetTables(item)
	Weapons:Equip(hero, item)
end

function Weapons:Equip(heroEntity, itemEntity)
	print("[Weapons:Equip] itemEntity")
	print(itemEntity)
	local player = heroEntity:GetPlayerOwner()
	local slot = RPCItems:getGearSlot(itemEntity.newItemTable.item_slot)
	print(slot)
	local oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(slot))
	local oldGear = false
	local playerID = heroEntity:GetPlayerID()
	local heroId = heroEntity:GetClassname()
	if itemEntity.newItemTable.requiredHero then
		if itemEntity.newItemTable.requiredHero == heroEntity:GetUnitName() then
		else
			return false
		end
	end
	CustomNetTables:SetTableValue("equipment", tostring(player:GetPlayerID()).."-"..tostring(slot), {itemIndex = itemEntity:GetEntityIndex()} )
	-- CustomGameEventManager:Send_ServerToPlayer(player, "InitializeEquipment", {item=itemEntity:GetEntityIndex()} )
	heroEntity:TakeItem(itemEntity)
	if IsValidEntity(itemEntity:GetContainer()) then
		RPCItems:ItemUTIL_Remove(itemEntity:GetContainer())
	end
	local hero, inventory_unit = RPCItems:GetHeroAndInventoryByID(player:GetPlayerID())
	RPCItems:EquipItem(slot, hero, inventory_unit, itemEntity)
	CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})


	if itemEntity.newItemTable.hasRunePoints then
		itemEntity.newItemTable.translated = false
        RPCItems:AmuletPickup(heroEntity, itemEntity)
    end
    print("SLOT: "..slot)
    if slot == 1 then
    	if not itemEntity.newItemTable.xp and not itemEntity.newItemTable.level then
		    itemEntity.newItemTable.xp = 0
		    itemEntity.newItemTable.level = 1
		end
    	print("SLOT = 1!!")
    	hero.weapon = itemEntity
		CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), 
			{xp = itemEntity.newItemTable.xp, 
			level = itemEntity.newItemTable.level, 
			xpNeeded = Weapons.XP_PER_LEVEL_TABLE[itemEntity.newItemTable.level], 
			maxLevel = itemEntity.newItemTable.maxLevel, 
			requiredHero = itemEntity.newItemTable.requiredHero} )

    	Weapons:SetWeaponTable(itemEntity)

    	CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemEntity:GetEntityIndex(), heroId=heroId, playerId=playerID, pickup="weapon", rarity=itemEntity.newItemTable.rarity, rarityColor=RPCItems:GetRarityColor(itemEntity.newItemTable.rarity)} )
    else
    	CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemEntity:GetEntityIndex(), heroId=heroId, playerId=playerID, pickup="equip", rarity=itemEntity.newItemTable.rarity, rarityColor=RPCItems:GetRarityColor(itemEntity.newItemTable.rarity)} )
	    EmitGlobalSound("ui.treasure_reveal")
	    EmitGlobalSound("ui.treasure_reveal")
	    EmitGlobalSound("ui.treasure_reveal")
    end
end

function Weapons:SetWeaponTable(itemEntity)
	if not itemEntity then
		print("[Weapons:SetWeaponTable] itemEntity is null")
		return
	end
	if not itemEntity.newItemTable then
		print("[Weapons:SetWeaponTable] itemEntity.newItemTable is null")
		itemEntity.newItemTable = {}
	end
	if not itemEntity.newItemTable.item_name then
		itemEntity.newItemTable.item_name = itemEntity:GetAbilityName()
	end
	if itemEntity.newItemTable.xpNeeded and itemEntity.newItemTable.level then
		itemEntity.newItemTable.xpNeeded = Weapons.XP_PER_LEVEL_TABLE[itemEntity.newItemTable.level]
	end
	RPCItems:ItemUpdateCustomNetTables(itemEntity)
end

function Weapons:UnequipItem(hero, item, slot)
	if hero and item and slot then
		print("[Weapons:UnequipItem] ok")
	else
		print("[Weapons:UnequipItem] missing parameters")
	end
	RPCItems:RemoveItemStats(slot, hero)

	CustomNetTables:SetTableValue("equipment", tostring(hero:GetPlayerOwnerID()).."-"..tostring(slot), {itemIndex = -1} )
	if slot == 1 then
		hero.weapon = nil
	end
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
	print("[Weapons:ValidateGear] +++++++++++++++++++++++++++++++++++++++++++++")
	local playerID = hero:GetPlayerOwnerID()
	for i = 0, 5, 1 do
		local gearTable = CustomNetTables:GetTableValue("equipment", tostring(playerID).."-"..tostring(i))
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
						CustomNetTables:SetTableValue("equipment", tostring(playerID).."-"..tostring(slot), {itemIndex = -1} )
						CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
					end
				else
					print("[Weapons:ValidateGear} NO SLOT!")
					RPCItems:ItemUTIL_Remove(itemEntity)
					CustomNetTables:SetTableValue("equipment", tostring(playerID).."-"..tostring(slot), {itemIndex = -1} )
					CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
				end
			else
				print("[Weapons:ValidateGear} 111 NO SLOT!")
				CustomNetTables:SetTableValue("equipment", tostring(playerID).."-"..tostring(slot), {itemIndex = -1} )
				CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
			end
		end
	end
end

function Weapons:UpdateWeaponXP(xpBounty)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		Weapons:UpdateWeaponXPPerHero(i, xpBounty)
	end
	CustomGameEventManager:Send_ServerToAllClients("xp_earned", {} )
end

function Weapons:UpdateWeaponXPPerHero(heroNumber, xpBounty)
	if MAIN_HERO_TABLE[heroNumber]:IsAlive() then
		local hero = MAIN_HERO_TABLE[heroNumber]
		if not hero then
			print("[UpdateWeaponXPPerHero] hero is null")
			return
		end
		local weapon = hero.weapon
		if not weapon then
			print("[UpdateWeaponXPPerHero] weapon is null")
			return
		end
		local itemProperties = CustomNetTables:GetTableValue("item_basics", tostring(weapon:GetEntityIndex()))
		if not itemProperties then
			print("[UpdateWeaponXPPerHero] no itemDescription")
			return
		else
			if itemProperties.item_slot and itemProperties.item_slot == "weapon" then
				print("[UpdateWeaponXPPerHero] alright its a weapon")
			else
				print("[UpdateWeaponXPPerHero] it is not a weapon")
				Weapons:weaponRedirect(hero)
				return
			end
		end
		-- DeepPrintTable(weapon)
		if not itemProperties.level or not itemProperties.maxLevel then
			print("[UpdateWeaponXPPerHero] .level .maxLevel")
			return
		else
			if itemProperties.level == itemProperties.maxLevel then
				print("[UpdateWeaponXPPerHero] max level")
				return
			end
		end
		weapon.newItemTable = itemProperties

		if not IsValidEntity(weapon) then
			return
		end
		local newBounty = xpBounty
		if hero:HasModifier("modifier_blacksmiths_tablet") then
			newBounty = math.floor(newBounty*(1+BLACKSMITH_TABLE_ADD_WEAPON_EXP))
		end
		if weapon.newItemTable.rarity == "immortal" then
			newBounty = math.ceil(newBounty/500)
		end
		if weapon.newItemTable.level < weapon.newItemTable.maxLevel then
			weapon.newItemTable.xp = weapon.newItemTable.xp + newBounty
		end

		if weapon.newItemTable.xp >= Weapons.XP_PER_LEVEL_TABLE[weapon.newItemTable.level] and weapon.newItemTable.level < weapon.newItemTable.maxLevel then
			weapon.newItemTable.xp = newBounty - (Weapons.XP_PER_LEVEL_TABLE[weapon.newItemTable.level]-weapon.newItemTable.xp)
			weapon.newItemTable.xp = math.max(weapon.newItemTable.xp, 0)

			weapon.newItemTable.level = math.min(weapon.newItemTable.level + 1, 50)
			if weapon.newItemTable.xp > Weapons.XP_PER_LEVEL_TABLE[weapon.newItemTable.level] then
				weapon.newItemTable.xp = 0
			end

			Weapons:LevelUpWeapon(hero, weapon)
		end

		Weapons:SetWeaponTable(weapon)
		CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), 
			{xp = weapon.newItemTable.xp, 
			level = weapon.newItemTable.level, 
			xpNeeded = Weapons.XP_PER_LEVEL_TABLE[weapon.newItemTable.level], 
			maxLevel = weapon.newItemTable.maxLevel, 
			requiredHero = weapon.newItemTable.requiredHero} )
	end
end

function Weapons:LevelUpWeapon(hero, weapon, doNotEquip)
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
		if weapon.newItemTable.propertyName1 == "#item_bonus_attack_damage" then
			weapon.newItemTable.property1 = weapon.newItemTable.property1 + math.ceil(weapon.newItemTable.property1 * 0.1)
		else
			weapon.newItemTable.property1 = weapon.newItemTable.property1 + math.ceil(weapon.newItemTable.property1 * 0.1)
		end
	end
	if weapon.newItemTable.property2 and type(weapon.newItemTable.property2) == "number" then
		if weapon.newItemTable.propertyName2 == "#item_bonus_attack_damage" then
			weapon.newItemTable.property2 = weapon.newItemTable.property2 + math.ceil(weapon.newItemTable.property2 * 0.1)
		else
			weapon.newItemTable.property2 = weapon.newItemTable.property2 + math.ceil(weapon.newItemTable.property2 * 0.1)
		end
	end
	if weapon.newItemTable.property3 and type(weapon.newItemTable.property3) == "number" then
		if weapon.newItemTable.propertyName3 == "#item_bonus_attack_damage" then
			weapon.newItemTable.property3 = weapon.newItemTable.property3 + math.ceil(weapon.newItemTable.property3 * 0.1)
		else
			weapon.newItemTable.property3 = weapon.newItemTable.property3 + 1
		end
	end
	if weapon.newItemTable.property4 and type(weapon.newItemTable.property4) == "number" then
		if weapon.newItemTable.propertyName4 == "#item_bonus_attack_damage" then
			weapon.newItemTable.property4 = weapon.newItemTable.property4 + math.ceil(weapon.newItemTable.property4 * 0.1)
		else
			weapon.newItemTable.property4 = weapon.newItemTable.property4 + 1
		end
	end
	if not doNotEquip then
		Weapons:Equip(hero, weapon)
		if weapon.newItemTable.rarity == "immortal" then
			Stars:StarEventPlayer("weapon", hero)
		end
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
	if GameMode.VoteSystem.junk_loot_disabled and (rarity == "uncommon" or rarity == "rare" or rarity == "mythical") then
		-- print("junk_loot_disabled weapon rarity: "..rarity)
		return
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
	    weapon.newItemTable.property1 = value
	    weapon.newItemTable.property1name = "aspect_health"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property1, "#item_aspect_health", "#3D82CC",  1) 
	else
		local value = Weapons:GetDeviation(100, 0)
	    weapon.newItemTable.property1 = value
	    weapon.newItemTable.property1name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property1, "#item_bonus_attack_damage", "#343EC9",  1) 
	end
	if mainAttrRoll == 1 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.newItemTable.property2 = value
	    weapon.newItemTable.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000",  2)
	elseif mainAttrRoll == 2 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.newItemTable.property2 = value
	    weapon.newItemTable.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_agility", "#2EB82E",  2)
	else
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.newItemTable.property2 = value
	    weapon.newItemTable.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_intelligence", "#33CCFF",  2)
	end
	if rarityFactor >= 3 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty1], rarityFactor)
		weapon.newItemTable.property3 = value
		weapon.newItemTable.property3name = propertyTable[specialProperty1]
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)
	end
	if rarityFactor >= 4 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty2], rarityFactor)
		weapon.newItemTable.property4 = value
		weapon.newItemTable.property4name = propertyTable[specialProperty2]
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)
	end

    local drop = CreateItemOnPositionSync( deathLocation, weapon )
    local position = deathLocation
    RPCItems:DropItem(weapon, position)
    
end

function Weapons:RollWeaponWithClass(deathLocation, whichHero)
	
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
	if GameMode.VoteSystem.junk_loot_disabled and (rarity == "uncommon" or rarity == "rare" or rarity == "mythical") then
		-- print("junk_loot_disabled weapon rarity: "..rarity)
		return
	end
	local itemName = ""
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
	    weapon.newItemTable.property1 = value
	    weapon.newItemTable.property1name = "aspect_health"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property1, "#item_aspect_health", "#3D82CC",  1) 
	else
		local value = Weapons:GetDeviation(100, 0)
	    weapon.newItemTable.property1 = value
	    weapon.newItemTable.property1name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property1, "#item_bonus_attack_damage", "#343EC9",  1) 
	end
	if mainAttrRoll == 1 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.newItemTable.property2 = value
	    weapon.newItemTable.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000",  2)
	elseif mainAttrRoll == 2 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.newItemTable.property2 = value
	    weapon.newItemTable.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_agility", "#2EB82E",  2)
	else
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.newItemTable.property2 = value
	    weapon.newItemTable.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_intelligence", "#33CCFF",  2)
	end
	if rarityFactor >= 3 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty1], rarityFactor)
		weapon.newItemTable.property3 = value
		weapon.newItemTable.property3name = propertyTable[specialProperty1]
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)
	end
	if rarityFactor >= 4 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty2], rarityFactor)
		weapon.newItemTable.property4 = value
		weapon.newItemTable.property4name = propertyTable[specialProperty2]
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)
	end

    local drop = CreateItemOnPositionSync( deathLocation, weapon )
    local position = deathLocation
    RPCItems:DropItem(weapon, position)
    
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

    Weapons:SetWeaponTableValues(item, itemName, false, slotText, RPCItems:GetRarityColor(item.newItemTable.rarity), item.newItemTable.rarity, "", "", RPCItems:GetRarityFactor(item.newItemTable.rarity), slot)
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
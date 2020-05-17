function CDOTA_BaseNPC_Hero:EquipItem(item, bDoPopup, bInitial)
	local hero = self
	local playerID = hero:GetPlayerOwnerID()
	Events:TutorialServerEvent(hero, "3_1", 0)
	if not hero.gear_bonuses then
		hero:InitGearBonuses()
	end
	local gear_slot = item.newItemTable.gear_slot
	hero:ResetGearBonusesForSlot(gear_slot)

	if not hero.equipped_gear then
		hero.equipped_gear = {}
	end
	hero.equipped_gear[gear_slot] = item
	if item.newItemTable.base_armor then
		RPCItems:RecordGearBonusToHeroBySlot(item, hero, "armor", item.newItemTable.base_armor, gear_slot)
	end
	if item.newItemTable.base_magic_armor then
		RPCItems:RecordGearBonusToHeroBySlot(item, hero, "magic_armor", item.newItemTable.base_magic_armor, gear_slot)
	end

	if item.newItemTable.property1 then
		RPCItems:RecordGearBonusToHeroBySlot(item, hero, item.newItemTable.property1name, item.newItemTable.property1, gear_slot)
	end
	if item.newItemTable.property2 then
		RPCItems:RecordGearBonusToHeroBySlot(item, hero, item.newItemTable.property2name, item.newItemTable.property2, gear_slot)
	end
	if item.newItemTable.property3 then
		RPCItems:RecordGearBonusToHeroBySlot(item, hero, item.newItemTable.property3name, item.newItemTable.property3, gear_slot)
	end
	if item.newItemTable.property4 then
		RPCItems:RecordGearBonusToHeroBySlot(item, hero, item.newItemTable.property4name, item.newItemTable.property4, gear_slot)
	end
	if item.newItemTable.socket1 then
		RPCItems:RecordGemBonusesBySlot(item, hero, 1, item.newItemTable.socket1, item.newItemTable.socket1value, gear_slot)
	end
	if item.newItemTable.socket2 then
		RPCItems:RecordGemBonusesBySlot(item, hero, 2, item.newItemTable.socket2, item.newItemTable.socket2value, gear_slot)
	end
	RPCItems:SpecialGearInitialization(item, hero, gear_slot)

	hero:ApplyGearBonusesByGearSlot(gear_slot)
	
	CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(gear_slot), {itemIndex = item:GetEntityIndex()})
	if bDoPopup then
		CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item = item:GetEntityIndex(), heroId = hero:GetClassname(), playerId = playerID, pickup = "equip", rarity = item.newItemTable.rarity, rarityColor = RPCItems:GetRarityColor(item.newItemTable.rarity)})
		EmitGlobalSound("RPC.EquipItem")
	end
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_inventory", {})
	CustomGameEventManager:Send_ServerToAllClients("update_runes", {})
	item.wearer = hero


	if gear_slot == RPC_GEAR_SLOT_WEAPON and item.newItemTable.rarity == "immortal" then
		Stars:StarEventPlayer("weapon", hero)
	end
	if bInitial then
		hero:ReequipAllGear(gear_slot)
	end
end

function CDOTA_BaseNPC_Hero:UnequipItem(item)
	local hero = self
	local slot = item.newItemTable.gear_slot
	hero:ResetGearBonusesForSlot(slot)
	CustomNetTables:SetTableValue("equipment", tostring(hero:GetPlayerOwnerID()) .. "-"..tostring(slot), {itemIndex = -1})
	-- if slot == 1 then
	-- 	hero.weapon = nil
	-- end
	if IsValidEntity(item:GetContainer()) then
		UTIL_Remove(item:GetContainer())
	end
	if Challenges:CheckIfHeroHasItemByItemIndex(hero, item:GetEntityIndex()) then
	else
		RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
		CustomGameEventManager:Send_ServerToAllClients("update_inventory", {})
		item:StartCooldown(3)
	end
	hero.equipped_gear[slot] = nil
	item.wearer = nil
	Events:TutorialServerEvent(hero, "3_2", 0)
	hero:ReequipAllGear(nil)
end

function CDOTA_BaseNPC_Hero:InitGearBonuses()
	local hero = self
	hero.gear_bonuses = {}
	hero.gear_bonuses[RPC_GEAR_SLOT_HEAD] = {}
	hero.gear_bonuses[RPC_GEAR_SLOT_WEAPON] = {}
	hero.gear_bonuses[RPC_GEAR_SLOT_GLOVES] = {}
	hero.gear_bonuses[RPC_GEAR_SLOT_BOOTS] = {}
	hero.gear_bonuses[RPC_GEAR_SLOT_BODY] = {}
	hero.gear_bonuses[RPC_GEAR_SLOT_TRINKET] = {}
end

function CDOTA_BaseNPC_Hero:ResetGearBonusesForSlot(gear_slot)
	local hero = self
	local internal_hero_name = HerosCustom:GetInternalHeroNameMain(hero:GetClassname())
	if hero.gear_bonuses[gear_slot] then
		for key, value in pairs(hero.gear_bonuses[gear_slot]) do
			if string.match(key, "immortal_weapon") or string.match(key, "arcana") then
				hero:RemoveModifierByName("modifier_"..internal_hero_name.."_"..key)
			elseif string.match(key, "!immortal!") then
				local modifier_name = key:gsub("!immortal!_", "")
				hero:RemoveModifierByName(modifier_name)
			else
				hero:RemoveModifierByName("modifier_"..RPC_GEAR_SLOT_NAMES[gear_slot].."_"..key)
			end
			hero.gear_bonuses[gear_slot][key] = nil
		end
	end
	if not hero.gear_bonuses then
		hero.gear_bonuses = {}
	end
	hero.gear_bonuses[gear_slot] = {}
	hero:UpdateRuneBonusesFromGear()
end

function RPCItems:RecordGearBonusToHeroBySlot(item, hero, property_name, property_value, gear_slot)
	-- --print("PROPERTY NAME: "..property_name)
	-- PROPERTY TYPE MODIFIERS:
	if hero:HasModifier("modifier_puzzlers_locket") or item:GetAbilityName() == "item_rpc_puzzlers_locket" then
		property_name = RPCItems:AdjustPropertyNameForPuzzler(hero, item, property_value, property_name)
	end
	if hero:HasModifier("modifier_monarch_ring") or item:GetAbilityName() == "item_rpc_monarch_ring" then
		property_name, property_value = RPCItems:AdjustPropertyForMonarchRing(hero, item, property_value, property_name)
	end
	if property_name == "immortal_weapon_3" and hero:GetUnitName() == "npc_dota_hero_skywrath_mage" then
		property_name = "all_t4_runes"
		property_value = SEPHYR_IMMORTAL_WEAPON_3_T4_RUNES
	end
	-- RECORD PROPERTIES TO HASH
	if not hero.gear_bonuses[gear_slot][property_name] then
		if string.match(property_name, "all_attributes") then
			RPCItems:InitGearBonusProperty(hero, "strength", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "agility", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "intelligence", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "spirit", gear_slot)
		elseif string.match(property_name, "all_t1_runes") then
			RPCItems:InitGearBonusProperty(hero, "rune_q_1", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_w_1", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_e_1", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_r_1", gear_slot)
		elseif string.match(property_name, "all_t2_runes") then
			RPCItems:InitGearBonusProperty(hero, "rune_q_2", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_w_2", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_e_2", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_r_2", gear_slot)
		elseif string.match(property_name, "all_t3_runes") then
			RPCItems:InitGearBonusProperty(hero, "rune_q_3", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_w_3", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_e_3", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_r_3", gear_slot)
		elseif string.match(property_name, "all_t4_runes") then
			RPCItems:InitGearBonusProperty(hero, "rune_q_4", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_w_4", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_e_4", gear_slot)
			RPCItems:InitGearBonusProperty(hero, "rune_r_4", gear_slot)
		else
			hero.gear_bonuses[gear_slot][property_name] = 0
		end
	end

	--print("--RECORDING PROPERTY--")
	-- HANDLE SPECIAL GEAR BOOST MODIFIERS IN HERE
	-- TATTERED NOVICE ARMOR AMETHYST:
	local property_bonus_mult = 0

	if hero:HasModifier("modifier_tattered_novice_armor") then
		if item.newItemTable.rarityFactor < RPC_ITEMS_RARITY_IMMORTAL then
			novice_armor = hero:FindModifierByName("modifier_tattered_novice_armor"):GetAbility()
			property_bonus_mult = property_bonus_mult + novice_armor:GetFinalGemPropertyValue("amethyst", ITEM_RPC_TATTERED_NOVICE_ARMOR_GEM_AMETHYST)/100
		end
	end
	if item:GetAbilityName() == "item_rpc_harvester_boots" then
		property_bonus_mult = property_bonus_mult + RPCItems:AdjustPropertyValueForHarvester(hero, item, property_value, property_name)
	end
	if hero:HasModifier("modifier_blacksmiths_tablet") then
		if item.newItemTable.gear_slot == RPC_GEAR_SLOT_WEAPON then
			property_bonus_mult = property_bonus_mult + RPCItems:AdjustPropertyValueForBlacksmithTablet(hero, item, property_value, property_name)
		end
	end
	if hero:HasModifier("modifier_paladin_glyph_2_2") then
		if item.newItemTable.gear_slot == RPC_GEAR_SLOT_WEAPON then
			property_bonus_mult = property_bonus_mult + RPCItems:AdjustPropertyValueForPaladinGlyph22(hero, item, property_value, property_name)
		end
	end
	if hero:HasModifier("modifier_vermillion_dream_robes") or item:GetAbilityName() == "item_rpc_vermillion_dream_robes" then
		property_bonus_mult = property_bonus_mult + RPCItems:GetMultForDreamRobes(hero, item, property_value, property_name)
	end
	if hero:HasModifier("modifier_excavators_focus_cap") or item:GetAbilityName() == "item_rpc_excavators_focus_cap" then
		property_bonus_mult = property_bonus_mult + EXCAVATOR_GEAR_AMP/100
	end
	if hero.equipped_gear and hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] and hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetAbilityName() == "item_rpc_stone_of_gordon" then
		property_bonus_mult = property_bonus_mult + RPCItems:GetMultStoneOfGordon(hero, item, property_value, property_name)
	end
	if hero:GetUnitName() == "npc_dota_hero_zuus" and hero:HasAbility("auriun_ult") then
		property_bonus_mult = property_bonus_mult + RPCItems:BonusMultForAuriun(hero, item, property_value, property_name)
	end
	if hero:GetUnitName() == "npc_dota_hero_winter_wyvern" and hero:HasAbility("dinath_dragon_dive") then
		property_bonus_mult = property_bonus_mult + RPCItems:BonusMultForDinath(hero, item, property_value, property_name)
	end
	if hero:GetUnitName() == "npc_dota_hero_invoker" and hero:HasAbility("summon_shadow_deity") then
		property_bonus_mult = property_bonus_mult + RPCItems:BonusMultForConjuror(hero, item, property_value, property_name)
	end
	if type(property_value) == "number" then
		property_value = property_value + property_bonus_mult*property_value
	end

	-- 
	--DeepPrintTable(hero.gear_bonuses[gear_slot])
	if string.match(property_name, "immortal_weapon") or string.match(property_name, "arcana") or string.match(property_name, "!immortal!") then
		hero.gear_bonuses[gear_slot][property_name] = 1
	elseif string.match(property_name, "all_attributes") then
		hero.gear_bonuses[gear_slot]["strength"] = hero.gear_bonuses[gear_slot]["strength"] + property_value
		hero.gear_bonuses[gear_slot]["agility"] = hero.gear_bonuses[gear_slot]["agility"] + property_value
		hero.gear_bonuses[gear_slot]["intelligence"] = hero.gear_bonuses[gear_slot]["intelligence"] + property_value
		hero.gear_bonuses[gear_slot]["spirit"] = hero.gear_bonuses[gear_slot]["spirit"] + property_value
	elseif string.match(property_name, "all_t1_runes") then
		hero.gear_bonuses[gear_slot]["rune_q_1"] = hero.gear_bonuses[gear_slot]["rune_q_1"] + property_value
		hero.gear_bonuses[gear_slot]["rune_w_1"] = hero.gear_bonuses[gear_slot]["rune_w_1"] + property_value
		hero.gear_bonuses[gear_slot]["rune_e_1"] = hero.gear_bonuses[gear_slot]["rune_e_1"] + property_value
		hero.gear_bonuses[gear_slot]["rune_r_1"] = hero.gear_bonuses[gear_slot]["rune_r_1"] + property_value
	elseif string.match(property_name, "all_t2_runes") then
		hero.gear_bonuses[gear_slot]["rune_q_2"] = hero.gear_bonuses[gear_slot]["rune_q_2"] + property_value
		hero.gear_bonuses[gear_slot]["rune_w_2"] = hero.gear_bonuses[gear_slot]["rune_w_2"] + property_value
		hero.gear_bonuses[gear_slot]["rune_e_2"] = hero.gear_bonuses[gear_slot]["rune_e_2"] + property_value
		hero.gear_bonuses[gear_slot]["rune_r_2"] = hero.gear_bonuses[gear_slot]["rune_r_2"] + property_value
	elseif string.match(property_name, "all_t3_runes") then
		hero.gear_bonuses[gear_slot]["rune_q_3"] = hero.gear_bonuses[gear_slot]["rune_q_3"] + property_value
		hero.gear_bonuses[gear_slot]["rune_w_3"] = hero.gear_bonuses[gear_slot]["rune_w_3"] + property_value
		hero.gear_bonuses[gear_slot]["rune_e_3"] = hero.gear_bonuses[gear_slot]["rune_e_3"] + property_value
		hero.gear_bonuses[gear_slot]["rune_r_3"] = hero.gear_bonuses[gear_slot]["rune_r_3"] + property_value
	elseif string.match(property_name, "all_t4_runes") then
		hero.gear_bonuses[gear_slot]["rune_q_4"] = hero.gear_bonuses[gear_slot]["rune_q_4"] + property_value
		hero.gear_bonuses[gear_slot]["rune_w_4"] = hero.gear_bonuses[gear_slot]["rune_w_4"] + property_value
		hero.gear_bonuses[gear_slot]["rune_e_4"] = hero.gear_bonuses[gear_slot]["rune_e_4"] + property_value
		hero.gear_bonuses[gear_slot]["rune_r_4"] = hero.gear_bonuses[gear_slot]["rune_r_4"] + property_value
	else
		if type(property_value) == "number" then
			hero.gear_bonuses[gear_slot][property_name] = hero.gear_bonuses[gear_slot][property_name] + property_value
		else
			hero.gear_bonuses[gear_slot][property_name] = 1
		end
	end
end

function RPCItems:InitGearBonusProperty(hero, property_name, gear_slot)
	if not hero.gear_bonuses[gear_slot][property_name] then
		hero.gear_bonuses[gear_slot][property_name] = 0
	end
end

function CDOTA_BaseNPC_Hero:ApplyGearBonusesByGearSlot(gear_slot)
	local hero = self
	local internal_hero_name = HerosCustom:GetInternalHeroNameMain(hero:GetClassname())
	local inventory_unit = hero.InventoryUnit
	local ability_name = "equipment_"..RPC_GEAR_SLOT_NAMES[gear_slot]
	--print("ABILITY NAME: "..ability_name)
	local ability = inventory_unit:FindAbilityByName(ability_name)
	--DeepPrintTable(hero.gear_bonuses[gear_slot])
	for key, value in pairs(hero.gear_bonuses[gear_slot]) do
		if string.match(key, "immortal_weapon") then
			hero.equipped_gear[gear_slot]:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_"..internal_hero_name.."_"..key, {})
		elseif string.match(key, "arcana") then
			hero.equipped_gear[gear_slot]:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_"..internal_hero_name.."_"..key, {})
			RPCItems:PreacheArcanaResources(hero.equipped_gear[gear_slot])
		elseif string.match(key, "!immortal!") then
			local modifier_name = key:gsub("!immortal!_", "")
			if hero.equipped_gear[gear_slot].isLuaItem then
				hero:AddNewModifier(inventory_unit, hero.equipped_gear[gear_slot], modifier_name, {})
			else
				hero.equipped_gear[gear_slot]:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
				RPCItems:PreacheArcanaResources(hero.equipped_gear[gear_slot])
			end
		else
			if value > 0 then
				local modifier_name = "modifier_"..RPC_GEAR_SLOT_NAMES[gear_slot].."_"..key
				local stacks = value
				
				ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
				hero:SetModifierStackCount(modifier_name, inventory_unit, stacks)
			end
		end
	end
	hero:UpdateRuneBonusesFromGear()
end

function CDOTA_BaseNPC_Hero:UpdateRuneBonusesFromGear()
	local hero = self
	if not hero.runes_bonus_table then
		hero.runes_bonus_table = {}
	end
	for i = 1, #Runes.AllRunesTable, 1 do
		local rune_bonus = 0
		local rune_name = Runes.AllRunesTable[i]
		for gear_slot, slot_name in pairs(RPC_GEAR_SLOT_NAMES) do
			local modifier_name = "modifier_"..slot_name.."_rune_"..rune_name
			if hero:HasModifier(modifier_name) then
				rune_bonus = rune_bonus + hero:GetModifierStackCount(modifier_name, hero.InventoryUnit)
			end	
		end
		if hero.runes_bonus_ring_of_mysteries and hero.runes_bonus_ring_of_mysteries[rune_name] then
			rune_bonus = rune_bonus + hero.runes_bonus_ring_of_mysteries[rune_name]
		end
		hero.runes_bonus_table[rune_name] = rune_bonus
	end
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "-rune_bonuses", hero.runes_bonus_table)
	local player = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player, "update_abilities_and_runes_ui", {})
end

function RPCItems:RecordGemBonusesBySlot(item, hero, socket_number, socket_type, socket_value, gear_slot)
	if item.newItemTable.rarityFactor < RPC_ITEMS_RARITY_IMMORTAL then
		local property_name = nil
		if socket_type == "ruby" then
			property_name = "strength"
		elseif socket_type == "sapphire" then
			property_name = "intelligence"
		elseif socket_type == "emerald" then
			property_name = "agility"
		elseif socket_type == "amethyst" then
			property_name = "spirit"
		end
		if property_name then
			if not hero.gear_bonuses[gear_slot][property_name] then
				hero.gear_bonuses[gear_slot][property_name] = 0
			end
			hero.gear_bonuses[gear_slot][property_name] = hero.gear_bonuses[gear_slot][property_name] + item:GetLevelSpecialValueFor(socket_type.."1", socket_value-1)
		end
	elseif item:GetAbilityName() == "item_rpc_arcane_cascade_hat" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ARCANE_CASCADE_RUBY, hero, "element_arcane", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ARCANE_CASCADE_RUBY, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		end
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ARCANE_CASCADE_EMERALD, hero, "max_mana", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_blackfeather_crown" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", BLACKFEATHER_AMETHYST1, hero, "attack_speed", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sappire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", BLACKFEATHER_SAPPHIRE2, hero, "armor_pierce", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_blinded_glint_of_onu" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", GLINT_OF_ONU_EMERALD1, hero, "agility", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", GLINT_OF_ONU_EMERALD2, hero, "base_ability", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_burning_spirit_helmet" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", BURNING_SPIRIT_RUBY, hero, "element_fire", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", BURNING_SPIRIT_RUBY, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", BURNING_SPIRIT_EMERALD2, hero, "strength", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", BURNING_SPIRIT_EMERALD2, hero, "agility", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", BURNING_SPIRIT_EMERALD2, hero, "intelligence", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", BURNING_SPIRIT_EMERALD2, hero, "spirit", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_cap_of_wild_nature" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", WILD_NATURE_EMERALD, hero, "element_nature", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", WILD_NATURE_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", WILD_NATURE_AMETHYST, hero, "health_regen", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_centaur_horns" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", CENTAUR_HORNS_RUBY, hero, "strength", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_crest_of_the_umbral_sentinel" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", UMBRAL_SENTINEL_EMERALD, hero, "rune_w_4", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST1, hero, "strength", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST1, hero, "agility", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST1, hero, "intelligence", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST1, hero, "spirit", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST2, hero, "max_health", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_crimson_skull_cap" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", CRIMSON_SKULL_CAP_AMETHYST, hero, "element_undead", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", CRIMSON_SKULL_CAP_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() =="item_rpc_crown_of_the_lava_forge" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", LAVA_FORGE_SAPPHIRE, hero, "armor", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", LAVA_FORGE_SAPPHIRE, hero, "magic_armor", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", LAVA_FORGE_AMETHYST, hero, "element_fire", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", LAVA_FORGE_AMETHYST, hero, "element_wind", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", LAVA_FORGE_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_crown_of_the_roknar_emperor" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ROKNAR_SAPPHIRE1, hero, "armor", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ROKNAR_SAPPHIRE2, hero, "max_health", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() =="item_rpc_dark_reef_shark_helmet" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", DARK_REEF_SHARK_RUBY, hero, "attack_speed", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", DARK_REEF_SHARK_SAPPHIRE, hero, "armor_pierce", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() =="item_rpc_death_whisper_helm" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", DEATH_WHISPER_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", DEATH_WHISPER_RUBY, hero, "rune_w_1", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", DEATH_WHISPER_RUBY, hero, "rune_e_1", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", DEATH_WHISPER_RUBY, hero, "rune_r_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", DEATH_WHISPER_EMERALD, hero, "rune_q_2", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", DEATH_WHISPER_EMERALD, hero, "rune_w_2", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", DEATH_WHISPER_EMERALD, hero, "rune_e_2", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", DEATH_WHISPER_EMERALD, hero, "rune_r_2", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", DEATH_WHISPER_AMETHYST, hero, "element_shadow", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", DEATH_WHISPER_AMETHYST, hero, "base_ability", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_demon_mask" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", DEMON_MASK_EMERALD, hero, "rune_q_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", DEMON_MASK_AMETHYST, hero, "element_demon", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", DEMON_MASK_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_emerald_douli" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", EMERALD_DOULI_SAPPHIRE1, hero, "mana_regen", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", EMERALD_DOULI_SAPPHIRE2, hero, "max_mana", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_excavators_focus_cap" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", EXCAVATOR_RUBY, hero, "rune_q_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", EXCAVATOR_EMERALD, hero, "rune_w_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", EXCAVATOR_SAPPHIRE, hero, "rune_e_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", EXCAVATOR_AMETHYST, hero, "rune_r_3", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_eye_of_seasons" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", EYE_OF_SEASONS_EMERALD, hero, "rune_q_1", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", EYE_OF_SEASONS_EMERALD, hero, "rune_w_1", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", EYE_OF_SEASONS_EMERALD, hero, "rune_e_1", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", EYE_OF_SEASONS_EMERALD, hero, "rune_r_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", EYE_OF_SEASONS_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", EYE_OF_SEASONS_AMETHYST, hero, "rune_q_2", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", EYE_OF_SEASONS_AMETHYST, hero, "rune_w_2", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", EYE_OF_SEASONS_AMETHYST, hero, "rune_e_2", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", EYE_OF_SEASONS_AMETHYST, hero, "rune_r_2", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_guard_of_grithault" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", GRITHAULT_SAPPHIRE, hero, "armor", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", GRITHAULT_SAPPHIRE, hero, "magic_armor", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_guard_of_luma" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", LUMA_SAPPHIRE2 , hero, "element_cosmic", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_helm_of_champions" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", CHAMPIONS_GEAR_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", CHAMPIONS_GEAR_EMERALD, hero, "rune_q_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", CHAMPIONS_GEAR_SAPPHIRE, hero, "rune_q_2", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", CHAMPIONS_GEAR_AMETHYST, hero, "rune_q_4", RPC_GEAR_SLOT_HEAD)
		end		
	elseif item:GetAbilityName() == "item_rpc_hood_of_chosen" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", HOOD_OF_CHOSEN_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", HOOD_OF_CHOSEN_EMERALD, hero, "rune_e_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", HOOD_OF_CHOSEN_SAPPHIRE, hero, "rune_w_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", HOOD_OF_CHOSEN_AMETHYST, hero, "rune_r_1", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_hood_of_lords" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", HOOD_OF_LORDS_RUBY, hero, "rune_q_4", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", HOOD_OF_LORDS_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", HOOD_OF_LORDS_SAPPHIRE, hero, "rune_w_4", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", HOOD_OF_LORDS_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_hood_of_the_black_mage" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", HOOD_OF_BLACK_MAGE_SAPPHIRE1, hero, "intelligence", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", HOOD_OF_BLACK_MAGE_SAPPHIRE2, hero, "mana_regen", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_hyper_visor" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", HYPER_VISOR_RUBY, hero, "attack_speed", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", HYPER_VISOR_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", HYPER_VISOR_AMETHYST, hero, "element_lightning", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_igneous_canine_helm" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", IGNEOUS_CANINE_RUBY2, hero, "strength", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_helm_of_the_iron_colossus" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", IRON_COLOSSUS_RUBY, hero, "strength", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_magistrates_hood" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", MAGISTRATE_SAPPHIRE1, hero, "spell_pierce", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", MAGISTRATE_SAPPHIRE2, hero, "intelligence", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_mask_of_the_phantom_sorcerer" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", PHANTOM_SORCERER_EMERALD, hero, "rune_w_2", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", PHANTOM_SORCERER_SAPPHIRE, hero, "rune_w_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", PHANTOM_SORCERER_AMETHYST, hero, "rune_w_3", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_mask_of_tyrius" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", TYRIUS_SAPPHIRE2, hero, "spirit", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", TYRIUS_AMETHYST2, hero, "spirit", RPC_GEAR_SLOT_HEAD)
		end		
	elseif item:GetAbilityName() == "item_rpc_ocean_helm_of_valdun" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", OCEAN_HELM_VALDUN_RUBY, hero, "rune_q_3", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", OCEAN_HELM_VALDUN_RUBY, hero, "rune_w_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", OCEAN_HELM_VALDUN_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", OCEAN_HELM_VALDUN_EMERALD, hero, "rune_r_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", OCEAN_HELM_VALDUN_SAPPHIRE, hero, "rune_w_3", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", OCEAN_HELM_VALDUN_SAPPHIRE, hero, "rune_e_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", OCEAN_HELM_VALDUN_AMETHYST, hero, "rune_q_3", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", OCEAN_HELM_VALDUN_AMETHYST, hero, "rune_r_3", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_odin_helmet" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ODIN_AMETHYST, hero, "base_ability", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ODIN_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		end		
	elseif item:GetAbilityName() == "item_rpc_shipyard_veil_lv1" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", SHIPYARD_VEIL_AMETHYST, hero, "element_ghost", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_stormcrack_helm" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", STORMCRACK_AMETHYST1, hero, "spirit", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", STORMCRACK_AMETHYST2, hero, "attack_damage", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_swamp_witch_hat" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", SWAMP_WITCH_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", SWAMP_WITCH_AMETHYST, hero, "element_shadow", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_twisted_purple_mask_of_ahnqhir" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", TWISTED_PURPLE_AHNQHIR_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", TWISTED_PURPLE_AHNQHIR_EMERALD, hero, "rune_q_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", TWISTED_PURPLE_AHNQHIR_SAPPHIRE, hero, "rune_q_2", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", TWISTED_PURPLE_AHNQHIR_AMETHYST, hero, "rune_q_4", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_twisted_yellow_mask_of_ahnqhir" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", TWISTED_YELLOW_AHNQHIR_RUBY, hero, "rune_w_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", TWISTED_YELLOW_AHNQHIR_EMERALD, hero, "rune_w_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", TWISTED_YELLOW_AHNQHIR_SAPPHIRE, hero, "rune_w_2", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", TWISTED_YELLOW_AHNQHIR_AMETHYST, hero, "rune_w_4", RPC_GEAR_SLOT_HEAD)
		end	
	elseif item:GetAbilityName() == "item_rpc_twisted_blue_mask_of_ahnqhir" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", TWISTED_BLUE_AHNQHIR_RUBY, hero, "rune_e_1", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", TWISTED_BLUE_AHNQHIR_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", TWISTED_BLUE_AHNQHIR_SAPPHIRE, hero, "rune_e_2", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", TWISTED_BLUE_AHNQHIR_AMETHYST, hero, "rune_e_4", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_undertakers_hood" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", UNDERTAKER_EMERALD2, hero, "attack_damage", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_veil_of_the_cerulean_high_guard" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", CERULEAN_HIGHGUARD_RUBY, hero, "max_mana", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", CERULEAN_HIGHGUARD_EMERALD, hero, "spell_pierce", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", CERULEAN_HIGHGUARD_SAPPHIRE, hero, "mana_regen", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_water_deity_crown" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", WATER_DEITY_RUBY, hero, "element_water", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", WATER_DEITY_RUBY, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_wind_deity_crown" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", WIND_DEITY_RUBY1, hero, "agility", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", WIND_DEITY_RUBY2, hero, "attack_speed", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", WIND_DEITY_EMERALD, hero, "element_wind", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", WIND_DEITY_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_wraith_hunters_steel_helm" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", WRAITH_HUNTER_SAPPHIRE, hero, "armor_pierce", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_ancient_tanari_wind_armor" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ANCIENT_TANARI_WIND_ARMOR_GEM_EMERALD, hero, "element_wind", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == 'item_rpc_armor_of_atlantis' then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ARMOR_OF_ATLANTIS_GEM_AMETHYST, hero, "max_health", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_armor_of_secret_temple" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ARMOR_OF_SECRET_TEMPLE_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_avalanche_plate" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_AVALANCHE_PLATE_GEM_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_AVALANCHE_PLATE_GEM_EMERALD, hero, "element_earth", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_AVALANCHE_PLATE_GEM_SAPPHIRE2, hero, "strength", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_blazing_fury_armor" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BLAZING_FURY_ARMOR_GEM_EMERALD1, hero, "agility", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BLAZING_FURY_ARMOR_GEM_EMERALD2, hero, "element_fire", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_bluestar_armor" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_BLUESTAR_ARMOR_GEM_RUBY, hero, "max_health", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_BLUESTAR_ARMOR_GEM_AMETHYST, hero, "mana_regen", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_boreal_granite_vest" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BOREAL_GRANITE_VEST_GEM_EMERALD, hero, "rune_q_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BOREAL_GRANITE_VEST_GEM_EMERALD, hero, "rune_q_2", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BOREAL_GRANITE_VEST_GEM_SAPPHIRE, hero, "rune_q_3", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_champions_mail" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", CHAMPIONS_GEAR_RUBY, hero, "rune_r_1", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", CHAMPIONS_GEAR_EMERALD, hero, "rune_r_3", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", CHAMPIONS_GEAR_SAPPHIRE, hero, "rune_r_2", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", CHAMPIONS_GEAR_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_depth_crest_armor" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_DEPTH_CREST_ARMOR_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_direwolf_bulwark" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_DIREWOLF_BULWARK_GEM_SAPPHIRE, hero, "armor_pierce", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_golden_war_plate" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GOLDEN_WAR_PLATE_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GOLDEN_WAR_PLATE_GEM_EMERALD, hero, "armor", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_gold_plate_of_leon" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_EMERALD, hero, "strength", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_EMERALD, hero, "intelligence", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GOLD_PLATE_OF_LEON_GEM_EMERALD, hero, "spirit", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_heroic_conqueror_vestments" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_RUBY, hero, "rune_q_2", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_RUBY, hero, "rune_q_3", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_RUBY, hero, "rune_q_4", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_EMERALD, hero, "rune_e_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_EMERALD, hero, "rune_e_2", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_SAPPHIRE, hero, "rune_w_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_SAPPHIRE, hero, "rune_w_2", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_SAPPHIRE, hero, "rune_w_3", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_SAPPHIRE, hero, "rune_w_4", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_AMETHYST, hero, "rune_r_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_AMETHYST, hero, "rune_r_2", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_AMETHYST, hero, "rune_r_3", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HEROIC_CONQUEROR_VESTMENTS_GEM_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_ice_quill_carapace" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ICE_QUILL_CARAPACE_GEM_EMERALD2, hero, "max_mana", RPC_GEAR_SLOT_BODY)
		end		
	elseif item:GetAbilityName() == "item_rpc_infused_mageplate" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_INFUSED_MAGEPLATE_GEM_AMETHYST, hero, "strength", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_INFUSED_MAGEPLATE_GEM_AMETHYST, hero, "intelligence", RPC_GEAR_SLOT_BODY)
		end		
	elseif item:GetAbilityName() == "item_rpc_ocean_tempest_pallium" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_OCEAN_TEMPEST_PALLIUM_GEM_SAPPHIRE, hero, "element_water", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_OCEAN_TEMPEST_PALLIUM_GEM_SAPPHIRE, hero, "element_wind", RPC_GEAR_SLOT_BODY)
		end		
	elseif item:GetAbilityName() == "item_rpc_robe_of_the_erudite_teacher" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ROBE_OF_THE_ERUDITE_TEACHER_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_BODY)
		end		
	elseif item:GetAbilityName() == "item_rpc_savage_plate_of_ogthun" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SAVAGE_PLATE_OF_OGTHUN_GEM_AMETHYST, hero, "element_normal", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_seraphic_soulvest" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERAPHIC_SOULVEST_GEM_RUBY2, hero, "strength", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERAPHIC_SOULVEST_GEM_RUBY2, hero, "agility", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERAPHIC_SOULVEST_GEM_RUBY2, hero, "intelligence", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERAPHIC_SOULVEST_GEM_RUBY2, hero, "spirit", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_sorcerers_regalia" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SORCERERS_REGALIA_GEM_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SORCERERS_REGALIA_GEM_RUBY, hero, "rune_w_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SORCERERS_REGALIA_GEM_RUBY, hero, "rune_e_1", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SORCERERS_REGALIA_GEM_RUBY, hero, "rune_r_1", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SORCERERS_REGALIA_GEM_EMERALD, hero, "rune_q_2", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SORCERERS_REGALIA_GEM_EMERALD, hero, "rune_w_2", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SORCERERS_REGALIA_GEM_EMERALD, hero, "rune_e_2", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SORCERERS_REGALIA_GEM_EMERALD, hero, "rune_r_2", RPC_GEAR_SLOT_BODY)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SORCERERS_REGALIA_GEM_SAPPHIRE1, hero, "intelligence", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SORCERERS_REGALIA_GEM_SAPPHIRE2, hero, "spell_pierce", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_space_tech_vest" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SPACE_TECH_VEST_GEM_AMETHYST, hero, "element_cosmic", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_spellslinger_coat" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SPELLSLINGER_COAT_GEM_SAPPHIRE, hero, "mana_regen", RPC_GEAR_SLOT_BODY)
		end
	elseif item:GetAbilityName() == "item_rpc_staggering_knight_crusher_armor" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_STAGGERING_KNIGHT_CRUSHER_ARMOR_GEM_SAPPHIRE2, hero, "armor", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_templar_light_seers_robe" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TEMPLAR_LIGHT_SEERS_ROBE_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TEMPLAR_LIGHT_SEERS_ROBE_GEM_RUBY, hero, "spirit", RPC_GEAR_SLOT_BODY)
		end		
	elseif item:GetAbilityName() == "item_rpc_terrasic_stone_plate" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_RUBY1, hero, "strength", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_RUBY2, hero, "armor", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_RUBY2, hero, "armor_pierce", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_RUBY3, hero, "element_fire", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TERRASIC_STONE_PLATE_GEM_RUBY3, hero, "element_earth", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_the_infernal_prison" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_THE_INFERNAL_PRISON_GEM_SAPPHIRE, hero, "armor", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_THE_INFERNAL_PRISON_GEM_SAPPHIRE, hero, "magic_armor", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_twilight_vestments" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_TWILIGHT_VESTMENTS_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_BODY)
		end			
	elseif item:GetAbilityName() == "item_rpc_vampiric_breastplate" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_VAMPIRIC_BREASTPLATE_GEM_AMETHYST1, hero, "attack_speed", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_VAMPIRIC_BREASTPLATE_GEM_AMETHYST2, hero, "attack_damage", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_vermillion_dream_robes" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_SAPPHIRE1, hero, "base_ability", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_water_mage_robes" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_WATER_MAGE_ROBES_GEM_SAPPHIRE1, hero, "element_water", RPC_GEAR_SLOT_BODY)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_WATER_MAGE_ROBES_GEM_SAPPHIRE2, hero, "spell_pierce", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_aquasteel_bracers" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_AQUASTEEL_BRACERS_GEM_SAPPHIRE1, hero, "armor", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_autumnrock_bracer" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_AUTUMNROCK_BRACER_GEM_RUBY1, hero, "strength", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_AUTUMNROCK_BRACER_GEM_SAPPHIRE2, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
		end		
	elseif item:GetAbilityName() == "item_rpc_bladeforge_gauntlet" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BLADEFORGE_GAUNTLET_GEM_EMERALD1, hero, "armor_pierce", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BLADEFORGE_GAUNTLET_GEM_EMERALD2, hero, "attack_damage", RPC_GEAR_SLOT_GLOVES)
		end		
	elseif item:GetAbilityName() == "item_rpc_blue_rain_gauntlet" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_RUBY1, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_RUBY2, hero, "strength", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_RUBY2, hero, "agility", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_RUBY2, hero, "intelligence", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_BLUE_RAIN_GAUNTLET_GEM_RUBY2, hero, "spirit", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_buzukis_finger" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BUZUKIS_FINGER_GEM_SAPPHIRE, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_claw_of_azinoth" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_q_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_q_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_q_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_w_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_w_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_w_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_e_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_e_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_r_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_r_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAW_OF_AZINOTH_GEM_EMERALD, hero, "rune_r_3", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_claws_of_the_ethereal_revenant" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_GEM_EMERALD2, hero, "armor_pierce", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CLAWS_OF_THE_ETHEREAL_REVENANT_GEM_EMERALD2, hero, "spell_pierce", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_cytopian_laser_glove" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_CYTOPIAN_LASER_GLOVE_GEM_SAPPHIRE2, hero, "mana_regen", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_dark_emissary_glove" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_DARK_EMISSARY_GLOVE_GEM_RUBY2, hero, "spell_pierce", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_DARK_EMISSARY_GLOVE_GEM_SAPPHIRE, hero, "element_ghost", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_DARK_EMISSARY_GLOVE_GEM_SAPPHIRE, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_diamond_claws_of_tiamat" then	
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_DIAMOND_CLAWS_OF_TIAMAT_GEM_RUBY, hero, "rune_q_4", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_DIAMOND_CLAWS_OF_TIAMAT_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_DIAMOND_CLAWS_OF_TIAMAT_GEM_SAPPHIRE, hero, "rune_w_4", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_DIAMOND_CLAWS_OF_TIAMAT_GEM_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_energy_whip_glove" then	
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ENERGY_WHIP_GLOVE_GEM_RUBY, hero, "rune_w_1", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ENERGY_WHIP_GLOVE_GEM_EMERALD, hero, "rune_w_3", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ENERGY_WHIP_GLOVE_GEM_SAPPHIRE, hero, "rune_w_2", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ENERGY_WHIP_GLOVE_GEM_AMETHYST, hero, "rune_w_4", RPC_GEAR_SLOT_GLOVES)
		end			
	elseif item:GetAbilityName() == "item_rpc_eternal_essence_gauntlet" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ETERNAL_ESSENCE_GAUNTLET_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_GLOVES)
		end			
	elseif item:GetAbilityName() == "item_rpc_far_seers_enchanted_gloves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_GEM_RUBY2, hero, "spell_pierce", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_FAR_SEERS_ENCHANTED_GLOVES_GEM_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_GLOVES)
		end		
	elseif item:GetAbilityName() == "item_rpc_frostburn_gauntlets" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_FROSTBURN_GAUNTLETS_GEM_SAPPHIRE2, hero, "mana_regen", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_gauntlet_of_champions" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", CHAMPIONS_GEAR_RUBY, hero, "rune_w_1", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", CHAMPIONS_GEAR_EMERALD, hero, "rune_w_3", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", CHAMPIONS_GEAR_SAPPHIRE, hero, "rune_w_2", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", CHAMPIONS_GEAR_AMETHYST, hero, "rune_w_4", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_gauntlet_of_divine_purity" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GAUNTLET_OF_DIVINE_PURITY_GEM_RUBY, hero, "armor", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GAUNTLET_OF_DIVINE_PURITY_GEM_RUBY, hero, "magic_armor", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GAUNTLET_OF_DIVINE_PURITY_GEM_EMERALD, hero, "element_holy", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_GAUNTLET_OF_DIVINE_PURITY_GEM_SAPPHIRE, hero, "attack_damage", RPC_GEAR_SLOT_GLOVES)
		end		
	elseif item:GetAbilityName() == "item_rpc_glove_of_the_forgotten_ghost" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GLOVE_OF_THE_FORGOTTEN_GHOST_GEM_RUBY, hero, "element_ghost", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GLOVE_OF_THE_FORGOTTEN_GHOST_GEM_RUBY, hero, "base_ability", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_GLOVE_OF_THE_FORGOTTEN_GHOST_GEM_AMETHYST, hero, "element_ghost", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_GLOVE_OF_THE_FORGOTTEN_GHOST_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_goldbreaker_gauntlet" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_GOLDBREAKER_GAUNTLET_GEM_SAPPHIRE1, hero, "attack_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_grand_arcanist_wraps" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GRAND_ARCANIST_WRAPS_GEM_RUBY1, hero, "intelligence", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GRAND_ARCANIST_WRAPS_GEM_RUBY2, hero, "mana_regen", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GRAND_ARCANIST_WRAPS_GEM_RUBY3, hero, "spell_pierce", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_grasp_of_elder" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_GRASP_OF_ELDER_GEM_SAPPHIRE1, hero, "spirit", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_halcyon_soul_glove" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_EMERALD, hero, "rune_q_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_EMERALD, hero, "rune_w_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_EMERALD, hero, "rune_r_3", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_SAPPHIRE, hero, "strength", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_SAPPHIRE, hero, "agility", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_SAPPHIRE, hero, "spirit", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_q_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_w_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_e_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_r_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_q_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_w_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_e_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HALCYON_SOUL_GLOVE_GEM_AMETHYST, hero, "rune_r_2", RPC_GEAR_SLOT_GLOVES)
		end			
	elseif item:GetAbilityName() == "item_rpc_hand_of_midas" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HAND_OF_MIDAS_GEM_AMETHYST1, hero, "attack_speed", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_HAND_OF_MIDAS_GEM_AMETHYST2, hero, "attack_damage", RPC_GEAR_SLOT_GLOVES)
		end			
	elseif item:GetAbilityName() == "item_rpc_heavy_echo_gauntlet" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HEAVY_ECHO_GAUNTLET_GEM_EMERALD, hero, "base_ability", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_HEAVY_ECHO_GAUNTLET_GEM_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_ironbound_gloves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_IRONBOUND_GLOVES_GEM_RUBY, hero, "element_normal", RPC_GEAR_SLOT_GLOVES)
		end		
	elseif item:GetAbilityName() == "item_rpc_kappa_pride_gloves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_KAPPA_PRIDE_GLOVES_GEM_RUBY, hero, "all_elements", RPC_GEAR_SLOT_GLOVES)
		end		
	elseif item:GetAbilityName() == "item_rpc_magebane_gloves" then	
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MAGEBANE_GLOVES_GEM_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MAGEBANE_GLOVES_GEM_RUBY, hero, "rune_w_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MAGEBANE_GLOVES_GEM_RUBY, hero, "rune_e_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MAGEBANE_GLOVES_GEM_RUBY, hero, "rune_r_1", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_MAGEBANE_GLOVES_GEM_EMERALD, hero, "rune_q_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_MAGEBANE_GLOVES_GEM_EMERALD, hero, "rune_w_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_MAGEBANE_GLOVES_GEM_EMERALD, hero, "rune_e_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_MAGEBANE_GLOVES_GEM_EMERALD, hero, "rune_r_2", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_MAGEBANE_GLOVES_GEM_SAPPHIRE, hero, "rune_q_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_MAGEBANE_GLOVES_GEM_SAPPHIRE, hero, "rune_w_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_MAGEBANE_GLOVES_GEM_SAPPHIRE, hero, "rune_e_1", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_MAGEBANE_GLOVES_GEM_SAPPHIRE, hero, "rune_r_1", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MAGEBANE_GLOVES_GEM_AMETHYST, hero, "rune_q_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MAGEBANE_GLOVES_GEM_AMETHYST, hero, "rune_w_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MAGEBANE_GLOVES_GEM_AMETHYST, hero, "rune_e_2", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MAGEBANE_GLOVES_GEM_AMETHYST, hero, "rune_r_2", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_marauder_gloves" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MARAUDER_GLOVES_GEM_AMETHYST, hero, "attack_speed", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MARAUDER_GLOVES_GEM_AMETHYST, hero, "movespeed", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_master_gloves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MASTER_GLOVES_GEM_RUBY, hero, "rune_r_1", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_MASTER_GLOVES_GEM_EMERALD, hero, "rune_r_3", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_MASTER_GLOVES_GEM_SAPPHIRE, hero, "rune_r_2", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MASTER_GLOVES_GEM_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_mordiggus_gauntlet" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MORDIGGUS_GAUNTLET_GEM_RUBY, hero, "max_health", RPC_GEAR_SLOT_GLOVES)
		end		
	elseif item:GetAbilityName() == "item_rpc_mountain_vambraces" then		
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MOUNTAIN_VAMBRACES_GEM_RUBY1, hero, "strength", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MOUNTAIN_VAMBRACES_GEM_RUBY2, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_phoenix_gloves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_PHOENIX_GLOVES_GEM_RUBY, hero, "attack_speed", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_PHOENIX_GLOVES_GEM_EMERALD1, hero, "agility", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_PHOENIX_GLOVES_GEM_AMETHYST1, hero, "spirit", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_power_ranger_gloves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_POWER_RANGER_GLOVES_GEM_RUBY, hero, "armor", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_POWER_RANGER_GLOVES_GEM_EMERALD, hero, "armor_pierce", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_POWER_RANGER_GLOVES_GEM_SAPPHIRE, hero, "spell_pierce", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_POWER_RANGER_GLOVES_GEM_AMETHYST, hero, "magic_armor", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_scarecrow_gloves" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SCARECROW_GLOVES_GEM_SAPPHIRE1, hero, "intelligence", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_scorched_gauntlets" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_EMERALD1, hero, "armor", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SCORCHED_GAUNTLETS_GEM_AMETHYST1, hero, "attack_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_shadow_armlet" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SHADOW_ARMLET_GEM_EMERALD, hero, "element_shadow", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SHADOW_ARMLET_GEM_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_spellfire_gloves" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SPELLFIRE_GLOVES_GEM_SAPPHIRE, hero, "rune_q_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SPELLFIRE_GLOVES_GEM_SAPPHIRE, hero, "rune_w_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SPELLFIRE_GLOVES_GEM_SAPPHIRE, hero, "rune_e_3", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SPELLFIRE_GLOVES_GEM_SAPPHIRE, hero, "rune_r_3", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_spirit_glove" then	
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SPIRIT_GLOVE_GEM_AMETHYST1, hero, "spirit", RPC_GEAR_SLOT_GLOVES)
		end
	elseif item:GetAbilityName() == "item_rpc_admiral_boots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ADMIRAL_BOOTS_GEM_RUBY, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ADMIRAL_BOOTS_GEM_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ADMIRAL_BOOTS_GEM_SAPPHIRE, hero, "rune_e_2", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ADMIRAL_BOOTS_GEM_AMETHYST, hero, "rune_e_4", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_alaranas_ice_boot" then	
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ALARANAS_ICE_BOOT_GEM_RUBY1, hero, "max_health", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ALARANAS_ICE_BOOT_GEM_RUBY2, hero, "intelligence", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_arcanys_slipper" then	
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ARCANYS_SLIPPER_GEM_SAPPHIRE, hero, "max_mana", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ARCANYS_SLIPPER_GEM_AMETHYST1, hero, "intelligence", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ARCANYS_SLIPPER_GEM_AMETHYST2, hero, "element_arcane", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_blue_dragon_greaves" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_BLUE_DRAGON_GREAVES_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_BLUE_DRAGON_GREAVES_GEM_AMETHYST, hero, "element_dragon", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_boots_of_ashara" then	
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BOOTS_OF_ASHARA_GEM_SAPPHIRE, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BOOTS_OF_ASHARA_GEM_SAPPHIRE, hero, "rune_e_2", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BOOTS_OF_ASHARA_GEM_SAPPHIRE, hero, "rune_e_3", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BOOTS_OF_ASHARA_GEM_SAPPHIRE, hero, "rune_e_4", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_boots_of_champions" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", CHAMPIONS_GEAR_RUBY, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", CHAMPIONS_GEAR_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", CHAMPIONS_GEAR_SAPPHIRE, hero, "rune_e_2", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", CHAMPIONS_GEAR_AMETHYST, hero, "rune_e_4", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_boots_of_old_wisdom" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BOOTS_OF_OLD_WISDOM_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_BOOTS_OF_OLD_WISDOM_GEM_EMERALD, hero, "intelligence", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_boots_of_the_violet_guard" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_BOOTS_OF_THE_VIOLET_GUARD_GEM_RUBY2, hero, "attack_speed", RPC_GEAR_SLOT_BOOTS)
		end
	elseif item:GetAbilityName() == "item_rpc_crusader_boots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_CRUSADER_BOOTS_GEM_RUBY1, hero, "strength", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_CRUSADER_BOOTS_GEM_AMETHYST1, hero, "amethyst", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_emerald_speed_runners" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_EMERALD_SPEED_RUNNERS_GEM_EMERALD1, hero, "agility", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_falcon_boots" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_FALCON_BOOTS_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_FALCON_BOOTS_GEM_EMERALD, hero, "intelligence", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_FALCON_BOOTS_GEM_SAPPHIRE1, hero, "attack_speed", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_gravelfoot_treads" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GRAVELFOOT_TREADS_GEM_RUBY1, hero, "max_health", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GRAVELFOOT_TREADS_GEM_RUBY2, hero, "strength", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GRAVELFOOT_TREADS_GEM_RUBY2, hero, "spirit", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_guardian_greaves" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_GUARDIAN_GREAVES_GEM_SAPPHIRE, hero, "strength", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_GUARDIAN_GREAVES_GEM_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_ice_floe_slippers"then	
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ICE_FLOE_SLIPPERS_GEM_EMERALD1, hero, "rune_e_4", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ICE_FLOE_SLIPPERS_GEM_SAPPHIRE1, hero, "base_ability", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ICE_FLOE_SLIPPERS_GEM_SAPPHIRE1, hero, "element_ice", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_iron_treads_of_destruction" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_EMERALD, hero, "rune_r_1", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_EMERALD, hero, "rune_r_2", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_EMERALD, hero, "rune_r_3", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_IRON_TREADS_OF_DESTRUCTION_GEM_EMERALD, hero, "rune_r_4", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_mana_striders" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_MANA_STRIDERS_GEM_EMERALD1, hero, "max_mana", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_MANA_STRIDERS_GEM_SAPPHIRE1, hero, "intelligence", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MANA_STRIDERS_GEM_AMETHYST1, hero, "base_ability", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_moon_tech_runners" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MOON_TECH_RUNNERS_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MOON_TECH_RUNNERS_GEM_AMETHYST, hero, "element_cosmic", RPC_GEAR_SLOT_BOOTS)
		end			
	elseif item:GetAbilityName() == "item_rpc_neptunes_water_gliders" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_AMETHYST, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_AMETHYST, hero, "rune_e_2", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_AMETHYST, hero, "rune_e_3", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_NEPTUNES_WATER_GLIDERS_GEM_AMETHYST, hero, "rune_e_4", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_oceanrunner_boots" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_OCEANRUNNER_BOOTS_GEM_EMERALD1, hero, "agility", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_OCEANRUNNER_BOOTS_GEM_EMERALD2, hero, "movespeed", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_pivotal_swiftboots" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_PIVOTAL_SWIFTBOOTS_GEM_SAPPHIRE, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)		
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_PIVOTAL_SWIFTBOOTS_GEM_SAPPHIRE, hero, "rune_e_2", RPC_GEAR_SLOT_BOOTS)
		end
	elseif item:GetAbilityName() == "item_rpc_redfall_runners" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_REDFALL_RUNNERS_GEM_AMETHYST, hero, "agility", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_REDFALL_RUNNERS_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_BOOTS)
		end
	elseif item:GetAbilityName() == "item_rpc_red_october_boots" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_EMERALD, hero, "rune_e_3", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_AMETHYST2, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_RED_OCTOBER_BOOTS_GEM_AMETHYST2, hero, "rune_e_2", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_resplendent_rubber_boots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_RESPLENDENT_RUBBER_BOOTS_GEM_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_RESPLENDENT_RUBBER_BOOTS_GEM_EMERALD, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_RESPLENDENT_RUBBER_BOOTS_GEM_SAPPHIRE, hero, "rune_w_1", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_RESPLENDENT_RUBBER_BOOTS_GEM_AMETHYST, hero, "rune_r_1", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_sange_boots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SANGE_BOOTS_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SANGE_BOOTS_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_slinger_boots" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SLINGER_BOOTS_GEM_SAPPHIRE1, hero, "attack_damage", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SLINGER_BOOTS_GEM_AMETHYST1, hero, "armor_pierce", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_steamboots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_STEAMBOOTS_GEM_RUBY, hero, "rune_q_3", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_STEAMBOOTS_GEM_RUBY, hero, "rune_w_3", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_STEAMBOOTS_GEM_RUBY, hero, "rune_e_3", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_STEAMBOOTS_GEM_RUBY, hero, "rune_r_3", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_STEAMBOOTS_GEM_EMERALD1, hero, "agility", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_STEAMBOOTS_GEM_EMERALD2, hero, "item_damage", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_STEAMBOOTS_GEM_AMETHYST, hero, "rune_e_1", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_STEAMBOOTS_GEM_AMETHYST, hero, "rune_e_2", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_storm_pacer_sabatons" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_STORM_PACER_SABATONS_GEM_SAPPHIRE, hero, "all_elements", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_temporal_warp_boots" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_TEMPORAL_WARP_BOOTS_GEM_EMERALD, hero, "element_time", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_TEMPORAL_WARP_BOOTS_GEM_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_BOOTS)
		end			
	elseif item:GetAbilityName() == "item_rpc_terrasic_lava_boots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TERRASIC_LAVA_BOOTS_GEM_RUBY, hero, "element_fire", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TERRASIC_LAVA_BOOTS_GEM_RUBY, hero, "item_damage", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_tranquil_boots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TRANQUIL_BOOTS_GEM_RUBY1, hero, "max_health", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_TRANQUIL_BOOTS_GEM_SAPPHIRE1, hero, "max_health", RPC_GEAR_SLOT_BOOTS)
		end
	elseif item:GetAbilityName() == "item_rpc_yasha_boots" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_YASHA_BOOTS_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_BOOTS)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_YASHA_BOOTS_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_BOOTS)
		end		
	elseif item:GetAbilityName() == "item_rpc_aeriths_tear" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_AERITHS_TEAR_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_ancient_tanari_waterstone" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ANCIENT_TANARI_WATERSTONE_GEM_RUBY1, hero, "max_health", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ANCIENT_TANARI_WATERSTONE_GEM_RUBY2, hero, "max_mana", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ANCIENT_TANARI_WATERSTONE_GEM_SAPPHIRE, hero, "element_water", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ANCIENT_TANARI_WATERSTONE_GEM_SAPPHIRE, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ANCIENT_TANARI_WATERSTONE_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_antique_mana_relic" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ANTIQUE_MANA_RELIC_GEM_SAPPHIRE1, hero, "max_mana", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ANTIQUE_MANA_RELIC_GEM_SAPPHIRE2, hero, "mana_regen", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_aqua_lily" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_AQUA_LILY_GEM_SAPPHIRE, hero, "rune_r_4", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_aquastone_ring" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_AQUASTONE_RING_GEM_RUBY, hero, "rune_q_4", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_AQUASTONE_RING_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_AQUASTONE_RING_GEM_SAPPHIRE, hero, "rune_w_4", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_AQUASTONE_RING_GEM_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_arbor_dragonfly" then		
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ARBOR_DRAGONFLY_GEM_RUBY, hero, "rune_q_1", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ARBOR_DRAGONFLY_GEM_RUBY, hero, "rune_w_1", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ARBOR_DRAGONFLY_GEM_RUBY, hero, "rune_e_1", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ARBOR_DRAGONFLY_GEM_RUBY, hero, "rune_r_1", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ARBOR_DRAGONFLY_GEM_EMERALD, hero, "base_ability", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_ARBOR_DRAGONFLY_GEM_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ARBOR_DRAGONFLY_GEM_SAPPHIRE, hero, "rune_q_2", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ARBOR_DRAGONFLY_GEM_SAPPHIRE, hero, "rune_w_2", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ARBOR_DRAGONFLY_GEM_SAPPHIRE, hero, "rune_e_2", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ARBOR_DRAGONFLY_GEM_SAPPHIRE, hero, "rune_r_2", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ARBOR_DRAGONFLY_GEM_AMETHYST, hero, "all_attributes", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_arcane_charm" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ARCANE_CHARM_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_ARCANE_CHARM_GEM_AMETHYST, hero, "element_arcane", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_auric_ring_of_inspiration" then	
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_AURIC_RING_OF_INSPIRATION_GEM_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_AURIC_RING_OF_INSPIRATION_GEM_EMERALD, hero, "element_holy", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_beryl_ring_of_intuition" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BERYL_RING_OF_INTUITION_GEM_SAPPHIRE, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_BERYL_RING_OF_INTUITION_GEM_SAPPHIRE, hero, "element_ice", RPC_GEAR_SLOT_TRINKET)
		end			
	elseif item:GetAbilityName() == "item_rpc_cobalt_serenity_ring" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_COBALT_SERENITY_RING_GEM_RUBY, hero, "max_health", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_COBALT_SERENITY_RING_GEM_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_TRINKET)
		end
	elseif item:GetAbilityName() == "item_rpc_conquest_stone_falcon" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_CONQUEST_STONE_FALCON_GEM_RUBY, hero, "armor", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_CONQUEST_STONE_FALCON_GEM_EMERALD, hero, "armor_pierce", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_CONQUEST_STONE_FALCON_GEM_SAPPHIRE, hero, "spell_pierce", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_CONQUEST_STONE_FALCON_GEM_AMETHYST, hero, "magic_armor", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_emerald_nullification_ring" then	
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_EMERALD_NULLIFICATION_RING_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_epsilons_eyeglass" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_EPSILONS_EYEGLASS_GEM_AMETHYST, hero, "element_cosmic", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_EPSILONS_EYEGLASS_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_fenrirs_fang" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_FENRIRS_FANG_GEM_AMETHYST1, hero, "movespeed", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_FENRIRS_FANG_GEM_AMETHYST2, hero, "attack_speed", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_fire_blossom" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_FIRE_BLOSSOM_GEM_RUBY, hero, "rune_w_4", RPC_GEAR_SLOT_TRINKET)
		end
	elseif item:GetAbilityName() == "item_rpc_firelock_pendant" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_FIRELOCK_PENDANT_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_FIRELOCK_PENDANT_GEM_RUBY, hero, "agility", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_FIRELOCK_PENDANT_GEM_EMERALD, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_FIRELOCK_PENDANT_GEM_EMERALD, hero, "element_fire", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_fractional_enhancement_geode" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_FRACTIONAL_ENHANCEMENT_GEODE_GEM_SAPPHIRE, hero, "all_elements", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_FRACTIONAL_ENHANCEMENT_GEODE_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_fuchsia_ring" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_FUCHSIA_RING_GEM_AMETHYST, hero, "strength", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_FUCHSIA_RING_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_galaxy_orb" then	
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_GALAXY_ORB_GEM_AMETHYST, hero, "element_cosmic", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_GALAXY_ORB_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_garnet_warfare_ring" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_GARNET_WARFARE_RING_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GARNET_WARFARE_RING_GEM_EMERALD, hero, "armor", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GARNET_WARFARE_RING_GEM_EMERALD, hero, "armor_pierce", RPC_GEAR_SLOT_TRINKET)
		end
	elseif item:GetAbilityName() == "item_rpc_gem_of_eternal_frost" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_GEM_OF_ETERNAL_FROST_GEM_SAPPHIRE, hero, "element_ice", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_GEM_OF_ETERNAL_FROST_GEM_SAPPHIRE, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		end
	elseif item:GetAbilityName() == "item_rpc_guardian_stone" then	
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_GUARDIAN_STONE_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_lifesource_vessel" then	
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_LIFESOURCE_VESSEL_GEM_AMETHYST, hero, "all_attributes", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_monkey_paw" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_MONKEY_PAW_GEM_RUBY, hero, "attack_power", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_MONKEY_PAW_GEM_EMERALD, hero, "base_ability", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_MONKEY_PAW_GEM_SAPPHIRE, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_MONKEY_PAW_GEM_AMETHYST, hero, "all_elements", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_omega_ruby" then	
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_OMEGA_RUBY_GEM_EMERALD, hero, "attack_speed", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_OMEGA_RUBY_GEM_SAPPHIRE, hero, "attack_power", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_OMEGA_RUBY_GEM_AMETHYST, hero, "armor_pierce", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_OMEGA_RUBY_GEM_AMETHYST, hero, "spell_pierce", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_phoenix_emblem" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_PHOENIX_EMBLEM_GEM_RUBY1, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_PHOENIX_EMBLEM_GEM_EMERALD1, hero, "max_health", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_puzzlers_locket" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_PUZZLERS_LOCKET_GEM_RUBY, hero, "rune_q_2", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_PUZZLERS_LOCKET_GEM_EMERALD, hero, "rune_e_2", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_PUZZLERS_LOCKET_GEM_SAPPHIRE, hero, "rune_w_2", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_PUZZLERS_LOCKET_GEM_AMETHYST, hero, "rune_r_2", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_raven_idol" then		
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_RAVEN_IDOL_GEM_EMERALD2, hero, "base_ability", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_RAVEN_IDOL_GEM_EMERALD3, hero, "attack_power", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_RAVEN_IDOL_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_RAVEN_IDOL_GEM_AMETHYST, hero, "element_shadow", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_ring_of_nobility_augmented" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_RING_OF_NOBILITY_AUGMENTED_GEM_RUBY, hero, "all_t1_runes", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_RING_OF_NOBILITY_AUGMENTED_GEM_EMERALD, hero, "all_t3_runes", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_RING_OF_NOBILITY_AUGMENTED_GEM_SAPPHIRE, hero, "all_t2_runes", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_RING_OF_NOBILITY_AUGMENTED_GEM_AMETHYST, hero, "all_t4_runes", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_sapphire_lotus" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SAPPHIRE_LOTUS_GEM_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_serengaard_sun_crystal" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_RUBY, hero, "element_fire", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_RUBY, hero, "element_earth", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_RUBY, hero, "element_lightning", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_RUBY, hero, "element_poison", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_EMERALD, hero, "element_arcane", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_EMERALD, hero, "element_shadow", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_EMERALD, hero, "element_wind", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_EMERALD, hero, "element_ghost", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_SAPPHIRE, hero, "element_time", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_SAPPHIRE, hero, "element_holy", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_SAPPHIRE, hero, "element_cosmic", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_SAPPHIRE, hero, "element_ice", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_AMETHYST, hero, "element_water", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_AMETHYST, hero, "element_demon", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_AMETHYST, hero, "element_nature", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_AMETHYST, hero, "element_undead", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SERENGAARD_SUN_CRYSTAL_GEM_AMETHYST, hero, "element_dragon", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_sparkling_token_of_oceanis" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_RUBY1, hero, "max_health", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_SPARKLING_TOKEN_OF_OCEANIS_GEM_RUBY2, hero, "max_mana", RPC_GEAR_SLOT_TRINKET)
		end			
	elseif item:GetAbilityName() == "item_rpc_stargazers_sphere" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_STARGAZERS_SPHERE_GEM_AMETHYST, hero, "element_cosmic", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_STARGAZERS_SPHERE_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_tempest_falcon_ring" then	
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_TEMPEST_FALCON_RING_GEM_RUBY1, hero, "movespeed", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_TEMPEST_FALCON_RING_GEM_EMERALD1, hero, "attack_speed", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_TEMPEST_FALCON_RING_GEM_EMERALD2, hero, "agility", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_TEMPEST_FALCON_RING_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_TEMPEST_FALCON_RING_GEM_AMETHYST, hero, "element_wind", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_torch_of_gengar" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_TORCH_OF_GENGAR_GEM_AMETHYST, hero, "element_ghost", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_TORCH_OF_GENGAR_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_twig_of_the_enlightened" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_TWIG_OF_THE_ENLIGHTENED_GEM_AMETHYST, hero, "mana_regen", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_volcano_orb" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_VOLCANO_ORB_GEM_RUBY, hero, "strength", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_VOLCANO_ORB_GEM_EMERALD, hero, "agility", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_VOLCANO_ORB_GEM_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_VOLCANO_ORB_GEM_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_TRINKET)
		end
	elseif item:GetAbilityName() == "item_rpc_wind_orchid" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_WIND_ORCHID_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_winterblight_skull_ring" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_WINTERBLIGHT_SKULL_RING_GEM_RUBY, hero, "rune_q_4", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_WINTERBLIGHT_SKULL_RING_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_WINTERBLIGHT_SKULL_RING_GEM_SAPPHIRE, hero, "rune_w_4", RPC_GEAR_SLOT_TRINKET)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_WINTERBLIGHT_SKULL_RING_GEM_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_TRINKET)
		end	
	elseif item:GetAbilityName() == "item_rpc_world_trees_flower_cache" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_WORLD_TREES_FLOWER_CACHE_GEM_AMETHYST, hero, "element_nature", RPC_GEAR_SLOT_TRINKET)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_WORLD_TREES_FLOWER_CACHE_GEM_AMETHYST, hero, "item_damage", RPC_GEAR_SLOT_TRINKET)
		end		
	elseif item:GetAbilityName() == "item_rpc_plague_emperor_armor" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_PLAGUE_EMPEROR_ARMOR_GEM_RUBY1, hero, "element_poison", RPC_GEAR_SLOT_BODY)
		end	
	elseif item:GetAbilityName() == "item_rpc_justice_greaves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_JUSTICE_GREAVES_GEM_RUBY1, hero, "strength", RPC_GEAR_SLOT_BOOTS)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_JUSTICE_GREAVES_GEM_RUBY2, hero, "max_health", RPC_GEAR_SLOT_BOOTS)
		end	
	elseif item:GetAbilityName() == "item_rpc_angelic_gloves_of_the_judiciary" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ANGELIC_GLOVES_OF_THE_JUDICIARY_GEM_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_ANGELIC_GLOVES_OF_THE_JUDICIARY_GEM_SAPPHIRE, hero, "spirit", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_demonic_gloves_of_the_judiciary" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_DEMONIC_GLOVES_OF_THE_JUDICIARY_GEM_SAPPHIRE, hero, "strength", RPC_GEAR_SLOT_GLOVES)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_DEMONIC_GLOVES_OF_THE_JUDICIARY_GEM_SAPPHIRE, hero, "agility", RPC_GEAR_SLOT_GLOVES)
		end	
	elseif item:GetAbilityName() == "item_rpc_sun_gods_visage" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SUN_GODS_VISAGE_AMETHYST1, hero, "max_health", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_SUN_GODS_VISAGE_AMETHYST2, hero, "element_fire", RPC_GEAR_SLOT_HEAD)
		end		
	elseif item:GetAbilityName() == "item_rpc_zombiegrip_gauntlet" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_ZOMBIEGRIP_GAUNTLET_GEM_RUBY1, hero, "element_undead", RPC_GEAR_SLOT_GLOVES)
		end
	elseif item:GetAbilityName() == "item_rpc_world_commander_gloves" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ITEM_RPC_WORLD_COMMANDER_GLOVES_GEM_RUBY, hero, "rune_q_4", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_WORLD_COMMANDER_GLOVES_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ITEM_RPC_WORLD_COMMANDER_GLOVES_GEM_SAPPHIRE, hero, "rune_w_4", RPC_GEAR_SLOT_GLOVES)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", ITEM_RPC_WORLD_COMMANDER_GLOVES_GEM_AMETHYST, hero, "rune_r_4", RPC_GEAR_SLOT_GLOVES)
		end
	elseif item:GetAbilityName() == "item_rpc_grey_domain_greaves" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ITEM_RPC_GREY_DOMAIN_GREAVES_GEM_EMERALD, hero, "rune_e_4", RPC_GEAR_SLOT_BOOTS)
		end
	end
end

function RPCItems:RecordSpecificGemBonusForImmortalItem(item, gem_name, value_table, hero, property_name, gear_slot)
	local gem_value = item:GetGemValue(gem_name)
	if gem_value > 0 then
		--DeepPrintTable(value_table)
		local property_value = item:GetFinalGemPropertyValue(gem_name, value_table)
		if property_value > 0 then
			RPCItems:RecordGearBonusToHeroBySlot(item, hero, property_name, property_value, gear_slot)
		end
	end
end

function RPCItems:SpecialGearInitialization(item, hero, gear_slot)
	if item:GetAbilityName() == "item_rpc_dragon_ceremony_vestments" then
		hero.gear_bonuses[gear_slot]["!immortal!_modifier_dragon_ceremony_vestments"] = 1
	elseif item:GetAbilityName() == "item_rpc_winterblight_skull_ring" then
		hero.gear_bonuses[gear_slot]["!immortal!_modifier_winterblight_skull_ring"] = 1
	end
end

function CDOTA_BaseNPC_Hero:ReequipAllGear(ignore_slot)
	if self.equipped_gear then
		if ignore_slot ~= RPC_GEAR_SLOT_HEAD then
			--print("REEQUIP 3")
			if self.equipped_gear[RPC_GEAR_SLOT_HEAD] then
				--print("REEQUIP 4")
				self:EquipItem(self.equipped_gear[RPC_GEAR_SLOT_HEAD], false, false)
			end
		end
		if ignore_slot ~= RPC_GEAR_SLOT_BODY then
			if self.equipped_gear[RPC_GEAR_SLOT_BODY] then
				self:EquipItem(self.equipped_gear[RPC_GEAR_SLOT_BODY], false, false)
			end
		end
		if ignore_slot ~= RPC_GEAR_SLOT_WEAPON then
			if self.equipped_gear[RPC_GEAR_SLOT_WEAPON] then
				self:EquipItem(self.equipped_gear[RPC_GEAR_SLOT_WEAPON], false, false)
			end
		end
		if ignore_slot ~= RPC_GEAR_SLOT_GLOVES then
			if self.equipped_gear[RPC_GEAR_SLOT_GLOVES] then
				self:EquipItem(self.equipped_gear[RPC_GEAR_SLOT_GLOVES], false, false)
			end
		end
		if ignore_slot ~= RPC_GEAR_SLOT_BOOTS then
			if self.equipped_gear[RPC_GEAR_SLOT_BOOTS] then
				self:EquipItem(self.equipped_gear[RPC_GEAR_SLOT_BOOTS], false, false)
			end
		end
		if ignore_slot ~= RPC_GEAR_SLOT_TRINKET then
			if self.equipped_gear[RPC_GEAR_SLOT_TRINKET] then
				self:EquipItem(self.equipped_gear[RPC_GEAR_SLOT_TRINKET], false, false)
			end
		end
	end
end

function RPCItems:AdjustPropertyValueForHarvester(hero, item, property_value, property_name)
	local mult = 0
	if item.newItemTable.property1 == property_value and item.newItemTable.property1name == property_name then
		mult = item:GetFinalGemPropertyValue("ruby", ITEM_RPC_HARVESTER_BOOTS_GEM_RUBY)/100
	elseif item.newItemTable.property2 == property_value and item.newItemTable.property2name == property_name then
		mult = item:GetFinalGemPropertyValue("sapphire", ITEM_RPC_HARVESTER_BOOTS_GEM_SAPPHIRE)/100
	elseif item.newItemTable.property3 == property_value and item.newItemTable.property3name == property_name then
		mult = item:GetFinalGemPropertyValue("emerald", ITEM_RPC_HARVESTER_BOOTS_GEM_EMERALD)/100
	elseif item.newItemTable.property4 == property_value and item.newItemTable.property4name == property_name then
		mult = item:GetFinalGemPropertyValue("amethyst", ITEM_RPC_HARVESTER_BOOTS_GEM_AMETHYST)/100
	end
	return mult
end

function RPCItems:AdjustPropertyValueForBlacksmithTablet(hero, item, property_value, property_name)
	local mult = 0
	if item.newItemTable.property1 == property_value and item.newItemTable.property1name == property_name then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_BLACKSMITHS_TABLET_GEM_RUBY)/100
	elseif item.newItemTable.property2 == property_value and item.newItemTable.property2name == property_name then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_BLACKSMITHS_TABLET_GEM_SAPPHIRE)/100
	elseif item.newItemTable.property3 == property_value and item.newItemTable.property3name == property_name then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_BLACKSMITHS_TABLET_GEM_EMERALD)/100
	elseif item.newItemTable.property4 == property_value and item.newItemTable.property4name == property_name then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_BLACKSMITHS_TABLET_GEM_AMETHYST)/100
	end
	return mult
end

function RPCItems:AdjustPropertyValueForPaladinGlyph22()
	local mult = PALADIN_GLYPH_2_2_WEAPON_BONUS_PCT/100
	-- if item.newItemTable.property1 == property_value and item.newItemTable.property1name == property_name then
	-- 	mult = PALADIN_GLYPH_2_2_WEAPON_BONUS_PCT/100
	-- elseif item.newItemTable.property2 == property_value and item.newItemTable.property2name == property_name then
	-- 	mult = PALADIN_GLYPH_2_2_WEAPON_BONUS_PCT/100
	-- elseif item.newItemTable.property3 == property_value and item.newItemTable.property3name == property_name then
	-- 	mult = PALADIN_GLYPH_2_2_WEAPON_BONUS_PCT/100
	-- elseif item.newItemTable.property4 == property_value and item.newItemTable.property4name == property_name then
	-- 	mult = PALADIN_GLYPH_2_2_WEAPON_BONUS_PCT/100
	-- end
	return mult
end

function RPCItems:GetMultForDreamRobes(hero, item, property_value, property_name)
	local mult = 0
	if property_name == "rune_q_1" or property_name == "rune_q_2" or property_name == "rune_q_3" or property_name == "rune_q_4" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_EMERALD)/100
	elseif property_name == "rune_w_1" or property_name == "rune_w_2" or property_name == "rune_w_3" or property_name == "rune_w_4" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_EMERALD)/100
	elseif property_name == "rune_e_1" or property_name == "rune_e_2" or property_name == "rune_e_3" or property_name == "rune_e_4" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_EMERALD)/100
	elseif property_name == "rune_r_1" or property_name == "rune_r_2" or property_name == "rune_r_3" or property_name == "rune_r_4" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_EMERALD)/100
	elseif property_name == "all_t1_runes" or property_name == "all_t2_runes" or property_name == "all_t3_runes" or property_name == "all_t4_runes" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_BODY]:GetFinalGemPropertyValue("emerald", ITEM_RPC_VERMILLION_DREAM_ROBES_GEM_EMERALD)/100
	end
	return mult
end

function RPCItems:BonusMultForAuriun(hero, item, property_value, property_name)
	local mult = hero:GetRuneValue("r", 2)*(AURIUN_R2_GEAR_VALUE_ENCH_PCT/100)
	if property_name == "rune_q_1" or property_name == "rune_q_2" or property_name == "rune_q_3" or property_name == "rune_q_4" then
		mult = 0
	elseif property_name == "rune_w_1" or property_name == "rune_w_2" or property_name == "rune_w_3" or property_name == "rune_w_4" then
		mult = 0
	elseif property_name == "rune_e_1" or property_name == "rune_e_2" or property_name == "rune_e_3" or property_name == "rune_e_4" then
		mult = 0
	elseif property_name == "rune_r_1" or property_name == "rune_r_2" or property_name == "rune_r_3" or property_name == "rune_r_4" then
		mult = 0
	elseif property_name == "all_t1_runes" or property_name == "all_t2_runes" or property_name == "all_t3_runes" or property_name == "all_t4_runes" then
		mult = 0
	end
	return mult
end

function RPCItems:BonusMultForDinath(hero, item, property_value, property_name)
	local mult = 0
	if property_name == "attack_damage" then
		mult = hero:GetRuneValue("e", 2)*DINATH_E2_GEAR_BASE_DAMAGE_AMP
	end
	return mult
end

function RPCItems:BonusMultForConjuror(hero, item, property_value, property_name)
	local mult = 0
	if property_name == "agility" then
		mult = hero:GetRuneValue("e", 3)*(CONJUROR_ARCANA_E3_AGILITY_GEAR_AMP/100)
	end
	return mult
end

function RPCItems:AdjustPropertyNameForPuzzler(hero, item, property_value, property_name)
	local property_name_to_return = property_name
	if property_name == "all_t2_runes" then
		property_name_to_return = "all_t3_runes"
	elseif property_name == "all_t3_runes" then
		property_name_to_return = "all_t2_runes"
	elseif property_name == "rune_q_2" then
		property_name_to_return = "rune_q_3"
	elseif property_name == "rune_w_2" then
		property_name_to_return = "rune_w_3"
	elseif property_name == "rune_e_2" then
		property_name_to_return = "rune_e_3"
	elseif property_name == "rune_r_2" then
		property_name_to_return = "rune_r_3"
	elseif property_name == "rune_q_3" then
		property_name_to_return = "rune_q_2"
	elseif property_name == "rune_w_3" then
		property_name_to_return = "rune_w_2"
	elseif property_name == "rune_e_3" then
		property_name_to_return = "rune_e_2"
	elseif property_name == "rune_r_3" then
		property_name_to_return = "rune_r_2"
	end
	return property_name_to_return
end

function RPCItems:GetMultStoneOfGordon(hero, item, property_value, property_name)
	local mult = 0
	if property_name == "rune_q_1" or property_name == "rune_w_1" or property_name == "rune_e_1" or property_name == "rune_r_1" or property_name == "all_t1_runes" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("ruby", ITEM_RPC_STONE_OF_GORDON_GEM_RUBY)/100
	elseif property_name == "rune_q_3" or property_name == "rune_w_3" or property_name == "rune_e_3" or property_name == "rune_r_3" or property_name == "all_t3_runes" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("emerald", ITEM_RPC_STONE_OF_GORDON_GEM_EMERALD)/100
	elseif property_name == "rune_q_2" or property_name == "rune_w_2" or property_name == "rune_e_2" or property_name == "rune_r_2" or property_name == "all_t2_runes" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("sapphire", ITEM_RPC_STONE_OF_GORDON_GEM_SAPPHIRE)/100
	elseif property_name == "rune_q_4" or property_name == "rune_w_4" or property_name == "rune_e_4" or property_name == "rune_r_4" or property_name == "all_t4_runes" then
		mult = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]:GetFinalGemPropertyValue("amethyst", ITEM_RPC_STONE_OF_GORDON_GEM_AMETHYST)/100
	end
	return mult
end

function RPCItems:AdjustPropertyForMonarchRing(hero, item, property_value, property_name)
	local property_name_to_return = property_name
	if property_name == "all_t1_runes" then
		property_name_to_return = "all_attributes"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T1
	elseif property_name == "all_t2_runes" then
		property_name_to_return = "all_attributes"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T2
	elseif property_name == "all_t3_runes" then
		property_name_to_return = "all_attributes"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T3
	elseif property_name == "all_t4_runes" then
		property_name_to_return = "all_attributes"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T4
	elseif property_name == "rune_q_1" or property_name == "rune_q_2" then
		property_name_to_return = "strength"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T1
	elseif property_name == "rune_q_3" then
		property_name_to_return = "strength"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T3
	elseif property_name == "rune_q_4" then
		property_name_to_return = "strength"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T4
	elseif property_name == "rune_w_1" or property_name == "rune_w_2" then
		property_name_to_return = "agility"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T1
	elseif property_name == "rune_w_3" then
		property_name_to_return = "agility"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T3
	elseif property_name == "rune_w_4" then
		property_name_to_return = "agility"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T4
	elseif property_name == "rune_e_1" or property_name == "rune_e_2" then
		property_name_to_return = "intelligence"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T1
	elseif property_name == "rune_e_3" then
		property_name_to_return = "intelligence"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T3
	elseif property_name == "rune_e_4" then
		property_name_to_return = "intelligence"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T4
	elseif property_name == "rune_r_1" or property_name == "rune_r_2" then
		property_name_to_return = "spirit"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T1
	elseif property_name == "rune_r_3" then
		property_name_to_return = "spirit"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T3
	elseif property_name == "rune_r_4" then
		property_name_to_return = "spirit"
		property_value = property_value * ITEM_RPC_MONARCH_RING_STAT_PER_RUNE * Runes.COST_TO_LEVEL_T4
	end
	local ring = hero.equipped_gear[RPC_GEAR_SLOT_TRINKET]
	if ring then
		if property_name == "strength" then
			property_value = property_value*(1 + ring:GetFinalGemPropertyValue("ruby", ITEM_RPC_MONARCH_RING_GEM_RUBY)/100)
		elseif property_name == "agility" then
			property_value = property_value*(1 + ring:GetFinalGemPropertyValue("emerald", ITEM_RPC_MONARCH_RING_GEM_EMERALD)/100)
		elseif property_name == "intelligence" then
			property_value = property_value*(1 + ring:GetFinalGemPropertyValue("sapphire", ITEM_RPC_MONARCH_RING_GEM_SAPPHIRE)/100)
		elseif property_name == "spirit" then
			property_value = property_value*(1 + ring:GetFinalGemPropertyValue("amethyst", ITEM_RPC_MONARCH_RING_GEM_AMETHYST)/100)
		end
	end
	return property_name_to_return, property_value
end
function CDOTA_BaseNPC_Hero:EquipItem(item)
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

	hero:ApplyGearBonusesByGearSlot(gear_slot)
	if item.isLuaItem then
		item:AddSpecialModifiers(hero)
	end
	
	CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(gear_slot), {itemIndex = item:GetEntityIndex()})
	CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item = item:GetEntityIndex(), heroId = hero:GetClassname(), playerId = playerID, pickup = "equip", rarity = item.newItemTable.rarity, rarityColor = RPCItems:GetRarityColor(item.newItemTable.rarity)})
	EmitGlobalSound("RPC.EquipItem")
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_inventory", {})
	CustomGameEventManager:Send_ServerToAllClients("update_runes", {})



	if gear_slot == RPC_GEAR_SLOT_WEAPON and item.newItemTable.rarity == "immortal" then
		Stars:StarEventPlayer("weapon", hero)
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
	Events:TutorialServerEvent(hero, "3_2", 0)
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
	hero.gear_bonuses[gear_slot] = {}
end

function RPCItems:RecordGearBonusToHeroBySlot(item, hero, property_name, property_value, gear_slot)
	print("PROPERTY NAME: "..property_name)
	if not hero.gear_bonuses[gear_slot][property_name] then
		if string.match(property_name, "all_attributes") then
			if not hero.gear_bonuses[gear_slot]["strength"] then
				hero.gear_bonuses[gear_slot]["strength"] = 0
			end
			if not hero.gear_bonuses[gear_slot]["agility"] then
				hero.gear_bonuses[gear_slot]["agility"] = 0
			end
			if not hero.gear_bonuses[gear_slot]["intelligence"] then
				hero.gear_bonuses[gear_slot]["intelligence"] = 0
			end
			if not hero.gear_bonuses[gear_slot]["spirit"] then
				hero.gear_bonuses[gear_slot]["spirit"] = 0
			end
		else
			hero.gear_bonuses[gear_slot][property_name] = 0
		end
	end
	print("--RECORDING PROPERTY--")
	DeepPrintTable(hero.gear_bonuses[gear_slot])
	if string.match(property_name, "immortal_weapon") or string.match(property_name, "arcana") or string.match(property_name, "!immortal!") then
		hero.gear_bonuses[gear_slot][property_name] = 1
	elseif string.match(property_name, "all_attributes") then
		hero.gear_bonuses[gear_slot]["strength"] = hero.gear_bonuses[gear_slot]["strength"] + property_value
		hero.gear_bonuses[gear_slot]["agility"] = hero.gear_bonuses[gear_slot]["agility"] + property_value
		hero.gear_bonuses[gear_slot]["intelligence"] = hero.gear_bonuses[gear_slot]["intelligence"] + property_value
		hero.gear_bonuses[gear_slot]["spirit"] = hero.gear_bonuses[gear_slot]["spirit"] + property_value
	else
		hero.gear_bonuses[gear_slot][property_name] = hero.gear_bonuses[gear_slot][property_name] + property_value
	end
end

function CDOTA_BaseNPC_Hero:ApplyGearBonusesByGearSlot(gear_slot)
	local hero = self
	local internal_hero_name = HerosCustom:GetInternalHeroNameMain(hero:GetClassname())
	local inventory_unit = hero.InventoryUnit
	local ability_name = "equipment_"..RPC_GEAR_SLOT_NAMES[gear_slot]
	print("ABILITY NAME: "..ability_name)
	local ability = inventory_unit:FindAbilityByName(ability_name)
	DeepPrintTable(hero.gear_bonuses[gear_slot])
	for key, value in pairs(hero.gear_bonuses[gear_slot]) do
		if string.match(key, "immortal_weapon") then
			hero.equipped_gear[gear_slot]:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_"..internal_hero_name.."_"..key, {})
		elseif string.match(key, "arcana") then
			hero.equipped_gear[gear_slot]:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_"..internal_hero_name.."_"..key, {})
			RPCItems:PreacheArcanaResources(hero.equipped_gear[gear_slot])
		elseif string.match(key, "!immortal!") and not hero.equipped_gear[gear_slot].isLuaItem then
			local modifier_name = key:gsub("!immortal!_", "")
			hero.equipped_gear[gear_slot]:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
			RPCItems:PreacheArcanaResources(hero.equipped_gear[gear_slot])
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
		hero.runes_bonus_table[rune_name] = rune_bonus
	end
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "-rune_bonuses", hero.runes_bonus_table)
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
	elseif item:GetAbilityName() == "item_rpc_adamantine_samurai_helmet" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ADAMANTINE_SAMURAI_HELMET_RUBY, hero, "strength", RPC_GEAR_SLOT_HEAD)
		end
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ADAMANTINE_SAMURAI_HELMET_EMERALD, hero, "agility", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_arcane_cascade_hat" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", ARCANE_CASCADE_RUBY, hero, "element_arcane", RPC_GEAR_SLOT_HEAD)
		end
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", ARCANE_CASCADE_EMERALD, hero, "max_mana", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_blackfeather_crown" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", BLACKFEATHER_AMETHYST, hero, "attack_speed", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_blinded_glint_of_onu" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", GLINT_OF_ONU_EMERALD, hero, "agility", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_brazen_kabuto_of_the_desert_realm" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", KABUTO_RUBY, hero, "strength", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_burning_spirit_helmet" then
		if socket_type == "ruby" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "ruby", BURNING_SPIRIT_RUBY, hero, "element_fire", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", BURNING_SPIRIT_SAPPHIRE, hero, "strength", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", BURNING_SPIRIT_SAPPHIRE, hero, "agility", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", BURNING_SPIRIT_SAPPHIRE, hero, "intelligence", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", BURNING_SPIRIT_SAPPHIRE, hero, "spirit", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_cap_of_wild_nature" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", WILD_NATURE_EMERALD, hero, "element_nature", RPC_GEAR_SLOT_HEAD)
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
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST, hero, "strength", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST, hero, "agility", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST, hero, "intelligence", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", UMBRAL_SENTINEL_AMETHYST, hero, "spirit", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_crimson_skull_cap" then
		if socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", CRIMSON_SKULL_CAP_AMETHYST, hero, "element_undead", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() =="item_rpc_crown_of_the_lava_forge" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", LAVA_FORGE_SAPPHIRE, hero, "armor", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", LAVA_FORGE_SAPPHIRE, hero, "magic_armor", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", LAVA_FORGE_AMETHYST, hero, "element_fire", RPC_GEAR_SLOT_HEAD)
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", LAVA_FORGE_AMETHYST, hero, "element_wind", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_crown_of_the_roknar_emperor" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", ROKNAR_SAPPHIRE, hero, "armor", RPC_GEAR_SLOT_HEAD)
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
		end
	elseif item:GetAbilityName() == "item_rpc_demon_mask" then
		if socket_type == "emerald" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "emerald", DEMON_MASK_EMERALD, hero, "rune_q_3", RPC_GEAR_SLOT_HEAD)
		elseif socket_type == "amethyst" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "amethyst", DEMON_MASK_AMETHYST, hero, "element_demon", RPC_GEAR_SLOT_HEAD)
		end
	elseif item:GetAbilityName() == "item_rpc_emerald_douli" then
		if socket_type == "sapphire" then
			RPCItems:RecordSpecificGemBonusForImmortalItem(item, "sapphire", EMERALD_DOULI_SAPPHIRE, hero, "mana_regen", RPC_GEAR_SLOT_HEAD)
		end
	end
end



function RPCItems:RecordSpecificGemBonusForImmortalItem(item, gem_name, value_table, hero, property_name, gear_slot)
	local gem_value = item:GetGemValue(gem_name)
	if gem_value > 0 then
		DeepPrintTable(value_table)
		local property_value = value_table[gem_value]
		if property_value > 0 then
			RPCItems:RecordGearBonusToHeroBySlot(item, hero, property_name, property_value, gear_slot)
		end
	end
end
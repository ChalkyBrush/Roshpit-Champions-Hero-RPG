function RPCItems:DropSynthesisVessel(position)
	local item = RPCItems:CreateConsumable("item_rpc_synthesis_vessel", "immortal", "Synthesis Vessel", "consumable", false, "Consumable", "synthesis_vessel_desc")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	RPCItems:ItemUpdateCustomNetTables(item)
	RPCItems:BasicDropItem(position, item)
end

function RPCItems:UseSynthesisVessel(caster, item)
	item.itemTable = {}
	CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "open_synthesis_vessel", {item = item:GetEntityIndex()})
end

function RPCItems:SynthesisItemPlaced(msg)
	local hero = EntIndexToHScript(msg.heroIndex)
	local draggedItem = EntIndexToHScript(msg.itemIndex)
	local vessel = EntIndexToHScript(msg.vessel)
	Timers:CreateTimer(0.03, function()
		hero:Stop()
	end)
	table.insert(vessel.itemTable, draggedItem)
end

function RPCItems:CombineItems(msg)
	local hero = EntIndexToHScript(msg.heroIndex)
	local vessel = EntIndexToHScript(msg.vessel)
	local playerID = hero:GetPlayerOwnerID()
	if not IsValidEntity(vessel) then
		Notifications:Top(playerID, {text = "Vessel Not Found", duration = 5, style = {color = "#EE2211"}, continue = true})
		return false
	end
	if not Challenges:CheckIfHeroHasItemByItemIndex(hero, vessel:GetEntityIndex()) then
		Notifications:Top(playerID, {text = "Vessel Not Found", duration = 5, style = {color = "#EE2211"}, continue = true})
		return false
	end
	if not vessel:GetAbilityName() == "item_rpc_synthesis_vessel" then
		Notifications:Top(playerID, {text = "Synthesis Error", duration = 5, style = {color = "#EE2211"}, continue = true})
		return false
	end
	if #vessel.itemTable == 2 then
		if vessel.itemTable[1]:GetEntityIndex() == vessel.itemTable[2]:GetEntityIndex() then
			Notifications:Top(playerID, {text = "Can't do that", duration = 5, style = {color = "#EE2211"}, continue = true})
			return false
		end
		for i = 1, #vessel.itemTable, 1 do
			local combineItem = vessel.itemTable[i]
			if not IsValidEntity(combineItem) then
				Notifications:Top(playerID, {text = "Item Not Found", duration = 5, style = {color = "#EE2211"}, continue = true})
				return false
			end
			if not Challenges:CheckIfHeroHasItemByItemIndex(hero, combineItem:GetEntityIndex()) then
				Notifications:Top(playerID, {text = "Item Not Found", duration = 5, style = {color = "#EE2211"}, continue = true})
				return false
			end
			print(vessel.itemTable[i]:GetAbilityName())
		end
		Events.reroll = true
		local newItem = nil
		newItem = RPCItems:SynthCheckCombination(vessel.itemTable[1], vessel.itemTable[2], hero:GetAbsOrigin())
		if not newItem then
			newItem = RPCItems:SynthCheckCombination2(vessel.itemTable[1], vessel.itemTable[2], hero:GetAbsOrigin())
		end
		Events.reroll = false
		if newItem and IsValidEntity(newItem) then
			UTIL_Remove(vessel.itemTable[1])
			UTIL_Remove(vessel.itemTable[2])
			UTIL_Remove(vessel)
			UTIL_Remove(newItem:GetContainer())
			newItem.pickedUp = true
			newItem.expiryTime = nil
			RPCItems:GiveItemToHeroWithSlotCheck(hero, newItem)
			EmitSoundOn("item.newItemTable.SynthesisComplete", hero)
			CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_g_cowlofice_b.vpcf", hero, 5)
		else
			Notifications:Top(playerID, {text = "Synthesis Fail", duration = 5, style = {color = "#EE2211"}, continue = true})
		end
	else
		Notifications:Top(playerID, {text = "Must Insert 2 Items", duration = 5, style = {color = "#EE2211"}, continue = true})
	end
end

function RPCItems:SynthCheckCombination2(item1, item2, position)
	print("-------")
	local core_of_fire_table = {"item_tanari_core_of_fire_normal", "item_tanari_core_of_fire_elite", "item_tanari_core_of_fire_legend"}
	local jex_weapon_table = {"item_rpc_jex_immortal_weapon_1", "item_rpc_jex_immortal_weapon_2", "item_rpc_jex_immortal_weapon_3"}
	if (WallPhysics:DoesTableHaveValue(core_of_fire_table, item1:GetAbilityName()) and WallPhysics:DoesTableHaveValue(jex_weapon_table, item2:GetAbilityName())) or (WallPhysics:DoesTableHaveValue(core_of_fire_table, item2:GetAbilityName()) and WallPhysics:DoesTableHaveValue(jex_weapon_table, item1:GetAbilityName())) then
		print("WE'RE IN")
		local newItem = nil
		local maxWeaponLevel = 50
		if WallPhysics:DoesTableHaveValue(jex_weapon_table, item1:GetAbilityName()) then
			maxWeaponLevel = item1.newItemTable.maxLevel
		elseif WallPhysics:DoesTableHaveValue(jex_weapon_table, item2:GetAbilityName()) then
			maxWeaponLevel = item2.newItemTable.maxLevel
		end
		local newItemName = "item_rpc_jex_immortal_weapon_2_a"
		local new_min_level = 100
		maxWeaponLevel = math.min(maxWeaponLevel, 50)
		RPCItems.LevelRoll = new_min_level
		local newItem = Weapons:RollJexLegendWeapon2a(position, true)
		RPCItems.LevelRoll = nil
		if newItem and IsValidEntity(newItem) then
			newItem.pickedUp = true
			newItem.newItemTable.minLevel = new_min_level
			return newItem
		else
			return false
		end
	elseif (string.match(item1:GetAbilityName(), "item_serengaard_sunstone") and string.match(item2:GetAbilityName(), "item_rpc_serengaard_sun_crystal")) or (string.match(item2:GetAbilityName(), "item_serengaard_sunstone") and string.match(item1:GetAbilityName(), "item_rpc_serengaard_sun_crystal")) then
		local suncrystal = nil
		if string.match(item2:GetAbilityName(), "item_rpc_serengaard_sun_crystal") then
			suncrystal = item2
		elseif string.match(item2:GetAbilityName(), "item_serengaard_sunstone") then
			suncrystal = item1
		end
		local score1 = 0
		if suncrystal.newItemTable.property1 and type(suncrystal.newItemTable.property1) == "number" then
			score1 = RPCItems:GetLogarithmicVarianceValue(suncrystal.newItemTable.property1, 0, 0, 0, 0)
		end
		local score2 = 0
		if suncrystal.newItemTable.property2 and type(suncrystal.newItemTable.property2) == "number" then
			score2 = RPCItems:GetLogarithmicVarianceValue(suncrystal.newItemTable.property2, 0, 0, 0, 0)
		end
		local score3 = 0
		if suncrystal.newItemTable.property3 and type(suncrystal.newItemTable.property3) == "number" then
			score3 = RPCItems:GetLogarithmicVarianceValue(suncrystal.newItemTable.property3, 0, 0, 0, 0)
		end
		local score4 = 0
		if suncrystal.newItemTable.property4 and type(suncrystal.newItemTable.property4) == "number" then
			score4 = RPCItems:GetLogarithmicVarianceValue(suncrystal.newItemTable.property4, 0, 0, 0, 0) * 10
		end
		local score5 = suncrystal.newItemTable.minLevel * 200
		local total_score = RPCItems:GetLogarithmicVarianceValue(score1 + score2 + score2 + score4 + score5, 0, 0, 0, 0)
		local divisor = RPCItems:GetLogarithmicVarianceValue(220, 0, 0, 0, 0)
		local final_score = math.max(total_score / divisor, 30)
		final_score = math.min(math.ceil(final_score), 350)
		local hyperstone = RPCItems:RollHyperstone(final_score)
		return hyperstone
	else
		return false
	end
end

function RPCItems:SynthCheckCombination(item1, item2, position)
	if item1.newItemTable.gear and item2.newItemTable.gear and (item1.newItemTable.gear == 1 or item1.newItemTable.gear == true) and (item2.newItemTable.gear == 1 or item2.newItemTable.gear == true) then
		if item1.newItemTable.rarity == "arcana" and item2.newItemTable.rarity == "arcana" then
			local possibilityTable = {item1, item2}
			local randomItem = possibilityTable[RandomInt(1, #possibilityTable)]
			local minLevelAVG = math.floor((item1.newItemTable.minLevel + item2.newItemTable.minLevel) / 2)
			local newMinLevel = RPCItems:GetImmortalLevelForSynth(minLevelAVG)
			newMinLevel = math.max(math.min(newMinLevel, 100), 3)
			RPCItems.LevelRoll = newMinLevel
			local newItem = RPCItems:RollArcanaByName(randomItem:GetAbilityName(), position)
			RPCItems.LevelRoll = nil
			if newItem and IsValidEntity(newItem) then
				newItem.pickedUp = true
				newItem.newItemTable.minLevel = newMinLevel
				local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(randomItem:GetEntityIndex()))
				newItem.newItemTable.validator = itemInfo.validator
				RPCItems:ItemUpdateCustomNetTables(newItem)
				return newItem
			else
				return false
			end
		elseif item1.newItemTable.rarity == "immortal" and item2.newItemTable.rarity == "immortal" then
			if item1.newItemTable.item_slot ~= "weapon" and item2.newItemTable.item_slot ~= "weapon" then
				local possibilityTable = {item1, item2}
				local randomItem = possibilityTable[RandomInt(1, #possibilityTable)]
				local minLevelAVG = math.floor((item1.newItemTable.minLevel + item2.newItemTable.minLevel) / 2)
				local newMinLevel = RPCItems:GetImmortalLevelForSynth(minLevelAVG)
				newMinLevel = math.max(math.min(newMinLevel, 100), 3)
				RPCItems.LevelRoll = newMinLevel
				local newItem = RPCItems:RollImmortalByName(randomItem:GetAbilityName(), position)
				RPCItems.LevelRoll = nil
				if newItem and IsValidEntity(newItem) then
					newItem.pickedUp = true
					newItem.newItemTable.minLevel = newMinLevel
					local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(randomItem:GetEntityIndex()))
					newItem.newItemTable.validator = itemInfo.validator
					RPCItems:ItemUpdateCustomNetTables(newItem)
					return newItem
				else
					return false
				end
			elseif item1.newItemTable.item_slot == "weapon" and item2.newItemTable.item_slot == "weapon" then
				local possibilityTable = {item1, item2}
				local randomItem = possibilityTable[RandomInt(1, #possibilityTable)]
				local newMinLevel = 100
				local maxWeaponLevel = math.floor((item1.newItemTable.maxLevel + item2.newItemTable.maxLevel) / 2)
				maxWeaponLevel = math.min(maxWeaponLevel, 50)
				RPCItems.LevelRoll = newMinLevel
				local newItem = Weapons:RollLegendWeaponVariantWithAbilityName(randomItem:GetAbilityName(), maxWeaponLevel, position, true)
				RPCItems.LevelRoll = nil
				if newItem and IsValidEntity(newItem) then
					newItem.pickedUp = true
					newItem.newItemTable.minLevel = newMinLevel
					local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(randomItem:GetEntityIndex()))
					newItem.newItemTable.validator = itemInfo.validator
					RPCItems:ItemUpdateCustomNetTables(newItem)
					return newItem
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	else
		if (item1:GetAbilityName() == "item_rpc_galactic_arcana_cache_piece_1" and item2:GetAbilityName() == "item_rpc_galactic_arcana_cache_piece_2") or (item1:GetAbilityName() == "item_rpc_galactic_arcana_cache_piece_2" and item2:GetAbilityName() == "item_rpc_galactic_arcana_cache_piece_1") then
			local radianceAVG = math.floor((item1.newItemTable.property1 + item2.newItemTable.property1) / 2)
			local key1 = "abc"
			local key2 = "xyz"
			local validatorTable = CustomNetTables:GetTableValue("item_basics", tostring(item1:GetEntityIndex()))
			if validatorTable then
				key1 = validatorTable.validator
			end
			local validatorTable = CustomNetTables:GetTableValue("item_basics", tostring(item2:GetEntityIndex()))
			if validatorTable then
				key2 = validatorTable.validator
			end
			--local validator = key1.."-"..key2
			local validator = key1
			local newItem = RPCItems:CreateArcanaCache(radianceAVG, validator)
			if newItem and IsValidEntity(newItem) then
				newItem.pickedUp = true
				return newItem
			else
				return false
			end
		elseif (item1:GetAbilityName() == "item_rpc_boreal_granite_chunk" and item2.newItemTable.item_slot and item2.newItemTable.item_slot == "body" and item2.newItemTable.rarity == "immortal")
			or (item2:GetAbilityName() == "item_rpc_boreal_granite_chunk" and item1.newItemTable.item_slot and item1.newItemTable.item_slot == "body" and item1.newItemTable.rarity == "immortal") then
			local new_min_level = 0
			local newValidator = nil
			if item2.newItemTable.item_slot then
				new_min_level = RPCItems:GetLogarithmicVarianceValue(item2.newItemTable.minLevel, 0, 0, 0, 0)
				newValidator = item2.newItemTable.validator
			elseif item1.newItemTable.item_slot then
				new_min_level = RPCItems:GetLogarithmicVarianceValue(item1.newItemTable.minLevel, 0, 0, 0, 0)
				newValidator = item1.newItemTable.validator
			end
			new_min_level = math.max(math.min(new_min_level, 100), 3)
			RPCItems.LevelRoll = new_min_level
			local newItem = RPCItems:RollBorealGraniteVest(position)
			RPCItems.LevelRoll = nil
			if newItem and IsValidEntity(newItem) then
				newItem.pickedUp = true
				newItem.newItemTable.minLevel = new_min_level
				local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(newItem:GetEntityIndex()))
				newItem.newItemTable.validator = newValidator
				RPCItems:ItemUpdateCustomNetTables(newItem)
				return newItem
			else
				return false
			end
		elseif (item1:GetAbilityName() == "item_rpc_currency_whetstone" and item2.newItemTable.item_slot == "weapon" and (item2.newItemTable.gear == 1 or item2.newItemTable.gear == true))
			or (item2:GetAbilityName() == "item_rpc_currency_whetstone" and item1.newItemTable.item_slot == "weapon" and (item1.newItemTable.gear == 1 or item1.newItemTable.gear == true)) then
			local currencyItem = item1
			local targetItem = item2
			if item2:GetAbilityName() == "item_rpc_currency_whetstone" then
				currencyItem = item2
				targetItem = item1
			end
			local itemData = CustomNetTables:GetTableValue("item_basics", tostring(targetItem:GetEntityIndex()))
			if not itemData then
				print("[RPCItems:SynthCheckCombination] Error itemData is null")
				return false
			end
			if itemData.level and itemData.maxLevel and itemData.level < itemData.maxLevel then
				local weaponAdditionalLevels = itemData.maxLevel - itemData.level
				print("[RPCItems:SynthCheckCombination] weaponAdditionalLevels:"..tostring(weaponAdditionalLevels))
				RPCItems.LevelRoll = newMinLevel
				local newItem = Weapons:RollLegendWeaponVariantWithAbilityName(targetItem:GetAbilityName(), itemData.maxLevel, position, true)
				RPCItems.LevelRoll = nil

				if newItem and IsValidEntity(newItem) and weaponAdditionalLevels > 0 and weaponAdditionalLevels < 50 then
					newItem.pickedUp = true
					newItem.newItemTable = itemData
					RPCItems:ItemUpdateCustomNetTables(newItem)
					for i = 1, weaponAdditionalLevels do
						Weapons:LevelUpWeapon(nil, newItem, true)
					end
					newItem.newItemTable.xp = 0
					newItem.newItemTable.level = itemData.maxLevel
					newItem.newItemTable.xpNeeded = Weapons.XP_PER_LEVEL_TABLE[newItem.newItemTable.level]
					RPCItems:ItemUpdateCustomNetTables(newItem)

					return newItem
				else
					return false
				end
			else
				return false
			end
		elseif (item1:GetAbilityName() == "item_rpc_currency_arcana_reroll" and item2.newItemTable.rarity == "arcana" and (item2.newItemTable.gear == 1 or item2.newItemTable.gear == true))
			or (item2:GetAbilityName() == "item_rpc_currency_arcana_reroll" and item1.newItemTable.rarity == "arcana" and (item1.newItemTable.gear == 1 or item1.newItemTable.gear == true)) then
			local currencyItem = item1
			local targetItem = item2
			if item2:GetAbilityName() == "item_rpc_currency_arcana_reroll" then
				currencyItem = item2
				targetItem = item1
			end
			local itemData = CustomNetTables:GetTableValue("item_basics", tostring(targetItem:GetEntityIndex()))
			if not itemData then
				print("[RPCItems:SynthCheckCombination] Error itemData is null")
				return false
			end
			RPCItems.LevelRoll = itemData.minLevel
			local newItem = RPCItems:RerollArcanaItem(targetItem:GetAbilityName(), itemData, position, 50)
			RPCItems.LevelRoll = nil
			if newItem and IsValidEntity(newItem) then
				newItem.pickedUp = true
				newItem.newItemTable.minLevel = itemData.minLevel
				newItem.newItemTable.validator = itemData.validator
				RPCItems:ItemUpdateCustomNetTables(newItem)
				return newItem
			else
				return false
			end
		else
			return false
		end
	end
end

function RPCItems:RerollArcanaItem(abilityName, originalItemData, position, attempts)
	DeepPrintTable(originalItemData)
	local newProperty1Value = nil
	local newProperty2Value = nil
	local newProperty3Value = nil
	local newProperty4Value = nil

	for i = 1, attempts do
		if not newProperty1Value or not newProperty2Value or not newProperty3Value or not newProperty4Value then
			print("[RPCItems:RerollArcanaItem] attempt:"..tostring(i))
			local newItem = RPCItems:RollArcanaByName(abilityName, position)

			if not newProperty1Value and (type(originalItemData.property1) == "string" or type(newItem.newItemTable.property1) == "string") then
				print("[RPCItems:RerollArcanaItem] type(originalItemData.property1) == \"string\"")
				newProperty1Value = true
			end
			if not newProperty1Value and newItem.newItemTable.property1tooltip == originalItemData.property1tooltip and newItem.newItemTable.property1 > originalItemData.property1 then
				newProperty1Value = newItem.newItemTable.property1
				print("[RPCItems:RerollArcanaItem] newProperty1Value == "..tostring(newProperty1Value))
			end

			if not newProperty2Value and (type(originalItemData.property2) == "string" or type(newItem.newItemTable.property2) == "string") then
				print("[RPCItems:RerollArcanaItem] type(originalItemData.property2) == \"string\"")
				newProperty2Value = true
			end
			if not newProperty2Value and newItem.newItemTable.property2tooltip == originalItemData.property2tooltip and newItem.newItemTable.property2 > originalItemData.property2 then
				newProperty2Value = newItem.newItemTable.property2
				print("[RPCItems:RerollArcanaItem] newProperty2Value == "..tostring(newProperty2Value))
			end

			if not newProperty3Value and (type(originalItemData.property3) == "string" or type(newItem.newItemTable.property3) == "string") then
				print("[RPCItems:RerollArcanaItem] type(originalItemData.property3) == \"string\"")
				newProperty3Value = true
			end
			if not newProperty3Value and newItem.newItemTable.property3tooltip == originalItemData.property3tooltip and newItem.newItemTable.property3 > originalItemData.property3 then
				newProperty3Value = newItem.newItemTable.property3
				print("[RPCItems:RerollArcanaItem] newProperty3Value == "..tostring(newProperty3Value))
			end

			if not newProperty4Value and (type(originalItemData.property4) == "string" or type(newItem.newItemTable.property4) == "string") then
				print("[RPCItems:RerollArcanaItem] type(originalItemData.property4) == \"string\"")
				newProperty4Value = true
			end
			if not newProperty4Value and newItem.newItemTable.property4tooltip == originalItemData.property4tooltip and newItem.newItemTable.property4 > originalItemData.property4 then
				newProperty4Value = newItem.newItemTable.property4
				print("[RPCItems:RerollArcanaItem] newProperty4Value == "..tostring(newProperty4Value))
			end

			if IsValidEntity(newItem:GetContainer()) then
				UTIL_Remove(newItem:GetContainer())
			end
			UTIL_Remove(newItem)
		end
	end

	local finalItem = RPCItems:RollArcanaByName(abilityName, position)

	-- if originalItemData.property1name then
	-- finalItem.newItemTable.property1name = originalItemData.property1name
	-- end
	-- if originalItemData.property1tooltip then
	-- finalItem.newItemTable.property1tooltip = originalItemData.property1tooltip
	-- end
	-- if originalItemData.property1color then
	-- finalItem.newItemTable.property1color = originalItemData.property1color
	-- end
	-- if originalItemData.property1special then
	-- finalItem.newItemTable.property1special = originalItemData.property1special
	-- end
	-- if newProperty1Value then
	-- finalItem.newItemTable.property1 = newProperty1Value
	-- else
	-- finalItem.newItemTable.property1 = originalItemData.property1
	-- end

	if originalItemData.property2name then
		finalItem.newItemTable.property2name = originalItemData.property2name
	end
	if originalItemData.property2tooltip then
		finalItem.newItemTable.property2tooltip = originalItemData.property2tooltip
	end
	if originalItemData.property2color then
		finalItem.newItemTable.property2color = originalItemData.property2color
	end
	if originalItemData.property2special then
		finalItem.newItemTable.property2special = originalItemData.property2special
	end
	if newProperty2Value then
		finalItem.newItemTable.property2 = newProperty2Value
	else
		finalItem.newItemTable.property2 = originalItemData.property2
	end

	if originalItemData.property3name then
		finalItem.newItemTable.property3name = originalItemData.property3name
	end
	if originalItemData.property3tooltip then
		finalItem.newItemTable.property3tooltip = originalItemData.property3tooltip
	end
	if originalItemData.property3color then
		finalItem.newItemTable.property3color = originalItemData.property3color
	end
	if originalItemData.property3special then
		finalItem.newItemTable.property3special = originalItemData.property3special
	end
	if newProperty3Value then
		finalItem.newItemTable.property3 = newProperty3Value
	else
		finalItem.newItemTable.property3 = originalItemData.property3
	end

	if originalItemData.property4name then
		finalItem.newItemTable.property4name = originalItemData.property4name
	end
	if originalItemData.property4tooltip then
		finalItem.newItemTable.property4tooltip = originalItemData.property4tooltip
	end
	if originalItemData.property4color then
		finalItem.newItemTable.property4color = originalItemData.property4color
	end
	if originalItemData.property4special then
		finalItem.newItemTable.property4special = originalItemData.property4special
	end
	if newProperty4Value then
		finalItem.newItemTable.property4 = newProperty4Value
	else
		finalItem.newItemTable.property4 = originalItemData.property4
	end

	RPCItems:ItemUpdateCustomNetTables(finalItem)
	return finalItem
end

function RPCItems:GetImmortalLevelForSynth(minLevelAVG)
	local bonus = 0
	if minLevelAVG < 10 then
		bonus = bonus + RandomInt(1, 10)
	elseif minLevelAVG < 20 then
		bonus = bonus + RandomInt(1, 8)
	elseif minLevelAVG < 30 then
		bonus = bonus + RandomInt(1, 7)
	elseif minLevelAVG < 40 then
		bonus = bonus + RandomInt(1, 6)
	elseif minLevelAVG < 50 then
		bonus = bonus + RandomInt(1, 5)
	elseif minLevelAVG < 60 then
		bonus = bonus + RandomInt(-3, 6)
	elseif minLevelAVG < 70 then
		bonus = bonus + RandomInt(-3, 5)
	elseif minLevelAVG < 80 then
		bonus = bonus + RandomInt(-4, 3)
	elseif minLevelAVG < 90 then
		bonus = bonus + RandomInt(-3, 2)
	elseif minLevelAVG < 100 then
		bonus = bonus + RandomInt(-4, 2)
	elseif minLevelAVG == 100 then
		bonus = 0
	end
	local new_min_level = math.min(minLevelAVG + bonus, 100)
	return new_min_level
end

function RPCItems:RollRandomArcanaCachePart(position)
	local partNameTable = {"item_rpc_galactic_arcana_cache_piece_1", "item_rpc_galactic_arcana_cache_piece_2"}
	local part_name = partNameTable[RandomInt(1, 2)]
	RPCItems:DropGalacticArcanaCachePart(part_name, position)
end

function RPCItems:CreateArcanaCache(radiance, validator)
	local item = RPCItems:CreateConsumable("item_rpc_galactic_arcana_cache", "arcana", "Galactic Arcana Cache", "consumable", false, "Consumable", "item_rpc_galactic_arcana_cache_desc")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	item.newItemTable.property1 = radiance
	item.newItemTable.property1name = "cache_radiance"
	item.newItemTable.property1color = "#e9ff5b"
	item.newItemTable.property1tooltip = "cache_radiance"
	RPCItems:SetPropertyValues(item, item.newItemTable.property1, "cache_radiance", item.newItemTable.property1color, 1)
	item.newItemTable.validator = validator
	RPCItems:ItemUpdateCustomNetTables(item)
	RPCItems:BasicDropItem(RPCItems.DROP_LOCATION, item)
	return item
end

function RPCItems:DropGalacticArcanaCachePart(part_name, position)
	local item = RPCItems:CreateConsumable(part_name, "immortal", "Arcana Cache Part", "consumable", false, "Consumable", part_name.."_desc")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	item.newItemTable.property1 = RPCItems:GetMinLevel()
	item.newItemTable.property1name = "cache_radiance"
	item.newItemTable.property1color = "#e9ff5b"
	item.newItemTable.property1tooltip = "cache_radiance"
	RPCItems:SetPropertyValues(item, item.newItemTable.property1, "cache_radiance", item.newItemTable.property1color, 1)
	RPCItems:ItemUpdateCustomNetTables(item)
	RPCItems:BasicDropItem(position, item)
end

function RPCItems:UseArcanaCache(caster, item)
	if item:GetAbilityName() == "item_rpc_galactic_arcana_cache" then
		local radiance = item.newItemTable.property1
		if not Challenges:CheckIfHeroHasItemByItemIndex(caster, item:GetEntityIndex()) then
			return false
		end
		local validator = ""
		local validatorTable = CustomNetTables:GetTableValue("item_basics", tostring(item:GetEntityIndex()) .. "-key")
		if validatorTable then
			validator = validatorTable.key
		end
		local playerID = caster:GetPlayerOwnerID()
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		local url = ROSHPIT_URL.."/champions/arcana_cache_use?"
		url = url.."steam_id="..steamID
		url = url.."&validator="..validator
		url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
		CreateHTTPRequestScriptVM("POST", url):Send(function(result)
			if result.StatusCode == 200 then
				print("POST response:\n")
				for k, v in pairs(result) do
					print(string.format("%s : %s\n", k, v))
				end
				print("Done.")
				local resultTable = JSON:decode(result.Body)
				if resultTable.success == 1 then
					RPCItems.LevelRoll = radiance
					Events.reroll = true
					for i = 1, 3, 1 do
						local item = RPCItems:RollRandomArcana(caster:GetAbsOrigin())
						item.pickedUp = true
					end
					Events.reroll = false
					RPCItems.LevelRoll = nil
				end
				if IsValidEntity(item) then
					RPCItems:ItemUTIL_Remove(item)
				end
			end
		end)
	end
end

function RPCItems:RollHyperstone(wave_bonus, position)
	local item = RPCItems:CreateConsumable("item_serengaard_hyperstone", "immortal", "Serengaard Hyperstone", "consumable", false, "Consumable", "item_serengaard_hyperstone_desc")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	item.newItemTable.property1 = wave_bonus
	item.newItemTable.property1name = "wave_number"
	item.newItemTable.property1color = "#e8f442"
	item.newItemTable.property1tooltip = "serengaard_hyperstone_property"
	RPCItems:SetPropertyValuesSpecial(item, item.newItemTable.property1, item.newItemTable.property1tooltip, item.newItemTable.property1color, 1, "#item_serengaard_hyperstone_desc")
	RPCItems:ItemUpdateCustomNetTables(item)
	if position then
		RPCItems:BasicDropItem(position, item)
	end
	return item
end

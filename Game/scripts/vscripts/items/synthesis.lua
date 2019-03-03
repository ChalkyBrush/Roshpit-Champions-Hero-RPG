function RPCItems:DropSynthesisVessel(position)
    local item = RPCItems:CreateConsumable("item_rpc_synthesis_vessel", "immortal", "Synthesis Vessel", "consumable", false, "Consumable", "synthesis_vessel_desc")
    item.stashable = true
    item.consumable = true
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

function RPCItems:GetRealItemLevel(item)
	local itemLevel = 1
	if item.minLevel then
		itemLevel = item.minLevel
	end
	if item.property1 and item.property1name and item.property1name == "level_reduce" then
		itemLevel = itemLevel + item.property1
	end
	if item.property2 and item.property2name and item.property2name == "level_reduce" then
		itemLevel = itemLevel + item.property2
	end
	if item.property3 and item.property3name and item.property3name == "level_reduce" then
		itemLevel = itemLevel + item.property3
	end
	if item.property4 and item.property4name and item.property4name == "level_reduce" then
		itemLevel = itemLevel + item.property4
	end
	-- print("GetRealItemLevel "..itemLevel)		
	return math.max(itemLevel, 1)--min lvl can not be lower than 1
end

function RPCItems:CombineItems(msg)
	local hero = EntIndexToHScript(msg.heroIndex)
	local vessel = EntIndexToHScript(msg.vessel)
	local playerID = hero:GetPlayerOwnerID()
	if not IsValidEntity(vessel) then
		Notifications:Top(playerID, {text="Vessel Not Found", duration=5, style={color="#EE2211"}, continue=true})
		return false
	end
	if not Challenges:CheckIfHeroHasItemByItemIndex(hero, vessel:GetEntityIndex()) then
		Notifications:Top(playerID, {text="Vessel Not Found", duration=5, style={color="#EE2211"}, continue=true})
		return false
	end		
	if not vessel:GetAbilityName() == "item_rpc_synthesis_vessel" then
		Notifications:Top(playerID, {text="Synthesis Error", duration=5, style={color="#EE2211"}, continue=true})
		return false
	end
	if #vessel.itemTable == 2 then
		if vessel.itemTable[1]:GetEntityIndex() == vessel.itemTable[2]:GetEntityIndex() then
			Notifications:Top(playerID, {text="Can't do that", duration=5, style={color="#EE2211"}, continue=true})
			return false
		end
		for i = 1, #vessel.itemTable, 1 do
			local combineItem = vessel.itemTable[i]
			if not IsValidEntity(combineItem) then
				Notifications:Top(playerID, {text="Item Not Found", duration=5, style={color="#EE2211"}, continue=true})
				return false
			end
			if not Challenges:CheckIfHeroHasItemByItemIndex(hero, combineItem:GetEntityIndex()) then
				Notifications:Top(playerID, {text="Item Not Found", duration=5, style={color="#EE2211"}, continue=true})
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
			EmitSoundOn("Item.SynthesisComplete", hero)
			CustomAbilities:QuickAttachParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_g_cowlofice_b.vpcf", hero, 5)
		else
			Notifications:Top(playerID, {text="Synthesis Fail", duration=5, style={color="#EE2211"}, continue=true})
		end
	else
		Notifications:Top(playerID, {text="Must Insert 2 Items", duration=5, style={color="#EE2211"}, continue=true})
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
			maxWeaponLevel = item1.maxLevel
		elseif WallPhysics:DoesTableHaveValue(jex_weapon_table, item2:GetAbilityName()) then
			maxWeaponLevel = item2.maxLevel
		end
		local newItemName = "item_rpc_jex_immortal_weapon_2_a"
		local new_min_level = 100
		maxWeaponLevel = math.min(maxWeaponLevel, 50)
		RPCItems.LevelRoll = new_min_level				
		local newItem = Weapons:RollJexLegendWeapon2a(position, true)
		RPCItems.LevelRoll = nil
		if newItem and IsValidEntity(newItem) then
			newItem.pickedUp = true
			newItem.minLevel = new_min_level
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
		local score1 = RPCItems:GetLogarithmicVarianceValue(suncrystal.property1, 0, 0, 0, 0)
		local score2 = RPCItems:GetLogarithmicVarianceValue(suncrystal.property2, 0, 0, 0, 0)
		local score3 = RPCItems:GetLogarithmicVarianceValue(suncrystal.property3, 0, 0, 0, 0)
		local score4 = RPCItems:GetLogarithmicVarianceValue(suncrystal.property4, 0, 0, 0, 0)*10
		local score5 = suncrystal.minLevel*200
		local total_score = RPCItems:GetLogarithmicVarianceValue(score1 + score2 + score2 + score4 + score5, 0, 0, 0, 0)
		local divisor = RPCItems:GetLogarithmicVarianceValue(220, 0, 0, 0, 0)
		local final_score = math.max(total_score/divisor, 30)
		final_score = math.min(math.ceil(final_score), 350)
		local hyperstone = Serengaard:RollHyperstone(final_score)
		return hyperstone
	else
		return false
	end
end

function RPCItems:SynthCheckCombination(item1, item2, position)
	if item1.gear and item2.gear then
		if item1.rarity == "arcana" and item2.rarity == "arcana" then
			local possibilityTable = {item1:GetAbilityName(), item2:GetAbilityName()}
			local newArcanaName = possibilityTable[RandomInt(1, #possibilityTable)]
			local minLevelAVG = math.floor((RPCItems:GetRealItemLevel(item1) + RPCItems:GetRealItemLevel(item2))/2)
			local new_min_level = minLevelAVG
			new_min_level = math.max(math.min(new_min_level, 100), 3)
			RPCItems.LevelRoll = new_min_level
			local newItem = RPCItems:RollArcanaByName(newArcanaName, position)
			RPCItems.LevelRoll = nil
			if newItem and IsValidEntity(newItem) then
	            newItem.pickedUp = true
	            newItem.minLevel = new_min_level
	            local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(newItem:GetEntityIndex()))
	            CustomNetTables:SetTableValue( "item_basics", tostring(newItem:GetEntityIndex()), {itemName = itemInfo.itemName, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, minLevel = newItem.minLevel, requiredHero = itemInfo.requiredHero  } )
				return newItem
			else
				return false
			end
		elseif item1.rarity == "immortal" and item2.rarity == "immortal" then
			if item1.slot ~= "weapon" and item2.slot ~= "weapon" then
				local possibilityTable = {item1:GetAbilityName(), item2:GetAbilityName()}
				local newItemName = possibilityTable[RandomInt(1, #possibilityTable)]
				local minLevelAVG = math.floor((RPCItems:GetRealItemLevel(item1) + RPCItems:GetRealItemLevel(item2))/2)
				local new_min_level = RPCItems:GetImmortalLevelForSynth(minLevelAVG)
				new_min_level = math.max(math.min(new_min_level, 100), 3)
				RPCItems.LevelRoll = new_min_level
				local newItem = RPCItems:RollImmortalByName(newItemName, position)
				RPCItems.LevelRoll = nil
				if newItem and IsValidEntity(newItem) then
					newItem.pickedUp = true
					newItem.minLevel = new_min_level
					local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(newItem:GetEntityIndex()))
					CustomNetTables:SetTableValue( "item_basics", tostring(newItem:GetEntityIndex()), {itemName = itemInfo.itemName, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, minLevel = newItem.minLevel } )
					return newItem
				else
					return false
				end
			elseif item1.slot == "weapon" and item2.slot == "weapon" then
				local possibilityTable = {item1:GetAbilityName(), item2:GetAbilityName()}
				local newItemName = possibilityTable[RandomInt(1, #possibilityTable)]
				local new_min_level = 100
				local maxWeaponLevel = math.floor((item1.maxLevel + item2.maxLevel)/2)
				maxWeaponLevel = math.min(maxWeaponLevel, 50)
				RPCItems.LevelRoll = new_min_level				
				local newItem = Weapons:RollLegendWeaponVariantWithAbilityName(newItemName, maxWeaponLevel, position, true)
				RPCItems.LevelRoll = nil
				if newItem and IsValidEntity(newItem) then
					newItem.pickedUp = true
					newItem.minLevel = new_min_level
					-- local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(newItem:GetEntityIndex()))
					-- CustomNetTables:SetTableValue( "item_basics", tostring(newItem:GetEntityIndex()), {itemName = itemInfo.itemName, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, minLevel = newItem.minLevel, maxLevel = newItem.maxLevel, requiredHero = newItem.requiredHero, slot = newItem.slot } )
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
			local radianceAVG = math.floor((item1.property1 + item2.property1)/2)
			local key1 = "abc"
			local key2 = "xyz"
			local validatorTable = CustomNetTables:GetTableValue("item_basics", tostring(item1:GetEntityIndex()).."-key")
			if validatorTable then
				key1 = validatorTable.key
			end
			local validatorTable = CustomNetTables:GetTableValue("item_basics", tostring(item2:GetEntityIndex()).."-key")
			if validatorTable then
				key2 = validatorTable.key
			end
			local validator = key1.."-"..key2
			local newItem = RPCItems:CreateArcanaCache(radianceAVG, validator)
			if newItem and IsValidEntity(newItem) then
	            newItem.pickedUp = true
				return newItem
			else
				return false
			end			
		elseif (item1:GetAbilityName() == "item_rpc_boreal_granite_chunk" and item2.slot and item2.slot == "body" and item2.rarity == "immortal") or (item2:GetAbilityName() == "item_rpc_boreal_granite_chunk" and item1.slot and item1.slot == "body" and item1.rarity == "immortal") then
			local new_min_level = 0
			if item2.slot then
				new_min_level = RPCItems:GetLogarithmicVarianceValue(item2.minLevel, 0, 0, 0, 0)
			elseif item1.slot then
				new_min_level = RPCItems:GetLogarithmicVarianceValue(item1.minLevel, 0, 0, 0, 0)
			end
			new_min_level = math.max(math.min(new_min_level, 100), 3)
			RPCItems.LevelRoll = new_min_level
			local newItem = RPCItems:RollBorealGraniteVest(position)
			RPCItems.LevelRoll = nil
			if newItem and IsValidEntity(newItem) then
	            newItem.pickedUp = true
	            newItem.minLevel = new_min_level
	            local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(newItem:GetEntityIndex()))
	            CustomNetTables:SetTableValue( "item_basics", tostring(newItem:GetEntityIndex()), {itemName = itemInfo.itemName, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, minLevel = newItem.minLevel } )
				return newItem
			else
				return false
			end
		else
			return false
		end
	end
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
    item.stashable = true
    item.consumable = true
    item.property1 = radiance
    item.property1name = "cache_radiance"
	item.property1color = "#e9ff5b"
	item.property1tooltip = "cache_radiance"
	RPCItems:SetPropertyValues(item, item.property1, "cache_radiance", item.property1color,  1)
    RPCItems:BasicDropItem(RPCItems.DROP_LOCATION, item)	
    CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()).."-key", {key = validator} )
    return item
end

function RPCItems:DropGalacticArcanaCachePart(part_name, position)
    local item = RPCItems:CreateConsumable(part_name, "immortal", "Arcana Cache Part", "consumable", false, "Consumable", part_name.."_desc")
    item.stashable = true
    item.consumable = true
    item.property1 = RPCItems:GetMinLevel()
    item.property1name = "cache_radiance"
	item.property1color = "#e9ff5b"
	item.property1tooltip = "cache_radiance"
	RPCItems:SetPropertyValues(item, item.property1, "cache_radiance", item.property1color,  1)
    RPCItems:BasicDropItem(position, item)
    local validator = RPCItems:GetRandomKey(13)
    CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()).."-key", {key = validator} )
end

function RPCItems:UseArcanaCache(caster, item)
	if item:GetAbilityName() == "item_rpc_galactic_arcana_cache" then
		local radiance = item.property1
		if not Challenges:CheckIfHeroHasItemByItemIndex(caster, item:GetEntityIndex()) then
			return false
		end
		local validator = ""
		local validatorTable = CustomNetTables:GetTableValue("item_basics", tostring(item:GetEntityIndex()).."-key")
		if validatorTable then
			validator = validatorTable.key
		end
		local playerID = caster:GetPlayerOwnerID()
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		local url = ROSHPIT_URL.."/champions/arcana_cache_use?"
		url = url.."steam_id="..steamID
		url = url.."&validator="..validator
		url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
		CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
			if result.StatusCode == 200 then
				print( "POST response:\n" )
				for k,v in pairs( result ) do
					print( string.format( "%s : %s\n", k, v ) )
				end
				print( "Done." )
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
		end )
	end
end

function RPCItems:RollHyperstone(wave_bonus)
  local item = RPCItems:CreateConsumable("item_serengaard_hyperstone", "immortal", "Serengaard Hyperstone", "consumable", false, "Consumable", "item_serengaard_hyperstone_desc")
  item.stashable = true
  item.consumable = true
  item.property1 = wave_bonus
  item.property1name = "wave_number"
  item.property1color = "#e8f442"
  item.property1tooltip = "serengaard_hyperstone_property"
  RPCItems:SetPropertyValuesSpecial(item, item.property1, item.property1tooltip, item.property1color,  1, "#item_serengaard_hyperstone_desc")
  local validator = RPCItems:GetRandomKey(13)
  CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()).."-key", {key = validator} )
  return item
end
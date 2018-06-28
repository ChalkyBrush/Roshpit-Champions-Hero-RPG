function RPCItems:DropSynthesisVessel(position)
    local item = RPCItems:CreateConsumable("item_rpc_synthesis_vessel", "immortal", "Synthesis Vessel", "consumable", false, "Consumable", "synthesis_vessel_desc")
    item.stashable = true
    item.consumable = true
    RPCItems:BasicDropItem(position, item)
end

function RPCItems:UseSynthesisVessel(caster, item)
	item.itemTable = {}
	print("HALLO")
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
		local newItem = RPCItems:SynthCheckCombination(vessel.itemTable[1], vessel.itemTable[2], hero:GetAbsOrigin())
		if newItem and IsValidEntity(newItem) then
			UTIL_Remove(vessel.itemTable[1])
			UTIL_Remove(vessel.itemTable[2])
			UTIL_Remove(vessel)
			UTIL_Remove(newItem:GetContainer())
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

function RPCItems:SynthCheckCombination(item1, item2, position)
	if item1.gear and item2.gear then
		if item1.rarity == "arcana" and item2.rarity == "arcana" then
			local possibilityTable = {item1:GetAbilityName(), item2:GetAbilityName()}
			local newArcanaName = possibilityTable[RandomInt(1, #possibilityTable)]
			local minLevelAVG = math.floor((item1.minLevel + item2.minLevel)/2)
			local new_min_level = RPCItems:GetLogarithmicVarianceValue(minLevelAVG, 0, 0, 0, 0)
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
			local possibilityTable = {item1:GetAbilityName(), item2:GetAbilityName()}
			local newItemName = possibilityTable[RandomInt(1, #possibilityTable)]
			local minLevelAVG = math.floor((item1.minLevel + item2.minLevel)/2)
			local new_min_level = RPCItems:GetLogarithmicVarianceValue(minLevelAVG, 0, 0, 0, 0)
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
		else
			return false
		end
	end
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
    local validator = WallPhysics:RandomString(15)
    print(validator)
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
					for i = 1, 3, 1 do
						RPCItems:RollRandomArcana(caster:GetAbsOrigin())
					end
					RPCItems.LevelRoll = nil
				end
				if IsValidEntity(item) then
					UTIL_Remove(item)
				end
			end
		end )
	end
end
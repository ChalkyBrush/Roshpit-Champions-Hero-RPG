function RPCItems:DropSynthesisVessel(position)
    local item = RPCItems:CreateConsumable("item_rpc_synthesis_vessel", "immortal", "Synthesis Vessel", "consumable", false, "Consumable", "synthesis_vessel_desc")
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
		return false
	end
end
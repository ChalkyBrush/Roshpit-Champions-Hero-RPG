function CDOTA_BaseNPC_Hero:EquipItem(item)
	local hero = self
	local playerID = hero:GetPlayerOwnerID()
	Events:TutorialServerEvent(hero, "3_1", 0)
	if not hero.gear_bonuses then
		hero:InitGearBonuses()
	end
	local gear_slot = item.newItemTable.gear_slot
	hero:ResetGearBonusesForSlot(gear_slot)
	
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

	hero:ApplyGearBonusesByGearSlot(gear_slot)
	if item.isLuaItem then
		item:AddSpecialModifiers(hero)
	end
	
	CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(gear_slot), {itemIndex = item:GetEntityIndex()})
	CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item = item:GetEntityIndex(), heroId = hero:GetClassname(), playerId = playerID, pickup = "equip", rarity = item.newItemTable.rarity, rarityColor = RPCItems:GetRarityColor(item.newItemTable.rarity)})
	EmitGlobalSound("RPC.EquipItem")
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_inventory", {})
	CustomGameEventManager:Send_ServerToAllClients("update_runes", {})

	if not hero.equipped_gear then
		hero.equipped_gear = {}
	end
	hero.equipped_gear[gear_slot] = item

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
	for key, value in pairs(hero.gear_bonuses[gear_slot]) do
		hero:RemoveModifierByName("modifier_"..RPC_GEAR_SLOT_NAMES[gear_slot].."_"..key)
		hero.gear_bonuses[gear_slot][key] = nil
	end
	hero.gear_bonuses[gear_slot] = {}
end

function RPCItems:RecordGearBonusToHeroBySlot(item, hero, property_name, property_value, gear_slot)
	print("PROPERTY NAME: "..property_name)
	if not hero.gear_bonuses[gear_slot][property_name] then
		hero.gear_bonuses[gear_slot][property_name] = 0
	end
	print("--RECORDING PROPERTY--")
	DeepPrintTable(hero.gear_bonuses[gear_slot])
	hero.gear_bonuses[gear_slot][property_name] = hero.gear_bonuses[gear_slot][property_name] + property_value
end

function CDOTA_BaseNPC_Hero:ApplyGearBonusesByGearSlot(gear_slot)
	local hero = self
	local inventory_unit = hero.InventoryUnit
	local ability_name = "equipment_"..RPC_GEAR_SLOT_NAMES[gear_slot]
	print("ABILITY NAME: "..ability_name)
	local ability = inventory_unit:FindAbilityByName(ability_name)
	DeepPrintTable(hero.gear_bonuses[gear_slot])
	for key, value in pairs(hero.gear_bonuses[gear_slot]) do
		if value > 0 then
			local modifier_name = "modifier_"..RPC_GEAR_SLOT_NAMES[gear_slot].."_"..key
			print("MODIFIER "..modifier_name)
			local stacks = value
			ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
			hero:SetModifierStackCount(modifier_name, inventory_unit, stacks)
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
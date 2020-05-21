if Soulbinder == nil then
	Soulbinder = class({})
end

SOULBINDER_STASH_ID = -10

SOULBIND_CRYSTAL_COST_PER_ITEM_LEVEL = 10
SOULBIND_CRYSTAL_COST_ARCANA_MULT = 5

function Soulbinder:SpawnSoulbinder(position, forwardVector)
	local soulbinder = CreateUnitByName("the_soulbinder", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	soulbinder:SetForwardVector(forwardVector)
	soulbinder:NoHealthBar()
	soulbinder:AddAbility("town_unit")
	soulbinder:AddAbility("npc_dialogue")
	soulbinder:FindAbilityByName("town_unit"):SetLevel(1)
	soulbinder:FindAbilityByName("npc_dialogue"):SetLevel(1)
	soulbinder.dialogueName = "soulbinder"
	return soulbinder
end

function Soulbinder:SoulbinderInput(msg)
	if msg.event_type == "search" then
		Soulbinder:ItemSearch(msg)
	elseif msg.event_type == "item_select" then
		Soulbinder:GetPlayerSoulbindItems(msg)
	elseif msg.event_type == "item_up_for_binding" then
		Soulbinder:ItemUpForBinding(msg)
	elseif msg.event_type == "final_bind" then
		Soulbinder:SoulbindItem(msg)
	elseif msg.event_type == "delete_bind" then
		Soulbinder:DeleteSoulboundItem(msg)
	elseif msg.event_type == "equip_bind" then
		Soulbinder:EquipSoulboundItem(msg)
	elseif msg.event_type == "click_equipment" then
		Soulbinder:EquipmentClicked(msg)
	end
end

function Soulbinder:ItemSearch(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	if not hero.soulbinder_search then
		hero.soulbinder_search = true
		local url = ROSHPIT_URL.."/soulbinder/item_search?"
		url = url.."query="..Curator:urlencode(msg.query)
		CreateHTTPRequestScriptVM("GET", url):Send(function(result)
			if result.StatusCode == 200 then
				local resultTable = JSON:decode(result.Body)
				CustomGameEventManager:Send_ServerToPlayer(player, "soulbinder_search", {result = resultTable})
			else

			end
		end)
		Timers:CreateTimer(1, function()
			hero.soulbinder_search = false
		end)
	end
end

function Soulbinder:GetPlayerSoulbindItems(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local steamID = PlayerResource:GetSteamAccountID(playerID)

	Soulbinder:RemovePreviewItems(hero)

	
	local url = ROSHPIT_URL.."/soulbinder/get_soulbind_results_by_item_for_player?"
	url = url.."steam_id="..steamID
	url = url.."&item_name="..msg.item_variant
	CreateHTTPRequestScriptVM("GET", url):Send(function(result)
		if result.StatusCode == 200 then
			Soulbinder:ConvertResponseToItemPreviews(hero, result, playerID)
			local premium = 0
			if GameState:GetPlayerPremiumStatus(playerID) then
				premium = 1
			end
			CustomGameEventManager:Send_ServerToPlayer(player, "soulbinder_item_page_load", {result = hero.soul_bind_preview_items, item_variant = msg.item_variant, image_name = msg.image_name, premium = premium})
		else

		end
	end)

end

function Soulbinder:ConvertResponseToItemPreviews(hero, result, playerID)
	hero.soul_bind_preview_items = {{}, {}, {}}
	local resultTable = JSON:decode(result.Body)
	for i = 1, 3, 1 do
		if resultTable[i] then
			local itemData = resultTable[i]
			local itemEntity = SaveLoad:LoadGear(itemData, playerID, false)
			local entityIndex = itemEntity:GetEntityIndex()
			local soulBindSlot = resultTable[i].stash_slot
			local item_data = {}
			item_data.entityIndex = entityIndex
			item_data.soulBindSlot = soulBindSlot
			hero.soul_bind_preview_items[soulBindSlot] = item_data
		end
	end
end

function Soulbinder:RemovePreviewItems(hero)
	if hero.soul_bind_preview_items then
		for i = 1, #hero.soul_bind_preview_items, 1 do
			local data = hero.soul_bind_preview_items[i]
			if data.entityIndex then
				local item = EntIndexToHScript(data.entityIndex)
				UTIL_Remove(item)
			end
		end
	end
end

function Soulbinder:GetSoulbindCost(item)
	local cost = item.newItemTable.minLevel * SOULBIND_CRYSTAL_COST_PER_ITEM_LEVEL
	if item.newItemTable.rarity == "arcana" then
		cost = cost * SOULBIND_CRYSTAL_COST_ARCANA_MULT
	end
	return cost
end

function Soulbinder:ItemUpForBinding(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local item = EntIndexToHScript(msg.itemIndex)
	hero.item_up_for_soulbinding = {}
	hero.item_up_for_soulbinding["slot"] = msg.slot
	hero.item_up_for_soulbinding["item"] = item
	local cost = Soulbinder:GetSoulbindCost(item)
	local currentCrystals = CustomNetTables:GetTableValue("player_stats", tostring(playerID) .. "-resources").arcane
	CustomGameEventManager:Send_ServerToPlayer(player, "soulbinder_item_up_for_soulbind", {item = item:GetEntityIndex(), slot_number = msg.slot, cost = cost, currentCrystals = currentCrystals})
end

function Soulbinder:SoulbindItem(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	if not hero.item_up_for_soulbinding then
		return false
	end

	local item_to_bind = hero.item_up_for_soulbinding["item"]

	local rarity = item_to_bind.newItemTable.rarity
	if rarity ~= "immortal" and rarity ~= "arcana" then
		return false
	end
	local cost = Soulbinder:GetSoulbindCost(item_to_bind)
	local currentCrystals = CustomNetTables:GetTableValue("player_stats", tostring(playerID) .. "-resources").arcane
	if cost > currentCrystals then
		return false
	else
		local crystal_debit = cost*-1
		Glyphs:ModifyArcaneCrystals(hero, crystal_debit)
	end
	if hero.item_up_for_soulbinding["slot"] > 1 then
		if not GameState:GetPlayerPremiumStatus(playerID) then
			print("FAIL")
			return false
		end
	end
	local isItemEquipped = false
	if hero.equipped_gear then
		if hero.equipped_gear[RPC_GEAR_SLOT_HEAD] and hero.equipped_gear[RPC_GEAR_SLOT_HEAD] == item_to_bind then
			isItemEquipped = true
		elseif hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] and hero.equipped_gear[RPC_GEAR_SLOT_WEAPON] == item_to_bind then
			isItemEquipped = true
		elseif hero.equipped_gear[RPC_GEAR_SLOT_GLOVES] and hero.equipped_gear[RPC_GEAR_SLOT_GLOVES] == item_to_bind then
			isItemEquipped = true
		elseif hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] and hero.equipped_gear[RPC_GEAR_SLOT_BOOTS] == item_to_bind then
			isItemEquipped = true
		elseif hero.equipped_gear[RPC_GEAR_SLOT_BODY] and hero.equipped_gear[RPC_GEAR_SLOT_BODY] == item_to_bind then
			isItemEquipped = true
		elseif hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] and hero.equipped_gear[RPC_GEAR_SLOT_TRINKET] == item_to_bind then
			isItemEquipped = true
		end
	end

	if not isItemEquipped then
		if not Challenges:CheckIfHeroHasItemByItemIndex(hero, item_to_bind:GetEntityIndex()) then
			Notifications:Top(hero:GetPlayerOwnerID(), {text = "Soulbind Failed. Not Holding Item.", duration = 2, style = {color = "red"}, continue = true})
			CustomGameEventManager:Send_ServerToPlayer(player, "close_soulbinder", {})
			return false
		else
			hero:TakeItem(item_to_bind)
		end
	else
		item_to_bind.newItemTable.soulbound = 1
		RPCItems:ItemUpdateCustomNetTables(item_to_bind)
	end
	-- item.newItemTable.validator = RPCItems:GetRandomKey(13)
	local url = ROSHPIT_URL.."/soulbinder/soulbind_item?"
	url = url.."steam_id="..steamID
	url = SaveLoad:AttachItemToURL(url, hero, SOULBINDER_STASH_ID, hero.item_up_for_soulbinding["slot"], playerID, 0, item_to_bind)
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	CreateHTTPRequestScriptVM("POST", url):Send(function(result)
		if result.StatusCode == 200 then
			print("ITEM BOUND")
			EmitSoundOn("UI.Soulbinder.SoulbindItem", hero)
			Soulbinder:ConvertResponseToItemPreviews(hero, result, playerID)
			local premium = 0
			if GameState:GetPlayerPremiumStatus(playerID) then
				premium = 1
			end
			CustomGameEventManager:Send_ServerToPlayer(player, "soulbinder_item_page_load", {result = hero.soul_bind_preview_items, premium = premium})
		else
			print("ITEM BIND FAILED?")
		end
	end)	
	SpecialFX:ColoredSpotlight(hero:GetAbsOrigin(), Vector(200, 10, 235))
end

function Soulbinder:DeleteSoulboundItem(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	EmitSoundOn("UI.Soulbinder.DeleteBind", hero)
	local url = ROSHPIT_URL.."/soulbinder/delete_soulbind_item?"
	url = url.."steam_id="..steamID
	url = url.."&item_variant="..msg.item_name
	url = url.."&stash_slot="..msg.slot
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	print(url)
	CreateHTTPRequestScriptVM("POST", url):Send(function(result)
		if result.StatusCode == 200 then
			print("ITEM DELETED")

			Soulbinder:ConvertResponseToItemPreviews(hero, result, playerID)
			local premium = 0
			if GameState:GetPlayerPremiumStatus(playerID) then
				premium = 1
			end
			CustomGameEventManager:Send_ServerToPlayer(player, "soulbinder_item_page_load", {result = hero.soul_bind_preview_items, premium = premium})
		else
			print("ITEM DELETE FAILED?")
		end
	end)	
end

function Soulbinder:EquipSoulboundItem(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local steamID = PlayerResource:GetSteamAccountID(playerID)

	local slot = msg.slot
	local item_data = hero.soul_bind_preview_items[slot]
	hero.soul_bind_preview_items[slot] = {}
	DeepPrintTable(hero.soul_bind_preview_items)
	local item = EntIndexToHScript(item_data.entityIndex)


	if hero:HasModifier("modifier_cant_equip") then
		return false
	end
	if hero:HasModifier("modifier_respawned_equip") then
		return false
	end
	if hero:GetLevel() >= item.newItemTable.minLevel then
		if item.newItemTable.requiredHero then
			if hero:GetUnitName() == item.newItemTable.requiredHero then

			else
				Notifications:Top(hero:GetPlayerOwnerID(), {text = "Can't Equip", duration = 2, style = {color = "red"}, continue = true})
				CustomGameEventManager:Send_ServerToPlayer(player, "close_soulbinder", {})
				return false
			end
		else
			
		end
	else
		Notifications:Top(hero:GetPlayerOwnerID(), {text = "Level Requirement", duration = 2, style = {color = "red"}, continue = true})
		EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
		CustomGameEventManager:Send_ServerToPlayer(player, "close_soulbinder", {})
		return false
	end


	local newGear = item
	local slot = RPCItems:getGearSlot(newGear.newItemTable.item_slot)
	local oldGearTable = CustomNetTables:GetTableValue("equipment", tostring(playerID) .. "-"..tostring(slot))
	local oldGear = false
	if oldGearTable then
		if oldGearTable.itemIndex == -1 then
			oldGear = false
		else
			oldGear = EntIndexToHScript(oldGearTable.itemIndex)
		end
	end

	hero.cant_use_items = true
	Timers:CreateTimer(0.75, function()
		hero.cant_use_items = false
	end)
	CustomNetTables:SetTableValue("equipment", tostring(playerID) .. "-"..tostring(slot), {itemIndex = newGear:GetEntityIndex()})
	

	if oldGear then
		Timers:CreateTimer(1, function()
			UTIL_Remove(oldGear)
		end)
	end
	hero:RemoveModifierByName("modifier_equip_ui_open")
	EmitGlobalSound("RPC.EquipItem")
	local player = hero:GetPlayerOwner()
	local heroId = hero:GetClassname()
	if newGear then
		hero:EquipItem(newGear, true, true)
	end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "update_inventory", {})
	SaveLoad:SaveCharacterGeneric(hero)
	CustomGameEventManager:Send_ServerToPlayer(player, "close_soulbinder", {})

	Soulbinder:RemovePreviewItems(hero)
	newGear.newItemTable.soulbound = 1
	RPCItems:ItemUpdateCustomNetTables(newGear)
	local premium_allowed = true
	if hero.saveSlot and hero.saveSlot > 0 then
		if hero.saveSlot > 8 then
			if not GameState:GetPlayerPremiumStatus(hero:GetPlayerOwnerID()) then
				premium_allowed = false
			end
		end
		if premium_allowed then
			SaveLoad:SaveCharacterGeneric(hero)
		end
	end
	CustomAbilities:QuickAttachParticle("particles/roshpit/soulbind/soulbind.vpcf", hero, 3)
	EmitSoundOn("UI.Soulbinder.EquipBind", hero)
end

function Soulbinder:EquipmentClicked(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local item = EntIndexToHScript(msg.itemIndex)

	local gear_slot = item.newItemTable.item_slot
	local rarity = item.newItemTable.rarity
	if rarity == "immortal" or rarity == "arcana" then
		local item_name = item:GetAbilityName()
		local item_texture = item:GetKeyValue("AbilityTextureName", 1)
		CustomGameEventManager:Send_ServerToPlayer(player, "soulbinder_gear_click_result", {item = item:GetEntityIndex(), gear_slot = gear_slot, item_name = item_name, item_texture = item_texture})
	end
end

function CDOTABaseAbility:IsSoulbound()
	if self.newItemTable.soulbound and self.newItemTable.soulbound == 1 then
		return true
	else
		return false
	end
end
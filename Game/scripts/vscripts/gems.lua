if Gems == nil then
	Gems = class({})
end

Gems.BaseRewardDifficultyMult = {}
Gems.BaseRewardDifficultyMult[DIFFICULTY_NORMAL] = 1
Gems.BaseRewardDifficultyMult[DIFFICULTY_ELITE] = 2
Gems.BaseRewardDifficultyMult[DIFFICULTY_LEGEND] = 4

Gems.GEMS_COST = {0, 30, 150, 750, 3750, 18750}
Gems.ITEM_MIN_LEVEL_PER_GEM = {0, 15, 30, 45, 60}

function Gems:GemForgerPossibleSpawnEvent(event_name)
	if Gems.GemForgerSpawned then
		return false
	end
	local spawn_args = nil
	if GameState:IsTanariJungle() then
		if event_name == "wind_temple_boss" or event_name == "water_temple_boss" or event_name == "flame_worshipper_kolthun" then
			if not Gems.TanariGemForgerKills then
				Gems.TanariGemForgerKills = 0
			end
			Gems.TanariGemForgerKills = Gems.TanariGemForgerKills + 1
			local luck = RandomInt(1, 4 - Gems.TanariGemForgerKills)
			if luck == 1 then
				spawn_args = Gems:GetRewardAndSpawnPositionByEventName(event_name)
			end
		else
			spawn_args = Gems:GetRewardAndSpawnPositionByEventName(event_name)
		end
	elseif GameState:IsRedfallRidge() then
		if event_name == "redfall_canyon_boss" or event_name == "redfall_shipyard_boss" then
			if not Gems.RedfallBasicBossesKilled then
				Gems.RedfallBasicBossesKilled = 0
			end
			Gems.RedfallBasicBossesKilled = Gems.RedfallBasicBossesKilled + 1
			local luck = RandomInt(1, 5 - Gems.RedfallBasicBossesKilled)
			if luck == 1 then
				spawn_args = Gems:GetRewardAndSpawnPositionByEventName(event_name)
			end
		else
			spawn_args = Gems:GetRewardAndSpawnPositionByEventName(event_name)
		end		
	else
		spawn_args = Gems:GetRewardAndSpawnPositionByEventName(event_name)
	end
	if spawn_args and spawn_args["reward"] then
		local reward = spawn_args["reward"]*Gems.BaseRewardDifficultyMult[GameState:GetDifficultyFactor()]
		Gems:SpawnGemForger(spawn_args["position"], spawn_args["fv"], reward)
	end
end

function Gems:GetRewardAndSpawnPositionByEventName(event_name)
	local spawn_args = {}
	if event_name == "wind_temple_boss" then
		spawn_args["position"] = Vector(7520, 9024)
		spawn_args["fv"] = Vector(1,0)
		spawn_args["reward"] = 6
	elseif event_name == "water_temple_boss" then
		spawn_args["position"] = Vector(-3834, 11554)
		spawn_args["fv"] = Vector(0,-1)
		spawn_args["reward"] = 6
	elseif event_name == "flame_worshipper_kolthun" then
		spawn_args["position"] = Vector(6272, -8384)
		spawn_args["fv"] = Vector(1,0)
		spawn_args["reward"] = 7	
	elseif event_name == "fire_temple_spirit_boss" then
		spawn_args["position"] = Vector(-15040, -3904)
		spawn_args["fv"] = Vector(1,0)
		spawn_args["reward"] = 9		
	elseif event_name == "water_temple_spirit_boss" then
		spawn_args["position"] = Vector(14400, -2432)
		spawn_args["fv"] = Vector(-1,1)
		spawn_args["reward"] = 9	
	elseif event_name == "wind_temple_spirit_boss" then
		spawn_args["position"] = Vector(11200, 2880)
		spawn_args["fv"] = Vector(1,0)
		spawn_args["reward"] = 9	
	elseif event_name == "tanari_ancient_hero" then
		spawn_args["position"] = Vector(3520, -1856)
		spawn_args["fv"] = Vector(1,0)
		spawn_args["reward"] = 12
	elseif event_name == "redfall_crimsyth_castle_boss" then
		spawn_args["position"] = Vector(-960, 4096)
		spawn_args["fv"] = Vector(1,-1)
		spawn_args["reward"] = 10
	elseif event_name == "redfall_shipyard_boss" then
		spawn_args["position"] = Vector(14606, 11392)
		spawn_args["fv"] = Vector(0,-1)
		spawn_args["reward"] = 8
	elseif event_name == "redfall_canyon_boss" then
		spawn_args["position"] = Vector(-14874, 12864)
		spawn_args["fv"] = Vector(1,0)
		spawn_args["reward"] = 7
	elseif event_name ==  "redfall_ancient_tree" then
		spawn_args["position"] = Vector(-12736, -12288)
		spawn_args["fv"] = Vector(1,-1)
		spawn_args["reward"] = 12	
	elseif event_name == "winterblight_cavern_boss_tiamat" then	
		spawn_args["position"] = Vector(-8832, 6016)
		spawn_args["fv"] = Vector(1,1)
		spawn_args["reward"] = 12	
	elseif event_name == "azalea_boss" then	
		spawn_args["position"] = Vector(-640, -14336)
		spawn_args["fv"] = Vector(1,-1)
		spawn_args["reward"] = 12	
	elseif event_name == "arena_pit_of_trials_final_boss" then	
		spawn_args["position"] = Vector(3904, -13248)
		spawn_args["fv"] = Vector(0.3,-1)
		spawn_args["reward"] = 13	
	elseif event_name == "seafortress_final_boss" then	
		spawn_args["position"] = Vector(-12154, 11310)
		spawn_args["fv"] = Vector(0.5,-0.5)
		spawn_args["reward"] = 14
	end
	return spawn_args
end

function Gems:RandomlySetSocketsForItem(item)
end

function Gems:AddSocket(item)
	if Gems:CanItemBeSocketed(item) then
		if not item.newItemTable.socket1 then
			item.newItemTable.socket1 = "open"
			item.newItemTable.socket1value = 0
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif not item.newItemTable.socket2 then
			item.newItemTable.socket2 = "open"
			item.newItemTable.socket2value = 0
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		else
			return item
		end
	else
		return item
	end
end

function Gems:SetSocket(item, socket_number, gem, value)
	if socket_number == 1 then
		item.newItemTable.socket1 = gem
		item.newItemTable.socket1value = value
		RPCItems:ItemUpdateCustomNetTables(item)
	elseif socket_number == 2 then
		item.newItemTable.socket2 = gem
		item.newItemTable.socket2value = value
		RPCItems:ItemUpdateCustomNetTables(item)
	end
end

function Gems:CanItemBeSocketed(item)
	local allowed = true
	local slot = item.newItemTable.item_slot
	if slot == "amulet" or slot == "body" or slot == "feet" or slot == "hands" or slot == "head" then
	else
		allowed = false
	end
	if item.newItemTable.rarity == "immortal" or item.newItemTable.rarity == "mythical" or item.newItemTable.rarity == "rare" or item.newItemTable.rarity == "uncommon" or item.newItemTable.rarity == "common" then
	else
		allowed = false
	end
	if not item.newItemTable.socket2 then
	else
		allowed = false
		if item.newItemTable.socket2 == "none" then
			allowed = true
		else
			allowed = false
		end
	end
	return allowed
end

function Gems:GetMithrilCostToAddSocket(item)
	local cost = 0
	local next_slot = Gems:NextSlotNumber(item)
	if next_slot == 1 then
		cost = item.newItemTable.minLevel*120
	elseif next_slot == 2 then
		cost = item.newItemTable.minLevel*1200
	end
	return cost
end

function Gems:NextSlotNumber(item)
	local next_slot = 0
	if not item.newItemTable.socket1 then
		next_slot = 1
	elseif not item.newItemTable.socket2 then
		next_slot = 2
	end
	return next_slot
end

function Gems:GetErrorMessageForSocketing(item)
	local error_message = "none"
	local slot = item.newItemTable.item_slot
	if slot == "amulet" or slot == "body" or slot == "feet" or slot == "hands" or slot == "head" then
	else
		error_message = "cannot_be_socketed_slot"
	end
	if item.newItemTable.rarity == "immortal" then
	else
		error_message = "cannot_be_socketed_rarity"
	end
	if not item.newItemTable.socket2 then
	else
		error_message = "cannot_be_socketed_full_socket"
		if item.newItemTable.socket2 == "none" then
			error_message = "none"
		end
	end
	return error_message
end

function Gems:SpawnGemForger(position, endFV, gem_reward)
	if not Gems.GemForgerSpawned then
	 	if Gems.GemForger then
	 		UTIL_Remove(Gems.GemForger)
	 	end
		Gems.GemForgerSpawned = true
		Gems.GemForger = CreateUnitByName("gem_forger", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
		Gems.GemForger:SetAbsOrigin(Gems.GemForger:GetAbsOrigin()+Vector(0,0,1000))
		Gems.GemForger.endFV = endFV

		Gems.GemForger:FindAbilityByName("town_unit"):SetLevel(1)
		Gems.GemForger:FindAbilityByName("npc_dialogue"):SetLevel(1)
		Gems.GemForger.dialogueName = "gem_forger"

		local startFV = WallPhysics:rotateVector(endFV, 2*math.pi*1/4)
		Gems.GemForger:SetForwardVector(startFV)
		local gem_ability = Gems.GemForger:FindAbilityByName("gem_forger_ability")
		gem_ability:ApplyDataDrivenModifier(Gems.GemForger, Gems.GemForger, "modifier_gem_forger_entering", {})
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", Gems.GemForger, 0.03)

		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, Gems.GemForger:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Gems.GemForger:GetAbsOrigin())
		Gems.GemForger.entering_pfx = pfx
		StartAnimation(Gems.GemForger, {duration = 3, activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1})
		EmitSoundOn("NPC.Gemforger.Enter.Start", Gems.GemForger)

		gem_reward = math.ceil(RPCItems:GetLogarithmicVarianceValue(gem_reward, 0, 0, 0, 0))
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Gems.GemForger:GetAbsOrigin(), 800, 10, false)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].gem_reward = gem_reward
		end
	end
end

function Gems:DropSocketForger(position)
	local item = RPCItems:CreateConsumable("item_rpc_socket_cutter", "immortal", "Socket Cutter", "consumable", false, "Consumable", "socket_cutter_desc")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	RPCItems:ItemUpdateCustomNetTables(item)
	if position then
		RPCItems:BasicDropItem(position, item)
		return item
	else
		return item
	end
end

function Gems:PanoramaInput(msg)
	print("GEM PANORAMA INPUT")
	if msg.event_type == "collect_reward" then
		Gems:CollectReward(msg)
	elseif msg.event_type == "item_up_for_forging" then
		Gems:ItemUpForForging(msg)
	elseif msg.event_type == "insert_gem" then
		Gems:InsertGem(msg)
	end
end

function Gems:CollectReward(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		local hero = GameState:GetHeroByPlayerID(playerID)
		if hero.gem_reward > 0 then

			local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)

			ParticleManager:SetParticleControl(particle1, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle1, 1, Vector(200, 2, 1000))
			ParticleManager:SetParticleControl(particle1, 3, Vector(200, 550, 550))
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)
			EmitSoundOn("Gemforger.UI.CollectReward.Game", hero)
			local reward = hero.gem_reward
			hero.gem_reward = 0
			Gems:ModifyPrismaticGemstones(playerID, reward, "gemforger_reward", "add")
		end
	end
end

function Gems:ModifyPrismaticGemstones(playerID, amount, reason, add_or_subtract)
	local player = PlayerResource:GetPlayer(playerID)
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local url = ROSHPIT_URL.."/champions/modifyPrismaticGemstones?"
	url = url.."steam_id="..steamID
	url = url.."&amount="..amount
	url = url.."&reason=" ..reason
	url = url.."&add_or_subtract=" ..add_or_subtract
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)

	CreateHTTPRequestScriptVM("POST", url):Send(function(result)
		--SaveLoad:NewKey()
		local resultTable = {}
		--print( "GET response:\n" )
		for k, v in pairs(result) do
			--print( string.format( "%s : %s\n", k, v ) )
		end
		--print( "Done." )
		if result.StatusCode == 200 then
			local resultTable = JSON:decode(result.Body)
			local gemstones_from_json = resultTable.prismatic_gemstones
			--print("[Challenges:FinalReroll] gemstones_from_json:"..tostring(gemstones_from_json))
			CustomNetTables:SetTableValue("player_stats", tostring(playerID) .. "-gemstones", {gemstones = gemstones_from_json})
			CustomGameEventManager:Send_ServerToPlayer(player, "update_gemstones", {gemstones = gemstones_from_json, player = playerID})

		else
			for k, v in pairs(result) do
				print( string.format( "%s : %s\n", k, v ) )
			end
		end
	end)	
end

function Gems:ItemUpForForging(msg)
	local playerID = msg.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	print("UP FOR FORGING")
	if player then
		local item = EntIndexToHScript(msg.itemIndex)
		print("GO")
		if Gems:CanItemTakeGems(item) then
			CustomGameEventManager:Send_ServerToPlayer(player, "item_gemforge_menu", {item_index = item:GetEntityIndex(), success = 1})
		else
			CustomGameEventManager:Send_ServerToPlayer(player, "item_gemforge_menu", {item_index = item:GetEntityIndex(), success = 0})
		end
	end
end

function Gems:CanItemProceedToGemMenu(item)
	local allowed = true
	local slot = item.newItemTable.item_slot
	if slot == "amulet" or slot == "body" or slot == "feet" or slot == "hands" or slot == "head" then
	else
		allowed = false
	end
	if item.newItemTable.rarity == "immortal" or item.newItemTable.rarity == "mythical" or item.newItemTable.rarity == "rare" or item.newItemTable.rarity == "uncommon" or item.newItemTable.rarity == "common" then
	else
		allowed = false
	end
	return allowed
end

function Gems:CanItemTakeGems(item)
	if IsValidEntity(item) and Gems:CanItemProceedToGemMenu(item) then
		print("VALID ENTITY")
		if item.newItemTable.socket1 and item.newItemTable.socket1 ~= "none" then
			return true
		elseif item.newItemTable.socket2 and item.newItemTable.socket2 ~= "none" then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Gems:IsValidGemInput(item, socket_number, gem, gem_level, item)
	if item.newItemTable.minLevel >= Gems.ITEM_MIN_LEVEL_PER_GEM[gem_level] then
		return true
	else
		return false
	end
end

function Gems:InsertGem(msg)
	local item = EntIndexToHScript(msg.item)
	local playerID = msg.PlayerID
	local hero = GameState:GetHeroByPlayerID(playerID)
	if Gems:CanItemTakeGems(item) and Gems:IsValidGemInput(item, msg.socket_number, msg.gem, msg.gem_level, item) then
		if Gems:CanPlayerAffordGem(playerID, msg.socket_number, msg.gem, msg.gem_level, item) then
			local cost = Gems:GetCostFromItem(msg.gem_level, item, msg.gem, msg.socket_number)
			Gems:SetSocket(item, msg.socket_number, msg.gem, msg.gem_level, item)
			EmitSoundOn("NPC.Blacksmith.AddSocket", hero)
			local pfx = CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_luna/luna_eclipse.vpcf", hero, 5)
			ParticleManager:SetParticleControl(pfx, 1, hero:GetAbsOrigin()+Vector(0,0,1000))
			Timers:CreateTimer(1.5, function()
				EmitSoundOn("NPC.Blacksmith.AddSocket2", hero)
			end)
			EmitSoundOn("Gemforger.UI.CollectReward.Game", hero)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", hero, 0.03)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", Gems.GemForger, 0.03)
			Gems:ModifyPrismaticGemstones(playerID, cost, "forge_gem", "subtract")
			if hero.equipped_gear[item.newItemTable.gear_slot] == item then
				hero:EquipItem(item)
			end
		end
	end
end

function Gems:GetCostFromItem(gem_level, item, gem, socket_number)
	local current_level = 0
	local desired_level = gem_level
	if socket_number == 1 then
		current_level = item.newItemTable.socket1value
	elseif socket_number == 2 then
		current_level = item.newItemTable.socket2value
	end
	print("CURRENT LEVEL: "..current_level)
	if not current_level then
		current_level = 0
	end
	local cost = Gems:GetGemCost(current_level, desired_level, gem, item.newItemTable.rarityFactor)
	return cost
end

function Gems:GetGemCost(current_level, desired_level, gem, item_rarity)
	gems_cost = Gems.GEMS_COST
	local cost = 0
	if desired_level <= current_level then
		cost = 0
	else 
		for i = current_level+1, desired_level, 1 do
			cost = cost + gems_cost[i+1]
		end
	end
	if item_rarity < RPC_ITEMS_RARITY_IMMORTAL then
		cost = cost/5
	end
	return cost
end

function Gems:CanPlayerAffordGem(playerID, socket_number, gem, gem_level, item)
	local cost = Gems:GetCostFromItem(gem_level, item, gem, socket_number)
	local gems = CustomNetTables:GetTableValue("player_stats", tostring(playerID) .. "-gemstones").gemstones
	if (gems >= cost) then
		return true
	else
		return false
	end
end

function Gems:CreateUnrefinedGemstones(reward)
	local item = RPCItems:CreateConsumable("item_rpc_unrefined_gemstones", "immortal", "Unrefined Gemstones", "consumable", false, "Consumable", "unrefined_gemstones_desc")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	item.pickedUp = true
	item.newItemTable.property1 = reward
	item.newItemTable.property1name = "tooltip_prismatic_gemstones"
	item.newItemTable.property1color = "#EEEEEE"
	item.newItemTable.property1tooltip = "tooltip_prismatic_gemstones"
	RPCItems:SetPropertyValues(item, item.newItemTable.property1, "tooltip_prismatic_gemstones", item.newItemTable.property1color, 1)
	RPCItems:ItemUpdateCustomNetTables(item)
	return item
end

function Gems:UseUnrefinedGemstonesItem(event)
	local caster = event.caster
	local gemstones = event.ability
	local gemstone_value = gemstones.newItemTable.property1
end

function CDOTABaseAbility:GetGemValue(gem_type)
	local item = self
	local value = 0
	if item.newItemTable.socket1 then
		if item.newItemTable.socket1 == gem_type then
			value = item.newItemTable.socket1value
		end
	end
	if item.newItemTable.socket2 then
		if item.newItemTable.socket2 == gem_type then
			value = item.newItemTable.socket2value
		end		
	end
	return value
end

function CDOTABaseAbility:GetGemValueFromSpecificSocket(gem_type, socket_number)
	local item = self
	local value = 0
	if socket_number == 1 and item.newItemTable.socket1 then
		if item.newItemTable.socket1 == gem_type then
			value = item.newItemTable.socket1value
		end
	end
	if socket_number == 2 and item.newItemTable.socket2 then
		if item.newItemTable.socket2 == gem_type then
			value = item.newItemTable.socket2value
		end		
	end
	return value
end

function CDOTABaseAbility:GetFinalGemPropertyValue(gem_type, value_table)
	local item = self
	local final_value = 0
	local gem_level = 0
	if item.newItemTable.socket1 then
		if item.newItemTable.socket1 == gem_type then
			gem_level = item.newItemTable.socket1value
		end
	end
	if item.newItemTable.socket2 then
		if item.newItemTable.socket2 == gem_type then
			gem_level = item.newItemTable.socket2value
		end		
	end
	if gem_level > 0 then
		final_value = value_table[gem_level]
	end
	return final_value
end
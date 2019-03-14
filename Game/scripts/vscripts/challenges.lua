if Challenges == nil then
  Challenges = class({})
end

function Challenges:InitializeChallenges()
	Challenges:InitializeChallengeVariables()
	local url = ROSHPIT_URL.."/champions/getChallenge"

	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		print(resultTable)
		Challenges:CommitChallengeToGame(resultTable)
	end )	

end

function Challenges:ChiselItem(msg)
	local playerID = msg.playerID
	local hero = GameState:GetHeroByPlayerID(playerID)
	local player = hero:GetPlayerOwner()
	local saveSlot = hero.saveSlot
	local itemIndex = msg.itemIndex
	local item = nil
	local itemSlot = msg.slot
	if not SaveLoad:GetAllowSaving() then
		return false
	end
	local itemEntity = CustomNetTables:GetTableValue("equipment", tostring(playerID).."-"..tostring(itemSlot))
	if itemEntity.itemIndex == itemIndex then
		item = EntIndexToHScript(itemEntity.itemIndex)
	else
		return false
	end
	if hero:HasModifier("modifier_cant_equip") then
		return false
	end

	-- if itemSlot == 1 then
	-- 	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "reopen_blacksmith", {})
	-- 	return false
	-- end
	SaveLoad:NewKey()
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_cant_equip", {duration = 6})
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local cost = math.max(msg.cost, 1)
	CustomGameEventManager:Send_ServerToPlayer(player, "close_swap_ui", {} )
	local url = ROSHPIT_URL.."/champions/chiselItem?"
	url = url.."steam_id="..steamID
	url = url.."&hero_slot="..saveSlot
	url = url.."&equip_slot="..itemSlot
	url = url.."&cost="..cost
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		SaveLoad:NewKey()
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		if result.StatusCode == 200 then
			local resultTable = JSON:decode(result.Body)
			local shards = resultTable.mithril_shards
			CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-mithril", {mithril = shards})
			CustomGameEventManager:Send_ServerToPlayer(player, "update_main_mithril", {mithril = shards, player=playerID} )
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "reopen_blacksmith", {})
			hero:RemoveModifierByName("modifier_cant_equip")
			Weapons:UnequipItem(hero, item)
			Statistics.dispatch('items:chisel')
			Events:TutorialServerEvent(hero, "3_2", 0)
		end
	end )		
end

function Challenges:FinalReroll(msg)
	local playerID = msg.playerID
	local hero = GameState:GetHeroByPlayerID(playerID)
	local player = hero:GetPlayerOwner()
	local itemIndex = msg.itemIndex
	local item = EntIndexToHScript(itemIndex)
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local itemLevel = math.max(item.minLevel+RPCItems:GetPrereductionMinLevel(item), 5)
	CustomGameEventManager:Send_ServerToPlayer(player, "close_swap_ui", {} )
	Events.reroll = true
	local newItem = nil
	if (msg.lock1 + msg.lock2 + msg.lock3 + msg.lock4) > 2 then
		return false
	end
	local itemProperties = CustomNetTables:GetTableValue("item_basics", tostring(itemIndex))
	local reductionTable = CustomNetTables:GetTableValue( "min_level_reduction", tostring(itemIndex) )
	local minLevel = itemProperties.minLevel
	local minReduc = 0
	if reductionTable then
		if reductionTable.levelReduce then
			minReduc = reductionTable.levelReduce
		end
	end
	local costMult = math.max(1, (msg.lock1+msg.lock2+msg.lock3+msg.lock4)*2)
	local cost = (minLevel-minReduc)*3*costMult
	-- local cost = msg.cost
	local amount = math.min(cost*(-1), -1)
	
	local shards = CustomNetTables:GetTableValue("player_stats", tostring(playerID).."-mithril").mithril
	if shards < cost then
		return false
	end
	if Challenges:CheckIfHeroHasItemByItemIndex(hero, item:GetEntityIndex()) then
		if IsValidEntity(item:GetContainer()) then
			CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith", {})
			return false
		end
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith", {})
		return false
	end
	if IsValidEntity(item) then
		newItem = RPCItems:RerollImmortal(hero, item, msg.lock1, msg.lock2, msg.lock3, msg.lock4, itemLevel)
		if newItem then
			if IsValidEntity(newItem) then
				newItem:StartCooldown(2)
				hero:TakeItem(item)
				RPCItems:ItemUTIL_Remove(item)
				RPCItems:GiveItemToHeroWithSlotCheck(hero, newItem)
			else
				CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith", {})
			end
		else
			CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith", {})
		end
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith", {})
		return false
	end
	Events.reroll = false

	Statistics.dispatch('items:reroll')
	
	DeepPrintTable(msg)
	if newItem then
		local url = ROSHPIT_URL.."/champions/modifyMithrilShards?"
		url = url.."steam_id="..steamID
		url = url.."&amount="..amount
		url = url.."&reason=".."reroll"
		url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
		
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "playerReceivedItem", {})
		CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
			SaveLoad:NewKey()
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			if result.StatusCode == 200 then
				local resultTable = JSON:decode(result.Body)
				local shards = resultTable.mithril_shards
				CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-mithril", {mithril = shards})
				CustomGameEventManager:Send_ServerToPlayer(player, "update_main_mithril", {mithril = shards, player=playerID} )

				if Challenges:CheckIfHeroHasItemByItemIndex(hero, newItem:GetEntityIndex()) then
					Timers:CreateTimer(0, function()
						CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith_after_reroll", {itemIndex = newItem:GetEntityIndex(), lock1 = msg.lock1, lock2 = msg.lock2, lock3 = msg.lock3, lock4 = msg.lock4})
					end)
					-- CustomGameEventManager:Send_ServerToPlayer(player, "lockSlotsFromServerCall", {itemIndex = newItem:GetEntityIndex(), lock1 = msg.lock1, lock2 = msg.lock2, lock3 = msg.lock3, lock4 = msg.lock4})

				else
					CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith", {})
				end

				Statistics.dispatch("mithril:change", {playerID = playerID});
				-- local rerollTable = {}
				-- rerollTable.playerID = playerID
				-- rerollTable.heroIndex = hero:GetEntityIndex()
				-- rerollTable.itemIndex = newItem:GetEntityIndex()
				-- rerollTable.ignoreLock = 1
				-- Challenges:DragIntoRerollSlot(rerollTable)	
			else
				CustomGameEventManager:Send_ServerToPlayer(player, "unlock_blacksmith", {})
			end	
		end )
    end
end

function Challenges:ModifyMithril(amount, hero, reason)
	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)

	local url = ROSHPIT_URL.."/champions/modifyMithrilShards?"
	url = url.."steam_id="..steamID
	url = url.."&amount="..amount
	url = url.."&reason="..reason
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		SaveLoad:NewKey()
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		local shards = resultTable.mithril_shards
		Statistics.dispatch("mithril:change", {playerID = playerID});
		CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-mithril", {mithril = shards})
		CustomGameEventManager:Send_ServerToPlayer(player, "update_main_mithril", {mithril = shards, player=playerID})
	end )
end

function Challenges:OpenBlacksmith(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	if hero:HasModifier("modifier_equip_ui_open") then
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "close_swap_ui", {})
		CustomGameEventManager:Send_ServerToPlayer(player, "open_blacksmith", {player=playerID} )
	end
end

function Challenges:ChiselableGearClicked(msg)
	local playerID = msg.playerID
	local itemIndex = msg.itemIndex
	local slot = msg.slot
	local player = PlayerResource:GetPlayer(playerID)
	CustomGameEventManager:Send_ServerToPlayer(player, "chiselable_gear_clicked", {itemIndex = itemIndex, slot=slot} )
end

function Challenges:CollectMithrilIncome(msg)
	local playerID = msg.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local amount = 1000
	local url = ROSHPIT_URL.."/champions/modifyMithrilShards?"
	url = url.."steam_id="..steamID
	url = url.."&amount="..amount
	url = url.."&reason=".."income"
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		SaveLoad:NewKey()
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		local shards = resultTable.mithril_shards
		CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-mithril", {mithril = shards})
		CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-income", {available = 0})
		CustomGameEventManager:Send_ServerToPlayer(player, "update_main_mithril", {mithril = shards, player=playerID} )
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "reopen_blacksmith", {})

		Statistics.dispatch("mithril:change", {playerID = playerID});
		for i = 1, 5, 1 do
			Timers:CreateTimer(0.1*i, function()
				EmitSoundOnClient("Resource.MithrilShardEnter", player)
			end)
		end
	end )	
end

function Challenges:CheckIfHeroHasItemByItemIndex(hero, itemIndex)
	local hasItem = false
	for i = 0, 8, 1 do
		if IsValidEntity(hero:GetItemInSlot(i)) then
			if hero:GetItemInSlot(i):GetEntityIndex() == itemIndex then
				hasItem = true
			end
		end
	end
	return hasItem
end

function Challenges:CheckIfHeroHoldsDupes(hero)
	for i = 0, 5, 1 do
		if IsValidEntity(hero:GetItemInSlot(i)) then
			for j = 0, 5, 1 do
				if IsValidEntity(hero:GetItemInSlot(j)) then
					if not j == i then
						if hero:GetItemInSlot(i):GetEntityIndex() == hero:GetItemInSlot(j):GetEntityIndex() then
							UTIL_Remove(hero:GetItemInSlot(j))
						end
					end
				end
			end
		end
	end
end

function Challenges:DragIntoRerollSlot(msg)
	local playerID = msg.playerID
	local heroIndex = msg.heroIndex
	local itemIndex = msg.itemIndex
	local ignoreLock = msg.ignoreLock
	local hero = EntIndexToHScript(heroIndex)
	local item = EntIndexToHScript(itemIndex)
	local player = hero:GetPlayerOwner()
	-- if IsValidEntity(item:GetContainer()) then
	-- 	UTIL_Remove(item:GetContainer())
	-- end
	if item.slot == "weapon" then
		return false
	end
	Timers:CreateTimer(0.03, function()
		hero:Stop()
	end)
	if Challenges:CheckIfHeroHasItemByItemIndex(hero, itemIndex) then
		-- if IsValidEntity(item:GetContainer()) then
		-- 	return false
		-- end
		hero.rerollItem = item
		-- Timers:CreateTimer(0.5, function()
		-- 	if IsValidEntity(item:GetContainer()) then
		-- 		UTIL_Remove(item:GetContainer())
		-- 	end
		-- end)
		print("LOAD ITEM INTO REROLL SLOT")
		DeepPrintTable(msg)
		CustomGameEventManager:Send_ServerToPlayer(player, "load_item_for_reroll", {itemIndex = itemIndex, player=playerID, ignoreLock=ignoreLock, lock1 = msg.lock1, lock2 = msg.lock2, lock3 = msg.lock3, lock4 = msg.lock4} )
	end
end

function Challenges:ReturnReroll(msg)
	local playerID = msg.playerID
	local itemIndex = msg.itemIndex
	local hero = GameState:GetHeroByPlayerID(playerID)
	-- if hero.rerollItem then
	-- 	local item = EntIndexToHScript(itemIndex)
	-- 	RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
	-- 	hero.rerollItem = nil
	-- end
end

function Challenges:CommitChallengeToGame(resultTable)
	Challenges.challenge = {}
	Challenges.challenge.dungeon_name = resultTable.dungeon_name
	Challenges.challenge.enemy_objective_name = resultTable.enemy_objective_name
	Challenges.challenge.paragon_affix = resultTable.paragon_affix
	Challenges.challenge.paragon_quantity = resultTable.paragon_quantity
	Challenges.challenge.quantity = resultTable.quantity
	Challenges.challenge.time_constraint = resultTable.time_constraint
	Challenges.challenge.ability_constraint = resultTable.ability_constraint
	Challenges.challenge.disallowed_hero = resultTable.disallowed_hero
	Challenges.challenge.no_deaths = resultTable.no_deaths
	Challenges.challenge.reward = resultTable.reward

	-- Challenges.challenge.dungeon_name = resultTable.dungeon_name
	-- Challenges.challenge.enemy_objective_name = resultTable.enemy_objective_name
	-- Challenges.challenge.paragon_affix = resultTable.paragon_affix
	-- Challenges.challenge.paragon_quantity = resultTable.paragon_quantity
	-- Challenges.challenge.quantity = 1
	-- Challenges.challenge.time_constraint = resultTable.time_constraint
	-- Challenges.challenge.ability_constraint = resultTable.ability_constraint
	-- Challenges.challenge.disallowed_hero = resultTable.disallowed_hero
	-- Challenges.challenge.no_deaths = resultTable.no_deaths
	-- Challenges.challenge.reward = resultTable.reward
	DeepPrintTable(Challenges.challenge)
end

function Challenges:InitializeChallengeVariables()
	Challenges.qUsed = false
	Challenges.wUsed = false
	Challenges.eUsed = false
	Challenges.rUsed = false
	Challenges.heroesDied = false
	Challenges.paragonsKilled = 0
	Challenges.paragonsWithKeyAffixKilled = 0
	Challenges.timerStart = 0
	Challenges.timerEnd = 0
	Challenges.completed_this_session = false
end

function Challenges:StartDungeonTimer(dungeonName)
	Challenges.timerStart = GameRules:GetGameTime()
	Challenges.timerEnd = 0
	if Challenges.challenge.time_constraint then
		local dungeonName = "dungeon_"..dungeonName.."_title"
		if Challenges.challenge.dungeon_name == dungeonName then
			CustomGameEventManager:Send_ServerToAllClients("start_challenge_timer", {seconds = Challenges.challenge.time_constraint})
			Timers:CreateTimer(1, function()
				local timeElapsed = GameRules:GetGameTime() - Challenges.timerStart
				CustomGameEventManager:Send_ServerToAllClients("update_challenge_timer", {seconds = (Challenges.challenge.time_constraint-timeElapsed)})
				if Challenges.timerEnd == 0 then
					return 1
				end
			end)
		end
	end
end

function Challenges:BossDie(bossName, bossPosition)
	Challenges.timerEnd = GameRules:GetGameTime()
	if Challenges.challenge.enemy_objective_name then
		print("DEBUG: ENEMY OBJECTIVE TRUE")
		if Challenges.challenge.enemy_objective_name == bossName then
			if bossName == "phoenix_boss" and Challenges.challenge.quantity then
				if (Dungeons.phoenixWave - 10) >= Challenges.challenge.quantity then
					Challenges:CompleteChallenge(bossPosition)
				end
			else
				Challenges:CompleteChallenge(bossPosition)
			end
		end
		Timers:CreateTimer(5, function()
			CustomGameEventManager:Send_ServerToAllClients("close_challenge_timer", {})
		end)
	end

end

function Challenges:IsTimeConditionSatisfied()
	if Challenges.challenge.time_constraint then
		local timeElapsed = Challenges.timerEnd - Challenges.timerStart
		if timeElapsed < Challenges.challenge.time_constraint then
			return true
		else
			Notifications:TopToAll({text="Missed Challenge by"..math.floor(timeElapsed).." seconds", duration=8.0})
			return false
		end
	else
		return true
	end
end

function Challenges:AbilityUsed(abilityIndex)
	if abilityIndex == 1 then
		Challenges.qUsed = true
	elseif abilityIndex == 2 then
		Challenges.wUsed = true
	elseif abilityIndex == 3 then
		Challenges.eUsed = true
	elseif abilityIndex == 4 then
		Challenges.rUsed = true
	end
end

function Challenges:IsAbilityConditionSatisfied()
	if Challenges.challenge.ability_constraint then
		if Challenges.challenge.ability_constraint == 0 and Challenges.qUsed then
			return false
		end
		if Challenges.challenge.ability_constraint == 1 and Challenges.wUsed then
			return false
		end
		if Challenges.challenge.ability_constraint == 2 and Challenges.eUsed then
			return false
		end
		if Challenges.challenge.ability_constraint == 3 and Challenges.rUsed then
			return false
		end
		return true
	else
		return true
	end
end

function Challenges:AreSoloAndNoDeathSatisfied()
	if Challenges.challenge.no_deaths > 0 then
		if Challenges.challenge.no_deaths == 1 then
			if Challenges.heroesDied then
				return false
			end
		end
		if Challenges.challenge.no_deaths == 2 then
			if #MAIN_HERO_TABLE > 1 then
				return false
			end
		end
		return true
	else
		return true
	end
end

function Challenges:IsHeroBanSatisfied()
	if Challenges.challenge.disallowed_hero then
		for i = 1, #MAIN_HERO_TABLE, 1 do
			if MAIN_HERO_TABLE[i]:GetUnitName() == Challenges.challenge.disallowed_hero then
				return false
			end
		end
		return true
	else
		return true
	end
end

function Challenges:PlayerDied()
	Challenges.heroesDied = true
end

function Challenges:ParagonKilled(affixTable, deathPosition)
	if GameState:IsWorld1() then
		Challenges.paragonsKilled = Challenges.paragonsKilled + 1
		local newTable = {}
		for i = 1, #affixTable, 1 do
			local translatedAffixes = affixTable[i]:gsub("modifier_paragon_", "")
			table.insert(newTable, translatedAffixes)
		end
		for i = 1, #newTable, 1 do
			if newTable[i] == Challenges.challenge.paragon_affix then
				print("PARAGON WITH AFFIX INCREASE")
				Challenges.paragonsWithKeyAffixKilled = Challenges.paragonsWithKeyAffixKilled + 1
			end
		end
		if Challenges.challenge.paragon_affix then
			if Challenges.paragonsWithKeyAffixKilled == Challenges.challenge.quantity then
				Challenges:CompleteChallenge(deathPosition)
			end
		end
		if Challenges.challenge.paragon_quantity then
			if Challenges.paragonsKilled == Challenges.challenge.paragon_quantity then
				Challenges:CompleteChallenge(deathPosition)
			end
		end
	end
end

function Challenges:CompleteChallenge(position)
	if not Challenges.completed_this_session then
		if Challenges:IsAbilityConditionSatisfied() and Challenges:AreSoloAndNoDeathSatisfied() and Challenges:IsHeroBanSatisfied() and Challenges:IsTimeConditionSatisfied() then
			Challenges.completed_this_session = true
		  	local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
		  	crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
		  	local crystalAbility = crystal:AddAbility("mithril_shard_ability")
		  	crystalAbility:SetLevel(1)
		  	local fv = RandomVector(1)
		  	crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
		  	crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
		  	crystal.reward = Challenges.challenge.reward*Challenges:GetDifficultyMultipler()
		  	crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))
		  	crystal.distributed = 0
		  	local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
		  	crystal.modelScale = baseModelSize
		  	crystal:SetModelScale(baseModelSize)
		  	crystal.fallVelocity = 45
		  	crystal.falling = true
		  	crystal.winnerTable = MAIN_HERO_TABLE
		  	-- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
		  	-- for i = 1, #potentialWinnerTable, 1 do
		  	-- 	local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
		  	-- 	local completed = completedTable.completed
		  	-- 	if completed == 0 then
		  	-- 		potentialWinnerTable[i].shardsPickedUp = 0
		  	-- 		table.insert(crystal.winnerTable, potentialWinnerTable[i])
		  	-- 	end
		  	-- end
		  	if #crystal.winnerTable > 0 then
			  	for i = 1, #crystal.winnerTable, 1 do
			  		crystal.winnerTable[i].shardsPickedUp = 0
			  		EmitSoundOn("Challenge.ChallengeComplete", crystal.winnerTable[i])
			  		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", crystal.winnerTable[i], 5)
			  	end
			  	Timers:CreateTimer(1.4, function()
			  		EmitSoundOn("Resource.MithrilShardEnter", crystal)
			  	end)
		  	end
		end
	end
end

function Challenges:GetDifficultyMultipler()
	local difficulty = GameState:GetDifficultyFactor()
	if difficulty == 1 then
		return 1
	elseif difficulty == 2 then
		return 2
	elseif difficulty == 3 then
		return 6
	end
end

function Challenges:SaveMithrilShards(winnerTable)
	if SaveLoad:GetAllowSaving() then
		for i = 1, #winnerTable, 1 do
			local hero = winnerTable[i][1]
			if winnerTable[i][2] > 0 then
				local playerID = hero:GetPlayerOwnerID()
				local steamID = PlayerResource:GetSteamAccountID(playerID)
				local player = PlayerResource:GetPlayer(playerID)
				local amount = winnerTable[i][2]
				local url = ROSHPIT_URL.."/champions/modifyMithrilShards?"
				url = url.."steam_id="..steamID
				url = url.."&amount="..amount
				url = url.."&reason=".."challenge"
				url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
				hero.shardsPickedUp = hero.shardsPickedUp - amount
				CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
					SaveLoad:NewKey()
					local resultTable = {}
					print( "GET response:\n" )
					for k,v in pairs( result ) do
						print( string.format( "%s : %s\n", k, v ) )
					end
					print( "Done." )
					if result.StatusCode == 200 then
						local resultTable = JSON:decode(result.Body)
						
						local shards = resultTable.mithril_shards
						if hero.shardsPickedUp <= 1 then
							CustomGameEventManager:Send_ServerToAllClients("arcane_out", {})
						else
							CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "collect_mithril", {gain = hero.shardsPickedUp})
						end

						Statistics.dispatch("mithril:change", {playerID = playerID});
						CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-mithril", {mithril = shards})
						CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-challenge", {completed = resultTable.challenge_completed})
						CustomGameEventManager:Send_ServerToPlayer(player, "update_main_mithril", {mithril = shards, player=playerID} )
					end
				end )
			end
		end
	end
end


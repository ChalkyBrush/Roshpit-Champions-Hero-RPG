if Quests == nil then
	Quests = class({})
end

if ActiveQuests == nil then
	ActiveQuests = {}
end


--------------
--- QUESTS ---
--------------
ROSHPIT_QUEST_STATUS_NONE = 0 --Placeholders that dont count as Quests
ROSHPIT_QUEST_STATUS_ACTIVE = 1 --Quest the player is currently doing
ROSHPIT_QUEST_STATUS_COMPLETED = 2 --Quest objective completed, reward to be claimed

ROSHPIT_QUEST_REWARD_TYPE_NONE = 0
ROSHPIT_QUEST_REWARD_TYPE_KEY = 1
ROSHPIT_QUEST_REWARD_TYPE_BUFF = 2
ROSHPIT_QUEST_REWARD_TYPE_IMMORTAL = 3
ROSHPIT_QUEST_REWARD_TYPE_MITHRIL = 4
ROSHPIT_QUEST_REWARD_TYPE_ARCANE_CRYSTALS = 5
ROSHPIT_QUEST_REWARD_TYPE_PRISMATIC_GEMSTONES = 6

function Quests:StartNewQuest(questName)
	DeepPrintTable(ActiveQuests)
	local quest = _G[questName]
	if Quests:HasQuest(questName) or not quest then
		return
	end
	quest:StartQuest()
	table.insert(ActiveQuests, quest)
	Quests:UpdateQuests()
end

function Quests:HasQuest(questname)
	for i = 1, #ActiveQuests, 1 do
		if ActiveQuests[i]:GetQuestName() == questname then
			return true
		end
	end
	return false
end

function Quests:UpdateQuests()
	local questData = {}
	for i = 1, #ActiveQuests, 1 do
		table.insert(questData, ActiveQuests[i]:GetInternalQuestData())
	end
	CustomNetTables:SetTableValue("interface_data", "quests", questData)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerId = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
		local player = PlayerResource:GetPlayer(playerId)
		CustomGameEventManager:Send_ServerToPlayer(player, "update_quests", {})
	end
end

function Quests:IncrementQuestObjective(objectiveString)
	local needupdate = false
	for questIndex = 1, #ActiveQuests, 1 do
		if ActiveQuests[questIndex]:GetStatus() == ROSHPIT_QUEST_STATUS_ACTIVE then
			ActiveQuests[questIndex]:IncrementObjective(objectiveString)
		end
	end
end

function Quests:ClaimQuestReward(msg)
	local playerId = msg.playerId
	local questIndex = msg.questId
	local rewardIndex = msg.rewardId
	ActiveQuests[questIndex]:ClaimReward(playerId, rewardIndex)
	Quests:UpdateQuests()
end

function Quests:ApplyQuestrewardBuff(hero, modifierName, duration)
    Timers:CreateTimer(
        0,
        function()
            if hero:IsAlive() then
                if duration then
                    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, modifierName, {duration = duration})
                else
                    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, modifierName, {})
                end
            else
                return 1
            end
        end
    )
end

function Quests:PingQuestObjective(msg)
	if Quests.Pinging then
		return
	end
	
	local pingLocations = ActiveQuests[msg.questId]:GetObjectives()[msg.objectiveId]:GetObjectivePingLocations()
	Quests.Pinging = true
	for i = 1, #pingLocations, 1 do
		Quests:PingLocation(msg.playerId, pingLocations[i], Quests.PingDummies[i])
	end
	Timers:CreateTimer(4, function()
		Quests.Pinging = false
	end)
end

function Quests:InitializePingDummies()
	Quests.PingDummies = {}
	for i = 1, 10, 1 do
		local pingDummy = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
		pingDummy:AddAbility("dummy_unit"):SetLevel(1)
		table.insert(Quests.PingDummies, pingDummy)
	end
end

function Quests:PingLocation(playerId, point, unit)
	local hero = PlayerResource:GetPlayer(playerId):GetAssignedHero()
	MinimapEvent(DOTA_TEAM_GOODGUYS, unit, point.x, point.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 4)
end

function Quests:PingLocationForAllPlayers(xcoord, ycoord)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerId = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
		Quests:PingLocation(playerId, xcoord, ycoord)
	end
end

--Used inside of base_quest.lua
function Quests:GetRealMithrilReward(baseReward)

	local mithrilMult = 1

	if GameState:IsRedfallRidge() then
		mithrilMult = REDFALL_MITHRIL_NORMAL_MULT
		if GameState:GetDifficultyFactor() == 2 then
			mithrilMult = REDFALL_MITHRIL_ELITE_MULT
		elseif GameState:GetDifficultyFactor() == 3 then
			mithrilMult = REDFALL_MITHRIL_LEGEND_MULT
		end
		if Events.SpiritRealm then
			mithrilMult = mithrilMult * REDFALL_MITHRIL_EQUINOX_MULT
		end
	elseif GameState:IsTanariJungle() then

	elseif GameState:IsRPCArena() then

	elseif GameState:IsSeaFortress() then

	elseif GameState:IsWinterblight() then

	elseif GameState:IsSerengaard() then
		
	end
	local mithrilReward = math.floor(baseReward * mithrilMult) * Events.ResourceBonus

	return mithrilReward
end













function Quests:OpenQuests(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	CustomGameEventManager:Send_ServerToPlayer(player, "open_crusader", {})
end

function Quests:ReceiveQuestmenuStatusFromClient(msg)
	local playerID = msg.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local slot = hero.saveSlot
	local url = ROSHPIT_URL.."/champions/getQuestList?"
	url = url.."steam_id="..steamID
	url = url.."&hero_slot="..slot
	CreateHTTPRequestScriptVM("GET", url):Send(function(result)
		local resultTable = {}
		--print( "GET response:\n" )
		for k, v in pairs(result) do
			--print( string.format( "%s : %s\n", k, v ) )
		end
		--print( "Done." )
		local resultTable = JSON:decode(result.Body)
		resultTable = Quests:GetQuestDataFromJSON(resultTable)
		CustomGameEventManager:Send_ServerToPlayer(player, "crusader_quests_loaded", {result = resultTable, player = playerID, gameProgress = Quests:GetGameProgressTable(), challenge = Challenges.challenge})
	end)
end

function Quests:GetQuestDataFromJSON(resultTable)
	local quests = {}
	for i = 1, #resultTable, 1 do
		table.insert(quests, resultTable[i])
	end
	if #quests == 0 then
		table.insert(quests, 0)
	end
	resultTable.quests = quests


	return resultTable
end

function Quests:DeleteQuest(msg)
	local playerID = msg.playerID
	local questID = msg.questID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local slot = hero.saveSlot
	local url = ROSHPIT_URL.."/champions/deleteQuest?"
	url = url.."steam_id="..steamID
	url = url.."&hero_slot="..slot
	url = url.."&quest_id="..questID
	--print(url)
	CreateHTTPRequestScriptVM("GET", url):Send(function(result)
		local resultTable = {}
		--print( "GET response:\n" )
		for k, v in pairs(result) do
			--print( string.format( "%s : %s\n", k, v ) )
		end
		--print( "Done." )
		local resultTable = JSON:decode(result.Body)
		resultTable = Quests:GetQuestDataFromJSON(resultTable)
		if msg.complete == 1 then
			local quest_level = msg.quest_level
			Quests:QuestComplete(quest_level, hero, Vector(-13888, 14464))
			CustomGameEventManager:Send_ServerToPlayer(player, "close_crusader", {result = resultTable, player = playerID, unlock = 1, gameProgress = Quests:GetGameProgressTable()})
		else
			CustomGameEventManager:Send_ServerToPlayer(player, "crusader_quests_loaded", {result = resultTable, player = playerID, unlock = 1, gameProgress = Quests:GetGameProgressTable()})
		end
	end)
end

function Quests:QuestComplete(quest_level, hero, location)
	Quests.itemLevel = math.floor(quest_level * 3)
	local itemCount = 3
	local luck = RandomInt(1, 10)
	if luck == 10 then
		itemCount = 5
	elseif luck > 7 then
		itemCount = 4
	end
	for i = 1, itemCount, 1 do
		RPCItems:RollItemtype(300, location, 5, 2)
	end
	local XPbonus = Quests:GetQuestRewardXP(quest_level)
	PopupExperience(hero, XPbonus)
	hero:AddExperience(XPbonus, 0, false, false)
	Quests.itemLevel = nil

	-- RPCItems:RollReanimationStone(location)
end

function Quests:GetGameProgressTable()
	local gameProgressTable = {}
	gameProgressTable.chieftain = GameState.chieftain
	gameProgressTable.neverlord = GameState.neverlord
	gameProgressTable.jonuous = GameState.jonuous
	gameProgressTable.wraithkeeper = GameState.wraithkeeper
	gameProgressTable.gazbinceo = GameState.gazbinceo
	gameProgressTable.silithicus = GameState.silithicus
	gameProgressTable.razormore = GameState.razormore
	gameProgressTable.majinaq = GameState.majinaq
	gameProgressTable.keeper = GameState.keeper
	gameProgressTable.count = GameState.count
	gameProgressTable.rentiki = GameState.rentiki
	gameProgressTable.starblight = GameState.starblight
	gameProgressTable.phoenix = GameState.phoenix
	return gameProgressTable
end

function Quests:SpiritItemPlace(msg)
	local playerID = msg.playerID
	local heroIndex = msg.heroIndex
	local itemIndex = msg.itemIndex
	local player = PlayerResource:GetPlayer(playerID)
	local hero = EntIndexToHScript(heroIndex)
	local item = EntIndexToHScript(itemIndex)
	hero:TakeItem(item)
	if IsValidEntity(item:GetContainer()) then
		UTIL_Remove(item:GetContainer())
	end
	Timers:CreateTimer(0.05, function()
		hero:Stop()
	end)
	CustomGameEventManager:Send_ServerToPlayer(player, "witch_doctor_item_placed", {itemIndex = itemIndex})
end

function Quests:CloseWitchDoctor(msg)
	local playerID = msg.playerID
	local heroIndex = msg.heroIndex
	local wind = msg.wind
	local water = msg.water
	local fire = msg.fire
	local hero = EntIndexToHScript(heroIndex)

	if wind > 0 then
		local item = EntIndexToHScript(wind)
		RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
	end
	if water > 0 then
		local item = EntIndexToHScript(water)
		RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
	end
	if fire > 0 then
		local item = EntIndexToHScript(fire)
		RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
	end
end

function Quests:WitchDoctorCombine(msg)
	local hero = EntIndexToHScript(msg.heroIndex)
	Tanari:WitchDoctorCombine(hero, msg.difficulty)
end

function Quests:TownPortal(msg)
	local playerID = msg.playerID
	local heroIndex = msg.heroIndex
	local hero = EntIndexToHScript(heroIndex)
	-- hero:RemoveAbility("rpc_hero_town_portal")
	local townPortalAbility = hero:FindAbilityByName("rpc_hero_town_portal")
	if GameState:IsPVPAlpha() then
		return false
	end
	if hero:HasAbility("rpc_respawn_flag") then
		hero:RemoveAbility("rpc_respawn_flag")
	end
	if not townPortalAbility then
		hero.baseUlt = hero:GetAbilityByIndex(DOTA_D_SLOT)
		townPortalAbility = hero:AddAbility("rpc_hero_town_portal")
		townPortalAbility:SetLevel(1)
	end
	townPortalAbility:SetActivated(true)
	townPortalAbility:SetStolen(true)
	-- townPortalAbility:SetAbilityIndex(3)
	-- hero:SwapAbilities(hero.baseUlt:GetAbilityName(), "rpc_hero_town_portal", false, true)
	local newOrder = {
		UnitIndex = hero:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = townPortalAbility:entindex(),
		Queue = 0,
	}

	ExecuteOrderFromTable(newOrder)

end

function Quests:RespawnFlag(msg)
	local playerID = msg.playerID
	local heroIndex = msg.heroIndex
	local hero = EntIndexToHScript(heroIndex)
	local color = msg.color
	-- hero:RemoveAbility("rpc_hero_town_portal")
	local townPortalAbility = hero:FindAbilityByName("rpc_respawn_flag")
	if GameState:IsPVPAlpha() then
		return false
	end
	if not townPortalAbility then
		hero.baseUlt = hero:GetAbilityByIndex(DOTA_D_SLOT)
		townPortalAbility = hero:AddAbility("rpc_respawn_flag")
		townPortalAbility:SetLevel(1)
	end
	if hero:HasAbility("rpc_hero_town_portal") then
		hero:RemoveAbility("rpc_hero_town_portal")
	end
	townPortalAbility:SetActivated(true)
	townPortalAbility:SetStolen(true)
	townPortalAbility.color = color
	local enemies = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		Notifications:Top(playerID, {text = "tooltip_enemies_nearby", duration = 5, style = {color = "#FF1111"}, continue = true})
	else
		local newOrder = {
			UnitIndex = hero:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = townPortalAbility:entindex(),
			Queue = 0,
		}

		ExecuteOrderFromTable(newOrder)
	end
end

function Quests:ArenaDialogue(msg)
	if GameState:IsRPCArena() then
		Arena:ArenaDialogue(msg)
	elseif GameState:IsRedfallRidge() then
		Redfall:DialogueAnswer(msg)
		if msg.dummy then
			Quests:DummyFromClient(msg)
		end
	else
		if msg.dummy then
			Quests:DummyFromClient(msg)
		end
	end
end

function Quests:DummyFromClient(msg)
	local playerID = msg.playerID
	local hero = false
	if playerID then
		hero = GameState:GetHeroByPlayerID(playerID)
	end
	--print("ANYTHNG?")
	if msg.exit then
		local dummy = hero.targetDummy
		hero:RemoveModifierByName("modifier_attacking_dummy")
		dummy:RemoveModifierByName("modifier_dummy_active")
		dummy:RemoveModifierByName("modifier_black_King_bar_immunity")
		dummy:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
		dummy:RemoveModifierByName("modifier_dummy_attacking")
		dummy:SetBaseRoshpitArmor(0, false)
		dummy:SetBaseRoshpitMagicArmor(0, false)
		dummy:CalculateAndSaveRoshpitAttributes()
	elseif msg.timer then
		local dummy = hero.targetDummy
		local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
		dummyAbility:ApplyDataDrivenModifier(dummy, hero, "modifier_dummy_timer", {duration = 7})
		dummy.timerDamage = 0
		--print("DUMMY TIMER START")
		for i = 1, 35, 1 do
			Timers:CreateTimer(i * 0.2, function()
				local DPS = math.floor(dummy.timerDamage / (i * 0.2))
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "updateDPSLabel", {dps = DPS})
			end)
		end
	elseif msg.armor or msg.attack then
		local dummy = hero.targetDummy
		if tonumber(msg.armor) then
			dummy:SetBaseRoshpitArmor(tonumber(msg.armor), false)
			Events:TutorialServerEvent(hero, "4_5", 2)
		end	
		if tonumber(msg.magicArmor) then
			dummy:SetBaseRoshpitMagicArmor(tonumber(msg.magicArmor), false)
			Events:TutorialServerEvent(hero, "4_5", 2)
		end
		dummy:CalculateAndSaveRoshpitAttributes()
		if tonumber(msg.attack) then
			local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
			if tonumber(msg.attack) >= 0 then
				dummy:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
				dummyAbility:ApplyDataDrivenModifier(dummy, dummy, "modifier_dummy_attacking", {})
				dummy:SetRangedProjectileName("particles/econ/items/keeper_of_the_light/kotl_weapon_arcane_staff/keeper_base_attack_arcane_staff.vpcf")
				dummy.attack_input = msg.attack
			else
				dummy:RemoveModifierByName("modifier_dummy_attacking")
				dummy:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
			end
		else
			dummy:RemoveModifierByName("modifier_dummy_attacking")
			dummy:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
		end
	elseif msg.magic_immune then
		local dummy = hero.targetDummy
		local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
		if dummy:HasModifier("modifier_black_King_bar_immunity") then
			dummy:RemoveModifierByName("modifier_black_King_bar_immunity")
		else
			Events:TutorialServerEvent(hero, "4_5", 3)
			dummyAbility:ApplyDataDrivenModifier(dummy, dummy, "modifier_black_King_bar_immunity", {})
		end
	end
end

function Quests:NPCDialogue(msg)
	if msg.type == "supplies_dealer" then
		local playerID = msg.playerID
		local hero = EntIndexToHScript(msg.heroIndex)
		local potionType = msg.item
		local tier = msg.tier
		local rarity = "uncommon"
		if tier == 3 then
			rarity = "rare"
		end
		local cost = tier * 10000
		local gold = PlayerResource:GetGold(playerID)
		if gold >= cost then
			EmitSoundOnClient("SuppliesDealer.Buy", PlayerResource:GetPlayer(playerID))
			local potion = RPCItems:CreateConsumable(potionType, rarity, "potion", "consumable", false, "Consumable", "DOTA_Tooltip_ability_"..potionType.."_Description")
			potion.cantStash = true
			RPCItems:GiveItemToHeroWithSlotCheck(hero, potion)
			EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "SuppliesDealer.BuyVO"..RandomInt(1, 6), hero)
			PlayerResource:SpendGold(playerID, cost, 0)
		else
			EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
		end
	end
end

function Quests:QuestLog(msg)
	local playerID = msg.playerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = EntIndexToHScript(msg.heroIndex)
	local questlog = nil
	if GameState:IsRedfallRidge() then
		questlog = hero.RedfallQuests
	end
	CustomGameEventManager:Send_ServerToPlayer(player, "open_quest_log", {questlog = questlog, maxQuests = Redfall.TOTAL_QUESTS, bFade = msg.bFade})
end

function Quests:QuestLogComplete(msg)
	local playerID = msg.playerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = EntIndexToHScript(msg.heroIndex)
	Redfall:QuestComplete(hero, msg.questIndex)
end

function Quests:ShowDialogueText(activators, unit, unitText, time, bLeash)
	if not activators then
		return false
	end
	for i = 1, #activators, 1 do
		--print("DIALOGUE TEST?")
		local hero = activators[i]
		local headerText = unit:GetUnitName()
		local messageText = unitText
		local nameColorClass = "enemy_name"
		if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			nameColorClass = "allied_name"
		end
		--print(headerText)
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "basic_dialogue", {portraitHero = portraitHero, unitName = headerText, messageText = messageText, nameColorClass = nameColorClass, timeLock = time})
		hero.dialogueTime = GameRules:GetGameTime() + time

		-- if bLeash then
		-- Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_dialogue_leash", {duration = time})
		-- hero.dialogueUnit = unit
		-- end
		-- Timers:CreateTimer(time, function()
		-- if hero.dialogueTime >= GameRules:GetGameTime() - 0.1 then
		-- hero:RemoveModifierByName("modifier_dialogue_leash")
		-- CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_basic_dialogue", {})
		-- end
		-- end)
	end
end

function Quests:ShowDialogueTextAzalea(activators, unit, unitText, time, bLeash)
	if not activators then
		return false
	end
	for i = 1, #activators, 1 do
		--print("DIALOGUE TEST?")
		local hero = activators[i]
		local headerText = unit:GetUnitName()
		local messageText = unitText
		local nameColorClass = "enemy_name"
		if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			nameColorClass = "allied_name"
		end
		--print(headerText)
		CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "basic_dialogue", {portraitHero = portraitHero, unitName = headerText, messageText = messageText, nameColorClass = nameColorClass, timeLock = time, azalea = true})
		hero.dialogueTime = GameRules:GetGameTime() + time
	end
end

function Quests:CloseAltarOfIce(msg)
	Winterblight:CloseAltarOfIce(msg)
end

function Quests:PlaceIceCrystal(msg)
	Winterblight:CrystalPlaced(msg)
end

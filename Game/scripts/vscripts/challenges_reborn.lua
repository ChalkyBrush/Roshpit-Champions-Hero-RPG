if Challenges == nil then
	Challenges = class({})
	Challenges.ParagonDivisor = 1
	Challenges.MagicArmorMult = 1
	Challenges.SpellPierceMult = 1
	Challenges.ArmorMult = 1
	Challenges.ArmorPierceMult = 1
	Challenges.BonusHPMult = 1
	Challenges.SpeedMult = 1
end

function Challenges:GetChallengeFromRoshpitServer()
	if Challenges.main_challenge then
		return false
	end
	-- if GameState:GetDifficultyFactor() == 3 then
		local url = ROSHPIT_URL.."/champions/get_challenges?"
		local steamIDS = ""
		for i = 1, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS), 1 do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
			local steam_id = PlayerResource:GetSteamAccountID(playerID)
			steamIDS = steamIDS..steam_id
			if i < PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) then
				steamIDS = steamIDS.."-"
			end
		end
		url = url.."steam_ids="..steamIDS
		CreateHTTPRequestScriptVM("GET", url):Send(function(result)
			local resultTable = {}
			--print( "GET response:\n" )
			for k, v in pairs(result) do
				--print( string.format( "%s : %s\n", k, v ) )
			end
			--print( "Done." )
			local resultTable = JSON:decode(result.Body)
			--print(resultTable)
			Challenges:ProcessChallengeResult(resultTable)
		end)
	-- end
end

function Challenges:ProcessChallengeResult(result)
	DeepPrintTable(result)
	Challenges.main_challenge = result["main"]
	Challenges.web_challenge = result["web_premium"]
	Challenges:CheckSpawn()
end

function Challenges:CheckSpawn()
	if Challenges.Crusader then
		return false
	end
	local challenges_list = {Challenges.main_challenge, Challenges.web_challenge}
	for i = 1, #challenges_list, 1 do
		local full_challenge = challenges_list[i]
		local challenge_table = challenges_list[i]["challenge"]
		if Challenges:HeroMatch(full_challenge) and Challenges:MapMatch(challenge_table) and Challenges:DifficultyModMatch(challenge_table) and Challenges:IsThereAtLeastOneUnclearedPlayer(challenges_list[i]) then
			Challenges:SpawnByMap()
		end
	end
end

function Challenges:AreConditionsValidForChallenge(challenge)
	local challenge_table = challenge["challenge"]
	if Challenges:HeroMatch(challenge) and Challenges:MapMatch(challenge_table) and Challenges:DifficultyModMatch(challenge_table) and Challenges:IsThereAtLeastOneUnclearedPlayer(challenge) then
		return true
	else
		return false
	end
end

function Challenges:HeroMatch(challenge_table)
	local proceed = true
	print("--------")
	DeepPrintTable(challenge_table["mods"])
	for i = 1, #challenge_table["mods"], 1 do
		local mod = challenge_table["mods"][i]
		if mod["mod_type"] == "hero_limit" then
			print("CHALLENGES: HERO LIMIT")
			if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) > mod["mod_int1"] then
				print("LIMIT PASS FAIL")
				proceed = false
				break
			end
		end
		if mod["mod_type"] == "hero_spec" then
			print("CHALLENGES: HERO SPEC")
			for i = 1, #MAIN_HERO_TABLE, 1 do
				if MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string1"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string2"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string3"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string4"] and MAIN_HERO_TABLE[i]:GetUnitName() ~= mod["mod_string5"] then
					print("HERO CHECK FAIL")
					proceed = false
					break
				end
			end
		end
	end
	return proceed
end

function Challenges:MapMatch(challenge_table)
	if challenge_table["map_name"] == GetMapName() then
		return true
	else
		return false
	end
end

function Challenges:IsThereAtLeastOneUnclearedPlayer(challenge_table)
	if challenge_table["clears"] and #challenge_table["clears"] >= PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) then
		return false
	else
		return true
	end
end

function Challenges:DifficultyModMatch(challenge_table)
	local mod_match = true
	if challenge_table["map_name"] == "rpc_tanari_jungle" and challenge_table["difficulty_mod"] == 1 then
		if Events.SpiritRealm then
			mod_match = true
		else
			mod_match = false
		end
	end
	if challenge_table["map_name"] == "rpc_redfall_ridge" and challenge_table["difficulty_mod"] == 1 then
		if Events.SpiritRealm then
			mod_match = true
		else
			mod_match = false
		end
	end
	if challenge_table["map_name"] == "rpc_winterblight_mountain" and challenge_table["difficulty_mod"] > 0 then
		if Winterblight then
			if Winterblight.Stones >= challenge_table["difficulty_mod"] then
				mod_match = true
			else
				mod_match = false
			end
		else
			mod_match = false
		end
	end
	if challenge_table["map_name"] == "rpc_roshpit_arena" and challenge_table["difficulty_mod"] > 0 then
		if Arena then
			if Arena.PitLevel >= challenge_table["difficulty_mod"] then
				mod_match = true
			else
				mod_match = false
			end
		else
			mod_match = false
		end
	end
	return mod_match
end

function Challenges:SpawnByMap()
	if Challenges.Crusader then
		return false
	end
	PrecacheUnitByNameAsync("the_crusader", function(...) end)
	if GetMapName() == "rpc_tanari_jungle" then
		Challenges:SpawnCrusaderNow(Vector(-4416, 1069), Vector(-1, 0))
	elseif GetMapName() == "rpc_redfall_ridge" then
		Challenges:SpawnCrusaderNow(Vector(-13530, -15232), Vector(0,1))
	elseif GetMapName() == "rpc_winterblight_mountain" then
		Challenges:SpawnCrusaderNow(Vector(-13979, -1664), Vector(0,-1))
	elseif GetMapName() == "rpc_roshpit_arena" then
		Challenges:SpawnCrusaderNow(Vector(-13979, -1664), Vector(0,-1))
	elseif GetMapName() == "rpc_sea_fortress" then
		Challenges:SpawnCrusaderNow(Vector(896, -14592), Vector(-1,-1))
	end	
end

function Challenges:ProcessPossibleSpawnEvent(value)
	if Challenges.Crusader then
		return false
	end
	Challenges:CheckSpawn()
end

function Challenges:ChallengeWinEvent(event)
end

function Challenges:SpawnCrusaderNow(position, fv)
	print("SPAWN CRUSADER")
 	if Challenges.Crusader then
 		UTIL_Remove(Challenges.Crusader)
 	end
	Challenges.CrusaderSpawned = true
	Challenges.Crusader = CreateUnitByName("the_crusader", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	-- Challenges.Crusader:SetAbsOrigin(Challenges.Crusader:GetAbsOrigin()+Vector(0,0,1000))
	Events:smoothSizeChange(Challenges.Crusader, 0.01, 1.14, 66)
	Timers:CreateTimer(0.9, function()
		CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", Challenges.Crusader, 4)
		EmitSoundOn("Challenges.Crusader.Enter", Challenges.Crusader)
	end)
	Timers:CreateTimer(2.3, function()
		EmitSoundOn("Challenges.Crusader.VOEnter", Challenges.Crusader)
	end)
	Challenges.Crusader:FindAbilityByName("town_unit"):SetLevel(1)
	Challenges.Crusader:FindAbilityByName("npc_dialogue"):SetLevel(1)
	Challenges.Crusader.dialogueName = "crusader"
	Challenges.Crusader:SetForwardVector(fv)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Challenges.Crusader:GetAbsOrigin(), 700, 8, false)
	Timers:CreateTimer(0.5, function()
		StartAnimation(Challenges.Crusader, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_3, rate = 0.8})
	end)
end

function Challenges:ShouldWeSpawnCrusader(challenge)
end

function Challenges:ProcessEvent(event_name)
end

function Challenges:PanoramaInput(msg)
	print("START CHALLENGE")
	print(msg.challenge_type)
	CustomGameEventManager:Send_ServerToAllClients("close_crusader", {} )
	if msg.event_type == "start" then
		if Challenges.ActiveChallenge then
			return false
		end
		if Challenges.Crusader.disabled then
			return false
		end
		for i = 1, #MAIN_HERO_TABLE, 1 do
			CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", MAIN_HERO_TABLE[i], 4)
			EmitSoundOn("Challenges.Crusader.Enter", MAIN_HERO_TABLE[i])
		end
		Notifications:BottomToAll({text = "ui_challenge_started", duration = 4.2})
		local challenge_text = msg.challenge_text
		for _, mod in pairs(msg.mod_array) do
			challenge_text = challenge_text .. "<br>"..mod
		end
		print(challenge_text)
		Timers:CreateTimer(4.2, function()
			Notifications:BottomToAll({text = challenge_text, duration = 10.0})
		end)
		EmitGlobalSound("UI.CrusaderAccept.Music")
		if msg.challenge_type == "main" and Challenges:AreConditionsValidForChallenge(Challenges.main_challenge) then
			Challenges.ActiveChallenge = Challenges.main_challenge
		end
		if msg.challenge_type == "web" and Challenges:AreConditionsValidForChallenge(Challenges.web_challenge) then
			Challenges.ActiveChallenge = Challenges.web_challenge
		end
		StartAnimation(Challenges.Crusader, {duration = 2.5, activity = ACT_DOTA_CAST_ABILITY_1, rate = 0.8})
		EmitSoundOn("Challenges.Crusader.VOStart", Challenges.Crusader)
		Timers:CreateTimer(2.5, function()
			Challenges:DespawnCrusader()
		end)
		if Challenges.ActiveChallenge["clears"] then
			for i = 1, #Challenges.ActiveChallenge["clears"], 1 do
				for j = 1, #MAIN_HERO_TABLE, 1 do
					local hero = MAIN_HERO_TABLE[j]
					local playerID = hero:GetPlayerOwnerID()
					local steamID = PlayerResource:GetSteamAccountID(playerID)
					if Challenges.ActiveChallenge["clears"][i]["steam_id"] == steamID then
						hero.challenge_cleared = true
					end
				end
			end
			for i = 1, #MAIN_HERO_TABLE, 1 do
				if MAIN_HERO_TABLE[i].challenge_cleared then
					local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
					Notifications:Top(playerID, {text="You have already cleared this Challenge", duration=4, style={color="#FFDDAA"}, continue=true})
				end
			end
		end
	elseif msg.event_type == "purchase_exp_orb" then
		local item = nil
		local playerID = msg.PlayerID
		local mithril = CustomNetTables:GetTableValue("player_stats", tostring(playerID) .. "-mithril").mithril
		local amount = 100000
		if msg.action == "exp-orb-1" then
			amount = 100000
			if mithril >= amount then
				item = Challenges:CreateEXPOrb()
			else
				return false
			end
		elseif msg.action == "exp-orb-2" then
			amount = 1000000
			if mithril >= amount then
				item = Challenges:CreateGreaterEXPOrb()
			else
				return false
			end
		end
		local hero = GameState:GetHeroByPlayerID(playerID)
		local cost = amount*-1
		Challenges:ModifyMithril(cost, hero, "exp-orb")
		RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
		CustomAbilities:QuickAttachParticle("particles/roshpit/exp_orb.vpcf", hero, 3)
		EmitSoundOn("RPCItems.PurchaseExpOrb", hero)
		StartAnimation(Events.ElderRai, {duration = 1.5, activity = ACT_DOTA_RUN, rate = 1.2})
	elseif msg.event_type == "refine_inventory_gemstones" then
		local playerID = msg.PlayerID
		local amount = 0
		local hero = GameState:GetHeroByPlayerID(playerID)
		--COLLECT GEMSTONE COUNT AND REMOVE THEM
		for i = 0, 8, 1 do
			if IsValidEntity(hero:GetItemInSlot(i)) then
				local item_check = hero:GetItemInSlot(i)
				if item_check:GetAbilityName() == "item_rpc_unrefined_gemstones" then
					amount = amount + item_check.newItemTable.property1
					UTIL_Remove(item_check)
				end
			end
		end
		if amount == 0 then
			return false
		end
		--ANIMATION SEQUENCE
		StartAnimation(Events.ElderRai, {duration = 1.5, activity = ACT_DOTA_SPAWN, rate = 1.2})
		local attachPointA = Events.ElderRai:GetAbsOrigin()+Vector(0,0,80)
		local attachPointB = hero:GetAbsOrigin()+Vector(0,0,120)
		local particleName = "particles/roshpit/arkimus/zonis_lightning.vpcf"
		local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
		ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(lightningBolt, false)
			ParticleManager:ReleaseParticleIndex(lightningBolt)
		end)
		CustomAbilities:QuickAttachParticle("particles/roshpit/challenges/win_pop.vpcf", hero, 3)
		EmitSoundOn("ElderRai.RefinePop", Events.ElderRai)
		EmitSoundOn("ElderRai.RefineCut", hero)
		EmitSoundOn("Challenges.RewardPopEnd", hero)
		Quests:ShowDialogueText({hero}, Events.ElderRai, "elder_rai_cut", 4, true)
		--ADD GEMSTONES
		local reason = "refine_gemstones"
		Gems:ModifyPrismaticGemstones(playerID, amount, reason, "add")
	end
end

function Challenges:DespawnCrusader()

	CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", Challenges.Crusader, 4)
	EmitSoundOn("Challenges.Crusader.Enter", Challenges.Crusader)
	EmitSoundOn("Challenges.Crusader.VOEnter", Challenges.Crusader)
	Events:smoothSizeChange(Challenges.Crusader, 1.14, 0.01, 66)
	StartAnimation(Challenges.Crusader, {duration = 1.5, activity = ACT_DOTA_OVERRIDE_ABILITY_3, rate = 0.8})
	Timers:CreateTimer(1.9, function()
		CustomAbilities:QuickAttachParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", Challenges.Crusader, 4)
		EmitSoundOn("Challenges.Crusader.Exit", Challenges.Crusader)
	end)
	Timers:CreateTimer(2.2, function()
		UTIL_Remove(Challenges.Crusader)
		Challenges.Crusader = nil
	end)
end

function Challenges:MainBossSlainEvent(boss_name)
	if Challenges.ChallengeCompleted then
		return false
	end
	if Challenges.ActiveChallenge["challenge"]["objective"] == boss_name then
		Challenges.ChallengeCompleted = true
		Challenges:SetChallengeClears()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			if MAIN_HERO_TABLE[i].hero.challenge_cleared then
				Notifications:Top(MAIN_HERO_TABLE[i]:GetPlayerOwnerID(), {text="You have already cleared this Challenge", duration=4, style={color="#FFDDAA"}, continue=true})
			else
				local hero = MAIN_HERO_TABLE[i]
				local playerID = hero:GetPlayerOwnerID()
				local steamID = PlayerResource:GetSteamAccountID(playerID)
				Challenges:RewardSequenceForHero(hero)
			end
		end
	end
end

function Challenges:RewardSequenceForHero(hero)
	print("REWARD SEQUENCE")
	CustomAbilities:QuickAttachParticle("particles/econ/taunts/ursa/ursa_unicycle/ursa_unicycle_taunt_spotlight.vpcf", hero, 10)
	Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_challenge_win_float", {duration = 5})
	EmitSoundOn("UI.Challenge.WinStart", hero)
	Timers:CreateTimer(1, function()
		EmitSoundOn("UI.Crusader.Win", hero)
		Notifications:BottomToAll({text = "ui_challenge_completed", duration = 7.0})
	end)
	Timers:CreateTimer(2, function()
		CustomAbilities:QuickAttachParticle("particles/roshpit/challenges/challenge_complete.vpcf", hero, 4)
		CustomAbilities:QuickAttachParticle("particles/econ/taunts/ursa/ursa_unicycle/ursa_unicycle_taunt_spotlight.vpcf", hero, 10)
	end)
	local reward = 10
	Timers:CreateTimer(5, function()
		CustomAbilities:QuickAttachParticle("particles/roshpit/challenges/win_pop.vpcf", hero, 3)
		EmitSoundOn("Challenges.RewardPopEnd", hero)
		-- Challenges:CreateUnrefinedGemstonesForHero(hero, Challenges.ActiveChallenge["challenge"]["reward"])
		local gemstones_item = Gems:CreateUnrefinedGemstones(reward)
		RPCItems:GiveItemToHeroWithSlotCheck(hero, gemstones_item)
	end)
	-- C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\content\dota\particles\econ\items\monkey_king\mk_ti9_immortal\mk_ti9_immortal_army_cast.vpcf
end

function Challenges:SpawnElderRai(position, fv)
	Events.ElderRai = CreateUnitByName("elder_rai", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	Events.ElderRai:SetForwardVector(fv)
	Events.ElderRai:FindAbilityByName("town_unit"):SetLevel(1)
	Events.ElderRai:FindAbilityByName("npc_dialogue"):SetLevel(1)
	Events.ElderRai.dialogueName = "elder_rai"
end

function Challenges:UnitDiedForCrusader(killedUnit, killerEntity)
	if not Challenges.Crusader then
		return false
	end
	if not Challenges.units_slain then
		Challenges.units_slain = 0
	end
	Challenges.units_slain = Challenges.units_slain + 1
	local unitName = killedUnit:GetUnitName()
	if unitName == "winterblight_living_ice" or unitName == "winterblight_heartfreezer" or unitName == "winterblight_mountain_lord" then
		Challenges.units_slain = Challenges.units_slain - 1
	end
	if Challenges.units_slain == 40 then
		Challenges.Crusader.disabled = true
		CustomGameEventManager:Send_ServerToAllClients("close_crusader", {} )
		Challenges:DespawnCrusader()
	end
end

function Challenges:CreateEXPOrb()
	local item = RPCItems:CreateConsumable("item_rpc_exp_orb", "mythical", "EXP Orb", "consumable", false, "Consumable", "item_rpc_exp_orb_description")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	item.pickedUp = true
	RPCItems:ItemUpdateCustomNetTables(item)
	return item
end

function Challenges:CreateGreaterEXPOrb()
	local item = RPCItems:CreateConsumable("item_rpc_greater_exp_orb", "mythical", "Unrefined Gemstones", "consumable", false, "Consumable", "item_rpc_greater_exp_orb_description")
	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	item.pickedUp = true
	RPCItems:ItemUpdateCustomNetTables(item)
	return item
end

function Challenges:SetChallengeClears()
	local url = ROSHPIT_URL.."/champions/set_challenge_clears?"
	local steamIDS = ""
	for i = 1, #MAIN_HERO_TABLE, 1 do
		local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
		local steam_id = PlayerResource:GetSteamAccountID(playerID)
		steamIDS = steamIDS..steam_id
		if i < #MAIN_HERO_TABLE then
			steamIDS = steamIDS.."-"
		end
	end
	print(steamIDS)
	url = url.."steam_ids="..steamIDS
	url = url.."&challenge_id="..Challenges.ActiveChallenge["challenge"]["id"]
	CreateHTTPRequestScriptVM("POST", url):Send(function(result)
		local resultTable = {}
		--print( "GET response:\n" )
		for k, v in pairs(result) do
			--print( string.format( "%s : %s\n", k, v ) )
		end
		--print( "Done." )
		local resultTable = JSON:decode(result.Body)
		print(resultTable)
	end)
end

function Challenges:AdjustUnitForChallenge(unit, unit_level, enemyTier)
	if not Challenges.ActiveChallenge then
		return false
	end
end
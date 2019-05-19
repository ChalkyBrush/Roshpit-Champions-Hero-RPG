function Tutorial:InitTutorialMap()
  print("Initialize Tutorial")
  Dungeons.phoenixCollision = true
  RPCItems.DROP_LOCATION = Vector(-16000,492)
  Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
  Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
  Events.GameMaster:RemoveModifierByName("modifier_portal")

  Tutorial.ZFLOAT = 0
  Events.TownPosition = Vector(-2830, -2881)
  Events.isTownActive = true

  Dungeons.itemLevel = 1
  Tutorial:NatureAmbience()
  Tutorial:WaterfallAmbience()

  Tutorial:SpawnTutorialMaster(Vector(-64, 2176))
end

function Tutorial:SpawnOracle()
	if not Tutorial.OracleSpawned then
		Tutorial.OracleSpawned = true
		local oracle = Events:SpawnOracle(Vector(-2842, -1943), Vector(-0.3, -1))
	end
end

function Tutorial:Debug()
	local deathLocation = Vector(-3242, -2143)
	-- local hero = MAIN_HERO_TABLE[1]
	-- local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
	-- local question = "tutorial_quiz_question_7"
	-- local sub_number = RandomInt(1,2)
	-- local gsub1 = "tutorial_quiz_question_7_sub_answer"..sub_number
	-- local verifier = "item_rarity_immortal"
	-- if sub_number == 2 then
	-- 	verifier = "item_rarity_arcana"
	-- end
	-- local buttons = {"item_rarity_uncommon", "item_rarity_rare", "item_rarity_mythical", "item_rarity_immortal", "item_rarity_arcana"}
	-- CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="3_1", quiz_question=question, sequence=2, verifier = verifier, localize_verifier = 1, challenge_progress = 2, gsub1 = gsub1, buttons = buttons} )
	-- CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
    -- Weapons:RollLegendWeapon1(Vector(-2842, -1943), "warlord")
    -- Weapons:RollLegendWeapon2(Vector(-2842, -1943), "warlord")
    -- Weapons:RollLegendWeapon3(Vector(-2842, -1943), "warlord")
    -- RPCItems:RollChernobogArcana2(deathLocation)
    -- Runes:EquipArcana(MAIN_HERO_TABLE[1], 2)
    -- Glyphs:RollGlyphAll("item_rpc_zonik_glyph_5_a", deathLocation, 0)
end

function Tutorial:SpawnAllTownNPCs()
	if not Tutorial.OracleSpawned then
		Tutorial:SpawnOracle()
	end
	if not Tutorial.NPCSspawned then
	  Timers:CreateTimer(0, function()
	      local blacksmith = Events:SpawnTownNPC(Vector(-1995, -3412), "red_fox", Vector(1, 0.8), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
	      StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
	      Tutorial.Blacksmith = blacksmith
	      Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-1537, -1547), Vector(-0.2, -1))
	      Events:SpawnCurator(Vector(-320, -1472), Vector(0,-1))
	      Tutorial:BlacksmithSounds()
	  end)
	  Tutorial.NPCSspawned = true
	end
end

function Tutorial:SpawnTrainingDummies()
	local positionTable = {Vector(1044, 2953), Vector(1741, 2953), Vector(2304, 2752), Vector(2632, 2463), Vector(2729, 2046)}
	local fvTable = {Vector(0,-1), Vector(0,-1), Vector(-1,-1), Vector(-1,-0.5), Vector(-1,0)}
	local indexTable = {-90, -90, -110, -120, -180}
	for i =1, #positionTable, 1 do
		local dummy = CreateUnitByName("arena_training_dummy", positionTable[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		dummy:SetForwardVector(fvTable[i])
		dummy.angle = indexTable[i]
		dummy.targetPosition = dummy:GetAbsOrigin()
		dummy.pushLock = true
	end
end

function Tutorial:SpawnTrainingDummyForHero(hero)
	if not hero.tutorial_dummy_spawned then
		hero.tutorial_dummy_spawned = true
		if not Tutorial.dummies_count then
			Tutorial.dummies_count = 0
		end
		Tutorial.dummies_count = Tutorial.dummies_count + 1
		local positionTable = {Vector(1044, 2953), Vector(1741, 2953), Vector(2304, 2752), Vector(2632, 2463), Vector(2729, 2046)}
		local fvTable = {Vector(0,-1), Vector(0,-1), Vector(-1,-1), Vector(-1,-0.5), Vector(-1,0)}
		local indexTable = {-90, -90, -110, -120, -180}
		local i = Tutorial.dummies_count
		local dummy = CreateUnitByName("arena_training_dummy", positionTable[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		dummy:SetForwardVector(fvTable[i])
		dummy.angle = indexTable[i]
		dummy.targetPosition = dummy:GetAbsOrigin()
	end
end

function Tutorial:WaterfallAmbience()
	Timers:CreateTimer(3, function()
		EmitSoundOnLocationWithCaster(Vector(2368, 854), "Tutorial.Waterfall", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(-576, 528), "Tutorial.River", Events.GameMaster)
		return 20
	end)
end

function Tutorial:NatureAmbience()
	local ambiencePoints = {Vector(-1536, -1536), Vector(-320, 3010)}
	Timers:CreateTimer(0, function()
		for i = 1, #ambiencePoints, 1 do
			EmitSoundOnLocationWithCaster(ambiencePoints[i], "Tutorial.NatureAmbience", Events.GameMaster)
		end
		return 145
	end)
end

function Tutorial:BlacksmithSounds()
	Timers:CreateTimer(5, function()
		local luck = RandomInt(1, 3)
		if luck < 3 then
			EmitSoundOnLocationWithCaster(Vector(-1899, -3303), "Tutorial.BlacksmithCasual", Events.GameMaster)
			StartAnimation(Tutorial.Blacksmith, {duration=3, activity=ACT_DOTA_TAUNT, rate=1.0})
			Timers:CreateTimer(3, function()
				StartAnimation(Tutorial.Blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
			end)
		end
		return 15
	end)
	
end

function Tutorial:SpawnTutorialMaster(position)
	local master = CreateUnitByName("tutorial_master", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
	master:AddAbility("tutorial_master_ability"):SetLevel(1)
	master:SetForwardVector(Vector(1,0))
	master.speech_phase = {}
	Tutorial.Master = master
end

function Tutorial:ApplyTutorialModifier(modifierName, unit, duration)
	local ability = Tutorial.Master:FindAbilityByName("tutorial_master_ability")
	if duration > 0 then
		ability:ApplyDataDrivenModifier(Tutorial.Master, unit, modifierName, {duration = duration})
	else
		ability:ApplyDataDrivenModifier(Tutorial.Master, unit, modifierName, {})
	end
end

function Tutorial:GetTutorialDataArray(hero, code)
	if code == "progress" then
		return {hero.tutorial.section1.progress, hero.tutorial.section2.progress, hero.tutorial.section3.progress, hero.tutorial.section4.progress, hero.tutorial.section5.progress, hero.tutorial.section6.progress, hero.tutorial.section7.progress, hero.tutorial.section8.progress}
	elseif code == "reward" then
		return {hero.tutorial.section1.reward, hero.tutorial.section2.reward, hero.tutorial.section3.reward, hero.tutorial.section4.reward, hero.tutorial.section5.reward, hero.tutorial.section6.reward, hero.tutorial.section7.reward, hero.tutorial.section8.reward}
	end
end

function Tutorial:LoadTutorialDataForHero(hero, resultTable)
	if not hero.tutorial then
		hero.tutorial = {}
	end
	hero.tutorial.section1 = {}
	hero.tutorial.section1.progress = resultTable.progress1
	hero.tutorial.section1.state = 0
	hero.tutorial.section1.reward = resultTable.reward1
	if hero.tutorial.section1.reward == 1 then
		Tutorial:ActivatePortal(false)
	end
	hero.tutorial.section2 = {}
	hero.tutorial.section2.progress = resultTable.progress2
	hero.tutorial.section2.state = 0
	hero.tutorial.section2.reward = resultTable.reward2
	if hero.tutorial.section2.reward == 1 then
		Tutorial:SpawnAllTownNPCs()
	end
	hero.tutorial.section3 = {}
	hero.tutorial.section3.progress = resultTable.progress3
	hero.tutorial.section3.state = 0
	hero.tutorial.section3.reward = resultTable.reward3
	hero.tutorial.section4 = {}
	hero.tutorial.section4.progress = resultTable.progress4
	hero.tutorial.section4.state = 0
	hero.tutorial.section4.reward = resultTable.reward4
	if hero.tutorial.section4.reward == 1 then
		Tutorial:SpawnTrainingDummyForHero(hero)
	end
	hero.tutorial.section5 = {}
	hero.tutorial.section5.progress = resultTable.progress5
	hero.tutorial.section5.state = 0
	hero.tutorial.section5.reward = resultTable.reward5
	hero.tutorial.section6 = {}
	hero.tutorial.section6.progress = resultTable.progress6
	hero.tutorial.section6.state = 0
	hero.tutorial.section6.reward = resultTable.reward6
	hero.tutorial.section7 = {}
	hero.tutorial.section7.progress = resultTable.progress7
	hero.tutorial.section7.state = 0
	hero.tutorial.section7.reward = resultTable.reward7
	hero.tutorial.section8 = {}
	hero.tutorial.section8.progress = resultTable.progress8
	hero.tutorial.section8.state = 0
	hero.tutorial.section8.reward = resultTable.reward8

	Tutorial:PreIntro(hero)
end

function Tutorial:PreIntro(hero)
	local progressTable = Tutorial:GetTutorialDataArray(hero, "progress")
	local totalProgress = 0
	for i = 1, #progressTable, 1 do
		totalProgress = totalProgress + progressTable[i]
	end
	if totalProgress == 0 then
		local assistant = CreateUnitByName("tutorial_assistant", Vector(-1984, -2304)+RandomVector(RandomInt(0, 200)), false, nil, nil, DOTA_TEAM_GOODGUYS)
		FindClearSpaceForUnit(assistant, assistant:GetAbsOrigin(), false)
		CustomAbilities:QuickParticleAtPoint("particles/roshpit/tutorial/tutorial_sprout.vpcf", assistant:GetAbsOrigin(), 3)
		EmitSoundOn("Tutorial.Assistant.Spawn", assistant)
		assistant.state = 0
		assistant.hero = hero
		StartAnimation(assistant, {duration=2, activity=ACT_DOTA_SPAWN, rate=1.0})
		Timers:CreateTimer(1, function()
			EmitSoundOn("Tutorial.Assistant.Voice1", assistant)
		end)
		Tutorial:ApplyTutorialModifier("modifier_tutorial_assistant", assistant, 0)
		hero.tutorial_assistant = assistant
	end
end

function Tutorial:GetTutorialFromServer(hero)
	Timers:CreateTimer(1, function()
		if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			return 1.5
		else
			local playerID = hero:GetPlayerOwnerID()
			local steamID = PlayerResource:GetSteamAccountID(playerID)
			local player = PlayerResource:GetPlayer(playerID)
			local url = ROSHPIT_URL.."/champions/get_tutorial_status?"
			url = url.."steam_id="..steamID
			print(url)
			CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
				if result.StatusCode == 200 then
					local resultTable = {}
					print( "GET response:\n" )
					for k,v in pairs( result ) do
						print( string.format( "%s : %s\n", k, v ) )
					end
					print( "Done." )
					local resultTable = JSON:decode(result.Body)
					Tutorial:LoadTutorialDataForHero(hero, resultTable)
				end
			end )
		end	
	end)
end

function Tutorial:OpenTutorial(hero)
	if not hero:HasModifier("modifier_tutorial_open") then
		if not hero.tutorial.master_is_talking then
			if not hero.tutorial.firstopened then
				Tutorial:ApplyTutorialModifier("modifier_tutorial_open", hero, 0)
				hero.tutorial.firstopened = true
				if hero.tutorial_assistant then
					if hero.tutorial_assistant.state < 6 then
						hero.tutorial_assistant.state = 6
					end
					local distance = WallPhysics:GetDistance2d(Tutorial.Master:GetAbsOrigin(), hero.tutorial_assistant:GetAbsOrigin())
					if distance < 500 then
						Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_1", 5, false)
					else
						Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_2", 5, false)
					end
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.GreetingWellWell", ACT_DOTA_CAST_ABILITY_3, 0.8, 4.2)
					Timers:CreateTimer(4.5, function()
						Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_3", 5, false)
						Tutorial:TutorialUIActiveForPlayer(hero, 1)
						Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.2, 2.5)
						Timers:CreateTimer(6, function()
							Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_4", 5, false)
							Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 1.1, 3.1)
						end)
					end)
				else
					Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_4", 5, false)
					Tutorial:TutorialUIActiveForPlayer(hero, 1)
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.GreetingBasic", ACT_DOTA_ATTACK, 0.7, 4.1)
				end
			else
				if not hero.master_is_talking then
					Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_hello", 5, false)
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.GreetingBasic", ACT_DOTA_ATTACK, 0.7, 4.1)
				end
				Tutorial:TutorialUIActiveForPlayer(hero, 0)
			end
		end
	end

end



function Tutorial:SoundAndAnimationForMaster(sound, animationName, playRate, duration)
	if not Tutorial.Master:HasModifier("modifier_tutorial_master_making_noises") then
		EmitSoundOn(sound, Tutorial.Master)
		StartAnimation(Tutorial.Master, {duration=duration, activity=animationName, rate=playRate})
		Tutorial:ApplyTutorialModifier("modifier_tutorial_master_making_noises", Tutorial.Master, duration)
	end
end

function Tutorial:TutorialUIActiveForPlayer(hero, sound)
	local categories = Tutorial:GetFixedTutorialData(hero)
	local playerID = hero:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(playerID)
	local stars = hero.grandTotalStars
	CustomGameEventManager:Send_ServerToPlayer(player, "open_tutorial", {hero=hero:GetEntityIndex(), tutorial=hero.tutorial, sound=sound, categories=categories, stars=stars} )
	-- Tutorial:ApplyTutorialModifier("modifier_tutorial_open", hero, 15)
	Tutorial:ApplyTutorialModifier("modifier_tutorial_open", hero, 0)
	--uncomment this in before release
end

function Tutorial:GetFixedTutorialData(hero)
	local categories = {}
	--
	local quest = {}
	quest.progress = hero.tutorial.section1.progress
	quest.index = 1
	quest.header = "quest_1_interface"
	quest.description = "quest_1_interface_description"
	quest.challenges = 4
	quest.reward = hero.tutorial.section1.reward
	table.insert(categories, quest)
	--
	--
	if hero.tutorial.section1.progress >= 4 then
		local quest = {}
		quest.index = 2
		quest.progress = hero.tutorial.section2.progress
		quest.header = "quest_2_interface"
		quest.description = "quest_2_interface_description"
		quest.reward = hero.tutorial.section2.reward
		quest.challenges = 3
		table.insert(categories, quest)
	end
	if hero.tutorial.section2.progress >= 3 then
		local quest = {}
		quest.index = 3
		quest.progress = hero.tutorial.section3.progress
		quest.header = "quest_3_interface"
		quest.description = "quest_3_interface_description"
		quest.reward = hero.tutorial.section3.reward
		quest.challenges = 5
		table.insert(categories, quest)
	end
	if hero.tutorial.section3.progress >= 5 then
		local quest = {}
		quest.index = 4
		quest.progress = hero.tutorial.section4.progress
		quest.header = "quest_4_interface"
		quest.description = "quest_4_interface_description"
		quest.reward = hero.tutorial.section4.reward
		quest.challenges = 7
		table.insert(categories, quest)
	end
	if hero.tutorial.section4.progress >= 7 then
		local quest = {}
		quest.index = 5
		quest.progress = hero.tutorial.section5.progress
		quest.header = "quest_5_interface"
		quest.description = "quest_5_interface_description"
		quest.reward = hero.tutorial.section5.reward
		quest.challenges = 3
		table.insert(categories, quest)
	end
	if hero.tutorial.section5.progress >= 3 then
		local quest = {}
		quest.index = 6
		quest.progress = hero.tutorial.section6.progress
		quest.header = "quest_6_interface"
		quest.description = "quest_6_interface_description"
		quest.reward = hero.tutorial.section6.reward
		quest.challenges = 5
		table.insert(categories, quest)
	end
	--
	return categories
end

function Tutorial:TutorialEvent(msg)
	local code = msg.code
	local hero = EntIndexToHScript(msg.hero)
	if code == "close_tutorial" then
		Timers:CreateTimer(2, function()
			hero:RemoveModifierByName("modifier_tutorial_open")
		end)
	elseif code == "challenge_select" then
		hero:RemoveModifierByName("challen_postmit_buff")
		hero:RemoveModifierByName("modifier_challen_4_7_buff")

		hero.tutorial.active_challenge = msg.category_index.."_"..msg.challenge_index
		hero.active_challenge_progress = 0
		local player = hero:GetPlayerOwner()
		CustomGameEventManager:Send_ServerToPlayer(player, "close_quiz", {} )

		if hero.shroomling then
			UTIL_Remove(hero.shroomling)
			hero.shroomling = nil
		end
		if hero.shroomling_table then
			for i = 1, #hero.shroomling_table, 1 do
				local shroomling = hero.shroomling_table[i]
				if IsValidEntity(shroomling) then
					UTIL_Remove(shroomling)
				end
			end
			hero.shroomling_table = nil
		end
		if hero.elemental then
			UTIL_Remove(hero.elemental)
			hero.elemental = nil
		end
		if hero.tutorial.active_challenge == "1_1" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 1, 1, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "1_2" then
			hero.tutorialhasBeenSlain = false
			Tutorial:UpdateChallengeSummaryProgress(hero, 1, 2, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "1_3" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 1, 3, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "1_4" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 1, 4, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "2_1" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 2, 1, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "2_2" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 2, 2, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "2_3" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 2, 3, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "3_1" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 3, 1, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "3_2" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 3, 2, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "3_3" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 3, 3, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "3_4" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 3, 4, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "3_5" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 3, 5, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "4_1" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 4, 1, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "4_2" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 4, 2, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "4_3" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 4, 3, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "4_4" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 4, 4, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "4_5" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 4, 5, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
			Tutorial:SpawnTrainingDummyForHero(hero)
		elseif hero.tutorial.active_challenge == "4_6" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 4, 6, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
			Tutorial:SpawnTrainingDummyForHero(hero)
		elseif hero.tutorial.active_challenge == "4_7" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 4, 7, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "5_1" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 5, 1, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "5_2" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 5, 2, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "5_3" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 5, 3, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "6_1" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 6, 1, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "6_2" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 6, 2, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "6_3" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 6, 3, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "6_4" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 6, 4, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		elseif hero.tutorial.active_challenge == "6_5" then
			Tutorial:UpdateChallengeSummaryProgress(hero, 6, 5, 0, false)
			Tutorial:MasterSequenceWithLocks(hero, hero.tutorial.active_challenge)
		end
	elseif code == "reward_select" then
		Tutorial:ClaimReward(msg)
	elseif code == "submit_quiz" then
		Tutorial:SubmitQuiz(msg)
	end
end

function Tutorial:UpdateChallengeSummaryProgress(hero, category_index, challenge_index, sub_index, bCapped)
	local player = hero:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player, "challenge_summary", {hero=hero:GetEntityIndex(), category_index=category_index, challenge_index=challenge_index, sub_index = sub_index, bCapped = bCapped} )
	if bCapped then
		Timers:CreateTimer(5, function()
			CustomGameEventManager:Send_ServerToPlayer(player, "close_challenge_summary", {} )
		end)
	end
end

function Tutorial:MasterSequenceWithLocks(hero, code)
	local heroIndex = hero:GetEntityIndex()
	if not hero.tutorial_speech_phase then
		hero.tutorial_speech_phase = 0
	end
	hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
	local speech_phase = hero.tutorial_speech_phase
	print(code)
	Timers:CreateTimer(8, function()
		hero:RemoveModifierByName("modifier_tutorial_open")
	end)
	if code == "1_1" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_1a", 4, false)
		Timers:CreateTimer(4, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_1b", 4, false)
				Timers:CreateTimer(4, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_1c", 4, false)
						Timers:CreateTimer(4, function()
							if speech_phase == hero.tutorial_speech_phase then
								Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_3, 1.0, 4.0)
								Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_1d", 4, false)
							end
						end)
					end
				end)
			end
		end)
		Timers:CreateTimer(16, function()
			hero.master_is_talking = false
		end)
	elseif code == "1_2" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2a", 4, false)
		Timers:CreateTimer(4, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2b", 4, false)
				Timers:CreateTimer(4, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2c", 4, false)
						Timers:CreateTimer(4, function()
							if speech_phase == hero.tutorial_speech_phase then
								Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2d", 4, false)
								Timers:CreateTimer(4, function()
									if speech_phase == hero.tutorial_speech_phase then
										Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_CAST_ABILITY_4, 1.0, 4.0)
										Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2e", 4, false)
										Timers:CreateTimer(4.2, function()
											if speech_phase == hero.tutorial_speech_phase then
												Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_3, 1.0, 4.0)
												Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2f", 4, false)
											end
										end)
									end
								end)
							end
						end)
					end
				end)
			end
		end)
		Timers:CreateTimer(24, function()
			hero.master_is_talking = false
		end)
	elseif code == "1_3" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_3a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_3b", 4, false)
				hero.master_is_talking = false
			end
		end)
	elseif code == "1_4" then
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_4a", 5, false)
	elseif code == "2_1" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1d", 5, false)
			end
		end)
		Timers:CreateTimer(20, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_CAST_ABILITY_4, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1e", 5, false)
			end
		end)
		Timers:CreateTimer(25, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1f", 5, false)
			end
		end)
		Timers:CreateTimer(30, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1g", 5, false)
			end
		end)
		Timers:CreateTimer(35, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1h", 5, false)
			end
		end)
		Timers:CreateTimer(40, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1h2", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 1.1, 3.1)
			end
		end)
		Timers:CreateTimer(45, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1h3", 4, false)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				-- local random_rune = "DOTA_Tooltip_Ability_"..HerosCustom:GetInternalHeroName(hero:GetUnitName())
				local rune_column = RandomInt(1,4)
				local rune_row = RandomInt(1, 4)
				local rune_letter = Runes:GetRuneLetterByIndex(rune_column)
				rune_letter = string.upper(rune_letter)
				local random_rune = rune_letter..rune_row
				local rune_text = "["..random_rune.."]"
				local question = "tutorial_quiz_question_1"
				local runename = Runes:GetRuneAbility(hero, rune_row, rune_column-1):GetAbilityName()
				local rune_name_tooltip = "DOTA_Tooltip_ability_"..runename
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="2_1", quiz_question=question, sequence=0, gsub1 = rune_text, verifier = rune_name_tooltip, localize_verifier = 1, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
				-- Tutorial:TutorialServerEvent(hero, "2_1", 0)
			end
		end)
		Timers:CreateTimer(50, function()
			hero.master_is_talking = false
		end)
	elseif code == "2_2" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2c", 4, false)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				-- local random_rune = "DOTA_Tooltip_Ability_"..HerosCustom:GetInternalHeroName(hero:GetUnitName())
				local question = "tutorial_quiz_question_2"
				local choice = RandomInt(1,5)
				local sub1 = nil
				local sub2 = nil
				local verifier = 0
				if choice == 1 then
					sub1 = "item_health_regen"
					sub2 = "item_strength"
					verifier = math.floor(hero:GetStrength()*CustomAttributes.HEALTH_REGEN_PER_STR)
				elseif choice == 2 then
					sub1 = "item_max_health"
					sub2 = "item_strength"
					verifier = math.floor(hero:GetStrength()*CustomAttributes.HEALTH_PER_STR)
				elseif choice == 3 then
					sub1 = "item_attack_speed"
					sub2 = "item_agility"
					verifier = math.floor(hero:GetAgility()*CustomAttributes.ATTACKSPEED_PER_AGI)
				elseif choice == 4 then
					sub1 = "item_max_mana"
					sub2 = "item_intelligence"
					verifier = math.floor(hero:GetIntellect()*CustomAttributes.MANA_PER_INT)
				elseif choice == 5 then
					sub1 = "item_mana_regen"
					sub2 = "item_intelligence"
					verifier = math.floor(hero:GetIntellect()*CustomAttributes.MANA_REGEN_PER_INT)
				end
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="2_2", quiz_question=question, sequence=0, gsub1 = sub1, gsub2 = sub2, verifier = verifier, localize_verifier = 0, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)
		Timers:CreateTimer(15, function()
			hero.master_is_talking = false
		end)
	elseif code == "2_3" then
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_3a", 5, false)
		if hero:GetLevel() < 2 then
			hero:AddExperience(1000, 0, false, true)
		end
		Timers:CreateTimer(5, function()
			Tutorial:SpawnOracle()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_3b", 5, false)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_3c", 5, false)
						Timers:CreateTimer(5, function()
							if speech_phase == hero.tutorial_speech_phase then
								Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_3, 1.0, 4.0)
								Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_3d", 5, false)
							end
						end)
					end
				end)
			end
		end)
		Timers:CreateTimer(20, function()
			hero.master_is_talking = false
		end)
	elseif code == "3_1" then
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		hero.master_is_talking = true
		speech_phase = hero.tutorial_speech_phase
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_3_1a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1b", 5, false)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1b1", 5, false)
						Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_3, 1.0, 4.0)
						local luck = RandomInt(200,500)
						if luck >= 200 and luck < 265 then
							RPCItems:RollHood(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
						elseif luck >= 265 and luck < 330 then
							RPCItems:RollHand(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
						elseif luck >= 330 and luck < 395 then
							RPCItems:RollFoot(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
						elseif luck >= 395 and luck < 460 then
							RPCItems:RollBody(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
						elseif luck <= 500 then
							RPCItems:RollAmulet(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
						end
						if hero:GetLevel() < 10 then
							hero:AddExperience(3000, 0, false, true)
						end
					end
				end)
			end
		end)
		Timers:CreateTimer(12, function()
			hero.master_is_talking = false
		end)
	elseif code == "3_2" then
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		hero.master_is_talking = true
		speech_phase = hero.tutorial_speech_phase
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_3_2a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				local delayUntil_b = 0
				local shards = CustomNetTables:GetTableValue("player_stats", tostring(hero:GetPlayerOwnerID()).."-mithril").mithril
				if shards < 50 then
					delayUntil_b = 11
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2a1", 5, false)
					Tutorial:GetMithrilPrize(Tutorial.Master:GetAbsOrigin(), hero, 50)
					Timers:CreateTimer(3, function()
						Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_3, 1.0, 7.0)
					end)
				end
				Timers:CreateTimer(delayUntil_b, function()
					hero.master_is_talking = false
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2b", 5, false)
					Tutorial:SpawnAllTownNPCs()
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_2, 1.0, 4.0)
					local luck = RandomInt(200,500)
					if luck >= 200 and luck < 265 then
						RPCItems:RollHood(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
					elseif luck >= 265 and luck < 330 then
						RPCItems:RollHand(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
					elseif luck >= 330 and luck < 395 then
						RPCItems:RollFoot(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
					elseif luck >= 395 and luck < 460 then
						RPCItems:RollBody(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
					elseif luck <= 500 then
						RPCItems:RollAmulet(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
					end
					if hero:GetLevel() < 10 then
						hero:AddExperience(3000, 0, false, true)
					end
				end)
			end
		end)
	elseif code == "3_3" then
		hero.master_is_talking = true
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		local speech_phase = hero.tutorial_speech_phase
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_3a", 5, false)
		Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_3b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_3c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				local delayUntil_d = 0
				local gear_data = CustomNetTables:GetTableValue("equipment", tostring(hero:GetPlayerOwnerID()).."-"..tostring(RPCItems.WEAPONS_SLOT))
				CustomNetTables:SetTableValue("equipment", tostring(hero:GetPlayerOwnerID()).."-"..tostring(slot), {itemIndex = -1} )
				if gear_data.itemIndex == -1 then
					if not hero.free_weapon_given then
						hero.free_weapon_given = true
						delayUntil_d = 6
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_3c1", 5, false)
						Weapons:RollWeaponWithClass(Tutorial.Master:GetAbsOrigin(), hero:GetUnitName())
					end
				end
				Timers:CreateTimer(delayUntil_d, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_3d", 5, false)
					local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
					local question = "tutorial_quiz_question_9"
					CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="3_3", quiz_question=question, sequence=0, verifier = 0, localize_verifier = 0, challenge_progress = 0} )
					CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
				end)
			end
		end)
		Timers:CreateTimer(20, function()
			hero.master_is_talking = false
		end)
	elseif code == "3_4" then
		hero.master_is_talking = true
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		local speech_phase = hero.tutorial_speech_phase
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4a", 5, false)
		Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				local crystals = CustomNetTables:GetTableValue("player_stats", tostring(hero:GetPlayerOwnerID()).."-resources").arcane
				if crystals < 300 then
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4d1", 5, false)
					Glyphs:DropArcaneCrystals(Tutorial.Master:GetAbsOrigin(), 500)
					Timers:CreateTimer(5, function()
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4d2", 5, false)
					end)
				else
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_2, 1.0, 4.0)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4d", 5, false)
				end
			end
		end)
		Timers:CreateTimer(20, function()
			hero.master_is_talking = false
		end)
	elseif code == "3_5" then
		hero.master_is_talking = true
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		local speech_phase = hero.tutorial_speech_phase
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_5a", 5, false)
		Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_5b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_5c", 5, false)
				local luck = RandomInt(200,500)
				if luck >= 200 and luck < 265 then
					RPCItems:RollHood(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
				elseif luck >= 265 and luck < 330 then
					RPCItems:RollHand(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
				elseif luck >= 330 and luck < 395 then
					RPCItems:RollFoot(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
				elseif luck >= 395 and luck < 460 then
					RPCItems:RollBody(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
				elseif luck <= 500 then
					RPCItems:RollAmulet(300, Tutorial.Master:GetAbsOrigin(), "uncommon", false, 0, nil, 0)
				end
			end
		end)
	elseif code == "4_1" then
		hero.master_is_talking = true
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		local speech_phase = hero.tutorial_speech_phase
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1a", 5, false)
		Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_CAST_ABILITY_3, 1.0, 4.0)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1c", 5, false)
			end
		end)	
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				-- spawn shroomling
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1d", 7, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Timers:CreateTimer(0.3, function()
					local shroomling = CreateUnitByName("tutorial_shroomling", Vector(-576, 1984), false, nil, nil, DOTA_TEAM_NEUTRALS)
					shroomling.dominion = true
					EmitSoundOn("Tutorial.SpawnUnit", shroomling)
					shroomling:SetForwardVector(Vector(1,0))
					CustomAbilities:QuickParticleAtPoint("particles/roshpit/tutorial/tutorial_sprout.vpcf", shroomling:GetAbsOrigin(), 3)
					shroomling.cantAggro = true
					local particleName = "particles/roshpit/redfall/red_beam.vpcf"
				    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
				    ParticleManager:SetParticleControl(pfx,1,shroomling:GetAbsOrigin()+Vector(0,0,60))
					Timers:CreateTimer(3.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					AddFOWViewer(DOTA_TEAM_GOODGUYS, shroomling:GetAbsOrigin(), 300, 180, false)
					shroomling.hero = hero
					shroomling.phase = 0
					shroomling.damage_code = 0
					hero.shroomling = shroomling
					Tutorial:ApplyTutorialModifier("modifier_tutorial_unit", shroomling, 0)
					local ability = shroomling:FindAbilityByName("dungeon_creep")
					if ability then
						ability:SetLevel(1)
						ability:ApplyDataDrivenModifier(shroomling, shroomling, "modifier_dungeon_thinker_creep", {})
					end
					shroomling.aggroSound = "Tutorial.Shroomling.Aggro"
				    shroomling:SetDeathXP(500)
				    shroomling:SetMaximumGoldBounty(10)
				    shroomling:SetMinimumGoldBounty(20)
				end)
			end
		end)
		Timers:CreateTimer(21, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_4_1e", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_CAST_ABILITY_4, 1.0, 4.0)
				hero.master_is_talking = false
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				local question = "tutorial_quiz_question_10"
				local verifier = "DOTA_Tooltip_ability_tutorial_shroomling_ability"
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_1", quiz_question=question, sequence=0, verifier = verifier, localize_verifier = 1, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)	
	elseif code == "4_2" then
		hero.master_is_talking = true
		hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
		local speech_phase = hero.tutorial_speech_phase
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_4_2a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_4_2c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2d", 5, false)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				local question = "tutorial_quiz_question_11"
				local armor = math.floor(hero:GetPhysicalArmorValue())
				local verifier = (1 - GameState:GetPostReductionPhysicalDamage(10000, armor)/10000)*100
				-- local resist = (0.05*hero:GetPhysicalArmorValue()/(1 + (0.05 * math.abs(hero:GetPhysicalArmorValue()))))
				-- resist = (resist*100000)/1000
				-- verifier = resist
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_2", quiz_question=question, sequence=0, verifier = verifier, localize_verifier = 0, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)	
	elseif code == "4_3" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3c", 5, false)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				-- local random_rune = "DOTA_Tooltip_Ability_"..HerosCustom:GetInternalHeroName(hero:GetUnitName())
				local question = "tutorial_quiz_question_14"
				local verifier = (hero:GetAverageTrueAttackDamage(hero) - ((hero:GetBaseDamageMin()+hero:GetBaseDamageMax())/2))
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_3", quiz_question=question, sequence=0, verifier = verifier, localize_verifier = 0, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)
		Timers:CreateTimer(15, function()
			hero.master_is_talking = false
		end)
	elseif code == "4_4" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4a", 5, false)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4c", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				local random_element = RandomInt(1, RPC_ELEMENT_COUNT)
				local damageDealt = 1000
				local damageELEMENT = Filters:ElementalDamage(Events.GameMaster, hero, damageDealt*100, DAMAGE_TYPE_PURE, 0, random_element, RPC_ELEMENT_NONE, false)
				local validator = math.floor(damageELEMENT/damageDealt)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				local question = "tutorial_quiz_question_14a"
				local sub1 = "rpc_element"..random_element
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_4", quiz_question=question, sequence=0, gsub1 = sub1, verifier = validator, localize_verifier = 0, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)
	elseif code == "4_5" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5b", 5, false)
			end
		end)
	elseif code == "4_6" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_6a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_6b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_6c", 5, false)
			end
		end)
	elseif code == "4_7" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7c", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Timers:CreateTimer(0.3, function()
					local particleName = "particles/roshpit/redfall/red_beam.vpcf"
				    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
				    ParticleManager:SetParticleControl(pfx,1,hero:GetAbsOrigin()+Vector(0,0,80))
					Timers:CreateTimer(3.5, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					EmitSoundOn("Tutorial.PostmitBuff.Apply", hero)
					Tutorial:ApplyTutorialModifier("modifier_challen_4_7_buff", hero, 0)
				end)
				Timers:CreateTimer(1.5, function()
					local validator = "DOTA_Tooltip_modifier_challen_4_7_buff"
					local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
					local question = "tutorial_quiz_question_16"
					CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_7", quiz_question=question, sequence=0, verifier = validator, localize_verifier = 1, challenge_progress = 0} )
					CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
				end)
			end
		end)
	elseif code == "5_1" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_1a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_1b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_1c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_1c1", 5, false)
			end
		end)
		Timers:CreateTimer(20, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_1d", 5, false)
			end
		end)
		Timers:CreateTimer(25, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_1e", 5, false)
			end
		end)
		Timers:CreateTimer(30, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_1f", 5, false)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				local question = "tutorial_quiz_question_17"
				local verifier = "rpc_redfall_ridge"
				local buttons = {"rpc_tanari_jungle", "rpc_redfall_ridge", "rpc_winterblight_mountain", "rpc_roshpit_arena", "rpc_sea_fortress"}
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="5_1", quiz_question=question, sequence=0, verifier = verifier, localize_verifier = 1, challenge_progress = 0, buttons = buttons} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)
	elseif code == "5_2" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_2a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_2b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_2c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_2d", 5, false)
			end
		end)
	elseif code == "5_3" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_3a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_3b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_3c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_3d", 5, false)
			end
		end)
		Timers:CreateTimer(20, function()
			hero.master_is_talking = false
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_3e", 5, false)
				Timers:CreateTimer(1, function()
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 2.0)
					Timers:CreateTimer(0.3, function()
						local shroomling = CreateUnitByName("tutorial_shroomling", Vector(-576, 1984), false, nil, nil, DOTA_TEAM_NEUTRALS)
						EmitSoundOn("Tutorial.SpawnUnit", shroomling)
						shroomling.dominion = true
						shroomling:SetForwardVector(Vector(1,0))
						CustomAbilities:QuickParticleAtPoint("particles/roshpit/tutorial/tutorial_sprout.vpcf", shroomling:GetAbsOrigin(), 3)
						shroomling.cantAggro = true
						local particleName = "particles/roshpit/redfall/red_beam.vpcf"
					    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
					    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
					    ParticleManager:SetParticleControl(pfx,1,shroomling:GetAbsOrigin()+Vector(0,0,60))
						Timers:CreateTimer(3.5, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
						AddFOWViewer(DOTA_TEAM_GOODGUYS, shroomling:GetAbsOrigin(), 300, 180, false)
						shroomling.hero = hero
						shroomling.phase = 0
						shroomling.damage_code = 4
						hero.shroomling = shroomling
						Tutorial:ApplyTutorialModifier("modifier_tutorial_unit", shroomling, 0)

						local ability = shroomling:FindAbilityByName("dungeon_creep")
						if ability then
							ability:SetLevel(1)
							ability:ApplyDataDrivenModifier(shroomling, shroomling, "modifier_dungeon_thinker_creep", {})
						end
						shroomling.aggroSound = "Tutorial.Shroomling.Aggro"
					    shroomling:SetDeathXP(500)
					    shroomling:SetMaximumGoldBounty(10)
					    shroomling:SetMinimumGoldBounty(20)
					end)
				end)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_ATTACK, 1.0, 3.0)
						Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_5_3f", 6, false)
						Timers:CreateTimer(0.3, function()
							Paragon:AddParagonUnit(hero.shroomling)
							local particleName = "particles/roshpit/redfall/red_beam.vpcf"
						    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
						    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
						    ParticleManager:SetParticleControl(pfx,1,hero.shroomling:GetAbsOrigin()+Vector(0,0,60))
						    EmitSoundOn("Tutorial.PostmitBuff.Apply", hero.shroomling)
							Timers:CreateTimer(3.5, function()
								ParticleManager:DestroyParticle(pfx, false)
							end)
							Timers:CreateTimer(2.5, function()
								hero.shroomling.phase = 1
								hero.shroomling.cantAggro = false
								Dungeons:AggroUnit(hero.shroomling)
								StartAnimation(hero.shroomling, {duration=1, activity=ACT_DOTA_SPAWN, rate=1.3})
							end)
						end)
					end
				end)
			end
		end)
	elseif code == "6_1" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_1a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_1b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_1c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_1d", 5, false)
			end
		end)
		Timers:CreateTimer(20, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_1e", 5, false)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				local question = "tutorial_quiz_question_18"
				local verifier = 30
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="6_1", quiz_question=question, sequence=0, verifier = verifier, localize_verifier = 0, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)
	elseif code == "6_2" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2d", 5, false)
				Tutorial:UpdateSpecialKeyOnWeb(hero, 1)
			end
		end)
		Timers:CreateTimer(20, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2e", 5, false)
			end
		end)
		Timers:CreateTimer(25, function()
			if speech_phase == hero.tutorial_speech_phase then
				hero.tutorial_polling_count = 0
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2f", 5, false)
				Timers:CreateTimer(0, function()
					if speech_phase == hero.tutorial_speech_phase then
						hero.tutorial_polling_count = hero.tutorial_polling_count + 1
						Tutorial:CheckSpecialKeyAndLoop(hero)
						if hero.special_key then
							if hero.special_key == 1 then
								if hero.tutorial_polling_count%8 == 0 then
									Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
									Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2g", 5, false)
								end
								return 6
							end
							if hero.special_key == 2 then
								Tutorial:TutorialServerEvent(hero, "6_2", 0)
							end
						else
							return 6
						end
					end
				end)
			end
		end)
	elseif code == "6_3" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_3a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_3b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_3c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_3d", 5, false)
				Tutorial:UpdateSpecialKeyOnWeb(hero, 3)
			end
		end)
		Timers:CreateTimer(20, function()
			if speech_phase == hero.tutorial_speech_phase then
				hero.tutorial_polling_count = 0
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_3e", 5, false)
				Timers:CreateTimer(0, function()
					if speech_phase == hero.tutorial_speech_phase then
						hero.tutorial_polling_count = hero.tutorial_polling_count + 1
						Tutorial:CheckSpecialKeyAndLoop(hero)
						if hero.special_key then
							if hero.special_key == 3 then
								if hero.tutorial_polling_count%8 == 0 then
									Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
									Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2g", 5, false)
								end
								return 6
							end
							if hero.special_key == 4 then
								Tutorial:TutorialServerEvent(hero, "6_3", 0)
							end
						else
							return 6
						end
					end
				end)
			end
		end)
	elseif code == "6_4" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_4a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_CAST_ABILITY_1, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_4b", 5, false)
				Tutorial:UpdateSpecialKeyOnWeb(hero, 5)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				hero.tutorial_polling_count = 0
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_4c", 5, false)
				Timers:CreateTimer(0, function()
					if speech_phase == hero.tutorial_speech_phase then
						hero.tutorial_polling_count = hero.tutorial_polling_count + 1
						Tutorial:CheckSpecialKeyAndLoop(hero)
						if hero.special_key then
							if hero.special_key == 5 then
								if hero.tutorial_polling_count%8 == 0 then
									Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
									Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_2g", 5, false)
								end
								return 6
							end
							if hero.special_key == 6 then
								Tutorial:TutorialServerEvent(hero, "6_4", 0)
							end
						else
							return 6
						end
					end
				end)
			end
		end)
	elseif code == "6_5" then
		hero.master_is_talking = true
		Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_5a", 5, false)
		local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
		Timers:CreateTimer(5, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_5b", 5, false)
			end
		end)
		Timers:CreateTimer(10, function()
			if speech_phase == hero.tutorial_speech_phase then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 0.9, 2.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_5c", 5, false)
			end
		end)
		Timers:CreateTimer(15, function()
			if speech_phase == hero.tutorial_speech_phase then
				Quests:ShowDialogueText({hero}, Tutorial.Master, "tutorial_master_dialogue_6_5d", 5, false)
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				local question = "tutorial_quiz_question_19"
				local verifier = "krjua5"
				CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="6_5", quiz_question=question, sequence=0, verifier = verifier, localize_verifier = 1, challenge_progress = 0} )
				CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
			end
		end)
	end
end

function Tutorial:CheckSpecialKeyAndLoop(hero)
	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/get_tutorial_status?"
	url = url.."steam_id="..steamID
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			hero.special_key = resultTable.special_key
		end
	end )
end

function Tutorial:TutorialServerEvent(hero, code1, code2)
	if not hero.tutorial then
		return false
	end
	if hero.tutorial.active_challenge == code1 then
		print("-----TUTORIAL SERVER EVENT------")
		print(hero.active_challenge_progress)
		print(code2)
		print("------------")
		if code1 == "1_1" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_1e", 5, false)
				hero.master_is_talking = false
				Tutorial:ProgressUpdateOrNot(hero, 1, 1)
				Timers:CreateTimer(2, function()
					EmitSoundOn("Tutorial.Master.Giggle", hero)
				end)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial.active_challenge = nil
				Timers:CreateTimer(3, function()
					Tutorial:UpdateChallengeSummaryProgress(hero, 1, 1, 1, true)
				end)
			end
		elseif code1 == "1_2" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2g", 5, false)
				hero.master_is_talking = false
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(3, function()
					Tutorial:UpdateChallengeSummaryProgress(hero, 1, 2, 1, false)
					Timers:CreateTimer(1, function()
						Events:TutorialServerEvent(hero, "1_2", 1)
					end)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				hero.master_is_talking = true
				hero.active_challenge_progress =  hero.active_challenge_progress + 1
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2h", 5, false)
				Timers:CreateTimer(4, function()
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_ATTACK, 1.5, 2.0)
					local particleName = "particles/roshpit/redfall/ashara_moonbeam_lucent_beam_impact_shared_ti_5_gold.vpcf"
					local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, hero )
					for i = 1, 8, 1 do
						ParticleManager:SetParticleControl(pfx, i, hero:GetAbsOrigin()+Vector(0,0,60))
					end
					ParticleManager:SetParticleControl(pfx, 2, Vector(0,0,1000))
					for i = 3, 12, 1 do
						ParticleManager:SetParticleControl(pfx, i, hero:GetAbsOrigin()+Vector(0,0,300))
					end
					EmitSoundOnLocationWithCaster(hero:GetAbsOrigin(), "Tutorial.SpiritAshara.BeamImpact", Events.GameMaster)
					Timers:CreateTimer(4, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
					Tutorial:ApplyTutorialModifier("modifier_tutorial_super_kill", hero, 0)
				end)
				Timers:CreateTimer(6, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2j", 3, false)
					EmitSoundOn("Tutorial.Master.Giggle", hero)
				end)
				Timers:CreateTimer(9, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2k", 3, false)
				end)	
				Timers:CreateTimer(12, function()
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_ATTACK, 1.5, 4.0)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_2l", 4, false)
					hero.master_is_talking = false
				end)			
			end
		elseif code1 == "1_3" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress =  hero.active_challenge_progress + 1
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				local speech_phase = hero.tutorial_speech_phase
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_3c", 6, false)
				Timers:CreateTimer(2.5, function()
					EmitSoundOn("Tutorial.Master.Giggle", hero)
				end)
				Timers:CreateTimer(6, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_3d", 5, false)
					end
				end)	
				Timers:CreateTimer(10, function()
					if speech_phase == hero.tutorial_speech_phase then
						Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_ATTACK, 1.5, 4.0)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_3e", 4, false)
						hero.master_is_talking = false
					end
					Tutorial:ProgressUpdateOrNot(hero, 1, 3)
					Tutorial:UpdateChallengeSummaryProgress(hero, 1, 3, 1, true)
				end)	
			end
		elseif code1 == "1_4" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				local speech_phase = hero.tutorial_speech_phase
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_4b", 6, false)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_4c", 5, false)
					end
				end)	
				Timers:CreateTimer(10, function()
					if speech_phase == hero.tutorial_speech_phase then
						Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Giggle", ACT_DOTA_ATTACK, 1.5, 4.0)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_4d", 4, false)
						hero.master_is_talking = false
					end
					Tutorial:ProgressUpdateOrNot(hero, 1, 4)
					Tutorial:UpdateChallengeSummaryProgress(hero, 1, 4, 1, true)
					Timers:CreateTimer(5, function()
						local bStarEvent = Stars:StarEventSolo("champleague", hero)
						if bStarEvent then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_4f", 5, false)
						else
							if speech_phase == hero.tutorial_speech_phase then
								Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_1_4e", 5, false)
							end
						end
					end)	
				end)
			end
		elseif code1 == "2_1" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:UpdateChallengeSummaryProgress(hero, 2, 1, 1, false)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1i", 5, false)
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1j", 5, false)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				local speech_phase = hero.tutorial_speech_phase
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1k", 6, false)
				Tutorial:UpdateChallengeSummaryProgress(hero, 2, 1, 2, false)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1l", 5, false)
					end
				end)	
				Timers:CreateTimer(10, function()
					if speech_phase == hero.tutorial_speech_phase then
						Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_ATTACK, 1.5, 4.0)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1m", 4, false)
					end
					Timers:CreateTimer(4, function()
						if speech_phase == hero.tutorial_speech_phase then
							Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_ATTACK, 1.5, 4.0)
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1n", 4, false)
						end						
					end)
				end)
			elseif code2 == 2 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				local speech_phase = hero.tutorial_speech_phase
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1o", 6, false)
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_1p", 5, false)
					hero.master_is_talking = false
					Tutorial:ProgressUpdateOrNot(hero, 2, 1)
					Tutorial:UpdateChallengeSummaryProgress(hero, 2, 1, 3, true)
				end)
			end
		elseif code1 == "2_2" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:UpdateChallengeSummaryProgress(hero, 2, 2, 1, false)
				hero.master_is_talking = true
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2d", 5, false)
				Timers:CreateTimer(2, function()
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Giggle", ACT_DOTA_ATTACK, 1.5, 4.0)
				end)
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2e"	, 5, false)
				end)
				Timers:CreateTimer(10, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2f"	, 5, false)
					hero.master_is_talking = false
					local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
					local question = "tutorial_quiz_question_3"
					local verifier = CustomAttributes.ATK_DMG_PER_PRIMARY
					CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="2_2", quiz_question=question, sequence=0, verifier = verifier, localize_verifier = 0, challenge_progress = 1} )
					CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:UpdateChallengeSummaryProgress(hero, 2, 2, 2, false)
				hero.master_is_talking = true
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2g", 5, false)
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2h"	, 5, false)
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_CAST_ABILITY_4, 1.0, 4.0)
					hero.master_is_talking = false
					local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
					local question = "tutorial_quiz_question_4"
					local choice = RandomInt(1,2)
					local verifier = nil
					local sub = nil
					if choice == 1 then
						verifier = tonumber(math.floor(hero:GetPhysicalArmorBaseValue()))
						sub = "tutorial_base_armor"
					elseif choice == 2 then
						verifier = tonumber(math.floor(hero:Script_GetAttackRange()))
						sub = "ui_attack_range"
					end
					CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="2_2", quiz_question=question, sequence=0, verifier = verifier, gsub1 = sub, localize_verifier = 0, challenge_progress = 2} )
					CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
				end)
			elseif code2 == 2 and hero.active_challenge_progress == code2 then
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:UpdateChallengeSummaryProgress(hero, 2, 2, 3, false)
				hero.master_is_talking = true
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2i", 5, false)
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2j", 5, false)
				end)
				Timers:CreateTimer(10, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2k", 5, false)
				end)
				Timers:CreateTimer(15, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2l"	, 5, false)
					hero.master_is_talking = false
					local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
					local question = "tutorial_quiz_question_5"
					local choice = RandomInt(1,3)
					local baseDamage = 100000
					local verifier = Filters:TakeArgumentsAndApplyDamage(Events.GameMaster, hero, baseDamage, DAMAGE_TYPE_PURE, choice, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE, true)
					verifier = math.floor((verifier/baseDamage)*100)
					if choice == 4 then
						choice = DOTA_ULTIMATE_SLOT+1
					end
					local sub = "DOTA_Tooltip_Ability_"..hero:GetAbilityByIndex(choice-1):GetAbilityName()
					CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="2_2", quiz_question=question, sequence=0, verifier = verifier, gsub1 = sub, localize_verifier = 0, challenge_progress = 3} )
					CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
				end)
			elseif code2 == 3 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				local speech_phase = hero.tutorial_speech_phase
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.2, 2.5)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_2m", 6, false)
				Timers:CreateTimer(3, function()
					hero.master_is_talking = false
					Tutorial:ProgressUpdateOrNot(hero, 2, 2)
					Tutorial:UpdateChallengeSummaryProgress(hero, 2, 2, 4, true)
				end)
			end
		elseif code1 == "2_3" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_3e", 5, false)
				Timers:CreateTimer(2, function()
					EmitSoundOn("Tutorial.Master.GreetingBasic", hero)
				end)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				local speech_phase = hero.tutorial_speech_phase
				Timers:CreateTimer(5, function()
					hero.master_is_talking = false
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_3f", 5, false)
					end
					Timers:CreateTimer(5, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_2_3g", 5, false)
						end
						Tutorial:ProgressUpdateOrNot(hero, 2, 3)
						Timers:CreateTimer(3, function()
							hero.tutorial.active_challenge = nil
							Tutorial:UpdateChallengeSummaryProgress(hero, 2, 3, 1, true)
						end)
					end)
				end)
			end
		elseif code1 == "3_1" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1c", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.2, 2.5)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				local speech_phase = hero.tutorial_speech_phase
				Timers:CreateTimer(2, function()
					Tutorial:UpdateChallengeSummaryProgress(hero, 3, 1, 1, false)
				end)
				Timers:CreateTimer(5, function()
					hero.master_is_talking = false
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1d", 5, false)
					end
					Timers:CreateTimer(5, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1e", 5, false)
							local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
							local question = "tutorial_quiz_question_6"
							local verifier = "tutorial_quiz_question_6_answer"
							CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="3_1", quiz_question=question, sequence=1, verifier = verifier, localize_verifier = 1, challenge_progress = 1} )
							CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
						end
					end)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1f", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting2", ACT_DOTA_CAST_ABILITY_2, 1.2, 2.5)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				local speech_phase = hero.tutorial_speech_phase
				Tutorial:UpdateChallengeSummaryProgress(hero, 3, 1, 2, false)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1g", 5, false)
					end
					Timers:CreateTimer(5, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1h", 5, false)
						end
					end)
					Timers:CreateTimer(10, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1i", 5, false)
						end
					end)
					Timers:CreateTimer(15, function()
						if speech_phase == hero.tutorial_speech_phase then
							Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_3, 1.2, 2.5)
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1j", 5, false)
						end
					end)
					Timers:CreateTimer(20, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1l", 5, false)
							local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
							local question = "tutorial_quiz_question_7"
							local sub_number = RandomInt(1,2)
							local gsub1 = "tutorial_quiz_question_7_sub_answer"..sub_number
							local verifier = "item_rarity_immortal"
							if sub_number == 2 then
								verifier = "item_rarity_arcana"
							end
							local buttons = {"item_rarity_uncommon", "item_rarity_rare", "item_rarity_mythical", "item_rarity_immortal", "item_rarity_arcana"}
							CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="3_1", quiz_question=question, sequence=2, verifier = verifier, localize_verifier = 1, challenge_progress = 2, gsub1 = gsub1, buttons = buttons} )
							CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
						end
					end)
				end)
				Timers:CreateTimer(20, function()
					hero.master_is_talking = false
				end)
			elseif code2 == 2 and hero.active_challenge_progress == code2 then
				print("in here?")
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				local speech_phase = hero.tutorial_speech_phase
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.2, 2.5)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_1m", 6, false)
				Timers:CreateTimer(3, function()
					hero.master_is_talking = false
					Tutorial:ProgressUpdateOrNot(hero, 3, 1)
					Tutorial:UpdateChallengeSummaryProgress(hero, 3, 1, 3, true)
				end)
			end
		elseif code1 == "3_2" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2c", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.2, 2.5)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				local speech_phase = hero.tutorial_speech_phase
				Timers:CreateTimer(2, function()
					Tutorial:UpdateChallengeSummaryProgress(hero, 3, 2, 1, false)
				end)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2d", 5, false)
					end
					Timers:CreateTimer(5, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2e", 5, false)
						end
					end)
					Timers:CreateTimer(10, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2f", 5, false)
						end
					end)
					Timers:CreateTimer(15, function()
						hero.master_is_talking = false
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2g", 5, false)
						end
					end)
					Timers:CreateTimer(20, function()
						if speech_phase == hero.tutorial_speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2h", 5, false)
							local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
							local question = "tutorial_quiz_question_8"
							local verifier = 2
							CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="3_2", quiz_question=question, sequence=1, verifier = verifier, localize_verifier = 0, challenge_progress = 1} )
							CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
						end
					end)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
				local speech_phase = hero.tutorial_speech_phase
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.2, 2.5)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2i", 5, false)
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2j", 6, false)
				end)
				Timers:CreateTimer(11, function()
					hero.master_is_talking = false
					Tutorial:ProgressUpdateOrNot(hero, 3, 2)
					Tutorial:UpdateChallengeSummaryProgress(hero, 3, 2, 2, true)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_2k", 6, false)
				end)
			end
		elseif code1 == "3_3" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_3e", 5, false)
				hero.master_is_talking = false
				Tutorial:ProgressUpdateOrNot(hero, 3, 3)
				Timers:CreateTimer(2, function()
					EmitSoundOn("Tutorial.Master.Talk", hero)
				end)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				hero.tutorial.active_challenge = nil
				Timers:CreateTimer(3, function()
					Tutorial:UpdateChallengeSummaryProgress(hero, 3, 3, 1, true)
				end)
			end
		elseif code1 == "3_4" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4e", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = false
				Timers:CreateTimer(5, function()
					Tutorial:ProgressUpdateOrNot(hero, 3, 4)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_4f", 5, false)
					hero.active_challenge_progress = hero.active_challenge_progress + 1
					hero.tutorial.active_challenge = nil
					Timers:CreateTimer(3, function()
						Tutorial:UpdateChallengeSummaryProgress(hero, 3, 4, 1, true)
					end)
				end)
			end
		elseif code1 == "3_5" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_5d", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = false
				Tutorial:UpdateChallengeSummaryProgress(hero, 3, 5, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					EmitSoundOn("Tutorial.Master.Talk", hero)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_5e", 5, false)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_3_5f", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = false
				Timers:CreateTimer(1.7, function()
					Tutorial:ProgressUpdateOrNot(hero, 3, 5)
					hero.active_challenge_progress = hero.active_challenge_progress + 1
					hero.tutorial.active_challenge = nil
					Tutorial:UpdateChallengeSummaryProgress(hero, 3, 5, 2, true)
				end)
			end
		elseif code1 == "4_1" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1f", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = true
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 1, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1g", 5, false)
				end)
				Timers:CreateTimer(10, function()
					hero.shroomling.cantAggro = false
					hero.shroomling.phase = 1
					EmitSoundOn("Tutorial.Master.Talk", hero)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1h", 5, false)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_1i", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = false
				Timers:CreateTimer(0, function()
					Tutorial:ProgressUpdateOrNot(hero, 4, 1)
					hero.active_challenge_progress = hero.active_challenge_progress + 1
					hero.tutorial.active_challenge = nil
					Tutorial:UpdateChallengeSummaryProgress(hero, 4, 1, 2, true)
				end)
			end
		elseif code1 == "4_2" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2e", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = true
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 2, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2f", 5, false)
				end)
				Timers:CreateTimer(10, function()
					if speech_phase == hero.tutorial_speech_phase then
						EmitSoundOn("Tutorial.Master.Talk", hero)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2g", 5, false)
					end
				end)
				Timers:CreateTimer(15, function()
					if speech_phase == hero.tutorial_speech_phase then
						EmitSoundOn("Tutorial.Master.Talk", hero)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2h", 5, false)
					end
				end)
				Timers:CreateTimer(20, function()
					if speech_phase == hero.tutorial_speech_phase then
						EmitSoundOn("Tutorial.Master.Talk", hero)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2i", 5, false)
						local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
						local question = "tutorial_quiz_question_12"
						local choice = RandomInt(1,3)
						local verifier = nil
						local sub = nil
						if choice == 1 then
							local reduc = (1 - GameState:IncomingDamageDecreaseWithType(hero, Events.GameMaster, false, DAMAGE_TYPE_PHYSICAL))*100000
							reduc = reduc - (GameState:IncomingDamageIncrease(hero, Events.GameMaster, false, DAMAGE_TYPE_PHYSICAL) - 1)*100000
							verifier = reduc/1000
							sub = "DOTA_ToolTip_Damage_Physical"
						elseif choice == 2 then
							local reduc = (1 - GameState:IncomingDamageDecreaseWithType(hero, Events.GameMaster, false, DAMAGE_TYPE_MAGICAL))*100000
							reduc = reduc - (GameState:IncomingDamageIncrease(hero, Events.GameMaster, false, DAMAGE_TYPE_MAGICAL) - 1)*100000
							verifier = reduc/1000
							sub = "DOTA_ToolTip_Damage_Magical"
						elseif choice == 3 then
							local reduc = (1 - GameState:IncomingDamageDecreaseWithType(hero, Events.GameMaster, false, DAMAGE_TYPE_PURE))*100000
							reduc = reduc - (GameState:IncomingDamageIncrease(hero, Events.GameMaster, false, DAMAGE_TYPE_PURE) - 1)*100000
							verifier = reduc/1000
							sub = "DOTA_ToolTip_Damage_Pure"
						end
						CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_2", quiz_question=question, sequence=1, verifier = verifier, gsub1 = sub, localize_verifier = 0, challenge_progress = 1} )
						CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
					end
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2j", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = true
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 2, 2, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2k", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
					Timers:CreateTimer(2.4, function()
						local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
						local question = "tutorial_quiz_question_13"
						local choice = RandomInt(1,3)
						local verifier = nil
						local sub = nil
						if choice == 1 then
							verifier = "DOTA_ToolTip_Damage_Physical"
							sub = "tutorial_quiz_question_13_sub1"
						elseif choice == 2 then
							verifier = "DOTA_ToolTip_Damage_Magical"
							sub = "tutorial_quiz_question_13_sub2"
						elseif choice == 3 then
							verifier = "DOTA_ToolTip_Damage_Pure"
							sub = "tutorial_quiz_question_13_sub3"
						end
						local buttons = {"DOTA_ToolTip_Damage_Physical", "DOTA_ToolTip_Damage_Magical", "DOTA_ToolTip_Damage_Pure"}
						CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_2", quiz_question=question, sequence=2, verifier = verifier, gsub1 = sub, localize_verifier = 1, challenge_progress = 2, buttons = buttons} )
						CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
					end)
				end)
			elseif code2 == 2 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_2l", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = false
				Timers:CreateTimer(2, function()
					Tutorial:ProgressUpdateOrNot(hero, 4, 2)
					hero.active_challenge_progress = hero.active_challenge_progress + 1
					hero.tutorial.active_challenge = nil
					Tutorial:UpdateChallengeSummaryProgress(hero, 4, 2, 3, true)
				end)
			end
		elseif code1 == "4_3" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3d", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = true
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 3, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3e", 5, false)
				end)
				Timers:CreateTimer(10, function()
					if speech_phase == hero.tutorial_speech_phase then
						Timers:CreateTimer(2, function()
							Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
							Timers:CreateTimer(0.3, function()
								hero.shroomling_table = {}
								hero.shrooms_slain = 0
								EmitSoundOn("Tutorial.SpawnUnit", Tutorial.Master)
								for i = 1, 10, 1 do
									local rotatedVector = WallPhysics:rotateVector(Vector(1,0), 2*math.pi*i/10)
									local shroomling = CreateUnitByName("tutorial_shroomling2", Vector(-576, 1984)+rotatedVector*300, false, nil, nil, DOTA_TEAM_NEUTRALS)
									shroomling.dominion = true
									shroomling:SetForwardVector(Vector(1,0))
									CustomAbilities:QuickParticleAtPoint("particles/roshpit/tutorial/tutorial_sprout.vpcf", shroomling:GetAbsOrigin(), 3)
									-- shroomling.cantAggro = true
									local particleName = "particles/roshpit/redfall/red_beam.vpcf"
								    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
								    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
								    ParticleManager:SetParticleControl(pfx,1,shroomling:GetAbsOrigin()+Vector(0,0,60))
									Timers:CreateTimer(3.5, function()
										ParticleManager:DestroyParticle(pfx, false)
									end)
									AddFOWViewer(DOTA_TEAM_GOODGUYS, shroomling:GetAbsOrigin(), 300, 180, false)
									shroomling.hero = hero
									shroomling.damage_code = 1
									hero.shroomling = shroomling
									Tutorial:ApplyTutorialModifier("modifier_tutorial_unit", shroomling, 0)
									local ability = shroomling:FindAbilityByName("dungeon_creep")
									if ability then
										ability:SetLevel(1)
										ability:ApplyDataDrivenModifier(shroomling, shroomling, "modifier_dungeon_thinker_creep", {})
									end
									if i < 4 then
										shroomling.aggroSound = "Tutorial.Shroomling.Aggro"
									end
								    shroomling:SetDeathXP(500)
								    shroomling:SetMaximumGoldBounty(10)
								    shroomling:SetMinimumGoldBounty(20)
								    table.insert(hero.shroomling_table, shroomling)
								end
							end)
						end)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3f", 5, false)
					end
				end)
				Timers:CreateTimer(15, function()
					if speech_phase == hero.tutorial_speech_phase then
						hero.master_is_talking = false
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3g", 5, false)
						if hero.shroomling_table then
							for i = 1, #hero.shroomling_table, 1 do
								Dungeons:AggroUnit(hero.shroomling_table[i])
							end
						end
					end
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_3h", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				hero.master_is_talking = false
				Timers:CreateTimer(2, function()
					Tutorial:ProgressUpdateOrNot(hero, 4, 3)
					hero.active_challenge_progress = hero.active_challenge_progress + 1
					hero.tutorial.active_challenge = nil
					Tutorial:UpdateChallengeSummaryProgress(hero, 4, 3, 2, true)
				end)
			end
		elseif code1 == "4_4" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4d", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = false
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 4, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4e", 5, false)
					end
				end)
				Timers:CreateTimer(10, function()
					if speech_phase == hero.tutorial_speech_phase then
						hero.master_is_talking = false
						EmitSoundOn("Tutorial.Master.Talk", hero)
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4f", 5, false)
						local runes_with_element = {}
						for i = 0, 3, 1 do
							for j = 1, 4, 1 do
								local runeUnit = hero.runeUnitTable[j]
								local rune = runeUnit:GetAbilityByIndex(i)
								if rune:GetLevelSpecialValueFor("element_one", 1) > 0 then
									table.insert(runes_with_element, rune)
								end
							end
						end
						local random_rune = runes_with_element[RandomInt(1, #runes_with_element)]
						local sub1 = "DOTA_Tooltip_ability_"..random_rune:GetAbilityName()
						local verifier = "rpc_element"..random_rune:GetLevelSpecialValueFor("element_one", 1)
						local question = "tutorial_quiz_question_15"
						local player = hero:GetPlayerOwner()
						CustomGameEventManager:Send_ServerToPlayer(player, "call_quiz", {hero=hero:GetEntityIndex(), identifier="4_4", quiz_question=question, sequence=1, gsub1 = sub1, verifier = verifier, localize_verifier = 1, challenge_progress = 1} )
						CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Hint"} )
					end
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4g", 3.7, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				hero.master_is_talking = false
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 4, 2, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Timers:CreateTimer(4.0 , function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4h", 5, false)
						Tutorial:ApplyTutorialModifier("modifier_tutorial_summon_animation", Tutorial.Master, 5)
						Tutorial.Master.floatPhase = 0
						Timers:CreateTimer(1.5, function()
							Tutorial.Master.floatPhase = 1
						end)
						Timers:CreateTimer(0.5, function()
							EmitSoundOnLocationWithCaster(Vector(-576, 1984), "Tutorial.Elemental.SpawnStart", Tutorial.Master)
						end)
						Timers:CreateTimer(3, function()
							Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
							Timers:CreateTimer(0.3, function()
								local elemental = CreateUnitByName("challens_elemental", Vector(-576, 1984), false, nil, nil, DOTA_TEAM_NEUTRALS)
								EmitSoundOn("Tutorial.Elemental.Spawn", elemental)
								elemental:SetForwardVector(Vector(1,0))
								CustomAbilities:QuickAttachParticle("particles/roshpit/zonik/speedball_explosion.vpcf", elemental, 5)
								elemental.cantAggro = true
								local particleName = "particles/roshpit/redfall/red_beam.vpcf"
							    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
							    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
							    ParticleManager:SetParticleControl(pfx,1,elemental:GetAbsOrigin()+Vector(0,0,60))
								Timers:CreateTimer(3.5, function()
									ParticleManager:DestroyParticle(pfx, false)
								end)
								AddFOWViewer(DOTA_TEAM_GOODGUYS, elemental:GetAbsOrigin(), 300, 180, false)
								elemental.hero = hero
								elemental.damage_code = 2
								hero.elemental = elemental
								Tutorial:ApplyTutorialModifier("modifier_tutorial_unit", elemental, 0)
								local ability = elemental:FindAbilityByName("dungeon_creep")
								if ability then
									ability:SetLevel(1)
									ability:ApplyDataDrivenModifier(elemental, elemental, "modifier_dungeon_thinker_creep", {})
								end
								elemental.aggroSound = "Tutorial.Elemental.Aggro"
							    elemental:SetDeathXP(500)
							    elemental:SetMaximumGoldBounty(10)
							    elemental:SetMinimumGoldBounty(20)
							    Timers:CreateTimer(3, function()
							    	elemental.cantAggro = false
							    	Dungeons:AggroUnit(elemental)
							    end)
							end)
						end)
					end
				end)
				Timers:CreateTimer(10.5 , function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4i", 5, false)
					end
				end)
			elseif code2 == 2 and hero.active_challenge_progress == code2 then
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_4j", 3.7, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				hero.master_is_talking = false
				Tutorial:ProgressUpdateOrNot(hero, 4, 4)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 4, 3, true)
				hero.active_challenge = nil
			end
		elseif code1 == "4_5" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5c", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 5, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5d", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5e", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 5, 2, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5f", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
				end)
			elseif code2 == 2 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5g", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 5, 3, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
			elseif code2 == 3 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5i", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 5, 4, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5j", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
				end)
			elseif code2 == 4 and hero.active_challenge_progress == code2 then
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_5k", 4.5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				hero.master_is_talking = false
				Tutorial:ProgressUpdateOrNot(hero, 4, 5)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 5, 5, true)
				hero.active_challenge = nil
			end
		elseif code1 == "4_6" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_6d", 5, false)
				EmitSoundOn("Tutorial.Master.Greeting1", hero)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 6, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_6e", 5, false)
					Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
					Timers:CreateTimer(0.3, function()
						local particleName = "particles/roshpit/redfall/red_beam.vpcf"
					    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
					    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
					    ParticleManager:SetParticleControl(pfx,1,hero:GetAbsOrigin()+Vector(0,0,80))
						Timers:CreateTimer(3.5, function()
							ParticleManager:DestroyParticle(pfx, false)
						end)
						EmitSoundOn("Tutorial.PostmitBuff.Apply", hero)
						Tutorial:ApplyTutorialModifier("challen_postmit_buff", hero, 0)
					end)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_6f", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Tutorial:ProgressUpdateOrNot(hero, 4, 6)
					Tutorial:UpdateChallengeSummaryProgress(hero, 4, 6, 2, true)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_6g", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
					hero:RemoveModifierByName("challen_postmit_buff")
				end)
			end
		elseif code1 == "4_7" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				hero:RemoveModifierByName("modifier_challen_4_7_buff")
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7d", 5, false)
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Greeting1", ACT_DOTA_CAST_ABILITY_3, 1.0, 4.0)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 7, 1, false)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7e", 5, false)
					Timers:CreateTimer(5, function()
						if hero.tutorial_speech_phase == speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7f", 5, false)
						end
					end)
					Timers:CreateTimer(10, function()
						if hero.tutorial_speech_phase == speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7g", 6, false)
							Timers:CreateTimer(3, function()
								Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
								Timers:CreateTimer(0.3, function()
									local shroomling = CreateUnitByName("tutorial_shroomling", Vector(-576, 1984), false, nil, nil, DOTA_TEAM_NEUTRALS)
									EmitSoundOn("Tutorial.SpawnUnit", shroomling)
									shroomling:SetForwardVector(Vector(1,0))
									CustomAbilities:QuickParticleAtPoint("particles/roshpit/tutorial/tutorial_sprout.vpcf", shroomling:GetAbsOrigin(), 3)
									shroomling.cantAggro = true
									local particleName = "particles/roshpit/redfall/red_beam.vpcf"
								    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
								    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
								    ParticleManager:SetParticleControl(pfx,1,shroomling:GetAbsOrigin()+Vector(0,0,60))
									Timers:CreateTimer(3.5, function()
										ParticleManager:DestroyParticle(pfx, false)
									end)
									AddFOWViewer(DOTA_TEAM_GOODGUYS, shroomling:GetAbsOrigin(), 300, 180, false)
									shroomling.hero = hero
									shroomling.phase = 0
									shroomling.damage_code = 3
									hero.shroomling = shroomling
									Tutorial:ApplyTutorialModifier("modifier_tutorial_unit", shroomling, 0)

									local ability = shroomling:FindAbilityByName("dungeon_creep")
									if ability then
										ability:SetLevel(1)
										ability:ApplyDataDrivenModifier(shroomling, shroomling, "modifier_dungeon_thinker_creep", {})
									end
									shroomling.aggroSound = "Tutorial.Shroomling.Aggro"
								    shroomling:SetDeathXP(500)
								    shroomling:SetMaximumGoldBounty(10)
								    shroomling:SetMinimumGoldBounty(20)
								end)
							end)
						end
					end)
					Timers:CreateTimer(16, function()
						if hero.tutorial_speech_phase == speech_phase then
							hero.shroomling.bossStatus = true
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7h", 5, false)
							Timers:CreateTimer(2, function()
								for i = 1, 15, 1 do
									Timers:CreateTimer(1*i, function()
										Tutorial:SoundAndAnimationForMaster(nil, ACT_DOTA_ATTACK, 1.0, 0.9)
										Timers:CreateTimer(0.3, function()
											local particleName = "particles/roshpit/redfall/red_beam.vpcf"
											if i == 5 then
												Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7i", 3, false)
											end
											if i == 8 then
												Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7j", 3, false)
												Timers:CreateTimer(1.5, function()
													EmitSoundOn("Tutorial.Master.Giggle", hero)
												end)
											end
											if i == 11 then
												hero.shroomling:AddAbility("redfall_forest_roar"):SetLevel(1)
												Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7k", 5, false)
											end
										    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
										    ParticleManager:SetParticleControl(pfx,0,Tutorial.Master:GetAbsOrigin()+Vector(0,0,120))   
										    ParticleManager:SetParticleControl(pfx,1,hero.shroomling:GetAbsOrigin()+Vector(0,0,60))
											Timers:CreateTimer(3.5, function()
												ParticleManager:DestroyParticle(pfx, false)
											end)
											EmitSoundOn("Tutorial.PostmitBuff.Apply", hero.shroomling)
											Filters:ApplyStun(Tutorial.Master, 1, hero.shroomling)
											if i < 11 then
												StartAnimation(hero.shroomling, {duration=0.3, activity=ACT_DOTA_FLAIL, rate=1.1})
											end
											if i%4 == 1 then
												EmitSoundOn("Tutorial.Shroomling.Stun", hero.shroomling)
											end
										end)
									end)
								end
							end)
						end
					end)
					Timers:CreateTimer(32, function()
						if hero.tutorial_speech_phase == speech_phase then
							Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7l", 5, false)
							Timers:CreateTimer(1, function()
								local castAbility = hero.shroomling:FindAbilityByName("redfall_forest_roar")
								local newOrder = {
								 		UnitIndex = hero.shroomling:entindex(), 
								 		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
								 		AbilityIndex = castAbility:entindex(),
							 	}
								ExecuteOrderFromTable(newOrder)		
								EmitSoundOn("Tutorial.Shroomling.AngerStart", hero.shroomling)
								local newHealth = 4000
							    hero.shroomling:SetMaxHealth(newHealth)
							    hero.shroomling:SetBaseMaxHealth(newHealth)
							    hero.shroomling:SetHealth(newHealth)
								Timers:CreateTimer(3, function()
									hero.shroomling.cantAggro = false
									hero.shroomling.phase = 1
									Dungeons:AggroUnit(hero.shroomling)
								end)
							end)
						end
					end)
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_4_7m", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:ProgressUpdateOrNot(hero, 4, 7)
				Tutorial:UpdateChallengeSummaryProgress(hero, 4, 7, 2, true)
				EmitSoundOn("Tutorial.Master.Talk", hero)
				hero:RemoveModifierByName("modifier_challen_4_7_buff")
			end
		elseif code1 == "5_1" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_5_1g", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Tutorial:ProgressUpdateOrNot(hero, 5, 1)
					Tutorial:UpdateChallengeSummaryProgress(hero, 5, 1, 1, true)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_5_1h", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
				end)
			end
		elseif code1 == "5_2" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_5_2e", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:ProgressUpdateOrNot(hero, 5, 2)
				Tutorial:UpdateChallengeSummaryProgress(hero, 5, 2, 1, true)
			end
		elseif code1 == "5_3" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_5_3g", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:ProgressUpdateOrNot(hero, 5, 3)
				Tutorial:UpdateChallengeSummaryProgress(hero, 5, 3, 1, true)
			end
		elseif code1 == "6_1" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				if GameState:GetPlayerPremiumStatus(hero:GetPlayerOwnerID()) then
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_1f1", 5, false)
				else
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_1f", 5, false)
				end
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Tutorial:ProgressUpdateOrNot(hero, 6, 1)
					Tutorial:UpdateChallengeSummaryProgress(hero, 6, 1, 1, true)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_1g", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
				end)
			end
		elseif code1 == "6_2" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_2h", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:UpdateChallengeSummaryProgress(hero, 6, 2, 1, false)
				Timers:CreateTimer(5, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_2i", 5, false)
						EmitSoundOn("Tutorial.Master.Talk", hero)
					end
				end)
				Timers:CreateTimer(10, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_2j", 5, false)
					end
				end)
				Timers:CreateTimer(15, function()
					if speech_phase == hero.tutorial_speech_phase then
						Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_2k", 5, false)
					end
				end)
			elseif code2 == 1 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_2l", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:ProgressUpdateOrNot(hero, 6, 2)
				Tutorial:UpdateChallengeSummaryProgress(hero, 6, 2, 2, true)
			end
		elseif code1 == "6_3" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_3f", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:ProgressUpdateOrNot(hero, 6, 3)
				Tutorial:UpdateChallengeSummaryProgress(hero, 6, 3, 1, true)
			end
		elseif code1 == "6_4" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_4d", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Tutorial:ProgressUpdateOrNot(hero, 6, 4)
				Tutorial:UpdateChallengeSummaryProgress(hero, 6, 4, 1, true)
			end
		elseif code1 == "6_5" then
			if code2 == 0 and hero.active_challenge_progress == code2 then
				Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_1, 1.0, 4.0)
				Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_5e", 5, false)
				local speech_phase = Tutorial:GetSpeechPhaseAndUpdate(hero)
				hero.active_challenge_progress = hero.active_challenge_progress + 1
				Timers:CreateTimer(5, function()
					Tutorial:ProgressUpdateOrNot(hero, 6, 5)
					Tutorial:UpdateChallengeSummaryProgress(hero, 6, 5, 1, true)
					Quests:ShowDialogueText({hero}, Tutorial.Master,"tutorial_master_dialogue_6_5f", 5, false)
					EmitSoundOn("Tutorial.Master.Talk", hero)
				end)
			end
		end
	end
end



function Tutorial:GetSpeechPhaseAndUpdate(hero)
	hero.tutorial_speech_phase = hero.tutorial_speech_phase + 1
	local speech_phase = hero.tutorial_speech_phase
	return speech_phase
end

function Tutorial:ProgressUpdateOrNot(hero, section_index, newProgress)
	local section = nil
	if section_index == 1 then
		if newProgress > hero.tutorial.section1.progress then
			hero.tutorial.section1.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	elseif section_index == 2 then
		if newProgress > hero.tutorial.section2.progress then
			hero.tutorial.section2.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	elseif section_index == 3 then
		if newProgress > hero.tutorial.section3.progress then
			hero.tutorial.section3.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	elseif section_index == 4 then
		if newProgress > hero.tutorial.section4.progress then
			hero.tutorial.section4.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	elseif section_index == 5 then
		if newProgress > hero.tutorial.section5.progress then
			hero.tutorial.section5.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	elseif section_index == 6 then
		if newProgress > hero.tutorial.section6.progress then
			hero.tutorial.section6.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	elseif section_index == 7 then
		if newProgress > hero.tutorial.section7.progress then
			hero.tutorial.section7.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	elseif section_index == 8 then
		if newProgress > hero.tutorial.section8.progress then
			hero.tutorial.section8.progress = newProgress
			Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
		end
	end
end

function Tutorial:SaveTutorialProgressOnWeb(hero, section_index, newProgress)
	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/update_tutorial?"
	print(section_index)
	url = url.."steam_id="..steamID
	url = url.."&type=".."progress"
	url = url.."&section="..section_index
	url = url.."&progress="..newProgress
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	print(url)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			Tutorial:LoadTutorialDataForHero(hero, resultTable)
		end
	end )
end

function Tutorial:ActivatePortal(bFirst)
	local sound = "Tutorial.PortalActivate"
	if bFirst then
		sound = "Tutorial.PortalActivateFirst"
		Tutorial:SoundAndAnimationForMaster("Tutorial.Master.Talk", ACT_DOTA_CAST_ABILITY_3, 1.0, 4.0)
	end
	if not Tutorial.PortalActive then
		Tutorial.PortalActive = true
		local positionTable = {Vector(-3720, -2535), Vector(606, 1588)}
		for i = 1, #positionTable, 1 do
			local position = positionTable[i]
			EmitSoundOnLocationWithCaster(position, sound, Tutorial.Master)
			Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", GetGroundPosition(position, Tutorial.Master) - Vector(0,0,40), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
			AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 300, 99999, false)
		end
	end
end

function Tutorial:ClaimReward(msg)
	local hero = EntIndexToHScript(msg.hero)
	local rewards = Tutorial:GetTutorialDataArray(hero, "reward")
	if msg.category_index == 3 and hero.grandTotalStars < 20 then
		return false
	elseif msg.category_index == 5 and hero.grandTotalStars < 30 then
		return false
	elseif msg.category_index == 6 and hero.grandTotalStars < 75 then
		return false
	end
	if rewards[msg.category_index] == 0 then
		Tutorial:UpdateRewardProgressOnWeb(hero, msg.category_index)
	end
end

function Tutorial:UpdateRewardProgressOnWeb(hero, section_index)
	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/update_tutorial?"
	url = url.."steam_id="..steamID
	url = url.."&type=".."reward"
	url = url.."&section="..section_index
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	print(url)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			Tutorial:LoadTutorialDataForHero(hero, resultTable)
			if section_index == 1 then
				Tutorial:ActivatePortal(true)
				Stars:StarEventSolo("champleague", hero)
			elseif section_index == 2 then
				Tutorial:SpawnAllTownNPCs()
			elseif section_index == 3 then
				local validator = "roshpit"
				local newItem = RPCItems:CreateArcanaCache(15, validator)
				newItem.pickedUp = true
				UTIL_Remove(newItem:GetContainer())
				RPCItems:GiveItemToHeroWithSlotCheck(hero, newItem)
			elseif section_index == 4 then
				Tutorial:SpawnTrainingDummyForHero(hero)
			elseif section_index == 5 then
				Tutorial:GetMithrilPrize(Tutorial.Master:GetAbsOrigin(), hero, 125000)
			elseif section_index == 6 then
				local particleName = "particles/roshpit/web/web_premium.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, hero)
				ParticleManager:SetParticleControl(pfx, 0, hero:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 1, Vector(200, 200, 200))
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				EmitSoundOn("RPC.WebPremium", hero)
				CustomNetTables:SetTableValue("premium_pass", "web-"..tostring(playerID), {premium = 1} )
				CustomGameEventManager:Send_ServerToAllClients("update_premium", {playerID = playerID} )
				Notifications:Top(playerID, {text="Web Premium Added", duration=8, style={color="#A2EFEF"}, continue=true})
				Stars:StarEventSolo("champleague", hero)
			end
		end
	end )
end

function Tutorial:UpdateSpecialKeyOnWeb(hero, special_key)
	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/update_tutorial?"
	url = url.."steam_id="..steamID
	url = url.."&type=".."special_key"
	url = url.."&special_key="..special_key
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	print(url)
	CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			local special_key = resultTable.special_key
		end
	end )
end

function Tutorial:SubmitQuiz(msg)
	local hero = EntIndexToHScript(msg.hero)
	local playerID = hero:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(playerID)
	print("---SUBMIT QUIZ---")
	print(hero.tutorial.active_challenge)
	if hero.tutorial.active_challenge == msg.challenge_index then
		if hero.tutorial.active_challenge == "2_1" then
			msg.verifier = Tutorial:RemoveRunePrefix(msg.verifier)
		end
		if hero.tutorial.active_challenge == "3_3" then
			local weapons_data = CustomNetTables:GetTableValue("weapons", tostring(hero:GetEntityIndex()))
			msg.verifier = weapons_data.maxLevel
		end
		local correct_answer = tonumber(msg.verifier) == tonumber(msg.answer)
		if hero.tutorial.active_challenge == "3_1" then
			msg.answer = string.gsub(string.lower(msg.answer), "the ", "")
			correct_answer = string.match(string.lower(msg.verifier), string.lower(msg.answer))
		elseif hero.tutorial.active_challenge == "4_1" then
			correct_answer = msg.verifier == msg.answer
		elseif hero.tutorial.active_challenge == "4_2" then
			if msg.challenge_progress == 0 then
				if tonumber(msg.answer) - 1 < tonumber(msg.verifier) and tonumber(msg.answer) + 1 > tonumber(msg.verifier) then
					correct_answer = true
				end
			end
		elseif hero.tutorial.active_challenge == "4_3" then
				if tonumber(msg.answer) - 100 < tonumber(msg.verifier) and tonumber(msg.answer) + 100 > tonumber(msg.verifier) then
					correct_answer = true
				end			
		end
		if tonumber(msg.bLocalize) == 1 then
			msg.answer = string.gsub(msg.answer, "%", "")
			correct_answer = msg.verifier == string.gsub(msg.answer, "%%", "")
		end
		print(msg.challenge_index)
		print(msg.verifier)
		print(msg.answer)
		if correct_answer then
			CustomGameEventManager:Send_ServerToPlayer(player, "close_quiz", {} )
			Tutorial:TutorialServerEvent(hero, hero.tutorial.active_challenge, msg.challenge_progress)
		else
			CustomGameEventManager:Send_ServerToPlayer(player, "quiz_sound", {sound = "Tutorial.Error"} )
			local dialogue = "tutorial_quiz_wrong_"..hero.tutorial.active_challenge.."_"..(RandomInt(1,2)+(tonumber(msg.challenge_progress))*2)
			Quests:ShowDialogueText({hero}, Tutorial.Master, dialogue, 5, false)
		end
	end
end

function Tutorial:RemoveRunePrefix(full_rune_name)
	full_rune_name = string.gsub(full_rune_name, "%[q1%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[q2%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[q3%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[q4%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[w1%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[w2%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[w3%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[w4%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[e1%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[e2%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[e3%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[e4%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[r1%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[r2%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[r3%] ", "")
	full_rune_name = string.gsub(full_rune_name, "%[r4%] ", "")
	return full_rune_name
end

function Tutorial:GetMithrilPrize(position, hero, mithrilReward)
  Timers:CreateTimer(5, function()

        local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))*Events.ResourceBonus
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = {hero}
        if #crystal.winnerTable > 0 then
          Timers:CreateTimer(1.4, function()
            EmitSoundOn("Resource.MithrilShardEnter", crystal)
          end)
        end
  end)
end

function Tutorial:UnitDamage(attacker, victim, damage, damagetype, inflictor_index)
	local inflictor_ability = nil
	if inflictor_index then
		inflictor_ability = EntIndexToHScript(inflictor_index)
	end
	if victim.damage_code == 0 then
		if victim.phase == 0 then
			return 0
		elseif victim.phase == 1 then
			if not IsValidEntity(inflictor_ability) then
				if damagetype == DAMAGE_TYPE_PHYSICAL then
					return damage
				else
					return 0
				end
			else
				return 0
			end
		end
	elseif victim.damage_code == 1 then
		if damagetype == DAMAGE_TYPE_PHYSICAL then
			return 0
		else
			return damage
		end
	elseif victim.damage_code == 2 then
		return damage
	elseif victim.damage_code == 3 then
		if victim.phase == 0 then
			return 0
		elseif victim.phase == 1 then
			return damage
		end	
	elseif victim.damage_code == 4 then
		if victim.phase == 0 then
			return 0
		elseif victim.phase == 1 then
			return damage
		end	
	end
end
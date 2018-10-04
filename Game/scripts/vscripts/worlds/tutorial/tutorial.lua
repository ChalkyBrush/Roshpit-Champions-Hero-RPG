function Tutorial:InitTutorialMap()
  print("Initialize Winterblight")
      Dungeons.phoenixCollision = true
      RPCItems.DROP_LOCATION = Vector(-16000,492)
      Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")


      Tutorial.ZFLOAT = 0
    
  Events.TownPosition = Vector(-2830, -2881)
  Events.isTownActive = true

  Dungeons.itemLevel = 1
  Timers:CreateTimer(1, function()
      local blacksmith = Events:SpawnTownNPC(Vector(-1995, -3412), "red_fox", Vector(1, 0.8), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
      StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
      Tutorial.Blacksmith = blacksmith
      Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-1537, -1547), Vector(-0.2, -1))
      Events:SpawnCurator(Vector(-320, -1472), Vector(0,-1))
  end)
  Timers:CreateTimer(3, function()
  	Tutorial:SpawnTrainingDummies()
  end)
  Tutorial:NatureAmbience()
  Tutorial:WaterfallAmbience()
  Tutorial:BlacksmithSounds()

  Tutorial:SpawnTutorialMaster(Vector(-64, 2176))
end

function Tutorial:SpawnOracle()
	Tutorial.OracleSpawned = true
	local oracle = Events:SpawnOracle(Vector(-2842, -1943), Vector(-0.3, -1))
end

function Tutorial:SpawnAllTownNPCs()
	if not Tutorial.OracleSpawned then
		Tutorial:SpawnOracle()
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
	CustomGameEventManager:Send_ServerToPlayer(player, "open_tutorial", {hero=hero:GetEntityIndex(), tutorial=hero.tutorial, sound=sound, categories=categories} )
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
		quest.challenges = 3
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
		hero.tutorial.active_challenge = msg.category_index.."_"..msg.challenge_index
		hero.active_challenge_progress = 0
		local player = hero:GetPlayerOwner()
		CustomGameEventManager:Send_ServerToPlayer(player, "close_quiz", {} )
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
	end
end

function Tutorial:TutorialServerEvent(hero, code1, code2)
	if not hero.tutorial then
		return false
	end
	if hero.tutorial.active_challenge == code1 then
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
						verifier = tonumber(math.floor(hero:GetBaseAttackRange()))
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
					local choice = RandomInt(1,4)
					local baseDamage = 100000
					local verifier = Filters:TakeArgumentsAndApplyDamage(Events.GameMaster, hero, baseDamage, DAMAGE_TYPE_PURE, choice, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE, true)
					verifier = (verifier/baseDamage)*100
					if choice == 4 then
						choice = DOTA_ULTIMATE_SLOT
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
		end
	end
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
	url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
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
	url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
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
			elseif section_index == 2 then
				Tutorial:SpawnAllTownNPCs()
			end
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
		local correct_answer = tonumber(msg.verifier) == tonumber(msg.answer)
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
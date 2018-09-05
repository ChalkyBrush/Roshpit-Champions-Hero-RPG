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
      local oracle = Events:SpawnOracle(Vector(-2842, -1943), Vector(-0.3, -1))
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
  -- Winterblight:CalculateHeroZones()
  -- Winterblight:StarterMusic()
  -- Winterblight:HowlingWind()

    -- Winterblight.Master = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
    -- Winterblight.Master:AddAbility("winterblight_master_ability"):SetLevel(GameState:GetDifficultyFactor())
    -- Winterblight.MasterAbility = Winterblight.Master:FindAbilityByName("winterblight_master_ability")
    -- Winterblight.Master:AddAbility("dummy_unit"):SetLevel(1)
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
	end
end

function Tutorial:LoadTutorialDataForHero(hero, resultTable)
	hero.tutorial = {}
	hero.tutorial.section1 = {}
	hero.tutorial.section1.progress = resultTable.progress1
	hero.tutorial.section1.state = 0
	hero.tutorial.section2 = {}
	hero.tutorial.section2.progress = resultTable.progress2
	hero.tutorial.section2.state = 0
	hero.tutorial.section3 = {}
	hero.tutorial.section3.progress = resultTable.progress3
	hero.tutorial.section3.state = 0
	hero.tutorial.section4 = {}
	hero.tutorial.section4.progress = resultTable.progress4
	hero.tutorial.section4.state = 0
	hero.tutorial.section5 = {}
	hero.tutorial.section5.progress = resultTable.progress5
	hero.tutorial.section5.state = 0
	hero.tutorial.section6 = {}
	hero.tutorial.section6.progress = resultTable.progress6
	hero.tutorial.section6.state = 0
	hero.tutorial.section7 = {}
	hero.tutorial.section7.progress = resultTable.progress7
	hero.tutorial.section7.state = 0
	hero.tutorial.section8 = {}
	hero.tutorial.section8.progress = resultTable.progress8
	hero.tutorial.section8.state = 0

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
	local sound = 0
	if not hero.tutorial.firstopened then
		hero.tutorial.firstopened = true
		sound = 1
		if hero.tutorial_assistant then
			if hero.tutorial_assistant.state < 6 then
				hero.tutorial_assistant.state = 6
			end
		end
	end
	local categories = Tutorial:GetFixedTutorialData()
	local playerID = hero:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(playerID)
	CustomGameEventManager:Send_ServerToPlayer(player, "open_tutorial", {hero=hero:GetEntityIndex(), tutorial=hero.tutorial, sound=sound, categories=categories} )
end

function Tutorial:GetFixedTutorialData()
	local categories = {}
	--
	local quest = {}
	quest.index = 1
	quest.header = "quest_1_interface"
	quest.description = "quest_1_interface_description"
	quest.challenges = {}
	local challenge = {}
	table.insert(quest.challenges, challenge)
	table.insert(categories, quest)
	--
	--
	local quest = {}
	quest.index = 2
	quest.header = "quest_2_interface"
	quest.description = "quest_2_interface_description"
	quest.challenges = {}
	local challenge = {}
	table.insert(quest.challenges, challenge)
	table.insert(categories, quest)
	--
	return categories
end
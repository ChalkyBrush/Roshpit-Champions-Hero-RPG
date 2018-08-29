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
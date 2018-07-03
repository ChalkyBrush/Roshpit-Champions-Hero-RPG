if Serengaard == nil then
  Serengaard = class({})
end

DEBUG_WAVE = 29

function Serengaard:Debug()
  -- CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
  -- Serengaard.wave = 20
  -- Serengaard:TimerEnd()
  -- Serengaard:GiveSunstone(MAIN_HERO_TABLE[1], Serengaard.mainAncient)
  -- Serengaard:SubmitStats()
end

function Serengaard:Debug2()
  -- Serengaard.mainAncient:ForceKill(false)
  -- Serengaard:Mithril("baron", Serengaard.mainAncient:GetAbsOrigin(), 120)
  Serengaard.InfiniteWaveCount = 30
  for i = 1, #MAIN_HERO_TABLE, 1 do
    Stars:StarEventPlayer("serengaard_infinite", MAIN_HERO_TABLE[i])
  end
  -- Serengaard:SubmitStats()
  -- Serengaard:SpawnBossUnit("serengaard_final_boss", SERENGAARD_SPAWN_POINTS[RandomInt(1,#SERENGAARD_SPAWN_POINTS)], 1, 35, 0, false)
  -- Serengaard:SpawnBossUnit("serengaard_final_boss", SERENGAARD_SPAWN_POINTS[RandomInt(1,#SERENGAARD_SPAWN_POINTS)], 1, 35, 0, false)
end

function Serengaard:Init()
  print("Initialize Redfall")
      Dungeons.phoenixCollision = false
      RPCItems.DROP_LOCATION = Vector(0,0)
      Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")


      Serengaard.ZFLOAT = Serengaard:GetZFLOAT()
    
  -- Timers:CreateTimer(2, function()
  --   Events:SpawnSuppliesDealer(Vector(-12928, -14336), Vector(0,-1))

  -- end)
  Events.TownPosition = Vector(0, 0)
  Events.isTownActive = true

  local oracle = Events:SpawnOracle(Vector(-1235, -1621), Vector(-0.2, -1))

	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(0,0), 3400, 99999, false)

  

      Serengaard.SerengaardMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
      Serengaard.SerengaardMaster:AddAbility("serengaard_master_ability"):SetLevel(GameState:GetDifficultyFactor())
      Serengaard.SerengaardMasterAbility = Serengaard.SerengaardMaster:FindAbilityByName("serengaard_master_ability")
      Serengaard.SerengaardMaster:AddAbility("dummy_unit"):SetLevel(1)

  -- Redfall:CalculateHeroZones()
  local startTime = 90
  if Beacons.cheats then
    startTime = 60
  end
  
  
  Serengaard.wave = 0
  if Beacons.cheats then
      Serengaard.wave = 5
      Serengaard:LinewarIncomeFunction(60)
  else
    Serengaard:LinewarIncomeFunction(startTime)
    Serengaard:ZoneDisplayAndMusic()
  end
  Timers:CreateTimer(1, function()
    Serengaard.SerengaardTowerTable = {}
    for i = 1, #SERENGAARD_TOWER_LOCATIONS1, 1 do
      Serengaard:SpawnTower(SERENGAARD_TOWER_LOCATIONS1[i], SERENGAARD_FV_TABLE1[i])
    end
    for j = 1, #SERENGAARD_TOWER_LOCATIONS2, 1 do
      Serengaard:SpawnTower(SERENGAARD_TOWER_LOCATIONS2[j], SERENGAARD_FV_TABLE2[j])
    end
  end)
  local ancient = CreateUnitByName("rpc_serengaard_ancient", Vector(-235, 322), false, nil, nil, DOTA_TEAM_GOODGUYS)
  ancient.startPosition = ancient:GetAbsOrigin()
  Serengaard.mainAncient = ancient
  Events:AdjustDeathXP(ancient)
  Timers:CreateTimer(2, function()
    Serengaard.SerengaardRangerTable = {}
    for i = 1, #SERENGAARD_RANGER_POS_TABLE, 1 do
      Timers:CreateTimer(i*0.1, function()
        Serengaard:SpawnRanger(SERENGAARD_RANGER_POS_TABLE[i])
      end)
    end
  end)
  Timers:CreateTimer(8, function()
    Serengaard.SerengaardGuardianTable = {}
    for i = 1, #SERENGAARD_SUN_GUARD_POS_TABLE, 1 do
      Serengaard:AncientGuardian(SERENGAARD_SUN_GUARD_POS_TABLE[i])
    end
  end)
  Serengaard.SerengaardBarracksTable = {}
  for i = 1, #SERENGAARD_BARRACKS_POS_TABLE, 1 do
    Serengaard:Barracks(SERENGAARD_BARRACKS_POS_TABLE[i], SERENGAARD_BARRACKS_RALLY_TABLE[i])
  end
  Serengaard.SerengaardTeleporterTable = {}
  for i = 1, #SERENGAARD_TELEPORTER_POS_TABLE, 1 do
    Serengaard:SpawnTeleporter(SERENGAARD_TELEPORTER_POS_TABLE[i])
  end
  Timers:CreateTimer(20, function()
    CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Intro"})
  end)
  -- Timers:CreateTimer(80, function()
  --   CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
  --   CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.BetweenWaves"})
    
  -- end)
end

function Serengaard:ZoneDisplayAndMusic()
  Timers:CreateTimer(3, function()
    if MAIN_HERO_TABLE then
      for i = 1, #MAIN_HERO_TABLE, 1 do
        local hero = MAIN_HERO_TABLE[i]
        local player = hero:GetPlayerOwner()
        CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "battle_of_serengaard"} )
      end
    end
    return 20
  end)
end

function Serengaard:GetZFLOAT()
    return 0
end

function Serengaard:LinewarIncomeFunction(timerActivate)
	Serengaard.IncomeTimer = timerActivate
  if Serengaard.wave > 2 then
    CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
    CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.WaveWin"})
    Timers:CreateTimer(14, function()
      if Serengaard.IncomeTimer > 5 then
        CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
        CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.BetweenWaves"})
      end
    end)
  end
  print("MAKE VOTE?")
  Serengaard.SkipVotes = 0
  if Beacons.cheats then
    CustomGameEventManager:Send_ServerToAllClients("serengaard_vote_skip", {playerCount = 3} )
  else
    for i = 1, #MAIN_HERO_TABLE, 1 do
      local hero = MAIN_HERO_TABLE[i]
      CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "serengaard_vote_skip", {playerCount = RPCItems:GetConnectedPlayerCount()} )
    end
  end
  
  
	Timers:CreateTimer(0, function()
		CustomGameEventManager:Send_ServerToAllClients("updateLineWarIncomeTimer", {incomeTimer = Serengaard.IncomeTimer} )
		Serengaard.IncomeTimer = Serengaard.IncomeTimer - 1
		if Serengaard.IncomeTimer < 0 then
      CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
			Serengaard:TimerEnd()
		else
      if not Serengaard.timerBlock then
			 return 1
      end
		end
	end)
end

function Serengaard:Vote(msg)
  local player = PlayerResource:GetPlayer(msg.player)
  print("SERENGAARD VOTE???")
  Serengaard.SkipVotes = Serengaard.SkipVotes + 1
  if Serengaard.SkipVotes > RPCItems:GetConnectedPlayerCount()/2 then
    Serengaard.IncomeTimer = 0
  else
    CustomGameEventManager:Send_ServerToAllClients("serengaard_update_skip_votes", {number = Serengaard.SkipVotes} )
  end
end

SERENGAARD_SPAWN_POINTS = {Vector(0, -7672), Vector(7672, 0), Vector(-288, 7636), Vector(-7636, 64)}

function Serengaard:TimerEnd()
  CustomGameEventManager:Send_ServerToAllClients("updateLineWarIncomeTimer", {incomeTimer = "-"} )
  CustomGameEventManager:Send_ServerToAllClients("serengaard_between_wave_end", {} )
	if Serengaard.wave == 0 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 40
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("dark_fighter_serengaard", SERENGAARD_SPAWN_POINTS[i], 11, 8, 1.2, false)
    end
  elseif Serengaard.wave == 5 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 50
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_antimage", SERENGAARD_SPAWN_POINTS[i], 13, 8, 1.2, false)
    end      
    Timers:CreateTimer(9, function()
      CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Wave.6_10"})
    end)
  elseif Serengaard.wave == 10 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    local spawnsPerPoint = GameState:GetDifficultyFactor() + 5
    Serengaard.waveMax = (spawnsPerPoint*8)-5
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("goremaw_brute", SERENGAARD_SPAWN_POINTS[i], spawnsPerPoint, 25, 1.2, false)
    end    
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("goremaw_shaman", SERENGAARD_SPAWN_POINTS[i], spawnsPerPoint, 25, 1.2, false)
    end  
    Timers:CreateTimer(9, function()
      CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Wave.11_20"})
    end)
  elseif Serengaard.wave == 15 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 74
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("dire_ranged", SERENGAARD_SPAWN_POINTS[i], 10, 10, 1.2, false)
    end    
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("dire_melee", SERENGAARD_SPAWN_POINTS[i], 10, 10, 1.2, false)
    end  
    Timers:CreateTimer(9, function()
      CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Wave.11_20"})
    end)
  elseif Serengaard.wave == 20 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 75
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_engima_raider", SERENGAARD_SPAWN_POINTS[i], 4, 10, 1.2, false)
    end    
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_mini_enigma", SERENGAARD_SPAWN_POINTS[i], 6, 10, 1.2, false)
    end  
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_geosidic", SERENGAARD_SPAWN_POINTS[i], 10, 10, 1.2, false)
    end  

    Timers:CreateTimer(9, function()
      StartMusic("Serengaard.Music.Wave.21_30", 110)
    end)
  elseif Serengaard.wave == 25 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 80
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_nightmare_raider", SERENGAARD_SPAWN_POINTS[i], 22, 10, 1.2, false)
    end     

    Timers:CreateTimer(9, function()
      StartMusic("Serengaard.Music.Wave.21_30", 110)
    end)
  elseif Serengaard.wave >= 30 then
    CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {} )
    Serengaard:InfiniteWave()
	end
end

function Serengaard:NextWave()
  print("WAVE!!")
  print(Serengaard.wave)
  if Serengaard.wave == 1 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 50
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_icy_venge", SERENGAARD_SPAWN_POINTS[i], 11, 9, 1.2, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_freeze_fiend", SERENGAARD_SPAWN_POINTS[i], 3, 11, 5.2, false)
    end
    CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
    CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Wave.1_5"})
  elseif Serengaard.wave == 2 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 48
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("gargoyle", SERENGAARD_SPAWN_POINTS[i], 10, 9, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_freeze_fiend", SERENGAARD_SPAWN_POINTS[i], 2, 11, 8.2, false)
    end
    StartMusic("Serengaard.Music.Wave.1_5", 70)
  elseif Serengaard.wave == 3 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 60
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("npc_dota_creature_basic_zombie_exploding", SERENGAARD_SPAWN_POINTS[i], 9, 9, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_hook_flinger", SERENGAARD_SPAWN_POINTS[i], 6, 11, 8.2, false)
    end
    StartMusic("Serengaard.Music.Wave.1_5", 70)
  elseif Serengaard.wave == 4 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 70
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("npc_dota_creature_basic_zombie_exploding", SERENGAARD_SPAWN_POINTS[i], 4, 9, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_hook_flinger", SERENGAARD_SPAWN_POINTS[i], 3, 13, 3.2, false)
    end    
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_freeze_fiend", SERENGAARD_SPAWN_POINTS[i], 3, 13, 2.2, false)
    end  
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_icy_venge", SERENGAARD_SPAWN_POINTS[i], 3, 13, 1.2, false)
    end  
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("gargoyle", SERENGAARD_SPAWN_POINTS[i], 4, 13, 1.2, false)
    end  
    StartMusic("Serengaard.Music.Wave.1_5", 70)
  elseif Serengaard.wave == 5 then
     Serengaard.waveProgress = -1
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave} )
    Serengaard:LinewarIncomeFunction(60)
  elseif Serengaard.wave == 6 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 65
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("npc_dota_creature_desert_zombie", SERENGAARD_SPAWN_POINTS[i], 8, 20, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("blood_fiend", SERENGAARD_SPAWN_POINTS[i], 5, 17, 3.2, false)
    end    
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_sand_king", SERENGAARD_SPAWN_POINTS[i], 4, 18, 3.2, false)
    end  
    StartMusic("Serengaard.Music.Wave.6_10", 80)
  elseif Serengaard.wave == 7 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 70
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_wandering_mage", SERENGAARD_SPAWN_POINTS[i], 9, 21, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("experimental_minion", SERENGAARD_SPAWN_POINTS[i], 9, 21, 1.3, false)
    end
    StartMusic("Serengaard.Music.Wave.6_10", 80)
  elseif Serengaard.wave == 8 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 60
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("desert_warlord", SERENGAARD_SPAWN_POINTS[i], 8, 24, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("tomb_stalker", SERENGAARD_SPAWN_POINTS[i], 8, 24, 1.3, false)
    end
    StartMusic("Serengaard.Music.Wave.6_10", 80)
  elseif Serengaard.wave == 9 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    local amount = math.max(GameState:GetDifficultyFactor() + 1, 3)
    Serengaard.waveMax = 26*amount
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("desert_warlord", SERENGAARD_SPAWN_POINTS[i], amount, 26, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("tomb_stalker", SERENGAARD_SPAWN_POINTS[i], amount, 26, 3.3, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("experimental_minion", SERENGAARD_SPAWN_POINTS[i], amount, 26, 3.3, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_wandering_mage", SERENGAARD_SPAWN_POINTS[i], amount, 26, 3.3, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_sand_king", SERENGAARD_SPAWN_POINTS[i], amount, 26, 3.3, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("blood_fiend", SERENGAARD_SPAWN_POINTS[i], amount, 24, 3.3, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("npc_dota_creature_desert_zombie", SERENGAARD_SPAWN_POINTS[i], 4, 24, 3.3, false)
    end
    StartMusic("Serengaard.Music.Wave.6_10", 80)
  elseif Serengaard.wave == 10 then
    if Serengaard.bossWave then
      Serengaard.waveProgress = -1
      Serengaard.bossWave = false
      CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave} )
      Serengaard:LinewarIncomeFunction(60)
    else
      CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Wave.Boss"})
      Serengaard.waveProgress = 0

      -- local neverlordCount = math.min(GameState:GetDifficultyFactor(), #SERENGAARD_SPAWN_POINTS)
      local neverlordCount = 1
      -- if GameState:GetDifficultyFactor() == 3 then
      --   neverlordCount = 2
      -- end
      Serengaard.waveMax = neverlordCount
      Serengaard.bossWave = true
      CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
      EmitGlobalSound("nevermore_nev_spawn_09")
      for i = 1, neverlordCount, 1 do
        Serengaard:SpawnBossUnit("serengaard_neverlord", SERENGAARD_SPAWN_POINTS[i], 1, 35, 0, false)
      end
    end
  elseif Serengaard.wave == 11 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 50
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("obsidian_golem", SERENGAARD_SPAWN_POINTS[i], 2, 31, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_siege_archer", SERENGAARD_SPAWN_POINTS[i], 12, 24, 1.1, false)
    end
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 12 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 80
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("mine_zombie", SERENGAARD_SPAWN_POINTS[i], 21, 31, 0.9, false)
    end
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 13 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 70
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("arabor_cultist", SERENGAARD_SPAWN_POINTS[i], 3, 33, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("hell_hound", SERENGAARD_SPAWN_POINTS[i], 3, 33, 4.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("crawler", SERENGAARD_SPAWN_POINTS[i], 12, 24, 1.1, false)
    end
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 14 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 100
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("arabor_cultist", SERENGAARD_SPAWN_POINTS[i], 2, 33, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("hell_hound", SERENGAARD_SPAWN_POINTS[i], 2, 33, 4.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("crawler", SERENGAARD_SPAWN_POINTS[i], 6, 24, 2.1, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("obsidian_golem", SERENGAARD_SPAWN_POINTS[i], 2, 31, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_siege_archer", SERENGAARD_SPAWN_POINTS[i], 6, 24, 1.4, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("goremaw_brute", SERENGAARD_SPAWN_POINTS[i], 2, 4, 1.6, false)
    end    
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("goremaw_shaman", SERENGAARD_SPAWN_POINTS[i], 2, 4, 1.6, false)
    end 
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 15 then
     Serengaard.waveProgress = -1
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave} )
    Serengaard:LinewarIncomeFunction(60)
  elseif Serengaard.wave == 16 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 75
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("warden_of_death", SERENGAARD_SPAWN_POINTS[i], 2, 48, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("shadow_hunter", SERENGAARD_SPAWN_POINTS[i], 10, 43, 1.8, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("swamp_viper", SERENGAARD_SPAWN_POINTS[i], 8, 44, 1.1, false)
    end
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 17 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 45
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("amber_spider_queen", SERENGAARD_SPAWN_POINTS[i], 4, 48, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("citre_spiderling", SERENGAARD_SPAWN_POINTS[i], 8, 48, 3.0, false)
    end
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 18 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 78
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("spectral_assassin", SERENGAARD_SPAWN_POINTS[i], 8, 50, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("conjured_tide", SERENGAARD_SPAWN_POINTS[i], 8, 52, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("betrayer_of_time", SERENGAARD_SPAWN_POINTS[i], 4, 54, 3.0, false)
    end
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 19 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 100
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("spectral_assassin", SERENGAARD_SPAWN_POINTS[i], 4, 51, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("conjured_tide", SERENGAARD_SPAWN_POINTS[i], 3, 51, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("betrayer_of_time", SERENGAARD_SPAWN_POINTS[i], 2, 51, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("amber_spider_queen", SERENGAARD_SPAWN_POINTS[i], 2, 51, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("citre_spiderling", SERENGAARD_SPAWN_POINTS[i], 4, 51, 3.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("warden_of_death", SERENGAARD_SPAWN_POINTS[i], 3, 51, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("shadow_hunter", SERENGAARD_SPAWN_POINTS[i], 3, 51, 1.8, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("swamp_viper", SERENGAARD_SPAWN_POINTS[i], 4, 46, 1.1, false)
    end
    StartMusic("Serengaard.Music.Wave.11_20", 80)
  elseif Serengaard.wave == 20 then
    if Serengaard.bossWave then
      Serengaard.waveProgress = -1
      Serengaard.bossWave = false
      CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave} )
      if GameState:GetDifficultyFactor() == 1 then
        CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Win"})
        Notifications:TopToAll({text="serengaard_normal_complete", duration=10.0})
      else
        Serengaard:LinewarIncomeFunction(60)
      end
      for i = 1, #MAIN_HERO_TABLE, 1 do
        Stars:StarEventPlayer("serengaard", MAIN_HERO_TABLE[i])
      end
    else
      CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Wave.Boss"})
      Serengaard.waveProgress = 0
      local neverlordCount = 1
      Serengaard.waveMax = neverlordCount
      Serengaard.bossWave = true
      CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
      EmitGlobalSound("razor_raz_spawn_07")
      for i = 1, neverlordCount, 1 do
        Serengaard:SpawnBossUnit("serengaard_baron_razor", SERENGAARD_SPAWN_POINTS[i], 1, 35, 0, false)
      end
    end
  elseif Serengaard.wave == 21 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 65
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_snowball_thrower", SERENGAARD_SPAWN_POINTS[i], 7, 48, 3.1, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_ice_shard_thrower", SERENGAARD_SPAWN_POINTS[i], 10, 48, 2.4, false)
    end
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 22 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 80
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_gazbin_mercenary", SERENGAARD_SPAWN_POINTS[i], 15, 48, 1, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_shredder_max", SERENGAARD_SPAWN_POINTS[i], 4, 48, 6.0, false)
    end
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 23 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 56
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("wraithguard", SERENGAARD_SPAWN_POINTS[i], 1, 60, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("wraithguard_elite", SERENGAARD_SPAWN_POINTS[i], 3, 62, 9.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("castle_skeleton_archer", SERENGAARD_SPAWN_POINTS[i], 11, 64, 1.5, false)
    end
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 24 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 100
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("wraithguard", SERENGAARD_SPAWN_POINTS[i], 1, 60, 5.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("wraithguard_elite", SERENGAARD_SPAWN_POINTS[i], 2, 62, 4.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("castle_skeleton_archer", SERENGAARD_SPAWN_POINTS[i], 4, 54, 2.5, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_gazbin_mercenary", SERENGAARD_SPAWN_POINTS[i], 2, 58, 1.9, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_shredder_max", SERENGAARD_SPAWN_POINTS[i], 1, 58, 4.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_snowball_thrower", SERENGAARD_SPAWN_POINTS[i], 3, 58, 3.1, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_ice_shard_thrower", SERENGAARD_SPAWN_POINTS[i], 3, 58, 4.4, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_engima_raider", SERENGAARD_SPAWN_POINTS[i], 2, 10, 3.2, false)
    end    
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_mini_enigma", SERENGAARD_SPAWN_POINTS[i], 2, 10, 3.2, false)
    end  
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_geosidic", SERENGAARD_SPAWN_POINTS[i], 5, 10, 3.2, false)
    end  
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 25 then
     Serengaard.waveProgress = -1
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave} )
    Serengaard:LinewarIncomeFunction(60)
  elseif Serengaard.wave == 26 then
    EmitGlobalSound("Hero_Nightstalker.Darkness")
    GameRules:BeginNightstalkerNight(60)
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 70
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_night_invader", SERENGAARD_SPAWN_POINTS[i], 20, 60, 1.0, false)
    end
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 27 then
    Dungeons.phoenixEggLocation = Vector(0,0,0)
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 70
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_siege_dragon", SERENGAARD_SPAWN_POINTS[i], 6, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_hunter", SERENGAARD_SPAWN_POINTS[i], 6, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_assassin", SERENGAARD_SPAWN_POINTS[i], 6, 60, 1.0, false)
    end
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 28 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 52
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_siege_lich", SERENGAARD_SPAWN_POINTS[i], 13, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_siege_lich_boss", SERENGAARD_SPAWN_POINTS[i], 1, 60, 1.0, false)
    end
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 29 then
    Serengaard.wave = Serengaard.wave + 1
    Serengaard.waveProgress = 0
    Serengaard.waveMax = 100
    Dungeons.phoenixEggLocation = Vector(0,0,0)
    CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_siege_lich", SERENGAARD_SPAWN_POINTS[i], 4, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_siege_dragon", SERENGAARD_SPAWN_POINTS[i], 4, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_hunter", SERENGAARD_SPAWN_POINTS[i], 4, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_assassin", SERENGAARD_SPAWN_POINTS[i], 4, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_night_invader", SERENGAARD_SPAWN_POINTS[i], 4, 60, 1.0, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("serengaard_nightmare_raider", SERENGAARD_SPAWN_POINTS[i], 5, 10, 1.2, false)
    end
    for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
      Serengaard:SpawnWaveUnit("phoenix_executioner", SERENGAARD_SPAWN_POINTS[i], 2, 10, 1.2, false)
    end
    StartMusic("Serengaard.Music.Wave.21_30", 110)
  elseif Serengaard.wave == 30 then
    if Serengaard.bossWave then
      Serengaard.waveProgress = -1
      Serengaard.bossWave = false
      CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave} )
      if GameState:GetDifficultyFactor() <= 2 then
        CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Win"})
        Notifications:TopToAll({text="serengaard_elite_complete", duration=10.0})
      else
        Serengaard:LinewarIncomeFunction(60)
      end
      for i = 1, #MAIN_HERO_TABLE, 1 do
        Stars:StarEventPlayer("serengaard", MAIN_HERO_TABLE[i])
      end
      Serengaard.wave = Serengaard.wave + 1

    else
      CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Wave.Boss"})
      Serengaard.waveProgress = 0
      local neverlordCount = 1
      Serengaard.waveMax = neverlordCount
      Serengaard.bossWave = true
      CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave} )
      -- EmitGlobalSound("razor_raz_spawn_07")
      for i = 1, neverlordCount, 1 do
        Serengaard:SpawnBossUnit("serengaard_final_boss", SERENGAARD_SPAWN_POINTS[RandomInt(1,#SERENGAARD_SPAWN_POINTS)], 1, 35, 0, false)
      end
    end
  elseif Serengaard.wave > 30 then
    if Serengaard.InfiniteWaveCount then
      if Serengaard.InfiniteWaveCount%5 == 0 then
        Serengaard:LinewarIncomeFunction(60)
        if Serengaard.InfiniteWaveCount%10 == 0 then
          local mithril = 140 + math.min(Serengaard.InfiniteWaveCount*10, 500)
          Serengaard:Mithril("infinite", Serengaard.mainAncient:GetAbsOrigin(), mithril)
          for i = 1, #MAIN_HERO_TABLE, 1 do
            Stars:StarEventPlayer("serengaard_infinite", MAIN_HERO_TABLE[i])
          end
        end
        if Serengaard.InfiniteWaveCount%30 == 0 then
          Timers:CreateTimer(2, function()
            for i = 1, #MAIN_HERO_TABLE, 1 do
              Serengaard:GiveSunstone(MAIN_HERO_TABLE[i], Serengaard.mainAncient:GetAbsOrigin())
            end
          end)
        end
      else
        Serengaard:InfiniteWave()
      end
    else
      Serengaard:InfiniteWave()
    end
  end
end

INFINITE_UNIT_TABLE = {"dark_fighter_serengaard", "serengaard_freeze_fiend", "serengaard_icy_venge", "gargoyle", "npc_dota_creature_basic_zombie_exploding", "serengaard_hook_flinger",  "serengaard_antimage", "blood_fiend", "serengaard_sand_king", "serengaard_wandering_mage", "experimental_minion", "desert_warlord", "tomb_stalker", "goremaw_brute", "goremaw_shaman", "obsidian_golem", "serengaard_siege_archer", "arabor_cultist", "hell_hound", "crawler", "dire_ranged", "dire_melee", "shadow_hunter", "warden_of_death", "swamp_viper", "amber_spider_queen", "amber_spiderling", "citre_spiderling", "spectral_assassin", "conjured_tide", "betrayer_of_time", "serengaard_engima_raider", "serengaard_mini_enigma", "serengaard_geosidic", "serengaard_snowball_thrower", "serengaard_ice_shard_thrower", "serengaard_shredder_max", "serengaard_gazbin_mercenary", "wraithguard", "wraithguard_elite", "castle_skeleton_archer", "serengaard_nightmare_raider", "serengaard_night_invader", "phoenix_assassin", "phoenix_siege_lich", "phoenix_siege_lich_boss", "phoenix_electron_raider", "phoenix_hunter", "phoenix_executioner", "phoenix_siege_dragon",
"redfall_dragonkin", "redfall_crimsyth_hell_bandit", "redfall_autumn_monster", "crimsyth_bombadier", "redfall_snarlroot_treant", "redfall_crimsyth_thug", "redfall_castle_archer", "nibohg", "redfall_crimsyth_hawk_soldier", "redfall_crimsyth_hawk_soldier_elite", "redfall_crimsyth_shadow", "redfall_castle_warflayer", "redfall_lava_lizard", "redfall_crimsyth_gunman", "redfall_crimsyth_gunman_elite", "redfall_crimsyth_khan_knight", "redfall_enclave_viking", "redfall_crimsyth_torture_puppet", "redfall_crimsyth_corrupted_corpse", "redfall_tortured_soul", "redfall_crimson_samurai", "redfall_crimson_warrior", "redfall_crimson_shadow_dancer", "redfall_crimsyth_crystal_hoarder", "redfall_crystal_shifter", "redfall_crimsyth_mage", "redfall_crimsyth_mage_elite", "redfall_soul_scar", "arena_conquest_ruins_guardian", "redfall_crimsyth_grunt", "crimsyth_raging_shaman", "crimsyth_fortune_seeker", "redfall_crimsyth_castle_grounds_guardian", "redfall_crimsyth_guard", "redfall_crimsyth_berserker", "redfall_castle_garden_watcher", "iron_spine", "redfall_castle_dweller", "redfall_castle_demented_shaman", "redfall_castle_avian_purifier", "redfall_crimsyth_demon_knight", "redfall_demonic_follower",
"redfall_shipyard_crimsyth_blood_hunter", "redfall_shipyard_demon_wolf", "redfall_shipyard_blood_wolf", "shipyard_skeleton_archer", "redfall_shipyard_void", "redfall_shipyard_haunt_knight", "shipyard_zombie_warrior", "shipyard_ghost_fish", "shipyard_pirate_archer", "redfall_shipyard_cargo_watcher", "redfall_shipyard_pirate_gnoll", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_knight",
"redfall_farmlands_bandit", "redfall_farmlands_thief", "redfall_harvest_wraith", "redfall_farmlands_flame_panda", "redfall_farmlands_corn_harvester", "redfall_twisted_pumpkin", "redfall_chibi_bear", "redfall_crymsith_duelist", "redfall_crimsyth_bandit", "redfall_crimsyth_recruiter",
"redfall_autumn_enforcer", "redfall_autumn_tyrant", "redfall_pan_knight", "redfall_canyon_alpha_beast", "redfall_canyon_breaker", "redfall_canyon_predator", "redfall_armored_crab_beast", "redfall_canyon_bull", "redfall_canyon_grizzly_patriarch", "redfall_mist_knight", "redfall_autumn_mage", "redfall_troll_warlord", "redfall_mist_assassin", "water_temple_vault_lord_two",
"redfall_shroomling", "redfall_wozxak", "redfall_forest_summoner", "redfall_crimsyth_cultist", "redfall_forest_minion", "redfall_forest_wood_dweller", "redfall_forest_overgrowth", "redfall_disciple_of_maru", "redfall_autumn_spirit", "redfall_forest_gnome", "redfall_cliff_weed", "redfall_cliff_invader_range", "redfall_cliff_invader", "redfall_stone_watcher", "redfall_hooded_soul_reacher", "redfall_ash_snake", "redfall_ashfall_knight", "redfall_redfall_vulture", "redfall_autumn_cragnataur",
"fire_temple_blackguard", "blackguard_cultist", "fire_temple_blackguard_doombringer", "fire_temple_molten_war_knight", "fire_temple_lost_shadow_of_davion", "fire_temple_passage_skeleton", "fire_temple_relic_seeker", "fire_temple_secret_fanatic", "fire_temple_tempered_warrior", "fire_temple_sky_guardian", "fire_temple_dimension_seeker", "fire_temple_fireling", "fire_temple_skeleton_archer", "fire_temple_final_wave_mob", "fire_temple_fire_mage", "fire_temple_lava_caller", "fire_temple_protective_spirit", "fire_temple_flame_wraith", "fire_temple_flame_wraith_lord",
"tanari_water_bug", "swamp_razorfish", "swamp_razorfish_captain", "swamp_razorfish_irritable", "water_temple_shark", "water_temple_aqua_mage", "water_temple_beach_hermit", "water_temple_prison_guard", "water_temple_executioner", "water_temple_faceless_water_elemental", "water_temple_blue_warlock", "water_temple_vault_master", "water_temple_serpent_sleeper", "water_temple_armored_water_beetle", "water_temple_blinded_serpent_warrior", "water_temple_fairy_dragon",
"terrasic_volcanic_legion", "terrasic_awakened_stone", "terrasic_red_mist_soldier", "terrasic_goremaw_flame_splitter", "terrasic_red_guard", "terrasic_captain_reimus", "molten_entity", "volcanic_ash", "terrasic_red_warlock", "terrasic_red_mist_conqueror", "terrasic_red_mist_brute", "terrasic_captain_clayborne",
"tanari_thicket_ursa", "tanari_primitive_hunter", "tanari_thicket_priest", "tanari_thicket_high_priest", "blighted_sapling", "tanari_wild_troll", "tanari_thicket_bat", "tanari_thicket_matriarch", "wind_temple_emerald_spider", "wind_temple_venom_spider", "wind_temple_gardener", "wind_temple_wind_maiden", "wind_temple_descendant_of_zeus", "water_temple_stone_priestess", "water_manifestation"}

PIT_MOBS = {"arena_boss_spectre_summon", "champion_gladiator", "arena_pit_quizmaster", "arena_pit_soul_revenant", "arena_pit_conquest_mire_keeper", "arena_pit_conquest_mountain_behemoth", "arena_pit_conquest_cragnataur", "arena_pit_conquest_mountain_spider", "arena_pit_conquest_spider", "arena_pit_conquest_priest_of_karzhun", "arena_pit_conquest_helob", "arena_conquest_ruins_guardian", "arena_pit_conquest_temple_explorer", "arena_conquest_temple_witch_doctor", "arena_conquest_temple_repeller", "arena_conquest_skeletal_mage", "arena_conquest_temple_shifter", "pit_conquest_dragon", "arena_pit_conquest_mire_boss", "pit_conquest_forest_soldier", "pit_conquest_woods_titan", "pit_conquest_forest_mage", "arena_lies_castle_light_absorber", "arena_lies_spark_beetle", "arena_lies_lich", "arena_lies_samurai", "lies_golden_skullbone", "lies_trickster_mage", "tanari_angry_fish", "arena_lies_castle_enigma", "arena_lies_razor_miniboss", "arena_descent_exiled_spirit", "arena_descent_passage_keeper", "arena_descent_horror_construct", "arena_descent_death_seeker", "arena_descent_zombie", "arena_descent_terror_striker", "arena_descent_gargoyle", "arena_descent_goo_beetle", "arena_descent_zombie_critter", "arena_descent_razor_guard"}

function Serengaard:InfiniteWave()
  print("SPAWN INFINITE WAVE!")
  if Serengaard.gameOver then
    return false
  end
  StartMusic("Serengaard.Music.InfiniteWaves", 50)
  CustomGameEventManager:Send_ServerToAllClients("serengaardInfiniteWaves", {} )
  if not Serengaard.InfiniteWaveCount then
    Serengaard.InfiniteWaveCount = 0
  end
  if Serengaard.InfiniteWaveCount == 20 then
    for i = 1, #PIT_MOBS, 1 do
      table.insert(INFINITE_UNIT_TABLE, PIT_MOBS[i])
    end
  end
  Serengaard.InfiniteWaveCount = Serengaard.InfiniteWaveCount + 1

  Serengaard.waveProgress = 0
  Serengaard.waveMax = 80
  if Serengaard.InfiniteWaveCount == 1 then
    Serengaard.waveMax = 70
  end
  CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = "I-"..Serengaard.InfiniteWaveCount} )
  local unit1 = INFINITE_UNIT_TABLE[RandomInt(1, #INFINITE_UNIT_TABLE)]
  local unit2 = INFINITE_UNIT_TABLE[RandomInt(1, #INFINITE_UNIT_TABLE)]
  local unit3 = INFINITE_UNIT_TABLE[RandomInt(1, #INFINITE_UNIT_TABLE)]
  local unit4 = INFINITE_UNIT_TABLE[RandomInt(1, #INFINITE_UNIT_TABLE)]
  for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
    Serengaard:SpawnWaveUnit(unit1, SERENGAARD_SPAWN_POINTS[i], 5, 60, 2.4, false)
  end
  for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
    Serengaard:SpawnWaveUnit(unit2, SERENGAARD_SPAWN_POINTS[i], 5, 60, 2.4, false)
  end
  for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
    Serengaard:SpawnWaveUnit(unit3, SERENGAARD_SPAWN_POINTS[i], 5, 60, 2.4, false)
  end
  for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
    Serengaard:SpawnWaveUnit(unit4, SERENGAARD_SPAWN_POINTS[i], 5, 60, 2.4, false)
  end

end


function StartMusic(songName, songDelay)
  if not Serengaard.musicTime then
    Serengaard.musicTime = 0
  end
  if (GameRules:GetGameTime() - songDelay) > Serengaard.musicTime then
    Serengaard.musicTime = GameRules:GetGameTime()
    CustomGameEventManager:Send_ServerToAllClients("BGMend", {})
    CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = songName})
  end
end

function Serengaard:AdjustSpawnPoint(spawnPoint)
  local random = RandomInt(1, 4)
  -- SERENGAARD_SPAWN_POINTS = {Vector(0, -7672), Vector(7672, 0), Vector(-288, 7636), Vector(-7636, 64)}
  if WallPhysics:GetDistance2d(SERENGAARD_SPAWN_POINTS[1], spawnPoint) < 200 then
    if random == 1 then
      spawnPoint = spawnPoint+Vector(0,600)
    elseif random == 2 then
      spawnPoint = spawnPoint+Vector(-600,0)
    elseif random == 3 then
      spawnPoint = spawnPoint+Vector(600,0)
    end
  elseif WallPhysics:GetDistance2d(SERENGAARD_SPAWN_POINTS[2], spawnPoint) < 200 then
    if random == 1 then
      spawnPoint = spawnPoint+Vector(0,600)
    elseif random == 2 then
      spawnPoint = spawnPoint+Vector(0,-600)
    elseif random == 3 then
      spawnPoint = spawnPoint+Vector(-600,0)
    end
  elseif WallPhysics:GetDistance2d(SERENGAARD_SPAWN_POINTS[3], spawnPoint) < 200 then
    if random == 1 then
      spawnPoint = spawnPoint+Vector(600,0)
    elseif random == 2 then
      spawnPoint = spawnPoint+Vector(0,-600)
    elseif random == 3 then
      spawnPoint = spawnPoint+Vector(-600,0)
    end
  elseif WallPhysics:GetDistance2d(SERENGAARD_SPAWN_POINTS[4], spawnPoint) < 200 then
    if random == 1 then
      spawnPoint = spawnPoint+Vector(600,0)
    elseif random == 2 then
      spawnPoint = spawnPoint+Vector(0,600)
    elseif random == 3 then
      spawnPoint = spawnPoint+Vector(0,-600)
    end
  end
  return spawnPoint
end

function Serengaard:SpawnWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)
  local baseSpawnPos = spawnPoint
  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    spawnPoint = Serengaard:AdjustSpawnPoint(baseSpawnPos)
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CastleSpawner.Spawn", Redfall.RedfallMaster)
    end
    local maxLuck = 120
    if Serengaard.InfiniteWaveCount then
      maxLuck = math.max(120-Serengaard.InfiniteWaveCount, 85)
    end
      local luck = RandomInt(1, maxLuck)
      if luck == 1 then
        unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)  
        
      end
      if IsValidEntity(unit) then
        unit.dominion = true
        unit.itemLevel = itemLevel
        Serengaard:AdjustUnit(unit)
      else
        for i = 1, #unit, 1 do
          unit[i].dominion = true
          unit[i].itemLevel = itemLevel
          Serengaard:AdjustUnit(unit[i])
        end
      end
    end)
  end
end

function Serengaard:SpawnBossUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)  
        -- Events:AdjustDeathXP(unit) 
        local adjustFactor = math.ceil(Serengaard.wave/4)
        
        Serengaard:AdjustUnit(unit)
        Events:AdjustBossPower(unit, adjustFactor, adjustFactor, false)
        unit.serengaardBoss = true
    end)
  end
end

function Serengaard:AdjustUnit(unit)
  Serengaard.SerengaardMasterAbility:ApplyDataDrivenModifier(Serengaard.SerengaardMaster, unit, "modifier_serengaard_wave_unit", {})
  Serengaard.SerengaardMasterAbility:ApplyDataDrivenModifier(Serengaard.SerengaardMaster, unit, "modifier_serengaard_unit_spawned", {duration = 3})
  unit.aggro = true
  unit:SetAcquisitionRange(6000)
  Timers:CreateTimer(0.1, function()
    unit:MoveToPositionAggressive(Vector(0,0))
  end)
  unit.targetRadius = 800
  unit.minRadius = 0
  unit.targetAbilityCD = 1
  unit.targetFindOrder = FIND_ANY_ORDER
  unit.autoAbilityCD = 1

  Events:AdjustDeathXP(unit)
  if GameState:GetDifficultyFactor() == 3 then
    newHealth = unit:GetMaxHealth()*(1 + Serengaard.wave*0.1)
    newHealth = math.min(newHealth, (2^30)-10)
    unit:SetMaxHealth(newHealth)
    unit:SetBaseMaxHealth(newHealth)
    unit:SetHealth(newHealth)
    unit:Heal(newHealth, unit)
  end
  if unit:HasAbility("redfall_mega_steadfast") then
    unit:RemoveAbility("redfall_mega_steadfast")
    unit:RemoveModifierByName("modifier_mega_steadfast")
    unit:AddAbility("fire_temple_steadfast")
  end
  if unit:GetUnitName() == "serengaard_hook_flinger" then
    unit.targetRadius = 1200
  elseif unit:GetUnitName() == "serengaard_icy_venge" then
    unit.targetRadius = 800
  elseif unit:GetUnitName() == "npc_dota_creature_basic_zombie_exploding" or unit:GetUnitName() == "npc_dota_creature_desert_zombie" then
    Serengaard.SerengaardMasterAbility:ApplyDataDrivenModifier(Serengaard.SerengaardMaster, unit, "modifier_serengaard_charge", {duration = 6}) 
  elseif unit:GetUnitName() ==  "serengaard_antimage" then
    unit.targetRadius = 1000
    unit.autoAbilityCD = 5
    unit.targetAbilityCD = 5
  elseif unit:GetUnitName() == "tomb_stalker" then
    if GameState:GetDifficultyFactor() == 1 then
      unit:SetBaseDamageMin(2000)
      unit:SetBaseDamageMax(2000)
    end
  elseif unit:GetUnitName() == "serengaard_neverlord" then
    unit.dominion = false
  elseif unit:GetUnitName() == "mine_zombie" then
    local modifierTable = {"zombie_blue", "zombie_green", "zombie_red"}
    Serengaard.SerengaardMasterAbility:ApplyDataDrivenModifier(Serengaard.SerengaardMaster, unit, "modifier_serengaard_charge", {duration = 7}) 
    local ability = unit:FindAbilityByName("zombie_colors")
    ability:ApplyDataDrivenModifier(unit, unit, modifierTable[RandomInt(1, #modifierTable)], {})
  elseif unit:GetUnitName() == "serengaard_night_invader" then
    unit:SetRenderColor(40, 40, 40)
    Events:ColorWearables(unit, Vector(40,40,40))
  elseif unit:GetUnitName() == "crimsyth_fortune_seeker" then
    unit:AddNewModifier(unit, nil, "modifier_animation", {translate="attack_normal_range"})
    unit:AddNewModifier(unit, nil, "modifier_animation_translate", {translate="run"})
  elseif unit:GetUnitName() == "fire_temple_protective_spirit" then
    unit.modelScale = 0.95
  elseif unit:GetUnitName() == "phoenix_siege_dragon" then
    Dungeons.phoenixEggLocation = Vector(0,0,0)
  end

  if GameState:GetDifficultyFactor() > 1 then
    local bountyXP = math.ceil(unit:GetDeathXP()/2)
    unit:SetDeathXP(bountyXP)
  end
  if Serengaard.InfiniteWaveCount then
    local bountyXP = math.ceil(unit:GetDeathXP()+unit:GetDeathXP()*0.1*Serengaard.InfiniteWaveCount)
    unit:SetDeathXP(bountyXP)
    unit:SetRenderColor(120, 120, 120)
    Events:ColorWearables(unit, Vector(120,120,120))
    Events:AdjustBossPower(unit, Serengaard.InfiniteWaveCount, Serengaard.InfiniteWaveCount, false)
    unit.itemLevel = 80 + Serengaard.InfiniteWaveCount*3
  end
end

SERENGAARD_TOWER_LOCATIONS1 = {Vector(-3456, 896), Vector(-3456, -600), Vector(-640, -3904), Vector(575, -3904), Vector(3392, -640), Vector(3392, 887), Vector(448, 4032), Vector(-950, 4032)}
SERENGAARD_TOWER_LOCATIONS2 = {Vector(448, 2240), Vector(-800, 2240), Vector(-1920, 1024), Vector(-1920, -681), Vector(-832, -1856), Vector(657, -1856), Vector(1600, -640), Vector(1600, 1234)}
SERENGAARD_FV_TABLE1 = {Vector(-1,0), Vector(-1,0), Vector(0,-1), Vector(0,-1), Vector(1,0), Vector(1,0), Vector(0,1), Vector(0,1)}
SERENGAARD_FV_TABLE2 = {Vector(0,1), Vector(0,1), Vector(-1,0), Vector(-1,0), Vector(0,-1), Vector(0,-1), Vector(1,0), Vector(1,0)}

SERENGAARD_RANGER_POS_TABLE = {Vector(1587, -4453), Vector(2602, -4453), Vector(3609, -4454), Vector(3812, -3092), Vector(3812, -1253), Vector(3812, 1728), Vector(3812, 3635), Vector(3812, 4700), Vector(2248, 4700), Vector(797, 4700), Vector(-1792, 4700), Vector(-2900, 4700), Vector(-4096, 4700), Vector(-4096, 3482), Vector(-4096, 1933), Vector(-4096, -1536), Vector(-4096, -3323), Vector(-4020, -4498), Vector(-2828, -4498), Vector(-1528, -4498)}

SERENGAARD_SUN_GUARD_POS_TABLE = {Vector(-64, -576), Vector(-64, 1195), Vector(762, 248), Vector(-923, 248)}

SERENGAARD_BARRACKS_POS_TABLE = {Vector(-64, -1792), Vector(-64, 2241), Vector(1628, 263), Vector(-1796, 263)}
SERENGAARD_BARRACKS_RALLY_TABLE = {Vector(22, -4160), Vector(-286, 4032), Vector(3456, 137), Vector(-3825, 137)}

SERENGAARD_TELEPORTER_POS_TABLE = {Vector(-64, -3136), Vector(2641, 155), Vector(-288, 3361), Vector(-3117, 136)}

function Serengaard:SpawnTower(position, fv)
  local tower = CreateUnitByName("rpc_serengaard_tower", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
  tower:SetForwardVector(fv)
  Events:AdjustDeathXP(tower)
  tower.startPosition = tower:GetAbsOrigin()
  table.insert(Serengaard.SerengaardTowerTable, tower)
  return tower
end

function Serengaard:SpawnRanger(position)
  local tower = CreateUnitByName("serengaard_ranger", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
  local fv = position:Normalized()
  tower:SetForwardVector(fv)
  tower.spawnPoint = position
  Events:AdjustDeathXP(tower)
  table.insert(Serengaard.SerengaardRangerTable, tower)
  return tower
end

function Serengaard:AncientGuardian(position)
  local tower = CreateUnitByName("serengaard_ancient_guardian", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
  local fv = position:Normalized()
  tower:SetForwardVector(fv)
  tower.startPosition = tower:GetAbsOrigin()
  Events:AdjustDeathXP(tower)
  table.insert(Serengaard.SerengaardGuardianTable, tower)
  return tower
end

function Serengaard:Barracks(position, rallyPoint)
  local tower = CreateUnitByName("rpc_serengaard_barracks", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
  local fv = Vector(1,0)
  tower:SetForwardVector(fv)
  Events:AdjustDeathXP(tower)
  tower.rallyPoint = rallyPoint
  tower.startPosition = tower:GetAbsOrigin()
  table.insert(Serengaard.SerengaardBarracksTable, tower)
  return tower
end

function Serengaard:SpawnTeleporter(position)
  local tower = CreateUnitByName("rpc_serengaard_teleporter", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
  local fv = position:Normalized()
  tower:SetForwardVector(fv)
  Events:AdjustDeathXP(tower)
  tower.startPosition = tower:GetAbsOrigin()
  table.insert(Serengaard.SerengaardTeleporterTable, tower)
  return tower
end

function Serengaard:UpdateTowers()
  for i = 1, #Serengaard.SerengaardBarracksTable, 1 do
    if IsValidEntity(Serengaard.SerengaardBarracksTable[i]) then
      local tower = Serengaard.SerengaardBarracksTable[i]
      if tower:IsAlive() then
        local hpPercentage = tower:GetHealth()/tower:GetMaxHealth()
        local armor = math.floor(tower:GetPhysicalArmorBaseValue()*(1.05))
        local attackDamage = math.floor(tower:GetAttackDamage()*(1.05))
        local hp = math.floor(tower:GetMaxHealth()*(1.05))
        hp = math.min(hp, 2^28)
        tower:SetMaxHealth(hp)
        tower:SetBaseMaxHealth(hp)
        tower:SetHealth(hp*hpPercentage)

        tower:SetPhysicalArmorBaseValue(armor)
        tower:SetBaseDamageMin(attackDamage)
        tower:SetBaseDamageMax(attackDamage) 
      end
    end
  end
  for i = 1, #Serengaard.SerengaardTeleporterTable, 1 do
    if IsValidEntity(Serengaard.SerengaardTeleporterTable[i]) then
      local tower = Serengaard.SerengaardTeleporterTable[i]
      if tower:IsAlive() then
        local hpPercentage = tower:GetHealth()/tower:GetMaxHealth()
        local armor = math.floor(tower:GetPhysicalArmorBaseValue()*(1.05))
        local attackDamage = math.floor(tower:GetAttackDamage()*(1.05))
        local hp = math.floor(tower:GetMaxHealth()*(1.05))
        hp = math.min(hp, 2^28)
        tower:SetMaxHealth(hp)
        tower:SetBaseMaxHealth(hp)
        tower:SetHealth(hp*hpPercentage)

        tower:SetPhysicalArmorBaseValue(armor)
        tower:SetBaseDamageMin(attackDamage)
        tower:SetBaseDamageMax(attackDamage) 
      end
    end
  end
  for i = 1, #Serengaard.SerengaardGuardianTable, 1 do
    if IsValidEntity(Serengaard.SerengaardGuardianTable[i]) then
      local tower = Serengaard.SerengaardGuardianTable[i]
      if tower:IsAlive() then
        local hpPercentage = tower:GetHealth()/tower:GetMaxHealth()
        local armor = math.floor(tower:GetPhysicalArmorBaseValue()*(1.05))
        local attackDamage = math.floor(tower:GetAttackDamage()*(1.05))
        local hp = math.floor(tower:GetMaxHealth()*(1.05))
        hp = math.min(hp, 2^28)
        tower:SetMaxHealth(hp)
        tower:SetBaseMaxHealth(hp)
        tower:SetHealth(hp*hpPercentage)

        tower:SetPhysicalArmorBaseValue(armor)
        tower:SetBaseDamageMin(attackDamage)
        tower:SetBaseDamageMax(attackDamage) 
      end      
    end
  end
  for i = 1, #Serengaard.SerengaardTowerTable, 1 do
    if IsValidEntity(Serengaard.SerengaardTowerTable[i]) then
      local tower = Serengaard.SerengaardTowerTable[i]
      if tower:IsAlive() then
        local hpPercentage = tower:GetHealth()/tower:GetMaxHealth()
        local armor = math.floor(tower:GetPhysicalArmorBaseValue()*(1.05))
        local attackDamage = math.floor(tower:GetAttackDamage()*(1.05))
        local hp = math.floor(tower:GetMaxHealth()*(1.05))
        hp = math.min(hp, 2^28)
        tower:SetMaxHealth(hp)
        tower:SetBaseMaxHealth(hp)
        tower:SetHealth(hp*hpPercentage)

        tower:SetPhysicalArmorBaseValue(armor)
        tower:SetBaseDamageMin(attackDamage)
        tower:SetBaseDamageMax(attackDamage) 
      end      
    end
  end
  if IsValidEntity(Serengaard.mainAncient) then
      local tower = Serengaard.mainAncient
      if tower:IsAlive() then
        local hpPercentage = tower:GetHealth()/tower:GetMaxHealth()
        local armor = math.min(math.floor(tower:GetPhysicalArmorBaseValue()*(1.05)), 8000)
        local attackDamage = math.floor(tower:GetAttackDamage()*(1.05))
        local hp = math.floor(tower:GetMaxHealth()*(1.05))
        hp = math.min(hp, 2^28)
        tower:SetMaxHealth(hp)
        tower:SetBaseMaxHealth(hp)
        tower:SetHealth(hp*hpPercentage)

        tower:SetPhysicalArmorBaseValue(armor)
        tower:SetBaseDamageMin(attackDamage)
        tower:SetBaseDamageMax(attackDamage) 
      end 
  end
end

function Serengaard:GiveSunstone(hero, position)
    local itemName = "item_serengaard_sunstone"
    local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
    EmitSoundOn("Resource.MithrilShardEnter", hero)
    Events:CreateCollectionBeam(position, hero:GetAbsOrigin())
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", hero, 0.5)
    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
end

function Serengaard:Url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str  
end

function Serengaard:CachePlayers()
  if not Serengaard.CachedPlayers then
    Serengaard.CachedPlayers = {}
  end
  if #Serengaard.CachedPlayers ~= 4 then--skip if already 4 players cached
    for i, v in pairs(MAIN_HERO_TABLE) do
      if MAIN_HERO_TABLE[i]:GetPlayerOwner() and MAIN_HERO_TABLE[i]:GetPlayerOwnerID() then
        local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
        if PlayerResource:GetSelectedHeroName(playerID) and PlayerResource:GetSteamAccountID(playerID) and PlayerResource:GetPlayerName(playerID) and PlayerResource:GetSteamID(playerID) then--this should return nil when player dc
          local actuallyContains = false    
          for o, b in pairs(Serengaard.CachedPlayers) do--checking unique element
              if b[2] ~= nil and b[2] == PlayerResource:GetSteamAccountID(playerID) then--[2] and element is GetSteamAccountID
                  actuallyContains = true
              end
          end
          
          if not actuallyContains then
              Serengaard.CachedPlayers[i] = { Serengaard:Url_encode(PlayerResource:GetSelectedHeroName(playerID)), PlayerResource:GetSteamAccountID(playerID), Serengaard:Url_encode(PlayerResource:GetPlayerName(playerID)), tostring(PlayerResource:GetSteamID(playerID))}
          end
        end  
      end  
    end
  end
end

function Serengaard:SubmitStats()
  local url = ""
  for i, v in pairs(Serengaard.CachedPlayers) do
    print("Players: "..i.." "..v[1].." "..v[2].." "..v[3].." "..v[4])  
  end   
  if Serengaard.InfiniteWaveCount and SaveLoad:GetAllowSaving() then
    url = ROSHPIT_URL.."/champions/save_serengaard?"
    url = url.."wave_number="..Serengaard.InfiniteWaveCount
    url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
    SaveLoad:NewKey()
    for i = 1, #Serengaard.CachedPlayers, 1 do
      -- local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
      local heroName = Serengaard.CachedPlayers[i][1]
      local steamID = Serengaard.CachedPlayers[i][2]
      local playerName = Serengaard.CachedPlayers[i][3]
      local steamIDlong = Serengaard.CachedPlayers[i][4]
      print(steamIDlong)
      url = url.."&steam_id"..i.."="..steamID
      url = url.."&hero"..i.."="..heroName
      url = url.."&steam_name"..i.."="..playerName
      url = url.."&steam_id_long"..i.."="..steamIDlong
      print("serengaard urlWaves: "..url)
      CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
        print( "POST".." response infWaves:" )
        if result.StatusCode then 
          print(result.StatusCode)
        end
      end )
    end
  end
  Timers:CreateTimer(5, function()
    url = ROSHPIT_URL.."/champions/get_serengaard?"
    print("serengaard url: "..url)
    CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
      print( "GET".." response stats:" )
      local resultTable = {}
      if result.StatusCode then 
        print(result.StatusCode)
      end
      for k,v in pairs( result ) do
        print( string.format( "%s : %s\n", k, v ) )
      end
      print( "Done." )
      local resultTable = JSON:decode(result.Body)
      CustomGameEventManager:Send_ServerToAllClients("serengaard_leaderboard", {resultTable = resultTable})
    end ) 
  end )   
end

function Serengaard:Mithril(name, position, mithrilReward)
  Timers:CreateTimer(5, function()
        -- if starTitle then
        --   for i = 1, #MAIN_HERO_TABLE, 1 do
        --     Stars:StarEventPlayer(starTitle, MAIN_HERO_TABLE[i])
        --   end
        -- end
        local mithrilMult = 2
        if GameState:GetDifficultyFactor() == 2 then
          mithrilMult = 4
        elseif GameState:GetDifficultyFactor() == 3 then
          mithrilMult = 12
        end
        if Events.SpiritRealm then
          mithrilMult = mithrilMult*3
        end
        mithrilReward = math.floor(mithrilReward*mithrilMult)*Events.ResourceBonus
        local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end
        if #crystal.winnerTable > 0 then
          -- for i = 1, #crystal.winnerTable, 1 do
          --   crystal.winnerTable[i].shardsPickedUp = 0
          -- end
          Timers:CreateTimer(1.4, function()
            EmitSoundOn("Resource.MithrilShardEnter", crystal)
          end)
        end
  end)
end
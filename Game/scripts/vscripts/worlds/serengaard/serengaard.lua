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
	--print("SERENGAARD DEBUG")
	--print(MAIN_HERO_TABLE[1]:GetUnitName())
	-- RPCItems:DropSynthesisVessel(MAIN_HERO_TABLE[1]:GetAbsOrigin())
	-- Serengaard:GiveSunstone(MAIN_HERO_TABLE[1], Serengaard.mainAncient:GetAbsOrigin())
	-- RPCItems:RollSunCrystal(MAIN_HERO_TABLE[1]:GetAbsOrigin(), 200)
end

function Serengaard:Debug2()
	-- Serengaard.mainAncient:ForceKill(false)
	-- Serengaard:Mithril("baron", Serengaard.mainAncient:GetAbsOrigin(), 120)
	--Serengaard.InfiniteWaveCount = 30
	--for i = 1, #MAIN_HERO_TABLE, 1 do
	--  Stars:StarEventPlayer("serengaard_infinite", MAIN_HERO_TABLE[i])
	--end
	-- Serengaard:SubmitStats()
	-- Serengaard:SpawnBossUnit("serengaard_final_boss", SERENGAARD_SPAWN_POINTS[RandomInt(1,#SERENGAARD_SPAWN_POINTS)], 1, 35, 0, false)
	-- Serengaard:SpawnBossUnit("serengaard_final_boss", SERENGAARD_SPAWN_POINTS[RandomInt(1,#SERENGAARD_SPAWN_POINTS)], 1, 35, 0, false)
end

function Serengaard:Init()
	--print("Initialize Redfall")
	Dungeons.phoenixCollision = false
	RPCItems.DROP_LOCATION = Vector(0, 0)
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

	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(0, 0), 3400, 99999, false)

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
		--Serengaard.wave = 5
		Serengaard:LinewarIncomeFunction(150)
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
	ancient:SetMaxHPandHealToFull(SERENGAARD_ANCIENT_HP)
	Events:AdjustDeathXP(ancient)
	Timers:CreateTimer(2, function()
		Serengaard.SerengaardRangerTable = {}
		for i = 1, #SERENGAARD_RANGER_POS_TABLE, 1 do
			Timers:CreateTimer(i * 0.1, function()
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
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "battle_of_serengaard"})
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
	--print("MAKE VOTE?")
	Serengaard.SkipVotes = 0
	if Beacons.cheats then
		CustomGameEventManager:Send_ServerToAllClients("serengaard_vote_skip", {playerCount = 3})
	else
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local hero = MAIN_HERO_TABLE[i]
			CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "serengaard_vote_skip", {playerCount = RPCItems:GetConnectedPlayerCount()})
		end
	end

	Timers:CreateTimer(0, function()
		CustomGameEventManager:Send_ServerToAllClients("updateLineWarIncomeTimer", {incomeTimer = Serengaard.IncomeTimer})
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
	--print("SERENGAARD VOTE???")
	Serengaard.SkipVotes = Serengaard.SkipVotes + 1
	if Serengaard.SkipVotes > RPCItems:GetConnectedPlayerCount() / 2 then
		Serengaard.IncomeTimer = 0
	else
		CustomGameEventManager:Send_ServerToAllClients("serengaard_update_skip_votes", {number = Serengaard.SkipVotes})
	end
end

function Serengaard:TimerEnd()
	CustomGameEventManager:Send_ServerToAllClients("updateLineWarIncomeTimer", {incomeTimer = "-"})
	CustomGameEventManager:Send_ServerToAllClients("serengaard_between_wave_end", {})
	if Serengaard.wave == 0 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 40
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {})
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("dark_fighter_serengaard", SERENGAARD_SPAWN_POINTS[i], 11, 8, 1.2, false)
		end
	elseif Serengaard.wave == 5 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 50
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {})
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
		Serengaard.waveMax = (spawnsPerPoint * 8) - 5
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {})
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("serengaard_nightmare_raider", SERENGAARD_SPAWN_POINTS[i], 22, 10, 1.2, false)
		end

		Timers:CreateTimer(9, function()
			StartMusic("Serengaard.Music.Wave.21_30", 110)
		end)
	elseif Serengaard.wave >= 30 then
		CustomGameEventManager:Send_ServerToAllClients("serengaardWaveSpawn", {})
		Serengaard:InfiniteWave()
	end
end

function Serengaard:NextWave()
	--print("WAVE!!")
	--print(Serengaard.wave)
	if Serengaard.wave == 1 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 50
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave})
		Serengaard:LinewarIncomeFunction(60)
	elseif Serengaard.wave == 6 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 65
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		Serengaard.waveMax = 26 * amount
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave})
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
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
			EmitGlobalSound("nevermore_nev_spawn_09")
			for i = 1, neverlordCount, 1 do
				Serengaard:SpawnBossUnit("serengaard_neverlord", SERENGAARD_SPAWN_POINTS[i], 1, 35, 0, false)
			end
		end
	elseif Serengaard.wave == 11 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 50
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("mine_zombie", SERENGAARD_SPAWN_POINTS[i], 21, 31, 0.9, false)
		end
		StartMusic("Serengaard.Music.Wave.11_20", 80)
	elseif Serengaard.wave == 13 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 70
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave})
		Serengaard:LinewarIncomeFunction(60)
	elseif Serengaard.wave == 16 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 75
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave})
			if GameState:GetDifficultyFactor() == 1 then
				CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Win"})
				Notifications:TopToAll({text = "serengaard_normal_complete", duration = 10.0})
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
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
			EmitGlobalSound("razor_raz_spawn_07")
			for i = 1, neverlordCount, 1 do
				Serengaard:SpawnBossUnit("serengaard_baron_razor", SERENGAARD_SPAWN_POINTS[i], 1, 35, 0, false)
			end
		end
	elseif Serengaard.wave == 21 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 65
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("wraithguard", SERENGAARD_SPAWN_POINTS[i], 1, 60, 5.0, false)
		end
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("wraithguard_elite", SERENGAARD_SPAWN_POINTS[i], 3, 62, 9.0, false)
		end
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("serengaard_skeleton_archer", SERENGAARD_SPAWN_POINTS[i], 11, 64, 1.5, false)
		end
		StartMusic("Serengaard.Music.Wave.21_30", 110)
	elseif Serengaard.wave == 24 then
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 100
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("wraithguard", SERENGAARD_SPAWN_POINTS[i], 1, 60, 5.0, false)
		end
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("wraithguard_elite", SERENGAARD_SPAWN_POINTS[i], 2, 62, 4.0, false)
		end
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("serengaard_skeleton_archer", SERENGAARD_SPAWN_POINTS[i], 4, 54, 2.5, false)
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave})
		Serengaard:LinewarIncomeFunction(60)
	elseif Serengaard.wave == 26 then
		EmitGlobalSound("Hero_Nightstalker.Darkness")
		GameRules:BeginNightstalkerNight(60)
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 70
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
		for i = 1, #SERENGAARD_SPAWN_POINTS, 1 do
			Serengaard:SpawnWaveUnit("serengaard_night_invader", SERENGAARD_SPAWN_POINTS[i], 20, 60, 1.0, false)
		end
		StartMusic("Serengaard.Music.Wave.21_30", 110)
	elseif Serengaard.wave == 27 then
		Dungeons.phoenixEggLocation = Vector(0, 0, 0)
		Serengaard.wave = Serengaard.wave + 1
		Serengaard.waveProgress = 0
		Serengaard.waveMax = 70
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
		Dungeons.phoenixEggLocation = Vector(0, 0, 0)
		CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
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
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = 0, currentEnemies = 0, waveNumber = Serengaard.wave})
			if GameState:GetDifficultyFactor() <= 2 then
				CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Serengaard.Music.Win"})
				Notifications:TopToAll({text = "serengaard_elite_complete", duration = 10.0})
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
			CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = Serengaard.wave})
			-- EmitGlobalSound("razor_raz_spawn_07")
			for i = 1, neverlordCount, 1 do
				Serengaard:SpawnBossUnit("serengaard_final_boss", SERENGAARD_SPAWN_POINTS[RandomInt(1, #SERENGAARD_SPAWN_POINTS)], 1, 35, 0, false)
			end
		end
	elseif Serengaard.wave > 30 then
		if Serengaard.InfiniteWaveCount then
			local income_timer = 60
			if Serengaard.InfiniteWaveCount % 5 == 0 then
				income_timer = 60
				if Serengaard.InfiniteWaveCount % 10 == 0 then
					Serengaard:KillAllNeutrals()
					local mithril = SERENGAARD_MITHRIL_INF_BASE + math.min(Serengaard.InfiniteWaveCount * SERENGAARD_MITHRIL_INF_PER_WAVE, SERENGAARD_MITHRIL_INF_PER_WAVE_MAX)
					Serengaard:Mithril("infinite", Serengaard.mainAncient:GetAbsOrigin(), mithril)
					for i = 1, #MAIN_HERO_TABLE, 1 do
						Stars:StarEventPlayer("serengaard_infinite", MAIN_HERO_TABLE[i])
					end
				end
				if Serengaard.InfiniteWaveCount % 30 == 0 then
					income_timer =  500
					Timers:CreateTimer(2, function()
						for i = 1, #MAIN_HERO_TABLE, 1 do
							Serengaard:GiveSunstone(MAIN_HERO_TABLE[i], Serengaard.mainAncient:GetAbsOrigin())
						end
					end)
				end
				Serengaard:LinewarIncomeFunction(income_timer)
			else
				Serengaard:InfiniteWave()
			end
		else
			Serengaard:InfiniteWave()
		end
	end
end

function Serengaard:InfiniteWave()
	--print("SPAWN INFINITE WAVE!")
	if Serengaard.gameOver then
		return false
	end
	StartMusic("Serengaard.Music.InfiniteWaves", 50)
	CustomGameEventManager:Send_ServerToAllClients("serengaardInfiniteWaves", {})
	if not Serengaard.InfiniteWaveCount then
		Serengaard.InfiniteWaveCount = 0
	end
	Serengaard.InfiniteWaveCount = Serengaard.InfiniteWaveCount + 1

	Serengaard.waveProgress = 0
	Serengaard.waveMax = 75
	if Serengaard.InfiniteWaveCount == 1 then
		Serengaard.waveMax = 70
	end
	CustomGameEventManager:Send_ServerToAllClients("serengaardUpdateData", {enemiesMax = Serengaard.waveMax, currentEnemies = Serengaard.waveProgress, waveNumber = "I-"..Serengaard.InfiniteWaveCount})
	local unit1 = SERENGAARD_TABLE_TIER_1 [RandomInt(1, #SERENGAARD_TABLE_TIER_1 )]
	local unit2 = SERENGAARD_TABLE_TIER_1[RandomInt(1, #SERENGAARD_TABLE_TIER_1)]
	local unit3 = SERENGAARD_TABLE_TIER_2[RandomInt(1, #SERENGAARD_TABLE_TIER_2)]
	local unit4 = SERENGAARD_TABLE_TIER_2[RandomInt(1, #SERENGAARD_TABLE_TIER_2)]
	if Serengaard.InfiniteWaveCount >= SERENGAARD_INFINITE_STAGE_2 then
		unit4 = SERENGAARD_TABLE_TIER_3[RandomInt(1, #SERENGAARD_TABLE_TIER_3)]
	end
	if Serengaard.InfiniteWaveCount >= SERENGAARD_INFINITE_STAGE_3 then
		local luck1 = RandomInt(1,4)
			if luck1 < 2 then
				unit1 = SERENGAARD_TABLE_TIER_2 [RandomInt(1, #SERENGAARD_TABLE_TIER_2 )] --25%
			end
		local luck2 = RandomInt(1,4)
			if luck2 < 3 then
				unit2 = SERENGAARD_TABLE_TIER_1[RandomInt(1, #SERENGAARD_TABLE_TIER_1)] --50%
			elseif luck2 < 4 then
				unit2 = SERENGAARD_TABLE_TIER_2[RandomInt(1, #SERENGAARD_TABLE_TIER_2)] --25%
			elseif luck2 == 4 then
				unit2 = SERENGAARD_TABLE_TIER_3[RandomInt(1, #SERENGAARD_TABLE_TIER_3)] --25%
			end
		local luck3 = RandomInt(1,4)
			if luck3 < 2 then
				unit3 = SERENGAARD_TABLE_TIER_1[RandomInt(1, #SERENGAARD_TABLE_TIER_1)] --25%
			elseif luck3 < 4 then
				unit3 = SERENGAARD_TABLE_TIER_2[RandomInt(1, #SERENGAARD_TABLE_TIER_2)] --50%
			elseif luck3 == 4 then
				unit3 = SERENGAARD_TABLE_TIER_3[RandomInt(1, #SERENGAARD_TABLE_TIER_3)] --25%
			end
		local luck4 = RandomInt(1,8)
			if luck4 < 2 then
				unit4 = SERENGAARD_TABLE_TIER_4[RandomInt(1, #SERENGAARD_TABLE_TIER_4)] --12.5%
			else
				unit4 = SERENGAARD_TABLE_TIER_3[RandomInt(1, #SERENGAARD_TABLE_TIER_3)] --87.5%
			end
	end
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
			spawnPoint = spawnPoint + Vector(0, 600)
		elseif random == 2 then
			spawnPoint = spawnPoint + Vector(-600, 0)
		elseif random == 3 then
			spawnPoint = spawnPoint + Vector(600, 0)
		end
	elseif WallPhysics:GetDistance2d(SERENGAARD_SPAWN_POINTS[2], spawnPoint) < 200 then
		if random == 1 then
			spawnPoint = spawnPoint + Vector(0, 600)
		elseif random == 2 then
			spawnPoint = spawnPoint + Vector(0, -600)
		elseif random == 3 then
			spawnPoint = spawnPoint + Vector(-600, 0)
		end
	elseif WallPhysics:GetDistance2d(SERENGAARD_SPAWN_POINTS[3], spawnPoint) < 200 then
		if random == 1 then
			spawnPoint = spawnPoint + Vector(600, 0)
		elseif random == 2 then
			spawnPoint = spawnPoint + Vector(0, -600)
		elseif random == 3 then
			spawnPoint = spawnPoint + Vector(-600, 0)
		end
	elseif WallPhysics:GetDistance2d(SERENGAARD_SPAWN_POINTS[4], spawnPoint) < 200 then
		if random == 1 then
			spawnPoint = spawnPoint + Vector(600, 0)
		elseif random == 2 then
			spawnPoint = spawnPoint + Vector(0, 600)
		elseif random == 3 then
			spawnPoint = spawnPoint + Vector(0, -600)
		end
	end
	return spawnPoint
end

function Serengaard:SpawnWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)
	local baseSpawnPos = spawnPoint
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			spawnPoint = Serengaard:AdjustSpawnPoint(baseSpawnPos)
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CastleSpawner.Spawn", Redfall.RedfallMaster)
			end
			local maxLuck = 120
			if Serengaard.InfiniteWaveCount then
				maxLuck = math.max(120 - Serengaard.InfiniteWaveCount, 85)
			end
			local luck = RandomInt(1, maxLuck)
			local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)

			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				unit.dominion = true
				unit.itemLevel = itemLevel
				Serengaard:AdjustUnit(unit)
			else
				for i = 1, #unit.buddiesTable, 1 do
					unit.buddiesTable[i].dominion = true
					unit.buddiesTable[i].itemLevel = itemLevel
					Serengaard:AdjustUnit(unit.buddiesTable[i])
				end
			end
		end)
	end
end

function Serengaard:SpawnBossUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
			-- Events:AdjustDeathXP(unit)
			local adjustFactor = math.ceil(Serengaard.wave / 4)

			Serengaard:AdjustUnit(unit)
			Events:AdjustBossPower(unit, adjustFactor, adjustFactor, false)
			unit.serengaardBoss = true
			unit.type = ENEMY_TYPE_BOSS
		end)
	end
end

function Serengaard:AdjustUnit(unit)
	Serengaard.SerengaardMasterAbility:ApplyDataDrivenModifier(Serengaard.SerengaardMaster, unit, "modifier_serengaard_wave_unit", {})
	Serengaard.SerengaardMasterAbility:ApplyDataDrivenModifier(Serengaard.SerengaardMaster, unit, "modifier_serengaard_unit_spawned", {duration = 3})
	unit.aggro = true
	unit:SetAcquisitionRange(6000)
	Timers:CreateTimer(0.1, function()
		unit:MoveToPositionAggressive(Vector(0, 0))
	end)
	unit.targetRadius = 800
	unit.minRadius = 0
	unit.targetAbilityCD = 1
	unit.targetFindOrder = FIND_ANY_ORDER
	unit.autoAbilityCD = 1

	-- Events:AdjustDeathXP(unit)
	if GameState:GetDifficultyFactor() == 3 then
		newHealth = unit:GetMaxHealth() * (1 + Serengaard.wave * 0.1)
		newHealth = math.min(newHealth, (2 ^ 30) - 10)
		unit:SetMaxHealth(newHealth)
		unit:SetBaseMaxHealth(newHealth)
		unit:SetHealth(newHealth)
		unit:Heal(newHealth, unit)
	end
	if unit:HasAbility("mega_steadfast") then
		unit:RemoveAbility("mega_steadfast")
		unit:RemoveModifierByName("modifier_mega_steadfast")
		unit:AddAbility("normal_steadfast")
	end
	if unit:GetUnitName() == "serengaard_hook_flinger" then
		unit.targetRadius = 1200
	elseif unit:GetUnitName() == "serengaard_icy_venge" then
		unit.targetRadius = 800
	elseif unit:GetUnitName() == "npc_dota_creature_basic_zombie_exploding" or unit:GetUnitName() == "npc_dota_creature_desert_zombie" then
		Serengaard.SerengaardMasterAbility:ApplyDataDrivenModifier(Serengaard.SerengaardMaster, unit, "modifier_serengaard_charge", {duration = 6})
	elseif unit:GetUnitName() == "serengaard_antimage" then
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
		Events:ColorWearables(unit, Vector(40, 40, 40))
	elseif unit:GetUnitName() == "crimsyth_fortune_seeker" then
		unit:AddNewModifier(unit, nil, "modifier_animation", {translate = "attack_normal_range"})
		unit:AddNewModifier(unit, nil, "modifier_animation_translate", {translate = "run"})
	elseif unit:GetUnitName() == "fire_temple_protective_spirit" then
		unit.modelScale = 0.95
	elseif unit:GetUnitName() == "phoenix_siege_dragon" then
		Dungeons.phoenixEggLocation = Vector(0, 0, 0)
	end

	if GameState:GetDifficultyFactor() > 1 then
		local bountyXP = math.ceil(unit:GetDeathXP() / 2)
		unit:SetDeathXP(bountyXP)
	end
	if Serengaard.InfiniteWaveCount then
		unit:SetRenderColor(120, 120, 120)
		Events:ColorWearables(unit, Vector(120, 120, 120))
		unit.itemLevel = 80 + Serengaard.InfiniteWaveCount * 3
	end
end

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
	local fv = Vector(1, 0)
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
	local maxValue = 2500000
	for i = 1, #Serengaard.SerengaardBarracksTable, 1 do
		if IsValidEntity(Serengaard.SerengaardBarracksTable[i]) then
			local tower = Serengaard.SerengaardBarracksTable[i]
			if tower:IsAlive() then
				local hpPercentage = tower:GetHealth() / tower:GetMaxHealth()
				local armor = math.floor(tower:GetPhysicalArmorBaseValue() * (1.05))
				local attackDamage = math.floor(tower:GetAttackDamage() * (1.05))
				local hp = math.floor(tower:GetMaxHealth() * (1.05))
				armor = math.min(armor, maxValue)
				attackDamage = math.min(attackDamage, maxValue)
				hp = math.min(hp, maxValue)
				tower:SetMaxHealth(hp)
				tower:SetBaseMaxHealth(hp)
				tower:SetHealth(hp * hpPercentage)

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
				local hpPercentage = tower:GetHealth() / tower:GetMaxHealth()
				local armor = math.floor(tower:GetPhysicalArmorBaseValue() * (1.05))
				local attackDamage = math.floor(tower:GetAttackDamage() * (1.05))
				local hp = math.floor(tower:GetMaxHealth() * (1.05))
				armor = math.min(armor, maxValue)
				attackDamage = math.min(attackDamage, maxValue)
				hp = math.min(hp, maxValue)
				tower:SetMaxHealth(hp)
				tower:SetBaseMaxHealth(hp)
				tower:SetHealth(hp * hpPercentage)

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
				local hpPercentage = tower:GetHealth() / tower:GetMaxHealth()
				local armor = math.floor(tower:GetPhysicalArmorBaseValue() * (1.05))
				local attackDamage = math.floor(tower:GetAttackDamage() * (1.05))
				local hp = math.floor(tower:GetMaxHealth() * (1.05))
				armor = math.min(armor, maxValue)
				attackDamage = math.min(attackDamage, maxValue)
				hp = math.min(hp, maxValue)
				tower:SetMaxHealth(hp)
				tower:SetBaseMaxHealth(hp)
				tower:SetHealth(hp * hpPercentage)

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
				local hpPercentage = tower:GetHealth() / tower:GetMaxHealth()
				local armor = math.floor(tower:GetPhysicalArmorBaseValue() * (1.05))
				local attackDamage = math.floor(tower:GetAttackDamage() * (1.05))
				local hp = math.floor(tower:GetMaxHealth() * (1.05))
				armor = math.min(armor, maxValue)
				attackDamage = math.min(attackDamage, maxValue)
				hp = math.min(hp, maxValue)
				tower:SetMaxHealth(hp)
				tower:SetBaseMaxHealth(hp)
				tower:SetHealth(hp * hpPercentage)

				tower:SetPhysicalArmorBaseValue(armor)
				tower:SetBaseDamageMin(attackDamage)
				tower:SetBaseDamageMax(attackDamage)
			end
		end
	end
	if IsValidEntity(Serengaard.mainAncient) then
		local tower = Serengaard.mainAncient
		if tower:IsAlive() then
			local hpPercentage = tower:GetHealth() / tower:GetMaxHealth()
			local armor = math.min(math.floor(tower:GetPhysicalArmorBaseValue() * (1.05)), 8000)
			local attackDamage = math.floor(tower:GetAttackDamage() * (1.05))
			local hp = SERENGAARD_ANCIENT_HP
			hp = math.min(hp, maxValue)
			tower:SetMaxHealth(hp)
			tower:SetBaseMaxHealth(hp)
			tower:SetHealth(hp * hpPercentage)

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
						Serengaard.CachedPlayers[i] = {Serengaard:Url_encode(PlayerResource:GetSelectedHeroName(playerID)), PlayerResource:GetSteamAccountID(playerID), Serengaard:Url_encode(PlayerResource:GetPlayerName(playerID)), tostring(PlayerResource:GetSteamID(playerID))}
					end
				end
			end
		end
	end
end

function Serengaard:SubmitStats()
	local url = ""
	for i, v in pairs(Serengaard.CachedPlayers) do
		--print("Players: "..i.." "..v[1] .. " "..v[2] .. " "..v[3] .. " "..v[4])
	end
	if Serengaard.InfiniteWaveCount and SaveLoad:GetAllowSaving() then
		url = ROSHPIT_URL.."/champions/save_serengaard?"
		url = url.."wave_number="..Serengaard.InfiniteWaveCount
		url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
		--SaveLoad:NewKey()
		for i = 1, #Serengaard.CachedPlayers, 1 do
			-- local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
			local heroName = Serengaard.CachedPlayers[i][1]
			local steamID = Serengaard.CachedPlayers[i][2]
			local playerName = Serengaard.CachedPlayers[i][3]
			local steamIDlong = Serengaard.CachedPlayers[i][4]
			--print(steamIDlong)
			url = url.."&steam_id"..i.."="..steamID
			url = url.."&hero"..i.."="..heroName
			url = url.."&steam_name"..i.."="..playerName
			url = url.."&steam_id_long"..i.."="..steamIDlong
		end
		CreateHTTPRequestScriptVM("POST", url):Send(function(result)
			--print("POST" .. " response infWaves:")
			if result.StatusCode then
				--print(result.StatusCode)
			end
		end)
	end
	Timers:CreateTimer(5, function()
		url = ROSHPIT_URL.."/champions/get_serengaard?"
		--print("serengaard url: "..url)
		CreateHTTPRequestScriptVM("GET", url):Send(function(result)
			--print("GET" .. " response stats:")
			local resultTable = {}
			if result.StatusCode then
				--print(result.StatusCode)
			end
			for k, v in pairs(result) do
				--print(string.format("%s : %s\n", k, v))
			end
			--print("Done.")
			local resultTable = JSON:decode(result.Body)
			CustomGameEventManager:Send_ServerToAllClients("serengaard_leaderboard", {resultTable = resultTable})
		end)
	end)
end

function Serengaard:Mithril(name, position, mithrilReward)
	Timers:CreateTimer(5, function()
		-- if starTitle then
		--   for i = 1, #MAIN_HERO_TABLE, 1 do
		--     Stars:StarEventPlayer(starTitle, MAIN_HERO_TABLE[i])
		--   end
		-- end
		local mithrilMult = SERENGAARD_MITHRIL_MULT_NORMAL
		if GameState:GetDifficultyFactor() == 2 then
			mithrilMult = SERENGAARD_MITHRIL_MULT_ELITE
		elseif GameState:GetDifficultyFactor() == 3 then
			mithrilMult = SERENGAARD_MITHRIL_MULT_LEGEND
		end
		if Events.SpiritRealm then
			mithrilMult = mithrilMult * 3
		end
		mithrilReward = math.floor(mithrilReward * mithrilMult) * Events.ResourceBonus
		local crystal = CreateUnitByName("arcane_crystal", position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
		crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
		local crystalAbility = crystal:AddAbility("mithril_shard_ability")
		crystalAbility:SetLevel(1)
		local fv = RandomVector(1)
		crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
		crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
		crystal.reward = mithrilReward
		crystal.reward = math.floor(crystal.reward * (1 + GameState:GetPlayerPremiumStatusCount() * 0.1))
		crystal.distributed = 0
		local baseModelSize = math.min(2.9, 1.2 + crystal.reward / 200)
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


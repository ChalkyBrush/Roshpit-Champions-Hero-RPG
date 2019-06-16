if Arena == nil then
  Arena = class({})
end

require('/worlds/arena/champions_league')
require('/worlds/arena/arena_games')
require('/worlds/arena/arena_nightmare')
require('/worlds/arena/pit_of_trials/pit_of_trials')

function Arena:Debug()
	-- Arena:SpawnCragnataur(MAIN_HERO_TABLE[1]:GetAbsOrigin(), Vector(1,0))
    if MAIN_HERO_TABLE[1] then
 --      MAIN_HERO_TABLE[1]:SetBaseStrength(40000)
 --      MAIN_HERO_TABLE[1]:SetBaseAgility(25000)
 --      MAIN_HERO_TABLE[1]:SetBaseIntellect(25000)
 --      MAIN_HERO_TABLE[1]:SetBaseDamageMax(1500000)
 --      MAIN_HERO_TABLE[1]:SetBaseDamageMin(1500000)
 --      MAIN_HERO_TABLE[1]:CalculateStatBonus()
 --      local hero = MAIN_HERO_TABLE[1]
	-- 	hero.runeUnit2.amulet.e_2 = hero.runeUnit2.amulet.e_2 + 1500
	-- 	Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.e_2, "rune_e_2", hero)
	-- 	hero.runeUnit3.amulet.w_3 = hero.runeUnit3.amulet.w_3 + 500
	-- 	Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.w_3, "rune_w_3", hero)
	-- 	hero.runeUnit2.amulet.q_2 = hero.runeUnit2.amulet.q_2 + 500
	-- 	Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.q_2, "rune_q_2", hero)
	-- 	hero.runeUnit.amulet.q_1 = hero.runeUnit.amulet.q_1 + 500
	-- 	Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.q_1, "rune_q_1", hero)
    end
	-- -- Arena:BeginBattle(MAIN_HERO_TABLE[1])
    local item = RPCItems:CreateItem("item_debug_blink", nil, nil)
    local drop = CreateItemOnPositionSync( Vector(-3136, -11200), item )
    local position = Vector(-3136, -11200)
    RPCItems:DropItem(item, Vector(-3136, -11200))
 --    MAIN_HERO_TABLE[1].ChampionsLeague = {}
 --    MAIN_HERO_TABLE[1].ChampionsLeague.rank = 14

			-- local lockoutStatus = os:ServerTimeToTable()
			-- local hero = MAIN_HERO_TABLE[1]
			-- hero.pit = {}
			-- hero.pit.pit_level = 7
			-- if Arena.PitActive or Arena.PitLocked then
			-- 	lockoutStatus = 2
			-- end
			-- CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "pit_terminal", {pitData=hero.pit, heroName=hero:GetUnitName(), lockoutStatus = lockoutStatus})

    -- Arena.ChampionsLeague = {}
    -- Arena.ChampionsLeague.state = 14
    -- Arena:ChampionsLeagueRegisterForBattle(MAIN_HERO_TABLE[1], 14)

    -- Arena:SpawnTrainingDummies()
    -- Weapons:RollWeapon(Vector(-3136, -11200))
    -- RPCItems:RollNeptunesWaterGliders(Vector(-3136, -11200))
    -- Arena.PitLevel = 5
    -- Weapons:RollLegendWeapon1(Vector(-3136, -11200), "chernobog")
end

function Arena:Debug2()
	-- Arena:OpenPit(3)
	-- Arena:DescentRoom2()
	-- Weapons:RollRandomLegendWeapon1(Vector(-3136, -11200))
	-- Arena.PitLevel = 7
	-- Weapons:RollRandomLegendWeapon1(Vector(-3136, -11200))
	-- Arena.PitColor = "blue"
	
	-- RPCItems:RollGiantHunterBoots(Vector(-3136, -11200))
	-- RPCItems:RollSacredTrialsArmor(Vector(-3136, -11200))
	-- RPCItems:RollHeroicConquerorVestments(Vector(-3136, -11200), 3)
	-- Arena:OpenPit(3)
	-- Arena:SpawnLies7()
	require('/worlds/arena/pit_of_trials/pit_of_trials')
	Arena.PitLevel = 7
	-- Arena.LiesOpen = true
	-- Arena:SpawnLiesBoss(Vector(-3136, -11200))
	-- Weapons:RollLegendWeapon1(Vector(-3136, -11200), "chernobog")
	Arena:SoulFerrierEvent()
	-- Weapons:RollLegendWeapon1(Vector(-3136, -11200), "spirit_warrior")
	-- -- Arena:SpawnPitFinalBoss()
	-- RPCItems:RollConquestStoneFalcon(Vector(-3136, -11200))
	-- Weapons:RollLegendWeapon1(Vector(-3136, -11200), "auriun")
	-- Arena.widow = Arena:SpawnGrievingWidow(Vector(10624, 8000), Vector(1,0))
	-- 	Arena.widowCorpse = CreateUnitByName("npc_dummy_unit", Vector(10874, 7830), false, nil, nil, DOTA_TEAM_GOODGUYS)
	-- 	Arena.widowCorpse:SetAbsOrigin(Vector(10874, 7830, 210+Arena.ZFLOAT))
	-- 	Arena.widowCorpse:RemoveAbility("dummy_unit")
	-- 	Arena.widowCorpse:RemoveModifierByName("dummy_unit")
	-- 	Arena.widowCorpse:SetOriginalModel("models/heroes/abaddon/abaddon.vmdl")
	-- 	Arena.widowCorpse:SetModel("models/heroes/abaddon/abaddon.vmdl")
	-- 	Arena.widowCorpse:SetModelScale(1.2)
	-- 	Arena.widowCorpse:SetAngles(-90, 270, 0)
	-- 	local corpseAbility = Arena.widowCorpse:AddAbility("arena_descent_corpse_ability")
	-- 	corpseAbility:ApplyDataDrivenModifier(Arena.widowCorpse, Arena.widowCorpse, "modifier_corpse_start", {})
	-- 	Timers:CreateTimer(1, function()
	-- 		corpseAbility:ApplyDataDrivenModifier(Arena.widowCorpse, Arena.widowCorpse, "modifier_corpse_frozen", {})
	-- 	end)
	-- 	corpseAbility:SetLevel(1)

	-- 	local distance = (Arena.widow:GetAbsOrigin().z - GetGroundHeight(Arena.widow:GetAbsOrigin(), Arena.widow))/90
	-- 	for i = 1, 90, 1 do
	-- 		Timers:CreateTimer(i*0.03, function()
	-- 			Arena.widow:SetAbsOrigin(Arena.widow:GetAbsOrigin()-Vector(0,0,distance))
	-- 		end)
	-- 	end
	-- 	Timers:CreateTimer(2.75, function()
	-- 		local widowAbility = Arena.widow:FindAbilityByName("arena_descent_grieving_widow_ability")
	-- 		widowAbility:ApplyDataDrivenModifier(Arena.widow, Arena.widow, "modifier_widow_soul_steal_aura", {})
	-- 		StartAnimation(Arena.widow, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=1.1})
	-- 		Arena.widow:RemoveModifierByName("modifier_grieving_widow_start")
	-- 		widowAbility:ApplyDataDrivenModifier(Arena.widow, Arena.widow, "modifier_widow_scream", {})
	-- 		if Arena.PitLevel > 3 then
	-- 			Arena.widow:AddAbility("arena_magic_immune_breakable_ability"):SetLevel(1)
	-- 		end
	-- 	end)
	-- Arena:ConquestTemplePart3()
	-- Arena:InitTrialOfConquest()
	-- Arena:SpawnRoom1()
	-- Arena:SpawnRoom1()
        -- RPCItems:RollChampionsGearHelm(MAIN_HERO_TABLE[1]:GetAbsOrigin())
        -- RPCItems:RollChampionsGearGauntlet(MAIN_HERO_TABLE[1]:GetAbsOrigin())
        -- RPCItems:RollChampionsGearMail(MAIN_HERO_TABLE[1]:GetAbsOrigin())
        -- RPCItems:RollChampionsGearBoots(MAIN_HERO_TABLE[1]:GetAbsOrigin())
        -- RPCItems:RollLumaGuard(MAIN_HERO_TABLE[1]:GetAbsOrigin(), false)
	-- if Arena.Nightmare then
	-- 	return false
	-- end
	-- local hero = MAIN_HERO_TABLE[1]
	-- -- hero.ChampionsLeague = {}
	-- -- hero.ChampionsLeague.rank = 10
	-- if hero.ChampionsLeague and (Arena.ChampionsLeague.state == 8 or Arena.ChampionsLeague.state == 7) then
	-- 	Arena.ChampionsLeague.state = 9
	-- 	Timers:CreateTimer(2.5, function()
	-- 		Arena.Coach:MoveToPosition(Vector(-9884, -1024))
	-- 		Timers:CreateTimer(0.5, function()
	-- 			Timers:CreateTimer(0.5, function()
	-- 				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
	-- 			end)
	-- 			basic_dialogue(Arena.Coach, nil, "#champion_assistant_dialogue_10", 7, 5, -80)
	-- 			Timers:CreateTimer(7, function()
	-- 				basic_dialogue(Arena.Coach, nil, "#champion_assistant_dialogue_11", 10, 5, -80)
	-- 				Timers:CreateTimer(4, function()
	-- 					Arena.ChampionsLeague.state = 10
	-- 				end)
	-- 			end)
	-- 		end)
	-- 	end)
	-- end
	-- if Arena.ChampionsLeague.state == 18 then
	-- 	Arena.ChampionsLeague.state = 19
	-- 	Arena:OgreSequence(hero)
	-- 	return false
	-- end
	-- if Arena.ChampionsLeague.state == 19 then
	-- 	return false
	-- end
	-- if hero.ChampionsLeague then
	-- 	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "arena_terminal", {ChampionsLeague=hero.ChampionsLeague, heroName=hero:GetUnitName(), ArenaChampions=Arena.ChampionsLeague})
	-- end
	-- local hero = MAIN_HERO_TABLE[1]
	-- hero.ChampionsLeague = {}
	-- hero.ChampionsLeague.rank = 21
	-- hero.roshpitID = 1
	-- Arena:SaveChampionsLeagueData(hero, 20, 200)
	
end

function Arena:Init()
  print("Initialize Arena")
  Arena.ChampionsLeague = {}
  Arena.ZFLOAT = 200
      Dungeons.phoenixCollision = true
      RPCItems.DROP_LOCATION = Vector(-11584,-11712)
      Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")

      Arena.ArenaMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
      Arena.ArenaMaster:AddAbility("arena_master_ability"):SetLevel(1)
      Arena.ArenaMasterAbility = Arena.ArenaMaster:FindAbilityByName("arena_master_ability")
      Arena.ArenaMaster:AddAbility("dummy_unit"):SetLevel(1)

  Events.TownPosition = Vector(-2752, -10816)
  Events.isTownActive = true
  Events.Dialog0 = false
  Events.Dialog1 = false
  Events.Dialog2 = false
  Events.Dialog3 = false
  Dungeons.itemLevel = 1
  Timers:CreateTimer(3, function()
      -- local blacksmith = Events:SpawnTownNPC(Vector(-5443, 2606), "red_fox", Vector(0.2, -1), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
      -- StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
      local oracle = Events:SpawnOracle(Vector(-2432, -10496), Vector(-0.7, -1))
      -- Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-5184, 1521), Vector(1, 1))
      Arena:StartingMusic()
      Arena:SpawnChampionsCoach()
  end)

  Arena.NumPlayers = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
  print(Arena.NumPlayers)
  Timers:CreateTimer(9, function()
  	 Arena:SpawnArenaOutsideEntities()
  end)
  -- Timers:CreateTimer(10, function()
  --   CalculateHeroZones()
  --   return 10
  -- end)
  -- Timers:CreateTimer(5, function()
  --   Tanari:RareSpawns()
  -- end)
	Arena:InitArenaDoors()
	Timers:CreateTimer(7, function()
		Arena:CreateArenaWalls(true, true, true, true)
		Arena:RaiseWalls(true, {Arena.Door1, Arena.Door4, Arena.Door3, Arena.Door2}, false)
	end)
	Timers:CreateTimer(15, function()
		Arena.WaterMagician = Events:SpawnTownNPC(Vector(-10304, -6731), "arena_aquatarium_magician", Vector(1, 0), nil, nil, nil, 1.2, false, nil)	
		Arena.WaterMagician:SetRenderColor(90, 90, 255)
	end)
	Timers:CreateTimer(22, function()
		Arena:PreparePitSwitches()
	end)
end

function Arena:StartingMusic()
	Timers:CreateTimer(5, function()
		if not Arena.ChampionsLeague.battlePrep and not Arena.PitActive then
			-- EmitSoundOnLocationWithCaster(Vector(-2816, -10306, 256), "Arena.StartingMusic", Events.GameMaster)
			-- EmitSoundOnLocationWithCaster(Vector(-2670, -2445, 256), "Arena.StartingMusic", Events.GameMaster)
			CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.StartingMusic"})
			if not Arena.ChampionsLeague.battlePrep and not Arena.PitActive then
				return 94
			end
		end
	end)
end

function Arena:BattleMusic()
	
	Timers:CreateTimer(0, function()
		if Arena.ChampionsLeague.battlePrep then
			EmitSoundOnLocationWithCaster(Vector(-2816, -10306, 256), "Arena.Battle.Music", Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(-2670, -2445, 256), "Arena.Battle.Music", Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(-2670, -2445, 256), "Arena.Battle.Music", Events.GameMaster)
			return 74
		end
	end)
end

function Arena:SpawnArenaOutsideEntities()
	if not Arena.OutsideEntitiesTable then
		Arena.OutsideEntitiesTable = {}
	end
	local unit = Events:SpawnTownNPC(Vector(-3981, -10804), "red_fox", Vector(0, -1), "models/items/courier/shagbark/shagbark.vmdl", nil, nil, 1.0, false, nil)
	Arena:AddPatrolArguments(unit, 0, 6, 300, {Vector(-3548, -11334), Vector(-3981, -10804)})
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-3648, -9600), "red_fox", Vector(1, -1), "models/items/courier/shagbark/shagbark.vmdl", nil, nil, 1.0, false, nil)
	Arena:AddPatrolArguments(unit, 0, 8, 300, {Vector(-4160, -10432), Vector(-3648, -9600)})
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-1225, -10142), "red_fox", Vector(-1, -1), "models/items/courier/shagbark/shagbark.vmdl", nil, nil, 1.0, false, nil)
	Arena:AddPatrolArguments(unit, 0, 8, 300, {Vector(-1664, -9472), Vector(-1225, -10142)})
	table.insert(Arena.OutsideEntitiesTable, unit)

	local attendant = Events:SpawnTownNPC(Vector(-1728, -10752), "arena_attendee_one", Vector(-1, -1), nil, nil, nil, 1.0, true, "arena_attendant")
	table.insert(Arena.OutsideEntitiesTable, attendant)



	Timers:CreateTimer(3, function()
		local unit = Events:SpawnTownNPC(Vector(-2944, -8088), "arena_entrance_fan", Vector(0, -1), nil, nil, nil, 1.0, true, "arena_fan")
		table.insert(Arena.OutsideEntitiesTable, unit)

		local unit = Events:SpawnTownNPC(Vector(-2240, -8576), "red_fox", Vector(-1, -1), "models/courier/smeevil/smeevil.vmdl", nil, nil, 1.8, true, "arena_fan2")
		Arena:AddPatrolArguments(unit, 0, 10, 300, {Vector(-1072, -7328), Vector(-2240, -8576)})
		table.insert(Arena.OutsideEntitiesTable, unit)
		Timers:CreateTimer(0.05, function()
			unit:MoveToPosition(unit:GetAbsOrigin()+Vector(-5,-5))
		end)

		Arena.ChampionsLeagueAttendant = Events:SpawnTownNPC(Vector(-3648, -6932), "champions_league_attendant", Vector(0, -1), nil, nil, nil, 1.16, false, nil)
		table.insert(Arena.OutsideEntitiesTable, Arena.ChampionsLeagueAttendant)

		Arena.PVPAttendant = Events:SpawnTownNPC(Vector(-2688, -6932), "pvp_attendant", Vector(0, -1), nil, nil, nil, 1.2, false, nil)
		table.insert(Arena.OutsideEntitiesTable, Arena.PVPAttendant)

		Arena.ChallengerAttendant = Events:SpawnTownNPC(Vector(-1728, -6932), "challenger_attendant", Vector(0, -1), nil, nil, nil, 1.2, false, nil)
		table.insert(Arena.OutsideEntitiesTable, Arena.ChallengerAttendant)
		
	end)
	Timers:CreateTimer(5, function()
		Arena.NewbieGuardTable = {}
		local unit = Events:SpawnTownNPC(Vector(-8414, -2700), "arena_guard", Vector(1, 0), nil, nil, nil, 0.85, false, nil)
		unit.basePos = unit:GetAbsOrigin()
		unit.origFv = Vector(1,0)
		table.insert(Arena.OutsideEntitiesTable, unit)
		table.insert(Arena.NewbieGuardTable, unit)
		local unit = Events:SpawnTownNPC(Vector(-8414, -2048), "arena_guard", Vector(1, 0), nil, nil, nil, 0.85, false, nil)
		unit.basePos = unit:GetAbsOrigin()
		unit.origFv = Vector(1,0)
		table.insert(Arena.OutsideEntitiesTable, unit)
		table.insert(Arena.NewbieGuardTable, unit)
		Arena:SpawnNewbeeLounge()
	end)
	Timers:CreateTimer(7, function()
		Arena:GenerateCrowd(60)
	end)
	Timers:CreateTimer(8, function()
		Arena:CreateShowCombatants()
	end)
	Timers:CreateTimer(11, function()
		local unit = Events:SpawnTownNPC(Vector(-5376, -6336), "arena_hall_of_heroes_npc", Vector(-1, -1), nil, nil, nil, 1.1, true, "hall_of_champions_dialogue")
		Arena:AddPatrolArguments(unit, 32, 10, 150, {Vector(-6016, -6400), Vector(-5953, -5735), Vector(-6016, -6400), Vector(-5376, -6336)})
		table.insert(Arena.OutsideEntitiesTable, unit)
	
		local unit = Events:SpawnTownNPC(Vector(-7232, -4352), "arena_entrance_fan", Vector(0, -1), nil, nil, nil, 1.0, false, nil)
		Arena:AddPatrolArguments(unit, 0, 5, 150, {Vector(-6080, -6336), Vector(-6720, -4992), Vector(-7104, -5760), Vector(-7232, -4352)})
		table.insert(Arena.OutsideEntitiesTable, unit)

		local blacksmith = Events:SpawnTownNPC(Vector(-320, -6016), "red_fox", Vector(0, -1), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
		StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
		table.insert(Arena.OutsideEntitiesTable, blacksmith)
		Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(1469, -6527), Vector(0, 1))
		table.insert(Arena.OutsideEntitiesTable, Events.GlyphEnchanter)

		local curator = Events:SpawnCurator(Vector(-896, -6848), Vector(0,-1))
		table.insert(Arena.OutsideEntitiesTable, curator)
	end)
	
	Timers:CreateTimer(24, function()
		Arena:SpawnMajorLeagueLounge()
		Arena.MajorGuardTable = {}
		local unit = Events:SpawnTownNPC(Vector(-7719, 3968), "arena_guard", Vector(1, -1), nil, nil, nil, 0.85, false, nil)
		unit.basePos = unit:GetAbsOrigin()
		unit.origFv = Vector(1,-1)
		table.insert(Arena.OutsideEntitiesTable, unit)
		table.insert(Arena.MajorGuardTable, unit)
		local unit = Events:SpawnTownNPC(Vector(-7360, 4352), "arena_guard", Vector(0, -1), nil, nil, nil, 0.85, false, nil)
		unit.basePos = unit:GetAbsOrigin()
		unit.origFv = Vector(0,-1)
		table.insert(Arena.OutsideEntitiesTable, unit)
		table.insert(Arena.MajorGuardTable, unit)
	end)
	Timers:CreateTimer(32, function()
		Arena:SpawnAllStarLounge()
		Arena.AllstarGuardTable = {}
		local unit = Events:SpawnTownNPC(Vector(-3200, 4032), "arena_guard", Vector(0, -1), nil, nil, nil, 0.85, false, nil)
		unit.basePos = unit:GetAbsOrigin()
		unit.origFv = Vector(0,-1)
		table.insert(Arena.OutsideEntitiesTable, unit)
		table.insert(Arena.AllstarGuardTable, unit)
		local unit = Events:SpawnTownNPC(Vector(-2304, 4032), "arena_guard", Vector(0, -1), nil, nil, nil, 0.85, false, nil)
		unit.basePos = unit:GetAbsOrigin()
		unit.origFv = Vector(0,-1)
		table.insert(Arena.OutsideEntitiesTable, unit)
		table.insert(Arena.AllstarGuardTable, unit)
	end)
	Timers:CreateTimer(10, function()
		Arena:SpawnTrainingDummies()
	end)
end

function Arena:SpawnNewbeeLounge()
	local unit = Events:SpawnTownNPC(Vector(-10688, -1580), "champion_league_challenger_20", Vector(1, 0), nil, nil, nil, 1.0, true, "arena_challenger_20")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-10112, -2368), "champion_league_challenger_18", Vector(1, 1), nil, nil, nil, 1.0, true, "arena_challenger_18")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)
	Arena.Challenger18 = unit

	local unit = Events:SpawnTownNPC(Vector(-8906, -3328), "champion_league_challenger_17", Vector(-0.3, 1), nil, nil, nil, 1.0, true, "arena_challenger_17")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)
	-- Arena.Challenger17 = unit

	local unit = Events:SpawnTownNPC(Vector(-8000, -128), "champion_league_challenger_16", Vector(-0.3, 1), nil, nil, nil, 1.0, true, "arena_challenger_16")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	Arena:AddPatrolArguments(unit, 0, 4, 140, {Vector(-11420, -128), Vector(-8000, -128)})
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-10816, -3008), "champion_league_challenger_15", Vector(1, 0), nil, nil, nil, 1.0, true, "arena_challenger_15")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-8243, -1628), "champion_league_challenger_13", Vector(1, 0), nil, nil, nil, 1.0, true, "arena_challenger_13")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-8192, -448), "champion_league_challenger_12", Vector(-0.3, 1), nil, nil, nil, 1.0, true, "arena_challenger_12")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	Arena:AddPatrolArguments(unit, 5, 8, 140, {Vector(-9856, -448), Vector(-8192, -448)})
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-9472, -2818), "champion_league_challenger_11", Vector(-0.2, 1), nil, nil, nil, 1.0, true, "arena_challenger_11")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)
end

function Arena:SpawnMajorLeagueLounge()
	local unit = Events:SpawnTownNPC(Vector(-7640, 2591), "champion_league_challenger_10", Vector(1, -1), nil, nil, nil, 1.0, true, "arena_challenger_10")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-8832, 4160), "champion_league_challenger_9", Vector(1, -1), nil, nil, nil, 1.0, true, "arena_challenger_9")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	unit:SetAcquisitionRange(0)
	unit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-9547, 3578), "champion_league_challenger_8", Vector(1, 0.2), nil, nil, nil, 1.0, true, "arena_challenger_8")
	unit:SetRenderColor(67, 64, 47)
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-10112, 5312), "champion_league_challenger_7", Vector(1, -1), nil, nil, nil, 1.0, true, "arena_challenger_7")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local unit = Events:SpawnTownNPC(Vector(-3840, 2304), "champion_league_challenger_5", Vector(0, 1), nil, nil, nil, 1.0, true, "arena_challenger_5")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)
end

function Arena:SpawnAllStarLounge()
	local unit = Events:SpawnTownNPC(Vector(-2560, 5184), "champion_league_challenger_4", Vector(0, -1), nil, nil, nil, 1.0, true, "arena_challenger_4")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)

	local rubick1 = Events:SpawnTownNPC(Vector(-1984, 6208), "champion_league_challenger_3_a", Vector(0.2, -1), nil, nil, nil, 1.0, true, "arena_challenger_3")
	rubick1:SetDayTimeVisionRange(0)
	rubick1:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, rubick1)


	local rubick2 = Events:SpawnTownNPC(Vector(-2240, 6336), "champion_league_challenger_3_b", Vector(0, -1), nil, nil, nil, 1.0, true, "arena_challenger_3")
	rubick2:SetDayTimeVisionRange(0)
	rubick2:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, rubick2)
	rubick1.bro = rubick2
	rubick2.bro = rubick1

	local unit = Events:SpawnTownNPC(Vector(-3648, 5560), "champion_league_challenger_2", Vector(1, -1), nil, nil, nil, 1.0, true, "arena_challenger_2")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)
	unit:SetRenderColor(80, 80, 80)

	local unit = Events:SpawnTownNPC(Vector(-1600, 5193), "champion_league_challenger_1", Vector(-1, -0.4), nil, nil, nil, 1.0, true, "arena_challenger_1")
	unit:SetDayTimeVisionRange(0)
	unit:SetNightTimeVisionRange(0)
	table.insert(Arena.OutsideEntitiesTable, unit)
	-- Arena:ColorKingJette(unit)
end

function Arena:ColorKingJette(unit)
	for k, v in pairs(unit:GetChildren()) do 
		if v:GetClassname() == "dota_item_wearable" then
			v:SetRenderColor(200, 200, 20)
		end 
	end 
end

function Arena:AddPatrolArguments(unit, patrolSlow, phaseIntervals, patrolPointRandom, patrolPositionTable)
	unit:AddAbility("monster_patrol"):SetLevel(1)
	unit.patrolSlow = patrolSlow
	unit.phaseIntervals = phaseIntervals
	unit.patrolPointRandom = patrolPointRandom
	unit.patrolPositionTable = patrolPositionTable
end

function Arena:GenerateCrowd(size)
	Arena.Crowd = {}
	for i = 1, size, 1 do
		Timers:CreateTimer(i*0.3, function()
			local unitName, modelName, modelScale, cheerAnimation1 = Arena:GetRandomCrowdFan()
			local position, fv = Arena:GetCrowdPositionAndFV()
			local unit = Arena:CreateCrowdFan(position, unitName, fv, modelName, modelScale, cheerAnimation1, 1)
			table.insert(Arena.Crowd, unit)
		end)
	end
end

function Arena:GetRandomCrowdFan()
	local luck = RandomInt(1,17)
	local unitName = ""
	local modelName = ""
	local modelScale = 0
	local cheerAnimation1 = ""
	if luck == 1 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/bounty_hunter/bounty_hunter.vmdl"
		modelScale = 1.2
		cheerAnimation1 = ACT_DOTA_VICTORY
	elseif luck == 2 then
		unitName = "arena_crowd_fan"
		modelName = "models/courier/smeevil/smeevil.vmdl"
		modelScale = 1.5
		cheerAnimation1 = ACT_DOTA_IDLE_RARE
	elseif luck == 3 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/dark_seer/dark_seer.vmdl"
		modelScale = 0.9
		cheerAnimation1 = ACT_DOTA_VICTORY
	elseif luck == 4 then
		unitName = "arena_crowd_fan"
		modelName = "models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl"
		modelScale = 1.2
		cheerAnimation1 = ACT_DOTA_IDLE_RARE
	elseif luck == 5 then
		local luck2 = RandomInt(1,2)
		if luck2 == 1 then
			modelName = "models/items/wards/smeevil_ward/smeevil_ward_blue.vmdl"
		else
			modelName = "models/items/wards/smeevil_ward/smeevil_ward_green.vmdl"
		end
		unitName = "arena_crowd_fan"
		modelScale = 1.6
		cheerAnimation1 = ACT_DOTA_IDLE_RARE
	elseif luck == 6 then
		unitName = "arena_crowd_fan"
		modelName = "models/items/juggernaut/ward/fortunes_tout/fortunes_tout.vmdl"
		modelScale = 1.2
		cheerAnimation1 = ACT_DOTA_RUN
	elseif luck == 7 then
		unitName = "arena_crowd_fan"
		modelName = "models/courier/imp/imp.vmdl"
		modelScale = 1.2
		cheerAnimation1 = ACT_DOTA_IDLE_RARE
	elseif luck == 8 then
		unitName = "arena_crowd_fan"
		modelName = "models/items/courier/faceless_rex/faceless_rex.vmdl"
		modelScale = 1.3
		cheerAnimation1 = ACT_DOTA_RUN
	elseif luck == 9 then
		unitName = "arena_crowd_fan"
		modelName = "models/items/courier/vigilante_fox_green/vigilante_fox_green.vmdl"
		modelScale = 1.2
		cheerAnimation1 = ACT_DOTA_IDLE_RARE	
	elseif luck == 10 then
		unitName = "arena_crowd_fan"
		modelName = "models/items/courier/bucktooth_jerry/bucktooth_jerry.vmdl"
		modelScale = 1.2
		cheerAnimation1 = ACT_DOTA_IDLE_RARE
	elseif luck == 11 then
		unitName = "arena_crowd_fan"
		modelName = "models/items/courier/bearzky/bearzky.vmdl"
		modelScale = 1.2
		cheerAnimation1 = ACT_DOTA_RUN
	elseif luck == 12 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/brewmaster/brewmaster_firespirit.vmdl"
		modelScale = 1.0
		cheerAnimation1 = ACT_DOTA_RUN
	elseif luck == 13 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/bristleback/bristleback.vmdl"
		modelScale = 1.1
		cheerAnimation1 = ACT_DOTA_VICTORY
	elseif luck == 14 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/earthshaker/earthshaker.vmdl"
		modelScale = 1.0
		cheerAnimation1 = ACT_DOTA_VICTORY
	elseif luck == 15 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/furion/furion.vmdl"
		modelScale = 1.0
		cheerAnimation1 = ACT_DOTA_CAST_ABILITY_2
	elseif luck == 16 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/meepo/meepo.vmdl"
		modelScale = 1.0
		cheerAnimation1 = ACT_DOTA_VICTORY
	elseif luck == 17 then
		unitName = "arena_crowd_fan"
		modelName = "models/heroes/rikimaru/rikimaru.vmdl"
		modelScale = 1.0
		cheerAnimation1 = ACT_DOTA_VICTORY
	end
	
	return unitName, modelName, modelScale, cheerAnimation1
end

function Arena:CreateCrowdFan(position, unitName, fv, modelName, modelScale, cheerAnimation1, biasValue)
	local fan = CreateUnitByName(unitName, position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	fan:SetOriginalModel(modelName)
	fan:SetModel(modelName)
	fan:SetForwardVector(fv)
	fan:SetModelScale(modelScale)
	fan.cheerAnimation1 = cheerAnimation1
	fan:AddAbility("arena_crowd_ability"):SetLevel(1)
	fan:SetRenderColor(RandomInt(100,255), RandomInt(100,255), RandomInt(100,255))
	StartAnimation(fan, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
	return fan
end

function Arena:GetCrowdPositionAndFV()
	local quadrant = RandomInt(1,16)
	local position = Vector(0,0)
	local fv = Vector(0,0)
	if quadrant == 1 or quadrant == 2 then
		local randomX = RandomInt(-4224, -1576)
		local randomY = RandomInt(-5952, -5206)
		position = Vector(randomX, randomY)
		fv = Vector(0,1)
	elseif quadrant == 3 or quadrant == 4 then
		local basePos = Vector(-1320, -5910)
		local slope = Vector(1,1)
		local randomY = RandomInt(1, 900)
		local randomSlopeMult = RandomInt(1,2000)
		position = basePos+slope*randomSlopeMult+Vector(0,randomY)
		fv = Vector(-1,1)
	elseif quadrant == 5 then
		local randomX = RandomInt(128, 1055)
		local randomY = RandomInt(-3293, -2560)
		position = Vector(randomX, randomY)
		fv = Vector(-1,0)		
	elseif quadrant == 6 then
		local randomX = RandomInt(170, 1040)
		local randomY = RandomInt(-1856, -1120)
		position = Vector(randomX, randomY)
		fv = Vector(-1,0)
	elseif quadrant == 7 or quadrant == 8 then
		local basePos = Vector(128, -1152)
		local slope = Vector(-1,1)
		local randomX = RandomInt(1, 900)
		local randomSlopeMult = RandomInt(1,2000)
		position = basePos+slope*randomSlopeMult+Vector(randomX,0)
		fv = Vector(-1,-1)
	elseif quadrant == 9 then
		local randomX = RandomInt(-2304, -1344)
		local randomY = RandomInt(404, 1280)
		position = Vector(randomX, randomY)
		fv = Vector(0,-1)
	elseif quadrant == 10 then
		local randomX = RandomInt(-3968, -3072)
		local randomY = RandomInt(448, 1280)
		position = Vector(randomX, randomY)
		fv = Vector(0,-1)
	elseif quadrant == 11 or quadrant == 12 then
		local basePos = Vector(-5760, -1280)
		local slope = Vector(1,1)
		local randomY = RandomInt(1, 900)
		local randomSlopeMult = RandomInt(1,2000)
		position = basePos+slope*randomSlopeMult+Vector(0,randomY)
		fv = Vector(1,-1)
	elseif quadrant == 13 then
		local randomX = RandomInt(-6589, -5760)
		local randomY = RandomInt(-1891, -1408)
		position = Vector(randomX, randomY)
		fv = Vector(1,0)
	elseif quadrant == 14 then
		local randomX = RandomInt(-6592, -5824)
		local randomY = RandomInt(-3392, -2752)
		position = Vector(randomX, randomY)
		fv = Vector(1,0)
	elseif quadrant == 15 or quadrant == 16 then
		local basePos = Vector(-4416, -5950)
		local slope = Vector(-1,1)
		local randomY = RandomInt(1, 900)
		local randomSlopeMult = RandomInt(1,2000)
		position = basePos+slope*randomSlopeMult+Vector(0,randomY)
		fv = Vector(1,1)
	end
	return position, fv
end

function Arena:AnimateCheers()
	if Arena.Crowd then
		for i = 1, #Arena.Crowd, 1 do
			local fan = Arena.Crowd[i]
			StartAnimation(fan, {duration=4.5, activity=fan.cheerAnimation1, rate=1.0})
			Timers:CreateTimer(4.7, function()
				StartAnimation(fan, {duration=40, activity=ACT_DOTA_IDLE, rate=1.0})
			end)
		end
	end
end

function Arena:CreateShowCombatants()
	local fighter1 = Arena:CreateShowCombatant("dragon_knight", DOTA_TEAM_BADGUYS, Vector(-3072, -2432), Vector(1,0))
	local fighter2 = Arena:CreateShowCombatant("pudge", DOTA_TEAM_NEUTRALS, Vector(-2304, -2432), Vector(-1,0))
	fighter1.opponent = fighter2
	fighter2.opponent = fighter1
	fighter1.jumpAnimation = ACT_DOTA_CAST_ABILITY_1
	fighter2.jumpAnimation = ACT_DOTA_CAST_ABILITY_ROT
	Arena.fighter1 = fighter1
	Arena.fighter2 = fighter2
	table.insert(Arena.OutsideEntitiesTable, fighter1)
	table.insert(Arena.OutsideEntitiesTable, fighter2)
end

function Arena:CreateShowCombatant(fighter, team, position, fv)
	local fighterName = ""
	if fighter=="dragon_knight" then
		figherName = "arena_show_fighter_one"
	elseif fighter=="pudge" then
		figherName = "arena_show_fighter_two"
	end
	local fighter = CreateUnitByName(figherName, position, true, nil, nil, team)
	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, fighter, "modifier_arena_show_combatant", {})
	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, fighter, "modifier_combatant_ai", {})
	fighter:SetForwardVector(fv)
	local abilityCount = fighter:GetAbilityCount()
	for i = 1, abilityCount, 1 do
		local ability = fighter:GetAbilityByIndex(i-1)
		if ability then
			ability:SetLevel(1)
		end
	end
	return fighter
end

function Arena:GetCharacterArenaData(playerID, hero)
	if not hero.pit then
		hero.pit = {}
		hero.pit.pit_level = 0
	end
end

function Arena:SpawnChampionsCoach()
	Arena.Coach = CreateUnitByName("champions_league_assistant", Vector(-7237, -3072), true, nil, nil, DOTA_TEAM_GOODGUYS)
	Arena.Coach:SetForwardVector(Vector(-1,-1))
	Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, Arena.Coach, "modifier_champions_league_assistant_ai", {})
end



function Arena:basic_dialogue(caster, units, dialogueName, time, xOffset, yOffset)
	Quests:ShowDialogueText(units, caster, dialogueName, time, false)
end

function Arena:GetMithrilPrize(position, hero, mithrilReward)
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

function Arena:ArenaDialogue(msg)
	local accept = msg.accept
	local npc = msg.npc
	local intattr = msg.intattr
	local playerID = msg.playerID
	local hero = false
	if playerID then
		hero = GameState:GetHeroByPlayerID(playerID)
	end
	if msg.dummy then
		Quests:DummyFromClient(msg)
	end
	if accept == 0 then
	elseif accept == 1 then
		if npc == "champion_attendant" then
			if intattr == 1 then
				Arena:ChampionsLeagueFirstSignUp()
			end
		elseif npc == "arena_aquatarium_magician" then
			if Arena.WaterMagician.gameStart then
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
				return
			end
			if intattr == 0 then
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
				Arena:WaterGameStart(hero)
			end
		elseif npc == "arena_terminal" then
			if Arena.ChampionsLeague.battlePrep then
				return false
			end
			local rank = msg.rank
			print(rank)
			Arena:ChampionsLeagueRegisterForBattle(hero, rank)
		elseif npc == "pit_terminal" then
			Arena:PitSetup(hero, msg.starLevel)
		elseif npc == "skip" then
			Arena.skipIntro = 1
		elseif npc == "arena_pit_conquest_shrine_of_karzhun" then
			print("GO?")
			Arena:PitConquestKarzhun(hero)
			CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})	
		end
	end
end

function Arena:DummyFromClient(playerID, hero, msg)
	if msg.exit then
		local dummy = hero.targetDummy
		hero:RemoveModifierByName("modifier_attacking_dummy")
		dummy:RemoveModifierByName("modifier_dummy_active")
	elseif msg.timer then
		local dummy = hero.targetDummy
		local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
		dummyAbility:ApplyDataDrivenModifier(dummy, hero, "modifier_dummy_timer", {duration = 7})
		dummy.timerDamage = 0
		print("DUMMY TIMER START")
		for i = 1, 35, 1 do
			Timers:CreateTimer(i*0.2, function()
				local DPS = math.floor(dummy.timerDamage/(i*0.2))
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "updateDPSLabel", {dps = DPS})
			end)
		end
	elseif msg.armor then
		print("UPDATE ARMOR")
		print(msg.armor)
		local dummy = hero.targetDummy
		dummy:SetPhysicalArmorBaseValue(tonumber(msg.armor))
	end
end

function Arena:SpawnChampionsLeagueEnemy(unit_name, location, fv, damageAdjust, healthAdjust, damageReduc)
  local unit = CreateUnitByName(unit_name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
  unit:SetForwardVector(fv)
  Events:AdjustDeathXP(unit)
  Events:AdjustBossPower(unit, damageAdjust, healthAdjust)
  unit.damageReduc = damageReduc
  Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, unit, "modifier_arena_enemy", {})
  local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
  gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_command_restric_player", {duration = 10})
  return unit
end

function Arena:SpawnTrainingDummies()
	local positionTable = {Vector(576, -4856), Vector(854, -4587), Vector(1139, -4267), Vector(1450, -3974)}
	for i =1, #positionTable, 1 do
		local dummy = CreateUnitByName("arena_training_dummy", positionTable[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		dummy:SetForwardVector(Vector(1,-1))
		dummy.targetPosition = dummy:GetAbsOrigin()
		dummy.pushLock = true
		-- AddFOWViewer(DOTA_TEAM_GOODGUYS, dummy.targetPosition, 500, 4, false)
		Timers:CreateTimer(6, function()
			-- if IsValidEntity(dummy) then
			-- 	local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
			-- 	dummyAbility:ApplyDataDrivenModifier(dummy, dummy, "modifier_dummy_freeze", {})
			-- end
		end)
		table.insert(Arena.OutsideEntitiesTable, dummy)
	end
	
end

function Arena:RollPrizebox(rank, score, hero)
	local baseLevel = 0
	local rarity = "uncommon"
	if rank >= 16 then
		baseLevel = 1
	elseif rank >= 11 then
		baseLevel = 10
	elseif rank >= 6 then
		baseLevel = 30
	else
		baseLevel = 60
	end
	local scoreBonus = math.floor(score/8)
	local itemLevel = baseLevel + scoreBonus
	local prizeLevel = RPCItems:GetLogarithmicVarianceValue(itemLevel, 0, 0, 0, 0)
	if GameState:GetPlayerPremiumStatus(hero:GetPlayerOwnerID()) then
		prizeLevel = math.ceil(prizeLevel*1.35)
	end
	if prizeLevel > 40 and prizeLevel < 120 then
		rarity = "rare"
	elseif prizeLevel >= 120 then
		rarity = "mythical"
	end
    local item = RPCItems:CreateVariantWithMin("item_rpc_arena_prizebox", rarity, "Prizebox", false, false, "Consumable", 0, nil, nil)
    item.property1 = prizeLevel
    item.property1name = "prize_level"
    RPCItems:SetPropertyValues(item, item.property1, "#arena_prizebox_level", "#D1D1D1",  1) 
    Arena:RollPrizeBoxProperty2(item, prizeLevel)
    if rarity == "rare" or rarity == "mythical" then
    	Arena:RollPrizeBoxProperty3(item, prizeLevel)
    end
    if rarity == "mythical" then
    	Arena:RollPrizeBoxProperty4(item, prizeLevel)
    end

    RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
end

function Arena:RollPrizeBoxProperty2(item, itemLevel)
	local luck = RandomInt(1,itemLevel)
	local qualities = "rare"
	if luck >= 10 then
		qualities = "mythical"
	end
	if luck >= 25 then
		qualities = "immortal"
	end
	local quantity = math.min(RandomInt(1, itemLevel/30), 2)
	item.property2 = quantity
	item.property2name = qualities
	RPCItems:SetPropertyValues(item, item.property2, "#item_rarity_"..qualities, RPCItems:GetRarityColor(qualities),  2) 
end

function Arena:RollPrizeBoxProperty3(item, itemLevel)
	local luck = RandomInt(1,itemLevel)
	local qualities = "rare"
	if luck >= 30 then
		qualities = "mythical"
	end
	if luck >= 69 then
		qualities = "immortal"
	end
	if luck >= 20 and luck <= 28 then
		item.property3 = RandomInt(140, 140+itemLevel)
		item.property3name = "arcane_crystals"
		RPCItems:SetPropertyValues(item, item.property3, "#tooltip_arcane_crystals", "#C363D4",  3) 
		return
	end
	local quantity = math.min(RandomInt(1, itemLevel/30), 3)
	item.property3 = quantity
	item.property3name = qualities
	RPCItems:SetPropertyValues(item, item.property3, "#item_rarity_"..qualities, RPCItems:GetRarityColor(qualities),  3) 
end

function Arena:RollPrizeBoxProperty4(item, itemLevel)
	local luck = RandomInt(1,itemLevel)
	local qualities = "rare"
	if luck >= 30 then
		qualities = "mythical"
	end
	if luck >= 82 then
		qualities = "immortal"
	end
	if luck >= 20 and luck <= 29 then
		item.property4 = RandomInt(200, 260+itemLevel)
		item.property4name = "arcane_crystals"
		RPCItems:SetPropertyValues(item, item.property4, "#tooltip_arcane_crystals", "#C363D4",  4) 
		return
	end
	if luck >= 88 and luck <= 102 then
		item.property4 = 1
		item.property4name = "champions_gear"
		RPCItems:SetPropertyValues(item, item.property4, "#arena_prizebox_champions", "#D11D59",  4) 
		return
	end
	local quantity = math.min(RandomInt(1, itemLevel/30), 5)
	item.property4 = quantity
	item.property4name = qualities
	RPCItems:SetPropertyValues(item, item.property4, "#item_rarity_"..qualities, RPCItems:GetRarityColor(qualities),  4) 
end

function Arena:SaveChampionsLeagueData(hero, battleRank, score)
	local steamID = PlayerResource:GetSteamAccountID(hero:GetPlayerOwnerID())
	local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
	local url = ROSHPIT_URL.."/champions/updateChampionsLeague?"
	if hero.roshpitID == nil then
		return
	end
	--SaveLoad:NewKey()
	url = url.."steam_id="..steamID
	url = url.."&hero_id="..hero.roshpitID
	url = url.."&rank="..battleRank
	url = url.."&score="..score
	url = url.."&hero_name="..hero:GetUnitName()
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	if Arena:DetermineIfSaveIsNecessary(hero, battleRank, score) then
		CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
			--SaveLoad:NewKey()
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			Timers:CreateTimer(16, function()
				Arena:LoadChampionsLeagueData(hero, resultTable)
			end)
		end )	
	end
end

function Arena:ResetArenaData(hero)
	local steamID = PlayerResource:GetSteamAccountID(hero:GetPlayerOwnerID())
	local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
	url = url.."steam_id="..steamID
	url = url.."&hero_id="..hero.roshpitID
	url = url.."&hero_name="..hero:GetUnitName()
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		Timers:CreateTimer(8, function()
			Arena:LoadChampionsLeagueData(hero, resultTable)
		end)
	end )
end

function Arena:LoadChampionsLeagueData(hero, results)
	if results then
		if results == 0 then
			return
		end
		print("LOAD CHAMP LEAGUE DATA")
		if results.hero_name then
			if not results.hero_name == hero:GetUnitName() then
				if results.hero_name == "" then
					Arena:SaveChampionsLeagueData(hero, results.champions_league_rank, 0)
				else
					Arena:ResetArenaData(hero)
					return false
				end
			end
		end
		hero.ChampionsLeague = {}
		hero.ChampionsLeague.rank = results.champions_league_rank
		hero.ChampionsLeague.score1 = results.score1
		hero.ChampionsLeague.score2 = results.score2
		hero.ChampionsLeague.score3 = results.score3
		hero.ChampionsLeague.score4 = results.score4
		hero.ChampionsLeague.score5 = results.score5
		hero.ChampionsLeague.score6 = results.score6
		hero.ChampionsLeague.score7 = results.score7
		hero.ChampionsLeague.score8 = results.score8
		hero.ChampionsLeague.score9 = results.score9
		hero.ChampionsLeague.score10 = results.score10
		hero.ChampionsLeague.score11 = results.score11
		hero.ChampionsLeague.score12 = results.score12
		hero.ChampionsLeague.score13 = results.score13
		hero.ChampionsLeague.score14 = results.score14
		hero.ChampionsLeague.score15 = results.score15
		hero.ChampionsLeague.score16 = results.score16
		hero.ChampionsLeague.score17 = results.score17
		hero.ChampionsLeague.score18 = results.score18
		hero.ChampionsLeague.score19 = results.score19
		hero.ChampionsLeague.score20 = results.score20
		if not hero.pit then
			hero.pit = {}
		end
		hero.pit.pit_level = results.pit_level
		print(results.pit_open_time)
		hero.pit.pit_open_time = results.pit_open_time
		Arena:SetUpArenaForChampionsLeagueRank(hero.ChampionsLeague.rank)
		print("BEFORE STAR CHECK")
		Timers:CreateTimer(7, function()
			Stars:StarEventPlayer("champleague", hero)
		end)

	else
		local url = ROSHPIT_URL.."/champions/loadChampionArena?"
		if hero.roshpitID == nil then
			return
		end
		url = url.."hero_id="..hero.roshpitID
		CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			Arena:LoadChampionsLeagueData(hero, resultTable)
		end )	

	end
end

function Arena:DetermineIfSaveIsNecessary(hero, battleRank, score)
	if battleRank < hero.ChampionsLeague.rank then
		return true
	end
	if Arena:GetScoreForRank(hero, battleRank) < score then
		return true
	end
	return false
end

function Arena:GetScoreForRank(hero, battleRank)
	local ChampionsLeague = hero.ChampionsLeague
	if battleRank == 20 then
		return ChampionsLeague.score20
	elseif battleRank == 19 then
		return ChampionsLeague.score19
	elseif battleRank == 18 then
		return ChampionsLeague.score18
	elseif battleRank == 17 then
		return ChampionsLeague.score17
	elseif battleRank == 16 then
		return ChampionsLeague.score16
	elseif battleRank == 15 then
		return ChampionsLeague.score15
	elseif battleRank == 14 then
		return ChampionsLeague.score14
	elseif battleRank == 13 then
		return ChampionsLeague.score13
	elseif battleRank == 12 then
		return ChampionsLeague.score12
	elseif battleRank == 11 then
		return ChampionsLeague.score11
	elseif battleRank == 10 then
		return ChampionsLeague.score10
	elseif battleRank == 9 then
		return ChampionsLeague.score9
	elseif battleRank == 8 then
		return ChampionsLeague.score8
	elseif battleRank == 7 then
		return ChampionsLeague.score7
	elseif battleRank == 6 then
		return ChampionsLeague.score6
	elseif battleRank == 5 then
		return ChampionsLeague.score5
	elseif battleRank == 4 then
		return ChampionsLeague.score4
	elseif battleRank == 3 then
		return ChampionsLeague.score3
	elseif battleRank == 2 then
		return ChampionsLeague.score2
	elseif battleRank == 1 then
		return ChampionsLeague.score1
	end
end
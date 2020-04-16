function Winterblight:OpenWinterblightCastle()
	if not Winterblight.WinterCastleOpened then
		Precache:WinterCastle()
		Winterblight:SetupCastleData()
		Precache:WinterPart3()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].bgm = "Music.Winterblight.BlackfrostCitadel"
		end
		Winterblight:CastleMusic()
		Winterblight.WinterCastleOpened = true
		local walls = Entities:FindAllByNameWithin("MainCastleDoor", Vector(10757, 13568, 1319 + Winterblight.ZFLOAT), 2400)
		-- local key1 = Entities:FindByNameNearest("CastleDoorKey1", Vector(10699, 13819, 1615), 1000)
		-- local key2 = Entities:FindByNameNearest("CastleDoorKey2", Vector(10699, 13606, 1615), 1000)
		-- local key3 = Entities:FindByNameNearest("CastleDoorKey3", Vector(10699, 13402, 1615), 1000)
		-- table.insert(walls, key1)
		-- table.insert(walls, key2)
		-- table.insert(walls, key3)
		EmitSoundOnLocationWithCaster(Vector(10757, 13568, 1319 + Winterblight.ZFLOAT), "Winterblight.WallOpen", Events.GameMaster)
		Winterblight:WallsTicks(false, walls, true, 5, 360, 0.15)
		Winterblight:RemoveBlockers(4, "WinterCastleEntranceBlockers", Vector(10757, 13568, 1319 + Winterblight.ZFLOAT), 1400)
		Timers:CreateTimer(1, function()
			EmitGlobalSound("Winterblight.OpenDungeon")
		end)
		Events:DoorDust(Vector(10752, 13952), Vector(10752, 13352), 60, 0.2)

		-- MAKE DELAY 9s WHEN DONE TESTING
		Timers:CreateTimer(1, function()
			local spawnPosition = Vector(11818, 14419)
			local wraith = Enemies:SpawnEnemyUnit("winterblight_diviner_horus", spawnPosition, Vector(0,-1), false)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", wraith:GetAbsOrigin(), 3)
			EmitSoundOn("Winterblight.GraveGhostSpawn", wraith)
			AddFOWViewer(DOTA_TEAM_GOODGUYS, wraith:GetAbsOrigin(), 500, 5, false)
			wraith.phase = 0
			Winterblight.CastleDungeonMaster = wraith
			-- Winterblight:OpenCastleDoorByIndex(2)
			-- Winterblight:OpenCastleDoorByIndex(3)
			-- Winterblight:OpenCastleDoorByIndex(4)
			-- Winterblight:OpenCastleDoorByIndex(5)
			-- Winterblight:OpenCastleDoorByIndex(6)
			-- Winterblight:OpenCastleDoorByIndex(7)
			-- Winterblight:OpenCastleDoorByIndex(8)
			-- Winterblight:OpenCastleDoorByIndex(9)
			-- Winterblight:OpenCastleDoorByIndex(10)
			-- Winterblight:OpenCastleDoorByIndex(11)
			-- Winterblight:OpenCastleDoorByIndex(12)
			-- Winterblight:OpenCastleDoorByIndex(13)
		end)
		Dungeons.respawnPoint = Vector(11812, 13652)

	end
end

function Winterblight:SetupCastleData()
		Winterblight.CASTLE_DATA = {}

		Winterblight.CASTLE_DATA["rooms_cleared"] = 0
		-- TAROT
		Winterblight.CASTLE_DATA["tarot"] = {}
		Winterblight.CASTLE_DATA["tarot"][1] = {}
		Winterblight.CASTLE_DATA["tarot"][1]["name"] = "fool"
		Winterblight.CASTLE_DATA["tarot"][1]["index"] = "00"
		Winterblight.CASTLE_DATA["tarot"][1]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][1]["prop_scale"] = 0.88
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][1] = {index = 3, variant = 1}
		-- Winterblight.CASTLE_DATA["tarot"][1]["rooms"][2] = {index = 3, variant = 1}
		-- Winterblight.CASTLE_DATA["tarot"][1]["rooms"][3] = {index = 9, variant = 1}
		-- Winterblight.CASTLE_DATA["tarot"][1]["rooms"][4] = {index = 7, variant = 1}
		-- Winterblight.CASTLE_DATA["tarot"][1]["rooms"][5] = {index = 6, variant = 1}
		-- Winterblight.CASTLE_DATA["tarot"][1]["rooms"][6] = {index = 5, variant = 1}
		-- Winterblight.CASTLE_DATA["tarot"][1]["rooms"][7] = {index = 4, variant = 1}
		-- Winterblight.CASTLE_DATA["tarot"][1]["rooms"][8] = {index = 3, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][2] = {}
		Winterblight.CASTLE_DATA["tarot"][2]["name"] = "magician"
		Winterblight.CASTLE_DATA["tarot"][2]["index"] = "01"
		Winterblight.CASTLE_DATA["tarot"][2]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][2]["prop_scale"] = 0.5

		Winterblight.CASTLE_DATA["tarot"][3] = {}
		Winterblight.CASTLE_DATA["tarot"][3]["name"] = "high_priestess"
		Winterblight.CASTLE_DATA["tarot"][3]["index"] = "02"
		Winterblight.CASTLE_DATA["tarot"][3]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][3]["prop_scale"] = 0.95

		Winterblight.CASTLE_DATA["tarot"][4] = {}
		Winterblight.CASTLE_DATA["tarot"][4]["name"] = "empress"
		Winterblight.CASTLE_DATA["tarot"][4]["index"] = "03"
		Winterblight.CASTLE_DATA["tarot"][4]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][4]["prop_scale"] = 0.85

		Winterblight.CASTLE_DATA["tarot"][5] = {}
		Winterblight.CASTLE_DATA["tarot"][5]["name"] = "emperor"
		Winterblight.CASTLE_DATA["tarot"][5]["index"] = "04"
		Winterblight.CASTLE_DATA["tarot"][5]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][5]["prop_scale"] = 0.85

		Winterblight.CASTLE_DATA["tarot"][6] = {}
		Winterblight.CASTLE_DATA["tarot"][6]["name"] = "hierophant"
		Winterblight.CASTLE_DATA["tarot"][6]["index"] = "05"
		Winterblight.CASTLE_DATA["tarot"][6]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][6]["prop_scale"] = 0.62

		Winterblight.CASTLE_DATA["tarot"][7] = {}
		Winterblight.CASTLE_DATA["tarot"][7]["name"] = "lovers"
		Winterblight.CASTLE_DATA["tarot"][7]["index"] = "06"
		Winterblight.CASTLE_DATA["tarot"][7]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][7]["prop_scale"] = 1.02

		Winterblight.CASTLE_DATA["tarot"][8] = {}
		Winterblight.CASTLE_DATA["tarot"][8]["name"] = "chariot"
		Winterblight.CASTLE_DATA["tarot"][8]["index"] = "07"
		Winterblight.CASTLE_DATA["tarot"][8]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][8]["prop_scale"] = 0.7

		Winterblight.CASTLE_DATA["tarot"][9] = {}
		Winterblight.CASTLE_DATA["tarot"][9]["name"] = "strength"
		Winterblight.CASTLE_DATA["tarot"][9]["index"] = "08"
		Winterblight.CASTLE_DATA["tarot"][9]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][9]["prop_scale"] = 0.95

		Winterblight.CASTLE_DATA["tarot"][10] = {}
		Winterblight.CASTLE_DATA["tarot"][10]["name"] = "hermit"
		Winterblight.CASTLE_DATA["tarot"][10]["index"] = "09"
		Winterblight.CASTLE_DATA["tarot"][10]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][10]["prop_scale"] = 0.95

		Winterblight.CASTLE_DATA["tarot"][11] = {}
		Winterblight.CASTLE_DATA["tarot"][11]["name"] = "wheel_of_fortune"
		Winterblight.CASTLE_DATA["tarot"][11]["index"] = "10"
		Winterblight.CASTLE_DATA["tarot"][11]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][11]["prop_scale"] = 0.85

		Winterblight.CASTLE_DATA["tarot"][12] = {}
		Winterblight.CASTLE_DATA["tarot"][12]["name"] = "justice"
		Winterblight.CASTLE_DATA["tarot"][12]["index"] = "11"
		Winterblight.CASTLE_DATA["tarot"][12]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][12]["prop_scale"] = 0.85

		Winterblight.CASTLE_DATA["tarot"][13] = {}
		Winterblight.CASTLE_DATA["tarot"][13]["name"] = "hanged_man"
		Winterblight.CASTLE_DATA["tarot"][13]["index"] = "12"
		Winterblight.CASTLE_DATA["tarot"][13]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][13]["prop_scale"] = 0.92

		Winterblight.CASTLE_DATA["tarot"][14] = {}
		Winterblight.CASTLE_DATA["tarot"][14]["name"] = "death"
		Winterblight.CASTLE_DATA["tarot"][14]["index"] = "13"
		Winterblight.CASTLE_DATA["tarot"][14]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][14]["prop_scale"] = 0.6
		Winterblight.CASTLE_DATA["tarot"][14]["horror"] = true

		Winterblight.CASTLE_DATA["tarot"][15] = {}
		Winterblight.CASTLE_DATA["tarot"][15]["name"] = "temperance"
		Winterblight.CASTLE_DATA["tarot"][15]["index"] = "14"
		Winterblight.CASTLE_DATA["tarot"][15]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][15]["prop_scale"] = 0.9

		Winterblight.CASTLE_DATA["tarot"][16] = {}
		Winterblight.CASTLE_DATA["tarot"][16]["name"] = "devil"
		Winterblight.CASTLE_DATA["tarot"][16]["index"] = "15"
		Winterblight.CASTLE_DATA["tarot"][16]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][16]["prop_scale"] = 0.66
		Winterblight.CASTLE_DATA["tarot"][16]["horror"] = true

		Winterblight.CASTLE_DATA["tarot"][17] = {}
		Winterblight.CASTLE_DATA["tarot"][17]["name"] = "tower"
		Winterblight.CASTLE_DATA["tarot"][17]["index"] = "16"
		Winterblight.CASTLE_DATA["tarot"][17]["prop_angle"] = Vector(0, 1)
		Winterblight.CASTLE_DATA["tarot"][17]["prop_scale"] = 0.73
		Winterblight.CASTLE_DATA["tarot"][17]["horror"] = true

		Winterblight.CASTLE_DATA["tarot"][18] = {}
		Winterblight.CASTLE_DATA["tarot"][18]["name"] = "star"
		Winterblight.CASTLE_DATA["tarot"][18]["index"] = "17"
		Winterblight.CASTLE_DATA["tarot"][18]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][18]["prop_scale"] = 1.0

		Winterblight.CASTLE_DATA["tarot"][19] = {}
		Winterblight.CASTLE_DATA["tarot"][19]["name"] = "moon"
		Winterblight.CASTLE_DATA["tarot"][19]["index"] = "18"
		Winterblight.CASTLE_DATA["tarot"][19]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][19]["prop_scale"] = 0.9

		Winterblight.CASTLE_DATA["tarot"][20] = {}
		Winterblight.CASTLE_DATA["tarot"][20]["name"] = "sun"
		Winterblight.CASTLE_DATA["tarot"][20]["index"] = "19"
		Winterblight.CASTLE_DATA["tarot"][20]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][20]["prop_scale"] = 0.45

		Winterblight.CASTLE_DATA["tarot"][21] = {}
		Winterblight.CASTLE_DATA["tarot"][21]["name"] = "judgement"
		Winterblight.CASTLE_DATA["tarot"][21]["index"] = "20"
		Winterblight.CASTLE_DATA["tarot"][21]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][21]["prop_scale"] = 0.84

		Winterblight.CASTLE_DATA["tarot"][22] = {}
		Winterblight.CASTLE_DATA["tarot"][22]["name"] = "world"
		Winterblight.CASTLE_DATA["tarot"][22]["index"] = "21"
		Winterblight.CASTLE_DATA["tarot"][22]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][22]["prop_scale"] = 0.87
		-- DOORS
		Winterblight.CASTLE_DATA["doors"] = {}
		Winterblight.CASTLE_DATA["doors"][1] = {}
		Winterblight.CASTLE_DATA["doors"][1]["position"] = Vector(12899, 13560, 1540)
		Winterblight.CASTLE_DATA["doors"][1]["name"] = "CastleWall0"
		Winterblight.CASTLE_DATA["doors"][1]["dust_start_position"] = Vector(12895, 13824)
		Winterblight.CASTLE_DATA["doors"][1]["dust_end_position"] =  Vector(12895, 13312)
		Winterblight.CASTLE_DATA["doors"][1]["blockers"] = "CastleWall0Blocker"

		Winterblight.CASTLE_DATA["doors"][2] = {}
		Winterblight.CASTLE_DATA["doors"][2]["position"] = Vector(13699, 14584, 1520)
		Winterblight.CASTLE_DATA["doors"][2]["name"] = "CastleWall1"
		Winterblight.CASTLE_DATA["doors"][2]["dust_start_position"] = Vector(13548, 14592)
		Winterblight.CASTLE_DATA["doors"][2]["dust_end_position"] =  Vector(13850, 14592)
		Winterblight.CASTLE_DATA["doors"][2]["blockers"] = "CastleWall1Blocker"

		Winterblight.CASTLE_DATA["doors"][3] = {}
		Winterblight.CASTLE_DATA["doors"][3]["position"] = Vector(15470, 14584, 1540)
		Winterblight.CASTLE_DATA["doors"][3]["name"] = "CastleWall2"
		Winterblight.CASTLE_DATA["doors"][3]["dust_start_position"] = Vector(15226, 14592)
		Winterblight.CASTLE_DATA["doors"][3]["dust_end_position"] =  Vector(15726, 14592)
		Winterblight.CASTLE_DATA["doors"][3]["blockers"] = "CastleWall2Blocker"

		Winterblight.CASTLE_DATA["doors"][4] = {}
		Winterblight.CASTLE_DATA["doors"][4]["position"] = Vector(12890, 10660, 1540)
		Winterblight.CASTLE_DATA["doors"][4]["name"] = "CastleWall3"
		Winterblight.CASTLE_DATA["doors"][4]["dust_start_position"] = Vector(12895, 10368)
		Winterblight.CASTLE_DATA["doors"][4]["dust_end_position"] =  Vector(12895, 11008)
		Winterblight.CASTLE_DATA["doors"][4]["blockers"] = "CastleWall3Blocker"

		Winterblight.CASTLE_DATA["doors"][5] = {}
		Winterblight.CASTLE_DATA["doors"][5]["position"] = Vector(15449, 9195, 1550)
		Winterblight.CASTLE_DATA["doors"][5]["name"] = "CastleWall4"
		Winterblight.CASTLE_DATA["doors"][5]["dust_start_position"] = Vector(15219, 9421)
		Winterblight.CASTLE_DATA["doors"][5]["dust_end_position"] =  Vector(15701, 8876)
		Winterblight.CASTLE_DATA["doors"][5]["blockers"] = "CastleWall4Blocker"

		Winterblight.CASTLE_DATA["doors"][6] = {}
		Winterblight.CASTLE_DATA["doors"][6]["position"] = Vector(11429, 7645, 1660)
		Winterblight.CASTLE_DATA["doors"][6]["name"] = "CastleWall5"
		Winterblight.CASTLE_DATA["doors"][6]["dust_start_position"] = Vector(11449, 7339)
		Winterblight.CASTLE_DATA["doors"][6]["dust_end_position"] =  Vector(11449, 7940)
		Winterblight.CASTLE_DATA["doors"][6]["blockers"] = "CastleWall5Blocker"

		Winterblight.CASTLE_DATA["doors"][7] = {}
		Winterblight.CASTLE_DATA["doors"][7]["position"] = Vector(13005, 5753, 2000)
		Winterblight.CASTLE_DATA["doors"][7]["name"] = "CastleWall6"
		Winterblight.CASTLE_DATA["doors"][7]["dust_start_position"] = Vector(13007, 6061)
		Winterblight.CASTLE_DATA["doors"][7]["dust_end_position"] =  Vector(13007, 5453)
		Winterblight.CASTLE_DATA["doors"][7]["blockers"] = "CastleWall6Blocker"

		Winterblight.CASTLE_DATA["doors"][8] = {}
		Winterblight.CASTLE_DATA["doors"][8]["position"] = Vector(10945, 3162, 2000)
		Winterblight.CASTLE_DATA["doors"][8]["name"] = "CastleWall7"
		Winterblight.CASTLE_DATA["doors"][8]["dust_start_position"] = Vector(10624, 3113)
		Winterblight.CASTLE_DATA["doors"][8]["dust_end_position"] =  Vector(11224, 3113)
		Winterblight.CASTLE_DATA["doors"][8]["blockers"] = "CastleWall7Blocker"

		Winterblight.CASTLE_DATA["doors"][9] = {}
		Winterblight.CASTLE_DATA["doors"][9]["position"] = Vector(13978, 2662, 2000)
		Winterblight.CASTLE_DATA["doors"][9]["name"] = "CastleWall8"
		Winterblight.CASTLE_DATA["doors"][9]["dust_start_position"] = Vector(13937, 2976)
		Winterblight.CASTLE_DATA["doors"][9]["dust_end_position"] =  Vector(13937, 2376)
		Winterblight.CASTLE_DATA["doors"][9]["blockers"] = "CastleWall8Blocker"

		Winterblight.CASTLE_DATA["doors"][10] = {}
		Winterblight.CASTLE_DATA["doors"][10]["position"] = Vector(9455, 988, 2000)
		Winterblight.CASTLE_DATA["doors"][10]["name"] = "CastleWall9"
		Winterblight.CASTLE_DATA["doors"][10]["dust_start_position"] = Vector(9216, 1024)
		Winterblight.CASTLE_DATA["doors"][10]["dust_end_position"] =  Vector(9728, 1024)
		Winterblight.CASTLE_DATA["doors"][10]["blockers"] = "CastleWall9Blocker"

		Winterblight.CASTLE_DATA["doors"][11] = {}
		Winterblight.CASTLE_DATA["doors"][11]["position"] = Vector(11645, -1625, 2000)
		Winterblight.CASTLE_DATA["doors"][11]["name"] = "CastleWall10"
		Winterblight.CASTLE_DATA["doors"][11]["dust_start_position"] = Vector(11422, -1670)
		Winterblight.CASTLE_DATA["doors"][11]["dust_end_position"] =  Vector(11904, -1670)
		Winterblight.CASTLE_DATA["doors"][11]["blockers"] = "CastleWall10Blocker"

		Winterblight.CASTLE_DATA["doors"][12] = {}
		Winterblight.CASTLE_DATA["doors"][12]["position"] = Vector(12960, -1625, 2000)
		Winterblight.CASTLE_DATA["doors"][12]["name"] = "CastleWall11"
		Winterblight.CASTLE_DATA["doors"][12]["dust_start_position"] = Vector(12672, -1670)
		Winterblight.CASTLE_DATA["doors"][12]["dust_end_position"] =  Vector(13184, -1670)
		Winterblight.CASTLE_DATA["doors"][12]["blockers"] = "CastleWall11Blocker"

		Winterblight.CASTLE_DATA["doors"][13] = {}
		Winterblight.CASTLE_DATA["doors"][13]["position"] = Vector(14204, 13, 2000)
		Winterblight.CASTLE_DATA["doors"][13]["name"] = "CastleWall12"
		Winterblight.CASTLE_DATA["doors"][13]["dust_start_position"] = Vector(14208, 200)
		Winterblight.CASTLE_DATA["doors"][13]["dust_end_position"] =  Vector(14208, -200)
		Winterblight.CASTLE_DATA["doors"][13]["blockers"] = "CastleWall12Blocker"

		-- ROOMS
		Winterblight.CASTLE_DATA["rooms"] = {}

		-- graveyard
		Winterblight.CASTLE_DATA["rooms"][1] = {}
		Winterblight.CASTLE_DATA["rooms"][1]["door_index"] = 2
		Winterblight.CASTLE_DATA["rooms"][1]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][1]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][1]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][1]["extra_goal"] = 9
		Winterblight.CASTLE_DATA["rooms"][1]["key_positions"] = {Vector(11264,15232), Vector(12544, 15232)}
		Winterblight.CASTLE_DATA["rooms"][1]["cleared"] = 0

		-- cellar
		Winterblight.CASTLE_DATA["rooms"][2] = {}
		Winterblight.CASTLE_DATA["rooms"][2]["door_index"] = 3
		Winterblight.CASTLE_DATA["rooms"][2]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["extra_goal"] = 30
		Winterblight.CASTLE_DATA["rooms"][2]["key_positions"] = {Vector(15488,16000), Vector(15440, 15307)}
		Winterblight.CASTLE_DATA["rooms"][2]["cleared"] = 0

		-- ice_harbor
		Winterblight.CASTLE_DATA["rooms"][3] = {}
		Winterblight.CASTLE_DATA["rooms"][3]["door_index"] = 4
		Winterblight.CASTLE_DATA["rooms"][3]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["key_positions"] = {Vector(11859,11682), Vector(11859, 10667), Vector(11628, 9898)}
		Winterblight.CASTLE_DATA["rooms"][3]["cleared"] = 0

		-- torture_chamber
		Winterblight.CASTLE_DATA["rooms"][4] = {}
		Winterblight.CASTLE_DATA["rooms"][4]["door_index"] = 5
		Winterblight.CASTLE_DATA["rooms"][4]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][4]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][4]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][4]["extra_goal"] = 25
		Winterblight.CASTLE_DATA["rooms"][4]["key_positions"] = {Vector(15784, 10496), Vector(15304, 11008), Vector(15304, 11392), Vector(15304, 11776)}
		Winterblight.CASTLE_DATA["rooms"][4]["cleared"] = 0

		-- mouldy_burial_chamber
		Winterblight.CASTLE_DATA["rooms"][5] = {}
		Winterblight.CASTLE_DATA["rooms"][5]["door_index"] = 6
		Winterblight.CASTLE_DATA["rooms"][5]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["key_positions"] = {Vector(10624, 6609), Vector(10624, 7212), Vector(10578, 8030)}
		Winterblight.CASTLE_DATA["rooms"][5]["cleared"] = 0

		-- lookout
		Winterblight.CASTLE_DATA["rooms"][6] = {}
		Winterblight.CASTLE_DATA["rooms"][6]["door_index"] = 7
		Winterblight.CASTLE_DATA["rooms"][6]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["key_positions"] = {Vector(15646, 5704), Vector(15410, 7380), Vector(16000, 4224)}
		Winterblight.CASTLE_DATA["rooms"][6]["cleared"] = 0

		-- slime_chamber
		Winterblight.CASTLE_DATA["rooms"][7] = {}
		Winterblight.CASTLE_DATA["rooms"][7]["door_index"] = 8
		Winterblight.CASTLE_DATA["rooms"][7]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["key_positions"] = {Vector(10837, 5609), Vector(9492, 5446), Vector(8960, 3660)}
		Winterblight.CASTLE_DATA["rooms"][7]["cleared"] = 0

		-- weapons_cache
		Winterblight.CASTLE_DATA["rooms"][8] = {}
		Winterblight.CASTLE_DATA["rooms"][8]["door_index"] = 9
		Winterblight.CASTLE_DATA["rooms"][8]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][8]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][8]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][8]["extra_goal"] = 24
		Winterblight.CASTLE_DATA["rooms"][8]["key_positions"] = {Vector(15669, 1024), Vector(15120, 1870), Vector(14413, 1965)}
		Winterblight.CASTLE_DATA["rooms"][8]["cleared"] = 0

		-- freezer
		Winterblight.CASTLE_DATA["rooms"][9] = {}
		Winterblight.CASTLE_DATA["rooms"][9]["door_index"] = 10
		Winterblight.CASTLE_DATA["rooms"][9]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["key_positions"] = {Vector(9412, -13), Vector(9412, -640), Vector(9088, -1152)}
		Winterblight.CASTLE_DATA["rooms"][9]["cleared"] = 0

		-- treasure_stash
		Winterblight.CASTLE_DATA["rooms"][10] = {}
		Winterblight.CASTLE_DATA["rooms"][10]["door_index"] = 11
		Winterblight.CASTLE_DATA["rooms"][10]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["key_positions"] = {Vector(11612, -2688), Vector(10491, -2688)}
		Winterblight.CASTLE_DATA["rooms"][10]["cleared"] = 0

		-- font_of_luminescence
		Winterblight.CASTLE_DATA["rooms"][11] = {}
		Winterblight.CASTLE_DATA["rooms"][11]["door_index"] = 12
		Winterblight.CASTLE_DATA["rooms"][11]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["key_positions"] = {Vector(12928, -2944), Vector(15257, -2775), Vector(14350, -2018)}
		Winterblight.CASTLE_DATA["rooms"][11]["cleared"] = 0

		-- blue_goo_room
		Winterblight.CASTLE_DATA["rooms"][12] = {}
		Winterblight.CASTLE_DATA["rooms"][12]["door_index"] = 13
		Winterblight.CASTLE_DATA["rooms"][12]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["key_positions"] = {Vector(15240, -863), Vector(15694, -632), Vector(15744, -1792)}
		Winterblight.CASTLE_DATA["rooms"][12]["cleared"] = 0
end

function Winterblight:InitCastleProps()
	local goo = Entities:FindByNameNearest("CastleGoo", Vector(9742, 4586, 1600), 2000)
	goo:SetAbsOrigin(goo:GetAbsOrigin()+Vector(0,0,300))
end

function Winterblight:OpenCastleDoorByIndex(index)
	local DoorsData = Winterblight.CASTLE_DATA["doors"]
	local walls = Entities:FindAllByNameWithin(DoorsData[index]["name"], DoorsData[index]["position"], 1200)
	Winterblight:WallsTicks(false, walls, true, 5.5, 150, 0.05)
	Winterblight:RemoveBlockers(4, DoorsData[index]["blockers"], DoorsData[index]["position"], 1600)
	Events:DoorDust(DoorsData[index]["dust_start_position"], DoorsData[index]["dust_end_position"], 20, 0.3)
end

function Winterblight:TarotCardSelect(msg)
	local playerID = msg.PlayerID
	local selection = msg.card_index
	print("CARD SELECTED: "..selection)

	Winterblight.CastleDungeonMaster.phase = 1
	Winterblight.CastleDungeonMaster.selected_card = selection
	EmitSoundOn("Winterblight.TarotCardSelect", Winterblight.CastleDungeonMaster)
	EmitSoundOn("Winterblight.TarotCardSelect.Ping", Winterblight.CastleDungeonMaster)

	Winterblight.CastleTarot = Winterblight.CASTLE_DATA["tarot"][selection+1]

	local x_distance_between_card_props = 19
	local y_distance_between_card_props = 33
	local prop_search_position = Vector(11768, 14273, 1700)
	if selection/8 < 1 then
		prop_search_position = prop_search_position + Vector(selection*x_distance_between_card_props, 0, 0)
	elseif selection/8 < 2 then
		prop_search_position = prop_search_position + Vector((selection%8)*x_distance_between_card_props, -y_distance_between_card_props, 0)
	else
		print("3rd ROW SEARCH")
		prop_search_position = prop_search_position + Vector(((selection%8)+1)*x_distance_between_card_props, y_distance_between_card_props*-2, 0)
	end
	local card_prop = Entities:FindByNameNearest("tarot_card_prop", prop_search_position, 500)
	Events:smoothTranslate(card_prop, Vector(0,0,4), 30, Vector(0,0), nil)
	CustomAbilities:QuickParticleAtPoint("particles/econ/items/necrolyte/necronub_death_pulse/necrolyte_pulse_ka_explosion_flash_glow.vpcf", card_prop:GetAbsOrigin(), 2)

	Timers:CreateTimer(1.8, function()
		StartAnimation(Winterblight.CastleDungeonMaster, {duration = 1.0, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1})
		Winterblight.CastleDungeonMaster.card_prop = card_prop
		EmitSoundOn("Winterblight.GrabTarot", Winterblight.CastleDungeonMaster)
		card_prop:SetAngles(0, 0, 25)
	end)
	Timers:CreateTimer(3.3, function()
		Winterblight.CastleDungeonMaster:MoveToPosition(Vector(11800, 13400))
		Winterblight.CastleDungeonMaster.phase = 2
	end)
	Timers:CreateTimer(1, function()
		local model_name = "models/winterblight/tarot/"..Winterblight.CastleTarot["index"].."-"..Winterblight.CastleTarot["name"]..".vmdl"
		local function precache_function()
			PrecacheUnitByNameAsync(model_name, precache_function)	
		end
	end)
end

function Winterblight:CastleNextRoomInit()
	local next_room_data = Winterblight.CastleTarot["rooms"][Winterblight.CASTLE_DATA["rooms_cleared"] + 1]
	local next_room_index = next_room_data.index

	Winterblight.ActiveCastleRoom = Winterblight.CASTLE_DATA["rooms"][next_room_index]
	Winterblight.ActiveCastleRoom["active"] = 1
	Winterblight:OpenCastleDoorByIndex(Winterblight.ActiveCastleRoom["door_index"])
	Winterblight:SpawnCastleRoomByIndex(next_room_index, next_room_data.variant)
end

function Winterblight:CastleLobbySpawn1()
	local spawnIndex = 1
	print("SPAWN LOBBY - "..spawnIndex)
	if spawnIndex == 1 then
		Timers:CreateTimer(0.2, function()
			local positionTable = {Vector(13440, 13858), Vector(13952, 13742), Vector(13952, 13440), Vector(13440, 13056)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(13467, 13568) - positionTable[i]):Normalized()
				Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
			end
		end)
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(14336, 13312), Vector(14592, 13312), Vector(14848, 13312), Vector(15104, 13312), Vector(15360, 13312)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Enemies:SpawnEnemyUnit("winterblight_frozen_cage", positionTable[i], fv, false)
			end
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(14208, 13628), Vector(14515, 13628), Vector(14821, 13628), Vector(15135, 13628)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(-1,0)
				Enemies:SpawnEnemyUnit("winterblight_castle_warrior", positionTable[i], fv, false)
			end
		end)
		Timers:CreateTimer(2, function()
			Enemies:SpawnEnemyUnit("winterblight_mountain_spirit", Vector(15616, 13233), Vector(-1,1), false)
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(13824, 11648), Vector(13517, 11648), Vector(13517, 11904), Vector(13824, 11904), Vector(13496, 12164), Vector(13824, 12164)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Enemies:SpawnEnemyUnit("winterblight_wraithguard", positionTable[i], fv, false)
			end
		end)
		Timers:CreateTimer(3.0, function()
			local positionTable = {Vector(13524, 12682), Vector(13824, 12682)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Enemies:SpawnEnemyUnit("winterblight_wraithguard_elite", positionTable[i], fv, false)
			end
		end)
		Timers:CreateTimer(4, function()
			local positionTable = {Vector(13440, 10500), Vector(13656, 10485), Vector(13440, 10697), Vector(13672, 10678), Vector(13440, 10880), Vector(13666, 10880)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Enemies:SpawnEnemyUnit("winterblight_castle_warrior", positionTable[i], fv, false)
			end
			local positionTable = {Vector(13952, 10749), Vector(13952, 10527)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(-1,1)
				Enemies:SpawnEnemyUnit("winterblight_frozen_mage", positionTable[i], fv, false)
			end
		end)
	end
	Timers:CreateTimer(5.0, function()
		local positionTable = {Vector(13440, 9216), Vector(13912, 9216)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,1)
			Enemies:SpawnEnemyUnit("winterblight_castle_watchman", positionTable[i], fv, false)
		end
		local positionTable = {Vector(13730, 8049), Vector(14208, 8192)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(-0.2,1)
			Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
		end
		for i = 0, 3, 1 do
			for j = 0, 1, 1 do
				local fv = Vector(0,1)
				local x_spacing = 128
				local y_spacing = 128
				local base_pos = Vector(13420, 8661)
				Enemies:SpawnEnemyUnit("winterblight_frozen_phantom", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false)
			end
		end
	end)
	Timers:CreateTimer(7.0, function()
		for i = 0, 1, 1 do
			for j = 0, 3, 1 do
				local fv = Vector(-1,0)
				local x_spacing = 128
				local y_spacing = 128
				local base_pos = Vector(14720, 8576)
				Enemies:SpawnEnemyUnit("winterblight_frozen_soul", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false)
			end
		end
	end)
	Timers:CreateTimer(8, function()
		local positionTable = {Vector(13269, 7805), Vector(12032, 7936)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(13209, 8448) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_draugr", positionTable[i], fv, false)
		end
		Enemies:SpawnEnemyUnit("winterblight_castle_watchman", Vector(12288, 7040), Vector(1,0.6), false)
	end)
	Timers:CreateTimer(9.0, function()
		for i = 0, 1, 1 do
			for j = 0, 3, 1 do
				local fv = Vector(0,1)
				local x_spacing = 600
				local y_spacing = 128
				local base_pos = Vector(11904, 5338)
				Enemies:SpawnEnemyUnit("winterblight_frozen_mage", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false)
			end
		end
	end)
	Timers:CreateTimer(10, function()
		local positionTable = {Vector(12919, 4415), Vector(12800, 4631), Vector(12672, 4960), Vector(12032, 4550), Vector(11799, 4722), Vector(12040, 4960)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(12396, 4734) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_castle_warrior", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(13696, 12160), Vector(13040, 8251), Vector(12288, 5760), Vector(12416, 2560), Vector(9387, 2041)}
		Enemies:CreateUnitsWithPatrol("winterblight_skull_ripper", 2, positionTable, 25, 12, 300, 300, 1, 1)
	end)
	Timers:CreateTimer(11, function()
		local positionTable = {Vector(11906, 7040), Vector(12582, 6144), Vector(14272, 9250), Vector(13440, 3968)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(13568, 9344) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_suffering_spirit", positionTable[i], fv, false)
		end
		Enemies:SpawnEnemyUnit("winterblight_ancient_mountain_spirit", Vector(14080, 8576), Vector(-0.2, 1), false)
	end)
	Timers:CreateTimer(12, function()
		for i = 0, 2, 1 do
			for j = 0, 1, 1 do
				local fv = Vector(1,0)
				local x_spacing = 288
				local y_spacing = 428
				local base_pos = Vector(10350, 2033)
				Enemies:SpawnEnemyUnit("winterblight_defiler", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false)
			end
		end
	end)
	Timers:CreateTimer(14, function()
		local positionTable = {Vector(11904, 3350), Vector(13056, 2891), Vector(12160, 2560)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(12396, 4734) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_wraithguard_elite", positionTable[i], fv, false)
		end
		local positionTable = {Vector(12323, 1794), Vector(12800, 1494)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,1)
			Enemies:SpawnEnemyUnit("winterblight_castle_watchman", positionTable[i], fv, false)
		end
	end)	
	Timers:CreateTimer(13.5, function()
		local positionTable = {Vector(12294, 5708), Vector(12142, 6108), Vector(12350, 6364), Vector(11904, 6364)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Enemies:SpawnEnemyUnit( "winterblight_elite_ghoul", positionTable[i], fv, false)
			end)
		end
	end)
	Timers:CreateTimer(14.5, function()
		local positionTable = {Vector(12039, 2915), Vector(11776, 2944), Vector(11925, 2688)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Enemies:SpawnEnemyUnit( "winterblight_elite_ghoul", positionTable[i], fv, false)
			end)
		end
	end)
	Timers:CreateTimer(10.5, function()
		local positionTable = {Vector(12016, 8358), Vector(11776, 8448), Vector(11971, 8662)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Enemies:SpawnEnemyUnit( "winterblight_frozen_mage", positionTable[i], fv, false)
			end)
		end
	end)

	Timers:CreateTimer(15.5, function()
		local positionTable = {Vector(12134, 3840), Vector(12032, 3454), Vector(11648, 3712)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Enemies:SpawnEnemyUnit("winterblight_draugr", positionTable[i], fv, false)
			end)
		end
	end)

	Timers:CreateTimer(17.5, function()
		local positionTable = {Vector(9856, 1408), Vector(10240, 1541)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(1,0)
			Enemies:SpawnEnemyUnit("winterblight_suffering_spirit", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(18.5, function()
		local positionTable = {Vector(8964, 2508), Vector(8964, 2048), Vector(8964, 1664)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(1,0)
			Enemies:SpawnEnemyUnit("winterblight_castle_watchman", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(19.5, function()
		local positionTable = {Vector(13396, 1920), Vector(13620, 2103), Vector(13312, 2304)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Enemies:SpawnEnemyUnit( "winterblight_elite_ghoul", positionTable[i], fv, false)
			end)
		end
	end)
end

function Winterblight:SpawnCastleRoomByIndex(index, variant)
	if index == 1 then
		Winterblight:SpawnCastleRoom1(variant)
	elseif index == 2 then
		Winterblight:SpawnCastleRoom2(variant)
	elseif index == 3 then
		Winterblight:SpawnCastleRoom3(variant)
	elseif index == 4 then
		Winterblight:SpawnCastleRoom4(variant)
	elseif index == 5 then
		Winterblight:SpawnCastleRoom5(variant)
	elseif index == 6 then
		Winterblight:SpawnCastleRoom6(variant)
	elseif index == 7 then
		Winterblight:SpawnCastleRoom7(variant)
	elseif index == 8 then
		Winterblight:SpawnCastleRoom8(variant)
	elseif index == 9 then
		Winterblight:SpawnCastleRoom9(variant)
	elseif index == 10 then
		Winterblight:SpawnCastleRoom10(variant)
	elseif index == 11 then
		Winterblight:SpawnCastleRoom11(variant)
	elseif index == 12 then
		Winterblight:SpawnCastleRoom12(variant)
	end
end

function Winterblight:SpawnCastleRoomUnit(room_index, unit_name, position, fv, aggro, bIgnoreCounter)
	if bIgnoreCounter then
	else
		Winterblight.ActiveCastleRoom["enemy_spawn_count"] = Winterblight.ActiveCastleRoom["enemy_spawn_count"] + 1
	end
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	local enemy = Enemies:SpawnEnemyUnit(unit_name, position, fv, aggro)
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, enemy, "modifier_winter_castle_room_unit", {})
	enemy.room_index = room_index
	return enemy
end

function Winterblight:CastleRoomEnemyGoalReached(room_index)
	if not Winterblight.CastleDungeonMaster.key_drops then
		Winterblight.CastleDungeonMaster.key_drops = 0
	end
	Winterblight.CastleDungeonMaster.key_drops = Winterblight.CastleDungeonMaster.key_drops + 1
	if Winterblight.CastleDungeonMaster.key_drops == #Winterblight.CastleTarot["rooms"] then
		Winterblight:SpawnRoomKey(room_index, true)
	else
		Winterblight:SpawnRoomKey(room_index, false)
	end
end

function Winterblight:SpawnCastleRoom1(variant)
	local room_index = 1
	if variant == 1 then
		Timers:CreateTimer(1, function()
			for i = 0, 3, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 188
					local y_spacing = 148
					local base_pos = Vector(13312, 14976)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)	
		Timers:CreateTimer(1.4, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,0)
					local x_spacing = 600
					local y_spacing = 210
					local base_pos = Vector(11858, 15183)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)		
		Timers:CreateTimer(2.4, function()
			for i = 0, 4, 1 do
				for j = 0, 0, 1 do
					local fv = Vector(1,0)
					local x_spacing = 200
					local y_spacing = 0
					local base_pos = Vector(12096, 14896)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_frozen_cage", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(4, function()
			local positionTable = {Vector(12160, 15744), Vector(12160, 16000), Vector(12920, 16000), Vector(12920, 15744)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_skull_ripper", positionTable[i], fv, false, false)
			end
		end)
		Timers:CreateTimer(5, function()
			local positionTable = {Vector(13568, 15820), Vector(13824, 15763), Vector(14052, 15847), Vector(13824, 16000)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_suffering_spirit", positionTable[i], fv, false, false)
			end
		end)
		Timers:CreateTimer(7, function()
			local positionTable = {Vector(11136, 14976), Vector(11136, 15232), Vector(11136, 15500)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(1,0)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_suffering_spirit", positionTable[i], fv, false, false)
			end
		end)
		Timers:CreateTimer(8, function()
			local positionTable = {Vector(11330, 16000), Vector(11136, 15744)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(1,-1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_castle_warrior", positionTable[i], fv, false, false)
			end
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
	end
end

function Winterblight:SpawnCastleRoom2(variant)
	local room_index = 2
	if variant == 1 then
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(15968, 15005), Vector(16104, 15744), Vector(15488, 15989), Vector(14720, 15989), Vector(14531, 15360), Vector(15062, 15104)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(15449, 15360) - positionTable[i]):Normalized()
				if i == #positionTable then
					fv = Vector(0,-1)
				end
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_cellar_spider_mother", positionTable[i], fv, false, false)
			end
			
		end)	
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(16128, 15841), Vector(15183, 16023), Vector(14848, 15744), Vector(14848, 14966), Vector(15320, 15232), Vector(15903, 14966)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_spider_egg_sack", positionTable[i], RandomVector(1), false, false)
			end
			-- add 5 to extra_goal for each spider sack
		end)	
	end
end

function Winterblight:SpawnCastleRoom3(variant)
	local room_index = 3
	if variant == 1 then
		local positionTable = {Vector(12416, 9715), Vector(12416, 11776), Vector(11136, 11576), Vector(11264, 9472)}
		Enemies:CreateUnitsWithPatrol("winterblight_black_gargoyle", 3, positionTable, 34, 7, 300, 300, 0.2, 0.2)
		Timers:CreateTimer(0.5, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,0)
					local x_spacing = 196
					local y_spacing = 196
					local base_pos = Vector(12381, 10496)
					Enemies:SpawnEnemyUnit("winterblight_frozen_phantom", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false)
				end
			end
		end)
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(11701, 10713), Vector(11877, 10543), Vector(11620, 10476), Vector(11392, 10742)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(12703, 10702) - positionTable[i]):Normalized()
				Winterblight:SpawnCorporealRevenant(positionTable[i], fv)
			end
		end)	
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(11776, 9901), Vector(11458, 10069)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Enemies:SpawnEnemyUnit("winterblight_ancient_mountain_spirit", positionTable[i], fv, false)
			end
		end)	
		Timers:CreateTimer(2, function()
			for i = 0, 1, 1 do
				for j = 0, 4, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 304
					local y_spacing = 166
					local base_pos = Vector(11726, 11106)
					Enemies:SpawnEnemyUnit("winterblight_frozen_mage", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false)
				end
			end
		end)
		Timers:CreateTimer(2.5, function()
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_ice_harbor_mini_boss", Vector(11859, 12105), Vector(0,-1), false, false)
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
	end
end

function Winterblight:SpawnCastleRoom4(variant)
	local room_index = 4
	if variant == 1 then
		local positionTable = {Vector(15744, 10368), Vector(14976, 10368), Vector(14981, 10720), Vector(14976, 11119), Vector(14976, 11520)}
		for i = 1, #positionTable, 1 do
			local trap = CreateUnitByName("winterblight_spike_trap", positionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
			trap:SetAbsOrigin(trap:GetAbsOrigin()+Vector(0,0,10))
		end
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(14976, 9795), Vector(15360, 10368), Vector(15360, 10831), Vector(15360, 11392)}
			for i = 1, 1 + GameState:GetDifficultyFactor(), 1 do
				local trap = CreateUnitByName("winterblight_ground_blade", positionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
				trap:SetAbsOrigin(trap:GetAbsOrigin()+Vector(0,0,10))
				trap:SetForwardVector(RandomVector(1))
			end
		end)
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(14720, 10112), Vector(15036, 10112), Vector(15351, 10112), Vector(15036, 9856), Vector(14720, 9856)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(1,0)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_castle_warrior", positionTable[i], fv, false, false)
			end
			
		end)
		Timers:CreateTimer(2, function()
			for i = 0, 1, 1 do
				for j = 0, 5, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 640
					local y_spacing = 256
					local base_pos = Vector(14720, 10624)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_bloodripper", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
			
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(15744, 11165), Vector(15744, 11606), Vector(15744, 12005)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i*0.3, function()
					local fv = Vector(0,-1)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_torturer", positionTable[i], fv, false, false)
				end)
			end
			
		end)
		
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(16097, 10294), Vector(16000, 10588), Vector(15616, 10624)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(15616, 10112) - positionTable[i]):Normalized()
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_mountain_spirit", positionTable[i], fv, false, false)
			end
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
	end
end

function Winterblight:SpawnCastleRoom5(variant)
	local room_index = 5
	if variant == 1 then
		Timers:CreateTimer(0.5, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,0)
					local x_spacing = 200
					local y_spacing = 200
					local base_pos = Vector(10589, 7808)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
					monster.deathCode = "mould_room_mob"
				end
			end
			
		end)
		Timers:CreateTimer(1.5, function()
			for i = 0, 1, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,-1)
					local x_spacing = 256
					local y_spacing = 256
					local base_pos = Vector(10589, 8168)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_accursed", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
					monster.deathCode = "mould_room_mob"
				end
			end
			
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(10481, 7187), Vector(10729, 6917), Vector(10368, 6784)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_skeleton_archer", positionTable[i], fv, false, false)
				monster.deathCode = "mould_room_mob"
			end	
			
		end)
		Timers:CreateTimer(3.0, function()
			local positionTable = {Vector(9472, 6272), Vector(9626, 6656), Vector(9458, 7168), Vector(9795, 7497), Vector(9532, 7888)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(1,0)
				local monster = Enemies:SpawnEnemyUnit("winterblight_soul_fletcher", positionTable[i], fv, false)
			end	
		end)
		Timers:CreateTimer(3.5, function()
			local names = {"winterblight_draugr", "winterblight_accursed"}
			local positionTable = {Vector(10580, 7168), Vector(11061, 6912), Vector(11061, 6825), Vector(10649, 6400), Vector(10368, 6285)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(11136, 8129) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, names[RandomInt(1, #names)], positionTable[i], fv, false, false)
				monster.deathCode = "mould_room_mob"
			end	
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2		
		end)	
		Timers:CreateTimer(4.5, function()
			local positionTable = {Vector(10240, 8576), Vector(10240, 8192), Vector(10936, 6898), Vector(10240, 6528)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(11136, 8129) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_ghost_pirate", positionTable[i], fv, false, false)
				monster.deathCode = "mould_room_mob"
			end	
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2		
		end)	
	end
end

function Winterblight:SpawnCastleRoom6(variant)
	local room_index = 6
	if variant == 1 then
		Timers:CreateTimer(1, function()
			for i = 0, 3, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(-1,0)
					local x_spacing = 184
					local y_spacing = 184
					local base_pos = Vector(14360, 5632)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(2, function()
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_watchman", Vector(14767, 6240), Vector(0,-1), false, false)
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_watchman", Vector(14336, 5178), Vector(0,1), false, false)
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_suffering_spirit", Vector(14568, 4795), Vector(0,1), false, false)
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_suffering_spirit", Vector(14652, 4657), Vector(0,1), false, false)
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(15488, 4096), Vector(15232, 4352), Vector(14976, 6528)}
			for i = 1, #positionTable, 1 do
				local fv = RandomVector(1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_ghoul", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(3, function()
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_shadow_of_saturn", Vector(15642, 5708), Vector(-1,0), false, false)
			local positionTable = {Vector(15360, 6003), Vector(15617, 6153), Vector(15926, 6064), Vector(16021, 5760), Vector(15961, 5485), Vector(15630, 5317), Vector(15360, 5504)}
			for i = 1, 4+GameState:GetDifficultyFactor(), 1 do
				local fv = Vector(-1,0)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_saturn_zealot", positionTable[i], fv, false, false)
			end		
				
		end)
		Timers:CreateTimer(3.5, function()
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_ancient_mountain_spirit", Vector(14910, 4190), Vector(-0.3,1), false, false)
		end)
		Timers:CreateTimer(4, function()
			Winterblight:SpawnServantOfSaturn(Vector(15616, 4224), Vector(-1,0))
			local positionTable = {Vector(15981, 4096), Vector(16181, 4258), Vector(15872, 4352), Vector(15488, 7198), Vector(15232, 7296), Vector(15430, 7400), Vector(15654, 7452), Vector(15430, 7680)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(14208, 5689) - positionTable[i]):Normalized()
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_saturn_zealot", positionTable[i], fv, false, false)
			end
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2	
		end)
	end
end

function Winterblight:SpawnCastleRoom7(variant)
	local room_index = 7

	local goo_dummy = CreateUnitByName("npc_dummy_unit", Vector(9778, 4642), false, nil, nil, DOTA_TEAM_NEUTRALS)
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, goo_dummy, "modifier_room_7_goo_aura", {})
	goo_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)


	local buttonsPositions = {Vector(9037, 3622, 1584), Vector(9514, 5496, 1584), Vector(10867, 5619, 1584)}
	for i = 1, #buttonsPositions, 1 do
		local button = Entities:FindByNameNearest("GooSwitchButton", buttonsPositions[i], 800)
		button:SetAbsOrigin(button:GetAbsOrigin() + Vector(0,0,285))
	end
	Winterblight.CastleDungeonMaster.goo_switches = {0, 0, 0}
	Winterblight.CastleDungeonMaster.goo_dummy = goo_dummy
	if variant == 1 then
		Timers:CreateTimer(0.5, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(-1,0)
					local x_spacing = 256
					local y_spacing = 256
					local base_pos = Vector(10624, 3538)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_mountain_spirit", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)

		Timers:CreateTimer(1, function()
			for i = 0, 1, 1 do
				for j = 0, 2, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 184
					local y_spacing = 184
					local base_pos = Vector(9451, 5248)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_skeleton_archer", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)

		Timers:CreateTimer(2, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,0)
					local x_spacing = 234
					local y_spacing = 234
					local base_pos = Vector(9600, 3998)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_slime_goblin", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(8917, 4231), Vector(9216, 3840), Vector(8832, 3840), Vector(10176, 4976), Vector(10496, 4976), Vector(11136, 4569), Vector(11136, 4289)}
			for i = 1, #positionTable, 1 do
				local fv = RandomVector(1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_slime_goblin", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(3.5, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 240
					local y_spacing = 240
					local base_pos = Vector(10568, 5435)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_defiler", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(4.0, function()
			for i = 0, 3, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 220
					local y_spacing = 220
					local base_pos = Vector(10162, 4306)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(5.0, function()
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_watchman", Vector(9728, 5120), Vector(0,-1), false, false)
		end)
		Timers:CreateTimer(5.5, function()
			local positionTable = {Vector(8576, 4817), Vector(8925, 4817), Vector(9268, 4818)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(1,0)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_draugr", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(6.5, function()
			for i = 0, 1, 1 do
				for j = 0, 2, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 220
					local y_spacing = 240
					local base_pos = Vector(8384, 5176)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_accursed", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)

		Timers:CreateTimer(7, function()
			local positionTable = {Vector(9493, 5760), Vector(9824, 5760), Vector(9774, 5504)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_skull_ripper", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(8, function()
			local positionTable = {Vector(9144, 5217), Vector(9144, 5419), Vector(9144, 5632)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_suffering_spirit", positionTable[i], fv, false, false)
			end	
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
	end
end

function Winterblight:SpawnCastleRoom8(variant)
	local room_index = 8
	local vertices = Winterblight:Room8Vertices()
	for i = 1, 8, 1 do
		Timers:CreateTimer(i*0.1, function()
			local spawnPos = WallPhysics:RandomPointInBlockCollection(vertices)
			local rock = Enemies:SpawnEnemyUnit("winterblight_armory_rock", spawnPos, RandomVector(1), false)
			rock:SetAbsOrigin(rock:GetAbsOrigin() + Vector(0,0,40))
			rock:SetHullRadius(180)
		end)
	end
	if variant == 1 then
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(14464, 1920), Vector(14848, 2112), Vector(14952, 2455), Vector(14828, 2816), Vector(14513, 3200)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(14336, 2560) - positionTable[i]):Normalized()
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_cavern_centaur", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(1.2, function()
			for i = 0, 5, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,1)
					local x_spacing = 270
					local y_spacing = 270
					local base_pos = Vector(14593, 1340)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_fallen_one", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(15952, 2172), Vector(15756, 2597), Vector(15304, 2954), Vector(14592, 3456)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(14848, 1826) - positionTable[i]):Normalized()
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_fallen_one", positionTable[i], fv, false, false)
			end
			for i = 1, GameState:GetDifficultyFactor() + Winterblight.Stones, 1 do
				local spawnPos = WallPhysics:RandomPointInBlockCollection(vertices)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_ghoul", spawnPos, fv, false, false)
			end
		end)
		Timers:CreateTimer(3.0, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,1)
					local x_spacing = 240
					local y_spacing = 240
					local base_pos = Vector(15310, 768)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(3.5, function()
			if GameState:GetDifficultyFactor() > 1 then
				local positionTable = {Vector(1532, 2304), Vector(15305, 1938), Vector(15616, 2052)}
				for i = 1, #positionTable, 1 do
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_ancient_mountain_spirit", positionTable[i], RandomVector(1), false, false)
				end
			end
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
	end
end

function Winterblight:Room8Vertices()
	local vertices = {}

	local height = 2480
	local width = 406
	local origin = Vector(14667, 2333)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 2187
	local width = 467
	local origin = Vector(15145, 1871)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 1172
	local width = 733
	local origin = Vector(15761, 1971)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 777
	local width = 815
	local origin = Vector(15807, 919)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	return vertices
end

function Winterblight:SpawnCastleRoom9(variant)
	local room_index = 9
	if variant == 1 then
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(9088, 186), Vector(9863, -256), Vector(8941, -888)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(9455, 988) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winter_bone_blister", positionTable[i], fv, false, false)
				monster.deathCode = "freezer"
			end	
		end)
		Timers:CreateTimer(1, function()
			Winterblight:SpawnMountainStonePack(Vector(9344, -896))
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(8704, -1452), Vector(9151, -1152), Vector(8960, 351), Vector(9827, -130), Vector(9151, -512), Vector(9472, -990), Vector(9151, -1452)}
			for i = 1, #positionTable, 1 do
				local fv = RandomVector(1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_ice_bear", positionTable[i], fv, false, false)
				monster.deathCode = "freezer"
			end	
		end)
		Timers:CreateTimer(2.0, function()
			local vertices = Winterblight:Room9Vertices()
			local minion_count = GameState:GetDifficultyFactor() + Winterblight.Stones + 4
			for i = 1, minion_count, 1 do
				local fv = RandomVector(1)
				local position = WallPhysics:RandomPointInBlockCollection(vertices)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_warrior", position, fv, false, false)
				monster.deathCode = "freezer"
			end	
		end)
	end
end

function Winterblight:Room9Vertices()
	local vertices = {}

	local height = 512
	local width = 512
	local origin = Vector(8704, -1536)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 807
	local width = 1024
	local origin = Vector(9216, -1004)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 912
	local width = 1013
	local origin = Vector(9210, -161)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 912
	local width = 1013
	local origin = Vector(9210, -161)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 1457
	local width = 410
	local origin = Vector(9907, -434)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 384
	local width = 1408
	local origin = Vector(9408, 320)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	return vertices
end

function Winterblight:DropRoom9IcicleAtRandomPosition()
	local vertices = Winterblight:Room9Vertices()
	local position = WallPhysics:RandomPointInBlockCollection(vertices)
	local crystal = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,RandomInt(1000, 1400)))
	crystal:SetAngles(0, 0, -90)
	crystal:SetForwardVector(Vector(0,0.2,-1))
	crystal:SetOriginalModel("models/winterblight/azalea_crystal.vmdl")
	crystal:SetModel("models/winterblight/azalea_crystal.vmdl")
	crystal:SetModelScale(0.5)

	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, crystal, "modifier_room_9_icicle_fall", {})

	crystal:FindAbilityByName("dummy_unit"):SetLevel(1)
end

function Winterblight:SpawnCastleRoom10(variant)
	print("SPAWN ROOM 10")
	local room_index = 10
	if variant == 1 then
		print("SPAWN TOWER")
		local tower = Enemies:SpawnEnemyUnit("winterblight_treasure_room_tower", Vector(10491, -2576), Vector(1,-0.5), false)
		tower:SetHullRadius(165)
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(10368, -1744), Vector(9344, -2232), Vector(9039, -2368), Vector(9472, -2984), Vector(9600, -3219), Vector(9856, -3124), Vector(10240, -3229), Vector(10880, -3029), Vector(11520, -3200), Vector(10687, -2351), Vector(11008, -2380)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(11681, -1677) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_gold_fanatic", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(1, function()
			for i = 0, 4, 1 do
				for j = 0, 2, 1 do
					local fv = Vector(0,1)
					local x_spacing = 244
					local y_spacing = 244
					local base_pos = Vector(10652, -2816)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(9556, -3138), Vector(9984, -2944), Vector(9947, -2560), Vector(11277, -2560)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(10623, -3025) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_draugr", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(2.0, function()
			local positionTable = {Vector(8960, -2368), Vector(10496, -2100), Vector(11392, -2688)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(10623, -3025) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_accursed", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(11648, -3200), Vector(11235, -3200), Vector(10811, -3200)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_suffering_spirit", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(3.0, function()
			local positionTable = {Vector(8960, -2432), Vector(9677, -2212)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(10623, -3025) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_castle_warrior", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(1.75, function()
			if GameState:GetDifficultyFactor() > 2 then
				local amount = 2 + Winterblight.Stones
				if Winterblight.Stones == 3 then
					amount = 6
				end
				local positionTable = {Vector(11648, -2574), Vector(11136, -3164), Vector(10394, -2944), Vector(9728, -3200), Vector(9858, -2737), Vector(10624, -2368)}
				for i = 1, amount, 1 do
					local fv = RandomVector(1)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "ruins_golden_skullbone", positionTable[i], fv, false, false)
				end	
			end
		end)

	end
end

function Winterblight:SpawnTreasureRoomChests()
	local positionTable = {Vector(9498, -2670), Vector(10130, -2278), Vector(10746, -1901)}
	local glyphs_count = RandomInt(2, math.floor(3 + GameState:GetPlayerPremiumStatusCount()))
	local crystals_count = (GameState:GetDifficultyFactor() * RandomInt(34, 40 + GameState:GetPlayerPremiumStatusCount()*4))*6
	local rewardTables = {{items = RandomInt(6, 9+GameState:GetPlayerPremiumStatusCount())}, {crystals = crystals_count}, {glyphs = glyphs_count}}
	local rewardTables = WallPhysics:ShuffleTable(rewardTables)
	Winterblight.CastleDungeonMaster.treasure_room_chests = {}
	for i = 1, #positionTable, 1 do
		local chest = Enemies:SpawnEnemyUnit("winterblight_treasure_chest", positionTable[i], Vector(-1,1), false)
		local particleName = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, chest)
		ParticleManager:SetParticleControlEnt(pfx, 0, chest, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", chest:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, chest, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", chest:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, chest, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", chest:GetAbsOrigin(), true)
		EmitSoundOn("Winterblight.TreasureTower.GoldSound", chest)
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		chest.contents = rewardTables[i]
		table.insert(Winterblight.CastleDungeonMaster.treasure_room_chests, chest)
	end
end

function Winterblight:SpawnCastleRoom11(variant)
	local room_index = 11
	if variant == 1 then
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(12800, -3385), Vector(13082, -3020), Vector(13865, -2951), Vector(15232, -2774), Vector(14464, -2305), Vector(13747, -1920), Vector(12928, -2432)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(12960, -1624) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_graviton", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(1.2, function()
			for i = 0, 3, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,1)
					local x_spacing = 256
					local y_spacing = 256
					local base_pos = Vector(13494, -2615)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_skeleton_archer", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(1.7, function()
			local positionTable = {Vector(12509, -3200), Vector(12557, -3003), Vector(12621, -2803)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(12960, -1624) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elite_castle_warrior", positionTable[i], fv, false, false)
			end	
		end)		
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(13824, -1601), Vector(14031, -1497), Vector(14279, -1517)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_mountain_spirit", positionTable[i], fv, false, false)
			end	
		end)	
		Timers:CreateTimer(3, function()
			local positionTable = {Vector(13440, -2944), Vector(13696, -3082), Vector(13952, -2944)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_watchman", positionTable[i], fv, false, false)
			end	
		end)	
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(15419, -3272), Vector(15246, -3123), Vector(15140, -3278), Vector(15246, -3456), Vector(14953, -3456), Vector(14822, -3286), Vector(14667, -3454), Vector(14537, -3287), Vector(14366, -3456), Vector(14170, -3311), Vector(13959, -3473), Vector(13824, -3314), Vector(13568, -3278), Vector(13486, -3456)}
			local unitTable = {"winterblight_frozen_mage", "winterblight_frozen_phantom"}
			for i = 1, #positionTable, 1 do
				local fv = RandomVector(1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, unitTable[RandomInt(1, #unitTable)], positionTable[i], fv, false, false)
			end	
		end)	
		Timers:CreateTimer(4, function()
			local positionTable = {Vector(15244, -2407), Vector(15104, -2233), Vector(15003, -2363), Vector(14848, -2176)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(-1,-1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_frozen_cage", positionTable[i], fv, false, false)
			end	
			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_moon_warden", Vector(14712, -2720), Vector(0,-1), false, false)
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2	
		end)
	end
end

function Winterblight:SpawnCastleRoom12(variant)
	local room_index = 12
	if variant == 1 then
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(14848, 384), Vector(14848, -640), Vector(16000, -52), Vector(16000, -1305), Vector(15416, -1305), Vector(15269, -1664)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(14204, 13) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_blue_slime_monster", positionTable[i], fv, false, true)
				local corrected_position = GetGroundPosition(positionTable[i], monster)
				monster:SetAbsOrigin(corrected_position - Vector(0,0,10))
				monster.deathCode = "blue_slime_room"
			end	
		end)
		Timers:CreateTimer(1, function()
			for i = 0, 3, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(-1,0)
					local x_spacing = 200
					local y_spacing = 240
					local base_pos = Vector(14601, -101)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_grave_skeleton", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
					monster.deathCode = "blue_slime_room"
				end
			end
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(15028, -1280), Vector(14848, -1152), Vector(15196, -1152), Vector(15028, -1024), Vector(15131, -843), Vector(15360, -952)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_skeleton_archer", positionTable[i], fv, false, false)
				monster.deathCode = "blue_slime_room"
			end	
		end)	
		Timers:CreateTimer(2.0, function()
			for i = 0, 1, 1 do
				for j = 0, 2, 1 do
					local fv = Vector(-1,0)
					local x_spacing = 280
					local y_spacing = 220
					local base_pos = Vector(15493, -768)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_skull_ripper", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
					monster.deathCode = "blue_slime_room"
				end
			end
			local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_watchman", Vector(15781, -1272), Vector(0,1), false, false)
			monster.deathCode = "blue_slime_room"
		end)	
		Timers:CreateTimer(3, function()
			for i = 0, 1, 1 do
				for j = 0, 2, 1 do
					local fv = Vector(-1,0)
					local x_spacing = 240
					local y_spacing = 240
					local base_pos = Vector(15619, -2029)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_draugr", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
					monster.deathCode = "blue_slime_room"
				end
			end
		end)
	end
end

function Winterblight:SpawnSlimeRoomZombie()
	if not Winterblight.BlueGooSpawnPositions then
		Winterblight.BlueGooSpawnPositions = {}
		Winterblight.BlueGooSpawnPositions[1] = {location = Vector(14848, -295), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[2] = {location = Vector(14848, -400), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[3] = {location = Vector(14978, -733), fv  = Vector(1,-1)}
		Winterblight.BlueGooSpawnPositions[4] = {location = Vector(14819, -937), fv  = Vector(1,-1)}
		Winterblight.BlueGooSpawnPositions[5] = {location = Vector(14764, -1003), fv  = Vector(1,-1)}
		Winterblight.BlueGooSpawnPositions[6] = {location = Vector(14704, -1077), fv  = Vector(1,-1)}
		Winterblight.BlueGooSpawnPositions[7] = {location = Vector(15026, -1499), fv  = Vector(-1,1)}
		Winterblight.BlueGooSpawnPositions[8] = {location = Vector(15280, -1223), fv  = Vector(-1,1)}
		Winterblight.BlueGooSpawnPositions[9] = {location = Vector(15350, -1140), fv  = Vector(-1,1)}
		Winterblight.BlueGooSpawnPositions[10] = {location = Vector(15534, -1192), fv  = Vector(0,1)}
		Winterblight.BlueGooSpawnPositions[11] = {location = Vector(15599, -1247), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[12] = {location = Vector(15599, -1337), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[13] = {location = Vector(15548, -1401), fv  = Vector(0,-1)}
		Winterblight.BlueGooSpawnPositions[14] = {location = Vector(15414, -1508), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[15] = {location = Vector(15414, -1603), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[16] = {location = Vector(15414, -1703), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[17] = {location = Vector(15414, -1845), fv  = Vector(1,0)}
		Winterblight.BlueGooSpawnPositions[18] = {location = Vector(15810, -2217), fv  = Vector(0,1)}
		Winterblight.BlueGooSpawnPositions[19] = {location = Vector(16032, -1994), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[20] = {location = Vector(16032, -1888), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[21] = {location = Vector(16032, -1770), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[22] = {location = Vector(16032, -1501), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[23] = {location = Vector(15929, -1359), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[24] = {location = Vector(15929, -1272), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[25] = {location = Vector(16017, -794), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[26] = {location = Vector(16017, -616), fv  = Vector(-1,0)}
		Winterblight.BlueGooSpawnPositions[27] = {location = Vector(15800, -160), fv  = Vector(0,-1)}
		Winterblight.BlueGooSpawnPositions[28] = {location = Vector(15672, -160), fv  = Vector(0,-1)}
		Winterblight.BlueGooSpawnPositions[29] = {location = Vector(15560, -160), fv  = Vector(0,-1)}
		Winterblight.BlueGooSpawnPositions[30] = {location = Vector(15476, -160), fv  = Vector(0,-1)}
	end
	local index = RandomInt(1, #Winterblight.BlueGooSpawnPositions)
	local position = Winterblight.BlueGooSpawnPositions[index].location
	local fv = Winterblight.BlueGooSpawnPositions[index].fv
	local zombie = Winterblight:SpawnCastleRoomUnit(12, "winterblight_slime_zombie", position, fv, false, false)
	zombie:CrawlEnter(position, fv, "up", RandomInt(-600, -800), 8)
	zombie.deathCode = "blue_slime_room"
	zombie.extra_crawl_distance = 70
	zombie.crawl_end_pfx = "particles/roshpit/rubilash/ink_blot_explosion_blue.vpcf"
	zombie.crawl_end_sound = "Winterblight.BlueSlime.AttackSplash"
end

function Winterblight:SpawnRoomKey(room_index, bSkull)
	if Winterblight.CASTLE_DATA["rooms"][room_index]["cleared"] < 1 then
		local position = Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"][RandomInt(1, #Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"])]
		local key = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
		key:SetDayTimeVisionRange(300)
		key:SetNightTimeVisionRange(300)

		local model = "models/gameplay/prison_key.vmdl"
		if bSkull then
			model = "models/heroes/silencer/silencer_curse_skull.vmdl"
			key:SetModelScale(4.5)
			key.skull = true
			EmitSoundOn("Winterblight.KeySpawn.Skull", key)
			local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, key, "modifier_winter_castle_key_skull", {})
		end
		key:SetModel(model)
		key:SetOriginalModel(model)
		key:SetAbsOrigin(key:GetAbsOrigin() + Vector(0,0,1000))
		StartAnimation(key, {duration = 99999, activity = ACT_DOTA_IDLE, rate = 1})

		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, key, "modifier_winter_castle_key_entering", {})

		local groundPos = GetGroundPosition(key:GetAbsOrigin(), key) + Vector(0,0,20)
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/spotlight_colorable.vpcf", groundPos, 5)
		ParticleManager:SetParticleControl(pfx, 1, groundPos + Vector(0,0,3000))
		ParticleManager:SetParticleControl(pfx, 2, groundPos)
		ParticleManager:SetParticleControl(pfx, 3, Vector(0.2, 0.4, 0.8))
		-- EmitSoundOn("Winterblight.KeySpawn", key)
		EmitSoundOn("Winterblight.KeySpawn1", key)
		key:FindAbilityByName("dummy_unit"):SetLevel(1)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, key:GetAbsOrigin(), 300, 10, false)
	end
end

function Winterblight:WinterCastleBossSpawn()
	print("SUMMON CASTLE BOSS")
	local position = Vector(12306, 188, 600)
	local boss = Events:SpawnBoss("winterblight_castle_boss", position)
	Winterblight.CastleBossMusic = true
	if Beacons.cheats then
		if Winterblight.castle_boss  then
			UTIL_Remove(Winterblight.castle_boss)
		end
		Winterblight.castle_boss = boss
	end
	Winterblight.CastleBoss = boss
	Winterblight:CastleBossMusicPlayer()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 2500, 99999, false)
	boss:SetAbsOrigin(position-Vector(0,0,1000))
	-- boss:SetModelScale(6)

	local bossAbility = boss:FindAbilityByName("winterblight_castle_boss_passive")
	Events:smoothSizeChange(boss, 1, 6, 210)
	Timers:CreateTimer(3, function()
		Events:unitFVSpin(boss, 20, 240, 1, false)
		StartAnimation(boss, {duration = 8.0, activity = ACT_DOTA_TELEPORT, rate = 0.5})

		Timers:CreateTimer(0.6, function()
			Winterblight:CastleBossSplash(boss)
		end)

		Events:smoothTranslate(boss, Vector(0,0,20), 74, Vector(0,0), nil)

		Timers:CreateTimer(4, function()
			EmitSoundOn("Winterblight.CastleBoss.Spawn.VO", boss)
			bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_castle_boss_rotating", {})
		end)

		
	end)
end

function Winterblight:CastleBossSplash(boss)
	local splash_particle = "particles/roshpit/rubilash/ink_splatter_blue.vpcf"
	local splash_position = GetGroundPosition(boss:GetAbsOrigin(), boss) - Vector(0,0,300)
	CustomAbilities:QuickParticleAtPoint(splash_particle, splash_position, 5)
	EmitSoundOnLocationWithCaster(splash_position, "Winterblight.Boss.Splash", boss)
	for i = 1, 5, 1 do
		local fv = WallPhysics:rotateVector(Vector(1,1), 2*math.pi*i/5)
		CustomAbilities:QuickParticleAtPoint(splash_particle, splash_position + fv * 240, 5)
	end
end

function Winterblight:CastleBossMusicPlayer()
	for i = 1, #MAIN_HERO_TABLE, 1 do
		if MAIN_HERO_TABLE[i].bgm == "Music.Winterblight.BlackfrostCitadel" then
		  CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
		end
	end
	Timers:CreateTimer(0, function()
		if Winterblight.CastleBossMusic then
			local sound_position = GetGroundPosition(Winterblight.CastleBoss:GetAbsOrigin(), Winterblight.CastleBoss)
			EmitSoundOnLocationWithCaster(sound_position, "Winterblight.CastleBoss.Music", Winterblight.CastleBoss)
			return 40
		end
	end)
end
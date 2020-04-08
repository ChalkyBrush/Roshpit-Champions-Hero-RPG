function Winterblight:OpenWinterblightCastle()
	if not Winterblight.WinterCastleOpened then
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

		Timers:CreateTimer(10, function()
			local spawnPosition = Vector(11818, 14419)
			local wraith = Enemies:SpawnEnemyUnit("winterblight_diviner_horus", spawnPosition, Vector(0,-1), false)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", wraith:GetAbsOrigin(), 3)
			EmitSoundOn("Winterblight.GraveGhostSpawn", wraith)
			AddFOWViewer(DOTA_TEAM_GOODGUYS, wraith:GetAbsOrigin(), 500, 5, false)
			Winterblight.CastleDungeonMaster = wraith
			Winterblight:OpenCastleDoorByIndex(1)
			Winterblight:OpenCastleDoorByIndex(2)
			Winterblight:OpenCastleDoorByIndex(3)
			Winterblight:OpenCastleDoorByIndex(4)
			Winterblight:OpenCastleDoorByIndex(5)
			Winterblight:OpenCastleDoorByIndex(6)
			Winterblight:OpenCastleDoorByIndex(7)
			Winterblight:OpenCastleDoorByIndex(8)
			Winterblight:OpenCastleDoorByIndex(9)
			Winterblight:OpenCastleDoorByIndex(10)
			Winterblight:OpenCastleDoorByIndex(11)
			Winterblight:OpenCastleDoorByIndex(12)
			Winterblight:OpenCastleDoorByIndex(13)
		end)
		Dungeons.respawnPoint = Vector(11812, 13652)

	end
end

function Winterblight:SetupCastleData()
		Winterblight.CASTLE_DATA = {}

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

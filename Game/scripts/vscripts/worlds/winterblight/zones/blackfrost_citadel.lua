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
		Winterblight.CASTLE_DATA["tarot"][1]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][1]["prop_scale"] = 0.8
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][1] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][2] = {index = 2, variant = 1}

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
		Winterblight.CASTLE_DATA["rooms"][2]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["key_positions"] = {Vector(15488,1600)}
		Winterblight.CASTLE_DATA["rooms"][2]["cleared"] = 0
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
	Winterblight:SpawnRoomKey(room_index)
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
			Winterblight.ActiveCastleRoom["active"] = 2
		end)
	end
end

function Winterblight:SpawnCastleRoom2(variant)
	local room_index = 2
	if variant == 1 then
		-- Timers:CreateTimer(1, function()
		-- 	for i = 0, 3, 1 do
		-- 		for j = 0, 1, 1 do
		-- 			local fv = Vector(0,-1)
		-- 			local x_spacing = 188
		-- 			local y_spacing = 148
		-- 			local base_pos = Vector(13312, 14976)
		-- 			Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false)
		-- 		end
		-- 	end
		-- end)		
	end
end

function Winterblight:SpawnRoomKey(room_index)
	local position = Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"][RandomInt(1, #Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"])]
	local key = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	key:SetDayTimeVisionRange(300)
	key:SetNightTimeVisionRange(300)
	key:SetModel("models/gameplay/prison_key.vmdl")
	key:SetOriginalModel("models/gameplay/prison_key.vmdl")
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


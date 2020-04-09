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

		-- TAROT
		Winterblight.CASTLE_DATA["tarot"] = {}
		Winterblight.CASTLE_DATA["tarot"][1] = {}
		Winterblight.CASTLE_DATA["tarot"][1]["name"] = "fool"
		Winterblight.CASTLE_DATA["tarot"][1]["index"] = "00"
		Winterblight.CASTLE_DATA["tarot"][1]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][1]["prop_scale"] = 0.8

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
		Winterblight.CASTLE_DATA["tarot"][14]["prop_scale"] = 0.94
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
		PrecacheModel(model_name, function(...) end)
	end)
end
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
		end)
		Dungeons.respawnPoint = Vector(11812, 13652)
		Winterblight.TarotCardTable = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22}
		Winterblight.TarotCardTable = WallPhysics:ShuffleTable(Winterblight.TarotCardTable)
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
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][1] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][2] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][3] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][4] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][5] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][6] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][7] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][8] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][1]["rooms"][9] = {index = 9, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][2] = {}
		Winterblight.CASTLE_DATA["tarot"][2]["name"] = "magician"
		Winterblight.CASTLE_DATA["tarot"][2]["index"] = "01"
		Winterblight.CASTLE_DATA["tarot"][2]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][2]["prop_scale"] = 0.5
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][1] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][2] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][3] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][4] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][5] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][6] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][7] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][8] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][2]["rooms"][9] = {index = 11, variant = 2}

		Winterblight.CASTLE_DATA["tarot"][3] = {}
		Winterblight.CASTLE_DATA["tarot"][3]["name"] = "high_priestess"
		Winterblight.CASTLE_DATA["tarot"][3]["index"] = "02"
		Winterblight.CASTLE_DATA["tarot"][3]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][3]["prop_scale"] = 0.95
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][1] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][2] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][3] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][4] = {index = 11, variant = 3}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][5] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][6] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][7] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][8] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][3]["rooms"][9] = {index = 1, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][4] = {}
		Winterblight.CASTLE_DATA["tarot"][4]["name"] = "empress"
		Winterblight.CASTLE_DATA["tarot"][4]["index"] = "03"
		Winterblight.CASTLE_DATA["tarot"][4]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][4]["prop_scale"] = 0.85
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][1] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][2] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][3] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][4] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][5] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][6] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][7] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][8] = {index = 3, variant = 2}
		Winterblight.CASTLE_DATA["tarot"][4]["rooms"][9] = {index = 5, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][5] = {}
		Winterblight.CASTLE_DATA["tarot"][5]["name"] = "emperor"
		Winterblight.CASTLE_DATA["tarot"][5]["index"] = "04"
		Winterblight.CASTLE_DATA["tarot"][5]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][5]["prop_scale"] = 0.85
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][1] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][2] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][3] = {index = 7, variant = 2}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][4] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][5] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][6] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][7] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][8] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][5]["rooms"][9] = {index = 1, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][6] = {}
		Winterblight.CASTLE_DATA["tarot"][6]["name"] = "hierophant"
		Winterblight.CASTLE_DATA["tarot"][6]["index"] = "05"
		Winterblight.CASTLE_DATA["tarot"][6]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][6]["prop_scale"] = 0.62
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][1] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][2] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][3] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][4] = {index = 1, variant = 2}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][5] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][6] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][7] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][8] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][6]["rooms"][9] = {index = 12, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][7] = {}
		Winterblight.CASTLE_DATA["tarot"][7]["name"] = "lovers"
		Winterblight.CASTLE_DATA["tarot"][7]["index"] = "06"
		Winterblight.CASTLE_DATA["tarot"][7]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][7]["prop_scale"] = 1.02
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][1] = {index = 10, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][8] = {}
		Winterblight.CASTLE_DATA["tarot"][8]["name"] = "chariot"
		Winterblight.CASTLE_DATA["tarot"][8]["index"] = "07"
		Winterblight.CASTLE_DATA["tarot"][8]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][8]["prop_scale"] = 0.75
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][1] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][2] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][3] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][4] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][5] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][6] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][7] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][8] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][8]["rooms"][9] = {index = 7, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][9] = {}
		Winterblight.CASTLE_DATA["tarot"][9]["name"] = "strength"
		Winterblight.CASTLE_DATA["tarot"][9]["index"] = "08"
		Winterblight.CASTLE_DATA["tarot"][9]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][9]["prop_scale"] = 0.95
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][1] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][2] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][3] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][4] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][5] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][6] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][7] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][8] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][9]["rooms"][9] = {index = 8, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][10] = {}
		Winterblight.CASTLE_DATA["tarot"][10]["name"] = "hermit"
		Winterblight.CASTLE_DATA["tarot"][10]["index"] = "09"
		Winterblight.CASTLE_DATA["tarot"][10]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][10]["prop_scale"] = 0.95
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][1] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][2] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][3] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][4] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][5] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][6] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][7] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][8] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][10]["rooms"][9] = {index = 10, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][11] = {}
		Winterblight.CASTLE_DATA["tarot"][11]["name"] = "wheel_of_fortune"
		Winterblight.CASTLE_DATA["tarot"][11]["index"] = "10"
		Winterblight.CASTLE_DATA["tarot"][11]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][11]["prop_scale"] = 1.25
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][1] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][2] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][3] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][4] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][5] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][6] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][7] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][8] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][11]["rooms"][9] = {index = 12, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][12] = {}
		Winterblight.CASTLE_DATA["tarot"][12]["name"] = "justice"
		Winterblight.CASTLE_DATA["tarot"][12]["index"] = "11"
		Winterblight.CASTLE_DATA["tarot"][12]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][12]["prop_scale"] = 0.85
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][1] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][2] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][3] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][4] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][5] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][6] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][7] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][8] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][12]["rooms"][9] = {index = 9, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][13] = {}
		Winterblight.CASTLE_DATA["tarot"][13]["name"] = "hanged_man"
		Winterblight.CASTLE_DATA["tarot"][13]["index"] = "12"
		Winterblight.CASTLE_DATA["tarot"][13]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][13]["prop_scale"] = 0.92
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][1] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][2] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][3] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][4] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][5] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][6] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][7] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][8] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][13]["rooms"][9] = {index = 9, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][14] = {}
		Winterblight.CASTLE_DATA["tarot"][14]["name"] = "death"
		Winterblight.CASTLE_DATA["tarot"][14]["index"] = "13"
		Winterblight.CASTLE_DATA["tarot"][14]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][14]["prop_scale"] = 0.6
		Winterblight.CASTLE_DATA["tarot"][14]["horror"] = true
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][1] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][2] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][3] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][4] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][5] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][6] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][7] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][8] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][14]["rooms"][9] = {index = 1, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][15] = {}
		Winterblight.CASTLE_DATA["tarot"][15]["name"] = "temperance"
		Winterblight.CASTLE_DATA["tarot"][15]["index"] = "14"
		Winterblight.CASTLE_DATA["tarot"][15]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][15]["prop_scale"] = 0.9
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][1] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][2] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][3] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][4] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][5] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][6] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][7] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][8] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][15]["rooms"][9] = {index = 12, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][16] = {}
		Winterblight.CASTLE_DATA["tarot"][16]["name"] = "devil"
		Winterblight.CASTLE_DATA["tarot"][16]["index"] = "15"
		Winterblight.CASTLE_DATA["tarot"][16]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][16]["prop_scale"] = 0.66
		Winterblight.CASTLE_DATA["tarot"][16]["horror"] = true
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][1] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][2] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][3] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][4] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][5] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][6] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][7] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][8] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][16]["rooms"][9] = {index = 3, variant = 3}

		Winterblight.CASTLE_DATA["tarot"][17] = {}
		Winterblight.CASTLE_DATA["tarot"][17]["name"] = "tower"
		Winterblight.CASTLE_DATA["tarot"][17]["index"] = "16"
		Winterblight.CASTLE_DATA["tarot"][17]["prop_angle"] = Vector(0, 1)
		Winterblight.CASTLE_DATA["tarot"][17]["prop_scale"] = 0.52
		Winterblight.CASTLE_DATA["tarot"][17]["horror"] = true
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][1] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][2] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][3] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][1] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][5] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][6] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][7] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][8] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][17]["rooms"][9] = {index = 4, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][18] = {}
		Winterblight.CASTLE_DATA["tarot"][18]["name"] = "star"
		Winterblight.CASTLE_DATA["tarot"][18]["index"] = "17"
		Winterblight.CASTLE_DATA["tarot"][18]["prop_angle"] = Vector(-1, 0)
		Winterblight.CASTLE_DATA["tarot"][18]["prop_scale"] = 0.96
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][1] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][2] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][3] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][1] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][5] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][6] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][7] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][8] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][18]["rooms"][9] = {index = 7, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][19] = {}
		Winterblight.CASTLE_DATA["tarot"][19]["name"] = "moon"
		Winterblight.CASTLE_DATA["tarot"][19]["index"] = "18"
		Winterblight.CASTLE_DATA["tarot"][19]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][19]["prop_scale"] = 0.9
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][1] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][2] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][3] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][4] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][5] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][6] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][7] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][8] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][19]["rooms"][9] = {index = 11, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][20] = {}
		Winterblight.CASTLE_DATA["tarot"][20]["name"] = "sun"
		Winterblight.CASTLE_DATA["tarot"][20]["index"] = "19"
		Winterblight.CASTLE_DATA["tarot"][20]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][20]["prop_scale"] = 0.65
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][1] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][2] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][3] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][4] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][5] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][6] = {index = 10, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][7] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][8] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][20]["rooms"][9] = {index = 6, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][21] = {}
		Winterblight.CASTLE_DATA["tarot"][21]["name"] = "judgement"
		Winterblight.CASTLE_DATA["tarot"][21]["index"] = "20"
		Winterblight.CASTLE_DATA["tarot"][21]["prop_angle"] = Vector(1, 0)
		Winterblight.CASTLE_DATA["tarot"][21]["prop_scale"] = 0.84
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"] = {}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][1] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][2] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][3] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][4] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][5] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][6] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][7] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][8] = {index = 11, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][21]["rooms"][9] = {index = 12, variant = 1}

		Winterblight.CASTLE_DATA["tarot"][22] = {}
		Winterblight.CASTLE_DATA["tarot"][22]["name"] = "world"
		Winterblight.CASTLE_DATA["tarot"][22]["index"] = "21"
		Winterblight.CASTLE_DATA["tarot"][22]["prop_angle"] = Vector(0, -1)
		Winterblight.CASTLE_DATA["tarot"][22]["prop_scale"] = 0.87
		Winterblight.CASTLE_DATA["tarot"][22]["rooms"] = {}

		-- DOORS
		Winterblight.CASTLE_DATA["doors"] = {}
		Winterblight.CASTLE_DATA["doors"][1] = {}
		Winterblight.CASTLE_DATA["doors"][1]["position"] = Vector(12899, 13560, 1540)
		Winterblight.CASTLE_DATA["doors"][1]["name"] = "CastleWall0"
		Winterblight.CASTLE_DATA["doors"][1]["dust_start_position"] = Vector(12895, 13824)
		Winterblight.CASTLE_DATA["doors"][1]["dust_end_position"] =  Vector(12895, 13312)
		Winterblight.CASTLE_DATA["doors"][1]["blockers"] = "CastleWall0Blocker"
		Winterblight.CASTLE_DATA["doors"][1]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][2] = {}
		Winterblight.CASTLE_DATA["doors"][2]["position"] = Vector(13699, 14584, 1520)
		Winterblight.CASTLE_DATA["doors"][2]["name"] = "CastleWall1"
		Winterblight.CASTLE_DATA["doors"][2]["dust_start_position"] = Vector(13548, 14592)
		Winterblight.CASTLE_DATA["doors"][2]["dust_end_position"] =  Vector(13850, 14592)
		Winterblight.CASTLE_DATA["doors"][2]["blockers"] = "CastleWall1Blocker"
		Winterblight.CASTLE_DATA["doors"][2]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][3] = {}
		Winterblight.CASTLE_DATA["doors"][3]["position"] = Vector(15470, 14584, 1540)
		Winterblight.CASTLE_DATA["doors"][3]["name"] = "CastleWall2"
		Winterblight.CASTLE_DATA["doors"][3]["dust_start_position"] = Vector(15226, 14592)
		Winterblight.CASTLE_DATA["doors"][3]["dust_end_position"] =  Vector(15726, 14592)
		Winterblight.CASTLE_DATA["doors"][3]["blockers"] = "CastleWall2Blocker"
		Winterblight.CASTLE_DATA["doors"][3]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][4] = {}
		Winterblight.CASTLE_DATA["doors"][4]["position"] = Vector(12890, 10660, 1540)
		Winterblight.CASTLE_DATA["doors"][4]["name"] = "CastleWall3"
		Winterblight.CASTLE_DATA["doors"][4]["dust_start_position"] = Vector(12895, 10368)
		Winterblight.CASTLE_DATA["doors"][4]["dust_end_position"] =  Vector(12895, 11008)
		Winterblight.CASTLE_DATA["doors"][4]["blockers"] = "CastleWall3Blocker"
		Winterblight.CASTLE_DATA["doors"][4]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][5] = {}
		Winterblight.CASTLE_DATA["doors"][5]["position"] = Vector(15449, 9195, 1550)
		Winterblight.CASTLE_DATA["doors"][5]["name"] = "CastleWall4"
		Winterblight.CASTLE_DATA["doors"][5]["dust_start_position"] = Vector(15219, 9421)
		Winterblight.CASTLE_DATA["doors"][5]["dust_end_position"] =  Vector(15701, 8876)
		Winterblight.CASTLE_DATA["doors"][5]["blockers"] = "CastleWall4Blocker"
		Winterblight.CASTLE_DATA["doors"][5]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][6] = {}
		Winterblight.CASTLE_DATA["doors"][6]["position"] = Vector(11429, 7645, 1660)
		Winterblight.CASTLE_DATA["doors"][6]["name"] = "CastleWall5"
		Winterblight.CASTLE_DATA["doors"][6]["dust_start_position"] = Vector(11449, 7339)
		Winterblight.CASTLE_DATA["doors"][6]["dust_end_position"] =  Vector(11449, 7940)
		Winterblight.CASTLE_DATA["doors"][6]["blockers"] = "CastleWall5Blocker"
		Winterblight.CASTLE_DATA["doors"][6]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][7] = {}
		Winterblight.CASTLE_DATA["doors"][7]["position"] = Vector(13005, 5753, 2000)
		Winterblight.CASTLE_DATA["doors"][7]["name"] = "CastleWall6"
		Winterblight.CASTLE_DATA["doors"][7]["dust_start_position"] = Vector(13007, 6061)
		Winterblight.CASTLE_DATA["doors"][7]["dust_end_position"] =  Vector(13007, 5453)
		Winterblight.CASTLE_DATA["doors"][7]["blockers"] = "CastleWall6Blocker"
		Winterblight.CASTLE_DATA["doors"][7]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][8] = {}
		Winterblight.CASTLE_DATA["doors"][8]["position"] = Vector(10945, 3162, 2000)
		Winterblight.CASTLE_DATA["doors"][8]["name"] = "CastleWall7"
		Winterblight.CASTLE_DATA["doors"][8]["dust_start_position"] = Vector(10624, 3113)
		Winterblight.CASTLE_DATA["doors"][8]["dust_end_position"] =  Vector(11224, 3113)
		Winterblight.CASTLE_DATA["doors"][8]["blockers"] = "CastleWall7Blocker"
		Winterblight.CASTLE_DATA["doors"][8]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][9] = {}
		Winterblight.CASTLE_DATA["doors"][9]["position"] = Vector(13978, 2662, 2000)
		Winterblight.CASTLE_DATA["doors"][9]["name"] = "CastleWall8"
		Winterblight.CASTLE_DATA["doors"][9]["dust_start_position"] = Vector(13937, 2976)
		Winterblight.CASTLE_DATA["doors"][9]["dust_end_position"] =  Vector(13937, 2376)
		Winterblight.CASTLE_DATA["doors"][9]["blockers"] = "CastleWall8Blocker"
		Winterblight.CASTLE_DATA["doors"][9]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][10] = {}
		Winterblight.CASTLE_DATA["doors"][10]["position"] = Vector(9455, 988, 2000)
		Winterblight.CASTLE_DATA["doors"][10]["name"] = "CastleWall9"
		Winterblight.CASTLE_DATA["doors"][10]["dust_start_position"] = Vector(9216, 1024)
		Winterblight.CASTLE_DATA["doors"][10]["dust_end_position"] =  Vector(9728, 1024)
		Winterblight.CASTLE_DATA["doors"][10]["blockers"] = "CastleWall9Blocker"
		Winterblight.CASTLE_DATA["doors"][10]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][11] = {}
		Winterblight.CASTLE_DATA["doors"][11]["position"] = Vector(11645, -1625, 2000)
		Winterblight.CASTLE_DATA["doors"][11]["name"] = "CastleWall10"
		Winterblight.CASTLE_DATA["doors"][11]["dust_start_position"] = Vector(11422, -1670)
		Winterblight.CASTLE_DATA["doors"][11]["dust_end_position"] =  Vector(11904, -1670)
		Winterblight.CASTLE_DATA["doors"][11]["blockers"] = "CastleWall10Blocker"
		Winterblight.CASTLE_DATA["doors"][11]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][12] = {}
		Winterblight.CASTLE_DATA["doors"][12]["position"] = Vector(12960, -1625, 2000)
		Winterblight.CASTLE_DATA["doors"][12]["name"] = "CastleWall11"
		Winterblight.CASTLE_DATA["doors"][12]["dust_start_position"] = Vector(12672, -1670)
		Winterblight.CASTLE_DATA["doors"][12]["dust_end_position"] =  Vector(13184, -1670)
		Winterblight.CASTLE_DATA["doors"][12]["blockers"] = "CastleWall11Blocker"
		Winterblight.CASTLE_DATA["doors"][12]["state"] = "closed"

		Winterblight.CASTLE_DATA["doors"][13] = {}
		Winterblight.CASTLE_DATA["doors"][13]["position"] = Vector(14204, 13, 2000)
		Winterblight.CASTLE_DATA["doors"][13]["name"] = "CastleWall12"
		Winterblight.CASTLE_DATA["doors"][13]["dust_start_position"] = Vector(14208, 200)
		Winterblight.CASTLE_DATA["doors"][13]["dust_end_position"] =  Vector(14208, -200)
		Winterblight.CASTLE_DATA["doors"][13]["blockers"] = "CastleWall12Blocker"
		Winterblight.CASTLE_DATA["doors"][13]["state"] = "closed"

		-- ROOMS
		Winterblight.CASTLE_DATA["rooms"] = {}

		-- graveyard
		Winterblight.CASTLE_DATA["rooms"][1] = {}
		Winterblight.CASTLE_DATA["rooms"][1]["door_index"] = 2
		Winterblight.CASTLE_DATA["rooms"][1]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][1]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][1]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][1]["extra_goal"] = 8
		Winterblight.CASTLE_DATA["rooms"][1]["key_positions"] = {Vector(11264,15232), Vector(12544, 15232)}
		Winterblight.CASTLE_DATA["rooms"][1]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][1]["mid_point"] = Vector(12544, 15313)

		-- cellar
		Winterblight.CASTLE_DATA["rooms"][2] = {}
		Winterblight.CASTLE_DATA["rooms"][2]["door_index"] = 3
		Winterblight.CASTLE_DATA["rooms"][2]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["extra_goal"] = 30
		Winterblight.CASTLE_DATA["rooms"][2]["key_positions"] = {Vector(15488,16000), Vector(15440, 15307)}
		Winterblight.CASTLE_DATA["rooms"][2]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][2]["mid_point"] = Vector(15616, 15104)

		-- ice_harbor
		Winterblight.CASTLE_DATA["rooms"][3] = {}
		Winterblight.CASTLE_DATA["rooms"][3]["door_index"] = 4
		Winterblight.CASTLE_DATA["rooms"][3]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["key_positions"] = {Vector(11859,11682), Vector(11859, 10667), Vector(11628, 9898)}
		Winterblight.CASTLE_DATA["rooms"][3]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][3]["mid_point"] = Vector(11865, 10702)

		-- torture_chamber
		Winterblight.CASTLE_DATA["rooms"][4] = {}
		Winterblight.CASTLE_DATA["rooms"][4]["door_index"] = 5
		Winterblight.CASTLE_DATA["rooms"][4]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][4]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][4]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][4]["extra_goal"] = 25
		Winterblight.CASTLE_DATA["rooms"][4]["key_positions"] = {Vector(15784, 10496), Vector(15304, 11008), Vector(15304, 11392), Vector(15304, 11776)}
		Winterblight.CASTLE_DATA["rooms"][4]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][4]["mid_point"] = Vector(15298, 10572)

		-- mouldy_burial_chamber
		Winterblight.CASTLE_DATA["rooms"][5] = {}
		Winterblight.CASTLE_DATA["rooms"][5]["door_index"] = 6
		Winterblight.CASTLE_DATA["rooms"][5]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["key_positions"] = {Vector(10624, 6609), Vector(10624, 7212), Vector(10578, 8030)}
		Winterblight.CASTLE_DATA["rooms"][5]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][5]["mid_point"] = Vector(10690, 8093)

		-- lookout
		Winterblight.CASTLE_DATA["rooms"][6] = {}
		Winterblight.CASTLE_DATA["rooms"][6]["door_index"] = 7
		Winterblight.CASTLE_DATA["rooms"][6]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["key_positions"] = {Vector(15646, 5704), Vector(15410, 7380), Vector(16000, 4224)}
		Winterblight.CASTLE_DATA["rooms"][6]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][6]["mid_point"] = Vector(14697, 5747)

		-- slime_chamber
		Winterblight.CASTLE_DATA["rooms"][7] = {}
		Winterblight.CASTLE_DATA["rooms"][7]["door_index"] = 8
		Winterblight.CASTLE_DATA["rooms"][7]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["key_positions"] = {Vector(10837, 5609), Vector(9492, 5446), Vector(8960, 3660)}
		Winterblight.CASTLE_DATA["rooms"][7]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][7]["mid_point"] = Vector(10902, 3637)

		-- weapons_cache
		Winterblight.CASTLE_DATA["rooms"][8] = {}
		Winterblight.CASTLE_DATA["rooms"][8]["door_index"] = 9
		Winterblight.CASTLE_DATA["rooms"][8]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][8]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][8]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][8]["extra_goal"] = 15
		Winterblight.CASTLE_DATA["rooms"][8]["key_positions"] = {Vector(15669, 1024), Vector(15120, 1870), Vector(14413, 1965)}
		Winterblight.CASTLE_DATA["rooms"][8]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][8]["mid_point"] = Vector(15104, 1920)

		-- freezer
		Winterblight.CASTLE_DATA["rooms"][9] = {}
		Winterblight.CASTLE_DATA["rooms"][9]["door_index"] = 10
		Winterblight.CASTLE_DATA["rooms"][9]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["key_positions"] = {Vector(9412, -13), Vector(9412, -640), Vector(9088, -1152)}
		Winterblight.CASTLE_DATA["rooms"][9]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][9]["mid_point"] = Vector(9441, -256)

		-- treasure_stash
		Winterblight.CASTLE_DATA["rooms"][10] = {}
		Winterblight.CASTLE_DATA["rooms"][10]["door_index"] = 11
		Winterblight.CASTLE_DATA["rooms"][10]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["key_positions"] = {Vector(11612, -2688), Vector(10491, -2688)}
		Winterblight.CASTLE_DATA["rooms"][10]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][10]["mid_point"] = Vector(11008, -2688)

		-- font_of_luminescence
		Winterblight.CASTLE_DATA["rooms"][11] = {}
		Winterblight.CASTLE_DATA["rooms"][11]["door_index"] = 12
		Winterblight.CASTLE_DATA["rooms"][11]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["extra_goal"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["key_positions"] = {Vector(12928, -2944), Vector(15257, -2775), Vector(14350, -2018)}
		Winterblight.CASTLE_DATA["rooms"][11]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][11]["mid_point"] = Vector(12971, -2673)

		-- blue_goo_room
		Winterblight.CASTLE_DATA["rooms"][12] = {}
		Winterblight.CASTLE_DATA["rooms"][12]["door_index"] = 13
		Winterblight.CASTLE_DATA["rooms"][12]["active"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["enemy_spawn_count"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["enemies_slain"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["extra_goal"] = -1
		Winterblight.CASTLE_DATA["rooms"][12]["key_positions"] = {Vector(15240, -863), Vector(15694, -632), Vector(15744, -1792)}
		Winterblight.CASTLE_DATA["rooms"][12]["cleared"] = 0
		Winterblight.CASTLE_DATA["rooms"][12]["mid_point"] = Vector(15620, -620)
end

function Winterblight:InitCastleProps()
	local goo = Entities:FindByNameNearest("CastleGoo", Vector(9742, 4586, 1600), 2000)
	goo:SetAbsOrigin(goo:GetAbsOrigin()+Vector(0,0,300))
end

function Winterblight:OpenCastleDoorByIndex(index)
	local DoorsData = Winterblight.CASTLE_DATA["doors"]
	if DoorsData[index]["state"] == "closed" then
		local walls = Entities:FindAllByNameWithin(DoorsData[index]["name"], DoorsData[index]["position"], 1200)
		Winterblight:WallsTicks(false, walls, true, 5.5, 150, 0.05)
		if DoorsData[index]["generated_blockers"] then
			for i = 1, #DoorsData[index]["generated_blockers"], 1 do
				UTIL_Remove(DoorsData[index]["generated_blockers"][i])
			end
		else
			Winterblight:RemoveBlockers(4, DoorsData[index]["blockers"], DoorsData[index]["position"], 1600)
		end
		Events:DoorDust(DoorsData[index]["dust_start_position"], DoorsData[index]["dust_end_position"], 20, 0.3)
		DoorsData[index]["state"] = "open"
	end
end

function Winterblight:CloseCastleDoorByRoomIndex(room_index)
	local index = Winterblight.CASTLE_DATA["rooms"][room_index]["door_index"]
	local DoorsData = Winterblight.CASTLE_DATA["doors"]
	if DoorsData[index]["state"] == "open" then
		local walls = Entities:FindAllByNameWithin(DoorsData[index]["name"], DoorsData[index]["position"]-Vector(0,0,100), 1200)
		Winterblight:WallsTicks(true, walls, true, 5.5, 150, 0.05)
		Events:DoorDust(DoorsData[index]["dust_start_position"], DoorsData[index]["dust_end_position"], 20, 0.3)

		local startPos = GetGroundPosition(DoorsData[index]["dust_start_position"], Events.GameMaster)
		local endPos = GetGroundPosition(DoorsData[index]["dust_end_position"], Events.GameMaster)
		local fv = ((endPos - startPos)*Vector(1,1,0)):Normalized()
		local distance = WallPhysics:GetDistance2d(startPos, endPos)

		DoorsData[index]["generated_blockers"] = {}
		for i = 0, math.ceil(distance/128), 1 do
			local position = startPos + fv*128*i
			local blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = position})
			table.insert(DoorsData[index]["generated_blockers"], blocker)
		end

		Winterblight.CastleDungeonMaster.closed_door_index = index
		DoorsData[index]["state"] = "closed"
	end
end

function Winterblight:TarotCardSelect(msg)
	local playerID = msg.PlayerID
	local selection = msg.card_index
	print("CARD SELECTED: "..selection)
	CustomGameEventManager:Send_ServerToAllClients("close_wb_castle_tarot", {})
	if Winterblight.CastleTarot then
		return false
	end
	Winterblight.CastleDungeonMaster.phase = 1
	Winterblight.CastleDungeonMaster.selected_card = selection
	EmitSoundOn("Winterblight.TarotCardSelect", Winterblight.CastleDungeonMaster)
	EmitSoundOn("Winterblight.TarotCardSelect.Ping", Winterblight.CastleDungeonMaster)

	local actualTarot = Winterblight.TarotCardTable[selection + 1]
	Winterblight.CastleTarot = Winterblight.CASTLE_DATA["tarot"][actualTarot]

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
			
		end
		PrecacheUnitByNameAsync(model_name, precache_function)
	end)
	Timers:CreateTimer(2, function()
		Winterblight:PrecacheTarotAssets()
	end)
	if Winterblight.CastleTarot["name"] == "hanged_man" then
		Winterblight:HangedManPrepareHashMap()
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		Winterblight:TemperanceWaterProps()
		Winterblight.TemperanceDungeonStartTime = GameRules:GetGameTime()
	elseif Winterblight.CastleTarot["name"] == "devil" then
		Winterblight:DevilBloodProps()
	elseif Winterblight.CastleTarot["name"] == "moon" then
		Winterblight:CastleMoonProps()
	end
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
	if Winterblight.CastleTarot["name"] == "world" then
		local goo_dummy = CreateUnitByName("npc_dummy_unit", Vector(9778, 4642), false, nil, nil, DOTA_TEAM_NEUTRALS)
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, goo_dummy, "modifier_room_7_goo_aura", {})
		goo_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		Winterblight.CastleDungeonMaster.goo_dummy = goo_dummy
		Winterblight.CastleDungeonMaster.goo_switches = {0, 0, 0}
	end
	if spawnIndex == 1 then
		Timers:CreateTimer(0.2, function()
			local positionTable = {Vector(13440, 13858), Vector(13952, 13742), Vector(13952, 13440), Vector(13440, 13056)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(13467, 13568) - positionTable[i]):Normalized()
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_accursed", positionTable[i], fv, false, true)
			end
		end)
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(14336, 13312), Vector(14592, 13312), Vector(14848, 13312), Vector(15104, 13312), Vector(15360, 13312)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_frozen_cage", positionTable[i], fv, false, true)
			end
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(14208, 13628), Vector(14515, 13628), Vector(14821, 13628), Vector(15135, 13628)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(-1,0)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_castle_warrior", positionTable[i], fv, false, true)
			end
		end)
		Timers:CreateTimer(2, function()
			Winterblight:SpawnCastleRoomUnit(0, "winterblight_mountain_spirit", Vector(15616, 13233), Vector(-1,1), false, true)
		end)
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(13824, 11648), Vector(13517, 11648), Vector(13517, 11904), Vector(13824, 11904), Vector(13496, 12164), Vector(13824, 12164)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_wraithguard", positionTable[i], fv, false, true)
			end
		end)
		Timers:CreateTimer(3.0, function()
			local positionTable = {Vector(13524, 12682), Vector(13824, 12682)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_wraithguard_elite", positionTable[i], fv, false, true)
			end
		end)
		Timers:CreateTimer(4, function()
			local positionTable = {Vector(13440, 10500), Vector(13656, 10485), Vector(13440, 10697), Vector(13672, 10678), Vector(13440, 10880), Vector(13666, 10880)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_castle_warrior", positionTable[i], fv, false, true)
			end
			local positionTable = {Vector(13952, 10749), Vector(13952, 10527)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(-1,1)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_frozen_mage", positionTable[i], fv, false, true)
			end
		end)
	end
	Timers:CreateTimer(5.0, function()
		local positionTable = {Vector(13440, 9216), Vector(13912, 9216)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_castle_watchman", positionTable[i], fv, false, true)
		end
		local positionTable = {Vector(13730, 8049), Vector(14208, 8192)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(-0.2,1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_accursed", positionTable[i], fv, false, true)
		end
		for i = 0, 3, 1 do
			for j = 0, 1, 1 do
				local fv = Vector(0,1)
				local x_spacing = 128
				local y_spacing = 128
				local base_pos = Vector(13420, 8661)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_frozen_phantom", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, true)
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
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_frozen_soul", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, true)
			end
		end
	end)
	Timers:CreateTimer(8, function()
		local positionTable = {Vector(13269, 7805), Vector(12032, 7936)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(13209, 8448) - positionTable[i]):Normalized()
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_draugr", positionTable[i], fv, false, true)
		end
		Winterblight:SpawnCastleRoomUnit(0,"winterblight_castle_watchman", Vector(12288, 7040), Vector(1,0.6), false, true)
	end)
	Timers:CreateTimer(9.0, function()
		for i = 0, 1, 1 do
			for j = 0, 3, 1 do
				local fv = Vector(0,1)
				local x_spacing = 600
				local y_spacing = 128
				local base_pos = Vector(11904, 5338)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_frozen_mage", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, true)
			end
		end
	end)
	Timers:CreateTimer(10, function()
		local positionTable = {Vector(12919, 4415), Vector(12800, 4631), Vector(12672, 4960), Vector(12032, 4550), Vector(11799, 4722), Vector(12040, 4960)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(12396, 4734) - positionTable[i]):Normalized()
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_castle_warrior", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(13696, 12160), Vector(13040, 8251), Vector(12288, 5760), Vector(12416, 2560), Vector(9387, 2041)}
		local patrol_unit = "winterblight_skull_ripper"
		if Winterblight.CastleTarot["name"] == "hermit" then
			patrol_unit = "winterblight_shadow_wanderer"
		elseif Winterblight.CastleTarot["name"] == "moon" then
			patrol_unit = "winterblight_castle_werewolf"
		end
		Enemies:CreateUnitsWithPatrol(patrol_unit, 2, positionTable, 25, 12, 300, 300, 1, 1)
	end)
	Timers:CreateTimer(11, function()
		local positionTable = {Vector(11906, 7040), Vector(12582, 6144), Vector(14272, 9250), Vector(13440, 3968)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(13568, 9344) - positionTable[i]):Normalized()
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_suffering_spirit", positionTable[i], fv, false, true)
		end
		Winterblight:SpawnCastleRoomUnit(0,"winterblight_ancient_mountain_spirit", Vector(14080, 8576), Vector(-0.2, 1), false, true)
	end)
	Timers:CreateTimer(12, function()
		for i = 0, 2, 1 do
			for j = 0, 1, 1 do
				local fv = Vector(1,0)
				local x_spacing = 288
				local y_spacing = 428
				local base_pos = Vector(10350, 2033)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_defiler", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, true)
			end
		end
	end)
	Timers:CreateTimer(14, function()
		local positionTable = {Vector(11904, 3350), Vector(13056, 2891), Vector(12160, 2560)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(12396, 4734) - positionTable[i]):Normalized()
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_wraithguard_elite", positionTable[i], fv, false, true)
		end
		local positionTable = {Vector(12323, 1794), Vector(12800, 1494)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_castle_watchman", positionTable[i], fv, false, true)
		end
	end)	
	Timers:CreateTimer(13.5, function()
		local positionTable = {Vector(12294, 5708), Vector(12142, 6108), Vector(12350, 6364), Vector(11904, 6364)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Winterblight:SpawnCastleRoomUnit(0, "winterblight_elite_ghoul", positionTable[i], fv, false, true)
			end)
		end
	end)
	Timers:CreateTimer(14.5, function()
		local positionTable = {Vector(12039, 2915), Vector(11776, 2944), Vector(11925, 2688)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Winterblight:SpawnCastleRoomUnit(0, "winterblight_elite_ghoul", positionTable[i], fv, false, true)
			end)
		end
	end)
	Timers:CreateTimer(10.5, function()
		local positionTable = {Vector(12016, 8358), Vector(11776, 8448), Vector(11971, 8662)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Winterblight:SpawnCastleRoomUnit(0, "winterblight_frozen_mage", positionTable[i], fv, false, true)
			end)
		end
	end)

	Timers:CreateTimer(15.5, function()
		local positionTable = {Vector(12134, 3840), Vector(12032, 3454), Vector(11648, 3712)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Winterblight:SpawnCastleRoomUnit(0,"winterblight_draugr", positionTable[i], fv, false, true)
			end)
		end
	end)

	Timers:CreateTimer(17.5, function()
		local positionTable = {Vector(9856, 1408), Vector(10240, 1541)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(1,0)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_suffering_spirit", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(18.5, function()
		local positionTable = {Vector(8964, 2508), Vector(8964, 2048), Vector(8964, 1664)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(1,0)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_castle_watchman", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(19.5, function()
		local positionTable = {Vector(13396, 1920), Vector(13620, 2103), Vector(13312, 2304)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.25, function()
				local fv = RandomVector(1)
				Winterblight:SpawnCastleRoomUnit(0, "winterblight_elite_ghoul", positionTable[i], fv, false, true)
			end)
		end
	end)
	Timers:CreateTimer(20.5, function()
		if Winterblight.CastleTarot["name"] =="hierophant" or Winterblight.CastleTarot["name"] =="temperance" then
			local baseFV = Vector(1,0)
			for i = 1, 10, 1 do
				local rotatedFV = WallPhysics:rotateVector(baseFV, 2*math.pi*i/10)
				local position = Vector(12288, 224) + rotatedFV*600
				local fv = rotatedFV*-1
				Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_watchman", position, fv, false, true)
			end
		end
	end)
	Timers:CreateTimer(21, function()
		if Winterblight.CastleTarot["name"] =="hierophant" then
			local luck = RandomInt(1, 4)
			if luck <= 1 + Winterblight.Stones then
				local xelethar = Winterblight:SpawnCastleRoomUnit(0, "winterblight_high_priest_xelethar", Vector(12285, 163), Vector(0,-1), false, true)
				local groundHeight = GetGroundHeight(Vector(11393, 163), xelethar)
				xelethar:SetAbsOrigin(Vector(12285, 163) + Vector(0,0,groundHeight))
				Winterblight.xelethar = xelethar
				xelethar:AddLootDrop("special", "item_rpc_winterblight_tarot_card", 100)
				xelethar:AddLootDrop("immortal", "item_rpc_glove_of_the_hierophant", 100)
			end
		elseif Winterblight.CastleTarot["name"] == "empress" then
			if GameState:GetDifficultyFactor() > 2 then
				Winterblight:SpawnEmpressBoss()
			end
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
	if Winterblight.CastleTarot["name"] == "empress" then
		local key_positions = Winterblight.CASTLE_DATA["rooms"][index]["key_positions"]
		local position = key_positions[RandomInt(1, #key_positions)] + RandomVector(200)
		local luck = RandomInt(1, 2)
		if luck == 1 then
			Winterblight:SpawnArcaneCrystalMine(position)
		end
	elseif Winterblight.CastleTarot["name"] == "emperor" then
		if not Winterblight.CastleEmperorChests then
			Winterblight.CastleEmperorChests = 3
		end
		if Winterblight.CastleEmperorChests > 0 then
			local luck = RandomInt(1, 9 - Winterblight.CASTLE_DATA["rooms_cleared"])
			if luck <= Winterblight.CastleEmperorChests then
				Winterblight.CastleEmperorChests = Winterblight.CastleEmperorChests - 1
				local key_positions = Winterblight.CASTLE_DATA["rooms"][index]["key_positions"]
				local position = key_positions[RandomInt(1, #key_positions)] + RandomVector(200)
				Winterblight:GeneralChestSpawn(position, Vector(0,-1))
			end
		end
	elseif Winterblight.CastleTarot["name"] == "fool" then
		if not Winterblight.CastleFoolChests then
			Winterblight.CastleFoolChests = 1
		end
		if Winterblight.CastleFoolChests > 0 then
			local luck = RandomInt(1, 9 - Winterblight.CASTLE_DATA["rooms_cleared"])
			if luck <= Winterblight.CastleFoolChests then
				Winterblight.CastleFoolChests = Winterblight.CastleFoolChests - 1
				local key_positions = Winterblight.CASTLE_DATA["rooms"][index]["key_positions"]
				local position = key_positions[RandomInt(1, #key_positions)] + RandomVector(200)
				Winterblight:GeneralChestSpawn(position, Vector(0,-1))
			end
		end
	elseif Winterblight.CastleTarot["name"] == "hermit" then
		local key_positions = Winterblight.CASTLE_DATA["rooms"][index]["key_positions"]
		for i = 1, #key_positions, 1 do
			local spawnPos = key_positions[i] + RandomVector(320)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", spawnPos, RandomVector(1), false, true)
		end
	elseif Winterblight.CastleTarot["name"] == "wheel_of_fortune" then
		local key_positions = Winterblight.CASTLE_DATA["rooms"][index]["key_positions"]
		local position = key_positions[RandomInt(1, #key_positions)] + RandomVector(200)
		Winterblight:GeneralChestSpawn(position, Vector(0,-1))
	elseif Winterblight.CastleTarot["name"] == "justice" then
		if not Winterblight.CastleJusticeData then
			Winterblight:HandleJusticeSpawns()
		end
	elseif Winterblight.CastleTarot["name"] == "hanged_man" then
		Winterblight:HangedManSpawns(index)
	elseif Winterblight.CastleTarot["name"] == "devil" then
		Winterblight:SpawnDevilRings(index)
	elseif Winterblight.CastleTarot["name"] == "moon" then
		local key_positions = Winterblight.CASTLE_DATA["rooms"][index]["key_positions"]
		if not Winterblight.CastleDungeonMaster.moon_ghost_table then
			Winterblight.CastleDungeonMaster.moon_ghost_table = {}
		end
		local ghost_position = key_positions[RandomInt(1, #key_positions)] + RandomVector(RandomInt(200, 500))
		local moon_ghost_table_item = {}
		moon_ghost_table_item["position"] = ghost_position
		moon_ghost_table_item["active"] = 1
		table.insert(Winterblight.CastleDungeonMaster.moon_ghost_table, moon_ghost_table_item)
	elseif Winterblight.CastleTarot["name"] == "sun" then
		Winterblight:SpawnSunGroundFire(index)
	end
end

function Winterblight:SpawnArcaneCrystalMine(position)
	local crystal_mine = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	crystal_mine:SetOriginalModel("models/props_gameplay/rune_invisibility01.vmdl")
	crystal_mine:SetModel("models/props_gameplay/rune_invisibility01.vmdl")
	crystal_mine.jumpLock = true
	crystal_mine:SetForwardVector(Vector (0, 1))
	crystal_mine:SetModelScale(4.0)
	crystal_mine.resource_mult = 12
	crystal_mine:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
	crystal_mine:AddAbility("redfall_arcane_crystal_mine"):SetLevel(1)
	crystal_mine:RemoveAbility("dummy_unit")
	crystal_mine:RemoveModifierByName("dummy_unit")
	crystal_mine.attacks = 6
end

function Winterblight:SpawnCastleRoomUnit(room_index, unit_name, position, fv, aggro, bIgnoreCounter)

	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	if Winterblight.CastleTarot["name"] == "magician" then
		if unit_name == "winterblight_frozen_phantom" then
			unit_name = "winterblight_green_magician"
		elseif unit_name == "winterblight_frozen_mage" then
			unit_name = "winterblight_blue_magician"
		elseif unit_name == "winterblight_frozen_soul" then
			unit_name = "winterblight_red_magician"
		end
	elseif Winterblight.CastleTarot["name"] == "high_priestess" then
		if unit_name == "winterblight_castle_watchman" then
			unit_name = "winterblight_shadow_priestess"
		end
	elseif Winterblight.CastleTarot["name"] == "emperor" then
		if unit_name == "winterblight_elite_castle_warrior" then
			unit_name = "winterblight_emperors_servant"
		elseif unit_name == "winterblight_castle_warrior" then
			unit_name = "winterblight_elite_castle_warrior"
		end
	elseif Winterblight.CastleTarot["name"] == "hierophant" then
		if unit_name == "winterblight_castle_watchman" then
			unit_name = "winterblight_necro_knight"
		end
	elseif Winterblight.CastleTarot["name"] == "lovers" then
		local possible_units_table = {"winterblight_castle_watchman", "winterblight_draugr", "winterblight_accursed", "winterblight_castle_warrior", "winterblight_elite_castle_warrior", "winterblight_defiler", "winterblight_wraithguard", "winterblight_bloodripper", "winterblight_frozen_mage", "winterblight_frozen_soul", "winterblight_frozen_cage", "winterblight_frozen_phantom", "winterblight_suffering_spirit", "winterblight_elite_ghoul", "winterblight_ghost_pirate"}
		if WallPhysics:DoesTableHaveValue(possible_units_table, unit_name) then
			local luck = RandomInt(1, 10)
			if luck == 1 then
				unit_name = "winterblight_dual_drake"
			end
		end
	elseif Winterblight.CastleTarot["name"] == "strength" then
		if unit_name ~= "winterblight_castle_strength_spine_drake" then
			local luck = RandomInt(1, 100)
			if luck == 1 then
				local drake = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_strength_spine_drake", position+RandomVector(240), fv, false, true)
				SpecialFX:ColoredPop(dragon:GetAbsOrigin()+Vector(0,0,150), Vector(255, 120, 120))
				local modelScale = drake:GetModelScale()
				Events:smoothSizeChange(drake, 0.3, modelScale, 12)
			end
		end
	elseif Winterblight.CastleTarot["name"] == "hermit" then
		if unit_name == "winterblight_elite_castle_warrior" then
			unit_name = "winterblight_castle_elite_hermit_hoodling"
		elseif unit_name == "winterblight_castle_warrior" then
			unit_name = "winterblight_castle_hermit_hoodling"
		elseif unit_name == "winterblight_skull_ripper" then
			unit_name = "winterblight_shadow_wanderer"
		end
	elseif Winterblight.CastleTarot["name"] == "hanged_man" then
		unit_name = Winterblight:TranslateHangedManUnit(unit_name)
	elseif Winterblight.CastleTarot["name"] == "death" then
		if unit_name == "winterblight_castle_warrior" or unit_name == "winterblight_frozen_cage" then
			unit_name = "winterblight_castle_watchman"
		elseif unit_name == "winterblight_elite_castle_warrior" or unit_name == "winterblight_mountain_spirit" then
			unit_name = "winterblight_necro_knight"
		end
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		if unit_name == "winterblight_castle_watchman" then
			unit_name = "winterblight_water_bearer"
		end
	elseif Winterblight.CastleTarot["name"] == "devil" then
		if unit_name == "winterblight_castle_watchman" then
			unit_name = "winterblight_winterblight_devil_watcher"
		elseif unit_name == "winterblight_castle_warrior" then
			unit_name = "winterblight_winterblight_devil_warrior"
		elseif unit_name == "winterblight_elite_castle_warrior" then
			unit_name = "winterblight_winterblight_elite_devil_warrior"
		end
	elseif Winterblight.CastleTarot["name"] == "star" then
		if unit_name == "winterblight_castle_watchman" then
			unit_name = "winterblight_star_watcher"
		end
	elseif Winterblight.CastleTarot["name"] == "moon" then
		if unit_name == "winterblight_castle_watchman" or unit_name == "winterblight_skull_ripper" then
			unit_name = "winterblight_castle_werewolf"
		elseif unit_name == "winterblight_elite_castle_warrior" then
			unit_name = "winterblight_elite_castle_werewolf"
		end
	elseif Winterblight.CastleTarot["name"] == "sun" then
		if unit_name == "winterblight_draugr" or unit_name == "winterblight_accursed" then
			unit_name =  "winterblight_temple_sun_crow"
		elseif unit_name == "winterblight_castle_warrior" then
			unit_name = "winterblight_heat_fletcher"
		elseif unit_name == "winterblight_elite_castle_warrior" then
			unit_name = "winterblight_elite_heat_fletcher"
		elseif unit_name == "winterblight_castle_watchman" then
			unit_name = "winterblight_iron_sun_warrior"
		end
	elseif Winterblight.CastleTarot["name"] == "judgement" then
		if unit_name == "winterblight_castle_watchman" then
			unit_name = "winterblight_judgement_fallen"
		end
	end
	local enemy = Enemies:SpawnEnemyUnit(unit_name, position, fv, aggro)
	if unit_name == "winterblight_temple_sun_crow" then
		enemy:AddLootDrop("special", "item_rpc_winterblight_dragon_scale", 0.1)
	elseif unit_name == "winterblight_dual_drake" then
		enemy:AddLootDrop("special", "item_rpc_winterblight_dragon_scale", 0.3)
	elseif unit_name == "winterblight_castle_strength_spine_drake" then
		enemy:AddLootDrop("special", "item_rpc_winterblight_dragon_scale", 4)
	elseif unit_name == "winterblight_ice_harbor_mini_boss" then
		enemy:AddLootDrop("special", "item_rpc_winterblight_dragon_scale", 10)
	end
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, enemy, "modifier_winter_castle_room_unit", {})
	enemy.room_index = room_index

	if bIgnoreCounter then
	else
		Winterblight.ActiveCastleRoom["enemy_spawn_count"] = Winterblight.ActiveCastleRoom["enemy_spawn_count"] + 1
		print("SPAWN FOR ROOM")
		print(Winterblight.ActiveCastleRoom["enemy_spawn_count"])
		print(unit_name)
	end
	Timers:CreateTimer(0.1, function()
		Winterblight:AdjustCastleUnit(enemy)
	end)
	if Winterblight.CastleTarot["name"] == "hierophant" then
		local luck = RandomInt(1, 500)
		if luck == 1 then
			local chest_position = position + RandomVector(120)
			Winterblight:GeneralChestSpawn(chest_position, fv)
		end
	elseif Winterblight.CastleTarot["name"] == "chariot" then
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, enemy, "modifier_chariot_speed", {})
	elseif Winterblight.CastleTarot["name"] == "strength" then
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, enemy, "modifier_strength_attack_power_enemy", {})
	elseif Winterblight.CastleTarot["name"] == "wheel_of_fortune" then
		Timers:CreateTimer(0.15, function()
			if enemy:IsAlive() then
				local attempt_paragon = Winterblight:CastleWheelOfFortuneParagonChance(enemy)
				if attempt_paragon then
					SpecialFX:ColoredPop(enemy:GetAbsOrigin()+Vector(0,0,60), Vector(255, 255, 0))
				end
			end
		end)
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, enemy, "modifier_temperance_enemy_buff", {})
	elseif Winterblight.CastleTarot["name"] == "tower" then
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, enemy, "modifier_tower_attack_buff", {})
		local startScale = enemy:GetModelScale()
		local endScale = startScale*1.22
		Events:smoothSizeChange(enemy, startScale, endScale, 33)
		if enemy:HasAbility("mega_steadfast") then
			enemy:RemoveAbility("mega_steadfast")
			enemy:RemoveModifierByName("modifier_mega_steadfast")
			enemy:AddAbility("ancient_god_steadfast"):SetLevel(GameState:GetDifficultyFactor())
		elseif enemy:HasAbility("normal_steadfast") then
			enemy:RemoveAbility("normal_steadfast")
			enemy:RemoveModifierByName("modifier_steadfast")
			enemy:AddAbility("mega_steadfast"):SetLevel(GameState:GetDifficultyFactor())

		else
			enemy:AddAbility("normal_steadfast"):SetLevel(GameState:GetDifficultyFactor())
		end
	elseif Winterblight.CastleTarot["name"] == "sun" then
		local luck = RandomInt(1, 5)
		if luck == 1 then
			local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, enemy, "modifier_diviner_sun_immolation", {})
		end
	elseif Winterblight.CastleTarot["name"] == "world" then
		SpecialFX:ColoredPop(enemy:GetAbsOrigin()+Vector(0,0,60), Vector(120, 255, 140))
	end
	return enemy
end

function Winterblight:AdjustCastleUnit(enemy)
	if enemy:IsAlive() then
		if Winterblight.CastleTarot["name"] == "empress" then
			local newArmor = enemy.roshpit_attributes.roshpit_armor * 2
			enemy:SetBaseRoshpitArmor(newArmor, false)

			local newMagicArmor = enemy.roshpit_attributes.roshpit_magic_armor * 2
			enemy:SetBaseRoshpitMagicArmor(newMagicArmor, false)

			enemy:CalculateAndSaveRoshpitAttributes()
		elseif Winterblight.CastleTarot["name"] == "emperor" then
			local newArmorPierce = enemy.roshpit_attributes.roshpit_armor_pierce * 2
			enemy:SetBaseRoshpitArmorPierce(newArmorPierce, false)

			local newSpellPierce = enemy.roshpit_attributes.roshpit_spell_pierce * 2
			enemy:SetBaseRoshpitSpellPierce(newSpellPierce, false)

			enemy:CalculateAndSaveRoshpitAttributes()
		elseif Winterblight.CastleTarot["name"] == "strength" then
			local strength_hp_increase_pct = {30, 60, 90}
			local newMaxHP = enemy:GetMaxHealth() * (1 + strength_hp_increase_pct[GameState:GetDifficultyFactor()]/100)
			enemy:SetMaxHPandHealToFull(newMaxHP)
		end
	end
end

function Winterblight:CastleRoomEnemyGoalReached(room_index)
	if not Winterblight.CastleDungeonMaster.key_drops then
		Winterblight.CastleDungeonMaster.key_drops = 0
	end
	if room_index == 12 then
		Timers:CreateTimer(10, function()
		 	Winterblight:BlueGooSwitchCheck()
		end)
	end
	if Winterblight.CastleDungeonMaster.key_drops == 0 and Winterblight.CastleTarot["name"] == "lovers" then
		Winterblight.CastleDungeonMaster.key_drops = Winterblight.CastleDungeonMaster.key_drops + 1
		Winterblight:SpawnTreasureRoomLoversHearts()
	else
		Winterblight.CastleDungeonMaster.key_drops = Winterblight.CastleDungeonMaster.key_drops + 1
		if Winterblight.CastleTarot["name"] == "world" then
			if Winterblight.CastleDungeonMaster.key_drops == 12 then
				Winterblight:SpawnRoomKey(room_index, true)
			else
				Winterblight:SpawnRoomKey(room_index, false)
			end
		else
			if Winterblight.CastleDungeonMaster.key_drops == #Winterblight.CastleTarot["rooms"] then
				Winterblight:SpawnRoomKey(room_index, true)
			else
				Winterblight:SpawnRoomKey(room_index, false)
			end
		end
	end
	if Winterblight.CastleTarot["name"] == "judgement" then
		Winterblight:JudgementShow(room_index)
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
			if Winterblight.CastleLoversPath and Winterblight.CastleLoversPath == "galren" then
				local galren = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_galren", Vector(12207, 15488), Vector(0,-1), false, false)
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, galren, "modifier_lovers_miniboss", {})
			end
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
	elseif variant == 2 then
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
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_necro_knight", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(4, function()
			local positionTable = {Vector(12160, 15744), Vector(12160, 16000), Vector(12920, 16000), Vector(12920, 15744)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_necro_knight", positionTable[i], fv, false, false)
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
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_necro_knight", positionTable[i], fv, false, false)
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
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_spider_egg_sack", positionTable[i], RandomVector(1), false, true)
			end
			-- add 5 to extra_goal for each spider sack
		end)	
	end
end

function Winterblight:SpawnCastleRoom3(variant)
	local room_index = 3
	if variant == 1 or variant == 2 then
		local positionTable = {Vector(12416, 9715), Vector(12416, 11776), Vector(11136, 11576), Vector(11264, 9472)}
		Enemies:CreateUnitsWithPatrol("winterblight_black_gargoyle", 3, positionTable, 34, 7, 300, 300, 0.2, 0.2)
		Timers:CreateTimer(0.5, function()
			for i = 0, 2, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,0)
					local x_spacing = 196
					local y_spacing = 196
					local base_pos = Vector(12381, 10496)
					Winterblight:SpawnCastleRoomUnit(0, "winterblight_frozen_phantom", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, true)
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
				Winterblight:SpawnCastleRoomUnit(0, "winterblight_ancient_mountain_spirit", positionTable[i], fv, false, true)
			end
		end)	
		Timers:CreateTimer(2, function()
			for i = 0, 1, 1 do
				for j = 0, 4, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 304
					local y_spacing = 166
					local base_pos = Vector(11726, 11106)
					Winterblight:SpawnCastleRoomUnit(0, "winterblight_frozen_mage", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, true)
				end
			end
		end)
		Timers:CreateTimer(2.5, function()
			if variant == 1 then
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_ice_harbor_mini_boss", Vector(11859, 12105), Vector(0,-1), false, false)
			elseif variant == 2 then
				Winterblight:SpawnCastleRoomUnit(room_index, "winter_castle_faceless_empress", Vector(11859, 12105), Vector(0,-1), false, false)
			end
			if Winterblight.CastleTarot["name"] == "lovers" then
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_ice_harbor_mini_boss", Vector(11648, 9984), Vector(0,1), false, false)
			end
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
	elseif variant == 3 then
		local positionTable = {Vector(12416, 9715), Vector(12416, 11776), Vector(11136, 11576), Vector(11264, 9472)}
		for i = 1, #positionTable, 1 do
			for j = 1, 2, 1 do
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_saturn_zealot", positionTable[i]+RandomVector(RandomInt(10, 240)), RandomVector(1), false, false)
			end
		end
		Timers:CreateTimer(1, function()
			for i = 0, 1, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,0)
					local x_spacing = 286
					local y_spacing = 286
					local base_pos = Vector(11392, 9856)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_winterblight_elite_devil_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(1.5, function()
			for i = 0, 1, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,-1)
					local x_spacing = 286
					local y_spacing = 286
					local base_pos = Vector(11703, 11136)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_winterblight_devil_watcher", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(2.5, function()
			for i = 0, 5, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(1,0)
					local x_spacing = 256
					local y_spacing = 256
					local base_pos = Vector(11377, 10485)
					Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_winterblight_devil_warrior", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(3, function()
			local miniboss = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_devil_baphomet", Vector(11859, 12085), Vector(0,-1), false, false)
			miniboss:AddLootDrop("immortal", "item_rpc_baphomets_cursed_necklace", 100)
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2
		end)
		
	end
end

function Winterblight:SpawnCastleRoom4(variant)
	local room_index = 4
	if variant == 1 then
		local positionTable = {Vector(15744, 10368), Vector(14976, 10368), Vector(14981, 10720), Vector(14976, 11119), Vector(14976, 11520)}
		if Winterblight.CastleTarot["name"] == "death" then
			positionTable = {Vector(16040, 10264), Vector(15616, 10264), Vector(16041, 10650), Vector(15616, 10650), Vector(14807, 9884), Vector(15232, 9984), Vector(14807, 10496), Vector(15232, 10496), Vector(15232, 11008), Vector(14807, 11008), Vector(14807, 11520), Vector(15232, 11520)}
		end
		if Winterblight.CastleTarot["name"] ~= "temperance" then
			for i = 1, #positionTable, 1 do
				local trap = CreateUnitByName("winterblight_spike_trap", positionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
				trap:SetAbsOrigin(trap:GetAbsOrigin()+Vector(0,0,10))
				if Winterblight.CastleTarot["name"] == "chariot" then
					trap:RemoveModifierByName("modifier_spike_trap_passive")
					local trap_ability = trap:FindAbilityByName("winterblight_spike_trap_passive")
					trap_ability:ApplyDataDrivenModifier(trap, trap, "modifier_spike_trap_passive_chariot", {})
				end
			end
			Timers:CreateTimer(0.5, function()
				local positionTable = {Vector(14976, 9795), Vector(15360, 10368), Vector(15360, 10831), Vector(15360, 11392)}
				local extra_max = 0
				if Winterblight.CastleTarot["name"] == "death" then
					table.insert(positionTable, Vector(15832, 10496))
					table.insert(positionTable, Vector(15488, 11648))
					extra_max = 2
				end
				for i = 1, 1 + GameState:GetDifficultyFactor() + extra_max, 1 do
					local trap = CreateUnitByName("winterblight_ground_blade", positionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
					trap:SetAbsOrigin(trap:GetAbsOrigin()+Vector(0,0,10))
					trap:SetForwardVector(RandomVector(1))
				end
			end)
		end
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

			if Winterblight.CastleTarot["name"] == "tower" then
				local ripper = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_bloody_faceripper", Vector(15432, 12287), Vector(0,-1), false, false)
				ripper:AddLootDrop("immortal", "item_rpc_iron_tower_barbute", 100)
			end
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
				local monster = Winterblight:SpawnCastleRoomUnit(0, "winterblight_soul_fletcher", positionTable[i], fv, false, true)
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
			if Winterblight.CastleLoversPath and Winterblight.CastleLoversPath == "elyna" then
				local galren = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_elyna", Vector(10240, 6656), Vector(1,0), false, false)
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, galren, "modifier_lovers_miniboss", {})
			end	
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
	if not Winterblight.CastleDungeonMaster.goo_dummy then
		local goo_dummy = CreateUnitByName("npc_dummy_unit", Vector(9778, 4642), false, nil, nil, DOTA_TEAM_NEUTRALS)
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, goo_dummy, "modifier_room_7_goo_aura", {})
		goo_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		Winterblight.CastleDungeonMaster.goo_dummy = goo_dummy
		Winterblight.CastleDungeonMaster.goo_switches = {0, 0, 0}
	end
	local buttonsPositions = {Vector(9037, 3622, 1584), Vector(9514, 5496, 1584), Vector(10867, 5619, 1584)}
	for i = 1, #buttonsPositions, 1 do
		local button = Entities:FindByNameNearest("GooSwitchButton", buttonsPositions[i], 800)
		button:SetAbsOrigin(button:GetAbsOrigin() + Vector(0,0,285))
	end
	Winterblight.CastleDungeonMaster.goo_switches_can_be_pressed = true

	if variant == 1 or variant == 2 then
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
			if variant == 2 then
				local emperor = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_slime_emperor", Vector(10317, 4511), Vector(0,-1), false, false)
				emperor:AddLootDrop("immortal", "item_rpc_plague_emperor_armor", 100)
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
			if Winterblight.CastleTarot["name"] == "strength" then
				rock:SetModelScale(2.6)
				rock:SetHullRadius(260)
				rock:SetMaxHPandHealToFull(rock:GetMaxHealth()+1)
			else
				rock:SetHullRadius(180)
			end
		end)
	end
	if Winterblight.CastleTarot["name"] == "strength" then
		Winterblight.CASTLE_DATA["rooms"][8]["extra_goal"] = Winterblight.CASTLE_DATA["rooms"][8]["extra_goal"] + 21
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

	local height = 2280
	local width = 406
	local origin = Vector(14667, 2333)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 2087
	local width = 467
	local origin = Vector(15145, 1871)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 1072
	local width = 733
	local origin = Vector(15761, 1971)
	local bl_vertex = origin-Vector(width/2, height/2)
	local tr_vertex = origin+Vector(width/2, height/2)
	table.insert(vertices, {bl_vertex, tr_vertex})

	local height = 677
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
		local luck = RandomInt(1, 20)
		if luck == 1 then
			chest.contents = {ring_of_mysteries = 1}
		end
		local luck_card = RandomInt(1, 24)
		if luck_card == 1 then
			table.insert(chest.contents, {tarot_card = 1})
		end
		table.insert(Winterblight.CastleDungeonMaster.treasure_room_chests, chest)
		chest.treasure_room = true
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
			if Winterblight.CastleLoversPath and Winterblight.CastleLoversPath == "apple_tree" then
				local apple_tree = CreateUnitByName("npc_dummy_unit", Vector(13773, -2507), false, nil, nil, DOTA_TEAM_NEUTRALS)
				apple_tree:SetModel("models/props_tree/mango_tree.vmdl")
				apple_tree:SetOriginalModel("models/props_tree/mango_tree.vmdl")
				apple_tree:SetModelScale(2)
				apple_tree:SetRenderColor(255, 44, 44)
				apple_tree:FindAbilityByName("dummy_unit"):SetLevel(1)
				Winterblight.AppleTreeExists = true
				local snake_pos = Vector(13773, -2507) + RandomVector(300)
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_serpent_nachash", snake_pos, RandomVector(1), false, false)
			else
				Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_moon_warden", Vector(14712, -2720), Vector(0,-1), false, false)
			end
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2	
		end)
	elseif variant == 2 then
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(12800, -3385), Vector(13082, -3020), Vector(13865, -2951), Vector(15232, -2774), Vector(14464, -2305), Vector(13747, -1920), Vector(12928, -2432)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(12960, -1624) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_blue_magician", positionTable[i], fv, false, false)
			end	
		end)
		Timers:CreateTimer(1.2, function()
			for i = 0, 3, 1 do
				for j = 0, 1, 1 do
					local fv = Vector(0,1)
					local x_spacing = 256
					local y_spacing = 256
					local base_pos = Vector(13494, -2615)
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_green_magician", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
				end
			end
		end)
		Timers:CreateTimer(1.7, function()
			local positionTable = {Vector(12509, -3200), Vector(12557, -3003), Vector(12621, -2803)}
			for i = 1, #positionTable, 1 do
				local fv = (Vector(12960, -1624) - positionTable[i]):Normalized()
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_red_magician", positionTable[i], fv, false, false)
			end	
		end)		
		Timers:CreateTimer(2.5, function()
			local positionTable = {Vector(13824, -1601), Vector(14031, -1497), Vector(14279, -1517)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,-1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_blue_magician", positionTable[i], fv, false, false)
			end	
		end)	
		Timers:CreateTimer(3, function()
			local positionTable = {Vector(13440, -2944), Vector(13696, -3082), Vector(13952, -2944)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(0,1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_red_magician", positionTable[i], fv, false, false)
			end	
		end)	
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(15419, -3272), Vector(15246, -3123), Vector(15140, -3278), Vector(15246, -3456), Vector(14953, -3456), Vector(14822, -3286), Vector(14667, -3454), Vector(14537, -3287), Vector(14366, -3456), Vector(14170, -3311), Vector(13959, -3473), Vector(13824, -3314), Vector(13568, -3278), Vector(13486, -3456)}
			local unitTable = {"winterblight_blue_magician", "winterblight_red_magician", "winterblight_green_magician"}
			for i = 1, #positionTable, 1 do
				local fv = RandomVector(1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, unitTable[RandomInt(1, #unitTable)], positionTable[i], fv, false, false)
			end	
		end)	
		Timers:CreateTimer(4, function()
			local positionTable = {Vector(15244, -2407), Vector(15104, -2233), Vector(15003, -2363), Vector(14848, -2176)}
			for i = 1, #positionTable, 1 do
				local fv = Vector(-1,-1)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_green_magician", positionTable[i], fv, false, false)
			end	
			local miniboss = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_haunt_magician", Vector(14712, -2720), Vector(0,-1), false, false)
			miniboss:AddLootDrop("immortal", "item_rpc_spellcrafter_coat", 100)
			Winterblight.CASTLE_DATA["rooms"][room_index]["active"] = 2	
		end)
	elseif variant == 3 then
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
					local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_shadow_priestess", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
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
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_shadow_priestess", positionTable[i], fv, false, false)
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
	if Winterblight.xelethar and IsValidEntity(Winterblight.xelethar) and Winterblight.xelethar:IsAlive() then
		Dungeons:AggroUnit(Winterblight.xelethar)
	end
	Winterblight.CastleBoss = boss
	local bossAbility = boss:FindAbilityByName("winterblight_castle_boss_passive")
	Winterblight.CastleBoss.main_ability = bossAbility

	Winterblight:CastleBossMusicPlayer()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 2100, 99999, true)
	boss:SetAbsOrigin(position-Vector(0,0,1000))
	-- boss:SetModelScale(6)
	Winterblight:InitCastleBossData()
	boss.color = Vector(255,255,255)
	Events:smoothSizeChange(boss, 1, 6, 210)
	Timers:CreateTimer(3, function()
		Events:unitFVSpin(boss, 20, 240, 1, false)
		StartAnimation(boss, {duration = 6.0, activity = ACT_DOTA_TELEPORT, rate = 0.5})

		Timers:CreateTimer(0.6, function()
			Winterblight:CastleBossSplash(boss)
		end)

		Events:smoothTranslate(boss, Vector(0,0,20), 74, Vector(0,0), nil)

		Timers:CreateTimer(4, function()
			EmitSoundOn("Winterblight.CastleBoss.Spawn.VO", boss)
			bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_castle_boss_rotating", {})
		end)

		
	end)
	
	Timers:CreateTimer(2, function()
		local vision_guy = CreateUnitByName("npc_flying_dummy_vision", boss:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		vision_guy:SetAbsOrigin(boss:GetAbsOrigin())
		vision_guy:SetDayTimeVisionRange(1000)
		vision_guy:SetNightTimeVisionRange(1000)
		vision_guy:FindAbilityByName("dummy_unit"):SetLevel(1)
		boss.vision_guy = vision_guy
	end)
	Timers:CreateTimer(1, function()
		Winterblight:FinalBossSpawnEvents()
	end)
	if Winterblight.CastleTarot["name"] == "devil" then
		Winterblight:SpawnDevilRings(-1)
	elseif Winterblight.CastleTarot["name"] == "sun" then
		Winterblight:SpawnSunGroundFire(-1)
	end
end

function Winterblight:CastleBossSplash(boss)
	local splash_particle = "particles/roshpit/winterblight/blue_goo_explosion.vpcf"
	local splash_position = GetGroundPosition(boss:GetAbsOrigin(), boss) - Vector(0,0,300)
	CustomAbilities:QuickParticleAtPoint(splash_particle, splash_position, 5)
	EmitSoundOnLocationWithCaster(splash_position, "Winterblight.Boss.Splash", boss)
	for i = 1, 5, 1 do
		local fv = WallPhysics:rotateVector(Vector(1,1), 2*math.pi*i/5)
		CustomAbilities:QuickParticleAtPoint(splash_particle, splash_position + fv * 240, 5)
	end
end


function Winterblight:BlueGooSplash(position)
	local splash_particle = "particles/roshpit/winterblight/blue_goo_explosion.vpcf"
	local splash_position = position
	CustomAbilities:QuickParticleAtPoint(splash_particle, splash_position, 5)
	EmitSoundOnLocationWithCaster(splash_position, "Winterblight.Boss.Splash", Events.GameMaster)
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
			local musicSpeed = "Slow"
			if (Winterblight.CastleBoss:GetHealth()/Winterblight.CastleBoss:GetMaxHealth()) < 0.64 then
				musicSpeed = "Mezzo"
			end
			if (Winterblight.CastleBoss:GetHealth()/Winterblight.CastleBoss:GetMaxHealth()) < 0.3 then
				musicSpeed = "Fast"
			end
			EmitSoundOnLocationWithCaster(sound_position, "Winterblight.CastleBoss.Music"..musicSpeed, Winterblight.CastleBoss)
			return 40
		end
	end)
end

function Winterblight:InitCastleBossData()
	-- Winterblight.CastleBoss.data = {}
	-- Winterblight.CastleBoss.data["position_offsets"] = {}
	-- Winterblight.CastleBoss.data["position_offsets"][1] = {animation_state = "idle", offsetVector = }
end

function Winterblight:CastleBossDeath(boss)
	boss.dying = true
	local ability = boss:FindAbilityByName("winterblight_castle_boss_passive")
	Winterblight.CastleBossDead = true
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_boss_dying", {})
	Winterblight.CastleBossMusic = false
	-- EmitSoundOn("Winterblight.AzaleaBoss.Death1.VO", boss)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text = "Dungeon Clear!", duration = 8.0})
	end)
	for i = 1, #ability.skullFrostTable, 1 do
		ParticleManager:DestroyParticle(ability.skullFrostTable[i].pfx, false)
		UTIL_Remove(ability.skullFrostTable[i])
	end
	EmitSoundOn("Winterblight.CastleBoss.Death.VO", boss)
	local position = boss:GetAbsOrigin()
	boss:BossDrops(20)
	Timers:CreateTimer(1, function()
		local arcanaLuck = RandomInt(1, 195 - GameState:GetPlayerPremiumStatusCount() * 12 - Winterblight.Stones * 30)
		if arcanaLuck == 1 then
			Winterblight:DropCruxysEkkanArcana(boss)
		end
		local luck2 = RandomInt(1, 100 - GameState:GetPlayerPremiumStatusCount() * 3)
		if luck2 == 1 then
			Winterblight:DropBorealGraniteChunk(boss:GetAbsOrigin())
		end
	end)
	Timers:CreateTimer(1.5, function()
		local card_chance = RandomInt(1, 100)
		local chance_min = 10 + GameState:GetPlayerPremiumStatusCount()*5
		if card_chance < chance_min then
			Winterblight:CreateCastleTarotCard(boss:GetAbsOrigin(), nil)
		end
	end)
	Timers:CreateTimer(2, function()
		if Winterblight.CastleTarot["name"] == "death" then
			RPCItems:RollAndDropUniqueItem(enemy, "item_rpc_mortuary_charm")
		elseif Winterblight.CastleTarot["name"] == "emperor" and GameState:GetDifficultyFactor() >= 3 then
			Winterblight:DropEmperorQuestItem("emperor", boss:GetAbsOrigin())
		end
		local immortals_luck = RandomInt(1, 200)
		local chance_min = 50 + GameState:GetPlayerPremiumStatusCount()*10
		if immortals_luck <= chance_min then
			local luck = RandomInt(1, 4)
			if luck == 1 then
				RPCItems:RollAndDropUniqueItem(boss, "item_rpc_musty_crypt_armor")
			elseif luck == 2 then
				RPCItems:RollAndDropUniqueItem(boss, "item_rpc_shadowguard_helm")
			elseif luck == 3 then
				RPCItems:RollAndDropUniqueItem(boss, "item_rpc_zombiegrip_gauntlet")
			elseif luck == 4 then
				RPCItems:RollAndDropUniqueItem(boss, "item_rpc_gravewalkers")
			end
		end
		Timers:CreateTimer(1, function()
			local lich_king_gaze_luck = RandomInt(1, 200)
			local chance_min = 10 + GameState:GetPlayerPremiumStatusCount()*10
			if lich_king_gaze_luck < chance_min then
				RPCItems:RollAndDropUniqueItem(boss, "item_rpc_lich_kings_gaze")
			end
		end)
		for i = 1, 1 + Winterblight.Stones, 1 do
			Timers:CreateTimer(i*0.5, function()
				local glyph = RPCItems:RebornGlyph()
				RPCItems:BasicDropItem(boss:GetAbsOrigin(), glyph)
			end)
		end
	end)
	for j = 1, 4 + GameState:GetPlayerPremiumStatusCount() * 2, 1 do
		Timers:CreateTimer(j * 0.3, function()
			Winterblight:DropGlacierStone(boss:GetAbsOrigin())
		end)
	end
	Timers:CreateTimer(6, function()
		for j = 1, Winterblight.Stones + 2, 1 do
			Timers:CreateTimer(j, function()
				RPCItems:DropSynthesisVessel(boss:GetAbsOrigin())
			end)
		end
	end)
	boss.deathLock = true
	boss.rotateLock = true
	Timers:CreateTimer(0.03, function()
		StartAnimation(boss, {duration = 10, activity = ACT_DOTA_FLAIL, rate = 0.7})
		Timers:CreateTimer(0.1, function()
			boss.rotateLock = false
		end)
	end)
	Timers:CreateTimer(10, function()
		EmitSoundOn("Winterblight.CastleBoss.Death.VO2", boss)
		EndAnimation(boss)
		Events:smoothSizeChange(boss, 6, 3, 160)
		Enemies:EnemySlain(boss, nil)
		Events:MainBossSlain(boss:GetUnitName())
		-- EmitSoundOn("Winterblight.AzaleaBoss.Death2.VO", boss)
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossEntityIndex = boss:GetEntityIndex()})
		boss:RemoveModifierByName("modifier_boss_dying")
		-- Timers:CreateTimer(0.03, function()
		-- 	StartAnimation(boss, {duration = 10, activity = ACT_DOTA_DIE, rate = 0.24})
		-- end)
	    boss.rotateLock = true
	    Timers:CreateTimer(0.03, function()
			boss:StartGestureWithPlaybackRate(ACT_DOTA_DIE, 0.22)
		end)
		Timers:CreateTimer(0.5, function()
			boss.rotateLock = false
		end)
		Timers:CreateTimer(2.6, function()
			Winterblight:CastleBossSplash(boss)
		end)
		Timers:CreateTimer(4, function()
			Winterblight:CastleBossSplash(boss)
		end)
		Timers:CreateTimer(7, function()
			local position = boss:GetAbsOrigin()
			Winterblight:objectShake(boss, 48, 15, true, true, true, "Winterblight.AzaleaBoss.DeathShaking", 24)
			Timers:CreateTimer(1.5, function()
				for i = 0, 3, 1 do
					Timers:CreateTimer(0.1 * i, function()
						local pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, 80 + i * 120))
						ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
						ParticleManager:SetParticleControl(pfx, 2, Vector(0.8, 0.8, 0.8))
						Timers:CreateTimer(10, function()
							ParticleManager:DestroyParticle(pfx, false)
							ParticleManager:ReleaseParticleIndex(pfx)
						end)
					end)
				end
				EmitSoundOn("Winterblight.Tiamat.Ice.Explode", boss)
				local particleName = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
				local radius = 800
				local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(particle1, 0, boss:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 1, 1000))
				ParticleManager:SetParticleControl(particle1, 3, Vector(radius, radius, radius))
				Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(particle1, false)
				end)
				Winterblight:CastleBossSplash(boss)
				UTIL_Remove(boss)
			end)
		end)
	end)
	Timers:CreateTimer(10, function()
		Winterblight:PostCastleBossEvents()
	end)
	Timers:CreateTimer(13, function()
		Winterblight:MithrilReward(position, "cruxys")
	end)

end

function Winterblight:CastleBossSpawnPhase()
	local amount_weak = 8
	local amount_strong = 1
	if GameState:GetDifficultyFactor() == 2 then
		amount_weak = 7
		amount_strong = 3
	elseif GameState:GetDifficultyFactor() == 3 then
		amount_weak = 8
		amount_strong = 4
	end
	if Winterblight.Stones > 0 then
		amount_strong = amount_strong + Winterblight.Stones
	end
	local weak_creeps = {"winterblight_frozen_phantom", "winterblight_frozen_mage", "winterblight_frozen_cage", "winterblight_frozen_soul", "winterblight_castle_warrior", "winterblight_wraithguard"}
	local strong_creeps = {"winterblight_accursed", "winterblight_draugr", "winterblight_defiler", "winterblight_elite_castle_warrior", "winterblight_mountain_spirit", "winterblight_grave_skeleton"}
	if Winterblight.CastleTarot["name"] == "hierophant" then
		table.insert(strong_creeps, "winterblight_necro_knight")
	end
	for i = 1, amount_weak, 1 do
		Timers:CreateTimer(i*0.9, function()
			local spawnPos = Winterblight.CastleBoss:GetAbsOrigin()+RandomVector(RandomInt(300, 1000))
			local enemy = Winterblight:SpawnCastleRoomUnit(0, weak_creeps[RandomInt(1, #weak_creeps)], spawnPos, Vector(0,-1), true, true)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", enemy:GetAbsOrigin(), 3)
			EmitSoundOn("Winterblight.GraveGhostSpawn", enemy)
		end)
	end
	Timers:CreateTimer(6, function()
		for i = 1, amount_strong, 1 do
			Timers:CreateTimer(i*0.9, function()
				local spawnPos = Winterblight.CastleBoss:GetAbsOrigin()+RandomVector(RandomInt(300, 1000))
				local enemy = Winterblight:SpawnCastleRoomUnit(0, strong_creeps[RandomInt(1, #strong_creeps)], spawnPos, Vector(0,-1), true, true)
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", enemy:GetAbsOrigin(), 3)
				EmitSoundOn("Winterblight.GraveGhostSpawn", enemy)
			end)
		end	
	end)
end

function Winterblight:DropScryersStone(position)
	local item = RPCItems:CreateUnstashable("item_rpc_winterblight_scryers_stone", "uncommon", "Scryers Stone", -1, false, "Winterblight Only", "winterblight_scryers_stone_desc")
    local drop = CreateItemOnPositionSync( position, item )
    item.cantStash = true
    local dropPosition = position+RandomVector(RandomInt(30, 280))
    --item:LaunchLoot(false, 240, 0.75, dropPosition)
	RPCItems:LaunchLoot(item, 240, 0.5, dropPosition, position)
end

function Winterblight:PostCastleBossEvents()
	if Winterblight.CastleTarot["name"] == "fool" then
		Winterblight:OpenCastleDoorByIndex(11)
		Winterblight:SpawnTreasureRoomChests()
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		Winterblight:TemperanceBossChests()
	elseif Winterblight.CastleTarot["name"] == "world" then
		Timers:CreateTimer(10, function()
			if GameState:GetDifficultyFactor() >= 3 then
				Winterblight:WorldBossSpawn()
			end
		end)
	end
end

function Winterblight:PrecacheTarotAssets()
	if Winterblight.CastleTarot["name"] == "magician" then
		local function precache_function()

		end
		PrecacheUnitByNameAsync("winterblight_red_magician", precache_function)	
		PrecacheUnitByNameAsync("winterblight_blue_magician", precache_function)	
		PrecacheUnitByNameAsync("winterblight_green_magician", precache_function)	
		PrecacheUnitByNameAsync("winterblight_haunt_magician", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "high_priestess" then
		local function precache_function()
			
		end
		PrecacheUnitByNameAsync("winterblight_shadow_priestess", precache_function)	
		PrecacheUnitByNameAsync("winterblight_bishop_of_hades", precache_function)
	elseif Winterblight.CastleTarot["name"] == "empress" then
		local function precache_function()
				
		end	
		PrecacheUnitByNameAsync("winter_castle_faceless_empress", precache_function)
		PrecacheUnitByNameAsync("winterblight_empress_emasz", precache_function)
	elseif Winterblight.CastleTarot["name"] == "emperor" then
		local function precache_function()

		end
		PrecacheUnitByNameAsync("winterblight_emperors_servant", precache_function)
		PrecacheUnitByNameAsync("winterblight_slime_emperor", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "hierophant" then
		local function precache_function()
				
		end
		PrecacheUnitByNameAsync("winterblight_necro_knight", precache_function)	
		PrecacheUnitByNameAsync("winterblight_high_priest_xelethar", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "lovers" then
		local function precache_function()
	
		end
		PrecacheUnitByNameAsync("winterblight_lovers_heart_path", precache_function)
		PrecacheUnitByNameAsync("winterblight_dual_drake", precache_function)
		PrecacheUnitByNameAsync("winterblight_galren", precache_function)
		PrecacheUnitByNameAsync("winterblight_elyna", precache_function)
		PrecacheUnitByNameAsync("winterblight_serpent_nachash", precache_function)
	elseif Winterblight.CastleTarot["name"] == "strength" then
		local function precache_function()

		end
		PrecacheUnitByNameAsync("winterblight_castle_strength_spine_drake", precache_function)
		PrecacheUnitByNameAsync("winterblight_lost_gladiator", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "hermit" then
		local function precache_function()

		end
		PrecacheUnitByNameAsync("winterblight_hermit_eye", precache_function)
		PrecacheUnitByNameAsync("winterblight_castle_hermit_hoodling", precache_function)
		PrecacheUnitByNameAsync("winterblight_shadow_wanderer", precache_function)
		PrecacheUnitByNameAsync("winterblight_lonely_hermit", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "justice" then
		local function precache_function()

		end
		PrecacheUnitByNameAsync("winterblight_castle_justice_angel", precache_function)
		PrecacheUnitByNameAsync("winterblight_castle_justice_demon", precache_function)
		PrecacheUnitByNameAsync("winterblight_castle_justice_balance", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "hanged_man" then
		local function precache_function()
				
		end
		PrecacheUnitByNameAsync("winterblight_hanging_slayer", precache_function)
	elseif Winterblight.CastleTarot["name"] == "death" then
		local function precache_function()
			
		end	
		PrecacheUnitByNameAsync("winterblight_necro_knight", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "temperance" then
		local function precache_function()
				
		end
		PrecacheUnitByNameAsync("winterblight_water_bearer", precache_function)
	elseif Winterblight.CastleTarot["name"] == "devil" then
		local function precache_function()

		end
		PrecacheUnitByNameAsync("winterblight_winterblight_devil_watcher", precache_function)
		PrecacheUnitByNameAsync("winterblight_winterblight_elite_devil_warrior", precache_function)	
		PrecacheUnitByNameAsync("winterblight_devil_baphomet", precache_function)
	elseif Winterblight.CastleTarot["name"] == "tower" then
		local function precache_function()
		end
		PrecacheUnitByNameAsync("winterblight_bloody_faceripper", precache_function)
	elseif Winterblight.CastleTarot["name"] == "star" then
		local function precache_function()
			
		end
		PrecacheUnitByNameAsync("winterblight_star_watcher", precache_function)	
		PrecacheUnitByNameAsync("winterblight_castle_star_miniboss", precache_function)	

	elseif Winterblight.CastleTarot["name"] == "moon" then
		local function precache_function()
		end
		PrecacheUnitByNameAsync("winterblight_lumos_king", precache_function)	
		PrecacheUnitByNameAsync("winterblight_castle_werewolf", precache_function)
	elseif Winterblight.CastleTarot["name"] == "sun" then
		local function precache_function()

		end
		PrecacheUnitByNameAsync("winterblight_temple_sun_crow", precache_function)	
		PrecacheUnitByNameAsync("winterblight_heat_fletcher", precache_function)	
		PrecacheUnitByNameAsync("winterblight_elite_heat_fletcher", precache_function)	
		PrecacheUnitByNameAsync("winterblight_aspect_of_solos", precache_function)
	elseif Winterblight.CastleTarot["name"] == "judgement" then
		local function precache_function()
		end
		PrecacheUnitByNameAsync("winterblight_judgement_fallen", precache_function)	
		PrecacheUnitByNameAsync("winterblight_judgement_judge", precache_function)	
		PrecacheUnitByNameAsync("winterblight_paragon_of_judgement", precache_function)	
	elseif Winterblight.CastleTarot["name"] == "world" then
		local function precache_function()
		end
		PrecacheUnitByNameAsync("winterblight_world_commander_vorethrex", precache_function)
	end
end

function Winterblight:KeyLand(position)
	if Winterblight.CastleTarot["name"] == "magician" then
		local luck = RandomInt(1, 10)
		if luck == 1 then
			local spawnPoint = GetGroundPosition(position + RandomVector(240), Events.GameMaster)
			local pfx_dummy = CreateUnitByName("npc_dummy_unit", spawnPoint, true, nil, nil, DOTA_TEAM_GOODGUYS)
			pfx_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
			local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", pfx_dummy, 8)
			ParticleManager:SetParticleControl(pfx, 1, spawnPoint)
			Timers:CreateTimer(0.5, function()
				EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.Magician.ChestSpawn", Events.GameMaster)
			end)
			Timers:CreateTimer(2, function()
				local rewardTables = Winterblight:GetGeneralChestRewards()
				local chest = Enemies:SpawnEnemyUnit("winterblight_treasure_chest", spawnPoint, Vector(0, 1), false)
				EmitSoundOn("Winterblight.TreasureTower.GoldSound", chest)
				EmitSoundOn("Winterblight.Magician.ChestSpawn2", chest)
				chest.contents = rewardTables[RandomInt(1, #rewardTables)]
				local luck = RandomInt(1, 20)
				if luck == 1 then
					chest.contents = {ring_of_mysteries = 1}
				end
				local luck_card = RandomInt(1, 21)
				if luck_card == 1 then
					chest.contents.tarot_card = 1
				end
				Timers:CreateTimer(6, function()
					UTIL_Remove(pfx_dummy)
				end)
				CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", chest, 8)
			end)
		end
	end
end

function Winterblight:CastleEnemyDieItemHype(enemy)
	if Winterblight.CastleTarot["name"] == "high_priestess" then
		local luck = RandomInt(1, 500)
		if luck == 1 then
			local spawnPoint = GetGroundPosition(enemy:GetAbsOrigin() + RandomVector(240), Events.GameMaster)
			local pfx_dummy = CreateUnitByName("npc_dummy_unit", spawnPoint, true, nil, nil, DOTA_TEAM_GOODGUYS)
			pfx_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
			local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", pfx_dummy, 8)
			ParticleManager:SetParticleControl(pfx, 1, spawnPoint)
			Timers:CreateTimer(0.5, function()
				EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.Magician.ChestSpawn", Events.GameMaster)
			end)
			Timers:CreateTimer(2, function()
				local rewardTables = Winterblight:GetGeneralChestRewards()
				local chest = Enemies:SpawnEnemyUnit("winterblight_treasure_chest", spawnPoint, Vector(0, 1), false)
				EmitSoundOn("Winterblight.TreasureTower.GoldSound", chest)
				EmitSoundOn("Winterblight.Magician.ChestSpawn2", chest)
				chest.contents = rewardTables[RandomInt(1, #rewardTables)]
				local luck = RandomInt(1, 20)
				if luck == 1 then
					chest.contents = {ring_of_mysteries = 1}
				end
				local luck_card = RandomInt(1, 24)
				if luck_card == 1 then
					table.insert(chest.contents, {tarot_card = 1})
				end
				Timers:CreateTimer(6, function()
					UTIL_Remove(pfx_dummy)
				end)
				CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", chest, 8)
			end)
		end
	elseif Winterblight.CastleTarot["name"] == "star" then
		if not enemy.star_revived then
			local luck = RandomInt(1, 4)
			if enemy:GetUnitName() == "winterblight_star_watcher" then
				luck = 1
			end
			if luck == 1 and enemy:GetEnemyTier() < ENEMY_TYPE_MINI_BOSS then
				local star_revived_monster = Winterblight:SpawnCastleRoomUnit(0,enemy:GetUnitName(), enemy:GetAbsOrigin(), enemy:GetForwardVector(), false, true)
				star_revived_monster.cantAggro = true
				star_revived_monster.star_revived = true
				star_revived_monster:SetAbsOrigin(star_revived_monster:GetAbsOrigin() + Vector(0,0,1000))
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, star_revived_monster, "modifier_diviner_star_entering", {duration = 10})
				SpecialFX:ColoredSpotlight(enemy:GetAbsOrigin(), Vector(255, 255, 0))
			end
		else
			local luck = RandomInt(1, 100)
			if luck == 1 then
				Winterblight:GeneralChestSpawn(enemy:GetAbsOrigin(), enemy:GetForwardVector())
			end
		end
	end
	local tarot_card_luck = RandomInt(1, 100000)
	local chance_min = 20 + GameState:GetPlayerPremiumStatusCount()*5
	if enemy:GetEnemyTier() == ENEMY_TYPE_MINI_BOSS then
		chance_min = chance_min*10
	end
	if tarot_card_luck <= chance_min then
		Winterblight:CreateCastleTarotCard(enemy:GetAbsOrigin(), nil)
	end
	local immortals_luck = RandomInt(1, 200000)
	local chance_min = 50 + GameState:GetPlayerPremiumStatusCount()*10
	if immortals_luck <= chance_min then
		local luck = RandomInt(1, 4)
		if luck == 1 then
			RPCItems:RollAndDropUniqueItem(enemy, "item_rpc_musty_crypt_armor")
		elseif luck == 2 then
			RPCItems:RollAndDropUniqueItem(enemy, "item_rpc_shadowguard_helm")
		elseif luck == 3 then
			RPCItems:RollAndDropUniqueItem(enemy, "item_rpc_zombiegrip_gauntlet")
		elseif luck == 4 then
			RPCItems:RollAndDropUniqueItem(enemy, "item_rpc_gravewalkers")
		end
	end
end

function Winterblight:GetGeneralChestRewards()
	local glyphs_count = RandomInt(2, math.floor(3 + GameState:GetPlayerPremiumStatusCount()))
	local crystals_count = (GameState:GetDifficultyFactor() * RandomInt(34, 40 + GameState:GetPlayerPremiumStatusCount()*4))*6
	return {{items = RandomInt(6, 9+GameState:GetPlayerPremiumStatusCount())}, {crystals = crystals_count}, {glyphs = glyphs_count}}
end

function Winterblight:GeneralChestSpawn(position, fv)
	local spawnPoint = GetGroundPosition(position, Events.GameMaster)
	local pfx_dummy = CreateUnitByName("npc_dummy_unit", spawnPoint, true, nil, nil, DOTA_TEAM_GOODGUYS)
	pfx_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", pfx_dummy, 8)
	ParticleManager:SetParticleControl(pfx, 1, spawnPoint)
	Timers:CreateTimer(0.5, function()
		EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.Magician.ChestSpawn", Events.GameMaster)
	end)
	Timers:CreateTimer(2, function()
		local rewardTables = Winterblight:GetGeneralChestRewards()
		local chest = Enemies:SpawnEnemyUnit("winterblight_treasure_chest", spawnPoint, fv*-1, false)
		EmitSoundOn("Winterblight.TreasureTower.GoldSound", chest)
		EmitSoundOn("Winterblight.Magician.ChestSpawn2", chest)
		chest.contents = rewardTables[RandomInt(1, #rewardTables)]
		local luck = RandomInt(1, 20)
		if luck == 1 then
			chest.contents = {ring_of_mysteries = 1}
		end
		local luck_card = RandomInt(1, 24)
		if luck_card == 1 then
			table.insert(chest.contents, {tarot_card = 1})
		end
		if Winterblight.CastleTarot["name"] == "wheel_of_fortune" then
			local bad_luck = RandomInt(1, 2)
			if bad_luck == 1 then
				chest.bad_chest = true
			end
		end
		Timers:CreateTimer(6, function()
			UTIL_Remove(pfx_dummy)
		end)
		CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", chest, 8)
	end)
end

function Winterblight:SpawnTreasureRoomLoversHearts()
	local positionTable = {Vector(9498, -2670), Vector(10130, -2278), Vector(10746, -1901)}
	Winterblight.CastleDungeonMaster.treasure_room_chests = {}
	local indeces = {1, 2, 3}
	local shuffledIndeces = WallPhysics:ShuffleTable(indeces)
	for i = 1, #positionTable, 1 do
		local chest = Enemies:SpawnEnemyUnit("winterblight_lovers_heart_path", positionTable[i], Vector(1,-1), false)
		chest:SetAbsOrigin(chest:GetAbsOrigin() + Vector(0,0,110))
		local particleName = "particles/roshpit/winterblight/colorable_pop.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, chest)
		ParticleManager:SetParticleControlEnt(pfx, 0, chest, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", chest:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 1, Vector(1,0.2,0.2))
		EmitSoundOn("Winterblight.LoverHeart.Spawn", chest)
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		table.insert(Winterblight.CastleDungeonMaster.treasure_room_chests, chest)
		chest.treasure_room = true
		chest.selection_index = shuffledIndeces[i]
	end
end


function Winterblight:UpdateLoversTarot(selection)
	if selection == 1 then
		Winterblight.CastleLoversPath = "galren"
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][2] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][3] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][4] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][5] = {index = 12, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][6] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][7] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][8] = {index = 8, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][9] = {index = 1, variant = 1}
	elseif selection == 2 then
		Winterblight.CastleLoversPath = "elyna"
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][2] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][3] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][4] = {index = 1, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][5] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][6] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][7] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][8] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][9] = {index = 5, variant = 1}
	elseif selection == 3 then
		Winterblight.CastleLoversPath = "apple_tree"
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][2] = {index = 7, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][3] = {index = 4, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][4] = {index = 2, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][5] = {index = 6, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][6] = {index = 3, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][7] = {index = 5, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][8] = {index = 9, variant = 1}
		Winterblight.CASTLE_DATA["tarot"][7]["rooms"][9] = {index = 11, variant = 1}
	end
end

function Winterblight:SpawnStrengthEvent()
	local spawnPos = Vector(15172, 1750)
	local rock_hp_table = {30, 40, 60}
	local rock = Enemies:SpawnEnemyUnit("winterblight_armory_rock", spawnPos, RandomVector(1), false)
	rock:SetAbsOrigin(rock:GetAbsOrigin() + Vector(0,0,2500))
	rock:SetModelScale(4.5)
	rock:SetHullRadius(360)
	rock.strength_boss_rock = true
	rock.speed = 20
	rock.distanceMoved = 0
	local rock_ability = rock:FindAbilityByName("winterblight_armory_rock_ability")
	rock_ability:ApplyDataDrivenModifier(rock, rock, "modifier_armory_rock_immune", {duration = 2})
	rock:SetMaxHPandHealToFull(rock_hp_table[GameState:GetDifficultyFactor()])
	Timers:CreateTimer(0.03, function()
		rock.speed = math.min(rock.speed + 1, 100)
		rock.distanceMoved = rock.distanceMoved + rock.speed
		rock:SetAbsOrigin(rock:GetAbsOrigin() - Vector(0, 0, rock.speed))
		if rock.distanceMoved >= 2400 then
		else
			return 0.03
		end
	end)
	Timers:CreateTimer(1.4, function()
		local startPoint = GetGroundPosition(rock:GetAbsOrigin(), Events.GameMaster)
		EmitSoundOnLocationWithCaster(startPoint, "Winterblight.AzaleaBoss.Stuate.Land", Events.GameMaster)

		local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, startPoint)
		ParticleManager:SetParticleControl(pfx, 5, Vector(0.8, 0.5, 0.3))
		ParticleManager:SetParticleControl(pfx, 2, Vector(0.9, 0.9, 0.9))
		Timers:CreateTimer(10, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
		end)
		ScreenShake(rock:GetAbsOrigin(), 800, 0.8, 0.8, 9000, 0, true)

		local damage = 10000
		local procs = 0
		local enemies = FindUnitsInRadius(rock:GetTeamNumber(), rock:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = Winterblight.MasterAbility})
			Filters:ApplyStun(Events.GameMaster, 3, enemy)
			FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), false)
		end
		for j = 0, procs, 1 do
			Timers:CreateTimer(j * 0.5, function()
				for i = 0, 4, 1 do
					Timers:CreateTimer(0.15, function()

						local forkDirection = WallPhysics:rotateVector(Vector(-1, -1), 2 * math.pi * i / 5)
						local direction = forkDirection
						if j == 0 then
							EmitSoundOnLocationWithCaster(startPoint, "Winterblight.ArcanaSunder.Moving", Events.GameMaster)
						end

						local particleName = "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
						local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl(pfx, 0, startPoint + forkDirection * 50)
						ParticleManager:SetParticleControl(pfx, 1, startPoint + forkDirection * 3000)
						ParticleManager:SetParticleControl(pfx, 3, Vector(200, 3.5, 200)) -- y COMPONENT = duration
						-- ParticleManager:SetParticleControl(pfx, 1, point)
						Timers:CreateTimer(3.5, function()
							ParticleManager:DestroyParticle(pfx, false)
							for i = 1, 3, 1 do
								EmitSoundOnLocationWithCaster(startPoint, "Winterblight.ArcanaSunder.Explode"..i, Events.GameMaster)
							end
							local enemies = FindUnitsInLine(DOTA_TEAM_NEUTRALS, startPoint, startPoint + forkDirection * 3000, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
							for _, enemy in pairs(enemies) do
								ApplyDamage({victim = enemy, attacker = Events.GameMaster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = Winterblight.MasterAbility})
								Filters:ApplyStun(Events.GameMaster, 3, enemy)
							end
						end)
					end)
				end
			end)
		end
	end)
end

function Winterblight:SpawnStrengthMiniboss(position)
	local miniboss = Winterblight:SpawnCastleRoomUnit(8, "winterblight_lost_gladiator", position, Vector(0,-1), true, false)
	local boss_ability = miniboss:FindAbilityByName("strength_boss_charge")
	miniboss.cantAggro = true
	boss_ability:ApplyDataDrivenModifier(miniboss, miniboss, "modifier_disable_player", {duration = 3})
	StartAnimation(miniboss, {duration = 3.0, activity = ACT_DOTA_TELEPORT, rate = 1})
	EmitSoundOn("Winterblight.StrengthBoss.Charge", miniboss)
	local call_particle = CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/strength_rock_explode.vpcf", miniboss:GetAbsOrigin(), 4)
	ScreenShake(miniboss:GetAbsOrigin(), 800, 0.8, 0.8, 9000, 0, true)
	Timers:CreateTimer(3, function()
		miniboss:RemoveModifierByName("modifier_disable_player")
		miniboss.cantAggro = false
		Dungeons:AggroUnit(miniboss)
	end)
	miniboss:AddLootDrop("immortal", "item_rpc_stonebreaker_gauntlet", 100)
end

function Winterblight:CastleLobbySpawnHermit()
	Timers:CreateTimer(0.2, function()
		local positionTable = {Vector(14208, 13568), Vector(14764, 13339), Vector(15329, 13604)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(1.5, function()
		local positionTable = {Vector(13696, 12672), Vector(13801, 11648), Vector(13583, 10624)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(4, function()
		local positionTable = {Vector(13583, 9267), Vector(13870, 8576), Vector(14848, 8823), Vector(12754, 8448), Vector(12288, 7643)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(8, function()
		local positionTable = {Vector(12288, 6528), Vector(11873, 5708), Vector(12288, 4992), Vector(11717, 4273), Vector(13035, 3688)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(12, function()
		local positionTable = {Vector(13217, 2352), Vector(12490, 1682), Vector(12120, 2454), Vector(11446, 2040), Vector(10671, 1922)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(15, function()
		local positionTable = {Vector(10201, 2537), Vector(9193, 1842), Vector(9930, 1525)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(18, function()
		local positionTable = {Vector(11592, 688), Vector(11549, -314), Vector(12897, -340), Vector(12875, 687)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
end

function Winterblight:FinalBossSpawnEvents()
	if Winterblight.CastleTarot["name"] == "hermit" then
		Winterblight:SpawnHermitSpecialRoom()
	end
end

function Winterblight:SpawnHermitSpecialRoom()
	Winterblight:OpenCastleDoorByIndex(12)
	Timers:CreateTimer(1, function()
		local positionTable = {Vector(12630, -2273), Vector(12825, -2560), Vector(13067, -2304), Vector(13492, -2061), Vector(13853, -2176), Vector(13972, -1792)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(14323, -2048), Vector(14476, -2304), Vector(15104, -2682), Vector(14848, -2976), Vector(14336, -2976), Vector(13891, -2976)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(3, function()
		local positionTable = {Vector(13440, -3015), Vector(13067, -2816), Vector(12672, -2816), Vector(12928, -3150), Vector(12561, -3200)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCastleRoomUnit(0,"winterblight_hermit_eye", positionTable[i], fv, false, true)
		end
	end)
	Timers:CreateTimer(4, function()
		for i = 0, 3, 1 do
			for j = 0, 1, 1 do
				local fv = Vector(-1,0)
				local x_spacing = 256
				local y_spacing = 356
				local base_pos = Vector(13493, -2688)
				local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_hermit_hoodling", base_pos + Vector(x_spacing*i, y_spacing*j), fv, false, false)
			end
		end
	end)
	Timers:CreateTimer(6, function()
		for i = 0, 5, 1 do
			local fv = Vector(0,1)
			local x_spacing = 326
			local base_pos = Vector(13493, -3353)
			local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_castle_elite_hermit_hoodling", base_pos + Vector(x_spacing*i, 0), fv, false, false)
		end
	end)
	Timers:CreateTimer(3.7, function()
		local positionTable = {Vector(12489, -3072), Vector(12581, -2747)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(14712, -2720) - positionTable[i]):Normalized()
			local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_shadow_wanderer", positionTable[i], fv, false, false)
		end	
	end)	
	Timers:CreateTimer(7.7, function()
		local positionTable = {Vector(15276, -2464), Vector(15066, -2280), Vector(14848, -2101)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(14712, -2720) - positionTable[i]):Normalized()
			local monster = Winterblight:SpawnCastleRoomUnit(room_index, "winterblight_shadow_wanderer", positionTable[i], fv, false, false)
		end	
	end)	
	Timers:CreateTimer(5, function()
		local miniboss = Winterblight:SpawnCastleRoomUnit(0, "winterblight_lonely_hermit", Vector(15232, -2816), Vector(1,0), false, true)
		miniboss:AddLootDrop("immortal", "item_rpc_cloak_of_isolation", 100)
	end)
end

function Winterblight:CastleWheelOfFortuneParagonChance(unit)
	local no_paragon = unit:GetKeyValue("RoshpitNoParagon")
	if no_paragon and no_paragon == 1 then
		return false
	end
	if unit:GetRoshpitLevel() <= 1 then
		return false
	end
	if unit.cant_paragon then
		return false
	end
	if unit.paragon then
		return false
	end
	local top_roll = 30 - GameState:GetDifficultyFactor()*4
	local luck = RandomInt(1, top_roll)
	if luck == 1 then
		Paragon:AddParagonUnit(unit)
		return true	
	else
		return false
	end
end

function Winterblight:BlueGooSwitchCheck()
	if not Winterblight.BlueGooSwitchSpawned then
		if Winterblight.CASTLE_DATA["rooms"][12]["active"] >= 2 then
			if Winterblight.CastleDungeonMaster.goo_switches then
				if Winterblight.CastleDungeonMaster.goo_switches[1] + Winterblight.CastleDungeonMaster.goo_switches[2] + Winterblight.CastleDungeonMaster.goo_switches[3] == 3 then
					Winterblight.BlueGooSwitchSpawned = 0
					Winterblight:ActivateSwitchGeneric(Vector(15751, -1818, 1976), "BlueGooSwitchButton", false, 0.76)
					local switchObject = Entities:FindByNameNearest("BlueGooSwitchButton", Vector(15751, -1818, 1976), 1000)
					Events:objectShake(switchObject, 60, 6, true, true, false, "Winterblight.DirtMoundShake", 20)
					local ground_position = GetGroundPosition(Vector(15751, -1818, 1976), Events.GameMaster)
					for mud_count = 0, 4, 1 do
						Timers:CreateTimer(mud_count*0.4, function()
							for mudx = 0, 1, 1 do
								for mudy = 0, 1, 1 do
									local mud_position = ground_position + Vector((mudx-0.5)*60, (mudy-0.5)*60, 0)
									CustomAbilities:QuickParticleAtPoint("particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf", mud_position, 4)
								end
							end
						end)
					end
					Timers:CreateTimer(2, function()
						Winterblight.BlueGooSwitchSpawned = 2
					end)
				end
			end
		end
	end
end

function Winterblight:BlueGooSwitchPressed()
	Winterblight:ActivateSwitchGeneric(Vector(15751, -1818, 1976), "BlueGooSwitchButton", true, 0.352)

	local goo_dummy = CreateUnitByName("npc_dummy_unit", Vector(9778, 4642), false, nil, nil, DOTA_TEAM_NEUTRALS)
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, goo_dummy, "modifier_room_7_goo_aura", {})
	goo_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	Winterblight.CastleDungeonMaster.blue_goo_dummy = goo_dummy

	Timers:CreateTimer(1, function()
		local goo = Entities:FindByNameNearest("CastleGooBlue", Vector(9742, 4586, 1500), 2000)
		print("ZXC FOUND GOO")
		print(goo:GetAbsOrigin())
		goo:SetAbsOrigin(goo:GetAbsOrigin()+Vector(0,0,240))
		Events:smoothTranslate(goo, Vector(0,0,0.74), 280, Vector(0,0), nil)
		StartSoundEvent("Winterblight.Castle.GooDrain", Winterblight.CastleDungeonMaster.blue_goo_dummy)
	end)
	Timers:CreateTimer(8.4, function()
		EmitSoundOn("Winterblight.Castle.GooDrainEnd", Winterblight.CastleDungeonMaster.blue_goo_dummy)
	end)
	Timers:CreateTimer(8.5, function()
		StopSoundEvent("Winterblight.Castle.GooDrain", Winterblight.CastleDungeonMaster.blue_goo_dummy)
	end)
	Timers:CreateTimer(10, function()
		local miniboss = Winterblight:SpawnCastleRoomUnit(0,"winterblight_blue_goo_gunman", Vector(10368, 4454), Vector(0,-1), false, true)
		miniboss:SetAbsOrigin(miniboss:GetAbsOrigin()-Vector(0,0,80))
		miniboss:AddLootDrop("immortal", "item_rpc_horn_of_the_triumphant", 100)
	end)
end

function Winterblight:HandleJusticeSpawns()
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")

	if not Winterblight.CastleJusticeData then
		Winterblight.CastleJusticeData = {}
		Winterblight.CastleJusticeData.room_index = 0
		Winterblight.CastleJusticeData.room_results = {}
		Winterblight.CastleJusticeData.angels_spawn_count = 1
		Winterblight.CastleJusticeData.demons_spawn_count = 1
		Winterblight.CastleJusticeData.total_angels_killed = 0
		Winterblight.CastleJusticeData.total_demons_killed = 0
	end
	Winterblight.CastleJusticeData.room_index = Winterblight.CastleJusticeData.room_index + 1

	local current_room_data = {}
	current_room_data.angels_entities = {}
	current_room_data.demons_entities = {}

	local room_index = Winterblight.CASTLE_DATA["tarot"][12]["rooms"][Winterblight.CastleJusticeData.room_index].index

	local key_positions = Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"]


	local angel_count = Winterblight.CastleJusticeData.angels_spawn_count
	local demon_count = Winterblight.CastleJusticeData.demons_spawn_count
	current_room_data.angels_spawned_count = 0
	current_room_data.demons_spawned_count = 0
	for i = 1, angel_count, 1 do
		local key_position = GetGroundPosition(key_positions[RandomInt(1, #key_positions)], Events.GameMaster) 
		local random_pos =  GetGroundPosition(key_position + RandomVector(RandomInt(150, 700)), Events.GameMaster)
		local spawnPos = WallPhysics:WallSearch(key_position, random_pos, Events.GameMaster)
		local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_justice_angel", spawnPos, RandomVector(1), false, true)
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, unit, "modifier_diviner_justice_white", {})
		table.insert(current_room_data.angels_entities, unit)
		current_room_data.angels_spawned_count = current_room_data.angels_spawned_count + 1
		unit.justice_index = Winterblight.CastleJusticeData.room_index
	end

	for i = 1, demon_count, 1 do
		local key_position = GetGroundPosition(key_positions[RandomInt(1, #key_positions)], Events.GameMaster) 
		local random_pos =  GetGroundPosition(key_position + RandomVector(RandomInt(150, 700)), Events.GameMaster)
		local spawnPos = WallPhysics:WallSearch(key_position, random_pos, Events.GameMaster)
		local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_justice_demon", spawnPos, RandomVector(1), false, true)
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, unit, "modifier_diviner_justice_black", {})
		table.insert(current_room_data.demons_entities, unit)
		current_room_data.demons_spawned_count = current_room_data.demons_spawned_count + 1
		unit.justice_index = Winterblight.CastleJusticeData.room_index
	end
	current_room_data.angels_killed = 0
	current_room_data.demons_killed = 0
	Winterblight.CastleJusticeData.room_results[Winterblight.CastleJusticeData.room_index] = current_room_data
end

function Winterblight:SpawnJusticeMatheus()
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_justice_arch_angel_matheus", Vector(13312, 896), RandomVector(1), false, true)
	SpecialFX:ColoredScaleSpotlightEntrance(unit, Vector(240, 245, 255), 120)
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, unit, "modifier_diviner_justice_white", {})

	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, unit, "modifier_diviner_justice_imbalance", {})
	local stacks = Winterblight.CastleJusticeData.total_demons_killed - Winterblight.CastleJusticeData.total_angels_killed
	unit:SetModifierStackCount("modifier_diviner_justice_imbalance", Winterblight.CastleDungeonMaster, stacks)

	unit:AddLootDrop("immortal", "item_rpc_angelic_gloves_of_the_judiciary", (Winterblight.CastleJusticeData.total_demons_killed-Winterblight.CastleJusticeData.total_angels_killed)*2)
end

function Winterblight:SpawnJusticeHellmouth()
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_justice_arch_demon_hellmouth", Vector(13312, 0), RandomVector(1), false, true)
	SpecialFX:ColoredScaleSpotlightEntrance(unit, Vector(255, 60, 40), 120)
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, unit, "modifier_diviner_justice_black", {})

	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, unit, "modifier_diviner_justice_imbalance", {})
	local stacks = Winterblight.CastleJusticeData.total_angels_killed - Winterblight.CastleJusticeData.total_demons_killed
	unit:SetModifierStackCount("modifier_diviner_justice_imbalance", Winterblight.CastleDungeonMaster, stacks)

	unit:AddLootDrop("immortal", "item_rpc_demonic_gloves_of_the_judiciary", (Winterblight.CastleJusticeData.total_angels_killed-Winterblight.CastleJusticeData.total_demons_killed)*2)
end

function Winterblight:SpawnJusticeBalance()
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_justice_balance", Vector(12278, 1024), Vector(0,-1), false, true)
	unit:AddLootDrop("immortal", "item_rpc_justice_greaves", 100)
	SpecialFX:ColoredScaleSpotlightEntrance(unit, Vector(255, 120, 40), 120)
end

function Winterblight:HangedManSpawns(room_index)
	print("HANG MAN SPAWNS")
	local key_positions = Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"]
	for i = 1, RandomInt(8, 12), 1 do
		local key_position = GetGroundPosition(key_positions[RandomInt(1, #key_positions)], Events.GameMaster) 
		local random_pos =  GetGroundPosition(key_position + RandomVector(RandomInt(150, 700)), Events.GameMaster)
		local spawnPos = WallPhysics:WallSearch(key_position, random_pos, Events.GameMaster)
		local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_hanging_slayer", spawnPos, RandomVector(1), false, true)
		unit:AddLootDrop("immortal", "item_rpc_hangman_slippers", 1)
	end
end

function Winterblight:HangedManPrepareHashMap()
	local unit_table = {"winterblight_draugr", "winterblight_accursed", "winterblight_defiler", "winterblight_wraithguard", "winterblight_wraithguard_elite", "winterblight_castle_warrior",
	"winterblight_elite_castle_warrior", "winterblight_skull_ripper", "winterblight_castle_watchman", "winterblight_frozen_mage", "winterblight_frozen_phantom", "winterblight_frozen_cage",
	"winterblight_frozen_soul", "winterblight_suffering_spirit", "winterblight_mountain_spirit", "winterblight_ancient_mountain_spirit", "winterblight_castle_watchman",
	"winterblight_skeleton_archer", "winterblight_bloodripper", "winterblight_saturn_zealot", "winterblight_ghost_pirate"}

	local shuffled_unit_table = WallPhysics:ShuffleTable(unit_table)

	local unit_table = {"winterblight_draugr", "winterblight_accursed", "winterblight_defiler", "winterblight_wraithguard", "winterblight_wraithguard_elite", "winterblight_castle_warrior",
	"winterblight_elite_castle_warrior", "winterblight_skull_ripper", "winterblight_castle_watchman", "winterblight_frozen_mage", "winterblight_frozen_phantom", "winterblight_frozen_cage",
	"winterblight_frozen_soul", "winterblight_suffering_spirit", "winterblight_mountain_spirit", "winterblight_ancient_mountain_spirit", "winterblight_castle_watchman",
	"winterblight_skeleton_archer", "winterblight_bloodripper", "winterblight_saturn_zealot", "winterblight_ghost_pirate"}

	Winterblight.HangedUnitHash = {}
	for i = 1, #unit_table, 1 do
		Winterblight.HangedUnitHash[unit_table[i]] = shuffled_unit_table[i]
	end
	DeepPrintTable(Winterblight.HangedUnitHash)
end

function Winterblight:TranslateHangedManUnit(unit_name)
	if Winterblight.HangedUnitHash[unit_name] then
		return Winterblight.HangedUnitHash[unit_name]
	else
		return unit_name
	end
end

function Winterblight:TemperanceWaterProps()
	local positionTable = {Vector(9517, 7278, 1139), Vector(11627, 10703, 1004), Vector(13580, 10591, 1000), Vector(14621, 13522, 1000), Vector(9742, 4586, 1310)}
	-- Vector(15385, 10990, 985) if we want o flood torture room
	for i = 1, #positionTable, 1 do
		local entity = Entities:FindByNameNearest("TemperanceWater", positionTable[i]+Vector(0,0,300), 1000)
		entity:SetAbsOrigin(entity:GetAbsOrigin() + Vector(0,0,300))
	end
end

function Winterblight:TemperanceBossChests()
	local chest_count = math.floor((GameRules:GetGameTime() - Winterblight.TemperanceDungeonStartTime)/720)
	chest_count = math.min(chest_count, 3)
	local positionTable = {Vector(11776, 1024), Vector(12288, 1024), Vector(12800, 1024)}
	for i = 1, chest_count, 1 do
		Timers:CreateTimer(i*2, function()
			Winterblight:GeneralChestSpawn(positionTable[i], Vector(0,-1))
		end)
	end
	if Winterblight.TemperanceChest then
		Timers:CreateTimer(8, function()
			Winterblight:TemperanceChestSpawn(Vector(12515, 1468), Vector(0,-1))
		end)
	end
end

function Winterblight:DevilBloodProps()
	local positionTable = {Vector(11627, 10703, 1004)}
	for i = 1, #positionTable, 1 do
		local entity = Entities:FindByNameNearest("DevilBlood", positionTable[i]+Vector(0,0,300), 1000)
		entity:SetAbsOrigin(entity:GetAbsOrigin() + Vector(0,0,600))
	end

	local entity = Entities:FindByNameNearest("HarborRoomGround", Vector(12267, 10781, 1814), 1000)
	entity:SetRenderColor(111, 63, 63)

	local entity = Entities:FindByNameNearest("HarborRoomFireParticle", Vector(11570, 12008, 1834), 1000)
	local pfx = ParticleManager:CreateParticle("particles/dire_fx/fire_ambience.vpcf", PATTACH_WORLDORIGIN, Winterblight.CastleDungeonMaster)
	ParticleManager:SetParticleControl(pfx, 0, entity:GetAbsOrigin())
	UTIL_Remove(entity)
	local entity = Entities:FindByNameNearest("HarborRoomFireParticle", Vector(12164, 12008, 1834), 1000)
	local pfx = ParticleManager:CreateParticle("particles/dire_fx/fire_ambience.vpcf", PATTACH_WORLDORIGIN, Winterblight.CastleDungeonMaster)
	ParticleManager:SetParticleControl(pfx, 0, entity:GetAbsOrigin())
	UTIL_Remove(entity)	

	Timers:CreateTimer(60, function()
		local entity = Entities:FindByNameNearest("HarborBatProp", Vector(11866, 12398, 1834), 1000)
		Events:smoothTranslate(entity, Vector(0,0,-5), 150, Vector(0,0), nil)
		-- UTIL_Remove(entity)	

		local entity = Entities:FindByNameNearest("HarborDevilProp", Vector(11851, 12371, 1134), 1000)
		Events:smoothTranslate(entity, Vector(0,0,5), 130, Vector(0,0), nil)
		-- entity:SetAbsOrigin(entity:GetAbsOrigin() + Vector(0,0,700))
	end)
end

function Winterblight:CastleMoonProps()
	local entity = Entities:FindByNameNearest("CastleMoonPlatform", Vector(14713, -2720, 1800), 1000)
	entity:SetAngles(0, 180, 0)
	Winterblight.CastleMoonPlatform = {}
	Winterblight.CastleMoonPlatform["entity"] = entity
	Winterblight.CastleMoonPlatform["color"] = Vector(255, 255, 255)
	Winterblight.CastleMoonPlatform["lock"] = false
	Winterblight.CastleMoonPlatform["lift_speed"] = 0
	Winterblight.CastleMoonPlatform["lift_interval"] = 0

	local remove_platform = Entities:FindByNameNearest("MoonPlatformCollision", Vector(14713, -2720, 1800), 1000)
	UTIL_Remove(remove_platform)
end

function Winterblight:ResetCastleMoonEvent()
	-- MAIN_HERO_TABLE[1]:RemoveModifierByName(string pszScriptName)
	-- Winterblight.CastleMoonPlatform["entity"]:SetAbsOrigin(Vector(14713, -2720, 1800))
end

function Winterblight:SpawnDevilRings(room_index)
	if not Winterblight.DevilRingData then
		Winterblight.DevilRingData = {}
	else
		for i = 1, #Winterblight.DevilRingData, 1 do
			ParticleManager:DestroyParticle(Winterblight.DevilRingData[i].pfx, false)
		end
	end
	local doomring_table = {}
	local key_positions = {}
	if room_index == -1 then
		for i = 1, 2+GameState:GetDifficultyFactor(), 1 do
			table.insert(key_positions, Vector(12306, 188, 600) + RandomVector(RandomInt(360, 1400)))
		end
	else
		key_positions = Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"]
	end
	for i = 1, #key_positions, 1 do
		local doomring = {}
		local key_position = GetGroundPosition(key_positions[RandomInt(1, #key_positions)], Events.GameMaster)
		local random_pos = key_position + RandomVector(RandomInt(80, 800))
		if room_index == -1 then
			random_pos = key_position
		end
		local spawnPos = WallPhysics:WallSearch(key_position, random_pos, Events.GameMaster)
		doomring.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_doom.vpcf", PATTACH_CUSTOMORIGIN, nil)
		doomring.position = spawnPos
		ParticleManager:SetParticleControl(doomring.pfx, 0, doomring.position)
		ParticleManager:SetParticleControl(doomring.pfx, 1, doomring.position)
		table.insert(doomring_table, doomring)
	end
	Winterblight.DevilRingData = doomring_table
end

function Winterblight:SpawnSunGroundFire(room_index)
	if room_index == 7 then
		return false
	end
	if not Winterblight.SunFireData then
		Winterblight.SunFireData = {}
	else
		for i = 1, #Winterblight.SunFireData, 1 do
			print("Destroy particles")
			ParticleManager:DestroyParticle(Winterblight.SunFireData[i].pfx, false)
		end
	end
	local sunfire_table = {}
	local key_positions = {}
	if room_index == -1 then
		for i = 1, 15+GameState:GetDifficultyFactor()*5 + Winterblight.Stones*4, 1 do
			table.insert(key_positions, Vector(12306, 188, 600) + RandomVector(RandomInt(360, 1400)))
		end
	else
		key_positions = Winterblight.CASTLE_DATA["rooms"][room_index]["key_positions"]
	end
	for i = 1, #key_positions, 1 do
		local key_position = GetGroundPosition(key_positions[i], Events.GameMaster)
		local random_pos = key_position + RandomVector(RandomInt(80, 400))
		if room_index == -1 then
			random_pos = key_position
		end
		local spawnPos = WallPhysics:WallSearch(key_position, random_pos, Events.GameMaster)
		local moveDirection = RandomVector(1)
		local lastSpawnPos = spawnPos
		local count = 15
		if room_index == -1 then
			count = 1
		end
		for j = 1, count, 1 do
			local sunfire = {}
			moveDirection = WallPhysics:rotateVector(moveDirection, 2*math.pi*RandomInt(-30, 30)/360)
			lastSpawnPos = lastSpawnPos + moveDirection*70
			sunfire.pfx = ParticleManager:CreateParticle("particles/econ/items/batrider/batrider_ti8_immortal_mount/batrider_ti8_immortal_firefly.vpcf", PATTACH_CUSTOMORIGIN, nil)
			sunfire.position = lastSpawnPos
			ParticleManager:SetParticleControl(sunfire.pfx, 0, sunfire.position)
			ParticleManager:SetParticleControl(sunfire.pfx, 1, sunfire.position)
			table.insert(sunfire_table, sunfire)
		end
	end
	Winterblight.SunFireData = sunfire_table
end

function Winterblight:CastleSunPhoenixSequence()
	local positionTable = {Vector(14812, 5376), Vector(15074, 5035), Vector(15401, 4692), Vector(15656, 4706), Vector(16083, 4876), Vector(15877, 5105), Vector(15488, 5058), Vector(16023, 6272), Vector(15634, 6528), Vector(15872, 6912), Vector(16023, 7424), Vector(14694, 6973), Vector(14382, 6639), Vector(14250, 6212)}
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	positionTable = WallPhysics:ShuffleTable(positionTable)
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.24, function()
			local egg = CreateUnitByName("npc_dummy_unit", positionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
			egg:SetAbsOrigin(egg:GetAbsOrigin()-Vector(0,0,RandomInt(600, 1000)))
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, egg, "modifier_diviner_sun_immolation", {})
			egg:SetOriginalModel("models/items/phoenix/ultimate/blazing_wing_blazing_egg/blazing_wing_blazing_egg.vmdl")
			egg:SetModel("models/items/phoenix/ultimate/blazing_wing_blazing_egg/blazing_wing_blazing_egg.vmdl")
			egg:SetModelScale(1)	
			StartAnimation(egg, {duration = 10.0, activity = ACT_DOTA_IDLE, rate = 0.8})	
			egg:FindAbilityByName("dummy_unit"):SetLevel(1)
			master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, egg, "modifier_diviner_sun_event_thinker", {})
			EmitSoundOn("Winterblight.SunPhoenixEvent.Egg.Supernova", egg)
		end)
	end

	Winterblight.CastleDungeonMaster.sun_phoenixes_slain = 0
	Winterblight.CastleDungeonMaster.sun_phoenixes_count = #positionTable
end

function Winterblight:WorldBossSpawn()
	local boss = Events:SpawnBoss("winterblight_world_commander_vorethrex", Vector(12544, 2688))
	AddFOWViewer(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 800, 20, false)
	SpecialFX:ColoredSpotlight(boss:GetAbsOrigin(), Vector(40, 155, 255))

	boss:SetAbsOrigin(boss:GetAbsOrigin()+Vector(0,0,1000))
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, boss, "modifier_diviner_star_entering", {duration = 10})
	boss:SetForwardVector(Vector(0,-1))
	Timers:CreateTimer(2, function()
		EmitSoundOn("Winterblight.DescribeTarotHaunt", boss)
	end)
	Timers:CreateTimer(3, function()
		EmitSoundOn("Winterblight.Vorethrex.Spawn", boss)
	end)
    local ability = boss:AddAbility("dungeon_creep")
	ability:SetLevel(1)
	ability:ApplyDataDrivenModifier(boss, boss, "modifier_dungeon_thinker_creep", {})
	local aggroSound = boss:GetKeyValue("RoshpitAggroSound")
	if aggroSound ~= 0 then
	  boss.aggroSound = aggroSound
	end
	boss.fight_phase = 0
end

function Winterblight:WorldInit()
	for i = 2, 13, 1 do
		Winterblight:OpenCastleDoorByIndex(i)
	end
	Winterblight:WorldRoomInitializers()
end

function Winterblight:WorldRoomInitializers()
	Winterblight.CastleDungeonMaster.world_pad_table = {}
	for i = 1, 12, 1 do
		Timers:CreateTimer(i*0.03, function()
			if Winterblight.CASTLE_DATA["rooms"][i]["cleared"] == 0 then
				local pad_point = Winterblight.CASTLE_DATA["rooms"][i]["mid_point"]
				local pad_dummy = CreateUnitByName("npc_dummy_unit", pad_point, false, nil, nil, DOTA_TEAM_NEUTRALS)
				pad_dummy:SetRenderColor(100, 140, 255)
				pad_dummy:SetModelScale(0.5)
				pad_dummy:SetModel("models/props_gameplay/conquest_point.vmdl")
				pad_dummy:SetOriginalModel("models/props_gameplay/conquest_point.vmdl")
				pad_dummy:SetAbsOrigin(pad_dummy:GetAbsOrigin()+Vector(0,0,30))
				local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")		
				master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, pad_dummy, "modifier_diviner_world_pad_think", {})
				pad_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
				pad_dummy.room_index = i
				table.insert(Winterblight.CastleDungeonMaster.world_pad_table, pad_dummy)	
			end
		end)
	end

end

function Winterblight:JudgementShow(room_index)
	if not Winterblight.JudgementTimesCounted then
		Winterblight.JudgementTimesCounted = 0
	end
	Winterblight.JudgementTimesCounted = Winterblight.JudgementTimesCounted + 1
	local spawnPosition = Winterblight.CASTLE_DATA["rooms"][room_index]["mid_point"] + Vector(0, 240)
	local judge = Enemies:SpawnEnemyUnit("winterblight_judgement_judge", spawnPosition, Vector(0,-1), false)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", judge:GetAbsOrigin(), 3)
	EmitSoundOn("Winterblight.GraveGhostSpawn", judge)
	EmitSoundOn("Winterblight.CastleJudge.InVO", judge)
	local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")		
	master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, judge, "modifier_diviner_judge_invincible", {})

	AddFOWViewer(DOTA_TEAM_GOODGUYS, judge:GetAbsOrigin(), 500, 15, false)
	judge.props_table = {}
	Winterblight.CASTLE_DATA["rooms"][room_index]["judgement_time_end"] = GameRules:GetGameTime()

	local time = Winterblight.CASTLE_DATA["rooms"][room_index]["judgement_time_end"] - Winterblight.CASTLE_DATA["rooms"][room_index]["judgement_time_start"]
	if not Winterblight.JudgementTotalTime then
		Winterblight.JudgementTotalTime = 0
	end
	Winterblight.JudgementTotalTime = Winterblight.JudgementTotalTime + time

	local digits = {}
	digits[1] = math.floor(time/600)
	digits[2] = math.floor((time%600)/60)
	digits[3] = nil
	local seconds = time%60
	digits[4] = math.floor(seconds/10)
	digits[5] = seconds%10
	Timers:CreateTimer(2, function()
		for i = 1, 5, 1 do
			Timers:CreateTimer(i*0.6 - 0.45, function()
				StartAnimation(judge, {duration = 1.0, activity = ACT_DOTA_ATTACK, rate = 1})
			end)
			Timers:CreateTimer(i*0.6, function()
				local prop_point = Winterblight.CASTLE_DATA["rooms"][room_index]["mid_point"] + Vector(-300, 0) + Vector(150*(i-1), 0)
				local time_prop = CreateUnitByName("npc_dummy_unit", prop_point, false, nil, nil, DOTA_TEAM_NEUTRALS)
				time_prop:SetRenderColor(100, 140, 255)
				time_prop:SetModelScale(1)
				-- time_prop:SetModel("models/heroes/wisp/wisp_additive.vmdl")
				-- time_prop:SetOriginalModel("models/heroes/wisp/wisp_additive.vmdl")
				SpecialFX:ColoredPop(time_prop:GetAbsOrigin()+Vector(0,0,20), Vector(0, 240, 255))
				EmitSoundOn("Winterblight.CastleJudge.PropSpawn", time_prop)
				table.insert(judge.props_table, time_prop)
				if digits[i] then
					time_prop.counter_pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/judgement_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, time_prop)
					ParticleManager:SetParticleControlEnt(time_prop.counter_pfx, 0, time_prop, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", time_prop:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(time_prop.counter_pfx, 1, Vector(0, digits[i], 0))
				else
					time_prop.counter_pfx = ParticleManager:CreateParticle("particles/roshpit/winterblight/judgement_delimiter.vpcf", PATTACH_OVERHEAD_FOLLOW, time_prop)
					ParticleManager:SetParticleControlEnt(time_prop.counter_pfx, 0, time_prop, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", time_prop:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(time_prop.counter_pfx, 1, Vector(0, digits[i], 0))
				end
			end)
		end
		Timers:CreateTimer(7, function()
			for i = 1, #judge.props_table, 1 do
				SpecialFX:ColoredPop(judge.props_table[i]:GetAbsOrigin()+Vector(0,0,20), Vector(0, 240, 255))
				if judge.props_table[i].counter_pfx then
					ParticleManager:DestroyParticle(judge.props_table[i].counter_pfx, false)
				end
				UTIL_Remove(judge.props_table[i])
			end
			if Winterblight.JudgementTimesCounted < 9 then
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", judge:GetAbsOrigin(), 3)
				EmitSoundOn("Winterblight.GraveGhostSpawn", judge)
				EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)
				UTIL_Remove(judge)
			else
				judge.final_phase = 0
				EmitSoundOn("Winterblight.CastleJudge.OutVO", judge)
			end
		end)
	end)
end

function Winterblight:DropCruxysEkkanArcana(boss)
	local luck = RandomInt(1, 3)
	local arcana = nil
	if luck == 1 then
	    RPCItems:RollAndDropUniqueArcana(boss, "item_rpc_ekkan_arcana2a")
	elseif luck == 2 then
		RPCItems:RollAndDropUniqueArcana(boss, "item_rpc_ekkan_arcana2b")
	elseif luck == 3 then
		RPCItems:RollAndDropUniqueArcana(boss, "item_rpc_ekkan_arcana2c")
	end
	return arcana
end

function Winterblight:CreateCastleTarotCard(position, tarot_name)
	local item = RPCItems:CreateConsumable("item_rpc_winterblight_tarot_card", "mythical", "Winterblight Tarot Card", "consumable", false, "Consumable", "item_rpc_winterblight_tarot_card_desc")

	card_tarot_name = tarot_name
	if not tarot_name then
		card_tarot_name = Winterblight.CastleTarot["name"]
		local luck = RandomInt(1, 2)
		if luck == 1 then
			card_tarot_name = Winterblight.CASTLE_DATA["tarot"][RandomInt(1, 22)]["name"]
		end
	end

	item.newItemTable.stashable = true
	item.newItemTable.consumable = true
	item.cantStash = false
	item.newItemTable.property1 = 1
	item.newItemTable.property1name = "tarot_"..card_tarot_name
	item.newItemTable.property1color = "#6a4373"
	item.newItemTable.property1tooltip = "tarot_"..card_tarot_name
	RPCItems:SetPropertyValues(item, item.newItemTable.property1, item.newItemTable.property1name, item.newItemTable.property1color, 1)
	RPCItems:ItemUpdateCustomNetTables(item)
	if position then
		RPCItems:BasicDropItem(position, item)
		return item
	else
		return item
	end
end

function Winterblight:SpawnHighPriestessBoss()
    local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_bishop_of_hades", Vector(10624, 6683), Vector(0,-1), false, true)
    Winterblight:AddPatrolArguments(unit, 40, 20, 200, {Vector(14592, 13568), Vector(10624, 6683), Vector(12318, 2304)})
    unit:AddLootDrop("immortal", "item_rpc_cloak_of_the_cimmerian_priesthood", 100)

	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", unit, 8)
	ParticleManager:SetParticleControl(pfx, 1, unit:GetAbsOrigin())
	Timers:CreateTimer(0.5, function()
		EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Winterblight.Magician.ChestSpawn", Events.GameMaster)
	end)
end

function Winterblight:TemperanceChestSpawn(position, fv)
	if not Winterblight.TemperanceChest then
		return false
	end
	local spawnPoint = GetGroundPosition(position, Events.GameMaster)
	local pfx_dummy = CreateUnitByName("npc_dummy_unit", spawnPoint, true, nil, nil, DOTA_TEAM_GOODGUYS)
	pfx_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", pfx_dummy, 8)
	ParticleManager:SetParticleControl(pfx, 1, spawnPoint)
	Timers:CreateTimer(0.5, function()
		EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.Magician.ChestSpawn", Events.GameMaster)
	end)
	Timers:CreateTimer(2, function()
		local chest = Enemies:SpawnEnemyUnit("winterblight_treasure_chest", spawnPoint, fv*-1, false)
		chest:SetRenderColor(80, 180, 250)
		EmitSoundOn("Winterblight.TreasureTower.GoldSound", chest)
		EmitSoundOn("Winterblight.Magician.ChestSpawn2", chest)
		chest.contents = {temperance_boots = 1}
		Timers:CreateTimer(6, function()
			UTIL_Remove(pfx_dummy)
		end)
		CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", chest, 8)
	end)
end

function Winterblight:InitCastleStarQuest()
	local positionTable = {Vector(14976, 13312), Vector(14154, 8282), Vector(9064, 2755), Vector(13282, 2207), Vector(10721, 613), Vector(11072, -1052), Vector(11711, -346),
	Vector(12354, -1016), Vector(13848, -798), Vector(12975, 754), Vector(9088, 1664), Vector(9088, 2079), Vector(13383, 3596), Vector(12875, 3749), Vector(11946, 7268),
	Vector(13058, 7268), Vector(13609, 8206), Vector(15159, 8716), Vector(13936, 11434), Vector(13401, 12092), Vector(13397, 13912), Vector(14081, 13938), Vector(15108, 13938),
	Vector(15525, 13283)}

	local shuffledTable = WallPhysics:ShuffleTable(positionTable)
	for i = 1, 5, 1 do
		local star_tile = CreateUnitByName("npc_dummy_unit", shuffledTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
		local master_ability = Winterblight.CastleDungeonMaster:FindAbilityByName("winterblight_the_diviner_passive")
		master_ability:ApplyDataDrivenModifier(Winterblight.CastleDungeonMaster, star_tile, "modifier_diviner_star_dummy_thinker", {})
		star_tile:FindAbilityByName("dummy_unit"):SetLevel(1)	
		star_tile:SetForwardVector(RandomVector(1))
		local colorVector = Vector(30,30,30)
		star_tile:SetRenderColor(colorVector.x, colorVector.y, colorVector.z)
		star_tile.colorVector = colorVector
		star_tile:SetModel("models/winterblight/castle_star.vmdl")
		star_tile:SetOriginalModel("models/winterblight/castle_star.vmdl")
		star_tile:SetAbsOrigin(star_tile:GetAbsOrigin() + Vector(0,0,8))
	end
end

function Winterblight:StarQuestBossSpawn(position)
	position = position + Vector(0,100,0)

	local pfx_dummy = CreateUnitByName("npc_dummy_unit", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
	pfx_dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	pfx_dummy:SetAbsOrigin(pfx_dummy:GetAbsOrigin()+Vector(0,0,200))
	pfx_dummy:SetForwardVector(Vector(0,-1))
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/debut/void_spirit_portal_debut.vpcf", PATTACH_ABSORIGIN_FOLLOW, pfx_dummy)
	ParticleManager:SetParticleControlEnt(pfx, 0, pfx_dummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", pfx_dummy:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, pfx_dummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", pfx_dummy:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, pfx_dummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", pfx_dummy:GetAbsOrigin(), true)
	Timers:CreateTimer(8, function()
		ParticleManager:DestroyParticle(pfx, false)
		EmitSoundOnLocationWithCaster(position, "Winterblight.Castle.Starboss.Intro3", Events.GameMaster)
	end)
	-- local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_void_spirit/debut/void_spirit_portal_debut.vpcf", position, 10)
	ParticleManager:SetParticleControl(pfx, 1, position)
	Timers:CreateTimer(2, function()
		local miniboss = Winterblight:SpawnCastleRoomUnit(0, "winterblight_castle_star_miniboss", position, Vector(0,-1), false, true)
		miniboss:SetAbsOrigin(miniboss:GetAbsOrigin()+Vector(0,100,100))
		local miniboss_ability = miniboss:FindAbilityByName("winterblight_star_boss_passive")
		Timers:CreateTimer(0, function()
			EmitSoundOn("Winterblight.Castle.Starboss.Intro", miniboss)
		end)
		miniboss_ability:ApplyDataDrivenModifier(miniboss, miniboss, "modifier_winter_boss_intro", {duration = 5})
		Events:smoothSizeChange(miniboss, 0.3, 2.5, 95)
		Events:smoothTranslate(miniboss, Vector(0,-4,0), 90, Vector(0,0), nil)
		miniboss.cantAggro = true
		Timers:CreateTimer(3, function()
			EmitSoundOn("Winterblight.Castle.Starboss.Intro2", miniboss)
		end)
		Timers:CreateTimer(5, function()
			CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", miniboss:GetAbsOrigin(), 3)
			miniboss.cantAggro = false
			Dungeons:AggroUnit(miniboss)
		end)
		miniboss:AddLootDrop("immortal", "item_rpc_exodia_gloves", 100)
	end)
end

function Winterblight:SpawnEmpressBoss()
	local positionTable = {Vector(11264, 896), Vector(13312, 896), Vector(13312, -640), Vector(11264, -640)}
    local unit = Winterblight:SpawnCastleRoomUnit(0, "winterblight_empress_emasz", positionTable[RandomInt(1, #positionTable)], Vector(0,-1), false, true)
    Winterblight:AddPatrolArguments(unit, 5, 20, 400, positionTable)
    -- unit:AddLootDrop("immortal", "item_rpc_cloak_of_the_cimmerian_priesthood", 100)

	local pfx = CustomAbilities:QuickAttachParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_death.vpcf", unit, 8)
	ParticleManager:SetParticleControl(pfx, 1, unit:GetAbsOrigin())
	Timers:CreateTimer(0.5, function()
		EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Winterblight.Magician.ChestSpawn", Events.GameMaster)
	end)
end

function Winterblight:DropEmperorQuestItem(drop_type, position)
	if drop_type == "emperor" then
		RPCItems:CreateBasicConsumable(position, "item_rpc_emperors_band", "Emperor's Band", "mythical", true)
	elseif drop_type == "empress" then
		RPCItems:CreateBasicConsumable(position, "item_rpc_empress_jewel", "Empress' Jewel", "mythical", true)
	end
end
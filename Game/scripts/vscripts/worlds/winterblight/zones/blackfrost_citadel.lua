function Winterblight:OpenWinterblightCastle()
	if not Winterblight.WinterCastleOpened then
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
		Events:DoorDust(Vector(10752, 13952), Vector(0,-1), 600, 60, 0.2)

		Timers:CreateTimer(10, function()
			local spawnPosition = Vector(11818, 14419)
			local wraith = Enemies:SpawnEnemyUnit("winterblight_diviner_sk", spawnPosition, Vector(0,-1), false)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", wraith:GetAbsOrigin(), 3)
			EmitSoundOn("Winterblight.GraveGhostSpawn", wraith)
			AddFOWViewer(DOTA_TEAM_GOODGUYS, wraith:GetAbsOrigin(), 500, 5, false)
		end)
		Dungeons.respawnPoint = Vector(11812, 13652)
	end
end
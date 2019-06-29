function Tanari:SpawnChampionsTrailPart1()
	Tanari.unibi = CreateUnitByName("npc_flying_dummy_vision", Vector(-4736, 1210), false, nil, nil, DOTA_TEAM_GOODGUYS)
	Tanari.unibi:AddAbility("dummy_unit"):SetLevel(1)
	Tanari.unibi:SetOriginalModel("models/items/courier/onibi_lvl_00/onibi_lvl_00.vmdl")
	Tanari.unibi:SetModel("models/items/courier/onibi_lvl_00/onibi_lvl_00.vmdl")
	Tanari.unibi:SetModelScale(1.4)
	local unibiAbility = Tanari.unibi:AddAbility("unibi_ai")
	unibiAbility:SetLevel(1)
	unibiAbility:ApplyDataDrivenModifier(Tanari.unibi, Tanari.unibi, "modifier_unibi_z_delta", {})
	Tanari.unibi:SetModifierStackCount("modifier_unibi_z_delta", caster, 240)
	Tanari.unibi.phase = 0
	Tanari.unibi.zPhase = 240
	Tanari.unibi.targetZ = 240
	Tanari.unibi.bonusZSpeed = 0
	Tanari.unibi.floatUp = true
	Tanari.unibi.wayPointEnabled = true
	Tanari.unibi.objectiveCount = 0

	Tanari.unibi:SetForwardVector(Vector(0, 1))

	Tanari:SpawnBasicKobold(Vector(-1, -1), Vector(-4352, 192))
	Tanari:SpawnBasicKobold(Vector(-0.1, -1), Vector(-4132, 180))
	Tanari:SpawnBasicKobold(Vector(1, 0), Vector(-5216, 271))
	Tanari:SpawnBasicKobold(Vector(1, 0), Vector(-5167, 107))
	Tanari:SpawnBasicKobold(Vector(1, 0.4), Vector(-5080, -271))

	Timers:CreateTimer(4, function()
		local vectorTable = {Vector(-2752, -1024), Vector(-3018, -964), Vector(-2496, -872), Vector(-2402, 3), Vector(-2863, 80), Vector(-2292, -488), Vector(-2496, -512), Vector(-2823, -410)}
		local fvTable = {Vector(0, 1), Vector(1, 1), Vector(-1, 1), Vector(0, -1), Vector(0, -1), Vector(-1, 0), Vector(-1, 0), Vector(-1, 1)}
		for i = 1, #vectorTable, 1 do
			Timers:CreateTimer(i * 0.5, function()
				Tanari:SpawnWaterTroll(vectorTable[i], fvTable[i])
			end)
		end
		Tanari:SpawnWaterTrollBig(Vector(-2240, -704), Vector(-1, 1))
		Timers:CreateTimer(3, function()
			Tanari:SpawnClamSpawner(Vector(-3008, 192), Vector(0, 0), Vector(-3008, 112))
			Tanari:SpawnClamSpawner(Vector(-2161, 22), Vector(-1, -1), Vector(-2361, -80))
			Tanari:SpawnClamSpawner(Vector(-2633, -1021), Vector(0, 1), Vector(-2633, -990))
			Timers:CreateTimer(2, function()
				Tanari:SpawnClamSpawner(Vector(-1548, -1360), Vector(0, 1), Vector(-1548, -1160))
				Tanari:SpawnClamSpawner(Vector(2004, -1600), Vector(-1, 1), Vector(2004, -1500))
				Tanari:SpawnClamSpawner(Vector(1893, 425), Vector(-1, -1), Vector(1800, 300))
				Tanari:SpawnClamSpawner(Vector(918, 502), Vector(0, -1), Vector(920, 300))
				Tanari:SpawnClamSpawner(Vector(-85, 502), Vector(0, -1), Vector(-85, 300))
			end)
			Timers:CreateTimer(1, function()
				Tanari:SpawnVoodooDoctor(Vector(-2880, -1664), Vector(0.5, 1))
				Tanari:SpawnVoodooDoctor(Vector(-2688, -1344), Vector(0.2, 1))
				Tanari:SpawnVoodooDoctor(Vector(-2240, -1472), Vector(0, 1))

				Tanari:SpawnVoodooDoctor(Vector(-3693, -1344), Vector(1, 1))
				Tanari:SpawnVoodooDoctor(Vector(-3392, -1600), Vector(0, 1))
			end)
			Timers:CreateTimer(0.5, function()
				Tanari:OutsideCampPatrols()
			end)
		end)
	end)

	Tanari:SpawnBongoFrog(Vector(-512, 3712), Vector(1, 0))

	Timers:CreateTimer(7, function()
		for i = 1, 5, 1 do
			Timers:CreateTimer(0.4 * i, function()
				Tanari:SpawnAngryFish(Vector(-960, -1152), Vector(0, 1))
			end)
		end
	end)
	Timers:CreateTimer(20, function()
		local heroLocTable = {}
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local heroPos = MAIN_HERO_TABLE[i]:GetAbsOrigin()
			if heroPos.x > -5440 and heroPos.y > -5888 and heroPos.y < 10000 and heroPos.y > -4160 then
				table.insert(heroLocTable, heroPos)
			end
		end
		if #heroLocTable > 0 then
			-- local totalVector = Vector(0,0,0)
			-- for j = 1, #heroLocTable, 1 do
			-- totalVector = totalVector+heroLocTable[j]
			-- end
			-- local avgVector = totalVector/#heroLocTable
			-- EmitSoundOnLocationWithCaster(avgVector, "Ambient.Tanari.Waterfall", Events.GameMaster)
			-- EmitSoundOnLocationWithCaster(avgVector, "Ambient.Tanari.Pond", Events.GameMaster)
			--print("PLAY POND SOUNDS")
			EmitSoundOnLocationWithCaster(Vector(2213, -896, 256), "Ambient.Tanari.Waterfall", Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(-960, -768, 38), "Ambient.Tanari.Pond", Events.GameMaster)
			EmitSoundOnLocationWithCaster(Vector(8320, -1344, 677), "Ambient.Tanari.Riverflow", Events.GameMaster)
		end
		

		return 20
	end)
	EmitSoundOnLocationWithCaster(Vector(2213, -896, 256), "Ambient.Tanari.Waterfall", Events.GameMaster)
	EmitSoundOnLocationWithCaster(Vector(-960, -768, 38), "Ambient.Tanari.Pond", Events.GameMaster)
	EmitSoundOnLocationWithCaster(Vector(8320, -1344, 677), "Ambient.Tanari.Riverflow", Events.GameMaster)
	Timers:CreateTimer(0, function()
		Timers:CreateTimer(11, function()
			local heroLocTable = {}
			for i = 1, #MAIN_HERO_TABLE, 1 do
				local heroPos = MAIN_HERO_TABLE[i]:GetAbsOrigin()
				if heroPos.x > -5880 and heroPos.y > -5888 and heroPos.y < 10000 then
					table.insert(heroLocTable, heroPos)
				end
			end
			if #heroLocTable > 0 then
				-- local totalVector = Vector(0,0,0)
				-- for j = 1, #heroLocTable, 1 do
				-- totalVector = totalVector+heroLocTable[j]
				-- end
				-- local avgVector = totalVector/#heroLocTable
				EmitSoundOnLocationWithCaster(Vector(-2176, 2176, 144), "Ambient.Tanari.Jungle", Events.GameMaster)
				EmitSoundOnLocationWithCaster(Vector(-5120, -576, 174), "Ambient.Tanari.Jungle", Events.GameMaster)
				EmitSoundOnLocationWithCaster(Vector(5184, 2816, 128), "Ambient.Tanari.Jungle", Events.GameMaster)
				EmitSoundOnLocationWithCaster(Vector(7488, 2240, 128), "Ambient.Tanari.Jungle", Events.GameMaster)
				EmitSoundOnLocationWithCaster(Vector(8768, 3252, 128), "Ambient.Tanari.Jungle", Events.GameMaster)
			end
			return 11
		end)
		EmitSoundOnLocationWithCaster(Vector(-2176, 2176, 144), "Ambient.Tanari.Jungle", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(-5120, -576, 174), "Ambient.Tanari.Jungle", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(5184, 2816, 128), "Ambient.Tanari.Jungle", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(7488, 2240, 128), "Ambient.Tanari.Jungle", Events.GameMaster)
		EmitSoundOnLocationWithCaster(Vector(8768, 3252, 128), "Ambient.Tanari.Jungle", Events.GameMaster)
	end)
end

function Tanari:OutsideCampPatrols()
	local position1 = Vector(-2432, 768)
	local position2 = Vector(-1152, 896)
	local position3 = Vector(-1024, 2688)
	local position4 = Vector(-384, 3520)
	local position5 = Vector(2368, 3328)

	local doctor = Tanari:SpawnVoodooDoctor(position1, RandomVector(1))
	Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position3, position2, position1})
	local doctor = Tanari:SpawnVoodooDoctor(position1 + RandomVector(80), RandomVector(1))
	Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position3, position2, position1})
	if GameState:GetDifficultyFactor() > 1 then
		local doctor = Tanari:SpawnVoodooAlchemist(position2, RandomVector(1))
		Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position2, position1, position3})
		local doctor = Tanari:SpawnVoodooAlchemist(position2 + RandomVector(80), RandomVector(1))
		Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position2, position1, position3})
	end
	local doctor = Tanari:SpawnVoodooDoctor(position2 + RandomVector(80), RandomVector(1))
	Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position2, position1, position3})
	Timers:CreateTimer(2, function()
		local doctor = Tanari:SpawnVoodooAlchemist(position3, RandomVector(1))
		Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position1, position3, position2})
		if GameState:GetDifficultyFactor() > 1 then
			local doctor = Tanari:SpawnVoodooAlchemist(position3 + RandomVector(80), RandomVector(1))
			Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position1, position3, position2})
			local doctor = Tanari:SpawnGrizzledWoodsman(position3 + RandomVector(80), RandomVector(1))
			Tanari:AddPatrolArguments(doctor, 30, 4, 240, {position1, position3, position2})
		end

		local doctor = Tanari:SpawnGrizzledWoodsman(position4 + RandomVector(80), RandomVector(1))
		Tanari:AddPatrolArguments(doctor, 30, 3, 240, {position5, position4})
		local doctor = Tanari:SpawnGrizzledWoodsman(position4 + RandomVector(80), RandomVector(1))
		Tanari:AddPatrolArguments(doctor, 30, 3, 240, {position5, position4})
	end)
	Timers:CreateTimer(4, function()
		if GameState:GetDifficultyFactor() > 1 then
			local doctor = Tanari:SpawnGrizzledWoodsman(position5 + RandomVector(80), RandomVector(1))
			Tanari:AddPatrolArguments(doctor, 30, 3, 240, {position4, position5})
		end
		local doctor = Tanari:SpawnVoodooAlchemist(position5 + RandomVector(80), RandomVector(1))
		Tanari:AddPatrolArguments(doctor, 30, 3, 240, {position4, position5})
		local doctor = Tanari:SpawnVoodooDoctor(position5 + RandomVector(80), RandomVector(1))
		Tanari:AddPatrolArguments(doctor, 30, 3, 240, {position4, position5})
	end)
end

function Tanari:SpawnBasicKobold(fv, position)
	local kobold = Tanari:SpawnDungeonUnit("easy_kobold", position, 1, 2, "techies_tech_pain_09", fv, false)
	kobold:SetRenderColor(230, 230, 255)
	kobold.itemLevel = 1
	kobold.dominion = true
end

function Tanari:SpawnStatueFlower()
	local randomX = RandomInt(0, 850)
	local position = Vector(-4928 + randomX, -1368)
	local flower = Tanari:SpawnDungeonUnit("tanari_shrine_growth", position, 0, 1, nil, Vector(0, 1), true)
	WallPhysics:Jump(flower, Vector(0, 1), 15 + RandomInt(2, 10), 15, 25, 1.5)
	StartAnimation(flower, {duration = 1, activity = ACT_DOTA_ATTACK, rate = 1.2})
	flower.itemLevel = 1
	flower.dominion = true
	return flower
end

function Tanari:StatueSpawnFlowers()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-4450, -1368, 700), 500, 20, false)
	for i = 0, 24, 1 do
		Timers:CreateTimer(0.15 * i, function()
			local flower = Tanari:SpawnStatueFlower()
			if i % 4 == 0 and i < 12 then
				EmitSoundOn("Hero_Treant.Overgrowth.Target", flower)
			end
		end)
	end
end

function Tanari:SpawnWaterTroll(position, fv)
	local troll = Tanari:SpawnDungeonUnit("tanari_water_troll", position, 0, 2, "techies_tech_pain_04", fv, false)
	troll:SetRenderColor(150, 150, 255)
	troll.itemLevel = 3
	troll.dominion = true
	-- local properties =  {
	--     pitch = 0,
	--     yaw = 0,
	--     roll = 0,
	--     XPos = 0,
	--     YPos = 0,
	--     ZPos = -100,
	--   }
	-- Attachments:AttachProp(troll, "attach_hitloc",  "models/items/witchdoctor/twilights_rest_head/twilights_rest_head.vmdl", 1.1, properties)
end

function Tanari:SpawnWaterTrollBig(position, fv)
	local troll = Tanari:SpawnDungeonUnit("tanari_water_troll_big", position, 2, 3, "techies_tech_pain_01", fv, false)
	troll:SetRenderColor(200, 200, 255)
	troll.itemLevel = 4
	troll.dominion = true
end

function Tanari:SpawnAngryFish(position, fv)
	local troll = Tanari:SpawnDungeonUnit("tanari_angry_fish", position, 1, 2, "tidehunter_tide_pain_04", fv, false)
	troll.itemLevel = 4
	troll.dominion = true
end

function Tanari:SpawnAmbushers()
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-1280, -1536), 0, 1, nil, Vector(0, 1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-1811, -1536), 0, 1, nil, Vector(0, 1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-1949, -1438), 0, 1, nil, Vector(0, 1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-2032, -1316), 0, 1, nil, Vector(0, 1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-1795, -171), 0, 1, nil, Vector(0, -1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-1718, -330), 0, 1, nil, Vector(0, -1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-1647, -330), 0, 1, nil, Vector(0, -1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
	local ambusher = Tanari:SpawnDungeonUnit("tanari_ambusher", Vector(-1518, -208), 0, 1, nil, Vector(0, -1), true)
	ambusher.itemLevel = 2
	ambusher.dominion = true
end

function Tanari:InitiateKrakenKing()
	local king = Tanari:SpawnDungeonUnit("tanari_kraken_king", Vector(3072, -721), 4, 5, nil, Vector(-1, 0), true)
	king.itemLevel = 9
	EmitSoundOn("tidehunter_tide_pain_01", king)
	EmitSoundOn("tidehunter_tide_pain_01", king)
	king.jumpEnd = "kraken_king"
	Events:AdjustBossPower(king, 2, 5, false)
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", king:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	visionTracer:AddAbility("dummy_unit"):SetLevel(1)
	visionTracer:SetDayTimeVisionRange(1000)
	visionTracer:SetNightTimeVisionRange(1000)
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(king:GetAbsOrigin(), "Tanari.KingKrakenSpawn", king)
	end)
	if GameState:GetDifficultyFactor() > 1 then
		if TANARI_V2 then
			king:AddAbility("fire_temple_steadfast"):SetLevel(GameState:GetDifficultyFactor())
			king:AddAbility("king_kraken_aoe_ability"):SetLevel(GameState:GetDifficultyFactor())
		end
	end
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	-- Dungeons:LockCameraToUnitForPlayers(unit, duration, heroTable)
	-- for i = 1, #MAIN_HERO_TABLE, 1 do
	-- local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
	-- if playerID then
	-- gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 5.5})
	-- MAIN_HERO_TABLE[i]:Stop()
	-- PlayerResource:SetCameraTarget(playerID, king)
	-- end
	-- end
	local pfx = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_water_base.vpcf", PATTACH_CUSTOMORIGIN, king)
	ParticleManager:SetParticleControl(pfx, 0, king:GetAbsOrigin() + Vector(0, 0, 90))
	ParticleManager:SetParticleControl(pfx, 1, Vector(200, 2, 200))
	Timers:CreateTimer(5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	Timers:CreateTimer(1, function()
		local fv = (Vector(576, -640) - king:GetAbsOrigin()):Normalized()
		--print(fv)
		StartAnimation(king, {duration = 3, activity = ACT_DOTA_SPAWN, rate = 0.5})
		Timers:CreateTimer(0.15, function()
			ScreenShake(king:GetAbsOrigin(), 200, 0.4, 0.8, 9000, 0, true)
			EmitSoundOn("Hero_EarthShaker.EchoSlamSmall", king)
		end)
		Timers:CreateTimer(1.5, function()
			WallPhysics:Jump(king, fv, 44, 50, 30, 1)
			for i = 1, 45, 1 do
				Timers:CreateTimer(i * 0.05, function()
					if IsValidEntity(visionTracer) then
						visionTracer:SetAbsOrigin(king:GetAbsOrigin() + Vector(0, 0, 220))
					end
				end)
			end
		end)
	end)

	Timers:CreateTimer(4.7, function()
		king:SetAcquisitionRange(1600)
		UTIL_Remove(visionTracer)
		king.aggro = true
	end)

end

function Tanari:SpawnHeroTrail2()
	Tanari.HeroTrail2 = true
	Tanari:SpawnCragLizard(Vector(2816, -2240), Vector(-1, 0.4))
	Tanari:SpawnCragLizard(Vector(3106, -2496), Vector(1, 0.2))
	local mud = Tanari:SpawnDungeonUnit("big_mud", Vector(2880, -3776), 1, 2, nil, Vector(-0.2, 1), false)
	mud:SetAcquisitionRange(0)
	mud:AddAbility("dungeon_creep"):SetLevel(1)
	mud.itemLevel = 6
	mud.dominion = true
	Tanari:SpawnPoisonFlower(Vector(-1, -1), Vector(5632, -3072))
	Tanari:SpawnPoisonFlower(Vector(0, -1), Vector(5500, -2694))
	Tanari:SpawnPoisonFlower(Vector(-0.3, -1), Vector(6072, -2782))
	Tanari:SpawnPoisonFlower(Vector(-0.1, -1), Vector(6547, -2640))
	Tanari:SpawnPoisonFlower(Vector(-0.1, -1), Vector(6844, -2667))
	Tanari:SpawnPoisonFlower(Vector(-0.1, -1), Vector(7186, -2628))
	Tanari:SpawnPoisonFlower(Vector(-0.5, -0.5), Vector(7198, -3607))
	Tanari:SpawnPoisonFlower(Vector(-0.5, 0.5), Vector(6528, -3648))
	Tanari:SpawnMountainPassGuardian(Vector(8063, -2844), Vector(-1, 0))
	Tanari:SpawnPoisonFlower(Vector(0.5, 0.5), Vector(6363, -1731))
	Tanari:SpawnPoisonFlower(Vector(-0.5, -0.5), Vector(7168, -1152))
	Tanari:SpawnPoisonFlower(Vector(-1, -0.2), Vector(7616, -1344))

	Timers:CreateTimer(4, function()
		Tanari:SpawnWaterSlug(Vector(8128, -1408), Vector(-1, -1))
		Tanari:SpawnWaterSlug(Vector(8546, -618), Vector(1, 1))
		Tanari:SpawnWaterSlug(Vector(9114, -1284), Vector(1, 0))
		Tanari:SpawnWaterSlug(Vector(5766, -1284), Vector(-1, -0.2))

	end)
	Timers:CreateTimer(7, function()
		local position1 = Vector(4608, -1966)
		local position2 = Vector(7636, -1741)
		local position3 = Vector(9034, -1974)
		local position4 = Vector(4800, -576)
		local position5 = Vector(7958, 26)

		local slug = Tanari:SpawnWaterSlug(position5, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 4, 240, {position4, position5})
		local slug = Tanari:SpawnWaterSlug(position5, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 4, 240, {position4, position5})

		local slug = Tanari:SpawnWaterSlug(position4, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 4, 240, {position2, position3, position4})
		local slug = Tanari:SpawnWaterSlug(position4, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 4, 240, {position2, position3, position4})
		local slug = Tanari:SpawnThicketUrsa(position4, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 4, 240, {position2, position3, position4})

		local slug = Tanari:SpawnVoodooDoctor(position1, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 6, 240, {position2, position3, position1})
		local slug = Tanari:SpawnVoodooDoctor(position1, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 6, 240, {position2, position3, position1})
		local slug = Tanari:SpawnGrizzledWoodsman(position1, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 6, 240, {position2, position3, position1})

		local slug = Tanari:SpawnWaterSlug(position2, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 4, 240, {position3, position2})
		local slug = Tanari:SpawnWaterSlug(position2, RandomVector(1))
		Tanari:AddPatrolArguments(slug, 30, 4, 240, {position3, position2})
	end)
	Timers:CreateTimer(6, function()
		Tanari:SpawnMountainGiant(Vector(6592, -504), Vector(1, 1))
		Tanari:SpawnThicketUrsa(Vector(9856, -3200), Vector(-1, 1))
		Tanari:SpawnThicketUrsa(Vector(10240, -3072), Vector(-1, 0))
		Tanari:SpawnThicketUrsa(Vector(10176, -2688), Vector(-1, -0.3))
	end)
	Timers:CreateTimer(8, function()
		Tanari:SpawnCaveDwellerLeader(Vector(9600, -128), Vector(-1, -1))
		Tanari:SpawnCaveDweller(Vector(9570, -256), Vector(-1, 0))
		Tanari:SpawnCaveDweller(Vector(9298, -73), Vector(1, 0))
		Tanari:SpawnCaveDweller(Vector(9334, -275), Vector(1, 0.2))
		Tanari:SpawnCaveDweller(Vector(9425, -346), Vector(0, 1))
		Tanari:SpawnCaveDweller(Vector(9425, -346), Vector(0, 1))
		Tanari:SpawnCaveDweller(Vector(9553, -315), Vector(-1, 0.8))
		Tanari:SpawnCaveDweller(Vector(9471, -11), Vector(0, -1))
	end)
end

function Tanari:SpawnCaveDweller(position, fv)
	local rockGuy = Tanari:SpawnDungeonUnit("grizzly_cave_dweller", position, 0, 1, "shadowshaman_shad_pain_07", fv, false)
	rockGuy:SetRenderColor(90, 100, 155)
	rockGuy.dominion = true
end

function Tanari:SpawnCaveDwellerLeader(position, fv)
	local rockGuy = Tanari:SpawnDungeonUnit("grizzly_cave_dweller_leader", position, 2, 4, "shadowshaman_shad_pain_08", fv, false)
	rockGuy:SetRenderColor(90, 100, 155)
	Events:AdjustBossPower(rockGuy, 1, 1, false)
	rockGuy.dominion = true
end

function Tanari:SpawnCragLizard(position, fv)
	local troll = Tanari:SpawnDungeonUnit("tanari_crag_lizard", position, 0, 1, "Tanari.CragLizardAggro", fv, false)
	troll.itemLevel = 5
	troll.dominion = true
end

function Tanari:SpawnMountainBullies()
	local baseVector = Vector(4516, -2304)
	for i = 1, 30, 1 do
		Timers:CreateTimer(i * 0.35, function()
			local xOffset = RandomInt(0, 1000)
			local bully = Tanari:SpawnMountainBully(baseVector + Vector(xOffset, 0), Vector(0, -1))
			bully.jumpEnd = "basic_dust"
			WallPhysics:Jump(bully, Vector(0, -1), 16 + RandomInt(7, 12), 15, 18, 1.5)
			StartAnimation(bully, {duration = 1.3, activity = ACT_DOTA_OVERRIDE_ABILITY_2, rate = 1})
			if i % 2 == 0 then
				EmitSoundOn("earthshaker_erth_pain_0"..RandomInt(1, 9), bully)
			end
		end)
	end
end

function Tanari:SpawnMountainBully(position, fv)
	local bully = Tanari:SpawnDungeonUnit("tanari_mountain_bully", position, 0, 1, nil, fv, true)
	bully.itemLevel = 7
	bully.dominion = true
	return bully
end

function Tanari:SpawnPoisonFlower(fv, position)
	local orchid = Tanari:SpawnDungeonUnit("tanari_poison_flower", position, 1, 2, nil, fv, false)
	orchid.itemLevel = 6
	orchid:SetRenderColor(190, 255, 180)
	orchid:SetAbsOrigin(orchid:GetAbsOrigin() - Vector(0, 0, 85))
	orchid.dominion = true
	return orchid
end

function Tanari:SpawnPoisonFlowerNoLoot(fv, position)
	local orchid = Tanari:SpawnDungeonUnit("tanari_poison_flower", position, 0, 0, nil, fv, false)
	orchid.itemLevel = 6
	orchid:SetRenderColor(190, 255, 180)
	orchid:SetAbsOrigin(orchid:GetAbsOrigin() - Vector(0, 0, 85))
	orchid.dominion = true
	return orchid
end

function Tanari:SpawnMountainPassGuardian(position, fv)
	local passGuardian = Tanari:SpawnDungeonUnit("tanari_mountain_pass_guardian", position, 3, 4, "elder_titan_elder_attack_07", fv, false)
	passGuardian.itemLevel = 10
	Events:AdjustBossPower(passGuardian, 3, 3, false)

end

function Tanari:SpawnWaterSlug(position, fv)
	local slug = Tanari:SpawnDungeonUnit("tanari_river_slug", position, 0, 2, "slardar_slar_anger_04", fv, false)
	slug.itemLevel = 7
	slug.dominion = true
	return slug
end

function Tanari:SpawnMountainGiant(position, fv)
	local giant = Tanari:SpawnDungeonUnit("tanari_mountain_giant", position, 2, 3, "earth_spirit_earthspi_pain_11", fv, false)
	giant:SetAbsOrigin(giant:GetAbsOrigin() - Vector(0, 0, 140))
	giant:SetRenderColor(180, 255, 160)
	giant.itemLevel = 13
	giant.dominion = true
	Events:AdjustBossPower(giant, 3, 3, false)
end

function Tanari:SpawnMountainTroggs()
	for i = 1, 18, 1 do
		Timers:CreateTimer(0.25 * i, function()
			local trogg = Tanari:SpawnMountainTrogg(Vector(4222, 0) + RandomVector(140), Vector(1, -1))
			trogg:MoveToPositionAggressive(Vector(6656, -1472))
		end)
	end
end

function Tanari:SpawnMountainTrogg(position, fv)
	local trogg = Tanari:SpawnDungeonUnit("tanari_mountain_trogg", position, 0, 1, nil, fv, true)
	trogg.itemLevel = 13
	trogg.dominion = true
	return trogg
end

function Tanari:SpawnMountainNomad(position, fv)
	local nomad = Tanari:SpawnDungeonUnit("tanari_reclusive_mountain_nomad", position, 3, 5, "earth_spirit_earthspi_pain_04", fv, false)
	nomad.itemLevel = 11
	Events:AdjustBossPower(nomad, 3, 3, false)
end

function Tanari:SpawnMountainSpecter(position, fv)
	local nomad = Tanari:SpawnDungeonUnit("tanari_mountain_specter", position, 3, 5, nil, fv, true)
	nomad.itemLevel = 13
	Events:AdjustBossPower(nomad, 20, 3, false)
	CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", nomad, 1)
	EmitSoundOn("Tanari.RemnantAppear", nomad)
	nomad:SetHealth(nomad:GetMaxHealth() * 0.25)
	return nomad
end

function Tanari:SpawnMountainSpecterCrow(position, fv)
	local nomad = Tanari:SpawnDungeonUnit("tanari_mountain_specter_crow_form", position, 3, 5, nil, fv, true)
	nomad.itemLevel = 25
	Events:AdjustBossPower(nomad, 20, 3, false)
	CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", nomad, 2)
	EmitSoundOn("Tanari.RemnantAppear", nomad)
	EmitGlobalSound("Tanari.MountainSpecterCrowIntro")

	nomad.targetRadius = 700
	nomad.minRadius = 0
	nomad.targetAbilityCD = 1
	nomad.targetFindOrder = FIND_ANY_ORDER
	return nomad
end

function Tanari:SpawnSeaHydra()
	local beast = Tanari:SpawnEnemyUnit("tanari_island_hydra", Vector(1728, -576), RandomVector(1))
	beast:SetRenderColor(170, 170, 255)
	beast:SetAbsOrigin(beast:GetAbsOrigin() - Vector(0, 0, 400))
	beast.offsetForward = Vector(-1, 0)
	Events:AdjustBossPower(beast, 2, 5, false)
	beast.itemLevel = 15
	local ability = beast:FindAbilityByName("tanari_hydra_ai")
	ability:ApplyDataDrivenModifier(beast, beast, "modifier_tanari_hydra_submerged", {})
end

function Tanari:SpawnBongoFrog(position, fv)
	local beast = Tanari:SpawnEnemyUnit("tanari_bongo_frog", position, fv)
	beast.itemLevel = 15
end

function Tanari:SpawnAmbusher(position, fv)
	local ambusher = Tanari:SpawnDungeonUnit("tanari_tribal_ambusher", position, 1, 2, "Tanari.TrabalAmbusher.Aggro", fv, true)
	ambusher.itemLevel = 15
	ambusher.dominion = true
	return ambusher
end

function Tanari:SpawnWindTempleKeyHolder(position, fv)
	local beast = Tanari:SpawnEnemyUnit("tanari_wind_temple_keyholder", position, fv)
	beast.itemLevel = 24
	return beast
end

function Tanari:BeginSideTempleOpenSequence(allies)
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	local beaconPointA = CreateUnitByName("npc_flying_dummy_vision", Vector(3818, 409, 1060), false, nil, nil, DOTA_TEAM_GOODGUYS)
	local visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(3818, 409, 1060), false, nil, nil, DOTA_TEAM_GOODGUYS)
	visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin() + Vector(0, 0, 120))
	beaconPointA:SetAbsOrigin(beaconPointA:GetAbsOrigin() + Vector(0, 0, 120))
	local eyePoint = Vector(1800, 3112, 472)
	visionTracer:FindAbilityByName("dummy_unit"):SetLevel(1)
	beaconPointA:FindAbilityByName("dummy_unit"):SetLevel(1)
	visionTracer:AddNewModifier(visionTracer, nil, 'modifier_movespeed_cap', nil)
	Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, visionTracer, "modifier_ms_thinker", {})
	visionTracer:SetNightTimeVisionRange(1000)
	visionTracer:SetDayTimeVisionRange(1000)
	visionTracer:SetBaseMoveSpeed(900)
	Timers:CreateTimer(1.0, function()

		for i = 1, #allies, 1 do
			local playerID = allies[i]:GetPlayerID()
			if playerID then
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 12})
				allies[i]:Stop()
				PlayerResource:SetCameraTarget(playerID, visionTracer)
			end
		end
	end)
	Timers:CreateTimer(1.2, function()
		local movementVector = eyePoint - visionTracer:GetAbsOrigin()
		local movementPerTick = movementVector / 90
		for i = 1, 90, 1 do
			Timers:CreateTimer(0.03 * i, function()
				visionTracer:SetAbsOrigin(visionTracer:GetAbsOrigin() + movementPerTick)
				if i % 15 == 0 then
					EmitSoundOn("Tanari.UnibiEvent", visionTracer)
				end
			end)
		end
		-- visionTracer:MoveToPosition(eyePoint)
	end)

	Timers:CreateTimer(1.2, function()
		local particleName = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, beaconPointA)
		ParticleManager:SetParticleControlEnt(pfx, 0, beaconPointA, PATTACH_POINT_FOLLOW, "attach_hitloc", beaconPointA:GetAbsOrigin() + Vector(0, 0, 90), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, visionTracer, PATTACH_POINT_FOLLOW, "attach_hitloc", visionTracer:GetAbsOrigin() + Vector(0, 0, 90), true)
	end)
	Timers:CreateTimer(5.7, function()
		local eyeEnt = Entities:FindByNameNearest("SideTempleEye", Vector(1805, 3139, 128), 400)
		UTIL_Remove(eyeEnt)
		local newEye = CreateUnitByName("npc_dummy_unit", Vector(1805, 3139), false, nil, nil, DOTA_TEAM_GOODGUYS)
		newEye:FindAbilityByName("dummy_unit"):SetLevel(1)
		newEye:SetModel("models/items/wards/ocula/ocula.vmdl")
		newEye:SetOriginalModel("models/items/wards/ocula/ocula.vmdl")
		newEye:SetModelScale(3)
		newEye:SetForwardVector(Vector(0, -1))
		StartAnimation(newEye, {duration = 1000, activity = ACT_DOTA_IDLE, rate = 0.8})
		newEye:SetRenderColor(100, 100, 100)
		CustomAbilities:QuickAttachParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end_mana_flash.vpcf", newEye, 1)
		EmitSoundOn("Tanari.Hint", newEye)
		for i = 1, 31, 1 do
			Timers:CreateTimer(i * 0.03, function()
				newEye:SetRenderColor(100 + i * 5, 100 + i * 5, 100 + i * 5)
			end)
		end
		Timers:CreateTimer(1.4, function()
			local visionTracer2 = CreateUnitByName("npc_flying_dummy_vision", visionTracer:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
			visionTracer2:FindAbilityByName("dummy_unit"):SetLevel(1)
			visionTracer2:AddNewModifier(visionTracer2, nil, 'modifier_movespeed_cap', nil)
			Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, visionTracer2, "modifier_ms_thinker", {})
			visionTracer2:SetNightTimeVisionRange(1000)
			visionTracer2:SetDayTimeVisionRange(1000)
			visionTracer2:SetBaseMoveSpeed(900)
			-- for i = 1, #MAIN_HERO_TABLE, 1 do
			-- local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			-- if playerID then
			-- PlayerResource:SetCameraTarget(playerID, nil)
			-- Timers:CreateTimer(0.1, function()
			-- PlayerResource:SetCameraTarget(playerID, visionTracer2)
			-- end)
			-- end
			-- end
			Dungeons:LockCameraToUnitForPlayers(visionTracer2, 5.2, allies)
			local wallPoint = Vector(2548, 2696, 192)
			local movementVector = (wallPoint - visionTracer2:GetAbsOrigin()) / 25
			for j = 1, 25, 1 do
				Timers:CreateTimer(j * 0.03, function()
					visionTracer2:SetAbsOrigin(visionTracer2:GetAbsOrigin() + movementVector)
				end)
			end
			Timers:CreateTimer(3.9, function()
				EmitGlobalSound("Tanari.HarpMystery")
			end)
			Timers:CreateTimer(5.2, function()
				Dungeons:UnlockCamerasAndReturnToHero()
				UTIL_Remove(visionTracer2)
			end)
		end)
	end)

	--GOOD
	Timers:CreateTimer(7.5, function()
		Tanari:WindTempleKeyWalls(true)
	end)
	Timers:CreateTimer(10, function()
		Tanari:SpawnSeaHydra()
	end)
end

function Tanari:WindTempleKeyWalls(bDown)
	local movementZ = 4.5
	if bDown then
		movementZ = -4.5
		UTIL_Remove(Tanari.springTempleBlock1)
		UTIL_Remove(Tanari.springTempleBlock2)
		UTIL_Remove(Tanari.springTempleBlock3)
		UTIL_Remove(Tanari.springTempleBlock4)
		UTIL_Remove(Tanari.springTempleBlock5)
	end
	local walls = Entities:FindAllByNameWithin("SideTempleWall", Vector(2549, 2836, 223), 900)
	Timers:CreateTimer(0.2, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
	end)
	for j = 1, #walls, 1 do
		for i = 1, 64, 1 do
			Timers:CreateTimer(i * 0.03, function()
				if i % 2 == 0 then
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(-1, 0, movementZ))
				else
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(1, 0, movementZ))
				end
				if j == 1 then
					ScreenShake(walls[1]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
				end

			end)
		end
	end

end

function Tanari:SpawnLakeCheep(position, fv)
	local animationTable = {ACT_DOTA_SLARK_POUNCE, ACT_DOTA_CAST_ABILITY_1}
	local fish = Tanari:SpawnDungeonUnit("grizzly_bridge_fish", position, 0, 2, nil, fv, true)
	EmitSoundOn("Tanari.CheepJump", fish)
	local particleName = "particles/units/heroes/hero_slark/slark_pounce_splash.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, fish)
	for j = 0, 4, 1 do
		ParticleManager:SetParticleControl(pfx, j, fish:GetAbsOrigin())
	end
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	fish.dominion = true
	StartAnimation(fish, {duration = 0.8, activity = animationTable[RandomInt(1, 2)], rate = 1})
	WallPhysics:Jump(fish, fv, 16, 20, 24, 1)
	fish.itemLevel = 10
end

--TANARI EXPANSION

function Tanari:SpawnClamSpawner(position, fv, summonCenter)
	local stone = Tanari:SpawnDungeonUnit("tanari_clam_spawner", position, 2, 4, nil, fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 24
	stone.summonCenter = summonCenter
	return stone
end

function Tanari:SpawnClamSpawnerUnit(position, fv, itemRoll, bAggro)
	local stone = Tanari:SpawnDungeonUnit("tanari_clam_fish", position, itemRoll, itemRoll, nil, fv, bAggro)
	-- stone:SetRenderColor(233,100,100)
	stone.itemLevel = 17
	stone.dominion = true
	return stone
end

function Tanari:SpawnClamSpawnerUnit2(position, fv, itemRoll, bAggro)
	local stone = Tanari:SpawnDungeonUnit("swamp_razorfish", position, itemRoll, itemRoll, nil, fv, bAggro)
	-- stone:SetRenderColor(233,100,100)
	stone.itemLevel = 37
	stone.dominion = true
	return stone
end

function Tanari:SpawnVoodooDoctor(position, fv)
	local rockGuy = Tanari:SpawnDungeonUnit("tanari_voodoo_shaman", position, 1, 3, "Tanari.VoodooAggro", fv, false)
	Events:AdjustBossPower(rockGuy, 1, 1, false)
	rockGuy.dominion = true
	rockGuy.targetRadius = 1400
	rockGuy.minRadius = 0
	rockGuy.targetAbilityCD = 1
	rockGuy.targetFindOrder = FIND_ANY_ORDER
	return rockGuy
end

function Tanari:SpawnVoodooAlchemist(position, fv)
	local rockGuy = Tanari:SpawnDungeonUnit("tanari_alchemist", position, 1, 3, "Tanari.VoodooAlchemistAggro", fv, false)
	Events:AdjustBossPower(rockGuy, 1, 1, false)
	rockGuy.dominion = true
	rockGuy.targetRadius = 1400
	rockGuy.minRadius = 0
	rockGuy.targetAbilityCD = 1
	rockGuy.targetFindOrder = FIND_ANY_ORDER
	return rockGuy
end

function Tanari:SpawnGrizzledWoodsman(position, fv)
	local tribal_tank = Tanari:SpawnDungeonUnit("grizzled_woodsman", position, 1, 3, "tusk_tusk_anger_01", fv, false, nil)
	local properties = {
		pitch = -30,
		yaw = 10,
		roll = 90,
		XPos = -20,
		YPos = 10,
		ZPos = -170,
	}
	Attachments:AttachProp(tribal_tank, "attach_head", "models/items/witchdoctor/tribal_mask.vmdl", 1.1, properties)
	Events:AdjustBossPower(tribal_tank, 3, 3, false)
	tribal_tank:SetRenderColor(150, 150, 255)

	return tribal_tank
end

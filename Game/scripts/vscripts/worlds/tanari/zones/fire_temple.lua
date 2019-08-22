function Tanari:InitializeFireTemple()
	Tanari:FireTempleWalls()
	Tanari.FireTemple = {}
	Tanari.FireTemple.Initialized = true
	Dungeons.respawnPoint = Vector(-1367, -9483)
	Timers:CreateTimer(3, function()
		Tanari:FireTempleInitMobs()
	end)
	Timers:CreateTimer(7, function()
		EmitGlobalSound("Tanari.TempleStart")
	end)
	Timers:CreateTimer(15, function()
		if not Tanari.FireTemple.BossBattleBegun then
			EmitSoundOnLocationWithCaster(Vector(1344, -7872, 200), "Tanari.FireTemple.Music", Events.GameMaster)
			Timers:CreateTimer(112, function()
				local heroLocTable = {}
				for i = 1, #MAIN_HERO_TABLE, 1 do
					local heroPos = MAIN_HERO_TABLE[i]:GetAbsOrigin()
					if heroPos.x > -1266 and heroPos.y < -4928 then
						table.insert(heroLocTable, heroPos)
					end
				end
				if #heroLocTable > 0 then
					local totalVector = Vector(0, 0, 0)
					for j = 1, #heroLocTable, 1 do
						totalVector = totalVector + heroLocTable[j]
					end
					local avgVector = totalVector / #heroLocTable
					if not Tanari.FireTemple.BossBattleBegun then
						EmitSoundOnLocationWithCaster(avgVector, "Tanari.FireTemple.Music", Events.GameMaster)
					end
				end
				EmitSoundOnLocationWithCaster(Vector(-13825, -14515), "Tanari.FireTemple.Music", Events.GameMaster)
				EmitSoundOnLocationWithCaster(Vector(-14184, -8668), "Tanari.FireTemple.Music", Events.GameMaster)
				if not Tanari.FireTemple.BossBattleBegun then
					return 112
				end
			end)
		end
	end)

end

function Tanari:FireTempleWalls()
	local movementZ = -4.00
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-563, -9344, 420), 1000, 900, false)
	Timers:CreateTimer(5, function()
		local walls = Entities:FindAllByNameWithin("FireTempleEntranceWall", Vector(-563, -9344, 220), 600)
		Timers:CreateTimer(0.1, function()
			EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
		end)
		for i = 1, 90, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i * 0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, movementZ))
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin() + Vector(0, 0, movementZ))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 200, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end)
	Timers:CreateTimer(5.3, function()
		local blockers = Entities:FindAllByNameWithin("FireTempleEntranceBlocker", Vector(-768, -9472, -25), 1100)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particle1, 0, Vector(-794, -10074, 925))
	local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particle2, 0, Vector(-929, -9004, 904))
end

function Tanari:SpawnBlackguard(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_blackguard", position, 2, 4, "Tanari.FireTemple.BlackguardAggro", fv, false)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 85
	ancient.patrolSlow = 35
	ancient.phaseIntervals = 3
	ancient.patrolPointRandom = 100
	ancient:SetRenderColor(80, 80, 80)
	ancient.dominion = true
	return ancient
end

function Tanari:SpawnBlackguardCultist(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("blackguard_cultist", position, 2, 4, "Tanari.FireTemple.BlackguardAggro", fv, false)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 85
	ancient.patrolSlow = 35
	ancient.phaseIntervals = 5
	ancient.patrolPointRandom = 100
	ancient:SetRenderColor(80, 80, 80)
	ancient.dominion = true
	return ancient

end

function Tanari:FireTempleInitMobs()
	for i = 1, 2, 1 do
		local unit = Tanari:SpawnBlackguard(Vector(320, -7360), Vector(1, 0))
		unit.patrolPositionTable = {Vector(256, -8704), Vector(320, -7360)}
		unit:AddAbility("monster_patrol"):SetLevel(1)
	end
	Tanari:SpawnBlackguard(Vector(501, -8704), Vector(-1, -1))
	Tanari:SpawnBlackguard(Vector(647, -9216), Vector(-1, -0.1))

	Tanari:SpawnBlackguardCultist(Vector(126, -9938), Vector(0, 1))
	Tanari:SpawnBlackguardCultist(Vector(704, -9765), Vector(-1, 0.3))
	Timers:CreateTimer(3, function()
		for i = 1, 2, 1 do
			local unit = Tanari:SpawnBlackguardCultist(Vector(512, -6400), Vector(1, 0))
			unit.patrolPositionTable = {Vector(512, -9472), Vector(512, -6400)}
			unit:AddAbility("monster_patrol"):SetLevel(1)
		end
	end)
	Timers:CreateTimer(30, function()
		if not Tanari.FireTemple.BossBattleBegun then
			Tanari:CreateLavaBlast(Vector(1664, -7040))
			return 30
		end
	end)
	Timers:CreateTimer(1, function()
		local particleName = "particles/dire_fx/fire_ambience.vpcf"
		local vectorTable = {Vector(969, -10094, 260), Vector(929, -9241, 260), Vector(667, -8476, 256), Vector(668, -7525, 223), Vector(1054, -6677, 329)}
		for i = 1, #vectorTable, 1 do
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(particle1, 0, vectorTable[i] + Vector(0, 0, 400))
		end
	end)
end

function Tanari:SpawnVolcanoDragon(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_volcano_dragon", position, 0, 2, "Tanari.BlackDrake.Aggro", fv, false)
	stone:SetRenderColor(255, 0, 0)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 84
	stone.dominion = true
	return stone
end

function Tanari:SpawnBlackguardDoombringer(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_blackguard_doombringer", position, 2, 3, "Tanari.FireTemple.BlackguardDoombringerAggro", fv, false)
	stone:SetRenderColor(255, 200, 200)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 87
	stone.dominion = true
	return stone
end

function Tanari:FireTempleSpawnFirstLavaArea()
	Tanari.FireTemple.flameDummy = CreateUnitByName("npc_flying_dummy_vision", Vector(768, -6400), false, nil, nil, DOTA_TEAM_NEUTRALS)
	local flamebousAbility = Tanari.FireTemple.flameDummy:AddAbility("fire_temple_fire_dummy")
	Tanari.FireTemple.flameDummy.phase = 0
	flamebousAbility:SetLevel(1)
	flamebousAbility:ApplyDataDrivenModifier(Tanari.FireTemple.flameDummy, Tanari.FireTemple.flameDummy, "modifier_flamebous_fly_height", {})
	-- local zDifference = math.max(0, 700- GetGroundHeight(Tanari.FireTemple.flameDummy:GetAbsOrigin(), Tanari.FireTemple.flameDummy))
	Tanari.FireTemple.flameDummy:SetModifierStackCount("modifier_flamebous_fly_height", Tanari.FireTemple.flameDummy, 400)
	Tanari.FireTemple.flameDummy.zDifference = 400
	Tanari.FireTemple.flameDummy.targetZ = 400

	local patrolFairyTable = {}
	local fairy = Tanari:SpawnVolcanoDragon(Vector(1999, -6208), RandomVector(1))
	fairy.patrolPositionTable = {Vector(2880, -7008), Vector(1999, -6208)}
	table.insert(patrolFairyTable, fairy)

	fairy = Tanari:SpawnVolcanoDragon(Vector(1950, -7306), RandomVector(1))
	fairy.patrolPositionTable = {Vector(2624, -6592), Vector(1950, -7306)}
	table.insert(patrolFairyTable, fairy)

	fairy = Tanari:SpawnVolcanoDragon(Vector(1408, -7808), RandomVector(1))
	fairy.patrolPositionTable = {Vector(2283, -7220), Vector(1408, -7808)}
	table.insert(patrolFairyTable, fairy)
	Timers:CreateTimer(3, function()
		for j = 1, 4, 1 do
			local baseVector = Vector(1663, -8917)
			local randomX = RandomInt(1, 1400)
			local randomY = RandomInt(1, 1200)
			local patrolPoint1 = baseVector + Vector(randomX, randomY)
			randomX = RandomInt(1, 1400)
			randomY = RandomInt(1, 1200)
			local patrolPoint2 = baseVector + Vector(randomX, randomY)
			fairy = Tanari:SpawnVolcanoDragon(patrolPoint1, Vector(0, 1))
			fairy.patrolPositionTable = {patrolPoint2, patrolPoint1}
			table.insert(patrolFairyTable, fairy)
		end

		for i = 1, #patrolFairyTable, 1 do
			patrolFairyTable[i].patrolSlow = 45
			patrolFairyTable[i].phaseIntervals = 4
			patrolFairyTable[i].patrolPointRandom = 320

			patrolFairyTable[i]:AddAbility("monster_patrol"):SetLevel(1)
		end
	end)
	Tanari:SpawnBlackguardDoombringer(Vector(1985, -6532), Vector(-1, 0))
	Timers:CreateTimer(1, function()
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(1985, -6532), 500, 10, false)
	end)
	Timers:CreateTimer(4, function()
		Tanari:SpawnBlackguardDoombringer(Vector(1792, -7488), Vector(1, -0.3))
	end)
	Timers:CreateTimer(3, function()
		Tanari:SpawnLavaPrisoner(Vector(-1, 0), Vector(3172, -7395))
		Tanari:SpawnLavaPrisoner(Vector(0, 1), Vector(2004, -8105))
	end)
	-- Timers:CreateTimer(3.5, function()
	-- Tanari:SpawnTerrasicStoneGiant(Vector(0,-1), Vector(2523, -7309))
	-- end)
	Timers:CreateTimer(8, function()
		Tanari:SpawnMoltenWarKnight(Vector(-1, 0.3), Vector(2560, -8950))
	end)
end

function Tanari:SpawnLavaPrisoner(fv, position)
	local beast = Tanari:SpawnEnemyUnit("fire_temple_burning_prisoner", position, fv)
	beast:SetRenderColor(255, 170, 170)
	beast:SetAbsOrigin(beast:GetAbsOrigin() - Vector(0, 0, 700))
	beast.itemLevel = 88
	local ability = beast:FindAbilityByName("fire_temple_lava_prisoner_ai")
	ability:ApplyDataDrivenModifier(beast, beast, "modifier_lava_prisoner_submerged", {})

end

function Tanari:SpawnMoltenWarKnight(fv, position)
	local beast = Tanari:SpawnDungeonUnit("fire_temple_molten_war_knight", position, 3, 5, "Tanari.FireTemple.KnightAggro", fv, false)
	Events:AdjustBossPower(beast, 5, 5)
	beast:SetRenderColor(255, 170, 170)
	beast.itemLevel = 95
	beast.targetRadius = 900
	beast.minRadius = 100
	beast.targetAbilityCD = 1
	beast.targetFindOrder = FIND_FARTHEST
	beast.dominion = true
	return beast
end

function Tanari:Room1Run()
	Timers:CreateTimer(1, function()
		Tanari:LowerWaterTempleWall(-4, "FireTempleWall1", Vector(1725, -9625, 189), "FireTempleBlocker1", Vector(1724, -9664, 18), 800, true, false)
	end)
	local rockFallTable = {Vector(2048, -9216, 400), Vector(2048, -8064, 400), Vector(2112, -7104, 400), Vector(3200, -6976, 400), Vector(2048, -9216, 400), Vector(2048, -8064, 400), Vector(2112, -7104, 400), Vector(3200, -6976, 400), Vector(2048, -9216, 400), Vector(2048, -8064, 400), Vector(2112, -7104, 400), Vector(3200, -6976, 400)}
	for k = 1, #rockFallTable, 1 do
		Timers:CreateTimer(4 * k, function()
			ScreenShake(rockFallTable[k], 500, 2, 5, 9000, 0, true)
			local rockfallParticle = "particles/dire_fx/dire_lava_falling_rocks.vpcf"
			local position = rockFallTable[k]
			local pfx = ParticleManager:CreateParticle(rockfallParticle, PATTACH_CUSTOMORIGIN, Events.GameMaster)
			ParticleManager:SetParticleControl(pfx, 0, position)
			Timers:CreateTimer(12, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end)
	end
	EmitSoundOnLocationWithCaster(Vector(2240, -7808), "Tanari.LightRockFall", Events.GameMaster)
	local blackguardTable = {}
	local black1 = Tanari:SpawnBlackguardDoombringer(Vector(710, -5440), Vector(0, -1))
	table.insert(blackguardTable, black1)
	black1 = Tanari:SpawnBlackguard(Vector(810, -5440), Vector(0, -1))
	table.insert(blackguardTable, black1)
	black1 = Tanari:SpawnBlackguard(Vector(910, -5440), Vector(0, -1))
	table.insert(blackguardTable, black1)
	black1 = Tanari:SpawnBlackguardCultist(Vector(1010, -5440), Vector(0, -1))
	table.insert(blackguardTable, black1)
	black1 = Tanari:SpawnBlackguardCultist(Vector(1110, -5440), Vector(0, -1))
	table.insert(blackguardTable, black1)
	Timers:CreateTimer(0.2, function()
		for i = 1, #blackguardTable, 1 do
			WallPhysics:Jump(blackguardTable[i], Vector(0, -1), RandomInt(12, 14), RandomInt(12, 16), 18, 1)
		end
	end)
	Timers:CreateTimer(3, function()
		for i = 1, #blackguardTable, 1 do
			blackguardTable[i]:MoveToPositionAggressive(Vector(2688, -9024))
		end
	end)

	Timers:CreateTimer(1, function()
		Tanari:SpawnFireTempleRoom1Part2()
	end)
end

function Tanari:SpawnShadowOfDavion(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_lost_shadow_of_davion", position, 2, 4, "Tanari.FireTemple.DavionAggro", fv, false)
	stone:SetRenderColor(20, 20, 20)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 90
	stone.dominion = true
	return stone
end

function Tanari:SpawnPassageSkeleton(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_passage_skeleton", position, 0, 1, "Tanari.FireTemple.PassageSkeletonAggro", fv, false)
	stone:SetRenderColor(180, 0, 0)
	stone.itemLevel = 78
	stone.dominion = true
	return stone
end

function Tanari:SpawnFireTempleRoom1Part2()
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local vectorTable = {Vector(1177, -9433, 256), Vector(1181, -9876, 265), Vector(2111, -9537, 151), Vector(2429, -9547, 149), Vector(2746, -9547, 147), Vector(3098, -9928, 129), Vector(3098, -10374, 129), Vector(2980, -11649, 166), Vector(1822, -11441.8, 192), Vector(2101, -13379, 576), Vector(1951, -15744, 414), Vector(738, -13618, 384), Vector(484, -13880, 393)}
	for i = 1, #vectorTable, 1 do
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, vectorTable[i] + Vector(0, 0, 400))
	end
	Tanari:SpawnShadowOfDavion(Vector(2816, -9664), Vector(-1, 0))

	Timers:CreateTimer(5, function()
		local baseVector = Vector(1664, -11776)
		for i = 1, 18, 1 do
			local randomX = RandomInt(1, 1200)
			local randomY = RandomInt(1, 320)
			Tanari:SpawnPassageSkeleton(baseVector + Vector(randomX, randomY), RandomVector(1))
		end
	end)
	Timers:CreateTimer(9, function()
		Tanari:SpawnRelicHunter(Vector(3008, -10752), Vector(0, 1))
		Tanari:SpawnRelicHunter(Vector(1008, -11840), Vector(1, 0.3))
		Tanari:SpawnRelicHunter(Vector(1536, -12032), Vector(0.5, 1))
	end)
end

function Tanari:SpawnBRDRoom()
	Tanari:SpawnSecretFanatic(Vector(1408, -13888), Vector(-1, 0))
	Tanari:SpawnSecretFanatic(Vector(2331, -14302), Vector(-1, -1))
	Tanari:SpawnSecretFanatic(Vector(1344, -14784), Vector(1, 0))
end

function Tanari:SpawnRelicHunter(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_relic_seeker", position, 2, 4, "Tanari.FireTemple.RelicSeekerAggro", fv, false)
	stone:SetRenderColor(255, 120, 100)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 88
	stone.dominion = true
	return stone
end

function Tanari:SpawnSecretFanatic(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_secret_fanatic", position, 2, 4, "Tanari.FireTemple.SecretFanaticAggro", fv, false)
	stone:SetRenderColor(255, 100, 90)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 91
	stone.dominion = true
	return stone
end

function Tanari:Steadfast(damage, victim)
	local thresh = 0.05
	if GameState:GetDifficultyFactor() == 2 then
		thresh = 0.04
	elseif GameState:GetDifficultyFactor() == 3 then
		thresh = 0.03
	end
	if damage > victim:GetMaxHealth() * thresh then
		damage = victim:GetMaxHealth() * thresh
	end
	return damage
end

function Tanari:InitiateYojimboSequence()
	if not Tanari.FireTemple then
		Tanari.FireTemple = {}
	end
	local particlePosition = Vector(2469, -14965, 640)
	local pfx = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_fire_captured.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 10, particlePosition)
	ParticleManager:SetParticleControl(pfx, 0, particlePosition)
	ParticleManager:SetParticleControl(pfx, 1, particlePosition)
	ParticleManager:SetParticleControl(pfx, 2, particlePosition)
	ParticleManager:SetParticleControl(pfx, 3, particlePosition)
	Timers:CreateTimer(0.2, function()
		EmitGlobalSound("Tanari.FireTemple.ChineseGong")
	end)
	Timers:CreateTimer(1, function()
		Tanari.FireTemple.yojimboDummy = CreateUnitByName("npc_flying_dummy_vision", Vector(2876, -14966, 500), false, nil, nil, DOTA_TEAM_NEUTRALS)
		local flamebousAbility = Tanari.FireTemple.yojimboDummy:AddAbility("fire_temple_statue_light_dummy")
		flamebousAbility:SetLevel(1)
		

		for i = 1, 60, 1 do
			Timers:CreateTimer(i * 0.03, function()
				Tanari.FireTemple.yojimboDummy:SetAbsOrigin(Tanari.FireTemple.yojimboDummy:GetAbsOrigin() + Vector(0, 0, 4))
			end)
		end
		Timers:CreateTimer(2.4, function()
			local vectorTable = {Vector(1475, -13695, 278), Vector(2408, -14089, 278), Vector(2468, -15570, 278), Vector(1523, -15396, 278), Vector(930, -14748, 278), Vector(2879, -15099, 285)}
			local fvTable = {Vector(0, -1), Vector(-1, -0.2), Vector(0.3, 1), Vector(1, -0.5), Vector(1, 0), Vector(-1, 0)}
			for i = 1, #vectorTable, 1 do
				Timers:CreateTimer(12 * (i - 1), function()
					local bBoss = false
					if i == #vectorTable then
						bBoss = true
					end
					Tanari:StatueActivation(vectorTable[i], fvTable[i], bBoss)
				end)
			end
		end)
	end)
end

function Tanari:StatueActivation(position, fv, bBoss)
	EmitSoundOn("Tanari.FireTemple.StatueStaffGreeting", Tanari.FireTemple.yojimboDummy)
	local walls = Entities:FindAllByNameWithin("YojimboStatue", position, 600)
	if #walls > 0 then
		-- Timers:CreateTimer(0.1, function()
		-- EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.WallOpen", Events.GameMaster)
		-- end)
		for i = 1, 30, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i * 0.3, function()
					walls[j]:SetRenderColor(0, i * 8, i * 8)
					if j == 1 then
						Tanari:CreateCollectionBeam(Tanari.FireTemple.yojimboDummy:GetAbsOrigin() + Vector(0, 0, 100), position + Vector(0, 0, 530))
					end
				end)
			end
		end
		Timers:CreateTimer(8.7, function()
			if bBoss then
				EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.FireTemple.YojimboBossEmerge", Events.GameMaster)
			else
				EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Tanari.FireTemple.StatueStaffEmerge", Events.GameMaster)
			end
		end)
		Timers:CreateTimer(10, function()
			ScreenShake(walls[1]:GetAbsOrigin(), 500, 3, 3, 9000, 0, true)
			if bBoss then
				Tanari:SpawnYojimboBoss(position, fv)
				EmitGlobalSound("Tanari.FireTemple.YojimboBossAggro")
				UTIL_Remove(Tanari.FireTemple.yojimboDummy)
			else
				EmitGlobalSound("Tanari.FireTemple.YojimboAggro")
				Tanari:SpawnYojimboDisciple(position, fv)
			end
			for j = 1, #walls, 1 do
				UTIL_Remove(walls[j])
			end
		end)
	end
end

function Tanari:SpawnYojimboDisciple(position, fv)
	local stone = Tanari:SpawnDungeonUnit("disciple_of_yojimbo", position, 2, 4, nil, fv, true)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone:SetRenderColor(0, 255, 255)
	stone.itemLevel = 99
	CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", stone, 3)
	EmitSoundOn("Tanari.FireTemple.YojimboDiscipleShatter", stone)
	stone.dominion = true
	return stone
end

function Tanari:SpawnYojimboBoss(position, fv)
	local stone = Tanari:SpawnDungeonUnit("yojimbo_boss", position, 3, 5, nil, fv, true)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone:SetRenderColor(0, 255, 255)
	stone.itemLevel = 104
	CustomAbilities:QuickAttachParticle("particles/radiant_fx/good_barracks_ranged002_destroy.vpcf", stone, 3)
	EmitSoundOn("Tanari.FireTemple.YojimboDiscipleShatter", stone)
	return stone
end

function Tanari:FireTempleRoom3()
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local vectorTable = {Vector(3818, -14779, 513), Vector(4958, -13908, 587), Vector(4374, -13909, 576), Vector(4957, -13058, 586), Vector(4395, -13064, 590), Vector(4385, -12224, 590), Vector(4957, -12221, 590), Vector(5480, -11475, 613), Vector(6686, -11992, 640)}
	for i = 1, #vectorTable, 1 do
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, vectorTable[i] + Vector(0, 0, 400))
	end
	Tanari:SpawnTemperedWarrior(Vector(4416, -15040), Vector(-1, 0))
	Tanari:SpawnTemperedWarrior(Vector(4480, -15552), Vector(-1, 0.5))
	Tanari:SpawnTemperedWarrior(Vector(4544, -14272), Vector(0, -1))
	Tanari:SpawnSecretFanatic(Vector(4864, -14400), Vector(-0.5, -1))

	Tanari:SpawnRelicHunter(Vector(4544, -12992), Vector(0, -1))
	Tanari:SpawnRelicHunter(Vector(4672, -13184), Vector(0, -1))
	Tanari:SpawnRelicHunter(Vector(4800, -12992), Vector(0, -1))

	Timers:CreateTimer(3, function()
		Tanari:SpawnCrazyJugg(Vector(4672, -12288), Vector(0, -1))
	end)
	Timers:CreateTimer(10, function()
		Tanari:SpawnLumosAscender(Vector(6784, -13504), Vector(0.4, 1))
	end)
	Timers:CreateTimer(5, function()
		if Tanari.RareLavaForge then
			Tanari:SpawnRareLavaForgeMaster(Vector(6400, -12416), Vector(-1, 0.2))
		end
	end)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(4480, -15232, 420), 500, 30, false)
end

function Tanari:SpawnTemperedWarrior(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_tempered_warrior", position, 1, 3, "Tanari.FireTemple.TemperedWarriorAggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone:SetRenderColor(255, 255, 60)
	stone.itemLevel = 99
	stone.targetRadius = 300
	stone.autoAbilityCD = 3
	stone.dominion = true
	return stone
end

function Tanari:SpawnCrazyJugg(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_mad_rito", position, 2, 4, "Tanari.FireTemple.CrazyJuggAggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone:SetRenderColor(255, 255, 60)
	stone.itemLevel = 106
	stone.dominion = true
	return stone
end

function Tanari:SpawnLumosAscender(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_lumos_ascender", position, 3, 4, "Tanari.FireTemple.LumosAggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone:SetRenderColor(100, 60, 180)
	stone.itemLevel = 109
	stone.targetRadius = 550
	stone.minRadius = 0
	stone.targetAbilityCD = 1
	stone.targetFindOrder = FIND_FARTHEST
	return stone
end

function Tanari:FireTempleWaveTrigger()
	if not Tanari.FireTemple then
		Tanari.FireTemple = {}
	end
	local beacon = Entities:FindAllByNameWithin("FireTempleWaveIndicator", Vector(6714, -13964, 386), 900)
	UTIL_Remove(beacon[1])
	EmitGlobalSound("Tanari.FireTemple.MagicSpell")

	Tanari.FireTemple.wavePFXTable = {}
	local portal1loc = Vector(6884, -15236)
	local portal2loc = Vector(6633, -15236)
	local portal3loc = Vector(6373, -15236)
	local pfx = Tanari:CreateFireTempleWavePortal(Vector(6884, -15236, 600))
	table.insert(Tanari.FireTemple.wavePFXTable, pfx)
	pfx = Tanari:CreateFireTempleWavePortal(Vector(6633, -15236, 600))
	table.insert(Tanari.FireTemple.wavePFXTable, pfx)
	pfx = Tanari:CreateFireTempleWavePortal(Vector(6373, -15236, 600))
	table.insert(Tanari.FireTemple.wavePFXTable, pfx)

	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(6633, -15236), 700, 900, false)
	Timers:CreateTimer(3, function()
		Tanari:SpawnFireTempleWaveUnit("fire_temple_sky_guardian", portal1loc, 10, 100, 2.3, true)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_dimension_seeker", portal2loc, 10, 100, 2.3, false)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_sky_guardian", portal3loc, 10, 100, 2.3, false)
	end)
end

function Tanari:CreateFireTempleWavePortal(position)
	local particleName = "particles/econ/events/league_teleport_2014/teleport_end_league.vpcf"
	local colorVector = Vector(255, 255, 255)
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(pfx, 0, position + Vector(0, 0, 600))
	ParticleManager:SetParticleControl(pfx, 1, colorVector)
	ParticleManager:SetParticleControl(pfx, 2, colorVector)
	ParticleManager:SetParticleControl(pfx, 3, colorVector)
	return pfx
end

function Tanari:SpawnFireTempleWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Tanari.FireTemple.WaveSpawn", Events.GameMaster)
			end
			local luck = RandomInt(1, 222)
			if Events.SpiritRealm then
				luck = RandomInt(1, 80)
			end
			if luck == 1 then
				unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
			elseif luck == 2 then
				unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
			else
				unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(unit)
			end
			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				unit.itemLevel = itemLevel
				unit:AddAbility("fire_temple_wave_room_ability"):SetLevel(1)
				unit:SetAcquisitionRange(3000)
				unit.dominion = true
				if unit:GetUnitName() == "fire_temple_dimension_seeker" then
					unit:SetRenderColor(255, 100, 0)
				elseif unit:GetUnitName() == "fire_temple_passage_skeleton" then
					unit:SetRenderColor(255, 0, 0)
				elseif unit:GetUnitName() == "fire_temple_skeleton_archer" then
					unit:SetRenderColor(255, 140, 0)
				end
			else
				for i = 1, #unit.buddiesTable, 1 do
					unit.buddiesTable[i].itemLevel = itemLevel
					unit.buddiesTable[i]:AddAbility("fire_temple_wave_room_ability"):SetLevel(1)
					unit.buddiesTable[i]:SetAcquisitionRange(3000)
					unit.buddiesTable[i].dominion = true
				end
			end
		end)
	end
end

function Tanari:WaveRoomPhase(phase)
	local portal1loc = Vector(6884, -15236)
	local portal2loc = Vector(6633, -15236)
	local portal3loc = Vector(6373, -15236)
	if phase >= 8 then
		return
	end
	local torchVectorLocTable = {Vector(5703, -14055, 632), Vector(5866, -13647, 624), Vector(6179, -13317, 623), Vector(6686, -13131, 623), Vector(7237, -13309, 622), Vector(7579, -13647, 622), Vector(7786, -14023, 620)}
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)

	ParticleManager:SetParticleControl(particle1, 0, torchVectorLocTable[phase] + Vector(0, 0, 400))
	EmitSoundOnLocationWithCaster(torchVectorLocTable[phase], "Tanari.TerrasicCrater.FlameSpitThink", Events.GameMaster)
	if phase == 1 then
		Tanari:SpawnFireTempleWaveUnit("terrasic_volcanic_legion", portal1loc, 10, 100, 2.3, true)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_dimension_seeker", portal2loc, 10, 100, 2.3, false)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_fireling", portal3loc, 10, 100, 2.3, false)
	elseif phase == 2 then
		Tanari:SpawnFireTempleWaveUnit("fire_temple_fireling", portal1loc, 10, 100, 2.3, false)
		Tanari:SpawnFireTempleWaveUnit("terrasic_volcano_beetle", portal2loc, 10, 100, 2.3, true)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_dimension_seeker", portal3loc, 10, 100, 2.3, false)
	elseif phase == 3 then
		Tanari:SpawnFireTempleWaveUnit("fire_temple_passage_skeleton", portal1loc, 10, 100, 2.3, false)
		Tanari:SpawnFireTempleWaveUnit("terrasic_volcanic_legion", portal2loc, 10, 100, 2.3, true)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_passage_skeleton", portal3loc, 10, 100, 2.3, false)
	elseif phase == 4 then
		Tanari:SpawnFireTempleWaveUnit("fire_temple_skeleton_archer", portal1loc, 10, 100, 2.3, false)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_dimension_seeker", portal2loc, 10, 100, 2.3, true)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_skeleton_archer", portal3loc, 10, 100, 2.3, false)
	elseif phase == 5 then
		Tanari:SpawnFireTempleWaveUnit("fire_temple_fireling", portal1loc, 10, 100, 2.3, false)
		Tanari:SpawnFireTempleWaveUnit("volcanic_ash", portal2loc, 10, 100, 2.3, true)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_blackguard", portal3loc, 10, 100, 2.3, false)
	elseif phase == 6 then
		Tanari:SpawnFireTempleWaveUnit("fire_temple_final_wave_mob", portal1loc, 10, 100, 2.3, false)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_final_wave_mob", portal2loc, 10, 100, 2.3, true)
		Tanari:SpawnFireTempleWaveUnit("fire_temple_final_wave_mob", portal3loc, 10, 100, 2.3, false)
	elseif phase == 7 then
		EmitSoundOnLocationWithCaster(portal2loc, "Tanari.FireTemple.MagicSpell", Events.GameMaster)
		Timers:CreateTimer(5, function()
			for i = 1, #Tanari.FireTemple.wavePFXTable, 1 do
				ParticleManager:DestroyParticle(Tanari.FireTemple.wavePFXTable[i], false)
			end
		end)
		Timers:CreateTimer(8, function()
			local particleName = "particles/generic_hero_status/hero_levelup.vpcf"
			local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particle2, 0, Vector(6714, -13964, 786))
			ParticleManager:SetParticleControl(particle2, 1, Vector(6714, -13964, 3300))
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(particle2, false)
			end)
			local boss = Tanari:SpawnSeerOfSolos(Vector(6714, -13964, 386), Vector(0, 1))
			boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0, 0, 2400))
			local bossAbility = boss:FindAbilityByName("fire_temple_solos_ai")
			bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_solos_entrance", {duration = 4})
			WallPhysics:Jump(boss, Vector(0, 0), 0, 30, 1, 2.0)
			boss.jumpEnd = "ruins_boss"
			Timers:CreateTimer(3, function()
				boss.jumpEnd = false
				StartAnimation(boss, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
			end)
			Timers:CreateTimer(5, function()
				local spearAbility = boss:FindAbilityByName("solos_burning_spear")
				spearAbility:ToggleAutoCast()
			end)

		end)
	end
end

function Tanari:SpawnSeerOfSolos(position, fv)
	local stone = Tanari:SpawnDungeonUnit("fire_temple_seer_of_solos", position, 4, 5, "Tanari.FireTemple.LumosAggro", fv, false)
	Events:AdjustBossPower(stone, 6, 6, false)
	stone:SetRenderColor(240, 40, 0)
	stone.itemLevel = 115
	stone.targetRadius = 1100
	stone.autoAbilityCD = 2
	return stone
end

function Tanari:SpawnFireMage(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_fire_mage", position, 1, 3, "Tanari.FireTemple.FireMageAggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 100
	-- ancient.patrolSlow = 35
	-- ancient.phaseIntervals = 5
	-- ancient.patrolPointRandom = 100
	ancient:SetRenderColor(255, 255, 0)
	ancient.dominion = true
	return ancient

end

function Tanari:FireTemplePart4()
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local vectorTable = {Vector(8618, -14784, 624), Vector(8705, -13448, 624), Vector(8622, -14784, 550)}
	for i = 1, #vectorTable, 1 do
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, vectorTable[i] + Vector(0, 0, 400))
	end
	Tanari:SpawnFireMage(Vector(8512, -15040), Vector(1, -1))
	Tanari:SpawnFireMage(Vector(9088, -14848), Vector(-0.3, -1))
	Tanari:SpawnTemperedWarrior(Vector(9536, -15488), Vector(-1, 1))
	Tanari:SpawnLavaCaller(Vector(8896, -13824), Vector(0.8, -1))
	Tanari:SpawnLavaCaller(Vector(9408, -13696), Vector(-0.5, -1))
	Tanari:SpawnFireMage(Vector(8789, -14189), Vector(1, 0))
	if Tanari.BlackCentaur then
		Tanari:SpawnRareBlackCentaur(Vector(9141, -12843), Vector(0, -1))
	end

	if Events.SpiritRealm then
		Tanari:SpawnFireSpirit(Vector(9664, -15104), Vector(-1, 0))
	end
end

function Tanari:FireTempleFinalRoomSpawn()
	if not Tanari.FireTemple then
		Tanari.FireTemple = {}
	end
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local vectorTable = {Vector(7515, -12404, 477), Vector(5480, -9719, 170), Vector(5399, -7491, 128), Vector(6021, -7985, 128), Vector(6888, -7985, 128), Vector(6936, -8882, 128), Vector(6016, -8862, 128)}
	for i = 1, #vectorTable, 1 do
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1, 0, vectorTable[i] + Vector(0, 0, 400))
	end
	Tanari:SpawnLavaCaller(Vector(8576, -13053), Vector(1, 0))
	Tanari:SpawnFireMage(Vector(8972, -12582), Vector(0.2, -1))
	Tanari:SpawnTemperedWarrior(Vector(8704, -12736), Vector(1, -1))
	local spiritBasePos = Vector(7780, -12160)
	for i = 0, 2, 1 do
		for j = 0, 2, 1 do
			Tanari:SpawnProtectiveSpirit(spiritBasePos + Vector(145 * i, 200 * j), Vector(0, -1))
		end
	end
	Timers:CreateTimer(10, function()
		Tanari:SpawnLavaCaller(Vector(6144, -10176), Vector(1, 0))
		Tanari:SpawnLavaCaller(Vector(6144, -10010), Vector(1, 0))
		local basePos = Vector(5824, -10210)
		for i = 0, 1 do
			for j = 0, 2 do
				Tanari:SpawnProtectiveSpirit(basePos + Vector(120 * i, 100 * j), Vector(1, 0))
			end
		end
	end)
	Timers:CreateTimer(13, function()
		Tanari:SpawnBlackguardDoombringer(Vector(5120, -10112), Vector(1, 0))
	end)
end

function Tanari:SpawnLavaCaller(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_lava_caller", position, 2, 3, "Tanari.FireTemple.LavaCallerAggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 110
	ancient.targetRadius = 780
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_ANY_ORDER
	ancient:SetRenderColor(255, 100, 0)
	ancient.dominion = true
	return ancient

end

function Tanari:SpawnProtectiveSpirit(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_protective_spirit", position, 1, 2, "Tanari.FireTemple.ProtectiveSpiritAggro", fv, false)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 105
	ancient:SetRenderColor(255, 0, 0)
	ancient.modelScale = 0.95
	ancient.dominion = true
	return ancient

end

function Tanari:FireTempleLastRoomTrigger()
	Tanari:SpawnBlackguardDoombringer(Vector(5120, -7232), Vector(0, -1))
	Tanari:SpawnFlameWraith(Vector(5015, -8832), Vector(0, -1))
	Tanari:SpawnFlameWraith(Vector(5184, -8832), Vector(0, -1))
	Tanari:SpawnFlameWraith(Vector(5015, -8640), Vector(0, -1))
	Tanari:SpawnFlameWraith(Vector(5184, -8640), Vector(0, -1))
	Tanari:SpawnFireMage(Vector(5119, -8448), Vector(0, -1))
	Timers:CreateTimer(2, function()
		Tanari:SpawnFlameWraithLord(Vector(6485, -8384), Vector(0, 1))
	end)
end

function Tanari:SpawnFlameWraith(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_flame_wraith", position, 1, 3, "Tanari.FireTemple.FlameWraithAggro", fv, false)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 107
	ancient:SetRenderColor(255, 0, 0)
	ancient.dominion = true
	return ancient
end

function Tanari:SpawnFlameWraithLord(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_flame_wraith_lord", position, 2, 3, "Tanari.FireTemple.FlameWraithAggro", fv, false)
	Events:AdjustBossPower(ancient, 6, 6, false)
	ancient.itemLevel = 115
	ancient:SetRenderColor(255, 0, 0)
	ancient.dominion = true
	return ancient
end

function Tanari:SpawnKelthas()
	local boss = CreateUnitByName("flame_worshipper_kolthun", Vector(8354, -9283), false, nil, nil, DOTA_TEAM_NEUTRALS)
	boss.type = ENEMY_TYPE_BOSS
	Events:AdjustDeathXP(boss)
	boss:SetRenderColor(255, 30, 0)
	Events:AdjustBossPower(boss, 8, 8)
	boss:SetForwardVector(Vector(-1, 1))
	return boss
end

function Tanari:FireTempleFinalBossSpawn()
	if not Tanari.FireTemple then
		Tanari.FireTemple = {}
	end
	if not Tanari.FireTemple.Initialized then
		return
	end
	local boss = Tanari:SpawnKelthas()
	boss.type = ENEMY_TYPE_BOSS
	boss.phase = 0
	boss.fallVelocity = 0
	boss:SetAcquisitionRange(8000)
	local bossAbility = boss:FindAbilityByName("fire_temple_kolthun_ai")
	bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_kolthun_intro", {})
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(8119, -9083, 870), 700, 2400, false)
	Tanari.FireTemple.flameOrb = CreateUnitByName("npc_flying_dummy_vision", Vector(8119, -9083, 870), false, nil, nil, DOTA_TEAM_NEUTRALS)
	Tanari.FireTemple.flameOrb:AddAbility("dummy_unit"):SetLevel(1)
	Tanari.FireTemple.flameOrb:SetAbsOrigin(Vector(8119, -9083, 740))
	return boss
end

function Tanari:FireTempleKolthunShieldHit(victim)
	local newStacks = victim:GetModifierStackCount("modifier_kolthun_shield", victim) - 1
	if newStacks == 0 then
		victim:RemoveModifierByName("modifier_kolthun_shield")
	else
		victim:SetModifierStackCount("modifier_kolthun_shield", victim, newStacks)
	end
end

function Tanari:FireTempleFireShieldHit(victim)
	local newStacks = victim:GetModifierStackCount("modifier_firelord_shield", victim) - 1
	if newStacks == 0 then
		victim:RemoveModifierByName("modifier_firelord_shield")
	else
		victim:SetModifierStackCount("modifier_firelord_shield", victim, newStacks)
	end
end

function Tanari:SpawnFireLord(kolthun)
	local boss = CreateUnitByName("fire_temple_neverlord_reborn", Vector(8395, -10101, 100), false, nil, nil, DOTA_TEAM_NEUTRALS)
	boss:SetAbsOrigin(Vector(8395, -10101, -400))
	boss:SetRenderColor(255, 30, 0)
	Events:AdjustDeathXP(boss)

	Events:AdjustBossPower(boss, 10, 10)
	if GameState:GetDifficultyFactor() == 3 then
		local newHealth = 2 ^ 24
		boss:SetMaxHealth(newHealth)
		boss:SetBaseMaxHealth(newHealth)
		boss:SetHealth(newHealth)
		boss:Heal(newHealth, unit)
	end
	boss:SetForwardVector(Vector(-1, 0))
	boss.kolthun = kolthun
	boss.fallVelocity = 0
	boss.type = ENEMY_TYPE_BOSS
	kolthun.phase3active = true
	kolthun.boss = boss
	CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = boss:GetUnitName(), bossMaxHealth = boss:GetMaxHealth(), bossId = tostring(boss)})
	AddFOWViewer(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 1000, 900, false)
	kolthun:SetModelScale(1.16)
	local bossAbility = boss:FindAbilityByName("firelord_ability_ai")
	StartAnimation(boss, {duration = 3, activity = ACT_DOTA_CAST_ABILITY_6, rate = 1})
	bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_firelord_intro", {duration = 3.2})
	Timers:CreateTimer(0.2, function()
		ScreenShake(boss:GetAbsOrigin(), 700, 3, 3, 9000, 0, true)
		Tanari:CreateLavaBlast(boss:GetAbsOrigin())
		EmitSoundOn("Tanari.LavaSplash", boss)
	end)
	local particleName = "particles/dire_fx/fire_ambience.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	ParticleManager:SetParticleControl(particle1, 0, Vector(8120, -9084, 849))
	Timers:CreateTimer(0.6, function()
		EmitGlobalSound("Tanari.FireTemple.NeverlordSpawn")
	end)
	for i = 1, 40, 1 do
		Timers:CreateTimer(0.03 * i, function()
			boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0, 0, 20))
		end)
	end
	Timers:CreateTimer(3.2, function()
		bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_firelord_shield", {})
		local stacks = 50
		if GameState:GetDifficultyFactor() == 2 then
			stacks = 10
		elseif GameState:GetDifficultyFactor() == 3 then
			stacks = 150
		end
		boss:SetModifierStackCount("modifier_firelord_shield", boss, stacks)
	end)
	return boss
end

function Tanari:SpawnRareBlackCentaur(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_rare_blackguard_centaur", position, 3, 5, "Tanari.FireTemple.CentaurBossAggro", fv, false)
	Events:AdjustBossPower(ancient, 10, 10, false)
	ancient.itemLevel = 135
	ancient:SetRenderColor(255, 150, 150)
	ancient.targetRadius = 300
	ancient.autoAbilityCD = 1
	return ancient

end

function Tanari:SpawnRareLavaForgeMaster(position, fv)
	local ancient = Tanari:SpawnDungeonUnit("fire_temple_rare_lava_forgemaster", position, 3, 5, "Tanari.FireTemple.LavaforgeAggro", fv, false)
	Events:AdjustBossPower(ancient, 9, 9, false)
	ancient.itemLevel = 135
	ancient:SetRenderColor(255, 50, 50)
	ancient.targetRadius = 900
	ancient.autoAbilityCD = 2
	return ancient

end

function Tanari:SpawnFireSpirit(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_ancient_fire_spirit", position, 2, 4, "Tanari.FireSpirit.Death", fv, false)
	mage.itemLevel = 100
	Events:AdjustBossPower(mage, 10, 10, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnFireShaman(position, fv)
	local mage = Tanari:SpawnDungeonUnit("fire_temple_flame_shaman", position, 1, 2, "Tanari.FireShaman.Aggro", fv, false)
	mage.itemLevel = 100
	mage.dominion = true
	Events:AdjustBossPower(mage, 6, 6, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpiritFireTempleStart()
	Tanari:SpawnFireShaman(Vector(11072, -14782), Vector(0, -1))
	Tanari:SpawnFireShaman(Vector(11008, -15488), Vector(-1, 0))
	Tanari:SpawnFireShaman(Vector(11456, -15360), Vector(-1, -0.2))
	Tanari:SpawnFireShaman(Vector(11840, -15185), Vector(-1, -0.5))

	Timers:CreateTimer(2, function()
		Tanari:SpawnFireSpawner(Vector(10688, -15040), RandomVector(1), Vector(10810, -15040))
		Tanari:SpawnFireSpawner(Vector(12906, -14464), RandomVector(1), Vector(12906, -14594))
	end)
	Timers:CreateTimer(4, function()
		Tanari:SpawnLavaSpecter(Vector(12416, -14976), Vector(-1, -1))
		Tanari:SpawnLavaSpecter(Vector(13420, -14976), Vector(-1, 0.2))
		Tanari:SpawnLavaSpecter(Vector(13926, -15258), Vector(-1, 0.7))
		Tanari:SpawnLavaSpecter(Vector(14072, -15258), Vector(-1, 0))
		Tanari:SpawnFireSpawner(Vector(15490, -15543), RandomVector(1), Vector(15389, -15358))
		Tanari:SpawnFireShaman(Vector(15448, -15309), Vector(-1, 0.1))
		Tanari:SpawnFireShaman(Vector(13952, -15397), Vector(0, 1))
	end)

	Timers:CreateTimer(6, function()
		Tanari:SpawnFlameriderGorthos(Vector(14976, -13632), Vector(0, -1))
		Tanari:SpawnLavaSpecter(Vector(14852, -14232), Vector(0, -1))
		Tanari:SpawnLavaSpecter(Vector(15104, -14193), Vector(-0.3, -1))
		Tanari:SpawnLavaSpecter(Vector(14979, -14016), Vector(0, -1))
	end)
	Timers:CreateTimer(8, function()
		Tanari:SpawnLavaPrisoner(Vector(0, -1), Vector(14976, -15040))
		Tanari:SpawnLavaPrisoner(Vector(0, -1), Vector(12997, -15181))
		if GameState:GetDifficultyFactor() > 1 then
			Tanari:SpawnLavaPrisoner(Vector(0, -1), Vector(14400, -15040))
		end
	end)
end

function Tanari:SpawnFireSpawner(position, fv, summonCenter)
	local stone = Tanari:SpawnDungeonUnit("tanari_fire_temple_spawner", position, 2, 4, nil, fv, false)
	stone:SetRenderColor(40, 0, 0)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 80
	stone.summonCenter = summonCenter
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, stone, "tanari_mountain_specter_ai", {})
	StartAnimation(stone, {duration = 99999, activity = ACT_DOTA_CAPTURE, rate = 1})
	stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate = "level2"})
	return stone
end

function Tanari:SpawnFireSpawnerUnit(position, fv, itemRoll, bAggro)
	local stone = Tanari:SpawnDungeonUnit("molten_entity", position, itemRoll, itemRoll, nil, fv, bAggro)
	stone:SetRenderColor(233, 100, 100)
	stone.itemLevel = 90
	stone.dominion = true
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, stone, "tanari_mountain_specter_ai", {})
	return stone
end

function Tanari:SpawnLavaSpecter(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_lava_spectre", position, 1, 2, "Tanari.LavaSpecter.Aggro", fv, false)
	mage.itemLevel = 100
	mage.dominion = true
	Events:AdjustBossPower(mage, 10, 10, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnFlameriderGorthos(position, fv)
	local mage = Tanari:SpawnDungeonUnit("flamerider_gorthos", position, 2, 5, "Tanari.Gorthos.Aggro", fv, false)
	mage.itemLevel = 120
	mage.dominion = true
	Events:AdjustBossPower(mage, 10, 10, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	return mage
end

function Tanari:SpawnFlameBeast(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_flame_beast", position, 1, 2, "Tanari.FlameBeast.Aggro", fv, false)
	mage.itemLevel = 100
	mage.dominion = true
	Events:AdjustBossPower(mage, 8, 8, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	Events:SetPositionCastArgs(mage, 1000, 0, 1, FIND_ANY_ORDER)
	return mage
end

function Tanari:SpawnFireTempleOgre(position, fv)
	local mage = Tanari:SpawnDungeonUnit("fire_temple_ogre", position, 1, 2, "Tanari.FireOgre.Aggro", fv, false)
	mage.itemLevel = 100
	mage.dominion = true
	Events:AdjustBossPower(mage, 8, 8, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	Events:SetTargetCastArgs(mage, 1200, 0, 2, FIND_ANY_ORDER)
	return mage
end

function Tanari:SpawnFireSpiritArea2()
	Tanari:SpawnFlameBeast(Vector(14528, -12992), Vector(1, 0))
	Tanari:SpawnFlameBeast(Vector(14702, -12416), Vector(1, -1))
	Tanari:SpawnFlameBeast(Vector(15480, -11902), Vector(-1, -0.6))

	Tanari:SpawnFireShaman(Vector(14976, -12800), Vector(0, -1))
	Tanari:SpawnFireShaman(Vector(15143, -12096), Vector(0, -1))
	Tanari:SpawnFireShaman(Vector(14532, -11595), Vector(0, -1))

	Tanari:SpawnFireSpawner(Vector(15424, -11520), Vector(-1, -1), Vector(15242, -11720))

	Timers:CreateTimer(2, function()
		for i = 0, 1, 1 do
			for j = 0, 2, 1 do
				Tanari:SpawnLavaSpecter(Vector(13440, -12096) + Vector(i * 320, j * 220), Vector(1, 0))
			end
		end
	end)
	Timers:CreateTimer(6, function()
		Tanari:SpawnFireTempleOgre(Vector(12674, -12416), Vector(0.2, 1))
		Tanari:SpawnFireTempleOgre(Vector(12032, -12696), Vector(0.8, 1))
		Tanari:SpawnFireTempleOgre(Vector(11520, -12217), Vector(1, 0))
		Tanari:SpawnFireTempleOgre(Vector(12352, -11520), Vector(1, -1))

		Tanari:SpawnFlameBeast(Vector(12352, -12131), Vector(1, 1))
		Tanari:SpawnFlameBeast(Vector(11902, -12317), Vector(1, 0.5))
		Tanari:SpawnFlameBeast(Vector(11840, -11380), Vector(1, -1))

		Timers:CreateTimer(2, function()
			Tanari:SpawnFireShaman(Vector(11776, -11759), Vector(1, 0))
			Tanari:SpawnFireShaman(Vector(12608, -11776), Vector(1, 0))
			Tanari:SpawnFireSpawner(Vector(11840, -10892), Vector(0.2, -1), Vector(11840, -11050))
			Tanari:SpawnFireSpawner(Vector(11264, -12434), Vector(1, 0), Vector(11500, -12434))
			Tanari:SpawnFireSpawner(Vector(12416, -12800), Vector(1, 1), Vector(12416, -12500))
		end)
	end)
end

function Tanari:SpawnSpiritFireWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Tanari.SpiritWater.Spawn", Events.GameMaster)
			end
			local luck = RandomInt(1, 222)
			if Events.SpiritRealm then
				luck = RandomInt(1, 66)
			end
			if luck == 1 then
				unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
			elseif luck == 2 then
				unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
			else
				unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(unit)
			end

			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				unit.itemLevel = itemLevel
				unit.dominion = true
				Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_fire_temple_modifier", {})
				Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_mountain_specter_ai", {})
				unit.code = 0

				unit:SetAcquisitionRange(5000)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", unit, 2)
				unit.aggro = true
				Events:SetPositionCastArgs(unit, 1000, 0, 1, FIND_ANY_ORDER)
				unit.targetRadius = 300
				unit.autoAbilityCD = 2
				unit.modelScale = 0.95
			else
				for i = 1, #unit.buddiesTable, 1 do
					unit.buddiesTable[i].aggro = true
					unit.buddiesTable[i].itemLevel = itemLevel
					Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit.buddiesTable[i], "tanari_fire_temple_modifier", {})
					Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit.buddiesTable[i], "tanari_mountain_specter_ai", {})
					unit.buddiesTable[i].code = 0
					unit.buddiesTable[i]:SetAcquisitionRange(5000)
					unit.buddiesTable[i].dominion = true
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", unit.buddiesTable[i], 2)
					Events:SetPositionCastArgs(unit.buddiesTable[i], 1000, 0, 1, FIND_ANY_ORDER)
					unit.buddiesTable[i].targetRadius = 300
					unit.buddiesTable[i].autoAbilityCD = 2
					unit.buddiesTable[i].modelScale = 0.95
				end
			end
		end)
	end
end

function Tanari:FireSpiritPortalRoom()
	Tanari:SpawnFireTempleOgre(Vector(12096, -9472), Vector(-1, 0))
	Tanari:SpawnFireTempleOgre(Vector(13054, -9472), Vector(-1, 0))
	Tanari:SpawnFireTempleOgre(Vector(14976, -9472), Vector(-1, 0))

	Tanari:SpawnInfernODemon(Vector(12032, -8832), Vector(0, -1))
	Tanari:SpawnInfernODemon(Vector(13568, -8832), Vector(0, -1))
	Tanari:SpawnInfernODemon(Vector(15040, -8832), Vector(0, -1))

	Timers:CreateTimer(2, function()
		Tanari:SpawnFireSpawner(Vector(12864, -9216), Vector(0, -1), Vector(12864, -9500))
		Tanari:SpawnFireSpawner(Vector(14388, -9751), Vector(0, 1), Vector(14388, -9500))
	end)

	Timers:CreateTimer(4, function()
		local positionTable = {Vector(11136, -9408), Vector(12864, -9408), Vector(14319, -9408), Vector(15552, -9408)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 2
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnFireShaman(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 4, 30, patrolPositionTable)
			end
		end
	end)

	Tanari.FireTemple.SpiritPortalsActive = true
	Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(12008, -8320, 580), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
	Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(13568, -8320, 580), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
	Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(15104, -8320, 580), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
end

function Tanari:SpawnInfernODemon(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_inferno_demon", position, 2, 4, "Tanari.InfernoDemon.Aggro", fv, false)
	mage.itemLevel = 100
	mage.dominion = true
	Events:AdjustBossPower(mage, 10, 8, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	-- Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	Events:SetPositionCastArgs(mage, 1200, 0, 1, FIND_ANY_ORDER)
	return mage
end

function Tanari:SpawnLavaBully(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_lava_bully", position, 0, 2, "Tanari.LavaBully.Aggro", fv, false)
	mage.itemLevel = 100
	Events:AdjustBossPower(mage, 10, 8, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	mage:RemoveModifierByName("modifier_paragon_springy")
	-- Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	return mage
end

function Tanari:SpawnLavaBullyBig(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_lava_bully_big", position, 0, 2, "Tanari.LavaBully.Aggro", fv, false)
	mage.itemLevel = 100
	Events:AdjustBossPower(mage, 10, 8, false)
	Events:SetPositionCastArgs(mage, 1000, 0, 2, FIND_ANY_ORDER)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	mage:RemoveModifierByName("modifier_paragon_springy")
	-- Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	return mage
end

function Tanari:InitPortal1Room()
	Tanari.FireTemple.Portal1Activated = true
	Timers:CreateTimer(2.5, function()
		for i = 1, 3, 1 do
			Timers:CreateTimer(i * 0.5, function()
				local centerPoint = Vector(-13817, -14545)
				local spawnPosition = centerPoint + RandomVector(RandomInt(200, 650))
				local bully = Tanari:SpawnLavaBully(spawnPosition, RandomVector(1))
				bully.jumpEnd = "lava_legion"
				bully:SetAbsOrigin(bully:GetAbsOrigin() + Vector(0, 0, 1000))
				WallPhysics:Jump(bully, Vector(0, 0), 0, 30, 1, 1.2)
				Dungeons:AggroUnit(bully)
			end)
		end
	end)
end

function Tanari:InitPortal2Room()
	local platform1 = Tanari:CreateMovingPlatform(Vector(-15714, -9680), Vector(-15714, -8785))
	local platform2 = Tanari:CreateMovingPlatform(Vector(-15273, -8319), Vector(-15273, -9300))
	local platform3 = Tanari:CreateMovingPlatform(Vector(-12416, -9323), Vector(-14762, -9323))
	local platform4 = Tanari:CreateMovingPlatform(Vector(-12416, -8872), Vector(-12416, -8256))
	Tanari.FireTemple.MovingPlatformTable = {platform1, platform2, platform3, platform4}

	Tanari:SpawnFireCrabBeast(Vector(-12800, -10816), Vector(0.4, -1))
	Tanari:SpawnFireCrabBeast(Vector(-12102, -10880), Vector(-0.6, -1))
	Tanari:SpawnFireCrabBeast(Vector(-12515, -10560), Vector(0, -1))

	Timers:CreateTimer(1, function()
		Tanari:SpawnFireTempleOgre(Vector(-12224, -10240), Vector(-0.5, -1))
		Tanari:SpawnFireTempleOgre(Vector(-12992, -10240), Vector(1, -0.2))
	end)
	Timers:CreateTimer(3, function()
		Tanari:SpawnInfernODemon(Vector(-13248, -11456), Vector(0, 1))
		for i = 0, 4, 1 do
			Tanari:SpawnFireSpawner(Vector(-15424, -11917) + Vector(500 * i, 0), Vector(0, 1), Vector(-15424, -12217) + Vector(500 * i, 240))
		end
		Tanari:SpawnFlameBeast(Vector(-13184, -11016), Vector(0, 1))
		Tanari:SpawnFlameBeast(Vector(-13440, -10880), Vector(1, 1))
	end)

	Timers:CreateTimer(5, function()

		local positionTable = {Vector(-13824, -11968), Vector(-14400, -11968), Vector(-14976, -11968)}
		for i = 1, #positionTable, 1 do
			Tanari:SpawnLavaSpecter(positionTable[i], Vector(1, 0))
		end
		Tanari:SpawnInfernODemon(Vector(-15936, -11712), Vector(1, -1))

		Tanari:SpawnLavaPrisoner(Vector(0, -1), Vector(-14976, -9536))
		Tanari:SpawnLavaPrisoner(Vector(0, -1), Vector(-13918, -9019))
		if GameState:GetDifficultyFactor() > 1 then
			Tanari:SpawnLavaPrisoner(Vector(1, 0), Vector(-13046, -8617))
		end
	end)
	Timers:CreateTimer(4, function()
		local positionTable = {Vector(-14016, -10752), Vector(-15232, -11200), Vector(-15889, -11937), Vector(-13504, -11937)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local spawnCount = 2
			for k = 1, spawnCount, 1 do
				local elemental = Tanari:SpawnFireShaman(positionTable[i], RandomVector(1))
				Tanari:AddPatrolArguments(elemental, 30, 4, 30, patrolPositionTable)
			end
		end
	end)
	Timers:CreateTimer(7, function()
		local positionTable = {Vector(-14278, -11328), Vector(-14592, -10944), Vector(-13928, -10752)}
		for i = 1, #positionTable, 1 do
			local lookToPoint = Vector(-14912, -11264)
			local fv = (lookToPoint - positionTable[i]):Normalized()
			Tanari:SpawnFireCrabBeast(positionTable[i], fv)
		end
	end)
	Timers:CreateTimer(10, function()
		local positionTable = {Vector(-14400, -10240), Vector(-15079, -10240), Vector(-15744, -10240)}
		for i = 1, #positionTable, 1 do
			Tanari:SpawnFlameBeast(positionTable[i], Vector(0, 1))
		end
		Tanari:SpawnFireCrabBeast(Vector(-15744, -9664), Vector(0, -1))
		Tanari:SpawnLavaSiegeHulker(Vector(-12224, -7616), Vector(0, -1))
	end)
	

	Tanari:SpawnFireShaman(Vector(-15744, -8367), Vector(0, -1))
	Tanari:SpawnFlameBeast(Vector(-15296, -8367), Vector(0, -1))
	Tanari:SpawnLavaSpecter(Vector(-12416, -9316), Vector(1, 0))
	Tanari:SpawnInfernODemon(Vector(-12416, -8900), Vector(0, -1))
end

function Tanari:CreateMovingPlatform(position, target)
	local platformThinker = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
	-- platformThinker:SetAbsOrigin(position+Vector(0,0,platformThinker.headOffset))
	platformThinker:AddAbility("tanari_moving_platform_ability"):SetLevel(1)
	platformThinker:RemoveAbility("dummy_unit")
	platformThinker:RemoveModifierByName("dummy_unit")

	local platform = Entities:FindByNameNearest("FireTempleMovingPlatform", position, 800)
	platformThinker:SetAbsOrigin(platform:GetAbsOrigin())
	platformThinker.platform = platform
	platformThinker.state = 0
	platformThinker.movementTicks = 0
	platformThinker.movementVector = (target - platform:GetAbsOrigin() * Vector(1, 1, 0)) / 240
	return platformThinker
end

function Tanari:SpawnFireCrabBeast(position, fv)
	local mage = Tanari:SpawnDungeonUnit("tanari_fire_crab_beast", position, 1, 2, "Tanari.LavaBeast.Aggro", fv, false)
	mage.itemLevel = 100
	mage.dominion = true
	Events:AdjustBossPower(mage, 8, 8, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	Events:SetTargetCastArgs(mage, 1200, 0, 2, FIND_ANY_ORDER)
	return mage
end

function Tanari:SpawnLavaSiegeHulker(position, fv)
	local mage = Tanari:SpawnDungeonUnit("fire_temple_siege_hulker", position, 1, 2, "Tanari.SiegeHulker.Aggro", fv, false)
	mage.itemLevel = 100
	mage.dominion = true
	Events:AdjustBossPower(mage, 12, 12, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	return mage
end

function Tanari:InitPortal3Room()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13824, -6825), 700, 600, false)
	Tanari:SpawnInfernODemon(Vector(-15067, -6377), Vector(0, -1))
	Tanari:SpawnInfernODemon(Vector(-15067, -7213), Vector(0, 1))
	Tanari:SpawnInfernODemon(Vector(-14080, -6848), Vector(-1, 0))
	Timers:CreateTimer(5, function()
		Tanari:SpawnSpiritFireWaveUnit3("tanari_fire_crab_beast", Vector(1, 1), 5, 110, 2.5, false)
		Tanari:SpawnSpiritFireWaveUnit3("tanari_flame_beast", Vector(1, 1), 5, 110, 2.5, false)
	end)
end

function Tanari:SpawnSpiritFireWaveUnit3(unitName, spawnPoint, quantity, itemLevel, delay, bSound)
	spawnPoint = Vector(-13356, -7037) + Vector(RandomInt(0, 150), RandomInt(0, 370))
	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Tanari.SpiritWater.Spawn", Events.GameMaster)
			end
			local luck = RandomInt(1, 222)
			if Events.SpiritRealm then
				luck = RandomInt(1, 66)
			end
			if luck == 1 then
				unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
			elseif luck == 2 then
				unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
			else
				unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
				Events:AdjustDeathXP(unit)
			end

			if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
				unit.itemLevel = itemLevel
				unit.dominion = true
				Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_fire_temple_modifier", {})
				Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "tanari_mountain_specter_ai", {})
				unit.code = 1

				unit:SetAcquisitionRange(5000)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", unit, 2)
				unit.aggro = true
				Events:SetPositionCastArgs(unit, 1000, 0, 1, FIND_ANY_ORDER)
				unit.targetRadius = 300
				unit.autoAbilityCD = 2
				unit.modelScale = 0.95
				Tanari:LaunchWaveUnit3(unit)
			else
				for i = 1, #unit.buddiesTable, 1 do
					unit.buddiesTable[i].aggro = true
					unit.buddiesTable[i].itemLevel = itemLevel
					Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit.buddiesTable[i], "tanari_fire_temple_modifier", {})
					Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit.buddiesTable[i], "tanari_mountain_specter_ai", {})
					unit.buddiesTable[i].code = 1
					unit.buddiesTable[i]:SetAcquisitionRange(5000)
					unit.buddiesTable[i].dominion = true
					CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_batrider/batrider_firefly_startflash.vpcf", unit.buddiesTable[i], 2)
					Events:SetPositionCastArgs(unit.buddiesTable[i], 1000, 0, 1, FIND_ANY_ORDER)
					unit.buddiesTable[i].targetRadius = 300
					unit.buddiesTable[i].autoAbilityCD = 2
					unit.buddiesTable[i].modelScale = 0.95
					Tanari:LaunchWaveUnit3(unit.buddiesTable[i])
				end
			end
		end)
	end
end

function Tanari:LaunchWaveUnit3(unit)
	unit:SetForwardVector(Vector(-1, 0))
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, unit, "modifier_tanari_red", {})
	unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 200))
	local particleName = "particles/addons_gameplay/small_lava_splash_blast.vpcf"
	local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, uni)
	ParticleManager:SetParticleControl(particle1, 0, unit:GetAbsOrigin() + Vector(0, 0, 80))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(particle1, false)
	end)
	EmitSoundOn("Tanari.LavaSplash", unit)
	WallPhysics:Jump(unit, Vector(-1, 0), RandomInt(14, 22), RandomInt(24, 26), RandomInt(26, 32), 1)
	StartAnimation(unit, {duration = 1, activity = ACT_DOTA_SPAWN, rate = 1})
end

function Tanari:SpawnDemonWatcher(position, fv)
	local mage = Tanari:SpawnDungeonUnit("fire_temple_demon_watcher", position, 3, 4, "Tanari.FlameWatcher.Aggro", fv, false)
	mage.itemLevel = 100
	Events:AdjustBossPower(mage, 9, 9, false)
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "tanari_mountain_specter_ai", {})
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, mage, "modifier_tanari_red", {})
	return mage
end

function Tanari:CheckFireSpiritBossCondition()
	if Tanari.FireTemple.Room2Clear and Tanari.FireTemple.Room3Clear and Tanari.FireTemple.BullyRoomClear then
		Timers:CreateTimer(5, function()
			EmitGlobalSound("ui.set_applied")
			AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(15240, -10153, 640), 400, 1200, false)
			-- Dungeons:CreateBasicCameraLock(Vector(15240, -10153, 640), 2)
			Timers:CreateTimer(0.5, function()
				Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(15240, -10153, 640), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
				Tanari.FireTemple.FinalFireBossPortal = true
			end)
		end)
	end
end

function Tanari:SpawnFireSpiritFinalBoss()
	if Tanari.FireTemple.FinalSpiritBoss then
		UTIL_Remove(Tanari.FireTemple.FinalSpiritBoss)
	end
	local guardian = Events:SpawnBoss("tanari_fire_spirit_boss", Vector(-14375, -2126))
	guardian.pushLock = true
	guardian.jumpLock = true
	guardian.type = ENEMY_TYPE_BOSS
	Tanari.TanariMasterAbility:ApplyDataDrivenModifier(Tanari.TanariMaster, guardian, "tanari_mountain_specter_ai", {})
	-- local guardian = CreateUnitByName("wind_temple_spirit_boss", Vector(12992, 1536), false, nil, nil, DOTA_TEAM_NEUTRALS)
	guardian:SetForwardVector(Vector(0, -1))
	Events:AdjustBossPower(guardian, 12, 12, true)
	-- local bossAbility = guardian:FindAbilityByName("water_spirit_main_boss_ability")
	local properties = {
		roll = 0,
		pitch = 0,
		yaw = 0,
		XPos = 30,
		YPos = 0,
		ZPos = -160,
	}
	local prop = Attachments:AttachProp(guardian, "attach_hitloc", "models/items/axe/shout_mask/shout_mask.vmdl", 2.4, properties)
	prop:SetRenderColor(255, 40, 40)

	Tanari.FireTemple.FinalSpiritBoss = guardian

	local bossAbility = guardian:FindAbilityByName("fire_spirit_main_boss_ability")
	bossAbility:ApplyDataDrivenModifier(guardian, guardian, "modifier_fire_spirit_boss_waiting", {})

end

function Tanari:InitSpiritFireBossRoom()
	Tanari:SpawnFireSpiritFinalBoss()
end

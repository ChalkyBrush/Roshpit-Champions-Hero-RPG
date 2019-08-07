function Winterblight:SpawnCrabSpawner(position, fv, summonCenter)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_snowcrab_eggs", position, 2, 3, nil, fv, false)
	-- stone:SetRenderColor(180,180,255)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 24
	stone.summonCenter = summonCenter
	return stone
end

function Winterblight:SpawnSpawnerUnit(position, fv, itemRoll, bAggro)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_snow_crab", position, itemRoll, itemRoll, nil, fv, bAggro)
	stone:SetRenderColor(210, 230, 255)
	stone.itemLevel = 12
	stone.dominion = true
	return stone
end

function Winterblight:SpawnWinterSeal(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_seal", position, 1, 1, "Seafortress.Seal.Aggro", fv, false)
	if GameState:GetDifficultyFactor() >= 3 then
		stone:AddAbility("normal_steadfast"):SetLevel(GameState:GetDifficultyFactor())
	end
	-- stone:SetRenderColor(180,180,255)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 20
	stone.dominion = true
	return stone
end

function Winterblight:SpawnMountainOgre(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mountain_ogre", position, 1, 2, "Winterblight.Ogre.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 20
	stone.dominion = true
	return stone
end

function Winterblight:SpawnMonolith(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_ancient_monolith", position, 1, 2, nil, fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 20
	return stone
end

function Winterblight:SpawnRaxxus(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_ice_champion_raxxus", position, 2, 3, "Winterblight.Raxxus.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 2, false)
	stone.itemLevel = 27
	return stone
end

function Winterblight:SpawnAssassin(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("mountain_assassin", position, 1, 2, "Winterblight.Assassin.Aggro", fv, true)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 22
	CustomAbilities:QuickAttachParticle("particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf", stone, 5)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnMountainCritter(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("aggressive_monster", position, 1, 1, "Winterblight.MountainCritter.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 18
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnMountainBeetle(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("ice_beetle", position, 1, 1, "Winterblight.MountainBeetle.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 22
	stone:SetRenderColor(170, 200, 255)
	stone:SetAbsOrigin(stone:GetAbsOrigin() - Vector(0, 0, 40))
	stone.dominion = true
	return stone
end

function Winterblight:SpawnWolf(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_wolf", position, 1, 1, "Winterblight.Wolf.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 18
	stone:SetRenderColor(220, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:FirstSpawns()
	local luck = RandomInt(1, 3)
	if luck == 1 then
		local positionTable = {Vector(-12960, -3003), Vector(-12951, -3392), Vector(-12800, -3840), Vector(-12224, -4544), Vector(-11840, -4864)}
		for i = 1, #positionTable, 1 do
			local lookToPoint = (Vector(-13824, -4672) - positionTable[i]):Normalized()
			Winterblight:SpawnWinterSeal(positionTable[i], lookToPoint)
		end
	elseif luck == 2 then
		local positionTable = {Vector(-12416, -3776), Vector(-11968, -3648), Vector(-11520, -3456), Vector(-11712, -3272), Vector(-12096, -3336), Vector(-12544, -3400)}
		for i = 1, #positionTable, 1 do
			local lookToPoint = (Vector(-13120, -2304) - positionTable[i]):Normalized()
			Winterblight:SpawnWinterSeal(positionTable[i], lookToPoint)
		end
	else
		local positionTable = {Vector(-11812, -4781), Vector(-12608, -4333), Vector(-12352, -2624)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				for j = 0, 1, 1 do
					Timers:CreateTimer(j * 2, function()
						local elemental = Winterblight:SpawnWinterSeal(positionTable[i] + RandomVector(120), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 35, 5, 240, patrolPositionTable)
					end)
				end
			end)
		end
	end
	Timers:CreateTimer(3, function()
		local luck = RandomInt(1, 3)
		if luck == 1 then
			Winterblight:SpawnMountainOgre(Vector(-12416, -2752), Vector(-1, 0.2))
			Winterblight:SpawnMountainOgre(Vector(-11058, -3861), Vector(0, -1))
			Winterblight:SpawnMountainOgre(Vector(-10459, -4160), Vector(0, -1))
		elseif luck == 2 then
			Winterblight:SpawnMountainOgre(Vector(-10944, -4161), Vector(-1, 0))
			Winterblight:SpawnMountainOgre(Vector(-10944, -4544), Vector(-1, 0))
			Winterblight:SpawnMountainOgre(Vector(-10496, -4544), Vector(-1, 0))
			Winterblight:SpawnMountainOgre(Vector(-10496, -4161), Vector(-1, 0))
		elseif luck == 3 then
			local positionTable = {Vector(-10432, -3904), Vector(-11520, -3968), Vector(-10112, -4800)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					local elemental = Winterblight:SpawnMountainOgre(positionTable[i] + RandomVector(120), RandomVector(1))
					Winterblight:AddPatrolArguments(elemental, 30, 5, 240, patrolPositionTable)
				end)
			end
			local elemental = Winterblight:SpawnWinterSeal(Vector(-11392, -4800), RandomVector(1))
			Winterblight:SpawnCrabSpawner(Vector(-11008, -4672), Vector(0, 1), Vector(-12992, -3264))
		end
	end)
	Winterblight:SpawnMonolith(Vector(-10357, -3776), Vector(0, -1))

	Timers:CreateTimer(6.5, function()
		local positionTable = {Vector(-9088, -3904), Vector(-10304, -5376), Vector(-5760, -6336), Vector(-6080, -8128)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				local wolfCount = 1 + GameState:GetDifficultyFactor()
				for j = 0, wolfCount, 1 do
					Timers:CreateTimer(j * 2, function()
						local elemental = Winterblight:SpawnWolf(positionTable[i] + RandomVector(120), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 8, 5, 240, patrolPositionTable)
					end)
				end
			end)
		end
	end)
end

function Winterblight:IceCrystalArea()
	for i = 1, 20, 1 do
		Timers:CreateTimer(i * 0.05, function()
			local scale = (7 + RandomInt(0, 5)) / 10
			local luck = RandomInt(1, 5)
			local position = Vector(-8384 + RandomInt(0, 2900), -8128 + RandomInt(0, 2150))
			if luck > 3 then
				position = Vector(-5632 + RandomInt(0, 1900), -8512 + RandomInt(0, 1650))
			end
			Winterblight:SpawnIceCrystal(position, RandomVector(1), scale)
		end)
	end
	local luck = RandomInt(1, 3)
	if luck == 1 then
		Winterblight:SpawnMountainDweller(Vector(-8768, -6976), Vector(0.7, 1))
		Winterblight:SpawnMountainDweller(Vector(-8512, -7104), Vector(0, 1))
		Winterblight:SpawnMountainDweller(Vector(-6720, -5824), Vector(0, -1))
		Winterblight:SpawnMountainDweller(Vector(-7360, -5824), Vector(0, -1))
		Winterblight:SpawnMountainDweller(Vector(-5680, -6817), Vector(-1, 1))
		Winterblight:SpawnMountainDweller(Vector(-6353, -8329), Vector(0, 1))
	elseif luck == 2 then
		Winterblight:SpawnMountainDweller(Vector(-6272, -7999), Vector(0, 1))
		Winterblight:SpawnMountainDweller(Vector(-6016, -8099), Vector(-0.3, 1))
		Winterblight:SpawnMountainDweller(Vector(-6217, -8271), Vector(0, 1))
		Winterblight:SpawnMountainDweller(Vector(-7360, -5696), Vector(0, -1))
		Winterblight:SpawnMountainDweller(Vector(-7424, -7040), Vector(-1, 1))
		Winterblight:SpawnMountainDweller(Vector(-6084, -6784), Vector(-1, 0.3))
	elseif luck == 3 then
		Winterblight:SpawnMountainDweller(Vector(-7424, -6336), Vector(-1, 0))
		Winterblight:SpawnMountainDweller(Vector(-7496, -6976), Vector(-1, 0.8))
		Winterblight:SpawnMountainDweller(Vector(-6784, -7278), Vector(0, 1))
		Winterblight:SpawnMountainDweller(Vector(-6400, -7480), Vector(0, 1))
		Winterblight:SpawnMountainDweller(Vector(-5570, -6720), Vector(-1, 0))
		Winterblight:SpawnMountainDweller(Vector(-5674, -6464), Vector(-1, 0))
		Winterblight:SpawnMountainDweller(Vector(-5409, -6299), Vector(-1, -0.3))
	end
	Timers:CreateTimer(2, function()
		local reynarLuck = RandomInt(1, 5)
		if reynarLuck == 1 then
			Winterblight:InitCaptainReynar()
		end
	end)
	Timers:CreateTimer(2, function()
		local luck2 = RandomInt(1, 3)
		if luck2 == 1 then
			local positionTable = {Vector(-6144, -8128), Vector(-6912, -5888), Vector(-5632, -6336), Vector(-8192, -6528)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					local wolfCount = 0
					for j = 0, wolfCount, 1 do
						Timers:CreateTimer(j * 2, function()
							local elemental = Winterblight:SpawnMountainOgre(positionTable[i] + RandomVector(120), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 8, 25, 240, patrolPositionTable)
						end)
					end
				end)
			end
		elseif luck2 == 2 then
			local positionTable = {Vector(-6144, -8128), Vector(-6912, -5888), Vector(-5632, -6336), Vector(-8192, -6528)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					local wolfCount = 1
					for j = 0, wolfCount, 1 do
						Timers:CreateTimer(j * 2, function()
							local elemental = Winterblight:SpawnMountainCritter(positionTable[i] + RandomVector(120), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 8, 25, 240, patrolPositionTable)
						end)
					end
				end)
			end
		elseif luck2 == 3 then
			for i = 0, 9 + GameState:GetDifficultyFactor() * 4, 1 do
				Timers:CreateTimer(0.03 * i, function()
					local position = Vector(-8832 + RandomInt(0, 3200), -6848 + RandomInt(0, 700))
					Winterblight:SpawnMountainBeetle(position, RandomVector(1))
				end)
			end
		end
	end)
end

function Winterblight:SpawnIceCrystal(position, fv, scale)
	local crystal = CreateUnitByName("winterblight_ice_crystal", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, RandomInt(100, 200)))
	crystal:SetForwardVector(fv)
	crystal.startingBlue = RandomInt(130, 200)
	crystal:SetRenderColor(crystal.startingBlue, crystal.startingBlue, 255)
	crystal:SetModelScale(scale)
	crystal.dummy = true
end

function Winterblight:SpawnLivingIce(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_living_ice", position, 0, 0, nil, fv, true)
	stone.itemLevel = 18
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnLivingIceNoAggro(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_living_ice", position, 0, 0, nil, fv, false)
	stone.itemLevel = 18
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:ShatterIceWall()
	local blockers = Entities:FindAllByNameWithin("IceShatterBlocker", Vector(-3335, -7744, 265 + Winterblight.ZFLOAT), 3000)
	for i = 1, #blockers, 1 do
		UTIL_Remove(blockers[i])
	end
	local iceWalls = Entities:FindAllByNameWithin("IceWallToShatter", Vector(-3335, -7744, 265 + Winterblight.ZFLOAT), 3000)
	for i = 1, #iceWalls, 1 do
		local iceWall = iceWalls[i]
		local position = iceWall:GetAbsOrigin()
		Winterblight:objectShake(iceWall, 8, 15, true, true, true, nil, 4)
		Timers:CreateTimer(0.3, function()
			local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)

			ParticleManager:SetParticleControl(particle1, 0, position)
			ParticleManager:SetParticleControl(particle1, 1, Vector(300, 2, 1000))
			ParticleManager:SetParticleControl(particle1, 3, Vector(300, 550, 550))
			Timers:CreateTimer(4, function()
				ParticleManager:DestroyParticle(particle1, false)
			end)

			EmitSoundOnLocationWithCaster(position, "Winterblight.IceCrystal.Shatter", Events.GameMaster)
			for i = 1, 3, 1 do
				local spawnPos = position + WallPhysics:rotateVector(Vector(-1, 0), 2 * math.pi * i / 3) * 3
				local ice = Winterblight:SpawnLivingIce(position, (spawnPos - position):Normalized())
				CustomAbilities:QuickAttachParticle("particles/act_2/flying_shatter_blast_explosion.vpcf", ice, 3)
				EmitSoundOn("Winterblight.IceCrystal.Spawn", ice)
			end
			UTIL_Remove(iceWall)
		end)
	end
	Timers:CreateTimer(2, function()
		Winterblight.IceWallShattered = true
		Winterblight:SpawnNorgok(Vector(2066, -5821), Vector(-1, 1))
	end)
end

function Winterblight:SpawnMountainDweller(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mountain_dweller", position, 1, 2, "Winterblight.MountainDweller.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 21
	stone:SetRenderColor(255, 255, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SnowCaveArea()
	local luck = RandomInt(1, 3)
	if luck == 1 then
		Winterblight:SpawnFrostiok(Vector(-1280, -8070), Vector(-0.3, 1))
		Winterblight:SpawnFrostiok(Vector(-1042, -8384), Vector(-0.1, 1))
		Winterblight:SpawnFrostiok(Vector(-790, -8040), Vector(-0.6, 1))
		Winterblight:SpawnChillingColossus(Vector(-128, -8256), Vector(-1, 1))
		Winterblight:SpawnChillingColossus(Vector(-704, -6080), Vector(0, -1))
		Timers:CreateTimer(2, function()
			Winterblight:SpawnIceMarauader(Vector(-960, -6133), Vector(-0.2, -1))
			Winterblight:SpawnIceMarauader(Vector(-1344, -6420), Vector(-0.3, -1))
			Winterblight:SpawnIceMarauader(Vector(-1792, -6723), Vector(0, -1))
		end)
		Timers:CreateTimer(2.5, function()
			Winterblight:Snowshaker(Vector(-320, -7424), Vector(-1, 0.5))
			Winterblight:Snowshaker(Vector(-192, -7168), Vector(-1, 0.7))
			Winterblight:Snowshaker(Vector(0, -6912), Vector(-1, 0))
			Winterblight:Snowshaker(Vector(128, -6592), Vector(-1, 0))
			Winterblight:SpawnChillingColossus(Vector(3264, -5504), Vector(-1, -1))
		end)
		Timers:CreateTimer(3, function()
			Winterblight:SpawnFrigidGrowth(Vector(1439, -6208), Vector(0, 1))
			Winterblight:SpawnFrigidGrowth(Vector(1536, -5376), Vector(-1, -1))
			Winterblight:SpawnFrigidGrowth(Vector(1920, -5129), Vector(-0.5, -1))
			Winterblight:SpawnFrigidGrowth(Vector(1792, -6784), Vector(0, 1))
			Winterblight:SpawnFrigidGrowth(Vector(2129, -7066), Vector(0.3, 1))
		end)
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(192, -6218), Vector(-118, -6080), Vector(223, -5824), Vector(-142, -5696), Vector(543, -5884), Vector(141, -5515), Vector(452, -5444)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostiok(positionTable[i], Vector(-1, -0.8))
			end
		end)
		Timers:CreateTimer(3.8, function()
			local positionTable = {Vector(1119, -5440), Vector(704, -5568), Vector(942, -5120), Vector(1209, -4992), Vector(1053, -4608)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnMountainDweller(positionTable[i], Vector(-0.2, -1))
			end
		end)
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(-2240, -7616), Vector(-492, -6792), Vector(768, -5376), Vector(2688, -5760), Vector(4224, -5888), Vector(3264, -6912), Vector(1984, -6528)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					for j = 0, 2, 1 do
						Timers:CreateTimer(j * 0.3, function()
							local elemental = Winterblight:SpawnIceMarauader(positionTable[i] + RandomVector(120), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
						end)
					end
				end)
			end
		end)
	elseif luck == 2 then
		local positionTable = {Vector(-1408, -8192), Vector(-1216, -7872), Vector(-1065, -8192), Vector(-832, -7819), Vector(-733, -8128), Vector(-421, -7892)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnIceSummoner(positionTable[i], Vector(-0.2, 1))
		end
		Winterblight:SpawnFrigidGrowth(Vector(-256, -8384), Vector(-1, 1))
		Winterblight:SpawnFrigidGrowth(Vector(128, -8128), Vector(-1, 0.3))
		Winterblight:SpawnFrigidGrowth(Vector(64, -7616), Vector(-1, -0.1))
		Timers:CreateTimer(0.5, function()
			Winterblight:SpawnChillingColossus(Vector(192, -4992), Vector(0.3, -1))
			Winterblight:SpawnChillingColossus(Vector(-1070, -6004), Vector(0.3, -1))
			local positionTable = {Vector(-1921, -6813), Vector(-1664, -6621), Vector(-1399, -6400), Vector(-1024, -6400), Vector(-704, -6176)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostiok(positionTable[i], Vector(-0.2, -1))
			end
		end)
		Timers:CreateTimer(1.0, function()
			for i = 0, 3 + GameState:GetDifficultyFactor(), 1 do
				for j = 0, 3, 1 do
					local spawnPos = Vector(1472 + i * 168, -6093 + j * 168)
					local distance = WallPhysics:GetDistance2d(spawnPos, Vector(2066, -5821))
					if distance > 200 then
						Winterblight:SpawnIceMarauader(spawnPos, Vector(-1, 0.1))
					end
				end
			end
		end)
		Timers:CreateTimer(2.0, function()
			local positionTable = {Vector(2842, -5518), Vector(3072, -5632), Vector(3248, -5440), Vector(3392, -5802), Vector(3648, -5824), Vector(3703, -5440)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnIceSummoner(positionTable[i], Vector(-0.2, -1))
			end
		end)
		Timers:CreateTimer(2.5, function()
			Winterblight:SpawnChillingColossus(Vector(3072, -6848), Vector(-1, 1))
		end)
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(-2048, -7552), Vector(-896, -6976), Vector(448, -5568), Vector(1343, -4752), Vector(2688, -6976), Vector(3648, -6592)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					for j = 0, 1, 1 do
						Timers:CreateTimer(j * 0.3, function()
							local elemental = Winterblight:Snowshaker(positionTable[i] + RandomVector(120), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
						end)
					end
				end)
			end
		end)
		Timers:CreateTimer(3, function()
			local positionTable = {Vector(2190, -4800), Vector(1984, -4544), Vector(2487, -4672), Vector(2277, -4416), Vector(2613, -4288), Vector(1984, -4072), Vector(2368, -3974)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostiok(positionTable[i], Vector(-1, -0.5))
			end
		end)
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(1152, -4224), Vector(1408, -4224), Vector(1659, -4224)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnMountainDweller(positionTable[i], Vector(0, -1))
			end
		end)
		Timers:CreateTimer(1.3, function()
			for i = 0, 5, 1 do
				Timers:CreateTimer(0.03 * i, function()
					local position = Vector(-637 + RandomInt(0, 500), -7769 + RandomInt(0, 500))
					Winterblight:SpawnMountainBeetle(position, RandomVector(1))
				end)
			end
		end)
		Timers:CreateTimer(4, function()
			for i = 0, 1, 1 do
				for j = 0, 2, 1 do
					Winterblight:SpawnMountainDweller(Vector(2768 + i * 200, -6444 + j * 200), RandomVector(1))
				end
			end
		end)
		Timers:CreateTimer(3, function()
			Winterblight:SpawnFrigidGrowth(Vector(2048, -6721), Vector(0, 1))
			Winterblight:SpawnFrigidGrowth(Vector(1730, -6823), Vector(-0.2, 1))
			Winterblight:SpawnFrigidGrowth(Vector(2176, -7040), Vector(0, 1))
		end)
	elseif luck == 3 then
		local positionTable = {Vector(-1472, -6976), Vector(-1600, -7360), Vector(-1984, -7360), Vector(-1728, -7744), Vector(-1344, -7616)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnDashingSwordsman(positionTable[i], Vector(-1, 0))
		end
		Timers:CreateTimer(1.7, function()
			local positionTable = {Vector(-1088, -6059), Vector(-960, -5989), Vector(-960, -5824), Vector(-992, -5692), Vector(-1088, -5710), Vector(-1248, -5989), Vector(-1281, -5632), Vector(-1529, -5856)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(-896, -6208) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(2.3, function()
			local positionTable = {Vector(3072, -7424), Vector(2944, -7424), Vector(2816, -7424), Vector(2521, -7668), Vector(1280, -6400), Vector(2240, -7296), Vector(2112, -7296), Vector(2112, -7168), Vector(1984, -7296), Vector(1984, -7168), Vector(2000, -7040), Vector(1882, -6912), Vector(1728, -6912), Vector(1728, -6770), Vector(1600, -6656), Vector(1600, -6784), Vector(1600, -6912)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(-896, -6208) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
			end
		end)
		for i = 0, 5 + GameState:GetDifficultyFactor(), 1 do
			for j = 0, 4, 1 do
				Timers:CreateTimer(i * 0.1, function()
					if i >= j then
						local spawnPos = Vector(-1536, -8320) + Vector(i * 140, j * 140)
						Winterblight:SpawnIceMarauader(spawnPos, Vector(0, 1))
					end
				end)
			end
		end
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(-75, -7616), Vector(128, -7869), Vector(-124, -8000), Vector(64, -8235), Vector(-192, -8384)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnMountainDweller(positionTable[i], Vector(-1, 1))
			end
		end)
		Timers:CreateTimer(0.4, function()
			local positionTable = {Vector(-2112, -7936), Vector(-1792, -6656), Vector(-256, -7040), Vector(-768, -6080)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					for j = 0, 1, 1 do
						Timers:CreateTimer(j * 0.3, function()
							local elemental = Winterblight:SpawnFrostiok(positionTable[i] + RandomVector(120), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
						end)
					end
				end)
			end
		end)
		Winterblight:SpawnChillingColossus(Vector(-768, -7006), Vector(-1, -0.3))
		Winterblight:SpawnChillingColossus(Vector(192, -5824), Vector(-1, -0.5))
		Timers:CreateTimer(2.0, function()
			local positionTable = {Vector(256, -4873), Vector(980, -5120), Vector(1174, -4864), Vector(1374, -5006), Vector(1600, -5192), Vector(1024, -5824), Vector(1280, -6071)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(1344, -5568) - positionTable[i]):Normalized()
				Winterblight:SpawnWinterbear(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(1.2, function()
			local positionTable = {Vector(1024, -5376), Vector(1792, -4800), Vector(3520, -6208), Vector(3136, -6976), Vector(1920, -6464)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					for j = 0, 1, 1 do
						Timers:CreateTimer(j * 0.3, function()
							local elemental = Winterblight:SpawnIceSummoner(positionTable[i] + RandomVector(120), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
						end)
					end
				end)
			end
		end)
		Timers:CreateTimer(3.2, function()
			local positionTable = {Vector(2240, -6208), Vector(2485, -5888), Vector(2648, -6208), Vector(2944, -6146), Vector(3200, -6379), Vector(2850, -6464), Vector(2489, -6528)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(1600, -5632) - positionTable[i]):Normalized()
				Winterblight:Snowshaker(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(3.8, function()
			local positionTable = {Vector(3428, -5760), Vector(3648, -5441), Vector(3328, -5442), Vector(3070, -5568), Vector(2816, -5376), Vector(2995, -5120)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrigidGrowth(positionTable[i], RandomVector(1))
			end
		end)
	end
	local luck2 = RandomInt(1, 3)
	if luck2 == 1 then
		local positionTable = {Vector(-2014, -7092), Vector(896, -5822), Vector(3456, -6976), Vector(4544, -5376)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				local wolfCount = 1
				for j = 0, wolfCount, 1 do
					Timers:CreateTimer(j * 2, function()
						local elemental = Winterblight:SpawnMountainCritter(positionTable[i] + RandomVector(120), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 8, 25, 240, patrolPositionTable)
					end)
				end
			end)
		end
	end
end

function Winterblight:SpawnFrostiok(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("frostiok", position, 1, 2, "Winterblight.Frostiok.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.type = ENEMY_TYPE_MINI_BOSS
	stone.itemLevel = 24
	stone.dominion = true
	return stone
end

function Winterblight:SpawnIceMarauader(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_icewrack_marauder", position, 1, 1, "Winterblight.IceMarauder.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 24
	stone.dominion = true
	stone:SetRenderColor(10, 140, 255)
	Timers:CreateTimer(0.2, function()
		if GameState:GetDifficultyFactor() < 3 then
			stone:RemoveAbility("winterblight_marauder_passive")
		end
		if GameState:GetDifficultyFactor() < 2 then
			stone:RemoveAbility("creature_black_king_bar")
		end
	end)
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate = "melee"})
	stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate = "run"})
	return stone
end

function Winterblight:SpawnChillingColossus(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_chilling_colossus", position, 2, 3, "Winterblight.FrostColossus.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 24
	stone.dominion = true
	stone:SetRenderColor(30, 90, 255)
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnNorgok(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_norgok_the_ice_rider", position, 3, 5, "Winterblight.Norgok.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.type = ENEMY_TYPE_MINI_BOSS
	stone.itemLevel = 38
	stone:SetRenderColor(30, 90, 255)
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(3)
	end
	return stone
end

function Winterblight:Snowshaker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_snow_shaker", position, 1, 2, "Winterblight.Snowshaker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 4, false)
	stone.itemLevel = 28
	Events:ColorWearablesAndBase(stone, Vector(30, 90, 255))
	Winterblight:SetPositionCastArgs(stone, 900, 0, 3, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrigidGrowth(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frigid_growth", position, 0, 2, "Winterblight.FrigidGrowth.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 4, false)
	stone.itemLevel = 29
	stone.targetRadius = 420
	stone.autoAbilityCD = 1
	stone.dominion = true
	return stone
end

function Winterblight:SpawnIceSummoner(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_ice_summoner", position, 0, 2, "Winterblight.IceSummoner.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 26
	stone.targetRadius = 1200
	stone.autoAbilityCD = 1
	stone.dominion = true
	Events:ColorWearablesAndBase(stone, Vector(70, 130, 255))
	stone.maxSummons = GameState:GetDifficultyFactor() + 1
	return stone
end

function Winterblight:SpawnIceSummon(position, fv, caster, bAggro)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_summon_a", position, 0, 2, "Winterblight.FrigidGrowth.Aggro", fv, bAggro)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 25
	stone.dominion = true
	Timers:CreateTimer(0.03, function()
		stone:SetOwner(caster)
		stone:SetTeam(caster:GetTeamNumber())
	end)
	return stone
end

function Winterblight:SpawnDashingSwordsman(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_dashing_swordsman", position, 1, 2, "Winterblight.BladeDancer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 26
	Winterblight:SetPositionCastArgs(stone, 1300, 0, 1, FIND_FARTHEST)
	stone.dominion = true
	Events:ColorWearablesAndBase(stone, Vector(80, 130, 255))
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate = "walk"})
	Timers:CreateTimer(0.03, function()
		if GameState:GetDifficultyFactor() == 1 then
			stone:RemoveAbility("creature_pure_strike")
			stone:RemoveModifierByName("modifier_pure_strike")
		end
	end)
	return stone
end

function Winterblight:StartCaveWaves()
	for i = 1, #Winterblight.CaveSpawnerIceTable, 1 do
		Winterblight:MoveObject(Winterblight.CaveSpawnerIceTable[i], Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin() + Vector(0, 0, 100), 90)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin(), 500, 15, false)
		EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin(), "Winterblight.Monolith.Shake", Winterblight.Master)
		for j = 0, 4, 1 do
			Timers:CreateTimer(0.8 * j, function()
				local pfx = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/frosty_base_statue_destruction_dire.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin() - Vector(0, 0, 80))
				Timers:CreateTimer(5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin(), "Winterblight.Monolith.Detect", Winterblight.Master)
			end)
		end
	end
	Timers:CreateTimer(2.6, function()
		for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
			Winterblight:MoveObject(Winterblight.CaveSpawnerInnerTable[i], Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin() + Vector(0, 0, 28), 140)
			EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.RiseStart", Winterblight.Master)
			EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.Rising", Winterblight.Master)
			Timers:CreateTimer(0.4, function()
				EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.Monolith.Detect", Winterblight.Master)
			end)
			Timers:CreateTimer(3.6, function()
				EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.Rise", Winterblight.Master)
			end)
			Winterblight:RotateObject(Winterblight.CaveSpawnerInnerTable[i], "right", 0.65, 150, 0)
		end
	end)
	Winterblight.caveSpawnRotate = 97.5
	Winterblight.caveSpawnRotateAccel = 0.1
	Winterblight.caveSpawnInitialSpin = true
	Timers:CreateTimer(8.0, function()
		Winterblight.CaveSpawnParticleTable = {}

		Timers:CreateTimer(0.03, function()
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				Winterblight.caveSpawnRotate = (Winterblight.caveSpawnRotate + Winterblight.caveSpawnRotateAccel) % 360
				local newAngle = Winterblight.caveSpawnRotate
				Winterblight.caveSpawnRotateAccel = math.min(Winterblight.caveSpawnRotateAccel + 0.0025, 1.8)
				Winterblight.CaveSpawnerInnerTable[i]:SetAngles(0, newAngle, 0)
			end
			if Winterblight.caveSpawnInitialSpin then
				return FrameTime()
			end
		end)

		for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
			EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.StartSpinning", Winterblight.Master)

			Timers:CreateTimer(4.0, function()
				local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/town_portal_start_lvl2_black_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(pfx, 0, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin())
				table.insert(Winterblight.CaveSpawnParticleTable, pfx)
				EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.TechStart", Winterblight.Master)
			end)
		end
	end)
	Timers:CreateTimer(14.8, function()
		local delay = 1.2 - 0.15 * GameState:GetDifficultyFactor()
		for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
			local unitName = ""
			local luck = RandomInt(1, 2)
			if luck == 1 then
				unitName = "winterblight_ice_satyr"
			elseif luck == 2 then
				unitName = "winterblight_void_spawn"
			end
			Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 13, delay, true)
		end
	end)
end

function Winterblight:SpawnCaveWaveUnit(unitName, spawnPoint, quantity, delay, bSound)

	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.WaveSpawn", Winterblight.Master)
			end
			local luck = RandomInt(1, 160)
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
				unit.dominion = true
				unit.deathCode = 1
				Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_wave_unit", {})
				unit:SetAcquisitionRange(3000)
				CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit, 2)
				unit.aggro = true
				Winterblight:AdjustWaveUnit(unit)
			else
				for i = 1, #unit.buddiesTable, 1 do
					unit.buddiesTable[i].aggro = true
					unit.buddiesTable[i].dominion = true
					unit.buddiesTable[i]:SetAcquisitionRange(3000)
					unit.buddiesTable[i].deathCode = 1
					Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit.buddiesTable[i], "modifier_winterblight_wave_unit", {})
					CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit.buddiesTable[i], 2)
					Winterblight:AdjustWaveUnit(unit.buddiesTable[i])
				end
			end
		end)
	end
end

function Winterblight:AdjustWaveUnit(unit)
	if unit:GetUnitName() == "winterblight_icetaur" then
		unit:SetRenderColor(60, 140, 250)
		if GameState:GetDifficultyFactor() == 3 then
			unit:AddAbility("ability_mega_haste")
		end
	elseif unit:GetUnitName() == "winterblight_dashing_swordsman" then
		local stone = unit
		Winterblight:SetPositionCastArgs(stone, 1300, 0, 1, FIND_FARTHEST)
		Events:ColorWearablesAndBase(stone, Vector(80, 130, 255))
		stone:AddNewModifier(stone, nil, "modifier_animation", {translate = "walk"})
		Timers:CreateTimer(0.03, function()
			if GameState:GetDifficultyFactor() == 1 then
				stone:RemoveAbility("creature_pure_strike")
				stone:RemoveModifierByName("modifier_pure_strike")
			end
		end)
	elseif unit:GetUnitName() == "winterblight_frigid_growth" then
		unit.targetRadius = 420
		unit.autoAbilityCD = 1
	elseif unit:GetUnitName() == "winterblight_frostbite_spiderling" then
		local speed = 440
		if GameState:GetDifficultyFactor() == 2 then
			speed = 380
		elseif GameState:GetDifficultyFactor() == 1 then
			speed = 300
		end
		unit:SetBaseMoveSpeed(speed)
	elseif unit:GetUnitName() == "winterblight_icewrack_marauder" then
		local stone = unit
		stone:SetRenderColor(10, 140, 255)
		Timers:CreateTimer(0.2, function()
			if GameState:GetDifficultyFactor() < 3 then
				stone:RemoveAbility("winterblight_marauder_passive")
			end
			if GameState:GetDifficultyFactor() < 2 then
				stone:RemoveAbility("creature_black_king_bar")
			end
		end)
		stone:AddNewModifier(stone, nil, "modifier_animation", {translate = "melee"})
		stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate = "run"})
	elseif unit:GetUnitName() == "winterblight_dimension_walker" then
		unit:AddNewModifier(unit, nil, "modifier_animation_translate", {translate = "run"})
	elseif unit:GetUnitName() == "winterblight_puck" then
		unit.targetRadius = 320
		unit.autoAbilityCD = 1
	elseif unit:GetUnitName() == "frost_whelpling" then
		Winterblight:SetPositionCastArgs(unit, 900, 0, 3, FIND_ANY_ORDER)
	elseif unit:GetUnitName() == "winterblight_azalean_priest" then
		Events:ColorWearablesAndBase(unit, Vector(90, 150, 255))
		Winterblight:SetTargetCastArgs(unit, 600 + GameState:GetDifficultyFactor() * 200, 0, 2, FIND_ANY_ORDER)
	elseif unit:GetUnitName() == "winterblight_frost_avatar" then
		if GameState:GetDifficultyFactor() == 3 then
			unit:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
		end
		unit:SetRenderColor(200, 210, 255)
	elseif unit:GetUnitName() == "winterblight_azure_sorceress" then
		if GameState:GetDifficultyFactor() == 3 then
			unit:AddAbility("seafortress_golden_shell"):SetLevel(3)
		end
	elseif unit:GetUnitName() == "winterblight_rider_of_azalea" then
		if GameState:GetDifficultyFactor() < 3 then
			unit:RemoveAbility("armor_break_ultra")
		end
	elseif unit:GetUnitName() == "winterblight_source_revenant" then
		unit:SetMana(0)
	end
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_Winterblight_unit", {})
end

function Winterblight:FinishCaveWaves()
	Winterblight.caveSpawnInitialSpin = false
	Timers:CreateTimer(0.09, function()
		for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
			Winterblight.caveSpawnRotate = (Winterblight.caveSpawnRotate + Winterblight.caveSpawnRotateAccel) % 360
			local newAngle = Winterblight.caveSpawnRotate
			Winterblight.caveSpawnRotateAccel = Winterblight.caveSpawnRotateAccel - 0.0025
			Winterblight.CaveSpawnerInnerTable[i]:SetAngles(0, newAngle, 0)
		end
		if Winterblight.caveSpawnRotateAccel > 0 then
			return FrameTime()
		else
			--print("REMOVE PARTICLES")
			for i = 1, #Winterblight.CaveSpawnParticleTable, 1 do
				ParticleManager:DestroyParticle(Winterblight.CaveSpawnParticleTable[i], false)
			end
			for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
				EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.TechEnd", Winterblight.Master)
			end
		end
	end)
	Timers:CreateTimer(5, function()
		Timers:CreateTimer(4, function()
			Winterblight.CaveIceWallDestroyed = true
		end)
		local walls = Entities:FindAllByNameWithin("CaveWall", Vector(3770, -7423, 128 + Winterblight.ZFLOAT), 1800)
		Winterblight:Walls(false, walls, true, 4.3)
		Winterblight:RemoveBlockers(4, "CaveWallBlocker", Vector(3770, -7423, 128 + Winterblight.ZFLOAT), 1400)
		Winterblight:FirstOutsideAzaleaPocketSpawn()
	end)
	Timers:CreateTimer(6, function()
		Winterblight:InitializeAzaleaSwords()
	end)
end

function Winterblight:FirstOutsideAzaleaPocketSpawn()
	if Winterblight.FirstAzaleaPocketSpawned then
		return false
	end
	Winterblight.FirstAzaleaPocketSpawned = true
	local luck = RandomInt(1, 3)
	if luck == 1 then
		local positionTable = {Vector(4672, -7616), Vector(4864, -7762), Vector(5100, -7847)}
		for i = 1, #positionTable, 1 do
			local lookToPoint = (Vector(4717, -8205) - positionTable[i]):Normalized()
			Winterblight:SpawnWinterAssasin(positionTable[i], lookToPoint)
		end

		Winterblight:SpawnFrigidGrowth(Vector(4992, -7424) + RandomVector(60), RandomVector(1))
		Winterblight:SpawnFrigidGrowth(Vector(5371, -7290) + RandomVector(60), RandomVector(1))
		Winterblight:SpawnFrigidGrowth(Vector(5696, -7360) + RandomVector(60), RandomVector(1))
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(3072, -8448), Vector(3349, -8204)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(3500, -8635) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(1.7, function()
			local positionTable = {Vector(3774, -8704), Vector(3712, -8850), Vector(3861, -8849), Vector(3830, -8995), Vector(4032, -8982), Vector(4032, -8767), Vector(4224, -8877), Vector(4272, -9099), Vector(4414, -9152), Vector(4544, -9152), Vector(4688, -9077), Vector(4480, -8976), Vector(4666, -8896), Vector(4478, -8768)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(4288, -8384) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(1.9, function()
			local positionTable = {Vector(6080, -8640), Vector(6363, -8804), Vector(6592, -8913), Vector(6848, -9018), Vector(7296, -9018), Vector(7637, -8907)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(6912, -8256) - positionTable[i]):Normalized()
				local unit = Winterblight:SpawnRiderOfAzalea(positionTable[i], lookToPoint)
				CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", unit, 2)
			end
		end)
		Winterblight:SpawnChillingColossus(Vector(4979, -8896), Vector(-0.2, 1))
	elseif luck == 2 then
		local positionTable = {Vector(3776, -8384), Vector(4096, -8256), Vector(4203, -8730), Vector(4544, -8512), Vector(4864, -8768)}
		for i = 1, #positionTable, 1 do
			local lookToPoint = (Vector(4512, -8056) - positionTable[i]):Normalized()
			Winterblight:SpawnColdSeer(positionTable[i], lookToPoint)
		end
		Winterblight:SpawnFrigidGrowth(Vector(3798, -8490) + RandomVector(60), RandomVector(1))
		Winterblight:SpawnFrigidGrowth(Vector(3559, -8576) + RandomVector(60), RandomVector(1))
		Winterblight:SpawnChillingColossus(Vector(4541, -7596), Vector(-0.2, -1))

		Winterblight:SpawnFrostElemental(Vector(4160, -9088), Vector(0, -1))
		Winterblight:SpawnFrostElemental(Vector(4672, -9088), Vector(0, -1))
		Winterblight:SpawnFrostElemental(Vector(4416, -9088), Vector(0, -1))
		Timers:CreateTimer(1.3, function()
			local positionTable = {Vector(5248, -8896), Vector(5440, -8576), Vector(5632, -8832), Vector(5888, -8512)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(5440, -8064) - positionTable[i]):Normalized()
				local unit = Winterblight:SpawnRiderOfAzalea(positionTable[i], lookToPoint)
				CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", unit, 2)
			end
		end)
		Timers:CreateTimer(1.7, function()
			local positionTable = {Vector(5824, -7808), Vector(6039, -7488), Vector(6273, -7744), Vector(6273, -7232)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(6144, -8128) - positionTable[i]):Normalized()
				local unit = Winterblight:SpawnAzaleaSorceress(positionTable[i], lookToPoint)
				CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", unit, 2)
			end
		end)
		local positionTable = {Vector(4096, -8704), Vector(6720, -8064)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				for j = 0, 1, 1 do
					Timers:CreateTimer(j * 0.55, function()
						local elemental = Winterblight:SpawnFrostAvatar(positionTable[i] + RandomVector(60), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
					end)
				end
			end)
		end
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(4992, -7424), Vector(5248, -7616), Vector(5248, -7352), Vector(5468, -7699), Vector(5440, -7488), Vector(5586, -7352), Vector(5673, -7532), Vector(5844, -7616)}
			for i = 1, #positionTable, 1 do
				if i < GameState:GetDifficultyFactor() * 3 + 1 then
					local lookToPoint = (Vector(5468, -7903) - positionTable[i]):Normalized()
					Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
				end
			end
		end)
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(6980, -8960), Vector(7232, -8888), Vector(7479, -9024), Vector(6851, -8632), Vector(7128, -8545), Vector(7424)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(7232, -9408) - positionTable[i]):Normalized()
				local unit = Winterblight:SpawnColdSeer(positionTable[i], RandomVector(1))
				CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", unit, 2)
			end
		end)
	elseif luck == 3 then
		local positionTable = {Vector(5120, -9024), Vector(5376, -8903), Vector(5632, -8753)}
		for i = 1, #positionTable, 1 do
			local lookToPoint = (Vector(5271, -8443) - positionTable[i]):Normalized()
			local unit = Winterblight:SpawnDashingSwordsman(positionTable[i], lookToPoint)
			CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", unit, 2)
		end
		local positionTable = {Vector(3776, -8512), Vector(3776, -8768), Vector(4096, -8512), Vector(4398, -8512), Vector(4096, -8768), Vector(4398, -8768)}
		for i = 1, #positionTable, 1 do
			local unit = Winterblight:SpawnSoftwalker(positionTable[i], Vector(0, 1))
		end
		local positionTable = {Vector(4224, -9088), Vector(4544, -9088), Vector(4846, -8896)}
		for i = 1, #positionTable, 1 do
			local unit = Winterblight:SpawnPriestOfAzalea(positionTable[i], Vector(0, -1))
		end
		Timers:CreateTimer(1.2, function()
			for i = 0, 4, 1 do
				Winterblight:SpawnFrostHulk(Vector(5312, -8704 + i * 256), Vector(-1, 0))
			end
			if GameState:GetDifficultyFactor() >= 2 then
				for i = 0, 2, 1 do
					Winterblight:SpawnFrostHulk(Vector(5504, -8448 + i * 256), Vector(-1, 0))
				end
			end
			if GameState:GetDifficultyFactor() >= 3 then
				Winterblight:SpawnFrostHulk(Vector(5696, -8192), Vector(-1, 0))
			end
		end)
		local positionTable = {Vector(6044, -8640), Vector(5696, -7360), Vector(6528, -7744)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				for j = 0, 1, 1 do
					Timers:CreateTimer(j * 0.35, function()
						local elemental = Winterblight:SpawnFrostElemental(positionTable[i] + RandomVector(60), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
					end)
				end
			end)
		end
		Timers:CreateTimer(2.0, function()
			local positionTable = {Vector(5824, -7824), Vector(6080, -7543), Vector(5888, -7415), Vector(6144, -7168)}
			for i = 1, #positionTable, 1 do
				if i < GameState:GetDifficultyFactor() + 2 then
					Winterblight:SpawnWinterAssasin(positionTable[i], RandomVector(1))
				end
			end
		end)
		Timers:CreateTimer(2.2, function()
			local positionTable = {Vector(6784, -8896), Vector(7040, -8781), Vector(7296, -8682), Vector(7238, -8960), Vector(7488, -8960)}
			for i = 1, #positionTable, 1 do
				local unit = Winterblight:SpawnIceSummoner(positionTable[i], RandomVector(1))
			end
		end)
		Winterblight:SpawnFrigidGrowth(Vector(6660, -7716) + RandomVector(60), RandomVector(1))
		Winterblight:SpawnFrigidGrowth(Vector(6400, -7104) + RandomVector(60), RandomVector(1))
	end
end

function Winterblight:SpawnWinterAssasin(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mistral_assassin", position, 0, 2, "Winterblight.MistralAssassin.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 31
	stone.dominion = true
	-- Timers:CreateTimer(0.03, function()
	-- if GameState:GetDifficultyFactor() == 1 then
	-- end
	-- end)
	-- Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	return stone
end

function Winterblight:SpawnFrostOrchid(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_orchid", position, 0, 0, nil, fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 31
	stone.dominion = true
	stone:SetAbsOrigin(stone:GetAbsOrigin() - Vector(0, 0, 40))
	-- Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	return stone
end

function Winterblight:SpawnWinterbear(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_winterbear", position, 0, 0, "Winterblight.Winterbear.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 31
	stone.dominion = true
	-- Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	return stone
end

function Winterblight:SpawnRiderOfAzalea(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_rider_of_azalea", position, 1, 1, "Winterblight.RiderOfAzalea.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	stone.itemLevel = 33
	stone.dominion = true
	if GameState:GetDifficultyFactor() < 3 then
		stone:RemoveAbility("armor_break_ultra")
	end
	return stone
end

function Winterblight:AzaleaMainSpawn()
	local luck = RandomInt(1, 3)

	if luck == 1 then
		local count = 1
		if GameState:GetDifficultyFactor() == 3 then
			count = 2
		end
		local positionTable = {Vector(7296, -7744), Vector(8448, -6208), Vector(9664, -6912), Vector(11008, -6208), Vector(12544, -6976), Vector(14464, -8256)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				for j = 0, count, 1 do
					Timers:CreateTimer(j * 0.8, function()
						local elemental = Winterblight:SpawnDashingSwordsman(positionTable[i] + RandomVector(350), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
					end)
				end
			end)
		end
		Timers:CreateTimer(0.6, function()
			local count = 0
			if GameState:GetDifficultyFactor() == 3 then
				count = 1
			end
			local positionTable = {Vector(7744, -5913), Vector(9280, -7424), Vector(11456, -6272), Vector(11494, -7901), Vector(12736, -8256), Vector(14592, -6912)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					for j = 0, count, 1 do
						Timers:CreateTimer(j * 0.55, function()
							local elemental = Winterblight:SpawnRiderOfAzalea(positionTable[i] + RandomVector(350), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
						end)
					end
				end)
			end
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(7104, -7808), Vector(7552, -8320), Vector(8192, -8256)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostElemental(positionTable[i], RandomVector(1))
			end
		end)
		Timers:CreateTimer(3, function()
			local positionTable = {Vector(8128, -7232), Vector(8512, -7104), Vector(8448, -7488), Vector(8000, -7552)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaSorceress(positionTable[i], RandomVector(1))
			end
		end)
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(9792, -5248), Vector(10240, -5056), Vector(10880, -5056), Vector(11456, -5056), Vector(11968, -5120), Vector(12416, -5376)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostAvatar(positionTable[i], Vector(0, -1))
			end
		end)
		Timers:CreateTimer(3.15, function()
			local positionTable = {Vector(9344, -7360), Vector(9024, -6272), Vector(9856, -5952), Vector(10304, -7232), Vector(11328, -7424), Vector(11904, -7104), Vector(12480, -6336), Vector(12352, -5504), Vector(13376, -6080), Vector(14464, -6464)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostElemental(positionTable[i], RandomVector(1))
			end

		end)
		Timers:CreateTimer(2.1, function()
			local positionTable = {Vector(6421, -6912), Vector(6666, -6848), Vector(6912, -6848), Vector(7006, -6720), Vector(6720, -6656), Vector(6424, -6656), Vector(6606, -6464), Vector(6858, -6464), Vector(7114, -6464), Vector(6757, -6272), Vector(7027, -6234)}
			for i = 1, #positionTable, 1 do
				if i < 6 + GameState:GetDifficultyFactor() * 4 then
					local lookToPoint = (Vector(7488, -7104) - positionTable[i]):Normalized()
					Winterblight:SpawnIceSummoner(positionTable[i], lookToPoint)
				end
			end
			Winterblight:SpawnChillingColossus(Vector(8000, -5824), Vector(0.1, -1))
		end)
		Timers:CreateTimer(4.2, function()
			local positionTable = {Vector(10688, -7744), Vector(10688, -8192), Vector(11456, -7744), Vector(11456, -8192)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostHulk(positionTable[i], Vector(0, 1))
			end
			Winterblight:SpawnFrostHulk(Vector(15168, -7168), Vector(-1, 0))
		end)
		Timers:CreateTimer(4.7, function()
			local positionTable = {Vector(14775, -8468), Vector(15104, -8320), Vector(14720, -8064), Vector(14976, -7808), Vector(15360, -7488)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnPriestOfAzalea(positionTable[i], RandomVector(1))
			end
		end)
		Timers:CreateTimer(5.2, function()
			local positionTable = {Vector(10944, -5766), Vector(10688, -6144), Vector(11136, -6400), Vector(11520, -6016)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaSorceress(positionTable[i], RandomVector(1))
			end
		end)
		Timers:CreateTimer(5.7, function()
			local positionTable = {Vector(13312, -7104), Vector(13384, -7552), Vector(13894, -7296), Vector(13824, -7668)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnAzaleaSorceress(positionTable[i], RandomVector(1))
			end
		end)
		Timers:CreateTimer(5.9, function()
			local positionTable = {Vector(11840, -8448), Vector(12104, -8640), Vector(12480, -8640)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(12224, -8128) - positionTable[i]):Normalized()
				Winterblight:SpawnPriestOfAzalea(positionTable[i], lookToPoint)
			end
			Winterblight:SpawnChillingColossus(Vector(8000, -5824), Vector(0.1, -1))
		end)
		Timers:CreateTimer(6.3, function()
			local positionTable = {Vector(14976, -5376), Vector(15232, -5312), Vector(15424, -5568), Vector(15168, -5760), Vector(15424, -5952)}
			for i = 1, #positionTable, 1 do
				if i < GameState:GetDifficultyFactor() + 3 then
					local lookToPoint = (Vector(14923, -6137) - positionTable[i]):Normalized()
					Winterblight:SpawnFrostAvatar(positionTable[i], lookToPoint)
				end
			end
			Winterblight:SpawnChillingColossus(Vector(15168, -6336), Vector(-1, 0))
			Winterblight:SpawnWinterAssasin(Vector(14427, -8640), Vector(0, -1))
			Winterblight:SpawnWinterAssasin(Vector(14080, -8832), Vector(0, -1))
		end)
	elseif luck == 2 then
		local count = 1
		if GameState:GetDifficultyFactor() == 3 then
			count = 2
		end
		local positionTable = {Vector(6464, -6592), Vector(6935, -8075), Vector(7680, -6455), Vector(8891, -7680), Vector(9384, -6336), Vector(10752, -7479), Vector(11268, -5440), Vector(11776, -6985), Vector(12352, -5909), Vector(12864, -7725), Vector(14208, -6969), Vector(14976, -7743)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				for j = 0, count, 1 do
					Timers:CreateTimer(j * 0.8, function()
						local elemental = Winterblight:SpawnFrostWhelpling(positionTable[i] + RandomVector(350), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
					end)
				end
			end)
		end
		Timers:CreateTimer(0.5, function()
			Winterblight:SpawnColdSeer(Vector(7808, -8448), Vector(0, 1))
			Winterblight:SpawnColdSeer(Vector(8064, -8448), Vector(0, 1))
			Winterblight:SpawnColdSeer(Vector(8369, -8448), Vector(0, 1))
			Winterblight:SpawnColdSeer(Vector(8640, -8448), Vector(0, 1))

			Winterblight:SpawnRiderOfAzalea(Vector(8192, -7096), RandomVector(1))
			Winterblight:SpawnRiderOfAzalea(Vector(8064, -7488), RandomVector(1))
			Winterblight:SpawnRiderOfAzalea(Vector(8384, -7419), RandomVector(1))
		end)
		Timers:CreateTimer(1, function()
			local positionTable = {Vector(6528, -6464), Vector(6793, -6720), Vector(7222, -6720), Vector(7499, -6294), Vector(7221, -6080), Vector(7040, -6393), Vector(6793, -6208), Vector(6528, -6464)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(7168, -7168) - positionTable[i]):Normalized()
				Winterblight:SpawnPriestOfAzalea(positionTable[i], lookToPoint)
			end
			Winterblight:SpawnChillingColossus(Vector(8083, -5888), Vector(0, -1))
			Winterblight:SpawnChillingColossus(Vector(7680, -5696), Vector(1, -1))
			local positionTable = {Vector(9620, -5056), Vector(9152, -5056), Vector(9408, -4867)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostAvatar(positionTable[i], Vector(0, -1))
			end
		end)
		Timers:CreateTimer(1.3, function()
			local positionTable = {Vector(10496, -5824), Vector(10701, -6144), Vector(11072, -6444), Vector(11524, -6175), Vector(11646, -5760), Vector(11088, -5669)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (positionTable[i] - Vector(11123, -6082)):Normalized()
				Winterblight:SpawnSoftwalker(positionTable[i], lookToPoint)
			end
			local positionTable = {Vector(10240, -5120), Vector(10816, -5029), Vector(11392, -5029), Vector(12096, -5077)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostHulk(positionTable[i], Vector(0, -1))
			end
		end)
		Timers:CreateTimer(1.7, function()
			local positionTable = {Vector(12800, -6172), Vector(12366, -6172), Vector(12657, -5888), Vector(12288, -5760), Vector(12527, -5568), Vector(12774, -5312)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostElemental(positionTable[i], RandomVector(1))
			end
			Winterblight:SpawnChillingColossus(Vector(12352, -6848), Vector(-1, 0.2))
		end)
		Timers:CreateTimer(1.9, function()
			local positionTable = {Vector(13248, -6528), Vector(13488, -6144), Vector(13749, -6400), Vector(14016, -6592), Vector(14080, -6223), Vector(14311, -6528)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostAvatar(positionTable[i], Vector(-1, -1))
			end
		end)
		Timers:CreateTimer(2.1, function()
			local positionTable = {Vector(13312, -7162), Vector(13312, -7552), Vector(13517, -7808), Vector(13576, -7104), Vector(13888, -7424), Vector(13888, -7808)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(13680, -7175) - positionTable[i]):Normalized()
				Winterblight:SpawnPriestOfAzalea(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(2.3, function()
			local positionTable = {Vector(10764, -7872), Vector(10624, -7616), Vector(10880, -7616)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnColdSeer(positionTable[i], Vector(0, 1))
			end
			for i = 0, 2, 1 do
				for j = 0, 2, 1 do
					Winterblight:SpawnRiderOfAzalea(Vector(11456 + i * 256, -8128 + j * 256), Vector(0, 1))
				end
			end
		end)
		Timers:CreateTimer(2.7, function()
			local positionTable = {Vector(11904, -8576), Vector(12160, -8576), Vector(12416, -8576), Vector(12662, -8576)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnWinterAssasin(positionTable[i], Vector(0, -1))
			end
		end)
		Timers:CreateTimer(3.0, function()
			local positionTable = {Vector(13632, -8448), Vector(14336, -6848), Vector(15168, -7827)}
			for i = 1, #positionTable, 1 do
				Timers:CreateTimer(i * 1.2, function()
					local patrolPositionTable = {}
					for j = 1, #positionTable, 1 do
						local index = i + j
						if index > #positionTable then
							index = index - #positionTable
						end
						table.insert(patrolPositionTable, positionTable[index])
					end
					for j = 0, 1, 1 do
						Timers:CreateTimer(j * 0.8, function()
							local elemental = Winterblight:SpawnDashingSwordsman(positionTable[i] + RandomVector(350), RandomVector(1))
							Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
						end)
					end
				end)
			end
		end)
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(14848, -8192), Vector(15232, -8192), Vector(14848, -7744), Vector(14848, -7168), Vector(15232, -7168)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostHulk(positionTable[i], Vector(0, -1))
			end
			Winterblight:SpawnChillingColossus(Vector(15296, -8512), Vector(-1, 1))
		end)
		Timers:CreateTimer(3.9, function()
			Winterblight:SpawnIceSummoner(Vector(15263, -6080), Vector(-1, -1))
			Winterblight:SpawnIceSummoner(Vector(15040, -6336), Vector(-1, -1))
			Winterblight:SpawnIceSummoner(Vector(15360, -6447), Vector(-1, -1))
			Winterblight:SpawnChillingColossus(Vector(15232, -5504), Vector(0, -1))
		end)
		Timers:CreateTimer(4.1, function()
			local positionTable = {Vector(9152, -7043), Vector(9152, -6784), Vector(9152, -6464), Vector(9408, -7043), Vector(9472, -6720), Vector(9472, -6393), Vector(9626, -6305), Vector(9758, -6602), Vector(9866, -6912)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(8576, -6976) - positionTable[i]):Normalized()
				Winterblight:SpawnPriestOfAzalea(positionTable[i], lookToPoint)
			end
			Winterblight:SpawnChillingColossus(Vector(-14080, -8704), Vector(-1, 1))
		end)
		Timers:CreateTimer(4.5, function()
			local positionTable = {Vector(14720, -8600), Vector(14912, -8640), Vector(14950, -8448), Vector(15104, -8544), Vector(15254, -8640), Vector(15360, -8512), Vector(15540, -8621)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(14565, -8000) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
			end
		end)
	elseif luck == 3 then
		Timers:CreateTimer(0.1, function()
			local positionTable = {Vector(6912, -7976), Vector(6656, -7744), Vector(6904, -7667), Vector(7168, -7765), Vector(7104, -7418), Vector(6894, -7296), Vector(6679, -7360), Vector(6777, -7040), Vector(7040, -6938)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(6144, -7872) - positionTable[i]):Normalized()
				Winterblight:SpawnAzaleaSorceress(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(0.3, function()
			local positionTable = {Vector(6464, -6528), Vector(6784, -6232), Vector(7114, -5976)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(7104, -6528) - positionTable[i]):Normalized()
				Winterblight:SpawnAzaleaSorceress(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(8064, -7475), Vector(8320, -7552), Vector(8595, -7296), Vector(8064, -7065), Vector(8384, -6917)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (positionTable[i] - Vector(8287, -7175)):Normalized()
				Winterblight:SpawnAzaleaArcher(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(0.8, function()
			local positionTable = {Vector(8000, -8384), Vector(8320, -8244), Vector(8586, -8365), Vector(8640, -8000)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnSoftwalker(positionTable[i], Vector(-1, 0))
			end
		end)
		Timers:CreateTimer(1.1, function()
			local positionTable = {Vector(7424, -5977), Vector(7609, -5760), Vector(7800, -5952), Vector(8003, -5696), Vector(8167, -5948)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(7744, -6336) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostElemental(positionTable[i], lookToPoint)
			end
			local positionTable = {Vector(8512, -6208), Vector(8768, -6400), Vector(9029, -6272)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnPriestOfAzalea(positionTable[i], RandomVector(1))
			end
			Winterblight:SpawnChillingColossus(Vector(9344, -8960), Vector(-1, 1))
			Winterblight:SpawnFrostElemental(Vector(9600, -8448), RandomVector(1))
			Winterblight:SpawnFrostElemental(Vector(9955, -8361), RandomVector(1))
			Winterblight:SpawnFrostElemental(Vector(9769, -8000), RandomVector(1))
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(12608, -6400), Vector(12864, -6302), Vector(13120, -6268), Vector(13368, -6196), Vector(13156, -6034), Vector(12928, -5952), Vector(12528, -6052), Vector(12608, -5632)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(12096, -6565) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostiok(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(1.8, function()
			local positionTable = {Vector(9920, -5090), Vector(10221, -4976), Vector(10575, -5120), Vector(10880, -4976), Vector(11328, -5039), Vector(11648, -5110), Vector(11968, -4992)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnColdSeer(positionTable[i], Vector(0, -1))
			end
			Winterblight:SpawnFrigidGrowth(Vector(9344, -5120), RandomVector(1))
		end)
		Timers:CreateTimer(2.1, function()
			local positionTable = {Vector(11904, -8704), Vector(12292, -8704), Vector(12609, -8640), Vector(12429, -8448), Vector(12609, -8256), Vector(12928, -8095), Vector(12862, -8448), Vector(13100, -8640)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(11968, -7872) - positionTable[i]):Normalized()
				Winterblight:SpawnFrostAvatar(positionTable[i], lookToPoint)
			end
		end)
		Timers:CreateTimer(2.3, function()
			local positionTable = {Vector(11136, -6498), Vector(11007, -6208), Vector(10752, -6272), Vector(11392, -6208), Vector(11598, -6016), Vector(11453, -5760), Vector(10944, -5656), Vector(10539, -5888)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostHulk(positionTable[i], Vector(0, -1))
			end
		end)
		Timers:CreateTimer(2.6, function()
			local positionTable = {Vector(11328, -8064), Vector(11504, -7744), Vector(11729, -7424), Vector(11566, -8215), Vector(11743, -7986), Vector(11986, -7575), Vector(11801, -8400), Vector(11977, -8080), Vector(12203, -7760), Vector(12047, -8571), Vector(12223, -8251), Vector(12448, -7931)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnRiderOfAzalea(positionTable[i], Vector(-1, 1))
			end
		end)
		Timers:CreateTimer(2.8, function()
			local positionTable = {Vector(13509, -8320), Vector(13841, -8576), Vector(14129, -8320), Vector(14424, -8597), Vector(9000, -6720), Vector(9344, -7040), Vector(9206, -6336), Vector(9553, -6720), Vector(9803, -6976), Vector(9921, -6592)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnSoftwalker(positionTable[i], RandomVector(1))
			end
		end)
		Timers:CreateTimer(3.0, function()
			local positionTable = {Vector(10624, -8128), Vector(10880, -7989), Vector(10688, -7820), Vector(10493, -7552), Vector(10944, -7513)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnWinterAssasin(positionTable[i], Vector(0, 1))
			end
		end)
		Timers:CreateTimer(3.2, function()
			local positionTable = {Vector(13312, -5504), Vector(13696, -5293), Vector(14016, -5503), Vector(14464, -5701)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostElemental(positionTable[i], RandomVector(1))
			end
		end)
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(13376, -7297), Vector(13312, -7616), Vector(13568, -7828), Vector(13888, -7828), Vector(13975, -7552), Vector(13975, -7232), Vector(13632, -7067)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (positionTable[i] - Vector(13680, -7175)):Normalized()
				Winterblight:SpawnAzaleaArcher(positionTable[i], lookToPoint)
			end
		end)
		local positionTable = {Vector(7296, -7744), Vector(8448, -6208), Vector(9664, -6912), Vector(11008, -6208), Vector(12544, -6976), Vector(14464, -8256)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i * 1.2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				for j = 0, 1, 1 do
					Timers:CreateTimer(j * 0.8, function()
						local elemental = Winterblight:SpawnColdSeer(positionTable[i] + RandomVector(350), RandomVector(1))
						Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
					end)
				end
			end)
		end
		Timers:CreateTimer(4, function()
			Winterblight:SpawnChillingColossus(Vector(13824, -6272), Vector(-1, -0.2))
			local positionTable = {Vector(15063, -8512), Vector(14848, -8256), Vector(15424, -8320), Vector(15232, -8049), Vector(14656, -7886), Vector(14976, -7809), Vector(15296, -7614), Vector(14836, -7424), Vector(15081, -7232), Vector(14855, -6976), Vector(14693, -6720), Vector(15104, -6592), Vector(15424, -6850)}
			local unitTable = {"winterblight_softwalker", "winterblight_cold_seer", "winterblight_winterbear", "winterblight_azalea_archer", "winterblight_azure_sorceress", "frost_whelpling", "winterblight_frost_avatar", "winterblight_frost_elemental", "winterblight_rider_of_azalea", "winterblight_azalean_priest", "winterblight_mistral_assassin", "winterblight_frost_frigid_hulk", "winterblight_ice_summoner"}
			for i = 1, #positionTable, 1 do
				local unitName = unitTable[RandomInt(1, #unitTable)]
				if unitName == "winterblight_softwalker" then
					Winterblight:SpawnSoftwalker(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_cold_seer" then
					Winterblight:SpawnColdSeer(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_winterbear" then
					Winterblight:SpawnWinterbear(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_azalea_archer" then
					Winterblight:SpawnAzaleaArcher(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_azure_sorceress" then
					Winterblight:SpawnAzaleaSorceress(positionTable[i], RandomVector(1))
				elseif unitName == "frost_whelpling" then
					Winterblight:SpawnFrostWhelpling(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_frost_avatar" then
					Winterblight:SpawnFrostAvatar(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_frost_elemental" then
					Winterblight:SpawnFrostElemental(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_rider_of_azalea" then
					Winterblight:SpawnRiderOfAzalea(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_azalean_priest" then
					Winterblight:SpawnPriestOfAzalea(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_mistral_assassin" then
					Winterblight:SpawnWinterAssasin(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_frost_frigid_hulk" then
					Winterblight:SpawnFrostHulk(positionTable[i], RandomVector(1))
				elseif unitName == "winterblight_ice_summoner" then
					Winterblight:SpawnIceSummoner(positionTable[i], RandomVector(1))
				end
			end
			Winterblight:SpawnChillingColossus(Vector(12096, -6912) + RandomVector(RandomInt(10, 400)), Vector(-1, 0))
		end)
		Timers:CreateTimer(1.5, function()
			local positionTable = {Vector(14976, -5324), Vector(15168, -5504), Vector(15424, -5504), Vector(15168, -5824), Vector(15424, -5824), Vector(15168, -6167)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostAvatar(positionTable[i], Vector(-1, 0))
			end
		end)
	end
end

function Winterblight:SpawnAzaleaArcher(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_archer", position, 0, 1, "Winterblight.AzaleaArcher.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 2, false)
	stone.itemLevel = 37
	stone.dominion = true
	return stone
end

function Winterblight:SpawnAzaleaSorceress(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azure_sorceress", position, 1, 2, "Winterblight.AzaleaSorceress.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("seafortress_golden_shell"):SetLevel(3)
	end
	stone.itemLevel = 37
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrostAvatar(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_avatar", position, 0, 2, "Winterblight.IceSpecter.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	stone.itemLevel = 37
	stone.dominion = true
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	stone:SetRenderColor(200, 210, 255)
	return stone
end

function Winterblight:SpawnFrostElemental(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_elemental", position, 1, 2, "Winterblight.FrostElemental.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 4, false)
	stone.itemLevel = 39
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrostHulk(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_frigid_hulk", position, 1, 3, "Winterblight.FrostHulk.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 6, false)
	stone.itemLevel = 41
	stone.dominion = true
	stone:SetRenderColor(200, 210, 255)
	return stone
end

function Winterblight:SpawnPriestOfAzalea(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalean_priest", position, 0, 2, "Winterblight.Priest.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 28
	Events:ColorWearablesAndBase(stone, Vector(90, 150, 255))
	Winterblight:SetTargetCastArgs(stone, 600 + GameState:GetDifficultyFactor() * 200, 0, 2, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Winterblight:InitializeAzaleaSwords()
	local positionTable = {Vector(9280, -7360), Vector(12019, -7872), Vector(15040, -6976)}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer((i - 1) * 4.5, function()
			local position = positionTable[i]
			local yaw = 45
			local shield = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			local yaw = RandomInt(0, 345)

			shield:SetAngles(0, yaw, 0)
			shield:SetRenderColor(180, 210, 255)
			shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
			shield:SetOriginalModel("models/winterblight/winter_sword.vmdl")
			shield:SetModel("models/winterblight/winter_sword.vmdl")
			shield:SetAbsOrigin(position)
			shield:AddAbility("winterblight_attackable_unit"):SetLevel(1)
			shield:RemoveAbility("dummy_unit")
			shield:RemoveModifierByName("dummy_unit")
			shield.basePosition = position

			shield.yaw = yaw

			shield.pushLock = true
			shield.dummy = true
			shield.jumpLock = true
			AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 500, 99999, false)
			shield.acceleration = 35
			shield:SetAbsOrigin(shield:GetAbsOrigin() + Vector(0, 0, 2600))

			local prop_ability = shield:FindAbilityByName("winterblight_attackable_unit")
			prop_ability:ApplyDataDrivenModifier(shield, shield, "modifier_icy_appearance", {})
			prop_ability:ApplyDataDrivenModifier(shield, shield, "modifier_sword_falling", {})
			shield.prop_id = 0
		end)
	end

end

function Winterblight:SpawnFrostTitan(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_frost_titan", position, 3, 5, "Winterblight.FrostTitan.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 6, false)
	stone.itemLevel = 46
	stone.type = ENEMY_TYPE_MINI_BOSS
	Events:ColorWearablesAndBase(stone, Vector(200, 210, 255))
	Winterblight:SetTargetCastArgs(stone, 1000 + GameState:GetDifficultyFactor() * 500, 0, 1, FIND_ANY_ORDER)
	local passive = stone:FindAbilityByName("frost_titan_passive")
	passive:ApplyDataDrivenModifier(stone, stone, "modifier_disable_player", {duration = 1.5})
	return stone
end

function Winterblight:StartOrbSequence()
	Winterblight.OrbTable = {}
	local particleName = "particles/roshpit/winterblight/azalea_orb.vpcf"
	local basePos = Vector(7620, -8671)
	local topRightPos = GetGroundPosition(Vector(15417, -5454), Events.GameMaster)
	local differenceI = (topRightPos.x - basePos.x) / 10
	local differenceJ = (topRightPos.y - basePos.y) / 3
	for i = 1, 10, 1 do
		for j = 1, 3, 1 do
			Timers:CreateTimer(0.3 * (i - 1) + (j - 1) * 3, function()
				local orbPos = GetGroundPosition(basePos + Vector(differenceI * (i - 0.5) + RandomInt(-200, 200), differenceJ * (j - 0.5) + RandomInt(-400, 400)), Events.GameMaster)
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
				--print(orbPos)
				local startHeight = 900 + RandomInt(0, 200)
				local endHeight = 380 + RandomInt(0, 210)
				ParticleManager:SetParticleControl(pfx, 0, orbPos + Vector(0, 0, startHeight))
				ParticleManager:SetParticleControl(pfx, 1, orbPos + Vector(0, 0, endHeight))
				ParticleManager:SetParticleControl(pfx, 2, Vector(100, 100, 100))
				ParticleManager:SetParticleControl(pfx, 3, Vector(100, 100, 100))
				local orb = {}
				orb.pfx = pfx
				orb.endPos = orbPos + Vector(0, 0, endHeight)
				orb.index = i + j * 100
				-- AddFOWViewer(DOTA_TEAM_GOODGUYS,orbPos, 300, 600, false)
				table.insert(Winterblight.OrbTable, orb)
			end)
		end
	end
	Timers:CreateTimer(1, function()
		EmitGlobalSound("Winterblight.AzaleaOrbs.Start")
	end)
	Winterblight.StatuesTable = {}
	local positionTable = {Vector(8288, -7175), Vector(11123, -6082), Vector(13680, -7175)}
	for i = 1, #positionTable, 1 do
		local statue = {}
		statue.prop = Entities:FindByNameNearest("RadiantTower", positionTable[i] + Vector(0, 0, 300), 1000)
		statue.position = statue.prop:GetAbsOrigin()
		table.insert(Winterblight.StatuesTable, statue)
	end
	Timers:CreateTimer(0.1, function()
		Winterblight.OrbsMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
		Winterblight.OrbsMaster:AddAbility("winterblight_orb_ability"):SetLevel(GameState:GetDifficultyFactor())
		Winterblight.OrbsMaster:AddAbility("dummy_unit"):SetLevel(1)
	end)
	Timers:CreateTimer(12, function()
		Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
		for i = 1, #Winterblight.OrbTable, 1 do
			Timers:CreateTimer(i * 0.15, function()
				local orb = Winterblight.OrbTable[i]
				Winterblight:SpawnAzaleaWaveUnit("winterblight_dimension_walker", orb.endPos, 2, 12, true)
			end)
		end
	end)
end

function Winterblight:SpawnAzaleaWaveUnit(unitName, spawnPoint, quantity, delay, bSound)

	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.AzaleaOrbs.Spawn", Winterblight.Master)
			end
			local luck = RandomInt(1, 160)
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
				unit.dominion = true
				unit.deathCode = 2
				Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_wave_unit", {})
				unit:SetAcquisitionRange(5000)
				CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit, 2)
				unit.aggro = true
				Winterblight:AdjustWaveUnit(unit)
				Winterblight:UnitDescendFromOrb(unit, spawnPoint)
			else
				for i = 1, #unit.buddiesTable, 1 do
					unit.buddiesTable[i].aggro = true
					unit.buddiesTable[i].dominion = true
					unit.buddiesTable[i]:SetAcquisitionRange(5000)
					unit.buddiesTable[i].deathCode = 2
					Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit.buddiesTable[i], "modifier_winterblight_wave_unit", {})
					CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit.buddiesTable[i], 2)
					Winterblight:AdjustWaveUnit(unit.buddiesTable[i])
					Winterblight:UnitDescendFromOrb(unit.buddiesTable[i], spawnPoint)
				end
			end
		end)
	end
end

function Winterblight:UnitDescendFromOrb(unit, spawnPoint)
	unit:SetAbsOrigin(spawnPoint)
	local startSpeed = 21
	local particleName = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, spawnPoint)
	ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_disable_player", {duration = 2.5})
	for i = 1, 80, 1 do
		Timers:CreateTimer(i * 0.03, function()
			if not unit:HasModifier("modifier_disable_player") then
				if pfx then
					FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
					ParticleManager:DestroyParticle(pfx, false)
					pfx = false
				end
				return false
			end
			local distanceToGround = unit:GetAbsOrigin().z - GetGroundHeight(unit:GetAbsOrigin(), unit)
			if distanceToGround < 10 then
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
				unit:RemoveModifierByName("modifier_disable_player")
				ParticleManager:DestroyParticle(pfx, false)
				pfx = false
				return false
			end
			startSpeed = math.max(startSpeed - 0.5, 8)
			unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, startSpeed))
		end)
	end
end

function Winterblight:EndOrbWaves()
	for i = 1, #Winterblight.OrbTable, 1 do
		local targetProp = Winterblight.StatuesTable[1]
		if i % 3 == 0 then
			targetProp = Winterblight.StatuesTable[1]
		elseif i % 3 == 1 then
			targetProp = Winterblight.StatuesTable[2]
		elseif i % 3 == 2 then
			targetProp = Winterblight.StatuesTable[3]
		end
		EmitSoundOnLocationWithCaster(Winterblight.OrbTable[i].endPos, "Winterblight.AzaleaOrbs.MoveToStatue", Winterblight.Master)
		local pfx = Winterblight.OrbTable[i].pfx
		local speed = (WallPhysics:GetDistance2d(targetProp.prop:GetAbsOrigin(), Winterblight.OrbTable[i].endPos) / 80) / 0.03
		ParticleManager:SetParticleControl(pfx, 1, targetProp.prop:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(speed, speed, speed))
		ParticleManager:SetParticleControl(pfx, 3, Vector(speed, speed, speed))
	end
	Timers:CreateTimer(0.03 * 80, function()
		local posTable = {Vector(10738, -7129), Vector(11088, -7129), Vector(11432, -7129)}
		for i = 1, #Winterblight.StatuesTable, 1 do
			local statue = Winterblight.StatuesTable[i].prop
			EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Winterblight.AzaleaOrbs.StatuesActivated", Winterblight.Master)
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/frost_titan_god_start.vpcf", statue:GetAbsOrigin(), 3)
			local targetPos = posTable[i]
			local moveVector = ((targetPos - statue:GetAbsOrigin()) * Vector(1, 1, 0)) / 160
			for j = 1, 160, 1 do
				Timers:CreateTimer(j * 0.03, function()
					Winterblight.StatuesTable[i].position = (statue:GetAbsOrigin() + moveVector)
				end)
			end
			Timers:CreateTimer(4.8, function()
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/frost_titan_god_start.vpcf", Winterblight.StatuesTable[i].position, 3)
				EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Winterblight.AzaleaOrbs.StatuesAtPoint", Winterblight.Master)
			end)
		end
		Timers:CreateTimer(6.5, function()
			Winterblight:StatueSlotStart(1)
		end)
		Timers:CreateTimer(0.1, function()
			for i = 1, #Winterblight.OrbTable, 1 do
				ParticleManager:DestroyParticle(Winterblight.OrbTable[i].pfx, false)
				ParticleManager:ReleaseParticleIndex(Winterblight.OrbTable[i].pfx)
			end
			Timers:CreateTimer(0.05, function()
				Winterblight.OrbTable = nil
			end)
		end)
	end)

end

function Winterblight:StatueSlotStart(statue_index)
	if statue_index == 1 then
		Winterblight.StatueColors = {"none", "none", "none"}
	end
	local statue = Winterblight.StatuesTable[statue_index]
	local potentialColors = WallPhysics:ShuffleTable({"red", "green", "blue"})
	local delay = 0
	local colorRotats = 25 + RandomInt(1, 6)
	local delay = 0
	--DeepPrintTable(potentialColors)
	for i = 1, colorRotats, 1 do
		delay = delay + 0.03 * i
		Timers:CreateTimer(delay, function()
			EmitSoundOnLocationWithCaster(statue.prop:GetAbsOrigin(), "Winterblight.Statue.SlotMachine", Winterblight.Master)
			local color = potentialColors[(i % 3 + 1)]
			if color == "red" then
				statue.prop:SetRenderColor(240, 110, 110)
			elseif color == "green" then
				statue.prop:SetRenderColor(120, 220, 120)
			elseif color == "blue" then
				statue.prop:SetRenderColor(110, 110, 240)
			end
			if i == colorRotats then
				Winterblight.StatueColors[statue_index] = color
				CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/frost_titan_god_start.vpcf", statue.position, 3)
				EmitSoundOnLocationWithCaster(statue.prop:GetAbsOrigin(), "Winterblight.AzaleaStatue.ColorRotatEnd", Winterblight.Master)
				Timers:CreateTimer(0.5, function()
					if Winterblight.StatueColors[1] == Winterblight.StatueColors[2] and Winterblight.StatueColors[2] == Winterblight.StatueColors[3] then
						EmitSoundOnLocationWithCaster(Winterblight.StatuesTable[2].prop:GetAbsOrigin(), "Winterblight.AzaleaCrystal.FinishPuzzle", Events.GameMaster)
						CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/frost_titan_god_start.vpcf", Winterblight.StatuesTable[2].prop:GetAbsOrigin(), 3)
						if Winterblight.StatueColors[1] == "red" then
							RPCItems:RollRedDivinexAmulet(Winterblight.StatuesTable[2].prop:GetAbsOrigin())
						elseif Winterblight.StatueColors[1] == "blue" then
							RPCItems:RollBlueDivinexAmulet(Winterblight.StatuesTable[2].prop:GetAbsOrigin())
						else
							RPCItems:RollGreenDivinexAmulet(Winterblight.StatuesTable[2].prop:GetAbsOrigin())
						end
					end
				end)
				Timers:CreateTimer(1.0, function()
					local zealot = Winterblight:SpawnAzaleaZealot(statue.prop:GetAbsOrigin(), Vector(0, -1))
					zealot.cantAggro = true
					CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", zealot, 2)
					zealot:SetAbsOrigin(statue.prop:GetAbsOrigin() + Vector(0, 0, 440))
					WallPhysics:Jump(zealot, Vector(0, -1), RandomInt(4, 16), RandomInt(10, 16), RandomInt(16, 24), 1)
					Winterblight:smoothSizeChange(zealot, 0.1, 3.2, 66)
					EmitSoundOn("Winterblight.AzaleanZealot.Spawn", zealot)
					zealot.color = color
					zealot.deathCode = 3
					zealot:AddNewModifier(zealot, nil, "modifier_animation_translate", {translate = "run"})
					Timers:CreateTimer(1.5, function()
						zealot.cantAggro = false
						Dungeons:AggroUnit(zealot)
						CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", zealot, 2)
					end)
					if color == "red" then
						Events:ColorWearablesAndBase(zealot, Vector(240, 110, 110))
					elseif color == "green" then
						Events:ColorWearablesAndBase(zealot, Vector(110, 240, 110))
					elseif color == "blue" then
						Events:ColorWearablesAndBase(zealot, Vector(110, 110, 240))
					end
				end)
			end
		end)
	end
end

function Winterblight:SpawnAzaleaZealot(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_zealot", position, 3, 4, "Winterblight.AzaleanZealot.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 44
	stone.type = ENEMY_TYPE_MINI_BOSS
	Winterblight:SetPositionCastArgs(stone, 2000, 0, 3, FIND_ANY_ORDER)
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
	end
	return stone
end

function Winterblight:OpenShrineOfAzalea()
	Winterblight.AzaleaDungeonOpened = {}
	Timers:CreateTimer(3, function()
		Winterblight.AzaleaDungeonOpened = true
		local walls = Entities:FindAllByNameWithin("AzaleaEntranceWall", Vector(11007, -9574, -4094 + Winterblight.ZFLOAT), 2400)
		EmitSoundOnLocationWithCaster(Vector(11007, -9574), "Winterblight.WallOpen", Events.GameMaster)
		Winterblight:WallsTicks(false, walls, true, 5, 360, 0.3)
		Winterblight:RemoveBlockers(4, "AzaleaEntranceBlocker", Vector(11274, -9600, 300 + Winterblight.ZFLOAT), 1400)
		Timers:CreateTimer(1, function()
			EmitGlobalSound("Winterblight.OpenDungeon")
		end)
		Winterblight:FirstShrineSpawn()
	end)
	Winterblight.AzaleaDungeonOpened = true
	Winterblight:SpawnAzaleaCups()
	Timers:CreateTimer(6, function()
		Winterblight.AzaleaEntranceBridgeRaised = true
	end)
	Dungeons.respawnPoint = Vector(11133, -8100)
end

function Winterblight:SpawnColdSeer(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_cold_seer", position, 1, 1, "Winterblight.ColdSeer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 36
	Winterblight:SetPositionCastArgs(stone, 1000, 0, 3, FIND_ANY_ORDER)
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	Events:ColorWearablesAndBase(stone, Vector(90, 90, 225))
	stone.dominion = true
	return stone
end

function Winterblight:SpawnSoftwalker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_softwalker", position, 1, 1, "Winterblight.ColdSeer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 5, 5, false)
	stone.itemLevel = 38
	Events:ColorWearablesAndBase(stone, Vector(120, 140, 205))
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrostWhelpling(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("frost_whelpling", position, 0, 1, "Winterblight.Whelpling.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 3, false)
	Winterblight:SetPositionCastArgs(stone, 900, 0, 3, FIND_ANY_ORDER)
	stone.itemLevel = 36
	stone:SetAcquisitionRange(0)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnHeartFreezer(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_heartfreezer", position, 1, 3, "Winterblight.HeartFreezer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 3, false)
	stone.itemLevel = 44
	stone.dominion = true
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_ANY_ORDER)
	return stone
end

function Winterblight:SpawnMountainGod(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mountain_lord", position, 3, 9, "Winterblight.MountainGod.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 3, false)
	stone.itemLevel = 44
	local ability = stone:FindAbilityByName("winterblight_mountain_god_passive")
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_mountain_god_falling", {})
	stone:SetAbsOrigin(stone:GetAbsOrigin() + Vector(0, 0, 2200))
	stone.cantAggro = true
	Timers:CreateTimer(1.5, function()
		stone.cantAggro = false
	end)
	return stone
end

function Winterblight:InitCaptainReynar()
	local position = Vector(-8333, -8098) + Vector(RandomInt(0, 3400), RandomInt(0, 2000))
	local captain = CreateUnitByName("winterblight_captain_reynar_ghost", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
end

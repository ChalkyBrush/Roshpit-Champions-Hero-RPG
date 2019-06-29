function Redfall:InitializeForest()
	local vectorTable = {Vector(-12480, -12754), Vector(-12608, -12692), Vector(-12453, -12617)}
	local bottomLeftPos = Vector(-11840, -12711)
	for i = 0, 10, 1 do
		local randomX = RandomInt(1, 1050)
		local randomY = RandomInt(1, 810)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroom(vectorTable[i])
	end
	Timers:CreateTimer(3, function()
		Redfall:SpawnTrainingDummy(Vector(-13504, -11072))
		Redfall:SpawnAutumnGazer(Vector(-14080, -12275), Vector(0.2, -1))
		Redfall:SpawnAutumnGazer(Vector(-13684, -12395), Vector(0, -1))
		Redfall:SpawnAutumnGazer(Vector(-13248, -12241), Vector(0, -1))
		Redfall:SpawnAutumnGazer(Vector(-13783, -13110), Vector(-0.4, 1))
		Redfall:SpawnAutumnGazer(Vector(-13312, -13002), Vector(0, 1))
		local vecTable2 = {Vector(-14355, -13184), Vector(-14209, -13056), Vector(-13950, -12530), Vector(-13209, -12951)}
		for i = 1, #vecTable2, 1 do
			Redfall:SpawnRedfallShroom(vecTable2[i])
		end
	end)
	Timers:CreateTimer(5, function()
		Redfall:SpawnAutumnSpawner(Vector(-11584, -11648, 47), Vector(-1, -1), Vector(-11819, -11786))
		Redfall:SpawnAutumnSpawner(Vector(-10302, -12817, 47), Vector(-1, 1), Vector(-10496, -12688))
		Redfall:SpawnAutumnSpawner(Vector(-12608, -10708, 47), Vector(1, -1), Vector(-12416, -10833))
		Redfall:SpawnAutumnSummoner(Vector(-12160, -11382), Vector(0, -1))
		if GameState:GetDifficultyFactor() > 1 then
			Redfall:SpawnAutumnSummoner(Vector(-12416, -11264), Vector(1, -1))
		end
	end)
	Timers:CreateTimer(8, function()
		Redfall:SpawnRedfallForestMinion(Vector(-10979, -13768), Vector(1, -1), false)
		Redfall:SpawnRedfallForestMinion(Vector(-11104, -14103), Vector(1, 0.5), false)
		Redfall:SpawnRedfallForestMinion(Vector(-10302, -13893), Vector(-1, -1), false)
		Redfall:SpawnRedfallForestMinion(Vector(-10254, -14144), Vector(-1, 0.6), false)
	end)
	Redfall:SpawnShadowOfFenrir()
end

function Redfall:HouseArea()
	Redfall:SpawnAutumnSummoner(Vector(-15808, -12992), Vector(1, 0))
	Redfall:SpawnAutumnSummoner(Vector(-15040, -12864), Vector(1, 0))
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnAutumnSummoner(Vector(-15858, -12544), Vector(1, -0.5))
		Redfall:SpawnAutumnSummoner(Vector(-15552, -13184), Vector(1, 1))
	end
	Redfall:SpawnAutumnSpawner(Vector(-15265, -12416, 47), Vector(-1, -1), Vector(-15424, -12608))
end

function Redfall:SpawnRedfallShroom(position)
	local creepFunction = function(unit)
		unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 70))
		unit:SetRenderColor(255, 57, 53)
		local ability = unit:FindAbilityByName("grizzly_cave_shroom_ai")
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_cave_shroom_ai", {})
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shroomling",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 1,
		itemLevel = 12,
		aggroSound = nil,
		fv = RandomVector(1),
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction,
	}
	return unit
end

function Redfall:SpawnAutumnGazer(position, fv)
	local creepFunction = function(unit)
		unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 35))
		local colorRandomizer = RandomInt(1, 35)
		unit:SetRenderColor(255 - colorRandomizer, 159 - colorRandomizer, 159 - colorRandomizer)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_gazer",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 1,
		itemLevel = 15,
		aggroSound = nil,
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction,
	}
	return unit
end

function Redfall:SpawnAutumnSpawner(position, fv, summonCenter)
	local creepFunction = function(unit)
		unit.summonCenter = summonCenter
		unit:SetAbsOrigin(Vector(unit:GetAbsOrigin().x, unit:GetAbsOrigin().y, position.z) + Vector(0, 0, Redfall.ZFLOAT))
		unit:SetRenderColor(214, 101, 101)
		Events:AdjustBossPower(unit, 1, 2, false)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_spawner",
		spawnPoint = position,
		minDrops = 2,
		maxDrops = 4,
		itemLevel = 24,
		aggroSound = nil,
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAutumnSpawnerUnit(position, fv, itemRoll, bAggro)
	local creepFunction = function(unit)
		unit:SetRenderColor(233, 100, 100)
		Events:AdjustBossPower(unit, 1, 2, false)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_flower",
		spawnPoint = position,
		minDrops = itemRoll,
		maxDrops = itemRoll,
		itemLevel = 17,
		aggroSound = "Redfall.Flower.Aggro",
		fv = fv,
		isAggro = bAggro,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_WEAK_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAutumnSummoner(position, fv)
	local creepFunction = function(unit)
		unit:SetRenderColor(255, 118, 118)
		Events:AdjustBossPower(unit, 1, 1, false)
		Redfall:ColorWearables(unit, Vector(255, 110, 110))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_forest_summoner",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 18,
		aggroSound = "Redfall.ForestSummoner.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit

end

function Redfall:SpawnRedfallTreant(position, fv)
	local creepFunction = function(unit)
		unit:SetRenderColor(255, 130, 130)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_treant",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 2,
		itemLevel = 12,
		aggroSound = nil,
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_WEAK_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnRedfallForestMinion(position, fv, bAggro)
	local creepFunction = function(unit)
		unit:SetRenderColor(255, 148, 0)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_forest_minion",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 2,
		itemLevel = 12,
		aggroSound = "Redfall.ForestMinion.Aggro",
		fv = fv,
		isAggro = bAggro,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnWaterLily(position, fv, bAggro)
	local creepFunction = function(unit)
		unit:SetRenderColor(0, 148, 255)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_aqua_lily",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 2,
		itemLevel = 16,
		aggroSound = "Redfall.ForestMinion.Aggro",
		fv = fv,
		isAggro = bAggro,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnWoodDweller(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 158, 158)
		Redfall:ColorWearables(unit, Vector(255, 160, 160))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_forest_wood_dweller",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 18,
		aggroSound = "Redfall.WoodDweller.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit

end

function Redfall:SpawnWozxak(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 2, 2, false)
		unit:SetRenderColor(255, 158, 158)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_wozxak",
		spawnPoint = position,
		minDrops = 2,
		maxDrops = 4,
		itemLevel = 24,
		aggroSound = "Redfall.Wozxak.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_MINI_BOSS,
		creepFunction = creepFunction
	}
	return unit

end

function Redfall:SpawnOvergrowth(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 2, 2, false)
		unit:SetRenderColor(255, 158, 158)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_forest_overgrowth",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 24,
		aggroSound = "Redfall.Overgrowth.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:WoodDwellerArea()
	Redfall:SpawnWoodDweller(Vector(-8766, -13137), Vector(0, 1))
	Redfall:SpawnWoodDweller(Vector(-8384, -12416), Vector(0.2, -1))
	Redfall:SpawnWoodDweller(Vector(-7711, -12320), Vector(-1, -1))
	Redfall:SpawnWoodDweller(Vector(-7616, -12924), Vector(-1, 0.3))
	Redfall:SpawnWoodDweller(Vector(-8020, -13184), Vector(-1, 0.8))
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnAutumnSpawner(Vector(-7936, -12672, 47), Vector(-1, -1), Vector(-7936, -12672))
	end
end

function Redfall:ForestMiniBossTrigger()
	Redfall:SpawnAutumnSpawner(Vector(-10723, -10880, 80), Vector(1, 0), Vector(-10496, -10880))
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnAutumnSpawner(Vector(-9792, -10624, 80), Vector(-1, -1), Vector(-9920 - 10723))
	end
	local vectorTable = {}
	local bottomLeftPos = Vector(-10560, -11236)
	for i = 0, 10 + GameState:GetDifficultyFactor() * 2, 1 do
		local randomX = RandomInt(1, 800)
		local randomY = RandomInt(1, 800)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroom(vectorTable[i])
	end
	if GameState:GetDifficultyFactor() > 0 then
		local baseVector = Vector(-9408, -11445)
		local loops = -2 + (GameState:GetDifficultyFactor() * 4)
		for i = 1, loops, 1 do
			Timers:CreateTimer(i * 0.75, function()
				local position = baseVector + Vector(RandomInt(1, 200), RandomInt(1, 740))
				local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
				dummy:AddAbility("ability_blue_effect"):SetLevel(1)
				dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
				WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
				Timers:CreateTimer(10, function()
					local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
					unit:SetAbsOrigin(dummy:GetAbsOrigin())
					unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
					-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
					UTIL_Remove(dummy)
				end)
			end)
		end
	end
	Redfall:SpawnWozxak(Vector(-10304, -10880), Vector(1, 0))
end

function Redfall:BackTreeArea()
	Redfall:SpawnAutumnSpawner(Vector(-9024, -8896, 80), Vector(-1, 1), Vector(-9280, -8768))
	Redfall:SpawnAutumnSpawner(Vector(-9920, -7424, 80), Vector(1, 1), Vector(-9728, -7616))
	Redfall:SpawnAutumnSummoner(Vector(-9664, -8640), Vector(-1, -1))
	Redfall:SpawnAutumnSummoner(Vector(-8384, -8064), Vector(-1, 1))

	local position1 = Vector(-9299, -8202)
	local position2 = Vector(-9536, -7294)
	local position3 = Vector(-8662, -7829)
	local growth1 = Redfall:SpawnOvergrowth(position1, RandomVector(1))
	Redfall:AddPatrolArguments(growth1, 30, 3, 240, {position3, position2, position1})
	local growth2 = Redfall:SpawnOvergrowth(position2, RandomVector(1))
	Redfall:AddPatrolArguments(growth2, 30, 3, 240, {position1, position3, position2})
	local growth3 = Redfall:SpawnOvergrowth(position3, RandomVector(1))
	Redfall:AddPatrolArguments(growth3, 30, 3, 240, {position2, position1, position3})
end

function Redfall:JuggStatueArea()
	Redfall:SpawnAutumnSpawner(Vector(-6336, -8640, 80), Vector(-1, 1), Vector(-6509, -8813))
	local vectorTable = {}
	local bottomLeftPos = Vector(-7360, -9280)
	for i = 0, 6 + GameState:GetDifficultyFactor() * 2, 1 do
		local randomX = RandomInt(1, 1000)
		local randomY = RandomInt(1, 640)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroom(vectorTable[i])
	end
	if GameState:GetDifficultyFactor() > 1 then
		local lilyTable = {Vector(-8064, -8768), Vector(-7552, -8192)}
		for i = 1, #lilyTable, 1 do
			Timers:CreateTimer(i * 0.75, function()
				local position = lilyTable[i]
				local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
				dummy:AddAbility("ability_blue_effect"):SetLevel(1)
				dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
				WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
				Timers:CreateTimer(10, function()
					local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
					unit:SetAbsOrigin(dummy:GetAbsOrigin())
					unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
					-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
					UTIL_Remove(dummy)
				end)
			end)
		end
	end
	Redfall:SpawnAutumnGazer(Vector(-7064, -9261), Vector(0, 1))
	Redfall:SpawnAutumnGazer(Vector(-6592, -9600), Vector(1, 1))
	Redfall:SpawnAutumnGazer(Vector(-6144, -9344), Vector(-1, -1))
end

function Redfall:JuggStatueTrigger()
	EmitSoundOnLocationWithCaster(Vector(-6916, -8042), "Redfall.JuggStatue.Start", Redfall.RedfallMaster)
	Redfall.JuggStatue = Entities:FindByNameNearest("JuggStatue", Vector(-6916, -8042, 70 + Redfall.ZFLOAT), 400)
	for i = 1, 240, 1 do
		Timers:CreateTimer(0.03 * i, function()
			Redfall.JuggStatue:SetAbsOrigin(Redfall.JuggStatue:GetAbsOrigin() + Vector(0, 0, 1))
		end)
	end
	Timers:CreateTimer(1, function()
		Redfall.JuggAmbient = ParticleManager:CreateParticle("particles/econ/events/battlecup/battlecup_fall_ambient.vpcf", PATTACH_CUSTOMORIGIN, Redfall.RedfallMaster)
		ParticleManager:SetParticleControl(Redfall.JuggAmbient, 0, Vector(-6912, -8128, 250 + Redfall.ZFLOAT))
	end)
	Timers:CreateTimer(2, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[2].state = 0
			Redfall:NewQuest(MAIN_HERO_TABLE[i], 2)
		end
	end)
	local delay = 3
	if GameState:GetDifficultyFactor() == 2 then
		delay = 1.5
	elseif GameState:GetDifficultyFactor() == 3 then
		delay = 0.5
	end
	Timers:CreateTimer(5, function()
		for j = 1, 12, 1 do
			Timers:CreateTimer(j * delay, function()
				local spawnPosition = Vector(-6976, -8448) + RandomVector(RandomInt(1, 240))
				local particleName = "particles/roshpit/redfall/red_beam.vpcf"
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(pfx, 0, Vector(-6916, -8042, 200 + Redfall.ZFLOAT))
				ParticleManager:SetParticleControl(pfx, 1, spawnPosition + Vector(0, 0, 122 + Redfall.ZFLOAT))
				Redfall:SpawnDiscipleOfMaru(spawnPosition, Vector(0, -1))
				Timers:CreateTimer(3.5, function()
					ParticleManager:DestroyParticle(pfx, false)
				end)
				EmitSoundOnLocationWithCaster(spawnPosition, "Redfall.Maru.Spawn", Redfall.RedfallMaster)
			end)
		end
	end)
end

function Redfall:SpawnDiscipleOfMaru(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 158, 158)
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_fire_effect", {})
		unit.targetRadius = 450
		unit.autoAbilityCD = 3
		CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/time_bind_damage.vpcf", unit, 2)
		unit.dominion = true
		unit:AddNewModifier(unit, nil, "modifier_animation", {translate = "walk"})
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_disciple_of_maru",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 2,
		itemLevel = 22,
		aggroSound = "Redfall.Maru.Aggro",
		fv = fv,
		isAggro = true,
		deathModifier = "modifier_redfall_disciple_of_maru_die",
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAutumnSpirit(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 3, 3, false)
		unit:SetRenderColor(255, 158, 158)
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_fire_effect", {})
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_spirit",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 25,
		aggroSound = "Redfall.AutumnSpirit.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ForestStaffArea()
	Redfall:SpawnAutumnSummoner(Vector(-7552, -10816), Vector(0.3, 1))
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnAutumnSummoner(Vector(-6400, -10496), Vector(0, -1))
	end
	Redfall:SpawnAutumnSummoner(Vector(-5568, -10496), Vector(0, -1))
	Redfall:SpawnAutumnSpirit(Vector(-6976, -10816), Vector(-1, 0))
	Redfall:SpawnAutumnSpawner(Vector(-5696, -9728, 80), Vector(-1, 1), Vector(-5836, -9864))
	local vectorTable = {}
	local bottomLeftPos = Vector(-6592, -10688)
	for i = 0, 8 + GameState:GetDifficultyFactor() * 4, 1 do
		local randomX = RandomInt(1, 1200)
		local randomY = RandomInt(1, 720)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroom(vectorTable[i])
	end
end

function Redfall:SpawnBigFlower(position, fv)
	local creepFunction = function(unit)
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_tree_split", {})
		unit:SetRenderColor(255, 118, 118)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_big_autumn_flower",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 24,
		aggroSound = "Redfall.BigFlower.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit

end

function Redfall:BigFlowerTrigger()
	Redfall:SpawnBigFlower(Vector(-5952, -12282), Vector(-1, 0))
	Redfall:SpawnBigFlower(Vector(-5120, -11584), Vector(-1, -1))
	Redfall:SpawnBigFlower(Vector(-4224, -11776), Vector(-1, 0))
	Redfall:SpawnBigFlower(Vector(-3776, -10816), Vector(-1, -1))
	if GameState:GetDifficultyFactor() > 1 then
		Redfall:SpawnBigFlower(Vector(-3648, -11264), Vector(-1, 0))
		Redfall:SpawnAutumnSpawner(Vector(-4096, -10688, 80), Vector(1, -1), Vector(-4096, -10944))
	end
	Redfall:SpawnBigFlower(Vector(-3200, -11520), Vector(-1, 0.3))
	Redfall:SpawnAutumnSpawner(Vector(-4672, -12160, 80), Vector(1, -1), Vector(-4672, -11943))
end

function Redfall:SpawnForestGnome(position, fv)
	local creepFunction = function(unit)
		Redfall:SetPositionCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)
		unit:SetRenderColor(255, 115, 60)
		Redfall:ColorWearables(unit, Vector(255, 115, 60))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_forest_gnome",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 24,
		aggroSound = "Redfall.ForstGnome.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:NearTreantArea()
	Redfall:SpawnAutumnSpawner(Vector(-4591, -8880, 80), Vector(1, -1), Vector(-4634, -9035))
	Redfall:SpawnAutumnSpawner(Vector(-3589, -10136, 80), Vector(1, -1), Vector(-3649, -9950))
	local vectorTable = {}
	local bottomLeftPos = Vector(-5445, -10461)
	for i = 0, 8 + GameState:GetDifficultyFactor() * 4, 1 do
		local randomX = RandomInt(1, 1200)
		local randomY = RandomInt(1, 720)
		local spawnPos = bottomLeftPos + Vector(randomX, randomY)
		table.insert(vectorTable, spawnPos)
	end
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnRedfallShroom(vectorTable[i])
	end
	Redfall:SpawnBigFlower(Vector(-3587, -9861), Vector(-1, -1))

	Redfall:SpawnForestGnome(Vector(-3328, -9600), Vector(0, -1))
	Redfall:SpawnForestGnome(Vector(-3008, -9280), Vector(-0.3, -1))
	Redfall:SpawnForestGnome(Vector(-2880, -9664), Vector(-0.8, -0.2))
	if GameState:GetDifficultyFactor() == 3 then
		Redfall:SpawnForestGnome(Vector(-3072, -9534), Vector(0, -1))
	end
	Redfall:SpawnAutumnSummoner(Vector(-5110, -9280), Vector(0, -1))
	Redfall:SpawnAutumnSummoner(Vector(-4800, -9206), Vector(0, -1))
	Redfall:SpawnAutumnSummoner(Vector(-4800, -9536), Vector(0.2, -1))
end

function Redfall:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
	unit.targetRadius = radius
	unit.minRadius = minRadius
	unit.targetAbilityCD = cooldown
	unit.targetFindOrder = targetFindOrder
end

function Redfall:SpawnCliffWeed(position, fv)
	local creepFunction = function(unit)
		Redfall:SetPositionCastArgs(unit, 800, 0, 1, FIND_ANY_ORDER)
		unit:SetRenderColor(255, 161, 0)
		unit.targetRadius = 1500
		unit.autoAbilityCD = 1
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_cliff_weed",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 2,
		itemLevel = 24,
		aggroSound = "Redfall.CliffWeed.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:CliffSpawn()
	Redfall:SpawnBigFlower(Vector(-10880, -15040), Vector(0, 1))
	Redfall:SpawnBigFlower(Vector(-10176, -14720), Vector(-0.5, 1))

	Redfall:SpawnCliffWeed(Vector(-9472, -14912), Vector(-1, 1))
	Redfall:SpawnCliffWeed(Vector(-9024, -14647), Vector(-1, 0))
	Redfall:SpawnCliffWeed(Vector(-9292, -14326), Vector(-1, -1))
	Redfall:SpawnAutumnSpawner(Vector(-8704, -14318, 127), Vector(1, -1), Vector(-8704, -14448))

	Redfall:SpawnAutumnSummoner(Vector(-8320, -14464), Vector(-1, -0.6))
	Redfall:SpawnAutumnSummoner(Vector(-8064, -14709), Vector(-1, 0))

	Timers:CreateTimer(2, function()
		Redfall:SpawnCliffWeed(Vector(-8256, -14912), Vector(0, -1))
		Redfall:SpawnCliffWeed(Vector(-7680, -14528), Vector(1, -1))
		Redfall:SpawnCliffWeed(Vector(-7785, -14208), Vector(0.2, -1))
		Redfall:SpawnAutumnGazer(Vector(-8704, -14848), Vector(0.2, 1))
		Redfall:SpawnAutumnGazer(Vector(-8000, -15104), Vector(0, 1))
		Redfall:SpawnAutumnGazer(Vector(-7424, -14016), Vector(0, -1))
	end)
	Redfall:SpawnCliffWeed(Vector(-7104, -14784), Vector(0, -1))
	Redfall:SpawnCliffWeed(Vector(-6656, -14400), Vector(1, 0))
	Redfall:SpawnCliffWeed(Vector(-6400, -14720), Vector(0.5, 1))
	Redfall:SpawnCliffWeed(Vector(-6475, -14016), Vector(0.5, 1))
	Redfall:SpawnCliffWeed(Vector(-5952, -14080), Vector(0, 1))
	Redfall:SpawnCliffWeed(Vector(-5440, -13970), Vector(-1, 1))
	Timers:CreateTimer(4, function()
		local patrolPoint1 = Vector(-10560, -14784)
		local patrolPoint2 = Vector(-5312, -13888)
		local gnome1 = Redfall:SpawnForestGnome(Vector(-8064, -14528), Vector(-0.8, -0.2))
		Redfall:AddPatrolArguments(gnome1, 40, 9, 340, {patrolPoint2, patrolPoint1})
		local gnome2 = Redfall:SpawnForestGnome(Vector(-8064, -14758), Vector(-0.8, -0.2))
		Redfall:AddPatrolArguments(gnome2, 40, 9, 340, {patrolPoint2, patrolPoint1})
		local gnome3 = Redfall:SpawnForestGnome(Vector(-7840, -14528), Vector(-0.8, -0.2))
		Redfall:AddPatrolArguments(gnome3, 40, 9, 340, {patrolPoint2, patrolPoint1})
	end)

	local foxNPC = CreateUnitByName("redfall_otaru", Vector(-3019, -15087), true, nil, nil, DOTA_TEAM_GOODGUYS)
	foxNPC.hasSpeechBubble = false
	foxNPC:SetForwardVector(Vector(-1, 0))
	foxNPC:FindAbilityByName("town_unit_not_invuln"):SetLevel(1)
	foxNPC:FindAbilityByName("redfall_otaru_ability"):SetLevel(1)
	foxNPC.state = 0
	Redfall.Otaru = foxNPC

end

function Redfall:OtaruQuestStart()
	if not Redfall.OtaruQuestStarted then
		Redfall.OtaruQuestStarted = true
		for i = 1, #MAIN_HERO_TABLE, 1 do
			MAIN_HERO_TABLE[i].RedfallQuests[3].state = 0
			Redfall:NewQuest(MAIN_HERO_TABLE[i], 3)
		end
		EndAnimation(Redfall.Otaru)
		Redfall:Dialogue(Redfall.Otaru, MAIN_HERO_TABLE, "redfall_otaru_dialogue_2", 6, 5, -40, true)
		Timers:CreateTimer(1, function()
			Redfall.Otaru.state = 1
			Redfall.Otaru.altSummon = 0
		end)
	end
end

function Redfall:SpawnCliffInvader(position, fv)
	local creepFunction = function(unit)
		unit:SetAbsOrigin(position - Vector(0, 0, 800))
		unit:SetRenderColor(0, 100, 255)
		local ability = unit:FindAbilityByName("arena_pit_crawler_ai")
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_arena_pit_crawler_enter", {})
		unit.fv = fv
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_cliff_invader",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 2,
		itemLevel = 21,
		aggroSound = nil,
		fv = fv,
		isAggro = true,
		deathModifier = "modifier_redfall_cliff_invader",
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnCliffInvaderRanged(position, fv)
	local creepFunction = function(unit)
		unit:SetAbsOrigin(position - Vector(0, 0, 800))
		unit:SetRenderColor(0, 100, 255)
		Redfall:ColorWearables(unit, Vector(0, 100, 255))
		local ability = unit:FindAbilityByName("arena_pit_crawler_ai")
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_arena_pit_crawler_enter", {})
		unit.fv = fv
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_cliff_invader_range",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 2,
		itemLevel = 21,
		aggroSound = nil,
		fv = fv,
		isAggro = true,
		deathModifier = "modifier_redfall_cliff_invader",
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ForestRangerTrigger()
	local vectorTable = {Vector(-5056, -7552), Vector(-4928, -6976), Vector(-4529, -6272), Vector(-3904, -6101), Vector(-3456, -6240), Vector(-3837, -6528), Vector(-3406, -6912)}
	local fvTable = {Vector(0, -1), Vector(-0.2, -1), Vector(-1, -0.6), Vector(-1, 0), Vector(-1, 0.2), Vector(-1, 1), Vector(0, 1)}
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnForestRanger(vectorTable[i], fvTable[i])
	end
	Redfall:SpawnWoodDweller(Vector(-5377, -7232), Vector(1, -1))
	Redfall:SpawnForestGnome(Vector(-3904, -7360), Vector(1, 1))
	Redfall:SpawnForestGnome(Vector(-4096, -7168), Vector(1, 0.7))
	Redfall:SpawnAutumnSpawner(Vector(-3840, -5696, 127), Vector(-1, -1), Vector(-3968, -5824))
end

function Redfall:SpawnForestRanger(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_forest_ranger",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 24,
		aggroSound = "Redfall.ForestRanger.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = "modifier_redfall_forest_ranger_die",
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnRedRaven(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 4, 4, false)
		unit.jumpEnd = "basic_dust"
		unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 2000))
		WallPhysics:Jump(unit, Vector(1, 1), 0, 0, 0, 1)
		Timers:CreateTimer(1, function()
			EmitSoundOn("Redfall.RedRaven.Taunt", unit)
		end)
		Timers:CreateTimer(2, function()
			StartAnimation(unit, {duration = 2.5, activity = ACT_DOTA_SPAWN, rate = 0.8, translate = "manias_mask"})
		end)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_red_raven",
		spawnPoint = position,
		minDrops = 3,
		maxDrops = 5,
		itemLevel = 31,
		aggroSound = "Redfall.RedRaven.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = "modifier_redfall_red_raven_die",
		enemyType = ENEMY_TYPE_MINI_BOSS,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnStoneWatcher(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit.targetRadius = 900
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_CLOSEST
		unit:SetRenderColor(255, 118, 118)
		Redfall:ColorWearables(unit, Vector(255, 110, 110))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_stone_watcher",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 24,
		aggroSound = "Redfall.StoneWatcher.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ForestStoneWatcherTrigger()
	Redfall:SpawnStoneWatcher(Vector(-4906, -12974), Vector(1, -0.2))
	Redfall:SpawnStoneWatcher(Vector(-3858, -12976), Vector(-1, -1))
	Redfall:SpawnStoneWatcher(Vector(-3264, -12734), Vector(-1, -1))
	Redfall:SpawnStoneWatcher(Vector(-2357, -12510), Vector(-1, 0))
end

function Redfall:WoodsmenTrigger2()
	Redfall:SpawnWoodDweller(Vector(-1728, -8000), Vector(0, 1))
	Redfall:SpawnWoodDweller(Vector(-1408, -8064), Vector(-0.2, 1))
	Redfall:SpawnWoodDweller(Vector(-1152, -7936), Vector(-1, 1))
	Redfall:SpawnWoodDweller(Vector(-1152, -7552), Vector(-1, 0))

	Redfall:SpawnBigFlower(Vector(-1472, -7680), Vector(-0.2, 1))
	Redfall:SpawnBigFlower(Vector(-1856, -7130), Vector(-0.8, 0.2))
	Redfall:SpawnBigFlower(Vector(-1664, -6656), Vector(-0.8, -0.8))

	Redfall:SpawnAutumnSpawner(Vector(-1152, -6976, 127), Vector(-1, -1), Vector(-1280, -7104))
	Redfall:SpawnAutumnSpawner(Vector(-1497, -6016, 127), Vector(0, -1), Vector(-1499, -6218))

	Redfall:SpawnForestGnome(Vector(-2048, -6464), Vector(0.8, -0.7))
	Redfall:SpawnForestGnome(Vector(-1344, -6912), Vector(-1, 0.1))
	Redfall:SpawnForestGnome(Vector(-1280, -6592), Vector(-1, 0.4))
	Redfall:SpawnForestGnome(Vector(-1152, -6464), Vector(-1, 0.8))

	local baseVector = Vector(-1427, -8704)
	local loops = GameState:GetDifficultyFactor() * 3
	for i = 1, loops, 1 do
		Timers:CreateTimer(i * 0.75, function()
			local position = baseVector + Vector(RandomInt(1, 1300), RandomInt(1, 280))
			local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddAbility("ability_blue_effect"):SetLevel(1)
			dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
			WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
			Timers:CreateTimer(10, function()
				local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
				unit:SetAbsOrigin(dummy:GetAbsOrigin())
				unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
				-- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
				UTIL_Remove(dummy)
			end)
		end)
	end
	Timers:CreateTimer(4, function()
		local vectorTable = {Vector(-256, -7616), Vector(0, -7616), Vector(202, -7424), Vector(-352, -7329), Vector(94, -6804), Vector(-313, -6640)}
		local fvTable = {Vector(1, 1), Vector(-0.5, 1), Vector(-0.3, 0.7), Vector(1, 0.6), Vector(-1, 1), Vector(-0.6, 1)}
		for i = 1, #vectorTable, 1 do
			Redfall:SpawnSoulReacher(vectorTable[i], fvTable[i])
		end
		Redfall:SpawnAutumnSummoner(Vector(-832, -5760), Vector(-0.2, -1))
		Redfall:SpawnAutumnSummoner(Vector(-384, -6031), Vector(-1, 0))
	end)
end

function Redfall:SpawnSoulReacher(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 118, 118)
		Redfall:ColorWearables(unit, Vector(255, 110, 110))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_hooded_soul_reacher",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 3,
		itemLevel = 24,
		aggroSound = "Redfall.SoulReacher.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAshSnake(position, fv, bAggro)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_ash_snake",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 2,
		itemLevel = 24,
		aggroSound = "Redfall.AshSnake.Aggro",
		fv = fv,
		isAggro = bAggro,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:TopRightForestArea()
	local fvTarget = Vector(-2816, -5248)
	local snakePosTable = {Vector(-3584, -5248), Vector(-3328, -5184), Vector(-3535, -4947), Vector(-3584, -4928), Vector(-3328 - 4800), Vector(-3072, -4928), Vector(-3584, -4608)}
	for i = 1, #snakePosTable, 1 do
		local fv = ((fvTarget - snakePosTable[i]) * Vector(1, 1, 0)):Normalized()
		Redfall:SpawnAshSnake(snakePosTable[i], fv, false)
	end
	Redfall:SpawnCliffWeed(Vector(-3392, -4160), Vector(0.2, -1))
	Redfall:SpawnCliffWeed(Vector(-2752, -4352), Vector(-0.5, -1))
	Redfall:SpawnCliffWeed(Vector(-3136, -4416), Vector(0, -1))

	Redfall:SpawnStoneWatcher(Vector(-2432, -5632), Vector(1, -1))
	Redfall:SpawnStoneWatcher(Vector(-2863, -5356), Vector(1, -0.5))

	Redfall:SpawnAutumnSpawner(Vector(-3776, -4480, 127), Vector(-1, -1), Vector(-3648, -4672))
end

function Redfall:SpawnAshKnight(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 2, 2, false)
		unit:SetRenderColor(255, 0, 0)
		Redfall:ColorWearables(unit, Vector(255, 0, 0))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_ashfall_knight",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 3,
		itemLevel = 27,
		aggroSound = "Redfall.AshKnight.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ForestEndTrigger()
	local position1 = Vector(-6344, -4834)
	local position2 = Vector(-8042, -4408)
	local position3 = Vector(-9729, -5885)
	local position4 = Vector(-7524, -5764)
	local positionTable = {position1, position2, position3, position4}
	local skeletonsPerPatrol = 2
	if GameState:GetDifficultyFactor() == 3 then
		skeletonsPerPatrol = 3
	end
	for i = 1, #positionTable, 1 do
		for j = 1, skeletonsPerPatrol, 1 do
			local ashKnight = Redfall:SpawnAshKnight(positionTable[i] + RandomVector(RandomInt(60, 200)))
			--print(((i)%4)+1)
			Redfall:AddPatrolArguments(ashKnight, 30, 5, 240, {positionTable[((i) % 4) + 1], positionTable[((i + 1) % 4) + 1], positionTable[((i + 2) % 4) + 1], positionTable[((i + 3) % 4) + 1]})
		end
	end
	Redfall:SpawnAutumnSatyr(Vector(-5669, -4792), Vector(1, 0))
	Redfall:SpawnAutumnSatyr(Vector(-5873, -4479), Vector(1, -0.5))
	Redfall:SpawnAutumnSatyr(Vector(-5851, -5120), Vector(1, 0.5))
	Redfall:SpawnAutumnSatyr(Vector(-6464, -5184), Vector(1, 1))
	Redfall:SpawnAutumnSatyr(Vector(-6464, -4608), Vector(1, -0.5))

	local vultureTable = {Vector(-5504, -4160), Vector(-5632, -3968), Vector(-6784, -4608), Vector(-7104, -4352), Vector(-7232, -4736), Vector(-9344, -4416), Vector(-7616, -5888), Vector(-7296, -6016)}
	local lookPosition = Vector(-5952, -4800)
	for i = 1, #vultureTable, 1 do
		Timers:CreateTimer(0.5 * i, function()
			local fv = (lookPosition - vultureTable[i]):Normalized()
			Redfall:SpawnAutumnVulture(vultureTable[i], fv)
		end)
	end
	Timers:CreateTimer(2, function()
		Redfall:SpawnAutumnSpirit(Vector(-9088, -4544), Vector(1, 0))
		Redfall:SpawnAutumnSpirit(Vector(-8832, -5888), Vector(1, 0.2))
		Redfall:SpawnAutumnSpirit(Vector(-7168, -5696), Vector(1, 1))
	end)
	Redfall:SpawnAutumnCragnataur(Vector(-7872, -3788), Vector(1, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-8764, -4288), Vector(1, -0.2))
	Redfall:SpawnAutumnCragnataur(Vector(-7104, -4032), Vector(0.2, -1))
	Timers:CreateTimer(5, function()
		Redfall:SpawnBigFlower(Vector(-9216, -6080), Vector(-1, 0))
		Redfall:SpawnBigFlower(Vector(-7872, -5824), Vector(-1, 0.5))
		Redfall:SpawnBigFlower(Vector(-8896, -4864), Vector(-1, 1))
		Redfall:SpawnBigFlower(Vector(-9536, -5120), Vector(-1, 1))
	end)
end

function Redfall:SpawnAutumnSatyr(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 2, 1, false)
		unit:SetRenderColor(255, 127, 0)
		unit.targetRadius = 300
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_CLOSEST
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_satyr",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 3,
		itemLevel = 25,
		aggroSound = "Redfall.AutumnSatyr.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAutumnVulture(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 127, 0)
		unit.targetRadius = 1000
		unit.minRadius = 0
		unit.targetAbilityCD = 2
		unit.targetFindOrder = FIND_ANY_ORDER
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_redfall_vulture",
		spawnPoint = position,
		minDrops = 0,
		maxDrops = 2,
		itemLevel = 25,
		aggroSound = "Redfall.AutumnVulture.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAutumnCragnataur(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 127, 0)
		Redfall:ColorWearables(unit, Vector(255, 110, 0))
		unit.targetRadius = 1000
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_ANY_ORDER
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_cragnataur",
		spawnPoint = position,
		minDrops = 2,
		maxDrops = 5,
		itemLevel = 25,
		aggroSound = "Redfall.Cragnataur.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:CorruptedTreeInitiate(tree)
	local particleName = "particles/dark_smoke_test.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, tree:GetAbsOrigin())
	EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Redfall.CorruptedTreeStart", Redfall.RedfallMaster)
	Timers:CreateTimer(30, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local treeDummy = CreateUnitByName("npc_dummy_unit", tree:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
	treeDummy.cultistsSlain = 0
	treeDummy.cultistsTarget = 12
	treeDummy.tree = tree
	treeDummy:AddAbility("dummy_unit"):SetLevel(1)
	Timers:CreateTimer(2.5, function()
		for i = 1, treeDummy.cultistsTarget, 1 do
			Timers:CreateTimer(i, function()
				local cultist = Redfall:SpawnCrimsythCultist(tree:GetAbsOrigin(), Vector(0, -1), tree:GetAbsOrigin())
				cultist.treeDummy = treeDummy
			end)
		end
	end)
end

function Redfall:SpawnCrimsythCultist(position, fv, treeOrigin)
	local creepFunction = function(unit)
		unit:SetAbsOrigin(treeOrigin + Vector(0, 1) * 320 + Vector(0, 0, 800))
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 50, 50)
		Redfall:ColorWearables(unit, Vector(255, 50, 50))
		StartAnimation(unit, {duration = 7, activity = ACT_DOTA_VICTORY, rate = 1})
		local ability = unit:FindAbilityByName("crimsyth_cultist_ai")
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_cultist_entering", {duration = 7})
		unit.rotationIndex = 1
		unit.treeOrigin = treeOrigin
		Timers:CreateTimer(7.1, function()
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
		end)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_crimsyth_cultist",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 2,
		itemLevel = 25,
		aggroSound = nil,
		fv = fv,
		isAggro = true,
		deathModifier = "modifier_redfall_crimsyth_cultist_die",
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnCrimsythCultMaster(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 2, 1, false)
		unit:SetRenderColor(255, 127, 0)
		unit.targetRadius = 1100
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_FARTHEST
		local ability = unit:FindAbilityByName("crimsith_cult_master_pull")
		unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 900))
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_cultist_entering", {duration = 5})
		WallPhysics:Jump(unit, Vector(1, 1), 0, 0, 0, 0.1)
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Redfall.CultBoss.LaughEnter", unit)
		end)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_crimsyth_cultist_master",
		spawnPoint = position,
		minDrops = 3,
		maxDrops = 5,
		itemLevel = 25,
		aggroSound = nil,
		fv = fv,
		isAggro = true,
		deathModifier = "modifier_redfall_crimsyth_cultist_master_die",
		enemyType = ENEMY_TYPE_MINI_BOSS,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ForestFinalBridge()
	Redfall:SpawnAutumnCragnataur(Vector(-8384, -1408), Vector(1, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-8064, -1216), Vector(0, -1))
	Redfall:SpawnAutumnCragnataur(Vector(-7744, -1408), Vector(-1, -1))
	Redfall:SpawnStoneWatcher(Vector(-8512, -1088), Vector(1, -0.6))
	Redfall:SpawnStoneWatcher(Vector(-8192, -960), Vector(0.7, -0.9))

	Redfall:SpawnAutumnVulture(Vector(-8704, -935), Vector(1, -1))
	Redfall:SpawnAutumnVulture(Vector(-7104, -1088), Vector(-1, -1))

	Redfall:SpawnAutumnSatyr(Vector(-7680, -1024), Vector(-1, -0.8))
	Redfall:SpawnAutumnSatyr(Vector(-7424, -1216), Vector(-1, -0.3))
end

function Redfall:GiveBurgundyFirefly(hero)
	local item_name = "item_redfall_burgundy_firefly_"..GameState:GetDifficultyName()
	local key = RPCItems:CreateConsumable(item_name, "rare", "redfall_key", "consumable", false, "Consumable", item_name.."_desc")

	RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
end

function Redfall:DropAshTwig(position)
	local item_name = "item_redfall_ashen_twig"
	local key = RPCItems:CreateConsumable(item_name, "rare", "redfall_twig", "consumable", false, "Redfall Ridge Only", "DOTA_Tooltip_ability_"..item_name.."_Description")
	key.cantStash = true
	local drop = CreateItemOnPositionSync(position, key)
	RPCItems:DropItem(key, position)

	return key
end

function Redfall:PickupAshTwig()
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].RedfallQuests[4].state = 0
		Redfall:NewQuest(MAIN_HERO_TABLE[i], 4)
	end
end

function Redfall:SpawnAshTreant(position, fv)
	local unit = Spawning:Spawn("redfall_ashen_treant", position, 2, 4, "Redfall.AshTreeAggro", fv, true)
	Events:AdjustBossPower(unit, 5, 5, false)
	unit.itemLevel = 42

	unit:SetRenderColor(255, 60, 60)
	Redfall:ColorWearables(unit, Vector(255, 60, 60))
	return unit
end

function Redfall:DropEnchantedLeaf(position)
	local item_name = "item_redfall_glowing_redfall_leaf"
	local key = RPCItems:CreateConsumable(item_name, "rare", "redfall_leaf", "consumable", false, "Redfall Ridge Only", "DOTA_Tooltip_ability_"..item_name.."_Description")
	key.cantStash = true
	local drop = CreateItemOnPositionSync(position, key)
	RPCItems:DropItem(key, position)

	return key
end

function Redfall:PickupEnchantedLeaf()
	for i = 1, #MAIN_HERO_TABLE, 1 do
		MAIN_HERO_TABLE[i].RedfallQuests[5].state = 0
		Redfall:NewQuest(MAIN_HERO_TABLE[i], 5)
	end
end

function Redfall:SpawnStudentOfAshara(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 127, 0)
		Redfall:ColorWearables(unit, Vector(255, 110, 0))
		unit.targetRadius = 1000
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_ANY_ORDER
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_student_of_ashara",
		spawnPoint = position,
		minDrops = 1,
		maxDrops = 2,
		itemLevel = 25,
		aggroSound = "Redfall.AsharaStudent.Aggro",
		fv = fv,
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_NORMAL_CREEP,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ForestCrowStatueArea()
	local lookPosition = Vector(-2176, -12096)
	local vectorTable = {Vector(-2176, -11648), Vector(-1807, -11328), Vector(-1353, -11488), Vector(-1463, -11008), Vector(-832, -11008), Vector(-968, -10432), Vector(-512, -10249)}
	for i = 1, #vectorTable, 1 do
		local fv = (lookPosition - vectorTable[i]):Normalized()
		Redfall:SpawnStudentOfAshara(vectorTable[i], fv)
	end
end

function Redfall:CrowMovement(hero)
	if hero:HasModifier("modifier_raven_courier_active") then
		return false
	end

	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, hero, "modifier_raven_courier_active", {})
	local raven = CreateUnitByName("redfall_lzard_guide", Vector(-2048, -9344, 1457), false, nil, nil, DOTA_TEAM_GOODGUYS)
	raven:SetOriginalModel("models/items/beastmaster/hawk/beast_heart_marauder_beast_heart_marauder_raven/beast_heart_marauder_beast_heart_marauder_raven.vmdl")
	raven:SetModel("models/items/beastmaster/hawk/beast_heart_marauder_beast_heart_marauder_raven/beast_heart_marauder_beast_heart_marauder_raven.vmdl")
	raven:SetModelScale(1.2)
	raven:SetAbsOrigin(Vector(-2048, -9344, 1457))
	raven:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	raven:SetBaseMoveSpeed(360)
	raven:AddAbility("redfall_raven_courier_ability"):SetLevel(1)
	raven.hero = hero
	local ability = raven:FindAbilityByName("redfall_raven_courier_ability")
	ability.velocity = 40
	ability:ApplyDataDrivenModifier(raven, raven, "modifier_raven_seeking_hero", {})
end

function Redfall:SpawnRedfallWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)
	local unit = false
	for i = 0, quantity - 1, 1 do
		Timers:CreateTimer(i * delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
			end
			local creepFunction = function(unit)
				unit.dominion = true
				unit:SetAcquisitionRange(3000)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit, 2)
				if unit:GetUnitName() == "redfall_troll_warlord" then
					unit:SetRenderColor(255, 140, 30)
				elseif unit:GetUnitName() == "redfall_student_of_ashara" then
					unit:SetRenderColor(255, 120, 0)
					Redfall:ColorWearables(unit, Vector(255, 120, 0))
					unit:SetModelScale(unit:GetModelScale() * 0.74)
					unit.targetRadius = 1000
					unit.minRadius = 0
					unit.targetAbilityCD = 1
					unit.targetFindOrder = FIND_ANY_ORDER
				elseif unit:GetUnitName() == "redfall_armored_crab_beast" or unit:GetUnitName() == "redfall_autumn_mage" or unit:GetUnitName() == "redfall_canyon_alpha_beast" or unit:GetUnitName() == "redfall_canyon_breaker" then
					unit:SetRenderColor(255, 120, 0)
					Redfall:ColorWearables(unit, Vector(255, 120, 0))
					unit.targetRadius = 1000
					unit.minRadius = 0
					unit.targetAbilityCD = 1
					unit.targetFindOrder = FIND_ANY_ORDER
				end
			end
			local unit = Spawning:SpawnUnit{
				unitName = unitName,
				spawnPoint = spawnPoint,
				minDrops = 0,
				maxDrops = 1,
				itemLevel = itemLevel,
				aggroSound = nil,
				fv = fv,
				isAggro = true,
				deathModifier = "modifier_ashara_wave_unit",
				enemyType = ENEMY_TYPE_NORMAL_CREEP,
				creepFunction = creepFunction
			}
		end)
	end
end

function Redfall:SpawnAshara(position, fv)
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 7, 7, false)
		unit.jumpEnd = "basic_dust"
		unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 2000))
		WallPhysics:Jump(unit, Vector(1, 1), 0, 0, 0, 1)
		Timers:CreateTimer(1, function()
			EmitSoundOn("Redfall.Ashara.Taunt", unit)
		end)
		Timers:CreateTimer(2, function()
			StartAnimation(unit, {duration = 2.5, activity = ACT_DOTA_SPAWN, rate = 0.8, translate = "manias_mask"})
		end)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_ashara",
		spawnPoint = position,
		minDrops = 3,
		maxDrops = 5,
		itemLevel = 42,
		aggroSound = "Redfall.Ashara.Aggro",
		fv = fv,
		isAggro = true,
		deathModifier = "modifier_redfall_ashara_die",
		enemyType = ENEMY_TYPE_MINI_BOSS,
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShadowOfFenrir()
	Timers:CreateTimer(5, function()
		Redfall:SpawnFenrirGhost()
	end)
end

function Redfall:SpawnFenrirGhost()
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 2, 2, false)
		unit:SetRenderColor(255, 158, 158)
		local ability = unit:FindAbilityByName("redfall_fenrir_ability")
		ability:ApplyDataDrivenModifier(unit, unit, "modifier_fenrir_ghost", {})
		unit.movementTable = {Vector(-15680, -12864), Vector(-12176, -12322), Vector(-11682, -10065), Vector(-9487, -8279), Vector(-10560, -14528), Vector(-5828, -14311), Vector(-2114, -11472), Vector(-6080, -12096), Vector(-7309, -10572), Vector(-2424, -10367), Vector(-4864, -9216), Vector(-3392, -6720), Vector(-87, -6563), Vector(-5952, -4800), Vector(-3072, -4375), Vector(-9618, -5890), Vector(-6720, -9024)}
		FindClearSpaceForUnit(unit, unit.movementTable[RandomInt(1, #unit.movementTable)], false)
		unit.targetPoint = unit.movementTable[RandomInt(1, #unit.movementTable)]
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_fenrir",
		spawnPoint = Vector(-2114, -11472),
		minDrops = 2,
		maxDrops = 4,
		itemLevel = 40,
		aggroSound = nil,
		fv = Vector(1, 0),
		isAggro = false,
		deathModifier = nil,
		enemyType = ENEMY_TYPE_MINI_BOSS,
		creepFunction = creepFunction,
		canBeParagon = false
	}
	return unit
end

function Redfall:SpawnFenrir()
	local movementTable = {Vector(-15680, -12864), Vector(-12176, -12322), Vector(-11682, -10065), Vector(-9487, -8279), Vector(-10560, -14528), Vector(-5828, -14311), Vector(-2114, -11472), Vector(-6080, -12096), Vector(-7309, -10572), Vector(-2424, -10367), Vector(-4864, -9216), Vector(-3392, -6720), Vector(-87, -6563), Vector(-5952, -4800), Vector(-3072, -4375), Vector(-9618, -5890), Vector(-6720, -9024)}
	local spawnPoint = movementTable[RandomInt(1, #movementTable)]
	local firstTarget = movementTable[RandomInt(1, #movementTable)]
	local creepFunction = function(unit)
		Events:AdjustBossPower(unit, 2, 2, false)
		unit.itemLevel = 45
		unit:SetRenderColor(255, 158, 158)
		local ability = unit:FindAbilityByName("redfall_fenrir_ability")
		unit.movementTable = movementTable
		unit.targetPoint = firstTarget
		unit:MoveToPosition(unit.targetPoint)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_fenrir",
		spawnPoint = spawnPoint,
		minDrops = 2,
		maxDrops = 4,
		itemLevel = 45,
		aggroSound = "Redfall.Fenrir.Aggro",
		fv = Vector(1, 0),
		isAggro = false,
		deathModifier = "modifier_redfall_fenrir",
		enemyType = ENEMY_TYPE_MINI_BOSS,
		creepFunction = creepFunction
	}
	return unit

end

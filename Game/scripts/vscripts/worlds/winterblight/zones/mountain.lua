function Winterblight:InitMountain()
	Winterblight:MountainPrecache()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(1071, 2740), 9000, 50000, true)
	Winterblight:SpawnMountainTombstones()
	Timers:CreateTimer(2, function()
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(-256, -128), Vector(1, 0), false)
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(-1024, -384), Vector(1, -1), false)
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(128, -896), Vector(-1, 0), false)		
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(-2048, 2944), Vector(0, 1), false)
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(-1787, 2560), Vector(-0.7, 1), false)
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(-978, 4608), Vector(0, -1), false)
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(4608, 276), Vector(0, -1), false)
		Enemies:SpawnEnemyUnit("winterblight_mountain_tree", Vector(5376, 128), Vector(0, -1), false)
	end)
	Timers:CreateTimer(3, function()
		Enemies:SpawnEnemyUnit("winterblight_winters_chieftain", Vector(-256, 896), Vector(0.3, -1), false)
		Enemies:SpawnEnemyUnit("winterblight_winters_chieftain", Vector(2176, -256), Vector(0.3, -1), false)
	end)
	Timers:CreateTimer(4, function()
		local positionTable = {Vector(2944, 4096), Vector(512, 2255), Vector(-122, 4096)}
		Enemies:CreateUnitsWithPatrol("winterblight_snowvil_brute", 2, positionTable, 24, 7, 200, 120, 1, 1)
	end)
	Timers:CreateTimer(5, function()
		local positionTable = {Vector(711, 2560), Vector(1280, 2304), Vector(1837, 2713), Vector(1734, 3200), Vector(1072, 3584)}
		Enemies:CreateUnitsWithPatrol("winterblight_snowvil_shaman", 2, positionTable, 34, 7, 200, 120, 1, 1)
	end)
	Timers:CreateTimer(6, function()
		local positionTable = {Vector(2176, 1408), Vector(2342, 1224), Vector(2505, 1017), Vector(2688, 839)}
		for i = 1, #positionTable, 1 do
			Enemies:SpawnEnemyUnit("winterblight_snowvil_brute", positionTable[i], Vector(-1,-1), false)
		end
		for i = 1, #positionTable, 1 do
			Enemies:SpawnEnemyUnit("winterblight_snowvil_shaman", positionTable[i]+Vector(0,350), Vector(-1,-1), false)
		end
	end)
	Timers:CreateTimer(8, function()
		local chief = Enemies:SpawnEnemyUnit("winterblight_snowvil_chieftain", Vector(1280, 2944), Vector(-1,-1), false)
		Winterblight:SetPositionCastArgs(chief, 1200, 0, 1, FIND_ANY_ORDER)
	end)
	Timers:CreateTimer(7, function()
		Enemies:SpawnEnemyUnit("winterblight_winters_chieftain", Vector(3079, 1152), Vector(-1, 0), false)
		Enemies:SpawnEnemyUnit("winterblight_winters_chieftain", Vector(2938, 2621), Vector(0, -1), false)
	end)
	Timers:CreateTimer(15, function()
		local positionTable = {Vector(3712, 5504), Vector(3874, 5632), Vector(4081, 5888), Vector(4375, 6144), Vector(3421, 5902), Vector(3712, 6144), Vector(3840, 6504)}
		for i = 1, #positionTable, 1 do
			local fv = (positionTable[i] - Vector(3840, 5961)):Normalized()
			Winterblight:SpawnWintertideMonkMountain(positionTable[i], fv)
		end
	end)
	Timers:CreateTimer(3, function()
		local positionTable = {Vector(-2048, 2688), Vector(-1561, 2560), Vector(-1798, 2432), Vector(-1920, 2304), Vector(-1561, 2304), Vector(-1804, 2048), Vector(-1280, 2048)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnFrostAvatar(positionTable[i], fv)
		end
	end)
	Winterblight:SpawnOwlSentry(Vector(-128, 640), {Vector(5888, 5120), Vector(-512, 6695), Vector(1792, 1408), Vector(5760, 1664)})
	Timers:CreateTimer(8, function()
		Winterblight:SpawnOwlSentry(Vector(5888, 5120), {Vector(5760, 1664), Vector(1792, 1408), Vector(-512, 6695), Vector(-128, 640)})
	end)
	Timers:CreateTimer(10, function()
		Enemies:SpawnEnemyUnit("winterblight_hinterlands_guardian", Vector(4864, 5248), Vector(-1, -1), false)
		Enemies:SpawnEnemyUnit("winterblight_hinterlands_guardian", Vector(1152, 5504), Vector(0, -1), false)
		Enemies:SpawnEnemyUnit("winterblight_hinterlands_guardian", Vector(5504, 2560), Vector(-0.5, -1), false)
	end)
	Timers:CreateTimer(9, function()
		local positionTable = {Vector(4224, 1461), Vector(4616, 1461), Vector(4552, 1792), Vector(4482, 2048), Vector(4592, 2304), Vector(4817, 1920), Vector(4992, 1664)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(3456, 1792) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_demonoid", positionTable[i], fv, false)
		end

	end)
	Timers:CreateTimer(12, function()
		local positionTable = {Vector(4464, 4352), Vector(4489, 4352), Vector(4148, 4224), Vector(3840, 3968)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(3840, 4615) - positionTable[i]):Normalized()
			Winterblight:SpawnCorporealRevenant(positionTable[i], fv)
		end
	end)
	Timers:CreateTimer(14, function()
		Winterblight:SpawnBloodWraith(Vector(4224, 2743), Vector(0,-1))
		Winterblight:SpawnBloodWraith(Vector(3968, 1147), Vector(0, 1))
		Winterblight:SpawnBloodWraith(Vector(3584, 1024), Vector(-0.3, 1))
	end)
	Timers:CreateTimer(12, function()
		local positionTable = {Vector(-708, 6349), Vector(-582, 6016), Vector(-685, 5760), Vector(-640, 5498), Vector(-768, 5248)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnCorporealRevenant(positionTable[i], fv)
		end
	end)
	Timers:CreateTimer(18, function()
		local positionTable = {Vector(389, 5412), Vector(148, 5248), Vector(359, 4992), Vector(148, 4930), Vector(128, 4736)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Enemies:SpawnEnemyUnit("winterblight_yozario", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(24, function()
		local positionTable = {Vector(3698, 5504), Vector(1280, 6272), Vector(-640, 3712), Vector(3072, 1280)}
		Enemies:CreateUnitsWithPatrol("winterblight_yozario", 3, positionTable, 34, 7, 200, 120, 1, 1)
	end)
	Timers:CreateTimer(30, function()
		Winterblight:SpawnOwlSentry(Vector(-640, 5284), {Vector(1567, 7518), Vector(5888, 6400), Vector(3200, 918)})
	end)
	Timers:CreateTimer(50, function()
		Winterblight:SpawnOwlSentry(Vector(-2203, 6080), {Vector(360, 8120), Vector(7040, 256), Vector(4352, 6912), Vector(-2203, 6080)})
	end)
end

function Winterblight:MountainPrecache()
	if not Winterblight.MountainP3Precached then
		Precache:WinterPart3()
	end
end

function Winterblight:SpawnMountainTombstones()
	local positionTable = {Vector(698, 1978), Vector(-852, 1434), Vector(2560, -442), Vector(3116, 2666), Vector(2408, 7243), Vector(-424, 6939), Vector(-599, 3128), Vector(5484, 4139)}
	local shuffleTable = WallPhysics:ShuffleTable(positionTable)
	for i = 1, 3, 1 do
		local tombstone = Enemies:SpawnEnemyUnit("winterblight_mountain_tombstone", shuffleTable[i], RandomVector(1), false)
		local health = 100
		if GameState:GetDifficultyFactor() == 2 then
			health = 200
		elseif GameState:GetDifficultyFactor() == 3 then
			health = 300
		end
		tombstone:SetMaxHealth(health)
		tombstone:SetBaseMaxHealth(health)
		tombstone:SetHealth(health)
		tombstone:SetRenderColor(134, 158, 255)
	end
end

function Winterblight:MountainP2()
	Winterblight:MountainPrecache()
	Winterblight:SpawnMountainStonePack(Vector(5572, 7032))
end

function Winterblight:SpawnMountainStonePack(base_position)
	local mountain_bro_table = {}
	for i = 1, 8, 1 do
		local spawn_pos = base_position + RandomVector(RandomInt(0, 760))
		local rubble = Enemies:SpawnEnemyUnit("winterblight_composed_rubble", spawn_pos, RandomVector(1), false)
		rubble.phase = 0
		table.insert(mountain_bro_table, rubble)
	end
	for i = 1, #mountain_bro_table, 1 do
		mountain_bro_table[i].mountain_bro_table = mountain_bro_table
	end
end

function Winterblight:SpawnOwlSentry(start_position, patrol_point_table)
	local owl_sentry = Enemies:SpawnEnemyUnit("winterblight_owl_sentry", start_position, RandomVector(1), false)
	owl_sentry.patrol_point_table = patrol_point_table
	owl_sentry.patrol_index = 1
	owl_sentry:SetRenderColor(50, 50, 50)
	owl_sentry.aggro = nil
end

function Winterblight:SpawnHaunter(position, fv)
	local haunter =  Enemies:SpawnEnemyUnit("winterblight_haunter", position, fv, false)
	CustomAbilities:QuickParticleAtPoint("particles/roshpit/winterblight/blue_raze.vpcf", haunter:GetAbsOrigin(), 3)
	Winterblight:SetPositionCastArgs(haunter, RandomInt(400, 700), 0, 1, FIND_CLOSEST)
	return haunter
end

function Winterblight:SpawnWintertideMonkMountain(position, fv)
	local queen = Enemies:SpawnEnemyUnit("winterblight_wintertide_monk", position, fv, false)
	queen.dominion = true
	Events:ColorWearablesAndBase(queen, Vector(100, 140, 245))
	Events:AdjustBossPower(queen, 8, 8, false)
	Winterblight:SetPositionCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
	queen.randomMissMin = 200
	queen.randomMissMax = 600
	return queen
end
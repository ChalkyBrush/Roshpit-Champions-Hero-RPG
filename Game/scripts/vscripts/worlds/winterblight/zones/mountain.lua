function Winterblight:InitMountain()
	Winterblight:MountainPrecache()

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
		local chief = Enemies:SpawnEnemyUnit("winterblight_snowvil_chieftain", Vector(1320, 3044), Vector(-1,-1), false)
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
			Winterblight:SpawnIceHaunter(positionTable[i], fv)
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
		local positionTable = {Vector(4464, 4352), Vector(4148, 4224), Vector(3840, 3968)}
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
	Timers:CreateTimer(11, function()
		local positionTable = {Vector(3698, 5504), Vector(1280, 6272), Vector(-640, 3712), Vector(3072, 1280)}
		Enemies:CreateUnitsWithPatrol("winterblight_yozario", 3, positionTable, 34, 7, 200, 120, 1, 1)
	end)
	Timers:CreateTimer(30, function()
		Winterblight:SpawnOwlSentry(Vector(-640, 5284), {Vector(1567, 7518), Vector(5888, 6400), Vector(3200, 918)})
	end)
	Timers:CreateTimer(10, function()
		local chief = Enemies:SpawnEnemyUnit("winterblight_snowvil_chieftain", Vector(5632, 4096), Vector(0,-1), false)
		Winterblight:SetPositionCastArgs(chief, 1200, 0, 1, FIND_ANY_ORDER)
		local positionTable = {Vector(5417, 3840), Vector(5587, 3840), Vector(5760, 3840), Vector(5954, 3840), Vector(5417, 3584), Vector(5587, 3584), Vector(5760, 3584), Vector(5954, 3584)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,-1)
			Enemies:SpawnEnemyUnit("winterblight_snowvil_brute", positionTable[i], fv, false)
		end		
		Enemies:SpawnEnemyUnit("winterblight_snowvil_shaman", Vector(6061, 3200), Vector(-1,-1), false)
		Enemies:SpawnEnemyUnit("winterblight_snowvil_shaman", Vector(5888, 3328), Vector(-0.2,-1), false)
	end)
	Timers:CreateTimer(1, function()
		Winterblight:SpawnWinterRunner(Vector(-2304, 3840), Vector(-0.94,-0.2))
		Winterblight:SpawnWinterRunner(Vector(-2304, 4280), Vector(-1,0))
		Winterblight:SpawnWinterRunner(Vector(-2048, 4096), Vector(-0.4,-1))
	end)
	Timers:CreateTimer(13, function()
		Winterblight:SpawnWinterRunner(Vector(4924, 4766), Vector(-1,0.2))
		Winterblight:SpawnWinterRunner(Vector(4608, 4480), Vector(-1,0.3))
	end)
	Timers:CreateTimer(3.7, function()
		local positionTable = {Vector(3712, -256), Vector(4071, 128), Vector(4344, -135), Vector(4723, -384), Vector(4924, 0), Vector(5251, -256)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Winterblight:SpawnIcixel(positionTable[i], fv)
		end
	end)
	Timers:CreateTimer(35, function()
		local positionTable = {Vector(1692, 8192), Vector(1536, 7881), Vector(1792, 7881)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,-1)
			Enemies:SpawnEnemyUnit("winterblight_snowvil_brute", positionTable[i], fv, false)
		end				
	end)
	Timers:CreateTimer(36, function()
		local positionTable = {Vector(1132, 7881), Vector(855, 7946), Vector(1009, 8094), Vector(1161, 8192)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(1261, 7987) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_snowvil_shaman", positionTable[i], fv, false)
		end
		Winterblight:SpawnWinterRunner(Vector(512, 7552), Vector(-0.5,-0.9))
	end)
	Timers:CreateTimer(16, function()
		Winterblight:SpawnWinterRunner(Vector(6144, 1838), Vector(-0.94,-0.2))
		Winterblight:SpawnWinterRunner(Vector(5854, 1774), Vector(-1,0))
		Winterblight:SpawnWinterRunner(Vector(5632, 1587), Vector(-0.4,-1))
	end)
	Timers:CreateTimer(20, function()
		local positionTable = {Vector(3200, 6504), Vector(2836, 6314), Vector(2944, 6723), Vector(2560, 6535), Vector(2248, 6784), Vector(1920, 6528)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,-1)
			local bloodeater = Enemies:SpawnEnemyUnit("winterblight_snowvil_bloodeater", positionTable[i], fv, false)
			bloodeater:SetRenderColor(255, 75, 75)
		end
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
	local positionTable = {Vector(698, 1978), Vector(-852, 1434), Vector(2560, -442), Vector(3116, 2666), Vector(2408, 7243), Vector(-424, 6939), Vector(-599, 3128), Vector(5484, 4139), Vector(3873, 6854)}
	local pos1 = RandomInt(1, #positionTable)
	local pos2 = RandomInt(1, #positionTable)
	local pos3 = RandomInt(1, #positionTable)
	while pos1 == pos2 do
		pos2 = RandomInt(1, #positionTable)
	end
	while pos3 == pos1 or pos3 == pos2 do
		pos3 = RandomInt(1, #positionTable)
	end
	local shuffleTableTomb = {positionTable[pos1], positionTable[pos2], positionTable[pos3]}
	for i = 1, 3, 1 do
		local tombstone = Enemies:SpawnEnemyUnit("winterblight_mountain_tombstone", shuffleTableTomb[i], RandomVector(1), false)
		tombstone.index = i
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



function Winterblight:SpawnMountainStonePack(base_position)
	local mountain_bro_table = {}
	for i = 1, 8, 1 do
		local spawn_pos = base_position + RandomVector(RandomInt(0, 460))
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

function Winterblight:MountainGhostProp()
	Winterblight:MountainGhostScare()
end

function Winterblight:MountainP2()
	Winterblight:MountainPrecache()
	Winterblight:SpawnMountainStonePack(Vector(5572, 7032))
	Timers:CreateTimer(2, function()
		Winterblight:SpawnMountainStonePack(Vector(4625, 8576))
	end)
	Timers:CreateTimer(1, function()
		local positionTable = {Vector(2304, 9040), Vector(2048, 9223), Vector(1792, 9228), Vector(1908, 9472), Vector(2242, 9344), Vector(2111, 9728)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(2560, 9856) - positionTable[i]):Normalized()
			local bloodeater = Enemies:SpawnEnemyUnit("winterblight_frozen_soul", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(4052, 8511), Vector(4102, 8832), Vector(4096, 9216), Vector(3896, 9113), Vector(3768, 8850), Vector(3724, 8576)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(4608, 8602) - positionTable[i]):Normalized()
			local bloodeater = Enemies:SpawnEnemyUnit("winterblight_demonoid", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(2.8, function()
		local positionTable = {Vector(2953, 8835), Vector(3139, 9174), Vector(3495, 9335)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(3968, 8813) - positionTable[i]):Normalized()
			local bloodeater = Enemies:SpawnEnemyUnit("winterblight_frozen_mage", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(3, function()
		local positionTable = {}
		Enemies:CreateUnitsWithPatrol("winterblight_wraithguard_elite", 2, positionTable, 24, 9, 500, 500, 1, 1)
	end)
	Timers:CreateTimer(4, function()
		local positionTable = {Vector(2304, 10496), Vector(2411, 11654), Vector(2560, 13568)}
		Enemies:CreateUnitsWithPatrol("winterblight_wraithguard_elite", 2, positionTable, 24, 7, 500, 500, 1, 1)
	end)
	Timers:CreateTimer(5, function()
		Winterblight:SpawnMountainStonePack(Vector(3405, 11663))
	end)
	Timers:CreateTimer(6, function()
		local positionTable = {Vector(2176, 12544), Vector(2432, 12544), Vector(2688, 12544), Vector(2176, 12288), Vector(2432, 12288), Vector(2688, 12288)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,-1)
			local bloodeater = Enemies:SpawnEnemyUnit("winterblight_wraithguard", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(7, function()
		local positionTable = {Vector(1152, 10240), Vector(1280, 10363), Vector(1408, 10233), Vector(1426, 10443), Vector(1601, 10376), Vector(1734, 10240), Vector(1734, 10544)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(1920, 10112) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_frozen_phantom", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(2944, 10112), Vector(3153, 9862)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(2663, 9643) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_frozen_cage", positionTable[i], fv, false)
		end
		local positionTable = {Vector(3893, 10136), Vector(4224, 10202)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(0,1)
			Enemies:SpawnEnemyUnit("winterblight_frozen_cage", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(2.5, function()
		local positionTable = {Vector(3738, 10864), Vector(3947, 10954), Vector(4224, 10920), Vector(4352, 10836)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(4112, 10526) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_frozen_phantom", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(7, function()
		local positionTable = {Vector(843, 11037), Vector(1152, 10901), Vector(896, 10752)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(1280, 10496) - positionTable[i]):Normalized()
			local bloodeater = Enemies:SpawnEnemyUnit("winterblight_wraithguard", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(6.4, function()
		local positionTable = {Vector(1152, 9728), Vector(768, 9455), Vector(256, 9419), Vector(678, 8959)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(1408, 9984) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_frozen_cage", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(10, function()
		local positionTable = {Vector(3919, 11904), Vector(4039, 11602), Vector(3968, 11392)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Enemies:SpawnEnemyUnit("winterblight_yozario", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(3.4, function()
		local positionTable = {Vector(-384, 8704), Vector(123, 8354)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(42, 8960) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_wraithguard_elite", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(1.5, function()
		local positionTable = {Vector(419, 9984), Vector(566, 10525), Vector(1117, 12031), Vector(938, 11776)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(4096, 8704) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_skeleton_archer", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(4864, 9216), Vector(4508, 9289)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(6016, 10735) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_skeleton_archer", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(5.8, function()
		local positionTable = {Vector(3040, 10852), Vector(2895, 11056)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(2688, 10624) - positionTable[i]):Normalized()
			local bloodeater = Enemies:SpawnEnemyUnit("winterblight_frozen_mage", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(14, function()
		local positionTable = {Vector(1536, 14464), Vector(1536, 14863), Vector(1792, 15360), Vector(2108, 15824), Vector(2587, 16128), Vector(3289, 16165)}
		for i = 1, #positionTable, 1 do
			local fv = (positionTable[i] - Vector(2851, 14720)):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_skeleton_archer", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(16, function()
		local positionTable = {Vector(2048, 14592), Vector(3072, 14208)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(2432, 12672) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_defiler", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(9, function()
		local positionTable = {Vector(1738, 13378), Vector(1920, 13098), Vector(1640, 12986)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(2313, 12822) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_frozen_cage", positionTable[i], fv, false)
		end
	end)	
	Timers:CreateTimer(18, function()
		local positionTable = {Vector(3724, 14062), Vector(3584, 14720), Vector(4163, 14464)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(2944, 14464) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
		end
	end)
	
end

function Winterblight:InitGraveGhost(grave_index)
	if grave_index == 1 then
		local grave_pos = Vector(-151, 8062)
		local search_position = Vector(-128, 8516)
		local fv = WallPhysics:angleToVector(75)
		local ghost = Enemies:SpawnEnemyUnit("winterblight_grave_ghost", grave_pos, fv, false)
		-- local zOffset = 820
		-- ghost:SetAbsOrigin(grave_pos + Vector(0,0,zOffset))
		ghost.search_position = search_position
		EmitSoundOn("Winterblight.Tombstone.GhostScareEnd", ghost)
		ghost.grave_index = 1
		ghost.sequence = 0
	elseif grave_index == 2 then
		local grave_pos = Vector(892, 11489)
		local search_position = Vector(1280, 11136)
		local fv = WallPhysics:angleToVector(330)
		local ghost = Enemies:SpawnEnemyUnit("winterblight_grave_ghost", grave_pos, fv, false)
		-- local zOffset = 584
		-- ghost:SetAbsOrigin(grave_pos + Vector(0,0,zOffset))
		ghost.search_position = search_position
		EmitSoundOn("Winterblight.Tombstone.GhostScareEnd", ghost)
		ghost.grave_index = 2
		ghost.sequence = 0
	elseif grave_index == 3 then
		local grave_pos = Vector(4569, 10515)
		local search_position = Vector(4028, 10629)
		local fv = Vector(-1,0)
		local ghost = Enemies:SpawnEnemyUnit("winterblight_grave_ghost", grave_pos, fv, false)
		-- local zOffset = 572
		-- ghost:SetAbsOrigin(grave_pos + Vector(0,0,zOffset))
		ghost.search_position = search_position
		EmitSoundOn("Winterblight.Tombstone.GhostScareEnd", ghost)
		ghost.grave_index = 3
		ghost.sequence = 0
	end
end

function Winterblight:MountainGhostScare()
	Timers:CreateTimer(5, function()
	local positionTable = {Vector(1920, 14592), Vector(2247, 15146), Vector(2990, 15726)}
		for i = 1, #positionTable, 1 do
			local delay = 1.5
			if i == 2 then
				delay = 4
			elseif i == 3 then
				delay = 8
			end
			Timers:CreateTimer(delay, function()
				local ghost = CreateUnitByName("npc_dummy_unit", positionTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
				ghost:SetAbsOrigin(ghost:GetAbsOrigin() - Vector(0,0,300))
				local luck = RandomInt(1, 2)
				if luck == 1 then
					Events:smoothTranslate(ghost, Vector(0,0,20), 15, -1, "Winterblight.Tombstone.MountainGhostScare")
				else
					Events:smoothTranslate(ghost, Vector(0,0,20), 15, -1, "Winterblight.Tombstone.GhostScare")
				end
				local fv = (Vector(2890, 14581) - positionTable[i]):Normalized()
				ghost:SetForwardVector(fv)
				ghost:SetOriginalModel("models/items/necrolyte/necro_ti9_immortal_skirt/necro_ti9_immortal_ghost.vmdl")
				ghost:SetModel("models/items/necrolyte/necro_ti9_immortal_skirt/necro_ti9_immortal_ghost.vmdl")
				Events:smoothSizeChange(ghost, 0.1, 3, 40)
				EmitSoundOn("Winterblight.CrowSentry.HauntStart", ghost)
				local pfx = ParticleManager:CreateParticle("particles/roshpit/seafortress/big_dust.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
				ParticleManager:SetParticleControl(pfx, 0, ghost:GetAbsOrigin()+Vector(-150,0,240))
				local blueFactor = RandomInt(50, 90)/100
				ParticleManager:SetParticleControl(pfx, 5, Vector(0.4, 0.5, blueFactor))
				ParticleManager:SetParticleControl(pfx, 2, Vector(0.2, 0.2, 0.2))
				Timers:CreateTimer(6, function()
					ParticleManager:DestroyParticle(pfx, false)
					ParticleManager:ReleaseParticleIndex(pfx)
				end)
				Timers:CreateTimer(18.5-delay, function()
					EmitSoundOn("Winterblight.CrowSentry.HauntEnd", ghost)
					Events:smoothSizeChange(ghost, 3, 0.01, 15)
				end)
				Timers:CreateTimer(19.5-delay, function()
					UTIL_Remove(ghost)
				end)
			end)
		end
	end)
end

function Winterblight:EvilExplosion(position)
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/winterblight/evil_explosion.vpcf", position, 8)
	ParticleManager:SetParticleControl(pfx, 1, Vector(1,0,0))
	ParticleManager:SetParticleControl(pfx, 11, Vector(0.5,0,0))
end

function Winterblight:InitOutsideCastleSwitch()
	local switch = Entities:FindByNameNearest("WinterCastleSwitchProp", Vector(4224, 15936, 646), 2000)
	local zDifferential = switch:GetAbsOrigin().z - 646.642

	Winterblight.MountainSwitchIndex = RandomInt(1, 6)
	if Winterblight.MountainSwitchIndex == 2 then
		switch:SetAbsOrigin(Vector(6768, 16012, 902+zDifferential))
	elseif Winterblight.MountainSwitchIndex == 3 then
		switch:SetAbsOrigin(Vector(8270, 15971, 1167+zDifferential))
	elseif Winterblight.MountainSwitchIndex == 4 then
		switch:SetAbsOrigin(Vector(8251, 10920, 1167+zDifferential))
	elseif Winterblight.MountainSwitchIndex == 5 then
		switch:SetAbsOrigin(Vector(6750, 11235, 1167+zDifferential))
	elseif Winterblight.MountainSwitchIndex == 6 then
		switch:SetAbsOrigin(Vector(3877, 12379, 640+zDifferential))
	end
end

function Winterblight:MountainP3()
	Winterblight:MountainPrecache()
	Timers:CreateTimer(3, function()
		local positionTable = {Vector(5504, 14720), Vector(5760, 14450), Vector(6144, 14450)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(5632, 13952) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_mountain_spirit", positionTable[i], fv, false)
		end
	end)	
	Timers:CreateTimer(3.5, function()
		local positionTable = {Vector(5888, 14976), Vector(6016, 14888), Vector(6144, 14785), Vector(6144, 14976), Vector(6016, 15078), Vector(5888, 15166), Vector(6144, 15232), Vector(6016, 15334), Vector(5888, 15422)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(5632, 13952) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_frozen_phantom", positionTable[i], fv, false)
		end

		Enemies:SpawnEnemyUnit("winterblight_ancient_mountain_spirit", Vector(6247, 15635), Vector(0,-1), false)
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(5908, 12594), Vector(6144, 12928)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(5632, 13952) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
		end
	end)	
	Timers:CreateTimer(4, function()
		local positionTable = {Vector(6272, 13598), Vector(5550, 13794), Vector(5376, 13440)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(5033, 13851) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_defiler", positionTable[i], fv, false)
		end
	end)	
	Timers:CreateTimer(1, function()
		local positionTable = {Vector(3896, 15848), Vector(4163, 15558), Vector(4251, 15232), Vector(4065, 13312), Vector(3854, 13056), Vector(3675, 12800), Vector(3646, 12544)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(-1, 0)
			Enemies:SpawnEnemyUnit("winterblight_soul_fletcher", positionTable[i], fv, false)
		end
	end)	
	Timers:CreateTimer(4, function()
		local positionTable = {Vector(7296, 15052), Vector(6912, 15360)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(2944, 14464) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(6, function()
		local positionTable = {Vector(4751, 12288), Vector(4480, 12288), Vector(4572, 12544), Vector(4736, 12672), Vector(4736, 12915), Vector(4480, 12822), Vector(4302, 12672)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(5504, 12544) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_frozen_mage", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(7, function()
		local positionTable = {Vector(6474, 11648), Vector(6474, 12062), Vector(6615, 12416), Vector(6705, 12840)}
		for i = 1, #positionTable, 1 do
			local fv = Vector(-1, 0)
			Enemies:SpawnEnemyUnit("winterblight_soul_fletcher", positionTable[i], fv, false)
		end
	end)	
	Timers:CreateTimer(8, function()
		local positionTable = {Vector(5057, 15702), Vector(4864, 15488), Vector(4743, 15795)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Enemies:SpawnEnemyUnit("winterblight_skeleton_archer", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(10, function()
		for i = 0, 4, 1 do
			local unit = Winterblight:SpawnSkaterFiend(Vector(8586 + RandomInt(0, 730), 14445 + RandomInt(0, 380)), RandomVector(1))
			unit.minVector = Vector(8586, 14445)
			unit.maxXroam = 730
			unit.maxYroam = 380
		end
	end)
	Timers:CreateTimer(11, function()
		local positionTable = {Vector(7330, 12288), Vector(7603, 12160), Vector(7424, 11904)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Enemies:SpawnEnemyUnit("winterblight_frozen_mage", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(12, function()
		local positionTable = {Vector(6707, 11668), Vector(6889, 11459), Vector(7168, 11240), Vector(6912, 11046)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(7623, 13315) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
		end
	end)

	Timers:CreateTimer(14, function()
		for i = 0, 2, 1 do
			for j = 0, 1, 1 do
				Enemies:SpawnEnemyUnit("winterblight_frozen_cage", Vector(8609+(240*j), 12876+(240*i)), Vector(-1,0), false)
			end
		end
		for i = 0, 2, 1 do
			Enemies:SpawnEnemyUnit("winterblight_mountain_spirit", Vector(9180, 12876+(240*i)), Vector(-1,0), false)
		end
		Enemies:SpawnEnemyUnit("winterblight_ancient_mountain_spirit", Vector(9450, 12876+240), Vector(-1,0), false)
	end)
	Timers:CreateTimer(15, function()
		Winterblight:SpawnMountainStonePack(Vector(8576, 12416))
	end)
	Timers:CreateTimer(2, function()
		local positionTable = {Vector(8258, 12398), Vector(7871, 14976), Vector(9856, 14976), Vector(9856, 11776)}
		Enemies:CreateUnitsWithPatrol("winterblight_black_gargoyle", 3, positionTable, 34, 7, 300, 300, 1, 1)
	end)

	Timers:CreateTimer(10, function()
		local positionTable = {Vector(7787, 13512), Vector(7395, 13783), Vector(7680, 14208), Vector(10240, 14028), Vector(9980, 14572), Vector(10264, 15042)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(6528, 14336) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_draugr", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(12, function()
		local positionTable = {Vector(9856, 15946), Vector(9600, 15360), Vector(9344, 15699)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(15, function()
		local positionTable = {Vector(8064, 11264), Vector(7936, 11531), Vector(8264, 11648)}
		for i = 1, #positionTable, 1 do
			local fv = RandomVector(1)
			Enemies:SpawnEnemyUnit("winterblight_defiler", positionTable[i], fv, false)
		end
	end)

	Timers:CreateTimer(16, function()
		local positionTable = {Vector(10368, 12104), Vector(9791, 12104), Vector(9281, 12104), Vector(8878, 11520), Vector(8703, 11264), Vector(8832, 10880)}
		for i = 1, #positionTable, 1 do
			local fv = (positionTable[i] - Vector(10624, 10880)):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_skeleton_archer", positionTable[i], fv, false)
		end
	end)
	Timers:CreateTimer(17, function()
		local positionTable = {Vector(9658, 11648), Vector(9413, 11375), Vector(9216, 11136)}
		for i = 1, #positionTable, 1 do
			local fv = (Vector(8781, 11740) - positionTable[i]):Normalized()
			Enemies:SpawnEnemyUnit("winterblight_accursed", positionTable[i], fv, false)
		end
		if GameState:GetDifficultyFactor() > 2 then
			Enemies:SpawnEnemyUnit("winterblight_ancient_mountain_spirit", Vector(10065, 10410), Vector(-1,-1), false)
		end
	end)
end

function Winterblight:InitCastleDoorKeys()
	local key1 = Entities:FindByNameNearest("CastleDoorKey1", Vector(10699, 13819, 1615), 1000)
	key1:SetAbsOrigin(key1:GetAbsOrigin() - Vector(0,0,660))

	local key2 = Entities:FindByNameNearest("CastleDoorKey2", Vector(10699, 13606, 1615), 1000)
	key2:SetAbsOrigin(key2:GetAbsOrigin() - Vector(0,0,660))

	local key3 = Entities:FindByNameNearest("CastleDoorKey3", Vector(10699, 13402, 1615), 1000)
	key3:SetAbsOrigin(key3:GetAbsOrigin() - Vector(0,0,660))
end


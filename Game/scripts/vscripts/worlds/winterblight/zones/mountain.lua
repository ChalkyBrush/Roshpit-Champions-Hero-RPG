function Winterblight:InitMountain()
	Precache:WinterPart3()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(1071, 2740), 9000, 50000, true)
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
		Enemies:SpawnEnemyUnit("winterblight_snowvil_chieftain", Vector(1280, 2944), Vector(-1,-1), false)
		
	end)
	Timers:CreateTimer(7, function()
		Enemies:SpawnEnemyUnit("winterblight_winters_chieftain", Vector(3079, 1152), Vector(-1, 0), false)
		Enemies:SpawnEnemyUnit("winterblight_winters_chieftain", Vector(2938, 2621), Vector(0, -1), false)
	end)
end



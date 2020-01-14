function Winterblight:InitMountain()
	Precache:WinterPart3()
	local positionTable = {Vector(2954, 1152), Vector(2816, 1408), Vector(2472, 1408), Vector(2176, 1408), Vector(1871, 1536), Vector(2025, 1664), Vector(2560, 1664), Vector(2713, 1920), Vector(2144, 1920)}
	for i = 1, #positionTable, 1 do
		Enemies:SpawnEnemyUnit("winterblight_snowvil_brute", positionTable[i], RandomVector(1), false)
	end
end
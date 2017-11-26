function Winterblight:SpawnCrabSpawner(position, fv, summonCenter)
	local stone = Winterblight:SpawnDungeonUnit(  "winterblight_snowcrab_eggs", position, 2, 3, nil, fv, false)
	-- stone:SetRenderColor(180,180,255)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 24
	stone.summonCenter = summonCenter
	return stone
end

function Winterblight:SpawnSpawnerUnit(position, fv, itemRoll, bAggro)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_snow_crab", position, itemRoll, itemRoll, nil, fv, bAggro)
	stone:SetRenderColor(210,230,255)
	stone.itemLevel = 12
	stone.dominion = true
	return stone
end

function Winterblight:SpawnWinterSeal(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_seal", position, 1, 1, "Seafortress.Seal.Aggro", fv, false)
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



function Winterblight:FirstSpawns()
	local luck = RandomInt(1,3)
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
	      Timers:CreateTimer(i*1.2, function()
	        local patrolPositionTable = {}
	        for j = 1, #positionTable, 1 do
	          local index = i + j
	          if index > #positionTable then
	            index = index - #positionTable
	          end
	          table.insert(patrolPositionTable, positionTable[index])
	        end
	        for j = 0, 1, 1 do
	          Timers:CreateTimer(j*2, function()
	            local elemental = Winterblight:SpawnWinterSeal(positionTable[i]+RandomVector(120), RandomVector(1))
	            Winterblight:AddPatrolArguments(elemental, 35, 5, 240, patrolPositionTable)
	          end)
	        end
	      end)
	    end
	end
	Timers:CreateTimer(3, function()
		local luck = RandomInt(1, 3)
		if luck == 1 then
			Winterblight:SpawnMountainOgre(Vector(-12416, -2752), Vector(-1,0.2))
			Winterblight:SpawnMountainOgre(Vector(-11058, -3861), Vector(0,-1))
			Winterblight:SpawnMountainOgre(Vector(-10459, -4160), Vector(0,-1))
		elseif luck == 2 then
			Winterblight:SpawnMountainOgre(Vector(-10944, -4161), Vector(-1,0))
			Winterblight:SpawnMountainOgre(Vector(-10944, -4544), Vector(-1,0))
			Winterblight:SpawnMountainOgre(Vector(-10496, -4544), Vector(-1,0))
			Winterblight:SpawnMountainOgre(Vector(-10496, -4161), Vector(-1,0))
		elseif luck == 3 then
   			local positionTable = {Vector(-10432, -3904), Vector(-11520, -3968), Vector(-10112, -4800)}
		    for i = 1, #positionTable, 1 do
		      Timers:CreateTimer(i*1.2, function()
		        local patrolPositionTable = {}
		        for j = 1, #positionTable, 1 do
		          local index = i + j
		          if index > #positionTable then
		            index = index - #positionTable
		          end
		          table.insert(patrolPositionTable, positionTable[index])
		        end
	            local elemental = Winterblight:SpawnMountainOgre(positionTable[i]+RandomVector(120), RandomVector(1))
	            Winterblight:AddPatrolArguments(elemental, 30, 5, 240, patrolPositionTable)
		      end)
		    end
		    local elemental = Winterblight:SpawnWinterSeal(Vector(-11392, -4800), RandomVector(1))
		    Winterblight:SpawnCrabSpawner(Vector(-11008, -4672), Vector(0,1), Vector(-12992, -3264))
		end
	end)
	Winterblight:SpawnMonolith(Vector(-10357, -3776), Vector(0,-1))
end
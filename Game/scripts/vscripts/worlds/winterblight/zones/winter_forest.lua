function Winterblight:InitWinterForest()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-6400, 200), 8000, 999999, false)

	Precache:WinterblightCavern()
	Timers:CreateTimer(3, function()
   		local positionTable = {Vector(-7680, 768), Vector(-6912, -372), Vector(-5865, -147), Vector(-5376,166), Vector(-5558, 1024), Vector(-5558, 1792)}
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
	            local elemental = Winterblight:SpawnScouringSharpa(positionTable[i]+RandomVector(120), RandomVector(1))
	            Winterblight:AddPatrolArguments(elemental, 35, 5, 240, patrolPositionTable)
	          end)
	        end
	      end)
	    end
	end)
	Timers:CreateTimer(1, function()
		Winterblight:SpawnFrigidGrowth(Vector(-7469, -338), Vector(-1,0))
		Winterblight:SpawnFrigidGrowth(Vector(-7469, -579), Vector(-1,0))
		Winterblight:SpawnFrigidGrowth(Vector(-7044, -144), Vector(0,1))
		Winterblight:SpawnFrigidGrowth(Vector(-5889, -64), Vector(0,1))
	end)
	Timers:CreateTimer(3, function()
		local positionTable = {Vector(-6779, -903), Vector(-6400, -1299), Vector(-6015, -1144), Vector(-5652, -1511), Vector(-5296, -1280), Vector(-5496, -1280)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*0.3, function()
				Winterblight:SpawnSkatingZealot(positionTable[i], RandomVector(1), Vector(-6656, -1351), 1320, 350)
			end)
		end
		Winterblight:SpawnSkatingZealot(Vector(-6262, 942), RandomVector(1), Vector(-6648, 767), 500, 290)
		Winterblight:SpawnSkatingZealot(Vector(-6512, 820), RandomVector(1), Vector(-6648, 767), 500, 290)
	end)
	Timers:CreateTimer(6, function()
		Winterblight:SpawnRelict(Vector(-5760, 640), Vector(1,-1))
		Winterblight:SpawnRelict(Vector(-5992, 1746), Vector(0,1))
		Winterblight:SpawnRelict(Vector(-7142, 2055), Vector(1,-0.5))
		Winterblight:SpawnRelict(Vector(-6650, 2798), Vector(1,0.1))
		Timers:CreateTimer(2, function()
			Winterblight:SpawnRelict(Vector(-5149, 1280), Vector(-1,-0.5))
			Winterblight:SpawnRelict(Vector(-5248, 1024), Vector(-1,-0.1))
		end)
	end)
end

function Winterblight:SpawnScouringSharpa(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_scouring_sherpa", position, 1, 1, "Winterblight.Sherpa.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 26
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnSkatingZealot(position, fv, minVector, maxXroam, maxYroam)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_skating_zealot", position, 0, 1, "Winterblight.SkatingZealot.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 42
	stone.dominion = true
	stone:SetRenderColor(42, 251, 255)
	stone.minVector = minVector
	stone.maxXroam = maxXroam
	stone.maxYroam = maxXroam
	return stone
end

function Winterblight:SpawnRelict(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_relict", position, 1, 2, "Winterblight.Relict.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 26
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	Winterblight:SetPositionCastArgs(stone, 1400, 0, 1, FIND_ANY_ORDER)
	-- stone:AddNewModifier(stone, nil, "modifier_animation", {translate="hunter_night"})
	-- stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="hunter_night"})
	return stone
end
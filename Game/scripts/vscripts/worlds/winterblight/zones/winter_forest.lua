function Winterblight:InitWinterForest()
	Precache:WinterblightCavern()
	Timers:CreateTimer(5, function()
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
end

function Winterblight:SpawnScouringSharpa(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_scouring_sherpa", position, 1, 1, "Winterblight.Sherpa.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 26
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end
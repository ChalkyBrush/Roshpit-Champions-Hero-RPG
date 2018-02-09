function CliffTrigger(trigger)
	local hero = trigger.activator
	local luck = RandomInt(1, 3)
	luck = 3
	if luck == 1 then
		local posTable = {Vector(-10368, -6032), Vector(-10560, -5927), Vector(-10716, -5696), Vector(-10752, -5839), Vector(-10944, -5721), Vector(-10944, -5568), Vector(-11136, -5568)}
		local jumpPosTable = {Vector(-9648, -4757), Vector(-9920, -5086), Vector(-10368, -4960), Vector(-10082, -4672), Vector(-10722, -4771), Vector(-10432, -4567)}
		for i = 1, 6 + GameState:GetDifficultyFactor()*3, 1 do
			Timers:CreateTimer(i*0.6, function()
				local position = posTable[RandomInt(1, #posTable)]
				local jumpToPos = jumpPosTable[RandomInt(1, #jumpPosTable)]
				local fv = (jumpToPos - position):Normalized()
				local assassin = Winterblight:SpawnAssassin(position, fv)
				Timers:CreateTimer(0.2, function()
					local targetPoint = jumpToPos + RandomVector(RandomInt(0, 320))	- fv*400
					local jumpAbility = assassin:FindAbilityByName("assassin_jump")		
					local order =
					{
						UnitIndex = assassin:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = jumpAbility:entindex(),
						Position = targetPoint
					}
					ExecuteOrderFromTable(order)
				end)
			end)
		end
	elseif luck == 2 then
		local luck2 = RandomInt(1,2)
		if luck2 == 1 then
			for i = 0, 15 + GameState:GetDifficultyFactor()*4, 1 do
				Timers:CreateTimer(0.03*i, function()
					local position = Vector(-10360+RandomInt(0, 1000), -5120+RandomInt(0, 900))
					Winterblight:SpawnMountainCritter(position, Vector(-1, 0.3))
				end)
			end
		else
			for i = 0, 15 + GameState:GetDifficultyFactor()*4, 1 do
				Timers:CreateTimer(0.03*i, function()
					local position = Vector(-9806, -4785)+RandomVector(RandomInt(200, 900))
					local fv = (position - Vector(-9806, -4785)):Normalized()
					Winterblight:SpawnMountainCritter(position, fv)
				end)
			end
		end
	elseif luck == 3 then
		for i = 0, 12 + GameState:GetDifficultyFactor()*3, 1 do
			Timers:CreateTimer(0.03*i, function()
				local position = Vector(-10360+RandomInt(0, 1100), -5120+RandomInt(0, 960))
				Winterblight:SpawnMountainBeetle(position, RandomVector(1))
			end)
		end
	end
end
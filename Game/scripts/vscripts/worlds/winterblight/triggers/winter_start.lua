function CliffTrigger(trigger)
	local hero = trigger.activator
	local luck = RandomInt(1, 3)
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

function IceShatterArea(trigger)
	Winterblight:IceCrystalArea()
end

function SnowCaveTrigger(trigger)
	Winterblight:SnowCaveArea()
end

function Ice1(trigger)
	local hero = trigger.activator
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, hero, "modifier_ice_sliding", {})
end

function IceEnd(trigger)
	local hero = trigger.activator
	hero:RemoveModifierByName("modifier_ice_sliding")
end

function CliffTrigger2(trigger)
	local hero = trigger.activator


	local posTable = {Vector(-320, -9664), Vector(-64, -9664), Vector(192, -9664), Vector(448, -9664), Vector(704, -9530), Vector(855, -9280), Vector(855, -9024), Vector(855, -8768)}
	for i = 1, 5 + GameState:GetDifficultyFactor()*2, 1 do
		Timers:CreateTimer(i*0.6, function()
			local position = posTable[RandomInt(1, #posTable)]
			local jumpToPos = Vector(-512, -7963)
			local fv = (jumpToPos - position):Normalized()
			local assassin = Winterblight:SpawnAssassin(position, fv)
			Timers:CreateTimer(0.2, function()
				local targetPoint = jumpToPos + RandomVector(RandomInt(0, 520))	- fv*400
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

end

function AzaleaSpawn1(trigger)
	Winterblight:FirstOutsideAzaleaPocketSpawn()
end

function AzaleaSpawn2(trigger)
	Winterblight:AzaleaMainSpawn()
end

function ShrineSpawn1(trigger)
	Winterblight:FirstShrineSpawn()
end

function ShrineSpawn2(trigger)
	Winterblight:ShrineSpawn2()
end

function AzaleaSwitch1(trigger)
	Winterblight:AzaleaSwitch1()
end

function ShrineSpawn3(trigger)
	Winterblight:ShrineSpawn3()
end

function AzaleaPortal(trigger)
	local activator = trigger.activator
	local caller = trigger.caller
	if activator:HasModifier("modifier_recently_teleported_portal") then
		return false
	end
	if WallPhysics:GetDistance2d(caller:GetAbsOrigin(), activator:GetAbsOrigin()) < 200 then
		if not Winterblight.AzaleaPortalTable then
			Winterblight.AzaleaPortalTable = {0, 0, 0, 0, 0, 0}
		end

		local portalIndex = caller:GetName():gsub('AzaleaPortal', "")
		portalIndex = tonumber(portalIndex)
		local tp_position = activator:GetAbsOrigin()
		if portalIndex == 1 then
			tp_position = Vector(11157, -11941, 192+Winterblight.ZFLOAT)
		elseif portalIndex == 2 then
			tp_position = Vector(12032, -15488, 192+Winterblight.ZFLOAT)
		end
		if Winterblight.AzaleaPortalTable[portalIndex] == 1 then
			Events:TeleportUnit(activator, tp_position, Events.GameMaster.portal, Events.GameMaster, 1.2)
		end
	end
end

function AzaleaSwitch2(trigger)
	if not Winterblight.AzaleaSwitch2pressed then
		Winterblight.AzaleaSwitch2pressed = true
		Winterblight:AzaleaSwitch2(trigger)
	end
end

function ShrineSpawn4(trigger)
	Winterblight:ShrineSpawn4()
end

function ShrineSpawn5(trigger)
	Winterblight:ShrineSpawn5()
end

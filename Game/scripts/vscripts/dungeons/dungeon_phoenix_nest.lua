function Dungeons:InitializePhoenixNest()
	-- Dungeons.phoenixCollision = true
	--^^ ACTIVE THIS SO YOU CANT GO UP WALLS

	Dungeons.phoenixWave = 1
	Dungeons.phoenixMobsKilled = 0
	Dungeons.phoenixMobsThreshold = 40
	Dungeons.wavePrefix = ""

	Dungeons.spawnPointSouth = Vector(3136, -16064)
	Dungeons.spawnPointEast = Vector(6848, -12480)
	Dungeons.spawnPointNorth = Vector(3136, -9664)
	Dungeons.spawnPointWest = Vector(-1152, -12416)
	Dungeons.phoenixEggLocation = Vector(3093, -12522, 0)

	Dungeons.beaconSWLoc = Vector(5098, -10560)
	Dungeons.beaconSELoc = Vector(1280, -10432)
	Dungeons.beaconNELoc = Vector(1216, -14359)
	Dungeons.beaconNWLoc = Vector(5120, -14464)
	Dungeons.protectorCount = 4
	Dungeons.beaconSW = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconSWLoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.beaconSW:SetForwardVector(Vector(-1,-1))
	Dungeons.beaconSW.index = 1
	Dungeons.beaconSW.regen = -1
	Dungeons.beaconSE = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconSELoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.beaconSE:SetForwardVector(Vector(1,-1))
	Dungeons.beaconSE.index = 2
	Dungeons.beaconSE.regen = -1
	Dungeons.beaconNE = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconNELoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.beaconNE:SetForwardVector(Vector(1,1))
	Dungeons.beaconNE.index = 3
	Dungeons.beaconNE.regen = -1
	Dungeons.beaconNW = CreateUnitByName("phoenix_nest_protector", Dungeons.beaconNWLoc, false, nil, nil, DOTA_TEAM_GOODGUYS)
	Dungeons.beaconNW:SetForwardVector(Vector(-1,1))
	Dungeons.beaconNW.index = 4
	Dungeons.beaconNW.regen = -1

	Dungeons.phoenixEggHatched = false

	local spawnTable = {Vector(3072, -13376), Vector(3984, -12582), Vector(3064, -11660), Vector(2283, -12528)}
	local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
	Dungeons.phoenixEgg = CreateUnitByName("phoenix_nest_egg", Dungeons.phoenixEggLocation, false, MAIN_HERO_TABLE[1], MAIN_HERO_TABLE[1]:GetPlayerOwner(), DOTA_TEAM_GOODGUYS)
	Dungeons.phoenixEgg:SetAbsOrigin(Dungeons.phoenixEgg:GetAbsOrigin()-Vector(0,0,280))
	Dungeons.phoenixEgg:FindAbilityByName("phoenix_passive"):SetLevel(1)
	Dungeons.phoenixEgg:SetMana(0)
	for i = 1, #MAIN_HERO_TABLE, 1 do
		Dungeons.phoenixEgg:SetControllableByPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwnerID(), true)
	end

	local eggAbility = Dungeons.phoenixEgg:FindAbilityByName("phoenix_passive")
	eggAbility:ApplyDataDrivenModifier(Dungeons.phoenixEgg, Dungeons.phoenixEgg, "modifier_phoenix_invuln", {})
	eggAbility:ApplyDataDrivenModifier(Dungeons.phoenixEgg, Dungeons.phoenixEgg, "modifier_phoenix_guardian_bonus", {})
	Dungeons.phoenixEgg:SetModifierStackCount( "modifier_phoenix_guardian_bonus", eggAbility, 4 )

	Dungeons:PhoenixScale(Dungeons.phoenixEgg)
	Dungeons:PhoenixScale(Dungeons.beaconSW)
	Dungeons:PhoenixScale(Dungeons.beaconSE)
	Dungeons:PhoenixScale(Dungeons.beaconNE)
	Dungeons:PhoenixScale(Dungeons.beaconNW)	
	local hatchAbility = Dungeons.phoenixEgg:FindAbilityByName("phoenix_hatch")
	hatchAbility:SetActivated(false)

	Timers:CreateTimer(0.5, function()
		for i = 1, #MAIN_HERO_TABLE, 1 do
			--print("MOVE HERO")
			MAIN_HERO_TABLE[i]:SetAbsOrigin(GetGroundPosition(spawnTable[i], MAIN_HERO_TABLE[i]))
			gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 20.5})
		end
	end)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Music.PhoenixIntro")
	end)
	Timers:CreateTimer(3, function()
		EmitSoundOn("Rune.Arcane", Dungeons.phoenixEgg)
		for i = 1, #MAIN_HERO_TABLE, 1 do
			local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
			if playerID then
				PlayerResource:SetCameraTarget(playerID, Dungeons.phoenixEgg)
			end
		end
		for i = 1, 70, 1 do
			Timers:CreateTimer(0.03*i, function()
				Dungeons.phoenixEgg:SetAbsOrigin(Dungeons.phoenixEgg:GetAbsOrigin()+Vector(0,0,8))
			end)
		end
		Timers:CreateTimer(2.1, function()
			for i = 1, 25, 1 do
				Timers:CreateTimer(0.03*i, function()
					Dungeons.phoenixEgg:SetAbsOrigin(Dungeons.phoenixEgg:GetAbsOrigin()-Vector(0,0,3))
				end)
			end
		end)
		Timers:CreateTimer(2.1, function()
			Dungeons:SpawnShowMinions()
			Timers:CreateTimer(0.35, function()
				Dungeons.visionTracer = CreateUnitByName("npc_flying_dummy_vision", Vector(3093, -12522, -200), true, nil, nil, DOTA_TEAM_GOODGUYS)
				Dungeons.visionTracer:AddAbility("dummy_unit"):SetLevel(1)
				Dungeons.visionTracer:AddNewModifier( Dungeons.visionTracer, nil, 'modifier_movespeed_cap_super', nil )
				Dungeons.visionTracer:SetBaseMoveSpeed(4000)
			    Timers:CreateTimer(2.8, function()
					for i = 1, #MAIN_HERO_TABLE, 1 do
						local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
						if playerID then
							
							MAIN_HERO_TABLE[i]:Stop()
							PlayerResource:SetCameraTarget(playerID, Dungeons.visionTracer)
						end
					end
					Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointWest)
					Timers:CreateTimer(5.8, function()
						Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointSouth)
						Timers:CreateTimer(2.2, function()
							Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointEast)
						end)
						Timers:CreateTimer(4.4, function()
							Dungeons.visionTracer:MoveToPosition(Dungeons.spawnPointNorth)
						end)
					end)
					Timers:CreateTimer(12.8, function()
						Dungeons:UnlockCamerasAndReturnToHero()
						Dungeons:BeginPhoenixBattle()
					end)
				end)
			end)
		end)
	end)

end

function Dungeons:SpawnShowMinions()
	Dungeons.showMinionTable = {}
	local followerOfKriggusTable = {}
	local ironSpineTable = {}
	local kriggus = CreateUnitByName("invader_kriggus", Dungeons.spawnPointWest, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons.kriggus = kriggus
	table.insert(Dungeons.showMinionTable, kriggus)
	for i = 1, #Dungeons.showMinionTable, 1 do
		Dungeons.showMinionTable[i].active = false
		Dungeons.showMinionTable[i]:SetAcquisitionRange(0)
		Dungeons.showMinionTable[i]:SetForwardVector(Vector(1,0))
	end
	for j = 1, 12, 1 do
		Timers:CreateTimer(0.2*j, function()
			--WEST
			local kriggusFollower = CreateUnitByName("follower_of_kriggus", Dungeons.spawnPointWest+RandomVector(j*20), true, nil, nil, DOTA_TEAM_NEUTRALS)
			kriggusFollower.active = false
			kriggusFollower:SetAcquisitionRange(0)
			kriggusFollower:SetForwardVector(Vector(1,0))
			kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
			table.insert(Dungeons.showMinionTable, kriggusFollower)
			table.insert(followerOfKriggusTable, kriggusFollower)
			--SOUTH
			local ironSpine= CreateUnitByName("iron_spine", Dungeons.spawnPointSouth+RandomVector(j*20), true, nil, nil, DOTA_TEAM_NEUTRALS)
			ironSpine.active = false
			ironSpine:SetAcquisitionRange(0)
			ironSpine:SetForwardVector(Vector(0,1))
			ironSpine:AddAbility("phoenix_siege_ai"):SetLevel(1)
			table.insert(Dungeons.showMinionTable, ironSpine)
			table.insert(ironSpineTable, ironSpine)
			--EAST
			local shadowFiend = CreateUnitByName("portal_invader", Dungeons.spawnPointEast+RandomVector(j*20), true, nil, nil, DOTA_TEAM_NEUTRALS)
			if j == 1 then
				shadowFiend:AddAbility("creature_endurance_aura"):SetLevel(1)
				shadowFiend:SetModelScale(1.6)
				shadowFiend:SetRenderColor(255, 80, 80)
				Dungeons.shadowFiendBoss = shadowFiend
			end
			shadowFiend.active = false
			shadowFiend:SetAcquisitionRange(0)
			shadowFiend:SetForwardVector(Vector(-1,0))
			shadowFiend:AddAbility("phoenix_siege_ai"):SetLevel(1)
			table.insert(Dungeons.showMinionTable, shadowFiend)
			--NORTH
			local ursa = CreateUnitByName("nomadic_siege", Dungeons.spawnPointNorth+RandomVector(j*20), true, nil, nil, DOTA_TEAM_NEUTRALS)
			ursa.active = false
			ursa:SetAcquisitionRange(0)
			ursa:SetForwardVector(Vector(0,-1))
			ursa:AddAbility("phoenix_siege_ai"):SetLevel(1)
			table.insert(Dungeons.showMinionTable, ursa)
			StartAnimation(ursa, {duration=20, activity=ACT_DOTA_TELEPORT, rate=0.5})
		end)
	end
	Timers:CreateTimer(3, function()
		StartAnimation(kriggus, {duration=7, activity=ACT_DOTA_VICTORY, rate=0.8, translate="trapper"})
		for j = 1, #followerOfKriggusTable, 1 do
			StartAnimation(followerOfKriggusTable[j], {duration=7, activity=ACT_DOTA_TELEPORT, rate=0.5})
		end
		Timers:CreateTimer(1.3, function()
			EmitSoundOn("life_stealer_lifest_anger_03", kriggus)
			EmitSoundOn("life_stealer_lifest_anger_03", followerOfKriggusTable[1])
			EmitSoundOn("life_stealer_lifest_anger_03", followerOfKriggusTable[2])
		end)
		Timers:CreateTimer(2, function()
			for j = 1, #ironSpineTable, 1 do
				StartAnimation(ironSpineTable[j], {duration=5, activity=ACT_DOTA_VICTORY, rate=0.5})
			end
		end)
	end)
	Timers:CreateTimer(19, function()
		for i = 1, #Dungeons.showMinionTable, 1 do
			Dungeons.showMinionTable[i].active = true
			Dungeons:PhoenixScale(Dungeons.showMinionTable[i])
			Dungeons.showMinionTable[i]:SetAcquisitionRange(20000)
		end
		Events:AdjustBossPower(Dungeons.shadowFiendBoss, 4, 2, false)
		Events:AdjustBossPower(Dungeons.kriggus, 3, 5, false)
	end)
end

function Dungeons:BeginPhoenixBattle()
	if not Dungeons.phoenixEgg then
		Dungeons.phoenixEgg = CreateUnitByName("phoenix_nest_egg", Vector(3093, -12522, 100), false, nil, nil, DOTA_TEAM_GOODGUYS)
	end
	Dungeons.phoenixEgg.active = true
	CustomGameEventManager:Send_ServerToAllClients("phoenix_nest_begin", {max_health=Dungeons.phoenixEgg:GetMaxHealth()} )
	CustomGameEventManager:Send_ServerToAllClients("update_phoenix_wave", {waveNumber = Dungeons.phoenixWave, wavePrefix = Dungeons.wavePrefix} )
end

function Dungeons:DebugPhoenixNest()
	-- Dungeons:InitializePhoenixNest()
	-- Dungeons:BeginPhoenixBattle()

	--BOSS DEBUG BELOW
	-- Dungeons.spawnPointSouth = Vector(3136, -16064)
	-- Dungeons.spawnPointEast = Vector(6848, -12480)
	-- Dungeons.spawnPointNorth = Vector(3136, -9664)
	-- Dungeons.spawnPointWest = Vector(-1152, -12416)
	-- Dungeons.phoenixEggLocation = Vector(3093, -12522, 0)
	-- Dungeons.phoenixWave = 1
	-- CustomGameEventManager:Send_ServerToAllClients("phoenix_nest_begin", {max_health=50000} )
	-- Timers:CreateTimer(1, function()
	-- 	CustomGameEventManager:Send_ServerToAllClients("phoenix_hatch", {} )
	-- 	CustomGameEventManager:Send_ServerToAllClients("phoenixHatched2", {} )
		
	-- end)
	-- Dungeons:begin_phoenix_boss_sequence()
end


function Dungeons:PhoenixCollisionCalc(unit, point, isDistanceSearch)
	local withinRelevantBounds = false
	local currentPosition = unit:GetAbsOrigin()
	local forwardVector = unit:GetForwardVector()
	if unit.EFV then
		forwardVector = unit.EFV
	end
	local normal = (point*Vector(1,1,0)-currentPosition*Vector(1,1,0)):Normalized()
	if unit.EFV then
		normal = unit.EFV
	end
	-- if unit.blowback then
	-- 	normal = normal*-1
	-- end
	local groundPos = GetGroundPosition(currentPosition, unit)
	local groundStraight = GetGroundPosition(currentPosition+normal*160, unit)
	local groundClockwise = GetGroundPosition(currentPosition+WallPhysics:rotateVector(normal, math.pi/4)*150, unit)
	local groundCounterClockwise = GetGroundPosition(currentPosition+WallPhysics:rotateVector(normal, -math.pi/4)*150, unit)
	if isDistanceSearch then
		groundStraight = GetGroundPosition(point+forwardVector*120, unit)
		groundClockwise = GetGroundPosition(point+WallPhysics:rotateVector(forwardVector, math.pi/2)*150, unit)
		groundCounterClockwise = GetGroundPosition(point+WallPhysics:rotateVector(forwardVector, -math.pi/2)*150, unit)
	end

	----print("-----------")
	----print("NORMAL: ")
	----print(normal)
	----print(groundPos)
	----print(groundStraight)
	----print("rotats:")
	----print(groundClockwise)
	----print(groundCounterClockwise)
	if currentPosition.z < groundStraight.z - 180 or currentPosition.z < groundClockwise.z - 200 or currentPosition.z < groundCounterClockwise.z - 200  then

		return true
	else

		return false
	end
end

function Dungeons:PhenoixCollisionRegion(verticeA, verticeB, acceptableVector, currentPosition, forwardVector, relevantAcceptableVector, relevantAcceptableVector2)
	if currentPosition.x > verticeA.x and currentPosition.x < verticeB.x and currentPosition.y > verticeA.y and currentPosition.y < verticeB.y then
		if relevantAcceptableVector == nil then
			return acceptableVector, nil
		else
			return relevantAcceptableVector, acceptableVector
		end
	else
		if relevantAcceptableVector == nil then
			return nil, nil
		else
			if relevantAcceptableVector2 == nil then
				return relevantAcceptableVector, nil
			else
				return relevantAcceptableVector, relevantAcceptableVector2
			end
		end
	end
end

function Dungeons:PhoenixCollisionCalcMath(medianAcceptableVector, actualForwardVector, acceptableDegrees)
	local dotProduct = actualForwardVector:Dot(medianAcceptableVector)
	local actualAngle = math.acos(dotProduct)
	if math.abs(actualAngle) >= acceptableDegrees*(math.pi/180) then
		return false
	else
		return true
	end
end

function Dungeons:PhoenixScale(unit)
    local difficulty = GameState:GetDifficultyFactor()
    local xp = unit:GetDeathXP()
    if difficulty == 1 then
      xp = math.floor(xp*0.7)
    end
    xp = ((difficulty-1)*805 + math.ceil(difficulty*xp*1.65))*0.65
    local xpBoost = (RPCItems:GetConnectedPlayerCount()-1)*0.35
    local adjustedXP = xp*(1+xpBoost)*(1+GameState:GetPlayerPremiumStatusCount()*0.1)
    unit:SetDeathXP(adjustedXP)
    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty()/3)
    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty()/3)
    local damageAdjustment = unit:GetAttackDamage()*4*(difficulty-1) + (difficulty-1)*60000
    if difficulty >= 3 then
      damageAdjustment = math.floor(damageAdjustment + unit:GetAttackDamage()*200)
      damageAdjustment = math.min(damageAdjustment, 1000000000)
    end
    damageAdjustment = damageAdjustment*Dungeons.phoenixWave*0.2
    if difficulty == 1 then
    	damageAdjustment = unit:GetAttackDamage()*0.2*Dungeons.phoenixWave
    end
    local minDamage = unit:GetBaseDamageMin()
    local maxDamage = unit:GetBaseDamageMax()
    unit:SetBaseDamageMin(minDamage+damageAdjustment)
    unit:SetBaseDamageMax(maxDamage+damageAdjustment) 

    -- local newArmor = unit:GetPhysicalArmorValue(false)*difficulty*difficulty+30*(difficulty-1)
    -- if difficulty > 2 then
    --   newArmor = newArmor+90 + unit:GetPhysicalArmorValue(false)*4
    -- end
    local newArmor = unit:GetPhysicalArmorBaseValue()*difficulty + 10*(difficulty-1)
    newArmor = newArmor + Dungeons.phoenixWave*difficulty
    unit:SetPhysicalArmorBaseValue(newArmor)


    local newHealth = unit:GetMaxHealth()*difficulty + (difficulty-1)*unit:GetMaxHealth() + 82000*(difficulty-1)
    if difficulty == 0 then
    	newHealth = newHealth + 4500*Dungeons.phoenixWave + (newHealth/8)*Dungeons.phoenixWave
    end
    if difficulty == 1 then
    	newHealth = newHealth + 120000
    	newHealth = newHealth + (newHealth/4)*Dungeons.phoenixWave
    end
    if difficulty > 2 then
      newHealth = newHealth + (newHealth/5)*Dungeons.phoenixWave
      newHealth = newHealth + 420000
    end
    newHealth = math.min(newHealth, (2^30)-10)
    unit:SetMaxHealth(newHealth)
    unit:SetBaseMaxHealth(newHealth)
    unit:SetHealth(newHealth)
    unit:Heal(newHealth, unit)

    for i = 0, 6, 1 do
      local ability = unit:GetAbilityByIndex(i)
      if ability then
        ability:SetLevel(difficulty)
      end
    end
    
end

function Dungeons:IncrementPhoenixWave()
	if not Dungeons.phoenixEggHatched then
		Dungeons.phoenixMobsKilled = 0
		Dungeons.phoenixWave = Dungeons.phoenixWave+1
		Dungeons:PhoenixWaveSpawn()
		Dungeons.phoenixMobsThreshold = 40
		--print("INCREMENT PHOENIX WAVE")
		local difficultyMax = 0
		if GameState:GetDifficultyFactor() == 2 then
			difficultyMax = 45
		elseif GameState:GetDifficultyFactor() == 1 then
			difficultyMax = 15
		end
		Dungeons.itemLevel = math.min(Dungeons.itemLevel+1, 80+difficultyMax)
		local newHealth = Dungeons.phoenixEgg:GetMaxHealth()*1.01
		newHealth = math.min(newHealth, (2^30)-10)
	    Dungeons.phoenixEgg:SetMaxHealth(newHealth)
	    Dungeons.phoenixEgg:SetBaseMaxHealth(newHealth)
	    Dungeons.phoenixEgg:Heal(Dungeons.phoenixEgg:GetMaxHealth()*0.01, unit)
	    local armor = 100 + GameState:GetDifficultyFactor()*40
	    Dungeons.phoenixEgg:SetPhysicalArmorBaseValue(armor)
		if Dungeons.phoenixWave == 11 then
			local hatchAbility = Dungeons.phoenixEgg:FindAbilityByName("phoenix_hatch")
			Notifications:TopToAll({text="The Phoenix is ready to Hatch!", duration=8.0})
			EmitGlobalSound("phoenix_phoenix_bird_victory")
			hatchAbility:SetActivated(true)
			Dungeons.wavePrefix = "S"
		end
	end
end

function Dungeons:spawnPhoenixUnit(unitName, spawnPoint)
	local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
	Dungeons:PhoenixScale(unit)
	local luck = RandomInt(1,56)
	if luck == 1 then
		Paragon:AddParagonUnit(unit)
	end
	unit.active = true
	unit:AddAbility("phoenix_siege_ai"):SetLevel(1)
	unit:SetAcquisitionRange(5000)
	return unit
end

function Dungeons:PhoenixWaveSpawn()
	if Dungeons.phoenixWave == 2 then
		for j = 1, 10, 1 do
			Timers:CreateTimer(0.4*j, function()
				--WEST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_marshall", Dungeons.spawnPointWest+RandomVector(j*10))
				kriggusFollower:SetRenderColor(200, 40, 40)
				Events:AdjustBossPower(kriggusFollower, 1, 1, false)
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				--SOUTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("feral_bloodseeker", Dungeons.spawnPointSouth+RandomVector(j*10))
				kriggusFollower:SetRenderColor(200, 80, 80)
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				--EAST
				kriggusFollower = CreateUnitByName("iron_spine", Dungeons.spawnPointEast+RandomVector(j*10), true, nil, nil, DOTA_TEAM_NEUTRALS)
				kriggusFollower.active = true
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				kriggusFollower:SetAcquisitionRange(5000)
				Dungeons:PhoenixScale(kriggusFollower)
				--NORTH
				kriggusFollower = CreateUnitByName("nomadic_siege", Dungeons.spawnPointNorth+RandomVector(j*10), true, nil, nil, DOTA_TEAM_NEUTRALS)
				kriggusFollower.active = true
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				kriggusFollower:SetAcquisitionRange(5000)
				Dungeons:PhoenixScale(kriggusFollower)
			end)
		end
	elseif Dungeons.phoenixWave == 3 then
		for j = 1, 10, 1 do
			Timers:CreateTimer(0.4*j, function()
				--WEST
				local kriggusFollower = CreateUnitByName("phoenix_assassin", Dungeons.spawnPointWest+RandomVector(j*10), true, nil, nil, DOTA_TEAM_NEUTRALS)
				kriggusFollower.active = true
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				kriggusFollower:SetAcquisitionRange(5000)
				kriggusFollower.animationInt = ACT_DOTA_CAST_ABILITY_2
				kriggusFollower:SetRenderColor(200, 40, 40)
				Dungeons:PhoenixScale(kriggusFollower)
				--SOUTH
				kriggusFollower = CreateUnitByName("iron_spine", Dungeons.spawnPointSouth+RandomVector(j*10), true, nil, nil, DOTA_TEAM_NEUTRALS)
				kriggusFollower.active = true
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				kriggusFollower:SetAcquisitionRange(5000)
				Dungeons:PhoenixScale(kriggusFollower)
				--EAST
				kriggusFollower = CreateUnitByName("phoenix_siege_dragon", Dungeons.spawnPointEast+RandomVector(j*15), true, nil, nil, DOTA_TEAM_NEUTRALS)
				kriggusFollower.active = true
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				kriggusFollower:SetAcquisitionRange(5000)
				Dungeons:PhoenixScale(kriggusFollower)
				--NORTH
				kriggusFollower = CreateUnitByName("phoenix_siege_dragon", Dungeons.spawnPointNorth+RandomVector(j*10), true, nil, nil, DOTA_TEAM_NEUTRALS)
				kriggusFollower.active = true
				kriggusFollower:AddAbility("phoenix_siege_ai"):SetLevel(1)
				kriggusFollower:SetAcquisitionRange(5000)
				Dungeons:PhoenixScale(kriggusFollower)
			end)
		end
	elseif Dungeons.phoenixWave == 4 then
		for i = 1, 10, 1 do
			Timers:CreateTimer(0.5*i, function()
				local randomX = RandomInt(Dungeons.beaconNELoc.x, Dungeons.beaconSWLoc.x)
				local randomY = RandomInt(Dungeons.beaconNELoc.y, Dungeons.beaconSWLoc.y)
				local randomVec = Vector(randomX, randomY)
				local bat = Dungeons:spawnPhoenixUnit("phoenix_siege_bat", randomVec)
				bat:SetRenderColor(140, 0, 0)
				bat:SetAbsOrigin(bat:GetAbsOrigin() +Vector(0,0,900))
				WallPhysics:Jump(bat, bat:GetForwardVector(), 0, 24, 10, 0.5)
				local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
				gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, bat, "modifier_no_damage_cant_die", {duration = 2.2})
				Timers:CreateTimer(2.1, function()
					local soundTable = {"batrider_bat_laugh_01", "batrider_bat_laugh_02", "batrider_bat_laugh_03", "batrider_bat_laugh_04"}
					EmitSoundOn(soundTable[RandomInt(1,4)], bat)
					for j = 1, 3, 1 do
						Timers:CreateTimer(j*0.1, function()
							local batSummon = Dungeons:spawnPhoenixUnit("bat_summon", bat:GetAbsOrigin()+Vector(0,0,50))
							WallPhysics:Jump(batSummon, bat:GetForwardVector(), 0, 24, 10, 0.5)
						end)
					end
				end)
			end)
		end
	elseif Dungeons.phoenixWave == 5 then
		for j = 1, 10, 1 do
			Timers:CreateTimer(0.4*j, function()
				--WEST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_siege_lich", Dungeons.spawnPointWest+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--SOUTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_siege_lich", Dungeons.spawnPointSouth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--EAST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_siege_lich", Dungeons.spawnPointEast+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--NORTH
				if j == 10 then
					local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_siege_lich_boss", Dungeons.spawnPointNorth)
					Events:AdjustBossPower(kriggusFollower, 5, 5, false)
					EmitGlobalSound("lich_lich_cast_02")
				else
					local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_siege_lich", Dungeons.spawnPointNorth+RandomVector(RandomInt(10, 200)))
					kriggusFollower:SetRenderColor(200, 40, 40)
				end
			end)
		end
	elseif Dungeons.phoenixWave == 6 then
		for j = 1, 10, 1 do
			Timers:CreateTimer(0.6*j, function()
				--WEST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_hunter", Dungeons.spawnPointWest+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--SOUTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_hunter", Dungeons.spawnPointSouth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--EAST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_assassin", Dungeons.spawnPointEast+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--NORTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_assassin", Dungeons.spawnPointNorth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
			end)
		end
	elseif Dungeons.phoenixWave == 7 then
			local colorsTable = {"red", "blue", "green"}
			for j = 1, 10, 1 do
				Timers:CreateTimer(0.6*j, function()
			--WEST

			local shadowFiend = Dungeons:spawnPhoenixUnit("portal_invader", Dungeons.spawnPointWest+RandomVector(RandomInt(10, 200)))
			shadowFiend:SetModelScale(1.2)
			if j == 1 then
				-- shadowFiend:AddAbility("creature_regen_aura"):SetLevel(1)
				shadowFiend:SetModelScale(1.6)
				shadowFiend:SetRenderColor(255, 80, 80)
				Events:AdjustBossPower(shadowFiend, 3, 2, false)
			end
			local zombieAbil = shadowFiend:AddAbility("zombie_colors")
			zombieAbil:SetLevel(GameState:GetDifficultyFactor())
			zombieAbil:ApplyDataDrivenModifier(shadowFiend, shadowFiend, "zombie_"..colorsTable[RandomInt(1,3)], {})
			--SOUTH
			shadowFiend = Dungeons:spawnPhoenixUnit("portal_invader", Dungeons.spawnPointSouth+RandomVector(RandomInt(10, 200)))
			shadowFiend:SetModelScale(1.2)
			if j == 1 then
				-- shadowFiend:AddAbility("creature_regen_aura"):SetLevel(1)
				shadowFiend:SetModelScale(1.6)
				shadowFiend:SetRenderColor(255, 80, 80)
				Events:AdjustBossPower(shadowFiend, 3, 2, false)
			end
			local zombieAbil = shadowFiend:AddAbility("zombie_colors")
			zombieAbil:SetLevel(GameState:GetDifficultyFactor())
			zombieAbil:ApplyDataDrivenModifier(shadowFiend, shadowFiend, "zombie_"..colorsTable[RandomInt(1,3)], {})
			--EAST
			shadowFiend = Dungeons:spawnPhoenixUnit("portal_invader", Dungeons.spawnPointEast+RandomVector(RandomInt(10, 200)))
			shadowFiend:SetModelScale(1.2)
			if j == 1 then
				-- shadowFiend:AddAbility("creature_regen_aura"):SetLevel(1)
				shadowFiend:SetModelScale(1.6)
				shadowFiend:SetRenderColor(255, 80, 80)
				Events:AdjustBossPower(shadowFiend, 3, 2, false)
			end
			local zombieAbil = shadowFiend:AddAbility("zombie_colors")
			zombieAbil:SetLevel(GameState:GetDifficultyFactor())
			zombieAbil:ApplyDataDrivenModifier(shadowFiend, shadowFiend, "zombie_"..colorsTable[RandomInt(1,3)], {})
			--NORTH
			shadowFiend = Dungeons:spawnPhoenixUnit("portal_invader", Dungeons.spawnPointNorth+RandomVector(RandomInt(10, 200)))
			shadowFiend:SetModelScale(1.2)
			if j == 1 then
				-- shadowFiend:AddAbility("creature_regen_aura"):SetLevel(1)
				shadowFiend:SetModelScale(1.6)
				shadowFiend:SetRenderColor(255, 80, 80)
				Events:AdjustBossPower(shadowFiend, 3, 2, false)
			end
			local zombieAbil = shadowFiend:AddAbility("zombie_colors")
			zombieAbil:SetLevel(GameState:GetDifficultyFactor())
			zombieAbil:ApplyDataDrivenModifier(shadowFiend, shadowFiend, "zombie_"..colorsTable[RandomInt(1,3)], {})
				end)
			end
	elseif Dungeons.phoenixWave == 8 then
		for j = 1, 10, 1 do
			Timers:CreateTimer(0.6*j, function()
				--WEST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_electron_raider", Dungeons.spawnPointWest+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--SOUTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("chaos_warrior", Dungeons.spawnPointSouth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--EAST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_electron_raider", Dungeons.spawnPointEast+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--NORTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("iron_spine", Dungeons.spawnPointNorth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
			end)
		end
	elseif Dungeons.phoenixWave == 9 then
		for j = 1, 10, 1 do
			Timers:CreateTimer(0.6*j, function()
				--WEST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_executioner", Dungeons.spawnPointWest+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--SOUTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_executioner", Dungeons.spawnPointSouth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--EAST
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_executioner", Dungeons.spawnPointEast+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				--NORTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit("phoenix_executioner", Dungeons.spawnPointNorth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
			end)
		end
	elseif Dungeons.phoenixWave == 10 then
		Dungeons:SpawnPhoenixSingleWave("phoenix_executioner", 2)
		Dungeons:SpawnPhoenixSingleWave("phoenix_electron_raider", 1)
		Dungeons:SpawnPhoenixSingleWave("phoenix_hunter", 1)
		Dungeons:SpawnPhoenixSingleWave("phoenix_assassin", 2)
		Dungeons:SpawnPhoenixSingleWave("phoenix_siege_lich", 1)
		Dungeons:SpawnPhoenixSingleWave("phoenix_siege_dragon", 2)
		Dungeons:SpawnPhoenixSingleWave("iron_spine", 1)
	end
	if Dungeons.phoenixWave > 10 then
		if Dungeons.wavePrefix == "" then
			Dungeons.wavePrefix = "S"
		end
		Dungeons:PhoenixRandomWave()
	end
	if Dungeons.wavePrefix == "S" then
		CustomGameEventManager:Send_ServerToAllClients("update_phoenix_wave", {waveNumber = Dungeons.phoenixWave-10, wavePrefix = Dungeons.wavePrefix} )
	else
		CustomGameEventManager:Send_ServerToAllClients("update_phoenix_wave", {waveNumber = Dungeons.phoenixWave, wavePrefix = Dungeons.wavePrefix} )
	end
end

function Dungeons:SpawnPhoenixSingleWave(unitName, quantity)
		for j = 1, quantity, 1 do
			Timers:CreateTimer(1.4*j, function()
				--WEST
				local kriggusFollower = Dungeons:spawnPhoenixUnit(unitName, Dungeons.spawnPointWest+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				Dungeons:RemoveUnrelatedAbilities(kriggusFollower)
				--SOUTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit(unitName, Dungeons.spawnPointSouth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				Dungeons:RemoveUnrelatedAbilities(kriggusFollower)
				--EAST
				local kriggusFollower = Dungeons:spawnPhoenixUnit(unitName, Dungeons.spawnPointEast+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				Dungeons:RemoveUnrelatedAbilities(kriggusFollower)
				--NORTH
				local kriggusFollower = Dungeons:spawnPhoenixUnit(unitName, Dungeons.spawnPointNorth+RandomVector(RandomInt(10, 200)))
				kriggusFollower:SetRenderColor(200, 40, 40)
				Dungeons:RemoveUnrelatedAbilities(kriggusFollower)
			end)
		end
end

function Dungeons:RemoveUnrelatedAbilities(unit)
	for i = 1, #Dungeons.abilityRemoveTable, 1 do
		if unit:HasAbility(Dungeons.abilityRemoveTable[i]) then
			unit:RemoveAbility(Dungeons.abilityRemoveTable[i])
		end
	end
end

Dungeons.waveCreatureTable = {"dark_fighter", "icy_venge", "time_walker", "rabid_walker", "npc_dota_creature_basic_zombie_exploding", "gargoyle", "hook_flinger", "human_rifleman", "blood_jumper", "mekanoid_disruptor", "furion_brute", "freeze_fiend", "forest_broodmother", "spiderling", "spiderling2", "rolling_earth_spirit", "little_meepo", "furion_mystic", "twitch_lone_druid", "obsidian_golem", "depth_demon", "arabor_cultist", "exploding_warrior", "rockjaw", "wastelands_archer", "desert_ghost", "goremaw_brute", "goremaw_shaman", "bone_horror", "wandering_mage", "scarab", "skittering_beetle", "satyr_doctor", "hammersaur", "alpha_wolf", "wolf_ally", "mountain_destroyer", "desert_warlord", "blood_fiend", "dune_crasher", "twisted_soldier", "experimental_minion", "tortured_beast", "abomination", "hell_hound", "chaos_warrior", "raging_shaman", "crawler", "crafter", "nibohg", "satyr_behemoth", "firebat", "dire_ranged", "dire_melee", "minion_of_twilight", "spectral_assassin", "shadow_hunter", "betrayer_of_time", "arabor_spellweaver", "river_beast", "grizzly_awakened_stone", "grizzly_water_hydra", "gazbin_guard", "gazbin_brute", "gazbin_peon", "gazbin_berserker", "gazbin_recruit", "gazbin_explosives_expert", "gazbin_mercenary", "gazbin_mercenary_ranged", "sludge_golem", "skeleton_archer"}
Dungeons.dungeonCreatureTableSmall = {"wraithguard", "castle_ghost", "castle_skeleton_archer", "castle_skeleton_mage", "summoner_true_form", "swamp_viper", "swamp_razorfish", "swamp_razorfish_captain", "swamp_tribal_cultist", "swamp_razorfish_irritable", "swamp_grove_bear", "swamp_grove_tender", "swamp_grove_ancestral_bear", "vault_guard", "vault_assassin", "vault_pleb", "vault_executioner", "vault_henchman", "vault_worshipper", "vault_arcanist", "desert_outrunner", "enslaved_corpse", "ruins_solarium_enigma", "fungal_overlord", "blighted_sapling", "tomb_remnant", "ancient_ghost", "tomb_defender", "raging_flame", "crow_eater", "tomb_stalker", "vision_warden", "grizzly_twilight_worshipper", "follower_of_kriggus", "portal_invader", "iron_spine", "feral_bloodseeker", "phoenix_marshall", "phoenix_assassin", "bat_summon", "phoenix_siege_lich", "phoenix_hunter", "phoenix_electron_raider"}
Dungeons.dungeonCreatureTableLarge = {"wraithguard_elite", "vault_treasurer", "unreal_terror", "grave_watcher", "ruins_golden_skullbone", "grizzly_granite_apparition", "invader_kriggus", "general_wolfenstein"}
Dungeons.abilityRemoveTable = {"dungeon_creep", "knockback_immunity", "desert_ruins_ability", "swamp_grove_bear_ai", "grove_tender_ai", "swamp_grove_ancestral_bear_ai", "castle_summoner_trueform_ai"}

function Dungeons:PhoenixRandomWave()
		--WAVE
		Dungeons:SpawnPhoenixSingleWave(Dungeons.waveCreatureTable[RandomInt(1, #Dungeons.waveCreatureTable)], 2)
		Dungeons:SpawnPhoenixSingleWave(Dungeons.waveCreatureTable[RandomInt(1, #Dungeons.waveCreatureTable)], 2)
		Dungeons:SpawnPhoenixSingleWave(Dungeons.waveCreatureTable[RandomInt(1, #Dungeons.waveCreatureTable)], 2)
		--DUNGEON
		Dungeons:SpawnPhoenixSingleWave(Dungeons.dungeonCreatureTableSmall[RandomInt(1, #Dungeons.dungeonCreatureTableSmall)], 2)
		local luck = RandomInt(1, 5)
		if luck == 5 then
			Dungeons:SpawnPhoenixSingleWave(Dungeons.dungeonCreatureTableLarge[RandomInt(1, #Dungeons.dungeonCreatureTableLarge)], 2)
		else
			Dungeons:SpawnPhoenixSingleWave(Dungeons.dungeonCreatureTableSmall[RandomInt(1, #Dungeons.dungeonCreatureTableSmall)], 2)
		end
end


function Dungeons:begin_phoenix_boss_sequence()

	UTIL_Remove(Dungeons.beaconNE)
	UTIL_Remove(Dungeons.beaconNW)
	UTIL_Remove(Dungeons.beaconSE)
	UTIL_Remove(Dungeons.beaconSW)
	GameRules:SetTimeOfDay(0.75)
	CustomGameEventManager:Send_ServerToAllClients("phoenixBossStartMusic", {data="none"} )
	-- EmitGlobalSound("Music.PhoenixBoss")
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Dungeons.phoenixEggLocation, 500, 25, false)
      local particleName = "particles/units/heroes/hero_doom_bringer/doom_intro_ring.vpcf"
      local particleLoc = Vector(Dungeons.phoenixEggLocation.x, Dungeons.phoenixEggLocation.y, GetGroundPosition(Dungeons.phoenixEggLocation, Events.GameMaster).z)
      Dungeons.pentagramParticle = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( Dungeons.pentagramParticle, 0, particleLoc )
      ParticleManager:SetParticleControl( Dungeons.pentagramParticle, 1, particleLoc )
      ParticleManager:SetParticleControl( Dungeons.pentagramParticle, 4, particleLoc )
      -- Timers:CreateTimer(30, function()
      --   ParticleManager:DestroyParticle( particle1, false )
      -- end)
      Timers:CreateTimer(8, function()
      	EmitGlobalSound("doom_bringer_doom_ability_fail_01")
      end)
      Timers:CreateTimer(12.7, function()
		local boss = Events:SpawnBoss("phoenix_boss", particleLoc)
		Dungeons.phoenixBoss = boss
		boss:SetForwardVector(Vector(0,-1))
		CustomGameEventManager:Send_ServerToAllClients("hide_boss_health", {bossId = tostring(boss)})
		boss:SetAbsOrigin(boss:GetAbsOrigin() +Vector(0,0,1000))
		Dungeons:PhoenixScale(boss)
		Events:AdjustBossPower(boss, Dungeons.phoenixWave, Dungeons.phoenixWave, false)
		local armorBonus = 100 + (GameState:GetDifficultyFactor()-1)*35*Dungeons.phoenixWave
		boss:SetPhysicalArmorBaseValue(boss:GetPhysicalArmorBaseValue()+armorBonus)
		boss.jumpEnd = "doom_boss"
		WallPhysics:Jump(boss, Vector(0,0), 0, 30, 1, 0.7)
		local bossAbil = boss:FindAbilityByName("phoenix_boss_ai")
		bossAbil:ApplyDataDrivenModifier(boss, boss, "modifier_phoenix_boss_cinematic", {duration = 8.3})
		bossAbil:ApplyDataDrivenModifier(boss, boss, "modifier_phoenix_boss_really_cant_die", {})
		Timers:CreateTimer(2.5, function()
			StartAnimation(boss, {duration=2.5, activity=ACT_DOTA_SPAWN, rate=0.4})
			Timers:CreateTimer(0.4, function()
				EmitGlobalSound("doom_bringer_doom_anger_01")
				EmitGlobalSound("doom_bringer_doom_anger_01")
			end)
		end)
		Timers:CreateTimer(5.1, function()
			CustomGameEventManager:Send_ServerToAllClients("phoenixBossSpawn", {bossLevel=Dungeons.phoenixWave-10} )
			StartAnimation(boss, {duration=2.8, activity=ACT_DOTA_TELEPORT, rate=1.7})
			Timers:CreateTimer(0.1, function()
				for i = 1, 5, 1 do
					Timers:CreateTimer((2.8/5)*i, function()
						ScreenShake(boss:GetAbsOrigin(), 400, 0.4, 0.8, 9000, 0, true)
					end)
				end
				EmitGlobalSound("doom_bringer_doom_anger_08")
				EmitGlobalSound("doom_bringer_doom_anger_08")
			end)
		end)
		Timers:CreateTimer(8.9, function()
			EmitGlobalSound("doom_bringer_doom_attack_09")
			EmitGlobalSound("doom_bringer_doom_attack_09")
			EmitGlobalSound("doom_bringer_doom_attack_09")
			boss.active = true
		end)
      end)
		
end
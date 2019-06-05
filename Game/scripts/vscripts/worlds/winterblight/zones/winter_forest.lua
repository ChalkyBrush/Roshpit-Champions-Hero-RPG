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
	Timers:CreateTimer(8, function()
		Winterblight:SpawnPolarBear(Vector(-5449, -384), RandomVector(1))
		Winterblight:SpawnPolarBear(Vector(-5480, 1607), Vector(0,-1))
		Winterblight:SpawnPolarBear(Vector(-5766, 2373), Vector(-1,-1))
		Winterblight:SpawnPolarBear(Vector(-6339, 2954), Vector(-0.2,-1))
	end)
	Timers:CreateTimer(9, function()
		for i = 0, 3+GameState:GetDifficultyFactor(), 1 do
			Winterblight:SpawnScouringSharpa(Vector(-6912+(120*i), 1873), Vector(1,0))
		end
	end)
	Timers:CreateTimer(10.5, function()
		Winterblight:SpawnIceHaunter(Vector(-5669, 3840), Vector(-1,-1))
		Winterblight:SpawnIceHaunter(Vector(-5504, 3328), Vector(-1,0))
		Winterblight:SpawnIceHaunter(Vector(-5888, 3536), Vector(-1,-1))

		Winterblight:SpawnIceHaunter(Vector(-7011, 2560), Vector(-1,-1))
	end)
end

function Winterblight:OutsideCaveSpawn()
	Winterblight:SpawnStoneGuardian(Vector(-7680, 4608), Vector(0,-1))
	Winterblight:SpawnStoneGuardian(Vector(-7415, 4985), Vector(0,-1))
	Winterblight:SpawnStoneGuardian(Vector(-6985, 4928), Vector(0,-1))
	Winterblight.StoneGuardiansSlain = 0
	Winterblight.OutsideCaveSequence = 0
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
	stone.itemLevel = 38
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
	stone.itemLevel = 40
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	Winterblight:SetPositionCastArgs(stone, 1400, 0, 1, FIND_ANY_ORDER)
	-- stone:AddNewModifier(stone, nil, "modifier_animation", {translate="hunter_night"})
	-- stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="hunter_night"})
	return stone
end

function Winterblight:SpawnPolarBear(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("ferocious_polar_bear", position, 1, 1, "Winterblight.PolarBear.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 40
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnIceHaunter(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("ice_haunter", position, 1, 3, "Winterblight.IceHaunter.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 40
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnStoneGuardian(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_stone_guardian", position, 2, 2, nil, fv, false)
	stone.itemLevel = 40
	stone:SetRenderColor(190, 220, 255)
	Events:AdjustBossPower(stone, 2, 3, false)
	stone.itemLevel = 36
	stone.pushLock = true
	stone.jumpLock = true
	local health = 10
	if GameState:GetDifficultyFactor() == 2 then
		health = 150
	elseif GameState:GetDifficultyFactor() == 3 then
		health = 200
	end
	health = health + Winterblight.Stones*50
    stone:SetMaxHealth(health)
    stone:SetBaseMaxHealth(health)
    stone:SetHealth(health)
    local ticks = 130
    stone:SetAbsOrigin(stone:GetAbsOrigin()-Vector(0,0,2.2*ticks))
    local ability = stone:FindAbilityByName("winterblight_rock_guardian_passive")
    ability:ApplyDataDrivenModifier(stone, stone, "modifier_disable_player", {duration = 0.03*ticks})
    Winterblight:objectShake(stone, ticks, 3, true, true, false, nil, 5)
	return stone
end

function Winterblight:SpawnMerkurio(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_merkurio", position, 3, 7, "Winterblight.Merkurio.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 40
	stone:SetRenderColor(170, 200, 255)
	stone.state = 0
	Winterblight:SetPositionCastArgs(stone, 1000, 0, 1, FIND_ANY_ORDER)

	stone:SetAbsOrigin(stone:GetAbsOrigin()+Vector(0,0,2000))

	local ability = stone:FindAbilityByName("winterblight_merkurio_passive")
	stone.cantAggro = true
	ability:ApplyDataDrivenModifier(stone, stone, "modifier_disable_player", {duration = 4.1})
	WallPhysics:Jump(stone,Vector(0,-1), 1, 1, 1, 1)
	Timers:CreateTimer(2.2, function()
		if GameState:GetDifficultyFactor() == 3 and Winterblight.Stones > 0 then
			stone:AddAbility("creature_pure_strike"):SetLevel(3)
		end
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Winterblight.Merkurio.Spawn", stone)
		end)
		StartAnimation(stone, {duration=2.5, activity=ACT_DOTA_MK_SPRING_END, rate=0.6})
		EmitSoundOn("Winterblight.Merkurio.Gust", stone)
		for i = 1, 5, 1 do
			local fv = WallPhysics:rotateVector(stone:GetForwardVector(), 2*math.pi*i/5)
			local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", stone:GetAbsOrigin(), 4)
			ParticleManager:SetParticleControl(pfx, 1, fv*1000)
			ParticleManager:SetParticleControl(pfx, 3, stone:GetAbsOrigin()+fv*1000)
		end
	end)
	Timers:CreateTimer(4.2, function()
		stone.cantAggro = false
		stone:AddNewModifier(stone, nil, "modifier_animation", {translate="attack_normal_range"})
		stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="walk"})
	end)
	return stone
end
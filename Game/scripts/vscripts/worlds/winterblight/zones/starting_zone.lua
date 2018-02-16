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

function Winterblight:SpawnRaxxus(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_ice_champion_raxxus", position, 2, 3, "Winterblight.Raxxus.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 2, false)
	stone.itemLevel = 27
	return stone
end

function Winterblight:SpawnAssassin(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("mountain_assassin", position, 1, 2, "Winterblight.Assassin.Aggro", fv, true)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 22
	CustomAbilities:QuickAttachParticle("particles/econ/events/winter_major_2017/blink_dagger_start_wm07.vpcf", stone, 5)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnMountainCritter(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("aggressive_monster", position, 1, 1, "Winterblight.MountainCritter.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 18
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnMountainBeetle(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("ice_beetle", position, 1, 1, "Winterblight.MountainBeetle.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 22
	stone:SetRenderColor(170, 200, 255)
	stone:SetAbsOrigin(stone:GetAbsOrigin()-Vector(0,0,40))
	stone.dominion = true
	return stone
end

function Winterblight:SpawnWolf(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_wolf", position, 1, 1, "Winterblight.Wolf.Aggro", fv, false)
	Events:AdjustBossPower(stone, 1, 2, false)
	stone.itemLevel = 18
	stone:SetRenderColor(220, 200, 255)
	stone.dominion = true
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

	Timers:CreateTimer(6.5, function()
   		local positionTable = {Vector(-9088, -3904), Vector(-10304, -5376), Vector(-5760, -6336), Vector(-6080, -8128)}
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
	        local wolfCount = 1 + GameState:GetDifficultyFactor()
	        for j = 0, wolfCount, 1 do
	          Timers:CreateTimer(j*2, function()
	            local elemental = Winterblight:SpawnWolf(positionTable[i]+RandomVector(120), RandomVector(1))
	            Winterblight:AddPatrolArguments(elemental, 8, 5, 240, patrolPositionTable)
	          end)
	        end
	      end)
	    end
	end)
end

function Winterblight:IceCrystalArea()
	for i = 1, 20, 1 do
		Timers:CreateTimer(i*0.05, function()
			local scale = (7 + RandomInt(0, 5))/10
			local luck = RandomInt(1, 5)
			local position = Vector(-8384+RandomInt(0, 2900), -8128+RandomInt(0, 2150))
			if luck > 3 then
				position = Vector(-5632+RandomInt(0, 1900), -8512+RandomInt(0, 1650))
			end
			Winterblight:SpawnIceCrystal(position, RandomVector(1), scale)
		end)
	end
	local luck = RandomInt(1, 3)
	if luck == 1 then
		Winterblight:SpawnMountainDweller(Vector(-8768, -6976), Vector(0.7,1))
		Winterblight:SpawnMountainDweller(Vector(-8512, -7104), Vector(0,1))
		Winterblight:SpawnMountainDweller(Vector(-6720, -5824), Vector(0,-1))
		Winterblight:SpawnMountainDweller(Vector(-7360, -5824), Vector(0,-1))
		Winterblight:SpawnMountainDweller(Vector(-5680, -6817), Vector(-1,1))
		Winterblight:SpawnMountainDweller(Vector(-6353, -8329), Vector(0,1))
	elseif luck == 2 then
		Winterblight:SpawnMountainDweller(Vector(-6272, -7999), Vector(0,1))
		Winterblight:SpawnMountainDweller(Vector(-6016, -8099), Vector(-0.3,1))
		Winterblight:SpawnMountainDweller(Vector(-6217, -8271), Vector(0,1))
		Winterblight:SpawnMountainDweller(Vector(-7360, -5696), Vector(0,-1))
		Winterblight:SpawnMountainDweller(Vector(-7424, -7040), Vector(-1,1))
		Winterblight:SpawnMountainDweller(Vector(-6084, -6784), Vector(-1,0.3))
	elseif luck == 3 then
		Winterblight:SpawnMountainDweller(Vector(-7424, -6336), Vector(-1,0))
		Winterblight:SpawnMountainDweller(Vector(-7496, -6976), Vector(-1,0.8))
		Winterblight:SpawnMountainDweller(Vector(-6784, -7278), Vector(0,1))
		Winterblight:SpawnMountainDweller(Vector(-6400, -7480), Vector(0,1))
		Winterblight:SpawnMountainDweller(Vector(-5570, -6720), Vector(-1,0))
		Winterblight:SpawnMountainDweller(Vector(-5674, -6464), Vector(-1,0))
		Winterblight:SpawnMountainDweller(Vector(-5409, -6299), Vector(-1,-0.3))
	end
	Timers:CreateTimer(2, function()
		local luck2 = RandomInt(1, 3)
		if luck2 == 1 then
	      local positionTable = {Vector(-6144, -8128), Vector(-6912, -5888), Vector(-5632, -6336), Vector(-8192, -6528)}
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
	          local wolfCount = 0
	          for j = 0, wolfCount, 1 do
	            Timers:CreateTimer(j*2, function()
	              local elemental = Winterblight:SpawnMountainOgre(positionTable[i]+RandomVector(120), RandomVector(1))
	              Winterblight:AddPatrolArguments(elemental, 8, 25, 240, patrolPositionTable)
	            end)
	          end
	        end)
	      end
		elseif luck2 == 2 then
	      local positionTable = {Vector(-6144, -8128), Vector(-6912, -5888), Vector(-5632, -6336), Vector(-8192, -6528)}
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
	          local wolfCount = 1
	          for j = 0, wolfCount, 1 do
	            Timers:CreateTimer(j*2, function()
	              local elemental = Winterblight:SpawnMountainCritter(positionTable[i]+RandomVector(120), RandomVector(1))
	              Winterblight:AddPatrolArguments(elemental, 8, 25, 240, patrolPositionTable)
	            end)
	          end
	        end)
	      end
		elseif luck2 == 3 then
			for i = 0, 9 + GameState:GetDifficultyFactor()*4, 1 do
				Timers:CreateTimer(0.03*i, function()
					local position = Vector(-8832+RandomInt(0, 3200), -6848+RandomInt(0, 700))
					Winterblight:SpawnMountainBeetle(position, RandomVector(1))
				end)
			end
		end
	end)
end

function Winterblight:SpawnIceCrystal(position, fv, scale)
	local crystal = CreateUnitByName("winterblight_ice_crystal", position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,RandomInt(100, 200)))
	crystal:SetForwardVector(fv)
	crystal.startingBlue = RandomInt(130, 200)
	crystal:SetRenderColor(crystal.startingBlue, crystal.startingBlue, 255)
	crystal:SetModelScale(scale)
	crystal.dummy = true
end

function Winterblight:SpawnLivingIce(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_living_ice", position, 0, 0, nil, fv, true)
	stone.itemLevel = 18
	stone:SetRenderColor(170, 200, 255)
	stone.dominion = true
	return stone
end

function Winterblight:ShatterIceWall()
  local blockers = Entities:FindAllByNameWithin("IceShatterBlocker", Vector(-3335, -7744, 265+Winterblight.ZFLOAT), 3000)
  for i = 1, #blockers, 1 do
    UTIL_Remove(blockers[i])
  end
  local iceWalls = Entities:FindAllByNameWithin("IceWallToShatter", Vector(-3335, -7744, 265+Winterblight.ZFLOAT), 3000)
  for i = 1, #iceWalls, 1 do
  	local iceWall = iceWalls[i]
  	local position = iceWall:GetAbsOrigin()
	Winterblight:objectShake(iceWall, 8, 15, true, true, true, nil, 4)
	Timers:CreateTimer(0.3, function()
	    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )

	    ParticleManager:SetParticleControl( particle1, 0, position )
	    ParticleManager:SetParticleControl( particle1, 1, Vector(300, 2, 1000) )
	    ParticleManager:SetParticleControl( particle1, 3, Vector(300, 550, 550) )
	    Timers:CreateTimer(4, function()
	    	ParticleManager:DestroyParticle(particle1, false)
	    end)

		EmitSoundOnLocationWithCaster(position, "Winterblight.IceCrystal.Shatter", Events.GameMaster)
		for i = 1, 3, 1 do
			local spawnPos = position + WallPhysics:rotateVector(Vector(-1,0), 2*math.pi*i/3)*3
			local ice = Winterblight:SpawnLivingIce(position, (spawnPos-position):Normalized())
			CustomAbilities:QuickAttachParticle("particles/act_2/flying_shatter_blast_explosion.vpcf", ice, 3)
			EmitSoundOn("Winterblight.IceCrystal.Spawn", ice)
		end
		UTIL_Remove(iceWall)
	end)
  end
end

function Winterblight:SpawnMountainDweller(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mountain_dweller", position, 1, 2, "Winterblight.MountainDweller.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 21
	stone:SetRenderColor(255, 255, 255)
	stone.dominion = true
	return stone
end


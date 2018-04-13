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
  Timers:CreateTimer(2, function()
  	Winterblight:SpawnNorgok(Vector(2066, -5821), Vector(-1,1))
  end)
end

function Winterblight:SpawnMountainDweller(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mountain_dweller", position, 1, 2, "Winterblight.MountainDweller.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 21
	stone:SetRenderColor(255, 255, 255)
	stone.dominion = true
	return stone
end

function Winterblight:SnowCaveArea()
	local luck = RandomInt(1, 3)
	if luck == 1 then
		Winterblight:SpawnFrostiok(Vector(-1280, -8070), Vector(-0.3,1))
		Winterblight:SpawnFrostiok(Vector(-1042, -8384), Vector(-0.1,1))
		Winterblight:SpawnFrostiok(Vector(-790, -8040), Vector(-0.6,1))
		Winterblight:SpawnChillingColossus(Vector(-128, -8256), Vector(-1,1))
		Winterblight:SpawnChillingColossus(Vector(-704, -6080), Vector(0,-1))
		Timers:CreateTimer(2, function()
			Winterblight:SpawnIceMarauader(Vector(-960, -6133), Vector(-0.2,-1))
			Winterblight:SpawnIceMarauader(Vector(-1344, -6420), Vector(-0.3,-1))
			Winterblight:SpawnIceMarauader(Vector(-1792, -6723), Vector(0,-1))
		end)
		Timers:CreateTimer(2.5, function()
			Winterblight:Snowshaker(Vector(-320, -7424), Vector(-1,0.5))
			Winterblight:Snowshaker(Vector(-192, -7168), Vector(-1,0.7))
			Winterblight:Snowshaker(Vector(0, -6912), Vector(-1,0))
			Winterblight:Snowshaker(Vector(128, -6592), Vector(-1,0))
			Winterblight:SpawnChillingColossus(Vector(3264, -5504), Vector(-1,-1))
		end)
		Timers:CreateTimer(3, function()
			Winterblight:SpawnFrigidGrowth(Vector(1439, -6208), Vector(0,1))
			Winterblight:SpawnFrigidGrowth(Vector(1536, -5376), Vector(-1,-1))
			Winterblight:SpawnFrigidGrowth(Vector(1920, -5129), Vector(-0.5,-1))
			Winterblight:SpawnFrigidGrowth(Vector(1792, -6784), Vector(0,1))
			Winterblight:SpawnFrigidGrowth(Vector(2129, -7066), Vector(0.3,1))
		end)
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(192, -6218), Vector(-118, -6080), Vector(223, -5824), Vector(-142, -5696), Vector(543, -5884), Vector(141, -5515), Vector(452, -5444)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostiok(positionTable[i], Vector(-1,-0.8))
			end
		end)
		Timers:CreateTimer(3.8, function()
			local positionTable = {Vector(1119, -5440), Vector(704, -5568), Vector(942, -5120), Vector(1209, -4992), Vector(1053, -4608)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnMountainDweller(positionTable[i], Vector(-0.2,-1))
			end
		end)
		Timers:CreateTimer(0.5, function()
	   		local positionTable = {Vector(-2240, -7616), Vector(-492, -6792), Vector(768, -5376), Vector(2688, -5760), Vector(4224, -5888), Vector(3264, -6912), Vector(1984, -6528)}
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
		        for j = 0, 2, 1 do
		          Timers:CreateTimer(j*0.3, function()
		            local elemental = Winterblight:SpawnIceMarauader(positionTable[i]+RandomVector(120), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
		          end)
		        end
		      end)
		    end
		end)
	elseif luck == 2 then
		local positionTable = {Vector(-1408, -8192), Vector(-1216, -7872), Vector(-1065, -8192), Vector(-832, -7819), Vector(-733, -8128), Vector(-421, -7892)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnIceSummoner(positionTable[i], Vector(-0.2,1))
		end
		Winterblight:SpawnFrigidGrowth(Vector(-256, -8384), Vector(-1,1))
		Winterblight:SpawnFrigidGrowth(Vector(128, -8128), Vector(-1,0.3))
		Winterblight:SpawnFrigidGrowth(Vector(64, -7616), Vector(-1,-0.1))
		Timers:CreateTimer(0.5, function()
			Winterblight:SpawnChillingColossus(Vector(192, -4992), Vector(0.3,-1))
			Winterblight:SpawnChillingColossus(Vector(-1070, -6004), Vector(0.3,-1))
			local positionTable = {Vector(-1921, -6813), Vector(-1664, -6621), Vector(-1399, -6400), Vector(-1024, -6400), Vector(-704, -6176)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostiok(positionTable[i], Vector(-0.2,-1))
			end
		end)
		Timers:CreateTimer(1.0 ,function()
			for i = 0, 3+GameState:GetDifficultyFactor(), 1 do
				for j = 0, 3, 1 do
					local spawnPos = Vector(1472+i*168, -6093+j*168)
					local distance = WallPhysics:GetDistance2d(spawnPos, Vector(2066, -5821))
					if distance > 200 then
						Winterblight:SpawnIceMarauader(spawnPos, Vector(-1,0.1))
					end
				end
			end
		end)
		Timers:CreateTimer(2.0, function()
			local positionTable = {Vector(2842, -5518), Vector(3072, -5632), Vector(3248, -5440), Vector(3392, -5802), Vector(3648, -5824), Vector(3703, -5440)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnIceSummoner(positionTable[i], Vector(-0.2,-1))
			end
		end)
		Timers:CreateTimer(2.5, function()
			Winterblight:SpawnChillingColossus(Vector(3072, -6848), Vector(-1,1))
		end)
		Timers:CreateTimer(0.5, function()
	   		local positionTable = {Vector(-2048, -7552), Vector(-896, -6976), Vector(448, -5568), Vector(1343, -4752), Vector(2688, -6976), Vector(3648, -6592)}
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
		          Timers:CreateTimer(j*0.3, function()
		            local elemental = Winterblight:Snowshaker(positionTable[i]+RandomVector(120), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
		          end)
		        end
		      end)
		    end
		end)
		Timers:CreateTimer(3, function()
			local positionTable = {Vector(2190, -4800), Vector(1984, -4544), Vector(2487, -4672), Vector(2277, -4416), Vector(2613, -4288), Vector(1984, -4072), Vector(2368, -3974)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnFrostiok(positionTable[i], Vector(-1,-0.5))
			end
		end)
		Timers:CreateTimer(3.5, function()
			local positionTable = {Vector(1152, -4224), Vector(1408, -4224), Vector(1659, -4224)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnMountainDweller(positionTable[i], Vector(0,-1))
			end
		end)
		Timers:CreateTimer(1.3, function()
			for i = 0, 5, 1 do
				Timers:CreateTimer(0.03*i, function()
					local position = Vector(-637+RandomInt(0, 500), -7769+RandomInt(0, 500))
					Winterblight:SpawnMountainBeetle(position, RandomVector(1))
				end)
			end
		end)
		Timers:CreateTimer(4, function()
			for i = 0, 1, 1 do
				for j = 0, 2, 1 do
					Winterblight:SpawnMountainDweller(Vector(2768+i*200, -6444+j*200), RandomVector(1))
				end
			end
		end)
		Timers:CreateTimer(3, function()
			Winterblight:SpawnFrigidGrowth(Vector(2048, -6721), Vector(0,1))
			Winterblight:SpawnFrigidGrowth(Vector(1730, -6823), Vector(-0.2,1))
			Winterblight:SpawnFrigidGrowth(Vector(2176, -7040), Vector(0,1))
		end)	
	elseif luck == 3 then
		local positionTable = {Vector(-1472, -6976), Vector(-1600, -7360), Vector(-1984, -7360), Vector(-1728, -7744), Vector(-1344, -7616)}
		for i = 1, #positionTable, 1 do
			Winterblight:SpawnDashingSwordsman(positionTable[i], Vector(-1,0))
		end
	    Timers:CreateTimer(1.7, function()
		    local positionTable = {Vector(-1088, -6059), Vector(-960, -5989), Vector(-960, -5824), Vector(-992, -5692), Vector(-1088), Vector(-1248, -5989), Vector(-1281, -5632), Vector(-1529, -5856)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-896, -6208) - positionTable[i]):Normalized()
		      Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
		    end
	    end)
	    Timers:CreateTimer(2.3, function()
		    local positionTable = {Vector(3072, -7424), Vector(2944, -7424), Vector(2816, -7424), Vector(2521, -7668), Vector(1280, -6400), Vector(2240, -7296), Vector(2112, -7296), Vector(2112, -7168), Vector(1984, -7296), Vector(1984, -7168), Vector(2000, -7040), Vector(1882, -6912), Vector(1728, -6912), Vector(1728, -6770), Vector(1600, -6656), Vector(1600, -6784), Vector(1600, -6912)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(-896, -6208) - positionTable[i]):Normalized()
		      Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
		    end
	    end)
	    for i = 0, 5+GameState:GetDifficultyFactor(), 1 do
	    	for j = 0, 4, 1 do
	    		Timers:CreateTimer(i*0.1, function()
		    		if i >= j then
			    		local spawnPos = Vector(-1536, -8320)+Vector(i*140, j*140)
			    		Winterblight:SpawnIceMarauader(spawnPos, Vector(0,1))
			    	end
			    end)
	    	end
	    end
		Timers:CreateTimer(0.5, function()
			local positionTable = {Vector(-75, -7616), Vector(128, -7869), Vector(-124, -8000), Vector(64, -8235), Vector(-192, -8384)}
			for i = 1, #positionTable, 1 do
				Winterblight:SpawnMountainDweller(positionTable[i], Vector(-1,1))
			end
		end)
		Timers:CreateTimer(0.4, function()
	   		local positionTable = {Vector(-2112, -7936), Vector(-1792, -6656), Vector(-256, -7040), Vector(-768, -6080)}
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
		          Timers:CreateTimer(j*0.3, function()
		            local elemental = Winterblight:SpawnFrostiok(positionTable[i]+RandomVector(120), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
		          end)
		        end
		      end)
		    end
		end)
		Winterblight:SpawnChillingColossus(Vector(-768, -7006), Vector(-1,-0.3))
		Winterblight:SpawnChillingColossus(Vector(192, -5824), Vector(-1,-0.5))
		Timers:CreateTimer(2.0, function()
		    local positionTable = {Vector(256, -4873), Vector(980, -5120), Vector(1174, -4864), Vector(1374, -5006), Vector(1600, -5192), Vector(1024, -5824), Vector(1280, -6071)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(1344, -5568) - positionTable[i]):Normalized()
		      Winterblight:SpawnWinterbear(positionTable[i], lookToPoint)
		    end
		end)
		Timers:CreateTimer(1.2, function()
	   		local positionTable = {Vector(1024, -5376), Vector(1792, -4800), Vector(3520, -6208), Vector(3136, -6976), Vector(1920, -6464)}
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
		          Timers:CreateTimer(j*0.3, function()
		            local elemental = Winterblight:SpawnIceSummoner(positionTable[i]+RandomVector(120), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 7, 340, patrolPositionTable)
		          end)
		        end
		      end)
		    end
		end)
		Timers:CreateTimer(3.2, function()
		    local positionTable = {Vector(2240, -6208), Vector(2485, -5888), Vector(2648, -6208), Vector(2944, -6146), Vector(3200, -6379), Vector(2850, -6464), Vector(2489, -6528)}
		    for i = 1, #positionTable, 1 do
		      local lookToPoint = (Vector(1600, -5632) - positionTable[i]):Normalized()
		      Winterblight:Snowshaker(positionTable[i], lookToPoint)
		    end
		end)
		Timers:CreateTimer(3.8, function()
		    local positionTable = {Vector(3428, -5760), Vector(3648, -5441), Vector(3328, -5442), Vector(3070, -5568), Vector(2816, -5376), Vector(2995, -5120)}
		    for i = 1, #positionTable, 1 do
		      Winterblight:SpawnFrigidGrowth(positionTable[i], RandomVector(1))
		    end
		end)
	end
	local luck2 = RandomInt(1, 3)
	if luck2 == 1 then
	      local positionTable = {Vector(-2014, -7092), Vector(896, -5822), Vector(3456, -6976), Vector(4544, -5376)}
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
	end
end

function Winterblight:SpawnFrostiok(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("frostiok", position, 1, 2, "Winterblight.Frostiok.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 24
	stone.dominion = true
	return stone
end

function Winterblight:SpawnIceMarauader(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_icewrack_marauder", position, 1, 1, "Winterblight.IceMarauder.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 2, false)
	stone.itemLevel = 24
	stone.dominion = true
	stone:SetRenderColor(10,140,255)
	Timers:CreateTimer(0.2, function()
		if GameState:GetDifficultyFactor() < 3 then
			stone:RemoveAbility("winterblight_marauder_passive")
		end
		if GameState:GetDifficultyFactor() < 2 then
			stone:RemoveAbility("creature_black_king_bar")
		end
	end)
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate="melee"})
	stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="run"})
	return stone
end

function Winterblight:SpawnChillingColossus(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_chilling_colossus", position, 2, 3, "Winterblight.FrostColossus.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 24
	stone.dominion = true
	stone:SetRenderColor(30,90,255)
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	return stone
end

function Winterblight:SpawnNorgok(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_norgok_the_ice_rider", position, 3, 4, "Winterblight.Norgok.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 4, false)
	stone.itemLevel = 38
	stone:SetRenderColor(30,90,255)
	Winterblight:SetTargetCastArgs(stone, 1000, 0, 2, FIND_CLOSEST)
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(3)
	end
	return stone
end

function Winterblight:Snowshaker(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_snow_shaker", position, 0, 2, "Winterblight.Snowshaker.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 4, false)
	stone.itemLevel = 28
	Events:ColorWearablesAndBase(stone, Vector(30,90,255))
	Winterblight:SetPositionCastArgs(stone, 900, 0, 3, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrigidGrowth(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frigid_growth", position, 0, 2, "Winterblight.FrigidGrowth.Aggro", fv, false)
	Events:AdjustBossPower(stone, 2, 4, false)
	stone.itemLevel = 29
	stone.targetRadius = 420
	stone.autoAbilityCD = 1
	stone.dominion = true
	return stone
end

function Winterblight:SpawnIceSummoner(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_ice_summoner", position, 0, 2, "Winterblight.IceSummoner.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 26
	stone.targetRadius = 1200
	stone.autoAbilityCD = 1
	stone.dominion = true
	Events:ColorWearablesAndBase(stone, Vector(70,130,255))
	stone.maxSummons = GameState:GetDifficultyFactor() + 1
	return stone
end

function Winterblight:SpawnIceSummon(position, fv, caster, bAggro)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_summon_a", position, 0, 2, "Winterblight.FrigidGrowth.Aggro", fv, bAggro)
	Events:AdjustBossPower(stone, 1, 1, false)
	stone.itemLevel = 25
	stone.dominion = true
	Timers:CreateTimer(0.03, function()
		stone:SetOwner(caster)
		stone:SetTeam(caster:GetTeamNumber())
	end)
	return stone
end

function Winterblight:SpawnDashingSwordsman(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_dashing_swordsman", position, 0, 2, "Winterblight.BladeDancer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 26
	Winterblight:SetPositionCastArgs(stone, 1300, 0, 1, FIND_FARTHEST)
	stone.dominion = true
	Events:ColorWearablesAndBase(stone, Vector(80,130,255))
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate="walk"})
	Timers:CreateTimer(0.03, function()
		if GameState:GetDifficultyFactor() == 1 then
			stone:RemoveAbility("creature_pure_strike")
			stone:RemoveModifierByName("modifier_pure_strike")
		end
	end)
	return stone
end

function Winterblight:StartCaveWaves()
    for i = 1, #Winterblight.CaveSpawnerIceTable, 1 do
      Winterblight:MoveObject(Winterblight.CaveSpawnerIceTable[i], Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin()+Vector(0,0,100), 90)
      AddFOWViewer(DOTA_TEAM_GOODGUYS, Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin(), 500, 15, false)
      EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin(), "Winterblight.Monolith.Shake", Winterblight.Master)
      for j = 0, 4, 1 do
	      Timers:CreateTimer(0.8*j, function()
	      	local pfx = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/frosty_base_statue_destruction_dire.vpcf", PATTACH_CUSTOMORIGIN, nil)
	      	ParticleManager:SetParticleControl(pfx, 0, Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin()-Vector(0,0,80))
	      	Timers:CreateTimer(5, function()
	      		ParticleManager:DestroyParticle(pfx, false)
	      	end)
	      	EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin(), "Winterblight.Monolith.Detect", Winterblight.Master)
	      end)
	  end
    end
    Timers:CreateTimer(2.6, function()
	    for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
	      Winterblight:MoveObject(Winterblight.CaveSpawnerInnerTable[i], Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin()+Vector(0,0,28), 140)
	      EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.RiseStart", Winterblight.Master)
		  EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.Rising", Winterblight.Master)	      
	      Timers:CreateTimer(0.4, function()
	      	EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.Monolith.Detect", Winterblight.Master)
	      end)
	      Timers:CreateTimer(3.6, function()
	      	EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.Rise", Winterblight.Master)
	      end)
	      Winterblight:RotateObject(Winterblight.CaveSpawnerInnerTable[i], "right", 0.65, 150, 0)
	    end
    end)
	Winterblight.caveSpawnRotate = 97.5
	Winterblight.caveSpawnRotateAccel = 0.1
	Winterblight.caveSpawnInitialSpin = true
    Timers:CreateTimer(8.0, function()
    	Winterblight.CaveSpawnParticleTable = {}

	    Timers:CreateTimer(0.03, function()
	    	for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
		    	Winterblight.caveSpawnRotate = (Winterblight.caveSpawnRotate + Winterblight.caveSpawnRotateAccel)%360
		    	local newAngle = Winterblight.caveSpawnRotate
		    	Winterblight.caveSpawnRotateAccel = math.min(Winterblight.caveSpawnRotateAccel + 0.0025, 1.8)
		    	Winterblight.CaveSpawnerInnerTable[i]:SetAngles(0, newAngle, 0)
		    end
	    	if Winterblight.caveSpawnInitialSpin then
	    		return FrameTime()
	    	end
	    end)

	    for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
	     	EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.StartSpinning", Winterblight.Master)

		    Timers:CreateTimer(4.0, function()
		    	local pfx = ParticleManager:CreateParticle("particles/econ/events/ti5/town_portal_start_lvl2_black_ti5.vpcf", PATTACH_CUSTOMORIGIN, nil)
		    	ParticleManager:SetParticleControl(pfx, 0, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin())
		    	table.insert(Winterblight.CaveSpawnParticleTable, pfx)
		    	EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.TechStart", Winterblight.Master)
		    end)
	    end
	end)
	Timers:CreateTimer(14.8, function()
		local delay = 1.2 - 0.15*GameState:GetDifficultyFactor()
		for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
			local unitName = ""
			local luck = RandomInt(1, 2)
			if luck == 1 then
				unitName = "winterblight_ice_satyr"
			elseif luck == 2 then
				unitName = "winterblight_void_spawn"
			end
			Winterblight:SpawnCaveWaveUnit(unitName, Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), 13, delay, true)
		end
	end)
end

function Winterblight:SpawnCaveWaveUnit(unitName, spawnPoint, quantity, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.WaveSpawn", Winterblight.Master)
    end
      local luck = RandomInt(1, 160)
      if Events.SpiritRealm then
        luck = RandomInt(1, 66)
      end
      if luck == 1 then
        unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)   
      Events:AdjustDeathXP(unit)
      end
      if IsValidEntity(unit) then
        unit.dominion = true
        unit.deathCode = 1
        Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_wave_unit", {})
        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit, 2)
        unit.aggro = true
        Winterblight:AdjustWaveUnit(unit)
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].dominion = true
          unit[i]:SetAcquisitionRange(3000)
          unit[i].deathCode = 1
          Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit[i], "modifier_winterblight_wave_unit", {})
          CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit[i], 2)
          Winterblight:AdjustWaveUnit(unit[i])
        end
      end
    end)
  end
end

function Winterblight:AdjustWaveUnit(unit)
  if unit:GetUnitName() == "winterblight_icetaur" then
    unit:SetRenderColor(60, 140, 250 )
    if GameState:GetDifficultyFactor() == 3 then
    	unit:AddAbility("ability_mega_haste")
    end
  elseif unit:GetUnitName() == "winterblight_dashing_swordsman" then
	local stone = unit
	Winterblight:SetPositionCastArgs(stone, 1300, 0, 1, FIND_FARTHEST)
	Events:ColorWearablesAndBase(stone, Vector(80,130,255))
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate="walk"})
	Timers:CreateTimer(0.03, function()
		if GameState:GetDifficultyFactor() == 1 then
			stone:RemoveAbility("creature_pure_strike")
			stone:RemoveModifierByName("modifier_pure_strike")
		end
	end)
  elseif unit:GetUnitName() == "winterblight_frigid_growth" then
	unit.targetRadius = 420
	unit.autoAbilityCD = 1
  elseif unit:GetUnitName() ==  "winterblight_frostbite_spiderling" then
  	local speed = 440
  	if GameState:GetDifficultyFactor() == 2 then
  		speed = 380
  	elseif GameState:GetDifficultyFactor() == 1 then
  		speed = 300
  	end
  	unit:SetBaseMoveSpeed(speed)
  elseif unit:GetUnitName() == "winterblight_icewrack_marauder" then
	local stone = unit
	stone:SetRenderColor(10,140,255)
	Timers:CreateTimer(0.2, function()
		if GameState:GetDifficultyFactor() < 3 then
			stone:RemoveAbility("winterblight_marauder_passive")
		end
		if GameState:GetDifficultyFactor() < 2 then
			stone:RemoveAbility("creature_black_king_bar")
		end
	end)
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate="melee"})
	stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="run"})
  elseif unit:GetUnitName() == "winterblight_dimension_walker" then
  	unit:AddNewModifier(unit, nil, "modifier_animation_translate", {translate="run"})
  elseif unit:GetUnitName() == "winterblight_puck" then
	unit.targetRadius = 320
	unit.autoAbilityCD = 1
  elseif unit:GetUnitName() == "frost_whelpling" then
  	Winterblight:SetPositionCastArgs(unit, 900, 0, 3, FIND_ANY_ORDER)
  elseif unit:GetUnitName() == "winterblight_azalean_priest" then
  	Events:ColorWearablesAndBase(unit, Vector(90,150,255))
	Winterblight:SetTargetCastArgs(unit, 600+GameState:GetDifficultyFactor()*200, 0, 2, FIND_ANY_ORDER)
  elseif unit:GetUnitName() == "winterblight_frost_avatar" then
	if GameState:GetDifficultyFactor() == 3 then
		unit:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	unit:SetRenderColor(200, 210, 255)
  elseif unit:GetUnitName() == "winterblight_azure_sorceress" then
	if GameState:GetDifficultyFactor() == 3 then
		unit:AddAbility("seafortress_golden_shell"):SetLevel(3)
	end
  elseif unit:GetUnitName() ==  "winterblight_rider_of_azalea" then
	if GameState:GetDifficultyFactor() < 3 then
		unit:RemoveAbility("armor_break_ultra")
	end
  end
end

function Winterblight:FinishCaveWaves()
	Winterblight.caveSpawnInitialSpin = false
    Timers:CreateTimer(0.09, function()
    	for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
	    	Winterblight.caveSpawnRotate = (Winterblight.caveSpawnRotate + Winterblight.caveSpawnRotateAccel)%360
	    	local newAngle = Winterblight.caveSpawnRotate
	    	Winterblight.caveSpawnRotateAccel = Winterblight.caveSpawnRotateAccel - 0.0025
	    	Winterblight.CaveSpawnerInnerTable[i]:SetAngles(0, newAngle, 0)
	    end
    	if Winterblight.caveSpawnRotateAccel > 0 then
    		return FrameTime()
    	else
    		print("REMOVE PARTICLES")
    		for i = 1, #Winterblight.CaveSpawnParticleTable, 1 do
    			ParticleManager:DestroyParticle(Winterblight.CaveSpawnParticleTable[i], false)
    		end
		    for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
		     	EmitSoundOnLocationWithCaster(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin(), "Winterblight.WaveSpawner.TechEnd", Winterblight.Master)
		    end
    	end
    end)
    Timers:CreateTimer(5, function()
	    local walls = Entities:FindAllByNameWithin("CaveWall", Vector(3770, -7423, 128+Winterblight.ZFLOAT), 1800)
	    Winterblight:Walls(false, walls, true, 4.3)
	    Winterblight:RemoveBlockers(4, "CaveWallBlocker", Vector(3770, -7423, 128+Winterblight.ZFLOAT), 1400)
	    Winterblight:FirstOutsideAzaleaPocketSpawn()
    end)
    Timers:CreateTimer(6, function()
    	Winterblight:InitializeAzaleaSwords()
    end)
end

function Winterblight:FirstOutsideAzaleaPocketSpawn()
	if Winterblight.FirstAzaleaPocketSpawned then
		return false
	end
	Winterblight.FirstAzaleaPocketSpawned = true
    local positionTable = {Vector(4672, -7616), Vector(4864, -7762), Vector(5100, -7847)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(4717, -8205) - positionTable[i]):Normalized()
      Winterblight:SpawnWinterAssasin(positionTable[i], lookToPoint)
    end

    Winterblight:SpawnFrigidGrowth(Vector(4992, -7424)+RandomVector(60), RandomVector(1))
    Winterblight:SpawnFrigidGrowth(Vector(5371, -7290)+RandomVector(60), RandomVector(1))
    Winterblight:SpawnFrigidGrowth(Vector(5696, -7360)+RandomVector(60), RandomVector(1))
    Timers:CreateTimer(1, function()
	    local positionTable = {Vector(3072, -8448), Vector(3349,-8204)}
	    for i = 1, #positionTable, 1 do
	      local lookToPoint = (Vector(3500, -8635) - positionTable[i]):Normalized()
	      Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
	    end
    end)
    Timers:CreateTimer(1.7, function()
	    local positionTable = {Vector(3774, -8704), Vector(3712, -8850), Vector(3861, -8849), Vector(3830, -8995), Vector(4032, -8982), Vector(4032, -8767), Vector(4224, -8877), Vector(4272, -9099), Vector(4414, -9152), Vector(4544, -9152), Vector(4688, -9077), Vector(4480, -8976), Vector(4666, -8896), Vector(4478, -8768)}
	    for i = 1, #positionTable, 1 do
	      local lookToPoint = (Vector(4288, -8384) - positionTable[i]):Normalized()
	      Winterblight:SpawnFrostOrchid(positionTable[i], lookToPoint)
	    end
    end)
    Timers:CreateTimer(1.9, function()
	    local positionTable = {Vector(6080, -8640), Vector(6363, -8804), Vector(6592, -8913), Vector(6848, -9018), Vector(7296, -9018), Vector(7637, -8907)}
	    for i = 1, #positionTable, 1 do
	      local lookToPoint = (Vector(6912, -8256) - positionTable[i]):Normalized()
	      local unit = Winterblight:SpawnRiderOfAzalea(positionTable[i], lookToPoint)
	      CustomAbilities:QuickAttachParticle("particles/roshpit/items/ice_quill_explosion.vpcf", unit, 2)
	    end
    end)    
    Winterblight:SpawnChillingColossus(Vector(4979, -8896), Vector(-0.2,1))
end

function Winterblight:SpawnWinterAssasin(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_mistral_assassin", position, 0, 2, "Winterblight.MistralAssassin.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 31
	stone.dominion = true
	-- Timers:CreateTimer(0.03, function()
	-- 	if GameState:GetDifficultyFactor() == 1 then
	-- 	end
	-- end)
	-- Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	return stone
end

function Winterblight:SpawnFrostOrchid(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_orchid", position, 0, 0, nil, fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 31
	stone.dominion = true
	stone:SetAbsOrigin(stone:GetAbsOrigin()-Vector(0,0,40))
	-- Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	return stone
end

function Winterblight:SpawnWinterbear(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_winterbear", position, 0, 0, "Winterblight.Winterbear.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 31
	stone.dominion = true
	-- Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	return stone
end

function Winterblight:SpawnRiderOfAzalea(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_rider_of_azalea", position, 1, 1, "Winterblight.RiderOfAzalea.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	stone.itemLevel = 33
	stone.dominion = true
	if GameState:GetDifficultyFactor() < 3 then
		stone:RemoveAbility("armor_break_ultra")
	end
	return stone
end

function Winterblight:AzaleaMainSpawn()
	local luck = RandomInt(1, 3)
	luck = 2
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(11123, -7145), 23000, 23000, false)
	if luck == 1 then
		local count = 1
		if GameState:GetDifficultyFactor() == 3 then
			count = 2
		end
		local positionTable = {Vector(7296, -7744), Vector(8448, -6208), Vector(9664, -6912), Vector(11008, -6208), Vector(12544, -6976), Vector(14464, -8256)}
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
	        for j = 0, count, 1 do
	          Timers:CreateTimer(j*0.8, function()
	            local elemental = Winterblight:SpawnDashingSwordsman(positionTable[i]+RandomVector(350), RandomVector(1))
	            Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
	          end)
	        end
	      end)
	    end
	    Timers:CreateTimer(0.6, function()
			local count = 0
			if GameState:GetDifficultyFactor() == 3 then
				count = 1
			end
			local positionTable = {Vector(7744, -5913), Vector(9280, -7424), Vector(11456, -6272), Vector(11494, -7901), Vector(12736, -8256), Vector(14592, -6912)}
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
		        for j = 0, count, 1 do
		          Timers:CreateTimer(j*0.55, function()
		            local elemental = Winterblight:SpawnRiderOfAzalea(positionTable[i]+RandomVector(350), RandomVector(1))
		            Winterblight:AddPatrolArguments(elemental, 15, 5, 340, patrolPositionTable)
		          end)
		        end
		      end)
		    end
	    end)
	    Timers:CreateTimer(1.5, function()
	    	local positionTable = {Vector(7104, -7808), Vector(7552, -8320), Vector(8192, -8256)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnFrostElemental(positionTable[i], RandomVector(1))
	    	end	 
	    end)
	    Timers:CreateTimer(3, function()
	    	local positionTable = {Vector(8128, -7232), Vector(8512, -7104), Vector(8448, -7488), Vector(8000, -7552)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnAzaleaSorceress(positionTable[i], RandomVector(1))
	    	end
	    end)
	    Timers:CreateTimer(3.5, function()
	    	local positionTable = {Vector(9792, -5248), Vector(10240, -5056), Vector(10880, -5056), Vector(11456, -5056), Vector(11968, -5120), Vector(12416, -5376)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnFrostAvatar(positionTable[i], Vector(0,-1))
	    	end
	    end)
	    Timers:CreateTimer(3.15, function()
	    	local positionTable = {Vector(9344, -7360), Vector(9024, -6272), Vector(9856, -5952), Vector(10304, -7232), Vector(11328, -7424), Vector(11904, -7104), Vector(12480, -6336), Vector(12352, -5504), Vector(13376, -6080), Vector(14464, -6464)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnFrostElemental(positionTable[i], RandomVector(1))
	    	end	 
	    	
	    end)
	    Timers:CreateTimer(2.1, function()
			local positionTable = {Vector(6421, -6912), Vector(6666, -6848), Vector(6912, -6848), Vector(7006, -6720), Vector(6720, -6656), Vector(6424, -6656), Vector(6606, -6464), Vector(6858, -6464), Vector(7114, -6464), Vector(6757, -6272), Vector(7027, -6234)}
			for i = 1, #positionTable, 1 do
				if i < 6 + GameState:GetDifficultyFactor()*4 then
					local lookToPoint = (Vector(7488, -7104) - positionTable[i]):Normalized()
					Winterblight:SpawnIceSummoner(positionTable[i], lookToPoint)
				end
			end
			Winterblight:SpawnChillingColossus(Vector(8000, -5824), Vector(0.1,-1))
	    end)
	    Timers:CreateTimer(4.2, function()
	    	local positionTable = {Vector(10688, -7744), Vector(10688, -8192), Vector(11456, -7744), Vector(11456, -8192)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnFrostHulk(positionTable[i], Vector(0,1))
	    	end
	    	Winterblight:SpawnFrostHulk(Vector(15168, -7168), Vector(-1,0))
	    end)
	    Timers:CreateTimer(4.7, function()
	    	local positionTable = {Vector(14775, -8468), Vector(15104, -8320), Vector(14720, -8064), Vector(14976, -7808), Vector(15360, -7488)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnPriestOfAzalea(positionTable[i], RandomVector(1))
	    	end	 
	    end)
	    Timers:CreateTimer(5.2, function()
	    	local positionTable = {Vector(10944, -5766), Vector(10688, -6144), Vector(11136, -6400), Vector(11520, -6016)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnAzaleaSorceress(positionTable[i], RandomVector(1))
	    	end
	    end)
	    Timers:CreateTimer(5.7, function()
	    	local positionTable = {Vector(13312, -7104), Vector(13384, -7552), Vector(13894, -7296), Vector(13824, -7668)}
	    	for i = 1, #positionTable, 1 do
	    		Winterblight:SpawnAzaleaSorceress(positionTable[i], RandomVector(1))
	    	end
	    end)
	    Timers:CreateTimer(5.9, function()
			local positionTable = {Vector(11840, -8448), Vector(12104, -8640), Vector(12480, -8640)}
			for i = 1, #positionTable, 1 do
				local lookToPoint = (Vector(12224, -8128) - positionTable[i]):Normalized()
				Winterblight:SpawnPriestOfAzalea(positionTable[i], lookToPoint)
			end
			Winterblight:SpawnChillingColossus(Vector(8000, -5824), Vector(0.1,-1))
	    end)
	    Timers:CreateTimer(6.3, function()
			local positionTable = {Vector(14976, -5376), Vector(15232, -5312), Vector(15424, -5568), Vector(15168, -5760), Vector(15424, -5952)}
			for i = 1, #positionTable, 1 do
				if i < GameState:GetDifficultyFactor() + 3 then
					local lookToPoint = (Vector(14923, -6137) - positionTable[i]):Normalized()
					Winterblight:SpawnFrostAvatar(positionTable[i], lookToPoint)
				end
			end
			Winterblight:SpawnChillingColossus(Vector(15168, -6336), Vector(-1,0))
			Winterblight:SpawnWinterAssasin(Vector(14427, -8640), Vector(0,-1))
			Winterblight:SpawnWinterAssasin(Vector(14080, -8832), Vector(0,-1))
	    end)
	end
end

function Winterblight:SpawnAzaleaSorceress(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azure_sorceress", position, 1, 2, "Winterblight.AzaleaSorceress.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("seafortress_golden_shell"):SetLevel(3)
	end
	stone.itemLevel = 37
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrostAvatar(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_avatar", position, 0, 2, "Winterblight.IceSpecter.Aggro", fv, false)
	Events:AdjustBossPower(stone, 4, 3, false)
	stone.itemLevel = 37
	stone.dominion = true
	if GameState:GetDifficultyFactor() == 3 then
		stone:AddAbility("ability_mega_haste"):SetLevel(GameState:GetDifficultyFactor())
	end
	stone:SetRenderColor(200, 210, 255)
	return stone
end

function Winterblight:SpawnFrostElemental(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_elemental", position, 1, 2, "Winterblight.FrostElemental.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 4, false)
	stone.itemLevel = 39
	stone.dominion = true
	return stone
end

function Winterblight:SpawnFrostHulk(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_frost_frigid_hulk", position, 1, 3, "Winterblight.FrostHulk.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 6, false)
	stone.itemLevel = 41
	stone.dominion = true
	stone:SetRenderColor(200, 210, 255)
	return stone
end

function Winterblight:SpawnPriestOfAzalea(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalean_priest", position, 0, 2, "Winterblight.Priest.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 28
	Events:ColorWearablesAndBase(stone, Vector(90,150,255))
	Winterblight:SetTargetCastArgs(stone, 600+GameState:GetDifficultyFactor()*200, 0, 2, FIND_ANY_ORDER)
	stone.dominion = true
	return stone
end

function Winterblight:InitializeAzaleaSwords()
	local positionTable = {Vector(9280, -7360), Vector(12019, -7872), Vector(15040, -6976)}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer((i-1)*4.5, function()
			local position = positionTable[i]
			local yaw = 45
		    local shield = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
		    local yaw = RandomInt(0, 345)

		    shield:SetAngles(0, yaw, 0)
		    shield:SetRenderColor(180, 210, 255)
		    shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
		    shield:SetOriginalModel("models/winterblight/winter_sword.vmdl")
		    shield:SetModel("models/winterblight/winter_sword.vmdl")
		    shield:SetAbsOrigin(position)
		    shield:AddAbility("winterblight_attackable_unit"):SetLevel(1)
		    shield:RemoveAbility("dummy_unit")
		    shield:RemoveModifierByName("dummy_unit")
		    shield.basePosition = position

		    shield.yaw = yaw

		    shield.pushLock = true
		    shield.dummy = true
		    shield.jumpLock = true
		    AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 500, 99999, false)
		    shield.acceleration = 35
		    shield:SetAbsOrigin(shield:GetAbsOrigin()+Vector(0,0,2600))

		    local prop_ability = shield:FindAbilityByName("winterblight_attackable_unit")
		    prop_ability:ApplyDataDrivenModifier(shield, shield, "modifier_icy_appearance", {})
		    prop_ability:ApplyDataDrivenModifier(shield, shield, "modifier_sword_falling", {})
		    shield.prop_id = 0
		end)
	end

end

function Winterblight:SpawnFrostTitan(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_azalea_frost_titan", position, 3, 5, "Winterblight.FrostTitan.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 6, false)
	stone.itemLevel = 46
	Events:ColorWearablesAndBase(stone, Vector(200, 210, 255))
	Winterblight:SetTargetCastArgs(stone, 1000+GameState:GetDifficultyFactor()*500, 0, 1, FIND_ANY_ORDER)
	local passive = stone:FindAbilityByName("frost_titan_passive")
	passive:ApplyDataDrivenModifier(stone, stone, "modifier_disable_player", {duration =1.5})
	return stone
end


function Winterblight:StartOrbSequence()
	Winterblight.OrbTable = {}
	local particleName = "particles/roshpit/winterblight/azalea_orb.vpcf"
	local basePos = Vector(7620, -8671)
	local topRightPos = GetGroundPosition(Vector(15417, -5454), Events.GameMaster)
	local differenceI = (topRightPos.x - basePos.x)/10
	local differenceJ = (topRightPos.y - basePos.y)/3
	for i = 1, 10, 1 do
		for j = 1, 3, 1 do
			Timers:CreateTimer(0.3*(i-1) + (j-1)*3, function()
				local orbPos = GetGroundPosition(basePos + Vector(differenceI*(i-0.5)+RandomInt(-200, 200), differenceJ*(j-0.5)+RandomInt(-400, 400)), Events.GameMaster) 
				local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
				print(orbPos)
				local startHeight = 900+RandomInt(0, 200)
				local endHeight = 380+RandomInt(0, 210)
				ParticleManager:SetParticleControl(pfx, 0, orbPos + Vector(0,0,startHeight))
				ParticleManager:SetParticleControl(pfx, 1, orbPos + Vector(0,0,endHeight))
				ParticleManager:SetParticleControl(pfx, 2, Vector(100, 100, 100))
				ParticleManager:SetParticleControl(pfx, 3, Vector(100, 100, 100))
				local orb = {}
				orb.pfx = pfx
				orb.endPos = orbPos + Vector(0,0,endHeight)
				orb.index = i + j*100
				-- AddFOWViewer(DOTA_TEAM_GOODGUYS,orbPos, 300, 600, false)
				table.insert(Winterblight.OrbTable, orb)
			end)
		end
	end
	Timers:CreateTimer(1, function()
		EmitGlobalSound("Winterblight.AzaleaOrbs.Start")
	end)
	Winterblight.StatuesTable = {}
	local positionTable = {Vector(8288, -7175), Vector(11123, -6082), Vector(13680, -7175)}
	for i = 1, #positionTable, 1 do
		local statue = {}
		statue.prop = Entities:FindByNameNearest("RadiantTower", positionTable[i]+Vector(0,0,300), 1000)
		statue.position = statue.prop:GetAbsOrigin()
		table.insert(Winterblight.StatuesTable, statue)
	end
	Timers:CreateTimer(0.1, function()
	    Winterblight.OrbsMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
	    Winterblight.OrbsMaster:AddAbility("winterblight_orb_ability"):SetLevel(GameState:GetDifficultyFactor())
	    Winterblight.OrbsMaster:AddAbility("dummy_unit"):SetLevel(1)
	end)
	Timers:CreateTimer(12, function()
		Winterblight.OrbTable = WallPhysics:ShuffleTable(Winterblight.OrbTable)
		for i = 1, #Winterblight.OrbTable, 1 do
			Timers:CreateTimer(i*0.15, function()
				local orb = Winterblight.OrbTable[i]
				Winterblight:SpawnAzaleaWaveUnit("winterblight_dimension_walker", orb.endPos, 2, 12, true)
			end)
		end
	end)
end

function Winterblight:SpawnAzaleaWaveUnit(unitName, spawnPoint, quantity, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Winterblight.AzaleaOrbs.Spawn", Winterblight.Master)
    end
      local luck = RandomInt(1, 160)
      if Events.SpiritRealm then
        luck = RandomInt(1, 66)
      end
      if luck == 1 then
        unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)   
      Events:AdjustDeathXP(unit)
      end
      if IsValidEntity(unit) then
        unit.dominion = true
        unit.deathCode = 2
        Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_winterblight_wave_unit", {})
        unit:SetAcquisitionRange(5000)
        CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit, 2)
        unit.aggro = true
        Winterblight:AdjustWaveUnit(unit)
        Winterblight:UnitDescendFromOrb(unit, spawnPoint)
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].dominion = true
          unit[i]:SetAcquisitionRange(5000)
          unit[i].deathCode = 2
          Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit[i], "modifier_winterblight_wave_unit", {})
          CustomAbilities:QuickAttachParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff_beams.vpcf", unit[i], 2)
          Winterblight:AdjustWaveUnit(unit[i])
          Winterblight:UnitDescendFromOrb(unit[i], spawnPoint)
        end
      end
    end)
  end
end

function Winterblight:UnitDescendFromOrb(unit, spawnPoint)
	unit:SetAbsOrigin(spawnPoint)
	local startSpeed = 21
	local particleName = "particles/units/heroes/hero_wisp/wisp_tether.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(pfx, 0, spawnPoint)
	ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_disable_player", {duration = 2.5})
	for i = 1, 80, 1 do
		Timers:CreateTimer(i*0.03, function()
			if not unit:HasModifier("modifier_disable_player") then
				if pfx then
					FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
					ParticleManager:DestroyParticle(pfx, false)
					pfx = false
				end
				return false
			end
			local distanceToGround = unit:GetAbsOrigin().z - GetGroundHeight(unit:GetAbsOrigin(), unit)
			if distanceToGround < 10 then
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
				unit:RemoveModifierByName("modifier_disable_player")
				ParticleManager:DestroyParticle(pfx, false)
				pfx = false
				return false
			end
			startSpeed = math.max(startSpeed-0.5, 8)
			unit:SetAbsOrigin(unit:GetAbsOrigin()-Vector(0,0,startSpeed))
		end)
	end
end

function Winterblight:EndOrbWaves()
	for i = 1, #Winterblight.OrbTable, 1 do
		local targetProp = Winterblight.StatuesTable[1]
		if i%3 == 0 then
			targetProp = Winterblight.StatuesTable[1]
		elseif i%3 == 1 then
			targetProp = Winterblight.StatuesTable[2]
		elseif i%3 == 2 then
			targetProp = Winterblight.StatuesTable[3]
		end
	end
end
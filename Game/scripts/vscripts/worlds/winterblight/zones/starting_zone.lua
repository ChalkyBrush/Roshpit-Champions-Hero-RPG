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

function Winterblight:SnowCaveArea()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(1835, -7145), 7000, 7000, false)
	local luck = RandomInt(1, 3)
	luck = 3
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
	end

	Winterblight:SpawnNorgok(Vector(2066, -5821), Vector(-1,1))
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
	Events:ColorWearablesAndBase(stone, Vector(30,90,255))
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
	Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	stone:AddNewModifier(stone, nil, "modifier_animation", {translate="walk"})
	return stone
end

function Winterblight:FirstOutsideAzaleaPocketSpawn()
    local positionTable = {Vector(4672, -7616), Vector(4864, -7762), Vector(5100, -7847)}
    for i = 1, #positionTable, 1 do
      local lookToPoint = (Vector(4717, -8205) - positionTable[i]):Normalized()
      Winterblight:SpawnWinterSeal(positionTable[i], lookToPoint)
    end

    Winterblight:SpawnFrigidGrowth(Vector(4992, -7424)+RandomVector(60), RandomVector(1))
end

function Winterblight:SpawnWinterAssasin(position, fv)
	local stone = Winterblight:SpawnDungeonUnit("winterblight_dashing_swordsman", position, 0, 2, "Winterblight.BladeDancer.Aggro", fv, false)
	Events:AdjustBossPower(stone, 3, 3, false)
	stone.itemLevel = 31
	stone.dominion = true
	-- Events:ColorWearablesAndBase(stone, Vector(60,100,255))
	return stone
end
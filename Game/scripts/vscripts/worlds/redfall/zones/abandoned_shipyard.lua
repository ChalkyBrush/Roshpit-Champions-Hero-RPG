function Redfall:OpenAbandonedShipyard()
	Redfall.Shipyard = {}
	Redfall.Shipyard.active = true
	CustomGameEventManager:Send_ServerToAllClients("BGMend", {})

	Timers:CreateTimer(1, function()
		local walls = Entities:FindAllByNameWithin("ShipyardEntranceWall1", Vector(14950, -10419, 211+Redfall.ZFLOAT), 900)
		Redfall:Walls(false, walls, true, 2.3)
		Timers:CreateTimer(1, function()
			EmitGlobalSound("Music.Redfall.DungeonOpen")
		end)
		Timers:CreateTimer(4, function()
			local blockers = Entities:FindAllByNameWithin("ShipyardBlocker1", Vector(14912, -10471, 128+Redfall.ZFLOAT), 2000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
		Timers:CreateTimer(5.5, function()
			Redfall:SpawnShipyardRoom1()
			local walls = Entities:FindAllByNameWithin("ShipyardEntranceWall2", Vector(14950, -9966, 211+Redfall.ZFLOAT), 900)
			Redfall:Walls(false, walls, true, 2.3)
			Timers:CreateTimer(4, function()
				local blockers = Entities:FindAllByNameWithin("ShipyardBlocker2", Vector(14912, -9966, 128+Redfall.ZFLOAT), 2000)
				for i = 1, #blockers, 1 do
					UTIL_Remove(blockers[i])
				end
			end)
			Timers:CreateTimer(5.5, function()
				local walls = Entities:FindAllByNameWithin("ShipyardEntranceWall3", Vector(14950, -9536, 211+Redfall.ZFLOAT), 900)
				Redfall:Walls(false, walls, true, 2.3)
				Timers:CreateTimer(4, function()
					local blockers = Entities:FindAllByNameWithin("ShipyardBlocker3", Vector(15040, -9509, 128+Redfall.ZFLOAT), 2000)
					for i = 1, #blockers, 1 do
						UTIL_Remove(blockers[i])
					end
				end)
			end)
		end)
		Timers:CreateTimer(11, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				MAIN_HERO_TABLE[i].bgm = "Music.Redfall.AbandonedShipyard"
			end
			Redfall:ShipyardMusic()
		end)
	end)
	
	Redfall.Shipyard.Switch1 = Entities:FindByNameNearest("ShipyardSwitch1", Vector(10897, -6295, -125+Redfall.ZFLOAT), 750)
	Redfall.Shipyard.Switch1:SetAbsOrigin(Redfall.Shipyard.Switch1:GetAbsOrigin()+Vector(0,0,-500))


	local switch2 = Entities:FindByNameNearest("ShipyardSwitch2", Vector(15088, -6879, -516+Redfall.ZFLOAT), 750)
	Redfall.Shipyard.SpawnPedestals = Entities:FindAllByNameWithin("ShipyardSpawner", Vector(15088, -6879, -516+Redfall.ZFLOAT), 5000)
	table.insert(Redfall.Shipyard.SpawnPedestals, switch2)
	for i = 1, #Redfall.Shipyard.SpawnPedestals, 1 do
		Redfall.Shipyard.SpawnPedestals[i]:SetAbsOrigin(Redfall.Shipyard.SpawnPedestals[i]:GetAbsOrigin()+Vector(0,0,-500))
	end

	Redfall.ShipyardBigBridge = Entities:FindByNameNearest("ShipyardBigBridge", Vector(15892, 2933, -709+Redfall.ZFLOAT), 750)
	Redfall.ShipyardBigBridge:SetAbsOrigin(Redfall.ShipyardBigBridge:GetAbsOrigin()-Vector(0,0,600))
end

function Redfall:ShipyardMusic()
  Timers:CreateTimer(0, function()
    -- EmitSoundOnLocationWithCaster(Vector(-14976, -15296), "Music.Redfall.Village", Events.GameMaster)
    -- EmitSoundOnLocationWithCaster(Vector(-12864, -14848), "Music.Redfall.Village", Events.GameMaster)
      for i = 1, #MAIN_HERO_TABLE, 1 do
        if MAIN_HERO_TABLE[i].bgm == "Music.Redfall.AbandonedShipyard" then
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Redfall.AbandonedShipyard"})
        end
      end

    return 120
  end)
end

function Redfall:SpawnShipyardRoom1()
	Redfall:SpawnBloodHunter(Vector(14096, -8005), Vector(-1,0))
	Redfall:SpawnBloodHunter(Vector(13918, -8192), Vector(0,1))
	Redfall:SpawnBloodHunter(Vector(13778, -8677), Vector(1,1))

	Timers:CreateTimer(1, function()
		local positionTable = {Vector(13197, -8925), Vector(13001, -8384), Vector(13248, -7872), Vector(13493, -7466)}
		for i = 1, #positionTable, 1 do
			local patrolPositionTable = {}
			for j = 1, #positionTable, 1 do
				local index = i + j
				if index > #positionTable then
					index = index - #positionTable
				end
				table.insert(patrolPositionTable, positionTable[index])
			end
			local wraith = Redfall:SpawnDemonWolf(positionTable[i], RandomVector(1))
			Redfall:AddPatrolArguments(wraith, 60, 6, 30, patrolPositionTable)
		end
	end)
	Timers:CreateTimer(3, function()
		Redfall:SpawnSkeletonArcher(Vector(12032, -8832), Vector(1,1), false)
		Redfall:SpawnSkeletonArcher(Vector(12352, -8896), Vector(1,1), false)
		if GameState:GetDifficultyFactor() > 1 then
			Redfall:SpawnSkeletonArcher(Vector(12224, -8704), Vector(1,1))
		end

		Redfall:SpawnSkeletonArcher(Vector(11584, -8448), Vector(1,1), false)
		Redfall:SpawnSkeletonArcher(Vector(12160, -7936), Vector(0,-1), false)
		Redfall:SpawnSkeletonArcher(Vector(12416, -8128), Vector(0,-1), false)

		 Redfall:SpawnSkeletonArcherBoss(Vector(11776, -8064), Vector(1,-0.5), false)
	end)
	Timers:CreateTimer(4, function()
		Redfall:SpawnDemonRat(Vector(14272, -6528), Vector(0,1), false)
		Redfall:SpawnDemonRat(Vector(14144, -6720), Vector(-0.5,-1), false)
		Redfall:SpawnDemonRat(Vector(14400, -6675), Vector(1,0), false)

		Redfall:SpawnBloodHunter(Vector(15232, -7744), Vector(1,0.5))
		Redfall:SpawnBloodHunter(Vector(15616, -8000), Vector(0,1))
		Redfall:SpawnBloodHunter(Vector(15808, -7424), Vector(-1,0))
		local positionTable = {Vector(14720, -7552), Vector(14912, -6397), Vector(15680, -6528), Vector(15360, -7360)}
		for i = 1, #positionTable, 1 do
			Timers:CreateTimer(i*2, function()
				local patrolPositionTable = {}
				for j = 1, #positionTable, 1 do
					local index = i + j
					if index > #positionTable then
						index = index - #positionTable
					end
					table.insert(patrolPositionTable, positionTable[index])
				end
				local wraith = Redfall:SpawnDemonWolf(positionTable[i], RandomVector(1))
				Redfall:AddPatrolArguments(wraith, 60, 6, 30, patrolPositionTable)
			end)
		end

	end)
end

function Redfall:SpawnShipyardArea2()

	local zombieCount = 20 + GameState:GetDifficultyFactor()*4
	for i = 1, zombieCount, 1 do
		Timers:CreateTimer(i*0.35, function()
			Redfall:SpawnShipyardZombie(Vector(12544, -8896), Vector(0,1), true)
		end)
	end
end

function Redfall:SpawnBloodHunter(position, fv)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255,151,151)
		Events:AdjustBossPower(unit, 4, 4, false)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_crimsyth_blood_hunter",
		spawnPoint = position,		canBeParagon = false
		minDrops = 1, 
		maxDrops = 4, 
		itemLevel = 70, 
		aggroSound = "Redfall.BloodHunter.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnBloodWolf(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 1, 1, false)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_blood_wolf",
		spawnPoint = position,		canBeParagon = false
		minDrops = 1, 
		maxDrops = 2, 
		itemLevel = 68, 
		aggroSound = "Redfall.BloodWolf.Aggro",
		fv = fv, 
		isAggro = true, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnDemonWolf(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(120, 60, 60)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_demon_wolf",
		spawnPoint = position,		canBeParagon = false
		minDrops = 1, 
		maxDrops = 2, 
		itemLevel = 68, 
		aggroSound = "Redfall.DemonWolf.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnSkeletonArcher(position, fv, bAggro)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 3, 3, false)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_boar_glow_base.vpcf", unit, 3)
		unit:SetRenderColor(120, 70, 70)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "shipyard_skeleton_archer",
		spawnPoint = position,		canBeParagon = false
		minDrops = 1, 
		maxDrops = 2, 
		itemLevel = 68, 
		aggroSound = "Redfall.SkeletonArcher.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardZombie(position, fv, bAggro)
	local creepFunction = function(unit) 
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1,0,unit:GetAbsOrigin())
		Timers:CreateTimer(2, function()
    		ParticleManager:DestroyParticle( particle1, false )
		end)
		unit:SetRenderColor(200, 160, 160)
		unit.dominion = true
		Dungeons:attachWearables(unit, "attach_attack2", "models/items/axe/vanguard_armor/vanguard_armor.vmdl", 1.0)
		Dungeons:attachWearables(unit, "attach_attack1", "models/props_items/basher.vmdl", 1.0)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "shipyard_zombie_warrior",
		spawnPoint = position,		canBeParagon = false
		minDrops = 0, 
		maxDrops = 1, 
		itemLevel = 68, 
		aggroSound = "Redfall.ShipyardZombie.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnSkeletonArcherBoss(position, fv, bAggro)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 6, 7, false)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_boar_glow_base.vpcf", unit, 3)
		unit:SetRenderColor(255,130,130)
		Redfall:ColorWearables(unit, Vector(255,130,130))
		Redfall:SetPositionCastArgs(unit, 1400, 0, 1, FIND_ANY_ORDER)

		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "shipyard_skeleton_archer_boss",
		spawnPoint = position,		canBeParagon = false
		minDrops = 3, 
		maxDrops = 5, 
		itemLevel = 74, 
		aggroSound = "Redfall.SkeletonArcherBoss.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:AbandonedShipyardLobsterTrigger()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(12216, -7621, -337+Redfall.ZFLOAT), 400, 400, true)
	local lobsterHead = Entities:FindByNameNearest("LobsterStatueHead", Vector(12216, -7621, -337+Redfall.ZFLOAT), 750)
	for i = 1, 84, 1 do
		Timers:CreateTimer(i*0.03, function()
			lobsterHead:SetRenderColor(i*2, i*1, i*1)
		end)
	end
	EmitSoundOnLocationWithCaster(Vector(12216, -7821, Redfall.ZFLOAT), "Redfall.LobsterStatueActivate", Redfall.RedfallMaster)
	Timers:CreateTimer(4, function()
		for j = 1, 15, 1 do
			Timers:CreateTimer(j*0.3, function()
				local spawnPosition = Vector(11434+RandomInt(1, 780), -8176+RandomInt(1, 300))
				local rat = Redfall:SpawnShipyardZombie(spawnPosition, RandomVector(1), true)
				Redfall:RedBeam(lobsterHead:GetAbsOrigin(), GetGroundPosition(spawnPosition, Events.GameMaster))
				Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, rat, "modifier_lobster_statue_enemy", {})
			end)
		end
	end)
end

function Redfall:RedBeam(positionA, positionB)
      local particleName = "particles/roshpit/redfall/red_beam.vpcf"
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, Events.GameMaster) 
      -- ParticleManager:SetParticleControl(lightningBolt,0,Vector(8119, -9083, 870)) 
      ParticleManager:SetParticleControl(lightningBolt, 0, positionA+Vector(0,0,470))
      ParticleManager:SetParticleControl(lightningBolt, 1, positionB+Vector(0,0,340))
      Timers:CreateTimer(1.2, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
      end)
      EmitSoundOnLocationWithCaster(positionB, "Redfall.RedBeam.Sound", Redfall.RedfallMaster)
end

function Redfall:SpawnDemonRat(position, fv, bAggro)
	local creepFunction = function(unit) 
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1,0,unit:GetAbsOrigin())
		Timers:CreateTimer(2, function()
    		ParticleManager:DestroyParticle( particle1, false )
		end)
		unit:SetRenderColor(0, 120, 120)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_demon_rat",
		spawnPoint = position,		canBeParagon = false
		minDrops = 0, 
		maxDrops = 1, 
		itemLevel = 68, 
		aggroSound = nil,
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardDemonVoid(position, fv, bAggro)
	local creepFunction = function(unit) 
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1,0,unit:GetAbsOrigin())
		Timers:CreateTimer(2, function()
    		ParticleManager:DestroyParticle( particle1, false )
		end)
		unit:SetRenderColor(255,130,130)
		Redfall:ColorWearables(unit, Vector(255,130,130))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_void",
		spawnPoint = position,		canBeParagon = false
		minDrops = 0, 
		maxDrops = 2, 
		itemLevel = 74, 
		aggroSound = "Redfall.DemoinVoid.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardDemonBrute(position, fv, bAggro)
	local creepFunction = function(unit) 
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1,0,unit:GetAbsOrigin())
		Timers:CreateTimer(2, function()
    		ParticleManager:DestroyParticle( particle1, false )
		end)
		unit:SetRenderColor(255,130,130)
		Redfall:ColorWearables(unit, Vector(255,130,130))

		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_demon_brute",
		spawnPoint = position,		canBeParagon = false
		minDrops = 1, 
		maxDrops = 2, 
		itemLevel = 74, 
		aggroSound = "Redfall.DemoinBrute.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardConductor(position, fv, bAggro)
	local creepFunction = function(unit) 
		local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(particle1,0,unit:GetAbsOrigin())
		Timers:CreateTimer(2, function()
    		ParticleManager:DestroyParticle( particle1, false )
		end)
		Events:AdjustBossPower(unit, 12, 12, false)
		unit:SetRenderColor(255,130,130)
		Redfall:ColorWearables(unit, Vector(255,130,130))
		unit.targetRadius = 1500
		unit.autoAbilityCD = 1
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_conductor",
		spawnPoint = position,		canBeParagon = false
		minDrops = 1, 
		maxDrops = 2, 
		itemLevel = 74, 
		aggroSound = "Redfall.ShipyardConductor.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:DropShipyardSwitch1()
	Redfall.Shipyard.Switch1:SetAbsOrigin(Redfall.Shipyard.Switch1:GetAbsOrigin()+Vector(0,0,1485+500))
	Redfall.Shipyard.switchfallVelocity = 0

	for i = 1, 54, 1 do
		Timers:CreateTimer(i*0.03, function()
			Redfall.Shipyard.switchfallVelocity = Redfall.Shipyard.switchfallVelocity + 1
			Redfall.Shipyard.Switch1:SetAbsOrigin(Redfall.Shipyard.Switch1:GetAbsOrigin()-Vector(0,0,Redfall.Shipyard.switchfallVelocity))
		end)
	end
	Timers:CreateTimer(1.6, function()
	    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
	    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	    ParticleManager:SetParticleControl(particle1,0,Redfall.Shipyard.Switch1:GetAbsOrigin())
	    Timers:CreateTimer(2, function()
	    	ParticleManager:DestroyParticle( particle1, false )
	    end)
	    Redfall.Shipyard.Switch1Active = true
	    EmitSoundOnLocationWithCaster(Redfall.Shipyard.Switch1:GetAbsOrigin(), "Redfall.SwitchImpact", Events.GameMaster)
	end)
	-- Redfall.Shipyard.Switch1
end

function Redfall:LowerSwitch2andSpawners()
	for k = 1, #Redfall.Shipyard.SpawnPedestals, 1 do
		Redfall.Shipyard.SpawnPedestals[k]:SetAbsOrigin(Redfall.Shipyard.SpawnPedestals[k]:GetAbsOrigin()+Vector(0,0,1485+500))
		for i = 1, 54, 1 do
			Timers:CreateTimer(i*0.03, function()
				Redfall.Shipyard.SpawnPedestals[k]:SetAbsOrigin(Redfall.Shipyard.SpawnPedestals[k]:GetAbsOrigin()-Vector(0,0,i))
			end)
		end
		Timers:CreateTimer(1.6, function()
		    local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
		    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
		    ParticleManager:SetParticleControl(particle1,0,Redfall.Shipyard.SpawnPedestals[k]:GetAbsOrigin())
		    Timers:CreateTimer(2, function()
		    	ParticleManager:DestroyParticle( particle1, false )
		    end)
		    Redfall.Shipyard.Switch2Active = true
		    EmitSoundOnLocationWithCaster(Redfall.Shipyard.SpawnPedestals[k]:GetAbsOrigin(), "Redfall.SwitchImpact", Events.GameMaster)
		end)	
	end
end

function Redfall:Switch2Pressed()
	Redfall.shipyardSpawnPortalTable = {}
	local spawnPositionTable = {Vector(14275, -6679), Vector(15723, -6489), Vector(15093, -7482)}
	--print("SPAWN BATTLE??")
	Timers:CreateTimer(2, function()
		for i = 1, #spawnPositionTable, 1 do
			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
			ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i]+Vector(0,0,-358+Redfall.ZFLOAT))
			table.insert(Redfall.shipyardSpawnPortalTable, pfx)
			EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Redfall.SpawnPortalsActivate", Redfall.RedfallMaster)
		end
	end)
	Timers:CreateTimer(7, function()
		for i = 1, #spawnPositionTable, 1 do
			local delay = 1
			if GameState:GetDifficultyFactor() == 2 then
				delay = 0.8
			elseif GameState:GetDifficultyFactor() == 3 then
				delay = 0.6
			end
			Redfall:SpawnShipyardWaveUnit("redfall_shipyard_blood_wolf", spawnPositionTable[i], 13, 33, delay, true)
		end
	end)
end

function Redfall:SpawnShipyardWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
		if bSound then
			EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.SpawnShipyardPortalUnit", Redfall.RedfallMaster)
		end
      local luck = RandomInt(1, 222)
      if Events.SpiritRealm then
      	luck = RandomInt(1, 80)
      end
      if luck == 1 then
        unit = Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else
        unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)   
    	Events:AdjustDeathXP(unit)
      end
      if IsValidEntity(unit) and unit:GetUnitName() ~= "npc_dummy_unit" then
      	unit.itemLevel = itemLevel
      	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_shipyard_wave_unit", {})
      	unit:SetAcquisitionRange(3000)
      	unit.dominion = true
      	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", unit, 2)
      	unit.aggro = true
      	if unit:GetUnitName() == "redfall_shipyard_demon_wolf" then
      		unit:SetRenderColor(120, 60, 60)
      	elseif unit:GetUnitName() == "redfall_harvest_wraith" then
			unit:SetRenderColor(255,140,140)
			unit:ColorWearables(unit, Vector(255,140,140))
		elseif unit:GetUnitName() == "redfall_shipyard_void" then
			unit:SetRenderColor(255,130,130)
			Redfall:ColorWearables(unit, Vector(255,130,130))
		elseif unit:GetUnitName() == "water_temple_armored_water_beetle" then
			unit:SetRenderColor(255,130,130)
			Redfall:ColorWearables(unit, Vector(255,130,130))
		elseif unit:GetUnitName() == "redfall_farmlands_thief" then
			unit:SetRenderColor(100,40,40)
			Redfall:ColorWearables(unit, Vector(100,40,40))
      	end
      else
      	for i = 1, #unit, 1 do
      		unit.buddiesTable[i].aggro = true
      		unit.buddiesTable[i].itemLevel = itemLevel
      		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit.buddiesTable[i], "modifier_shipyard_wave_unit", {})
      		unit.buddiesTable[i]:SetAcquisitionRange(3000)
      		unit.buddiesTable[i].dominion = true
      		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_jakiro/viper_explosion_liquid_fire_explosion.vpcf", unit.buddiesTable[i], 2)
      	end
      end
    end)
  end
end

function Redfall:ShipyardGatekeeperBoss()
	local spawnPosition = Vector(15071, -6883, -440+Redfall.ZFLOAT)
	local particleName = "particles/frostivus_gameplay/frostivus_throne_wraith_king_ambient.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl(particle1,0,spawnPosition)
    Timers:CreateTimer(8, function()
    	ParticleManager:DestroyParticle( particle1, false )
    end)
    EmitSoundOnLocationWithCaster(spawnPosition, "Redfall.ShipyardGateKeeper.Spawn", Redfall.RedfallMaster)
    Timers:CreateTimer(3, function()
    	EmitSoundOnLocationWithCaster(spawnPosition, "Redfall.Gatekeeper.Spawn", Redfall.RedfallMaster)
    	Redfall:SpawnShipyardGatekeeper(spawnPosition, Vector(0,-1), false)
    end)
end

function Redfall:SpawnShipyardGatekeeper(position, fv, bAggro)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255,130,130)
		Redfall:ColorWearables(unit, Vector(255,130,130))
		Events:AdjustBossPower(unit, 6, 6, false)
		unit.targetRadius = 1300
		unit.autoAbilityCD = 2
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_gatekeeper",
		spawnPoint = position,		canBeParagon = false
		minDrops = 5, 
		maxDrops = 7, 
		itemLevel = 80, 
		aggroSound = "Redfall.Gatekeeper.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_MINI_BOSS, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardFerry()
	if not Redfall.Shipyard then
		Redfall.Shipyard = {}
	end
	Redfall.Shipyard.boatAlock = true
	Redfall.Shipyard.boatsEnabled = true
	local spawnPosition = Vector(13028, -5888, -735+Redfall.ZFLOAT)
	local particleName = "particles/frostivus_gameplay/frostivus_throne_wraith_king_ambient.vpcf"
    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl(particle1,0,spawnPosition)
    Timers:CreateTimer(8, function()
    	ParticleManager:DestroyParticle( particle1, false )
    end)
    EmitSoundOnLocationWithCaster(spawnPosition, "Redfall.ShipyardGateKeeper.Spawn", Redfall.RedfallMaster)
	local boatDummy = CreateUnitByName("redfall_shipyard_transport_boat", spawnPosition, false, nil, nil, DOTA_TEAM_GOODGUYS)
	boatDummy:SetAngles(-3, 0, 0)
	boatDummy:SetRenderColor(153, 255, 217)

	local ability_ghost = boatDummy:FindAbilityByName("shipyard_boat_dummy_ability"):SetLevel(1)
	boatDummy:AddAbility("dummy_unit"):SetLevel(1)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, spawnPosition, 500, 60, true)
	Redfall.BoatA = boatDummy

	Timers:CreateTimer(1, function()
		local spawnPosition = Vector(13028, -5888, -735+Redfall.ZFLOAT)

		local boatDummy = CreateUnitByName("redfall_shipyard_boat_handler", spawnPosition, false, nil, nil, DOTA_TEAM_GOODGUYS)
		boatDummy:SetForwardVector(Vector(0,-1))
		boatDummy:SetRenderColor(153, 255, 217)
		EmitSoundOn("Redfall.ShipyardHandler.Spawn", boatDummy)
		boatDummy:AddAbility("ability_ghost_effect"):SetLevel(1)
		Redfall.BoatA.handler = boatDummy
		boatDummy:AddAbility("town_unit"):SetLevel(1)
	end)
	Timers:CreateTimer(2, function()
		Redfall.Shipyard.boatAlock = false
	end)

	Timers:CreateTimer(3, function()
		Redfall.Shipyard.boatBlock = true
		local spawnPosition = Vector(13888, -3456, -735+Redfall.ZFLOAT)
		local particleName = "particles/frostivus_gameplay/frostivus_throne_wraith_king_ambient.vpcf"
	    local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
	    ParticleManager:SetParticleControl(particle1,0,spawnPosition)
	    Timers:CreateTimer(8, function()
	    	ParticleManager:DestroyParticle( particle1, false )
	    end)
		local boatDummy = CreateUnitByName("redfall_shipyard_transport_boat", spawnPosition, false, nil, nil, DOTA_TEAM_GOODGUYS)
		boatDummy:SetAngles(-3, 0, 0)
		boatDummy:SetRenderColor(153, 255, 217)
		boatDummy:SetForwardVector(Vector(0,1))

		local ability_ghost = boatDummy:FindAbilityByName("shipyard_boat_dummy_ability"):SetLevel(1)
		boatDummy:AddAbility("dummy_unit"):SetLevel(1)
		AddFOWViewer(DOTA_TEAM_GOODGUYS, spawnPosition, 500, 60, true)
		Redfall.BoatB = boatDummy

		Timers:CreateTimer(1, function()
			local spawnPosition = Vector(13888, -3456, -735+Redfall.ZFLOAT)

			local boatDummy = CreateUnitByName("redfall_shipyard_boat_handler", spawnPosition, false, nil, nil, DOTA_TEAM_GOODGUYS)
			boatDummy:SetForwardVector(Vector(1,0))
			boatDummy:SetRenderColor(153, 255, 217)
			boatDummy:AddAbility("ability_ghost_effect"):SetLevel(1)
			Redfall.BoatB.handler = boatDummy
			boatDummy:AddAbility("town_unit"):SetLevel(1)
		end)
		Timers:CreateTimer(2, function()
			Redfall.Shipyard.boatBlock = false
		end)
	end)
	Redfall:SpawnShipyardPt2()
end

function Redfall:SpawnShipyardPt2()
	local lookSpot = Vector(14976, -3392)
	local fishSpawnTable = {Vector(14720, -3264), Vector(14720, -3072), Vector(14720, -2880), Vector(14720, -2688), Vector(14784, -2496), Vector(14848, -2240), Vector(15360, -2240), Vector(15296, -2496), Vector(15296, -2688), Vector(15232, -2880), Vector(15168, -3072), Vector(15040, -3264)}
	for i = 1, #fishSpawnTable, 1 do
		Timers:CreateTimer(i*0.2, function()
			local fv = (lookSpot - fishSpawnTable[i]):Normalized()
			Redfall:SpawnShipyardGhostFish(fishSpawnTable[i], fv)
		end)
	end

	local skeleThinkers = {Vector(14784, -3072), Vector(15168, -3072), Vector(14784, -2816), Vector(15168, -2816), Vector(14874, -2496), Vector(15105, -2300)}
	for j = 1, #skeleThinkers, 1 do
		local thinker = CreateUnitByName("dungeon_thinker", skeleThinkers[j], true, nil, nil, DOTA_TEAM_NEUTRALS)
		thinker.dungeon = "abandoned_shipyard"
		thinker.type = "shipyard_skeleton"
		thinker:FindAbilityByName("dungeon_thinker"):SetLevel(1)
	end
end

function Redfall:SpawnShipyardGhostFish(position, fv)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255,60,60)
		Redfall:ColorWearables(unit, Vector(255,60,60))
		Events:AdjustBossPower(unit, 1, 1, false)
		unit.targetRadius = 1000
		unit.autoAbilityCD = 4
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "shipyard_ghost_fish",
		spawnPoint = position,		canBeParagon = false
		minDrops = 0, 
		maxDrops = 2, 
		itemLevel = 80, 
		aggroSound = "Redfall.ShipyardSharkFish.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ShipyardSkeletons(position)
	for i = 1, 3, 1 do
		Timers:CreateTimer(i*0.4, function()
			for j = 1, 3, 1 do
				Timers:CreateTimer(j*0.1, function()
					local spawnPosition = position + Vector(90*(i-2), 90*(j-2))
					local fv = Vector(0,-1)
					Redfall:SpawnShipyardSkeletonWarrior(spawnPosition, fv)
				end)
			end
		end)
	end
end

function Redfall:SpawnShipyardSkeletonWarrior(position, fv)
	local creepFunction = function(unit) 
		unit:SetRenderColor(90,180,150)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_basic_skeleton",
		spawnPoint = position,		canBeParagon = false
		minDrops = 0, 
		maxDrops = 1, 
		itemLevel = 72, 
		aggroSound = "Redfall.SkeletonSpawn.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardPirateArcher(position, fv)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255,160,160)
		Redfall:ColorWearables(unit, Vector(255,160,160))
		Events:AdjustBossPower(unit, 2, 2, false)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "shipyard_pirate_archer",
		spawnPoint = position,		canBeParagon = false
		minDrops = 0, 
		maxDrops = 2, 
		itemLevel = 72, 
		aggroSound = "Redfall.PirateArcher.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ShipyardBigTrigger1()
	Redfall:SpawnShipyardCargoWatcher(Vector(15296, -1472), Vector(0.4,-1))
	Redfall:SpawnShipyardCargoWatcher(Vector(15168, -1152), Vector(1,0))
	Redfall:SpawnShipyardCargoWatcher(Vector(15296, -704), Vector(1,-1))
	Redfall:SpawnShipyardCargoWatcher(Vector(15936, -1152), Vector(-1,-0.2))
	Redfall:SpawnShipyardCargoWatcher(Vector(15808, -1536), Vector(-1,1))

	Redfall:SpawnShipyardPirateArcher(Vector(16128, -896), Vector(-1,0))
	Timers:CreateTimer(3, function()
		Redfall:SpawnShipyardPirateArcher(Vector(15143, 664), Vector(1,0))
		if GameState:GetDifficultyFactor() > 1 then
			Redfall:SpawnShipyardPirateArcher(Vector(15143, 802), Vector(1,0))
		end
		Redfall:SpawnShipyardPirateArcher(Vector(15261, 802), Vector(1,0))
		Redfall:SpawnShipyardPirateArcher(Vector(15133, 553), Vector(1,0))

		Redfall:SpawnShipyardPirateArcher(Vector(15787, 299), Vector(-1,0))
		Redfall:SpawnShipyardPirateArcher(Vector(15787, 483), Vector(-1,0))
		Redfall:SpawnShipyardPirateArcher(Vector(15936, 500), Vector(-1,0))
		Redfall:SpawnShipyardPirateArcher(Vector(16080, 483), Vector(-1,0))
		Redfall:SpawnShipyardPirateArcher(Vector(15960, 743), Vector(-1,0))
	end)
	Timers:CreateTimer(5, function()
		local luck = RandomInt(1,3)
		if luck == 1 then
			Redfall:SpawnShipyardSoulCollector(Vector(15744, 1250), Vector(-0.15, -1))
		end
	end)
end

function Redfall:SpawnShipyardCargoWatcher(position, fv)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255,160,160)
		Redfall:ColorWearables(unit, Vector(255,160,160))
		Events:AdjustBossPower(unit, 5, 5, false)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_cargo_watcher",
		spawnPoint = position,		canBeParagon = false
		minDrops = 2, 
		maxDrops = 5, 
		itemLevel = 72, 
		aggroSound = "Redfall.CargoWatcher.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardSpawnerUnit(position, fv, itemRoll, bAggro)
	local creepFunction = function(unit) 
		unit:SetRenderColor(233,140,140)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_pirate_gnoll",
		spawnPoint = position,		canBeParagon = false
		minDrops = itemRoll, 
		maxDrops = itemRoll, 
		itemLevel = 67, 
		aggroSound = "Redfall.ShipyardKobold.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardSpawner(position, fv)
	local creepFunction = function(unit) 
		unit:SetForwardVector(fv)
		unit.summonCenter = summonCenter
		unit.jumpLock = true
		local newHealth = GameState:GetDifficultyFactor()*100
		unit:SetMaxHealth(newHealth)
		unit:SetBaseMaxHealth(newHealth)
		unit:SetHealth(newHealth)
		unit:Heal(newHealth, unit)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_spawner_boss",
		spawnPoint = position,		canBeParagon = false
		minDrops = nil, 
		maxDrops = nil, 
		itemLevel = 86, 
		aggroSound = nil,
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnShipyardSoulCollector(position, fv)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255,160,160)
		Redfall:ColorWearables(unit, Vector(255,160,160))
		Events:AdjustBossPower(unit, 6, 6, false)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_soul_collector",
		spawnPoint = position,		canBeParagon = false
		minDrops = 4, 
		maxDrops = 7, 
		itemLevel = 86, 
		aggroSound = "Redfall.ShipyardSoulCollector.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:RaiseShipyardBridge()
	local position = Vector(15891, 2933, -700+Redfall.ZFLOAT)
	local moveVector = Vector(0,0,600/180)
	for j = 1, 180, 1 do
		Timers:CreateTimer(j*0.03, function()

			Redfall.ShipyardBigBridge:SetAbsOrigin(Redfall.ShipyardBigBridge:GetAbsOrigin()+moveVector)
			if j%30 == 0 then
				ScreenShake(position, 130, 0.9, 0.9, 9000, 0, true)
				EmitSoundOnLocationWithCaster(position, "Redfall.TreeRising", Redfall.RedfallMaster)
		  		local vectorTable = {Vector(11676, 1728, -610), Vector(11776, 1984, -610), Vector(11776, 2240, -610), Vector(11776, 1528, -610), Vector(12233, 2240, -610), Vector(12233, 1728, -610), Vector(12233, 2028, -610), Vector(12233, 1528, -610)}
		  		local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
		      	for i = 0, 10, 1 do
		      		for j = 1, 2, 1 do
				  	  	local position = Vector(15700, 2002, -700)+Vector(0,180*i,Redfall.ZFLOAT-120)
				  	  	if j == 2 then
				  	  		position = Vector(16020, 2002, -700)+Vector(0,180*i,Redfall.ZFLOAT-120)
				  	  	end
				  	  	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
				  	  	ParticleManager:SetParticleControl(pfx, 0, position)
				  		  Timers:CreateTimer(2, function()
				  			   ParticleManager:DestroyParticle(pfx, false)
				  		  end)
				  	end
		      	end			
			end
			if j == 180 then
				EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealedMain", Events.GameMaster)
				EmitSoundOnLocationWithCaster(position, "Redfall.TreeHealed", Redfall.RedfallMaster)		
			end
		end)
	end
	Timers:CreateTimer(6.5, function()
		local blockers = Entities:FindAllByNameWithin("ShipyardBridgeBlocker", Vector(15891, 2933, -685+Redfall.ZFLOAT), 7000)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)
end

function Redfall:SpawnArmoredBearGuard(position, fv)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255,190,190)
		Redfall:ColorWearables(unit, Vector(255,190,190))
		Events:AdjustBossPower(unit, 3, 3, false)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "shipyard_armored_bear_guard",
		spawnPoint = position,		canBeParagon = false
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 86, 
		aggroSound = "Redfall.ShipyardArmoredBearGuard.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ShipyardBridgeTrigger()
	local bears = GameState:GetDifficultyFactor() + 2
	for i = 1, bears, 1 do
		Timers:CreateTimer(i*0.3, function()
			local spawnPoint = Vector(15552, 5504)
			local bear = Redfall:SpawnArmoredBearGuard(spawnPoint, RandomVector(1))
			Timers:CreateTimer(1, function()
				bear:MoveToPositionAggressive(Vector(15872, 2568))
			end)
		end)
	end
	local positionTable = {Vector(14976, 6528), Vector(15488, 6528), Vector(15040, 7424), Vector(15424, 7437)}
	for i = 1, #positionTable, 1 do
		Timers:CreateTimer(i*0.4, function()
			local knight = Redfall:SpawnCrimsythKnight(positionTable[i], Vector(0,-1), false)
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, knight, "modifier_shipyard_knight", {})
		end)
	end
end

function Redfall:SpawnCrimsythKnight(position, fv, bAggro)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 4, 4, false)
		if GameState:GetDifficultyFactor() > 1 then
			unit.targetRadius = 500
			unit.minRadius = 0
			unit.targetAbilityCD = RandomInt(2, 4)
			unit.targetFindOrder = FIND_CLOSEST
			unit:AddAbility("use_ability_1_target_ai"):SetLevel(1)
		end
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_crimsyth_knight",
		spawnPoint = position,		canBeParagon = false
		minDrops = 2, 
		maxDrops = 3, 
		itemLevel = 86, 
		aggroSound = "Redfall.CrimsythKnight.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = "modifier_shipyard_knight", 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnCrimsythKnightChamp(position, fv, bAggro)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 5, 5, false)
		unit.targetRadius = 500
		unit.minRadius = 0
		unit.targetAbilityCD = RandomInt(2, 4)
		unit.targetFindOrder = FIND_CLOSEST
		unit:AddAbility("use_ability_1_target_ai"):SetLevel(1)
		unit:SetRenderColor(255,130,130)
		Redfall:ColorWearables(unit, Vector(255,130,130))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_shipyard_crimsyth_knight_champ",
		spawnPoint = position,		canBeParagon = false
		minDrops = 4, 
		maxDrops = 5, 
		itemLevel = 86, 
		aggroSound = "Redfall.CrimsythKnight.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = "modifier_shipyard_knight", 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:LowerBossRoomWall()
	if not Redfall.Shipyard then
		Redfall.Shipyard = {}
	end
	local walls = Entities:FindAllByNameWithin("ShipyardBossEntranceWall", Vector(15254, 8427, -291+Redfall.ZFLOAT), 900)
	Redfall:Walls(false, walls, true, 2.91)
	Timers:CreateTimer(4.4, function()
		local blockers = Entities:FindAllByNameWithin("ShipyardBossEntranceBlocker", Vector(15307, 8381, -523+Redfall.ZFLOAT), 1400)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
	end)	

	Redfall:SpawnBossRoom()
end

function Redfall:SpawnBossRoom()
	local boss = CreateUnitByName("redfall_shipyard_boss", Vector(14848, 11634), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_command_restric_player", {})
	Events:AdjustDeathXP(boss)
	Events:AdjustBossPower(boss, 6, 6, false)
	boss.mainBoss = true
	Redfall.Shipyard.boss = boss
	boss:SetForwardVector(Vector(0,-1))
	AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(14848, 11634), 1000, 1200, false)
	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, boss, "modifier_disable_player", {}) 
	local archerTable = {Vector(14592, 11456), Vector(15104, 11456), Vector(14336, 10880), Vector(14336, 10624), Vector(14336, 10368), Vector(15296, 10880), Vector(15296, 10624), Vector(15296, 10368)}
	local archerFVTable = {Vector(0,-1), Vector(0,-1), Vector(1,-1), Vector(1,-1), Vector(1,-1), Vector(-1, -1), Vector(-1, -1), Vector(-1, -1)}
	Redfall.Shipyard.CrimsythTable = {}
	for i = 1, #archerTable, 1 do
		local archer = Redfall:SpawnFarmlandsBandit(archerTable[i], archerFVTable[i])
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, archer, "modifier_disable_player", {})
		table.insert(Redfall.Shipyard.CrimsythTable, archer)
		archer.aggroLock = true
	end
	local lionTable = {Vector(14144, 11200), Vector(15552, 11264)}
	for i = 1, #lionTable, 1 do
		local archer = Redfall:SpawnCrimsythRecruiter(lionTable[i], Vector(0,-1))
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, archer, "modifier_disable_player", {})
		table.insert(Redfall.Shipyard.CrimsythTable, archer)
		archer.aggroLock = false
	end
	Redfall.Shipyard.BossSpikeTable = {}
	local spike = {}
	local spikeProp = Entities:FindByNameNearest("SpikeBall1", Vector(13859, 10176, -520+Redfall.ZFLOAT), 550)
	spike.spikeProp = spikeProp
	spike.spikeFV = Vector(1,0)
	spike.spikeDistance = 2060
	table.insert(Redfall.Shipyard.BossSpikeTable, spike)

	local spike2 = {}
	local spikeProp = Entities:FindByNameNearest("SpikeBall2", Vector(15922, 10991, -520+Redfall.ZFLOAT), 550)
	spike2.spikeProp = spikeProp
	spike2.spikeFV = Vector(-1,0)
	spike2.spikeDistance = 2060
	table.insert(Redfall.Shipyard.BossSpikeTable, spike2)

	local spike3 = {}
	local spikeProp = Entities:FindByNameNearest("SpikeBall3", Vector(14312, 11785, -520+Redfall.ZFLOAT), 550)
	spike3.spikeProp = spikeProp
	spike3.spikeFV = Vector(0,-1)
	spike3.spikeDistance = 2120
	table.insert(Redfall.Shipyard.BossSpikeTable, spike3)

	local spike4 = {}
	local spikeProp = Entities:FindByNameNearest("SpikeBall4", Vector(15431, 11785, -520+Redfall.ZFLOAT), 550)
	spike4.spikeProp = spikeProp
	spike4.spikeFV = Vector(0,-1)
	spike4.spikeDistance = 2120
	table.insert(Redfall.Shipyard.BossSpikeTable, spike4)

	for i = 1, #Redfall.Shipyard.BossSpikeTable, 1 do
		local spikeData = Redfall.Shipyard.BossSpikeTable[i]
		spikeData.spikeProp:SetAbsOrigin(spikeData.spikeProp:GetAbsOrigin()-Vector(0,0,400))
	end
end

function Redfall:InitiateAndRunSpikeBalls(beginLoop, endLoop)
	for i = beginLoop, endLoop, 1 do
		local spikeData = Redfall.Shipyard.BossSpikeTable[i]
		spikeData.spikeProp:SetAbsOrigin(spikeData.spikeProp:GetAbsOrigin()+Vector(0,0,400))
	    local dummy = CreateUnitByName("npc_dummy_unit", spikeData.spikeProp:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
	    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	    dummy:AddAbility("shipyard_spike_ability"):SetLevel(1)	
	    Redfall.Shipyard.BossSpikeTable[i].dummy = dummy
	    dummy.spikeData = Redfall.Shipyard.BossSpikeTable[i]
	end
end

function Redfall:ScaleModelOverTime(loops, sizeDelta, unit)
	if loops%2 == 1 then
		loops = loops + 1
	end
	for i = 1, loops, 1 do
		Timers:CreateTimer(i*0.03, function()
			if i <= loops/2 then
				unit:SetModelScale(unit:GetModelScale()+sizeDelta)
			else
				unit:SetModelScale(unit:GetModelScale()-sizeDelta)
			end
		end)
	end
end

function Redfall:BossRoomTriggerInitiate()
	 -- CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = boss:GetUnitName(), bossMaxHealth = unit:GetMaxHealth()})
	 local boss = Redfall.Shipyard.boss
	 local dialogueName = "#shipyard_boss_dialogue_1"
	 local luck = RandomInt(1, 2)
	 if luck == 1 then
	 	dialogueName = "#shipyard_boss_dialogue_1a"
	 end
	 Redfall:Dialogue(boss, MAIN_HERO_TABLE, dialogueName, 4.6, 0, 0, true)
	 Timers:CreateTimer(5, function()
	 	boss.jumpEnd = "lava_legion"
	 	WallPhysics:Jump(boss, Vector(0,-1), 7, 7, 22, 1)
	 	StartAnimation(boss, {duration=1.1, activity=ACT_DOTA_TELEPORT_END, rate=1.0})
	 	Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_2", 2.6, 0, 0, true)
	 	EmitSoundOn("Redfall.ShipyardMainBoss.Oof", boss)
	 	Timers:CreateTimer(0.7, function()
	 		ScreenShake(boss:GetAbsOrigin(), 130, 0.3, 0.3, 9000, 0, true)
	 	end)
	 	Timers:CreateTimer(3, function()
	 		Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_3", 4.5, 0, 0, true)
	 		boss:MoveToPosition(Vector(14848, 11052))
	 		Timers:CreateTimer(5, function()
	 			local dialogueNumber = #Redfall.Shipyard.LockedPlayerTable
	 			local dialogueName = "#shipyard_boss_dialogue_4_"..dialogueNumber
	 			Redfall:Dialogue(boss, MAIN_HERO_TABLE, dialogueName, 5.2, 0, 0, true)
	 			boss:MoveToPosition(Vector(14848, 10710))
	 			Timers:CreateTimer(6, function()
	 				Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_5", 4.5, 0, 0, true)
	 				StartAnimation(boss, {duration=4.5, activity=ACT_DOTA_RUN, rate=1.0})
	 				EmitSoundOn("Redfall.ShipyardMainBoss.Laugh1", boss)
	 				Redfall:ScaleModelOverTime(150, 0.01, boss)
	 				for i = 1, 150, 1 do
	 					Timers:CreateTimer(i*0.03, function()
							if i <= 75 then
								boss:SetAbsOrigin(boss:GetAbsOrigin() + Vector(0,0,3))
							else
								boss:SetAbsOrigin(boss:GetAbsOrigin() - Vector(0,0,3))
							end
	 					end)
	 				end
	 				Timers:CreateTimer(5, function()
	 					local bossAbility = boss:FindAbilityByName("shipyard_boss_ai")
	 					bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_shipyard_boss_battle_pose", {})
	 					StartAnimation(boss, {duration=300, activity=ACT_DOTA_VICTORY, rate=1.0})
	 					bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_shipyard_boss_aura", {})
	 					local moveVector = (Vector(14856, 11111, -275+Redfall.ZFLOAT)-boss:GetAbsOrigin())/60
	 					for i = 1, 60, 1 do
	 						Timers:CreateTimer(0.03*i, function()
	 							boss:SetAbsOrigin(boss:GetAbsOrigin() + moveVector)
	 						end)
	 					end
	 					
	 					Redfall.Shipyard.BossBattleStart = true
	 					Beacons:CreateActiveParticle("particles/portals/green_portal.vpcf", Vector(14910, 7894, -650+Redfall.ZFLOAT), Events.GameMaster, 0, Vector(0.45, 0.45, 0.45))
	 					Redfall:ShipyardBossMusic()
	 					Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_6", 5, 0, 0, true)
	 					Timers:CreateTimer(1.5, function()
	 						boss:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)

	 						for k = 1, #Redfall.Shipyard.LockedPlayerTable, 1 do
	 							Redfall.Shipyard.LockedPlayerTable[k]:RemoveModifierByName("modifier_disable_player")
	 						end
	 						for j = 1, #Redfall.Shipyard.CrimsythTable, 1 do
	 							Redfall.Shipyard.CrimsythTable[j].aggroLock = false
	 							Redfall.Shipyard.CrimsythTable[j]:RemoveModifierByName("modifier_disable_player")
	 							Dungeons:AggroUnit(Redfall.Shipyard.CrimsythTable[j])
	 							Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, Redfall.Shipyard.CrimsythTable[j], "modifier_shipyard_boss_unit", {})
	 						end
	 					end)
	 				end)
	 			end)
	 		end)
	 	end)
	 end)
end

function Redfall:ShipyardBossMusic()
	Timers:CreateTimer(0, function()
		if not Redfall.Shipyard.BossBattleEnd then
			EmitSoundOnLocationWithCaster(Vector(14848, 10496), "Music.RedfallShipyard.Boss", Events.GameMaster)
			return 70
		end
	end)
end

function Redfall:ShipyardBossStateChange(stage)
	local boss = Redfall.Shipyard.boss
	if stage == 0 then
		local spawnPositionTable = {Vector(14054, 11473, -500), Vector(15556, 11473, -500), Vector(14016, 9969, -500), Vector(15556, 9969, -500)}
		local fvTable = {Vector(1,-1), Vector(-1,-1), Vector(1,1), Vector(-1,1)}
		Redfall.ShipyardBossSpawnParticleTable = {}
		for i = 1, #spawnPositionTable, 1 do
			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti4/teleport_end_counter_ti4.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
			ParticleManager:SetParticleControl(pfx, 0, spawnPositionTable[i]+Vector(0,0,Redfall.ZFLOAT))
			table.insert(Redfall.ShipyardBossSpawnParticleTable, pfx)
			EmitSoundOnLocationWithCaster(spawnPositionTable[i], "Redfall.SpawnPortalsActivate", Redfall.RedfallMaster)
		end
		Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_7", 12, 0, 0, true)
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		EndAnimation(boss)
		Timers:CreateTimer(0.2, function()
			StartAnimation(boss, {duration=11, activity=ACT_DOTA_RUN, rate=1.0})
		end)
		Timers:CreateTimer(1, function()
			Redfall.Shipyard.CycleUnits = {}
			for j = 1, #spawnPositionTable, 1 do
				local unitTable = {"redfall_pumpkin_flower", "redfall_farmlands_bandit", "redfall_farmlands_thief", "redfall_crymsith_duelist", "redfall_twisted_pumpkin", "redfall_shipyard_blood_wolf", "redfall_farmlands_flame_panda"}
				Redfall:CycleShipyardUnitAndSpawn(spawnPositionTable[j], unitTable, fvTable[j])
			end
		end)
	elseif stage == 1 then
		local spawnPositionTable = {Vector(14054, 11473, -500), Vector(15556, 11473, -500), Vector(14016, 9969, -500), Vector(15556, 9969, -500)}
		local fvTable = {Vector(1,-1), Vector(-1,-1), Vector(1,1), Vector(-1,1)}

		Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_8", 12, 0, 0, true)
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		EndAnimation(boss)
		Timers:CreateTimer(0.2, function()
			StartAnimation(boss, {duration=11, activity=ACT_DOTA_RUN, rate=1.0})
		end)
		for k = 1, #Redfall.Shipyard.CycleUnits, 1 do
			UTIL_Remove(Redfall.Shipyard.CycleUnits[k])
		end
		Redfall.Shipyard.CycleUnits = {}
		Redfall:InitiateAndRunSpikeBalls(1,2)
		Timers:CreateTimer(1, function()
			for j = 1, #spawnPositionTable, 1 do
				local unitTable = {"redfall_pumpkin_flower", "redfall_farmlands_bandit", "redfall_farmlands_thief", "redfall_crymsith_duelist", "redfall_twisted_pumpkin", "redfall_shipyard_blood_wolf", "redfall_farmlands_flame_panda", "redfall_crimsyth_recruiter", "redfall_farmlands_crymsith_taskmaster"}
				Redfall:CycleShipyardUnitAndSpawn(spawnPositionTable[j], unitTable, fvTable[j])
			end
		end)
	elseif stage == 2 then
		local spawnPositionTable = {Vector(14054, 11473, -500), Vector(15556, 11473, -500), Vector(14016, 9969, -500), Vector(15556, 9969, -500)}
		local fvTable = {Vector(1,-1), Vector(-1,-1), Vector(1,1), Vector(-1,1)}

		Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_8", 12, 0, 0, true)
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		EndAnimation(boss)
		Timers:CreateTimer(0.2, function()
			StartAnimation(boss, {duration=11, activity=ACT_DOTA_RUN, rate=1.0})
		end)
		for k = 1, #Redfall.Shipyard.CycleUnits, 1 do
			UTIL_Remove(Redfall.Shipyard.CycleUnits[k])
		end
		Redfall.Shipyard.CycleUnits = {}
		Redfall:InitiateAndRunSpikeBalls(3,4)
		Timers:CreateTimer(1, function()
			for j = 1, #spawnPositionTable, 1 do
				local unitTable = {"redfall_farmlands_bandit", "redfall_farmlands_thief", "redfall_crymsith_duelist", "redfall_twisted_pumpkin", "redfall_shipyard_crimsyth_blood_hunter", "redfall_farmlands_flame_panda", "redfall_crimsyth_recruiter", "redfall_farmlands_crymsith_taskmaster"}
				Redfall:CycleShipyardUnitAndSpawn(spawnPositionTable[j], unitTable, fvTable[j])
			end
		end)
	elseif stage == 3 then
		local spawnPositionTable = {Vector(14054, 11473, -500), Vector(15556, 11473, -500), Vector(14016, 9969, -500), Vector(15556, 9969, -500)}
		local fvTable = {Vector(1,-1), Vector(-1,-1), Vector(1,1), Vector(-1,1)}

		Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_7", 12, 0, 0, true)
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		EndAnimation(boss)
		Timers:CreateTimer(0.2, function()
			StartAnimation(boss, {duration=11, activity=ACT_DOTA_RUN, rate=1.0})
		end)
		for k = 1, #Redfall.Shipyard.CycleUnits, 1 do
			UTIL_Remove(Redfall.Shipyard.CycleUnits[k])
		end
		Redfall.Shipyard.CycleUnits = {}
		Timers:CreateTimer(1, function()
			for j = 1, #spawnPositionTable, 1 do
				local unitTable = { "shipyard_skeleton_archer", "redfall_farmlands_bandit", "shipyard_pirate_archer", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_blood_hunter", "redfall_farmlands_flame_panda", "redfall_crimsyth_recruiter", "redfall_farmlands_crymsith_taskmaster"}
				Redfall:CycleShipyardUnitAndSpawn(spawnPositionTable[j], unitTable, fvTable[j])
			end
		end)
	elseif stage == 4 then
		local spawnPositionTable = {Vector(14054, 11473, -500), Vector(15556, 11473, -500), Vector(14016, 9969, -500), Vector(15556, 9969, -500)}
		local fvTable = {Vector(1,-1), Vector(-1,-1), Vector(1,1), Vector(-1,1)}

		Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_7", 12, 0, 0, true)
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		EndAnimation(boss)
		Timers:CreateTimer(0.2, function()
			StartAnimation(boss, {duration=11, activity=ACT_DOTA_RUN, rate=1.0})
		end)
		for k = 1, #Redfall.Shipyard.CycleUnits, 1 do
			UTIL_Remove(Redfall.Shipyard.CycleUnits[k])
		end
		Redfall.Shipyard.CycleUnits = {}
		Timers:CreateTimer(1, function()
			for j = 1, #spawnPositionTable, 1 do
				local unitTable = {"redfall_shipyard_crimsyth_knight", "shipyard_skeleton_archer", "redfall_farmlands_bandit", "shipyard_pirate_archer", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_blood_hunter", "redfall_farmlands_flame_panda", "redfall_crimsyth_recruiter", "redfall_farmlands_crymsith_taskmaster"}
				Redfall:CycleShipyardUnitAndSpawn(spawnPositionTable[j], unitTable, fvTable[j])
			end
		end)
	elseif stage == 5 then
		local spawnPositionTable = {Vector(14054, 11473, -500), Vector(15556, 11473, -500), Vector(14016, 9969, -500), Vector(15556, 9969, -500)}
		local fvTable = {Vector(1,-1), Vector(-1,-1), Vector(1,1), Vector(-1,1)}

		Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_7", 12, 0, 0, true)
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		EndAnimation(boss)
		Timers:CreateTimer(0.2, function()
			StartAnimation(boss, {duration=11, activity=ACT_DOTA_RUN, rate=1.0})
		end)
		for k = 1, #Redfall.Shipyard.CycleUnits, 1 do
			UTIL_Remove(Redfall.Shipyard.CycleUnits[k])
		end
		Redfall.Shipyard.CycleUnits = {}
		Timers:CreateTimer(1, function()
			for j = 1, #spawnPositionTable, 1 do
				local unitTable = {"redfall_shipyard_crimsyth_knight", "shipyard_skeleton_archer", "shipyard_pirate_archer", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_blood_hunter", "redfall_crimsyth_recruiter"}
				Redfall:CycleShipyardUnitAndSpawn(spawnPositionTable[j], unitTable, fvTable[j])
			end
		end)
		Timers:CreateTimer(10, function()
			Redfall:ShipyardBossReadyForBattle()
		end)
	end
end

function Redfall:CycleShipyardUnitAndSpawn(position, unitTable, fv)
	local loops = 20
	for i = 1, loops, 1 do
		local delay = 0.02*i + 0.03*i^2 + 0.09
		Timers:CreateTimer(delay, function()
			if #Redfall.Shipyard.CycleUnits >= 4 then
				for k = 1, #Redfall.Shipyard.CycleUnits, 1 do
					UTIL_Remove(Redfall.Shipyard.CycleUnits[k])
				end
				Redfall.Shipyard.CycleUnits = {}
			end
			local randomUnit = unitTable[RandomInt(1,#unitTable)]
			local unit = CreateUnitByName(randomUnit, position, true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit.castLock = true
			EmitSoundOnLocationWithCaster(position, "Redfall.ShipyardMainBoss.RotationSound", Redfall.RedfallMaster) 
			unit:SetForwardVector(fv)  
			table.insert(Redfall.Shipyard.CycleUnits, unit)
			CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit, 3)
			Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_disable_player", {})
			if i == loops then
				Redfall:SpawnShipyardDungeonWaveByUnitName(randomUnit, position, fv)
				Timers:CreateTimer(0.5, function()
					unit:AddAbility("ability_ghost_effect"):SetLevel(1)

					for k = 1, 60, 1 do
						Timers:CreateTimer(k*0.03, function()
							unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0,0,2.5))
							unit:SetModelScale(unit:GetModelScale()-0.006)
						end)
					end
				end)
			end
		end)
	end
end

function Redfall:SpawnShipyardDungeonWaveByUnitName(unitName, position, fv)
	local boss = Redfall.Shipyard.boss
	local bossAbility = boss:FindAbilityByName("shipyard_boss_ai")
	bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_shipyard_boss_battle_pose", {})
	StartAnimation(boss, {duration=300, activity=ACT_DOTA_VICTORY, rate=1.0})	
	for i = 1, 4, 1 do
		Timers:CreateTimer(i*2, function()
			local unitTable = {}
			if unitName == "redfall_farmlands_bandit" then
				local unit = Redfall:SpawnFarmlandsBandit(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "redfall_farmlands_thief" then
				for z = 1, 2, 1 do
					local unit = Redfall:SpawnFarmlandThief(position, fv)
					table.insert(unitTable, unit)
				end
			elseif unitName == "redfall_crymsith_duelist" then
				local unit = Redfall:SpawnCrimsythDuelist(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "redfall_twisted_pumpkin" then
				for z = 1, 2, 1 do
					local unit = Redfall:SpawnTwistedPumpkin(position, fv)
					table.insert(unitTable, unit)
				end
			elseif unitName == "redfall_pumpkin_flower" then
				for z = 1, 3, 1 do
					local unit = Redfall:SpawnFarmlandSpawnerUnit(position, fv, 1, false)
					table.insert(unitTable, unit)
				end
			elseif unitName == "redfall_shipyard_blood_wolf" then
				local unit = Redfall:SpawnBloodWolf(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "redfall_farmlands_flame_panda" then
				for z = 1, 2, 1 do
					local unit = Redfall:SpawnFlamePanda(position, fv, false)
					table.insert(unitTable, unit)
				end
			elseif unitName == "redfall_crimsyth_recruiter" then
				local unit = Redfall:SpawnCrimsythRecruiter(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "redfall_farmlands_crymsith_taskmaster" then
				local unit = Redfall:SpawnFarmlandTaskmaster(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "redfall_shipyard_crimsyth_blood_hunter" then
				local unit = Redfall:SpawnBloodHunter(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "shipyard_pirate_archer" then
				local unit = Redfall:SpawnShipyardPirateArcher(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "shipyard_armored_bear_guard" then
				local unit = Redfall:SpawnArmoredBearGuard(position, fv)
				table.insert(unitTable, unit)
			elseif unitName ==  "shipyard_skeleton_archer" then
				local unit = Redfall:SpawnSkeletonArcher(position, fv)
				table.insert(unitTable, unit)
			elseif unitName == "redfall_shipyard_crimsyth_knight" then
				local unit = Redfall:SpawnCrimsythKnight(position, fv, false)
				table.insert(unitTable, unit)
			elseif unitName == "redfall_shipyard_cargo_watcher" then
				local unit = Redfall:SpawnShipyardCargoWatcher(position, fv)
				table.insert(unitTable, unit)
			end
			for k = 1, #unitTable, 1 do
				Dungeons:AggroUnit(unitTable[k])
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unitTable[k], 3)
				unitTable[k].minDungeonDrops = 0
				unitTable[k].maxDungeonDrops = 1
			end
			Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unitTable[1], "modifier_shipyard_boss_unit", {})
		end)
	end

end

function EndShipyardBossBattle()
	Redfall.Shipyard.BossBattleEnd = true
	for i = 1, #Redfall.Shipyard.BossSpikeTable, 1 do
		UTIL_Remove(Redfall.Shipyard.BossSpikeTable[i].dummy)
	end
	for j = 1, #Redfall.ShipyardBossSpawnParticleTable, 1 do
		ParticleManager:DestroyParticle(Redfall.ShipyardBossSpawnParticleTable[j], false)
	end
	if #Redfall.Shipyard.CycleUnits >= 1 then
		for k = 1, #Redfall.Shipyard.CycleUnits, 1 do
			UTIL_Remove(Redfall.Shipyard.CycleUnits[k])
		end
		Redfall.Shipyard.CycleUnits = nil
	end
end

function Redfall:ShipyardBossReadyForBattle()
	local boss = Redfall.Shipyard.boss

	Timers:CreateTimer(1, function()
		boss:RemoveModifierByName("modifier_disable_player")
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		boss:RemoveModifierByName("modifier_command_restric_player")
		local bossAbility = boss:FindAbilityByName("shipyard_boss_ai")
		bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_shipyard_boss_battle_state", {})
		boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
		boss:SetAcquisitionRange(2000)
		EndAnimation(boss)
		for i = 1, 30, 1 do
			Timers:CreateTimer(i*0.03, function()
				boss:SetModelScale(boss:GetModelScale()+0.01)
			end)
		end
	end)

	WallPhysics:Jump(boss, Vector(0,-1), 13, 13, 12, 1)
	Redfall:Dialogue(boss, MAIN_HERO_TABLE, "#shipyard_boss_dialogue_9", 7, 0, 0, true)
	Events:AdjustBossPower(boss, 0, 0, true)
	boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
	boss:RemoveModifierByName("modifier_shipyard_boss_battle_pose")
	boss:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	boss:SetAcquisitionRange(2500)
	EndAnimation(boss)
end

function Redfall:ShipyardBossDeath(caster, ability)
	Statistics.dispatch("redfall_ridge:kill:tyrant_thadelus");
	Redfall.BossBattle = false
	Timers:CreateTimer(0.5, function()
		EmitSoundOn("Redfall.ShipyardMainBoss.DeathNO", caster)
	end)
	Timers:CreateTimer(1.5, function()
		EmitGlobalSound("Loot_Drop_Stinger_Arcana")
		Notifications:TopToAll({text="Dungeon Clear!", duration=8.0})
		local luck = RandomInt(1,4)
		if luck == 1 then
			RPCItems:RollCrimsythEliteGreavesLV1(caster:GetAbsOrigin(), false)
		end
	end)
	for i = 1, 14, 1 do
		Timers:CreateTimer(0.5*i, function()
			RPCItems:RollItemtype(300, caster:GetAbsOrigin(), 1, 0)
		end)
	end
	-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_temple_boss_dying_effect", {})
	local bossOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(8, function()
		caster:RemoveModifierByName("modifier_dying_generic")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_cant_die_disabled", {duration = 20})
		Timers:CreateTimer(0.1, function()
			StartAnimation(caster, {duration=8, activity=ACT_DOTA_DIE, rate=0.25})
			EmitSoundOn("Redfall.ShipyardMainBoss.Death2", caster)
			-- for i = 1, 120, 1 do
			-- 	Timers:CreateTimer(i*0.05, function()
			-- 		if IsValidEntity(caster) then
			-- 			caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,-5))
			-- 		end
			-- 	end)
			-- end
			Timers:CreateTimer(5.7, function()
				for i = 1, #MAIN_HERO_TABLE, 1 do
					Redfall:GiveDemonRelic(MAIN_HERO_TABLE[i], bossOrigin+Vector(0,0,50))
				end
				EndShipyardBossBattle()
				UTIL_Remove(caster)
				Redfall:DefeatDungeonBoss("shipyard", bossOrigin)
			end)
		end)
	end)
end
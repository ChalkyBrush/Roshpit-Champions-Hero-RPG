function Redfall:InitializeAutumnMistCavern()
	Redfall.AutumnMistCavern = {}
	Redfall.AutumnMistCavern.active = true
	CustomGameEventManager:Send_ServerToAllClients("BGMend", {})


	local waveSwitch = Entities:FindByNameNearest("AutumnMistCaveSwitch", Vector(-15119, 10872, -104+Redfall.ZFLOAT), 1200)
	waveSwitch:SetAbsOrigin(waveSwitch:GetAbsOrigin()+Vector(0,0,100))

	local particle = "particles/roshpit/redfall/tree_healed.vpcf"
	local pfxA = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( pfxA, 0, waveSwitch:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pfxA, 1, waveSwitch:GetAbsOrigin() )
	ParticleManager:SetParticleControl( pfxA, 2, Vector(0,1) )
	Timers:CreateTimer(7.5, function()
		ParticleManager:DestroyParticle(pfxA, false)
	end)	

	Timers:CreateTimer(3, function()
		local walls = Entities:FindAllByNameWithin("AutumnMistEntranceWall", Vector(-15369, -7489, 400+Redfall.ZFLOAT), 2000)
		Redfall:Walls(false, walls, true, 4.5)
		Timers:CreateTimer(1, function()
			EmitGlobalSound("Music.Redfall.DungeonOpen")
		end)
		Timers:CreateTimer(5, function()
			local blockers = Entities:FindAllByNameWithin("AutumnMistEntranceBlocker", Vector(-15424, -7470, 282+Redfall.ZFLOAT), 3000)
			for i = 1, #blockers, 1 do
				UTIL_Remove(blockers[i])
			end
		end)
		Timers:CreateTimer(11, function()
			for i = 1, #MAIN_HERO_TABLE, 1 do
				MAIN_HERO_TABLE[i].bgm = "Music.Redfall.AutumnMistCavern"
			end
			Redfall:AutumnMistMusic()
		end)
	end)

	local statue = Entities:FindByNameNearest("AutumnMistEntranceStatue", Vector(-15426, -7808, 369+Redfall.ZFLOAT), 2000)
	for i = 1, 90, 1 do
		Timers:CreateTimer(i*0.03, function()
			local moveMadness = Vector(-12, -12)
			if i%2 == 0 then
				moveMadness = Vector(12,12)
			end
			if i%4 == 0 then
				EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Redfall.StatueMoving", Redfall.RedfallMaster)
			end
			if i == 1 then
				local pfxX = ParticleManager:CreateParticle("particles/dire_fx/dire_lfr_smoke_19sec.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
				ParticleManager:SetParticleControl(pfxX, 0, statue:GetAbsOrigin())
				Timers:CreateTimer(10, function()
					ParticleManager:DestroyParticle(pfxX, false)
				end)		
			end
			statue:SetAngles(0, i, 0)
			statue:SetAbsOrigin(statue:GetAbsOrigin()+moveMadness)
		end)
	end
	Timers:CreateTimer(4.0, function()
		local blockers = Entities:FindAllByNameWithin("AutumnMistEntranceBlocker2", Vector(-15424, -7470, 282+Redfall.ZFLOAT), 3000)
		for i = 1, #blockers, 1 do
			UTIL_Remove(blockers[i])
		end
		local targetPosition = Vector(-15847, -7808)
		local currentPosition = statue:GetAbsOrigin()*Vector(1,1,0)
		local moveVector = (targetPosition - currentPosition)/120
		for j = 1, 120, 1 do
			Timers:CreateTimer(j*0.03, function()
				local moveMadness = Vector(-12, -12)
				if j%2 == 0 then
					moveMadness = Vector(12,12)
				end
				if j%4 == 0 then
					EmitSoundOnLocationWithCaster(statue:GetAbsOrigin(), "Redfall.StatueMoving", Redfall.RedfallMaster)
				end
				if j%30 == 0 then
					local pfxX = ParticleManager:CreateParticle("particles/dire_fx/dire_lfr_smoke_19sec.vpcf", PATTACH_WORLDORIGIN, Redfall.RedfallMaster)
					ParticleManager:SetParticleControl(pfxX, 0, statue:GetAbsOrigin()-Vector(200,0,0))
					Timers:CreateTimer(10, function()
						ParticleManager:DestroyParticle(pfxX, false)
					end)		
				end
				statue:SetAbsOrigin(statue:GetAbsOrigin()+moveMadness+moveVector)
			end)
		end
	end)
	Timers:CreateTimer(8, function()
		Redfall:CavernRoom1()
		Redfall:WaterfallSounds()
	end)
end

function Redfall:Walls(bRaise, walls, bSound, movementZ)
	if not bRaise then
		movementZ = movementZ*-1
	end
	if #walls > 0 then
		Timers:CreateTimer(0.1, function()
			if bSound then
				for i = 1, #walls, 1 do
					EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Redfall.WallOpen", Events.GameMaster)
				end
			end
		end)
		for i = 1, 180, 1 do
			for j = 1, #walls, 1 do
				Timers:CreateTimer(i*0.03, function()
					walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
					if j == 1 then
						ScreenShake(walls[j]:GetAbsOrigin(), 160, 0.1, 0.1, 9000, 0, true)
					end
				end)
			end
		end
	end
end

function Redfall:AutumnMistMusic()
  Timers:CreateTimer(0, function()
    -- EmitSoundOnLocationWithCaster(Vector(-14976, -15296), "Music.Redfall.Village", Events.GameMaster)
    -- EmitSoundOnLocationWithCaster(Vector(-12864, -14848), "Music.Redfall.Village", Events.GameMaster)
      for i = 1, #MAIN_HERO_TABLE, 1 do
        if MAIN_HERO_TABLE[i].bgm == "Music.Redfall.AutumnMistCavern" then
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Redfall.AutumnMistCavern"})
        end
      end

    return 120
  end)
end

function Redfall:SpawnAutumnEnforcer(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 2, 2, false)
		unit.dominion = true
		Redfall:ColorWearables(unit, Vector(255, 0, 0))
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_enforcer",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 32, 
		aggroSound = "Redfall.Enforcer.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAutumnTyrant(position, fv)
	local creepFunction = function(unit) 	
		Events:AdjustBossPower(unit, 4, 4, false)
		Redfall:ColorWearables(unit, Vector(255, 0, 0))
		unit.targetRadius = 1100
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_ANY_ORDER
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_tyrant",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 38, 
		aggroSound = "Redfall.Enforcer.Aggro2",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:CavernRoom1()
	local lookPoint = Vector(-15360, -6464)
	local vectorTable = {Vector(-14592, -6656), Vector(-14784, -6464), Vector(-14784, -6208), Vector(-14464, -6080), Vector(-14528, -6336)}
	for i = 1, #vectorTable, 1 do
		local fv = (lookPoint - vectorTable[i]):Normalized()
		Redfall:SpawnAutumnEnforcer(vectorTable[i], fv)
	end
	Redfall:SpawnAutumnTyrant(Vector(-14117, -6208), Vector(-1,0))

	local position1 = Vector(-13696, -6592)
	local position2 = Vector(-15010, -5735)
	local positionTable = {position1, position2}
	local skeletonsPerPatrol = 2
	if GameState:GetDifficultyFactor() == 3 then
		skeletonsPerPatrol = 3
	end
	for i = 1, #positionTable, 1 do
		for j = 1, skeletonsPerPatrol, 1 do
			local ashKnight = Redfall:SpawnSoulReacher(positionTable[i]+RandomVector(RandomInt(60,200)), RandomVector(1))
			--print(((i)%4)+1)
			Redfall:AddPatrolArguments(ashKnight, 30, 4, 180, {positionTable[((i)%2)+1], positionTable[((i+1)%2)+1]})
		end
	end
	Redfall:SpawnPanKnight(Vector(-13760, -5440), Vector(-1,-1))
end

function Redfall:SpawnPanKnight(position, fv)
	local creepFunction = function(unit) 	
		Events:AdjustBossPower(unit, 4, 4, false)
		unit:SetRenderColor(255, 140, 0)
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
		unit.targetRadius = 1100
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_ANY_ORDER
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_pan_knight",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 35, 
		aggroSound = "Redfall.PanKnight.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:CanyonRoom2Trigger()
	Redfall:SpawnPanKnight(Vector(-14080, -4288), Vector(0,-1))
	Redfall:SpawnPanKnight(Vector(-14272, -4160), Vector(0.3,-1))

	Redfall:SpawnAlphaBeast(Vector(-14336, -4672), Vector(1,0))
	Redfall:SpawnAlphaBeast(Vector(-14912, -4288), Vector(1,-1))
	Redfall:SpawnAlphaBeast(Vector(-15104, -3712), Vector(0,-1))

	Redfall:SpawnAutumnCragnataur(Vector(-15040, -3072), Vector(0,-1))
	Redfall:SpawnAutumnCragnataur(Vector(-14720, -3072), Vector(0,-1))
	Redfall:SpawnAutumnCragnataur(Vector(-14400, -3072), Vector(0,-1))
	Redfall:SpawnAutumnCragnataur(Vector(-14080, -3072), Vector(0,-1))

	Timers:CreateTimer(3, function()
		for i = 0, 11, 1 do
			Redfall:SpawnAutumnEnforcer(Vector(-14848+(i*100), -2688), Vector(0,-1))
		end
	end)
	Timers:CreateTimer(4, function()
		Redfall:SpawnCanyonBreaker(Vector(-13952, -2176), Vector(0,-1))
	end)
	if GameState:GetDifficultyFactor() > 1 then
		local luck = RandomInt(1,4)
		if luck == 1 or Beacons.cheats then
			Redfall:SpawnFeronia(Vector(-12992, 2880), RandomVector(1))
		end
	end
end

function Redfall:SpawnAlphaBeast(position, fv)
	local creepFunction = function(unit) 	
		Events:AdjustBossPower(unit, 3, 3, false)
		unit:SetRenderColor(255, 140, 0)
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
		unit.targetRadius = 1100
		unit.minRadius = 0
		unit.targetAbilityCD = 1
		unit.targetFindOrder = FIND_ANY_ORDER
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_alpha_beast",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 32, 
		aggroSound = "Redfall.AlphaPanda.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:WaterfallSounds()
  Timers:CreateTimer(10, function()
  	local vectorTable = {Vector(-14272, -3840, -400), Vector(-14848, -1664, -400), Vector(-13632, -64, -400), Vector(-12700, 3904, -400)}
  	for i = 1, #vectorTable, 1 do
  		EmitSoundOnLocationWithCaster(vectorTable[i], "Redfall.AutumnMist.Waterfall", Events.GameMaster)
  	end
    local riverTable = {Vector(-11456, 3968), Vector(-15808, -6293), Vector(-15168, 9951)}
    for i = 1, #riverTable, 1 do
      EmitSoundOnLocationWithCaster(riverTable[i], "Redfall.LightWaterfall", Events.GameMaster)
    end    
  	return 30
  end)	
end

function Redfall:SpawnCanyonBreaker(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 4, 4, false)
		unit:SetRenderColor(255, 140, 0)
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
		Redfall:SetPositionCastArgs(unit, 1000, 0, 1, FIND_ANY_ORDER)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_breaker",
		spawnPoint = position,
		minDrops = 2, 
		maxDrops = 3, 
		itemLevel = 35, 
		aggroSound = "Redfall.CanyonBreaker.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:BruiserAmbush()
	for i = 1, 12 + GameState:GetDifficultyFactor()*4, 1 do
		Timers:CreateTimer(i*0.4, function()
			local position = Vector(-13082, -2368+RandomInt(1, 550))
			local bruiser = Redfall:SpawnCanyonBruiser(position, Vector(-1,0), true)
			bruiser.jumpEnd = "basic_dust"
			WallPhysics:Jump(bruiser, Vector(-1,0), 11+RandomInt(1,4), 11+RandomInt(1,4), 30, 1)
			StartAnimation(bruiser, {duration=1.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.8})
		end)
	end
end

function Redfall:SpawnCanyonBruiser(position, fv, bAggro)
	local creepFunction = function(unit) 
		unit:SetRenderColor(255, 140, 0)
		unit.dominion = true
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_bruiser",
		spawnPoint = position,
		minDrops = 0, 
		maxDrops = 2, 
		itemLevel = 31, 
		aggroSound = "Redfall.Bruiser.Aggro",
		fv = fv, 
		isAggro = bAggro, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:CanyonPart2()
	Redfall:SpawnAlphaBeast(Vector(-15104, -832), Vector(0.7,1))
	Redfall:SpawnCanyonPredator(Vector(-14080, -1088), Vector(0,-1))
	Redfall:SpawnCanyonPredator(Vector(-14367, -704), Vector(1,-1))
	Redfall:SpawnCanyonPredator(Vector(-14848, -640), Vector(1,0))
	Redfall:SpawnCanyonBreaker(Vector(-15168, 88), Vector(0,-1))
	Timers:CreateTimer(1.5, function()
		local vectorTable = {Vector(-15097, 704), Vector(-15242, 896), Vector(-14965, 891), Vector(-15371, 1088), Vector(-15097, 1088), Vector(-14825, 1088)}
		for i = 1, #vectorTable, 1 do
			Redfall:SpawnArmoredCrabBeast(vectorTable[i], Vector(0,-1))
		end
	end)
	Timers:CreateTimer(4, function()
		local position1 = Vector(-14019, 2560)
		local position2 = Vector(-15104, 1600)
		local position3 = Vector(-12992, 1408)
		local position4 = Vector(-12486, 2480)
		local positionTable = {position1, position2, position3, position4}
		local skeletonsPerPatrol = 2
		for i = 1, #positionTable, 1 do
			for j = 1, skeletonsPerPatrol, 1 do
				local ashknight = false
				if i%2 == 0 then
					ashKnight = Redfall:SpawnAutumnCragnataur(positionTable[i]+RandomVector(RandomInt(60,200)))
				else
					ashKnight = Redfall:SpawnPanKnight(positionTable[i]+RandomVector(RandomInt(60,200)))
				end
				Redfall:AddPatrolArguments(ashKnight, 30, 5, 240, {positionTable[((i)%4)+1], positionTable[((i+1)%4)+1],positionTable[((i+2)%4)+1], positionTable[((i+3)%4)+1]})
			end
		end
	end)
	Timers:CreateTimer(6, function()
		Redfall:SpawnCanyonBull(Vector(-14208, 1152), Vector(-1,-0.1))
		Redfall:SpawnCanyonBull(Vector(-14592, 2304), Vector(-1,-0.5))
		Redfall:SpawnCanyonBull(Vector(-13056, 2624), Vector(-1,0))
		Redfall:SpawnCanyonBull(Vector(-13056, 1516), Vector(-1,-0.2))
		Redfall:SpawnAutumnTyrant(Vector(-13312, 768), Vector(-0.2,1))
	end)
	Timers:CreateTimer(8, function()
		Redfall:SpawnArmoredCrabBeast(Vector(-12913, 3008), Vector(-0.2,-1))
		Redfall:SpawnArmoredCrabBeast(Vector(-12616, 2272), Vector(1,0.5))
		Redfall:SpawnArmoredCrabBeast(Vector(-12691, 2048), Vector(1,1))
		Redfall:SpawnArmoredCrabBeast(Vector(-12032, 2304), Vector(-1,0))
		Redfall:SpawnArmoredCrabBeast(Vector(-11904, 2174), Vector(-1,0))
		Redfall:SpawnArmoredCrabBeast(Vector(-12135, 1856), Vector(-1,1))
	end)
	Timers:CreateTimer(10, function()
		Redfall:SpawnCanyonDinosaur(Vector(-11712, 3200), Vector(-1,-1))
	end)
end

function Redfall:SpawnCanyonPredator(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 3, 3, false)
		unit:SetRenderColor(255, 140, 0)
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_predator",
		spawnPoint = position,
		minDrops = 0, 
		maxDrops = 2, 
		itemLevel = 32, 
		aggroSound = "Redfall.CanyonPredator.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnArmoredCrabBeast(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 2, 2, false)
		unit:SetRenderColor(255, 140, 0)
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
		unit.targetRadius = 1100
		unit.minRadius = 0
		unit.targetAbilityCD = RandomInt(2,4)
		unit.targetFindOrder = FIND_ANY_ORDER
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_armored_crab_beast",
		spawnPoint = position,
		minDrops = 0, 
		maxDrops = 3, 
		itemLevel = 34, 
		aggroSound = "Redfall.CrabBeast.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnCanyonBull(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 3, 3, false)
		unit:SetRenderColor(255, 140, 0)
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_bull",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 34, 
		aggroSound = "Redfall.BullGhost.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnSpiritOfAshara(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 6, 6, false)
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_spirit_of_ashara",
		spawnPoint = position,
		minDrops = 2, 
		maxDrops = 4, 
		itemLevel = 37, 
		aggroSound = "Redfall.SpiritOfAshara.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = "modifier_redfall_spirit_of_ashara_die", 
		enemyType = ENEMY_TYPE_MINI_BOSS, 
		creepFunction = creepFunction
	}
	return unit
end


function Redfall:SpawnCanyonDinosaur(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 4, 4, false)
		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_canyon_dinosaur_die", {})
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_dinosaur",
		spawnPoint = position,
		minDrops = 3, 
		maxDrops = 5, 
		itemLevel = 39, 
		aggroSound = "Redfall.DinosaurAggro.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_MINI_BOSS, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:CanyonDragonCross()
	Redfall:SpawnCanyonBreaker(Vector(-14464, 5824), Vector(0,-1))
	local vectorTable = {Vector(-15040, 7168), Vector(-14784, 7296), Vector(-14464, 7296), Vector(-14272, 7232), Vector(-14272, 7424), Vector(-14016, 7360)}
	for i = 1, #vectorTable, 1 do
		Redfall:SpawnCanyonGrizzly(vectorTable[i], Vector(0,-1))
	end
	Timers:CreateTimer(3, function()
		Redfall:SpawnCanyonBull(Vector(-15744, 6279), Vector(0,1))
		Redfall:SpawnCanyonPredator(Vector(-15808, 6592), Vector(1,1))
		Redfall:SpawnCanyonPredator(Vector(-15616, 6528), Vector(0.6,1))
		Redfall:SpawnCanyonBull(Vector(-15360, 6912), Vector(1,1))
	end)
	Redfall:SpawnCanyonBreaker(Vector(-13056, 8064), Vector(-1,-1))
	Timers:CreateTimer(6, function()
		for i = 0, 2, 1 do
			for j = 0, 2, 1 do
				Redfall:SpawnArmoredCrabBeast(Vector(-12268+(i*150), 8211+(j*120)), Vector(-1,0))
			end
		end
		Redfall:SpawnCanyonBarbarian(Vector(-11584, 7872), Vector(-0.5,1))
	end)
end

function Redfall:SpawnCanyonGrizzly(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 1, 1, false)
		unit:SetRenderColor(255, 140, 0)
		unit.dominion = true
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_grizzly_patriarch",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 34, 
		aggroSound = "Redfall.GrizzlyPatriarch.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end


function Redfall:SpawnCanyonBarbarian(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 3, 3, false)
		unit:SetRenderColor(255, 140, 0)
		Redfall:ColorWearables(unit, Vector(255, 140, 0))
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_barbarian",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 34, 
		aggroSound = "Redfall.Barbarian.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = "modifier_redfall_canyon_barbarian_die", 
		enemyType = ENEMY_TYPE_MINI_BOSS, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:ActivateSwitchGeneric(buttonPosition, buttonName, bDown, ms)
	local movementZ = ms
	if bDown then
		movementZ = -ms
	end
	local switch = Entities:FindByNameNearest(buttonName, buttonPosition, 600)
	local walls = {switch}
	Timers:CreateTimer(0.1, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchStart", Events.GameMaster)
	end)
	for i = 1, 60, 1 do
		for j = 1, #walls, 1 do
			Timers:CreateTimer(i*0.03, function()
				walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
			end)
		end
	end
	Timers:CreateTimer(1.7, function()
		EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Arena.WaterTemple.SwitchEnd", Events.GameMaster)
	end)
end

function Redfall:SpawnCaveWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)
	local unit = false
	for i = 0, quantity-1, 1 do
		Timers:CreateTimer(i*delay, function()
			if bSound then
				EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
			end
			local creepFunction = function(unit) 
				unit.dominion = true
				unit:SetAcquisitionRange(3000)
				CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit, 2)
				if unit:GetUnitName() == "redfall_troll_warlord" then
					unit:SetRenderColor(255, 140, 30)
				elseif unit:GetUnitName() == "redfall_ashfall_knight" then
					unit:SetRenderColor(255, 0, 0)
					Redfall:ColorWearables(unit, Vector(255, 0, 0))
				elseif unit:GetUnitName() == "redfall_mist_assassin" then
					unit:SetRenderColor(255, 100, 100)
					Redfall:ColorWearables(unit, Vector(255, 100, 100))
				end
			end
			local unit = Spawning:SpawnUnit{
				unitName = unitName,
				spawnPoint = spawnPoint,
				minDrops = 0, 
				maxDrops = 1, 
				itemLevel = itemLevel, 
				aggroSound = nil,
				fv = fv, 
				isAggro = true, 
				deathModifier = "modifier_redfall_cave_unit", 
				enemyType = ENEMY_TYPE_NORMAL_CREEP, 
				creepFunction = creepFunction
			}
		end)
	end
end

function Redfall:SpawnAutumnCaveRoom()
	Redfall:SpawnAutumnTyrant(Vector(-14464, 9344), Vector(1,0))
	Redfall:SpawnAlphaBeast(Vector(-13184, 9698), Vector(-1,-1))
	Redfall:SpawnAlphaBeast(Vector(-13056, 9344), Vector(-1,1))

	Redfall:SpawnAutumnMage(Vector(-13824, 9728), Vector(0,-1))
	Redfall:SpawnAutumnMage(Vector(-14016, 9664), Vector(0,-1))
	Redfall:SpawnAutumnMage(Vector(-13632, 9664), Vector(0,-1))

	Redfall:SpawnAutumnMage(Vector(-14272, 10877), Vector(1,-1))
	Redfall:SpawnAutumnMage(Vector(-13440, 11136), Vector(-1,-1))
end

function Redfall:SpawnAutumnMage(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 5, 5, false)
		unit.dominion = true
		unit:SetRenderColor(255, 180, 80)
		Redfall:ColorWearables(unit, Vector(255, 180, 80))
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_mage",
		spawnPoint = position,
		minDrops = 1, 
		maxDrops = 3, 
		itemLevel = 39, 
		aggroSound = "Redfall.AutumnMage.Aggro",
		fv = fv, 
		isAggro = false, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_NORMAL_CREEP, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnAutumnMageBoss(position, fv)
	local creepFunction = function(unit) 
		Events:AdjustBossPower(unit, 6, 6, false)
		unit:SetRenderColor(255, 180, 80)
		Redfall:ColorWearables(unit, Vector(255, 180, 80))
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_autumn_mage_boss",
		spawnPoint = position,
		minDrops = 4, 
		maxDrops = 6, 
		itemLevel = 39, 
		aggroSound = "Redfall.AutumnMage.Aggro",
		fv = fv, 
		isAggro = true, 
		deathModifier = "modifier_autumn_mage_boss_die", 
		enemyType = ENEMY_TYPE_MINI_BOSS, 
		creepFunction = creepFunction
	}
	return unit
end

function Redfall:SpawnCanyonBoss()
	--print("SPAWN CANYON BOSS")
	Redfall.BossBattle = true
	local boss = CreateUnitByName("redfall_canyon_boss", Vector(-14826, 14310), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_disable_player", {duration = 4.2})
	boss:SetAbsOrigin(Vector(-14826, 14310, 440+Redfall.ZFLOAT))
	Events:AdjustDeathXP(boss)
	Events:AdjustBossPower(boss, 6, 6, false)
	boss:SetModelScale(0.01)
	boss:SetRenderColor(255, 255, 0)
	boss.actualBoss = 3
	boss.threshold = 0.9
	boss.baseSize = 1.6
	boss.currentSize = 1.6
	boss.render = 0
	Redfall:ColorWearables(boss, Vector(255, 135, 0))
	local jumpToPosition = Vector(-14208, 13680, 240+Redfall.ZFLOAT)
	local timeWalk = boss:FindAbilityByName("canyon_boss_time_walk")
	timeWalk:ApplyDataDrivenModifier(boss, boss, "modifier_time_walking", {duration = 4.1})
	Timers:CreateTimer(2, function()
		local moveVector = (jumpToPosition - boss:GetAbsOrigin())/63
		StartAnimation(boss, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.5})
		EmitSoundOn("Redfall.CanyonBoss.LeapIntro", boss)
		for i = 1, 63, 1 do
			Timers:CreateTimer(i*0.03, function()
				boss:SetModelScale(0.01 + 0.024*i)
				boss:SetAbsOrigin(boss:GetAbsOrigin()+moveVector)
			end)
		end
		Timers:CreateTimer(1.95, function()
			FindClearSpaceForUnit(boss, boss:GetAbsOrigin(), false)
			StartAnimation(boss, {duration=0.27, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=1.0})
			Timers:CreateTimer(0.35, function()
				StartAnimation(boss, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
			end)
		end)
		Timers:CreateTimer(2.1, function()
			EmitSoundOn("Redfall.CanyonBoss.Laugh", boss)
		end)
	end)
	if Events.SpiritRealm then
		boss:AddAbility("canyon_boss_lightning"):SetLevel(GameState:GetDifficultyFactor())
	end
	return boss
end

function Redfall:SpawnCanyonBossParagonTest()
	local spawnPoint = Vector(-14826, 14310)
	Redfall.BossBattle = true
	local creepFunction = function(unit) 
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_disable_player", {duration = 4.2})
		unit:SetAbsOrigin(Vector(-14826, 14310, 440+Redfall.ZFLOAT))
		Events:AdjustDeathXP(unit)
		Events:AdjustBossPower(unit, 6, 6, true)
		unit:SetModelScale(0.01)
		unit:SetRenderColor(255, 255, 0)
		unit.generation = 0
		local difficulty = GameState:GetDifficultyFactor()
		if difficulty == DIFFICULTY_NORMAL then
			unit.threshold = 0.33
			unit.currentThreshold = 0.66
		elseif difficulty == DIFFICULTY_ELITE then			
			unit.threshold = 0.25
			unit.currentThreshold = 0.75
		else
			unit.threshold = 0.2
			unit.currentThreshold = 0.8
		end
		unit.baseSize = 2
		unit.currentSize = 2
		unit.render = 0
		unit.children = {}
		Redfall:ColorWearables(unit, Vector(255, 135, 0))
		local jumpToPosition = Vector(-14208, 13680, 240+Redfall.ZFLOAT)
		local timeWalk = unit:FindAbilityByName("canyon_boss_time_walk")
		timeWalk:ApplyDataDrivenModifier(unit, unit, "modifier_time_walking", {duration = 4.1})
		Timers:CreateTimer(2, function()
			local moveVector = (jumpToPosition - unit:GetAbsOrigin())/63
			StartAnimation(unit, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.5})
			EmitSoundOn("Redfall.CanyonBoss.LeapIntro", unit)
			for i = 1, 63, 1 do
				Timers:CreateTimer(i*0.03, function()
					unit:SetModelScale(0.01 + 0.024*i)
					unit:SetAbsOrigin(unit:GetAbsOrigin()+moveVector)
				end)
			end
			Timers:CreateTimer(1.95, function()
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
				StartAnimation(unit, {duration=0.27, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=1.0})
				Timers:CreateTimer(0.35, function()
					StartAnimation(unit, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
				end)
			end)
			Timers:CreateTimer(2.1, function()
				EmitSoundOn("Redfall.CanyonBoss.Laugh", unit)
			end)
		end)
		if Events.SpiritRealm then
			unit:AddAbility("canyon_boss_lightning"):SetLevel(GameState:GetDifficultyFactor())
		end
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_boss",
		spawnPoint = spawnPoint,
		minDrops = 14, 
		maxDrops = 14, 
		itemLevel = 42, 
		aggroSound = nil,
		fv = fv, 
		isAggro = true, 
		deathModifier = nil, 
		enemyType = ENEMY_TYPE_BOSS, 
		creepFunction = creepFunction
	}
end

function Redfall:CanyonBossTakeDamage(victim, damage)
	if not Redfall.BossBattle then
		return damage
	end
	if victim.parentDead == true then
		return damage
	end
	if victim.immortal == true then
		return 0
	end
	--Last generation takes less dmg
	if victim.generation >= 2 + GameState:GetDifficultyFactor() then
		return damage * 0.75
	end
	--colorTime starts if damage exceeds the threshold
	--First threshold is:
	--Boss:				0.9
	--1st Generation:	0.75
	--2nd Generation:	0.66
	--3rd Generation:	0.5
	if (victim:GetHealth() - damage) <= victim:GetMaxHealth() * victim.currentThreshold then
		if victim.currentThreshold > 0 then
			--Cant damage below current Threshold
			damage = math.max(victim:GetHealth() - victim:GetMaxHealth() * victim.currentThreshold, 0)
		end
	end
	local percentOfHealth = damage / victim:GetMaxHealth()
	if victim.currentSize < victim.baseSize * 1.7 then
		victim.currentSize = math.min(victim.currentSize + math.ceil(victim.baseSize * 0.7 * percentOfHealth / victim.threshold * 100) / 100, victim.baseSize * 1.7)
		victim:SetModelScale(victim.currentSize)
	end
	if victim.render < 255 then
		victim.render = math.min(victim.render + math.ceil(255 * percentOfHealth / victim.threshold), 255)
		victim:SetRenderColor(255, 255 - victim.render, 0)
	end
	if victim.render >= 255 then
		victim.immortal = true
		victim.render = 0
		victim:SetRenderColor(255, 255, 0)
		CustomAbilities:QuickAttachParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g.vpcf", victim, 3)

		victim.currentThreshold = math.max(victim.currentThreshold - victim.threshold, 0)
		local victimSizeReduce = (victim.currentSize - victim.baseSize) / 33
		for i = 1, 33, 1 do
			Timers:CreateTimer(i*0.03, function()
				victim.currentSize = victim.currentSize - victimSizeReduce
				victim:SetModelScale(victim.currentSize)
			end)
		end
	    local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	    local radius = 640 - victim.generation * 100
	    local particle2 = ParticleManager:CreateParticle( particleNameS, PATTACH_WORLDORIGIN, caster )
	    ParticleManager:SetParticleControl( particle2, 0, victim:GetAbsOrigin() )
	    ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
	    ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
	    ParticleManager:SetParticleControl( particle2, 4, Vector(100, 150, 255) )
	    Timers:CreateTimer(1.5, 
	    function()
	    ParticleManager:DestroyParticle( particle2, false )
	    end)
	    local ability = victim:FindAbilityByName("canyon_boss_ai")
		local enemies = FindUnitsInRadius( victim:GetTeamNumber(), victim:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
		if #enemies > 0 then	
			for i = 1, #enemies, 1 do
				-- ApplyDamage({ victim = enemies[i], attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })	
				enemies[i]:AddNewModifier(victim, Events:GetGameMasterAbility(), "modifier_stunned", {duration = 1})
					
				ability:ApplyDataDrivenModifier(victim, enemies[i], "modifier_explosion_pushback", {duration = 0.8})
			end
		end
		ability:ApplyDataDrivenModifier(victim, victim, "modifier_boss_post_explode", {duration = 2.5})
		Redfall:SpawnBossMinions(victim, victim.generation)
		Timers:CreateTimer(0.5, function()
			EmitSoundOn("Redfall.CanyonBoss.Stagger", victim)
			victim.immortal = false
		end)
	end
	return damage
end

function Redfall:SpawnBossMinions(boss, previousGeneration)
	local basePosition = boss:GetAbsOrigin()
	local fv = boss:GetForwardVector()
	for i = 1, 3, 1 do
		local unit = CreateUnitByName("redfall_canyon_boss_miniature", basePosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
		if boss.paragon == true then
			if boss:HasModifier("modifier_paragon_solo_visual") then
				local paragonAbility = boss:FindModifierByName("modifier_paragon_solo_visual"):GetAbility()
				paragonAbility:ApplyDataDrivenModifier(unit, unit, "modifier_paragon_solo_visual", {})
			elseif boss:HasModifier("modifier_paragon_pack_visual") then
				local paragonAbility = boss:FindModifierByName("modifier_paragon_pack_visual"):GetAbility()
				paragonAbility:ApplyDataDrivenModifier(unit, unit, "modifier_paragon_pack_visual", {})
			end
		end
		if previousGeneration == 0 then
			unit.boss = boss
		else
			unit.boss = boss.boss
		end
		table.insert(unit.boss.children, unit)
		unit.generation = previousGeneration + 1
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_disable_player", {duration = 1.6})
		unit:SetAbsOrigin(basePosition+Vector(0,0,200))
		Events:AdjustDeathXP(unit)
		Events:AdjustBossPower(unit, 5 - unit.generation, 5 - unit.generation, false)
		unit:SetModelScale(0.01)
		unit:SetRenderColor(255, 255, 0)
		local difficulty = GameState:GetDifficultyFactor()
		if difficulty == DIFFICULTY_NORMAL then
			if unit.generation == 1 then
				unit.threshold = 0.5
				unit.currentThreshold = 0.5
			else
				unit.threshold = 1
				unit.currentThreshold = 0
			end
		elseif difficulty >= DIFFICULTY_ELITE then			
			if unit.generation == 1 then
				unit.threshold = 0.33
				unit.currentThreshold = 0.66
			elseif unit.generation == 2 then
				unit.threshold = 0.5
				unit.currentThreshold = 0.5
			else
				unit.threshold = 1
				unit.currentThreshold = 0
			end
		end

		unit.baseSize = 2 - unit.generation * 0.2
		unit.render = 0
		Redfall:ColorWearables(unit, Vector(255, 100, 0))
		local jumpToPosition = basePosition + WallPhysics:rotateVector(fv, 2*math.pi*i/3)*440
		local timeWalk = unit:FindAbilityByName("canyon_boss_time_walk")
		timeWalk:ApplyDataDrivenModifier(unit, unit, "modifier_time_walking", {duration = 2.1})
		local moveVector = (jumpToPosition - unit:GetAbsOrigin())/43
		StartAnimation(unit, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.5})
		EmitSoundOn("Redfall.CanyonBoss.LeapIntro", unit)
		for i = 1, 43, 1 do
			Timers:CreateTimer(i*0.03, function()
				unit:SetModelScale(0.01 + 0.024*i)
				unit.currentSize = 0.01 + 0.024*i
				unit:SetAbsOrigin(unit:GetAbsOrigin()+moveVector)
			end)
		end
		Timers:CreateTimer(1.45, function()
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
			StartAnimation(unit, {duration=0.27, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=1.0})
		end)
	end
end

function Redfall:SpawnFeronia(position, fv)
	local creepFunction = function(unit) 	
		Events:AdjustBossPower(unit, 8, 8, false)
		unit:SetRenderColor(255, 180, 80)
		Redfall:ColorWearables(unit, Vector(255, 180, 80))
		Redfall:AddPatrolArguments(unit, 30, 6, 220, {Vector(-15040, -3136), position})
	end
	local unit = Spawning:SpawnUnit{
		unitName = "redfall_canyon_feronia",
		spawnPoint = position,
		minDrops = 2, 
		maxDrops = 4, 
		itemLevel = 39, 
		aggroSound = "Redfall.Feronia.Aggro",
		fv = fv, 
		isAggro = true, 
		deathModifier = "modifier_redfall_canyon_feronia_die", 
		enemyType = ENEMY_TYPE_MINI_BOSS, 
		creepFunction = creepFunction
	}
	return unit
end
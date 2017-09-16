function Redfall:InitializeAutumnMistCavern()
	Redfall.AutumnMistCavern = {}
	Redfall.AutumnMistCavern.active = true
	CustomGameEventManager:Send_ServerToAllClients("BGMend", {})

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
	local ancient = Redfall:SpawnDungeonUnit( "redfall_autumn_enforcer", position, 1, 3, "Redfall.Enforcer.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 32
	ancient.dominion = true
	-- ancient:SetRenderColor(60, 0, 0)
	Redfall:ColorWearables(ancient, Vector(255, 0, 0))

	return ancient
end

function Redfall:SpawnAutumnTyrant(position, fv)
	local ancient = Redfall:SpawnDungeonUnit( "redfall_autumn_tyrant", position, 1, 3, "Redfall.Enforcer.Aggro2", fv, false)
	Events:AdjustBossPower(ancient, 4, 4, false)
	ancient.itemLevel = 38

	-- ancient:SetRenderColor(60, 0, 0)
	Redfall:ColorWearables(ancient, Vector(255, 0, 0))
	ancient.targetRadius = 1100
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_ANY_ORDER

	ancient.dominion = true
	return ancient
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
			print(((i)%4)+1)
			Redfall:AddPatrolArguments(ashKnight, 30, 4, 180, {positionTable[((i)%2)+1], positionTable[((i+1)%2)+1]})
		end
	end
	Redfall:SpawnPanKnight(Vector(-13760, -5440), Vector(-1,-1))
end

function Redfall:SpawnPanKnight(position, fv)
	local ancient = Redfall:SpawnDungeonUnit( "redfall_pan_knight", position, 1, 3, "Redfall.PanKnight.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 4, 4, false)
	ancient.itemLevel = 35

	ancient:SetRenderColor(255, 140, 0)
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))
	ancient.targetRadius = 1100
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_ANY_ORDER

	ancient.dominion = true
	return ancient
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
		if luck == 1 then
			Redfall:SpawnFeronia(Vector(-12992, 2880), RandomVector(1))
		end
	end
end

function Redfall:SpawnAlphaBeast(position, fv)
	local ancient = Redfall:SpawnDungeonUnit( "redfall_canyon_alpha_beast", position, 1, 3, "Redfall.AlphaPanda.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 32

	ancient:SetRenderColor(255, 140, 0)
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))
	ancient.targetRadius = 1100
	ancient.minRadius = 0
	ancient.targetAbilityCD = 1
	ancient.targetFindOrder = FIND_ANY_ORDER

	ancient.dominion = true
	return ancient
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
	local ancient = Redfall:SpawnDungeonUnit("redfall_canyon_breaker", position, 2, 3, "Redfall.CanyonBreaker.Aggro", fv)
	Events:AdjustBossPower(ancient, 4, 4, false)
	ancient.itemLevel = 35

	ancient:SetRenderColor(255, 140, 0)
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))
	Redfall:SetPositionCastArgs(ancient, 1000, 0, 1, FIND_ANY_ORDER)

	ancient.dominion = true
	return ancient
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
	local ancient = Redfall:SpawnDungeonUnit("redfall_canyon_bruiser", position, 0, 2, "Redfall.Bruiser.Aggro", fv, bAggro)

	ancient.itemLevel = 31

	ancient:SetRenderColor(255, 140, 0)
	ancient.dominion = true
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))

	return ancient
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
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_canyon_predator", position, 1, 3, "Redfall.CanyonPredator.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 32

	ancient:SetRenderColor(255, 140, 0)
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))
	ancient.dominion = true
	return ancient
end

function Redfall:SpawnArmoredCrabBeast(position, fv)
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_armored_crab_beast", position, 0, 3, "Redfall.CrabBeast.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 34

	ancient:SetRenderColor(255, 140, 0)
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))
	ancient.targetRadius = 1100
	ancient.minRadius = 0
	ancient.targetAbilityCD = RandomInt(2,4)
	ancient.targetFindOrder = FIND_ANY_ORDER

	ancient.dominion = true
	return ancient
end

function Redfall:SpawnCanyonBull(position, fv)
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_canyon_bull", position, 1, 3, "Redfall.BullGhost.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 34

	ancient:SetRenderColor(255, 140, 0)
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))
	ancient.dominion = true
	return ancient
end

function Redfall:SpawnSpiritOfAshara(position, fv)
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_spirit_of_ashara", position, 2, 4, "Redfall.SpiritOfAshara.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 6, 6, false)
	ancient.itemLevel = 37

	-- ancient:SetRenderColor(255, 140, 0)
	-- Redfall:ColorWearables(ancient, Vector(255, 140, 0))

	return ancient
end


function Redfall:SpawnCanyonDinosaur(position, fv)
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_canyon_dinosaur", position, 3, 5, "Redfall.DinosaurAggro", fv, false)
	Events:AdjustBossPower(ancient, 4, 4, false)
	ancient.itemLevel = 39

	-- ancient:SetRenderColor(255, 140, 0)
	-- Redfall:ColorWearables(ancient, Vector(255, 140, 0))

	return ancient
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
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_canyon_grizzly_patriarch", position, 1, 3, "Redfall.GrizzlyPatriarch.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 1, 1, false)
	ancient.itemLevel = 34

	ancient:SetRenderColor(255, 140, 0)
	ancient.dominion = true

	return ancient
end


function Redfall:SpawnCanyonBarbarian(position, fv)
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_canyon_barbarian", position, 1, 3, "Redfall.Barbarian.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 34

	ancient:SetRenderColor(255, 140, 0)
	Redfall:ColorWearables(ancient, Vector(255, 140, 0))

	return ancient
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
    Timers:CreateTimer(i*delay, 
    function()
		if bSound then
			EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
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
      if IsValidEntity(unit) then
      	unit.itemLevel = itemLevel
      	unit.dominion = true
      	Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_cave_unit", {})
      	unit:SetAcquisitionRange(3000)
      	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit, 2)
      	unit.aggro = true
      	if unit:GetUnitName() == "redfall_troll_warlord" then
      		unit:SetRenderColor(255, 140, 30)
      		-- Redfall:ColorWearables(unit, Vector(255, 100, 0))
      	elseif unit:GetUnitName() == "redfall_ashfall_knight" then
			unit:SetRenderColor(255, 0, 0)
			Redfall:ColorWearables(unit, Vector(255, 0, 0))
		elseif unit:GetUnitName() == "redfall_mist_assassin" then
			unit:SetRenderColor(255, 100, 100)
			Redfall:ColorWearables(unit, Vector(255, 100, 100))
      	end
      else
      	for i = 1, #unit, 1 do
      		unit[i].aggro = true
      		unit[i].dominion = true
      		unit[i].itemLevel = itemLevel
      		Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit[i], "modifier_redfall_cave_unit", {})
      		unit[i]:SetAcquisitionRange(3000)
      		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit[i], 2)
      	end
      end
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
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_autumn_mage", position, 1, 3, "Redfall.AutumnMage.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 5, 5, false)
	ancient.itemLevel = 39
	ancient.dominion = true
	ancient:SetRenderColor(255, 180, 80)
	Redfall:ColorWearables(ancient, Vector(255, 180, 80))

	return ancient
end

function Redfall:SpawnAutumnMageBoss(position, fv)
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_autumn_mage_boss", position, 4, 6, "Redfall.AutumnMage.Aggro", fv, true)
	Events:AdjustBossPower(ancient, 6, 6, false)
	ancient.itemLevel = 39
	
	ancient:SetRenderColor(255, 180, 80)
	Redfall:ColorWearables(ancient, Vector(255, 180, 80))

	return ancient
end

function Redfall:SpawnCanyonBoss()
	print("SPAWN CANYON BOSS")
	Redfall.BossBattle = true
	local boss = CreateUnitByName("redfall_canyon_boss", Vector(-14826, 14310), true, nil, nil, DOTA_TEAM_NEUTRALS)
	Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_disable_player", {duration = 4.2})
	boss:SetAbsOrigin(Vector(-14826, 14310, 440+Redfall.ZFLOAT))
	Events:AdjustDeathXP(boss)
	Events:AdjustBossPower(boss, 6, 6, true)
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
end

function Redfall:CanyonBossTakeDamage(victim, damage)
	if not Redfall.BossBattle then
		return damage
	end
	if victim.actualBoss == 0 then
		return damage*0.75
	end
	local percentOfHealth = damage/victim:GetMaxHealth()
	if (victim:GetHealth() - damage) <= victim:GetMaxHealth()*victim.threshold then
		if victim.threshold > 0 then
			damage = math.max(victim:GetHealth() - victim:GetMaxHealth()*victim.threshold, 0)
			victim.colorTime = true
		else
			victim.colorTime = true
		end
	end
	if victim.currentSize < victim.baseSize*1.7 then
		victim.currentSize = victim.currentSize+percentOfHealth*5
		print(victim.currentSize)
		victim:SetModelScale(math.min(victim.currentSize,victim.baseSize*1.7))
	else
		if victim.colorTime then
			local redening = math.min(12-GameState:GetDifficultyFactor()*2 + (10-victim.actualBoss*2), percentOfHealth*500)
			victim.render = math.min(victim.render+redening, 255)
			print(victim.render)
			victim:SetRenderColor(255, 255-victim.render, 0)
		end
	end
	if victim.render >= 255 then
		victim.render = 100
		victim:SetRenderColor(255, 100, 0)
		CustomAbilities:QuickAttachParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g.vpcf", victim, 3)
		local threshReduce = 0.2 + (0.15-GameState:GetDifficultyFactor()*0.05)
		if victim.actualBoss == 2 then
			threshReduce = 0.5
		elseif victim.actualBoss == 1 then
			threshReduce = 0.7
		end
		victim.threshold = math.max(victim.threshold - threshReduce, 0)
		local victimSizeReduce = (victim.currentSize - victim.baseSize)/33
		for i = 1, 33, 1 do
			Timers:CreateTimer(i*0.03, function()
				victim.currentSize = victim.currentSize - victimSizeReduce
				victim:SetModelScale(victim.currentSize)
			end)
		end
	      local particleNameS = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local radius = 340 + victim.actualBoss*100
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
			Redfall:SpawnBossMinions(victim, victim.actualBoss)
			victim.colorTime = false
			Timers:CreateTimer(0.5, function()
				EmitSoundOn("Redfall.CanyonBoss.Stagger", victim)
			end)
	end
	return damage
end

function Redfall:SpawnBossMinions(boss, bossLevel)
	local basePosition = boss:GetAbsOrigin()
	local fv = boss:GetForwardVector()
	for i = 1, 3, 1 do
		local boss = CreateUnitByName("redfall_canyon_boss_miniature", basePosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
		Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, boss, "modifier_disable_player", {duration = 1.6})
		boss:SetAbsOrigin(basePosition+Vector(0,0,200))
		Events:AdjustDeathXP(boss)
		Events:AdjustBossPower(boss, 2+bossLevel, 2+bossLevel, false)
		boss:SetModelScale(0.01)
		boss:SetRenderColor(255, 255, 0)
		boss.actualBoss = bossLevel - 1
		local threshReduce = 0.1
		if boss.actualBoss == 2 then
			threshReduce = 0.25
		elseif boss.actualBoss == 1 then
			threshReduce = 0.4
		end
		boss.threshold = 1 - threshReduce
		boss.baseSize = 0.4 + bossLevel *0.4
		boss.render = 0
		Redfall:ColorWearables(boss, Vector(255, 100, 0))
		local jumpToPosition = basePosition + WallPhysics:rotateVector(fv, 2*math.pi*i/3)*440
		local timeWalk = boss:FindAbilityByName("canyon_boss_time_walk")
		timeWalk:ApplyDataDrivenModifier(boss, boss, "modifier_time_walking", {duration = 2.1})
		local moveVector = (jumpToPosition - boss:GetAbsOrigin())/43
		StartAnimation(boss, {duration=1.9, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.5})
		EmitSoundOn("Redfall.CanyonBoss.LeapIntro", boss)
		for i = 1, 43, 1 do
			Timers:CreateTimer(i*0.03, function()
				boss:SetModelScale(0.01 + 0.024*i)
				boss.currentSize = 0.01 + 0.024*i
				boss:SetAbsOrigin(boss:GetAbsOrigin()+moveVector)
			end)
		end
		Timers:CreateTimer(1.45, function()
			FindClearSpaceForUnit(boss, boss:GetAbsOrigin(), false)
			StartAnimation(boss, {duration=0.27, activity=ACT_DOTA_CAST_ABILITY_1_END, rate=1.0})
		end)
	end
end

function Redfall:SpawnFeronia(position, fv)
	local ancient = Redfall:SpawnDungeonUnit(  "redfall_canyon_feronia", position, 2, 4, "Redfall.Feronia.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 8, 8, false)
	ancient.itemLevel = 39

	ancient:SetRenderColor(255, 180, 80)
	Redfall:ColorWearables(ancient, Vector(255, 180, 80))
	Redfall:AddPatrolArguments(ancient, 30, 6, 220, {Vector(-15040, -3136), position})
	return ancient
end
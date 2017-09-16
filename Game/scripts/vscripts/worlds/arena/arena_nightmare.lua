function Arena:InitArenaNightmare(caster, hero, scoreR)
	GameRules:SetTimeOfDay(0.75)
	Timers:CreateTimer(1, function()
		CustomGameEventManager:Send_ServerToAllClients("arena_fade_to_black", {fadeBackDelay=4})
	end)	
	Arena.NightmareCaster = caster
	Arena.NightmarePre = false
	Arena.NightmareEntityTable = {}
	Arena.NightmareParticleTable = {}
	caster.summonTable = {}
	Arena.NightmareScene = false
	Arena.NightmareBossStart = false
	Arena:NightmareMusicInit()
	Timers:CreateTimer(2, function()
		Arena:CreateNightmareAmbience()
		FindClearSpaceForUnit(caster, Vector(-2176, 1216), false)
		caster:SetForwardVector(Vector(0,-1))
		FindClearSpaceForUnit(Arena.Coach, Vector(-2752, -8640), false)
		Arena:RaiseWalls(false, {Arena.Door1, Arena.Door2}, true)
		Arena:RemoveArenaBlockers(true, true, false, false)
	end)
	Timers:CreateTimer(7, function()
		local arenaCenter = Vector(-2670, -2445)
		local fv = Vector(1,0)
		for i = -6, 6, 1 do
			local rotatedVector = WallPhysics:rotateVector(fv, (math.pi/6)*i)
			local specter = Arena:SpawnNightmareSpecter(arenaCenter+rotatedVector*2000, rotatedVector*-1)
			table.insert(caster.summonTable, specter)
			EmitGlobalSound("Arena.Nightmare.SpecterSpawn")
		end
	end)
	Timers:CreateTimer(5, function()
		if Arena.scoreR > scoreR then
			return
		end
		local unit = Arena:SpawnNightmareGuard(Vector(-5568, -2112), Vector(1,0))
		table.insert(caster.summonTable, unit)
		unit = Arena:SpawnNightmareGuard(Vector(-5568, -2496), Vector(1,0))
		table.insert(caster.summonTable, unit)
		unit = Arena:SpawnNightmareCerberus(Vector(-7872, -2368), Vector(1,-1))
		table.insert(caster.summonTable, unit)

		local wallPoint1 = Vector(-7936, -932, 160)
		local wallPoint2 = Vector(-7360, -932, 160)

		local particle = "particles/units/heroes/hero_dark_seer/avernus_wall_of_replica.vpcf"
		local pfx = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, Events.GameMaster )
		ParticleManager:SetParticleControl( pfx, 0, wallPoint1 )
		ParticleManager:SetParticleControl( pfx, 1, wallPoint2 )
		table.insert(Arena.NightmareParticleTable, pfx)
		local blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-7808, -932), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-7680,-932), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-7552,-932), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-7424,-932), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
	end)
	Timers:CreateTimer(6, function()
		if Arena.scoreR > scoreR then
			return
		end
		local basePos = Vector(-8000, -4544)
		for i = 0, 5, 1 do
			for j = 0, 1, 1 do
				local zombie = Arena:SpawnNightmareZombie(basePos+Vector(160*i, 120*j), Vector(0,1))
				table.insert(caster.summonTable, zombie)
			end
		end
		local wallPoint1 = Vector(-434, -6917, 160)
		local wallPoint2 = Vector(-368, -7917, 160)

		local particle = "particles/units/heroes/hero_dark_seer/avernus_wall_of_replica.vpcf"
		local pfx = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, Events.GameMaster )
		ParticleManager:SetParticleControl( pfx, 0, wallPoint1 )
		ParticleManager:SetParticleControl( pfx, 1, wallPoint2 )
		table.insert(Arena.NightmareParticleTable, pfx)
		local blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-434, -7040), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-434,-7167), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-434,-7296), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-434,-7424), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-434,-7552), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-434,-7680), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
		blocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(-434,-7808), Name ="wallObstruction"})
		table.insert(Arena.NightmareEntityTable, blocker)
	end)
	Timers:CreateTimer(9, function()
		if Arena.scoreR > scoreR then
			return
		end
		local unit = Arena:SpawnGhastlyAirwarden(Vector(-6400, -5568), Vector(1,0))
		Arena:AddPatrolArguments(unit, 0, 3, 80, {Vector(-7102, -4858), Vector(-6400, -5568)})
		table.insert(caster.summonTable, unit)
		unit = Arena:SpawnGhastlyAirwarden(Vector(-6528, -5760), Vector(1,0))
		Arena:AddPatrolArguments(unit, 0, 3, 80, {Vector(-7264, -4981), Vector(-6528, -5760)})
		table.insert(caster.summonTable, unit)
		unit = Arena:SpawnGhastlyAirwarden(Vector(-6656, -5888), Vector(1,0))
		Arena:AddPatrolArguments(unit, 0, 3, 80, {Vector(-7417, -5103), Vector(-6656, -5888)})
		table.insert(caster.summonTable, unit)
		unit = Arena:SpawnGhastlyAirwarden(Vector(-6443, -6076), Vector(1,0))
		Arena:AddPatrolArguments(unit, 0, 3, 80, {Vector(-5163, -7219), Vector(-6443, -6076)})
		table.insert(caster.summonTable, unit)
		unit = Arena:SpawnGhastlyAirwarden(Vector(-6313, -5948), Vector(1,0))
		Arena:AddPatrolArguments(unit, 0, 3, 80, {Vector(-5035, -7091), Vector(-6313, -5948)})
		table.insert(caster.summonTable, unit)
		unit = Arena:SpawnGhastlyAirwarden(Vector(-6187, -5784), Vector(1,0))
		Arena:AddPatrolArguments(unit, 0, 3, 80, {Vector(-5163, -7219), Vector(-6187, -5784)})
		table.insert(caster.summonTable, unit)
	end)
	Timers:CreateTimer(10, function()
		if Arena.scoreR > scoreR then
			return
		end
		local fiend = Arena:SpawnArenaNightmareFiend(Vector(-6720, -6080), Vector(0,1))
		table.insert(caster.summonTable, fiend)
	end)
	Timers:CreateTimer(12, function()
		if Arena.scoreR > scoreR then
			return
		end
		local unit = Arena:SpawnNightmareGuard(Vector(-4800, -7168), Vector(-1,0.5))
		table.insert(caster.summonTable, unit)
		local unit = Arena:SpawnNightmareCerberus(Vector(-4992, -7552), Vector(-0.2,1))
		table.insert(caster.summonTable, unit)
	end)
	Timers:CreateTimer(15, function()
		if Arena.scoreR > scoreR then
			return
		end
		local unit = Arena:SpawnNightmareKnight(Vector(-3648, -6912), Vector(0,-1))
		table.insert(caster.summonTable, unit)
		local unit = Arena:SpawnNightmareKnight(Vector(-2730, -6912), Vector(0,-1))
		table.insert(caster.summonTable, unit)
		local unit = Arena:SpawnNightmareKnight(Vector(-1829, -6912), Vector(0,-1))
		table.insert(caster.summonTable, unit)
	end)
	Timers:CreateTimer(20, function()
		print('--------')
		print("SCORER")
		print(scoreR)
		print(Arena.scoreR)
		if Arena.scoreR > scoreR then
			return
		end
		local boss = Arena:SpawnArcherBoss(Vector(-2379, -8640), Vector(-1,0))
		local bossAbility = boss:FindAbilityByName("arena_nightmare_boss_ability")
		bossAbility:ApplyDataDrivenModifier(boss, boss, "modifier_nightmare_boss_waiting", {})
		bossAbility:ApplyDataDrivenModifier(boss, Arena.Coach, "modifier_nightmare_fiends_effect", {})
		table.insert(caster.summonTable, boss)
		Arena.NightmareBoss = boss
	end)
end

function Arena:CleanUpNightmareScene()
	Arena.NightmarePre = true
	Arena.Coach:RemoveModifierByName("modifier_nightmare_fiends_effect")
	for i = 1, #Arena.NightmareEntityTable, 1 do
		Timers:CreateTimer(i*0.05, function()
			if IsValidEntity(Arena.NightmareEntityTable[i]) then
				UTIL_Remove(Arena.NightmareEntityTable[i])
			end
		end)
	end
	for j = 1, #Arena.NightmareParticleTable, 1 do
		Timers:CreateTimer(j*0.05, function()
			ParticleManager:DestroyParticle(Arena.NightmareParticleTable[j], false)
		end)
	end
	Arena.Nightmare = false
	FindClearSpaceForUnit(Arena.Coach, Vector(-7744, -2624), false)
	Arena:CreateArenaWalls(true, true, false, false)
	Arena:RaiseWalls(true, {Arena.Door1, Arena.Door2}, false)

	Arena.Coach:RemoveNoDraw()

	Arena.Coach:RemoveModifierByName("modifier_nightmare_fiends_effect")
end

function Arena:CreateNightmareAmbience()
  local basePos = Vector(-10215, -12186)
  local spirit1 = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(-3392, -3264, 320)})
  spirit1:SetModel("models/effects/fountain_radiant_00.vmdl")
  spirit1:SetRenderColor(100, 20, 100)
  table.insert(Arena.NightmareEntityTable, spirit1)
  local spirit2 = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(-1792, 1984, 310)})
  spirit2:SetModel("models/effects/fountain_radiant_00.vmdl")
  spirit2:SetRenderColor(100, 20, 100)
  table.insert(Arena.NightmareEntityTable, spirit2)
  for i = 1, 9, 1 do
    for j = 1, 9, 1 do 
      Timers:CreateTimer(i*0.15, function()

        local position = basePos+Vector(i*1000+RandomInt(-400, 400), j*1600+RandomInt(-600, 600))
        local height = GetGroundHeight(position, Events.GameMaster)
        local spirit = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(position.x,position.y, height+140)})
        spirit:SetModel("models/effects/fountain_radiant_00.vmdl")
        spirit:SetRenderColor(100, 20, 100)
        spirit:SetAngles(RandomInt(1,360), RandomInt(1,360), RandomInt(1,360))
        table.insert(Arena.NightmareEntityTable, spirit)
        local pfx = ParticleManager:CreateParticle("particles/roshpit/weather/nightmare_rain_econ_weather_pestilence.vpcf", PATTACH_WORLDORIGIN, Arena.ArenaMaster)
        ParticleManager:SetParticleControl(pfx, 0, basePos+Vector(i*1000, j*1000)+Vector(0,2000,100))
        table.insert(Arena.NightmareParticleTable, pfx)
      end)
    end
  end
end

function Arena:NightmareMusicInit()
	Timers:CreateTimer(1, function()
		CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Arena.NightmareMusic"})
		if Arena.Nightmare then
			return 21
		end
	end)
end

function Arena:SpawnDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)
    local luck = 0
    luck = RandomInt(1, 120)
    local unit = ""
    if luck == 1 then
     unit = Paragon:SpawnParagonUnit(unitName, spawnPoint)
    else
     unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
     Events:AdjustDeathXP(unit)
    end
    local ability = unit:FindAbilityByName("dungeon_creep")
    if ability then
      ability:SetLevel(1)
      ability:ApplyDataDrivenModifier(unit, unit, "modifier_dungeon_thinker_creep", {})
    end
    if aggroSound then
      unit.aggroSound = aggroSound
    end
    unit.minDungeonDrops = minDrops
    unit.maxDungeonDrops = maxDrops
    if fv then
      unit:SetForwardVector(fv)
    end
    if isAggro then
      Dungeons:AggroUnit(unit)
    end
    return unit
end

function Arena:SpawnNightmareSpecter(position, fv)
	local ancient = Arena:SpawnDungeonUnit("arena_nightmare_spectre", position, 0, 2, nil, fv, true)
	Events:AdjustBossPower(ancient, 2, 2, false)
	ancient.itemLevel = 85
	ancient:SetRenderColor(80, 80, 80)
	return ancient

end

function Arena:SpawnNightmareGuard(position, fv)
	local ancient = Arena:SpawnDungeonUnit("arena_nightmare_guard", position, 3, 4, "Arena.NightmareGuard.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 7, 7, false)
	ancient.itemLevel = 95
	ancient:SetRenderColor(80, 80, 80)
	ancient.dominion = true
	return ancient

end


function Arena:SpawnNightmareCerberus(position, fv)
	local ancient = Arena:SpawnDungeonUnit("arena_nightmare_cerberus", position, 4, 5, "Arena.NightmareCerberus.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 9, 9, false)
	ancient.itemLevel = 100
	ancient:SetRenderColor(80, 80, 80)
	ancient.dominion = true
	return ancient

end

function Arena:SpawnNightmareZombie(position, fv)
	local ancient = Arena:SpawnDungeonUnit("arena_nightmare_zombie", position, 0, 2, "Arena.NightmareZombie.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 100
	ancient:SetRenderColor(80, 80, 80)
	ancient.dominion = true
	return ancient

end

function Arena:SpawnGhastlyAirwarden(position, fv)
	local ancient = Arena:SpawnDungeonUnit("arena_nightmare_ghastly_airwarden", position, 1, 4, "Arena.NightmareWarden.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 100
	ancient:SetRenderColor(80, 80, 80)
	ancient.targetRadius = 600
	ancient.minRadius = 0
	ancient.targetAbilityCD = 4
	ancient.targetFindOrder = FIND_ANY_ORDER
	ancient.dominion = true
	return ancient

end

function Arena:SpawnArenaNightmareFiend(position, fv)
	local ancient = Arena:SpawnDungeonUnit("arena_nightmare_fiend", position, 3, 4, "Arena.NightmareFiend.Aggro", fv, false)
	Events:AdjustBossPower(ancient, 3, 3, false)
	ancient.itemLevel = 100
	ancient.targetRadius = 800
	ancient.minRadius = 0
	ancient.targetAbilityCD = 4
	ancient.targetFindOrder = FIND_ANY_ORDER
	return ancient
end

function Arena:SpawnNightmareKnight(position, fv)
		local animated = Arena:SpawnDungeonUnit("animated_arms", position, 1, 2, "Conquest.hallow_laughter", fv, false)
		animated:SetModelScale(1)
			local properties =  {
				roll = 230,
			    pitch = 90,
			    yaw = 60,
			    XPos = -60,
			    YPos = -15,
			    ZPos = 0,
			  }
			Attachments:AttachProp(animated, "attach_attack1", "models/items/abaddon/darkstar_the_mistforged/darkstar_the_mistforged.vmdl", 1, properties)
			  properties =  {
				roll = 0,
			    pitch = 0,
			    yaw = 0,
			    XPos = 0,
			    YPos = -90,
			    ZPos = -90,
			  }
			Attachments:AttachProp(animated, "attach_attack2", "models/items/dragon_knight/wurmblood_shield/wurmblood_shield.vmdl", 1, properties)	
			return animated
end

function Arena:SpawnArcherBoss(position, fv)
	local ancient = Arena:SpawnDungeonUnit("arena_nightmare_boss", position, 3, 5, nil, fv, true)
	Events:AdjustBossPower(ancient, 1, 12, false)
	ancient.itemLevel = 100
	ancient:SetRenderColor(80, 80, 80)
	return ancient

end

function Arena:NightmareBossScene()
	Dungeons:LockCameraToUnitForAllPlayers(Arena.Coach, 5.7)
	Timers:CreateTimer(2.0, function()
		local powershotAbility = Arena.NightmareBoss:FindAbilityByName("arena_nightmare_powershot")
		local newOrder = {
				UnitIndex = Arena.NightmareBoss:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = powershotAbility:entindex(),
				Position = Arena.Coach:GetAbsOrigin()
		 	}

		ExecuteOrderFromTable(newOrder)	

	end)
	Timers:CreateTimer(3.05, function()
		Arena.Coach:RemoveModifierByName("modifier_nightmare_fiends_effect")
		local particleName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Arena.Coach )
		ParticleManager:SetParticleControlEnt(pfx, 0, Arena.Coach, PATTACH_CUSTOMORIGIN, "follow_origin", Arena.Coach:GetAbsOrigin()+Vector(0,0,100), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, Arena.Coach, PATTACH_CUSTOMORIGIN, "follow_origin", Arena.Coach:GetAbsOrigin()+Vector(0,0,100), true)

		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace", Arena.Coach)
		Timers:CreateTimer(0.1, function()
			EmitSoundOn("Arena.Coach.NightmareDeath", Arena.Coach)
			StartAnimation(Arena.Coach, {duration=3, activity=ACT_DOTA_DIE, rate=0.7})
			Timers:CreateTimer(2.8, function()
				ParticleManager:DestroyParticle(pfx, false)
				-- Arena.Coach:AddNoDraw()
				Arena.NightmareBossStart = true
				Arena.Coach:SetAbsOrigin(Vector(-5376, -8896))
				Arena.ArenaMasterAbility:ApplyDataDrivenModifier(Arena.ArenaMaster, Arena.NightmareBoss, "modifier_arena_enemy", {})
				Arena.NightmareBoss.damageReduc = 0.1
				Arena.NightmareBoss:RemoveModifierByName("modifier_nightmare_boss_waiting")
			end)
		end)
	end)
end
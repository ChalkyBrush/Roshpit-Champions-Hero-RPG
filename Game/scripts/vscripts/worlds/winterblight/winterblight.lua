if Winterblight == nil then
  Winterblight = class({})
end

require('worlds/winterblight/zones/starting_zone')
require('worlds/winterblight/zones/shrine_of_azalea')

function Winterblight:Debug()
    local item = CreateItem("item_debug_blink", nil, nil)
    local drop = CreateItemOnPositionSync( Vector(-15424,-2560), item )
    local position = Vector(-15424,-2560)
    RPCItems:DropItem(item, Vector(-15424,-2560))

    RPCItems:DropSynthesisVessel(Vector(-15424,-2560))
    RPCItems:RollSeinaruArcana1(Vector(-15424,-2560))
    RPCItems:RollSeinaruArcana2(Vector(-15424,-2560))
    RPCItems:RollHeroicConquerorVestments(Vector(-15424,-2560), 7)
    RPCItems:RollHeroicConquerorVestments(Vector(-15424,-2560), 7)
end


function Winterblight:InitCamp()
  print("Initialize Winterblight")
      Dungeons.phoenixCollision = true
      RPCItems.DROP_LOCATION = Vector(6656,-16128)
      Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")


      Winterblight.ZFLOAT = 0
    
  Timers:CreateTimer(2, function()
    -- Events:SpawnSuppliesDealer(Vector(-12928, -14336), Vector(0,-1))
    -- Events:SpawnCurator(Vector(-15744, -15488), Vector(1,0.7))
  end)
  Events.TownPosition = Vector(-15367, -2924)
  Events.isTownActive = true
  -- Events.Dialog0 = false
  -- Events.Dialog1 = false
  -- Events.Dialog2 = false
  -- Events.Dialog3 = false
  Dungeons.itemLevel = 1
  Timers:CreateTimer(3, function()
      local blacksmith = Events:SpawnTownNPC(Vector(-15190, -3609), "red_fox", Vector(0, 1), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
      StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
      local oracle = Events:SpawnOracle(Vector(-15808, -2048), Vector(0.3, -1))
      Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-14373, -2795), Vector(-1, 1))
  end)

  
  Winterblight.Stones = 0
  Winterblight:CalculateHeroZones()
  Winterblight:StarterMusic()
  Winterblight:HowlingWind()
  Timers:CreateTimer(1, function()
    Winterblight:SpawnStartWorld()
  end)
    Winterblight.Master = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Winterblight.Master:AddAbility("winterblight_master_ability"):SetLevel(GameState:GetDifficultyFactor())
    Winterblight.MasterAbility = Winterblight.Master:FindAbilityByName("winterblight_master_ability")
    Winterblight.Master:AddAbility("dummy_unit"):SetLevel(1)
    Timers:CreateTimer(25, function()
      Winterblight:ShrineOfAzaleaMusic()
    end)
    Winterblight:InitProps()
end

function Winterblight:InitProps()
  Timers:CreateTimer(1.5, function()
    Winterblight.CaveSpawnerIceTable = Entities:FindAllByNameWithin("CaveWaveSpawners", Vector(1664, -5952), 4500)
    Winterblight.CaveSpawnerInnerTable = Entities:FindAllByNameWithin("CaveWaveSpawnersI", Vector(1664, -5952), 4500)
    for i = 1, #Winterblight.CaveSpawnerIceTable, 1 do
      Winterblight.CaveSpawnerIceTable[i]:SetAbsOrigin(Winterblight.CaveSpawnerIceTable[i]:GetAbsOrigin()-Vector(0,0,100))
    end
    for i = 1, #Winterblight.CaveSpawnerInnerTable, 1 do
      Winterblight.CaveSpawnerInnerTable[i]:SetAbsOrigin(Winterblight.CaveSpawnerInnerTable[i]:GetAbsOrigin()-Vector(0,0,28))
    end
  end)
  Timers:CreateTimer(2.5, function()
    Winterblight.AzaleaBridge1 = Entities:FindByNameNearest("FirstAzaleaBridge", Vector(13073, -11560, 192+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaBridge1:SetAbsOrigin(Winterblight.AzaleaBridge1:GetAbsOrigin()-Vector(0,0,1500))
    Winterblight.AzaleaSwitchMathProp = Entities:FindByNameNearest("AzaleaSwitchProp1", Vector(15733, -11789, 64+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaSwitchMathProp:SetAbsOrigin(Winterblight.AzaleaSwitchMathProp:GetAbsOrigin()+Vector(0,0,1500))
    Winterblight.AzaleaBridge2 = Entities:FindByNameNearest("AzaleaBridge2", Vector(15109, -12792, 192+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaBridge2:SetAbsOrigin(Winterblight.AzaleaBridge2:GetAbsOrigin()-Vector(0,0,1500))
    Winterblight.AzaleaBridge3 = Entities:FindByNameNearest("AzaleaBridge3", Vector(9573, -15651, 192+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaBridge3:SetAbsOrigin(Winterblight.AzaleaBridge3:GetAbsOrigin()-Vector(0,0,1500))
    Winterblight.AzaleaBridge4 = Entities:FindByNameNearest("AzaleaBridge4", Vector(6400, -15449, 192+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaBridge4:SetAbsOrigin(Winterblight.AzaleaBridge4:GetAbsOrigin()-Vector(0,0,1500))
  end)
  Timers:CreateTimer(3.0, function()
    Winterblight.AzaleaOperatorPlus = Entities:FindByNameNearest("operator_plus", Vector(15074, -9613, 496+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaOperatorPlus:SetAbsOrigin(Winterblight.AzaleaOperatorPlus:GetAbsOrigin()-Vector(0,0,1500))
    Winterblight.AzaleaOperatorMinus = Entities:FindByNameNearest("operator_minus", Vector(15074, -9613, 496+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaOperatorMinus:SetAbsOrigin(Winterblight.AzaleaOperatorMinus:GetAbsOrigin()-Vector(0,0,1500))
    Winterblight.AzaleaOperatorMult = Entities:FindByNameNearest("operator_mult", Vector(15074, -9613, 496+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaOperatorMult:SetAbsOrigin(Winterblight.AzaleaOperatorMult:GetAbsOrigin()-Vector(0,0,1500))
    Winterblight.AzaleaOperatorDivide = Entities:FindByNameNearest("operator_divide", Vector(15074, -9613, 496+Winterblight.ZFLOAT), 2000)
    Winterblight.AzaleaOperatorDivide:SetAbsOrigin(Winterblight.AzaleaOperatorDivide:GetAbsOrigin()-Vector(0,0,1500))
  end)
  Timers:CreateTimer(3.5, function()
    local possibleColors = {"red", "yellow", "green", "blue"}
    local colors = {Vector(223, 54, 54), Vector(231, 214, 37), Vector(37, 231, 66), Vector(57, 99, 223)}
    Winterblight.AzaleaBladeColors = {}
    for i = 1, 4, 1 do
      local randomColorIndex = RandomInt(1, 4)
      table.insert(Winterblight.AzaleaBladeColors, possibleColors[randomColorIndex])
      local blade = Entities:FindByNameNearest("AzaleaBladeColor"..i, Vector(14662+(i-1)*110, -14560, 620+Winterblight.ZFLOAT), 1000)
      blade:SetRenderColor(colors[randomColorIndex].x, colors[randomColorIndex].y, colors[randomColorIndex].z)
    end
  end)
  Timers:CreateTimer(5, function()
    Winterblight:InitializeAzaleaPlatformRoom()
  end)
  Timers:CreateTimer(1, function()
    Winterblight.AzaleaBridge5 = Entities:FindByNameNearest("LastAzaleaBridge", Vector(-15901, -13624, 192+Winterblight.ZFLOAT), 3000)
    Winterblight.AzaleaBridge5:SetAbsOrigin(Winterblight.AzaleaBridge5:GetAbsOrigin()-Vector(0,0,3000))
    local bridgeDummy = Entities:FindByNameNearest("AzaleaBridgeDummy", Vector(-15901, -13624, 192+Winterblight.ZFLOAT), 3000)
    UTIL_Remove(bridgeDummy)
    Winterblight.AzaleaBossStatue = {}
    local props = Entities:FindAllByNameWithin("AzaleaBossStatue", Vector(-145, -14816, 200), 2000)
    for i = 1, #props, 1 do
      local boss_statue = {}
      boss_statue.model = props[i]
      boss_statue.model:SetAbsOrigin(boss_statue.model:GetAbsOrigin()+Vector(0,0,3000))
      table.insert(Winterblight.AzaleaBossStatue, boss_statue)
    end
  end)
end

function Winterblight:Debug2()
 -- Winterblight:FinishCaveWaves()
 -- Winterblight:InitializeAzaleaSwords()
 AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-15944, -13162), 23000, 23000, false)
 -- Winterblight:LastBridgeAndCup()
 Winterblight.AzaleaTeleportRoomSpawned = true
 Winterblight:SpawnAzaleaBoss()
 -- Winterblight:StartOrbSequence()
  -- Winterblight:EndOrbWaves()
    -- Winterblight:OpenShrineOfAzalea()
    -- Winterblight:ShrineSpawn6()
    -- Winterblight:SpawnChrolonus(Vector(7424, -15488), Vector(1,0))
    -- Winterblight:PlatformRoomStartBeacon()
    -- Winterblight:CandyCrushRoom()
    -- Winterblight:SpawnCruxal(Vector(-15367, -2924), Vector(0,-1))
    -- Winterblight:InitAzaleaMazeRoom()
    -- Winterblight:AzaleaSummonerRoomInit()
    -- Winterblight:LastAzaleaRoomStart()

end

function Winterblight:CalculateHeroZones()
  Timers:CreateTimer(0, function()
    if MAIN_HERO_TABLE then
      for i = 1, #MAIN_HERO_TABLE, 1 do
        local hero = MAIN_HERO_TABLE[i]
        local player = hero:GetPlayerOwner()
        local heroOrigin = hero:GetAbsOrigin()
          if (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-16512, -7095), Vector(-9856, -768))) then
            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "winterblight_village"} )
            hero.bgm = "Music.Winterblight.Start"
          elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-17000, -17000), Vector(-9856,-9550))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-17000, -17000), Vector(16384,-9550))) then
            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "shrine_of_azalea"} )
            if Winterblight.AzaleaBossMusic then
              hero.bgm = "Winterblight.AzaleaBossMusic"
            else
              hero.bgm = "Music.Winterblight.ShrineOfAzelea"
            end
          elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-9856, -9496), Vector(10058,267))) then
            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "winterblight_mountain"} )
            hero.bgm = "Music.Winterblight.Start"
          else
            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "winterblight_mountain"} )
            hero.bgm = "Music.Winterblight.Start"
          end
      end
    end
    return 3.5
  end)
end

function Winterblight:StarterMusic()
  Timers:CreateTimer(1, function()
      for i = 1, #MAIN_HERO_TABLE, 1 do
        if MAIN_HERO_TABLE[i].bgm == "Music.Winterblight.Start" then
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Winterblight.Start"})
        end
      end
    -- end
    return 130
  end)
end

function Winterblight:ShrineOfAzaleaMusic()
  Timers:CreateTimer(1, function()
      for i = 1, #MAIN_HERO_TABLE, 1 do
        if MAIN_HERO_TABLE[i].bgm == "Music.Winterblight.ShrineOfAzelea" then
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Winterblight.ShrineOfAzelea"})
        end
      end
    -- end
    return 157
  end)
end

function Winterblight:HowlingWind()
  Timers:CreateTimer(0, function()
    windTable = {Vector(-15424, -2624), Vector(-12459, -2014), Vector(-10624, -4288), Vector(-7900, -3341), Vector(-5696, -3136)}
    local luck = RandomInt(1,6)
    if Winterblight.iceWindLock then
      luck = 6
    end
    Winterblight.iceWindLock = false
    if luck == 1 then
      Winterblight.iceWindLock = true
    end
    for i = 1, #windTable, 1 do
      EmitSoundOnLocationWithCaster(windTable[i], "Winterblight.RandWind", Events.GameMaster)
      if luck == 1 then
        EmitSoundOnLocationWithCaster(windTable[i], "Winterblight.IceWind", Events.GameMaster)
      end
    end
    return 6
  end)
end

function Winterblight:SpawnStartWorld()
  local spawnerKid = CreateUnitByName("winterblight_snowball_kid", Vector(-12672, -1024), false, nil, nil, DOTA_TEAM_NEUTRALS)
  Winterblight:FirstSpawns()
  local luck = RandomInt(1,3)
  if luck == 1 then
    Winterblight:SpawnCrabSpawner(Vector(-12992, -3264), Vector(1,0), Vector(-12992, -3264))
    Timers:CreateTimer(0.2*RandomInt(1,5), function()
      Winterblight:SpawnCrabSpawner(Vector(-11428, -3281), Vector(-1,0.3), Vector(-11428, -3281))
    end)
    Timers:CreateTimer(0.3*RandomInt(1,4), function()
      Winterblight:SpawnCrabSpawner(Vector(-11840, -2688), Vector(-1,-0.1), Vector(-11840, -2688))
    end)
  elseif luck == 2 then
    local fv = (Vector(-12585, -2299) - Vector(-12608, -3264)):Normalized()
    Winterblight:SpawnCrabSpawner(Vector(-12608, -3264), fv, Vector(-12608, -3264))
    Timers:CreateTimer(0.2*RandomInt(1,5), function()
      local fv = (Vector(-12585, -2299) - Vector(-12160, -3067)):Normalized()
      Winterblight:SpawnCrabSpawner(Vector(-12160, -3067), fv, Vector(-12160, -3067))
    end)
    Timers:CreateTimer(0.3*RandomInt(1,4), function()
      local fv = (Vector(-12585, -2299) - Vector(-11648, -2987)):Normalized()
      Winterblight:SpawnCrabSpawner(Vector(-11648, -2987), fv, Vector(-11648, -2987))
    end)
  elseif luck == 3 then
    Winterblight:SpawnCrabSpawner(Vector(-12608, -3840), Vector(1,0.5), Vector(-12608, -3840))
    Timers:CreateTimer(0.2*RandomInt(1,5), function()
      Winterblight:SpawnCrabSpawner(Vector(-11584, -3499), Vector(-1,0.3), Vector(-11584, -3499))
    end)
    Timers:CreateTimer(0.3*RandomInt(1,4), function()
      Winterblight:SpawnCrabSpawner(Vector(-11776, -2953), Vector(-1,0), Vector(-11776, -2953))
    end)   
     Timers:CreateTimer(0.42*RandomInt(2,7), function()
      Winterblight:SpawnCrabSpawner(Vector(-12084, -2397), Vector(-1,0), Vector(-12084, -2397))
    end)  
  end
end

function Winterblight:SpawnDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)

    local luck = 0
    if not Events.SpiritRealm then
      luck = RandomInt(1, 180)
    else
      luck = RandomInt(1, 50)
    end
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
    Winterblight.MasterAbility:ApplyDataDrivenModifier(Winterblight.Master, unit, "modifier_Winterblight_unit", {})
    if fv then
      unit:SetForwardVector(fv)
    end
    if isAggro then
      Dungeons:AggroUnit(unit)
    end
    return unit
end

function Winterblight:AddPatrolArguments(unit, patrolSlow, phaseIntervals, patrolPointRandom, patrolPositionTable)
  unit:AddAbility("monster_patrol"):SetLevel(1)
  unit.patrolSlow = patrolSlow
  unit.phaseIntervals = phaseIntervals
  unit.patrolPointRandom = patrolPointRandom
  unit.patrolPositionTable = patrolPositionTable
end

function Winterblight:ColorWearables(unit, color)
  for k, v in pairs(unit:GetChildren()) do 
    if v:GetClassname() == "dota_item_wearable" then
      local model = v:GetModelName()
      v:SetRenderColor(color[1], color[2], color[3])
    end 
  end 
end

function Winterblight:objectShake(object, ticks, strength, bX, bY, bZ, sound, soundInterval)
  for i = 1, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      local magnitudeX = 0
      local magnitudeY = 0
      local magnitudeZ = 0
      if bX then
        magnitudeX = strength
      end
      if bY then
        magnitudeY = strength
      end
      if bZ then
        magnitudeZ = strength
      end
      local moveVector = Vector(magnitudeX, magnitudeY, magnitudeZ)
      if i%2 == 0 then
        moveVector = moveVector*-1
      end
      if sound then
        if i%soundInterval == 0 then
          EmitSoundOnLocationWithCaster(object:GetAbsOrigin(), sound, Events.GameMaster)
        end
      end
      object:SetAbsOrigin(object:GetAbsOrigin()+moveVector)
    end)
  end
end

function Winterblight:smoothColorTransition(object, startColor, endColor, ticks)
  local colorChangeVector = (endColor-startColor)/ticks
  for i = 0, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      object:SetRenderColor(startColor.x + colorChangeVector.x * i, startColor.y + colorChangeVector.y * i, startColor.z + colorChangeVector.z * i)
    end)
  end
end

function Winterblight:smoothSizeChange(object, startSize, endSize, ticks)
  local growth = (endSize-startSize)/ticks
  for i = 0, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      object:SetModelScale(startSize + growth*i)
    end)
  end
end

function Winterblight:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
    unit.targetRadius = radius
    unit.minRadius = minRadius
    unit.targetAbilityCD = cooldown
    unit.targetFindOrder = targetFindOrder
end

function Winterblight:SetTargetCastArgs(unit, targetRadius, minRadius, targetAbilityCD, targetFindOrder)
  unit.targetRadius = targetRadius
  unit.minRadius  = minRadius
  unit.targetAbilityCD = targetAbilityCD
  unit.targetFindOrder = targetFindOrder
end

function Winterblight:SpawnUnitsWithPatrol()

end

function Winterblight:Walls(bRaise, walls, bSound, movementZ)
  if not bRaise then
    movementZ = movementZ*-1
  end
  if #walls > 0 then
    Timers:CreateTimer(0.1, function()
      if bSound then
        for i = 1, #walls, 1 do
          EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Winterblight.WallOpen", Events.GameMaster)
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

function Winterblight:WallsTicks(bRaise, walls, bSound, movementZ, ticks, shakeForce)
  if not bRaise then
    movementZ = movementZ*-1
  end
  if #walls > 0 then
    Timers:CreateTimer(0.1, function()
      if bSound then
        for i = 1, #walls, 1 do
          EmitSoundOnLocationWithCaster(walls[i]:GetAbsOrigin(), "Winterblight.WallOpen", Events.GameMaster)
        end
      end
    end)
    for i = 1, ticks, 1 do
      for j = 1, #walls, 1 do
        Timers:CreateTimer(i*0.03, function()
          walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
          if j == 1 then
            ScreenShake(walls[j]:GetAbsOrigin(), 160, shakeForce, shakeForce, 9000, 0, true)
          end
        end)
      end
    end
  end
end

function Winterblight:RemoveBlockers(delay, blockername, position, searchRadius)
    Timers:CreateTimer(delay, function()
      local blockers = Entities:FindAllByNameWithin(blockername, position, searchRadius)
      for i = 1, #blockers, 1 do
        UTIL_Remove(blockers[i])
      end
    end)
end

function Winterblight:MoveObject(object, targetPosition, ticks)
  local moveVector = (targetPosition - object:GetAbsOrigin())/ticks
  for i = 1, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      object:SetAbsOrigin(object:GetAbsOrigin()+moveVector)
    end)
  end
end

function Winterblight:RotateObject(object, direction, speed, ticks, startAngle)
  for i = 1, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      local newAngle =  startAngle+speed*i
      if newAngle > 360 then
        newAngle = newAngle%360
      end
      object:SetAngles(0, newAngle, 0)
    end)
  end
end

function Winterblight:ActivateSwitchGeneric(buttonPosition, buttonName, bDown, ms)
  local movementZ = ms
  if bDown then
    movementZ = -ms
  end
  local switch = Entities:FindByNameNearest(buttonName, buttonPosition, 600)
  local walls = {switch}
  Timers:CreateTimer(0.1, function()
    EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Winterblight.SwitchStart", Events.GameMaster)
  end)
  for i = 1, 60, 1 do
    for j = 1, #walls, 1 do
      Timers:CreateTimer(i*0.03, function()
        walls[j]:SetAbsOrigin(walls[j]:GetAbsOrigin()+Vector(0,0,movementZ))
      end)
    end
  end
  Timers:CreateTimer(1.7, function()
    EmitSoundOnLocationWithCaster(walls[1]:GetAbsOrigin(), "Winterblight.SwitchEnd", Events.GameMaster)
  end)
end
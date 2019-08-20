if Winterblight == nil then
  Winterblight = class({})
end

require('worlds/winterblight/zones/starting_zone')
require('worlds/winterblight/zones/shrine_of_azalea')
require('worlds/winterblight/zones/winter_forest')
require('worlds/winterblight/zones/winter_cave')

function Winterblight:Debug()
    local item = RPCItems:CreateItem("item_debug_blink", nil, nil)
    local drop = CreateItemOnPositionSync( Vector(-15424,-2560), item )
    local position = Vector(-15424,-2560)
    RPCItems:DropItem(item, Vector(-15424,-2560))

  -- RPCItems:RollHoodOfLords(position, true)
    -- RPCItems:RollFrostmawHuntersHood(Vector(-15424,-2560))
    -- RPCItems:RollFrozenHeart(Vector(-15424,-2560))
    -- RPCItems:RollEnergyWhipGlove(Vector(-15424,-2560))
     RPCItems:RollDiamondClawsOfTiamat(Vector(-15424,-2560), 10)
    -- Weapons:RollLegendWeapon1(Vector(-15424,-2560), "flamewaker", 50, false)
    -- RPCItems:RollGalvanizedRazorBand(Vector(-15424,-2560))
    -- RPCItems:RollGoldbreakerGauntlet(Vector(-15424,-2560))
    -- RPCItems:RollHelmOfKnightHawk(Vector(-15424,-2560), false)
    -- RPCItems:RollPegasusBoots(Vector(-15424,-2560))
    -- RPCItems:RollGuardianStone(Vector(-15424,-2560))
    -- RPCItems:RollRobesOfEruditeTeacher(Vector(-15424,-2560))
    -- RPCItems:RollAlienArmor(Vector(-15424,-2560))
    -- RPCItems:RollPivotalSwiftboots(Vector(-15424,-2560))
    RPCItems:RollMagistratesHood(Vector(-15424,-2560))
    RPCItems:NethergraspPalisade(Vector(-15424,-2560))
    RPCItems:RollBerylRingOfIntuition(Vector(-15424,-2560), 40)
    RPCItems:RollAuricRingOfInspiration(Vector(-15424,-2560), 40)
    -- RPCItems:RollWindDeityCrown(Vector(-15424,-2560), false, 4)
    -- RPCItems:RollBorealGraniteVest(Vector(-15424,-2560))
    -- RPCItems:RollCaptainsVest(Vector(-15424,-2560))
    -- RPCItems:RollGravelfootTreads(Vector(-15424,-2560))
    -- RPCItems:RollIceFloeSlippers(Vector(-15424,-2560))
    -- RPCItems:RollIronTreadsOfDestruction(Vector(-15424,-2560))
    -- RPCItems:RollStargazersSphere(Vector(-15424,-2560))
    -- RPCItems:RollTatteredNoviceArmor(Vector(-15424,-2560))
    -- RPCItems:RollBuzukisFinger(Vector(-15424,-2560))
    -- RPCItems:RollSwiftspikeBracer(Vector(-15424,-2560))
    -- RPCItems:RollLegionVestments(Vector(-15424,-2560))
    -- RPCItems:RollRedDivinexAmulet(Vector(-15424,-2560))
    -- RPCItems:RollHelmOfTheMountainGiant(Vector(-15424,-2560), false)
    -- RPCItems:RollChainsOfOrthok(Vector(-15424,-2560))
    -- RPCItems:RollAstralArcana3(Vector(-15424,-2560))
    -- Winterblight:DropBorealGraniteChunk(Vector(-15424,-2560))
    -- RPCItems:RollSeinaruArcana1(Vector(-15424,-2560))
    -- RPCItems:RollSeinaruArcana1(Vector(-15424,-2560))
    -- RPCItems:RollPuzzlersLocket(Vector(-15424,-2560))
    -- Winterblight:CandyCrushRoom()

end


function Winterblight:InitCamp()
 --print("Initialize Winterblight")
      Dungeons.phoenixCollision = true
      RPCItems.DROP_LOCATION = Vector(-16000,492)
      Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")


      Winterblight.ZFLOAT = 0
    
  Timers:CreateTimer(2, function()
    -- Events:SpawnSuppliesDealer(Vector(-12928, -14336), Vector(0,-1))
    -- Events:SpawnCurator(Vector(-15744, -15488), Vector(1,0.7))
  end)
  Events.TownPosition = Vector(-15197, -2924)
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
      Events:SpawnCurator(Vector(-15925, -3113), Vector(1,0.35))
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
      Winterblight:CavernMusic()
    end)
    Winterblight:InitProps()
end

function Winterblight:InitProps()
  Winterblight.Villagers = {0, 0, 0}
  Winterblight.Villagers[1] = CreateUnitByName("winterblight_tuskar_villager", Vector(-11008, -896), false, nil, nil, DOTA_TEAM_GOODGUYS)
  Winterblight.Villagers[1]:SetForwardVector(Vector(0.2,-1))
  Winterblight.Villagers[2] = CreateUnitByName("winterblight_tuskar_villager", Vector(-9285, -930), false, nil, nil, DOTA_TEAM_GOODGUYS)
  Winterblight.Villagers[2]:SetForwardVector(Vector(-1,0.2))
  Winterblight.Villagers[2]:SetOriginalModel("models/creeps/ice_biome/tuskfolk/tuskfolk001c_f.vmdl")
  Winterblight.Villagers[2]:SetModel("models/creeps/ice_biome/tuskfolk/tuskfolk001c_f.vmdl")
  Winterblight.Villagers[3] = CreateUnitByName("winterblight_tuskar_villager", Vector(-8762, -3940), false, nil, nil, DOTA_TEAM_GOODGUYS)
  Winterblight.Villagers[3]:SetForwardVector(Vector(-1,-0.8))
  Winterblight.Villagers[3]:SetOriginalModel("models/creeps/ice_biome/tuskfolk/tuskfolk001a_f.vmdl")
  Winterblight.Villagers[3]:SetModel("models/creeps/ice_biome/tuskfolk/tuskfolk001a_f.vmdl")
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
  Timers:CreateTimer(6, function()
    Winterblight:SpawnTrainingDummy(Vector(-11968, -1096))
  end)
end

function Winterblight:SpawnTrainingDummy(position)
  local positionTable = {position}
  for i =1, #positionTable, 1 do
    local dummy = CreateUnitByName("arena_training_dummy", positionTable[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
    dummy.pushLock = true
    dummy:SetForwardVector(Vector(1,-1))
    dummy.targetPosition = dummy:GetAbsOrigin()
    local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
    dummyAbility:ApplyDataDrivenModifier(dummy, dummy, "modifier_dummy_ice", {})
  end
  
end

function Winterblight:DropGlacierStone(position)
    local item = RPCItems:CreateConsumable("item_rpc_winterblight_glacier_stone", "mythical", "Glacier Stone", "consumable", false, "Consumable", "item_rpc_winterblight_glacier_stone_desc")
    item.newItemTable.stashable = true
    item.newItemTable.consumable = true
  RPCItems:ItemUpdateCustomNetTables(item)
    RPCItems:BasicDropItem(position, item)
end

function Winterblight:Debug2()
  -- if not Winterblight.GuideBasePos then
  --   Winterblight.GuideBasePos = Winterblight.CavernGuide:GetAbsOrigin()
  -- end
  -- Winterblight.CavernGuide:RemoveModifierByName("modifier_guide_tiamat_thinking")
  -- Winterblight.CavernGuide:SetAbsOrigin(Winterblight.GuideBasePos)
  -- if Winterblight.CavernGuide.boss_table then
  --   for i = 1, #Winterblight.CavernGuide.boss_table, 1 do
  --     UTIL_Remove(Winterblight.CavernGuide.boss_table[i])
  --   end
  -- end
  -- if Winterblight.CavernGuide.relic_table then
  --   for i = 1, #Winterblight.CavernGuide.relic_table, 1 do
  --     UTIL_Remove(Winterblight.CavernGuide.relic_table[i])
  --   end
  -- end
  -- if Winterblight.tiamat_sequence_orb then
  --   ParticleManager:DestroyParticle(Winterblight.tiamat_sequence_orb.pfx, false)
  -- end
  -- local msg = {}
  -- msg.PlayerID = MAIN_HERO_TABLE[1]:GetPlayerOwnerID()
  -- Winterblight:TiamatSequence(msg)
  -- Winterblight.CavernData.Chambers[1]["events"][1]["level"] = 20
  -- Winterblight.CavernData.Chambers[1]["events"][2]["level"] = 15
  
  -- Winterblight.CavernData.Chambers[2]["events"][1]["level"] = 10
  -- Winterblight.CavernData.Chambers[2]["events"][2]["level"] = 15
  -- Winterblight.CavernData.Chambers[3]["events"][1]["level"] = 18
  -- Winterblight.CavernData.Chambers[3]["events"][2]["level"] = 15

  -- Winterblight.CavernData.Chambers[4]["events"][1]["level"] = 18
  -- Winterblight.CavernData.Chambers[4]["events"][2]["level"] = 15

  -- Winterblight.CavernData.Chambers[1]["boss_status"] = 2
  -- Winterblight.CavernData.Chambers[2]["boss_status"] = 2
  -- Winterblight.CavernData.Chambers[3]["boss_status"] = 2
  -- Winterblight.CavernData.Chambers[4]["boss_status"] = 2

  --  Winterblight.CavernData.Chambers[1]["boss_level_defeated"] = 2
  --  Winterblight.CavernData.Chambers[2]["boss_level_defeated"] = 2
  --  Winterblight.CavernData.Chambers[3]["boss_level_defeated"] = 2
  --  Winterblight.CavernData.Chambers[4]["boss_level_defeated"] = 2

  --  Winterblight.CavernData.tiamat_status = 0
  -- Winterblight.CavernData.RelicsFragments = 10000
     -- Winterblight:GetStarValueForCavernMaster(MAIN_HERO_TABLE[1])
     -- Stars:StarEventPlayer("cavern_master", MAIN_HERO_TABLE[1])
 -- Winterblight:FinishCaveWaves()
 -- Winterblight:InitializeAzaleaSwords()
 -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-15944, -13162), 23000, 23000, false)
 -- Winterblight:LastBridgeAndCup()
 -- Winterblight.AzaleaTeleportRoomSpawned = true
 -- Winterblight:SpawnAzaleaBoss()
 -- Winterblight:InitCaptainReynar()
 
 -- Winterblight:ShrineSpawn2()
--  Winterblight.MathPuzzleComplete = true


 -- Winterblight:SpawnGrandStalacorr(Vector(-15424,-2560), RandomVector(1))
 -- local hero = MAIN_HERO_TABLE[1]
 -- Runes:EasySwapArcanaSkills(hero, DOTA_R_SLOT, "ranger_aoe_explosion", "crystal_arrow", HerosCustom:GetInternalHeroName(hero:GetUnitName()), "arcana3")
 -- Winterblight:StartOrbSequence()
  -- Winterblight:EndOrbWaves()
    -- Winterblight:OpenShrineOfAzalea()
    -- Winterblight:SpawnAzaleaCup(Vector(15910, -15831), Vector(-1,0), 1)
    -- Winterblight:ShrineSpawn6()
    -- Winterblight:SpawnChrolonus(Vector(7424, -15488), Vector(1,0))
    -- Winterblight:PlatformRoomStartBeacon()
    -- Winterblight:CandyCrushRoom()
    -- Winterblight:SpawnCruxal(Vector(-15367, -2924), Vector(0,-1))
    -- Winterblight:InitAzaleaMazeRoom()
    -- Winterblight:AzaleaSummonerRoomInit()
    -- Winterblight:LastAzaleaRoomStart()
    
    -- Winterblight:CompleteChamberEvent(1, MAIN_HERO_TABLE[1]:GetAbsOrigin())
     -- Winterblight:SpawnWintertideMonk(MAIN_HERO_TABLE[1]:GetAbsOrigin()+Vector(0,-300), Vector(0,-1))
    -- local merkurio = Winterblight:SpawnMerkurio(Vector(-6656, 8064), Vector(0,1))
    -- merkurio.state = 9
    -- local ability = merkurio:FindAbilityByName("winterblight_merkurio_passive")
    -- ability:ApplyDataDrivenModifier(merkurio, merkurio, "modifier_disable_player", {duration = 0})
    -- Timers:CreateTimer(5, function()
    --   ability:ApplyDataDrivenModifier(merkurio, merkurio, "modifier_disable_player", {})
    -- end)
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
        elseif WallPhysics:IsWithinRegionA(heroOrigin, Vector(-17000, 1000), Vector(-13708,17000)) or WallPhysics:IsWithinRegionA(heroOrigin, Vector(-13708, 3062), Vector(-8120,17000)) or WallPhysics:IsWithinRegionA(heroOrigin, Vector(-7685, 6807), Vector(-4228,17000)) or WallPhysics:IsWithinRegionA(heroOrigin, Vector(-4228, 11672), Vector(-2394,11672)) then
          hero.bgm = "Music.Winterblight.Cavern"
          CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "winterblight_cavern"} )
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

function Winterblight:CavernMusic()
  Timers:CreateTimer(1, function()
      for i = 1, #MAIN_HERO_TABLE, 1 do
        if MAIN_HERO_TABLE[i].bgm == "Music.Winterblight.Cavern" then
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Winterblight.Cavern"})
        end
      end
    -- end
    return 127
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
  if false then
    local spawnerKid = CreateUnitByName("winterblight_snowball_kid", Vector(-12672, -1024), false, nil, nil, DOTA_TEAM_NEUTRALS)
  end
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
      luck = RandomInt(1, 180-(Winterblight.Stones*40))
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

function Winterblight:CloseAltarOfIce(msg)
  local hero = EntIndexToHScript(msg.heroIndex)
 --print("CLOSE ALTAR")
  hero.WinterblightAltar = false
  local closeAltar = true
  for i = 1, #MAIN_HERO_TABLE, 1 do
    if MAIN_HERO_TABLE[i].WinterblightAltar then
      closeAltar = false
    end
  end
  if closeAltar then
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-14024, -7195), 500, 5, false)
    if Winterblight.AltarApparition then
      StartAnimation(Winterblight.AltarApparition, {duration=1.6, activity=ACT_DOTA_CAST_ABILITY_5, rate=0.9})
    end
    Timers:CreateTimer(0.75, function()
      EmitSoundOnLocationWithCaster( Vector(-14024, -7195), "Winterblight.AzaleaBoss.IceNovaExplode", caster)
      local particle = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
      local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
      local radius = 500
      ParticleManager:SetParticleControl( pfx, 0,  GetGroundPosition(Vector(-14024, -7195), Events.GameMaster) )
      ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
      Timers:CreateTimer(3.5, function()
          ParticleManager:DestroyParticle(pfx, false)
      end)
    end)
    if Winterblight.AltarApparition then
      for i = 1, 60, 1 do
        Timers:CreateTimer(i*0.03, function()
          Winterblight.AltarApparition:SetAbsOrigin(Winterblight.AltarApparition:GetAbsOrigin() - Vector(0,0,30))
        end)
      end
      Timers:CreateTimer(0.2, function()
        EmitSoundOn("Winterblight.AltarApparition.Spawn", Winterblight.AltarApparition)
      end)
    end
  end
end

function Winterblight:CrystalPlaced(msg)
  local stone = EntIndexToHScript(msg.stone)
  local hero = EntIndexToHScript(msg.heroIndex)
  if stone:GetAbilityName() == "item_rpc_winterblight_glacier_stone" then
    if not Challenges:CheckIfHeroHasItemByItemIndex(hero, stone:GetEntityIndex()) then
      return false
    end
    Winterblight.Stones = math.min(Winterblight.Stones + 1, 3)
    hero:TakeItem(stone)
    Winterblight.StonesPlacedTable[Winterblight.Stones] = stone:GetEntityIndex()
    if Winterblight.Stones == 1 then
      local crystal = Entities:FindByNameNearest("WinterblightStones3", Vector(-14264, -6978, 56+Winterblight.ZFLOAT), 500)
      Winterblight:CrystalEnterAnimation(crystal)
      for i = 1, 30, 1 do
        Timers:CreateTimer(i*0.3, function()
          local spawnPos = Vector(-16000, -5888) + Vector(RandomInt(0,3200), RandomInt(0,880))
          local ice = Winterblight:SpawnLivingIceNoAggro(spawnPos, Vector(0,-1))
            local particleName = "particles/roshpit/winterblight/snow_impact.vpcf"
            local snowparticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(snowparticle,0,ice:GetAbsOrigin())
            Timers:CreateTimer(1, function()
              ParticleManager:DestroyParticle( snowparticle, false )
            end)
          EmitSoundOn("Winterblight.IceCrystal.Spawn", ice)
          StartAnimation(ice, {duration=1, activity=ACT_DOTA_SPAWN, rate=1.4})
          local iceAbil = ice:FindAbilityByName("winterblight_ice_magic_immune_ability")
          local iceImmuneDuration = 1 + 0.3*GameState:GetDifficultyFactor()
          iceAbil:ApplyDataDrivenModifier(ice, ice, "modifier_black_King_bar_immunity", {duration = iceImmuneDuration})
          if GameState:GetDifficultyFactor() >= 3 then
            local luck = RandomInt(1, 8)
            if luck == 1 then
              ice:AddAbility("creature_pure_strike"):SetLevel(GameState:GetDifficultyFactor())
            end
          end
        end)
      end
      if GameState:GetDifficultyFactor() >= 3 then
        Winterblight:InitializeOrthok()
      end
    elseif Winterblight.Stones == 2 then
      local crystal = Entities:FindByNameNearest("WinterblightStones2", Vector(-14061, -6978, 56+Winterblight.ZFLOAT), 500)
      Winterblight:CrystalEnterAnimation(crystal)
      local positionTable = {Vector(-15616, -5760), Vector(-15355, -5120), Vector(-14720, -4873), Vector(-14080, -4662), Vector(-13503, -4888), Vector(-12928, -5132), Vector(-12773, -5760), Vector(-14626, -5325), Vector(-13568, -5325), Vector(13770, -5411), Vector(8964, -5570)}
      for i = 1, #positionTable, 1 do
        Timers:CreateTimer(i*0.4, function()
          local queen = Winterblight:SpawnHeartFreezer(positionTable[i], Vector(0,-1))
          local particle = "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
          local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
          local radius = 300
          ParticleManager:SetParticleControl( pfx, 0,  GetGroundPosition(queen:GetAbsOrigin(), Events.GameMaster) )
          ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
          Timers:CreateTimer(3.5, function()
              ParticleManager:DestroyParticle(pfx, false)
          end)
          EmitSoundOn("Winterblight.HeartFreezer.SpawnLaugh", queen)
        end)
      end
    elseif Winterblight.Stones == 3 then
      Winterblight.AltarDisabled = true
      CustomGameEventManager:Send_ServerToAllClients("close_altar_of_ice", {} )
      local crystal = Entities:FindByNameNearest("WinterblightStones1", Vector(-13852, -6978, 56+Winterblight.ZFLOAT), 500)
      Winterblight:CrystalEnterAnimation(crystal)
      local positionTable = {Vector(-13024, -5950), Vector(-13312, -4524), Vector(-14377, -4524), Vector(-15104, -5504)}
      for i = 1, #positionTable, 1 do
        local lookToPoint = (Vector(-14080, -5923) - positionTable[i]):Normalized()
        Winterblight:SpawnMountainGod(positionTable[i], lookToPoint)
      end
    end
  end
end

function Winterblight:CrystalEnterAnimation(crystal)
  Winterblight:smoothSizeChange(crystal, 0.01, 1, 20)
  CustomAbilities:QuickParticleAtPoint("particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_frostbite_snow_explode.vpcf", crystal:GetAbsOrigin(), 4)
  EmitSoundOnLocationWithCaster(crystal:GetAbsOrigin(), "Winterblight.IceCrystal.Place", Events.GameMaster)
  for i = 1, 10, 1 do
    Timers:CreateTimer(i*1.8, function()
      ScreenShake(crystal:GetAbsOrigin(), 800, 1, 1, 9000, 0, true)
      EmitSoundOnLocationWithCaster(crystal:GetAbsOrigin(), "Winterblight.Mountain.Shake", Winterblight.Master)
    end)
  end
end

function Winterblight:DropBorealGraniteChunk(position)
  RPCItems:CreateBasicConsumable(position, "item_rpc_boreal_granite_chunk", "Boreal Granite Chunk", "immortal", true)
end

function Winterblight:SpawnGrandStalacorr(position, fv)
  local queen = Winterblight:SpawnDungeonUnit("winterblight_grand_stalacorr", position, 4, 5, "Seafortress.Stalakor.Aggro", fv, false)

  queen:SetRenderColor(100, 230, 245)
  queen.reduc = 0.05
  Events:AdjustBossPower(queen, 8, 8, false)
  Winterblight:SetTargetCastArgs(queen, 900, 0, 1, FIND_ANY_ORDER)
  local ability = queen:FindAbilityByName("grand_stalacorr_passive")
  queen.cantAggro = true
  ability:ApplyDataDrivenModifier(queen, queen, "modifier_disable_player", {duration = 6.0})
  queen.dominion = true
  for i = 0, 4, 1 do
    Timers:CreateTimer(i*1.5, function()
      ScreenShake(queen:GetAbsOrigin(), 860, 0.7, 0.7, 9000, 0, true)
        local pfx = ParticleManager:CreateParticle( "particles/roshpit/winterblight_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, queen:GetAbsOrigin()+Vector(0,0,80))
        ParticleManager:SetParticleControl(pfx, 5, Vector(0.9, 0.9, 1.0))
        ParticleManager:SetParticleControl(pfx, 2, Vector(0.8,0.8,0.8))
        Timers:CreateTimer(10, function() 
          ParticleManager:DestroyParticle( pfx, false )
          ParticleManager:ReleaseParticleIndex(pfx)
        end)
      EmitSoundOnLocationWithCaster(queen:GetAbsOrigin(), "Winterblight.GrandStalacorr.Rising", Events.GameMaster)
    end)
  end
  queen:SetRenderColor(70, 200, 255)
  
  Timers:CreateTimer(6.0, function()
    queen.cantAggro = false
    Dungeons:AggroUnit(queen)

  end)
  return queen
end

function Winterblight:MithrilReward(position, code)
  Timers:CreateTimer(5, function()
        local reward = 1000
        local stonesReward = 1000
        if GameState:GetDifficultyFactor() == 2 then
          reward = 2000
          stonesReward = 3000
        elseif GameState:GetDifficultyFactor() == 3 then
          reward = 5000
          stonesReward = 6000
        end
        if code == "azalea" then
          Timers:CreateTimer(4, function()
            for i = 1, #MAIN_HERO_TABLE, 1 do
              Stars:StarEventPlayer("azalea", MAIN_HERO_TABLE[i])
            end
          end)
        elseif code == "tiamat" then
          Timers:CreateTimer(4, function()
            for i = 1, #MAIN_HERO_TABLE, 1 do
              Stars:StarEventPlayer("wb_cavern", MAIN_HERO_TABLE[i])
            end
          end)
          reward = reward*1.3
          stonesReward = stonesReward*1.3
          local bonus_mult = Winterblight.TiamatBossLevel*0.06
          reward = reward + reward*bonus_mult
        end

        local mithrilReward = reward*Events.ResourceBonus+(stonesReward*(Winterblight.Stones))
        local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #MAIN_HERO_TABLE, 1 do
        --   Stars:StarEventPlayer("pitoftrials", MAIN_HERO_TABLE[i])
        -- end
        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end


      if #crystal.winnerTable > 0 then
          -- for i = 1, #crystal.winnerTable, 1 do
          --   crystal.winnerTable[i].shardsPickedUp = 0
          -- end
          Timers:CreateTimer(1.4, function()
            EmitSoundOn("Resource.MithrilShardEnter", crystal)
          end)
        end
  end)
end

function Winterblight:MithrilRewardVariable(position, code, reward)
  Timers:CreateTimer(5, function()
        if code == "math" then
          if GameState:GetDifficultyFactor() == 1 then
            reward = reward*120
          elseif GameState:GetDifficultyFactor() == 2 then
            reward = reward*160
          elseif GameState:GetDifficultyFactor() == 3 then
            reward = reward*240
          end
        end


        local mithrilReward = reward*Events.ResourceBonus*(Winterblight.Stones+1)
        local crystal = CreateUnitByName("arcane_crystal", position+Vector(0,0,1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
        crystal:SetAbsOrigin(crystal:GetAbsOrigin()+Vector(0,0,1300))
        local crystalAbility = crystal:AddAbility("mithril_shard_ability")
        crystalAbility:SetLevel(1)
        local fv = RandomVector(1)
        crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
        crystal.reward = mithrilReward
        crystal.reward = math.floor(crystal.reward*(1+GameState:GetPlayerPremiumStatusCount()*0.1))
        crystal.distributed = 0
        local baseModelSize = math.min(2.9, 1.2 + crystal.reward/200)
        crystal.modelScale = baseModelSize
        crystal:SetModelScale(baseModelSize)
        crystal.fallVelocity = 45
        crystal.falling = true
        crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #MAIN_HERO_TABLE, 1 do
        --   Stars:StarEventPlayer("pitoftrials", MAIN_HERO_TABLE[i])
        -- end
        -- local potentialWinnerTable = RPCItems:GetConnectedPlayerTable()
        -- for i = 1, #potentialWinnerTable, 1 do
        --  local completedTable = CustomNetTables:GetTableValue("player_stats", tostring(potentialWinnerTable[i]:GetPlayerOwnerID()).."-challenge")
        --  local completed = completedTable.completed
        --  if completed == 0 then
        --    potentialWinnerTable[i].shardsPickedUp = 0
        --    table.insert(crystal.winnerTable, potentialWinnerTable[i])
        --  end
        -- end


      if #crystal.winnerTable > 0 then
          -- for i = 1, #crystal.winnerTable, 1 do
          --   crystal.winnerTable[i].shardsPickedUp = 0
          -- end
          Timers:CreateTimer(1.4, function()
            EmitSoundOn("Resource.MithrilShardEnter", crystal)
          end)
        end
  end)
end
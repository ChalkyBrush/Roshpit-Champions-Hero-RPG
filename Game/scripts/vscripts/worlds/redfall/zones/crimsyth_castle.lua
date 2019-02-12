function Redfall:InitiateCrimsythCastleIntro()
  Dungeons.respawnPoint = Vector(14528, 14400)
	Redfall:CastleOutsideMusic()
  Redfall:SpawnFirstSetOfCrimsythCastleMobs()
  local drawbridge = Entities:FindByNameNearest("castle_drawbridge", Vector(5355, 11047, 76+Redfall.ZFLOAT), 800)
  drawbridge:SetAngles(0, 0, 90)
  drawbridge:SetAbsOrigin(drawbridge:GetAbsOrigin()-Vector(0,0,210))
end

function Redfall:InitiateDebugRedfall()
  Redfall.Castle = {}
  Redfall.CastleStart = true

  Redfall:InitiateCrimsythCastle()
  -- Redfall:InitializeCastleTortureRoom()
  -- Redfall:InitializeArchivistRoom()
  -- Redfall:InitCastleNextFirstRoom()

  -- Redfall:CastleStartLavaMazeRoom()
  -- RPCItems.StrictItemLevel = 300
  -- Redfall:SpawnFortuneRoom()
  -- RPCItems:RollHoodOfLords(MAIN_HERO_TABLE[1]:GetAbsOrigin(), true)
  -- RPCItems:RollWindDeityCrown(MAIN_HERO_TABLE[1]:GetAbsOrigin(), true, 5)
  -- RPCItems:RollSpellfireGloves(MAIN_HERO_TABLE[1]:GetAbsOrigin(), true)
  -- RPCItems:RollDunetreadBoots(MAIN_HERO_TABLE[1]:GetAbsOrigin())


  -- Redfall:SpawnTortureWaveUnit("redfall_crimsyth_khan_knight", Vector(-15168, -14976), 5, 100, 1.6, true)
  RPCItems:RollAzureEmpire(MAIN_HERO_TABLE[1]:GetAbsOrigin())
  RPCItems:RollHurricaneVest(MAIN_HERO_TABLE[1]:GetAbsOrigin())
  -- RPCItems:VermillionDreamRobes(MAIN_HERO_TABLE[1]:GetAbsOrigin())
  -- RPCItems:RollTwigOfEnlightened(MAIN_HERO_TABLE[1]:GetAbsOrigin())
  -- RPCItems:RollHyperVisor(MAIN_HERO_TABLE[1]:GetAbsOrigin(), false)
  -- RPCItems:RollIgneousCanineHelm(MAIN_HERO_TABLE[1]:GetAbsOrigin())
  -- local variantName = "item_rpc_neutral_glyph_3_3"
  -- local rarityName = "uncommon"
  -- local itemName = "Basic Glyph"
  -- local slotText = "Glyph"
  -- local useDescription = variantName.."_description"
  -- local minLevel = 15
  -- Glyphs:CreateGlyphItem(variantName, rarityName, itemNameText, slotText, useDescription, MAIN_HERO_TABLE[1]:GetAbsOrigin(), "tooltip_neutral", minLevel, "modifier_neutral_glyph_3_3", 0)
  -- Glyphs:RollGlyphAll("item_rpc_duskbringer_glyph_7_1", MAIN_HERO_TABLE[1]:GetAbsOrigin(), 0)
  -- Redfall:CastleSpawnBackHallway()
  -- Redfall:InitCastleGroundsRoom()
  -- Redfall:SpawnFortuneRoom()
  -- Redfall:SpawnTreasureRoom()
  -- Redfall:WaterPlatformRoom()
  -- Redfall:CastleInitiateAfterHallwayRoom()
  -- Redfall:CastleInitiateFinalRoom()
  -- Redfall:ActivateBossStatue(Vector(-1600, 4066, 315+Redfall.ZFLOAT))
  -- Timers:CreateTimer(6, function()
  --   Redfall:ActivateBossStatue(Vector(-1600, 2442, 315+Redfall.ZFLOAT))
  -- end)
      -- Redfall.Castle.BossStatuesActivated = 2
  -- Redfall:CastleStartLavaMazeRoom()
  Redfall:InitBallSwitchRoom()
  -- Redfall:CastleInitiateAfterBallRoom()
  -- Redfall:PerditionRoom()
  -- Redfall:InitCastleNextFirstRoom()

  -- -- Redfall:CastleInitiateLavaRoom()

  -- -- Redfall:InitializeMazeBattlementsRoom()
  -- Redfall:InitializeCastleTortureRoom()
  -- Redfall:InitializeArchivistRoom()

  -- local variantName = "item_rpc_".."solunia".."_glyph_5_a"
  -- Glyphs:RollGlyphAll(variantName, Vector(-15168, -14976), 0)
  -- for i = 1, 5, 1 do
  --   Glyphs:RollArchivistT5Glyph(Vector(-15168, -14976))
  -- end

    -- for i = 1, #MAIN_HERO_TABLE, 1 do
    --   Redfall:GiveSpiritRuby(MAIN_HERO_TABLE[i], Vector(-1600, 4066))
    -- end
end

function Redfall:InitiateCastleTiles()
  local tile1 = Entities:FindByNameNearest("CastleTile1", Vector(4544, 10816, 101+Redfall.ZFLOAT), 800)
  local tile2 = Entities:FindByNameNearest("CastleTile2", Vector(4224, 10816, 101+Redfall.ZFLOAT), 800)
  local tilePositionTable = {Vector(4349, 10023, 128 + Redfall.ZFLOAT), Vector(4349, 9513, 128 + Redfall.ZFLOAT), Vector(4098, 9261, 128 + Redfall.ZFLOAT), Vector(4098, 8768, 128 + Redfall.ZFLOAT), Vector(4608, 8768, 128 + Redfall.ZFLOAT), Vector(5122, 8768, 128 + Redfall.ZFLOAT), Vector(5632, 8768, 128 + Redfall.ZFLOAT), Vector(6127, 8768, 128 + Redfall.ZFLOAT), Vector(6127, 10279, 128 + Redfall.ZFLOAT), Vector(6398, 9513, 128 + Redfall.ZFLOAT), Vector(5122, 9769, 128 + Redfall.ZFLOAT)}
  local tileIndex1 = RandomInt(1, #tilePositionTable)
  local tileIndex2 = RandomInt(1, #tilePositionTable)
  while tileIndex1 == tileIndex2 do
    tileIndex2 = RandomInt(1, #tilePositionTable)
  end
  print(tilePositionTable[tileIndex1])
  tile1:SetAbsOrigin(tilePositionTable[tileIndex1]+Vector(0,0,-127))
  tile2:SetAbsOrigin(tilePositionTable[tileIndex2]+Vector(0,0,-127))
  Redfall.Castle.TileLocationTable = {tileIndex1, tileIndex2}
  Redfall.Castle.EntranceTileTable = {tile1, tile2}
end

function Redfall:CastleOutsideMusic()
  Timers:CreateTimer(4.95, function()
    for i = 1, #MAIN_HERO_TABLE, 1 do
      MAIN_HERO_TABLE[i].bgm ="Music.Redfall.CrimsythCastleIntro"
    end
  end)
  Timers:CreateTimer(5, function()
    -- EmitSoundOnLocationWithCaster(Vector(-14976, -15296), "Music.Redfall.Village", Events.GameMaster)
    -- EmitSoundOnLocationWithCaster(Vector(-12864, -14848), "Music.Redfall.Village", Events.GameMaster)
      if Redfall.CastleStart then
        return false
      end
      for i = 1, #MAIN_HERO_TABLE, 1 do
        if MAIN_HERO_TABLE[i].bgm == "Music.Redfall.CrimsythCastleIntro" then
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Redfall.CrimsythCastleIntro"})
        end
      end

    return 119
  end)
end

function Redfall:CastleMusic()
  Timers:CreateTimer(4.95, function()
    for i = 1, #MAIN_HERO_TABLE, 1 do
      MAIN_HERO_TABLE[i].bgm ="Music.Redfall.CrimsythCastle"
    end
  end)
  Timers:CreateTimer(5, function()
    -- EmitSoundOnLocationWithCaster(Vector(-14976, -15296), "Music.Redfall.Village", Events.GameMaster)
    -- EmitSoundOnLocationWithCaster(Vector(-12864, -14848), "Music.Redfall.Village", Events.GameMaster)
      if not Redfall.FinalBossStart then
        for i = 1, #MAIN_HERO_TABLE, 1 do
          if MAIN_HERO_TABLE[i].bgm == "Music.Redfall.CrimsythCastle" then
            CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
            CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Redfall.CrimsythCastle"})
          end
        end
      end

    return 149
  end)

end

function Redfall:SpawnFirstSetOfCrimsythCastleMobs()
  local positionTable = {Vector(11968, 14784), Vector(11945, 15104), Vector(12736, 14784), Vector(12864, 15168), Vector(11264, 15168), Vector(11328, 14912), Vector(11200, 14656)}
  local lookToPoint = Vector(13824, 14592)
  for i = 1, #positionTable, 1 do
    local fv = ((lookToPoint-positionTable[i])*Vector(1,1,0)):Normalized()
    Redfall:SpawnDragonkin(positionTable[i], fv)
  end
  for i = 1, 3, 1 do
     local bandit = Redfall:SpawnHellBandit(Vector(10688, 14848)+RandomVector(100), Vector(1,0))
     Redfall:AddPatrolArguments(bandit, 50, 6, 60, {Vector(13824, 14784), Vector(10688, 14848)})
  end

  Timers:CreateTimer(4, function()
    local positionTable = {Vector(9664, 14336), Vector(10176, 14144), Vector(9600, 13760), Vector(9920, 13696), Vector(10176, 13504), Vector(9792, 13376), Vector(10624, 12864), Vector(10496, 12608), Vector(9536, 12480), Vector(9728, 12416), Vector(9536, 12160)}
    local lookToPoint = Vector(10432, 14912)
    for i = 1, #positionTable, 1 do
      local fv = ((lookToPoint-positionTable[i])*Vector(1,1,0)):Normalized()
      Redfall:SpawnAutumnMonster(positionTable[i], fv)
    end
    for i = 1, 3, 1 do
       local bandit = Redfall:SpawnHellBandit(Vector(10112, 12352)+RandomVector(100), Vector(1,0))
       Redfall:AddPatrolArguments(bandit, 50, 6, 60, {Vector(10432, 14912), Vector(10112, 12352)})
    end
  end)
  Redfall:SpawnSnarlRootTreant(Vector(10048, 15040), Vector(1,-1))
  Timers:CreateTimer(7, function()
    local positionTable = {Vector(10176, 12288), Vector(8960, 12736), Vector(8704, 13120), Vector(8704, 13760), Vector(8384, 13504), Vector(8567, 12544)}
    local lookToPoint = Vector(9728, 13696)
    for i = 1, #positionTable, 1 do
      local fv = ((lookToPoint-positionTable[i])*Vector(1,1,0)):Normalized()
      Redfall:SpawnCrimsythBombadier(positionTable[i], fv)
    end
    for i = 1, 2, 1 do
       local bandit = Redfall:SpawnHellBandit(Vector(9088, 13312)+RandomVector(100), Vector(1,0))
       Redfall:AddPatrolArguments(bandit, 50, 6, 60, {Vector(7424, 13248), Vector(9088, 13312)})
    end
  end)

  Timers:CreateTimer(12, function()
    local positionTable = {Vector(5888, 12992), Vector(4352, 12672), Vector(5568, 14336), Vector(2944, 14464)}
    for i = 1, #positionTable, 1 do
      Redfall:SpawnCrimsythBombadierRooted(positionTable[i], RandomVector(1))
    end
    if GameState:GetDifficultyFactor() >= 2 then
      local positionTable = {Vector(6336, 12864), Vector(3904, 12928), Vector(5248, 14784), Vector(2688, 14784)}
      for i = 1, #positionTable, 1 do
        Redfall:SpawnCrimsythBombadierRooted(positionTable[i], RandomVector(1))
      end
    end
    Redfall:SpawnSnarlRootTreant(Vector(6016, 13952), Vector(-1,-1))
    for i = 1, 2, 1 do
       local bandit = Redfall:SpawnSnarlRootTreant(Vector(4085, 14670)+RandomVector(200), Vector(1,0))
       Redfall:AddPatrolArguments(bandit, 50, 6, 180, {Vector(5312, 13625), Vector(4083, 13626), Vector(4085, 14670)})
    end
    Redfall:SpawnSnarlRootTreant(Vector(2176, 15168), Vector(0,-1))
    Redfall:SpawnSnarlRootTreant(Vector(4544, 15040), Vector(-0.4,-1))
  end)
  Timers:CreateTimer(14, function()
    for i = 0, 3, 1 do
      for j = 0, 2, 1 do
        Timers:CreateTimer(j*0.27 + i*0.11, function()
          Redfall:SpawnHawkSoldier(Vector(5037+(i*120), 12352+(j*120)), Vector(0,1))
        end)
      end
    end
    for k = 1, 5, 1 do
       Timers:CreateTimer(k*0.3, function()
         local bandit = Redfall:SpawnHawkSoldier(Vector(4096, 13504)+RandomVector(200), Vector(1,0))
         Redfall:AddPatrolArguments(bandit, 60, 6, 180, {Vector(5312, 13625), Vector(4083, 13626), Vector(4085, 14670)})
        end)
    end
  end)
  Timers:CreateTimer(16, function()
    local positionTable = {Vector(3648, 14272), Vector(4480, 14144), Vector(4736, 14016), Vector(3584, 13440)}
    local lookToPoint = Vector(4124, 13679)
    for i = 1, #positionTable, 1 do
      local fv = ((lookToPoint-positionTable[i])*Vector(1,1,0)):Normalized()
      Redfall:SpawnAutumnMonster(positionTable[i], fv)
    end
  end)

  Timers:CreateTimer(2, function()
    Redfall.CastleSorceress = Redfall:SpawnSorceress(Vector(1664, 13696), Vector(0,-1))
  end)
end

function Redfall:SpawnDragonkin(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_dragonkin", position, 1, 2, "Redfall.Dragonkin.Aggro", fv, false)
  stone.itemLevel = 96
  Events:AdjustBossPower(stone, 3, 3, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnHellBandit(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_hell_bandit", position, 1, 2, "Redfall.HellBandit.Aggro", fv, false)
  stone.itemLevel = 96
  stone:SetRenderColor(255, 60, 60)
  Events:AdjustBossPower(stone, 1, 1, false)
  Redfall:ColorWearables(stone, Vector(255, 60, 60))
  stone.dominion = true
  return stone
end

function Redfall:SpawnAutumnMonster(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_autumn_monster", position, 1, 3, "Redfall.AutumnMonster.Aggro", fv, false)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 80, 80)
  stone.targetRadius = 800
  stone.autoAbilityCD = 1
  Events:AdjustBossPower(stone, 5, 5, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsythBombadier(position, fv)
  local stone = Redfall:SpawnDungeonUnit("crimsyth_bombadier", position, 1, 3, "Redfall.Bombadier.Aggro", fv, false)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 80, 80)
  Redfall:ColorWearables(stone, Vector(255, 60, 60))
  Events:SetPositionCastArgs(stone, 1200, 0, 1, FIND_ANY_ORDER)
  Events:AdjustBossPower(stone, 1, 1, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsythBombadierRooted(position, fv)
  local stone = Redfall:SpawnDungeonUnit("crimsyth_bombadier_rooted", position, 1, 3, nil, fv, true)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 90, 90)
  Redfall:ColorWearables(stone, Vector(255, 90, 90))
  Events:SetPositionCastArgs(stone, 1550, 0, 1, FIND_ANY_ORDER)
  Events:AdjustBossPower(stone, 2, 2, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnSnarlRootTreant(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_snarlroot_treant", position, 1, 3, "Redfall.SnarlRoot.Aggro", fv, false)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 120, 120)
  Redfall:ColorWearables(stone, Vector(255, 120, 120))
  Events:AdjustBossPower(stone, 4, 4, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnHawkSoldier(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_hawk_soldier", position, 1, 1, "Redfall.HawkSoldier.Aggro", fv, false)
  stone.itemLevel = 100
  stone:SetRenderColor(255, 170, 170)
  Redfall:ColorWearables(stone, Vector(255, 170, 170))
  stone.dominion = true
  return stone
end


function Redfall:SpawnHawkSoldierAggro(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_hawk_soldier", position, 1, 1, "Redfall.HawkSoldier.Aggro", fv, true)
  stone.itemLevel = 100
  stone:SetRenderColor(255, 170, 170)
  Redfall:ColorWearables(stone, Vector(255, 170, 170))
  stone.dominion = true
  return stone
end

function Redfall:SpawnHawkSoldierElite(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_hawk_soldier_elite", position, 1, 3, "Redfall.HawkSoldierElite.Aggro", fv, false)
  stone.itemLevel = 110
  stone:SetRenderColor(140, 140, 140)
  Redfall:ColorWearables(stone, Vector(140, 140, 140))
  stone.targetRadius = 600
  stone.minRadius = 0
  stone.targetAbilityCD = 1
  stone.targetFindOrder = FIND_CLOSEST
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsythShadow(position, fv, bAggro)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_shadow", position, 1, 3, "Redfall.CrimsythShadow.Aggro", fv, bAggro)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 80, 80)
  Redfall:ColorWearables(stone, Vector(255, 140, 140))
  stone.targetRadius = 800
  stone.autoAbilityCD = 1
  Events:AdjustBossPower(stone, 1, 1, false)
  stone.dominion = true
  return stone
end



function Redfall:SpawnSorceress(position, fv)
  local stone = Redfall:SpawnDungeonUnit("crimsyth_sorceress", position, 4, 6, nil, fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(255, 50, 50)
  local ability = stone:FindAbilityByName("redfall_crimsyth_sorceress_ai")
  ability:ApplyDataDrivenModifier(stone, stone, "modifier_crymsith_sorceress_waiting", {})
  Events:AdjustBossPower(stone, 12, 12, false)
  stone.dominion = true
  stone:RemoveModifierByName("modifier_paragon_springy")
  return stone
end

function Redfall:CreateLavaBlast(position)
      particleName = "particles/addons_gameplay/pit_lava_blast.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, position )
      ParticleManager:SetParticleControl( particle1, 1, position )
      Timers:CreateTimer(10, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
  
end

function Redfall:SpawnOutsideCastleWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CastleSpawner.Spawn", Redfall.RedfallMaster)
    end
      local luck = RandomInt(1, 222)
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
      local sorcAbility = Redfall.CastleSorceress:FindAbilityByName("redfall_crimsyth_sorceress_ai")
      if IsValidEntity(unit) then
        unit.itemLevel = itemLevel
        unit.dominion = true
        sorcAbility:ApplyDataDrivenModifier(Redfall.CastleSorceress, unit, "modifier_sorceress_wave_unit", {})
        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", unit, 2)
        unit.aggro = true
        if unit:GetUnitName() == "redfall_autumn_monster" then
          unit:SetRenderColor(255, 60, 60)
          unit.targetRadius = 800
          unit.autoAbilityCD = 1
        elseif unit:GetUnitName() == "redfall_castle_archer" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
        elseif unit:GetUnitName() == "crimsyth_bombadier" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
          Events:SetPositionCastArgs(unit, 1200, 0, 1, FIND_ANY_ORDER)
        elseif unit:GetUnitName() == "redfall_snarlroot_treant" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
        elseif unit:GetUnitName() == "phoenix_siege_dragon" then
          unit:SetRenderColor(255, 60, 60)
        end
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].itemLevel = itemLevel
          unit[i].dominion = true
          sorcAbility:ApplyDataDrivenModifier(Redfall.CastleSorceress, unit[i], "modifier_sorceress_wave_unit", {})
          unit[i]:SetAcquisitionRange(3000)
          CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", unit[i], 2)
          if unit[i]:GetUnitName() == "redfall_autumn_monster" then
            unit[i].targetRadius = 800
            unit[i].autoAbilityCD = 1
          elseif unit[i]:GetUnitName() == "crimsyth_bombadier" then
            Events:SetPositionCastArgs(unit[i], 1200, 0, 1, FIND_ANY_ORDER)
          end
        end
      end
    end)
  end
end

function Redfall:InitiateCrimsythCastle()
  Redfall.CastleStart = true
  Redfall.Castle = {}
  Redfall:CastleMusic()
  Dungeons.respawnPoint = Vector(5376, 12096)
  local positionTable = {Vector(4759, 9948), Vector(5120, 9728), Vector(5568, 9728), Vector(5950, 9984)}
  for i = 1, #positionTable, 1 do
    Timers:CreateTimer(i*0.3, function()
      Redfall:SpawnHawkSoldierElite(positionTable[i], Vector(0,1))
    end)
  end
  Redfall:SpawnCrimsythShadow(Vector(4736, 9152), Vector(0,1), false)
  Redfall:SpawnCrimsythShadow(Vector(5945, 9152), Vector(0,1), false)
  Redfall:SpawnPropSword()
  Redfall:PrepareLavaRoom()

  Redfall.Castle.Switch1 = Entities:FindByNameNearest("CastleSwitch1", Vector(5967, 9206, 215+Redfall.ZFLOAT), 750)
  Redfall.Castle.Switch1:SetAbsOrigin(Redfall.Castle.Switch1:GetAbsOrigin()+Vector(0,0,-500))

  Redfall.Castle.Switch2 = Entities:FindByNameNearest("CastleSwitch1a", Vector(4740, 9195, 214+Redfall.ZFLOAT), 750)
  Redfall.Castle.Switch2:SetAbsOrigin(Redfall.Castle.Switch2:GetAbsOrigin()+Vector(0,0,-500))

  Redfall:InitiateCastleTiles()

end

function Redfall:PrepareLavaRoom()
  Redfall.Castle.LavaFlood = Entities:FindByNameNearest("CastleFloodLava", Vector(7680, 8558, -44+Redfall.ZFLOAT), 1000)
  Redfall.Castle.LavaFlood:SetAbsOrigin(Redfall.Castle.LavaFlood:GetAbsOrigin()+Vector(0,0,97))
end

function Redfall:DropCastleSwtich(switch, index)
  switch:SetAbsOrigin(switch:GetAbsOrigin()+Vector(0,0,1485+500))
  if index == 0 then
    Redfall.Castle.switchfallVelocity1 = 0
  elseif index == 1 then
    Redfall.Castle.switchfallVelocity2 = 0
  end
  for i = 1, 54, 1 do
    Timers:CreateTimer(i*0.03, function()
      if index == 0 then
        Redfall.Castle.switchfallVelocity1 = Redfall.Castle.switchfallVelocity1 + 1
        switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,Redfall.Castle.switchfallVelocity1))
      elseif index == 1 then
        Redfall.Castle.switchfallVelocity2 = Redfall.Castle.switchfallVelocity2 + 1
        switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,Redfall.Castle.switchfallVelocity2))
      end
    end)
  end
  Timers:CreateTimer(1.6, function()
      local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
      local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
      ParticleManager:SetParticleControl(particle1,0,switch:GetAbsOrigin())
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
      EmitSoundOnLocationWithCaster(switch:GetAbsOrigin(), "Redfall.SwitchImpact", Events.GameMaster)
  end)
end

function Redfall:SpawnPropSword()
    local shield = CreateUnitByName("npc_dummy_unit", Vector(5773, 8652, 325+Redfall.ZFLOAT), false, nil, nil, DOTA_TEAM_NEUTRALS)
    shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    shield:SetOriginalModel("models/crimsyth_castle_sword.vmdl")
    shield:SetModel("models/crimsyth_castle_sword.vmdl")
    shield:SetAbsOrigin(Vector(5773, 8652, 325+Redfall.ZFLOAT))
    shield:AddAbility("redfall_attackable_prop_ability"):SetLevel(1)
    shield:RemoveAbility("dummy_unit")
    shield:RemoveModifierByName("dummy_unit")
    shield.basePosition = Vector(5773, 8652, 325+Redfall.ZFLOAT)
    shield.jumpLock = true
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(5773, 8652, 455+Redfall.ZFLOAT), 500, 99999, false)
end

function Redfall:CastleInitiateLavaRoom()
  Redfall:SpawnCastleWarflayer(Vector(7104, 10123), Vector(0,-1))
  Redfall.Castle.LavaRoomJumpTable = {false, false, false}
  Redfall.Castle.PlatformKillTable = {0,0,0}
  Timers:CreateTimer(1, function()
    local flayer1 = Redfall:SpawnCastleWarflayer(Vector(8256, 10432), Vector(-1,0))
    local flayer2 = Redfall:SpawnCastleWarflayer(Vector(8256, 10176), Vector(-1,0))

    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer1, "modifier_redfall_castle_lava_room_unit", {})
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer2, "modifier_redfall_castle_lava_room_unit", {})

    flayer1.platformIndex = 1
    flayer2.platformIndex = 1
  end)
  Timers:CreateTimer(3, function()
    local flayer1 = Redfall:SpawnCastleWarflayer(Vector(8192, 9216), Vector(0,1))
    local flayer2 = Redfall:SpawnCastleWarflayer(Vector(8576, 9216), Vector(0,1))
    local flayer3 = Redfall:SpawnCastleWarflayer(Vector(8358, 8768), Vector(0,1))

    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer1, "modifier_redfall_castle_lava_room_unit", {})
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer2, "modifier_redfall_castle_lava_room_unit", {})
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer3, "modifier_redfall_castle_lava_room_unit", {})

    flayer1.platformIndex = 2
    flayer2.platformIndex = 2
    flayer3.platformIndex = 2
    if GameState:GetDifficultyFactor() == 3 then
      Redfall:SpawnCrimsythBombadierRooted(Vector(8448, 8832), Vector(0,1))
    end
  end)
  Timers:CreateTimer(5, function()
    local flayer1 = Redfall:SpawnCrimsythBombadierRooted(Vector(8220,7210), Vector(0,1))
    local flayer2 = Redfall:SpawnCrimsythBombadierRooted(Vector(8512, 7217), Vector(0,1))
    local flayer3 = Redfall:SpawnCastleWarflayer(Vector(8256, 6720), Vector(0,1))
    local flayer4 = Redfall:SpawnCastleWarflayer(Vector(8512, 6713), Vector(0,1))

    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer1, "modifier_redfall_castle_lava_room_unit", {})
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer2, "modifier_redfall_castle_lava_room_unit", {})
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer3, "modifier_redfall_castle_lava_room_unit", {})
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flayer4, "modifier_redfall_castle_lava_room_unit", {})

    flayer1.platformIndex = 3
    flayer2.platformIndex = 3
    flayer3.platformIndex = 3
    flayer4.platformIndex = 3
  end)
  Timers:CreateTimer(7, function()
    Redfall:SpawnCrimsythShadow(Vector(7232, 7104), Vector(1,0), false)
    Redfall:SpawnCrimsythShadow(Vector(7360, 6848), Vector(1,0), false)
  end)
end

function Redfall:SpawnCastleWarflayer(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_warflayer", position, 1, 3, "Redfall.Warflayer.Aggro", fv, false)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 130, 130)
  Redfall:ColorWearables(stone, Vector(255, 130, 130))
  Events:AdjustBossPower(stone, 3, 3, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCastleLavaLizard(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_lava_lizard", position, 1, 1, "Redfall.LavaLizard.Aggro", fv, false)
  stone.itemLevel = 105
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsythGunman(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_gunman", position, 1, 2, "Redfall.CastleGunman.Aggro", fv, false)
  stone.itemLevel = 114
  stone:SetRenderColor(255, 100, 100)
  Redfall:ColorWearables(stone, Vector(255, 20, 20))
  Events:AdjustBossPower(stone, 5, 5, false)
  stone.dominion = true
  return stone
end



function Redfall:SpawnCrimsythGunmanElite(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_gunman_elite", position, 1, 4, "Redfall.CastleGunmanElite.Aggro", fv, false)
  stone.itemLevel = 118
  stone:SetRenderColor(255, 100, 100)
  Redfall:ColorWearables(stone, Vector(255, 20, 20))
  Events:SetPositionCastArgs(stone, 1400, 0, 1, FIND_ANY_ORDER)
  Events:AdjustBossPower(stone, 9, 9, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsythKhanKnight(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_khan_knight", position, 1, 2, "Redfall.KhanKnight.Aggro", fv, false)
  stone.itemLevel = 116
  stone:SetRenderColor(255, 100, 100)
  Redfall:ColorWearables(stone, Vector(255, 20, 20))
  Events:AdjustBossPower(stone, 5, 5, false)
  stone.dominion = true
  return stone
end


function Redfall:SpawnTongeyKong(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_tongey_kong", position, 2, 3, "Redfall.TongeyKong.Aggro", fv, false)
  stone.itemLevel = 114
  stone:SetRenderColor(255, 100, 100)
  Redfall:ColorWearables(stone, Vector(255, 20, 20))
  Events:AdjustBossPower(stone, 4, 4, false)
  stone.dominion = true
  return stone
end

function Redfall:InitializeMazeBattlementsRoom()
  Redfall:SpawnCastleWarflayer(Vector(8991, 9533), Vector(0,-1))
  Redfall:SpawnHawkSoldierElite(Vector(9107, 9277), Vector(0,-1))
  Redfall:SpawnHawkSoldierElite(Vector(8872, 9277), Vector(0,-1))

  Redfall:SpawnCrimsythGunman(Vector(9868, 8929), Vector(-1,0))
  Redfall:SpawnCrimsythGunman(Vector(9868, 9149), Vector(-1,0))
  Redfall:SpawnCrimsythGunman(Vector(9868, 9390), Vector(-1,0))
end

function Redfall:InitializeMazeBattlementsRoom2()
  Redfall:SpawnTongeyKong(Vector(9258, 10320), Vector(1,0))
  Redfall:SpawnTongeyKong(Vector(10410, 9905), Vector(0,-1))
  Redfall:SpawnCastleWarflayer(Vector(10409, 10389), Vector(0,-1))
  

  Redfall:SpawnCrimsythGunman(Vector(10304, 10816), Vector(-1,0))
  Redfall:SpawnCrimsythGunman(Vector(10496, 10752), Vector(-1,0))
  Redfall:SpawnCrimsythGunman(Vector(10368, 10944), Vector(-1,0))

  Redfall:SpawnTongeyKong(Vector(10048, 10816), Vector(-1,0))
end

function Redfall:InitializeMazeBattlementsRoom3()
  Redfall:SpawnCastleWarflayer(Vector(10304, 8448), Vector(-1,0))
  for i = 1, 6, 1 do
    for j = 1, 3, 1 do
      if j <= i then
        Redfall:SpawnEnclaveViking(Vector(9664+((i-1)*192), 8256-((j-1)*192)), Vector(0,1))
      end
    end
  end
  Timers:CreateTimer(2, function()
    local fv = (Vector(11680, 8661) - Vector(10949, 8881)):Normalized()
    Redfall:SpawnTongeyKong(Vector(10949, 8881), fv)
  end)
  Timers:CreateTimer(8, function()
    local gunmanTable = {Vector(11136, 9856), Vector(11328, 10081), Vector(11008, 10176)}
    for i = 1, #gunmanTable, 1 do
      local fv = (Vector(11072, 9664) - gunmanTable[i]):Normalized()
    local gunmanElite = Redfall:SpawnCrimsythGunmanElite(gunmanTable[i], fv)
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, gunmanElite, "modifier_castle_unit_generic", {})
    gunmanElite.code = 1
    if GameState:GetDifficultyFactor() == 3 then
      Redfall:SpawnCastleWarflayer(Vector(11479, 10304), Vector(0,-1))
    end
    end
  end)
end

function Redfall:SpawnEnclaveViking(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_enclave_viking", position, 1, 1, "Redfall.EnclaveViking.Aggro", fv, false)
  stone.itemLevel = 114
  stone:SetRenderColor(255, 100, 100)
  Redfall:ColorWearables(stone, Vector(255, 20, 20))
  stone.dominion = true
  return stone
end

function Redfall:InitializeCastleTortureRoom()
  local tortureBoss = Redfall:SpawnDungeonUnit("redfall_erakor_the_sadist", Vector(10304, 7015), 4, 6, nil, Vector(-1,0), false)
  tortureBoss.itemLevel = 125
  tortureBoss:SetRenderColor(255, 40, 40)
  Redfall:ColorWearables(tortureBoss, Vector(255, 160, 160))
  Redfall.Castle.tortureBoss = tortureBoss
  tortureBoss.ability = tortureBoss:FindAbilityByName("redfall_erakor_the_sadist_passive")
  tortureBoss.ability:ApplyDataDrivenModifier(tortureBoss, tortureBoss, "modifier_sadist_waiting", {})

  Redfall:SpawnTorturePuppet(Vector(9664, 7168), Vector(-1,0))
  Redfall:SpawnTorturePuppet(Vector(9664, 6848), Vector(-1,0))
  if GameState:GetDifficultyFactor() > 1 then
    Redfall:SpawnTorturePuppet(Vector(9984, 7168), Vector(-1,0))
    Redfall:SpawnTorturePuppet(Vector(9984, 6848), Vector(-1,0))
  end
  Redfall:SpawnTorturePuppet(Vector(10432, 6412), Vector(-0.5,1))
  Redfall:SpawnTorturePuppet(Vector(10832, 6601), Vector(-1,1))
end

function Redfall:SpawnTorturePuppet(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_torture_puppet", position, 1, 3, "Redfall.TorturePuppet.Aggro", fv, false)
  stone.itemLevel = 110
  stone:SetRenderColor(168, 40, 40)
  Events:SetPositionCastArgs(stone, 1180, 0, 1, FIND_ANY_ORDER)
  Events:AdjustBossPower(stone, 3, 3, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnTortureWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.TortureWaveUnit.Spawn", Redfall.RedfallMaster)
    end
      local luck = RandomInt(1, 222)
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
        unit.itemLevel = itemLevel
        unit.code = 2
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_castle_unit_generic", {})
        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", unit, 2)
        unit.aggro = true
        if unit:GetUnitName() == "redfall_crimsyth_corrupted_corpse" then
          unit:SetRenderColor(255, 60, 60)
        elseif unit:GetUnitName() == "redfall_tortured_soul" then
          unit:SetRenderColor(255, 90, 90)
          Redfall:ColorWearables(unit, Vector(255, 90, 90))
        elseif unit:GetUnitName() == "redfall_crimsyth_khan_knight" then
          unit:SetRenderColor(255, 100, 100)
          Redfall:ColorWearables(unit, Vector(255, 20, 20))
        elseif unit:GetUnitName() == "redfall_crimsyth_cultist_elite" then
          unit:SetRenderColor(255, 100, 100)
          Redfall:ColorWearables(unit, Vector(255, 20, 20))
        end
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].dominion = true
          unit[i].itemLevel = itemLevel
          Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit[i], "modifier_castle_unit_generic", {})
          unit[i]:SetAcquisitionRange(3000)
          unit[i].code = 2
          CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", unit[i], 2)

        end
      end
    end)
  end
end

function Redfall:CreateGooBlast(position)
      particleName = "particles/addons_gameplay/pit_goo_blast_blast.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, position )
      ParticleManager:SetParticleControl( particle1, 1, position )
      Timers:CreateTimer(8, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
  
end

function Redfall:InitializeArchivistRoom()
  local archivist = Redfall:SpawnArchivistBoss(Vector(8114, 6144), Vector(-1,1))
  Redfall.Castle.archivistBoss = archivist
  archivist.ability = archivist:FindAbilityByName("redfall_the_archivist_passive")
  archivist.ability:ApplyDataDrivenModifier(archivist, archivist, "modifier_the_archivist_waiting", {})
end

function Redfall:SpawnArchivistBoss(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_the_archivist", position, 4, 6, nil, fv, false)
  stone.itemLevel = 140
  stone:SetRenderColor(168, 70, 70)
  Events:AdjustBossPower(stone, 10, 10, false)
  return stone
end

function Redfall:SpawnArchivistDemonMoloth(position, fv)
  local stone = Redfall:SpawnDungeonUnit("archivist_demon_moloth", position, 4, 6, nil, fv, false)
  stone.itemLevel = 140
  stone:SetRenderColor(168, 70, 70)
  Events:AdjustBossPower(stone, 10, 10, false)
  return stone
end

function Redfall:SpawnMolothSphere(baseFV)
  local centerPoint = Vector(8816, 5467)
  local sphere = CreateUnitByName( "dummy_unit_vulnerable_with_animations", centerPoint+baseFV*900, false, nil, nil, DOTA_TEAM_NEUTRALS)
  sphere:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
  sphere:SetOriginalModel("models/boss_sphere.vmdl")
  sphere:SetModel("models/boss_sphere.vmdl")
  sphere.jumpLock = true
  sphere:SetRenderColor(0, 0, 0)
  sphere.colorCode = 0
  sphere:AddAbility("redfall_moloth_sphere_ability"):SetLevel(1)  
  sphere.baseFV = baseFV
  CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", sphere, 2)
  return sphere
end

function Redfall:InitCastleNextFirstRoom()
  Redfall.Castle.RockGolemsFound = 0
  Redfall.Castle.RocksUp = 12
  Redfall.Castle.StalagmitesExploded = 0
  local positionTable = {Vector(3200, 9216), Vector(3195, 8850), Vector(2816, 8850), Vector(2816, 9216)}
  for i = 1, #positionTable, 1 do
    Redfall:SpawnCrimsythThug(positionTable[i], Vector(1,0))
  end
  for i = 0, 4, 1 do
    Redfall:SpawnAutumnMonster(Vector(1536+(i*380), 8384), Vector(1,0))
  end
  Timers:CreateTimer(2, function()
    Redfall:SpawnCrimsythKnight(Vector(1984, 9216), Vector(1,0), false)
    Redfall:SpawnCrimsythKnight(Vector(1984, 8896), Vector(1,0), false)
  end)
  Timers:CreateTimer(4, function()
    Redfall:SpawnCrimsythBombadierRooted(Vector(2752, 7744), Vector(0,1))
    if GameState:GetDifficultyFactor() > 2 then
      Redfall:SpawnCrimsythBombadierRooted(Vector(2240, 7744), Vector(0,1))
    end
  end)
  local turtle = CreateUnitByName("redfall_exploding_turtle", Vector(3200, 9856), true, nil, nil, DOTA_TEAM_NEUTRALS)
  turtle.jumpLock = true
  Redfall.Castle.FireTurtle = turtle
end

function Redfall:SpawnCrimsythThug(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_thug", position, 1, 2, "Redfall.CrimsythThug.Aggro", fv, false)
  stone.itemLevel = 114
  Redfall:ColorWearables(stone, Vector(150, 20, 20))
  Events:AdjustBossPower(stone, 6, 6, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnGardenOverlord(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_garden_overlord", position, 3, 4, "Redfall.CrimsythThug.Aggro", fv, false)
  stone.itemLevel = 114
  stone:SetRenderColor(80, 30, 30)
  local properties =  {
    roll = 0,
    pitch = -10,
    yaw = 0,
    XPos = 25,
    YPos = 0,
    ZPos = -100,
  }
  Attachments:AttachProp(stone, "head", "models/items/chaos_knight/face_of_entropy/face_of_entropy.vmdl", 2.0, properties)
  Events:AdjustBossPower(stone, 12, 12, false)
  return stone
end

function Redfall:SpawnMiniGolem(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_mini_golem", position, 0, 0, nil, fv, true)
  stone.itemLevel = 114
  stone.dominion = true
  return stone
end

function Redfall:SpawnBigGolem(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_big_golem", position, 2, 4, nil, fv, true)
  stone:SetRenderColor(220, 80, 80)
  stone.itemLevel = 114
  Events:AdjustBossPower(stone, 2, 2, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsonSamurai(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimson_samurai", position, 1, 3, "Redfall.CrimsonSamurai.Aggro", fv, false)
  stone:SetRenderColor(220, 110, 110)
  stone.itemLevel = 124
  Events:AdjustBossPower(stone, 4, 4, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsonWarrior(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimson_warrior", position, 1, 1, "Redfall.CrimsonWarrior.Aggro", fv, false)
  stone:SetRenderColor(200, 150, 150)
  stone.itemLevel = 114
  stone.dominion = true
  return stone
end



function Redfall:WaterPlatformRoom()

  Redfall.Castle.WaterPlatformColorTable = {}
  
  local positionTable = {Vector(-1893, 10216), Vector (-1963, 8875), Vector(-646, 10052), Vector(-768, 8906), Vector(634, 10043), Vector(634, 8855)}
  for i = 1, #positionTable, 1 do
    local color = "red"
    local colorVector = Vector(185, 136, 136)
    local platform = Entities:FindByNameNearest("CastlePuzzlePlatform", positionTable[i] + Vector(0,0,22+Redfall.ZFLOAT), 600)
    local random = RandomInt(1, 3)
    if random == 2 then
      color = "blue"
      colorVector = Vector(112, 128, 238)
    elseif random == 3 then
      color = "yellow"
      colorVector = Vector(212, 203, 78)
    end
    platform:SetRenderColor(colorVector.x, colorVector.y, colorVector.z)
    table.insert(Redfall.Castle.WaterPlatformColorTable, color)
  end
  Redfall:SpawnCrimsonSamurai(Vector(-61, 9999), Vector(1,0))
  Redfall:SpawnCrimsonSamurai(Vector(592, 9353), Vector(0,1))
  Redfall:SpawnCrimsonSamurai(Vector(-64, 8926), Vector(1,0))
  Redfall:SpawnCrimsonSamurai(Vector(-1279, 8917), Vector(1,0))
  Redfall:SpawnCrimsonSamurai(Vector(-1152, 10048), Vector(1,0))
  DeepPrintTable(Redfall.Castle.WaterPlatformColorTable)
  Timers:CreateTimer(2, function()
    local basePosition = Vector(448, 9664)
    for i = 1, 3, 1 do
      for j = 1, 4, 1 do
        Redfall:SpawnCrimsonWarrior(basePosition+Vector((i-1)*196, (j-1)*196), Vector(1,0))
      end
    end
  end)
  Timers:CreateTimer(3, function()
    local basePosition = Vector(-1024, 8768)
    for i = 1, 4, 1 do
      for j = 1, 3, 1 do
        Redfall:SpawnCrimsonWarrior(basePosition+Vector((i-1)*128, (j-1)*128), Vector(1,0))
      end
    end
  end)
  Timers:CreateTimer(5, function()
    local basePosition = Vector(-832, 9920)
    for i = 1, 3, 1 do
      for j = 1, 2, 1 do
        Redfall:SpawnCrimsonWarrior(basePosition+Vector((i-1)*196, (j-1)*196), Vector(1,0))
      end
    end
  end)
  Timers:CreateTimer(7, function()
    Redfall:SpawnCrimsythKhanKnight(Vector(512,8960), Vector(0,1))
    Redfall:SpawnCrimsythKhanKnight(Vector(-1920,8896), Vector(1,0))
    Redfall:SpawnCastleWarflayer(Vector(-2112,8832), Vector(1,0))
    if GameState:GetDifficultyFactor() > 2 then
      Redfall:SpawnCastleWarflayer(Vector(-2112,9088), Vector(1,0))
    end
    Redfall:SpawnCrimsonShadowDancer(Vector(-1920, 10432), Vector(1,-1))
    Redfall:SpawnCrimsonShadowDancer(Vector(-2048, 10112), Vector(1,0))
    Redfall:SpawnCrimsonShadowDancer(Vector(-1664, 10112), Vector(1,0))
  end)
  Timers:CreateTimer(8, function()
    Redfall.Castle.SwitchTable = {}
    local switchPosTable = {Vector(-2278, 11122), Vector(-2278, 10944), Vector(-2099, 11122), Vector(-2099, 10944), Vector(-1920, 11122), Vector(-1920, 10944)}
    for i = 1, #switchPosTable, 1 do
      local thinker = CreateUnitByName("dungeon_thinker", switchPosTable[i], false, nil, nil, DOTA_TEAM_NEUTRALS)  
      thinker:SetOriginalModel("models/props_structures/ancient_trigger001.vmdl")
      thinker:SetModel("models/props_structures/ancient_trigger001.vmdl")
      thinker.index = i
      thinker.color = "black"
      thinker.enabled = true
      thinker:SetModelScale(0.6)
      thinker:RemoveAbility("dungeon_thinker")
      thinker:RemoveModifierByName("modifier_dungeon_thinker")
      thinker.name = "crimsythCastleSwitch"
      thinker:AddAbility("dungeon_thinker2")
      thinker:FindAbilityByName("dungeon_thinker2"):SetLevel(1)
      thinker:FindAbilityByName("dungeon_thinker2"):ApplyDataDrivenModifier(thinker, thinker, "modifier_dungeon_thinker2", {})
      table.insert(Redfall.Castle.SwitchTable, thinker)
    end
  end)
  Timers:CreateTimer(10, function()
    Redfall:SpawnCrimsonShadowDancer(Vector(-1600, 11200), Vector(0,-1))
    Redfall:SpawnCrimsonShadowDancer(Vector(-1344, 11200), Vector(0,-1))
    Redfall:SpawnCrimsonSamurai(Vector(-832, 11200), Vector(0,-1))
    if GameState:GetDifficultyFactor() > 2 then
      Redfall:SpawnCrimsonShadowDancer(Vector(-832, 11200), Vector(0,-1))
    end
    local flood = Redfall:SpawnCrimsonFlood(Vector(-1487, 13120), Vector(0,-1))
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, flood, "modifier_castle_unit_generic", {})
    flood.code = 5
  end)
end

function Redfall:CastleWaterRoomSwitch(caster)
  if caster.enabled then
    caster.enabled = false
    StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1.0})
    if caster.color == "black" or caster.color == "blue" then
      caster.color = "red"
      caster:SetRenderColor(185, 136, 136)
    elseif caster.color == "red" then
      caster.color = "yellow"
      caster:SetRenderColor(212, 203, 78) 
    elseif caster.color == "yellow" then
      caster.color = "blue"
      caster:SetRenderColor(112, 128, 238)
    end
    EmitSoundOn("Redfall.CastleSwitch.Press", caster)
    -- Timers:CreateTimer(1.1, function()
    --   if IsValidEntity(caster) then
    --      StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK2, rate=1.0})
    --   end
    -- end)
    local bPuzzleClear = true
    for i = 1, #Redfall.Castle.WaterPlatformColorTable, 1 do
      if Redfall.Castle.WaterPlatformColorTable[i] == Redfall.Castle.SwitchTable[i].color then
      else
        bPuzzleClear = false
      end
    end
    if bPuzzleClear then
      Redfall.Castle.WaterPuzzleClear = true
      EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Redfall.CastleSwitchPuzzle.Clear", Events.GameMaster)
      for i = 1, #Redfall.Castle.SwitchTable, 1 do
        local switch = Redfall.Castle.SwitchTable[i]
        switch.enabled = false
        switch:SetRenderColor(0, 0, 0)
        for j = 1, 30, 1 do
          Timers:CreateTimer(j*0.03, function()
            switch:SetAbsOrigin(switch:GetAbsOrigin()-Vector(0,0,1.6))
          end)
        end
        Timers:CreateTimer(0.3, function()
          local particleName = "particles/econ/items/pets/pet_frondillo/pet_spawn_dirt_frondillo.vpcf"
          local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
          ParticleManager:SetParticleControl(particle1,0,switch:GetAbsOrigin())
          Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle( particle1, false )
          end)
        end)
        Timers:CreateTimer(1, function()
          UTIL_Remove(switch)
        end)
      end
      Timers:CreateTimer(2, function()
        Redfall:CreateReaverSwitch()
      end)
      local positionTable = {Vector(-1893, 10216), Vector (-1963, 8875), Vector(-646, 10052), Vector(-768, 8906), Vector(634, 10043), Vector(634, 8855)}
      for i = 1, #positionTable, 1 do
        local platform = Entities:FindByNameNearest("CastlePuzzlePlatform", positionTable[i] + Vector(0,0,22+Redfall.ZFLOAT), 600)
        platform:SetRenderColor(80, 80, 80)
      end 
    else
      Timers:CreateTimer(0.2, function()
        caster.enabled = true
      end)
    end
  end
end

function Redfall:CreateReaverSwitch()
    local shield = CreateUnitByName("npc_dummy_unit", Vector(-704, 9472, -138+Redfall.ZFLOAT), false, nil, nil, DOTA_TEAM_NEUTRALS)
    shield:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    shield:SetOriginalModel("models/redfall/reaver_switch_hitbox.vmdl")
    shield:SetModel("models/redfall/reaver_switch_hitbox.vmdl")
    shield:SetAbsOrigin(Vector(-704, 9472, -138+Redfall.ZFLOAT)-Vector(0,0,520))
    shield:SetAngles(0, 270, 0)
    shield.type = "reaver"
    shield.jumpLock = true
    for i = 1, 130, 1 do
      Timers:CreateTimer(i*0.03, function()
        if i%18 == 0 then
          ScreenShake(shield:GetAbsOrigin(), 930, 1.1, 1.1, 9000, 3, true)
          EmitSoundOnLocationWithCaster(shield:GetAbsOrigin(), "Redfall.Shaking", Events.GameMaster)
        end
        shield:SetAbsOrigin(shield:GetAbsOrigin()+Vector(0,0,3.6))
      end)
    end
    Timers:CreateTimer(3.2, function()
        for i = 1, 3, 1 do
          local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
          local position = shield:GetAbsOrigin()
          local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
          ParticleManager:SetParticleControl(pfx, 0, position)
          Timers:CreateTimer(2, function()
             ParticleManager:DestroyParticle(pfx, false)
          end)
        end
    end)
    Timers:CreateTimer(3.9, function()
      EmitSoundOnLocationWithCaster(shield:GetAbsOrigin(), "Redfall.RockCrash", Events.GameMaster)
      shield:AddAbility("redfall_attackable_unit"):SetLevel(1)
      shield:RemoveAbility("dummy_unit")
      shield:RemoveModifierByName("dummy_unit")
    end)
end

function Redfall:SpawnCrimsonShadowDancer(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimson_shadow_dancer", position, 1, 3, "Redfall.CrimsonShadowDancer.Aggro", fv, false)
  stone:SetRenderColor(220, 110, 110)
  Redfall:ColorWearables(stone, Vector(220, 110, 100))
  stone.itemLevel = 124
  Events:AdjustBossPower(stone, 4, 4, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsonFlood(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_crimson_flood", position, 1, 3, "Redfall.CrimsonFlood.Aggro", fv, false)
  stone:SetRenderColor(255, 0, 0)
  Redfall:ColorWearables(stone, Vector(255, 0, 0))
  stone.itemLevel = 124
  Events:AdjustBossPower(stone, 7, 7, false)
  return stone
end

function Redfall:InitializeBluePlatformRoom()
  Redfall:SpawnCrystalHoarder(Vector(-1728, 14528), Vector(0,-1))
  Redfall:SpawnCrystalHoarder(Vector(-1088, 14528), Vector(0,-1))
  Redfall:SpawnCrystalHoarder(Vector(-1548, 14990), Vector(1,0))

  Redfall:SpawnCastleWarflayer(Vector(-1037, 15296), Vector(0,-1))
  Redfall:SpawnCastleWarflayer(Vector(-1280, 15552), Vector(0,-1))

  Redfall:SpawnCrimsonShadowDancer(Vector(-2624, 15680), Vector(1,0))

  Redfall:SpawnCrimsythBombadierRooted(Vector(-2176, 15552), RandomVector(1))

  Redfall:SpawnTongeyKong(Vector(-2496, 14720), Vector(1,0))

  Redfall:SpawnCrystalHoarder(Vector(-3072, 15360), Vector(1,0))

  Timers:CreateTimer(2, function()
    for i = 1, 2, 1 do
      for j = 1, 3, 1 do
        if j <= GameState:GetDifficultyFactor() then
          Redfall:SpawnCrystalHoarder(Vector(-4032, 15360) + Vector((i-1)*196, (j-1)*196), Vector(1,0))
        end
      end
    end
  end)
  Timers:CreateTimer(7, function()
    Redfall:SpawnTongeyKong(Vector(-4046, 14482), Vector(0,1))
    Redfall:SpawnLokiTheMad(Vector(-3264, 13992), Vector(0,1))
    local positionTable = {Vector(-3419, 14208), Vector(-3163, 14208), Vector(-3298, 14240)}
    local lookToPoint = Vector(-3584, 14464)
    for i = 1, #positionTable, 1 do
      local fv = ((lookToPoint-positionTable[i])*Vector(1,1,0)):Normalized()
      Redfall:SpawnCrimsythKhanKnight(positionTable[i], fv)
    end
  end)
end

function Redfall:SpawnCrystalHoarder(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_crystal_hoarder", position, 1, 3, "Redfall.CrystalHoarder.Aggro", fv, false)
  stone:SetRenderColor(220, 110, 110)
  Redfall:ColorWearables(stone, Vector(220, 110, 100))
  stone.itemLevel = 124
  Events:AdjustBossPower(stone, 4, 4, false)

  stone.targetRadius = 400
  stone.minRadius = 0
  stone.targetAbilityCD = 1
  stone.targetFindOrder = FIND_ANY_ORDER

  stone.dominion = true
  return stone
end

function Redfall:SpawnLokiTheMad(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_loki_the_mad", position, 1, 3, "Redfall.LokiTheMad.Aggro", fv, false)
  stone:SetRenderColor(220, 40, 40)
  Redfall:ColorWearables(stone, Vector(220, 40, 40))
  stone.itemLevel = 124
  Events:AdjustBossPower(stone, 6, 6, false)

  stone.targetRadius = 400
  stone.minRadius = 0
  stone.targetAbilityCD = 1
  stone.targetFindOrder = FIND_ANY_ORDER
  return stone
end

function Redfall:SpawnCrystalRoomWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CaveUnitSpawn", Redfall.RedfallMaster)
    end
      local luck = RandomInt(1, 222)
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
        unit.itemLevel = itemLevel
        unit.code = 6
        unit.dominion = true
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_castle_unit_generic", {})
        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit, 2)
        unit.aggro = true
        if unit:GetUnitName() == "redfall_crimsyth_hell_bandit" then
          unit:SetRenderColor(255, 60, 60)
        elseif unit:GetUnitName() == "redfall_crimsyth_gunman" then
          unit:SetRenderColor(255, 60, 60)
        elseif unit:GetUnitName() == "redfall_castle_warflayer" then
          unit:SetRenderColor(255, 130, 130)
          Redfall:ColorWearables(unit, Vector(255, 130, 130))
        elseif unit:GetUnitName() == "redfall_castle_archer" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
        elseif unit:GetUnitName() == "redfall_crystal_shifter" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
        end
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].itemLevel = itemLevel
          Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit[i], "modifier_castle_unit_generic", {})
          unit[i]:SetAcquisitionRange(3000)
          unit[i].code = 6
          unit[i].dominion = true
          CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_lone_druid/lone_druid_loadout.vpcf", unit[i], 2)
        end
      end
    end)
  end
end

function Redfall:CastleStartLavaMazeRoom()
  Redfall.Castle.LavaPoles = {false, false, false}
  Redfall:SpawnTongeyKong(Vector(-6707, 15765), Vector(1,0))
  CreateStompingHead(Vector(-6050, 14856, 120+Redfall.ZFLOAT), Vector(-100, 0))
  CreateStompingHead(Vector(-5184, 14855, 120+Redfall.ZFLOAT), Vector(-100, 0))
  CreateStompingHead(Vector(-4766, 14662, 120+Redfall.ZFLOAT), Vector(0, -100))
  CreateStompingHead(Vector(-5591, 13884, 360+Redfall.ZFLOAT), Vector(100, 0))

  Redfall:SpawnIceSwitch(Vector(-5760, 14848), Vector(-1,0), 1)
  Redfall:SpawnIceSwitch(Vector(-4765, 14215), Vector(0,-1), 2)
  Redfall:SpawnIceSwitch(Vector(-5809, 13855), Vector(1,0), 3)

  Redfall:SpawnFlameWraith(Vector(-6016, 15863), Vector(1,0))
  Redfall:SpawnFlameWraith(Vector(-6016, 15689), Vector(1,0))
  Timers:CreateTimer(3, function()
    Redfall:SpawnCrimsythKhanKnight(Vector(-6720, 14912), Vector(0,1))
    Redfall:SpawnCrimsythKhanKnight(Vector(-6720, 14912), Vector(0,1))
    Redfall:SpawnCrimsonSamurai(Vector(-5952, 14848), Vector(-1,0))
    Redfall:SpawnCrimsonSamurai(Vector(-4825, 14848), Vector(-1,0))
    Redfall:SpawnCastleWarflayer(Vector(-5596, 14848), Vector(-1,0))
    Redfall:SpawnCrimsythShadow(Vector(-4736, 13952), Vector(0,1))
  end)
  Timers:CreateTimer(5, function()
    local luck = RandomInt(1, 3)
    if luck == 1 then
      Redfall:SpawnLavaBehemoth(Vector(-5312, 14016), Vector(0,1))
    end
  end)
  Timers:CreateTimer(7, function()
    local basePosition = Vector(-6272, 13760)
    for i = 1, 6, 1 do
      for j = 1, 3, 1 do
        Redfall:SpawnCrimsonWarrior(basePosition+Vector((i-1)*196, (j-1)*128), Vector(1,0))
      end
    end
  end)
end

function CreateStompingHead(position, offset)
    local thwompUnit = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    thwompUnit.offset = offset
    thwompUnit.headOffset = 500
    thwompUnit:SetAbsOrigin(position+Vector(0,0,thwompUnit.headOffset))
    thwompUnit:AddAbility("redfall_thwomp_head_ability"):SetLevel(1)
    thwompUnit:RemoveAbility("dummy_unit")
    thwompUnit:RemoveModifierByName("dummy_unit")
    
    local thwompHead = Entities:FindByNameNearest("ThwompHead", position, 1100)
    thwompUnit.thwompHead = thwompHead
    thwompUnit.rising = 0
    thwompUnit.interval = 0
end

function Redfall:SpawnIceSwitch(position, fv, index)
  local iceSwitch = CreateUnitByName("redfall_lava_room_ice_switch", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
  iceSwitch:SetForwardVector(fv)
  iceSwitch.index = index
  iceSwitch:SetRenderColor(200, 20, 20)
  StartAnimation(iceSwitch, {duration=5000, activity=ACT_DOTA_IDLE, rate=1.0})
  Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, iceSwitch, "modifier_castle_unit_generic", {})
  iceSwitch.code = 7
end

function Redfall:LavaCrystalSwitch(unit)
  EndAnimation(unit)
  EmitSoundOn("Redfall.CrystalSwitchShatter", unit)
  local indicatorTable = {Vector(-4480, 14976, 222+Redfall.ZFLOAT), Vector(-4480, 14400, 222+Redfall.ZFLOAT), Vector(-4480, 13824, 222+Redfall.ZFLOAT)}
  local indicator = Entities:FindByNameNearest("LavaRoomPole", indicatorTable[unit.index], 800)
  for i = 1, 98, 1 do
    Timers:CreateTimer(0.05*i, function()
      indicator:SetRenderColor(210-i, 102, 102+(i*1.2))
    end)
  end
  Timers:CreateTimer(5, function()
    Redfall.Castle.LavaPoles[unit.index] = true
    EmitSoundOnLocationWithCaster(indicator:GetAbsOrigin(), "Redfall.CrystalSwitchPoleTurn", Events.GameMaster)
    if Redfall.Castle.LavaPoles[1] and Redfall.Castle.LavaPoles[2] and Redfall.Castle.LavaPoles[3] then
      local walls = Entities:FindAllByNameWithin("CastleWall1", Vector(-6672, 13228, 527+Redfall.ZFLOAT), 1800)
      Redfall:Walls(false, walls, true, 3.31)
      Redfall:InitBallSwitchRoom()
      Timers:CreateTimer(5, function()
        local blockers = Entities:FindAllByNameWithin("CastleBlocker", Vector(-6673, 13228, 124+Redfall.ZFLOAT), 2400)
        for i = 1, #blockers, 1 do
          UTIL_Remove(blockers[i])
        end
      end)      
    end
  end)
end

function Redfall:SpawnFlameWraith(position, fv)
  local ancient = Redfall:SpawnDungeonUnit("fire_temple_flame_wraith", position, 1, 2, "Redfall.FlameWraithAggro", fv, false)
  Events:AdjustBossPower(ancient, 2, 2, false)
  ancient.itemLevel = 107
  ancient:SetRenderColor(255, 0, 0)
  ancient.dominion = true
  return ancient
end

function Redfall:InitBallSwitchRoom()
  Redfall:SpawnBallSwitch(Vector(-6696, 12962))
  Redfall:SpawnBallSwitch(Vector(-3776, 11456))
  Redfall:SpawnBallSwitch(Vector(-6592, 10240))
  Redfall.Castle.BallSwitchGoalsTable = {Vector(-3356, 12147, 135+Redfall.ZFLOAT), Vector(-3011, 12147, 135+Redfall.ZFLOAT), Vector(-2686, 12147, 135+Redfall.ZFLOAT)}

  local magePositionTable = {Vector(-6784, 12032), Vector(-6272, 12032), Vector(-6784, 11520), Vector(-6272, 11520)}
  for i = 1, #magePositionTable, 1 do
    Redfall:SpawnCrimsythMage(magePositionTable[i], Vector(0,1))
  end
  Redfall:SpawnCrimsythMageElite(Vector(-6377, 10938), Vector(0,1))
  Timers:CreateTimer(5, function()
    for i = 1, 3, 1 do
      for j = 1, 3, 1 do
        Redfall:SpawnCrimsythThug(Vector(-5824, 10273)+Vector((i-1)*240, (j-1)*240), Vector(0,1))
      end
    end
  end)

  Timers:CreateTimer(2, function()
    local positionTable = {Vector(-5824, 12608), Vector(-5440, 12928), Vector(-5184, 12544), Vector(-4736, 12992), Vector(-4480, 12608)}
    for i = 1, #positionTable, 1 do
      local patrolPositionTable = {}
      for j = 1, #positionTable, 1 do
        local index = i + j
        if index > #positionTable then
          index = index - #positionTable
        end
        table.insert(patrolPositionTable, positionTable[index])
      end
      local wraith = Redfall:SpawnSoulScar(positionTable[i], RandomVector(1))
      Redfall:AddPatrolArguments(wraith, 70, 4, 30, patrolPositionTable)
    end
  end)

  Timers:CreateTimer(7, function()
    Redfall:SpawnCrimsythMageElite(Vector(-3904, 12352), Vector(-1,-1))
    Redfall:SpawnCrimsythMageElite(Vector(-4416, 11776), Vector(-1,0))
    Redfall:SpawnCrimsythShadow(Vector(-5376, 11776), Vector(0,1), false)
    Redfall:SpawnCastleWarflayer(Vector(-5696, 12032), Vector(0,1))
    Redfall:SpawnCastleWarflayer(Vector(-5120, 12032), Vector(0,1))
    Redfall:SpawnCastleWarflayer(Vector(-5696, 11520), Vector(0,-1))
    Redfall:SpawnCastleWarflayer(Vector(-5120, 11520), Vector(0,-1))
  end)
  Timers:CreateTimer(10, function()
    Redfall:SpawnCrimsythMageElite(Vector(-3584, 10240), Vector(-1,1))
    local positionTable = {Vector(-3840, 10816), Vector(-4096, 10624), Vector(-4480, 10688), Vector(-4416, 10304), Vector(-3904, 10368), Vector(-4096, 10048), Vector(-3584, 10048), Vector(-3456, 10432), Vector(-3072, 10048)}
    for i = 1, #positionTable, 1 do
      local patrolPositionTable = {}
      for j = 1, #positionTable, 1 do
        local index = i + j
        if index > #positionTable then
          index = index - #positionTable
        end
        table.insert(patrolPositionTable, positionTable[index])
      end
      local wraith = Redfall:SpawnSoulScar(positionTable[i], RandomVector(1))
      Redfall:AddPatrolArguments(wraith, 70, 4, 30, patrolPositionTable)
    end
  end)
end

function Redfall:SpawnBallSwitch(position)
    local ball = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    ball:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    ball:AddAbility("redfall_ball_prop"):SetLevel(1)
    ball:RemoveAbility("dummy_unit")
    ball:RemoveModifierByName("dummy_unit")
    ball.startPosition = ball:GetAbsOrigin()
    ball.jumpLock = true
    ball.moveVelocity = 0
    ball.liftVelocity = 0
    ball.roll = 0
    ball.pitch = 0
    ball.interval = 0
    ball:SetOriginalModel("models/redfall/castle_ball_switch.vmdl")
    ball:SetModel("models/redfall/castle_ball_switch.vmdl")
    ball:SetRenderColor(200, 100, 100)
    ball:SetModelScale(2.4)
end

function Redfall:SpawnCrimsythMage(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_mage", position, 1, 2, "Redfall.CrimsythMage.Aggro", fv, false)
  stone.itemLevel = 96
  stone:SetRenderColor(255, 120, 120)
  Events:AdjustBossPower(stone, 3, 3, false)
  Redfall:ColorWearables(stone, Vector(255, 120, 120))
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsythMageElite(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_mage_elite", position, 1, 4, "Redfall.CrimsythMage.Aggro2", fv, false)
  stone.itemLevel = 96
  stone:SetRenderColor(255, 120, 120)
  Events:AdjustBossPower(stone, 3, 3, false)
  Redfall:ColorWearables(stone, Vector(255, 120, 120))
  stone.dominion = true
  return stone
end

function Redfall:SpawnSoulScar(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_soul_scar", position, 1, 2, "Redfall.SoulScar.Aggro", fv, false)
  stone.itemLevel = 110
  stone:SetRenderColor(240, 80, 80)
  Redfall:ColorWearables(stone, Vector(240, 80, 80))
  stone.targetRadius = 700
  stone.minRadius = 0
  stone.targetAbilityCD = 1
  stone.targetFindOrder = FIND_ANY_ORDER
  Events:AdjustBossPower(stone, 3, 3, false)
  stone.dominion = true
  return stone
end

function Redfall:CastleInitiateAfterBallRoom()
  Redfall:SpawnHawkSoldierElite(Vector(-3648, 9152), Vector(1,0))
  Redfall:SpawnHawkSoldierElite(Vector(-3648, 9344), Vector(1,0))
  Redfall:SpawnHawkSoldierElite(Vector(-3648, 9536), Vector(1,0))

  Redfall:SpawnCastleWarflayer(Vector(-4288, 9344), Vector(1,0))

  Timers:CreateTimer(1, function()
    Redfall:SpawnHawkSoldierElite(Vector(-4160, 8576), Vector(0,1))
    Redfall:SpawnHawkSoldierElite(Vector(-4494, 8576), Vector(0,1))

    Redfall:SpawnCrimsonSamurai(Vector(-3648, 8640), Vector(-1,0))
    Redfall:SpawnCrimsonSamurai(Vector(-3136, 8640), Vector(-1,0))
  end)
  Timers:CreateTimer(2.5, function()
    for i = 1, 7, 1 do
      for j = 1, 4, 1 do
        Redfall:SpawnRuinsGuardian(Vector(-3648, 7552)+Vector((i-1)*128, (j-1)*128), Vector(0,1))
      end
    end
  end)
  if GameState:GetDifficultyFactor() > 1 then
    Redfall:SpawnCrystalHoarder(Vector(-4288, 8735), Vector(0,1))
  end

  Timers:CreateTimer(6, function()
    local positionTable = {Vector(-6208, 8640), Vector(-5824, 8320), Vector(-5248, 8000), Vector(-5568, 6976), Vector(-5824, 6336), Vector(-5184, 6784), Vector(-4992, 6400), Vector(-4032, 6272), Vector(-3840, 7168), Vector(-3584, 6272), Vector(-3136, 6528), Vector(-2944, 6912), Vector(-3200, 7104)}
    for i = 1, #positionTable, 1 do
      Redfall:SpawnShipyardGhostFish(positionTable[i], RandomVector(1))
    end
  end)

  Timers:CreateTimer(8, function()
    Redfall:SpawnCrimsythGrunt(Vector(-3618, 6720), Vector(0,1))
    Redfall:SpawnCrimsythGrunt(Vector(-3456, 6720), Vector(0,1))
    Redfall:SpawnCrimsythShadow(Vector(-4573, 6720), Vector(1,0), false)

    for i = 1, 3, 1 do
      for j = 1, 2, 1 do
        Redfall:SpawnCrimsythGrunt(Vector(-4928, 7360)+Vector((i-1)*216, (j-1)*138), Vector(0,-1))
      end
    end
  end)

  Timers:CreateTimer(12, function()
    Redfall:SpawnTongeyKong(Vector(-5504, 8768), Vector(0,-1))
    Redfall:SpawnCrimsonShadowDancer(Vector(-5248, 7488), Vector(1,0))
    Redfall:SpawnCrimsonShadowDancer(Vector(-5760, 7488), Vector(1,0))
    for i = 0, 3, 1 do
      Redfall:SpawnRagingShaman(Vector(-6208, 6912+(i*196)), Vector(1,0))
    end
    Redfall:SpawnRagingShaman(Vector(-5632, 8768), Vector(0,-1))
    Redfall:SpawnRagingShaman(Vector(-5312, 8768), Vector(0,-1))
    Redfall:SpawnRagingShaman(Vector(-5632, 9088), Vector(0,-1))
    Redfall:SpawnRagingShaman(Vector(-5312, 9088), Vector(0,-1))

    Redfall:SpawnCrimsythShadow(Vector(-5504, 9408), Vector(0,-1), false)
  end)
end

function Redfall:SpawnRuinsGuardian(position, fv)
  local stone = Redfall:SpawnDungeonUnit("arena_conquest_ruins_guardian", position, 1, 2, "Redfall.TempleGuardian.Aggro", fv, false)
  Events:AdjustBossPower(stone, 1, 1, false)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 90, 90)
  Redfall:ColorWearables(stone, Vector(255, 90, 90))
  stone.dominion = true
  return stone
end

function Redfall:SpawnCrimsythGrunt(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_grunt", position, 1, 2, "Redfall.CrimsythGrunt.Aggro", fv, false)
  Events:AdjustBossPower(stone, 3, 3, false)
  stone.itemLevel = 120

  stone.targetRadius = 240
  stone.minRadius = 0
  stone.autoAbilityCD = 1
  stone.targetFindOrder = FIND_ANY_ORDER
  stone.dominion = true
  return stone

end

function Redfall:SpawnRagingShaman(position, fv)
  local stone = Redfall:SpawnDungeonUnit("crimsyth_raging_shaman", position, 1, 2, "Redfall.RagingShaman.Aggro", fv, false)
  Events:AdjustBossPower(stone, 3, 3, false)
  stone.itemLevel = 110
  stone:SetRenderColor(255, 90, 90)
  Redfall:ColorWearables(stone, Vector(255, 90, 90))
  stone.dominion = true
  return stone
end

function Redfall:SpawnGhostOfPerdition(position, fv)
  local stone = Redfall:SpawnDungeonUnit("crimsyth_ghost_of_perdition", position, 4, 6, nil, fv, false)
  stone.itemLevel = 140
  stone:SetRenderColor(168, 70, 70)
  Events:AdjustBossPower(stone, 10, 10, false)
  return stone
end

function Redfall:PerditionRoom()
  Redfall:SpawnGhostOfPerdition(Vector(-7936, 4224), Vector(1,1))
  Redfall.Castle.TorchesLit = 0
  local positionTable = {Vector(-7680, 5376), Vector(-6144, 5376), Vector(-6902, 4100)}
  for i = 1, #positionTable, 1 do
    Redfall:SpawnPerditionTorch(positionTable[i])
  end
end

function Redfall:SpawnPerditionTorch(position)
    local torch = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    torch:SetOriginalModel("models/redfall/lantern_hitbox.vmdl")
    torch:SetModel("models/redfall/lantern_hitbox.vmdl")
    torch.jumpLock = true
    torch:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    torch:AddAbility("redfall_perdition_torch_ability"):SetLevel(1)
    Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, torch, "modifier_disable_player", {}) 
    torch:RemoveAbility("dummy_unit")
    torch:RemoveModifierByName("dummy_unit")
    torch.basePos = torch:GetAbsOrigin()
    torch:SetRenderColor(200, 90, 90)
    AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 100, 7200, false)
end

function Redfall:SpawnFortuneSeeker(position, fv)
  local stone = Redfall:SpawnDungeonUnit( "crimsyth_fortune_seeker", position, 1, 3, "Redfall.FortuneSeeker.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(188, 120, 120)
  Redfall:ColorWearables(stone, Vector(180, 90, 90))
  Events:AdjustBossPower(stone, 8, 8, false)
  -- stone:AddNewModifier(stone, nil, "modifier_animation", {translate="run"})
  stone:AddNewModifier(stone, nil, "modifier_animation", {translate="attack_normal_range"})
  stone:AddNewModifier(stone, nil, "modifier_animation_translate", {translate="run"})
  Events:SetPositionCastArgs(stone, 1000, 0, 1, FIND_ANY_ORDER)
  stone.dominion = true
  return stone
end

function Redfall:SpawnFortuneRoom()
  Redfall.Castle.FortuneChestTable = {}
  Redfall.Castle.FortuneChestBoss = RandomInt(1, 16)
  for i = 1, 4, 1 do
    for j = 1, 2, 1 do
      Timers:CreateTimer(j*0.05 + i*0.08, function()
        if i <= (GameState:GetDifficultyFactor() + 1) then
          Redfall:SpawnFortuneSeeker(Vector(1728, 6272)+Vector((i-1)*300, (j-1)*256), Vector(-1,0))
        end
      end)
    end
  end
  Timers:CreateTimer(4, function()
    for i = 0, 3, 1 do
      for j = 0, 3, 1 do
        local position = Vector(3032, 6130) + Vector(i*232, j*240)
        local chest = Redfall:SpawnFortuneRoomChest(position, i, j)
        chest.i = i
        chest.j = j
      end
    end
  end)
  Redfall.Castle.FortuneChestsOpened = 0
  

  print("FORTUNE CHEST INDEX!")
  print(Redfall.Castle.FortuneChestBoss)
end

function Redfall:SpawnFortuneRoomChest(position, i, j)
    local torch = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
    torch:SetOriginalModel("models/redfall/chest_hitbox.vmdl")
    torch:SetModel("models/redfall/chest_hitbox.vmdl")
    torch.jumpLock = true
    torch:SetForwardVector(Vector (1,0))
    torch:AddAbility("dummy_unit_can_be_attacked_cant_die"):SetLevel(1)
    torch:AddAbility("redfall_fortune_chest_ability"):SetLevel(1)
    torch:RemoveAbility("dummy_unit")
    torch:RemoveModifierByName("dummy_unit")
    torch:SetRenderColor(123, 239, 210)
    torch.code = RandomInt(0, 17)
    table.insert(Redfall.Castle.FortuneChestTable, torch)
    torch.index = #Redfall.Castle.FortuneChestTable
    if torch.index == Redfall.Castle.FortuneChestBoss then
      Redfall.Castle.chestItarget = i
      Redfall.Castle.chestJtarget = j
    end
    return torch
end

function Redfall:SpawnEffigyOfFortunis(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_effigy_of_fortunis", position, 1, 2, "Redfall.RagingShaman.Aggro", fv, false)
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.itemLevel = 120
  stone:SetRenderColor(35, 35, 35)
  Redfall:ColorWearables(stone, Vector(0, 0, 0))
  stone.targetRadius = 450
  stone.autoAbilityCD = 1

  return stone
end

function Redfall:SpawnTreasureRoom()
  Redfall.Castle.TreasureGhost = CreateUnitByName("redfall_maze_ghost", Vector(-1408, 8512), true, nil, nil, DOTA_TEAM_NEUTRALS)
  Redfall.Castle.TreasureGhost:AddAbility("town_unit"):SetLevel(1)
  Redfall.Castle.TreasureGhost:SetForwardVector(Vector(0,-1))


  Redfall.Castle.TreasureTable = {RandomInt(1, 3), RandomInt(1, 3), RandomInt(1, 3)}

end

function Redfall:SpawnEtherealRevenant(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_ethereal_revenant", position, 4, 6, "Redfall.EtherealRevenant.Aggro", fv, false)
  stone.itemLevel = 140
  stone:SetRenderColor(255, 200, 200)
  Redfall:ColorWearables(stone, Vector(255, 200, 200))
  Events:AdjustBossPower(stone, 10, 10, false)
  stone:RemoveModifierByName("modifier_magic_immune_breakable_ability")
  local ability = stone:FindAbilityByName("magic_immune_breakable_ability_mega")
  ability:ApplyDataDrivenModifier(stone, stone, "modifier_magic_immune_breakable_ability", {})

  return stone
end

function Redfall:SpawnCastleGroundsGuardian(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_castle_grounds_guardian", position, 4, 6, "Redfall.CastleGroundsGuardian.Aggro", fv, false)
  stone.itemLevel = 140
  stone:SetRenderColor(255, 190, 190)
  Events:AdjustBossPower(stone, 8, 8, false)
  return stone
end

function Redfall:CastleSpawnBackHallway()
  local stone = Redfall:SpawnCastleGroundsGuardian(Vector(4825, 4032), Vector(0,1))
  stone:SetModelScale(2.4)
  Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, stone, "modifier_castle_unit_generic", {})
  stone.code = 9

  Redfall:SpawnCrymsithGuard(Vector(3306, 4928), Vector(0,1))
  Redfall:SpawnCrymsithGuard(Vector(3615, 4928), Vector(0,1))

  Redfall:SpawnCrymsithGuard(Vector(5048, 5121), Vector(-1,0))
  Redfall:SpawnCrymsithGuard(Vector(4842, 4800), Vector(-1,0))
  Redfall:SpawnCastleWarflayer(Vector(4608, 5042), Vector(-1,0))

  Timers:CreateTimer(2, function()
    for i = 1, 3, 1 do
       local bandit = Redfall:SpawnCrymsithGuard(Vector(1255, 4956)+RandomVector(90), Vector(1,0))
       Redfall:AddPatrolArguments(bandit, 50, 8, 60, {Vector(4160, 4928), Vector(1255, 4956)})
    end
    Redfall:SpawnCrimsythKhanKnight(Vector(2752, 4928), Vector(1,0))
    Redfall:SpawnCrimsythKhanKnight(Vector(2048, 4928), Vector(1,0))
  end)
end

function Redfall:CastleGroundsGuardianDie()
  local walls = Entities:FindAllByNameWithin("CastleWallX", Vector(4875, 4484, 495+Redfall.ZFLOAT), 1800)
  Redfall:Walls(false, walls, true, 3.61)
  Redfall:InitCastleGroundsRoom()
  Timers:CreateTimer(5, function()
    local blockers = Entities:FindAllByNameWithin("CastleBlocker4", Vector(4864, 5632, 128+Redfall.ZFLOAT), 2400)
    for i = 1, #blockers, 1 do
      UTIL_Remove(blockers[i])
    end
  end) 
end

function Redfall:InitCastleGroundsRoom()
  local positionTable = {Vector(4992, 6080), Vector(5184, 6080), Vector(4992, 6336), Vector(5184, 6336)}
  for i = 1, #positionTable, 1 do
    Redfall:SpawnCrymsithBerserker(positionTable[i], Vector(0,-1))
  end

    for i = 1, 3, 1 do
       local bandit = Redfall:SpawnCrymsithGuard(Vector(6315, 5700)+RandomVector(90), Vector(0,1))
       Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(6316, 6812), Vector(5120, 6812), Vector(5120, 6016), Vector(5120, 6812), Vector(6316, 6812), Vector(6315, 5700)})
    end
  Timers:CreateTimer(2, function()
    local fortunePosTable = {Vector(5184, 6976), Vector(5760, 6976), Vector(6336, 6976)}
    for i = 1, #fortunePosTable, 1 do
      Redfall:SpawnFortuneSeeker(fortunePosTable[i], Vector(0,-1))
    end

    Redfall:SpawnCrymsithBerserker(Vector(6336, 6464), Vector(0,1))
    Redfall:SpawnCrymsithBerserker(Vector(6336, 6016), Vector(0,1))
  end)

  Timers:CreateTimer(4, function()
    local positionTable = {Vector(5952, 5184), Vector(6765, 5184), Vector(5952, 4009), Vector(6765, 4010)}
    local lookToPoint = Vector(6336, 5568)
    for i = 1, #positionTable, 1 do
      Timers:CreateTimer(i*0.27, function()
        local fv = ((lookToPoint-positionTable[i])*Vector(1,1,0)):Normalized()
        Redfall:SpawnGardenWatcher(positionTable[i], fv)
      end)
    end
    Timers:CreateTimer(2, function()
      for i = 1, 3, 1 do
         local bandit = Redfall:SpawnCrymsithGuard(Vector(6336, 5184)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(5923, 4551), Vector(6367, 4006), Vector(6765, 4589), Vector(6336, 5184)})
      end
      for i = 1, 3, 1 do
         local bandit =  Redfall:SpawnCrymsithBerserker(Vector(6765, 4589)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(6336, 5184), Vector(5923, 4551), Vector(6367, 4006), Vector(6765, 4589)})
      end
      for i = 1, 3, 1 do
         local bandit =  Redfall:SpawnGardenWatcher(Vector(6336, 5184)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(5923, 4551), Vector(6367, 4006), Vector(6765, 4589), Vector(6336, 5184)})
      end
      for i = 1, 3, 1 do
         local bandit =  Redfall:SpawnCastleWarflayer(Vector(5923, 4551)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(6367, 4006), Vector(6765, 4589), Vector(6336, 5184), Vector(5923, 4551)})
      end
    end)
  end)

  Timers:CreateTimer(10, function()
    for i = 1, 3, 1 do
      for j = 1, 2, 1 do
        Redfall:SpawnCrimsythGrunt(Vector(6155, 3120)+Vector((i-1)*150, (j-1)*192), Vector(0,1))
      end
    end
  end)

  Timers:CreateTimer(0.5, function()
    Redfall.Castle.Elthezun = Redfall:SpawnPrinceElthezun(Vector(6336, 2368), Vector(0,1))
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(6336, 2368), 300, 900, false)
    StartAnimation(Redfall.Castle.Elthezun, {duration=6000, activity=ACT_DOTA_VERSUS, rate=1.0})
    local ability = Redfall.Castle.Elthezun:FindAbilityByName("redfall_prince_elthezun_ability")
    ability:ApplyDataDrivenModifier(Redfall.Castle.Elthezun, Redfall.Castle.Elthezun, "modifier_elthezun_waiting", {})
  end)
end

function Redfall:SpawnCrymsithGuard(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_guard", position, 1, 2, "Redfall.CrimsythGuardian.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(255, 190, 190)
  Redfall:ColorWearables(stone, Vector(255, 200, 200))
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.dominion = true
  return stone
end


function Redfall:SpawnCrymsithBerserker(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_berserker", position, 1, 2, "Redfall.CrimsythBerserker.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(255, 190, 190)
  Redfall:ColorWearables(stone, Vector(255, 200, 200))
  Events:AdjustBossPower(stone, 7, 7, false)
  stone.dominion = true
  return stone
end

function Redfall:SpawnGardenWatcher(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_castle_garden_watcher", position, 1, 2, "Redfall.GardenWatcher.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(255, 80, 80)
  Redfall:ColorWearables(stone, Vector(255, 80, 80))
  Events:AdjustBossPower(stone, 6, 6, false)

  stone.targetRadius = 1000
  stone.minRadius = 0
  stone.targetAbilityCD = 1
  stone.targetFindOrder = FIND_FARTHEST
  stone.dominion = true
  return stone
end

function Redfall:SpawnPrinceElthezun(position, fv)
  local stone = Redfall:SpawnDungeonUnit("prince_elthezun", position, 4, 6, nil, fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(127, 11, 11)
  Redfall:ColorWearables(stone, Vector(255, 200, 200))
  Events:AdjustBossPower(stone, 8, 8, false)
  return stone
end

function Redfall:SpawnElthezunWaveUnit(unitName, spawnPoint, quantity, itemLevel, delay, bSound)

  local unit = false
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
    if bSound then
      EmitSoundOnLocationWithCaster(spawnPoint, "Redfall.CastleSpawner.Spawn", Redfall.RedfallMaster)
    end
      local luck = RandomInt(1, 222)
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
        unit.itemLevel = itemLevel
        unit.dominion = true
        Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_castle_unit_generic", {})
        unit.code = 10

        unit:SetAcquisitionRange(3000)
        CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", unit, 2)
        unit.aggro = true
        if unit:GetUnitName() == "redfall_castle_dweller" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
        elseif unit:GetUnitName() == "iron_spine" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
        elseif unit:GetUnitName() == "redfall_castle_demented_shaman" then
          unit:SetRenderColor(255, 60, 60)
          Redfall:ColorWearables(unit, Vector(255, 60, 60))
        end
      else
        for i = 1, #unit, 1 do
          unit[i].aggro = true
          unit[i].itemLevel = itemLevel
          Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit[i], "modifier_castle_unit_generic", {})
          unit[i].code = 10
          unit[i]:SetAcquisitionRange(3000)
          unit[i].dominion = true
          CustomAbilities:QuickAttachParticle("particles/roshpit/redfall/castle_spawn.vpcf", unit[i], 2)
          if unit[i]:GetUnitName() == "redfall_autumn_monster" then
            unit[i].targetRadius = 800
            unit[i].autoAbilityCD = 1
          elseif unit[i]:GetUnitName() == "crimsyth_bombadier" then
            Events:SetPositionCastArgs(unit[i], 1200, 0, 1, FIND_ANY_ORDER)
          end
        end
      end
    end)
  end
end

function Redfall:ElthezunWaveUnitDie(unit)
  if not Redfall.Castle.ElthezunDeathCount then
    Redfall.Castle.ElthezunDeathCount = 0
  end
  Redfall.Castle.ElthezunDeathCount = Redfall.Castle.ElthezunDeathCount + 1
  local positionTable = {Vector(5952, 4010), Vector(6765, 4010, 138), Vector(5952,5184, 138), Vector(6765,5184, 138)}
  if Redfall.Castle.ElthezunDeathCount == 30 then
    for i = 1, #positionTable, 1 do
      Redfall:SpawnElthezunWaveUnit("redfall_castle_dweller", positionTable[i], 8, 90, 1.3, true)
    end
  elseif Redfall.Castle.ElthezunDeathCount == 61 then
    for i = 1, #positionTable, 1 do
      Redfall:SpawnElthezunWaveUnit("redfall_castle_demented_shaman", positionTable[i], 7, 90, 1.3, true)
    end
  elseif Redfall.Castle.ElthezunDeathCount == 87 then
    for i = 1, #positionTable, 1 do
      Redfall:SpawnElthezunWaveUnit("redfall_castle_avian_purifier", positionTable[i], 7, 90, 1.3, true)
    end
  elseif Redfall.Castle.ElthezunDeathCount == 113 then
    Redfall:SpawnElthezunWaveUnit("redfall_castle_dweller", positionTable[1], 9, 90, 1.3, true)
    Redfall:SpawnElthezunWaveUnit("redfall_castle_demented_shaman", positionTable[2], 9, 90, 1.3, true)
    Redfall:SpawnElthezunWaveUnit("redfall_castle_avian_purifier", positionTable[3], 9, 90, 1.3, true)
    Redfall:SpawnElthezunWaveUnit("iron_spine", positionTable[4], 9, 90, 1.3, true)
  elseif Redfall.Castle.ElthezunDeathCount == 149 then
    Redfall:SpawnElthezunWaveUnit("redfall_crimsyth_berserker", positionTable[1], 3, 90, 1.3, true)
    Redfall:SpawnElthezunWaveUnit("redfall_crimsyth_guard", positionTable[2], 3, 90, 1.3, true)
    Redfall:SpawnElthezunWaveUnit("redfall_crimsyth_berserker", positionTable[3], 3, 90, 1.3, true)
    Redfall:SpawnElthezunWaveUnit("redfall_crimsyth_guard", positionTable[4], 3, 90, 1.3, true)
  elseif Redfall.Castle.ElthezunDeathCount == 152 then
    for j = 1, #Redfall.Castle.ElthezunSpawnParticleTable, 1 do
      ParticleManager:DestroyParticle(Redfall.Castle.ElthezunSpawnParticleTable[j], false)
      ParticleManager:ReleaseParticleIndex(Redfall.Castle.ElthezunSpawnParticleTable[j])
    end
    Redfall.Castle.ElthezunSpawnParticleTable = nil
    Redfall.Castle.Elthezun:RemoveModifierByName("modifier_elthezun_during_wave")
    Redfall.Castle.Elthezun:RemoveModifierByName("modifier_elthezun_waiting")
    
    EmitSoundOn("Redfall.Elthezun.FightStart", Redfall.Castle.Elthezun)
    local ability = Redfall.Castle.Elthezun:FindAbilityByName("redfall_prince_elthezun_ability")
    ability:ApplyDataDrivenModifier(Redfall.Castle.Elthezun, Redfall.Castle.Elthezun, "modifier_elthezun_in_combat", {})

  end
end

function Redfall:SpawnDemonKnight(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_crimsyth_demon_knight", position, 1, 2, "Redfall.DemonKnight.Aggro", fv, false)
  stone.itemLevel = 130
  stone:SetRenderColor(255, 80, 80)
  Redfall:ColorWearables(stone, Vector(255, 80, 80))
  Events:AdjustBossPower(stone, 6, 6, false)

  stone.targetRadius = 1000
  stone.minRadius = 0
  stone.targetAbilityCD = 1
  stone.targetFindOrder = FIND_FARTHEST
  stone.animation = ACT_DOTA_CAST_ABILITY_1
  stone.dominion = true
  return stone
end

function Redfall:CastleInitiateAfterHallwayRoom()
  local positionTable = {Vector(128, 4992), Vector(-320, 4992), Vector(-832, 4992)}
  for i = 1, #positionTable, 1 do
    Redfall:SpawnDemonKnight(positionTable[i], Vector(1,0))
  end
  Redfall:SpawnTheCannibal(Vector(256, 5888), Vector(-1,0))
end

function Redfall:SpawnTheCannibal(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_the_cannibal", position, 3, 4, "Redfall.TheCannibal.Aggro", fv, false)
  stone.itemLevel = 140
  stone:SetRenderColor(255, 80, 80)
  Redfall:ColorWearables(stone, Vector(255, 80, 80))
  Events:AdjustBossPower(stone, 6, 6, false)
  return stone
end

function Redfall:CastleInitiateFinalRoom()
  Redfall:SpawnDemonFollower(Vector(-1792, 6144), Vector(0,-1))
  Redfall:SpawnDemonFollower(Vector(-2240, 6144), Vector(0,-1))

  Redfall:SpawnCrimsythShadow(Vector(-2944, 5696), Vector(1,0))

  Redfall:SpawnCastleWarflayer(Vector(-1920, 5696), Vector(1,0))
  Redfall:SpawnCastleWarflayer(Vector(-2513, 5696), Vector(1,0))

  Timers:CreateTimer(2, function()
    for i = 0, 2, 1 do
      for j = 0, 2, 1 do
        Redfall:SpawnCrimsythKhanKnight(Vector(-3968, 5056)+Vector(i*200, j*200), Vector(1,0))
      end
    end
    for i = 1, 4, 1 do
         local bandit = Redfall:SpawnCrimsythGrunt(Vector(-4928, 5376)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(-2880, 4928), Vector(-4928, 5376)})
    end
  end)
  Timers:CreateTimer(4, function()
    for i = 1, 4, 1 do
         local bandit = Redfall:SpawnFortuneSeeker(Vector(-3008, 5268)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(-4928, 4778), Vector(-3008, 5268)})
    end
    for i = 1, 3, 1 do
         local bandit = Redfall:SpawnCrimsythGunmanElite(Vector(-5120, 4032)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(-3840, 2560), Vector(-5120, 4032)})
    end
  end)

  Timers:CreateTimer(5, function()
    local positionTable = {Vector(-3840, 4608), Vector(-3584, 4608), Vector(-3840, 4160), Vector(-3584, 4160)}
    for i = 1, #positionTable, 1 do
      Redfall:SpawnDemonKnight(positionTable[i], Vector(0,1))
    end
  end)
  Timers:CreateTimer(6, function()
    for i = 1, 3, 1 do
         local bandit = Redfall:SpawnCrymsithGuard(Vector(-2816, 3827)+RandomVector(90), Vector(0,1))
         Redfall:AddPatrolArguments(bandit, 45, 6, 60, {Vector(-4544, 3200), Vector(-2816, 3827)})
    end
  end)
  Timers:CreateTimer(7, function()
    for i = 0, 2, 1 do
      for j = 0, 2, 1 do
        Redfall:SpawnCrymsithBerserker(Vector(-3904, 3008)+Vector(i*240, j*240), Vector(0,1))
      end
    end
  end)
  Timers:CreateTimer(8, function()
    Redfall:SpawnCrimsonSamurai(Vector(-4352, 4544), Vector(1,0))
    Redfall:SpawnCrimsonSamurai(Vector(-4352, 3840), Vector(1,0))
    Redfall:SpawnCrimsythThug(Vector(-2994, 2580), Vector(0,1))
    Redfall:SpawnCrimsythThug(Vector(-2560, 2580), Vector(0,1))
  end)
  Timers:CreateTimer(9, function()
    Redfall:SpawnDemonFollower(Vector(-2432, 3520), Vector(-1,0))
    Redfall:SpawnDemonFollower(Vector(-2432, 3008), Vector(-1,0))
  end)
  Timers:CreateTimer(10, function()
    for i = 0, 2, 1 do
      for j = 0, 2, 1 do
        Redfall:SpawnEnclaveViking(Vector(-4608, 3328)+Vector(i*120, j*120))
      end
    end
    Redfall:SpawnCrimsythBombadierRooted(Vector(-2239, 4658), Vector(-1,0))
    Redfall:SpawnHawkSoldierElite(Vector(-3008, 2176), Vector(0,1))
    Redfall:SpawnHawkSoldierElite(Vector(-3413, 2176), Vector(0,1))
    Redfall:SpawnHawkSoldierElite(Vector(-2589, 2176), Vector(0,1))
  end)
  Timers:CreateTimer(12, function()
    Redfall:SpawnCrimsythMageElite(Vector(-2112, 4032), Vector(-1,0))
    Redfall:SpawnCrimsythMageElite(Vector(-2112, 2496), Vector(-1,0))
  end)
end

function Redfall:SpawnDemonFollower(position, fv)
  local stone = Redfall:SpawnDungeonUnit( "redfall_demonic_follower", position, 1, 3, "Redfall.DemonFollower.Aggro", fv, false)
  stone.itemLevel = 140
  stone:SetRenderColor(188, 120, 120)
  Redfall:ColorWearables(stone, Vector(180, 90, 90))
  Events:AdjustBossPower(stone, 8, 8, false)
  -- stone:AddNewModifier(stone, nil, "modifier_animation", {translate="run"})
  Events:SetPositionCastArgs(stone, 800, 0, 1, FIND_ANY_ORDER)
  stone.dominion = true
  return stone
end

function Redfall:ActivateBossStatue(position)
  if not Redfall.Castle.BossStatuesActivated then
    Redfall.Castle.BossStatuesActivated = 0
  end
  Timers:CreateTimer(4.5, function()
    Redfall.Castle.BossStatuesActivated = Redfall.Castle.BossStatuesActivated + 1
    if Redfall.Castle.BossStatuesActivated == 2 then
      EmitGlobalSound("Music.Redfall.DungeonOpen")

      Dungeons:CreateBasicCameraLockForHeroes(Vector(-1654, 3249), 10, MAIN_HERO_TABLE)
      Timers:CreateTimer(1.5, function()
        local wallN = Entities:FindByNameNearest("CastleBossDoorN", Vector(-1389, 3523, 519+Redfall.ZFLOAT), 800)
        local wallS = Entities:FindByNameNearest("CastleBossDoorS", Vector(-1389, 3007, 519+Redfall.ZFLOAT), 800)
        local skull = Entities:FindByNameNearest("CastleBossDoorFace", Vector(-1480, 3264, 570+Redfall.ZFLOAT), 800)
        for j = 1, 160, 1 do
          Timers:CreateTimer(j*0.03, function()
            wallN:SetAbsOrigin(wallN:GetAbsOrigin()+Vector(0,400/160))
            wallS:SetAbsOrigin(wallS:GetAbsOrigin()+Vector(0,-400/160))
            skull:SetRenderColor(200 - (200/160)*j, 59 - (59/160)*j, 59 - (59/160)*j)
            if j%10 == 0 then
              ScreenShake(Vector(-1654, 3249), 2, 0.5, 0.9, 9000, 0, true)
              EmitSoundOnLocationWithCaster(Vector(-2154, 3249), "Redfall.Shaking", Events.GameMaster)
            end
          end)
        end
        Timers:CreateTimer(5.0, function()
          EmitSoundOnLocationWithCaster(Vector(-2154, 3249), "Redfall.TreeHealed", Events.GameMaster)
          local blockers = Entities:FindAllByNameWithin("BossBlocker", Vector(-1408, 3264, 263+Redfall.ZFLOAT), 2400)
          print(#blockers)
          print("NUM BLOCKERS")
          for i = 1, #blockers, 1 do
            UTIL_Remove(blockers[i])
          end
          UTIL_Remove(skull)
        end)
      end)
    end
  end)
  local statue = Entities:FindByNameNearest("CastleBossStatue", position, 800)
  EmitGlobalSound("Redfall.BossStatue.Activate")
  for i = 1, 90, 1 do
    Timers:CreateTimer(0.05*i, function()
      statue:SetRenderColor((105/90)*i, (123/90)*i, (221/90)*i)
    end)
  end

end

function Redfall:CastleBossMusic()
  Timers:CreateTimer(4.95, function()
    for i = 1, #MAIN_HERO_TABLE, 1 do
      MAIN_HERO_TABLE[i].bgm ="Music.Redfall.CrimsythCastleBoss"
    end
  end)
  Timers:CreateTimer(5, function()
    -- EmitSoundOnLocationWithCaster(Vector(-14976, -15296), "Music.Redfall.Village", Events.GameMaster)
    -- EmitSoundOnLocationWithCaster(Vector(-12864, -14848), "Music.Redfall.Village", Events.GameMaster)
    if Redfall.FinalBossStart then
      for i = 1, #MAIN_HERO_TABLE, 1 do
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
          CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Redfall.CrimsythCastleBoss"})
      end
    end
    if not Redfall.CastleFinalBossEnd then
      return 51
    end
  end)

end

function Redfall:FinalBossSummon(caster, unitName)
  local unit = nil
  local positionTable = {Vector(-833, 3932, 326), Vector(384, 3968, 326), Vector(1536, 3968), Vector(-833, 2904), Vector(1536, 2944), Vector(-833, 1920), Vector(1536, 1920), Vector(-833, 960), Vector(384, 960), Vector(1536, 960)}
  local position = positionTable[RandomInt(1,#positionTable)]
  if unitName == "redfall_demonic_follower" then
    unit = Redfall:SpawnDemonFollower(position, RandomVector(1))
  elseif unitName == "redfall_crimsyth_recruiter" then
    unit = Redfall:SpawnCrimsythRecruiter(position, RandomVector(1))
  elseif unitName == "redfall_crimsyth_guard" then
    unit = Redfall:SpawnCrymsithGuard(position, RandomVector(1))
  elseif unitName == "redfall_crimsyth_thug" then
    unit = Redfall:SpawnCrimsythThug(position, RandomVector(1))
  elseif unitName == "redfall_crimsyth_berserker" then
    unit = Redfall:SpawnCrymsithBerserker(position, RandomVector(1))
  elseif unitName == "redfall_crimsyth_hawk_soldier" then
    unit = Redfall:SpawnHawkSoldier(position, RandomVector(1))
  elseif unitName == "redfall_crimsyth_mage" then
    unit = Redfall:SpawnCrimsythMage(position, RandomVector(1))
  elseif unitName == "redfall_soul_scar" then
    unit = Redfall:SpawnSoulScar(position, RandomVector(1))
  elseif unitName == "redfall_castle_warflayer" then
    unit = Redfall:SpawnCastleWarflayer(position, RandomVector(1))
  elseif unitName == "redfall_crimsyth_cultist" then
    unit = Redfall:SpawnCrimsythCultistForBoss(position, RandomVector(1))
  end
  EmitSoundOn("Redfall.FinalBoss.Summon", unit)
  AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 500, 10, false)
  
  local animationName = ACT_DOTA_ATTACK
  local attachPoint = "attach_attack1"
  local luck = RandomInt(1,2)
  if luck == 2 then
    animationName = ACT_DOTA_ATTACK2
    attachPoint = "attach_attack2"
  end
  Redfall:createCastleSummonParticle(position, caster, unit, attachPoint)
  StartAnimation(caster, {duration=0.39, activity=animationName, rate=1.0})
  Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_castle_unit_generic", {})
  unit.code = 11
  Dungeons:AggroUnit(unit)
end

function Redfall:FinallBossUnitDie(unit)
  if not Redfall.Castle.FinalBossUnitsKilled then
    Redfall.Castle.FinalBossUnitsKilled = 0
  end
  Redfall.Castle.FinalBossUnitsKilled = Redfall.Castle.FinalBossUnitsKilled + 1
  if Redfall.Castle.FinalBossUnitsKilled == 10 then
      local boss = Redfall.Castle.FinalBoss
      StartAnimation(boss, {duration=2.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.8})
      Quests:ShowDialogueText(MAIN_HERO_TABLE, boss, "redfall_castle_boss_dialogue_5", 6, false)
      EmitSoundOn("Redfall.CastleBoss.IntroVO3", boss)

      Timers:CreateTimer(1.5, function()
          for i = 1, 10, 1 do
            Timers:CreateTimer(i*0.4, function()
              Redfall:FinalBossSummon(boss, "redfall_demonic_follower")
            end)
          end
      end)
  elseif Redfall.Castle.FinalBossUnitsKilled == 18 then
      local boss = Redfall.Castle.FinalBoss
      for i = 1, 4, 1 do
        Timers:CreateTimer(i*0.4, function()
          Redfall:FinalBossSummon(boss, "redfall_crimsyth_guard")
        end)
      end
      Timers:CreateTimer(1.6, function()
        for i = 1, 4, 1 do
          Timers:CreateTimer(i*0.4, function()
            Redfall:FinalBossSummon(boss, "redfall_crimsyth_thug")
          end)
        end
      end)
      Timers:CreateTimer(3.2, function()
        for i = 1, 4, 1 do
          Timers:CreateTimer(i*0.4, function()
            Redfall:FinalBossSummon(boss, "redfall_crimsyth_berserker")
          end)
        end
      end)
  elseif Redfall.Castle.FinalBossUnitsKilled == 30 then
      local boss = Redfall.Castle.FinalBoss
      for i = 1, 20, 1 do
        Timers:CreateTimer(i*0.4, function()
          Redfall:FinalBossSummon(boss, "redfall_crimsyth_mage")
        end)
      end
  elseif Redfall.Castle.FinalBossUnitsKilled == 50 then
      local boss = Redfall.Castle.FinalBoss
      for i = 1, 14, 1 do
        Timers:CreateTimer(i*0.4, function()
          Redfall:FinalBossSummon(boss, "redfall_soul_scar")
        end)
      end
  elseif Redfall.Castle.FinalBossUnitsKilled == 64 then 
      local boss = Redfall.Castle.FinalBoss
      for i = 1, 6, 1 do
        Timers:CreateTimer(i*0.4, function()
          Redfall:FinalBossSummon(boss, "redfall_demonic_follower")
        end)
      end
      Timers:CreateTimer(2.4, function()
        for i = 1, 6, 1 do
          Timers:CreateTimer(i*0.4, function()
            Redfall:FinalBossSummon(boss, "redfall_castle_warflayer")
          end)
        end
      end)
  elseif Redfall.Castle.FinalBossUnitsKilled == 78 then
      local boss = Redfall.Castle.FinalBoss
      for i = 1, 30, 1 do
        Timers:CreateTimer(i*0.3, function()
          Redfall:FinalBossSummon(boss, "redfall_crimsyth_cultist")
        end)
      end
  elseif Redfall.Castle.FinalBossUnitsKilled == 108 then 
    local boss = Redfall.Castle.FinalBoss
    boss:RemoveModifierByName("modifier_waiting")
    
    local ability = boss:FindAbilityByName("redfall_crimsyth_castle_boss_ai")
    
    boss.jumpEnd = "hermit"
    WallPhysics:Jump(boss, Vector(0,-1), 22, 26, 24, 0.8)
    StartAnimation(boss, {duration=2.5, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.7})
    EmitSoundOn("Redfall.CastleBoss.IntroVO1", boss)
    Timers:CreateTimer(3.5, function()
      ability:ApplyDataDrivenModifier(boss, boss, "modifier_final_boss_in_combat_phase_1", {})
      boss:RemoveModifierByName("modifier_castle_boss_shielded_effect")
      StartAnimation(boss, {duration=2.5, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.8})
      EmitSoundOn("Redfall.CastleBoss.Anger1", boss)
      AddFOWViewer(DOTA_TEAM_GOODGUYS, boss:GetAbsOrigin(), 800, 900, false)
      Timers:CreateTimer(1, function()
        boss:SetAcquisitionRange(3000)
      end)
    end)
  end
end

function Redfall:createCastleSummonParticle(position, caster, target, attachPoint)
  local particleName = "particles/roshpit/redfall/red_beam.vpcf"
  local pfx = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
 ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, attachPoint, caster:GetAbsOrigin(), true) 
  ParticleManager:SetParticleControl(pfx,1,target:GetAbsOrigin()+Vector(0,0,422))
  Timers:CreateTimer(3.5, function()
    ParticleManager:DestroyParticle(pfx, false)
  end)  
end

function Redfall:SpawnCrimsythCultistForBoss(position, fv)
  local ancient = Redfall:SpawnDungeonUnit( "redfall_crimsyth_cultist", position, 0, 1, nil, fv, true)
  Events:AdjustBossPower(ancient, 4, 4, false)
  ancient.itemLevel = 110
  ancient.bossLock = true
  ancient:SetRenderColor(255, 50, 50)
  Redfall:ColorWearables(ancient, Vector(255, 50, 50))
  StartAnimation(ancient, {duration=7, activity=ACT_DOTA_VICTORY, rate=1}) 
  return ancient  
end

function Redfall:FinalBossDrops(position)
  local luck = RandomInt(1, 8-GameState:GetPlayerPremiumStatusCount())
  if luck == 1 then
    RPCItems:RollSpellfireGloves(position, Events.SpiritRealm)
  elseif luck == 2 then
    RPCItems:RollHoodOfLords(position, Events.SpiritRealm)
  end
end

function Redfall:SpawnLavaBehemoth(position, fv)
  local stone = Redfall:SpawnDungeonUnit("redfall_lava_behemoth", position, 2, 5, "Redfall.LavaBehemoth.Aggro", fv, false)
  stone.itemLevel = 136
  stone:SetRenderColor(255, 190, 190)
  Redfall:ColorWearables(stone, Vector(255, 200, 200))
  Events:AdjustBossPower(stone, 7, 7, false)
  Events:SetPositionCastArgs(stone, 1400, 0, 1, FIND_ANY_ORDER)
  return stone
end


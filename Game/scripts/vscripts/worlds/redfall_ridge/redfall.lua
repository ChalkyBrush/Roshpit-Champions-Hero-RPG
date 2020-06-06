if Redfall == nil then
  Redfall = class({})
end

Redfall.TOTAL_QUESTS = 8

require('worlds/redfall_ridge/redfall_ridge_quests/redfall_ridge_quests_require')

require('worlds/redfall_ridge/redfall_forest/redfall_forest_spawning')
require('worlds/redfall_ridge/redfall_forest/redfall_forest_spawning_async')
require('worlds/redfall_ridge/zones/autumn_mist_cavern')
require('worlds/redfall_ridge/zones/redfall_farmlands')
require('worlds/redfall_ridge/zones/abandoned_shipyard')
require('worlds/redfall_ridge/zones/crimsyth_castle')
require('quests/redfall_quests')

function Redfall:Debug()
  if MAIN_HERO_TABLE[1] then
    --MAIN_HERO_TABLE[1]:SetBaseStrength(25000)
    --MAIN_HERO_TABLE[1]:SetBaseAgility(25000)
    --MAIN_HERO_TABLE[1]:SetBaseIntellect(25000)
    --MAIN_HERO_TABLE[1]:SetBaseDamageMax(50000)
    --MAIN_HERO_TABLE[1]:SetBaseDamageMin(50000)
    --MAIN_HERO_TABLE[1]:CalculateStatBonus()
    -- local hero = MAIN_HERO_TABLE[1]
    -- hero.runeUnit2.amulet.e_2 = hero.runeUnit2.amulet.e_2 + 1500
    -- Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.e_2, "rune_e_2", hero)
    -- hero.runeUnit3.amulet.w_3 = hero.runeUnit3.amulet.w_3 + 500
    -- Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.w_3, "rune_w_3", hero)
    -- hero.runeUnit2.amulet.q_2 = hero.runeUnit2.amulet.q_2 + 500
    -- Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.q_2, "rune_q_2", hero)
    -- hero.runeUnit.amulet.q_1 = hero.runeUnit.amulet.q_1 + 500
    -- Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.q_1, "rune_q_1", hero)
    -- hero.runeUnit.amulet.r_1 = hero.runeUnit.amulet.r_1 + 500
    -- Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.r_1, "rune_r_1", hero)
    -- hero.runeUnit3.amulet.r_3 = hero.runeUnit3.amulet.r_3 + 500
    -- Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.r_3, "rune_r_3", hero)
  end
  -- Redfall.Castle = {}
  -- Redfall.Castle.BossStatuesActivated = 2
  -- Redfall.Castle.FinalSwitchPressed = true
  -- Redfall.Shipyard = {}
  -- Redfall:SpawnBossRoom()
  local item = RPCItems:CreateItem("item_debug_blink", nil, nil)
  local drop = CreateItemOnPositionSync(Vector(-15168, -14976), item)
  local position = Vector(-15168, -14976)
  RPCItems:DropItem(item, Vector(-15168, -14976))
  -- Dungeons.itemLevel = 300
  -- RPCItems:RollWorldTreesFlowerCache(Vector(-15168, -14976))
  -- RPCItems:RollRedOctoberBoots(Vector(-15168, -14976), true)
  -- -- Glyphs:DropArcaneCrystals(Vector(-15168, -14976), 1.0)
  -- -- RPCItems:RollPhoenixEmblem(Vector(-15168, -14976))
  -- -- Redfall:SpawnRedRaven(Vector(-15168, -14976), RandomVector(1))
  -- Redfall:GiveBurgundyFirefly(MAIN_HERO_TABLE[1])
  -- Arena = {}
  -- Arena.PitLevel = 7
  -- Weapons:RollLegendWeapon1(Vector(-15168, -14976), "sephyr")
  -- Weapons:RollLegendWeapon2(Vector(-15168, -14976), "sephyr")
  -- Weapons:RollLegendWeapon3(Vector(-15168, -14976), "sephyr")
  -- RPCItems:RollWindDeityCrown(Vector(-15168, -14976), true, 7)
  -- -- Redfall:GiveVermillionBundle(MAIN_HERO_TABLE[1], Vector(-15168, -14976))
  -- Redfall:GiveShipyardKey(MAIN_HERO_TABLE[1], Vector(-15168, -14976))
  -- Redfall:GiveDemonRelic(MAIN_HERO_TABLE[1], Vector(-15168, -14976))
  -- RPCItems:RollStormcrackHelm(Vector(-15168, -14976), false)
  -- RPCItems:RollHalcyonSoulGlove(Vector(-15168, -14976))
  -- RPCItems:RollAstralArcana1(Vector(-15168, -14976))
  -- RPCItems:RollRavenIdol(Vector(-15168, -14976))
  -- RPCItems:RollPhoenixEmblem(Vector(-15168, -14976))
  -- RPCItems:RollBaronsStormArmor(Vector(-15168, -14976))
  -- RPCItems:RollVioletGuardArmor(Vector(-15168, -14976))
  -- RPCItems:RollNeptunesWaterGliders(Vector(-15168, -14976))
  -- Arena = {}
  -- Arena.PitLevel = 4
  -- Weapons:RollLegendWeapon1(Vector(-15168, -14976), "chernobog")
  -- RPCItems:RollSpaceTechVest(Vector(-15168, -14976))
  -- Dungeons.itemLevel = 300
  -- RPCItems:RollVoltexArcana1(Vector(-15168, -14976))
  -- for i = 1, 3, 1 do
  --   RPCItems:RollConjurorArcana1(Vector(-15168, -14976))
  -- end
  -- RPCItems:RollPaladinArcana1(Vector(-15168, -14976))
  -- RPCItems:RollPaladinArcana1(Vector(-15168, -14976))
  -- RPCItems:RollSunCrystal(Vector(-15168, -14976), 50)
  -- Redfall:GiveSpiritRuby(MAIN_HERO_TABLE[1], Vector(0,0))
  -- RPCItems:RollSeinaruArcana1(Vector(-15168, -14976))
  -- RPCItems:RollDoomplate(Vector(-15168, -14976))

  -- Redfall:SpawnAncientTree()
  -- local variantName = "item_rpc_".."ekkan".."_glyph_2_1"
  -- Glyphs:RollGlyphAll(variantName, Vector(-15168, -14976), 0)

  -- local variantName = "item_rpc_".."ekkan".."_glyph_5_a"
  -- Glyphs:RollGlyphAll(variantName, Vector(-15168, -14976), 0)
  -- Arena = {}
  -- Arena.PitLevel = 4
  -- Weapons:RollLegendWeapon1(Vector(-15168, -14976), "ekkan")
  -- Redfall:OpenAbandonedShipyard()
  --   local rat = Redfall:SpawnShipyardConductor(Vector(11072, -7488), Vector(1,-1), false)
  --   Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, rat, "modifier_lobster_statue_enemy", {})
  -- RPCItems:VermillionDreamRobes(Vector(-15168, -14976))

  -- Arena = {}
  -- Arena.PitLevel = 4
  -- Weapons:RollLegendWeapon1(Vector(-15168, -14976), "flamewaker")

  -- RPCItems:RollHoodOfLords(Vector(-15168, -14976))
  -- RPCItems:RollSpellfireGloves(Vector(-15168, -14976))
  -- RPCItems:RollBloodstoneBoots(Vector(-15168, -14976))
  -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(5752,-7560), 500000, 500000, false)
  -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(8600,-12192), 500000, 500000, false)
  -- RPCItems:RollCrimsythEliteGreavesLV1(Vector(-15168, -14976))
  -- InitializeSidequestShredder()

  --   Redfall.ShredderSidequestActive = true
  --   Redfall.ShredderUpgradeTable = {true, false, false}
  --   local bladePFX = ParticleManager:CreateParticle("particles/roshpit/redfall/whirl_preview_tay.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
  --   ParticleManager:SetParticleControl(bladePFX, 0, Vector(5905, -5359, 58+Redfall.ZFLOAT))
  -- Redfall:GiveVermillionBundle(MAIN_HERO_TABLE[1], Vector(-15168, -14976))
  -- Redfall:LowerBossRoomWall()
  -- RPCItems:RollShipyardVeil1(Vector(-15168, -14976))
  -- Redfall:DropEnchantedLeaf(Vector(-15168, -14976))
  -- RPCItems:RollBootsOfAshara(Vector(-15168, -14976))
  -- RPCItems:RollAutumnrockBracers(Vector(-15168, -14976))
  -- RPCItems:RollGuardOfFeronia(Vector(-15168, -14976))
  -- RPCItems:RollFuchsiaRing(Vector(-15168, -14976))
  -- RPCItems:RollHelmOfSilentTemplar(Vector(-15168, -14976), false)
  -- Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, MAIN_HERO_TABLE[1], "modifier_blessing_of_ashara", {})
    --Redfall:DropAshTwig(Vector(-15168, -14976))
  -- RPCItems:RollEyeOfSeasons(Vector(-15168, -14976), false)
  -- RPCItems:RollRedfallRunners(Vector(-15168, -14976))
  -- RPCItems:RollSandstreamSlippers(Vector(-15168, -14976))
  -- RPCItems:RollMalachiteShadeBracer(Vector(-15168, -14976))
  -- local variantName = "item_rpc_".."venomort".."_glyph_5_a"
  -- Glyphs:RollGlyphAll(variantName, Vector(-15168, -14976), 0)
  -- RPCItems:RollBasiliskPlagueHelm(Vector(-15168, -14976), false)
  -- RPCItems:RollCytopianLaserGloves(Vector(-15168, -14976))
  -- RPCItems:RollDoomplate(Vector(-15168, -14976))
  -- RPCItems:RollCrimsonSkullCap(Vector(-15168, -14976), false)
  -- RPCItems:RollClawOfTheEtherealRevenant(Vector(-15168, -14976))
  -- Redfall:SpawnCanyonDinosaur(Vector(-11712, 3200), Vector(-1,-1))
  -- Redfall:SpawnCrimsythCultMaster(Vector(-15168, -14976), Vector(0,-1))

end

function Redfall:Debug2()
      -- local position = MAIN_HERO_TABLE[1]:GetAbsOrigin()
      -- local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NEUTRALS)
      -- dummy:AddAbility("ability_blue_effect"):SetLevel(1)
      -- dummy:SetAbsOrigin(dummy:GetAbsOrigin() + Vector(0, 0, 1200))
      -- local pfx = CustomAbilities:QuickAttachParticle("particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", dummy, 10)
      -- ParticleManager:SetParticleControl(pfx, 14, Vector(1,1,1))
      -- ParticleManager:SetParticleControl(pfx, 15, Vector(0,30,255))
      --print("SPAWN LILY")
      -- WallPhysics:Jump(dummy, Vector(1, 1), 0, 0, 0, 0.05)
      -- Timers:CreateTimer(10, function()
      --   local unit = Redfall:SpawnWaterLily(dummy:GetAbsOrigin(), RandomVector(1), false)
      --   unit:SetAbsOrigin(dummy:GetAbsOrigin())
      --   unit:SetAbsOrigin(unit:GetAbsOrigin() - Vector(0, 0, 40))
      --   EmitSoundOn("Redfall.Aqualily.Spawn", unit)
      --   CustomAbilities:QuickAttachParticle("particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf", unit, 4)
      --   -- StartAnimation(unit, {duration=1, activity=ACT_DOTA_SPAWN, rate=1})
      --   UTIL_Remove(dummy)
      -- end)
-- Redfall:SpawnShipyardPt2()
    -- Redfall:SpawnBigFlower(MAIN_HERO_TABLE[1]:GetAbsOrigin(), Vector(1,0))
  --print("HELLO?")
  -- Events:MainBossSlain("redfall_crimsyth_castle_boss")
  -- Redfall:InitiateCrimsythCastleIntro()
  -- Redfall:InitiateDebugRedfall()
  -- Redfall:SpawnCanyonBoss()
  -- Redfall:SpawnAshara(Vector(1244, -14776), Vector(0,-1))
  --     for i = 1, #MAIN_HERO_TABLE, 1 do
  --         MAIN_HERO_TABLE[i].RedfallQuests[1].state = 4
  --         MAIN_HERO_TABLE[i].RedfallQuests[1].goal = 4
  --         CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "newQuest", {} )
  --     end
  -- Weapons:RollLegendWeapon1(Vector(1244, -14776), "chernobog")
  -- Dungeons.itemLevel = 300
  -- Weapons:RollWeapon(Vector(-15168, -14976))

  -- Redfall:ShipyardBossReadyForBattle()
  -- Redfall:LowerSwitch2andSpawners()
  -- Redfall:ShipyardGatekeeperBoss()
  -- Redfall:RaiseShipyardBridge()
  -- Redfall:SpawnShipyardFerry()
  -- Paragon:SpawnParagonUnit("shipyard_armored_bear_guard", Vector(-15168, -14976))
  -- DeepPrintTable(GameState.HeroPlayerTable)
  -- local hero = GameState:GetHeroByPlayerID(0)
  ----print(hero:GetEntityIndex())
  -- local caster = MAIN_HERO_TABLE[1].shredder
  --   local shredderAbility = caster:FindAbilityByName("redfall_friendly_shredder_passive" )
  --   shredderAbility:ApplyDataDrivenModifier(caster, caster, "modifier_shredder_lumber", {})
  --   local currentStack = caster:GetModifierStackCount("modifier_shredder_lumber", caster)
  --   caster:SetModifierStackCount("modifier_shredder_lumber", caster, currentStack + 100)

  -- local hero = MAIN_HERO_TABLE[1]
  -- for i = 0, 11, 1 do
  --  --print("-----loop----"..i)
  --   local item = hero:GetItemInSlot(i)
  --   if IsValidEntity(item) then
  --    --print(item:GetAbilityName())
  --   end
  -- end

  -- CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[1]:GetPlayerOwner(), "collect_arcane", {gain = 10})
end

function Redfall:SpawnTrainingDummy(position)
  local positionTable = {position}
  for i = 1, #positionTable, 1 do
    local dummy = CreateUnitByName("arena_training_dummy", positionTable[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
    dummy:SetForwardVector(Vector(1, -1))
    dummy.targetPosition = dummy:GetAbsOrigin()
    local dummyAbility = dummy:FindAbilityByName("training_dummy_ability")
    dummyAbility:ApplyDataDrivenModifier(dummy, dummy, "modifier_dummy_red", {})
    dummy.pushLock = true
  end

end


function Redfall:CreateCollectionBeam(attachPointA, attachPointB)
  local particleName = "particles/items_fx/mithril_collect.vpcf"
  local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
  ParticleManager:SetParticleControl(lightningBolt, 0, Vector(attachPointA.x, attachPointA.y, attachPointA.z))
  ParticleManager:SetParticleControl(lightningBolt, 1, Vector(attachPointB.x, attachPointB.y, attachPointB.z))
  Timers:CreateTimer(2, function()
    ParticleManager:DestroyParticle(lightningBolt, false)
  end)
end

function Redfall:GiveVermillionBundle(hero, position)
  local itemName = "item_redfall_purified_vermillion_bundle_normal"
  local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
  EmitSoundOn("Resource.MithrilShardEnter", hero)
  Redfall:CreateCollectionBeam(position, hero:GetAbsOrigin())
  CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", hero, 0.5)
  RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
end

function Redfall:GiveShipyardKey(hero, position)
  local itemName = "item_redfall_hidden_shipyard_key_"..GameState:GetDifficultyName()
  local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
  EmitSoundOn("Resource.MithrilShardEnter", hero)
  Redfall:CreateCollectionBeam(position, hero:GetAbsOrigin())
  CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", hero, 0.5)
  RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
end

function Redfall:GiveDemonRelic(hero, position)
  local itemName = "item_redfall_crimsyth_demon_relic_"..GameState:GetDifficultyName()
  local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
  EmitSoundOn("Resource.MithrilShardEnter", hero)
  Redfall:CreateCollectionBeam(position, hero:GetAbsOrigin())
  CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", hero, 0.5)
  RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
end

function Redfall:InitCamp()
    Dungeons.phoenixCollision = true
    RPCItems.DROP_LOCATION = Vector(6656, -16128)
    Events:SpawnGamemaster(RPCItems.DROP_LOCATION)
    Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
    Events.GameMaster:RemoveModifierByName("modifier_portal")
    Redfall.Castle = {}

    Redfall.ZFLOAT = Redfall:GetRedfallZFLOAT()

    Events.TownPosition = Vector(-15168, -14976)
    Events.isTownActive = true
    
    -- end)
    Redfall:OceanSounds()
    Redfall:OceanSplashes()
    Redfall:VillageMusic()

    Timers:CreateTimer(8, function()
        --Init Forest
    	local vectorTable = {Vector(-12480, -12754), Vector(-12608, -12692), Vector(-12453, -12617)}
        local bottomLeftPos = Vector(-11840, -12711)
        for i = 0, 10, 1 do
            local randomX = RandomInt(1, 1050)
            local randomY = RandomInt(1, 810)
            local spawnPos = bottomLeftPos + Vector(randomX, randomY)
            table.insert(vectorTable, spawnPos)
        end
        for i = 1, #vectorTable, 1 do
            Redfall:SpawnRedfallShroom(vectorTable[i])
        end
        Timers:CreateTimer(3, function()
            Redfall:SpawnTrainingDummy(Vector(-13504, -11072))
            Redfall:SpawnAutumnGazer(Vector(-14080, -12275), Vector(0.2, -1))
            Redfall:SpawnAutumnGazer(Vector(-13684, -12395), Vector(0, -1))
            Redfall:SpawnAutumnGazer(Vector(-13248, -12241), Vector(0, -1))
            Redfall:SpawnAutumnGazer(Vector(-13783, -13110), Vector(-0.4, 1))
            Redfall:SpawnAutumnGazer(Vector(-13312, -13002), Vector(0, 1))
            local vecTable2 = {Vector(-14355, -13184), Vector(-14209, -13056), Vector(-13950, -12530), Vector(-13209, -12951)}
            for i = 1, #vecTable2, 1 do
                Redfall:SpawnRedfallShroom(vecTable2[i])
            end
        end)
        Timers:CreateTimer(5, function()
            Redfall:SpawnAutumnSpawner(Vector(-11584, -11648, 47), Vector(-1, -1), Vector(-11819, -11786))
            Redfall:SpawnAutumnSpawner(Vector(-10302, -12817, 47), Vector(-1, 1), Vector(-10496, -12688))
            Redfall:SpawnAutumnSpawner(Vector(-12608, -10708, 47), Vector(1, -1), Vector(-12416, -10833))
            Redfall:SpawnAutumnSummoner(Vector(-12160, -11382), Vector(0, -1))
            if GameState:GetDifficultyFactor() > 1 then
                Redfall:SpawnAutumnSummoner(Vector(-12416, -11264), Vector(1, -1))
            end
        end)
        Timers:CreateTimer(8, function()
            Redfall:SpawnRedfallForestMinion(Vector(-10979, -13768), Vector(1, -1), false)
            Redfall:SpawnRedfallForestMinion(Vector(-11104, -14103), Vector(1, 0.5), false)
            Redfall:SpawnRedfallForestMinion(Vector(-10302, -13893), Vector(-1, -1), false)
            Redfall:SpawnRedfallForestMinion(Vector(-10254, -14144), Vector(-1, 0.6), false)
        end)
        Timers:CreateTimer(5, function()
            Redfall:SpawnFenrirGhost()
        end)
        local bridge = Entities:FindAllByNameWithin("RedfallForest_RedfallFarmlands_Bridge", Vector(1728, -7281.91, 100 + Redfall.ZFLOAT), 3000)
        for i = 1, #bridge, 1 do
            bridge[i]:SetAbsOrigin(bridge[i]:GetAbsOrigin() - Vector(0, 0, 1000))
        end
    end)
    Redfall.RedfallMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Redfall.RedfallMaster:AddAbility("redfall_ability"):SetLevel(GameState:GetDifficultyFactor())
    Redfall.RedfallMasterAbility = Redfall.RedfallMaster:FindAbilityByName("redfall_ability")
    Redfall.RedfallMaster:AddAbility("dummy_unit"):SetLevel(1)

    Timers:CreateTimer(4, function()
        local quest1GiverSpawner = Entities:FindAllByName("npc_spawner_redfall_first_quest_giver")[1]
        if quest1GiverSpawner then
            local callback = function(quest1Giver)
                quest1Giver:SetForwardVector(quest1GiverSpawner:GetForwardVector())
                quest1Giver:NoHealthBar()
                quest1Giver:AddAbility("town_unit")
                quest1Giver:FindAbilityByName("town_unit"):SetLevel(1)
                quest1Giver:SetModelScale(1.1)
                quest1Giver.dialogueName = "redfall_first_quest_giver"
                Redfall.Quest1Giver = quest1Giver
                quest1Giver:SetRenderColor(255, 110, 110)
    
                local exclamationMark = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(quest1GiverSpawner:GetAbsOrigin().x, quest1GiverSpawner:GetAbsOrigin().y, Redfall.ZFLOAT + 150)})
                exclamationMark:SetModel("models/ui/exclamation/exclamation.vmdl")
                exclamationMark:SetModelScale(0.05)		
                exclamationMark:SetForwardVector(quest1GiverSpawner:GetForwardVector())
                Redfall.Quest1Giver.ExclamationMark = exclamationMark
            end
            CreateUnitByNameAsync("redfall_first_quest_giver", quest1GiverSpawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS, callback)
        end
        Redfall:AutumnParticles()
    end)
    Redfall:InitCorruptedTrees()
    Redfall:CalculateHeroZones()
end

function Redfall:GetRedfallZFLOAT()
  return 1024
end

function Redfall:InitCorruptedTrees()
    Timers:CreateTimer(3, function()
        local treeVectorTable = {
            Vector(-13285, -10545, 267), 
            Vector(-9216, -7616, 126), 
            Vector(-6279, -10397, 140), 
            Vector(-4466, -12800, 291), 
            Vector(-1479, -7313, 127), 
            Vector(-9931, -6006, 144)
        }
        local randomIndex1 = RandomInt(1, 6)
        local randomIndex2 = RandomInt(1, 6)
        local randomIndex3 = RandomInt(1, 6)
        while randomIndex1 == randomIndex2 do
            randomIndex2 = RandomInt(1, 6)
        end
        while randomIndex1 == randomIndex3 or randomIndex2 == randomIndex3 do
            randomIndex3 = RandomInt(1, 6)
        end
        local indexTable = {randomIndex1, randomIndex2, randomIndex3}
        for j = 1, #indexTable, 1 do
            local tree = Entities:FindByNameNearest("VermillionTreeCorrupted", treeVectorTable[indexTable[j]] + Vector(0, 0, Redfall.ZFLOAT), 1200)
            local blocker = Entities:FindByNameNearest("TreeBlocker", treeVectorTable[indexTable[j]] + Vector(0, 0, Redfall.ZFLOAT), 2400)
            local healedTree = Entities:FindByNameNearest("VermillionTreeHealed", treeVectorTable[indexTable[j]] - Vector(0, 0, 700) + Vector(0, 0, Redfall.ZFLOAT), 1200)
            UTIL_Remove(tree)
            UTIL_Remove(healedTree)
            UTIL_Remove(blocker)
        end
    end)
end

function Redfall:VillageMusic()
  Timers:CreateTimer(10, function()
    -- EmitSoundOnLocationWithCaster(Vector(-14976, -15296), "Music.Redfall.Village", Events.GameMaster)
    -- EmitSoundOnLocationWithCaster(Vector(-12864, -14848), "Music.Redfall.Village", Events.GameMaster)
    -- if not Redfall.AutumnMistCanyon then
    --   -- CustomGameEventManager:Send_ServerToAllClients("BGMstart", {songName = "Music.Redfall.Village"})
    -- else
    for i = 1, #MAIN_HERO_TABLE, 1 do
      if MAIN_HERO_TABLE[i].bgm == "Music.Redfall.Village" then
        CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
        CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Redfall.Village"})
      end
    end
    -- end
    return 110
  end)
end

function Redfall:FarmlandsMusic()
  Timers:CreateTimer(4.95, function()
    for i = 1, #MAIN_HERO_TABLE, 1 do
      MAIN_HERO_TABLE[i].bgm = "Music.Redfall.Farmlands"
    end
  end)
  Timers:CreateTimer(5, function()
    -- EmitSoundOnLocationWithCaster(Vector(-14976, -15296), "Music.Redfall.Village", Events.GameMaster)
    -- EmitSoundOnLocationWithCaster(Vector(-12864, -14848), "Music.Redfall.Village", Events.GameMaster)

    for i = 1, #MAIN_HERO_TABLE, 1 do
      if MAIN_HERO_TABLE[i].bgm == "Music.Redfall.Farmlands" then
        CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMend", {})
        CustomGameEventManager:Send_ServerToPlayer(MAIN_HERO_TABLE[i]:GetPlayerOwner(), "BGMstart", {songName = "Music.Redfall.Farmlands"})
      end
    end

    return 119
  end)
end

function Redfall:OceanSounds()
  Timers:CreateTimer(10, function()
    local vectorTable = {Vector(-10083, -15329, -740), Vector(-6592, -15987), Vector(-4556, -15755), Vector(-1721, -14688), Vector(1024, -6976), Vector(-2560, -3712), Vector(-7680, -3008)}
    for i = 1, #vectorTable, 1 do
      EmitSoundOnLocationWithCaster(vectorTable[i], "Ambient.Redfall.Cliff", Events.GameMaster)
    end
    local riverTable = {Vector(-11264, -8512), Vector(-5824, -6720), Vector(-1536, -9472)}
    for i = 1, #riverTable, 1 do
      EmitSoundOnLocationWithCaster(riverTable[i], "Redfall.LightWaterfall", Events.GameMaster)
    end

    return 30
  end)
end

function Redfall:OceanSplashes()
  Timers:CreateTimer(15, function()
    local vectorTable = {Vector(-10752, -15742, -740), Vector(-10083, -15329, -740), Vector(-9536, -15905, -741), Vector(-8704, -14967, -741), Vector(-8328, -15168, -741), Vector(-7680, -14964, -741), Vector(-7079, -15328, -741), Vector(-6116, -15036, -741), Vector(-5879, -15740, -741), Vector(-4864, -14967, -741), Vector(-3712, -14976, -741), Vector(-2935, -15358, -741), Vector(-2432, -15936, -741), Vector(-2304, -13696, -741), Vector(960, -5824, -730), Vector(-512, -4648, -730), Vector(-2880, -3648, -730), Vector(-4480, -3444, -730), Vector(-7424, -2923, -730), Vector(-8963, -1408, -730), Vector(-8384, -1664, -730), Vector(-7680, -1664, -730), Vector(-7428, -1408, -730)}
    local particleName = "particles/roshpit/redfall/cliff_splash.vpcf"
    for i = 1, 2, 1 do
      local position = vectorTable[RandomInt(1, #vectorTable)] + Vector(0, 0, Redfall.ZFLOAT - 20)
      local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
      ParticleManager:SetParticleControl(pfx, 0, position)
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(pfx, false)
      end)
    end
    return 0.4
  end)
end

function Redfall:SpawnDungeonUnit(unitName, spawnPoint, minDrops, maxDrops, aggroSound, fv, isAggro)

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
  Redfall.RedfallMasterAbility:ApplyDataDrivenModifier(Redfall.RedfallMaster, unit, "modifier_redfall_unit", {})
  if fv then
    unit:SetForwardVector(fv)
  end
  if isAggro then
    Dungeons:AggroUnit(unit)
  end
  return unit
end

function Redfall:ColorWearables(unit, color)
  for k, v in pairs(unit:GetChildren()) do
    if v:GetClassname() == "dota_item_wearable" then
      local model = v:GetModelName()
      v:SetRenderColor(color[1], color[2], color[3])
    end
  end
end

function Redfall:InitializeHero(hero)
  local questTable = {}
  for i = 1, Redfall.TOTAL_QUESTS, 1 do
    local quest = {}
    quest.state = -1
    quest.active = 0
    table.insert(questTable, quest)
  end
  hero.RedfallQuests = questTable
end

function Redfall:SpawnTownNPCNoDialogue(position, fv, model, modelScale, renderColor, unitName)
  local foxNPC = CreateUnitByName(unitName, position, true, nil, nil, DOTA_TEAM_GOODGUYS)
  foxNPC:SetForwardVector(fv)
  if model then
    foxNPC:SetOriginalModel(model)
    foxNPC:SetModel(model)
  end
  foxNPC:SetModelScale(modelScale)
  foxNPC:NoHealthBar()
  foxNPC:AddAbility("town_unit")
  foxNPC:FindAbilityByName("town_unit"):SetLevel(1)
  return foxNPC
end

function Redfall:Dialogue(caster, units, dialogueName, time, xOffset, yOffset, bOverride)
  local speechSlot = Redfall:findEmptyDialogSlot()
  if speechSlot < 4 then
    Quests:ShowDialogueText(units, caster, dialogueName, time, false)
    --caster:AddSpeechBubble(1, dialogueName, time, xOffset, yOffset)
    Redfall:disableSpeech(caster, time, speechSlot)
  end
end

function Redfall:findEmptyDialogSlot()
  if not Events.Dialog1 then
    Events.Dialog1 = true
    return 1
  elseif not Events.Dialog2 then
    Events.Dialog2 = true
    return 2
  elseif not Events.Dialog3 then
    Events.Dialog3 = true
    return 3
  end
  return 4
end

function Redfall:clearDialogSlot(slot)
  if slot == 1 then
    Events.Dialog1 = false
  elseif slot == 2 then
    Events.Dialog2 = false
  elseif slot == 3 then
    Events.Dialog3 = false
  end
end

function Redfall:disableSpeech(caster, time, speechSlot)
  caster.hasSpeechBubble = true
  Timers:CreateTimer(time, function()
    caster.hasSpeechBubble = false
    Redfall:clearDialogSlot(speechSlot)
  end)
end

function Redfall:AddPatrolArguments(unit, patrolSlow, phaseIntervals, patrolPointRandom, patrolPositionTable)
  unit:AddAbility("monster_patrol"):SetLevel(1)
  unit.patrolSlow = patrolSlow
  unit.phaseIntervals = phaseIntervals
  unit.patrolPointRandom = patrolPointRandom
  unit.patrolPositionTable = patrolPositionTable
end

function Redfall:DialogueAnswer(msg)
    local accept = msg.accept
    local npc = msg.npc
    local intattr = msg.intattr
    local playerID = msg.playerID
    local hero = false
    if playerID then
        hero = GameState:GetHeroByPlayerID(playerID)
    end
    if accept == 0 then
    elseif accept == 1 then
        if npc == "redfall_otaru" then
            if not Redfall.OtaruQuestStarted then
                Redfall.OtaruQuestStarted = true
                Quests:StartNewQuest("cleansing_the_coast")
                UTIL_Remove(Redfall.Otaru.ExclamationMark)
                EndAnimation(Redfall.Otaru)
                Redfall:Dialogue(Redfall.Otaru, MAIN_HERO_TABLE, "redfall_otaru_dialogue_2", 6, 5, -40, true)
                Timers:CreateTimer(1, function()
                    Redfall.Otaru.state = 1
                    Redfall.Otaru.altSummon = 0
                end)
            end
            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "close_left_leaderboard", {})
        end
    end
end

function Redfall:CalculateHeroZones()
    Timers:CreateTimer(5, function()
        if MAIN_HERO_TABLE then
            for i = 1, #MAIN_HERO_TABLE, 1 do
                local hero = MAIN_HERO_TABLE[i]
                local player = hero:GetPlayerOwner()
                local heroOrigin = hero:GetAbsOrigin()
                local zoneName = ""
                if (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-16256, -16256), Vector(-12032, -13760))) then
                    zoneName = "redfall_village"
                    hero.bgm = "Music.Redfall.Village"
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-16128, -13440), Vector(-12480, -9664))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-12480, -12864), Vector(451, -2354))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-11456, -16128), Vector(2029, -13607))) then
                    zoneName = "redfall_forest"
                    hero.bgm = "Music.Redfall.Village"
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-16064, -9024), Vector(-12544, -7616))) then
                    zoneName = "autumn_mist_canyon_entrance"
                    hero.bgm = nil
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-16000, -7296), Vector(-10432, 15360))) then
                    zoneName = "autumn_mist_canyon"
                    hero.bgm = "Music.Redfall.AutumnMistCavern"
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(3800, -15360), Vector(16512, -9984))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(1752, -12074), Vector(10350, -659))) then
                    zoneName = "redfall_farmlands"
                    hero.bgm = "Music.Redfall.Farmlands"
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(11300, -9152), Vector(16064, 8576))) then
                    zoneName = "abandoned_shipyard"
                    hero.bgm = "Music.Redfall.AbandonedShipyard"
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(13696, 9152), Vector(16256, 12351))) then
                    if Redfall.Shipyard then
                        if Redfall.Shipyard.BossBattleEnd then
                            zoneName = "abandoned_shipyard_boss_room"
                            hero.bgm = "Music.Redfall.AbandonedShipyard"
                        else
                            zoneName = "abandoned_shipyard_boss_room"
                            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "BGMend", {})
                            hero.bgm = "Music.RedfallShipyard.Boss"
                        end
                    end
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(384, 10176), Vector(11712, 15953))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(10816, 12928), Vector(15808, 16192))) then
                    zoneName = "redfall_crimsyth_castle_intro"
                    if Redfall.CastleStart then
                        hero.bgm = "Music.Redfall.CrimsythCastle"
                    else
                        hero.bgm = "Music.Redfall.CrimsythCastleIntro"
                    end
                elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-7936, 3776), Vector(12096, 11008))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-5760, -1088), Vector(8832, 5376))) or (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-8768, 3264), Vector(-184, 16642))) then
                    zoneName = "redfall_crimsyth_castle"
                    hero.bgm = "Music.Redfall.CrimsythCastle"
                else
                -- zoneName = "zone_redfall" } )
                end
                if zoneName ~= "" and (not hero.currentZone or hero.currentZone ~= zoneName) then
                    hero.currentZone = zoneName
                    CustomGameEventManager:Send_ServerToPlayer(player, "update_zone_display", {zoneName = zoneName})
                    Notifications:Top(player, { text = zoneName, duration=4, style={color="#FFDDAA"}, continue=true})
                end
            end
        end
        return 3.5
    end)
end

--

function Redfall:AutumnParticles()
  Redfall.WeatherParticles = {}
  local region = {Vector(-16256, -16256), Vector(-12032, -13760)}
  Redfall:CreateAutumnParticlesForRegion(region)
  local region = {Vector(-16128, -13440), Vector(-12480, -9664)}
  Redfall:CreateAutumnParticlesForRegion(region)
  local region = {Vector(-12480, -12864), Vector(-3300, -5054)}
  Redfall:CreateAutumnParticlesForRegion(region)
  local region = {Vector(-11456, -14028), Vector(-3329, -13007)}
  Redfall:CreateAutumnParticlesForRegion(region)

end

function Redfall:CreateAutumnParticlesForRegion(region)
  for i = 1, #region, 1 do
    local particleName = "particles/rain_fx/autumn_terrain.vpcf"
    local pfx = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster)
    local position = region[i] + Vector(1300, 1300, 1000 + Redfall.ZFLOAT)
    ParticleManager:SetParticleControl(pfx, 0, position)
    ParticleManager:SetParticleControl(pfx, 1, position)
    table.insert(Redfall.WeatherParticles, pfx)
  end
end

function Redfall:DefeatDungeonBoss(dungeon, position)
  Timers:CreateTimer(5, function()
    local mithrilReward = 0
    local starTitle = nil
    if dungeon == "canyon" then
      mithrilReward = REDFALL_MITHRIL_CANYON
      starTitle = "autumnmist"
    elseif dungeon == "shipyard" then
      mithrilReward = REDFALL_MITHRIL_SHIPYARD
      starTitle = "shipyard"
    elseif dungeon == "castle" then
      mithrilReward = REDFALL_MITHRIL_CASTLE
      starTitle = "castle"
    elseif dungeon == "ancient_tree" then
      mithrilReward = REDFALL_MITHRIL_WORLD_TREE
    elseif dungeon == "ashara" then
      mithrilReward = REDFALL_MITHRIL_ASHARA
    end
    if starTitle then
      for i = 1, #MAIN_HERO_TABLE, 1 do
        Stars:StarEventPlayer(starTitle, MAIN_HERO_TABLE[i])
      end
    end
    local mithrilMult = REDFALL_MITHRIL_NORMAL_MULT
    if GameState:GetDifficultyFactor() == 2 then
      mithrilMult = REDFALL_MITHRIL_ELITE_MULT
    elseif GameState:GetDifficultyFactor() == 3 then
      mithrilMult = REDFALL_MITHRIL_LEGEND_MULT
    end
    if Events.SpiritRealm then
      mithrilMult = mithrilMult * REDFALL_MITHRIL_EQUINOX_MULT
    end
    mithrilReward = math.floor(mithrilReward * mithrilMult) * Events.ResourceBonus
    local crystal = CreateUnitByName("arcane_crystal", position + Vector(0, 0, 1000), false, nil, nil, DOTA_TEAM_GOODGUYS)
    crystal:SetAbsOrigin(crystal:GetAbsOrigin() + Vector(0, 0, 1300))
    local crystalAbility = crystal:AddAbility("mithril_shard_ability")
    crystalAbility:SetLevel(1)
    local fv = RandomVector(1)
    crystal:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
    crystal:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
    crystal.reward = mithrilReward
    crystal.reward = math.floor(crystal.reward * (1 + GameState:GetPlayerPremiumStatusCount() * 0.1))
    crystal.distributed = 0
    local baseModelSize = math.min(2.9, 1.2 + crystal.reward / 200)
    crystal.modelScale = baseModelSize
    crystal:SetModelScale(baseModelSize)
    crystal.fallVelocity = 45
    crystal.falling = true
    crystal.winnerTable = RPCItems:GetConnectedPlayerTable()
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

function Redfall:SpawnTownNPC(point, unitName, fVector, model, patrolAbility, initialPatrolModifier, modelScale, bSpeech, dialogueName)
  local foxNPC = CreateUnitByName(unitName, point, true, nil, nil, DOTA_TEAM_GOODGUYS)

  foxNPC.dialogueName = dialogueName
  foxNPC.hasSpeechBubble = false
  foxNPC.baseFVector = fVector
  foxNPC:SetForwardVector(fVector)
  if model then
    foxNPC:SetOriginalModel(model)
    foxNPC:SetModel(model)
  end
  foxNPC:SetModelScale(modelScale)
  foxNPC:AddAbility("town_unit")

  foxNPC:FindAbilityByName("town_unit"):SetLevel(1)
  foxNPC:AddAbility("redfall_dialogue")
  foxNPC:FindAbilityByName("redfall_dialogue"):SetLevel(1)
  if patrolAbility then
    foxNPC:AddAbility(patrolAbility)
    patrolAbility = foxNPC:FindAbilityByName(patrolAbility)
    patrolAbility:SetLevel(1)
    patrolAbility:ApplyDataDrivenModifier(foxNPC, foxNPC, initialPatrolModifier, {})
  end
  return foxNPC
end

function Redfall:basic_dialogue(caster, units, dialogueName, time, xOffset, yOffset, bOverride)
  if not bOverride then
    if caster.hasSpeechBubble then
      return false
    end
  end
  caster:DestroyAllSpeechBubbles()
  local speechSlot = Redfall:findEmptyDialogSlot()
  if speechSlot < 4 then
    caster:AddSpeechBubble(speechSlot, dialogueName, time, xOffset, yOffset)
    Redfall:disableSpeech(caster, time, speechSlot)
  end
end

function Redfall:GiveSpiritRuby(hero, position)
  local itemName = "item_redfall_spirit_ruby_"..GameState:GetDifficultyName()
  local key = RPCItems:CreateConsumable(itemName, "mythical", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
  EmitSoundOn("Resource.MithrilShardEnter", hero)
  Redfall:CreateCollectionBeam(position, hero:GetAbsOrigin())
  CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", hero, 0.5)
  RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
end

function Redfall:CreateSpiritAmbience()
  local basePos = Vector(-15800, -15800)
  local spirit1 = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(-14528, -14528, 320)})
  spirit1:SetModel("models/effects/fountain_radiant_00.vmdl")
  spirit1:SetRenderColor(255, 0, 0)
  local spirit2 = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(-13100, -15494, 340)})
  spirit2:SetModel("models/effects/fountain_radiant_00.vmdl")
  spirit2:SetRenderColor(255, 0, 0)
  for i = 1, 9, 1 do
    for j = 1, 9, 1 do
      Timers:CreateTimer(i * 0.5, function()
        local position = basePos + Vector((i - 1) * 3500 + RandomInt(-600, 600), (j - 1) * 3500 + RandomInt(-600, 600))
        local height = GetGroundHeight(position, Events.GameMaster)
        local spirit = SpawnEntityFromTableSynchronous("prop_dynamic", {origin = Vector(position.x, position.y, height + 200)})
        spirit:SetModel("models/effects/fountain_radiant_00.vmdl")
        spirit:SetRenderColor(255, 0, 0)
      end)
    end
  end
end

function Redfall:SpawnAncientTree()
  local positionTable = {Vector(-7445, -12153), Vector(-9543, -8506), Vector(-820, -6181), Vector(-8064, -4352)}
  local position = positionTable[RandomInt(1, #positionTable)]
  Dungeons:CreateBasicCameraLock(position, 7.5)
  AddFOWViewer(DOTA_TEAM_GOODGUYS, position, 700, 300, false)
  Timers:CreateTimer(0.8, function()
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
    ParticleManager:SetParticleControl(pfx, 0, GetGroundPosition(position, Events.GameMaster))
    EmitSoundOnLocationWithCaster(position, "Redfall.AncientTree.Spawn", Events.GameMaster)
    Timers:CreateTimer(5, function()
      ParticleManager:DestroyParticle(pfx, false)
    end)
  end)

  Timers:CreateTimer(2.0, function()
    local creepFunction = function(unit)
      unit:SetRenderColor(255, 170, 170)
      Events:ColorWearables(unit, Vector(255, 170, 170))
      unit:SetModelScale(0.05)
      unit.summonCount = 0
	  unit.type = ENEMY_TYPE_MAJOR_BOSS
      local unitAbility = unit:FindAbilityByName("ancient_tree_passive")
      unitAbility:ApplyDataDrivenModifier(unit, unit, "modifier_ancient_tree_cinematic", {duration = 6.5})
      for i = 1, 120, 1 do
        Timers:CreateTimer(i * 0.03, function()
          unit:SetModelScale(0.05 + i * 0.02)
        end)
      end
      Events:AdjustBossPower(unit, 10, 10, true)
      Timers:CreateTimer(0.05, function()
        StartAnimation(unit, {duration = 6, activity = ACT_DOTA_TELEPORT, rate = 0.5})
      end)
      for j = 0, 3, 1 do
        Timers:CreateTimer(j * 0.8, function()
          local particleName = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
          local pfxB = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, unit)
          ParticleManager:SetParticleControl(pfxB, 0, unit:GetAbsOrigin() + Vector(0, 0, 50))
          ParticleManager:SetParticleControl(pfxB, 1, Vector(300 + j * 100, 1, 2))
          ScreenShake(unit:GetAbsOrigin(), 130, 0.9, 0.9, 9000, 0, true)
          Timers:CreateTimer(2.8, function()
            ParticleManager:DestroyParticle(pfxB, false)
          end)
        end)
      end

      Timers:CreateTimer(1, function()
        EmitSoundOn("Redfall.AncientTree.Spawn.VO", unit)
      end)
    end
    local unit = Spawning:SpawnUnit{
      unitName = "redfall_ancient_tree",
      spawnPoint = position,
      minDrops = 3,
      maxDrops = 5,
      itemLevel = 96,
      aggroSound = "Redfall.AncientTree.Aggro",
      fv = Vector(0, -1),
      isAggro = false,
      deathModifier = nil,
      enemyType = ENEMY_TYPE_MAJOR_BOSS,
	  canBeParagonPack = false,
      creepFunction = creepFunction
    }
  end)
end

function Redfall:SpawnAncientTreeSummon(position, fv)
  local creepFunction = function(unit)
    unit:SetDeathXP(0)
  end
  local unit = Spawning:SpawnUnit{
    unitName = "redfall_ancient_tree_summon",
    spawnPoint = position,
    minDrops = 0,
    maxDrops = 0,
    itemLevel = 0,
    aggroSound = "Redfall.SkeletonSpawn.Aggro",
    fv = fv,
    isAggro = true,
    deathModifier = nil,
    enemyType = ENEMY_TYPE_WEAK_CREEP,
	canBeParagonPack = false,
    creepFunction = creepFunction
  }
  return unit
end

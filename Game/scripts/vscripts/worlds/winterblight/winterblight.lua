if Winterblight == nil then
  Winterblight = class({})
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
  -- Dungeons.itemLevel = 1
  Timers:CreateTimer(3, function()
      local blacksmith = Events:SpawnTownNPC(Vector(-15190, -3609), "red_fox", Vector(0, 1), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
      StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
      local oracle = Events:SpawnOracle(Vector(-15808, -2048), Vector(0.3, -1))
      Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-14373, -2795), Vector(-1, 1))
  end)
  Winterblight:CalculateHeroZones()
  Winterblight:StarterMusic()
  Winterblight:HowlingWind()
  -- Timers:CreateTimer(8, function()
  --   Redfall:InitializeForest()
    
  -- end)
  --     Redfall.RedfallMaster = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
  --     Redfall.RedfallMaster:AddAbility("redfall_ability"):SetLevel(GameState:GetDifficultyFactor())
  --     Redfall.RedfallMasterAbility = Redfall.RedfallMaster:FindAbilityByName("redfall_ability")
  --     Redfall.RedfallMaster:AddAbility("dummy_unit"):SetLevel(1)
  -- Timers:CreateTimer(4, function()
  --   Redfall.Quest1Giver = Redfall:SpawnTownNPCNoDialogue(Vector(-12608, -13440), Vector(1,-0.5), nil, 1.1, Vector(255, 110, 110), "redfall_first_quest_giver")

  --   Redfall:AutumnParticles()
  -- end)
  -- Redfall:InitTrees()
  -- Redfall:CalculateHeroZones()
end

function Winterblight:CalculateHeroZones()
  Timers:CreateTimer(0, function()
    if MAIN_HERO_TABLE then
      for i = 1, #MAIN_HERO_TABLE, 1 do
        local hero = MAIN_HERO_TABLE[i]
        local player = hero:GetPlayerOwner()
        local heroOrigin = hero:GetAbsOrigin()
          if (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-16512, -9984), Vector(-4928, 3833))) then
            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "redfall_village"} )
            hero.bgm = "Music.Winterblight.Start"
          elseif (WallPhysics:IsWithinRegionA(heroOrigin, Vector(-6897, -9496), Vector(10058,267))) then
            CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "redfall_forest"} )
            hero.bgm = "Music.Winterblight.Start"
          else
            -- CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_zone_display", {zoneName = "zone_redfall" } )
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
  -- EmitSoundOnLocationWithCaster(Vector(-15424, -2624), "Winterblight.Wind", Events.GameMaster)
  -- EmitSoundOnLocationWithCaster(Vector(-12459, -2014), "Winterblight.Wind", Events.GameMaster)
  -- EmitSoundOnLocationWithCaster(Vector(-10624, -4288), "Winterblight.Wind", Events.GameMaster)
  -- EmitSoundOnLocationWithCaster(Vector(-7900, -3341), "Winterblight.Wind", Events.GameMaster)
  -- EmitSoundOnLocationWithCaster(Vector(-5696, -3136), "Winterblight.Wind", Events.GameMaster)
end

function Winterblight:HowlingWind()
  Timers:CreateTimer(0, function()
    windTable = {Vector(-15424, -2624), Vector(-12459, -2014), Vector(-10624, -4288), Vector(-7900, -3341), Vector(-5696, -3136)}
    for i = 1, #windTable, 1 do
      EmitSoundOnLocationWithCaster(windTable[i], "Winterblight.RandWind", Events.GameMaster)
    end
    return 6
  end)
end
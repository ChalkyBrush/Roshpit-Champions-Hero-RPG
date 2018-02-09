-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

-- Cleanup a player when they leave

require('runes')
require('beacons')
require('wallPhysics')
require('dungeons')
require('game_state')
require('saveload')
require('quests')
require('glyphs')
require('paragon')
require('elements')


if Events == nil then
  Events = class({})
end

if MAIN_HERO_TABLE == nil then
  MAIN_HERO_TABLE = {}
  TAKEN_HERO_TABLE = {}
end

--EVENTS
require('worlds/events/descent_of_winterblight_dec_2017/descent_of_winterblight_core')

Events.ResourceBonus = 1

ROSHPIT_URL = "https://www.roshpit.ca"


SPAWN_POINT_OPEN_1 = Vector(-7232, -6464)
SPAWN_POINT_OPEN_2 = Vector(-7168, -6400)
SPAWN_POINT_OPEN_3 = Vector(-5888, -4544)
SPAWN_POINT_GRAVEYARD_1 = Vector(-4096, -7360)
SPAWN_POINT_GRAVEYARD_2 = Vector(-5248, -7040)
SPAWN_POINT_GRAVEYARD_3 = Vector(-4544, -6720)
SPAWN_POINT_CAVE_1 = Vector(-4032, -4224)
SPAWN_POINT_CAVE_2 = Vector(-3392, -6528)
SPAWN_POINT_CAVE_3 = Vector(-1792, -6848)
SPAWN_POINT_CAVE_4 = Vector(-1408, -5504)
SPAWN_POINT_CAVE_5 = Vector(-3392, -4736)
SPAWN_POINT_CAVE_6 = Vector(-1792, -5952)
SPAWN_POINT_FOREST_1 = Vector(-4224, -2688)
SPAWN_POINT_FOREST_2 = Vector(-2816, -3008)
SPAWN_POINT_FOREST_3 = Vector(-2560, -1408)
SPAWN_POINT_FOREST_4 = Vector(-3200, 0)
SPAWN_POINT_FOREST_5 = Vector(-3392, -1088)
SPAWN_POINT_FOREST_6 = Vector(-6208, -832)
SPAWN_POINT_FOREST_7 = Vector(-7296, -2496)
SPAWN_POINT_FOREST_8 = Vector(-7424, -3940)
SPAWN_POINT_FOREST_9 = Vector(-5440, -3648)

TOWN_RESPAWN_VECTOR = Vector(-13248, 14144)

ACT1_SPAWN_POINT_TABLE = {SPAWN_POINT_OPEN_1, SPAWN_POINT_OPEN_2, SPAWN_POINT_OPEN_3, SPAWN_POINT_GRAVEYARD_1, SPAWN_POINT_GRAVEYARD_2, SPAWN_POINT_GRAVEYARD_3, SPAWN_POINT_CAVE_1, SPAWN_POINT_CAVE_2, SPAWN_POINT_CAVE_3, SPAWN_POINT_CAVE_4, SPAWN_POINT_CAVE_5, SPAWN_POINT_CAVE_6, SPAWN_POINT_FOREST_1, SPAWN_POINT_FOREST_2, SPAWN_POINT_FOREST_3, SPAWN_POINT_FOREST_4, SPAWN_POINT_FOREST_5, SPAWN_POINT_FOREST_6, SPAWN_POINT_FOREST_7, SPAWN_POINT_FOREST_8, SPAWN_POINT_FOREST_9}


function GameMode:OnDisconnect(keys)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

  -- local player = EntIndexToHScript(userid)
  -- local hero = player:GetAssignedHero()
  -- hero.disconnectLevel = hero:GetLevel()
  Statistics.dispatch("player:disconnect");
end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()

  print("---------NEW STATE---------")
  print(newState)
  print(DOTA_GAMERULES_STATE_GAME_IN_PROGRESS)
  if newState == 2 then
    local msg = {}
    print("GAME SETUP SET DIFFICULTY")
    msg.difficulty = GameState:GetDefaultDifficulty()
    msg.playerID = -10
    GameState:DifficultySelect(msg)
  end
  if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    CustomGameEventManager:Send_ServerToAllClients("hero_select", {} )
  end
  if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    CustomGameEventManager:Send_ServerToAllClients("update_difficulty", {} )
    -- GameRules:ResetToHeroSelection()
    if GameState:IsWorld1() then
        Events:initializeTown()
    elseif GameState:IsTanariJungle() then
        Tanari:InitCamp()
    elseif GameState:IsRPCArena() then
        Arena:Init()    
    elseif GameState:IsRedfallRidge() then
        Redfall:InitCamp()
    elseif GameState:IsPVPAlpha() then
        PVP:InitGame()
    elseif GameState:IsSerengaard() then
        Serengaard:Init()
    elseif GameState:IsSeaFortress() then
        Seafortress:Init()
    elseif GameState:IsWinterblight() then
        Winterblight:InitCamp()
    end

    if GameState:IsPVPAlpha() then
      PVP:SetPvpRules()
      CustomGameEventManager:Send_ServerToAllClients("closePVPVoteScreen", {})
      for i = 1, #MAIN_HERO_TABLE, 1 do 
        MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_command_restric_player")
      end
    end
    for i = 1, #MAIN_HERO_TABLE, 1 do 
      MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_command_restric_player")
    end
  end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  DebugPrint("[BAREBONES] NPC Spawned")
  DebugPrintTable(keys)
  
  -- This internal handling is used to set up main barebones functions
  GameMode:_OnNPCSpawned(keys)
  local npc = EntIndexToHScript(keys.entindex)
  if npc:IsRealHero() then
    if not npc.strength_custom then
      npc.strength_custom = 20
      npc.agility_custom = 20
      npc.intellect_custom = 20
    end
    CustomAttributes:SetAttributes(npc)
  end
  if npc:IsRealHero() and Events.gameLoaded then
    GameMode:CorrectRespawn(npc)
    if GameState:IsSerengaard() then
      if Serengaard.gameOver then
        local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
        gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, npc, "modifier_disable_player", {})        
      end
    end
    RPCItems:RecalculateStatsBasic(npc)
    print("RESPAWNING AND MOVING")
  end
end

function GameMode:CorrectRespawn(npc)
       
        Runes:RunesOnRespawn(npc)
      if GameState:IsWorld1() then
        if Events.isTownActive then
          local vector = TOWN_RESPAWN_VECTOR
          npc.lastPortalUsed = ""
          npc:SetOrigin(vector)
        elseif Beacons.respawnLocation then
          npc:SetOrigin(Beacons.respawnLocation)
        elseif Events.WaveNumber then
          local vector = Events.portalPosition
          if vector then
            npc:SetOrigin(vector)
          else
            npc:SetOrigin(TOWN_RESPAWN_VECTOR)
          end
        else
          local vector = Events.portalPosition
          if vector then
            npc:SetOrigin(vector)
          else
            npc:SetOrigin(TOWN_RESPAWN_VECTOR)
          end
        end
        if Dungeons.entryPoint and not Beacons.expireVote then
          npc:SetOrigin(Dungeons.entryPoint)
        end
      elseif GameState:IsTanariJungle() or GameState:IsRedfallRidge() or GameState:IsSeaFortress() or GameState:IsWinterblight() then
        if npc:HasModifier("modifier_neutral_glyph_4_1") and (not npc.prelastDeathTime or (npc.lastDeathTime - npc.prelastDeathTime > 30)) then
          npc:SetOrigin(npc.deathPosition)
        elseif npc.respawnFlag then
          Events:RespawnFlag(npc)
        else
          if Dungeons.respawnPoint then
            npc:SetOrigin(Dungeons.respawnPoint)
          elseif Events.TownPosition then
              npc:SetOrigin(Events.TownPosition)
          end
        end
      elseif GameState:IsRPCArena() then
        if npc.respawnFlag then
          if Arena.PitLevel then
            Events:RespawnFlag(npc)
          end
        else
          if Dungeons.respawnPoint then
            npc:SetOrigin(Dungeons.respawnPoint)
          end
        end
      elseif GameState:IsPVPAlpha() then
        PVP:Respawn(npc)
      end
      local respawnAbility = Events.GameMaster:FindAbilityByName("respawn_abilities")
      local duration = 3.5
      if npc:HasModifier("modifier_crusader_a_c_extension") then
        local durationIncrease = npc:GetModifierStackCount("modifier_crusader_a_c_extension", npc)*0.05
        duration = duration + durationIncrease
        npc:RemoveModifierByName("modifier_crusader_a_c_extension")
      end
      print("RESPAWN DURATION: "..duration)
      respawnAbility:ApplyDataDrivenModifier(Events.GameMaster, npc, "modifier_recently_respawned", {duration = duration})
end

function Events:RespawnFlag(npc)
  if npc.revive then
    npc.revive = false
  else
    npc:SetOrigin(npc.respawnFlag:GetAbsOrigin())
    UTIL_Remove(npc.respawnFlag)
    npc.respawnFlag = false
  end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

--  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
--  local entCause = EntIndexToHScript(keys.entindex_attacker)
--  local entVictim = EntIndexToHScript(keys.entindex_killed)
--  PopupDamage(entVictim, damagebits)
--  DeepPrintTable(keys)
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
  if itemEntity.particle then
    ParticleManager:DestroyParticle( itemEntity.particle, false )
    itemEntity.particle = false
  end
  if itemEntity.particle2 then
    ParticleManager:DestroyParticle( itemEntity.particle2, false )
    itemEntity.particle2 = false
  end
  itemEntity.expiryTime = false
  Challenges:CheckIfHeroHoldsDupes(heroEntity)
  Events:PickUpTest(heroEntity, itemEntity, itemname)
end

function Events:PickUpTest(heroEntity, itemEntity, itemname)
  if itemEntity.gear then
      if itemEntity.slot == "amulet" then
        RPCItems:AmuletPickup(heroEntity, itemEntity)
      elseif itemEntity.hasRunePoints then
        RPCItems:AmuletPickup(heroEntity, itemEntity)
      end
      -- RPCItems:GearPickup(heroEntity, itemEntity)
  end
  if GameState:NoOracle() then
    itemEntity.pickedUp = true
  end
  if itemname == "item_bag_of_gold" then
    DeepPrintTable(itemEntity)
    -- local r = RandomInt(100, Events.WaveNumber*30) + RandomInt(0, 100)
    local r = itemEntity.gold_amount
    local owner = heroEntity:GetPlayerOwner()
    PlayerResource:ModifyGold( owner:GetPlayerID(), r, false, 0 )
    PopupGoldGain(heroEntity, r)
    itemEntity.noMin = true
    SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
    UTIL_Remove( itemEntity )
  end
  if itemEntity.rarity and not itemEntity.pickedUp then
    print("RARITY")
    itemEntity.pickedUp = true
    RPCItems:ReduceLevelRequirement(itemEntity)
    local rarityFactor = RPCItems:GetRarityFactor(itemEntity.rarity)
    if rarityFactor > 2 then
      local soundString = ""
      if rarityFactor >= 5 then
        if rarityFactor == 5 then
          EmitSoundOnLocationWithCaster(heroEntity:GetAbsOrigin(), "Item.ImmortalPickup", Events.GameMaster)
        elseif rarityFactor == 6 then
          EmitGlobalSound("Item.ArcanaPickup")
        end
        if itemEntity.isShop then
        else
          RPCItems:LegendaryPickup(itemEntity, heroEntity)
        end
        -- soundString = "Loot_Drop_Stinger_Ancient"
      end
      
      local player = heroEntity:GetPlayerOwner()
      if player then
        local playerId = player:GetPlayerID()
        local heroId = heroEntity:GetClassname()
        CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=itemEntity:GetEntityIndex(), heroId=heroId, playerId=playerId, pickup="normal"} )
      end
    end
    if itemEntity.slot == "weapon" and rarityFactor > 2 and rarityFactor < 5 then
      RPCItems:LegendaryPickup(itemEntity, heroEntity)
    end
    if IsValidEntity(itemEntity) then
      if itemEntity:GetAbilityName() == "item_reanimation_stone" then
        RPCItems:LegendaryPickup(itemEntity, heroEntity)
      elseif itemEntity.glyph or itemEntity.glyphBook then
        if rarityFactor < 5 then
          RPCItems:LegendaryPickup(itemEntity, heroEntity)
        end
      elseif itemEntity:GetAbilityName() == "item_redfall_ashen_twig" then
        Redfall:PickupAshTwig()
      elseif itemEntity:GetAbilityName() == "item_redfall_glowing_redfall_leaf" then
        Redfall:PickupEnchantedLeaf()
      end
    end
  end
  Statistics.dispatch("items:backpack_change");
end



-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  Statistics.dispatch("player:reconnect");

  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
  local player = keys.player
  CustomGameEventManager:Send_ServerToPlayer(player, "close_oracle", {})
  CustomGameEventManager:Send_ServerToPlayer(player, "correct_dota_ui", {})
  Timers:CreateTimer(1.5, function()
    
    Events:PremiumPlayerLoaded(player:GetAssignedHero())
  end)
  if GameState:IsTanariJungle() then
    if Events.SpiritRealm then
      CustomGameEventManager:Send_ServerToAllClients("update_spirit_zone_display", {} )
    end
  end
  if GameState:IsPVPAlpha() then
    PVP:Reconnect(player)
  end
  -- local hero = player:GetAssignedHero()
  -- if hero:GetLevel() > hero.disconnectLevel then
  --   for i = 1, hero:GetLevel() - hero.disconnectLevel, 1 do
  --     Events:HeroLevelUp(player, hero, hero.disconnectLevel+i)
  --   end
  -- end
end

function GameMode:OnPlayerChat(keys)
  local text = string.lower(keys.text)
  -- if string.match(text, "-gold") or string.match(text, "-lvlup") or string.match(text, "-respawn") or string.match(text, "-createhero") or string.match(text, "-refresh") or string.match(text, "-item") or string.match(text, "-allvision") or string.match(text, "-wtf") or string.match(text, "-respawn") or string.match(text, "-teleport") then
  --   print("CHEATS ENABLED")
  --   GameState:CheatCommandUsed()
  -- end
  if string.match(text, "-suicide") then
    -- DeepPrintTable(keys)
    -- local playerHandle = EntIndexToHScript(keys.userid)
    -- local hero = player:GetAssignedHero()
    -- hero:ForceKill(false)

  end
  -- if string.match(text, "superdebug11") then
  --   Redfall:Debug()
  -- end
--  local mapName = GetMapName()
--  local position
--  if mapName == "rpc_roshpit_arena" then
--    position = Vector(-3136, -11200)
--  elseif mapName == "rpc_redfall_ridge" then
--    position = Vector(-15168, -14976)
--  elseif mapName == "rpc_tanari_jungle" then
--    position = Vector(-4928, 2048)
--  elseif mapName == "rpc_sea_fortress" then
--    position = Vector(844, -15488)
--  end
--  if string.match(text, "debug boss") then
--    if mapName == "rpc_roshpit_arena" then
--      Arena:OpenPit(7)
--      Arena.PitLevel = 7
--      Arena:SpawnPitFinalBoss()
--    elseif mapName == "rpc_redfall_ridge" then
--      Redfall:SpawnAncientTree()
--    elseif mapName == "rpc_tanari_jungle" then
--      Tanari:DebugSpawnBoss()
--    elseif mapName == "rpc_sea_fortress" then
--      Seafortress:SpawnFinalBoss()
--    end
--  end
--
--  if string.match(text, "debug main") then
--    local item = CreateItem("item_debug_blink", nil, nil)
--    local drop = CreateItemOnPositionSync( position, item )
--    RPCItems:DropItem(item, position)
--    RPCItems:RollReanimationStone(position)
--    RPCItems:RollDuskbringerArcana1(position)
--  end
--
--  if string.match(text, "debug items") then
--    RPCItems:RollVoyagerBoots(position)
--  end
--
--  if string.match(text, "debug glyphs") then
--    local heroName = 'duskbringer'
--    Glyphs:RollGlyphAll("item_rpc_" .. heroName .. "_glyph_5_a", position, 0)
--    for tier = 1,7 do
--      for rowItem = 1,2 do
--        local glyphName = "item_rpc_"..heroName.."_glyph_"..tier.."_"..rowItem
--        Glyphs:RollGlyphAll(glyphName, position, 0)
--      end
--    end
--  end

  if string.match(text, "spawnunit") then
       if Beacons.cheats then
          local position = MAIN_HERO_TABLE[1]:GetAbsOrigin() + MAIN_HERO_TABLE[1]:GetForwardVector()*600
          local unitName = string.gsub(text, "spawnunit ", '')
          local unit = CreateUnitByName(unitName, position, true, nil, nil, DOTA_TEAM_NEUTRALS)
          Events:AdjustDeathXP(unit)     
          unit.targetRadius = 800
          unit.minRadius = 0
          unit.targetAbilityCD = 1
          unit.targetFindOrder = FIND_ANY_ORDER     
          unit.targetRadius = 620
          unit.autoAbilityCD = 1
          unit.aggro = true
       end
  elseif string.match(text, "tanari") then
        if Beacons.cheats then
          Tanari:Debug()
        end
  elseif string.match(text, "arena") then
        if Beacons.cheats then
          Arena:Debug()
        end
  elseif string.match(text, "redfall") then
        if Beacons.cheats then
          Redfall:Debug()
        end
  elseif string.match(text, "serengaard") then
        if Beacons.cheats then
          Serengaard:Debug()
        end
  elseif string.match(text, "seafort") then
        if Beacons.cheats then
          Seafortress:Debug()
        end    
  elseif string.match(text, "winter") then
        if Beacons.cheats then
          Winterblight:Debug()
        end    
  elseif string.match(text, "ladder") then
    if GameState:IsRedfallRidge() then
        if Beacons.cheats then
          Redfall:Debug2()
        end
    elseif GameState:IsTanariJungle() then
        if Beacons.cheats then
          Tanari:Debug2()
        end
    elseif GameState:IsSerengaard() then
        if Beacons.cheats then
          Serengaard:Debug2()
        end
    elseif GameState:IsRPCArena() then
        if Beacons.cheats then
          Arena:Debug2()
        end
    elseif GameState:IsSeaFortress() then
        if Beacons.cheats then
          Seafortress:Debug2()
        end
    end
  elseif string.match(text, "special") then
    if Beacons.cheats then
      Events:SpecialDebug()
    end
  elseif string.match(text, "pvp") then
    PVP:Debug()
  end
end

function Events:DebugCalls()
    if not GameRules.DebugCalls then
        print("Starting DebugCalls")
        GameRules.DebugCalls = true

        debug.sethook(function(...)
            local info = debug.getinfo(2)
            local src = tostring(info.short_src)
            local name = tostring(info.name)
            if name ~= "__index" then
                print("Call: ".. src .. " -- " .. name)
            end
        end, "c")
    else
        print("Stopped DebugCalls")
        GameRules.DebugCalls = false
        debug.sethook(nil, "c")
    end
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  DebugPrint( '[BAREBONES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  DebugPrintTable(keys)
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  -- DebugPrintTable(keys)
  -- DeepPrintTable(keys)
  local player = EntIndexToHScript(keys.player)
  local level = keys.level
  local hero = player:GetAssignedHero()
  Events:HeroLevelUp(player, hero, level)
  if MAIN_HERO_TABLE then
    for i = 1, #MAIN_HERO_TABLE, 1 do
      MAIN_HERO_TABLE[i]:SetAbilityPoints(0)
    end
  end
end

function Events:HeroLevelUp(player, hero, level)
  hero:SetAbilityPoints(0)

  local player_stats = CustomNetTables:GetTableValue("player_stats", tostring(player:GetPlayerID()))
  -- if not player_stats then
  --   return false
  -- end
  local current_rune_points = player_stats.runePoints
  local current_skill_points = player_stats.skillPoints
  if level%5 == 0 then
    CustomNetTables:SetTableValue("player_stats", tostring(player:GetPlayerID()), {skillPoints = current_skill_points+1, runePoints = current_rune_points+2} )
  else
    CustomNetTables:SetTableValue("player_stats", tostring(player:GetPlayerID()), {skillPoints = current_skill_points, runePoints = current_rune_points+2} )
  end
  CustomGameEventManager:Send_ServerToPlayer(player, "AbilityUp", {playerId=PlayerID})
  CustomGameEventManager:Send_ServerToPlayer(player, "ability_tree_upgrade", {playerId=PlayerID})
  CustomGameEventManager:Send_ServerToPlayer(player, "hero_level_up", {})
  if level%40 == 0 then
    Stars:StarEventPlayer("power_up", hero)
  end
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

MainHero1 = nil
MainHero2 = nil
MainHero3 = nil
MainHero4 = nil
Inventory1 = nil
Inventory2 = nil
Inventory3 = nil
Inventory4 = nil
Player1 = nil
Player2 = nil
Player3 = nil
Player4 = nil

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
  if not GameState.HeroPlayerTable then
    GameState.HeroPlayerTable = {}
    Statistics.dispatch('game:start')
  end
  Timers:CreateTimer(0.3, function()
    if heroEntity:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
      return false
    end
    if heroEntity:GetUnitName() == "npc_dota_hero_wisp" then
      Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_command_restric_player", {})
      heroEntity:AddNoDraw()
      return false
    end
    if heroEntity.preview then
      return false
    end
    CustomGameEventManager:Send_ServerToPlayer(player, "correct_dota_ui", {})
    table.insert(GameState.HeroPlayerTable, {heroEntity:GetPlayerOwnerID(), keys.heroindex})
    Events:SetupHeroes(heroEntity)
    Events:BGMmanager(player, heroEntity)

    --DEBUG
    -- table.insert(TAKEN_HERO_TABLE, heroEntity:GetUnitName())
    -- CustomNetTables:SetTableValue("hero_index", "taken_heroes", TAKEN_HERO_TABLE)
    -- CustomGameEventManager:Send_ServerToAllClients("update_picked_heroes", {selectedHero = heroEntity:GetUnitName()} )
  end)
end

function Events:BGMmanager(player, hero)
  print("WHAT?")
  Timers:CreateTimer(3, function()
    if GameState:IsRPCArena() then
      CustomGameEventManager:Send_ServerToPlayer(player, "BGMstart", {songName = "Arena.StartingMusic"})
    elseif GameState:IsRedfallRidge() then
      if GameRules:GetGameTime() > 0 then
        CustomGameEventManager:Send_ServerToPlayer(player, "BGMstart", {songName = "Music.Redfall.Village"})
      end
      hero.bgm = "Music.Redfall.Village"
    elseif GameState:IsWinterblight() then
      if GameRules:GetGameTime() > 0 then
        CustomGameEventManager:Send_ServerToPlayer(player, "BGMstart", {songName = "Music.Winterblight.Start"})
      end
      hero.bgm = "Music.Winterblight.Start"
    end
  end)
end

function Events:SetupInventoryUnit(inventory_unit)
    inventory_unit:AddAbility("town_unit")
    inventory_unit:FindAbilityByName("town_unit"):SetLevel(1)
    inventory_unit:FindAbilityByName("helm_slot"):SetLevel(1)
    inventory_unit:FindAbilityByName("hand_slot"):SetLevel(1)
    inventory_unit:FindAbilityByName("foot_slot"):SetLevel(1)
    inventory_unit:FindAbilityByName("body_slot"):SetLevel(1)
    inventory_unit:FindAbilityByName("weapon_slot"):SetLevel(1)
end

function Events:InitializeHero(heroEntity)
  local ability = nil
  for i = 0, 5, 1 do
    ability = heroEntity:GetAbilityByIndex(i)
    if ability then
      ability:SetLevel(1)
    end
  end
  if heroEntity:HasItemInInventory("item_tpscroll") then
    for i = 0, 2, 1 do
      local item = heroEntity:GetItemInSlot(i)
      if item then
        if IsValidEntity(item) then
          UTIL_Remove(item)
        end
      end
    end
  end
  heroEntity.saveSlot = 0
  heroEntity.loadEnabled = 1
  
  local playerID = heroEntity:GetPlayerOwnerID()
  local player = heroEntity:GetPlayerOwner()

  local heroIndex = heroEntity:GetEntityIndex()
  if GameState:IsWorld1() then
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."1", {forest = 1, desert = 0, mines = 0} )
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."2", {forest = 0, desert = 0, mines = 0} )
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."3", {forest = 0, desert = 0, mines = 0} )
    Timers:CreateTimer(3, function()
      Beacons:ActivatePortalsForKeys()
    end)
  else
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."1", {forest = 1, desert = 0, mines = 0} )
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."2", {forest = 0, desert = 0, mines = 0} )
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."3", {forest = 0, desert = 0, mines = 0} )
  end
  Timers:CreateTimer(4, function()
    -- if not GameState:NoOracle() then
    --   CustomGameEventManager:Send_ServerToPlayer(player, "open_oracle", {player=playerID, loadEnabled = heroEntity.loadEnabled} )
    -- end
    -- Attributes:ModifyBonuses(heroEntity)
  end)
  Timers:CreateTimer(3, function()
    Glyphs:CreateGlyphModifierTable()
  end)
  CustomGameEventManager:Send_ServerToPlayer(player, "xp_earned", {})

  if GameState:IsPVPAlpha() then
    heroEntity.respawnPoint = heroEntity:GetAbsOrigin()
    PVP:InitiateHero(heroEntity)
    if GameState:NoOracle() then
    else  
      if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        CustomGameEventManager:Send_ServerToPlayer(player, "startPVPVoteScreen", {})
        if Events.GameMaster then
          Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_command_restric_player", {})
        else
          Timers:CreateTimer(3, function()
            Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_command_restric_player", {})
          end)
        end
      else
        CustomGameEventManager:Send_ServerToPlayer(player, "closePVPVoteScreen", {})
      end
    end
  end
end

function Events:EarnKey(clearedZone)
  local difficulty = GameState:GetDifficultyFactor()
  local keyName = ""
  if clearedZone == "forest" then
    for i = 1, #MAIN_HERO_TABLE, 1 do
      local heroIndex = MAIN_HERO_TABLE[i]:GetEntityIndex()
      local existingKeysThisDifficulty = CustomNetTables:GetTableValue("portal_keys", tostring(heroIndex).."-"..tostring(difficulty))
      CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-"..difficulty, {forest = existingKeysThisDifficulty.forest, desert = 1, mines = existingKeysThisDifficulty.mines} )
      keyName = "desert"
      local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
      if existingKeysThisDifficulty.desert == 0 then
        CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=-1, heroId=MAIN_HERO_TABLE[i]:GetUnitName(), playerId=playerID, pickup="key", keyName=keyName} )
      end
    end
  elseif clearedZone == "desert" then
    for i = 1, #MAIN_HERO_TABLE, 1 do
      local heroIndex = MAIN_HERO_TABLE[i]:GetEntityIndex()
      local existingKeysThisDifficulty = CustomNetTables:GetTableValue("portal_keys", tostring(heroIndex).."-"..tostring(difficulty))
      CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-"..difficulty, {forest = existingKeysThisDifficulty.forest, desert = existingKeysThisDifficulty.desert, mines = 1} )
      keyName = "mines"
      local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
      if existingKeysThisDifficulty.mines == 0 then
        CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=-1, heroId=MAIN_HERO_TABLE[i]:GetUnitName(), playerId=playerID, pickup="key", keyName=keyName} )
      end
    end
  elseif clearedZone == "mines" and difficulty < 3 then
    for i = 1, #MAIN_HERO_TABLE, 1 do
      local heroIndex = MAIN_HERO_TABLE[i]:GetEntityIndex()
      local existingKeysNextDifficulty = CustomNetTables:GetTableValue("portal_keys", tostring(heroIndex).."-"..tostring(difficulty+1))
      CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-"..difficulty+1, {forest = 1, desert = existingKeysNextDifficulty.desert, mines = existingKeysNextDifficulty.mines} )
      keyName = "forest"
      local playerID = MAIN_HERO_TABLE[i]:GetPlayerOwnerID()
      if existingKeysNextDifficulty.forest == 0 then
        CustomGameEventManager:Send_ServerToAllClients("PickupPopup", {item=-1, heroId=MAIN_HERO_TABLE[i]:GetUnitName(), playerId=playerID, pickup="key", keyName=keyName} )
      end
    end
  end
  CustomGameEventManager:Send_ServerToAllClients("update_key_display", {} )
  Beacons:ActivatePortalsForKeys()

  
end



function Events:LevelUpRune(keys)
  local PlayerID = keys.playerID
  local player = PlayerResource:GetPlayer(PlayerID)
  local ability = EntIndexToHScript(keys.ability)
  local unit = EntIndexToHScript(keys.unit)
  print("LEVELUP RUNE")
  local player_stats = CustomNetTables:GetTableValue("player_stats", tostring(player:GetPlayerID()))
  local current_rune_points = player_stats.runePoints
  local current_skill_points = player_stats.skillPoints
  local hero = player:GetAssignedHero()
  local bAllow = true
  if not unit:GetPlayerOwnerID() == PlayerID then
    if unit:IsHero() then
      bAllow = false
    end
  end
  print(unit:GetPlayerOwnerID())
  print(PlayerID)
  if current_rune_points > 0 and ability:GetLevel() < 20 and hero:IsAlive() and bAllow then
   CustomNetTables:SetTableValue("player_stats", tostring(PlayerID), {skillPoints = current_skill_points, runePoints = current_rune_points-1} )
   local newLevel = ability:GetLevel() + 1
   ability:SetLevel(newLevel)
   EmitSoundOnClient("ui.crafting_gem_applied", player)
   Runes:apply_runes(ability, unit, PlayerID)
  else
   EmitSoundOnClient("General.Cancel", player)
  end
  CustomGameEventManager:Send_ServerToPlayer(player, "AbilityUp", {playerId=PlayerID})
  CustomGameEventManager:Send_ServerToPlayer(player, "ability_tree_upgrade", {playerId=PlayerID})
end 

function Events:LevelUpAbility(keys)
  local PlayerID = keys.playerID
  local player = PlayerResource:GetPlayer(PlayerID)
  local ability = EntIndexToHScript(keys.ability)
  local unit = EntIndexToHScript(keys.unit)

  local player_stats = CustomNetTables:GetTableValue("player_stats", tostring(player:GetPlayerID()))
  local current_rune_points = player_stats.runePoints
  local current_skill_points = player_stats.skillPoints
   local hero = player:GetAssignedHero()
  local bAllow = true
  if not unit:GetPlayerOwnerID() == PlayerID then
    if unit:IsHero() then
      bAllow = false
    end
  end
  if current_skill_points > 0 and ability:GetLevel() < 7 and hero:IsAlive() and hero:GetLevel() >= -5+10*ability:GetLevel() and bAllow then
   CustomNetTables:SetTableValue("player_stats", tostring(PlayerID), {skillPoints = current_skill_points-1, runePoints = current_rune_points} )
   local newLevel = ability:GetLevel() + 1
   ability:SetLevel(newLevel)
   EmitSoundOnClient("ui.crafting_gem_applied", player)
  else
   EmitSoundOnClient("General.Cancel", player)
  end
  CustomGameEventManager:Send_ServerToPlayer(player, "AbilityUp", {playerId=PlayerID})
  CustomGameEventManager:Send_ServerToPlayer(player, "ability_tree_upgrade", {playerId=PlayerID})
end

function Events:CreateRuneUnits(heroEntity, playerID)
  local runeUnit = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, heroEntity, PlayerResource:GetPlayer(playerID), heroEntity:GetTeamNumber())
  heroEntity.runeUnit = runeUnit
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."rune_unit1", {runeUnit = runeUnit:GetEntityIndex()})
  -- runeUnit:AddAbility("town_unit"):SetLevel(1)

  local runeUnit2 = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, heroEntity, player, heroEntity:GetTeamNumber())
  heroEntity.runeUnit2 = runeUnit2
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."rune_unit2", {runeUnit = runeUnit2:GetEntityIndex()})
  -- runeUnit2:AddAbility("town_unit"):SetLevel(1)

  local runeUnit3 = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, heroEntity, player, heroEntity:GetTeamNumber())
  heroEntity.runeUnit3 = runeUnit3
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."rune_unit3", {runeUnit = runeUnit3:GetEntityIndex()})
  -- runeUnit3:AddAbility("town_unit"):SetLevel(1)

  local runeUnit4 = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, heroEntity, player, heroEntity:GetTeamNumber())
  heroEntity.runeUnit4 = runeUnit4
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."rune_unit4", {runeUnit = runeUnit4:GetEntityIndex()})
  -- runeUnit4:AddAbility("town_unit"):SetLevel(1)

  local glyphUnit = CreateUnitByName("rune_unit", RPCItems.DROP_LOCATION, true, heroEntity, player, heroEntity:GetTeamNumber())
  heroEntity.glyphUnit = glyphUnit
  glyphUnit.hero = heroEntity
  glyphUnit:AddAbility("town_unit"):SetLevel(1)
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."glyph_unit", {glyphUnit = glyphUnit:GetEntityIndex()})
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."-glyph-"..tostring(1), {glyphIndex = -1})
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."-glyph-"..tostring(2), {glyphIndex = -1})
  CustomNetTables:SetTableValue("skill_tree", tostring(playerID).."-glyph-"..tostring(3), {glyphIndex = -1})

  CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-resources", {arcane = -1})
  CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-enchanter", {tier = -1})
  CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-mithril", {mithril = -1})
  CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-income", {available = 0})
  CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-challenge", {completed = -1})

  Timers:CreateTimer(4, function()
    Glyphs:GetPlayerResources(playerID)
    Stars:GetPlayerStars(playerID)
    if GameState:IsRPCArena() then
      Arena:GetCharacterArenaData(playerID, heroEntity)
    end
  end)

  -- CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-resources", {arcane = 10000})
  -- CustomNetTables:SetTableValue("player_stats", tostring(playerID).."-enchanter", {tier = 7})

  Runes:RedirectRunes(heroEntity, runeUnit, runeUnit2, runeUnit3, runeUnit4, playerID)
end

function Events:SetupHeroes(heroEntity)

    table.insert(MAIN_HERO_TABLE, heroEntity)


    CustomNetTables:SetTableValue("hero_index", tostring(heroEntity:GetEntityIndex()), {playerOwner = tostring(heroEntity:GetPlayerID())} )
    heroEntity:SetAbilityPoints(0)
    ownerID = heroEntity:GetPlayerOwnerID()
    heroEntity.owner = ownerID
    heroEntity.inTown = true
    heroEntity.maxCrystals = 0
    heroEntity.crystalsPickedUp = 0
    heroEntity.crystalsToSave = 0
    heroEntity.baseAttackCapability = heroEntity:GetAttackCapability()
    print(heroEntity:GetUnitName())
    Timers:CreateTimer(14, function()
      heroEntity.originalProjectile = Events.HEROKV[heroEntity:GetUnitName()]["ProjectileModel"]
      heroEntity.baseProjectileSpeed = heroEntity:GetProjectileSpeed()
    end)

    -- Timers:CreateTimer(6, function()
      CustomNetTables:SetTableValue("player_stats", tostring(ownerID), {skillPoints = 0, runePoints = 3} )
      Events:CreateRuneUnits(heroEntity, ownerID)
      heroEntity.InventoryUnit = CreateUnitByName("inventory_unit", Vector(-8000,2000), true, heroEntity, PlayerResource:GetPlayer(ownerID), heroEntity:GetTeamNumber())
      heroEntity.InventoryUnit:AddAbility("town_unit"):SetLevel(1)
      heroEntity.InventoryUnit:AddAbility("attribute_bonuses"):SetLevel(1)
      heroEntity.InventoryUnit.hero = heroEntity
      Events:SetupInventoryUnit(heroEntity.InventoryUnit)
      Events:InitializeHero(heroEntity)
      Weapons:weaponRedirect(heroEntity)

    -- end)
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

        Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_command_restric_player", {duration = 20})
    end
    Events.gameLoaded = true
    heroEntity.origModelScale = heroEntity:GetModelScale()
    GameState:RecordPlayerID(heroEntity)
    Timers:CreateTimer(1.5, function()
      Events:PremiumPlayerLoaded(heroEntity)
    end)
  --Events:LockCamera(heroEntity)
  if GameState:IsRedfallRidge() then
    Redfall:InitializeHero(heroEntity)
  end
  if Events.GameMaster then
    Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_hero_thinker", {})
  else
    Timers:CreateTimer(3, function()
      if Events.GameMaster then
        Events:GetGameMasterAbility():ApplyDataDrivenModifier(Events.GameMaster, heroEntity, "modifier_hero_thinker", {})
      else
        return 3
      end
    end)
  end
end

function Events:CreateCollectionBeam(attachPointA, attachPointB)
      local particleName = "particles/items_fx/mithril_collect.vpcf"
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
      ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z))   
      ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z))
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
      end)
end

function Events:PremiumPlayerLoaded(heroEntity)
    local playerID = heroEntity:GetPlayerOwnerID()
    if GameState:GetPlayerPremiumStatus(playerID) then
        print("update_premium")
        CustomNetTables:SetTableValue("premium_pass", tostring(playerID), {pass = 1} )
    else
      CustomNetTables:SetTableValue("premium_pass", tostring(playerID), {pass = 0} )
    end
    CustomGameEventManager:Send_ServerToAllClients("update_premium", {playerID = playerID} )
    local premiumAbility = Events.GameMaster:FindAbilityByName("premium_abilities")
    local premiumCount = GameState:GetPlayerPremiumStatusCount()
    if premiumCount > 0 then
      for i = 1, #MAIN_HERO_TABLE, 1 do
        premiumAbility:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_premium_magic", {})
        MAIN_HERO_TABLE[i]:SetModifierStackCount( "modifier_premium_magic", premiumAbility,  premiumCount)
      end
    end
end

function Events:LockCamera(heroEntity)
    if heroEntity:IsHero() then
      local playerID = heroEntity:GetPlayerID()
      if PlayerResource:IsValidPlayerID(playerID) then
        PlayerResource:SetCameraTarget(playerID, heroEntity)
        Timers:CreateTimer(1.8,
        function()
          PlayerResource:SetCameraTarget(playerID, nil)
        end)
      end
    end
end

function Events:LockCameraWithDuration(heroEntity, duration)
    if heroEntity:IsHero() then
      local playerID = heroEntity:GetPlayerID()
      if PlayerResource:IsValidPlayerID(playerID) then
        PlayerResource:SetCameraTarget(playerID, heroEntity)
        Timers:CreateTimer(duration,
        function()
          PlayerResource:SetCameraTarget(playerID, nil)
        end)
      end
    end
end

function Events:UpdateKillScores(killedUnit, killerEntity)
  local killingPlayer = killerEntity.owner
  if killingPlayer then
      PlayerResource:IncrementKills(killingPlayer, 1)
  end
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )

  -- GameMode:_OnEntityKilled( keys )
  

  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  local killerEntity = nil
  local xpBounty = killedUnit:GetDeathXP()
  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end
  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
    if killedUnit.itemLevel then
      Dungeons.itemLevel = killedUnit.itemLevel
    end
    if killedUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
      PopupExperience(killedUnit, killedUnit:GetDeathXP())
      -- Events:updateKillQuest(killedUnit)
      Events:UpdateKillScores(killedUnit,killerEntity)

      if xpBounty > 0 then
        RPCItems:RollDrops(killedUnit, killerEntity)
      end
      Weapons:UpdateWeaponXP(xpBounty)
      if killedUnit.minDrops then
        Events:RollExtraItems(killedUnit:GetDeathXP(), killedUnit:GetAbsOrigin(), killedUnit.minDrops, killedUnit.maxDrops)
      end

      -- Events:SpecialDeath(killedUnit, killerEntity)
      Timers:CreateTimer(8,
        function()
              UTIL_Remove(killedUnit)

        end)
  
    end
    if killedUnit.dummy then
      killedUnit.dummy:RemoveSelf()
    end
  if GameState:IsPVPAlpha() then
    PVP:PlayerKill(killerEntity, killedUnit)
  else
    if killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and killedUnit:IsHero() and not killedUnit:HasModifier("modifier_paladin_rune_a_c_revivable") and not killedUnit:HasModifier("modifier_phoenix_rebirthing") then
      Timers:CreateTimer(0.06, function()
        local respawnTime = 20
        if MAIN_HERO_TABLE then
          respawnTime = #MAIN_HERO_TABLE*10
        end
        -- if killedUnit:HasModifier("modifier_duskbringer_glyph_2_1") then
        --   respawnTime = 20
        -- end
        if killedUnit:HasModifier("modifier_neutral_glyph_4_1") then
          respawnTime = respawnTime * 0.2
          killedUnit.deathPosition = killedUnit:GetAbsOrigin()
          killedUnit.prelastDeathTime = killedUnit.lastDeathTime
          killedUnit.lastDeathTime = GameRules:GetGameTime()
        end
        respawnTime = math.min(killedUnit:GetTimeUntilRespawn(), respawnTime)
        if killedUnit:HasModifier("modifier_slipfinn_immortal_weapon_1") then
          if killedUnit:GetUnitName() == "npc_dota_hero_slark" then
            respawnTime = 5
          end
        end
        killedUnit:SetTimeUntilRespawn(respawnTime)
      end)
      Timers:CreateTimer(2,
        function()
          Challenges:PlayerDied()
          if GameState:GetDifficultyFactor() > 1 then
            Events:CheckLoseCondition()
          end
        end)
    end
  end
end

function Events:RollExtraItems(xpBounty, origin, minDrops, maxDrops)
    minDrops = math.max(minDrops-1, 0)
    maxDrops = math.max(minDrops-1, maxDrops-1)
    for i = 0, RandomInt(minDrops, maxDrops), 1 do
      RPCItems:RollItemtype(xpBounty, origin, 0, 0)
    end
end

function Events:SpecialDeath(killedUnit, killerEntity)
  if killedUnit:GetUnitName() == "rare_ghost" then
    RPCItems:RollGhostSlippers(killedUnit:GetAbsOrigin())
  end
end

function Events:PlayerKill(killedUnit, killerEntity)
  if killerEntity.owner and not killedUnit:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
    if string.find(killerEntity.owner, "forest_boss") then
      FOREST_BOSS_KILL_SOUNDS_TABLE = {"nevermore_nev_deny_03", "nevermore_nev_arc_win_07", "nevermore_nev_arc_kill_01", "nevermore_nev_arc_kill_02", "nevermore_nev_arc_kill_03", "nevermore_nev_arc_kill_04", "nevermore_nev_arc_kill_05", "nevermore_nev_arc_kill_06", "nevermore_nev_arc_kill_07"}
      local soundIndex = RandomInt(1,9)
      EmitGlobalSound(FOREST_BOSS_KILL_SOUNDS_TABLE[soundIndex])
      EmitGlobalSound(FOREST_BOSS_KILL_SOUNDS_TABLE[soundIndex])
      EmitGlobalSound(FOREST_BOSS_KILL_SOUNDS_TABLE[soundIndex])
      EmitGlobalSound(FOREST_BOSS_KILL_SOUNDS_TABLE[soundIndex])
    end
  end
  --playerID = killedUnit:GetPlayerID()
  --PlayerResource:SetCameraTarget(playerID, nil)
  --Timers:CreateTimer(killedUnit:GetTimeUntilRespawn() + 1, 
  -- function()
  --  PlayerResource:SetCameraTarget(playerID, killedUnit)
  --end)  
end

function Events:ForestBossKill(forest_boss)
      for i = 0, RandomInt(10, 15), 1 do
        Timers:CreateTimer(0.4*i, 
        function()
          RPCItems:RollItemtype(300, forest_boss:GetAbsOrigin(), 1, 0)
        end)
      end
      local luck = RandomInt(1, 5)
      if luck == 5 then
        RPCItems:RollNeverlordRing(300, forest_boss:GetAbsOrigin(), "immortal", false, "", nil)
      end
end

function Events:DesertBossKill(forest_boss)
      for i = 0, RandomInt(10, 15), 1 do
        Timers:CreateTimer(0.4*i, 
        function()
          RPCItems:RollItemtype(1500, forest_boss:GetAbsOrigin(), 1, 0)
        end)
      end
end

function Events:CheckLoseCondition()
  local deadCount = 0
  for i = 1, #MAIN_HERO_TABLE, 1 do
    if not MAIN_HERO_TABLE[i]:IsAlive() and not MAIN_HERO_TABLE[i]:HasModifier("modifier_phoenix_rebirthing") and not MAIN_HERO_TABLE[i]:HasModifier("modifier_paladin_rune_a_c_reviving") then
      if (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) == 2) or (PlayerResource:GetConnectionState(MAIN_HERO_TABLE[i]:GetPlayerOwnerID()) ==1) then
        deadCount = deadCount + 1
      end
    end
  end
  if deadCount == RPCItems:GetConnectedPlayerCount() then
    Events:ChampionsLose()
  end
end

function Events:ChampionsLose()
  if not GameState.over then
    if GameState:IsWorld1() then
      GameState.over = true
      Notifications:TopToAll({image="file://{images}/custom_game/text/gameover.png", duration=5.0})
      -- Timers:CreateTimer(5, function()
      --   Notifications:TopToAll({text="View match history and player stats at https://roshpit.ca/champions", duration=8.0})
      -- end)

      GameState:RecordMatch()
        Timers:CreateTimer(5, 
        function()
          GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
        end)  
    end
  end
end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(keys)

  GameMode:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  DebugPrint('[BAREBONES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname

end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndeTxoHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

function Events:beginQuests()
  -- print("BEGINQUESTS IS HAPPENING")
  Beacons:DEBUG()
end

function Events:InitGameEntities()
    Events.SafeItemEntity = CreateUnitByName("npc_dummy_unit", Vector(0,0), true, nil, nil, DOTA_TEAM_GOODGUYS)
    Events.SafeItemEntity:FindAbilityByName("dummy_unit"):SetLevel(1)
end

function Events:initializeTown()
  print("initialize world 1")
  GameState:InitializeGameState()
  -- Beacons:MakeBeacon(Vector(-6443,-5282), "wave", "forestForest", 0)
  Timers:CreateTimer(5, function()
    Beacons:CreateBeacons()
  end)
  -- Timers:CreateTimer(1, function()
  --     CustomGameEventManager:Send_ServerToAllClients("open_oracle", {playerID = 0} )
  -- end)
  Dungeons.cleared = {}
  Timers:CreateTimer(10, function()
    Beacons:WorldBeacons()
  end)


  Events.TownPosition = Vector(-13888, 13248)
  
  Timers:CreateTimer(3, function()
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13888,14380), 1250, 99999, false)
    -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13888,1928), 500, 99999, false)
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13945, 12400, 200), 500, 99999, false)
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-14452, 12400, 200), 500, 99999, false)
    AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-13438, 12400, 200), 500, 99999, false)
    
    -- AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(-5500, 5200, 1000), 7000, 99999, false)
    local point = Vector(-14528, 14528)
    Events.portal = CreateUnitByName("town_portal", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
    Events.portal:NoHealthBar()
    Events.portal:AddAbility("town_portal")
    Events.portal:FindAbilityByName("town_portal"):SetLevel(1)
    
    Events.firstTeleported = false
    Events.isTownActive = true
    Events.portalPosition = Vector(-7808,-5504)
    Events.portal.teleportLocation = Events.portalPosition
    Events.portal.active = true
    Events.portal.name = "mainTown"
    particleName = "particles/econ/events/ti5/town_portal_start_lvl2_ti5.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, Events.portal )
    ParticleManager:SetParticleControl( particle1, 0, Events.portal:GetAbsOrigin() + Vector(0,0,20))
    
    point = Vector(-12800, 13696)
    local fountain = CreateUnitByName("npc_dummy_unit", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
    fountain:NoHealthBar()
    fountain:AddAbility("dummy_unit")
    fountain:FindAbilityByName("dummy_unit"):SetLevel(1)
    fountain:AddAbility("fountain_aura")
    fountainAbility = fountain:FindAbilityByName("fountain_aura")
    fountainAbility:SetLevel(1)

  end)
  
  Events.Dialog0 = false
  Events.Dialog1 = false
  Events.Dialog2 = false
  Events.Dialog3 = false

  Timers:CreateTimer(3, function()
      Events:SpawnTownNPC(Vector(-14528, 14928), "red_fox", Vector(0, -1), "models/items/courier/mei_nei_rabbit/mei_nei_rabbit.vmdl", nil, nil, 1.3, true, "rabbit")
      Events:SpawnTownNPC(Vector(-15686, 14784), "red_fox", Vector(2, -1), "models/items/courier/shroomy/shroomy.vmdl", nil, nil, 1, false, "shroom1")
      Events:SpawnTownNPC(Vector(-15477, 14711), "red_fox", Vector(-2, -1), "models/items/courier/shroomy/shroomy.vmdl", nil, nil, 1.05, false, "shroom2")
      Events:SpawnTownNPC(Vector(-15705, 14658), "red_fox", Vector(3, 1), "models/items/courier/shroomy/shroomy.vmdl", nil, nil, 1.1, false, "shroom3")
      Events:SpawnTownNPC(Vector(-14439, 13658), "red_fox", Vector(1, 1), "models/items/courier/teron/teron.vmdl", nil, nil, 1.7, false, "beaver")
      -- Events:SpawnTownNPC(Vector(-5800, 5400), "red_fox", Vector(1, 0), "models/items/courier/gama_brothers/gama_brothers.vmdl", "chest_patrol", "modifier_chest_patrol_point_one", 1.15, false, "chest_brothers")
      -- Events:SpawnTownNPC(Vector(-13824, 15104), "red_fox", Vector(-0.2, -1), "models/items/courier/dokkaebi_nexon_courier/dokkaebi_nexon_courier.vmdl", nil, nil, 1.7, false, "merchant")
      
      -- Events:SpawnTownNPC(Vector(-5925, 3320), "red_fox", Vector(0, -1), "models/items/courier/bearzky/bearzky.vmdl", nil, nil, 1.4, false, "bearzky")
      -- Events:SpawnTownNPC(Vector(-13504, 14528), "red_fox", Vector(10, 1), "models/items/courier/snowl/snowl.vmdl", "owl_patrol", "modifier_owl_patrol_point_one", 1.6, false, "owl")
      Events:SpawnTownNPC(Vector(-12992, 14720), "red_fox", Vector(-1, 0), "models/items/courier/vigilante_fox_red/vigilante_fox_red.vmdl", nil, nil, 1.6, false, "red_fox")
      local blacksmith = Events:SpawnTownNPC(Vector(-15104, 14198), "red_fox", Vector(0, -1), "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", nil, nil, 1.1, false, "blacksmith")
      StartAnimation(blacksmith, {duration=99999, activity=ACT_DOTA_IDLE, rate=1.0})
      Events.BookGuy = Events:SpawnTownNPC(Vector(-6243,-5082), "red_fox", Vector(-1, -1), "models/items/courier/bookwyrm/bookwyrm.vmdl", nil, nil, 1.2, false, "book")
      Events.BookGuy.state = 0

      Events:SpawnGamemaster(Vector(-8000,2000))

      local oracle = Events:SpawnOracle(Vector(-14784, 14276), Vector(1, -0.2))
      local crusader = Events:SpawnCrusader(Vector(-13888, 14464), Vector(-0.2,-1))

      Events:SpawnTownNPC(Vector(-15122, 14740), "red_fox", Vector(1, -1), "models/items/courier/coco_the_courageous/coco_the_courageous.vmdl", nil, nil, 1.6, false, "beer_bear")
      Events.GlyphEnchanter = Events:SpawnGlyphEnchanter(Vector(-13192, 14920), Vector(-1, -1))
      Events:SpawnSuppliesDealer(Vector(-13824, 15154), Vector(-0.2, -1))
    end)
end

function Events:SpawnGamemaster(position)
      if Events.GameMaster then
        Events.GameMaster:SetAbsOrigin(position)
      end
      Events.GameMaster = CreateUnitByName("rune_unit", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
      print("GAME MASTER")
      print(Events.GameMaster)
      local abil = Events.GameMaster:AddAbility("npc_abilities")
      abil:SetLevel(1)
      Events.GameMaster:AddAbility("premium_abilities"):SetLevel(1)
      Events.GameMaster:AddAbility("dummy_unit"):SetLevel(1)
      Events.GameMaster:AddAbility("rpc_hero_town_portal"):SetLevel(1)
      Events.GameMaster:AddAbility("respawn_abilities"):SetLevel(1)
      --Events.GameMaster.portal =
      Events.GameMaster:AddAbility("town_portal"):SetLevel(1)
      Events.GameMaster:RemoveModifierByName("modifier_portal")
      Events.GameMaster.portal = Events.GameMaster:FindAbilityByName("town_portal")
      Events.GameMasterAbility = abil
      return Events.GameMaster
end

function Events:GetGameMasterAbility()
  local gameMasterAbility = Events.GameMaster:FindAbilityByName("npc_abilities")
  return gameMasterAbility
end

function Events:SpawnOracle(position, forwardVector)
  local oracle = CreateUnitByName("the_oracle", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
  oracle:SetForwardVector(forwardVector)
  oracle:NoHealthBar()
  oracle:AddAbility("town_unit")
  oracle:AddAbility("npc_dialogue")
  oracle:FindAbilityByName("town_unit"):SetLevel(1)
  oracle:FindAbilityByName("npc_dialogue"):SetLevel(1)
  oracle.dialogueName = "oracle"
end

function Events:SpawnCurator(position, forwardVector)
  local oracle = CreateUnitByName("the_curator", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
  oracle:SetForwardVector(forwardVector)
  oracle:NoHealthBar()
  oracle:AddAbility("town_unit")
  oracle:AddAbility("npc_dialogue")
  oracle:FindAbilityByName("town_unit"):SetLevel(1)
  oracle:FindAbilityByName("npc_dialogue"):SetLevel(1)
  oracle.dialogueName = "curator"
  Events.curator = oracle
  return oracle
end

function Events:SpawnCrusader(position, forwardVector)
  local oracle = CreateUnitByName("the_crusader", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
  oracle:SetForwardVector(forwardVector)
  oracle:NoHealthBar()
  oracle:AddAbility("town_unit")
  oracle:AddAbility("npc_dialogue")
  oracle:FindAbilityByName("town_unit"):SetLevel(1)
  oracle:FindAbilityByName("npc_dialogue"):SetLevel(1)
  oracle.dialogueName = "crusader"
end

function Events:SpawnGlyphEnchanter(position, forwardVector)
  local oracle = CreateUnitByName("the_glyph_enchanter", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
  oracle:SetForwardVector(forwardVector)
  oracle:NoHealthBar()
  oracle:AddAbility("town_unit")
  oracle:AddAbility("npc_dialogue")
  oracle:FindAbilityByName("town_unit"):SetLevel(1)
  oracle:FindAbilityByName("npc_dialogue"):SetLevel(1)
  oracle.dialogueName = "glyph_enchanter"
  return oracle
end

function Events:SpawnSuppliesDealer(position, forwardVector)
  local oracle = CreateUnitByName("supplies_dealer", position, true, nil, nil, DOTA_TEAM_GOODGUYS)
  oracle:SetForwardVector(forwardVector)
  oracle:SetModelScale(1.04)
  oracle:NoHealthBar()
  oracle:AddAbility("town_unit")
  oracle:AddAbility("npc_dialogue")
  oracle:FindAbilityByName("town_unit"):SetLevel(1)
  oracle:FindAbilityByName("npc_dialogue"):SetLevel(1)
  oracle.dialogueName = "supplies_dealer"
  return oracle
end

function Events:SpawnTownNPC(point, unitName, fVector, model, patrolAbility, initialPatrolModifier, modelScale, bSpeech, dialogueName)
 if dialogueName == "blacksmith" then
  unitName = "the_blacksmith"
 end
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
  foxNPC:NoHealthBar()
  foxNPC:AddAbility("town_unit")
  foxNPC:AddAbility("npc_dialogue")
  foxNPC:FindAbilityByName("town_unit"):SetLevel(1)
  foxNPC:FindAbilityByName("npc_dialogue"):SetLevel(1)
  if patrolAbility then
    foxNPC:AddAbility(patrolAbility)
    patrolAbility = foxNPC:FindAbilityByName(patrolAbility)
    patrolAbility:SetLevel(1)
    patrolAbility:ApplyDataDrivenModifier(foxNPC, foxNPC, initialPatrolModifier, {})
  end
  return foxNPC
end

function Events:updateKillQuest(killedUnit)
  if killedUnit:GetDeathXP() > 0 then
    PopupExperience(killedUnit, killedUnit:GetDeathXP())
  end
  if GameRules.Quest then
    GameRules.Quest.UnitsKilled = GameRules.Quest.UnitsKilled + 1
    GameRules.Quest.UnitsKilledPart = GameRules.Quest.UnitsKilledPart + 1
          GameRules.Quest:SetTextReplaceValue(QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.Quest.UnitsKilled)
          GameRules.subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.Quest.UnitsKilled )
          if GameRules.Quest.UnitsKilledPart == GameRules.Quest.KillLimit1 and GameRules.Quest.Subwave == 0 then
                Events:wave_redirect()
                GameRules.Quest.UnitsKilledPart = 0
                GameRules.Quest.Subwave =  GameRules.Quest.Subwave + 1
          end
          if GameRules.Quest.UnitsKilledPart == GameRules.Quest.KillLimit2 and GameRules.Quest.Subwave == 1 then
                Events:wave_redirect()
                GameRules.Quest.UnitsKilledPart = 0
                GameRules.Quest.Subwave =  GameRules.Quest.Subwave + 1
          end
          if GameRules.Quest.UnitsKilledPart == GameRules.Quest.KillLimit3 and GameRules.Quest.Subwave == 2 then
                Events:wave_redirect()
                GameRules.Quest.UnitsKilledPart = 0
                GameRules.Quest.Subwave =  GameRules.Quest.Subwave + 1
          end
          if GameRules.Quest.UnitsKilled == GameRules.Quest.KillLimit then

              EmitGlobalSound("Tutorial.Quest.complete_01")
              Notifications:TopToAll({image="file://{images}/custom_game/text/wave-clear-simple.png", duration=4.0})
              Timers:CreateTimer(3, -- Start this timer 10 game-time seconds later
              function()
                GameRules.Quest:CompleteQuest()
                GameRules.Quest.UnitsKilled = -100
                GameRules.Quest.KillLimit = -1000
                Beacons:WaveClear(Events.WaveNumber)
              end)  
              --Timers:CreateTimer(8,
              --  function() 
              --  Events:killOffWave()
              --  end)          
          end
  end
        if (killedUnit:GetUnitName() == "the_butcher") and (GameRules.QuestBoss) then
          GameRules.QuestBoss:CompleteQuest()
          EmitGlobalSound("Tutorial.Quest.complete_01")
        elseif (killedUnit:GetUnitName() == "forest_boss") and (GameRules.QuestBoss) then
          GameRules.QuestBoss:CompleteQuest()
          EmitGlobalSound("Tutorial.Quest.complete_01")
          --Events.WaveNumber = Events.WaveNumber + 1
          Events:wave_redirect()
        elseif (killedUnit:GetUnitName() == "experimenter_jonuous_boss_phase_four") and (GameRules.QuestBoss) then
          GameRules.QuestBoss:CompleteQuest()
          EmitGlobalSound("Tutorial.Quest.complete_01")
          --Events.WaveNumber = Events.WaveNumber + 1
          Events:wave_redirect()
        elseif (killedUnit:GetUnitName() == "mines_boss") and (GameRules.QuestBoss) then
          GameRules.QuestBoss:CompleteQuest()
          EmitGlobalSound("Tutorial.Quest.complete_01")
          --Events.WaveNumber = Events.WaveNumber + 1
          Events:wave_redirect()
        end

end

function Events:killOffWave()
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    local enemies = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, Vector(0,0), nil, 30000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, target_flags, 0, false )
    if #enemies > 0 then
      for _,enemy in pairs(enemies) do
        if enemy:IsAlive() then
          enemy:RemoveSelf()
        end
      end
    end
end

function Events:TeleportUnit(unit, position, ability, caster, delay)
        StartSoundEvent("Hero_Chen.TeleportLoop", unit)
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_recently_teleported_portal", {duration = 9})
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_teleporting", {})
        Timers:CreateTimer(delay,
        function()
        EmitSoundOn("Portal.Hero_Appear", unit)
        end)
      Timers:CreateTimer(delay+0.6,
      function()
        CustomGameEventManager:Send_ServerToPlayer(unit:GetPlayerOwner(), "close_oracle", {})
        StopSoundEvent( "Hero_Chen.TeleportLoop", unit )
        local teleport_position = position
        unit:SetAbsOrigin(teleport_position)
        unit:Stop()
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_teleported", {})
        local groundPos = GetGroundPosition( teleport_position, unit )
        FindClearSpaceForUnit(unit, groundPos, true)
        Events:LockCamera(unit)
        if unit.birdTable then
          for i = 1, #unit.birdTable, 1 do
            unit.birdTable[i]:SetAbsOrigin(position)
          end
        end
      end)
      if unit:GetName() == "npc_dota_hero_invoker" then
        Events:conjurorMinions(unit, position, ability, caster, delay)
      end
      if unit:GetName() == "npc_dota_hero_crystal_maiden" then
        if unit.waterElemental then
          Events:TeleportUnit(unit.waterElemental, position, ability, caster, delay)
        end
      end
      if unit.summonTable then
        for i = 1, #unit.summonTable, 1 do
          if not unit.summonTable[i]:IsNull() then
            Events:TeleportUnit(unit.summonTable[i], position, ability, caster, delay)
          end
        end
      end
      
end

function Events:conjurorMinions(unit, position, ability, caster, delay)
  if unit.earthAspect then
    Events:TeleportUnit(unit.earthAspect, position, ability, caster, delay)
  end
  if unit.fireAspect then
    Events:TeleportUnit(unit.fireAspect, position, ability, caster, delay)
  end
  if unit.shadowAspect then
    Events:TeleportUnit(unit.shadowAspect, position, ability, caster, delay)
  end
end

function Events:wave_redirect()
  print("WAVENUMBER: "..Events.WaveNumber)
  if Events.WaveNumber == 0 then
    Events:wave1()
  end
  if Events.WaveNumber == 1 then
    Events:wave2()
  end
  if Events.WaveNumber == 2 then
    Events:wave3()
  end
  if Events.WaveNumber == 3 then
    Events:wave4()
  end
  if Events.WaveNumber == 4 then
    local luck = RandomInt(1,6)
    if luck == 5 then
      Events:wave5a()
    else
      Events:wave5()
    end
  end
  if Events.WaveNumber == 5 then
    local luck = RandomInt(1,15)
    if luck == 15 then
      Events:wave6a()
    else
      Events:wave6()
    end
  end
  if Events.WaveNumber == 6 then
    local luck = RandomInt(1,6)
    if luck == 5 then
      Events:wave7a()
    else
      Events:wave7()
    end
  end
  if Events.WaveNumber == 7 then
    Events:wave8()
  end
  if Events.WaveNumber == 8 then
    Events:wave9()
  end
  if Events.WaveNumber == 9 then
    Events:wave10()
    Events:prepare_boss_quest("#quest_the_butcher")
  end
  if Events.WaveNumber == 10 then
    Events:wave11()
  end
  if Events.WaveNumber == 11 then
    Events:wave12()
  end
  if Events.WaveNumber == 12 then
    Events:wave17()
    Events.WaveNumber=Events.WaveNumber+4
  end
  if Events.WaveNumber == 13 then
    Events:wave14()
  end
  if Events.WaveNumber == 14 then
    Events:wave15()
  end
  if Events.WaveNumber == 15 then
    Events:wave16()
  end
  if Events.WaveNumber == 16 then
    -- Events:wave17()
  end
  if Events.WaveNumber == 17 then
    Events:wave18()
  end
  if Events.WaveNumber == 18 then
    Events:wave19()
  end
  if Events.WaveNumber == 19 then
    Events:wave20()
  end
  if Events.WaveNumber == 20 then
    Events:wave21()
  end
  if Events.WaveNumber == 21 then
      Timers:CreateTimer(2,
      function()
        Beacons:WaveClear(Events.WaveNumber)
      end)
  end
  if Events.WaveNumber == 22 then
    Events:wave22()
  end
  if Events.WaveNumber == 23 then
    Events:wave23()
  end
  if Events.WaveNumber == 24 then
    Events:wave24()
  end
  if Events.WaveNumber == 25 then
    Events:wave25()
  end
  if Events.WaveNumber == 26 then
    Events:wave26()
  end
  if Events.WaveNumber == 27 then
    Events:wave27()
  end
  if Events.WaveNumber == 28 then
    Events:wave28()
  end
  if Events.WaveNumber == 29 then
    Events:wave29()
  end
  if Events.WaveNumber == 30 then
    Events:wave30()
  end
  if Events.WaveNumber == 31 then
    Events:wave31()
  end
  if Events.WaveNumber == 32 then
    Events:wave32()
  end
  if Events.WaveNumber == 33 then
    Events:wave33()
  end
  if Events.WaveNumber == 34 then
    Events:wave34()
  end
  if Events.WaveNumber == 35 then
    Events:wave35()
  end
  if Events.WaveNumber == 36 then
    Events:wave36()
  end
  if Events.WaveNumber == 37 then
    Events:wave37()
  end
  if Events.WaveNumber == 38 then
    Events:wave38()
  end
  if Events.WaveNumber == 39 then
      Timers:CreateTimer(2,
      function()
        Beacons:WaveClear(Events.WaveNumber)
      end)
  end
  if Events.WaveNumber == 40 then
    Events:wave40()
  end
  if Events.WaveNumber == 41 then
    Events:wave41()
  end
  if Events.WaveNumber == 42 then
    Events:wave42()
  end
  if Events.WaveNumber == 43 then
    Events:wave43()
  end
  if Events.WaveNumber == 44 then
    Events:wave44()
  end
  if Events.WaveNumber == 45 then
    Events:wave45()
  end
  if Events.WaveNumber == 46 then
    Events:wave46()
  end
  if Events.WaveNumber == 47 then
    Events:wave47()
  end
  if Events.WaveNumber == 48 then
    Events:wave48()
  end
  if Events.WaveNumber == 49 then
    Events:wave49()
  end
  if Events.WaveNumber == 50 then
    Events:wave50()
  end
  if Events.WaveNumber == 51 then
    Events:wave51()
  end
  if Events.WaveNumber == 52 then
    Events:wave52()
  end
  if Events.WaveNumber == 53 then
    Events:wave53()
  end
  if Events.WaveNumber == 54 then
    Events:wave54()
  end
  if Events.WaveNumber == 55 then
    Events:wave55()
  end
  if Events.WaveNumber == 56 then
    Events:wave56()
  end
  if Events.WaveNumber == 57 then
    Beacons:WaveClear(Events.WaveNumber)
  end

  Events.WaveNumber = Events.WaveNumber + 1
end

function Events:ChampionsVictory()
  Notifications:TopToAll({image="file://{images}/custom_game/text/victory.png", duration=5})
  Timers:CreateTimer(5, function()
    Notifications:TopToAll({text="View match history and player stats at https://roshpit.ca/champions", duration=8.0})
  end)
  GameState:RecordMatch()
    Timers:CreateTimer(5, 
    function()
      GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
    end)  
end

function Events:prepare_wave_quest(maxValue, questTitle, part1, part2, part3, part4)
  Notifications:TopToAll({image="file://{images}/custom_game/text/wave-spawned.png", duration=4.0})

end

function Events:prepare_boss_quest(bossName)
  GameRules.QuestBoss = SpawnEntityFromTableSynchronous( "quest", { name = "Quest2", title = bossName } )
end

function Events:inBetweenWave(time)
  QuestTimer = SpawnEntityFromTableSynchronous( "quest", { name = "QuestTimer", title = "#quest_next_wave" } )
  QuestTimer.EndTime = time
  QuestTimer:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, time )
  QuestTimer:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, time )

  Timers:CreateTimer(1, function()
    QuestTimer.EndTime = QuestTimer.EndTime - 1
    QuestTimer:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, QuestTimer.EndTime )

    -- Finish the quest when the time is up  
    if QuestTimer.EndTime < 1 then 
        QuestTimer:CompleteQuest()
        return
    else
        return 1 -- Call again every second
    end
end)
end

function Events:GetAdjustedAbilityDamage(normalDamage, increaseFactor, otherFactor)
  local damage = normalDamage
  damage = damage + increaseFactor*(GameState:GetDifficultyFactor()-1)
  damage = damage + otherFactor*(GameState:GetDifficultyFactor()-2)
  return damage
end

function Events:GetDifficultyScaledDamage(normalDamage, eliteDamage, legendDamage)
  if GameState:GetDifficultyFactor() == 1 then
    return normalDamage
  elseif GameState:GetDifficultyFactor() == 2 then
    return eliteDamage
  elseif GameState:GetDifficultyFactor() == 3 then
    return legendDamage
  end
end

function Events:AdjustDeathXP(unit)
    local difficulty = GameState:GetDifficultyFactor()
    local xp = unit:GetDeathXP()
    if difficulty == 1 then
      xp = math.floor(xp*1.3)
    end
    xp = (difficulty-1)*355 + math.ceil(difficulty*xp*1.55)
    if difficulty > 2 then
      xp = math.floor(xp*2)
    elseif difficulty == 2 then
      xp = math.floor(xp*1.5)
    end
    if Events.PreserverXP then
      xp = math.floor(xp*1.2)
    end
    local xpBoost = (RPCItems:GetConnectedPlayerCount()-1)*0.35
    local adjustedXP = xp*(1+xpBoost)*(1+GameState:GetPlayerPremiumStatusCount()*0.1)
    adjustedXP = math.min(adjustedXP, 200000)
    unit:SetDeathXP(adjustedXP)
    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty()/3)
    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty()/3)
    local damageAdjustment = unit:GetAttackDamage()*3*(difficulty-1) + (difficulty-1)*52000
    if GameState:IsTanariJungle() then
      local powerMult = 3
      if difficulty == 3 then
        powerMult = 5
      end
      damageAdjustment = unit:GetAttackDamage()*powerMult*(difficulty-1) + (difficulty-1)*52000
    end
    if difficulty >= 3 then
      if GameState:IsWorld1() then
        damageAdjustment = damageAdjustment + RPCItems:GetMaxFactor()*6400
      end
      if Dungeons.itemLevel > 0 then
        damageAdjustment = math.floor(damageAdjustment*1.6)
      end
      -- damageAdjustment = math.floor(damageAdjustment + unit:GetAttackDamage()*unit:GetAttackDamage()*1.45)
      -- damageAdjustment = math.min(damageAdjustment, 1000000000)
    end
    local minDamage = unit:GetBaseDamageMin()
    local maxDamage = unit:GetBaseDamageMax()
    if Events.SpiritRealm then
      minDamage = minDamage*2.6
      maxDamage = maxDamage*2.6
    end
    unit:SetBaseDamageMin(minDamage+damageAdjustment)
    unit:SetBaseDamageMax(maxDamage+damageAdjustment) 

    -- local newArmor = unit:GetPhysicalArmorValue()*difficulty*difficulty+30*(difficulty-1)
    -- if difficulty > 2 then
    --   newArmor = newArmor+90 + unit:GetPhysicalArmorValue()*4
    -- end
    local newArmor = unit:GetPhysicalArmorBaseValue()*difficulty + 10*(difficulty-1)
    unit:SetPhysicalArmorBaseValue(newArmor)


    local newHealth = unit:GetMaxHealth()*difficulty + (difficulty-1)*unit:GetMaxHealth() + 82000*(difficulty-1)
    if difficulty > 2 then
      newHealth = newHealth + 420000
    end
    newHealth = newHealth + newHealth*0.3*(math.max(RPCItems:GetConnectedPlayerCount()-1, 0))
    newHealth = math.min(newHealth, (2^30)-10)
    unit:SetMaxHealth(newHealth)
    unit:SetBaseMaxHealth(newHealth)
    unit:SetHealth(newHealth)
    unit:Heal(newHealth, unit)

    for i = 0, 6, 1 do
      local ability = unit:GetAbilityByIndex(i)
      if ability then
        ability:SetLevel(difficulty)
      end
    end
    unit.regularEnemy = true
end

function Events:TownSiegeXP(unit)
  unit:SetDeathXP(20)
end

function Events:AdjustBossPower(unit, damageFactor, healthFactor, bHealthbar)
  local difficulty = GameState:GetDifficultyFactor()
  local minDamage = unit:GetBaseDamageMin()
  local maxDamage = unit:GetBaseDamageMax()
  local damageAdjustment = damageFactor*80000*(difficulty-1)
  unit:SetBaseDamageMin(math.min(minDamage+damageAdjustment, 2^30))
  unit:SetBaseDamageMax(math.min(maxDamage+damageAdjustment, 2^30))
  local healthAdjustment = healthFactor*800000*(difficulty-1)
  if difficulty > 2 then
    healthAdjustment = healthAdjustment + healthFactor*1600000
    local armor = unit:GetPhysicalArmorValue()
    unit:SetPhysicalArmorBaseValue(armor+40*healthFactor)
    unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue()*difficulty+(healthFactor*(difficulty-1)*3))
  end
  local newHealth = unit:GetMaxHealth() + healthAdjustment
    newHealth = math.min(newHealth, (2^30)-10)
    unit:SetMaxHealth(newHealth)
    unit:SetBaseMaxHealth(newHealth)
    unit:SetHealth(newHealth)
    unit:Heal(newHealth, unit)
    if bHealthbar then
      CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = unit:GetUnitName(), bossMaxHealth = unit:GetMaxHealth()})
      unit.mainBoss = true
    end
  unit.bossStatus = true
end

function Events:spawnUnit(unitName, spawnPoint, quantity)
  local delay = 2.7
  if Events.WaveNumber > 42 then
    delay = 5
  end
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*delay, 
    function()
      local luck = RandomInt(1, 152)
      if luck == 1 then
        Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else
        local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
        Events:AdjustDeathXP(unit)
        Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_world_1_wave_unit", {})
      end
    end)
  end
end

function Events:spawnUnitMisc(unitName, spawnPoint, quantity)
  local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
  Events:AdjustDeathXP(unit)
  return unit
end

function Events:SpawnBoss(unitName, spawnPoint)
  local boss = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
  Events:AdjustDeathXP(boss)
  boss.mainBoss = true
  CustomGameEventManager:Send_ServerToAllClients("show_boss_health", {bossName = boss:GetUnitName(), bossMaxHealth = boss:GetMaxHealth()})
  return boss
end

function Events:spawnUnitAir(unitName, spawnPoint, quantity)
  for i = 0, quantity-1, 1 do
    local random_x = math.random(1400) - 700
    local random_y = math.random(1400) - 700
    local randomVector = Vector(random_x, random_y)
      local luck = RandomInt(1, 150)
      if luck == 1 then
        Paragon:SpawnParagonPack(unitName, spawnPoint)
      elseif luck == 2 then
        Paragon:SpawnParagonUnit(unitName, spawnPoint)
      else 
        local unit = CreateUnitByName(unitName, spawnPoint + randomVector, true, nil, nil, DOTA_TEAM_NEUTRALS)
        Events:AdjustDeathXP(unit)
      end
  end
end

function Events:createVisionDummy(unit)
  unit.loc = unit:GetAbsOrigin()
  unit.dummy = CreateUnitByName("npc_flying_dummy_vision", unit.loc, true, nil, nil, DOTA_TEAM_GOODGUYS)
  unit.dummy:NoHealthBar()
  unit.dummy:AddAbility("dummy_unit")
  unit.dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
  MinimapEvent(DOTA_TEAM_GOODGUYS, nil, unit.loc.x, unit.loc.y, DOTA_MINIMAP_EVENT_TUTORIAL_TASK_ACTIVE, 5)
  EmitGlobalSound("Hero_Slardar.Pick")
    Timers:CreateTimer(0.1, 
    function()
      unit.loc = unit:GetAbsOrigin()
      unit.dummy:SetAbsOrigin(unit.loc)
      if unit:IsAlive() then
        return 0.1
      end
    end)  
end

function Events:wave1()
    Events:prepare_wave_quest(220, "#quest_waves_1", 48, 60, 60, 52)
    Events:spawnUnit("dark_fighter", SPAWN_POINT_OPEN_1, 3)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_OPEN_2, 3)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_OPEN_3, 3)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_4, 5)
      Events:spawnUnit("icy_venge", SPAWN_POINT_FOREST_4, 1)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_7, 5)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_CAVE_5, 8)
      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_5, 1)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_CAVE_3, 8)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_CAVE_4, 8)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_5, 8)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_2, 5)
      Events:spawnUnit("shroomling", SPAWN_POINT_FOREST_2, 3)
end

function Events:wave2()

      Events:spawnUnit("icy_venge", SPAWN_POINT_FOREST_2, 1)
      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_1, 1)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_CAVE_2, 8)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_FOREST_3, 8)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_FOREST_5, 8)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_FOREST_6, 8)
      Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_OPEN_1, 1)
      Events:spawnUnitAir("gargoyle", SPAWN_POINT_CAVE_4, 4)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_FOREST_9, 6)
      Events:spawnUnit("shroomling", SPAWN_POINT_FOREST_4, 10)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_1, 10)
      Events:spawnUnit("shroomling", SPAWN_POINT_OPEN_2, 5)
      -- 26 units

end

function Events:wave3()

      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 4)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 4)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_FOREST_2, 6)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_3, 6)
      Events:spawnUnit("blood_jumper", SPAWN_POINT_FOREST_4, 8)
      Events:spawnUnit("blood_jumper", SPAWN_POINT_FOREST_5, 8)
      Events:spawnUnit("shroomling", SPAWN_POINT_FOREST_6, 8)
      Events:spawnUnit("shroomling", SPAWN_POINT_FOREST_7, 8)
      Events:spawnUnit("blood_jumper", SPAWN_POINT_FOREST_1, 8)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_4, 4)
end

function Events:wave4()

      Events:spawnUnit("icy_venge", SPAWN_POINT_FOREST_2, 2)
      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_1, 2)
      Events:spawnUnit("icy_venge", SPAWN_POINT_FOREST_3, 3)
      Events:spawnUnit("icy_venge", SPAWN_POINT_FOREST_4, 3)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_GRAVEYARD_3, 2)
      Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_CAVE_2, 1)
      Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_CAVE_3, 1)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_4, 7)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_5, 7)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_6, 7)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_7, 7)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_8, 7)
      Events:spawnUnitAir("gargoyle", SPAWN_POINT_CAVE_4, 4)
      Events:spawnUnitAir("gargoyle", SPAWN_POINT_FOREST_1, 4)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_1, 5)
end

function Events:wave5()

      Events:prepare_wave_quest(210, "#quest_waves_2", 35, 45, 50, 60)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_FOREST_4, 4)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_FOREST_5, 4)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_FOREST_6, 4)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_FOREST_7, 4)
      Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_FOREST_8, 1)     
      Events:spawnUnit("shroomling", SPAWN_POINT_FOREST_1, 1)
      Events:spawnUnit("blood_jumper", SPAWN_POINT_FOREST_2, 10)
      Events:spawnUnitAir("gargoyle", SPAWN_POINT_CAVE_4, 10)
      Events:spawnUnitAir("gargoyle", SPAWN_POINT_CAVE_6, 10)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 4)  
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 2)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_2, 2)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_8, 1)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_6, 1)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_CAVE_2, 2)                     
end

function Events:wave5a()

      Events:prepare_wave_quest(170, "#quest_waves_2", 10, 45, 45, 55)
      Events:spawnUnitSpecial("shroomling_big", SPAWN_POINT_FOREST_4, 2)
      Events:spawnUnitSpecial("shroomling_big", SPAWN_POINT_FOREST_5, 2)
      Events:spawnUnitSpecial("shroomling_big", SPAWN_POINT_FOREST_6, 2)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 4)  
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 4)                    
end

function Events:wave6()


      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_3, 3)
      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_CAVE_2, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_CAVE_1, 3)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_GRAVEYARD_1, 7)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_CAVE_1, 10)
      --Events:spawnUnit("shadow_stacker", SPAWN_POINT_FOREST_1, 4)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_2, 8)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_4, 8)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_6, 8)
      -- 26 units

    print("wave6 spawned")
end

function Events:wave6a()


      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_CAVE_3, 3)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_CAVE_2, 3)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_CAVE_1, 3)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_GRAVEYARD_1, 7)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_CAVE_1, 10)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_FOREST_2, 8)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_FOREST_4, 8)
      Events:spawnUnitSpecial("rare_ghost_minion", SPAWN_POINT_FOREST_6, 8)
      Events:spawnUnitSpecial("rare_ghost", SPAWN_POINT_FOREST_6, 1)
      -- 26 units

    print("wave6a spawned")
end

function Events:wave7()

      --Events:spawnUnit("shadow_stacker", SPAWN_POINT_CAVE_3, 4)
      --Events:spawnUnit("shadow_stacker", SPAWN_POINT_CAVE_4, 1)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_4, 2)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_2, 1)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_1, 1)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_FOREST_1, 7)
      Events:spawnUnit("blood_jumper", SPAWN_POINT_CAVE_1, 10)
      Events:spawnUnitAir("gargoyle", SPAWN_POINT_FOREST_1, 3)
      Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_FOREST_2, 2)
      local luck = RandomInt(1,12)
      if luck == 10 then
        Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_FOREST_7, 15)
      else
        Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_7, 15)
      end
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 3)  
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 3)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_6, 6)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_7, 6)
      -- 26 units
    print("wave7 spawned")
end

function Events:wave7a()
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 3)  
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 3)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_6, 6)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_7, 6)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_4, 2)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_2, 1)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_1, 1)
      Events:spawnUnit("furion_brute", SPAWN_POINT_FOREST_1, 7)
      Events:spawnUnit("furion_brute", SPAWN_POINT_CAVE_1, 10)
      Events:spawnUnitAir("gargoyle", SPAWN_POINT_FOREST_1, 3)
      Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_FOREST_2, 2)
      Events:spawnUnit("furion_brute", SPAWN_POINT_FOREST_7, 15)
end

function Events:wave8()

      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_3, 3)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_4, 4)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_4, 8)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_2, 8)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_3, 8)
      Events:spawnUnit("little_ice", SPAWN_POINT_FOREST_1, 2)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_1, 8)
      Events:spawnUnit("little_ice", SPAWN_POINT_FOREST_1, 8)
      Events:spawnUnit("little_ice", SPAWN_POINT_FOREST_2, 8)
      Events:spawnUnit("little_ice", SPAWN_POINT_FOREST_7, 8)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 4)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_3, 4)

    print("wave8 spawned")
end

function Events:wave9()

      Events:prepare_wave_quest(230, "#quest_waves_3", 50, 50, 55, 55)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_3, 1)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_4, 1)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_2, 1)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_1, 1)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_GRAVEYARD_3, 1)
      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_4, 1)
      Events:spawnUnit("human_rifleman", SPAWN_POINT_FOREST_1, 6)
      Events:spawnUnit("time_walker", SPAWN_POINT_CAVE_1, 8)
      Events:spawnUnit("little_ice", SPAWN_POINT_FOREST_1, 10)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_4, 10)
      --Events:spawnUnit("shadow_stacker", SPAWN_POINT_FOREST_2, 8)
      Events:spawnUnit("blood_jumper", SPAWN_POINT_FOREST_7, 10)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_2, 3)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_3, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 4)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 4)

    print("wave9 spawned")
end

function Events:wave10()

      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_3, 3)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_OPEN_1, 3)
      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("icy_venge", SPAWN_POINT_CAVE_2, 3)
      Events:spawnUnit("shroomling", SPAWN_POINT_CAVE_1, 3)
      Events:spawnUnit("mekanoid_disruptor", SPAWN_POINT_FOREST_1, 2)
      Events:spawnUnit("time_walker", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_1, 2)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_2, 2)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_7, 2)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_2, 4)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_3, 4)
      local butcher = Events:spawnUnitMisc("the_butcher", SPAWN_POINT_OPEN_1, 1)
      Events:AdjustBossPower(butcher, 3, 3, false)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_1, 3)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_3, 10)
      Events:spawnUnit("dark_fighter", SPAWN_POINT_FOREST_4, 10)
      EmitGlobalSound("pudge_pud_spawn_09")
      EmitGlobalSound("pudge_pud_spawn_09")

    print("wave10 spawned")
end

function Events:wave11()

      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_3, 4)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_OPEN_1, 4)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_GRAVEYARD_3, 3)
      --Events:spawnUnit("shadow_stacker", SPAWN_POINT_CAVE_4, 2)
      --Events:spawnUnit("shadow_stacker", SPAWN_POINT_CAVE_2, 3)
      --Events:spawnUnit("shadow_stacker", SPAWN_POINT_CAVE_1, 2)
      Events:spawnUnit("time_walker", SPAWN_POINT_CAVE_1, 3)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_1, 8)
      Events:spawnUnit("time_walker", SPAWN_POINT_FOREST_2, 3)
      Events:spawnUnit("rabid_walker", SPAWN_POINT_FOREST_7, 8)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_2, 4)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_3, 4)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 4)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 4)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_1, 4)
      Events:spawnUnit("spiderling", SPAWN_POINT_FOREST_3, 9)
      Events:spawnUnit("spiderling", SPAWN_POINT_FOREST_4, 9)

end

function Events:wave12()

      Events:spawnUnit("forest_broodmother", SPAWN_POINT_CAVE_2, 3)

      Events:spawnUnit("spiderling2", SPAWN_POINT_CAVE_1, 8)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_CAVE_3, 8)
      Events:spawnUnit("spiderling", SPAWN_POINT_FOREST_1, 8)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_2, 8)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_7, 2)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_2, 3)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_OPEN_3, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 2)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_1, 2)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_5, 4)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_FOREST_3, 4)
      Events:spawnUnit("spiderling", SPAWN_POINT_FOREST_3, 10)
      Events:spawnUnit("spiderling2", SPAWN_POINT_FOREST_4, 10)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("npc_dota_broodmother_web", SPAWN_POINT_FOREST_1 + Vector(-400, -400), 1)
      Events:spawnUnit("npc_dota_broodmother_web", SPAWN_POINT_FOREST_2 + Vector(-400, -400), 1)
      Events:spawnUnit("npc_dota_broodmother_web", SPAWN_POINT_FOREST_3 + Vector(-400, -400), 1)
      Events:spawnUnit("npc_dota_broodmother_web", SPAWN_POINT_FOREST_4 + Vector(-400, -400), 1)
      Events:spawnUnit("npc_dota_broodmother_web", SPAWN_POINT_FOREST_5 + Vector(-400, -400), 1)
      Events:spawnUnit("npc_dota_broodmother_web", SPAWN_POINT_FOREST_6 + Vector(-400, -400), 1)
      
    print("wave12 spawned")
end

function Events:wave13()


      Events:prepare_wave_quest(200, "#quest_waves_4", 55, 45, 40, 35)
      Events:spawnUnit("little_meepo", SPAWN_POINT_OPEN_1, 10)
      Events:spawnUnit("little_meepo", SPAWN_POINT_OPEN_2, 10)
      Events:spawnUnit("little_meepo", SPAWN_POINT_OPEN_3, 10)
      Events:spawnUnit("little_meepo", SPAWN_POINT_FOREST_1, 10)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_7, 4)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_6, 4)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_2, 10)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_3, 10)
    print("wave13 spawned")
end

function Events:wave14()

      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_1, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_2, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_3, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_FOREST_1, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_FOREST_2, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_FOREST_3, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_FOREST_4, 2)
      Events:spawnUnit("little_meepo", SPAWN_POINT_CAVE_1, 8)
      Events:spawnUnit("little_meepo", SPAWN_POINT_CAVE_2, 8)
      Events:spawnUnit("little_meepo", SPAWN_POINT_CAVE_3, 8)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_7, 4)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_6, 4)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("npc_dota_creature_basic_zombie_exploding", SPAWN_POINT_GRAVEYARD_2, 3)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_FOREST_2, 1)

    print("wave14 spawned")
end

function Events:wave15()

      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_1, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_2, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_3, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_1, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_2, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_3, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_4, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_5, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_6, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_7, 2)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_7, 4)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_6, 4)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_1, 10)
      Events:spawnUnit("little_ice", SPAWN_POINT_CAVE_1, 10)
      

    print("wave15 spawned")
end

function Events:wave16()

      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_1, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_2, 3)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_3, 4)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_3, 4)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_2, 4)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_1, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_2, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_3, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_4, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_5, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_6, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_7, 2)
      Events:spawnUnit("little_meepo", SPAWN_POINT_FOREST_7, 4)
      Events:spawnUnit("little_meepo", SPAWN_POINT_FOREST_6, 4)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_1, 2)
      Events:spawnUnit("hook_flinger", SPAWN_POINT_CAVE_1, 2)
      
    print("wave16 spawned")
end

function Events:wave17()
      Events:prepare_wave_quest(255, "#quest_waves_4", 48, 75, 51, 55)
      Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_OPEN_1, 4)
      Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_OPEN_2, 4)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_1, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_2, 3)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_3, 4)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_3, 4)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_2, 4)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_1, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_2, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_3, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_7, 4)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_3, 4)
      Events:spawnUnit("freeze_fiend", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_CAVE_4, 5)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_OPEN_1, 5)

    print("wave17 spawned")
end

function Events:wave18()

      Events:spawnUnit("big_mud", SPAWN_POINT_OPEN_2, 2)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("big_mud", SPAWN_POINT_FOREST_7, 2)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_3, 3)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_4, 3)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_5, 2)

end

function Events:wave19()

      Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_OPEN_1, 4)
      Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_OPEN_2, 4)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_1, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_2, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_3, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_1, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_2, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_3, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_7, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_4, 5)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_1, 5)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_4, 2)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_5, 2)

    print("wave19 spawned")
end

function Events:wave20()

      Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_OPEN_1, 4)
      Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_OPEN_2, 4)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_1, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_2, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_OPEN_3, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("rolling_earth_spirit", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_1, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_2, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_OPEN_3, 1)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("exploding_warrior", SPAWN_POINT_CAVE_2, 2)
      Events:spawnUnit("forest_broodmother", SPAWN_POINT_FOREST_7, 2)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_4, 5)
      Events:spawnUnit("furion_mystic", SPAWN_POINT_FOREST_1, 5)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_3, 2)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_4, 2)
      Events:spawnUnit("big_mud", SPAWN_POINT_CAVE_5, 2)

    print("wave20 spawned")
end



function Events:wave21()

      local boss = Events:SpawnBoss("forest_boss", SPAWN_POINT_OPEN_3)
      Events:AdjustBossPower(boss, 5, 2, true)
      EmitGlobalSound("nevermore_nev_spawn_09")
      EmitGlobalSound("nevermore_nev_spawn_09")
      EmitGlobalSound("nevermore_nev_spawn_09")
      EmitGlobalSound("nevermore_nev_spawn_09")
      Events:prepare_boss_quest("#quest_forest_boss")
    print("wave20 spawned")
end

SPAWN_POINT_DESERT_1 = Vector(4160, -7550)
SPAWN_POINT_DESERT_2 = Vector(5500, -7550)
SPAWN_POINT_DESERT_3 = Vector(3400, -7550)
SPAWN_POINT_DESERT_4 = Vector(1800, -7550)
SPAWN_POINT_DESERT_GRAVEYARD = Vector(6720, -2880)

function Events:wave22()
      Events:prepare_wave_quest(220, "#quest_waves_5", 50, 50, 35, 75)
      for i = 0, 1, 1 do
        Events:spawnUnit("desert_ghost", SPAWN_POINT_DESERT_1, 4)
        Events:spawnUnit("wastelands_archer", SPAWN_POINT_DESERT_2, 4)
        Events:spawnUnit("rockjaw", SPAWN_POINT_DESERT_3, 4)
        Events:spawnUnit("rockjaw", SPAWN_POINT_DESERT_4, 4)
      end
      Events:spawnUnit("desert_ghost", SPAWN_POINT_DESERT_1, 7)
      Events:spawnUnit("wastelands_archer", SPAWN_POINT_DESERT_2, 5)
      Events:spawnUnit("wastelands_archer", SPAWN_POINT_DESERT_2, 5)
      Events:spawnUnit("rockjaw", SPAWN_POINT_DESERT_3, 7)
      Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_4, 2)
    print("wave22 spawned")
end


function Events:wave23()
      Events:spawnUnit("dune_crasher", SPAWN_POINT_DESERT_1, 5)
      Events:spawnUnit("wastelands_archer", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_4, 5)
      Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_4, 5)
      Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_2, 7)
      Events:spawnUnit("wastelands_archer", SPAWN_POINT_DESERT_4, 7)
      Events:spawnUnit("rockjaw", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("rockjaw", SPAWN_POINT_DESERT_3, 7)
      Events:spawnUnit("dune_crasher", SPAWN_POINT_DESERT_4, 5)

    print("wave23 spawned")
end

function Events:wave24()
      Events:spawnUnit("goremaw_shaman", SPAWN_POINT_DESERT_1, 5)
      Events:spawnUnit("goremaw_shaman", SPAWN_POINT_DESERT_2, 5)
      Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_4, 7)
      Events:spawnUnit("goremaw_shaman", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_1, 5)
      Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_4, 5)


    print("wave24 spawned")
end


function Events:wave25()
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_1, 5)
      for i = 0, 1, 1 do
        Events:spawnUnit("satyr_doctor", SPAWN_POINT_DESERT_2, 5)
        Events:spawnUnit("goremaw_shaman", SPAWN_POINT_DESERT_3, 5)
        Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_1, 5)
        Events:spawnUnit("goremaw_shaman", SPAWN_POINT_DESERT_1, 5)
        Events:spawnUnit("satyr_doctor", SPAWN_POINT_DESERT_4, 5)
        Events:spawnUnit("scarab", SPAWN_POINT_DESERT_3, 5)
        Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_1, 5)
        Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_1, 5)
    end

    print("wave25 spawned")
end

function Events:wave26()
      Events:prepare_wave_quest(280, "#quest_waves_6", 62, 55, 90, 60)
      for i = 0, 1, 1 do
        Events:spawnUnit("bone_horror", SPAWN_POINT_DESERT_1, 7)
        Events:spawnUnit("bone_horror", SPAWN_POINT_DESERT_2, 8)
        Events:spawnUnit("scarab", SPAWN_POINT_DESERT_3, 7)
        Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_4, 8)
      end
      Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_2, 7)
      Events:spawnUnit("scarab", SPAWN_POINT_DESERT_1, 7)

    print("wave26 spawned")
end

function Events:wave27()
      Events:spawnUnit("alpha_wolf", SPAWN_POINT_DESERT_1, 5)
      Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_DESERT_2, 5)
      for i = 0, 1, 1 do
        Events:spawnUnit("twitch_lone_druid", SPAWN_POINT_DESERT_3, 7)
        Events:spawnUnit("npc_dota_creature_desert_zombie", SPAWN_POINT_DESERT_GRAVEYARD, 7)
        Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_2, 8)
        Events:spawnUnit("alpha_wolf", SPAWN_POINT_DESERT_4, 5)
      end
      Events:spawnUnit("satyr_doctor", SPAWN_POINT_DESERT_2, 5)


    print("wave27 spawned")
end

function Events:wave28()
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_1, 9)
      for i = 0, 1, 1 do
        Events:spawnUnit("goremaw_shaman", SPAWN_POINT_DESERT_2, 6)
        Events:spawnUnit("scarab", SPAWN_POINT_DESERT_3, 6)
        Events:spawnUnit("big_mud", SPAWN_POINT_DESERT_1, 3)
        Events:spawnUnit("bone_horror", SPAWN_POINT_DESERT_2, 6)
      end
      Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_4, 9)


    print("wave28 spawned")
end

function Events:wave29()
      Events:spawnUnit("alpha_wolf", SPAWN_POINT_DESERT_1, 8)
      Events:spawnUnit("alpha_wolf", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("alpha_wolf", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("alpha_wolf", SPAWN_POINT_DESERT_4, 8)
      Events:spawnUnit("general_wolfenstein", SPAWN_POINT_DESERT_3, 1)
      Events:spawnUnit("wolf_ally", SPAWN_POINT_DESERT_1, 8)
      Events:spawnUnit("wolf_ally", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("wolf_ally", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("wolf_ally", SPAWN_POINT_DESERT_4, 8)


    print("wave29 spawned")
end

function Events:wave30()
      Events:prepare_wave_quest(240, "#quest_waves_7", 55, 60, 51, 65)
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_1, 8)
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("scarab", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("scarab", SPAWN_POINT_DESERT_4, 8)
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_1, 8)
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_4, 8)


    print("wave30 spawned")
end

function Events:wave31()
      Events:spawnUnit("desert_warlord", SPAWN_POINT_DESERT_1, 10)
      Events:spawnUnit("desert_warlord", SPAWN_POINT_DESERT_2, 10)
      Events:spawnUnit("goremaw_shaman", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_4, 8)
      Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_1, 8)
      Events:spawnUnit("bone_horror", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("npc_dota_creature_desert_zombie", SPAWN_POINT_DESERT_GRAVEYARD, 6)
      Events:spawnUnit("alpha_wolf", SPAWN_POINT_DESERT_4, 8)


    print("wave31 spawned")
end

function Events:wave32()
      Events:spawnUnit("desert_warlord", SPAWN_POINT_DESERT_1, 8)
      Events:spawnUnit("desert_warlord", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("dune_crasher", SPAWN_POINT_DESERT_3, 6)
      Events:spawnUnit("goremaw_brute", SPAWN_POINT_DESERT_4, 6)
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_1, 5)
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_2, 5)
      Events:spawnUnit("skittering_beetle", SPAWN_POINT_DESERT_3, 5)
      Events:spawnUnit("scarab", SPAWN_POINT_DESERT_4, 5)
      Events:spawnUnit("satyr_doctor", SPAWN_POINT_DESERT_2, 10)


    print("wave32 spawned")
end

function Events:wave33()
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_1, 10)
      Events:spawnUnit("wandering_mage", SPAWN_POINT_DESERT_2, 10)
      Events:spawnUnit("blood_fiend", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("blood_fiend", SPAWN_POINT_DESERT_4, 8)
      Events:spawnUnit("blood_fiend", SPAWN_POINT_DESERT_1, 8)
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_2, 8)
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_3, 8)
      Events:spawnUnit("bone_horror", SPAWN_POINT_DESERT_4, 6)
      Events:spawnUnit("satyr_doctor", SPAWN_POINT_DESERT_2, 6)


    print("wave33 spawned")
end

function Events:wave34()
      Events:prepare_wave_quest(185, "#quest_waves_8", 46, 50, 40, 40)
      -- local jonuous_sounds_table = {}
      Events:spawnUnit("blood_fiend", SPAWN_POINT_DESERT_4, 4)
      Events:spawnUnit("blood_fiend", SPAWN_POINT_DESERT_1, 4)
      local particleName = "particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf"
      local jonuous = CreateUnitByName("experimenter_jonuous", Vector(4928,-3072), true, nil, nil, DOTA_TEAM_NEUTRALS)
      local ability = jonuous:AddAbility("replica")
      jonuous:FindAbilityByName("replica"):SetLevel(1)
      ability:ApplyDataDrivenModifier(jonuous, jonuous, "modifier_replica_shield", {duration = 99999})

       Timers:CreateTimer(0.5,
        function()     
          jonuous:MoveToPosition(Vector(4500, -3200))
        end)
      Timers:CreateTimer(3.5,
      function()
         StartAnimation(jonuous, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.0})
         jonuous:MoveToPosition(Vector(4500, -3220)) 
         local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, jonuous)
          ParticleManager:SetParticleControl(particle1,0,Vector(4500,-3500,jonuous:GetAbsOrigin().z))
          EmitGlobalSound("tinker_tink_ability_marchofthemachines_07")
          EmitGlobalSound("tinker_tink_ability_marchofthemachines_07")
          Events:spawnUnit("twisted_soldier", Vector(4500,-3500), 6)
          Events:spawnUnit("twisted_soldier", Vector(4500,-3500), 6)
          Timers:CreateTimer(300, 
            function()
            ParticleManager:DestroyParticle( particle1, false )
            end)
      end)

       Timers:CreateTimer(7.5,
        function()     
          jonuous:MoveToPosition(Vector(5500, -3200))
        end)
      Timers:CreateTimer(12,
      function()
         StartAnimation(jonuous, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.6})
         jonuous:MoveToPosition(Vector(5500, -3220))
         local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, jonuous)
          ParticleManager:SetParticleControl(particle2,0,Vector(5500,-3500,jonuous:GetAbsOrigin().z))
          EmitGlobalSound("tinker_tink_ability_rearm_03")
          EmitGlobalSound("tinker_tink_ability_rearm_03")
          Events:spawnUnit("twisted_soldier", Vector(5500,-3500), 6)
          Events:spawnUnit("twisted_soldier", Vector(5500,-3500), 6)
          Timers:CreateTimer(300, 
            function()
            ParticleManager:DestroyParticle( particle2, false )
            end)
      end)

       Timers:CreateTimer(13,
        function()     
          jonuous:MoveToPosition(Vector(5000, -1400))
        end)
      Timers:CreateTimer(22,
      function()
         StartAnimation(jonuous, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.6})
         jonuous:MoveToPosition(Vector(5000, -1420))
         local particle3 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, jonuous)
         EmitGlobalSound("tinker_tink_ability_rearm_09")
         EmitGlobalSound("tinker_tink_ability_rearm_09")
          ParticleManager:SetParticleControl(particle3,0,Vector(5000, -1600,jonuous:GetAbsOrigin().z))
          Events:spawnUnit("twisted_soldier", Vector(5000,-1600), 6)
          Events:spawnUnit("twisted_soldier", Vector(5000,-1600), 6)
          Timers:CreateTimer(300, 
            function()
            ParticleManager:DestroyParticle( particle3, false )
            end)
      end)

       Timers:CreateTimer(24,
        function()     
          jonuous:MoveToPosition(Vector(6000, -600))
        end)
      Timers:CreateTimer(35,
      function()
         StartAnimation(jonuous, {duration=2, activity=ACT_DOTA_CAST_ABILITY_3, rate=0.6})
         jonuous:MoveToPosition(Vector(6000, -620))
         local particle4 = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, jonuous)
          ParticleManager:SetParticleControl(particle4,0,Vector(6000, -900,jonuous:GetAbsOrigin().z))

          Events:spawnUnit("twisted_soldier", Vector(6000,-900), 6)
          Events:spawnUnit("twisted_soldier", Vector(6000,-900), 6)
          Timers:CreateTimer(300, 
            function()
            ParticleManager:DestroyParticle( particle4, false )
            end)
      end)

       Timers:CreateTimer(37,
        function()     
          jonuous:MoveToPosition(Vector(6000, -300))
        end)
      Timers:CreateTimer(38,
        function()
          UTIL_Remove(jonuous)
      end)


    print("wave34 spawned")
end

function Events:wave35()
      Events:spawnUnit("blood_fiend", SPAWN_POINT_DESERT_4, 4)
      Events:spawnUnit("blood_fiend", SPAWN_POINT_DESERT_1, 4)
      Events:spawnUnit("desert_warlord", SPAWN_POINT_DESERT_2, 4)
      Events:spawnUnit("desert_warlord", SPAWN_POINT_DESERT_3, 4)
      Events:spawnUnit("twisted_soldier", Vector(6000,-900), 5)
      Events:spawnUnit("twisted_soldier", Vector(5000,-1600), 5)
      Events:spawnUnit("twisted_soldier", Vector(5500,-3500), 5)
      Events:spawnUnit("twisted_soldier", Vector(4500,-3500), 5)
      Events:spawnUnit("experimental_minion", Vector(6000,-900), 5)
      Events:spawnUnit("experimental_minion", Vector(5000,-1600), 5)
      Events:spawnUnit("experimental_minion", Vector(5500,-3500), 5)
      Events:spawnUnit("experimental_minion", Vector(4500,-3500), 5)
end

function Events:wave36()
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_2, 4)
      Events:spawnUnit("mountain_destroyer", SPAWN_POINT_DESERT_3, 4)
      Events:spawnUnit("tortured_beast", Vector(6000,-900), 5)
      Events:spawnUnit("tortured_beast", Vector(5000,-1600), 5)
      Events:spawnUnit("tortured_beast", Vector(5500,-3500), 5)
      Events:spawnUnit("tortured_beast", Vector(4500,-3500), 5)
      Events:spawnUnit("experimental_minion", Vector(6000,-900), 5)
      Events:spawnUnit("experimental_minion", Vector(5000,-1600), 5)
      Events:spawnUnit("experimental_minion", Vector(5500,-3500), 5)
      Events:spawnUnit("experimental_minion", Vector(4500,-3500), 5)
end

function Events:wave37()
      Events:spawnUnit("twisted_soldier", Vector(6000,-900), 3)
      Events:spawnUnit("twisted_soldier", Vector(5000,-1600), 3)
      Events:spawnUnit("twisted_soldier", Vector(5500,-3500), 3)
      Events:spawnUnit("twisted_soldier", Vector(4500,-3500), 3)
      Events:spawnUnit("tortured_beast", Vector(6000,-900), 3)
      Events:spawnUnit("tortured_beast", Vector(5000,-1600), 3)
      Events:spawnUnit("tortured_beast", Vector(5500,-3500), 3)
      Events:spawnUnit("tortured_beast", Vector(4500,-3500), 3)
      Events:spawnUnit("experimental_minion", Vector(6000,-900), 3)
      Events:spawnUnit("experimental_minion", Vector(5000,-1600), 3)
      Events:spawnUnit("experimental_minion", Vector(5500,-3500), 3)
      Events:spawnUnit("experimental_minion", Vector(4500,-3500), 3)
      Events:spawnUnitSpecial("abomination", Vector(6000,-900), 3)
      Events:spawnUnitSpecial("abomination", Vector(5000,-1600), 3)
      Events:spawnUnitSpecial("abomination", Vector(5500,-3500), 3)
      Events:spawnUnitSpecial("abomination", Vector(4500,-3500), 3)
end

function Events:wave38()
    local jonuous = Events:SpawnBoss("experimenter_jonuous_boss", Vector(6000, -300))
    Events:AdjustBossPower(jonuous, 3, 5, true)
    local ability = jonuous:FindAbilityByName("jonuous_teleport")
    ability:StartCooldown(4)
      EmitGlobalSound("tinker_tink_respawn_13")
      EmitGlobalSound("tinker_tink_respawn_13")
      EmitGlobalSound("tinker_tink_respawn_13")
      EmitGlobalSound("tinker_tink_respawn_13")
      Events:prepare_boss_quest("#quest_desert_boss")
    print("wave38 spawned")
end

SPAWN_POINT_MINES_1 = Vector(3008,6656)
SPAWN_POINT_MINES_2 = Vector(1472,4416)
SPAWN_POINT_MINES_3 = Vector(7488,4736)
SPAWN_POINT_MINES_4 = Vector(5700,2750)
SPAWN_POINT_MINES_5 = Vector(3136,4608)

function Events:wave40()
      Events:prepare_wave_quest(125, "#quest_waves_9", 3, 40, 40, 45)
      local doom1 = CreateUnitByName("doomguard_a", SPAWN_POINT_MINES_1, true, nil, nil, DOTA_TEAM_NEUTRALS)
      local doom2 = CreateUnitByName("doomguard_b", SPAWN_POINT_MINES_1, true, nil, nil, DOTA_TEAM_NEUTRALS)
      local doom3 = CreateUnitByName("doomguard_c", SPAWN_POINT_MINES_1, true, nil, nil, DOTA_TEAM_NEUTRALS)
      Events:AdjustDeathXP(doom1)
      Events:AdjustDeathXP(doom2)
      Events:AdjustDeathXP(doom3)
      Events:DoomOrder(doom1, doom2, doom3)
      Events:DoomOrder(doom2, doom1, doom3)
      Events:DoomOrder(doom3, doom1, doom2)
    print("wave30 spawned")
end

function Events:DoomOrder(mainDoom, secondDoom, thirdDoom)
        local ability = mainDoom:FindAbilityByName("doomguard_bind")
        mainDoom.minDrops = 3
        mainDoom.maxDrops = 4

      local order =
      {
          UnitIndex = mainDoom:GetEntityIndex(),
          OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
          AbilityIndex = ability:GetEntityIndex(),
          TargetIndex = secondDoom:GetEntityIndex(),
          Queue = false
      }
    Timers:CreateTimer(2, 
    function()
      ExecuteOrderFromTable(order)
    end)
      local order_two =
      {
          UnitIndex = mainDoom:GetEntityIndex(),
          OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
          AbilityIndex = ability:GetEntityIndex(),
          TargetIndex = thirdDoom:GetEntityIndex(),
          Queue = false
      }
    Timers:CreateTimer(4, 
    function()
      ExecuteOrderFromTable(order_two)
    end)
end

function Events:wave41()
    Events:spawnUnit("basic_doomguard", SPAWN_POINT_MINES_1, 10)
    Events:spawnUnit("obsidian_golem", SPAWN_POINT_MINES_2, 4)
    Events:spawnUnit("basic_doomguard", SPAWN_POINT_MINES_3, 10)
    Events:spawnUnit("depth_demon", SPAWN_POINT_MINES_4, 10)
    Events:spawnUnit("depth_demon", SPAWN_POINT_MINES_5, 10)
end

function Events:wave42()
    Events:spawnUnit("arabor_cultist", SPAWN_POINT_MINES_1, 10)
    Events:spawnUnit("obsidian_golem", SPAWN_POINT_MINES_2, 4)
    Events:spawnUnit("arabor_cultist", SPAWN_POINT_MINES_3, 10)
    Events:spawnUnit("depth_demon", SPAWN_POINT_MINES_4, 10)
    Events:spawnUnit("depth_demon", SPAWN_POINT_MINES_5, 10)
end

function Events:wave43()
    Events:spawnUnit("arabor_cultist", SPAWN_POINT_MINES_1, 8)
    Events:spawnUnit("hell_hound", SPAWN_POINT_MINES_2, 10)
    Events:spawnUnit("basic_doomguard", SPAWN_POINT_MINES_3, 10)
    Events:spawnUnit("basic_doomguard", SPAWN_POINT_MINES_4, 10)
    Events:spawnUnit("hell_hound", SPAWN_POINT_MINES_5, 10)
end

function Events:wave44()
      Events:prepare_wave_quest(235, "#quest_waves_10", 40, 80, 55, 60)
      Events:spawnUnit("chaos_warrior", SPAWN_POINT_MINES_1, 12)
      Events:spawnUnit("chaos_warrior", SPAWN_POINT_MINES_2, 12)
      Events:spawnUnit("chaos_warrior", SPAWN_POINT_MINES_3, 12)
      Events:spawnUnit("depth_demon", SPAWN_POINT_MINES_4, 10)
    print("wave44 spawned")
end

function Events:wave45()
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_1, 10, "zombie_blue")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_2, 10, "zombie_blue")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_3, 10, "zombie_blue")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_4, 10, "zombie_red")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_5, 10, "zombie_red")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_1, 10, "zombie_red")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_2, 10, "zombie_green")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_3, 10, "zombie_green")
      Events:spawnZombie("mine_zombie", SPAWN_POINT_MINES_4, 10, "zombie_green")
    print("wave45 spawned")
end

function Events:wave46()
    Events:spawnUnit("hell_hound", SPAWN_POINT_MINES_1, 12)
    Events:spawnUnit("hell_hound", SPAWN_POINT_MINES_2, 12)
    Events:spawnUnit("hell_hound", SPAWN_POINT_MINES_3, 12)
    Events:spawnUnit("hell_hound", SPAWN_POINT_MINES_4, 12)
    Events:spawnUnit("crow_eater", SPAWN_POINT_MINES_5, 6)
    Events:spawnUnit("crow_eater", SPAWN_POINT_MINES_5, 6)
    print("wave46 spawned")
end

function Events:wave47()
    Events:spawnUnit("raging_shaman", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("raging_shaman", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("crow_eater", SPAWN_POINT_MINES_3, 3)
    Events:spawnUnit("crow_eater", SPAWN_POINT_MINES_4, 3)
    Events:spawnUnit("depth_demon", SPAWN_POINT_MINES_5, 4)
    Events:spawnUnit("chaos_warrior", SPAWN_POINT_MINES_1, 12)
    Events:spawnUnit("basic_doomguard", SPAWN_POINT_MINES_2, 10)
    Events:spawnUnit("hell_hound", SPAWN_POINT_MINES_3, 8)
    Events:spawnUnit("arabor_cultist", SPAWN_POINT_MINES_4, 8)
    Events:spawnUnit("obsidian_golem", SPAWN_POINT_MINES_5, 4)
    print("wave46 spawned")
end

function Events:wave48()
    Events:prepare_wave_quest(190, "#quest_waves_11", 25, 40, 75, 60)
    Events:spawnUnit("crawler", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("crafter", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("crawler", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("crafter", SPAWN_POINT_MINES_4, 6)
    Events:spawnUnit("nibohg", SPAWN_POINT_MINES_5, 6)
    print("wave48 spawned")
end

function Events:wave49()
    Events:spawnUnit("crafter", SPAWN_POINT_MINES_2, 2)
    Events:spawnUnit("crafter", SPAWN_POINT_MINES_4, 2)
    Events:spawnUnit("crow_eater", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("crow_eater", SPAWN_POINT_MINES_4, 6)
    Events:spawnUnit("satyr_behemoth", SPAWN_POINT_MINES_1, 4)
    Events:spawnUnit("satyr_behemoth", SPAWN_POINT_MINES_2, 4)
    Events:spawnUnit("satyr_behemoth", SPAWN_POINT_MINES_3, 4)
    Events:spawnUnit("firebat", SPAWN_POINT_MINES_4, 8)
    Events:spawnUnit("firebat", SPAWN_POINT_MINES_5, 8)
    print("wave49 spawned")
end

function Events:wave50()
  for i = 0, 3, 1 do
    Events:spawnUnit("dire_ranged", SPAWN_POINT_MINES_1, 2)
    Events:spawnUnit("dire_melee", SPAWN_POINT_MINES_1, 2)
    Events:spawnUnit("dire_ranged", SPAWN_POINT_MINES_2, 2)
    Events:spawnUnit("dire_melee", SPAWN_POINT_MINES_2, 2)
    Events:spawnUnit("dire_ranged", SPAWN_POINT_MINES_3, 2)
    Events:spawnUnit("dire_melee", SPAWN_POINT_MINES_3, 2)
    Events:spawnUnit("dire_ranged", SPAWN_POINT_MINES_4, 2)
    Events:spawnUnit("dire_melee", SPAWN_POINT_MINES_4, 2)
    Events:spawnUnit("dire_ranged", SPAWN_POINT_MINES_5, 2)
    Events:spawnUnit("dire_melee", SPAWN_POINT_MINES_5, 2)
  end
    print("wave50 spawned")
end

function Events:wave51()
    Events:spawnUnit("dire_ranged", SPAWN_POINT_MINES_1, 4)
    Events:spawnUnit("dire_melee", SPAWN_POINT_MINES_1, 4)
    Events:spawnUnit("satyr_behemoth", SPAWN_POINT_MINES_2, 4)
    Events:spawnUnit("satyr_behemoth", SPAWN_POINT_MINES_3, 4)
    Events:spawnUnit("firebat", SPAWN_POINT_MINES_4, 8)
    Events:spawnUnit("firebat", SPAWN_POINT_MINES_5, 8)
    Events:spawnUnit("crawler", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("crafter", SPAWN_POINT_MINES_2, 3)
    Events:spawnUnit("crawler", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("crafter", SPAWN_POINT_MINES_4, 3)
    Events:spawnUnit("nibohg", SPAWN_POINT_MINES_5, 4)
    Events:spawnUnit("raging_shaman", SPAWN_POINT_MINES_5, 8)
    Events:spawnUnit("obsidian_golem", SPAWN_POINT_MINES_2, 4)
    print("wave51 spawned")
end

function Events:wave52()
    Events:prepare_wave_quest(180, "#quest_waves_12", 40, 40, 42, 55)
    Events:spawnUnit("minion_of_twilight", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("soul_sucker", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("warden_of_death", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("minion_of_twilight", SPAWN_POINT_MINES_4, 6)
    Events:spawnUnit("warden_of_death", SPAWN_POINT_MINES_5, 6)

    Events:spawnUnit("minion_of_twilight", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("minion_of_twilight", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("minion_of_twilight", SPAWN_POINT_MINES_5, 6)
    print("wave52 spawned")
end

function Events:wave53()
    Events:spawnUnit("spectral_assassin", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("conjured_tide", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("shadow_hunter", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("minion_of_twilight", SPAWN_POINT_MINES_4, 6)
    Events:spawnUnit("shadow_hunter", SPAWN_POINT_MINES_5, 6)

    Events:spawnUnit("spectral_assassin", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("spectral_assassin", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("spectral_assassin", SPAWN_POINT_MINES_5, 6)
end

function Events:wave54()
    Events:spawnUnit("betrayer_of_time", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("betrayer_of_time", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("betrayer_of_time", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("betrayer_of_time", SPAWN_POINT_MINES_4, 6)
    Events:spawnUnit("betrayer_of_time", SPAWN_POINT_MINES_5, 6)

    Events:spawnUnit( "arabor_spellweaver", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit( "arabor_spellweaver", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit( "arabor_spellweaver", SPAWN_POINT_MINES_5, 6)
    Events:spawnUnit("crawler", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("crafter", SPAWN_POINT_MINES_4, 6)
end

function Events:wave55()
    Events:spawnUnit("minion_of_twilight", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("warden_of_death", SPAWN_POINT_MINES_2, 6)
    Events:spawnUnit("conjured_tide", SPAWN_POINT_MINES_3, 6)
    Events:spawnUnit("spectral_assassin", SPAWN_POINT_MINES_4, 6)
    Events:spawnUnit("shadow_hunter", SPAWN_POINT_MINES_5, 6)
    Events:spawnUnit("betrayer_of_time", SPAWN_POINT_MINES_1, 6)
    Events:spawnUnit("arabor_spellweaver", SPAWN_POINT_MINES_2, 6)
end

function Events:wave56()
    Events:MinesBossSummon()
    Events:prepare_boss_quest("#quest_mines_boss")
    print("wave38 spawned")
end

function Events:GetPlayerCount()
  local count = 0
  for playerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
      if PlayerResource:IsValidPlayerID(playerID) then
          count = count + 1
      end
  end
  return count
end

function Events:MinesBossSummon()
  AddFOWViewer(DOTA_TEAM_GOODGUYS, Vector(3036, 6720), 2000, 30, false)
  local dummy = CreateUnitByName("npc_dummy_unit", Vector(3036, 6720), true, nil, nil, DOTA_TEAM_NEUTRALS)
    dummy:NoHealthBar()
    dummy:AddAbility("dummy_unit")
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
  local gameMasterAbil = Events.GameMaster:FindAbilityByName("npc_abilities")
  for i = 1, #MAIN_HERO_TABLE, 1 do
    local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
    if playerID and MAIN_HERO_TABLE[i] then
      if gameMasterAbil then
        gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, MAIN_HERO_TABLE[i], "modifier_disable_player", {duration = 30})
      end
      -- MAIN_HERO_TABLE[i]:Stop()
      PlayerResource:SetCameraTarget(playerID, dummy)
    end
  end
  Timers:CreateTimer(0.5, function()
    EmitGlobalSound("deadmau5_01.stinger.respawn")
    EmitGlobalSound("deadmau5_01.stinger.respawn")
    EmitGlobalSound("deadmau5_01.stinger.respawn")
    EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
    EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
    EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
  end)
  local headPoint = Vector(3072, 7383, 400)
  local leftHandPoint = Vector(2717, 6690, 400)
  local rightHandPoint = Vector(3316, 6690, 400)
  local leftFootPoint = Vector(2917, 6300, 400)
  local rightFootPoint = Vector(3109, 6300, 400)
  local zapCountA = 2
  for i = 0, zapCountA, 1 do
    Timers:CreateTimer(i*0.8, function()
    Events:CreateLightningBeam(leftHandPoint, headPoint)
    Events:CreateLightningBeam(rightHandPoint, headPoint)
    end)
  end
  local zapCountB = 3
  for i = 0, zapCountB, 1 do
    Timers:CreateTimer(i*0.8+zapCountA*0.8, function()
    Events:CreateLightningBeam(leftHandPoint, headPoint)
    Events:CreateLightningBeam(rightHandPoint, headPoint)
    Events:CreateLightningBeam(leftHandPoint, rightHandPoint)
    end)
  end
  local zapCountC = 4
  for i = 0, zapCountC, 1 do
    Timers:CreateTimer(i*0.8+zapCountA*0.8+zapCountB*0.8, function()
    Events:CreateLightningBeam(leftHandPoint, headPoint)
    Events:CreateLightningBeam(rightHandPoint, headPoint)
    Events:CreateLightningBeam(leftHandPoint, rightHandPoint)
    Events:CreateLightningBeam(leftHandPoint, leftFootPoint)
    Events:CreateLightningBeam(rightHandPoint, rightFootPoint)
    end)
  end
  local zapCountD = 4
  for i = 0, zapCountD, 1 do
    Timers:CreateTimer(i*0.8+zapCountA*0.8+zapCountB*0.8+zapCountC*0.8, function()
    Events:CreateLightningBeam(leftHandPoint, headPoint)
    Events:CreateLightningBeam(rightHandPoint, headPoint)
    Events:CreateLightningBeam(leftHandPoint, rightHandPoint)
    Events:CreateLightningBeam(leftHandPoint, leftFootPoint)
    Events:CreateLightningBeam(rightHandPoint, rightFootPoint)
    Events:CreateLightningBeam(leftFootPoint, rightHandPoint)
    Events:CreateLightningBeam(rightFootPoint, leftHandPoint)
    Events:CreateLightningBeam(leftFootPoint, headPoint)
    Events:CreateLightningBeam(rightFootPoint, headPoint)
    end)
  end
  Timers:CreateTimer(0.8*zapCountA+0.8*zapCountB+0.8*zapCountC+0.8*zapCountD, function()
    EmitGlobalSound("Hero_Disruptor.ThunderStrike.Target")
    EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
    EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
    EmitGlobalSound("Hero_Disruptor.ThunderStrike.Cast")
    for i = 0, 12, 1 do
      local fv = Vector(1,0)
      local randomNegative = RandomInt(0,1)
      local mult = 1
      if randomNegative == 1 then
        mult = -1
      end
      local randomRadian = math.pi/RandomInt(7,50)*mult
      local rotatedFv = WallPhysics:rotateVector(fv, randomRadian)
      Events:CreateStaticOrb(rotatedFv, Events.GameMaster, gameMasterAbil, Vector(2717, 6690, 200))
    end
    for i = 0, 12, 1 do
      local fv = Vector(-1,0)
      local randomNegative = RandomInt(0,1)
      local mult = 1
      if randomNegative == 1 then
        mult = -1
      end
      local randomRadian = math.pi/RandomInt(7,50)*mult
      local rotatedFv = WallPhysics:rotateVector(fv, randomRadian)
      Events:CreateStaticOrb(rotatedFv, Events.GameMaster, gameMasterAbil, Vector(3316, 6690, 200))
    end
    Timers:CreateTimer(0.55, function()
      local razor = Events:SpawnBoss("mines_boss", Vector(3034, 6748))
      Events:AdjustBossPower(razor, 10, 5, true)
      razor:FindAbilityByName("mines_boss_dive"):StartCooldown(8)
      razor:FindAbilityByName("mines_boss_illusions"):StartCooldown(45)
      razor:FindAbilityByName("mines_boss_thunder_storm"):StartCooldown(15)
      local attachPoint = Vector(3034, 6748)
      EmitGlobalSound("razor_raz_respawn_01")
      EmitGlobalSound("razor_raz_respawn_01")
      EmitGlobalSound("razor_raz_respawn_01")
      EmitGlobalSound("razor_raz_respawn_01")
      EmitGlobalSound("razor_raz_respawn_01")
      local particleName = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
      local lightningBright = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, razor) 
      ParticleManager:SetParticleControl(lightningBright,0,Vector(attachPoint.x,attachPoint.y,attachPoint.z)) 
      ParticleManager:SetParticleControl(lightningBright,1,Vector(200, 0, 0))   
      ParticleManager:SetParticleControl(lightningBright,3,Vector(200, 0, 0))

      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBright, false)
        for i = 1, #MAIN_HERO_TABLE, 1 do
          local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
          if playerID then
            MAIN_HERO_TABLE[i]:RemoveModifierByName("modifier_disable_player")
            PlayerResource:SetCameraTarget(playerID, MAIN_HERO_TABLE[i])
          end
        end
        Timers:CreateTimer(1, function()
          for i = 1, #MAIN_HERO_TABLE, 1 do
            local playerID = MAIN_HERO_TABLE[i]:GetPlayerID()
            if playerID then
              PlayerResource:SetCameraTarget(playerID, nil)
            end
          end
        end)
      end)
    end)
  end)



end

function Events:CreateLightningBeam(attachPointA, attachPointB)
      local particleName = "particles/items_fx/chain_lightning.vpcf"
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
      ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z))   
      ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z))
      Timers:CreateTimer(2, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
        ParticleManager:ReleaseParticleIndex(lightningBolt)
      end)
end

function Events:CreateLightningBeamWithParticle(attachPointA, attachPointB, particleName, destroyTime)
      local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
      ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z))   
      ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z))
      Timers:CreateTimer(destroyTime, function()
        ParticleManager:DestroyParticle(lightningBolt, false)
        ParticleManager:ReleaseParticleIndex(lightningBolt)
      end)
end

function Events:CreateStaticOrb(fv, caster, ability, originPoint)
  local projectileParticle = "particles/econ/items/zeus/lightning_weapon_fx/voltex_ultimmortal_lightning.vpcf"
  local projectileOrigin = originPoint + Vector(0,0,300) + fv*10
  local start_radius = 140
  local end_radius = 140
  local range = 600
  local speed = 400 + RandomInt(0, 250)
    local info = 
    {
        Ability = ability,
            EffectName = projectileParticle,
            vSpawnOrigin = projectileOrigin+Vector(0,0,60),
            fDistance = range,
            fStartRadius = start_radius,
            fEndRadius = end_radius,
            Source = caster,
            StartPosition = "attach_attack1",
            bHasFrontalCone = true,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 4.0,
      bDeleteOnHit = false,
      vVelocity = fv * speed,
      bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end



function Events:spawnZombie(unitName, spawnPoint, quantity, type)
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*3, 
    function()
      local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
      local ability = unit:FindAbilityByName("zombie_colors")
      ability:ApplyDataDrivenModifier(unit, unit, type, {duration = 99999})
    end)
  end
end

function Events:spawnUnitSpecial(unitName, spawnPoint, quantity)
  for i = 0, quantity-1, 1 do
    Timers:CreateTimer(i*5, 
    function()
    local unit = CreateUnitByName(unitName, spawnPoint, true, nil, nil, DOTA_TEAM_NEUTRALS)
      if unitName == "abomination" then
        local ability = unit:FindAbilityByName("abom_electricity")
        ability:SetLevel(3)
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_electric_abom", {duration = 99999})
      elseif unitName == "shroomling_big" then
        unit.minDrops = 2
        unit.maxDrops = 3
      elseif unitName == "rare_ghost_minion" then
        local ability = unit:FindAbilityByName("npc_abilities")
        ability:SetLevel(1)
        local ghostBlast = unit:FindAbilityByName("ghost_blast")
        ghostBlast:SetLevel(1)
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_rare_ghost_minion_thinker", {})
      elseif unitName == "rare_ghost" then
        unit.minDrops = 2
        unit.maxDrops = 3
        local ability = unit:FindAbilityByName("npc_abilities")
        ability:SetLevel(1)
        local ghostBlast = unit:FindAbilityByName("ghost_blast")
        ghostBlast:SetLevel(2)
        ability:ApplyDataDrivenModifier(unit, unit, "modifier_rare_ghost_thinker", {})     
      end
    end)
  end
end

function Events:adjustStats()
  for i = 1, #MAIN_HERO_TABLE, 1 do

    --AGI
    local hero = MAIN_HERO_TABLE[i]
    local agility = hero:GetAgility()
    local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
    ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_attack_speed_reduce", {})
    local attackSpeedReduction = ((agility-20)/25)*24
    if attackSpeedReduction > 1 then
      hero:SetModifierStackCount("modifier_attack_speed_reduce", Events.GameMaster, attackSpeedReduction)
    end
    if hero:GetAgility() <= 21 then
      hero:RemoveModifierByName("modifier_attack_speed_reduce")
    end
    --INT
    -- local intelligence = hero:GetIntellect()
    -- local ability = Events.GameMaster:FindAbilityByName("npc_abilities")
    
    -- local manaReduction = math.ceil(hero:GetIntellect()*7) - 560
    -- if manaReduction > 0 then
    --   ability:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_mana_reduce", {duration = 1000})
    --   hero:SetModifierStackCount("modifier_mana_reduce", Events.GameMaster, manaReduction)
    -- else
    --   hero:RemoveModifierByName("modifier_mana_reduce")
    -- end
  end
end

function Events:DisableAndImmuneUnit(unit, duration)
  local gameMasterAbil = Events:GetGameMasterAbility()
  gameMasterAbil:ApplyDataDrivenModifier(Events.GameMaster, unit, "modifier_disable_player", {duration = duration})
end

function Events:SoftFloat(floatDuration, liftduration, speed, unit)
  Events:DisableAndImmuneUnit(unit, liftduration+floatDuration+liftduration)
  local loopCount = math.floor(liftduration/0.03)
  for i = 1, loopCount, 1 do
    local liftVelocity = 0
    Timers:CreateTimer(i*0.03, function()
      liftVelocity = speed*i
      unit:SetAbsOrigin(unit:GetAbsOrigin()+Vector(0,0,liftVelocity))
    end)
  end 
  Timers:CreateTimer(liftduration + floatDuration, function()
    for i = 1, loopCount, 1 do
      local liftVelocity = 0
      Timers:CreateTimer(i*0.03, function()
        liftVelocity = speed*i
        unit:SetAbsOrigin(unit:GetAbsOrigin()-Vector(0,0,liftVelocity))
      end)
    end
  end)
end

function Events:PVPVote(msg)
  PVP:VoteSubmit(msg)
end

function Events:PVPBuild(msg)
  PVP:BuildUnit(msg)
end

function Events:ColorWearablesAndBase(unit, color)
  unit:SetRenderColor(color[1], color[2], color[3])
  for k, v in pairs(unit:GetChildren()) do 
    if v:GetClassname() == "dota_item_wearable" then
      local model = v:GetModelName()
      v:SetRenderColor(color[1], color[2], color[3])
    end 
  end 
end

function Events:ColorWearables(unit, color)
  for k, v in pairs(unit:GetChildren()) do 
    if v:GetClassname() == "dota_item_wearable" then
      local model = v:GetModelName()
      v:SetRenderColor(color[1], color[2], color[3])
    end 
  end 
end

function Events:SetPositionCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
  unit.targetRadius = radius
  unit.minRadius = minRadius
  unit.targetAbilityCD = cooldown
  unit.targetFindOrder = targetFindOrder
end

function Events:SetTargetCastArgs(unit, radius, minRadius, cooldown, targetFindOrder)
  unit.targetRadius = radius
  unit.minRadius = minRadius
  unit.targetAbilityCD = cooldown
  unit.targetFindOrder = targetFindOrder
end

function Events:SpecialDebug()
  if Events.DebugStone then
    UTIL_Remove(Events.DebugStone)
    Events.DebugStone = false
  end
  local positionTable = {Vector(-10752, -14720), Vector(-7445, -12153), Vector(-9543, -8506), Vector(-820, -6181), Vector(-8064, -4352)}
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
    
    local stone = Redfall:SpawnDungeonUnit("redfall_ancient_tree", position, 3, 5, "Redfall.AncientTree.Aggro", Vector(0,-1), false)
    stone:SetRenderColor(255, 170, 170)
    Events:ColorWearables(stone, Vector(255, 170, 170))
    Events.DebugStone = stone
    stone:SetModelScale(0.05)
    stone.summonCount = 0
    local stoneAbility = stone:FindAbilityByName("ancient_tree_passive")
    stoneAbility:ApplyDataDrivenModifier(stone, stone, "modifier_ancient_tree_cinematic", {duration = 6.5})
    for i = 1, 120, 1 do
      Timers:CreateTimer(i*0.03, function()
        stone:SetModelScale(0.05+i*0.02)
      end)
    end
    stone.itemLevel = 200
    Events:AdjustBossPower(stone, 10, 10, true)
    Timers:CreateTimer(0.05, function()
      StartAnimation(stone, {duration=6, activity=ACT_DOTA_TELEPORT, rate=0.5})
    end)
    for j = 0, 3, 1 do
      Timers:CreateTimer(j*0.8, function()
        local particleName = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
        local pfxB = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, stone)
        ParticleManager:SetParticleControl(pfxB, 0, stone:GetAbsOrigin()+Vector(0,0,50))
        ParticleManager:SetParticleControl(pfxB, 1, Vector(300+j*100, 1, 2))
        ScreenShake(stone:GetAbsOrigin(), 130, 0.9, 0.9, 9000, 0, true)
        Timers:CreateTimer(2.8, function()
          ParticleManager:DestroyParticle(pfxB, false)
        end)
      end)
    end

    Timers:CreateTimer(1, function()
      EmitSoundOn("Redfall.AncientTree.Spawn.VO", stone)
    end)
  end)
end

function Events:CreateCollectionBeam(attachPointA, attachPointB)
    local particleName = "particles/items_fx/mithril_collect.vpcf"
    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, Events.GameMaster) 
    ParticleManager:SetParticleControl(lightningBolt,0,Vector(attachPointA.x,attachPointA.y,attachPointA.z))   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(attachPointB.x,attachPointB.y,attachPointB.z))
    Timers:CreateTimer(2, function()
      ParticleManager:DestroyParticle(lightningBolt, false)
    end)
end

function Events:SerengaardVote(msg)
  Serengaard:Vote(msg)
end

function Events:smoothColorTransition(object, startColor, endColor, ticks)
  local colorChangeVector = (endColor-startColor)/ticks
  for i = 0, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      object:SetRenderColor(startColor.x + colorChangeVector.x * i, startColor.y + colorChangeVector.y * i, startColor.z + colorChangeVector.z * i)
    end)
  end
end

function Events:smoothSizeChange(object, startSize, endSize, ticks)
  local growth = (endSize-startSize)/ticks
  for i = 0, ticks, 1 do
    Timers:CreateTimer(i*0.03, function()
      object:SetModelScale(startSize + growth*i)
    end)
  end
end

function Events:objectShake(object, ticks, strength, bX, bY, bZ, sound, soundInterval)
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
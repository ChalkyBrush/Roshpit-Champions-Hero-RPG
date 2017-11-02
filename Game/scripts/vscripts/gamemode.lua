-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end
if Events == nil then
  Events = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
-- require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
-- require('libraries/projectiles')
require('libraries/notifications')
require('libraries/animations')
require('libraries/attachments')
require('libraries/attributes')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
require('internal/popups')
require('internal/os')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')
require( 'ai_core' )
require( 'items')
require( 'precache')
require( 'custom_abilities')
require( 'challenges')
require( 'stars')
require( 'custom_attributes')




--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
  if GameState:IsWorld1() then
    Timers:CreateTimer(3, function()
      local unitTable = {"dark_fighter", "icy_venge", "sorc_water_elemental", "time_walker", "rabid_walker", "npc_dota_creature_basic_zombie_exploding", "gargoyle", "hook_flinger", "human_rifleman", "blood_jumper", "mekanoid_disruptor", "epoch_summon", "furion_brute", "freeze_fiend", "the_butcher", "forest_broodmother", "spiderling", "spiderling2", "rare_ghost", "rolling_earth_spirit", "little_meepo", "furion_mystic", "twitch_lone_druid", "doomguard_a", "doomguard_b", "doomguard_c", "obsidian_golem", "depth_demon", "arabor_cultist", "exploding_warrior", "forest_boss", "rockjaw", "wastelands_archer", "desert_ghost", "goremaw_brute", "goremaw_shaman", "bone_horror", "wandering_mage", "scarab", "skittering_beetle", "satyr_doctor", "hammersaur", "alpha_wolf", "general_wolfenstein", "wolf_ally", "mountain_destroyer", "desert_warlord", "blood_fiend", "dune_crasher", "experimenter_jonuous", "twisted_soldier", "experimental_minion", "tortured_beast", "abomination", "hell_hound", "chaos_warrior", "raging_shaman", "crawler", "crafter", "nibohg", "satyr_behemoth", "firebat", "dire_ranged", "dire_melee", "minion_of_twilight", "spectral_assassin", "shadow_hunter", "betrayer_of_time", "arabor_spellweaver", "mines_boss"}
      for i = 1, #unitTable, 1 do
        Timers:CreateTimer(i*0, 
        function()
          print("precaching: "..unitTable[i])
          PrecacheUnitByNameAsync(unitTable[i], function(...) end)      
          end)
      end
    end)
  else
    Timers:CreateTimer(3, function()
        local unitTable = {"dark_fighter", "icy_venge", "sorc_water_elemental", "time_walker", "rabid_walker", "npc_dota_creature_basic_zombie_exploding", "gargoyle", "hook_flinger", "human_rifleman", "blood_jumper", "mekanoid_disruptor", "epoch_summon", "furion_brute", "freeze_fiend", "the_butcher", "forest_broodmother", "spiderling", "spiderling2", "rare_ghost", "rolling_earth_spirit", "little_meepo", "furion_mystic", "twitch_lone_druid"}
        for i = 1, #unitTable, 1 do
          Timers:CreateTimer(i*0, 
          function()
            print("precaching: "..unitTable[i])
            PrecacheUnitByNameAsync(unitTable[i], function(...) end)      
            end)
        end
      end)
    end
  Timers:CreateTimer(1, function()
    Precache:items()
  end)
  if GameState:IsWorld1() then
    Timers:CreateTimer(8, function()
      Precache:townSiege()
    end)
    Timers:CreateTimer(10, function()
      Precache:graveYard()
    end)
    Timers:CreateTimer(20, function()
      Precache:loggingCamp()
    end)
    Timers:CreateTimer(30, function()
      Precache:grizzlyFalls()
    end)
    Timers:CreateTimer(70, function()
      Precache:sandTomb()
    end)
    Timers:CreateTimer(45, function()
      Precache:desertRuins()
    end)
    Timers:CreateTimer(120, function()
      Precache:vault()
    end)
    Timers:CreateTimer(160, function()
      Precache:swamp()
    end)
    Timers:CreateTimer(4, function()
      Precache:phoenixNest()
    end)
    Timers:CreateTimer(200, function()
      Precache:castle()
    end)
  end
  if GameState:IsTanariJungle() then
    Precache:tanari()
    Timers:CreateTimer(1, function()
      Precache:champions_walk()
    end)
    Timers:CreateTimer(10, function()
      Precache:boulderspine_cavern()
    end)
    Timers:CreateTimer(15, function()
      Precache:wildwood_thicket()
    end)
    Timers:CreateTimer(8.4, function()
      Precache:water_temple()
    end)
    Timers:CreateTimer(18, function()
      Precache:fire_temple()
    end)

    Timers:CreateTimer(5, function()
      Precache:tanari_crater()
    end)
    Timers:CreateTimer(3, function()
        Precache:tanariExpansion()
    end)
  end
  if GameState:IsRPCArena() then
    Timers:CreateTimer(1, function()
      Precache:arena()
    end)
    Timers:CreateTimer(2, function()
      Precache:champions_league()
    end)
    Timers:CreateTimer(15, function()
      Precache:pit_of_trials()
    end)
  end
  if GameState:IsRedfallRidge() then
    Precache:redfall()
    Timers:CreateTimer(10, function()
      Precache:autumnmist_cavern()
    end)
    Timers:CreateTimer(5, function()
      Precache:redfall_farmlands()
    end)
    Timers:CreateTimer(12, function()
      Precache:abandoned_shipyard()
    end)
    Timers:CreateTimer(7, function()
       Precache:crimsyth_castle()
    end)
  end
  if GameState:IsSerengaard() then
    Precache:serengaard()
  end
  if GameState:IsPVPAlpha() then
    Precache:pvp()
  end
  if GameState:IsSeaFortress() then
    Precache:SeaFortress()
  end
  if GameState:IsWinterblight() then
    Precache:Winterblight()
  end
end

function superPrecache()
  local unitTable = {"crow_eater"}
  for i = 1, #unitTable, 1 do
    Timers:CreateTimer(i*2, 
    function()
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameAsync(unitTable[i], function(...) end)      
      end)
  end
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("First Player has loaded")

end

function GameMode:PlayerConnect(msg)
  print(msg)
  if DIFFICULTY_FACTOR then
    CustomGameEventManager:Send_ServerToAllClients("update_selected_difficulty", {difficulty = DIFFICULTY_FACTOR} )
  end
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
  CustomNetTables:SetTableValue("player_stats", "diff", {difficulty = DIFFICULTY_FACTOR} )
  Events.MapName = GetMapName()
  Events.DifficultyFactor = GameState:SetDifficultyFactor()
  Events.WaveNumber = 0
  Dungeons.itemLevel = 0
  Events.HEROKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
  Events:InitGameEntities()
  print("ALL PLAYERS LOADED")
  CustomGameEventManager:Send_ServerToAllClients("update_selected_difficulty", {difficulty = DIFFICULTY_FACTOR} )
  CustomNetTables:SetTableValue("hero_index", "taken_heroes", {} )
  Events:SpawnGamemaster(Vector(0,0))
  if GameState:IsWorld1() then
    -- Events:initializeTown()
    Timers:CreateTimer(1, function()
      Challenges:InitializeChallenges()
    end)
  elseif GameState:IsTanariJungle() then
    require('worlds/tanari')
    -- Timers:CreateTimer(5, function()
    --   Tanari:InitCamp()
    -- end)
  elseif GameState:IsRPCArena() then
    require('worlds/arena/arena')
    -- Timers:CreateTimer(3, function()
    --   Arena:Init()    
    -- end)
  elseif GameState:IsRedfallRidge() then
    require('worlds/redfall/redfall')
    -- Timers:CreateTimer(5, function()
    --   Redfall:InitCamp()
    -- end)
  elseif GameState:IsPVPAlpha() then
    require('worlds/pvp/pvp_alpha')
    -- Timers:CreateTimer(5, function()
    --   PVP:InitGame()
    -- end)
  elseif GameState:IsSerengaard() then
    require('worlds/serengaard/serengaard')
  elseif GameState:IsSeaFortress() then
    require('worlds/sea_fortress/seafortress')
  elseif GameState:IsWinterblight() then
    require('worlds/winterblight/winterblight')
  end
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(0, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  --local item = CreateItem("item_example_item", hero, hero)
  --hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  Events:beginQuests()
  Timers:CreateTimer(90, 
    function()
      --Events:championChance()
      RPCItems:ClearItems()
      return 90 
    end)
  Timers:CreateTimer(5, 
    function()
        Events:adjustStats()
      return 0.3
    end)
  
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  LinkLuaModifier("modifier_movespeed_cap", "modifiers/modifier_movespeed_cap", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_movespeed_cap_super", "modifiers/modifier_movespeed_cap_super", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_movespeed_cap_glyph", "modifiers/modifier_movespeed_cap_glyph", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_movespeed_cap_sonic", "modifiers/modifier_movespeed_cap_sonic", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_movespeed_cap_heat_wave", "modifiers/modifier_movespeed_cap_heat_wave", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_vermillion_dream_lua", "modifiers/modifier_vermillion_dream_lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_hood_of_lords_lua", "modifiers/modifier_hood_of_lords_lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_trapper_immo3_effect", "modifiers/trapper/modifier_trapper_immo3_effect", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_black_portal_shrink", "modifiers/modifier_black_portal_shrink", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier( "modifier_rpc_attributes", "modifiers/modifier_rpc_attributes.lua", LUA_MODIFIER_MOTION_NONE )
  


  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end
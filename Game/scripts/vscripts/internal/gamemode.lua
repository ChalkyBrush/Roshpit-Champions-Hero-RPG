-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later

DOTA_ULTIMATE_SLOT = 5

function GameMode:SetTeamData(playersPerTeam)
  local custom_team_player_count = {}
  custom_team_player_count[DOTA_TEAM_GOODGUYS] = playersPerTeam
  custom_team_player_count[DOTA_TEAM_BADGUYS]  = playersPerTeam
  custom_team_player_count[DOTA_TEAM_CUSTOM_1] = 0
  custom_team_player_count[DOTA_TEAM_CUSTOM_2] = 0
  custom_team_player_count[DOTA_TEAM_CUSTOM_3] = 0
  custom_team_player_count[DOTA_TEAM_CUSTOM_4] = 0
  custom_team_player_count[DOTA_TEAM_CUSTOM_5] = 0
  custom_team_player_count[DOTA_TEAM_CUSTOM_6] = 0
  custom_team_player_count[DOTA_TEAM_CUSTOM_7] = 0
  custom_team_player_count[DOTA_TEAM_CUSTOM_8] = 0

  local count = 0
  for team,number in pairs(custom_team_player_count) do
    if count >= 2 then
      GameRules:SetCustomGameTeamMaxPlayers(team, 0)
    else
      GameRules:SetCustomGameTeamMaxPlayers(team, number)
    end
    count = count + 1
  end
end

function GameMode:_InitGameMode()
  -- Setup rules
  print("init game mode")
  GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
  GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
  GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
  GameRules:SetHeroSelectionTime( 5 )
  GameRules:EnableCustomGameSetupAutoLaunch(true)
  if GameState:IsPVPAlphaEarlyCheck() then
    if GameState:NoOracleEarlyCheck() then
      GameRules:SetPreGameTime( 5 )
    else
      GameRules:SetPreGameTime( 20 )
    end
  elseif GameState:IsSerengaardEarlyCheck() then
    GameRules:SetPreGameTime( 0)
  else
    GameRules:SetPreGameTime( 20)
  end
  GameRules:SetPostGameTime( POST_GAME_TIME )
  GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
 GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
  GameRules:SetGoldPerTick(GOLD_PER_TICK)
  GameRules:SetGoldTickTime(GOLD_TICK_TIME)
  GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
  GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
  GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
  GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
  GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )

  GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
  GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )
  GameRules:SetUseUniversalShopMode(false)


  -- This is multiteam configuration stuff
  if USE_AUTOMATIC_PLAYERS_PER_TEAM then
    local num = math.floor(10 / MAX_NUMBER_OF_TEAMS)
    local count = 0
    for team,number in pairs(TEAM_COLORS) do
      if count >= MAX_NUMBER_OF_TEAMS then
        GameRules:SetCustomGameTeamMaxPlayers(team, 0)
      else
        GameRules:SetCustomGameTeamMaxPlayers(team, num)
      end
      count = count + 1
    end
  else
    print(GameState:IsPVPAlpha())
    if GameState:IsPVPAlphaEarlyCheck() then
      if GameState:IsPVPAlpha3v3EarlyCheck() then
        GameMode:SetTeamData(3)
      elseif GameState:IsPVPAlpha1v1EarlyCheck() then
        GameMode:SetTeamData(1)
      end
    else
      local count = 0
      if GameState:IsSeaEarlyCheck() then
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 5
      end
      for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
        if count >= MAX_NUMBER_OF_TEAMS then
          GameRules:SetCustomGameTeamMaxPlayers(team, 0)
        else
          GameRules:SetCustomGameTeamMaxPlayers(team, number)
        end
        count = count + 1
      end
    end
  end

  --if USE_CUSTOM_TEAM_COLORS then
  --  for team,color in pairs(TEAM_COLORS) do
  --    SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
  --  end
  --end
  DebugPrint('[BAREBONES] GameRules set')

  --InitLogFile( "log/barebones.txt","")

  -- Event Hooks
  -- All of these events can potentially be fired by the game, though only the uncommented ones have had
  -- Functions supplied for them.  If you are interested in the other events, you can uncomment the
  -- ListenToGameEvent line and add a function to handle the event
  ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
  ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
  ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
  ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
  ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
  ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
  ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
  ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
  ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
  ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
  ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
  ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
  ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
  ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
  ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)

  ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(GameMode, 'OnIllusionsCreated'), self)
  ListenToGameEvent("dota_item_combined", Dynamic_Wrap(GameMode, 'OnItemCombined'), self)
  ListenToGameEvent("dota_player_begin_cast", Dynamic_Wrap(GameMode, 'OnAbilityCastBegins'), self)
  ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'OnTowerKill'), self)
  ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(GameMode, 'OnPlayerSelectedCustomTeam'), self)
  ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(GameMode, 'OnNPCGoalReached'), self)

  CustomGameEventManager:RegisterListener( "level_up_ability", Dynamic_Wrap(Events, "LevelUpAbility"))
  CustomGameEventManager:RegisterListener( "level_up_rune", Dynamic_Wrap(Events, "LevelUpRune"))
  CustomGameEventManager:RegisterListener( "change_rune_state", Dynamic_Wrap(Events, "ChangeRuneState"))
  
  CustomGameEventManager:RegisterListener( "DungeonsvoteYesJS", Dynamic_Wrap(Dungeons, "voteYesLua"))
  CustomGameEventManager:RegisterListener( "DungeonsvoteNoJS", Dynamic_Wrap(Dungeons, "voteNoLua"))

  CustomGameEventManager:RegisterListener( "accept_item", Dynamic_Wrap(RPCItems, "AcceptNewItem"))
  CustomGameEventManager:RegisterListener( "reject_item", Dynamic_Wrap(RPCItems, "RejectNewItem"))
  CustomGameEventManager:RegisterListener( "buy_item", Dynamic_Wrap(RPCItems, "BuyItem"))

  CustomGameEventManager:RegisterListener( "weapon_upgrade", Dynamic_Wrap(Weapons, "WeaponUpgrade"))

  CustomGameEventManager:RegisterListener( "recalculate_stats", Dynamic_Wrap(RPCItems, "RecalculateStats"))

  CustomGameEventManager:RegisterListener( "vote_roll", Dynamic_Wrap(RPCItems, "ItemVote"))


  CustomGameEventManager:RegisterListener( "save_menu", Dynamic_Wrap(SaveLoad, "GetPlayerCharacters"))
  CustomGameEventManager:RegisterListener( "save_slot", Dynamic_Wrap(SaveLoad, "SaveCharacter"))
  CustomGameEventManager:RegisterListener( "load_from_slot", Dynamic_Wrap(SaveLoad, "LoadCharacter"))
  CustomGameEventManager:RegisterListener( "stash_open", Dynamic_Wrap(SaveLoad, "StashOpen"))
  CustomGameEventManager:RegisterListener( "item_dragged_to_stash", Dynamic_Wrap(SaveLoad, "DraggedToStash"))
  CustomGameEventManager:RegisterListener( "item_dragged_from_stash_to_inventory", Dynamic_Wrap(SaveLoad, "DraggedFromStash"))

  CustomGameEventManager:RegisterListener( "keybank_open", Dynamic_Wrap(SaveLoad, "OpenKeyBank"))
  CustomGameEventManager:RegisterListener( "keybank_deposit", Dynamic_Wrap(SaveLoad, "DepositKey"))
  CustomGameEventManager:RegisterListener( "keybank_withdraw", Dynamic_Wrap(SaveLoad, "WithdrawKey"))

  CustomGameEventManager:RegisterListener( "ruins_button_press", Dynamic_Wrap(Dungeons, "RuinsButtonPress"))

  CustomGameEventManager:RegisterListener( "client_crusader", Dynamic_Wrap(Quests, "ReceiveQuestmenuStatusFromClient"))
  CustomGameEventManager:RegisterListener( "delete_quest", Dynamic_Wrap(Quests, "DeleteQuest"))

  CustomGameEventManager:RegisterListener( "flash_heal", Dynamic_Wrap(CustomAbilities, "UpdateAuriunCursorPosition"))

  CustomGameEventManager:RegisterListener( "tradeRequest", Dynamic_Wrap(RPCItems, "InitiateTrade"))
  CustomGameEventManager:RegisterListener( "cancel_trade", Dynamic_Wrap(RPCItems, "CancelTrade"))
  CustomGameEventManager:RegisterListener( "item_placed_in_trade", Dynamic_Wrap(RPCItems, "ItemPlaceInTrade"))
  CustomGameEventManager:RegisterListener( "item_removed_from_trade", Dynamic_Wrap(RPCItems, "ItemRemoveFromTrade"))
  CustomGameEventManager:RegisterListener( "update_trade_lock", Dynamic_Wrap(RPCItems, "UpdateLock"))

  CustomGameEventManager:RegisterListener( "glyph_in_slot", Dynamic_Wrap(Glyphs, "PlaceGlyphInSlot"))
  CustomGameEventManager:RegisterListener( "upgrade_arcane_tier", Dynamic_Wrap(Glyphs, "UpgradeArcaneTier"))
  CustomGameEventManager:RegisterListener( "glyph_purchase", Dynamic_Wrap(Glyphs, "GlyphPurchase"))
  CustomGameEventManager:RegisterListener( "purchase_reanimation_stone", Dynamic_Wrap(Glyphs, "ReanimationPurchase"))
  CustomGameEventManager:RegisterListener( "get_glyph_availability", Dynamic_Wrap(Glyphs, "GetGlyphAvailability"))

  CustomGameEventManager:RegisterListener( "collect_mithril_income", Dynamic_Wrap(Challenges, "CollectMithrilIncome"))
  CustomGameEventManager:RegisterListener( "clicked_chisel_gear", Dynamic_Wrap(Challenges, "ChiselableGearClicked"))
  CustomGameEventManager:RegisterListener( "final_chisel", Dynamic_Wrap(Challenges, "ChiselItem"))

  CustomGameEventManager:RegisterListener( "drag_into_reroll_slot", Dynamic_Wrap(Challenges, "DragIntoRerollSlot"))
  CustomGameEventManager:RegisterListener( "return_reroll", Dynamic_Wrap(Challenges, "ReturnReroll"))
  CustomGameEventManager:RegisterListener( "final_reroll", Dynamic_Wrap(Challenges, "FinalReroll"))

  CustomGameEventManager:RegisterListener( "drag_item_to_tanari_doctor_slot", Dynamic_Wrap(Quests, "SpiritItemPlace"))
  CustomGameEventManager:RegisterListener( "close_witch_doctor", Dynamic_Wrap(Quests, "CloseWitchDoctor"))
  CustomGameEventManager:RegisterListener( "final_tanari_combine", Dynamic_Wrap(Quests, "WitchDoctorCombine"))
  
  CustomGameEventManager:RegisterListener( "town_portal", Dynamic_Wrap(Quests, "TownPortal"))
   CustomGameEventManager:RegisterListener("respawn_flag", Dynamic_Wrap(Quests, "RespawnFlag"))

  CustomGameEventManager:RegisterListener( "arena_dialogue", Dynamic_Wrap(Quests, "ArenaDialogue"))
  
  CustomGameEventManager:RegisterListener( "npc_dialogue", Dynamic_Wrap(Quests, "NPCDialogue"))

  CustomGameEventManager:RegisterListener( "quest_log", Dynamic_Wrap(Quests, "QuestLog"))
  CustomGameEventManager:RegisterListener( "quest_log_complete", Dynamic_Wrap(Quests, "QuestLogComplete"))

  CustomGameEventManager:RegisterListener( "item_drag_from_backpack", Dynamic_Wrap(GameState, "ItemDragFromBackpack"))

  CustomGameEventManager:RegisterListener( "pvp_vote", Dynamic_Wrap(Events, "PVPVote"))
  CustomGameEventManager:RegisterListener( "pvp_build", Dynamic_Wrap(Events, "PVPBuild"))

  CustomGameEventManager:RegisterListener( "serengaard_vote", Dynamic_Wrap(Events, "SerengaardVote"))

  CustomGameEventManager:RegisterListener( "hero_selection_event", Dynamic_Wrap(SaveLoad, "HeroSelectOption"))
  CustomGameEventManager:RegisterListener( "processed_key", Dynamic_Wrap(SaveLoad, "ProcessedKey"))


  CustomGameEventManager:RegisterListener( "stars_menu", Dynamic_Wrap(Stars, "ActivateStarsMenu"))

  CustomGameEventManager:RegisterListener( "difficulty_select", Dynamic_Wrap(GameState, "DifficultySelect"))

  CustomGameEventManager:RegisterListener( "curate", Dynamic_Wrap(Curator, "Curate"))
  CustomGameEventManager:RegisterListener( "curator_client", Dynamic_Wrap(Curator, "FinishGettingClientData"))
  CustomGameEventManager:RegisterListener( "curateHero", Dynamic_Wrap(Curator, "ClientDataHero"))
  CustomGameEventManager:RegisterListener( "curateAbility", Dynamic_Wrap(Curator, "ClientDataAbility"))
  CustomGameEventManager:RegisterListener( "curateGlyph", Dynamic_Wrap(Curator, "ClientDataGlyph"))
  CustomGameEventManager:RegisterListener( "stop_unit", Dynamic_Wrap(Curator, "StopUnit"))

  CustomGameEventManager:RegisterListener("stats_hover", Dynamic_Wrap(CustomAttributes, "ActivateStatsTooltip"))
  
  CustomGameEventManager:RegisterListener( "drag_item_to_synthesis_slot", Dynamic_Wrap(RPCItems, "SynthesisItemPlaced"))
  CustomGameEventManager:RegisterListener( "synth_combine_items", Dynamic_Wrap(RPCItems, "CombineItems"))
  CustomGameEventManager:RegisterListener( "close_altar", Dynamic_Wrap(Quests, "CloseAltarOfIce"))
  CustomGameEventManager:RegisterListener( "ice_crystal_placed", Dynamic_Wrap(Quests, "PlaceIceCrystal"))

  -- GameMode:SetTrackingProjectileFilter( Dynamic_Wrap( Attacks, "FilterProjectile" ), self )
  --ListenToGameEvent("dota_tutorial_shop_toggled", Dynamic_Wrap(GameMode, 'OnShopToggled'), self)

  --ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
  --ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
  --ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
  --ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
  --ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
  --ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
  --ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
  --ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)

  --[[This block is only used for testing events handling in the event that Valve adds more in the future
  Convars:RegisterCommand('events_test', function()
      GameMode:StartEventTest()
    end, "events test", 0)]]

  local spew = 0
  if BAREBONES_DEBUG_SPEW then
    spew = 1
  end
  -- Convars:RegisterConvar('barebones_spew', tostring(spew), 'Set to 1 to start spewing barebones debug info.  Set to 0 to disable.', 0)

  -- Change random seed
  -- local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  -- math.randomseed(tonumber(timeTxt))

  -- Initialized tables for tracking state
  self.bSeenWaitForPlayers = false

  

  DebugPrint('[BAREBONES] Done loading Roshpit gamemode!\n\n')
  SendToServerConsole("dota_wait_for_players_to_load_timeout 240")
  SendToServerConsole("sv_timeout 60")
  SendToServerConsole("sv_timeout_when_fully_connected 60")
  SendToServerConsole("sv_timeout_when_fully_connected_tournament 60")
    SendToServerConsole("dota_surrender_on_disconnect 0")
    SendToServerConsole("dota_auto_surrender_all_disconnected_timeout 10000")
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:_CaptureGameMode()
  if mode == nil then
    -- Set GameMode parameters
    mode = GameRules:GetGameModeEntity()        
    mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
    mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
    mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
    mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    mode:SetBuybackEnabled( BUYBACK_ENABLED )
    --mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
    --mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
    mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
    mode:SetCustomHeroMaxLevel ( MAX_LEVEL )

    mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

    mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
    mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

    mode:SetFogOfWarDisabled(false)
    mode:SetUnseenFogOfWarEnabled(true)
    mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
    mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

    mode:SetAlwaysShowPlayerInventory( SHOW_ONLY_PLAYER_INVENTORY )
    mode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
    if FORCE_PICKED_HERO ~= nil then
      mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
    end
    mode:SetCustomGameForceHero("npc_dota_hero_wisp")
    mode:SetFixedRespawnTime( FIXED_RESPAWN_TIME ) 
    mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
    mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
    mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
    mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
    mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )
    mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
    mode:SetStashPurchasingDisabled ( DISABLE_STASH_PURCHASING )

    mode:SetDamageFilter( Dynamic_Wrap( GameState, "FilterDamage" ), self )
    mode:SetExecuteOrderFilter( Dynamic_Wrap( GameState, "OrderFilter" ), self )
    mode:SetModifyGoldFilter( Dynamic_Wrap( GameState, "GoldEarnFilter" ), self )
    for rune, spawn in pairs(ENABLED_RUNES) do
      mode:SetRuneEnabled(rune, spawn)
    end

    self:OnFirstPlayerLoaded()
  end 
end
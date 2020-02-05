function GameMode:StartEventTest()
	ListenToGameEvent("team_info", Dynamic_Wrap(GameMode, 'On_team_info'), self)
	ListenToGameEvent("team_score", Dynamic_Wrap(GameMode, 'On_team_score'), self)
	ListenToGameEvent("teamplay_broadcast_audio", Dynamic_Wrap(GameMode, 'On_teamplay_broadcast_audio'), self)
	ListenToGameEvent("player_team", Dynamic_Wrap(GameMode, 'On_player_team'), self)
	ListenToGameEvent("player_class", Dynamic_Wrap(GameMode, 'On_player_class'), self)
	ListenToGameEvent("player_death", Dynamic_Wrap(GameMode, 'On_player_death '), self)
	ListenToGameEvent("player_hurt", Dynamic_Wrap(GameMode, 'On_player_hurt '), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'On_player_chat '), self)
	ListenToGameEvent("player_score", Dynamic_Wrap(GameMode, 'On_player_score'), self)
	ListenToGameEvent("player_spawn", Dynamic_Wrap(GameMode, 'On_player_spawn'), self)
	ListenToGameEvent("player_shoot", Dynamic_Wrap(GameMode, 'On_player_shoot'), self)
	ListenToGameEvent("player_use", Dynamic_Wrap(GameMode, 'On_player_use'), self)
	ListenToGameEvent("player_changename", Dynamic_Wrap(GameMode, 'On_player_changename'), self)
	ListenToGameEvent("player_hintmessage", Dynamic_Wrap(GameMode, 'On_player_hintmessage'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'On_player_reconnected '), self)
	ListenToGameEvent("game_init", Dynamic_Wrap(GameMode, 'On_game_init'), self)
	ListenToGameEvent("game_newmap", Dynamic_Wrap(GameMode, 'On_game_newmap'), self)
	ListenToGameEvent("game_start", Dynamic_Wrap(GameMode, 'On_game_start'), self)
	ListenToGameEvent("game_end", Dynamic_Wrap(GameMode, 'On_game_end'), self)
	ListenToGameEvent("round_start", Dynamic_Wrap(GameMode, 'On_round_start'), self)
	ListenToGameEvent("round_end", Dynamic_Wrap(GameMode, 'On_round_end'), self)
	ListenToGameEvent("round_start_pre_entity", Dynamic_Wrap(GameMode, 'On_round_start_pre_entity'), self)
	ListenToGameEvent("teamplay_round_start", Dynamic_Wrap(GameMode, 'On_teamplay_round_start'), self)
	ListenToGameEvent("hostname_changed", Dynamic_Wrap(GameMode, 'On_hostname_changed'), self)
	ListenToGameEvent("difficulty_changed", Dynamic_Wrap(GameMode, 'On_difficulty_changed'), self)
	ListenToGameEvent("finale_start", Dynamic_Wrap(GameMode, 'On_finale_start'), self)
	ListenToGameEvent("game_message", Dynamic_Wrap(GameMode, 'On_game_message'), self)
	ListenToGameEvent("break_breakable", Dynamic_Wrap(GameMode, 'On_break_breakable'), self)
	ListenToGameEvent("break_prop", Dynamic_Wrap(GameMode, 'On_break_prop'), self)
	--ListenToGameEvent("npc_spawned", Dynamic_Wrap(GameMode, 'On_npc_spawned'), self)
	ListenToGameEvent("npc_replaced", Dynamic_Wrap(GameMode, 'On_npc_replaced'), self)
	--ListenToGameEvent("entity_killed", Dynamic_Wrap(GameMode, 'On_entity_killed'), self)
	--ListenToGameEvent("entity_hurt", Dynamic_Wrap(GameMode, 'On_entity_hurt'), self)
	ListenToGameEvent("bonus_updated", Dynamic_Wrap(GameMode, 'On_bonus_updated'), self)
	ListenToGameEvent("player_stats_updated", Dynamic_Wrap(GameMode, 'On_player_stats_updated'), self)
	ListenToGameEvent("achievement_event", Dynamic_Wrap(GameMode, 'On_achievement_event'), self)
	ListenToGameEvent("achievement_earned", Dynamic_Wrap(GameMode, 'On_achievement_earned'), self)
	ListenToGameEvent("achievement_write_failed", Dynamic_Wrap(GameMode, 'On_achievement_write_failed'), self)
	ListenToGameEvent("physgun_pickup", Dynamic_Wrap(GameMode, 'On_physgun_pickup'), self)
	ListenToGameEvent("flare_ignite_npc", Dynamic_Wrap(GameMode, 'On_flare_ignite_npc'), self)
	ListenToGameEvent("helicopter_grenade_punt_miss", Dynamic_Wrap(GameMode, 'On_helicopter_grenade_punt_miss'), self)
	ListenToGameEvent("user_data_downloaded", Dynamic_Wrap(GameMode, 'On_user_data_downloaded'), self)
	ListenToGameEvent("ragdoll_dissolved", Dynamic_Wrap(GameMode, 'On_ragdoll_dissolved'), self)
	ListenToGameEvent("gameinstructor_draw", Dynamic_Wrap(GameMode, 'On_gameinstructor_draw'), self)
	ListenToGameEvent("gameinstructor_nodraw", Dynamic_Wrap(GameMode, 'On_gameinstructor_nodraw'), self)
	ListenToGameEvent("map_transition", Dynamic_Wrap(GameMode, 'On_map_transition'), self)
	ListenToGameEvent("instructor_server_hint_create", Dynamic_Wrap(GameMode, 'On_instructor_server_hint_create'), self)
	ListenToGameEvent("instructor_server_hint_stop", Dynamic_Wrap(GameMode, 'On_instructor_server_hint_stop'), self)
	ListenToGameEvent("chat_new_message", Dynamic_Wrap(GameMode, 'On_chat_new_message'), self)
	ListenToGameEvent("chat_members_changed", Dynamic_Wrap(GameMode, 'On_chat_members_changed'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GameMode, 'On_game_rules_state_change'), self)
	ListenToGameEvent("inventory_updated", Dynamic_Wrap(GameMode, 'On_inventory_updated'), self)
	ListenToGameEvent("cart_updated", Dynamic_Wrap(GameMode, 'On_cart_updated'), self)
	ListenToGameEvent("store_pricesheet_updated", Dynamic_Wrap(GameMode, 'On_store_pricesheet_updated'), self)
	ListenToGameEvent("gc_connected", Dynamic_Wrap(GameMode, 'On_gc_connected'), self)
	ListenToGameEvent("item_schema_initialized", Dynamic_Wrap(GameMode, 'On_item_schema_initialized'), self)
	ListenToGameEvent("drop_rate_modified", Dynamic_Wrap(GameMode, 'On_drop_rate_modified'), self)
	ListenToGameEvent("event_ticket_modified", Dynamic_Wrap(GameMode, 'On_event_ticket_modified'), self)
	ListenToGameEvent("modifier_event", Dynamic_Wrap(GameMode, 'On_modifier_event'), self)
	ListenToGameEvent("dota_player_kill", Dynamic_Wrap(GameMode, 'On_dota_player_kill'), self)
	ListenToGameEvent("dota_player_deny", Dynamic_Wrap(GameMode, 'On_dota_player_deny'), self)
	ListenToGameEvent("dota_barracks_kill", Dynamic_Wrap(GameMode, 'On_dota_barracks_kill'), self)
	ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'On_dota_tower_kill'), self)
	ListenToGameEvent("dota_roshan_kill", Dynamic_Wrap(GameMode, 'On_dota_roshan_kill'), self)
	ListenToGameEvent("dota_courier_lost", Dynamic_Wrap(GameMode, 'On_dota_courier_lost'), self)
	ListenToGameEvent("dota_courier_respawned", Dynamic_Wrap(GameMode, 'On_dota_courier_respawned'), self)
	ListenToGameEvent("dota_glyph_used", Dynamic_Wrap(GameMode, 'On_dota_glyph_used'), self)
	ListenToGameEvent("dota_super_creeps", Dynamic_Wrap(GameMode, 'On_dota_super_creeps'), self)
	ListenToGameEvent("dota_item_purchase", Dynamic_Wrap(GameMode, 'On_dota_item_purchase'), self)
	ListenToGameEvent("dota_item_gifted", Dynamic_Wrap(GameMode, 'On_dota_item_gifted'), self)
	ListenToGameEvent("dota_rune_pickup", Dynamic_Wrap(GameMode, 'On_dota_rune_pickup'), self)
	ListenToGameEvent("dota_rune_spotted", Dynamic_Wrap(GameMode, 'On_dota_rune_spotted'), self)
	ListenToGameEvent("dota_item_spotted", Dynamic_Wrap(GameMode, 'On_dota_item_spotted'), self)
	ListenToGameEvent("dota_no_battle_points", Dynamic_Wrap(GameMode, 'On_dota_no_battle_points'), self)
	ListenToGameEvent("dota_chat_informational", Dynamic_Wrap(GameMode, 'On_dota_chat_informational'), self)
	ListenToGameEvent("dota_action_item", Dynamic_Wrap(GameMode, 'On_dota_action_item'), self)
	ListenToGameEvent("dota_chat_ban_notification", Dynamic_Wrap(GameMode, 'On_dota_chat_ban_notification'), self)
	ListenToGameEvent("dota_chat_event", Dynamic_Wrap(GameMode, 'On_dota_chat_event'), self)
	ListenToGameEvent("dota_chat_timed_reward", Dynamic_Wrap(GameMode, 'On_dota_chat_timed_reward'), self)
	ListenToGameEvent("dota_pause_event", Dynamic_Wrap(GameMode, 'On_dota_pause_event'), self)
	ListenToGameEvent("dota_chat_kill_streak", Dynamic_Wrap(GameMode, 'On_dota_chat_kill_streak'), self)
	ListenToGameEvent("dota_chat_first_blood", Dynamic_Wrap(GameMode, 'On_dota_chat_first_blood'), self)
	ListenToGameEvent("dota_player_update_hero_selection", Dynamic_Wrap(GameMode, 'On_dota_player_update_hero_selection'), self)
	ListenToGameEvent("dota_player_update_selected_unit", Dynamic_Wrap(GameMode, 'On_dota_player_update_selected_unit'), self)
	ListenToGameEvent("dota_player_update_query_unit", Dynamic_Wrap(GameMode, 'On_dota_player_update_query_unit'), self)
	ListenToGameEvent("dota_player_update_killcam_unit", Dynamic_Wrap(GameMode, 'On_dota_player_update_killcam_unit'), self)
	ListenToGameEvent("dota_player_take_tower_damage", Dynamic_Wrap(GameMode, 'On_dota_player_take_tower_damage'), self)
	ListenToGameEvent("dota_hud_error_message", Dynamic_Wrap(GameMode, 'On_dota_hud_error_message'), self)
	ListenToGameEvent("dota_action_success", Dynamic_Wrap(GameMode, 'On_dota_action_success'), self)
	ListenToGameEvent("dota_starting_position_changed", Dynamic_Wrap(GameMode, 'On_dota_starting_position_changed'), self)
	ListenToGameEvent("dota_money_changed", Dynamic_Wrap(GameMode, 'On_dota_money_changed'), self)
	ListenToGameEvent("dota_enemy_money_changed", Dynamic_Wrap(GameMode, 'On_dota_enemy_money_changed'), self)
	ListenToGameEvent("dota_portrait_unit_stats_changed", Dynamic_Wrap(GameMode, 'On_dota_portrait_unit_stats_changed'), self)
	ListenToGameEvent("dota_portrait_unit_modifiers_changed", Dynamic_Wrap(GameMode, 'On_dota_portrait_unit_modifiers_changed'), self)
	ListenToGameEvent("dota_force_portrait_update", Dynamic_Wrap(GameMode, 'On_dota_force_portrait_update'), self)
	ListenToGameEvent("dota_inventory_changed", Dynamic_Wrap(GameMode, 'On_dota_inventory_changed'), self)
	ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(GameMode, 'On_dota_item_picked_up'), self)
	ListenToGameEvent("dota_inventory_item_changed", Dynamic_Wrap(GameMode, 'On_dota_inventory_item_changed'), self)
	ListenToGameEvent("dota_ability_changed", Dynamic_Wrap(GameMode, 'On_dota_ability_changed'), self)
	ListenToGameEvent("dota_portrait_ability_layout_changed", Dynamic_Wrap(GameMode, 'On_dota_portrait_ability_layout_changed'), self)
	ListenToGameEvent("dota_inventory_item_added", Dynamic_Wrap(GameMode, 'On_dota_inventory_item_added'), self)
	ListenToGameEvent("dota_inventory_changed_query_unit", Dynamic_Wrap(GameMode, 'On_dota_inventory_changed_query_unit'), self)
	ListenToGameEvent("dota_link_clicked", Dynamic_Wrap(GameMode, 'On_dota_link_clicked'), self)
	ListenToGameEvent("dota_set_quick_buy", Dynamic_Wrap(GameMode, 'On_dota_set_quick_buy'), self)
	ListenToGameEvent("dota_quick_buy_changed", Dynamic_Wrap(GameMode, 'On_dota_quick_buy_changed'), self)
	ListenToGameEvent("dota_player_shop_changed", Dynamic_Wrap(GameMode, 'On_dota_player_shop_changed'), self)
	ListenToGameEvent("dota_player_show_killcam", Dynamic_Wrap(GameMode, 'On_dota_player_show_killcam'), self)
	ListenToGameEvent("dota_player_show_minikillcam", Dynamic_Wrap(GameMode, 'On_dota_player_show_minikillcam'), self)
	ListenToGameEvent("gc_user_session_created", Dynamic_Wrap(GameMode, 'On_gc_user_session_created'), self)
	ListenToGameEvent("team_data_updated", Dynamic_Wrap(GameMode, 'On_team_data_updated'), self)
	ListenToGameEvent("guild_data_updated", Dynamic_Wrap(GameMode, 'On_guild_data_updated'), self)
	ListenToGameEvent("guild_open_parties_updated", Dynamic_Wrap(GameMode, 'On_guild_open_parties_updated'), self)
	ListenToGameEvent("fantasy_updated", Dynamic_Wrap(GameMode, 'On_fantasy_updated'), self)
	ListenToGameEvent("fantasy_league_changed", Dynamic_Wrap(GameMode, 'On_fantasy_league_changed'), self)
	ListenToGameEvent("fantasy_score_info_changed", Dynamic_Wrap(GameMode, 'On_fantasy_score_info_changed'), self)
	ListenToGameEvent("player_info_updated", Dynamic_Wrap(GameMode, 'On_player_info_updated'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GameMode, 'On_game_rules_state_change'), self)
	ListenToGameEvent("match_history_updated", Dynamic_Wrap(GameMode, 'On_match_history_updated'), self)
	ListenToGameEvent("match_details_updated", Dynamic_Wrap(GameMode, 'On_match_details_updated'), self)
	ListenToGameEvent("live_games_updated", Dynamic_Wrap(GameMode, 'On_live_games_updated'), self)
	ListenToGameEvent("recent_matches_updated", Dynamic_Wrap(GameMode, 'On_recent_matches_updated'), self)
	ListenToGameEvent("news_updated", Dynamic_Wrap(GameMode, 'On_news_updated'), self)
	ListenToGameEvent("persona_updated", Dynamic_Wrap(GameMode, 'On_persona_updated'), self)
	ListenToGameEvent("tournament_state_updated", Dynamic_Wrap(GameMode, 'On_tournament_state_updated'), self)
	ListenToGameEvent("party_updated", Dynamic_Wrap(GameMode, 'On_party_updated'), self)
	ListenToGameEvent("lobby_updated", Dynamic_Wrap(GameMode, 'On_lobby_updated'), self)
	ListenToGameEvent("dashboard_caches_cleared", Dynamic_Wrap(GameMode, 'On_dashboard_caches_cleared'), self)
	ListenToGameEvent("last_hit", Dynamic_Wrap(GameMode, 'On_last_hit'), self)
	ListenToGameEvent("player_completed_game", Dynamic_Wrap(GameMode, 'On_player_completed_game'), self)
	--ListenToGameEvent("dota_combatlog", Dynamic_Wrap(GameMode, 'On_dota_combatlog'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'On_player_reconnected'), self)
	ListenToGameEvent("nommed_tree", Dynamic_Wrap(GameMode, 'On_nommed_tree'), self)
	ListenToGameEvent("dota_rune_activated_server", Dynamic_Wrap(GameMode, 'On_dota_rune_activated_server'), self)
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(GameMode, 'On_dota_player_gained_level'), self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(GameMode, 'On_dota_player_pick_hero'), self)
	ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(GameMode, 'On_dota_player_learned_ability'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(GameMode, 'On_dota_player_used_ability'), self)
	ListenToGameEvent("dota_non_player_used_ability", Dynamic_Wrap(GameMode, 'On_dota_non_player_used_ability'), self)
	ListenToGameEvent("dota_ability_channel_finished", Dynamic_Wrap(GameMode, 'On_dota_ability_channel_finished'), self)
	ListenToGameEvent("dota_holdout_revive_complete", Dynamic_Wrap(GameMode, 'On_dota_holdout_revive_complete'), self)
	ListenToGameEvent("dota_player_killed", Dynamic_Wrap(GameMode, 'On_dota_player_killed'), self)
	ListenToGameEvent("bindpanel_open", Dynamic_Wrap(GameMode, 'On_bindpanel_open'), self)
	ListenToGameEvent("bindpanel_close", Dynamic_Wrap(GameMode, 'On_bindpanel_close'), self)
	ListenToGameEvent("keybind_changed", Dynamic_Wrap(GameMode, 'On_keybind_changed'), self)
	ListenToGameEvent("dota_item_drag_begin", Dynamic_Wrap(GameMode, 'On_dota_item_drag_begin'), self)
	ListenToGameEvent("dota_item_drag_end", Dynamic_Wrap(GameMode, 'On_dota_item_drag_end'), self)
	ListenToGameEvent("dota_shop_item_drag_begin", Dynamic_Wrap(GameMode, 'On_dota_shop_item_drag_begin'), self)
	ListenToGameEvent("dota_shop_item_drag_end", Dynamic_Wrap(GameMode, 'On_dota_shop_item_drag_end'), self)
	ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(GameMode, 'On_dota_item_purchased'), self)
	ListenToGameEvent("dota_item_used", Dynamic_Wrap(GameMode, 'On_dota_item_used'), self)
	ListenToGameEvent("dota_item_auto_purchase", Dynamic_Wrap(GameMode, 'On_dota_item_auto_purchase'), self)
	ListenToGameEvent("dota_unit_event", Dynamic_Wrap(GameMode, 'On_dota_unit_event'), self)
	ListenToGameEvent("dota_quest_started", Dynamic_Wrap(GameMode, 'On_dota_quest_started'), self)
	ListenToGameEvent("dota_quest_completed", Dynamic_Wrap(GameMode, 'On_dota_quest_completed'), self)
	ListenToGameEvent("gameui_activated", Dynamic_Wrap(GameMode, 'On_gameui_activated'), self)
	ListenToGameEvent("gameui_hidden", Dynamic_Wrap(GameMode, 'On_gameui_hidden'), self)
	ListenToGameEvent("player_fullyjoined", Dynamic_Wrap(GameMode, 'On_player_fullyjoined'), self)
	ListenToGameEvent("dota_spectate_hero", Dynamic_Wrap(GameMode, 'On_dota_spectate_hero'), self)
	ListenToGameEvent("dota_match_done", Dynamic_Wrap(GameMode, 'On_dota_match_done'), self)
	ListenToGameEvent("dota_match_done_client", Dynamic_Wrap(GameMode, 'On_dota_match_done_client'), self)
	ListenToGameEvent("set_instructor_group_enabled", Dynamic_Wrap(GameMode, 'On_set_instructor_group_enabled'), self)
	ListenToGameEvent("joined_chat_channel", Dynamic_Wrap(GameMode, 'On_joined_chat_channel'), self)
	ListenToGameEvent("left_chat_channel", Dynamic_Wrap(GameMode, 'On_left_chat_channel'), self)
	ListenToGameEvent("gc_chat_channel_list_updated", Dynamic_Wrap(GameMode, 'On_gc_chat_channel_list_updated'), self)
	ListenToGameEvent("today_messages_updated", Dynamic_Wrap(GameMode, 'On_today_messages_updated'), self)
	ListenToGameEvent("file_downloaded", Dynamic_Wrap(GameMode, 'On_file_downloaded'), self)
	ListenToGameEvent("player_report_counts_updated", Dynamic_Wrap(GameMode, 'On_player_report_counts_updated'), self)
	ListenToGameEvent("scaleform_file_download_complete", Dynamic_Wrap(GameMode, 'On_scaleform_file_download_complete'), self)
	ListenToGameEvent("item_purchased", Dynamic_Wrap(GameMode, 'On_item_purchased'), self)
	ListenToGameEvent("gc_mismatched_version", Dynamic_Wrap(GameMode, 'On_gc_mismatched_version'), self)
	ListenToGameEvent("demo_skip", Dynamic_Wrap(GameMode, 'On_demo_skip'), self)
	ListenToGameEvent("demo_start", Dynamic_Wrap(GameMode, 'On_demo_start'), self)
	ListenToGameEvent("demo_stop", Dynamic_Wrap(GameMode, 'On_demo_stop'), self)
	ListenToGameEvent("map_shutdown", Dynamic_Wrap(GameMode, 'On_map_shutdown'), self)
	ListenToGameEvent("dota_workshop_fileselected", Dynamic_Wrap(GameMode, 'On_dota_workshop_fileselected'), self)
	ListenToGameEvent("dota_workshop_filecanceled", Dynamic_Wrap(GameMode, 'On_dota_workshop_filecanceled'), self)
	ListenToGameEvent("rich_presence_updated", Dynamic_Wrap(GameMode, 'On_rich_presence_updated'), self)
	ListenToGameEvent("dota_hero_random", Dynamic_Wrap(GameMode, 'On_dota_hero_random'), self)
	ListenToGameEvent("dota_rd_chat_turn", Dynamic_Wrap(GameMode, 'On_dota_rd_chat_turn'), self)
	ListenToGameEvent("dota_favorite_heroes_updated", Dynamic_Wrap(GameMode, 'On_dota_favorite_heroes_updated'), self)
	ListenToGameEvent("profile_closed", Dynamic_Wrap(GameMode, 'On_profile_closed'), self)
	ListenToGameEvent("item_preview_closed", Dynamic_Wrap(GameMode, 'On_item_preview_closed'), self)
	ListenToGameEvent("dashboard_switched_section", Dynamic_Wrap(GameMode, 'On_dashboard_switched_section'), self)
	ListenToGameEvent("dota_tournament_item_event", Dynamic_Wrap(GameMode, 'On_dota_tournament_item_event'), self)
	ListenToGameEvent("dota_hero_swap", Dynamic_Wrap(GameMode, 'On_dota_hero_swap'), self)
	ListenToGameEvent("dota_reset_suggested_items", Dynamic_Wrap(GameMode, 'On_dota_reset_suggested_items'), self)
	ListenToGameEvent("halloween_high_score_received", Dynamic_Wrap(GameMode, 'On_halloween_high_score_received'), self)
	ListenToGameEvent("halloween_phase_end", Dynamic_Wrap(GameMode, 'On_halloween_phase_end'), self)
	ListenToGameEvent("halloween_high_score_request_failed", Dynamic_Wrap(GameMode, 'On_halloween_high_score_request_failed'), self)
	ListenToGameEvent("dota_hud_skin_changed", Dynamic_Wrap(GameMode, 'On_dota_hud_skin_changed'), self)
	ListenToGameEvent("dota_inventory_player_got_item", Dynamic_Wrap(GameMode, 'On_dota_inventory_player_got_item'), self)
	ListenToGameEvent("player_is_experienced", Dynamic_Wrap(GameMode, 'On_player_is_experienced'), self)
	ListenToGameEvent("player_is_notexperienced", Dynamic_Wrap(GameMode, 'On_player_is_notexperienced'), self)
	ListenToGameEvent("dota_tutorial_lesson_start", Dynamic_Wrap(GameMode, 'On_dota_tutorial_lesson_start'), self)
	ListenToGameEvent("map_location_updated", Dynamic_Wrap(GameMode, 'On_map_location_updated'), self)
	ListenToGameEvent("richpresence_custom_updated", Dynamic_Wrap(GameMode, 'On_richpresence_custom_updated'), self)
	ListenToGameEvent("game_end_visible", Dynamic_Wrap(GameMode, 'On_game_end_visible'), self)
	ListenToGameEvent("antiaddiction_update", Dynamic_Wrap(GameMode, 'On_antiaddiction_update'), self)
	ListenToGameEvent("highlight_hud_element", Dynamic_Wrap(GameMode, 'On_highlight_hud_element'), self)
	ListenToGameEvent("hide_highlight_hud_element", Dynamic_Wrap(GameMode, 'On_hide_highlight_hud_element'), self)
	ListenToGameEvent("intro_video_finished", Dynamic_Wrap(GameMode, 'On_intro_video_finished'), self)
	ListenToGameEvent("matchmaking_status_visibility_changed", Dynamic_Wrap(GameMode, 'On_matchmaking_status_visibility_changed'), self)
	ListenToGameEvent("practice_lobby_visibility_changed", Dynamic_Wrap(GameMode, 'On_practice_lobby_visibility_changed'), self)
	ListenToGameEvent("dota_courier_transfer_item", Dynamic_Wrap(GameMode, 'On_dota_courier_transfer_item'), self)
	ListenToGameEvent("full_ui_unlocked", Dynamic_Wrap(GameMode, 'On_full_ui_unlocked'), self)
	ListenToGameEvent("client_connectionless_packet", Dynamic_Wrap(GameMode, 'On_client_connectionless_packet'), self)
	ListenToGameEvent("hero_selector_preview_set", Dynamic_Wrap(GameMode, 'On_hero_selector_preview_set'), self)
	ListenToGameEvent("antiaddiction_toast", Dynamic_Wrap(GameMode, 'On_antiaddiction_toast'), self)
	ListenToGameEvent("hero_picker_shown", Dynamic_Wrap(GameMode, 'On_hero_picker_shown'), self)
	ListenToGameEvent("hero_picker_hidden", Dynamic_Wrap(GameMode, 'On_hero_picker_hidden'), self)
	ListenToGameEvent("dota_local_quickbuy_changed", Dynamic_Wrap(GameMode, 'On_dota_local_quickbuy_changed'), self)
	ListenToGameEvent("show_center_message", Dynamic_Wrap(GameMode, 'On_show_center_message'), self)
	ListenToGameEvent("hud_flip_changed", Dynamic_Wrap(GameMode, 'On_hud_flip_changed'), self)
	ListenToGameEvent("frosty_points_updated", Dynamic_Wrap(GameMode, 'On_frosty_points_updated'), self)
	ListenToGameEvent("defeated", Dynamic_Wrap(GameMode, 'On_defeated'), self)
	ListenToGameEvent("reset_defeated", Dynamic_Wrap(GameMode, 'On_reset_defeated'), self)
	ListenToGameEvent("booster_state_updated", Dynamic_Wrap(GameMode, 'On_booster_state_updated'), self)
	ListenToGameEvent("event_points_updated", Dynamic_Wrap(GameMode, 'On_event_points_updated'), self)
	ListenToGameEvent("local_player_event_points", Dynamic_Wrap(GameMode, 'On_local_player_event_points'), self)
	ListenToGameEvent("custom_game_difficulty", Dynamic_Wrap(GameMode, 'On_custom_game_difficulty'), self)
	ListenToGameEvent("tree_cut", Dynamic_Wrap(GameMode, 'On_tree_cut'), self)
	ListenToGameEvent("ugc_details_arrived", Dynamic_Wrap(GameMode, 'On_ugc_details_arrived'), self)
	ListenToGameEvent("ugc_subscribed", Dynamic_Wrap(GameMode, 'On_ugc_subscribed'), self)
	ListenToGameEvent("ugc_unsubscribed", Dynamic_Wrap(GameMode, 'On_ugc_unsubscribed'), self)
	ListenToGameEvent("prizepool_received", Dynamic_Wrap(GameMode, 'On_prizepool_received'), self)
	ListenToGameEvent("microtransaction_success", Dynamic_Wrap(GameMode, 'On_microtransaction_success'), self)
	ListenToGameEvent("dota_rubick_ability_steal", Dynamic_Wrap(GameMode, 'On_dota_rubick_ability_steal'), self)
	ListenToGameEvent("compendium_event_actions_loaded", Dynamic_Wrap(GameMode, 'On_compendium_event_actions_loaded'), self)
	ListenToGameEvent("compendium_selections_loaded", Dynamic_Wrap(GameMode, 'On_compendium_selections_loaded'), self)
	ListenToGameEvent("compendium_set_selection_failed", Dynamic_Wrap(GameMode, 'On_compendium_set_selection_failed'), self)
	ListenToGameEvent("community_cached_names_updated", Dynamic_Wrap(GameMode, 'On_community_cached_names_updated'), self)
	ListenToGameEvent("dota_team_kill_credit", Dynamic_Wrap(GameMode, 'On_dota_team_kill_credit'), self)

	ListenToGameEvent("dota_effigy_kill", Dynamic_Wrap(GameMode, 'On_dota_effigy_kill'), self)
	ListenToGameEvent("dota_chat_assassin_announce", Dynamic_Wrap(GameMode, 'On_dota_chat_assassin_announce'), self)
	ListenToGameEvent("dota_chat_assassin_denied", Dynamic_Wrap(GameMode, 'On_dota_chat_assassin_denied'), self)
	ListenToGameEvent("dota_chat_assassin_success", Dynamic_Wrap(GameMode, 'On_dota_chat_assassin_success'), self)
	ListenToGameEvent("player_info_individual_updated", Dynamic_Wrap(GameMode, 'On_player_info_individual_updated'), self)
	ListenToGameEvent("dota_player_begin_cast", Dynamic_Wrap(GameMode, 'On_dota_player_begin_cast'), self)
	ListenToGameEvent("dota_non_player_begin_cast", Dynamic_Wrap(GameMode, 'On_dota_non_player_begin_cast'), self)
	ListenToGameEvent("dota_item_combined", Dynamic_Wrap(GameMode, 'On_dota_item_combined'), self)
	ListenToGameEvent("profile_opened", Dynamic_Wrap(GameMode, 'On_profile_opened'), self)
	ListenToGameEvent("dota_tutorial_task_advance", Dynamic_Wrap(GameMode, 'On_dota_tutorial_task_advance'), self)
	ListenToGameEvent("dota_tutorial_shop_toggled", Dynamic_Wrap(GameMode, 'On_dota_tutorial_shop_toggled'), self)
	ListenToGameEvent("ugc_download_requested", Dynamic_Wrap(GameMode, 'On_ugc_download_requested'), self)
	ListenToGameEvent("ugc_installed", Dynamic_Wrap(GameMode, 'On_ugc_installed'), self)
	ListenToGameEvent("compendium_trophies_loaded", Dynamic_Wrap(GameMode, 'On_compendium_trophies_loaded'), self)
	ListenToGameEvent("spec_item_pickup", Dynamic_Wrap(GameMode, 'On_spec_item_pickup'), self)
	ListenToGameEvent("spec_aegis_reclaim_time", Dynamic_Wrap(GameMode, 'On_spec_aegis_reclaim_time'), self)
	ListenToGameEvent("account_trophies_changed", Dynamic_Wrap(GameMode, 'On_account_trophies_changed'), self)
	ListenToGameEvent("account_all_hero_challenge_changed", Dynamic_Wrap(GameMode, 'On_account_all_hero_challenge_changed'), self)
	ListenToGameEvent("team_showcase_ui_update", Dynamic_Wrap(GameMode, 'On_team_showcase_ui_update'), self)
	ListenToGameEvent("ingame_events_changed", Dynamic_Wrap(GameMode, 'On_ingame_events_changed'), self)
	ListenToGameEvent("dota_match_signout", Dynamic_Wrap(GameMode, 'On_dota_match_signout'), self)
	ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(GameMode, 'On_dota_illusions_created'), self)
	ListenToGameEvent("dota_year_beast_killed", Dynamic_Wrap(GameMode, 'On_dota_year_beast_killed'), self)
	ListenToGameEvent("dota_hero_undoselection", Dynamic_Wrap(GameMode, 'On_dota_hero_undoselection'), self)
	ListenToGameEvent("dota_challenge_socache_updated", Dynamic_Wrap(GameMode, 'On_dota_challenge_socache_updated'), self)
	ListenToGameEvent("party_invites_updated", Dynamic_Wrap(GameMode, 'On_party_invites_updated'), self)
	ListenToGameEvent("lobby_invites_updated", Dynamic_Wrap(GameMode, 'On_lobby_invites_updated'), self)
	ListenToGameEvent("custom_game_mode_list_updated", Dynamic_Wrap(GameMode, 'On_custom_game_mode_list_updated'), self)
	ListenToGameEvent("custom_game_lobby_list_updated", Dynamic_Wrap(GameMode, 'On_custom_game_lobby_list_updated'), self)
	ListenToGameEvent("friend_lobby_list_updated", Dynamic_Wrap(GameMode, 'On_friend_lobby_list_updated'), self)
	ListenToGameEvent("dota_team_player_list_changed", Dynamic_Wrap(GameMode, 'On_dota_team_player_list_changed'), self)
	ListenToGameEvent("dota_player_details_changed", Dynamic_Wrap(GameMode, 'On_dota_player_details_changed'), self)
	ListenToGameEvent("player_profile_stats_updated", Dynamic_Wrap(GameMode, 'On_player_profile_stats_updated'), self)
	ListenToGameEvent("custom_game_player_count_updated", Dynamic_Wrap(GameMode, 'On_custom_game_player_count_updated'), self)
	ListenToGameEvent("custom_game_friends_played_updated", Dynamic_Wrap(GameMode, 'On_custom_game_friends_played_updated'), self)
	ListenToGameEvent("custom_games_friends_play_updated", Dynamic_Wrap(GameMode, 'On_custom_games_friends_play_updated'), self)
	ListenToGameEvent("dota_player_update_assigned_hero", Dynamic_Wrap(GameMode, 'On_dota_player_update_assigned_hero'), self)
	ListenToGameEvent("dota_player_hero_selection_dirty", Dynamic_Wrap(GameMode, 'On_dota_player_hero_selection_dirty'), self)
	--ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(GameMode, 'On_dota_npc_goal_reached'), self)
	ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(GameMode, 'On_dota_player_selected_custom_team'), self)
end

function GameMode:On_team_info(data)
	PrintTable(data)
end

function GameMode:On_team_score(data)
	PrintTable(data)
end

function GameMode:On_teamplay_broadcast_audio(data)
	PrintTable(data)
end

function GameMode:On_player_team(data)
	PrintTable(data)
end

function GameMode:On_player_class(data)
	PrintTable(data)
end

function GameMode:On_player_death (data)
	PrintTable(data)
end

function GameMode:On_player_hurt (data)
	PrintTable(data)
end

function GameMode:On_player_chat (data)
	PrintTable(data)
end

function GameMode:On_player_score(data)
	PrintTable(data)
end

function GameMode:On_player_spawn(data)
	PrintTable(data)
end

function GameMode:On_player_shoot(data)
	PrintTable(data)
end

function GameMode:On_player_use(data)
	PrintTable(data)
end

function GameMode:On_player_changename(data)
	PrintTable(data)
end

function GameMode:On_player_hintmessage(data)
	PrintTable(data)
end

function GameMode:On_player_reconnected (data)
	PrintTable(data)
end

function GameMode:On_game_init(data)
	PrintTable(data)
end

function GameMode:On_game_newmap(data)
	PrintTable(data)
end

function GameMode:On_game_start(data)
	PrintTable(data)
end

function GameMode:On_game_end(data)
	PrintTable(data)
end

function GameMode:On_round_start(data)
	PrintTable(data)
end

function GameMode:On_round_end(data)
	PrintTable(data)
end

function GameMode:On_round_start_pre_entity(data)
	PrintTable(data)
end

function GameMode:On_teamplay_round_start(data)
	PrintTable(data)
end

function GameMode:On_hostname_changed(data)
	PrintTable(data)
end

function GameMode:On_difficulty_changed(data)
	PrintTable(data)
end

function GameMode:On_finale_start(data)
	PrintTable(data)
end

function GameMode:On_game_message(data)
	PrintTable(data)
end

function GameMode:On_break_breakable(data)
	PrintTable(data)
end

function GameMode:On_break_prop(data)
	PrintTable(data)
end

function GameMode:On_npc_spawned(data)
	PrintTable(data)
end

function GameMode:On_npc_replaced(data)
	PrintTable(data)
end

function GameMode:On_entity_killed(data)
	PrintTable(data)
end

function GameMode:On_entity_hurt(data)
	PrintTable(data)
end

function GameMode:On_bonus_updated(data)
	PrintTable(data)
end

function GameMode:On_player_stats_updated(data)
	PrintTable(data)
end

function GameMode:On_achievement_event(data)
	PrintTable(data)
end

function GameMode:On_achievement_earned(data)
	PrintTable(data)
end

function GameMode:On_achievement_write_failed(data)
	PrintTable(data)
end

function GameMode:On_physgun_pickup(data)
	PrintTable(data)
end

function GameMode:On_flare_ignite_npc(data)
	PrintTable(data)
end

function GameMode:On_helicopter_grenade_punt_miss(data)
	PrintTable(data)
end

function GameMode:On_user_data_downloaded(data)
	PrintTable(data)
end

function GameMode:On_ragdoll_dissolved(data)
	PrintTable(data)
end

function GameMode:On_gameinstructor_draw(data)
	PrintTable(data)
end

function GameMode:On_gameinstructor_nodraw(data)
	PrintTable(data)
end

function GameMode:On_map_transition(data)
	PrintTable(data)
end

function GameMode:On_instructor_server_hint_create(data)
	PrintTable(data)
end

function GameMode:On_instructor_server_hint_stop(data)
	PrintTable(data)
end

function GameMode:On_chat_new_message(data)
	PrintTable(data)
end

function GameMode:On_chat_members_changed(data)
	PrintTable(data)
end

function GameMode:On_game_rules_state_change(data)
	PrintTable(data)
end

function GameMode:On_inventory_updated(data)
	PrintTable(data)
end

function GameMode:On_cart_updated(data)
	PrintTable(data)
end

function GameMode:On_store_pricesheet_updated(data)
	PrintTable(data)
end

function GameMode:On_gc_connected(data)
	PrintTable(data)
end

function GameMode:On_item_schema_initialized(data)
	PrintTable(data)
end

function GameMode:On_drop_rate_modified(data)
	PrintTable(data)
end

function GameMode:On_event_ticket_modified(data)
	PrintTable(data)
end

function GameMode:On_modifier_event(data)
	PrintTable(data)
end

function GameMode:On_dota_player_kill(data)
	PrintTable(data)
end

function GameMode:On_dota_player_deny(data)
	PrintTable(data)
end

function GameMode:On_dota_barracks_kill(data)
	PrintTable(data)
end

function GameMode:On_dota_tower_kill(data)
	PrintTable(data)
end

function GameMode:On_dota_roshan_kill(data)
	PrintTable(data)
end

function GameMode:On_dota_courier_lost(data)
	PrintTable(data)
end

function GameMode:On_dota_courier_respawned(data)
	PrintTable(data)
end

function GameMode:On_dota_glyph_used(data)
	PrintTable(data)
end

function GameMode:On_dota_super_creeps(data)
	PrintTable(data)
end

function GameMode:On_dota_item_purchase(data)
	PrintTable(data)
end

function GameMode:On_dota_item_gifted(data)
	PrintTable(data)
end

function GameMode:On_dota_rune_pickup(data)
	PrintTable(data)
end

function GameMode:On_dota_rune_spotted(data)
	PrintTable(data)
end

function GameMode:On_dota_item_spotted(data)
	PrintTable(data)
end

function GameMode:On_dota_no_battle_points(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_informational(data)
	PrintTable(data)
end

function GameMode:On_dota_action_item(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_ban_notification(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_event(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_timed_reward(data)
	PrintTable(data)
end

function GameMode:On_dota_pause_event(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_kill_streak(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_first_blood(data)
	PrintTable(data)
end

function GameMode:On_dota_player_update_hero_selection(data)
	PrintTable(data)
end

function GameMode:On_dota_player_update_selected_unit(data)
	PrintTable(data)
end

function GameMode:On_dota_player_update_query_unit(data)
	PrintTable(data)
end

function GameMode:On_dota_player_update_killcam_unit(data)
	PrintTable(data)
end

function GameMode:On_dota_player_take_tower_damage(data)
	PrintTable(data)
end

function GameMode:On_dota_hud_error_message(data)
	PrintTable(data)
end

function GameMode:On_dota_action_success(data)
	PrintTable(data)
end

function GameMode:On_dota_starting_position_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_money_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_enemy_money_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_portrait_unit_stats_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_portrait_unit_modifiers_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_force_portrait_update(data)
	PrintTable(data)
end

function GameMode:On_dota_inventory_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_item_picked_up(data)
	PrintTable(data)
end

function GameMode:On_dota_inventory_item_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_ability_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_portrait_ability_layout_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_inventory_item_added(data)
	PrintTable(data)
end

function GameMode:On_dota_inventory_changed_query_unit(data)
	PrintTable(data)
end

function GameMode:On_dota_link_clicked(data)
	PrintTable(data)
end

function GameMode:On_dota_set_quick_buy(data)
	PrintTable(data)
end

function GameMode:On_dota_quick_buy_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_player_shop_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_player_show_killcam(data)
	PrintTable(data)
end

function GameMode:On_dota_player_show_minikillcam(data)
	PrintTable(data)
end

function GameMode:On_gc_user_session_created(data)
	PrintTable(data)
end

function GameMode:On_team_data_updated(data)
	PrintTable(data)
end

function GameMode:On_guild_data_updated(data)
	PrintTable(data)
end

function GameMode:On_guild_open_parties_updated(data)
	PrintTable(data)
end

function GameMode:On_fantasy_updated(data)
	PrintTable(data)
end

function GameMode:On_fantasy_league_changed(data)
	PrintTable(data)
end

function GameMode:On_fantasy_score_info_changed(data)
	PrintTable(data)
end

function GameMode:On_player_info_updated(data)
	PrintTable(data)
end

function GameMode:On_game_rules_state_change(data)
	PrintTable(data)
end

function GameMode:On_match_history_updated(data)
	PrintTable(data)
end

function GameMode:On_match_details_updated(data)
	PrintTable(data)
end

function GameMode:On_live_games_updated(data)
	PrintTable(data)
end

function GameMode:On_recent_matches_updated(data)
	PrintTable(data)
end

function GameMode:On_news_updated(data)
	PrintTable(data)
end

function GameMode:On_persona_updated(data)
	PrintTable(data)
end

function GameMode:On_tournament_state_updated(data)
	PrintTable(data)
end

function GameMode:On_party_updated(data)
	PrintTable(data)
end

function GameMode:On_lobby_updated(data)
	PrintTable(data)
end

function GameMode:On_dashboard_caches_cleared(data)
	PrintTable(data)
end

function GameMode:On_last_hit(data)
	PrintTable(data)
end

function GameMode:On_player_completed_game(data)
	PrintTable(data)
end

function GameMode:On_dota_combatlog(data)
	PrintTable(data)
end

function GameMode:On_player_reconnected(data)
	PrintTable(data)
end

function GameMode:On_nommed_tree(data)
	PrintTable(data)
end

function GameMode:On_dota_rune_activated_server(data)
	PrintTable(data)
end

function GameMode:On_dota_player_gained_level(data)
	PrintTable(data)
end

function GameMode:On_dota_player_pick_hero(data)
	PrintTable(data)
end

function GameMode:On_dota_player_learned_ability(data)
	PrintTable(data)
end

function GameMode:On_dota_player_used_ability(data)
	PrintTable(data)
end

function GameMode:On_dota_non_player_used_ability(data)
	PrintTable(data)
end

function GameMode:On_dota_ability_channel_finished(data)
	PrintTable(data)
end

function GameMode:On_dota_holdout_revive_complete(data)
	PrintTable(data)
end

function GameMode:On_dota_player_killed(data)
	PrintTable(data)
end

function GameMode:On_bindpanel_open(data)
	PrintTable(data)
end

function GameMode:On_bindpanel_close(data)
	PrintTable(data)
end

function GameMode:On_keybind_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_item_drag_begin(data)
	PrintTable(data)
end

function GameMode:On_dota_item_drag_end(data)
	PrintTable(data)
end

function GameMode:On_dota_shop_item_drag_begin(data)
	PrintTable(data)
end

function GameMode:On_dota_shop_item_drag_end(data)
	PrintTable(data)
end

function GameMode:On_dota_item_purchased(data)
	PrintTable(data)
end

function GameMode:On_dota_item_used(data)
	PrintTable(data)
end

function GameMode:On_dota_item_auto_purchase(data)
	PrintTable(data)
end

function GameMode:On_dota_unit_event(data)
	PrintTable(data)
end

function GameMode:On_dota_quest_started(data)
	PrintTable(data)
end

function GameMode:On_dota_quest_completed(data)
	PrintTable(data)
end

function GameMode:On_gameui_activated(data)
	PrintTable(data)
end

function GameMode:On_gameui_hidden(data)
	PrintTable(data)
end

function GameMode:On_player_fullyjoined(data)
	PrintTable(data)
end

function GameMode:On_dota_spectate_hero(data)
	PrintTable(data)
end

function GameMode:On_dota_match_done(data)
	PrintTable(data)
end

function GameMode:On_dota_match_done_client(data)
	PrintTable(data)
end

function GameMode:On_set_instructor_group_enabled(data)
	PrintTable(data)
end

function GameMode:On_joined_chat_channel(data)
	PrintTable(data)
end

function GameMode:On_left_chat_channel(data)
	PrintTable(data)
end

function GameMode:On_gc_chat_channel_list_updated(data)
	PrintTable(data)
end

function GameMode:On_today_messages_updated(data)
	PrintTable(data)
end

function GameMode:On_file_downloaded(data)
	PrintTable(data)
end

function GameMode:On_player_report_counts_updated(data)
	PrintTable(data)
end

function GameMode:On_scaleform_file_download_complete(data)
	PrintTable(data)
end

function GameMode:On_item_purchased(data)
	PrintTable(data)
end

function GameMode:On_gc_mismatched_version(data)
	PrintTable(data)
end

function GameMode:On_demo_skip(data)
	PrintTable(data)
end

function GameMode:On_demo_start(data)
	PrintTable(data)
end

function GameMode:On_demo_stop(data)
	PrintTable(data)
end

function GameMode:On_map_shutdown(data)
	PrintTable(data)
end

function GameMode:On_dota_workshop_fileselected(data)
	PrintTable(data)
end

function GameMode:On_dota_workshop_filecanceled(data)
	PrintTable(data)
end

function GameMode:On_rich_presence_updated(data)
	PrintTable(data)
end

function GameMode:On_dota_hero_random(data)
	PrintTable(data)
end

function GameMode:On_dota_rd_chat_turn(data)
	PrintTable(data)
end

function GameMode:On_dota_favorite_heroes_updated(data)
	PrintTable(data)
end

function GameMode:On_profile_closed(data)
	PrintTable(data)
end

function GameMode:On_item_preview_closed(data)
	PrintTable(data)
end

function GameMode:On_dashboard_switched_section(data)
	PrintTable(data)
end

function GameMode:On_dota_tournament_item_event(data)
	PrintTable(data)
end

function GameMode:On_dota_hero_swap(data)
	PrintTable(data)
end

function GameMode:On_dota_reset_suggested_items(data)
	PrintTable(data)
end

function GameMode:On_halloween_high_score_received(data)
	PrintTable(data)
end

function GameMode:On_halloween_phase_end(data)
	PrintTable(data)
end

function GameMode:On_halloween_high_score_request_failed(data)
	PrintTable(data)
end

function GameMode:On_dota_hud_skin_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_inventory_player_got_item(data)
	PrintTable(data)
end

function GameMode:On_player_is_experienced(data)
	PrintTable(data)
end

function GameMode:On_player_is_notexperienced(data)
	PrintTable(data)
end

function GameMode:On_dota_tutorial_lesson_start(data)
	PrintTable(data)
end

function GameMode:On_map_location_updated(data)
	PrintTable(data)
end

function GameMode:On_richpresence_custom_updated(data)
	PrintTable(data)
end

function GameMode:On_game_end_visible(data)
	PrintTable(data)
end

function GameMode:On_antiaddiction_update(data)
	PrintTable(data)
end

function GameMode:On_highlight_hud_element(data)
	PrintTable(data)
end

function GameMode:On_hide_highlight_hud_element(data)
	PrintTable(data)
end

function GameMode:On_intro_video_finished(data)
	PrintTable(data)
end

function GameMode:On_matchmaking_status_visibility_changed(data)
	PrintTable(data)
end

function GameMode:On_practice_lobby_visibility_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_courier_transfer_item(data)
	PrintTable(data)
end

function GameMode:On_full_ui_unlocked(data)
	PrintTable(data)
end

function GameMode:On_client_connectionless_packet(data)
	PrintTable(data)
end

function GameMode:On_hero_selector_preview_set(data)
	PrintTable(data)
end

function GameMode:On_antiaddiction_toast(data)
	PrintTable(data)
end

function GameMode:On_hero_picker_shown(data)
	PrintTable(data)
end

function GameMode:On_hero_picker_hidden(data)
	PrintTable(data)
end

function GameMode:On_dota_local_quickbuy_changed(data)
	PrintTable(data)
end

function GameMode:On_show_center_message(data)
	PrintTable(data)
end

function GameMode:On_hud_flip_changed(data)
	PrintTable(data)
end

function GameMode:On_frosty_points_updated(data)
	PrintTable(data)
end

function GameMode:On_defeated(data)
	PrintTable(data)
end

function GameMode:On_reset_defeated(data)
	PrintTable(data)
end

function GameMode:On_booster_state_updated(data)
	PrintTable(data)
end

function GameMode:On_event_points_updated(data)
	PrintTable(data)
end

function GameMode:On_local_player_event_points(data)
	PrintTable(data)
end

function GameMode:On_custom_game_difficulty(data)
	PrintTable(data)
end

function GameMode:On_tree_cut(data)
	PrintTable(data)
end

function GameMode:On_ugc_details_arrived(data)
	PrintTable(data)
end

function GameMode:On_ugc_subscribed(data)
	PrintTable(data)
end

function GameMode:On_ugc_unsubscribed(data)
	PrintTable(data)
end

function GameMode:On_prizepool_received(data)
	PrintTable(data)
end

function GameMode:On_microtransaction_success(data)
	PrintTable(data)
end

function GameMode:On_dota_rubick_ability_steal(data)
	PrintTable(data)
end

function GameMode:On_compendium_event_actions_loaded(data)
	PrintTable(data)
end

function GameMode:On_compendium_selections_loaded(data)
	PrintTable(data)
end

function GameMode:On_compendium_set_selection_failed(data)
	PrintTable(data)
end

function GameMode:On_community_cached_names_updated(data)
	PrintTable(data)
end

function GameMode:On_dota_team_kill_credit(data)
	PrintTable(data)
end

function GameMode:On_dota_effigy_kill(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_assassin_announce(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_assassin_denied(data)
	PrintTable(data)
end

function GameMode:On_dota_chat_assassin_success(data)
	PrintTable(data)
end

function GameMode:On_player_info_individual_updated(data)
	PrintTable(data)
end

function GameMode:On_dota_player_begin_cast(data)
	PrintTable(data)
end

function GameMode:On_dota_non_player_begin_cast(data)
	PrintTable(data)
end

function GameMode:On_dota_item_combined(data)
	PrintTable(data)
end

function GameMode:On_profile_opened(data)
	PrintTable(data)
end

function GameMode:On_dota_tutorial_task_advance(data)
	PrintTable(data)
end

function GameMode:On_dota_tutorial_shop_toggled(data)
	PrintTable(data)
end

function GameMode:On_ugc_download_requested(data)
	PrintTable(data)
end

function GameMode:On_ugc_installed(data)
	PrintTable(data)
end

function GameMode:On_compendium_trophies_loaded(data)
	PrintTable(data)
end

function GameMode:On_spec_item_pickup(data)
	PrintTable(data)
end

function GameMode:On_spec_aegis_reclaim_time(data)
	PrintTable(data)
end

function GameMode:On_account_trophies_changed(data)
	PrintTable(data)
end

function GameMode:On_account_all_hero_challenge_changed(data)
	PrintTable(data)
end

function GameMode:On_team_showcase_ui_update(data)
	PrintTable(data)
end

function GameMode:On_ingame_events_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_match_signout(data)
	PrintTable(data)
end

function GameMode:On_dota_illusions_created(data)
	PrintTable(data)
end

function GameMode:On_dota_year_beast_killed(data)
	PrintTable(data)
end

function GameMode:On_dota_hero_undoselection(data)
	PrintTable(data)
end

function GameMode:On_dota_challenge_socache_updated(data)
	PrintTable(data)
end

function GameMode:On_party_invites_updated(data)
	PrintTable(data)
end

function GameMode:On_lobby_invites_updated(data)
	PrintTable(data)
end

function GameMode:On_custom_game_mode_list_updated(data)
	PrintTable(data)
end

function GameMode:On_custom_game_lobby_list_updated(data)
	PrintTable(data)
end

function GameMode:On_friend_lobby_list_updated(data)
	PrintTable(data)
end

function GameMode:On_dota_team_player_list_changed(data)
	PrintTable(data)
end

function GameMode:On_dota_player_details_changed(data)
	PrintTable(data)
end

function GameMode:On_player_profile_stats_updated(data)
	PrintTable(data)
end

function GameMode:On_custom_game_player_count_updated(data)
	PrintTable(data)
end

function GameMode:On_custom_game_friends_played_updated(data)
	PrintTable(data)
end

function GameMode:On_custom_games_friends_play_updated(data)
	PrintTable(data)
end

function GameMode:On_dota_player_update_assigned_hero(data)
	PrintTable(data)
end

function GameMode:On_dota_player_hero_selection_dirty(data)
	PrintTable(data)
end

function GameMode:On_dota_npc_goal_reached(data)
	PrintTable(data)
end

function GameMode:On_dota_player_selected_custom_team(data)
	PrintTable(data)
end

"use strict";

var m_RunePanels = []; // created up to a high-water mark, but reused when selection changes
var m_RunePanelsTier2 = [];
var m_RunePanelsTier3 = [];
var m_RunePanelsTier4 = [];
var COST_LEVEL_UP_RUNES = [1,1,2,4]

function OnLevelUpClicked()
{
	if ( Game.IsInAbilityLearnMode() )
	{
		Game.EndAbilityLearnMode();
	}
	else
	{
		Game.EnterAbilityLearnMode();
	}
}

function OnAbilityLearnModeToggled( bEnabled )
{
	UpdateRuneList();
}

function getRuneLevelsFromModifiers(caster){
	var number_of_buffs = Entities.GetNumBuffs( caster )
	var levels_hash = {}
	levels_hash["q"] = 0
	levels_hash["w"] = 0
	levels_hash["e"] = 0
	levels_hash["d"] = 0
	var loop_index = 0
	for (loop_index = 0; loop_index < number_of_buffs; loop_index++) {
	  var buff = Entities.GetBuff( caster, loop_index)
	  var buffName = Buffs.GetName( caster, buff )	
	  if (buffName == "modifier_rune_points_q"){
	  	levels_hash["q"] = Buffs.GetStackCount( caster, buff )
	  }else if (buffName == "modifier_rune_points_w"){
	  	levels_hash["w"] = Buffs.GetStackCount( caster, buff )
	  }else if (buffName == "modifier_rune_points_e"){
	  	levels_hash["e"] = Buffs.GetStackCount( caster, buff )
	  }else if (buffName == "modifier_rune_points_d"){
	  	levels_hash["d"] = Buffs.GetStackCount( caster, buff )
	  }
	}
	return levels_hash
}

function UpdateRuneList()
{
	// UpdateRuneListTier2();
	// UpdateRuneListTier3();
	// UpdateRuneListTier4();
	$.Msg("UPDATE RUNE LIST")
	var tier = 1;
	for (tier = 1; tier <= 4; tier++) {
		$.Msg("update runes: "+tier)
		var runeListPanel = $( "#rune_list_tier"+tier);
		if (runeListPanel){
			var playerIndex = getControllingPlayerIndex();
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit"+tier.toString() );

			$.Msg(skill_tree_data)
		}
		if (skill_tree_data===undefined){
			$.Msg("SKILL TREE DATA UNDEFINED")
			return;
		}
		var rune_unit_index = skill_tree_data.runeUnit;
		var queryUnit = rune_unit_index	
		if ( !runeListPanel)
			return;
		var rune_levels = getRuneLevelsFromModifiers(queryUnit)
		var mainHero = Players.GetPlayerHeroEntityIndex(playerIndex)
		// see if we can level up
		var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
		var bPointsToSpend = ( nRemainingPoints > 0 );
		var bControlsUnit = true
		var player_stats = CustomNetTables.GetTableValue( "player_stats", playerIndex.toString() );
		var runePoints = player_stats.runePoints
		if (runePoints >= COST_LEVEL_UP_RUNES[i-1]){
			$.GetContextPanel().SetHasClass( "could_level_up", ( true ) );
		}

		// update all the panels
		var nUsedPanels = 0;
		for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
		{
			var ability_level = rune_levels["q"]
			if (i == 1){
				ability_level = rune_levels["w"]
			}else if(i == 2){
				ability_level = rune_levels["e"]
			}else if(i == 3){
				ability_level = rune_levels["d"]
			}

	        var ability = Entities.GetAbility(queryUnit, i);
			if ( ability == -1 )
				continue;
			if ( !Abilities.IsDisplayedAbility(ability) )
				continue;
			if (tier == 1){
				if ( nUsedPanels >= m_RunePanels.length )
				{
					// create a new panel
					var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
					runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
					m_RunePanels.push( runePanel );
					runePanel.SetAttributeInt( "index", i );
					runePanel.SetAttributeInt( "tier", tier );
					runePanel.SetAttributeInt( "mainHero", mainHero );
				}

				// update the panel for the current unit / ability
				var runePanel = m_RunePanels[ nUsedPanels ];
				runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero, ability_level);
				
				nUsedPanels++;
			}else if(tier == 2){
				if ( nUsedPanels >= m_RunePanelsTier2.length )
				{
					// create a new panel
					var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
					runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
					m_RunePanelsTier2.push( runePanel );
					runePanel.SetAttributeInt( "index", i );
					runePanel.SetAttributeInt( "tier", tier );
					runePanel.SetAttributeInt( "mainHero", mainHero );
				}

				// update the panel for the current unit / ability
				var runePanel = m_RunePanelsTier2[ nUsedPanels ];
				runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero, ability_level);
				
				nUsedPanels++;				
			}else if(tier == 3){
				if ( nUsedPanels >= m_RunePanelsTier3.length )
				{
					// create a new panel
					var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
					runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
					m_RunePanelsTier3.push( runePanel );
					runePanel.SetAttributeInt( "index", i );
					runePanel.SetAttributeInt( "tier", tier );
					runePanel.SetAttributeInt( "mainHero", mainHero );
				}

				// update the panel for the current unit / ability
				var runePanel = m_RunePanelsTier3[ nUsedPanels ];
				runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero, ability_level);
				
				nUsedPanels++;				
			}else if(tier == 4){
				if ( nUsedPanels >= m_RunePanelsTier4.length )
				{
					// create a new panel
					var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
					runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
					m_RunePanelsTier4.push( runePanel );
					runePanel.SetAttributeInt( "index", i );
					runePanel.SetAttributeInt( "tier", tier );
					runePanel.SetAttributeInt( "mainHero", mainHero );
				}

				// update the panel for the current unit / ability
				var runePanel = m_RunePanelsTier4[ nUsedPanels ];
				runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero, ability_level);
				
				nUsedPanels++;				
			}
		}

		if (tier == 1){
			for ( var i = nUsedPanels; i < m_RunePanels.length; ++i )
			{
				var runePanel = m_RunePanels[ i ];
				runePanel.SetAbility( -1, -1, false, -1, 0 );
			}
		}else if(tier == 2){
			for ( var i = nUsedPanels; i < m_RunePanelsTier2.length; ++i )
			{
				var runePanel = m_RunePanelsTier2[ i ];
				runePanel.SetAbility( -1, -1, false, -1, 0 );
			}
		}else if(tier == 3){
			for ( var i = nUsedPanels; i < m_RunePanelsTier3.length; ++i )
			{
				var runePanel = m_RunePanelsTier3[ i ];
				runePanel.SetAbility( -1, -1, false, -1, 0 );
			}
		}else if(tier == 4){
			for ( var i = nUsedPanels; i < m_RunePanelsTier4.length; ++i )
			{
				var runePanel = m_RunePanelsTier4[ i ];
				runePanel.SetAbility( -1, -1, false, -1, 0 );
			}
		}
	}

}

function getControllingPlayerIndex()
{
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var playerIndex = Players.GetLocalPlayer();
	if (Entities.IsHero(queryUnit)){
		var playerTable = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString() );
		if (playerTable === undefined){
			playerIndex = Players.GetLocalPlayer();
		}else{
			playerIndex = playerTable.playerOwner
		}
		
	}else{
		playerIndex = Players.GetLocalPlayer();
	}
	playerIndex = parseInt(playerIndex)
	if (!(Players.IsValidPlayerID(playerIndex))){
		playerIndex = Game.GetAllPlayerIDs()[0];
	}
	return parseInt(playerIndex)
}

(function()
{


	// GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateRuneList );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateRuneList );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateRuneList );
	// GameEvents.Subscribe( "dota_ability_changed", UpdateRuneList );
	GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateRuneList );
	GameEvents.Subscribe( "update_abilities_and_runes_ui", UpdateRuneList );
	GameEvents.Subscribe( "update_runes", UpdateRuneList );
	UpdateRuneList();
})();


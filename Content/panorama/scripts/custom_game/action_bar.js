"use strict";

var m_AbilityPanels = []; // created up to a high-water mark, but reused when selection changes

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
	UpdateAbilityList();
}

function UpdateAbilityList()
{
	var abilityListPanel = $( "#ability_list" );
	$.Msg("updateAbilityList")
	if ( !abilityListPanel )
		return;

	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (Entities.IsHero(queryUnit)){
		
	}else{
		queryUnit = Players.GetPlayerHeroEntityIndex( Game.GetLocalPlayerID())
	}
	// see if we can level up
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = Entities.IsControllableByPlayer( queryUnit, Game.GetLocalPlayerID() );
	var player_stats = CustomNetTables.GetTableValue( "player_stats", Game.GetLocalPlayerID().toString() );
	if (!(player_stats === undefined)){
		var skillPoints = player_stats.skillPoints
		if (skillPoints > 0){
			$.GetContextPanel().SetHasClass( "could_level_up", ( true ) );
		}
	}
	

	// update all the panels
	var nUsedPanels = 0;
	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	// for ( var i = 0; i < 4; ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) ){
			continue;
		}
		if (nUsedPanels >= 4){
			continue;
		}
		if ( nUsedPanels >= m_AbilityPanels.length )
		{
			// create a new panel
			var abilityPanel = $.CreatePanel( "Panel", abilityListPanel, "" );
			abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );
			m_AbilityPanels.push( abilityPanel );
			//abilityPanel.SetAttributeInt( "index", i );
		}

		// update the panel for the current unit / ability
		var abilityPanel = m_AbilityPanels[ nUsedPanels ];
		abilityPanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode() );
		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_AbilityPanels.length; ++i )
	{
		var abilityPanel = m_AbilityPanels[ i ];
		abilityPanel.SetAbility( -1, -1, false );
	}
}

(function()
{
    // $.RegisterForUnhandledEvent( "DOTAAbility_LearnModeToggled", OnAbilityLearnModeToggled);

	GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_ability_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateAbilityList );
	GameEvents.Subscribe( "ability_tree_upgrade", UpdateAbilityList );
	GameEvents.Subscribe( "update_abilities_and_runes_ui", UpdateAbilityList );
	
	UpdateAbilityList(); // initial update
})();


"use strict";

var m_RunePanels = []; // created up to a high-water mark, but reused when selection changes
var m_RunePanelsTier2 = [];
var m_RunePanelsTier3 = [];
var m_RunePanelsTier4 = [];

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

function UpdateRuneList()
{
	UpdateRuneListTier2();
	UpdateRuneListTier3();
	UpdateRuneListTier4();
	$.Msg("update runes")
	var runeListPanel = $( "#rune_list" );
	if (runeListPanel){
		var playerIndex = getControllingPlayerIndex();
		

		var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit1" );
	
	}
	if (skill_tree_data===undefined){
		return;
	}
	var rune_unit_index = skill_tree_data.runeUnit;
	var queryUnit = rune_unit_index	
	if ( !runeListPanel)
		return;

	var mainHero = Players.GetPlayerHeroEntityIndex(playerIndex)
	// see if we can level up
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = true
	var player_stats = CustomNetTables.GetTableValue( "player_stats", playerIndex.toString() );
	var runePoints = player_stats.runePoints
	if (runePoints > 0){
		$.GetContextPanel().SetHasClass( "could_level_up", ( true ) );
	}
	

	// update all the panels
	var nUsedPanels = 0;
	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		
		if ( nUsedPanels >= m_RunePanels.length )
		{
			// create a new panel
			var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
			runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
			m_RunePanels.push( runePanel );
			runePanel.SetAttributeInt( "index", i );
			runePanel.SetAttributeInt( "tier", 1 );
			runePanel.SetAttributeInt( "mainHero", mainHero );
		}

		// update the panel for the current unit / ability
		var runePanel = m_RunePanels[ nUsedPanels ];
		runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero);
		
		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_RunePanels.length; ++i )
	{
		var runePanel = m_RunePanels[ i ];
		runePanel.SetAbility( -1, -1, false, -1 );
	}

}

function UpdateRuneListTier2()
{
	var playerIndex = getControllingPlayerIndex();
	var runeListPanel = $( "#rune_list_tier2" );
	if (runeListPanel){
		var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit2" );	
	}
	if (skill_tree_data === undefined){
		return;
	}
	var rune_unit_index = skill_tree_data.runeUnit;
	var queryUnit = rune_unit_index	
	if ( !runeListPanel)
		return;
	var mainHero = Players.GetPlayerHeroEntityIndex( playerIndex)
	// see if we can level up
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = true
	var player_stats = CustomNetTables.GetTableValue( "player_stats", playerIndex.toString() );
	var runePoints = player_stats.runePoints
	if (runePoints > 0){
		$.GetContextPanel().SetHasClass( "could_level_up", ( true ) );
	}
	

	// update all the panels
	var nUsedPanels = 0;
	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		
		if ( nUsedPanels >= m_RunePanelsTier2.length )
		{
			// create a new panel
			var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
			runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
			m_RunePanelsTier2.push( runePanel );
			runePanel.SetAttributeInt( "index", i );
			runePanel.SetAttributeInt( "tier", 2 );
			runePanel.SetAttributeInt( "mainHero", mainHero );
		}

		// update the panel for the current unit / ability
		var runePanel = m_RunePanelsTier2[ nUsedPanels ];

		runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero);
		
		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_RunePanelsTier2.length; ++i )
	{
		var runePanel = m_RunePanelsTier2[ i ];
		runePanel.SetAbility( -1, -1, false, -1 );
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
function UpdateRuneListTier3()
{
	var playerIndex = getControllingPlayerIndex();
	var runeListPanel = $( "#rune_list_tier3" );
	if (runeListPanel){
		var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit3" );	
	}
	if (skill_tree_data === undefined){
		return;
	}
	var rune_unit_index = skill_tree_data.runeUnit;
	var queryUnit = rune_unit_index	
	if ( !runeListPanel)
		return;

	var mainHero = Players.GetPlayerHeroEntityIndex( playerIndex)
	// see if we can level up
	var portraitUnitController = Players.GetLocalPlayerPortraitUnit();
	
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = true
	var player_stats = CustomNetTables.GetTableValue( "player_stats", playerIndex.toString() );
	var runePoints = player_stats.runePoints
	if (runePoints > 0){
		$.GetContextPanel().SetHasClass( "could_level_up", ( true ) );
	}

	// update all the panels
	var nUsedPanels = 0;
	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		
		if ( nUsedPanels >= m_RunePanelsTier3.length )
		{
			// create a new panel
			var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
			runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
			m_RunePanelsTier3.push( runePanel );
			runePanel.SetAttributeInt( "index", i );
			runePanel.SetAttributeInt( "tier", 3 );
			runePanel.SetAttributeInt( "mainHero", mainHero );
		}

		// update the panel for the current unit / ability
		var runePanel = m_RunePanelsTier3[ nUsedPanels ];

		runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero);
		
		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_RunePanelsTier3.length; ++i )
	{
		var runePanel = m_RunePanelsTier3[ i ];
		runePanel.SetAbility( -1, -1, false, mainHero );
	}
}

function UpdateRuneListTier4()
{
	var playerIndex = getControllingPlayerIndex();
	var runeListPanel = $( "#rune_list_tier4" );
	if (runeListPanel){
		var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit4" );	
	}
	if (skill_tree_data === undefined){
		return;
	}
	var rune_unit_index = skill_tree_data.runeUnit;
	var queryUnit = rune_unit_index	
	if ( !runeListPanel)
		return;

	var mainHero = Players.GetPlayerHeroEntityIndex( playerIndex)
	// see if we can level up
	var portraitUnitController = Players.GetLocalPlayerPortraitUnit();
	
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = true
	var player_stats = CustomNetTables.GetTableValue( "player_stats", playerIndex.toString() );
	var runePoints = player_stats.runePoints
	if (runePoints > 0){
		$.GetContextPanel().SetHasClass( "could_level_up", ( true ) );
	}

	// update all the panels
	var nUsedPanels = 0;
	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		
		if ( nUsedPanels >= m_RunePanelsTier4.length )
		{
			// create a new panel
			var runePanel = $.CreatePanel( "Panel", runeListPanel, "" );
			runePanel.BLoadLayout( "file://{resources}/layout/custom_game/rune_ability.xml", false, false );
			m_RunePanelsTier4.push( runePanel );
			runePanel.SetAttributeInt( "index", i );
			runePanel.SetAttributeInt( "tier", 4 );
			runePanel.SetAttributeInt( "mainHero", mainHero );
		}

		// update the panel for the current unit / ability
		var runePanel = m_RunePanelsTier4[ nUsedPanels ];

		runePanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode(), mainHero);
		
		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_RunePanelsTier4.length; ++i )
	{
		var runePanel = m_RunePanelsTier4[ i ];
		runePanel.SetAbility( -1, -1, false, mainHero );
	}
}

(function()
{


	// GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateRuneList );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateRuneList );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateRuneList );
	// GameEvents.Subscribe( "dota_ability_changed", UpdateRuneList );
	GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateRuneList );
	GameEvents.Subscribe( "ability_tree_upgrade", UpdateRuneList );
	GameEvents.Subscribe( "update_runes", UpdateRuneList );
	UpdateRuneList();
})();


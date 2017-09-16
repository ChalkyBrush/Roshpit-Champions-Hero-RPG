"use strict";

var g_ScoreboardHandle = null;

function UpdateScoreboard()
{
	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, true );
	// $.Msg($.GetContextPanel().premiumArray)
	$.Schedule( 0.3, UpdateScoreboard );
}

function UpdatePremium(msg)
{
	if ($.GetContextPanel().premiumArray === undefined){
		$.GetContextPanel().premiumArray = []
	}
	var ids = Game.GetAllPlayerIDs()
	for ( var i = 0; i < ids.length; ++i ){

		var passTable = CustomNetTables.GetTableValue( "premium_pass", ids[i].toString() )
		if (!(passTable === undefined)){
			if (passTable.pass == 1){
				$.GetContextPanel().premiumArray.push(ids[i])
				$.Msg("UPDATE PREMIUM")
				$.Msg($.GetContextPanel().premiumArray)		
			}
		}
	}

}

(function()
{
	GameEvents.Subscribe( "update_premium", UpdatePremium );
	if ( GameUI.CustomUIConfig().multiteam_top_scoreboard )
	{
		var cfg = GameUI.CustomUIConfig().multiteam_top_scoreboard;
		if ( cfg.LeftInjectXMLFile )
		{
			$( "#LeftInjectXMLFile" ).BLoadLayout( cfg.LeftInjectXMLFile, false, false );
		}
		if ( cfg.RightInjectXMLFile )
		{
			$( "#RightInjectXMLFile" ).BLoadLayout( cfg.RightInjectXMLFile, false, false );
		}
	}
	
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_top_scoreboard_player.xml",
	};
	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#MultiteamScoreboard" ) );

	UpdateScoreboard();
	
})();


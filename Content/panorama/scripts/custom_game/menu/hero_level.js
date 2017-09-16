function InitializeHeroLevel()
{
	if ($.GetContextPanel().GetAttributeInt("locked", 0) == 0){
		var entity = getSelectedHeroIndex()
		var level = Entities.GetLevel( entity )

		if (level === undefined){
			level = 1;
		}
		var xp = Entities.GetCurrentXP( entity )
		xp = xp - getXPNeededForLevel(level)
		if (xp === undefined){
			xp = 1;
		}
		var xpNeeded = Entities.GetNeededXPToLevel( entity )
		xpNeeded = xpNeeded - getXPNeededForLevel(level)
		if (xpNeeded == 0){
			xpNeeded = 1;
		}	
		$.Msg(xp)
		$.Msg(xpNeeded)
		$('#hero_level_label').text = level
		var percentage = Math.floor((xp/xpNeeded)*100)
		if (percentage < 1){
			percentage = 1;
		}
		var exp_label_text = xp+"/"+xpNeeded
		if (level == 120){
			percentage = 100
			exp_label_text = ""
		}
		$('#hero_exp_progress').style.width = percentage+"%"
		$('#hero_exp_progress_label').text = exp_label_text
	}
}

function getSelectedHeroIndex()
{
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	return queryUnit;

}

function HeroLevelUP()
{
	$.Msg("LEVEL UP!!")
	$('#hero_exp_progress').style.width = "100%"
	$('#hero_exp_progress_label').text = $.Localize("ui_level_up")
	$.GetContextPanel().SetAttributeInt("locked", 1)
	$.Schedule(4, function(){
		$.GetContextPanel().SetAttributeInt("locked", 0)
		InitializeHeroLevel();
	});
}

function getXPNeededForLevel(iLevel)
{
		var xpTable = CustomNetTables.GetTableValue( "xp_table",  iLevel.toString() )
		if (xpTable===undefined){
			return 1;
		}
		return xpTable.xpNeeded;
}

(function()
{
	GameEvents.Subscribe( "dota_player_update_selected_unit", InitializeHeroLevel );
	GameEvents.Subscribe( "dota_player_update_query_unit", InitializeHeroLevel );
	GameEvents.Subscribe( "xp_earned", InitializeHeroLevel );
	GameEvents.Subscribe( "hero_level_up", HeroLevelUP)
	InitializeHeroLevel();
})();

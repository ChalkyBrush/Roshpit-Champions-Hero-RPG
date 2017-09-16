function UpdateDifficulty(){
	// var mapName = Game.GetMapInfo().map_display_name
	// if (mapName === "rpc_world_1_normal"){
	// 	$('#difficulty_label').text = $.Localize("#ui_normal")+"★"
	// 	$('#difficulty_label').AddClass('normal_color')
	// }else if(mapName === "rpc_world_1_elite"){
	// 	$('#difficulty_label').text = $.Localize("#ui_elite")+"★★"
	// 	$('#difficulty_label').AddClass('elite_color')
	// }else if(mapName === "rpc_world_1_legend"){
	// 	$('#difficulty_label').text = $.Localize("#ui_legend")+"★★★"
	// 	$('#difficulty_label').AddClass('legend_color')
	// }
	// if (mapName === "rpc_tanari_jungle_normal"){
	// 	$('#difficulty_label').text = $.Localize("#ui_normal")+"★"
	// 	$('#difficulty_label').AddClass('normal_color')
	// 	$('#zone_label').text = $.Localize('#zone_tanari_town')
	// }else if(mapName === "rpc_tanari_jungle_elite"){
	// 	$('#difficulty_label').text = $.Localize("#ui_elite")+"★★"
	// 	$('#difficulty_label').AddClass('elite_color')
	// 	$('#zone_label').text = $.Localize('#zone_tanari_town')
	// }else if(mapName === "rpc_tanari_jungle_legend"){
	// 	$('#difficulty_label').text = $.Localize("#ui_legend")+"★★★"
	// 	$('#difficulty_label').AddClass('legend_color')
	// 	$('#zone_label').text = $.Localize('#zone_tanari_town')
	// }else if(mapName === "rpc_roshpit_arena_legend"){
	// 	$('#difficulty_label').text = $.Localize("#ui_legend")+"★★★"
	// 	$('#difficulty_label').AddClass('legend_color')
	// 	$('#zone_label').text = $.Localize('#roshpit_arena')
	// }

	// if (mapName === "rpc_redfall_ridge_normal"){
	// 	$('#difficulty_label').text = $.Localize("#ui_normal")+"★"
	// 	$('#difficulty_label').AddClass('normal_color')
	// }else if(mapName === "rpc_redfall_ridge_elite"){
	// 	$('#difficulty_label').text = $.Localize("#ui_elite")+"★★"
	// 	$('#difficulty_label').AddClass('elite_color')
	// }else if(mapName === "rpc_redfall_ridge_legend"){
	// 	$('#difficulty_label').text = $.Localize("#ui_legend")+"★★★"
	// 	$('#difficulty_label').AddClass('legend_color')
	// }
	var data = CustomNetTables.GetTableValue( "player_stats",  "diff" )
	var difficulty = parseInt(data.difficulty)
	if (difficulty == 1){
		$('#difficulty_label').text = $.Localize("#ui_normal")+"★"
		$('#difficulty_label').AddClass('normal_color')
	}else if(difficulty == 2){
		$('#difficulty_label').text = $.Localize("#ui_elite")+"★★"
		$('#difficulty_label').AddClass('elite_color')
	}else if(difficulty == 3){
		$('#difficulty_label').text = $.Localize("#ui_legend")+"★★★"
		$('#difficulty_label').AddClass('legend_color')
	}	
}

function UpdateZone(msg){
	var zoneName = msg.zoneName
	$('#zone_label').text = $.Localize('#'+zoneName)
}

function AddSpiritToZone(msg){
	var tooltipName = msg.tooltip
	$('#spirit_realm_label').text = $.Localize(tooltipName)+" - "
}

function PitLevel(msg){
	$('#spirit_realm_label').text = $.Localize("#weapon_current_level")+" "+msg.pitLevel+" - "
}

(function()
{
	GameEvents.Subscribe( "update_zone_display", UpdateZone );
	GameEvents.Subscribe( "update_spirit_zone_display", AddSpiritToZone );
	GameEvents.Subscribe( "update_pit_level", PitLevel );
	GameEvents.Subscribe( "update_difficulty", UpdateDifficulty );
	UpdateDifficulty();
})();

mTipIndex = 0
nTOOLTIPS = 22

function initLoadScreen()
{
	$.Msg('init load screen')
	$('#difficulty_tip_text_title').text = $.Localize('#tooltip_loading_screen_tip_title')
	var tipNumber = getRandomInt(1, nTOOLTIPS)
	$('#difficulty_tip_text').text = $.Localize('#tooltip_loading_screen_tip'+tipNumber)
	mTipIndex = tipNumber
	$('#tip_click_text').text = $.Localize('#tooltip_loading_screen_tip_click')
	RecursiveCheck()
	Game.SetAutoLaunchEnabled(false)
}

function RecursiveCheck(){
	$.Schedule(1.0, function(){
		if (SetMapImage()==0){
			RecursiveCheck()
		}
	})
}

function SetMapImage(){
	var mapName = getMap()
	// $.Msg(mapName)
	var status = 0
	if (mapName == "world1"){
		$.Msg("SET IMAGE!!")
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/world1load.jpg")
		status = 1
	}
	if(mapName === "tanari"){
		$.Msg("SET IMAGE TANARI!!")
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/tanari_load.jpg")
		status = 1
	}
	if(mapName === "redfall"){
		$.Msg("SET IMAGE REDFALL!!")
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/redfall_load.jpg")
		status = 1
	}
	if(mapName === "arena"){
		$.Msg("SET IMAGE ARENA!!")
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/arena_load.jpg")
		status = 1
	}
	if(mapName === "pvp_alpha"){
		$.Msg("SET IMAGE ARENA!!")
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/pvp_load.jpg")
		status = 1
	}
	if(mapName === "serengaard"){
		$.Msg("SET IMAGE SERENAARD!!")
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/serengaard_load.jpg")
		status = 1
	}
	if(mapName === "seafortress"){
		$.Msg("SET IMAGE SEAFORT!!")
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/seafortress_load.jpg")
		status = 1
	}
	if (status == 1){
		$('#seq_bg').SetImage("file://{images}/custom_game/loading_screen/descent_of_winterblight_load.jpg")
		UpdateValidDifficulties()
	}
	$.Msg(status)
	return status
}

function updateTip()
{
	mTipIndex = mTipIndex + 1
	if (mTipIndex > nTOOLTIPS){
		mTipIndex = 1
	}
	$('#difficulty_tip_text').text = $.Localize('#tooltip_loading_screen_tip'+mTipIndex)
}
function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getMap(){
	var mapName = Game.GetMapInfo().map_display_name
	// $.Msg(Game.GetMapInfo())
	// $.Msg('--MAPNAME--')
	// $.Msg(mapName)
	var map = ""
	if (mapName === "rpc_world_1_normal" || mapName === "rpc_world_1_elite" || mapName === "rpc_world_1_legend"){
		map = "world1"
	}
	if (mapName === "rpc_tanari_jungle_normal" || mapName === "rpc_tanari_jungle_elite" || mapName === "rpc_tanari_jungle_legend" || mapName == "rpc_tanari_jungle"){
		map = "tanari"
	}
	if (mapName === "rpc_redfall_ridge_normal" || mapName === "rpc_redfall_ridge_elite" || mapName === "rpc_redfall_ridge_legend" || mapName == "rpc_redfall_ridge"){
		map = "redfall"
	}
	if (mapName === "rpc_roshpit_arena_legend" || mapName == "rpc_roshpit_arena"){
		map = "arena"
	}
	if (mapName === "rpc_pvp_alpha_3v3_open" || mapName === "rpc_pvp_linewar_no_oracle"){
		map = "pvp_alpha"
	}
	if (mapName === "rpc_battle_of_serengaard"){
		map = "serengaard"
	}
	if (mapName === "rpc_sea_fortress"){
		map = "seafortress"
	}
	return map
}

function ActivateDifficultyButton(difficulty){
	$.Msg("ACTIVATE DIFFICULTY BUTTON"+difficulty)

	GameEvents.SendCustomGameEventToServer( "difficulty_select", {difficulty:difficulty, playerID: Game.GetLocalPlayerID()});
}

function updateSelectedDifficulty(msg){
	var difficulty = msg.difficulty
	$('#difficulty_button1').RemoveClass('active_vote_button')
	$('#difficulty_button2').RemoveClass('active_vote_button')
	$('#difficulty_button3').RemoveClass('active_vote_button')
	$('#difficulty_button'+difficulty).AddClass('active_vote_button')
}

function UpdateValidDifficulties(){
	var mapName = Game.GetMapInfo().map_display_name
	if (mapName == "rpc_roshpit_arena_legend" || mapName == "rpc_roshpit_arena" || mapName == "rpc_sea_fortress")
	{
		$('#difficulty_container3').RemoveClass('invisible')
	}else if(mapName == "rpc_pvp_linewar_no_oracle"){
		$('#difficulty_vote_container').AddClass('invisible')
	}else{
		$('#difficulty_container1').RemoveClass('invisible')
		$('#difficulty_container2').RemoveClass('invisible')
		$('#difficulty_container3').RemoveClass('invisible')
	}
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

}

(function()
{
	GameEvents.Subscribe( "update_selected_difficulty", updateSelectedDifficulty );
	
	initLoadScreen();
})();

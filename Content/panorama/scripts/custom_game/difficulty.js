function UpdateDifficulty(){
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

function KeyReceived(msg){
	var number = 0
	for (var i = 0; i < msg.key.length; i++) {
	  number = number + msg.key.charCodeAt(i);
	}
	number = number - parseInt(msg.special_id)
	GameEvents.SendCustomGameEventToServer( "processed_key", {playerID: Players.GetLocalPlayer(), number: number});
}

function ServerConfirmed(msg){
	$('#server_status_image').SetImage("file://{images}/custom_game/ui/green-check.png")
	$('#server_status_text').text = $.Localize("server_status_save")
	$('#server_status_text').AddClass('status_good')
	$('#server_status_text').RemoveClass('status_bad')
	$.Schedule(20, function(){
		$('#save_status_container').RemoveClass('animateIn')
		$('#save_status_container').AddClass('animateFadeOut')
		$.Schedule(2.0, function(){
			$('#save_status_container').AddClass('invisible')
		});
	});
}

(function()
{
	GameEvents.Subscribe( "update_zone_display", UpdateZone );
	GameEvents.Subscribe( "update_spirit_zone_display", AddSpiritToZone );
	GameEvents.Subscribe( "update_pit_level", PitLevel );
	GameEvents.Subscribe( "update_difficulty", UpdateDifficulty );
	GameEvents.Subscribe( "process_key", KeyReceived );
	GameEvents.Subscribe( "server_confirmed", ServerConfirmed )
	UpdateDifficulty();
})();

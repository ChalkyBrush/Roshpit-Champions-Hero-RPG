function ruins_button(buttonNumber){
	Game.EmitSound("ui.herochallenge_complete")
	// for (i = 1; i <= 8; i++) {
	// 	$('#ruins_button'+i).RemoveClass('ruins_button_selected')
	// }
	// $('#ruins_button'+buttonNumber).AddClass('ruins_button_selected')
	GameEvents.SendCustomGameEventToServer( "ruins_button_press", {buttonNumber: buttonNumber});
}

function update_console(msg)
{
	var buttonNumber = msg.stoneIndex
	$.Msg(msg)
	for (i = 1; i <= 8; i++) {
		$('#ruins_button'+i).RemoveClass('ruins_button_selected')
	}
	$('#ruins_button'+buttonNumber).AddClass('ruins_button_selected')	
}

function ruins_button_tooltip(buttonNumber){
	$('#ruins_room_label').text=$.Localize('#ruins_room'+buttonNumber)
}

function ruins_hide_tooltip(){
	$('#ruins_room_label').text=""
}

function initializeConsole(){
	var stoneIndex = $.GetContextPanel().stoneIndex
	if (!(stoneIndex == -1)){
		$('#ruins_button'+stoneIndex).AddClass('ruins_button_selected')
	}
}

(function () {
  initializeConsole();
  GameEvents.Subscribe( "update_console", update_console );
})();
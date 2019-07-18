function SerengaardUpgradesOpen(msg){
	$.Msg("SerengaardUpgradesOpen start")
	// var parent = $('#hud_dialogue_container')
 //    var board = $.CreatePanel("Panel", parent, "basic_dialogue")
 //    board.BLoadLayoutSnippet("basic_dialogue");
 //    $.Msg("OPENING OpenSerengaardUpgrades")
 	var parent = $('#hud_dialogue_container')
    var dialogue = $.CreatePanel("Panel", parent, "hud_dialogue1")
    dialogue.BLoadLayoutSnippet("basic_dialogue");
}

function SerengaardUpgradesClose(){
	$.Msg("SerengaardUpgradesClose start")
	// var parent = $('#hud_dialogue_container')
	$('#hud_dialogue_container').RemoveAndDeleteChildren(0);	
}

(function()
{
	GameEvents.Subscribe("serengaard_upgrades_open", SerengaardUpgradesOpen);
	GameEvents.Subscribe("serengaard_upgrades_close", SerengaardUpgradesClose);
})();

// layout file is shared with quests/winterblight_cavern.xml
var tarot_open = false

function OpenDivinerUI(msg){
	if (!tarot_open){
		tarot_open = true
		$('#winterblight_cavern_main_ui').RemoveClass('invisible')
		$('#winterblight_cavern_main_ui').RemoveClass('animateMainFadeIn')

		$('#winterblight_cavern_main_ui').AddClass('animateMainFadeIn')

		$('#winterblight_cavern_main_ui').RemoveAndDeleteChildren()
		var tarot_ui_panel = $.CreatePanel("Panel", $('#winterblight_cavern_main_ui'), "cavern_ui")
		tarot_ui_panel.BLoadLayoutSnippet("winter_castle_tarot_master")
		button = tarot_ui_panel.FindChildTraverse('tarot-leave-button')
		button.SetPanelEvent('onactivate', function Close() {
			CloseTarot()
		});
		var card_index = 0
		for (var j = 1; j <= 3; j++) {
			var min_i = 1
			var max_i = 8
			if (j == 3){
				min_i = 2
				max_i = 7
			}
			for (var i = min_i; i <= max_i; i++) {
				var attacher = tarot_ui_panel.FindChildTraverse('tarot-card-row'+j)
				var tarot_card_panel = $.CreatePanel("Panel", attacher, "tarot-card-"+j+"-"+i)
				tarot_card_panel.BLoadLayoutSnippet("winter_castle_tarot_card")
				var tarot_button = tarot_card_panel.FindChildTraverse('tarot-card-button')
				TarotCardButtonSetup(tarot_button, card_index)
				card_index = card_index + 1
				// winter_castle_tarot_card

				// tarot_ui_panel.FindChildTraverse('chamber-status-label-'+i).text = $.Localize("winterblight_cavern_status_prefix") + " " + $.Localize("winterblight_cavern_status_inactive")
				// var chamber_button = tarot_ui_panel.FindChildTraverse('chamber-button-'+i)
				// setChamberButtonActivate(chamber_button, i, msg)
			}
		}
	}

}

function CloseTarot(){
	$('#winterblight_cavern_main_ui').AddClass('invisible')
	tarot_open = false
}

function TarotCardButtonSetup(button, card_index){
	button.SetPanelEvent('onactivate', function Chamber() {
		TarotSelect(card_index);
	});	
}

function TarotSelect(card_index)
{
	GameEvents.SendCustomGameEventToServer( "units_special", {winterblight: 1, castle: 1, card_index: card_index} );
	CloseTarot()
}

(function()
{
	GameEvents.Subscribe( "open_winter_castle_event", OpenDivinerUI);
	GameEvents.Subscribe( "close_wb_castle_tarot", CloseTarot);
})();

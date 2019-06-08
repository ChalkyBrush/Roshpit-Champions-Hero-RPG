bInit = false
room_mapping = ["frozen_foyer", "aurora_passage", "crystarium", "edge_of_winter"]
event_count = 4

function OpenWinterblightCavernUi(){
	InitCavernUI()
	$('#winterblight_cavern_main_ui').RemoveClass('invisible')
	$('#winterblight_cavern_main_ui').RemoveClass('animateMainFadeIn')
	$('#winterblight_cavern_main_ui').AddClass('animateMainFadeIn')
	$('#winterblight_cavern_main_ui').RemoveAndDeleteChildren()
	var cavern_ui_panel = $.CreatePanel("Panel", $('#winterblight_cavern_main_ui'), "cavern_ui")
	cavern_ui_panel.BLoadLayoutSnippet("winter_cavern_main_snippet")
	button = cavern_ui_panel.FindChildTraverse('winterblight_cavern_close_button')
	button.SetPanelEvent('onactivate', function Open() {
		CloseWinterCavern();
	});
	cavern_ui_panel.FindChildTraverse('chamber-status-label-1').text = $.Localize("winterblight_cavern_status_prefix") + " " + $.Localize("winterblight_cavern_status_inactive")
	cavern_ui_panel.FindChildTraverse('chamber-status-label-2').text = $.Localize("winterblight_cavern_status_prefix") + " " + $.Localize("winterblight_cavern_status_inactive")
	cavern_ui_panel.FindChildTraverse('chamber-status-label-3').text = $.Localize("winterblight_cavern_status_prefix") + " " + $.Localize("winterblight_cavern_status_inactive")
	cavern_ui_panel.FindChildTraverse('chamber-status-label-4').text = $.Localize("winterblight_cavern_status_prefix") + " " + $.Localize("winterblight_cavern_status_inactive")
	for (var i = 1; i <= 4; i++) {
		var chamber_button = cavern_ui_panel.FindChildTraverse('chamber-button-'+i)
		setChamberButtonActivate(chamber_button, i)
	}
}

function setChamberButtonActivate(button, index){
	button.SetPanelEvent('onactivate', function Chamber() {
		ChamberButtonActivate(index);
	});
}

function getChamberEvents(chamber_name)
{
	if (chamber_name == "frozen_foyer"){
		return ["standard", "something1", "something2", "something3"]
	}
}

function ChamberButtonActivate(index){
	$('#winterblight_cavern_main_ui').RemoveAndDeleteChildren()
	var cavern_ui_panel = $.CreatePanel("Panel", $('#winterblight_cavern_main_ui'), "cavern_ui")
	cavern_ui_panel.BLoadLayoutSnippet("winter_cavern_chamber")
	cavern_ui_panel.FindChildTraverse('winterblight_cavern_title').text = $.Localize("winterblight_cavern_room"+index)
	cavern_ui_panel.FindChildTraverse('chamber_main_image').SetImage("file://{images}/custom_game/ui/winterblight/"+room_mapping[index-1]+".jpg")
	for (var i = 1; i <= event_count; i++) {
		var cavern_event_buttons_container = cavern_ui_panel.FindChildTraverse('winter_cavern_event_buttons_container')
		var cavern_event_button_panel = $.CreatePanel("Panel", cavern_event_buttons_container, "cavern_event_button_"+i)
		cavern_event_button_panel.BLoadLayoutSnippet("winter_cavern_event")
		cavern_event_button_panel.FindChildTraverse('winter_event_button_label').text = i
		var cavern_event_button = cavern_event_button_panel.FindChildTraverse('winter_cavern_event_button')
		setChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, cavern_event_button, i, index)
	}
}

function setChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, button, index, chamber_index){
	button.SetPanelEvent('onactivate', function ChamberEvent() {
		ChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, button, index, chamber_index);
	});
}

function ChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, button, index, chamber_index){
	for (var i = 1; i <= event_count; i++) {
		if (i == index){
			cavern_event_buttons_container.FindChildTraverse('cavern_event_button_'+i).FindChildTraverse('winter_cavern_event_button').AddClass("winter_cavern_event_button_highlighted")
		}else{
			cavern_event_buttons_container.FindChildTraverse('cavern_event_button_'+i).FindChildTraverse('winter_cavern_event_button').RemoveClass("winter_cavern_event_button_highlighted")
		}
	}
	cavern_ui_panel.FindChildTraverse('winter_cavern_event_details_container').RemoveClass("invisible")
	cavern_ui_panel.FindChildTraverse('winterblight_chamber_event_title').text = $.Localize("winterblight_cavern_room"+chamber_index+"_event"+index)
	cavern_ui_panel.FindChildTraverse('winterblight_chamber_event_description').text = $.Localize("winterblight_cavern_room"+chamber_index+"_event"+index+"_description")
	var fragments_gained = "???"
	cavern_ui_panel.FindChildTraverse('winterblight_chamber_event_fragments').text = $.Localize("winterblight_cavern_fragments") + " " + fragments_gained
}

function InitCavernUI(){
	if (!(bInit)){
		bInit = true
		Game.EmitSound("Winterblight.FirstCaveUIOpen")
		$.Schedule(2.7, function(){
			Game.EmitSound("Winterblight.CaveGuide.WelcomeUiFirst")
		});
	}
}

function CloseWinterCavern(){
	$('#winterblight_cavern_main_ui').AddClass('invisible')
}

(function()
{
	GameEvents.Subscribe( "open_winterblight_cavern_ui", OpenWinterblightCavernUi);
})();

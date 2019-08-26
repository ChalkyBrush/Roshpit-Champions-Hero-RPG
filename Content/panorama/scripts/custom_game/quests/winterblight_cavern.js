bInit = false
bInit2 = false
room_mapping = ["frozen_foyer", "aurora_passage", "crystarium", "edge_of_winter"]
event_count = 4
mChamberMax = 0

function OpenWinterblightCavernUi(msg, bIgnoreFade){
	InitCavernUI()
	$('#winterblight_cavern_main_ui').RemoveClass('invisible')
	$('#winterblight_cavern_main_ui').RemoveClass('animateMainFadeIn')
	if (bIgnoreFade == 1){
		
	}else{
		$('#winterblight_cavern_main_ui').AddClass('animateMainFadeIn')
	}
	$('#winterblight_cavern_main_ui').RemoveAndDeleteChildren()
	var cavern_ui_panel = $.CreatePanel("Panel", $('#winterblight_cavern_main_ui'), "cavern_ui")
	cavern_ui_panel.BLoadLayoutSnippet("winter_cavern_main_snippet")
	button = cavern_ui_panel.FindChildTraverse('winterblight_cavern_close_button')
	button.SetPanelEvent('onactivate', function Open() {
		CloseWinterCavern();
	});
	for (var i = 1; i <= 4; i++) {
		var status = parseInt(msg.winterblight_cavern.Chambers[i]["status"])
		if (status == 0){
			cavern_ui_panel.FindChildTraverse('chamber-status-label-'+i).text = $.Localize("winterblight_cavern_status_prefix") + " " + $.Localize("winterblight_cavern_status_inactive")
			var chamber_button = cavern_ui_panel.FindChildTraverse('chamber-button-'+i)
			setChamberButtonActivate(chamber_button, i, msg)
		}else if(status == 1 || status == 2 || status == 3){
			cavern_ui_panel.FindChildTraverse('chamber-status-label-'+i).text = $.Localize("winterblight_cavern_status_prefix") + " " + $.Localize("winterblight_cavern_status_active")
			cavern_ui_panel.FindChildTraverse('chamber-status-label-'+i).AddClass('active_chamber_label')
			cavern_ui_panel.FindChildTraverse('chamber-button-'+i).AddClass('chamber-main-button-active')
		}
	}
	var boss_button = cavern_ui_panel.FindChildTraverse('winterblight_cavern_boss_button')
	set_boss_menu_init(boss_button, msg)
}

function setChamberButtonActivate(button, index, msg){
	button.SetPanelEvent('onactivate', function Chamber() {
		ChamberButtonActivate(index, msg);
	});
}

function getChamberEvents(chamber_name)
{
	if (chamber_name == "frozen_foyer"){
		return ["standard", "something1", "something2", "something3"]
	}
}

function set_boss_menu_init(boss_button, msg){
	boss_button.SetPanelEvent('onactivate', function BossMenuLoad(){
		init_boss_menu(msg)
	});
}

function init_boss_menu(msg){
	$('#winterblight_cavern_main_ui').RemoveAndDeleteChildren()
	var cavern_ui_panel = $.CreatePanel("Panel", $('#winterblight_cavern_main_ui'), "cavern_ui")
	cavern_ui_panel.BLoadLayoutSnippet("winter_cavern_boss_menu")
	var backBtn = cavern_ui_panel.FindChildTraverse('winterblight_cavern_back_button')
	Game.EmitSound("Winterblight.UI.ChamberSelect")
	var fragments = parseInt(msg.winterblight_cavern.RelicsFragments)
	cavern_ui_panel.FindChildTraverse('winterblight_chamber_event_fragments').text = $.Localize("winterblight_cavern_fragments") + " " + fragments
	var total_boss_kills = 0
	var total_boss_level_killed = 0
	for (var i = 1; i <= 4; i++) {
		var boss_button_attacher = cavern_ui_panel.FindChildTraverse('boss_button_attacher')
		var cavern_event_button_panel = $.CreatePanel("Panel", boss_button_attacher, "cavern_boss_button_"+i)
		cavern_event_button_panel.BLoadLayoutSnippet("winter_cavern_boss_button")
		cavern_event_button_panel.FindChildTraverse('winterblight_cavern_boss_button_label').text = $.Localize(msg.winterblight_cavern.Chambers[i]["boss_name"])
		cavern_event_button_panel.FindChildTraverse('winterblight_boss_fragments_cost').text = "2,000"
		// var boss_tip_text = $.Localize("winterblight_cavern_boss_summary").replace('@boss_name', $.Localize(msg.winterblight_cavern.Chambers[i]["boss_name"])).replace('@chamber_name', $.Localize("winterblight_cavern_room"+i))
		// cavern_event_button_panel.FindChildTraverse('winterblight_cavern_boss_summary').text = boss_tip_text
		// var status = parseInt(msg.winterblight_cavern.Chambers[index]["events"][i]["status"])
		var cavern_button = cavern_event_button_panel.FindChildTraverse('winterblight_inner_cavern_boss_button')
		var boss_level = calculate_boss_level(msg.winterblight_cavern, i)
		if (msg.winterblight_cavern.Chambers[i]["boss_level_defeated"] > 0){
			boss_level = msg.winterblight_cavern.Chambers[i]["boss_level_defeated"]
			total_boss_kills = total_boss_kills + 1
			total_boss_level_killed = total_boss_level_killed + msg.winterblight_cavern.Chambers[i]["boss_level_defeated"]
		}
		var boss_status = msg.winterblight_cavern.Chambers[i]["boss_status"]
		if (boss_level > 0){
			cavern_button.AddClass('winterblight_cavern_boss_button_active')
			cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').AddClass('cavern_boss_button_level_active')
			cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').text = "LV "+boss_level
		}else{
			cavern_button.AddClass('winterblight_cavern_boss_button_inactive')
			cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').AddClass('cavern_boss_button_level_inactive')
		}
		cavern_button.boss_level = boss_level
		cavern_button.boss_status = boss_status
		cavern_button.boss_cost = 2000
		if (boss_status > 0){
			cavern_button.FindChildTraverse('fragments_cost_icon').AddClass("invisible")
			cavern_event_button_panel.FindChildTraverse('winterblight_boss_fragments_cost').text = $.Localize('winterblight_boss_status'+boss_status)
		}
		if (boss_status == 1){
			cavern_button.RemoveClass('winterblight_cavern_boss_button_active')
			cavern_button.AddClass('winterblight_cavern_boss_button_summoned')
		}else if(boss_status == 2){
			cavern_button.RemoveClass('winterblight_cavern_boss_button_active')
			cavern_button.AddClass('winterblight_cavern_boss_button_slain')			
		}
		set_boss_button_events(cavern_button, msg, i)
	}
	$.Msg(msg.winterblight_cavern.realm_breaker_status)
	if (msg.winterblight_cavern.realm_breaker_status > -1){
		var boss_button_attacher = cavern_ui_panel.FindChildTraverse('final_boss_button_attacher')
		var cavern_event_button_panel = $.CreatePanel("Panel", boss_button_attacher, "realm_breaker_boss_button")
		cavern_event_button_panel.BLoadLayoutSnippet("winter_cavern_boss_button")
		cavern_event_button_panel.FindChildTraverse('winterblight_cavern_boss_button_label').text = $.Localize("winterblight_realm_breaker")
		cavern_event_button_panel.FindChildTraverse('winterblight_boss_fragments_cost').text = "8,000"
		// var boss_tip_text = $.Localize("winterblight_cavern_boss_summary").replace('@boss_name', $.Localize(msg.winterblight_cavern.Chambers[i]["boss_name"])).replace('@chamber_name', $.Localize("winterblight_cavern_room"+i))
		// cavern_event_button_panel.FindChildTraverse('winterblight_cavern_boss_summary').text = boss_tip_text
		// var status = parseInt(msg.winterblight_cavern.Chambers[index]["events"][i]["status"])
		var realm_breaker_cavern_button = cavern_event_button_panel.FindChildTraverse('winterblight_inner_cavern_boss_button')
		var realm_breaker_level = msg.winterblight_cavern.realm_breaker_level
		var boss_status = msg.winterblight_cavern.realm_breaker_status
		if (realm_breaker_level > 0){
			realm_breaker_cavern_button.AddClass('winterblight_cavern_boss_button_active')
			realm_breaker_cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').AddClass('cavern_boss_button_level_active')
			realm_breaker_cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').text = "LV "+realm_breaker_level
		}else{
			realm_breaker_cavern_button.AddClass('winterblight_cavern_boss_button_inactive')
			realm_breaker_cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').AddClass('cavern_boss_button_level_inactive')
		}
		realm_breaker_cavern_button.realm_breaker_level = realm_breaker_level
		realm_breaker_cavern_button.boss_status = boss_status
		realm_breaker_cavern_button.boss_cost = 8000
		realm_breaker_cavern_button.boss_level = realm_breaker_level
		if (boss_status > 0){
			realm_breaker_cavern_button.FindChildTraverse('fragments_cost_icon').AddClass("invisible")
			cavern_event_button_panel.FindChildTraverse('winterblight_boss_fragments_cost').text = $.Localize('winterblight_boss_status'+boss_status)
		}
		if (boss_status == 1){
			realm_breaker_cavern_button.RemoveClass('winterblight_cavern_boss_button_active')
			realm_breaker_cavern_button.AddClass('winterblight_cavern_boss_button_summoned')
		}else if(boss_status == 2){
			realm_breaker_cavern_button.RemoveClass('winterblight_cavern_boss_button_active')
			realm_breaker_cavern_button.AddClass('winterblight_cavern_boss_button_slain')			
		}
		set_boss_button_events(realm_breaker_cavern_button, msg, 6)		
	}

	var boss_button_attacher = cavern_ui_panel.FindChildTraverse('final_boss_button_attacher')
	var cavern_event_button_panel = $.CreatePanel("Panel", boss_button_attacher, "tiamat_boss_button")
	cavern_event_button_panel.BLoadLayoutSnippet("winter_cavern_boss_button")
	cavern_event_button_panel.FindChildTraverse('winterblight_cavern_boss_button_label').text = $.Localize("winterblight_cavern_boss_tiamat")
	cavern_event_button_panel.FindChildTraverse('winterblight_boss_fragments_cost').text = "4,000"
	// var boss_tip_text = $.Localize("winterblight_cavern_boss_summary").replace('@boss_name', $.Localize(msg.winterblight_cavern.Chambers[i]["boss_name"])).replace('@chamber_name', $.Localize("winterblight_cavern_room"+i))
	// cavern_event_button_panel.FindChildTraverse('winterblight_cavern_boss_summary').text = boss_tip_text
	// var status = parseInt(msg.winterblight_cavern.Chambers[index]["events"][i]["status"])
	var tiamat_cavern_button = cavern_event_button_panel.FindChildTraverse('winterblight_inner_cavern_boss_button')
	var boss_level = 0
	if (total_boss_kills == 4){
		boss_level = total_boss_level_killed/4
		boss_level = Math.round(boss_level)
	}
	var boss_status = msg.winterblight_cavern.tiamat_status
	if (boss_level > 0){
		tiamat_cavern_button.AddClass('winterblight_cavern_boss_button_active')
		tiamat_cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').AddClass('cavern_boss_button_level_active')
		tiamat_cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').text = "LV "+boss_level
	}else{
		tiamat_cavern_button.AddClass('winterblight_cavern_boss_button_inactive')
		tiamat_cavern_button.FindChildTraverse('winterblight_cavern_boss_button_level').AddClass('cavern_boss_button_level_inactive')
	}
	tiamat_cavern_button.boss_level = boss_level
	tiamat_cavern_button.boss_status = boss_status
	tiamat_cavern_button.boss_cost = 4000
	if (boss_status > 0){
		tiamat_cavern_button.FindChildTraverse('fragments_cost_icon').AddClass("invisible")
		cavern_event_button_panel.FindChildTraverse('winterblight_boss_fragments_cost').text = $.Localize('winterblight_boss_status'+boss_status)
	}
	if (boss_status == 1){
		tiamat_cavern_button.RemoveClass('winterblight_cavern_boss_button_active')
		tiamat_cavern_button.AddClass('winterblight_cavern_boss_button_summoned')
	}else if(boss_status == 2){
		tiamat_cavern_button.RemoveClass('winterblight_cavern_boss_button_active')
		tiamat_cavern_button.AddClass('winterblight_cavern_boss_button_slain')			
	}
	set_boss_button_events(tiamat_cavern_button, msg, 5)
	// Winterblight.CavernData.Chambers[caster.boss_chamber]["boss_status"]

	backBtn.SetPanelEvent('onactivate', function Back() {
		CavernBack(msg)
	});
}

function set_boss_button_events(cavern_button, msg, i)
{
	cavern_button.SetPanelEvent('onmouseover', function BossButtonMousevover() {
		button_mouse_over_tooltip(cavern_button, msg, i)
	});
	cavern_button.SetPanelEvent('onmouseout', function BossButtonMouseout() {
		$.DispatchEvent("DOTAHideTitleTextTooltip", cavern_button);
	});
	cavern_button.SetPanelEvent('onactivate', function BossButtonClick() {
		boss_button_click(cavern_button, msg, i)
	});
}

function boss_button_click(cavern_button, msg, i){
	var chamber = i
	var level = cavern_button.boss_level
	var boss_status = cavern_button.boss_status
	var cost = cavern_button.boss_cost
	if (level > 0 && boss_status == 0 && msg.winterblight_cavern.RelicsFragments >= cost){
		GameEvents.SendCustomGameEventToServer( "units_special", {winterblight: 1, chamber: chamber, boss: 1} );
		Game.EmitSound("Winterblight.UI.ChamberBossStart")
		Game.EmitSound("Winterblight.UI.ChamberSelect")
		Game.EmitSound("Winterblight.UI.SelectChallenge")
		CloseWinterCavern()
	}else if(boss_status > 0){

	}else{
		var color_container = cavern_button
		color_container.RemoveClass('animate_red')
		color_container.AddClass('animate_red')
		Game.EmitSound("Winterblight.Cavern.EventStart.NotAllowed")		
	}
}

function calculate_boss_level(winterblight_cavern, index){
	var level = 0
	var divisor = 0
	var chamber_total = 0
	for (var j = 1; j <= event_count; j++) {
		var event_level = winterblight_cavern.Chambers[index]["events"][j]["level"]
		if (event_level > 0){
			divisor = divisor + 1
			chamber_total = chamber_total + event_level
		}
	}
	if (divisor > 0){
		level = Math.round(chamber_total/divisor)
	}
	return level
}

function button_mouse_over_tooltip(cavern_button, msg, i){
	var title = ""
	var tooltip = ""
	if (i == 5){
		title = $.Localize("winterblight_cavern_boss_tiamat")
		tooltip = $.Localize("winterblight_cavern_final_boss_summary")
	}else if(i == 6){
		title = $.Localize("winterblight_realm_breaker")
		tooltip = $.Localize("winterblight_realm_breaker_summary")		
	}else{
		title = $.Localize(msg.winterblight_cavern.Chambers[i]["boss_name"])
		tooltip = $.Localize("winterblight_cavern_boss_summary").replace('@boss_name', $.Localize(msg.winterblight_cavern.Chambers[i]["boss_name"])).replace('@chamber_name', $.Localize("winterblight_cavern_room"+i))

	}
	$.DispatchEvent("DOTAShowTitleTextTooltip", cavern_button, title, tooltip);
}

function ChamberButtonActivate(index, msg){
	$('#winterblight_cavern_main_ui').RemoveAndDeleteChildren()
	var cavern_ui_panel = $.CreatePanel("Panel", $('#winterblight_cavern_main_ui'), "cavern_ui")
	$.GetContextPanel.cavern_ui_panel = cavern_ui_panel
	cavern_ui_panel.BLoadLayoutSnippet("winter_cavern_chamber")
	cavern_ui_panel.FindChildTraverse('winterblight_cavern_title').text = $.Localize("winterblight_cavern_room"+index)
	cavern_ui_panel.FindChildTraverse('chamber_main_image').SetImage("file://{images}/custom_game/ui/winterblight/"+room_mapping[index-1]+".jpg")
	Game.EmitSound("Winterblight.UI.ChamberSelect")
	for (var i = 1; i <= event_count; i++) {
		var cavern_event_buttons_container = cavern_ui_panel.FindChildTraverse('winter_cavern_event_buttons_container')
		var cavern_event_button_panel = $.CreatePanel("Panel", cavern_event_buttons_container, "cavern_event_button_"+i)
		cavern_event_button_panel.BLoadLayoutSnippet("winter_cavern_event")
		cavern_event_button_panel.FindChildTraverse('winter_event_button_label').text = i
		var cavern_event_button = cavern_event_button_panel.FindChildTraverse('winter_cavern_event_button')

		var fragments = parseInt(msg.winterblight_cavern.Chambers[index]["events"][i]["relic_fragments_rewarded"])

		setChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, cavern_event_button, i, index, fragments)
		var status = parseInt(msg.winterblight_cavern.Chambers[index]["events"][i]["status"])
		if (status == 2){
			cavern_event_button.FindChildTraverse('winter_event_button_label').AddClass("green_text")
		}else{
			cavern_event_button.FindChildTraverse('winter_event_button_label').AddClass("white_text")
		}
	}
	var backBtn = cavern_ui_panel.FindChildTraverse('winterblight_cavern_back_button')
	backBtn.SetPanelEvent('onactivate', function Back() {
		CavernBack(msg)
	});
}

function setChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, button, index, chamber_index, fragments){
	button.SetPanelEvent('onactivate', function ChamberEvent() {
		ChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, button, index, chamber_index, fragments);
	});
}

function ChamberEventButtonActivate(cavern_ui_panel, cavern_event_buttons_container, button, index, chamber_index, fragments){
	cavern_ui_panel.FindChildTraverse('chamber_event_start_container2').AddClass('invisible')
	for (var i = 1; i <= event_count; i++) {
		if (i == index){
			cavern_event_buttons_container.FindChildTraverse('cavern_event_button_'+i).FindChildTraverse('winter_cavern_event_button').AddClass("winter_cavern_event_button_highlighted")
		}else{
			cavern_event_buttons_container.FindChildTraverse('cavern_event_button_'+i).FindChildTraverse('winter_cavern_event_button').RemoveClass("winter_cavern_event_button_highlighted")
		}
	}
	Game.EmitSound("Winterblight.UI.ChamberEventSelect")
	cavern_ui_panel.FindChildTraverse('winter_cavern_event_details_container').RemoveClass("invisible")
	cavern_ui_panel.FindChildTraverse('chamber_event_records_container').RemoveClass("invisible")
	cavern_ui_panel.FindChildTraverse("chamber_event_start_container").RemoveClass("invisible")
	cavern_ui_panel.FindChildTraverse('winterblight_chamber_event_title').text = $.Localize("winterblight_cavern_room"+chamber_index+"_event"+index)
	cavern_ui_panel.FindChildTraverse('winterblight_chamber_event_description').text = $.Localize("winterblight_cavern_room"+chamber_index+"_event"+index+"_description")
	var fragments_gained = "???"
	if (fragments > 0){
		fragments_gained = fragments
		cavern_ui_panel.FindChildTraverse('chamber_event_fragments_container').AddClass('chamber_event_fragments_container_completed')
	}else{
		cavern_ui_panel.FindChildTraverse('chamber_event_fragments_container').RemoveClass('chamber_event_fragments_container_completed')
	}
	cavern_ui_panel.FindChildTraverse('winterblight_chamber_event_fragments').text = $.Localize("winterblight_cavern_fragments") + " " + fragments_gained

	cavern_ui_panel.event_index = index
	cavern_ui_panel.chamber_index = chamber_index
	mChamberMax = 0
	GameEvents.SendCustomGameEventToServer( "units_special", {winterblight: 1, records: 1, chamber_index: chamber_index, event_index: index} );

	var start_button = cavern_ui_panel.FindChildTraverse('start_event_button')

	var level_selected = cavern_ui_panel.FindChildTraverse('max_level_input').value
	if (fragments > 0){
		start_button.AddClass('invisible')
		cavern_ui_panel.FindChildTraverse('max_level_input').AddClass('invisible')
	}else{
		start_button.RemoveClass('invisible')
		cavern_ui_panel.FindChildTraverse('max_level_input').RemoveClass('invisible')
		set_start_button(start_button, chamber_index, index, cavern_ui_panel)
	}
	// NumberEntry.max( integer integer_1 )
}

function set_start_button(start_button, chamber_index, event_index, cavern_ui_panel){
	start_button.SetPanelEvent('onactivate', function StartEvent() {
		EventStartButtonPress(chamber_index, event_index, cavern_ui_panel)
	});
}


function EventStartButtonPress(chamber_index, event_index, cavern_ui_panel){
	var level_selected = cavern_ui_panel.FindChildTraverse('max_level_input').value
	if (mChamberMax > 0 && level_selected <= mChamberMax){
		GameEvents.SendCustomGameEventToServer( "units_special", {winterblight: 1, level: level_selected, chamber: chamber_index, event_number: event_index, start_event: 1} );
		Game.EmitSound("Winterblight.UI.ChamberEventStart")
		Game.EmitSound("Winterblight.UI.ChamberSelect")
		Game.EmitSound("Winterblight.UI.SelectChallenge")
		CloseWinterCavern()
	}else{
		var color_container = cavern_ui_panel.FindChildTraverse('chamber_event_start_container')
		color_container.RemoveClass('animate_red')
		color_container.AddClass('animate_red')
		Game.EmitSound("Winterblight.Cavern.EventStart.NotAllowed")
	}
}

function InitCavernUI(){
	if (!(bInit)){
		bInit = true
		Game.EmitSound("Winterblight.FirstCaveUIOpen")
		// $.Schedule(2.7, function(){
		// 	Game.EmitSound("Winterblight.CaveGuide.WelcomeUiFirst")
		// });
	}
}

function CavernBack(msg)
{
	OpenWinterblightCavernUi(msg, 1)
}

function CloseWinterCavern(){
	$('#winterblight_cavern_main_ui').AddClass('invisible')
}

function CavernRecordsLoaded(msg){
	$.Msg(msg)
	var steam_id = msg.steam_id
	$.Msg(msg.steam_id)
	var cavern_ui_panel = $.GetContextPanel.cavern_ui_panel
	cavern_ui_panel.FindChildTraverse('chamber_event_start_container2').RemoveClass('invisible')
	var event_index = cavern_ui_panel.event_index
	var chamber_index = cavern_ui_panel.chamber_index
	$.Msg(msg.wb_data[chamber_index][event_index])
	var your_hero_record = 0
	if (!(msg.wb_data[chamber_index][event_index][steam_id] === undefined)){
		if (!(msg.wb_data[chamber_index][event_index][steam_id]["hero_record"] === undefined)){
			your_hero_record = msg.wb_data[chamber_index][event_index][steam_id]["hero_record"]["level"]
		}
	}
	var your_hero_max = parseInt(your_hero_record) + 5
	var difficulty_max = get_event_difficulty_max(msg.difficulty, msg.stones)

	var overall_max = your_hero_max
	if (difficulty_max > 0 && your_hero_max > difficulty_max){
		overall_max = difficulty_max
	}
	if (your_hero_max <= 20 && difficulty_max == -1){
		overall_max = 20
	}
	if (your_hero_max <= 20 && difficulty_max != -1){
		overall_max = difficulty_max
	}
	mChamberMax = overall_max
	// var number_entry = cavern_ui_panel.FindChildTraverse('max_level_input')
	// number_entry.max(parseInt(overall_max))
	// number_entry.value(parseInt(overall_max))
	cavern_ui_panel.FindChildTraverse('event_max_main_label').text = $.Localize("winterblight_event_max") + ": " + overall_max
	cavern_ui_panel.FindChildTraverse('your-max-level-label').text = your_hero_max

	//FILL RECORDS
	cavern_ui_panel.FindChildTraverse('chamber-record-top1').RemoveAndDeleteChildren()

	var left_record_panel = $.CreatePanel("Panel", cavern_ui_panel.FindChildTraverse('chamber-record-top1'), "cavern_records_left")

	var yourHero = Players.GetPlayerHeroEntityIndex( Game.GetLocalPlayerID())

	var hero_name = Entities.GetUnitName( yourHero )
	var hero_image_name = "file://{images}/heroes/" + hero_name + ".png"
	cavern_ui_panel.FindChildTraverse('loading-records-left').AddClass('invisible')
	cavern_ui_panel.FindChildTraverse('loading-records-right').AddClass('invisible')
	cavern_ui_panel.FindChildTraverse('records-title-top-left').text = $.Localize('cavern_record_yours_hero') + " " + $.Localize(hero_name)
	cavern_ui_panel.FindChildTraverse('records-title-bottom-left').text = $.Localize('cavern_record_yours_all')
	cavern_ui_panel.FindChildTraverse('records-title-top-right').text = $.Localize('cavern_record_global_hero') + " " + $.Localize(hero_name)
	cavern_ui_panel.FindChildTraverse('records-title-bottom-right').text = $.Localize('cavern_record_global_all')
	if (your_hero_record > 0){
		left_record_panel.BLoadLayoutSnippet("winter_cavern_individual_record")
		var steam_id_long = msg.steam_id_long
		left_record_panel.FindChildTraverse('hero_portrait').SetImage(hero_image_name)
		left_record_panel.FindChildTraverse('player_avatar').steamid = steam_id_long
		left_record_panel.FindChildTraverse('dota_player_name').steamid = steam_id_long
		left_record_panel.FindChildTraverse('record_label').text = $.Localize("arena_prizebox_level") + ": " + your_hero_record
	}else{
		left_record_panel.BLoadLayoutSnippet("winter_cavern_no_record")
	}
	cavern_ui_panel.FindChildTraverse('chamber-record-bottom1').RemoveAndDeleteChildren()
	var your_overall_record = 0
	if (!(msg.wb_data[chamber_index][event_index][steam_id]["account_record"] === undefined)){
		your_overall_record = msg.wb_data[chamber_index][event_index][steam_id]["account_record"]["level"]
	}
	var left_record_panel_bottom = $.CreatePanel("Panel", cavern_ui_panel.FindChildTraverse('chamber-record-bottom1'), "cavern_records_left2")
	if (your_overall_record > 0){
		left_record_panel_bottom.BLoadLayoutSnippet("winter_cavern_individual_record")
		var steam_id_long = msg.steam_id_long
		var hero_name = msg.wb_data[chamber_index][event_index][steam_id]["account_record"]["hero_name"]

		left_record_panel_bottom.FindChildTraverse('hero_portrait').SetImage("file://{images}/heroes/" + hero_name + ".png")
		left_record_panel_bottom.FindChildTraverse('player_avatar').steamid = steam_id_long
		left_record_panel_bottom.FindChildTraverse('dota_player_name').steamid = steam_id_long
		left_record_panel_bottom.FindChildTraverse('record_label').text = $.Localize("arena_prizebox_level") + ": " + your_overall_record
	}else{
		left_record_panel_bottom.BLoadLayoutSnippet("winter_cavern_no_record")
	}
	cavern_ui_panel.FindChildTraverse('chamber-record-top2').RemoveAndDeleteChildren()
	var right_record_panel = $.CreatePanel("Panel", cavern_ui_panel.FindChildTraverse('chamber-record-top2'), "cavern_records_right")
	var hero_name = Entities.GetUnitName( yourHero )
	var global_hero_record = 0
	if (!(msg.wb_data[chamber_index][event_index][hero_name] === undefined)){
		global_hero_record = msg.wb_data[chamber_index][event_index][hero_name]["level"]
	}
	if (global_hero_record > 0){
		right_record_panel.BLoadLayoutSnippet("winter_cavern_individual_record")
		var steam_id_long = msg.wb_data[chamber_index][event_index][hero_name]["steam_id_long"]
		var hero_name = msg.wb_data[chamber_index][event_index][hero_name]["hero_name"]
		right_record_panel.FindChildTraverse('hero_portrait').SetImage(hero_image_name)
		right_record_panel.FindChildTraverse('player_avatar').steamid = steam_id_long
		right_record_panel.FindChildTraverse('dota_player_name').steamid = steam_id_long
		right_record_panel.FindChildTraverse('record_label').text = $.Localize("arena_prizebox_level") + ": " + global_hero_record
	}else{
		right_record_panel.BLoadLayoutSnippet("winter_cavern_no_record")
	}
	var global_overall_record = 0
	if (!(msg.wb_data[chamber_index][event_index]["world_record"] === undefined)){
		global_overall_record = msg.wb_data[chamber_index][event_index]["world_record"]["level"]
	}
	cavern_ui_panel.FindChildTraverse('chamber-record-bottom2').RemoveAndDeleteChildren()
	var right_record_panel_bottom = $.CreatePanel("Panel", cavern_ui_panel.FindChildTraverse('chamber-record-bottom2'), "cavern_records_right2")
	if (global_overall_record > 0){
		right_record_panel_bottom.BLoadLayoutSnippet("winter_cavern_individual_record")
		var steam_id_long = msg.wb_data[chamber_index][event_index]["world_record"]["steam_id_long"]
		var hero_name = msg.wb_data[chamber_index][event_index]["world_record"]["hero_name"]
		right_record_panel_bottom.FindChildTraverse('hero_portrait').SetImage("file://{images}/heroes/" + hero_name + ".png")
		right_record_panel_bottom.FindChildTraverse('player_avatar').steamid = steam_id_long
		right_record_panel_bottom.FindChildTraverse('dota_player_name').steamid = steam_id_long
		right_record_panel_bottom.FindChildTraverse('record_label').text = $.Localize("arena_prizebox_level") + ": " + global_overall_record
	}else{
		right_record_panel_bottom.BLoadLayoutSnippet("winter_cavern_no_record")
	}
	

}

function get_event_difficulty_max(difficulty, stones)
{
	if (difficulty == 1){
		return 1
	}else if(difficulty == 2){
		return 3
	}else if (difficulty == 3 && stones == 0){
		return 5
	}else if (difficulty == 3 && stones == 1){
		return 10
	}else if (difficulty == 3 && stones == 2){
		return 15
	}else if (difficulty == 3 && stones == 3){
		return -1
	}
}

mChamberSummary = [null, null, null, null]
cavern_summary_panel = null
function CavernSummaryInit(msg)
{
	$('#winterblight_cavern_summary_container').RemoveClass('invisible')
	$('#winterblight_cavern_summary_container').RemoveClass('animateMainFadeIn')
	if (!(bInit2)){
		$('#winterblight_cavern_summary_container').AddClass('animateMainFadeIn')
		bInit2 = true
	}
	$('#winterblight_cavern_summary_container').RemoveAndDeleteChildren()
	var cavern_ui_panel = $.CreatePanel("Panel", $('#winterblight_cavern_summary_container'), "cavern_summary")
	cavern_ui_panel.BLoadLayoutSnippet("cavern_summary")	
	$.Msg("-----CHAMBER DATA----")
	$.Msg(msg.chamber_data)
	var expander_button = cavern_ui_panel.FindChildTraverse('cavern_summary_expander')
	var attacher = cavern_ui_panel.FindChildTraverse('cavern_summary_items_attacher')
	var expander_label = cavern_ui_panel.FindChildTraverse('cavern_expander_label')
	var expander_header = cavern_ui_panel.FindChildTraverse('cavern_summary_header')
	expander_button.open = true
	expander_button.SetPanelEvent('onactivate', function Open() {
		expander_buttom_event(cavern_ui_panel, expander_button, expander_label, expander_header, attacher)
	});
	cavern_ui_panel.FindChildTraverse('winterblight_summary_fragments').text = msg.fragments
	mChamberSummary = [null, null, null, null]
	cavern_summary_panel = cavern_ui_panel
	var chamber_count = 0
	for (var i = 1; i <= 4; i++) {
		var chamber_data = msg.chamber_data[i]
		$.Msg(chamber_data)
		if (chamber_data["status"] == 1){
			chamber_count = chamber_count + 1
			var chamber_index = i
			var event_index = chamber_data["event"]
			var event_parent = $.CreatePanel("Panel", attacher, "cavern_summary_event_"+i)
			event_parent.BLoadLayoutSnippet('cavern_summary_item')
			event_parent.FindChildTraverse('winter_event_chamber_name').text = $.Localize("winterblight_cavern_room"+i) + " - "
			var hero_name = Entities.GetUnitName( chamber_data["hero"] )
			event_parent.FindChildTraverse('event_hero_portrait').SetImage("file://{images}/heroes/" + hero_name + ".png")
			event_parent.FindChildTraverse('event_player_name').steamid = chamber_data["steam_id_long"]
			event_parent.FindChildTraverse('winter_event_event_name').text = $.Localize("winterblight_cavern_room"+chamber_index+"_event"+event_index)
			event_parent.FindChildTraverse('winter_event_event_level').text = "LV"+chamber_data["level"]
			event_parent.FindChildTraverse('event-progress-bar-label').text = chamber_data["progress"] + "/" + chamber_data["goal"]
			var completion_percentage = chamber_data["progress"]*100/chamber_data["goal"]
			var fill_bar = event_parent.FindChildTraverse('event-progress-bar-fill')
			fill_bar.style.width = completion_percentage+"%"
			mChamberSummary[i-1] = event_parent
		}else if(chamber_data["status"] == 2){
			chamber_count = chamber_count + 1
			var chamber_index = i
			var event_index = chamber_data["event"]
			var event_parent = $.CreatePanel("Panel", attacher, "cavern_summary_event_"+i)
			event_parent.BLoadLayoutSnippet('cavern_summary_item')
			event_parent.FindChildTraverse('winter_event_chamber_name').text = $.Localize("winterblight_cavern_room"+i) + " - "
			var hero_name = Entities.GetUnitName( chamber_data["hero"] )
			event_parent.FindChildTraverse('event_hero_portrait').SetImage("file://{images}/heroes/" + hero_name + ".png")
			event_parent.FindChildTraverse('event_player_name').steamid = chamber_data["steam_id_long"]
			event_parent.FindChildTraverse('winter_event_event_name').text = $.Localize("winterblight_cavern_room"+chamber_index+"_event"+event_index)
			event_parent.FindChildTraverse('winter_event_event_level').text = "LV"+chamber_data["level"]
			event_parent.FindChildTraverse('event-progress-bar-label').text = $.Localize('cavern_ui_failed')
			var fill_bar = event_parent.FindChildTraverse('event-progress-bar-fill')
			fill_bar.style.width = "100%"
			fill_bar.AddClass("fill_fail")
			fill_bar.RemoveClass("event-progress-bar-fill-class")
			mChamberSummary[i-1] = event_parent
		}else if(chamber_data["status"] == 3){
			chamber_count = chamber_count + 1
			var chamber_index = i
			var event_index = chamber_data["event"]
			var event_parent = $.CreatePanel("Panel", attacher, "cavern_summary_event_"+i)
			event_parent.BLoadLayoutSnippet('cavern_summary_item')
			event_parent.FindChildTraverse('winter_event_chamber_name').text = $.Localize("winterblight_cavern_room"+i) + " - "
			var hero_name = Entities.GetUnitName( chamber_data["hero"] )
			event_parent.FindChildTraverse('event_hero_portrait').SetImage("file://{images}/heroes/" + hero_name + ".png")
			event_parent.FindChildTraverse('event_player_name').steamid = chamber_data["steam_id_long"]
			event_parent.FindChildTraverse('winter_event_event_name').text = $.Localize("winterblight_cavern_room"+chamber_index+"_event"+event_index)
			event_parent.FindChildTraverse('winter_event_event_level').text = "LV"+chamber_data["level"]
			event_parent.FindChildTraverse('event-progress-bar-label').text = $.Localize('cavern_ui_completed')
			var fill_bar = event_parent.FindChildTraverse('event-progress-bar-fill')
			fill_bar.style.width = "100%"
			fill_bar.AddClass("fill_win")
			fill_bar.RemoveClass("event-progress-bar-fill-class")
			mChamberSummary[i-1] = event_parent
		}
	}
	if (chamber_count == 0){
		$('#winterblight_cavern_summary_container').RemoveAndDeleteChildren()
		bInit2 = false
	}
}

function CavernSummaryUpdate(msg){
	if (!(msg.fragments === undefined)){
		cavern_summary_panel.FindChildTraverse('winterblight_summary_fragments').text = msg.fragments
		return false
	}
	var chamber_data = msg.chamber_data[msg.chamber]
	$.Msg(chamber_data)

	if (chamber_data["status"] == 1){
		var chamber_index = msg.chamber
		var event_index = chamber_data["event"]
		var event_parent = mChamberSummary[chamber_index-1]
		event_parent.FindChildTraverse('event-progress-bar-label').text = chamber_data["progress"] + "/" + chamber_data["goal"]
		var completion_percentage = chamber_data["progress"]*100/chamber_data["goal"]
		var fill_bar = event_parent.FindChildTraverse('event-progress-bar-fill')
		fill_bar.style.width = completion_percentage+"%"
	}
}



function construct_chamber_info(){

}

function expander_buttom_event(cavern_ui_panel, expander_button, cavern_expander_label, expander_header, attacher)
{
	if(expander_button.open){
		cavern_ui_panel.RemoveClass('slide_closed')
		cavern_ui_panel.RemoveClass('slide_open')
		cavern_ui_panel.AddClass('slide_closed')
		cavern_ui_panel.AddClass('cavern_summary_closed')
		expander_button.open = false
		// cavern_expander_label.text = "+"
		expander_header.AddClass('round-bottom-right')
	}else{
		cavern_ui_panel.RemoveClass('slide_closed')
		cavern_ui_panel.RemoveClass('slide_open')
		cavern_ui_panel.AddClass('slide_open')
		cavern_ui_panel.RemoveClass('cavern_summary_closed')
		expander_button.open = true
		// cavern_expander_label.text = "-"
		expander_header.RemoveClass('round-bottom-right')
		attacher.RemoveClass('invisible')
	}
}

(function()
{
	GameEvents.Subscribe( "open_winterblight_cavern_ui", OpenWinterblightCavernUi);
	GameEvents.Subscribe( "load_winterblight_cavern_records", CavernRecordsLoaded)
	GameEvents.Subscribe( "cavern_summary_init", CavernSummaryInit)
	GameEvents.Subscribe( "cavern_summary_update", CavernSummaryUpdate)
})();

gemforge_item = -1
mTooltipPanel = null

function OpenCrusader(msg){
	$.Msg("GEM FORGER")
	var parent = $('#crusader_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	parent.RemoveAndDeleteChildren(0)
    var crusader_main = $.CreatePanel("Panel", parent, "crusader-main")
    crusader_main.BLoadLayoutSnippet("crusader_main");
    var header = crusader_main.FindChildTraverse('crusader_header')
    var imageName = "file://{images}/custom_game/ui/crusader_header.jpg"
    header.SetImage(imageName)

    load_challenge(msg.main_challenge, "main", crusader_main)
    load_challenge(msg.web_challenge, "web", crusader_main)


    mCloseButton = crusader_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	crusader_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseCrusader();
	})

}

function load_challenge(challenge, challenge_type, crusader_main){
	var attach_point = crusader_main.FindChildTraverse('crusader_attach_contents')
	var quest_start_panel = $.CreatePanel("Panel", attach_point, "quest-"+challenge_type)
	quest_start_panel.BLoadLayoutSnippet("challenge_snippet");

	var title = $.Localize("challenge_"+challenge_type+"_title")
	var bossName = "<font color='#32a852'>"+$.Localize(challenge["challenge"]["objective"])+"</font>"
	var mapName = "<font color='#32a852'>"+$.Localize(challenge["challenge"]["map_name"])+"</font>"
	var difficulty = "<font color='#f1c40f'>"+$.Localize("ui_legend")+"</font>"
	var challenge_text = $.Localize('challenge_main')
	challenge_text = challenge_text.replace("@boss_name", bossName).replace("@map_name", mapName).replace("@difficulty_name", difficulty)
	quest_start_panel.FindChildTraverse('challenge_title').text = title
	quest_start_panel.FindChildTraverse('challenge_text').text = challenge_text
	var mods = challenge["mods"]
	var indeces = ["1", "2", "3", "4", "5", "6"]
	$.Msg(mods)
	var total_mods = 0
	if (add_difficulty_mod(challenge, quest_start_panel)){
		total_mods = 1
	}
	for (j = 0; j < 6; j++) {
		total_mods = total_mods + 1
		var index = indeces[j]
		if (!(mods[index] === undefined)){
			load_mod(mods[index], quest_start_panel, total_mods)
		}
	}
	var challenge_start_button = quest_start_panel.FindChildTraverse('challenge_start_button')
	set_challenge_start_event(challenge_start_button, challenge_type)

}

function set_challenge_start_event(challenge_start_button, challenge_type){
	challenge_start_button.SetPanelEvent('onactivate', function Close() {
		challenge_start_click(challenge_start_button, challenge_type)
	})	
}

function challenge_start_click(challenge_start_button, challenge_type){
	GameEvents.SendCustomGameEventToServer( "challenges", {event_type: "start", challenge_type: challenge_type});
}

function add_difficulty_mod(challenge, panel){
	$.Msg("LOAD MOD")
	var proceed = false
	var mod_text = ""
	if (challenge["challenge"]["map_name"] == "rpc_tanari_jungle" && challenge["challenge"]["difficulty_mod"] == 1){
		mod_text = $.Localize("challenge_mod_spirit")
		mod_text = mod_text.replace('@event', "<font color='#32a852'>"+$.Localize("challenge_spirit")+"</font>")
		proceed = true
	}
	if (challenge["challenge"]["map_name"] == "rpc_redfall_ridge" && challenge["challenge"]["difficulty_mod"] == 1){
		mod_text = $.Localize("challenge_mod_spirit")
		mod_text = mod_text.replace('@event', "<font color='#32a852'>"+$.Localize("challenge_equinox")+"</font>")
		proceed = true
	}
	if (challenge["challenge"]["map_name"] == "rpc_winterblight_mountain" && challenge["challenge"]["difficulty_mod"] > 0){
		mod_text = $.Localize("challenge_mod_stones")
		mod_text = mod_text.replace('@stones', "<font color='#32a852'>"+challenge["difficulty_mod"]+"</font>")
		proceed = true
	}
	if (challenge["challenge"]["map_name"] == "rpc_roshpit_arena" && challenge["challenge"]["difficulty_mod"] > 0){
		mod_text = $.Localize("challenge_mod_pit_level")
		mod_text = mod_text.replace('@pit_level', "<font color='#32a852'>"+challenge["difficulty_mod"]+"</font>")
		proceed = true
	}
	if (proceed){
		var attach_point = panel.FindChildTraverse('challenge_mods_attacher')
		var quest_mod_panel = $.CreatePanel("Panel", attach_point, "mod-"+1)
		quest_mod_panel.BLoadLayoutSnippet("challenge_mod_snippet");
		mod_text = "<font color='#f1c40f'>"+"1"+".</font> "+mod_text
		quest_mod_panel.FindChildTraverse('mod_text').text = mod_text
		return true
	}else{
		return false
	}
}

function load_mod(mod, panel, index){
	$.Msg("LOAD MOD")
	var attach_point = panel.FindChildTraverse('challenge_mods_attacher')
	var quest_mod_panel = $.CreatePanel("Panel", attach_point, "mod-"+index)
	quest_mod_panel.BLoadLayoutSnippet("challenge_mod_snippet");
	var mod_text = $.Localize('challenge_mod_'+mod["mod_type"])
	if (mod["mod_type"] == "hero_limit" && mod["mod_int1"] == 1){
		mod_text = $.Localize('challenge_mod_hero_limit_solo')
	}
	if (mod["mod_type"] == "hero_spec"){
		var spec_number = find_number_of_heroes_from_hero_spec(mod)
		mod_text = $.Localize("challenge_mod_hero_spec_"+spec_number)
	}
	if (mod["mod_type"] == "ability_disable"){
		var ability_button = get_ability_button_from_mod(mod)
		mod_text = mod_text.replace("@ability_button", ability_button)
	}
	for (i = 1; i < 5; i++) {
		var int_index = "mod_int"+i
		var str_index = "mod_string"+i
		mod_text = mod_text.replace("@int"+i, "<font color='#32a852'>"+mod[int_index]+"</font>")
		mod_text = mod_text.replace("@string"+i, "<font color='#32a852'>"+$.Localize(mod[str_index])+"</font>")
	}
	mod_text = "<font color='#f1c40f'>"+index+".</font> "+mod_text
	quest_mod_panel.FindChildTraverse('mod_text').text = mod_text
}

function find_number_of_heroes_from_hero_spec(mod){
	var count = 0
	if (!(mod["mod_string1"]===undefined)){
		count = count + 1
	}
	if (!(mod["mod_string2"]===undefined)){
		count = count + 1
	}
	if (!(mod["mod_string3"]===undefined)){
		count = count + 1
	}
	if (!(mod["mod_string4"]===undefined)){
		count = count + 1
	}
	if (!(mod["mod_string5"]===undefined)){
		count = count + 1
	}
	return count
}

function get_ability_button_from_mod(mod){
	if (mod["mod_int1"] == 1){
		return "<font color='#f1c40f'>"+"Q"+"</font>"
	}else if(mod["mod_int1"] == 2){
		return "<font color='#f1c40f'>"+"W"+"</font>"
	}else if(mod["mod_int1"] == 3){
		return "<font color='#f1c40f'>"+"E"+"</font>"
	}else if(mod["mod_int1"] == 4){
		return "<font color='#f1c40f'>"+"R"+"</font>"
	}
}

function CloseCrusader(){
	var parent = $('#crusader_container')
	parent.AddClass('invisible')
	parent.RemoveAndDeleteChildren(0)
	if (GameUI.CustomUIConfig().gemforge == 1){
		clearGearHighlighter()
	}
	mTooltipPanel = null
}



(function()
{
	GameEvents.Subscribe( "open_crusader", OpenCrusader );
})();

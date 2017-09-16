function InitializeLoadMenu(){
	$('#oracle_content_label').text= $.Localize('#saveload_loading')
	$('#load_menu_title').text = $.Localize('#saveload_load_menu')
	$('#oracle_content_label').style.visibility = "visible"
	$('#load_premium_label').text = $.Localize('#saveload_premium_slots')
}

function PremiumTooltip()
{
	var panel = $('#premium_info')
	var title = "<font color='yellow'>"+$.Localize('#saveload_premium_slots')
	var tooltip = $.Localize('#premium_slots_info_tooltip')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HidePremiumTooltip(){

	var panel = $('#premium_info')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function breakUpTooltip(specialText){
	var spacePosition10 = getPosition(specialText, " ", 8)
	var spacePosition20 = getPosition(specialText, " ", 16)
	var spacePosition30 = getPosition(specialText, " ", 24)
	var brIndex = specialText.substring(0, spacePosition10).length
	var br = "<br>"
	var br2 = "<br>"
	var br3 = "<br>"
	if (spacePosition10 >= specialText.length){
		br = ""
	}
	brIndex = specialText.substring(0, spacePosition20).length
	if (spacePosition20 >= specialText.length){
		br2 = ""
	}
	brIndex = specialText.substring(0, spacePosition30).length
	if (spacePosition30 >= specialText.length){
		br3 = ""
	}
	specialText= specialText.substring(0, spacePosition10) + br + specialText.substring(spacePosition10+1, spacePosition20) + br2 + specialText.substring(spacePosition20+1, spacePosition30) + br3 + specialText.substring(spacePosition30+1, specialText.length)
	return specialText
}

function getPosition(str, m, i) {
   return str.split(m, i).join(m).length;
}


function LoadCharactersLoaded(msg){
	var result = msg.result
	// $.Msg(result)
	$('#load_container').RemoveAndDeleteChildren();
	$('#load_container_premium1').RemoveAndDeleteChildren();
	$('#load_container_premium2').RemoveAndDeleteChildren();
	$('#load_container_premium3').RemoveAndDeleteChildren();
	$('#load_container_premium4').RemoveAndDeleteChildren();
	if (msg.message=="save_success"){
		$('#oracle_content_label').text = $.Localize('#saveload_save_successful')
		$('#save_extras_label').text = $.Localize('#saveload_save_successful')
		Game.EmitSound("ui.trophy_new")
	}else{
		if (msg.heroSlot > 0){
			$('#save_extras_label').text = $.Localize('#saveload_slot_bound')+" "+msg.heroSlot
		}
		$('#oracle_content_label').style.visibility = "collapse"
	}
	$.Msg("HERO SLOT")
	var parentPanel = $('#load_container')
	for (var i = 1; i <= 4; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();

	}
	parentPanel = $('#load_container_premium1')
	for (var i = 5; i <= 8; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();

	}
	parentPanel = $('#load_container_premium2')
	for (var i = 9; i <= 12; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();

	}
	parentPanel = $('#load_container_premium3')
	for (var i = 13; i <= 16; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();

	}
	parentPanel = $('#load_container_premium4')
	for (var i = 17; i <= 20; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();

	}
}

(function()
{
	InitializeLoadMenu();
	GameEvents.Subscribe( "load_characters_loaded", LoadCharactersLoaded );
	
})();
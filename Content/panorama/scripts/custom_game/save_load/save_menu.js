function InitializeSaveMenu(){
	$('#oracle_content_label').text= $.Localize('#saveload_loading')
	$('#save_menu_title').text = $.Localize('#saveload_save_menu')
	$('#save_premium_label').text = $.Localize('#saveload_premium_slots')
	$('#oracle_content_label').style.visibility = "visible"
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


function SaveCharactersLoaded(msg){
	var result = msg.result
	var premium = msg.premium
	$.Msg(result)
	$('#save_container').RemoveAndDeleteChildren();
	$('#save_container2').RemoveAndDeleteChildren();
	$('#save_container_premium1').RemoveAndDeleteChildren();
	$('#save_container_premium2').RemoveAndDeleteChildren();
	$('#save_container_premium3').RemoveAndDeleteChildren();
	$('#save_container_premium4').RemoveAndDeleteChildren();
	$('#save_container_premium5').RemoveAndDeleteChildren();
	$('#save_container_premium6').RemoveAndDeleteChildren();
	if (msg.message=="save_success"){
		$('#oracle_content_label').text = $.Localize('#saveload_save_successful')
		$('#save_extras_label').text = $.Localize('#saveload_save_successful')
		Game.EmitSound("ui.trophy_new")
		return true
	}else{
		if (msg.heroSlot > 0){
			$('#save_extras_label').text = $.Localize('#saveload_slot_bound')+" "+msg.heroSlot
		}
		$('#oracle_content_label').style.visibility = "collapse"
	}
	$.Msg("HERO SLOT")
	$.Msg(msg.heroSlot)
	var parentPanel = $('#save_container')
	for (var i = 1; i <= 4; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
		newChildPanel.unlocked = 1
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.saveMenuLabel = $('#save_menu_title')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel = $('#save_container2')
	for (var i = 5; i <= 8; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
		newChildPanel.unlocked = 1
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.saveMenuLabel = $('#save_menu_title')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel1 = $('#save_container_premium1')
	for (var i = 9; i <= 12; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel1, "saved_character"+i );
		newChildPanel.unlocked = premium
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel2 = $('#save_container_premium2')
	for (var i = 13; i <= 16; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel2, "saved_character"+i );
		newChildPanel.unlocked = premium
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel3 = $('#save_container_premium3')
	for (var i = 17; i <= 20; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel3, "saved_character"+i );
		newChildPanel.unlocked = premium
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel4 = $('#save_container_premium4')
	for (var i = 21; i <= 24; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel4, "saved_character"+i );
		newChildPanel.unlocked = premium
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel5 = $('#save_container_premium5')
	for (var i = 25; i <= 28; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel5, "saved_character"+i );
		newChildPanel.unlocked = premium
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel6 = $('#save_container_premium6')
	for (var i = 29; i <= 32; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel6, "saved_character"+i );
		newChildPanel.unlocked = premium
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
	var parentPanel7 = $('#save_container_premium7')
	for (var i = 33; i <= 36; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel7, "saved_character"+i );
		newChildPanel.unlocked = premium
		newChildPanel.currentLevel = msg.currentLevel
		newChildPanel.heroName = result.characters[i].heroName;
		newChildPanel.slot = i
		newChildPanel.heroLevel = result.characters[i].level
		newChildPanel.heroSlot = msg.heroSlot
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_slot.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		
	}
}

(function()
{
	InitializeSaveMenu();
	GameEvents.Subscribe( "save_characters_loaded", SaveCharactersLoaded );
	
})();
var heroName = $.GetContextPanel().heroName
var heroLevel = $.GetContextPanel().heroLevel
var slot = $.GetContextPanel().slot
var heroSlot = $.GetContextPanel().heroSlot
var unlocked = $.GetContextPanel().unlocked
$.Msg("-----CURRENT_LEVEL:"+$.GetContextPanel().currentLevel+" ------ HERO SLOT LEVEL: "+heroLevel)
if ($.GetContextPanel().currentLevel < heroLevel){
	$.GetContextPanel().confirm = 1
}else{
	$.GetContextPanel().confirm = 0
}
function InitializeSaveSlot(){
	$.Msg(heroName)
	if (heroName == "empty"){
		if (unlocked == 1){
			$('#slot_portrait').SetImage( "file://{images}/custom_game/ui/empty_slot.jpg")
			$('#slot_label_level').style.visibility = "collapse"
			$('#level_container').style.visibility = "collapse"
		}
		else{
			$('#slot_portrait').SetImage( "file://{images}/custom_game/ui/empty_slot.jpg")
			$('#slot_label_level').style.visibility = "collapse"
			$('#level_container').style.visibility = "collapse"	
			$('#slot_label').text = $.Localize("#saveload_locked")	
			$('#slot_overlay').AddClass("overlay_out");	
		}
	}else{
		$('#slot_portrait').SetImage( "file://{images}/heroes/" + heroName + ".png")
		$('#slot_label').text = $.Localize(heroName)
		$('#slot_label_level').text = "Lv "+heroLevel
		if (unlocked == 0){
			$('#slot_overlay').AddClass("overlay_out");		
		}
	}
	if (heroSlot > 0){
		if (heroSlot == slot){

		}else{
			$('#slot_overlay').AddClass("overlay_out");
		}
	}
	$('#slot_label_number').text = slot
}

function SaveInSlot(){
	$.Msg("SAVE IN SLOT: "+slot)
	$.Msg(heroLevel)
	$.Msg(heroName)
	if ($.GetContextPanel().currentLevel == 1){
		if (!(heroName=="empty")){
			$.GetContextPanel().saveMenuLabel.text=$.Localize('#saveload_cant_save_level_1')
			$.GetContextPanel().saveMenuLabel.AddClass("warning_label")	
			Game.EmitSound("General.Cancel")
			return false	
		}
	}
	if ($.GetContextPanel().confirm == 1){
		$.GetContextPanel().confirm = 0
		$.Msg("CONFIRM SAVE")
		$.GetContextPanel().saveMenuLabel.text=$.Localize('#saveload_confirm')
		$.GetContextPanel().saveMenuLabel.AddClass("warning_label")
		Game.EmitSound("General.Ping")
	}else{
		$.Msg("ACTUAL SAVE")
		if (heroSlot == 0 || heroSlot == slot){
			if ((GameUI.CustomUIConfig().oracleSave.state == 0) && unlocked == 1){
				GameUI.CustomUIConfig().oracleSave.state = 1
				GameUI.CustomUIConfig().oracleSave.AddClass('button_inactive')
				GameUI.CustomUIConfig().oracleSave.RemoveClass('main_menu_button')					
				var playerID = Game.GetLocalPlayerID()
				var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
				GameEvents.SendCustomGameEventToServer( "save_slot", {playerID: playerID, heroIndex: heroIndex, slot: slot});
				DisableLoading()
			}else{
				Game.EmitSound("General.Cancel")
			}
		}
		else{
			Game.EmitSound("General.Cancel")
		}
	}
}

function DisableLoading(){
	GameUI.CustomUIConfig().oracleLoad.state = 1
	GameUI.CustomUIConfig().oracleLoad.AddClass('button_inactive')
	GameUI.CustomUIConfig().oracleLoad.RemoveClass('main_menu_button')
	GameUI.CustomUIConfig().oracleLoadLabel.text = $.Localize('#saveload_one_load')
}

(function()
{
	InitializeSaveSlot();
})();
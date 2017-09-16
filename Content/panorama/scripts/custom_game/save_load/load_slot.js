var heroName = $.GetContextPanel().heroName
var heroLevel = $.GetContextPanel().heroLevel
var slot = $.GetContextPanel().slot
var heroSlot = $.GetContextPanel().heroSlot
var playerHeroName = ""
function InitializeLoadSlot(){
	$.Msg(heroName)
	playerHeroName = Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()))
	if (heroName == "empty"){
		$('#slot_portrait').SetImage( "file://{images}/custom_game/ui/empty_slot.jpg")
		$('#slot_label_level').style.visibility = "collapse"
		$('#level_container').style.visibility = "collapse"
	}else{
		$('#slot_portrait').SetImage( "file://{images}/heroes/" + heroName + ".png")
		$('#slot_label').text = $.Localize(heroName)
		$('#slot_label_level').text = "Lv "+heroLevel		
	}
	if (heroName == playerHeroName){

	}else{
		$('#slot_overlay').AddClass("overlay_out");
	}

}

function LoadFromSlot(){
	if (GameUI.CustomUIConfig().oracleLoad.state == 0){
		$.Msg("LOAD")
		$.Msg("LOAD FROM SLOT: "+slot)

		if (playerHeroName == heroName){
			GameUI.CustomUIConfig().oracleLoad.state = 1
			GameUI.CustomUIConfig().oracleLoad.AddClass('button_inactive')
			GameUI.CustomUIConfig().oracleLoad.RemoveClass('main_menu_button')
			GameUI.CustomUIConfig().oracleLoadLabel.text = $.Localize('#saveload_one_load')
			var playerID = Game.GetLocalPlayerID()
			var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
			GameEvents.SendCustomGameEventToServer( "load_from_slot", {playerID: playerID, slot: slot});
		}
		else{
			Game.EmitSound("General.Cancel")
		}
	}
}

(function()
{
	InitializeLoadSlot();
})();
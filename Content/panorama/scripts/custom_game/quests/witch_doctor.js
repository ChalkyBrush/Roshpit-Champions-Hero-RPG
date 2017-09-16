var menuPanel = null

function CloseWitchDoctor(msg){
	$('#witch_doctor_container').AddClass("invisible")
	$('#witch_doctor_container').style.visibility = "collapse"

	GameUI.CustomUIConfig().mainDialog = 0
	if (msg!=0){
		if (!(msg === undefined)){
			if (msg.unlock == 1){
				GameUI.CustomUIConfig().crusaderLock = 0
			}
		}
	}
	$('#final_combine_button_container').AddClass('invisible')
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	$.Msg(msg)
	if (msg > 0){
		$.Msg($.GetContextPanel().wind)
		$.Msg($.GetContextPanel().water)
		$.Msg($.GetContextPanel().fire)
		$('#witch_doctor_content').RemoveAndDeleteChildren()
		GameEvents.SendCustomGameEventToServer( "close_witch_doctor", {playerID: playerID, heroIndex: heroIndex, wind: $.GetContextPanel().wind, water: $.GetContextPanel().water, fire: $.GetContextPanel().fire});
	}else if(msg == -1){
		$('#witch_doctor_content').RemoveAndDeleteChildren()
	}
	$.GetContextPanel().wind = -1
	$.GetContextPanel().water = -1
	$.GetContextPanel().fire = -1
}


function InitializeWitchDoctor(){

	CloseWitchDoctor(0);
	$('#close_button_label').text = $.Localize("ui_close")
	$('#header_text').text = $.Localize("tanari_witch_doctor")
	$('#witch_doctor_tooltip').text = $.Localize("witch_doctor_tooltip")
	$.GetContextPanel().wind = -1
	$.GetContextPanel().water = -1
	$.GetContextPanel().fire = -1
	$('#final_combine_button_label').text = $.Localize('combine_tanari_elements_button_label')

}

function CreateItemSlotPanels(){
	var parentPanel = $('#witch_doctor_content')
	parentPanel.RemoveAndDeleteChildren()
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "element-item" );
	newChildPanel.element = "wind"
	newChildPanel.witchDoctorParent = $.GetContextPanel()
	newChildPanel.combineButton = $('#final_combine_button_container')
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/witch_doctor_slot.xml", false, false );	
	$.GetContextPanel().windPanel = newChildPanel

	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "element-item" );
	newChildPanel.element = "water"
	newChildPanel.witchDoctorParent = $.GetContextPanel()
	newChildPanel.combineButton = $('#final_combine_button_container')
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/witch_doctor_slot.xml", false, false );	
	$.GetContextPanel().waterPanel = newChildPanel

	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "element-item" );
	newChildPanel.element = "fire"
	newChildPanel.witchDoctorParent = $.GetContextPanel()
	newChildPanel.combineButton = $('#final_combine_button_container')
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/witch_doctor_slot.xml", false, false );	
	$.GetContextPanel().firePanel = newChildPanel	
}




function LoadButton(){

}

function OpenTanariWitchDoctor(){
	$.Msg("OPEN WITCH DOCTOR")
	if (GameUI.CustomUIConfig().mainDialog == 0){
		CreateItemSlotPanels()
		$('#witch_doctor_container').RemoveClass("invisible")
		$('#witch_doctor_container').style.visibility = "visible"
		GameUI.CustomUIConfig().mainDialog = 1

		$('#witch_doctor_tooltip').text = $.Localize('#witch_doctor_tooltip')
		// $('#header_image').SetImage( "file://{images}/custom_game/ui/witch_doctor_header.jpg")
	}	

}

function FinalCombine(){
	$('#final_combine_button_container').AddClass('invisible')
	var difficulty = getLowestDifficultyEssence()
	CloseWitchDoctor(-1)
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	Game.EmitSound("Tanari.FireTemple.StatueStaffEmerge")
	GameEvents.SendCustomGameEventToServer( "final_tanari_combine", {playerID: playerID, heroIndex: heroIndex, difficulty: difficulty});
}

function getLowestDifficultyEssence(){
	var highestDiff = $.GetContextPanel().windPanel.mDifficulty
	$.Msg(highestDiff)
	if ($.GetContextPanel().waterPanel.mDifficulty < highestDiff){
		highestDiff = $.GetContextPanel().waterPanel.mDifficulty
	}
	if ($.GetContextPanel().firePanel.mDifficulty < highestDiff){
		highestDiff = $.GetContextPanel().firePanel.mDifficulty
	}
	return highestDiff
}

(function()
{
	InitializeWitchDoctor();
	// CloseOracle();
	GameEvents.Subscribe( "close_witch_doctor", CloseWitchDoctor);
	GameEvents.Subscribe( "open_witch_doctor", OpenTanariWitchDoctor );
})();

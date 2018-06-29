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
		$('#witch_doctor_container').style.width = "380px"
		$('#witch_doctor_container').RemoveClass("invisible")
		$('#witch_doctor_container').style.visibility = "visible"
		GameUI.CustomUIConfig().mainDialog = 1

		$('#witch_doctor_tooltip').text = $.Localize('#witch_doctor_tooltip')
		// $('#header_image').SetImage( "file://{images}/custom_game/ui/witch_doctor_header.jpg")
	}	

}

function OpenSynthesisVessel(msg)
{
	if (GameUI.CustomUIConfig().mainDialog == 0){
		var parentPanel = $('#witch_doctor_content')
		mItem = msg.item
		parentPanel.RemoveAndDeleteChildren()
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "element-item" );
		newChildPanel.vessel = mItem
		newChildPanel.vesselParent = $.GetContextPanel()
		newChildPanel.combineButton = $('#final_combine_button_container')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/synthesis_slot.xml", false, false );	
		$.GetContextPanel().windPanel = newChildPanel
		$.GetContextPanel().LastItem = 0
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "element-item" );
		newChildPanel.vessel = mItem
		newChildPanel.vesselParent = $.GetContextPanel()
		newChildPanel.combineButton = $('#final_combine_button_container')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/synthesis_slot.xml", false, false );	
		$.GetContextPanel().waterPanel = newChildPanel
		$('#witch_doctor_container').style.width = "300px"
		$('#header_image').SetImage("file://{images}/custom_game/ui/synth_vessel_background.jpg")
		$('#witch_doctor_container').RemoveClass("invisible")
		$('#witch_doctor_container').style.visibility = "visible"
		$('#header_text').text = $.Localize("#DOTA_Tooltip_ability_item_rpc_synthesis_vessel")
		$('#witch_doctor_tooltip').text = $.Localize("#synthesis_vessel_desc")
		$.GetContextPanel().style.visibility = "visible"
		$('#final_combine_button').SetPanelEvent('onactivate', function CombineItems(){
			var playerID = Game.GetLocalPlayerID()
			var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
			GameEvents.SendCustomGameEventToServer( "synth_combine_items", {heroIndex: heroIndex, vessel: mItem});
			CloseSynthesisVessel(-1)			
		})
		$('#close_witch_doctor').SetPanelEvent('onactivate', function CloseVessel(){
			CloseSynthesisVessel(0)
		})
		GameUI.CustomUIConfig().mainDialog = 1
		$.Msg("BIG PLAYER")	
	}
}
function CloseSynthesisVessel(msg){
	$('#witch_doctor_container').AddClass("invisible")
	$('#witch_doctor_container').style.visibility = "collapse"

	GameUI.CustomUIConfig().mainDialog = 0
	$.GetContextPanel().style.visibility = "collapse"
	$('#final_combine_button_container').AddClass('invisible')
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	$('#witch_doctor_content').RemoveAndDeleteChildren()
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

function OpenAltarOfIce(msg)
{
	if (GameUI.CustomUIConfig().mainDialog == 0){
		var parentPanel = $('#witch_doctor_content')
		mItem = msg.item
		parentPanel.RemoveAndDeleteChildren()
		$.Msg("BSJ")
		$.Msg(msg.stone_table)
		for (i = 0; i < 3; i++) {
			var newChildPanel = $.CreatePanel( "Panel", parentPanel, "element-item" );
			newChildPanel.stone = msg.stone_table[i]
			newChildPanel.altarParent = $.GetContextPanel()
			newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/altar_of_ice_slot.xml", false, false );	
		}
	
		$('#witch_doctor_container').style.width = "340px"
		$('#header_image').SetImage("file://{images}/custom_game/ui/altar_of_ice_header.jpg")
		$('#witch_doctor_container').RemoveClass("invisible")
		$('#witch_doctor_container').style.visibility = "visible"
		$('#header_text').text = $.Localize("#altar_of_ice")
		$('#witch_doctor_tooltip').text = $.Localize("#altar_of_ice_help"+(msg.stones+1))
		$.GetContextPanel().style.visibility = "visible"
		$('#final_combine_button').AddClass("invisible")
		$('#close_witch_doctor').SetPanelEvent('onactivate', function CloseAltar(){
			CloseAltarOfIce(0)
		})
		GameUI.CustomUIConfig().mainDialog = 1
		$.Msg("BIG PLAYER")	
	}
}

function CloseAltarOfIce(msg){
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	$('#witch_doctor_container').AddClass("invisible")
	$('#witch_doctor_container').style.visibility = "collapse"
	GameEvents.SendCustomGameEventToServer( "close_altar", {heroIndex: heroIndex});
	GameUI.CustomUIConfig().mainDialog = 0
	$.GetContextPanel().style.visibility = "collapse"
	$('#final_combine_button_container').AddClass('invisible')
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	$('#witch_doctor_content').RemoveAndDeleteChildren()
	
}

(function()
{
	InitializeWitchDoctor();
	// CloseOracle();
	GameEvents.Subscribe( "close_witch_doctor", CloseWitchDoctor);
	GameEvents.Subscribe( "open_witch_doctor", OpenTanariWitchDoctor );
	GameEvents.Subscribe( "open_synthesis_vessel", OpenSynthesisVessel );
	GameEvents.Subscribe( "close_synthesis_vessel", CloseSynthesisVessel );
	GameEvents.Subscribe( "open_altar_of_ice", OpenAltarOfIce );
	GameEvents.Subscribe( "close_altar_of_ice", CloseAltarOfIce)	
})();

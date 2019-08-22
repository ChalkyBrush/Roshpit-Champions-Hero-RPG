"use strict";
var root= $.GetContextPanel()
var m_difficulty = GetDifficultyFactor();
var range_particle



function equipment_button(){
	var equipmentPanel = GameUI.CustomUIConfig().equipmentParent
	if (equipmentPanel.GetAttributeInt("isOpen", 1) == 0){
		equipmentPanel.AddClass("animateIn")
		equipmentPanel.RemoveClass("animateOut")
		equipmentPanel.SetAttributeInt("isOpen", 1)	
		equipmentPanel.RemoveClass("invisible")
		equipmentPanel.style.visibility = "visible"		
	}else{
		equipmentPanel.RemoveClass("animateIn")
		equipmentPanel.AddClass("animateOut")
		equipmentPanel.SetAttributeInt("isOpen", 0)	
		$.Schedule(0.29, function(){		
			$.Msg("INVIS?")
			equipmentPanel.AddClass("invisible")
			equipmentPanel.style.visibility = "collapse"
		});			
	}
}

function skills_button(){
	var skillsPanel = GameUI.CustomUIConfig().abilityParent
	if (skillsPanel.GetAttributeInt("isOpen", 1) == 0){
		skillsPanel.AddClass("animateInLeft")
		skillsPanel.RemoveClass("animateOutLeft")
		skillsPanel.SetAttributeInt("isOpen", 1)	
		skillsPanel.RemoveClass("invisible")		
	}else{
		skillsPanel.RemoveClass("animateInLeft")
		skillsPanel.AddClass("animateOutLeft")
		skillsPanel.SetAttributeInt("isOpen", 0)	
		$.Schedule(0.29, function(){		
			skillsPanel.AddClass("invisible")
		});			
	}
}

function resources_button(){
	var skillsPanel = GameUI.CustomUIConfig().resourcesParent
	if (skillsPanel.GetAttributeInt("isOpen", 1) == 0){
		skillsPanel.AddClass("animateInLeft")
		skillsPanel.RemoveClass("animateOutLeft")
		skillsPanel.SetAttributeInt("isOpen", 1)	
		skillsPanel.RemoveClass("invisible")
		skillsPanel.style.visibility = "visible"			
	}else{
		skillsPanel.RemoveClass("animateInLeft")
		skillsPanel.AddClass("animateOutLeft")
		skillsPanel.SetAttributeInt("isOpen", 0)	
		$.Schedule(0.29, function(){		
			skillsPanel.AddClass("invisible")
			skillsPanel.style.visibility = "collapse"
		});			
	}
}

function stars_button(){
	var playerID = Game.GetLocalPlayerID();

	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	if (GameUI.CustomUIConfig().starsOpen){
		GameUI.CustomUIConfig().starsParent.AddClass('outLeftBig')
		GameUI.CustomUIConfig().starsOpen = false
		GameUI.CustomUIConfig().starsParent.RemoveClass('fromLeftBig')
		$.Schedule(0.26, function(){	
			GameUI.CustomUIConfig().starsParent.AddClass("invisible")
		});	
	}else{

		GameEvents.SendCustomGameEventToServer( "stars_menu", {playerID: playerID, heroIndex: heroIndex, openingPlayerID: playerID});
	}
	
}




Game.AddCommand("+OpenEquipment", equipment_button, "", 0);
Game.AddCommand("+OpenSkills", skills_button, "", 0);
Game.AddCommand("+OpenResources", resources_button, "", 0);
Game.AddCommand("+OpenStars", stars_button, "", 0);

function UpdateMenuValuesOnce(){
	var playerID = Game.GetLocalPlayerID();
	var portraitUnitController = Players.GetLocalPlayerPortraitUnit();
	for (var i = 1; i <= 4; i++){
		if (Entities.IsControllableByPlayer( portraitUnitController, i))
		{
			playerID = i;

		}
	}
	if (!(Players.IsValidPlayerID( playerID ))){
		playerID = 1
	}

	// var playerInfo = Game.GetPlayerInfo( playerID );
	var player_stats = CustomNetTables.GetTableValue( "player_stats", playerID.toString() );
	if (!(player_stats === undefined)){
		// var skillPoints = player_stats.skillPoints	
		// var runePoints = player_stats.runePoints
		var gold = Players.GetGold( playerID)
		// $('#skill_points_menu_level').text = skillPoints
		// $('#rune_points_menu_level').text = runePoints	
		$('#gold_menu_label').text = gold			
		
	}
}

function UpdateMenuValues(){

	UpdateMenuValuesOnce()
	// SetKeyVisibility();
	$.Schedule( 1.5, UpdateMenuValues );
}

function CorrectDotaUI(){

	// $.Msg($.GetContextPanel())
	var parent = $.GetContextPanel().GetParent();
	// $.Msg(parent)
	parent = parent.GetParent();
	// $.Msg(parent)
	parent = parent.GetParent();
	// $.Msg(parent)
	GameUI.DotaHUD = parent
	GameUI.HealthRegenLabel = parent.FindChildTraverse("HealthRegenLabel")
	
	GameUI.ManaRegenLabel = parent.FindChildTraverse("ManaRegenLabel")

	GameUI.MovespeedLabel = parent.FindChildTraverse("MoveSpeedLabelBase")
	// while(parent.id !="hud"){
	// 	parent = parent.GetParent();
	// }
	// parent.FindChildTraverse("HUDElements").FindChildTraverse("shop").enabled = false;
	// parent.FindChildTraverse("HUDElements").FindChildTraverse("shop").visible = false;





	//BASICS

	parent.FindChildTraverse("RadarButton").visible = false;
	parent.FindChildTraverse("NetGraph").style.marginRight = '180px';
	parent.FindChildTraverse("inventory").style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/inventory_bg_psd.vtex")'
	GameUI.InventoryPanel = parent.FindChildTraverse("inventory")

	parent.FindChildTraverse("QueryUnit").style.verticalAlign = 'bottom';
	parent.FindChildTraverse("QueryUnit").style.marginTop = '0px';
	parent.FindChildTraverse("QueryUnit").style.marginBottom = '178px';
	//REMOVE TALENTS
	// $.Msg(parent.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch"))
	// parent.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch").AddClass("GGStats")
	parent.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch").style.visibility = 'collapse';
	// $.Msg(StatBranch)
	// parent.FindChildTraverse("StatBranch").style.width = '0px';
	// parent.FindChildTraverse("StatBranch").visible = false;


	// StatBranch.style.visibility = 'collapse';
	// StatBranch.AddClass("GGStats")


	parent.FindChildTraverse("StatBranch").RemoveClass('ShowStatBranch')
	// parent.FindChildTraverse("StatBranch").style.opacity = '0';
	// parent.FindChildTraverse("PortraitContainer").style.marginLeft = '20px';
	parent.FindChildTraverse("unitname").style.width = '180px';
	parent.FindChildTraverse("unitname").style.marginBottom = '145px';
	parent.FindChildTraverse("left_flare").style.marginLeft = '0px';
	parent.FindChildTraverse("HUDSkinPortrait").style.visibility = 'collapse';
	parent.FindChildTraverse("SharedUnitControl").style.visibility = 'collapse';
	parent.FindChildTraverse("SharedUnitsButton").style.visibility = 'collapse';
	parent.FindChildTraverse("inventory_tpscroll_container").style.visibility = 'collapse';
	// parent.FindChildTraverse("HUDSkinPortrait").style.marginLeft = '0px';
	// parent.FindChildTraverse("center_with_stats").style.marginRight = '80px';

	parent.FindChildTraverse('xp').FindChildTraverse("LevelLabel").style.width = '42px';

	parent.FindChildTraverse("stats").style.verticalAlign = 'top';
	parent.FindChildTraverse("stats").style.marginTop = '4px'
	// parent.FindChildTraverse("AttackSpeed").style.visibility = "collapse"
	// parent.FindChildTraverse("xp").style.visibility = "collapse"
	// parent.FindChildTraverse("xpBacker").style.visibility = "collapse"
	// parent.FindChildTraverse("AbilityInsetShadowLeft").style.marginLeft = '212px';
	parent.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("abilities").style.horizontalAlign = 'center';
	parent.FindChildTraverse("AbilitiesAndStatBranch").GetChild(0).style.horizontalAlign = 'center';
	parent.FindChildTraverse("inventory").style.visibility = "collapse";
	parent.FindChildTraverse("right_flare").style.horizontalAlign = "center";
	parent.FindChildTraverse("right_flare").style.marginLeft = "345px";

	parent.FindChildTraverse("center_block").style.marginLeft = '200px';
	parent.FindChildTraverse("PortraitBacker").style.marginLeft = '54px';
	parent.FindChildTraverse("PortraitBackerColor").style.marginLeft = '54px';

	// parent.FindChildTraverse("HUDSkinPort").style.marginLeft = '54px';
	// parent.FindChildTraverse("stats").FindChildTraverse('Aligner').BCreateChildren( '<panel id="stat_row_2"></panel>')
	//TALENTS

	// parent.FindChildTraverse("LevelLabel").style.visibility = 'collapse';
	// parent.FindChildTraverse("LevelLabel").text = ""
	// var levelProgress = parent.FindChildTraverse("StatBranch").FindChildTraverse("StatLevelProgressBar_Left")
	// $.Msg(levelProgress)
	// levelProgress.style.width = "1px"
	// parent.FindChildTraverse("StatBranch").FindChildTraverse("StatLevelProgressBar_Right").style.width = '1px'
	// 
	// levelProgress.style.width = "5px"

	//PICK SCREEN

	// parent.FindChildTraverse("HeroFilters").style.visibility = "collapse"

	//RANDOM TEST
	// $.DispatchEvent("UIShowCustomLayoutParametersTooltip", itemPanel, "file://{resources}/layout/custom_game/equipment/item_tooltip.xml", tooltipArgs);
	var stats_tooltip_panel = parent.FindChildTraverse('stats_tooltip_region')
	GameUI.StatsTooltipAttachment = stats_tooltip_panel
	stats_tooltip_panel.SetPanelEvent('onmouseover', function StatsToolTip() {
		if (!range_particle){
			var unit = Players.GetLocalPlayerPortraitUnit()
			range_particle = Particles.CreateParticle("particles/ui_mouseactions/range_finder_ward_aoe_ring.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, unit)
			Particles.SetParticleControlEnt(range_particle, 2, unit, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, "follow_origin", Entities.GetAbsOrigin(unit), true)
			Particles.SetParticleControl(range_particle, 3, [Entities.GetAttackRange(unit), 1, 1])
		}

		GameUI.ShouldAttributeTooltip = true
		GameEvents.SendCustomGameEventToServer( "stats_hover", {playerID: Game.GetLocalPlayerID(), queryunit: Players.GetLocalPlayerPortraitUnit()});
		// $.DispatchEvent("UIShowCustomLayoutParametersTooltip", stats_tooltip_panel, "file://{resources}/layout/custom_game/equipment/item_tooltip.xml", tooltipArgs);
	});
	stats_tooltip_panel.SetPanelEvent('onmouseout', function StatsToolTip() {
		if (range_particle){
			Particles.DestroyParticleEffect(range_particle, true)
			Particles.ReleaseParticleIndex(range_particle)
			range_particle = null;
		}

		GameUI.ShouldAttributeTooltip = false
		$.DispatchEvent("UIHideCustomLayoutTooltip", "AttributesTooltip");
	});

	// var stats_tooltip_panel = parent.FindChildTraverse('QueryInfo').FindChildTraverse('stats_container')
	// GameUI.StatsTooltipAttachment = stats_tooltip_panel
	// stats_tooltip_panel.SetPanelEvent('onmouseover', function StatsToolTip() {
	// 	$.Msg("NEW TOOLTIP?")
	// 	GameEvents.SendCustomGameEventToServer( "stats_hover", {playerID: Game.GetLocalPlayerID(), queryunit: Players.GetLocalPlayerPortraitUnit()});
	// 	// $.DispatchEvent("UIShowCustomLayoutParametersTooltip", stats_tooltip_panel, "file://{resources}/layout/custom_game/equipment/item_tooltip.xml", tooltipArgs);
	// });
	// stats_tooltip_panel.SetPanelEvent('onmouseout', function StatsToolTip() {
	// 	$.DispatchEvent("UIHideCustomLayoutTooltip", "AttributesTooltip");
	// });
}

function InitializeMenu(){
	$('#skills_button_label').text=$.Localize("ui_skills")
	$('#equipment_button_label').text=$.Localize("ui_equipment")
	$('#resource_button_label').text=$.Localize("tooltip_resources")

	$('#menu_gold_label').text=$.Localize("ui_gold")
	// $('#menu_skill_points_label').text=$.Localize("skill_points")
	// $('#menu_rune_points_label').text=$.Localize("runic_points")
	if (isRedfallRidge()){
		$.Msg("HEY!!")
		$('#quest_log_button').RemoveClass('invisible')
	}

	
}

function SetKeyVisibility(){
	var difficulty = GetDifficultyFactor()
	var heroIndex = getSelectedHeroIndex()
	var keys = CustomNetTables.GetTableValue( "portal_keys", heroIndex+"-"+difficulty )
	$.Msg(heroIndex)
	$.Msg(keys)
	if (!(keys === undefined)){
		if (keys.forest == 1){
			$('#portal_key_forest').RemoveClass('hidden')
		}else{
			$('#portal_key_forest').AddClass('hidden')
		}
		if (keys.desert == 1){
			$('#portal_key_desert').RemoveClass('hidden')
		}else{
			$('#portal_key_desert').AddClass('hidden')
		}
		if (keys.mines == 1){
			$('#portal_key_mines').RemoveClass('hidden')
		}else{
			$('#portal_key_mines').AddClass('hidden')
		}
	}
	// CustomNetTables:SetTableValue("portal_keys", heroIndex+"-"+difficulty, {forest = 1, desert = 0, mines = 0} )
}

function KeyShowTooltip(keyName){
	var panel = $('#portal_key_'+keyName)
	var titleColor = '#1FB81F'
	if (keyName=="desert"){
		titleColor = '#EDE726'
	}else if (keyName =="mines"){
		titleColor = '#DE1600'
	}
	var difficulty_name = "#ui_normal"
	if (m_difficulty==2){
		difficulty_name = "#ui_elite"
	}else if (m_difficulty==3){
		difficulty_name = "#ui_legend"
	}
	
	var title = "<font color='"+titleColor+"'>"+$.Localize('#'+keyName+"_portal_key")
	var tooltip = $.Localize('#'+keyName+"_portal_key_description")+" "+$.Localize(difficulty_name)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function KeyHideTooltip(keyName){
	var panel = $('#portal_key_'+keyName)
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}



function GetDifficultyFactor(){
	var mapName = Game.GetMapInfo().map_display_name
	var difficulty = 1;
	if (mapName === "rpc_world_1_normal"){
		difficulty = 1;
	}else if(mapName === "rpc_world_1_elite"){
		difficulty = 2;
	}else if(mapName === "rpc_world_1_legend"){
		difficulty = 3;
	}	
	return difficulty;
}

function getSelectedHeroIndex()
{
	if (Players.IsSpectator( Game.GetLocalPlayerID() )){
		return 0
	}
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (Entities.IsHero(queryUnit)){
		return queryUnit
	}else{
		return Players.GetPlayerSelectedHero( Game.GetLocalPlayerID() )
	}

}

function TownPortalTooltip(){
		// "tooltip_town_portal"
		// "tooltip_town_portal_desc"
	var panel = $('#tp_button')
	panel.AddClass("tp_hover")
	$('#portal_hover').RemoveClass('invisible')
	var title = "<font color='yellow'>"+$.Localize('#tooltip_town_portal')
	var tooltip = $.Localize('#tooltip_town_portal_desc')
	// tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideTownPortalTooltip(){
	var panel = $('#tp_button')
	panel.RemoveClass("tp_hover")
	$('#portal_hover').AddClass('invisible')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function UseTownPortal(){
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	// Game.EmitSound("ui.crafting_pulse")
	GameEvents.SendCustomGameEventToServer( "town_portal", {playerID: playerID, heroIndex: heroIndex});
}

function QuestlogTooltip(){
		// "tooltip_town_portal"
		// "tooltip_town_portal_desc"
	var panel = $('#tp_button2')
	panel.AddClass("tp_hover")
	$('#portal_hover2').RemoveClass('invisible')
	var title = "<font color='yellow'>"+$.Localize('#tooltip_quest_log')
	var tooltip = $.Localize('#tooltip_quest_log_description')
	// tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideQuestlogTooltip(){
	var panel = $('#tp_button2')
	panel.RemoveClass("tp_hover")
	$('#portal_hover').AddClass('invisible')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function OpenQuestLog(){
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	// Game.EmitSound("ui.crafting_pulse")
	$('#quest_log_button').RemoveClass('quest-highlight')
	$('#quest_log_button').AddClass('quest-log-no-highlight')
	GameEvents.SendCustomGameEventToServer( "quest_log", {playerID: playerID, heroIndex: heroIndex, bFade: 1});
}

function highlightQuest(){
	$('#quest_log_button').AddClass('quest-highlight')
	$('#quest_log_button').RemoveClass('quest-log-no-highlight')
	
}

function RespawnTooltip(){
		// "tooltip_town_portal"
		// "tooltip_town_portal_desc"
	var panel = $('#respawn_button')
	panel.AddClass("tp_hover")
	$('#portal_hover').RemoveClass('invisible')
	var title = "<font color='yellow'>"+$.Localize('#tooltip_respawn_flag')
	var tooltip = $.Localize('#tooltip_respawn_flag_desc')
	// tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideRespawnTooltip(){
	var panel = $('#respawn_button')
	panel.RemoveClass("tp_hover")
	$('#portal_hover').AddClass('invisible')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function UseRespawnFlag(){
	var playerID = Game.GetLocalPlayerID()
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
	// Game.EmitSound("ui.crafting_pulse")
	var color = 1
	$.Msg(color)
	GameEvents.SendCustomGameEventToServer( "respawn_flag", {playerID: playerID, heroIndex: heroIndex, color: color});
}

function AttributeTooltipHoverFromServer(msg){
	if (GameUI.ShouldAttributeTooltip){
		var queryUnit = msg.unit
		// var tooltipArgs = "queryUnit="+queryUnit
		GameUI.StatQueryData = msg.extraData
		GameUI.AttributeQueryUnit = queryUnit
		$.DispatchEvent("UIShowCustomLayoutTooltip", GameUI.StatsTooltipAttachment, "AttributesTooltip", "file://{resources}/layout/custom_game/skills/attributes_tooltip.xml");
		// $.DispatchEvent("UIShowCustomLayoutParametersTooltip", GameUI.StatsTooltipAttachment, "file://{resources}/layout/custom_game/skills/attributes_tooltip.xml", tooltipArgs);
	}
}

(function()
{
	// GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateMenuValues );
	// GameEvents.Subscribe( "dota_player_update_query_unit", UpdateMenuValues );

	GameEvents.Subscribe( "", UpdateMenuValues );
	
	GameEvents.Subscribe( "correct_dota_ui", CorrectDotaUI );
	GameEvents.Subscribe( "update_key_display", SetKeyVisibility );
	GameEvents.Subscribe( "dota_player_update_query_unit", SetKeyVisibility );

	GameEvents.Subscribe( "UpdateMenuValues", UpdateMenuValuesOnce );

	GameEvents.Subscribe( "newQuest", highlightQuest)
	GameEvents.Subscribe( "attribute_tooltip", AttributeTooltipHoverFromServer)
	UpdateMenuValues();
	InitializeMenu();
	CorrectDotaUI();
})();
var quest = $.GetContextPanel().quest
var gameProgress = $.GetContextPanel().gameProgress

function InitializeQuestItem(){
	var quest_description = $.Localize('#quest_description')
	var boss_name = $.Localize("#"+quest.boss_name)
	var dungeon_name = $.Localize("#"+quest.dungeon_name)
	var difficulty_name = convertDifficultyIndexToName(quest.difficulty)
	$.Msg(quest)
	quest_description = quest_description.replace("@boss_name", "<font color='#79BA6E'>"+boss_name+"</font>")
	quest_description = quest_description.replace("@dungeon_name", "<font color='#79BA6E'>"+dungeon_name+"</font>")
	quest_description = quest_description.replace("@difficulty_name", "<font color='"+difficulty_name[1]+"'>"+difficulty_name[0]+"</font>")
	$('#quest_description').text = quest_description
	$('#quest_status_level').text = $.Localize('#quest_level')+": "
	$('#quest_status_level_number').text = quest.quest_level
	if (getQuestStatusBoss(quest.boss_name, gameProgress, quest.difficulty)){

		$.GetContextPanel().AddClass('quest_item_complete')
		$('#quest_status_label').text = $.Localize('#quest_status_complete')
		$('#quest_status_label').AddClass('quest_status_complete')
		$('#quest_delete_button').AddClass('invisible')
		$.GetContextPanel().questComplete = 1
	}else{
		$('#quest_status_label').text = $.Localize('#quest_status_incomplete')
		$('#quest_status_label').AddClass('quest_status_incomplete')
		$.GetContextPanel().questComplete = 0
	}
}

function getQuestStatusBoss(boss_name, gameProgress, difficulty)
{
	var questComplete = false
	if (getDifficultyFactor() >= difficulty){
		if ((boss_name == "graveyard_boss") && (gameProgress.wraithkeeper == 1)){
			questComplete = true
		}else if ((boss_name == "lumber_mill_boss") && (gameProgress.gazbinceo == 1)){
			questComplete = true
		}else if ((boss_name == "grizzly_falls_boss") && (gameProgress.starblight == 1)){
			questComplete = true
		}else if ((boss_name == "sand_tomb_boss") && (gameProgress.silithicus == 1)){
			questComplete = true
		}else if ((boss_name == "ruins_boss") && (gameProgress.rentiki == 1)){
			questComplete = true
		}else if ((boss_name == "dynasty_heir_majinaq") && (gameProgress.majinaq == 1)){
			questComplete = true
		}else if ((boss_name == "swamp_boss") && (gameProgress.keeper == 1)){
			questComplete = true
		}else if ((boss_name == "castle_boss") && (gameProgress.count == 1)){
			questComplete = true
		}else if ((boss_name == "phoenix_boss") && (gameProgress.phoenix == 1)){
			questComplete = true
		}
	}
	return questComplete
}

function getDifficultyFactor(){
	var mapName = Game.GetMapInfo().map_display_name
	if (mapName === "rpc_world_1_normal"){
		return 0
	}else if(mapName === "rpc_world_1_elite"){
		return 1
	}else if(mapName === "rpc_world_1_legend"){
		return 2
	}else{
		return 0
	}
}

function convertDifficultyIndexToName(difficulty){
	var difficultyText = ""
	var difficulty_color = "#FFFFFF"
	if (difficulty == 0){
		difficultyText = $.Localize("#ui_normal")
		difficulty_color = "#CCCCCC"
	}else if(difficulty == 1){
		difficultyText = $.Localize("#ui_elite")
		difficulty_color = "#2B8DE3"
	}else if(difficulty == 2){
		difficultyText = $.Localize("#ui_legend")
		difficulty_color = "#fdb53f"
	}
	return [difficultyText, difficulty_color]
}

function DeleteQuestTooltip()
{
	title = $.Localize( "#quest_delete_quest_title")
	message = $.Localize( "#quest_delete_quest_tooltip")
	title = "<font color='#C43B3B'>"+title+"</font>"
	title = title.replace(/(['"])/g, "\\$1");
	var tooltip = breakUpTooltip(message)
	var panel = $('#quest_delete_button')
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideDeleteQuestTooltip(){
	var panel = $('#quest_delete_button')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function DeleteQuest(){
	if (GameUI.CustomUIConfig().crusaderLock == 0){
		GameUI.CustomUIConfig().crusaderLock = 1
		var questID = quest.id
		$.Msg(questID)
		GameEvents.SendCustomGameEventToServer( "delete_quest", {playerID: Game.GetLocalPlayerID(), questID: questID, complete: 0});
		Game.EmitSound("ui.contract_fail")
	}
}

function CompleteQuest(){
	if ((GameUI.CustomUIConfig().crusaderLock == 0) && ($.GetContextPanel().questComplete == 1)){
		GameUI.CustomUIConfig().crusaderLock = 1
		var questID = quest.id
		GameEvents.SendCustomGameEventToServer( "delete_quest", {playerID: Game.GetLocalPlayerID(), questID: questID, complete: 1, quest_level: quest.quest_level});
		Game.EmitSound("Tutorial.Quest.complete_01")
	}
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

(function()
{
	InitializeQuestItem();
	
})();

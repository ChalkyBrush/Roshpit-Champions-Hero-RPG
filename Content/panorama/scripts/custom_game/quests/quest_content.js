var results = $.GetContextPanel().result
var gameProgress = $.GetContextPanel().gameProgress
var maxQuests = 3
function InitializeQuestContent(){
	$.Msg("RESULTS")
	var quests = results.quests
	var questCount = Object.keys(quests).length
	$('#quest_no_quest').text = $.Localize('#quests_no_quests')
	if (quests[1] == 0)
	{
		$('#quest_capacity').text=$.Localize('#quests_quest_capacity')+": 0/"+maxQuests
		$('#quest_no_quest').RemoveClass('invisible')
		// $('#quest_main_tooltip').text = $.Localize('#quests_questtip')
	}else{
		$('#quest_capacity').text=$.Localize('#quests_quest_capacity')+": "+questCount+"/"+maxQuests
		$('#quest_no_quest').AddClass('invisible')
		// $('#quest_main_tooltip').text = $.Localize('#quests_questtip')
		for (var i = 1; i <= questCount; i++) {
			var parentPanel = $('#quest_items_container')
			var newChildPanel = $.CreatePanel( "Panel", parentPanel, "quest_item" );
			newChildPanel.gameProgress = gameProgress
			newChildPanel.quest = quests[i]
			newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/quest_item.xml", false, false );
			if (i == 1){
				newChildPanel.AddClass('first_quest_item')
			}else if (i==maxQuests){
				newChildPanel.AddClass('last_quest_item')
			}else{
				newChildPanel.AddClass('middle_quest_item')
			}
		}
	}
}

(function()
{
	InitializeQuestContent();
	
})();
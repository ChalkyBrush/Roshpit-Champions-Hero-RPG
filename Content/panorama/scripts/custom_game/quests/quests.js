var questPanel = $.GetContextPanel()

function InitializeQuests() {
	GameUI.CustomUIConfig().questsParent = questPanel;
}

function UpdateQuests() {
	var player = Players.GetLocalPlayer();
	var quests = CustomNetTables.GetTableValue("interface_data", "quests");
	if (quests == undefined) {
		return;
	}
	var questsContainer = questPanel.FindChildTraverse("quests_container")
	questsContainer.RemoveAndDeleteChildren(); 
	var hideCompleted = questPanel.FindChildTraverse("hide_completed_quests_buton").checked;
	if (quests[1] !== undefined) {
		$.Each(quests, function(quest, questIndex){
            var questCompleted = true
            $.Each(quest["rewards"], function(reward)
            { 
                $.Msg("Quest Completed: " + questCompleted)
                $.Msg(reward.claimed[player])
                questCompleted = questCompleted && reward.claimed[player] == 1; 
            });
            $.Msg("Quest Completed: " + questCompleted)
			if(hideCompleted && questCompleted){
				$.Msg("Triggered");
				return; 
			}
			//Create new Questpanel
			var newQuestPanel = $.CreatePanel( "Panel", questsContainer, "quest-" + questIndex );
			newQuestPanel.BLoadLayoutSnippet("quest_snippet"); 

			//Set Questtitle
			var questTitle = newQuestPanel.FindChildTraverse("quest_name");
			questTitle.text = $.Localize("quest_" + quest["questname"] + "_title");
			if(!questCompleted) {
				//Set Questtext
				var questText = newQuestPanel.FindChildTraverse("quest_text");
				questText.text = $.Localize("quest_" + quest["questname"] + "_text"); 
				if(quest["objectives"] !== undefined) {
					$.Each(quest["objectives"], function(objective, objectiveIndex){
						var newQuestObjectivePanel = $.CreatePanel( "Panel", questsContainer, "questObjective-" + questIndex + "-" + objectiveIndex );
						newQuestObjectivePanel.BLoadLayoutSnippet("quest_objective_snippet"); 
						var questObjectiveLabel = newQuestObjectivePanel.FindChildTraverse("quest_objective");
						var objectiveText = "Missing Localization";
						if ($.Localize(objective["target"]) == objective["target"]){
							if ($.Localize("quest_" + objective["target"]) == objective["target"])	{
								throw "Objective is not localized. Tried with " + objective["target"] + " / quest_" + objective["target"];
							} 
							else{
								objectiveText = $.Localize("quest_" + objective["target"]);
							}
						}
						else{
							objectiveText = $.Localize(objective["target"]);
						}
						questObjectiveLabel.text = "• " + objectiveText + " " + objective["currentCount"] + "/" + objective["count"]; 
						if (objective["currentCount"] < objective["count"])
						{
							if (objective["ping"] !== undefined) {
								var questObjectivePingButton = newQuestObjectivePanel.FindChildTraverse("quest_objective_ping_button");
								questObjectivePingButton.SetPanelEvent('onactivate', () => PingQuestObjective(questIndex, objectiveIndex));
								questObjectivePingButton.RemoveClass("invisible");
							}
							return false;
						}
						else
						{
							questObjectiveLabel.AddClass("objective-completed"); 
						}
					});
				}
				if(quest["rewards"] !== undefined) {
					$.Each(quest["rewards"], function(reward, rewardIndex){
						var newQuestRewardPanel = $.CreatePanel( "Panel", questsContainer, "questReward-" + questIndex + "-" + rewardIndex );
						newQuestRewardPanel.BLoadLayoutSnippet("quest_reward_snippet"); 
						var questReward = newQuestRewardPanel.FindChildTraverse("quest_reward");
						var fontcolor = "";
                        var tooltipPrefix = "";
                        var prefix = "";
						//Key
						if (reward["type"] == 1) {
							fontcolor = "#FFFFFF";
							tooltipPrefix = "DOTA_Tooltip_ability_";
						}
						//Buff
						else if (reward["type"] == 2) {
							fontcolor = "#00FFFF";
							tooltipPrefix = "DOTA_Tooltip_";
						}
						//Immortal
						else if (reward["type"] == 3) {
							fontcolor = "#E4AE33"; 
							tooltipPrefix = "DOTA_Tooltip_ability_";
						}
						//Mithril
						else if (reward["type"] == 4) {
                            fontcolor = "#57B3FF"
                            prefix = " " + reward["amount"] + " "
						}
						//Arcane Crystals
						else if (reward["type"] == 5) {
							fontcolor = "#C363D4"
						}
						//Prismatic Gemstones
						else if (reward["type"] == 6) {
							fontcolor = "#DDDDDD"
						}
						questReward.text = $.Localize("quest_reward") + prefix + $.Localize(tooltipPrefix + reward["name"]); 
                        questReward.style.color = fontcolor;
                        var rewardButton = newQuestRewardPanel.FindChildTraverse("quest_reward_button");
						if (reward.claimed[player] === 0) {
							rewardButton.RemoveClass("invisible");
							rewardButton.SetPanelEvent('onactivate', () => ClaimQuestReward(questIndex, rewardIndex))
						} else if (reward.claimed[player] === 1) {
                            questReward.AddClass("reward-claimed")
                        }
					});
				}
			}
			else { 
				questTitle.text = questTitle.text + " (Completed)";
			}
			if (quest["status"] !== undefined) {
				if (quest["status"] === 1) {  
					questTitle.AddClass("quest-active"); 
				}
				else if (quest["status"] === 2) {
					questTitle.AddClass("quest-completed");
				}
			}
		});	
	}
	else { 
		var newQuestPanel = $.CreatePanel( "Panel", questsContainer, "quest0" );
		newQuestPanel.BLoadLayoutSnippet("quest_snippet"); 
		var questTitle = newQuestPanel.FindChildTraverse("quest_name");
		questTitle.text = "•" + $.Localize("quest_no_quests_title");
		var questText = newQuestPanel.FindChildTraverse("quest_text");
		questText.text = "•" + $.Localize("quest_no_quests_text"); 
	}
}

function ClaimQuestReward(questId, rewardId){
	GameEvents.SendCustomGameEventToServer( "claim_quest_reward", { questId: questId, playerId: Players.GetLocalPlayer(), rewardId: rewardId } );
}

function PingQuestObjective(questId, objectiveId){
	GameEvents.SendCustomGameEventToServer("ping_quest_objective", { questId: questId, objectiveId: objectiveId, playerId: Players.GetLocalPlayer() });
}

(function()
{
	InitializeQuests();
	UpdateQuests();
	GameEvents.Subscribe("update_quests", UpdateQuests);
})();

var menuPanel = null

function OpenCrusader(){
	$.Msg("OPEN CRUSADER")
	if (GameUI.CustomUIConfig().mainDialog == 0){
		$.Msg("OPEN CRUSADER WITH CLEAR DIALOG")
		$('#crusader_container').RemoveClass("invisible")
		$('#crusader_container').style.visibility = "visible"
		GameUI.CustomUIConfig().mainDialog = 1
		$('#crusader_loading_label').RemoveClass('invisible')
		$('#crusader_loading_label').text = $.Localize('#saveload_loading')
		GameEvents.SendCustomGameEventToServer( "client_crusader", {playerID: Game.GetLocalPlayerID()});
	}
}

function CloseCrusader(msg){
	$('#crusader_container').AddClass("invisible")
	$('#crusader_container').style.visibility = "collapse"
	$('#crusader_content').RemoveAndDeleteChildren()
	$('#challenge_content').RemoveAndDeleteChildren()
	GameUI.CustomUIConfig().mainDialog = 0
	ClearCrusader();
	if (msg!=0){
		if (!(msg === undefined)){
			if (msg.unlock == 1){
				GameUI.CustomUIConfig().crusaderLock = 0
			}
		}
	}
}

function CrusaderLoaded(msg){
	$('#crusader_loading_label').text = $.Localize('#quests_quests')
	ClearCrusader();
	var parentPanel = $('#crusader_content')
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "quest_content" );
	newChildPanel.result = msg.result
	newChildPanel.gameProgress = msg.gameProgress
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/quest_content.xml", false, false );	
	var playerID = Game.GetLocalPlayerID();
	populateChallenge(msg.challenge)
	if (msg.unlock == 1){
		GameUI.CustomUIConfig().crusaderLock = 0
	}
}

function populateChallenge(challenge){
	var parentPanel = $('#challenge_content')
	parentPanel.RemoveAndDeleteChildren()
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "challenge_content_sub" );
	newChildPanel.challenge = challenge

	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/quests/challenge.xml", false, false );	
	var playerID = Game.GetLocalPlayerID();
	// $.Msg(challenge)
	// $('#challenge_main_tooltip').text = $.Localize('#challenge_title')
	// // $('#challenge_information').text = $.Localize('#challenge_description')
	// var challengeInfo = "<font color='#FF0000'>-</font> "
	// if (challenge.dungeon_name){
	// 	challengeInfo = challengeInfo + $.Localize('#challenge_dungeon')
	// 	var boss_name = $.Localize('#'+challenge.enemy_objective_name)
	// 	var dungeon_name = $.Localize('#'+challenge.dungeon_name)
	// 	challengeInfo = challengeInfo.replace("@boss_name", "<font color='#79BA6E'>"+boss_name+"</font>")
	// 	challengeInfo = challengeInfo.replace("@dungeon_name", "<font color='#79BA6E'>"+dungeon_name+"</font>")
	// 	if (challenge.quantity){
	// 		var diabLevel = $.Localize('#challenge_level_condition')
	// 		diabLevel = diabLevel.replace("@level", challenge.quantity)
	// 		challengeInfo = challengeInfo.replace("@level_condition", "<font color='#79BA6E'> "+diabLevel+"</font>")
	// 	}else{
	// 		challengeInfo = challengeInfo.replace("@level_condition", "")
	// 	}

	// }
	// if (challenge.paragon_affix){
	// 	challengeInfo = challengeInfo + $.Localize('#challenge_paragon_with_affix')
	// 	challengeInfo = challengeInfo.replace("@paragon_quantity", "<font color='#79BA6E'>"+challenge.quantity+"</font>")
	// 	challengeInfo = challengeInfo.replace("@paragon_affix", "<font color='#79BA6E'>"+challenge.paragon_affix+"</font>")
	// }
	// if (challenge.paragon_quantity){
	// 	challengeInfo = challengeInfo + $.Localize('#challenge_paragon')
	// 	challengeInfo = challengeInfo.replace("@paragon_quantity", "<font color='#79BA6E'>"+challenge.paragon_quantity+"</font>")
	// }
	// if (challenge.disallowed_hero){
	// 	challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_hero_constraint')
	// 	var heroName = $.Localize('#'+challenge.disallowed_hero)
	// 	challengeInfo = challengeInfo.replace("@heroname", "<font color='#79BA6E'>"+heroName+"</font>")
	// }
	// if (challenge.time_constraint){
	// 	challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_time_constraint')
	// 	challengeInfo = challengeInfo.replace("@time_constraint", "<font color='#79BA6E'>"+secondsToLegibleTime(challenge.time_constraint)+"</font>")
	// }
	// if (challenge.ability_constraint){
	// 	var abilityIndex = parseInt(challenge.ability_constraint)
	// 	challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_ability_constraint')
	// 	challengeInfo = challengeInfo.replace("@ability","@Ability"+(abilityIndex+1))
	// 	var localHero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())

	// 	challengeInfo = updateSkillInTooltip(challengeInfo, localHero)
	// 	challengeInfo = challengeInfo.replace("@letter",getHotkeyFromSkillIndex(localHero, abilityIndex))
	// }
	// if (challenge.no_deaths == 1){
	// 	challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_no_deaths')
	// }
	// if (challenge.no_deaths == 2){
	// 	challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_solo')
	// }
	// $('#challenge_detail_information').text = challengeInfo
	// $('#challenge_detail_information').AddClass("none")
	// $('#challenge_detail_information').SetFocus()

	// $('#challenge_reward_title').text = $.Localize('#challenge_reward')
	// $('#challenge_reward_normal').text = $.Localize('#ui_normal')
	// $('#challenge_reward_elite').text = $.Localize('#ui_elite')
	// $('#challenge_reward_legend').text = $.Localize('#ui_legend')

	// var baseReward = parseInt(challenge.reward)
	// $('#mithril_shards_value_normal').text = baseReward
	// $('#mithril_shards_value_elite').text = baseReward*2
	// $('#mithril_shards_value_legend').text = baseReward*6
}

function QuestTooltip()
{
	var panel = $('#quest_main_tooltip_container')
	var title = "<font color='#3D84FF'>"+$.Localize('#quests_quests')
	var tooltip = $.Localize('#quests_questtip')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideQuestsTooltip()
{
	var panel = $('#quest_main_tooltip_container')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function getHotkeyFromSkillIndex(queryUnit, index)
{
	var ability = Entities.GetAbility( queryUnit, index )
	var bind = Abilities.GetKeybind( ability, queryUnit );
	return bind
}

function secondsToLegibleTime(rawSeconds)
{
	var seconds = Math.floor(rawSeconds%60)
	if (seconds < 10){
		seconds = "0"+seconds
	}
	var minutes = Math.floor(rawSeconds/60)
	var timeString = minutes+":"+seconds
	return timeString
}

function InitializeCrusader(){

	GameUI.CustomUIConfig().crusaderLock = 0
	CloseCrusader(0);

}

function ClearCrusader(){
	
	$('#crusader_content').RemoveAndDeleteChildren()
	if (!($('#save_box') == null)){
		$('#save_box').RemoveAndDeleteChildren()
		$('#save_box').DeleteAsync(0)
	}
}



function actionRefresh(type){
	if (type == "save"){
		$.GetContextPanel().saveOpen = true
		$.GetContextPanel().loadOpen = false
		$.GetContextPanel().stashOpen = false
	}else if (type == "load"){
		$.GetContextPanel().saveOpen = false
		$.GetContextPanel().loadOpen = true
		$.GetContextPanel().stashOpen = false
	}else if (type == "stash"){
		$.GetContextPanel().saveOpen = false
		$.GetContextPanel().loadOpen = false
		$.GetContextPanel().stashOpen = true
	}
}




function LoadButton(){

}


(function()
{
	// InitializeCrusader();
	// // CloseOracle();
	// GameEvents.Subscribe( "open_crusader", OpenCrusader );
	// GameEvents.Subscribe( "close_crusader", CloseCrusader);
	// GameEvents.Subscribe( "crusader_quests_loaded", CrusaderLoaded);
})();

challenge = $.GetContextPanel().challenge

function populateChallenge(){
	$.Msg(challenge)
	$('#challenge_main_tooltip').text = $.Localize('#challenge_title')
	// $('#challenge_information').text = $.Localize('#challenge_description')
	var challengeInfo = "<font color='#FF0000'>-</font> "
	if (challenge.dungeon_name){
		challengeInfo = challengeInfo + $.Localize('#challenge_dungeon')
		var boss_name = $.Localize('#'+challenge.enemy_objective_name)
		var dungeon_name = $.Localize('#'+challenge.dungeon_name)
		challengeInfo = challengeInfo.replace("@boss_name", "<font color='#79BA6E'>"+boss_name+"</font>")
		challengeInfo = challengeInfo.replace("@dungeon_name", "<font color='#79BA6E'>"+dungeon_name+"</font>")
		if (challenge.quantity){
			var diabLevel = $.Localize('#challenge_level_condition')
			diabLevel = diabLevel.replace("@level", challenge.quantity)
			challengeInfo = challengeInfo.replace("@level_condition", "<font color='#79BA6E'> "+diabLevel+"</font>")
		}else{
			challengeInfo = challengeInfo.replace("@level_condition", "")
		}

	}
	if (challenge.paragon_affix){
		challengeInfo = challengeInfo + $.Localize('#challenge_paragon_with_affix')
		challengeInfo = challengeInfo.replace("@paragon_quantity", "<font color='#79BA6E'>"+challenge.quantity+"</font>")
		challengeInfo = challengeInfo.replace("@paragon_affix", "<font color='#79BA6E'>"+challenge.paragon_affix+"</font>")
	}
	if (challenge.paragon_quantity){
		challengeInfo = challengeInfo + $.Localize('#challenge_paragon')
		challengeInfo = challengeInfo.replace("@paragon_quantity", "<font color='#79BA6E'>"+challenge.paragon_quantity+"</font>")
	}
	if (challenge.disallowed_hero){
		challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_hero_constraint')
		var heroName = $.Localize('#'+challenge.disallowed_hero)
		challengeInfo = challengeInfo.replace("@heroname", "<font color='#79BA6E'>"+heroName+"</font>")
	}
	if (challenge.time_constraint){
		challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_time_constraint')
		challengeInfo = challengeInfo.replace("@time_constraint", "<font color='#79BA6E'>"+secondsToLegibleTime(challenge.time_constraint)+"</font>")
	}
	if (challenge.ability_constraint){
		var abilityIndex = parseInt(challenge.ability_constraint)
		challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_ability_constraint')
		challengeInfo = challengeInfo.replace("@ability","@Ability"+(abilityIndex+1))
		var localHero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())

		challengeInfo = updateSkillInTooltip(challengeInfo, localHero)
		challengeInfo = challengeInfo.replace("@letter",getHotkeyFromSkillIndex(localHero, abilityIndex))
	}
	if (challenge.no_deaths == 1){
		challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_no_deaths')
	}
	if (challenge.no_deaths == 2){
		challengeInfo = challengeInfo + "<br><font color='#FF0000'>-</font> " + $.Localize('#challenge_solo')
	}
	$('#challenge_detail_information').text = challengeInfo
	$('#challenge_detail_information').AddClass("none")
	$('#challenge_detail_information').SetFocus()

	$('#challenge_reward_title').text = $.Localize('#challenge_reward')
	$('#challenge_reward_normal').text = $.Localize('#ui_normal')
	$('#challenge_reward_elite').text = $.Localize('#ui_elite')
	$('#challenge_reward_legend').text = $.Localize('#ui_legend')

	var baseReward = parseInt(challenge.reward)
	$('#mithril_shards_value_normal').text = baseReward
	$('#mithril_shards_value_elite').text = baseReward*2
	$('#mithril_shards_value_legend').text = baseReward*6
}

function ChallengeTooltip()
{
	var panel = $('#challenge_title_box')
	var title = "<font color='#3D84FF'>"+$.Localize('#challenge_title')
	var tooltip = $.Localize('#challenge_description')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideChallengeTooltip()
{
	var panel = $('#challenge_title_box')
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


(function()
{
	populateChallenge();
	
})();

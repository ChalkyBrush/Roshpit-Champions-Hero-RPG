function dungeonVote(msg){
	$('#dungeon_vote_box').RemoveClass('invisible');
	$('#dungeon_vote_box').RemoveClass('animateEaseOutClass');
	$('#dungeon_vote_box').AddClass('animateEaseClass');
	var heroName = msg.hero
	var hero_image_name = "file://{images}/heroes/" + heroName + ".png";
	$('#hero_portrait_vote_initiator').SetImage( hero_image_name );
	var translatedHeroName = $.Localize( "#"+heroName)
	$('#initiator_hero_text').text = translatedHeroName
	var image = msg.dungeonImage;
	$.Msg(image)
	$('#dungeon_image').SetImage(image);
	$('#dungeon_title').text = $.Localize("#dungeon_"+msg.dungeonName+"_title")
	$('#initiation_text').text = $.Localize("#dungeon_initiation_text")
	var timer = 20
	for (i = 0; i <= timer; i++) { 
		$.Schedule(i, function(){
			$('#timer_text').text = timer
			timer = timer - 1
			if (timer == -1){
				endVote()
			}
		});
	}
	
	var recommendedLevelText = msg.recommendedLevelMin+"-"+msg.recommendedLevelMax
	if (msg.recommendedLevelMin == msg.recommendedLevelMax){
		recommendedLevelText = msg.recommendedLevelMin
	}
	$('#recommended_level_text').text = $.Localize("#dungeon_recommended_level")+": "+recommendedLevelText
	$('#vote_tip_text').text = $.Localize("#dungeon_vote_tip")
	var numPlayers = msg.numPlayers
	resetVoteColors()
	adjustPanelsForPlayerCount(msg, numPlayers)
}

function resetVoteColors(){
	for (i = 1; i <= 4; i++) {
		 $('#vote_color_'+i).RemoveClass('vote_green')
		 $('#vote_color_'+i).RemoveClass('vote_red')
		 $('#vote_color_'+i).AddClass('initiator_panel_background')		
	}
}

function endVote(){
	$.Schedule(2, function(){
		$('#dungeon_vote_box').RemoveClass('animateEaseClass');
		$('#dungeon_vote_box').AddClass('animateEaseOutClass');
		$.Schedule(0.45, function(){
			$('#dungeon_vote_box').AddClass('invisible');
		});	
	});
}

function vote(bStatus, playerNumber){
	if (bStatus){
		GameEvents.SendCustomGameEventToServer( "DungeonsvoteYesJS", {playerNumber: playerNumber});
	}else{
		GameEvents.SendCustomGameEventToServer( "DungeonsvoteNoJS", {playerNumber: playerNumber});
	}
}

function receiveVote(msg){
	var playerNumber = msg.playerNumber
	var status = msg.status
	$.Msg("vote Received")
	$.Msg(playerNumber)
	$('#vote_options'+playerNumber).AddClass('invisible')
	if (status){
		 $('#vote_color_'+playerNumber).RemoveClass('initiator_panel_background')
		 $('#vote_color_'+playerNumber).AddClass('vote_green')
	}else{
		 $('#vote_color_'+playerNumber).RemoveClass('initiator_panel_background')
		 $('#vote_color_'+playerNumber).AddClass('vote_red')
	}
}


function adjustPanelsForPlayerCount(msg, numPlayers){
	var hero_image_name = "file://{images}/heroes/" + msg.hero1 + ".png";
	var localPlayer = Players.GetLocalPlayer();
	$('#hero_portrait_voter1').SetImage( hero_image_name );
	$('#player_voter_name1').text = Players.GetPlayerName(msg.player1);
	if (localPlayer == msg.player1){
		$('#vote_options1').RemoveClass('invisible')
	}
	if (localPlayer == msg.player2){
		$('#vote_options2').RemoveClass('invisible')
	}
	if (localPlayer == msg.player3){
		$('#vote_options3').RemoveClass('invisible')
	}
	if (localPlayer == msg.player4){
		$('#vote_options4').RemoveClass('invisible')
	}
	if (numPlayers >= 2){
		hero_image_name = "file://{images}/heroes/" + msg.hero2 + ".png";
		$('#hero_portrait_voter2').SetImage( hero_image_name );
		$('#player_voter_name2').text = Players.GetPlayerName(msg.player2);
	}else{
		$("#player_vote_2").AddClass('invisible');
		$("#player_vote_3").AddClass('invisible');
		$("#player_vote_4").AddClass('invisible');
	}
	if (numPlayers >= 3){
		hero_image_name = "file://{images}/heroes/" + msg.hero3 + ".png";
		$('#hero_portrait_voter3').SetImage( hero_image_name );
		$('#player_voter_name3').text = Players.GetPlayerName(msg.player3);
	}else{
		$("#player_vote_3").AddClass('invisible');
		$("#player_vote_4").AddClass('invisible');
	}
	if (numPlayers >= 4){
		hero_image_name = "file://{images}/heroes/" + msg.hero4 + ".png";
		$('#hero_portrait_voter4').SetImage( hero_image_name );
		$('#player_voter_name4').text = Players.GetPlayerName(msg.player4);
	}else{
		$("#player_vote_4").AddClass('invisible');
	}

}

(function () {
  GameEvents.Subscribe( "DungeonVote", dungeonVote );
  GameEvents.Subscribe( "receiveVote", receiveVote );
  GameEvents.Subscribe( "votingEnd", endVote );
})();

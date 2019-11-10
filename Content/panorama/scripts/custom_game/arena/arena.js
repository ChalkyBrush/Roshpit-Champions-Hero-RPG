mBGM = -1;
mOpponentSelect = -1;
mChampionsData = 0;

function InitializeArena(){
    GameUI.QuestLog = 0
    GameUI.QuestLogLock = 0
}

function OpenLeftLeaderboard(msg){
	var parent = $('#arena_container')
    var board = $.CreatePanel("Panel", parent, "leaderboard")
    board.BLoadLayoutSnippet("arena_scoreboard");
    $.Msg("OPENING LEADERBOARD")
    $('#arena_container').AddClass('animateEaseClass')
    for (i = 1; i <= 20; i++) { 
    	 createLeaderboardItem(i, "charactername", board.FindChildTraverse("leaderboard-leaders-box"), msg.playerRank)
    }
}

function createLeaderboardItem(position, text, parent, rank)
{
	var listItem = $.CreatePanel("Panel", parent, "listitem"+position)
	listItem.BLoadLayoutSnippet("arena_list_item");
	if (position < 4){
		listItem.AddClass('top_three')
		var image = listItem.FindChildTraverse('trophy_image')
		var imageName = "file://{images}/custom_game/ui/arena/trophy"+position+".png"
		image.SetImage(imageName)
	}
	var rankLabel = listItem.FindChildTraverse('list_item_rank')
	rankLabel.text = position+"."
	var nameLabel = listItem.FindChildTraverse('list_item_name')
    if (rank == position)
    {
        nameLabel.text = Players.GetPlayerName( Players.GetLocalPlayer() )
    }else if (rank>position){
	   nameLabel.text = $.Localize('#champion_league_challenger_'+position)
    }else if (rank<position){
        var newPosition = parseInt(position-1)
        nameLabel.text = $.Localize('#champion_league_challenger_'+newPosition)
    }
}

function CloseLeftLeaderboard(){
    GameUI.donationAppendContainer = false
	$('#arena_container').AddClass('animateEaseOutClass')
	$.Schedule(0.45, function(){
		$('#arena_container').RemoveClass('animateEaseClass')
		$('#arena_container').RemoveClass('animateEaseOutClass')
		$('#arena_container').RemoveAndDeleteChildren(0);
	});
}

function ArenaNPCDialogue(msg){
	var parent = $('#arena_container')
    var dialogue = $.CreatePanel("Panel", parent, "leaderboard")
    dialogue.BLoadLayoutSnippet("arena_npc_dialogue");
    $('#arena_container').AddClass('animateEaseClass')

    var heroPortraitContainer = dialogue.FindChildTraverse('dialogue_portrait')
    var button = $.CreatePanel("DOTAHeroImage", heroPortraitContainer, "dialogue_portrait_scene");
    button.AddClass("HeroButton");
    button.SetScaling("stretch-to-fit-x-preserve-aspect");
    button.heroname = "npc_dota_hero_lina";
    button.heroimagestyle = "portrait";

    var dialogueHeader = dialogue.FindChildTraverse('dialogue_name')
    dialogueHeader.text = $.Localize('#champions_league_attendant')

    var dialogueLabel = dialogue.FindChildTraverse('dialogue_text_text')
    dialogueLabel.level = 0
    var playerCount = parseInt(msg.numPlayers)
    if (playerCount == 1){
    	typeText(dialogueLabel, $.Localize('#arena_league_attendant_player_state_0'), 0)
    	dialogue.FindChildTraverse('dialogue_label1').text = $.Localize('#arena_league_attendant_choice_0_option_1')
    	dialogue.FindChildTraverse('dialogue_label2').text = $.Localize('#arena_league_attendant_choice_0_option_2')
 		dialogue.FindChildTraverse('option1').SetPanelEvent('onactivate', function DialogueOption1() {
 			var accept = 1
 			var npc = "champion_attendant"
 			var intattr = 0
 			dialogueLabel.level = 1
 			Game.EmitSound("Arena.Accept")
        	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:0} );
        	var newMsg = {npc: npc, intattr: intattr}
        	setDialogueChampionsLeagueAttendant(dialogue, newMsg)
		})
 		dialogue.FindChildTraverse('option2').SetPanelEvent('onactivate', function DialogueOption2() {
 			var accept = 0
 			var npc = "champion_attendant"
 			var intattr = 0
 			Game.EmitSound("Arena.Decline")
        	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:0} );
        	CloseLeftLeaderboard()
        	removeDialogueOptions(dialogue)
        	dialogueLabel.level = 100
		})
    }else{
    	removeDialogueOptions(dialogue)
    	typeText(dialogueLabel, $.Localize("#arena_league_attendant_player_restriction"))
    }
}

function setDialogueChampionsLeagueAttendant(dialogue, msg){
	var npc = msg.npc
	var intattr = msg.intattr
	var dialogueLabel = dialogue.FindChildTraverse('dialogue_text_text')
	if (npc == "champion_attendant"){
		if (intattr == 0){
	    	typeText(dialogueLabel, $.Localize('#arena_league_attendant_player_state_1'), 1)
	    	dialogue.FindChildTraverse('dialogue_label1').text = $.Localize('#arena_league_attendant_choice_1_option_1')
	    	dialogue.FindChildTraverse('dialogue_label2').text = $.Localize('#arena_league_attendant_choice_1_option_2')
	 		dialogue.FindChildTraverse('option1').SetPanelEvent('onactivate', function DialogueOption1() {
	 			var accept = 1
	 			var npc = "champion_attendant"
	 			var intattr = 1
	 			Game.EmitSound("Arena.Accept")
	        	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:intattr} );
	        	removeDialogueOptions(dialogue)
	        	dialogueLabel.level = 2
	        	CloseLeftLeaderboard()
	        	// var newMsg = {npc = npc, intattr = intattr}
	        	// setDialogue(dialogue, newMsg)
			})
	 		dialogue.FindChildTraverse('option2').SetPanelEvent('onactivate', function DialogueOption2() {
	 			var accept = 0
	 			var npc = "champion_attendant"
	 			var intattr = 1
	 			Game.EmitSound("Arena.Decline")
	        	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:0} );
	        	CloseLeftLeaderboard()
	        	removeDialogueOptions(dialogue)
	        	dialogueLabel.level = 100
			})			
		}
	}
}

function removeDialogueOptions(dialogue)
{
	dialogue.FindChildTraverse('dialogue_options').RemoveAndDeleteChildren(0);
}

function typeText(label, text, labelLevel)
{
	var j = 1
	var loop = text.length
	label.active = true
	for (i = 1; i < loop; i++) {
	 	$.Schedule(0.01*i, function(){
            if (!(label)){
                return false
            }
	 		if (label.level <= labelLevel){
		 		j = j + 1
		 		label.text = text.substring(0,j);
	 		}else{
	 			return
	 		}
	 	});
	}
}

function ViewSign(msg)
{
	var text = $.Localize(msg.sign)
	var parent = $('#arena_container')
    var sign = $.CreatePanel("Panel", parent, "leaderboard")
    sign.BLoadLayoutSnippet("arena_sign");
    $('#arena_container').AddClass('animateEaseClass')
    var label = sign.FindChildTraverse('sign_label')
    label.text = text;	
}

function ArenaGenericNPCDialogue(msg){
	var parent = $('#arena_container')
    var dialogue = $.CreatePanel("Panel", parent, "leaderboard")
    dialogue.BLoadLayoutSnippet("arena_npc_dialogue");
    $('#arena_container').AddClass('animateEaseClass')

    var portraitHero = msg.portraitHero
    var headerText = msg.headerText
    var messageText = msg.messageText
    var bDialogue = msg.bDialogue
    var subLabel = msg.subLabel
    var labelCost = msg.labelCost
    var bAltmessage = msg.bAltmessage
    var bAltCondition = msg.bAltCondition
    var intattr = msg.intattr
    var option1 = msg.option1
    var option2 = msg.option2


    var heroPortraitContainer = dialogue.FindChildTraverse('dialogue_portrait')
    var button = $.CreatePanel("DOTAHeroImage", heroPortraitContainer, "dialogue_portrait_scene");
    button.AddClass("HeroButton");
    button.SetScaling("stretch-to-fit-x-preserve-aspect");
    button.heroname = portraitHero;
    button.heroimagestyle = "portrait";

    var dialogueHeader = dialogue.FindChildTraverse('dialogue_name')
    dialogueHeader.text = $.Localize(headerText)

    var dialogueLabel = dialogue.FindChildTraverse('dialogue_text_text')
    dialogueLabel.level = 0
    var playerCount = parseInt(msg.numPlayers)

    if (!(subLabel === undefined)){
    	dialogue.FindChildTraverse('dialogue_price_box').RemoveClass('invisible')
    	dialogue.FindChildTraverse('dialogue_price_amount').text = labelCost
    }
    typeText(dialogueLabel, $.Localize(messageText), 0)
    if (bDialogue == 1){
    	if (!(subLabel === undefined)){
    		dialogue.FindChildTraverse('dialogue_price_box')
    	}
    	dialogue.FindChildTraverse('dialogue_label1').text = $.Localize(option1)
    	dialogue.FindChildTraverse('dialogue_label2').text = $.Localize(option2)
 		dialogue.FindChildTraverse('option1').SetPanelEvent('onactivate', function DialogueOption1() {
 			var accept = 1
 			var npc = headerText
 			dialogueLabel.level = 1
        	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:intattr, playerID: Players.GetLocalPlayer()} );
        	// var newMsg = {npc: npc, intattr: intattr}
        	Game.EmitSound("Arena.Accept")
		})
 		dialogue.FindChildTraverse('option2').SetPanelEvent('onactivate', function DialogueOption2() {
 			var accept = 0
 			var npc = headerText
        	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:intattr, playerID: Players.GetLocalPlayer()} );
        	CloseLeftLeaderboard()
        	removeDialogueOptions(dialogue)
        	dialogueLabel.level = 100
        	Game.EmitSound("Arena.Decline")
		})
    }else{
    	removeDialogueOptions(dialogue)
    }

}

function ArenaTerminal(msg){
    var parent = $('#arena_container')
    var sign = $.CreatePanel("Panel", parent, "arena_terminal")
    sign.BLoadLayoutSnippet("arena_terminal");
    $('#arena_container').AddClass('animateEaseClass') 
    sign.FindChildTraverse('terminal_header_text').text = $.Localize('arena_left_leaderboard_title')
    var heroName = msg.heroName
    var championsLeague = msg.ChampionsLeague
    var heroPortraitContainer = sign.FindChildTraverse('hero_portrait')
    var portrait = $.CreatePanel("DOTAHeroImage", heroPortraitContainer, "terminal_hero_portrait");
    portrait.heroname = heroName;
    mChampionsData = championsLeague
    portrait.heroimagestyle = "portrait";
    sign.FindChildTraverse('hero_name_text').text = Players.GetPlayerName( Players.GetLocalPlayer() )
    sign.FindChildTraverse('rank_value').text = championsLeague.rank
    sign.FindChildTraverse('enemy_portrait').AddClass('invisible')
    if (msg.ChampionsLeague.state == -1){
        sign.FindChildTraverse('hero_name_text').text = $.Localize('terminal_registrant_not_found')
        var imageName = "file://{images}/custom_game/ui/silhouette.png"
        portrait.SetImage(imageName)
        sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_inactive')
        sign.FindChildTraverse('champions_league_start_button_label').text=$.Localize('terminal_cant_register')
        sign.FindChildTraverse('rank_value').text = "--"
        sign.FindChildTraverse('champions_league_change_challenger_button').AddClass('champions_league_start_button_inactive')
        sign.FindChildTraverse('champions_league_change_challenger_button_label').text="--"
        
    }
    else if(msg.ArenaChampions.battlePrep){
         sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_inactive')
         sign.FindChildTraverse('champions_league_start_button_label').text=$.Localize('terminal_cant_register')
        sign.FindChildTraverse('champions_league_change_challenger_button').AddClass('champions_league_start_button_inactive')
        sign.FindChildTraverse('champions_league_change_challenger_button_label').text=$.Localize("terminal_cant_choose_opponent")       
    }else{
        sign.FindChildTraverse('champions_league_change_challenger_button').AddClass('champions_league_start_button_active')
        // sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_active')
         sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_inactive')
         sign.FindChildTraverse('champions_league_start_button_label').text=$.Localize('terminal_cant_register')
        // sign.FindChildTraverse('champions_league_start_button').SetPanelEvent('onactivate', function TerminalButtonActivate() {
        //     var accept = 1
        //     var intattr = 0
        //     var npc = "arena_terminal"
        //     GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:intattr, playerID: Players.GetLocalPlayer()} );
        //     CloseLeftLeaderboard()
        //     Game.EmitSound("Arena.Accept")
        // })
        sign.FindChildTraverse('champions_league_change_challenger_button').SetPanelEvent('onactivate', function TerminalSelectOpponentActivate() {
            openOpponentSelectMenu(sign, championsLeague.rank)
        })
    }
     
}

function openOpponentSelectMenu(sign, rank)
{
    var parent = sign.FindChildTraverse('opponent_select_box')
    var menu = $.CreatePanel("Panel", parent, "arena_select_opponent")
    menu.BLoadLayoutSnippet("champions_league_opponent_select");
    for (i = 20; i >= 11; i--) { 
        setOpponentButton(menu, i, "right_terminal_column_a_opponent", rank, sign)
    }  
    for (i = 10; i >= 1; i--) { 
        setOpponentButton(menu, i, "right_terminal_column_b_opponent", rank, sign)
    }  
}

function setOpponentButton(menu, i, columnA, rank, sign)
{
    var buttonText = i+".    "+$.Localize("#champion_league_challenger_"+i)
    var parent = sign.FindChildTraverse('opponent_select_box')
    var column = menu.FindChildTraverse(columnA)
    var button = $.CreatePanel("Panel", column, "arena_select_opponent"+i)
    button.rank = i
    button.BLoadLayoutSnippet("champions_league_opponent_select_individual")
    if (rank <= i+1){
        var j = i+1
        button.rank = i
        button.AddClass('champions_league_opponent_active')
        buttonText = j+".    "+$.Localize("#champion_league_challenger_"+i)
        if (rank == i+1){
            buttonText = i+".    "+$.Localize("#champion_league_challenger_"+i)
        }
        button.SetPanelEvent('onactivate', function SetOpponentRank() {
            $.Msg(button)
            sign.opponent = button.rank
            parent.RemoveAndDeleteChildren(0)
            Game.EmitSound("Arena.Accept")
            UpdateArenaTerminalOpponent(sign, sign.opponent)
        });
    }else{
        var buttonText = "--"
    }
    var label = button.FindChildTraverse('champions_opponent_label')
    label.text = buttonText    
}

function UpdateArenaTerminalOpponent(terminal, opponentNumber)
{
    terminal.opponent = opponentNumber
    $.Msg(terminal.opponent)
    var button = terminal.FindChildTraverse('champions_league_start_button')
    button.RemoveClass('champions_league_start_button_inactive')
    button.AddClass('champions_league_start_button_active')
    terminal.FindChildTraverse('enemy_name_text').text = $.Localize('#champion_league_challenger_'+terminal.opponent)
    terminal.FindChildTraverse('champions_league_start_button_label').text=$.Localize('start_champions_league_battle')
    var enemyPortraitContainer = terminal.FindChildTraverse('enemy_portrait')
    enemyPortraitContainer.RemoveClass('invisible')
    var portrait = $.CreatePanel("DOTAHeroImage", enemyPortraitContainer, "terminal_enemy_portrait");
    portrait.heroname = getHeroPortraitForRank(terminal.opponent);
    portrait.heroimagestyle = "portrait";
    var highScoreLabel = terminal.FindChildTraverse('champion_high_score_text')
    highScoreLabel.RemoveClass('invisible')
    var highscore = getScoreForRank(opponentNumber)
    if (highscore >= 0){
        highScoreLabel.text = $.Localize('#terminal_high_score')+" "+highscore
    }else{
        highScoreLabel.text = $.Localize('#terminal_high_score')+" --"
    }
    
    button.SetPanelEvent('onactivate', function TerminalButtonActivate() {
        var accept = 1
        var intattr = 0
        var npc = "arena_terminal"
        GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:intattr, playerID: Players.GetLocalPlayer(), rank:terminal.opponent} );
        CloseLeftLeaderboard()
        Game.EmitSound("Arena.Accept")
    })
}

function getScoreForRank(rank)
{
    if (rank == 20){
        return mChampionsData.score20
    }else if (rank == 19){
        return mChampionsData.score19
    }else if (rank == 18){
        return mChampionsData.score18
    }else if (rank == 17){
        return mChampionsData.score17
    }else if (rank == 16){
        return mChampionsData.score16
    }else if (rank == 15){
        return mChampionsData.score15
    }else if (rank == 14){
        return mChampionsData.score14
    }else if (rank == 13){
        return mChampionsData.score13
    }else if (rank == 12){
        return mChampionsData.score12
    }else if (rank == 11){
        return mChampionsData.score11
    }else if (rank == 10){
        return mChampionsData.score10
    }else if (rank == 9){
        return mChampionsData.score9
    }else if (rank == 8){
        return mChampionsData.score8
    }else if (rank == 7){
        return mChampionsData.score7
    }else if (rank == 6){
        return mChampionsData.score6
    }else if (rank == 5){
        return mChampionsData.score5
    }else if (rank == 4){
        return mChampionsData.score4
    }else if (rank == 3){
        return mChampionsData.score3
    }else if (rank == 2){
        return mChampionsData.score2
    }else if (rank == 1){
        return mChampionsData.score1
    }
}

function getHeroPortraitForRank(rank)
{
    if (rank == 20){
        return "npc_dota_hero_dark_seer"
    }else if (rank == 19){
        return "npc_dota_hero_phantom_assassin"
    }else if (rank == 18){
        return "npc_dota_hero_alchemist"
    }else if (rank == 17){
        return "npc_dota_hero_brewmaster"
    }else if (rank == 16){
        return "npc_dota_hero_centaur"
    }else if (rank == 15){
        return "npc_dota_hero_riki"
    }else if (rank == 14){
        return "npc_dota_hero_bristleback"
    }else if (rank == 13){
        return "npc_dota_hero_ursa"
    }else if (rank == 12){
        return "npc_dota_hero_troll_warlord"
    }else if (rank == 11){
        return "npc_dota_hero_axe"
    }else if (rank == 10){
        return "npc_dota_hero_skeleton_king"
    }else if (rank == 9){
        return "npc_dota_hero_silencer"
    }else if (rank == 8){
        return "npc_dota_hero_beastmaster"
    }else if (rank == 7){
        return "npc_dota_hero_phantom_lancer"
    }else if (rank == 6){
        return "npc_dota_hero_bane"
    }else if (rank == 5){
        return "npc_dota_hero_dragon_knight"
    }else if (rank == 4){
        return "npc_dota_hero_antimage"
    }else if (rank == 3){
        return "npc_dota_hero_rubick"
    }else if (rank == 2){
        return "npc_dota_hero_sven"
    }else if (rank == 1){
        return "npc_dota_hero_omniknight"
    }
}

function InitArenaTimer(msg)
{
    var parent = $('#arena_fade_container')
    var timer = $.CreatePanel("Panel", parent, "arena_battle_panel")
    timer.BLoadLayoutSnippet('arena_battle_timer')
    var timerText = msg.timer
    if (timerText < 10){
        timerText = "0"+timer
    }
    timer.FindChildTraverse('champions_league_start_timer').text = '0:'+timerText
    
}

function UpdateArenaTimer(msg)
{
    var timerText = msg.timer
    if (parseInt(timerText) < 10){
        timerText = "0"+timerText
    }
    var timer = $('#arena_battle_panel')
    timer.FindChildTraverse('champions_league_start_timer').text = '0:'+timerText
}

function ArenaFadeToBlack(msg)
{
    var fadeBackDelay = msg.fadeBackDelay
    var parent = $('#arena_fade_container')
    var blackBox = $.CreatePanel("Panel", parent, "black-box")
    blackBox.AddClass('black-mask')
    blackBox.AddClass('animateEaseClass')
    $.Schedule(fadeBackDelay, function(){
        blackBox.AddClass('animateEaseOutClass')
        $.Schedule(0.45, function(){
            $('#arena_fade_container').RemoveAndDeleteChildren(0);
        });
    });
    // timer.BLoadLayoutSnippet('arena_battle_timer')
}

function ArenaBattleUI(msg){
    var parent = $('#arena_battle_container')
    var arenaUI = $.CreatePanel("Panel", parent, "arenaUI-container")
    arenaUI.BLoadLayoutSnippet('arena_battle')
    var crowdsizeText = $.Localize('#arena_crowdsize_text')+": "+parseInt(msg.crowdSizeL+msg.crowdSizeR)
    arenaUI.FindChildTraverse('crowd_size').text = crowdsizeText
    arenaUI.FindChildTraverse('left-fighter-name').text = Players.GetPlayerName( Players.GetLocalPlayer() )
    var enemyNameText = $.Localize('#'+msg.enemyName)
    arenaUI.FindChildTraverse('right-fighter-name').text = enemyNameText
    arenaUI.FindChildTraverse('left-right-health').style.width = "100%"
    arenaUI.FindChildTraverse('right-right-health').style.width = "100%"
    arenaUI.FindChildTraverse('left-crowd-label').text = $.Localize('arena_fan_support')+": "
    arenaUI.FindChildTraverse('left-crowd-label-number').text = msg.crowdSizeL
    arenaUI.FindChildTraverse('right-crowd-label-number').text = msg.crowdSizeR
    arenaUI.FindChildTraverse('skip_button').SetPanelEvent('onactivate', function SkipButtonActivate() {
            hideArenaSkipButton();
            GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:1, npc:"skip", intattr:0, playerID: Players.GetLocalPlayer()} );
        });
    UpdateCrowdFavor(msg)
    if (msg.bo < 5){
        arenaUI.FindChildTraverse('left-bo3').AddClass('invisible')
        arenaUI.FindChildTraverse('right-bo3').AddClass('invisible')
    }

}

function hideArenaSkipButton()
{
    var arenaUI = $('#arenaUI-container')
    arenaUI.FindChildTraverse('skip_button').AddClass('invisible')
    arenaUI.FindChildTraverse('skip_button').SetPanelEvent('onactivate', function emptyFunction() {
    });
}

function updateTimerBattle(msg)
{
    var timer = $('#arenaUI-container')
    var seconds = msg.timeElapsed
    var minutes = fgetMinutes(seconds)
    var displaySeconds = fgetSeconds(seconds)
    timer.FindChildTraverse('arena_battle_timer').text = minutes+":"+displaySeconds
}

function fgetMinutes(seconds)
{
    var minutes = Math.floor(seconds/60)
    return minutes
}

function fgetSeconds(seconds)
{
    seconds = seconds%60
    if (seconds < 10){
        seconds = "0"+seconds
    }
    return seconds
}

function UpdateCrowdFavor(msg)
{
    var arenaUI = $('#arenaUI-container')
    var percentageL = parseInt(msg.crowdSizeL*100/(msg.crowdSizeR+msg.crowdSizeL))
    var percentageR = 100 - percentageL    
    arenaUI.FindChildTraverse('left-right-crowd').style.width = percentageL+"%"
    arenaUI.FindChildTraverse('right-right-crowd').style.width = percentageR+"%"
    arenaUI.FindChildTraverse('left-crowd-label-number').text = msg.crowdSizeL
    arenaUI.FindChildTraverse('right-crowd-label-number').text = msg.crowdSizeR
}

function UpdateArenaHP(msg)
{
    var arenaUI = $('#arenaUI-container')
    if (arenaUI === null){
        return
    }
    var healthBar = arenaUI.FindChildTraverse('right-right-health')
    if (msg.side == "L"){
        healthBar = arenaUI.FindChildTraverse('left-right-health')
    }
    var percentage = msg.currentHealth*100/msg.maxHealth
    healthBar.style.width = percentage+"%"
}

function RemoveBattleUI(){
    $('#arena_battle_container').RemoveAndDeleteChildren(0)
}

function VSClash(msg){
    var parent = $('#arena_container')
    var arenaUI = $.CreatePanel("Panel", parent, "arenaVS-container")
    arenaUI.BLoadLayoutSnippet('vs_clash')  

    var allyHero = msg.allyHero
    var enemyHero = msg.enemyHero
    var enemyName = msg.enemyName

    var heroImageL = arenaUI.FindChildTraverse('left_hero_image')
    heroImageL.heroname = allyHero;
    heroImageL.heroimagestyle = "portrait";

    var heroImageR = arenaUI.FindChildTraverse('right_hero_image')
    heroImageR.heroname = enemyHero;
    heroImageR.heroimagestyle = "portrait";

    arenaUI.FindChildTraverse('left_vs_name_label').text = Players.GetPlayerName( Players.GetLocalPlayer() )
    arenaUI.FindChildTraverse('right_vs_name_label').text = $.Localize(enemyName)

    arenaUI.FindChildTraverse('left_vs_clash').AddClass('animateFromTop')
    arenaUI.FindChildTraverse('right_vs_clash').AddClass('animateFromBottom')
    Game.EmitSound("Arena.PreBattleHype")
    $.Schedule(2.0, function(){
        var vsMessage = arenaUI.FindChildTraverse('vs_message')
        vsMessage.RemoveClass('invisible')
        vsMessage.AddClass('vsFadeIn')
        var whiteBG = arenaUI.FindChildTraverse('vs_container_bg_white')
        whiteBG.RemoveClass('invisible')
        whiteBG.AddClass('vsFadeIn')
        $.Schedule(0.55, function(){
            whiteBG.RemoveClass('vsFadeIn')
            whiteBG.AddClass('animateEaseOutClass')
            $.Schedule(0.49, function(){
                whiteBG.AddClass('invisible')
            });
        });
    });
    $.Schedule(5.0, function(){
        arenaUI.AddClass('animateEaseOutClass')
        $.Schedule(0.49, function(){
            parent.RemoveAndDeleteChildren(0)
        });        
    });
}

function updateBo(msg){
    var arenaUI = $('#arenaUI-container')
    if (msg.scoreL > 0){
        arenaUI.FindChildTraverse('left-bo1').AddClass('bo-winning')
    }
    if (msg.scoreL > 1){
        arenaUI.FindChildTraverse('left-bo2').AddClass('bo-winning')
    }
    if (msg.scoreL > 2){
        arenaUI.FindChildTraverse('left-bo3').AddClass('bo-winning')
    }
    if (msg.scoreR > 0){
        arenaUI.FindChildTraverse('right-bo1').AddClass('bo-winning')
    }
    if (msg.scoreR > 1){
        arenaUI.FindChildTraverse('right-bo2').AddClass('bo-winning')
    }
    if (msg.scoreR > 2){
        arenaUI.FindChildTraverse('right-bo3').AddClass('bo-winning')
    }
}

function championsLeagueLose(msg){
    var parent = $('#arena_container')
    var arenaUI = $.CreatePanel("Panel", parent, "champions-loss-container")
    arenaUI.AddClass('animateEaseClass')
    arenaUI.BLoadLayoutSnippet('champions_league_loss')
    var allyHero = msg.allyHero 
    arenaUI.FindChildTraverse('league_hero_image').heroname = allyHero
    arenaUI.FindChildTraverse('league_hero_image').heroimagestyle = "portrait";
    var outcomeMessage = msg.outcomeMessage
    arenaUI.FindChildTraverse('champions_league_outcome_message').text = $.Localize(outcomeMessage)
    arenaUI.FindChildTraverse('champions_league_outcome_name').text = Players.GetPlayerName( Players.GetLocalPlayer() )
    $.Schedule(1.5, function(){
        var timeLabel = arenaUI.FindChildTraverse('champions_league_time_bonus')
        timeLabel.text = $.Localize('#arena_time_bonus')
        timeLabel.RemoveClass('invisible')
        timeLabel.AddClass('animateEaseClass')

        var timeValue = arenaUI.FindChildTraverse('champions_league_time_bonus_value')
        timeValue.text = msg.timeBonus
        timeValue.RemoveClass('invisible')
        timeValue.AddClass('animateEaseClass')
    });
    $.Schedule(2.5, function(){
        var styleLabel = arenaUI.FindChildTraverse('champions_league_style_bonus')
        styleLabel.text = $.Localize('#arena_style_bonus')
        styleLabel.RemoveClass('invisible')
        styleLabel.AddClass('animateEaseClass')

        var styleValue = arenaUI.FindChildTraverse('champions_league_style_bonus_value')
        styleValue.text = msg.styleBonus
        styleValue.RemoveClass('invisible')
        styleValue.AddClass('animateEaseClass')
    });
    $.Schedule(4.0, function(){
        var totalLabel = arenaUI.FindChildTraverse('champions_league_total_bonus')
        totalLabel.text = $.Localize('#arena_total_bonus')
        totalLabel.RemoveClass('invisible')
        totalLabel.AddClass('animateEaseClass')

        var totalValue = arenaUI.FindChildTraverse('champions_league_total_bonus_value')
        totalValue.text = msg.styleBonus + msg.timeBonus
        totalValue.RemoveClass('invisible')
        totalValue.AddClass('animateEaseClass')
    });
    $.Schedule(5.5, function(){
        var rankLabel = arenaUI.FindChildTraverse('champions_league_rank')
        rankLabel.text = $.Localize('#terminal_rank_display')+" "+msg.rank
        rankLabel.RemoveClass('invisible')
        rankLabel.AddClass('animateEaseClass')
    });
    $.Schedule(7.0, function(){
        if (msg.rankUp > 0){
            Game.EmitSound("Arena.ChampionsLeague.RankUp")
            var arrowPanel = arenaUI.FindChildTraverse('rank-up-arrow')
            arrowPanel.RemoveClass('invisible')
            var rankLabel = arenaUI.FindChildTraverse('champions_league_rank')
            var newRank = msg.rank-1
            rankLabel.text = $.Localize('#terminal_rank_display')+" "+newRank
        }
    });
 
 
    $.Schedule(11.0, function(){
        arenaUI.AddClass('animateEaseOutClass')
        $.Schedule(0.49, function(){
            parent.RemoveAndDeleteChildren(0)
        });        
    });    
}

function BGMstart(msg)
{
    var songName = msg.songName
    if (!(GameUI.CustomUIConfig().muteMusic == 1)){
        mBGM = Game.EmitSound( songName )
    }
}

function BGMend(msg)
{
    Game.StopSound( mBGM )
}

function PitTerminal(msg){
    var parent = $('#arena_container')
    var sign = $.CreatePanel("Panel", parent, "pit_terminal")
    var pitLevelAvailable = msg.pitData.pit_level
    sign.BLoadLayoutSnippet("pit_terminal");
    $('#arena_container').AddClass('animateEaseClass') 
    sign.FindChildTraverse('terminal_header_text').text = $.Localize('tooltip_pit_of_trials')
    var heroName = msg.heroName
    var championsLeague = msg.ChampionsLeague
    var heroPortraitContainer = sign.FindChildTraverse('hero_portrait')
    var portrait = $.CreatePanel("DOTAHeroImage", heroPortraitContainer, "terminal_hero_portrait");
    portrait.heroname = heroName;
    mChampionsData = championsLeague
    portrait.heroimagestyle = "portrait";
    sign.FindChildTraverse('hero_name_text').text = Players.GetPlayerName( Players.GetLocalPlayer() )
    sign.FindChildTraverse('pit_level_label').text = $.Localize("tooltip_pit_highest_level") + ":"
    sign.FindChildTraverse('pit_level_value').text = msg.pitData.pit_level

    // msg.lockoutStatus = 1
    
    updatePitData(sign)
    for (i = 1; i <= 7; i++) { 
        var star = sign.FindChildTraverse('pit_star_'+i)
        star.level = i
        star.SetAttributeInt( "star_level", i )
        if (pitLevelAvailable >= (i-1)){
            sign.FindChildTraverse('pit_star_'+i).AddClass('pit_star_available')
            setPitSelection(sign, i, pitLevelAvailable, sign.FindChildTraverse('pit_star_'+i), msg.lockoutStatus)
        }else{
            sign.FindChildTraverse('pit_star_'+i).AddClass('pit_star_unavailable')
        }

    }
    
    
    if (msg.lockoutStatus == 1){
         sign.FindChildTraverse('pit_lockout_label').text = $.Localize("tooltip_lock_out")
         sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_inactive')
         sign.FindChildTraverse('champions_league_start_button_label').text=$.Localize("tooltip_dungeon_lockout")
    }
    else if(msg.lockoutStatus == 0){
         sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_inactive')
         sign.FindChildTraverse('champions_league_start_button_label').text=$.Localize('tooltip_select_pit_level')      
    }
    else if(msg.lockoutStatus == 2){
         sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_inactive')
         sign.FindChildTraverse('champions_league_start_button_label').text=$.Localize("tooltip_pit_open")      
    }
    
}

function setPitSelection(sign, level, pitLevelAvailable, star, lockout)
{
     star.SetPanelEvent('onactivate', function StarActivate() {
        sign.starLevel = star.level
        setPitLevel(sign, sign.starLevel, pitLevelAvailable, star, lockout)
    })   
}

function GetPitModData(level)
{
    var enemyAttackDamage = 0
    var enemyArmorsAndPierces = 0
    var enemyHealth = 0
    if (level == 2){
        enemyAttackDamage = 20
        enemyArmorsAndPierces = 30
        enemyHealth = 30
    }else if (level == 3){
        enemyAttackDamage = 40
        enemyArmorsAndPierces = 60
        enemyHealth = 60
    }else if (level == 4){
        enemyAttackDamage = 60
        enemyArmorsAndPierces = 90
        enemyHealth = 90
    }else if (level == 5){
        enemyAttackDamage = 80
        enemyArmorsAndPierces = 120
        enemyHealth = 120
    }else if (level == 6){
        enemyAttackDamage = 100
        enemyArmorsAndPierces = 150
        enemyHealth = 150
    }else if (level == 7){
        enemyAttackDamage = 120
        enemyArmorsAndPierces = 180
        enemyHealth = 180
    }
    return [enemyAttackDamage, enemyArmorsAndPierces, enemyHealth]
}

function setPitLevel(sign, starLevel, pitLevelAvailable, star, lockout)
{
    $.Msg(starLevel)
    $.Msg(star.level)
    sign.pitLevel = starLevel
    sign.FindChildTraverse('pit_enemy_data_row_1').RemoveClass('invisible')
    sign.FindChildTraverse('pit_enemy_data_row_2').RemoveClass('invisible')
    sign.FindChildTraverse('pit_enemy_data_row_3').RemoveClass('invisible')
    var pitData = GetPitModData(starLevel)
    sign.FindChildTraverse('enemy_attack_damage_label').text = $.Localize('tooltip_pit_enemy_damage')+": "
    sign.FindChildTraverse('enemy_attack_damage_value').text = "+"+pitData[0]+"%"
    sign.FindChildTraverse('enemy_resistance_label').text = $.Localize('tooltip_pit_enemy_armors_and_pierces')+": "
    sign.FindChildTraverse('enemy_resistance_value').text = "+"+pitData[1]+"%"
    sign.FindChildTraverse('enemy_paragon_label').text = $.Localize('tooltip_pit_enemy_health')+": "
    sign.FindChildTraverse('enemy_paragon_value').text = "+"+pitData[2]+"%"
    sign.FindChildTraverse('enemy_name_text').text = $.Localize('tooltip_pit_of_trials') + " " + $.Localize("weapon_current_level") + " " + starLevel
    for (i = 1; i <= 7; i++) { 
        if (i <= starLevel){
            var star = sign.FindChildTraverse('pit_star_'+i)
            star.AddClass('pit_star_active')
            star.RemoveClass('pit_star_available')
        }else{
            if (pitLevelAvailable >= (i-1)){
                var star = sign.FindChildTraverse('pit_star_'+i)
                star.RemoveClass('pit_star_active')
                star.AddClass('pit_star_available')
            }else{
                var star = sign.FindChildTraverse('pit_star_'+i)
                star.AddClass('pit_star_inactive')
                // star.RemoveClass('pit_star_active')
            }
        }
    }
    if (lockout == 0){
        sign.FindChildTraverse('champions_league_start_button').AddClass('champions_league_start_button_active')
        sign.FindChildTraverse('champions_league_start_button').RemoveClass('champions_league_start_button_inactive')
        sign.FindChildTraverse('champions_league_start_button_label').text=$.Localize("tooltip_open_pit")
        sign.FindChildTraverse('champions_league_start_button').SetPanelEvent('onactivate', function TerminalButtonActivate() {
            var accept = 1
            var intattr = 0
            var npc = "pit_terminal"
            GameEvents.SendCustomGameEventToServer( "arena_dialogue", {accept:accept , npc:npc, intattr:intattr, playerID: Players.GetLocalPlayer(), starLevel: starLevel} );
            CloseLeftLeaderboard()
            Game.EmitSound("Arena.Accept")
        })
    }
}

function updatePitData(sign){
    var pitLevel = sign.GetAttributeInt( "currentPitLevel", 0)
    if (pitLevel == 0){
        sign.FindChildTraverse('enemy_name_text').text = $.Localize('tooltip_select_pit_level')
    }else{
        sign.FindChildTraverse('enemy_name_text').text = $.Localize('tooltip_pit_of_trials') + " " + $.Localize("weapon_current_level") + " " + pitLevel
    }
}

function OpenQuestLog(msg){
    if (GameUI.QuestLog == 0 || msg.bFade == 0){
        var questlog = msg.questlog
        if (msg.bFade == 1){
            GameUI.QuestLog = 1
            $('#arena_battle_container').AddClass('animateEaseClass')  
        } 
        
        var parent = $('#arena_battle_container')
        var board = $.CreatePanel("Panel", parent, "leaderboard")
        board.BLoadLayoutSnippet("quest_log");
        parent.board = board
        $.Msg("OPENING QUEST LOG")


        $('#quest_log_title').text = $.Localize('zone_redfall')
        $('#quest_log_title_b').text = $.Localize('tooltip_quest_log')

        if (GameUI.QuestLog == 1){
            $('#quest_active_button').AddClass('quest_state_button_active')
            $('#quest_completed_button').RemoveClass('quest_state_button_active')
        }else{
            $('#quest_active_button').RemoveClass('quest_state_button_active')
            $('#quest_completed_button').AddClass('quest_state_button_active')
        }
        var noQuests = true
        for (i = 1; i <= msg.maxQuests; i++) {
            $.Msg(questlog[i].active)
            if (questlog[i].active == GameUI.QuestLog){
                noQuests = false
                createQuestItem($('#quest_list'), i, questlog[i])
            }
        }
        if (noQuests){
            if (GameUI.QuestLog == 1){
             $('#quest_log_no_quests').text = $.Localize('tooltip_no_quests')
            }else if(GameUI.QuestLog == 2){
             $('#quest_log_no_quests').text = $.Localize('tooltip_no_quests_completed')
            }
        }else{
            $('#quest_log_no_quests').AddClass('invisible')
        }
    }else{
        
        closeQuestLog()
    }
}

function closeQuestLog()
{
    GameUI.QuestLog = 0
    $('#arena_battle_container').AddClass('animateEaseOutClass')
    $.Schedule(0.45, function(){
        $('#arena_battle_container').RemoveClass('animateEaseClass')
        $('#arena_battle_container').RemoveClass('animateEaseOutClass')
        $('#arena_battle_container').RemoveAndDeleteChildren(0);

    }); 
    $.Schedule(0.5, function(){
        GameUI.QuestLogLock = 0   
    })
}

function toggleQuestState(buttonNumber){
    if (buttonNumber == 0 && GameUI.QuestLog == 1){
        return false
    }
    if (buttonNumber == 1 && GameUI.QuestLog == 2){
        return false
    }
    if (buttonNumber == 1 && GameUI.QuestLog == 1){
        $('#arena_battle_container').board.RemoveAndDeleteChildren(0)
        GameUI.QuestLog = 2
        var playerID = Game.GetLocalPlayerID()
        var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)

        GameEvents.SendCustomGameEventToServer( "quest_log", {playerID: playerID, heroIndex: heroIndex, bFade: 0});       
    }
    if (buttonNumber == 0 && GameUI.QuestLog == 2){
        $('#arena_battle_container').board.RemoveAndDeleteChildren(0)
        GameUI.QuestLog = 1
        var playerID = Game.GetLocalPlayerID()
        var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
        GameEvents.SendCustomGameEventToServer( "quest_log", {playerID: playerID, heroIndex: heroIndex, bFade: 0});  
    }
}

function createQuestItem(parent, questIndex, quest)
{
    var listItem = $.CreatePanel("Panel", parent, "questitem"+questIndex)
    listItem.BLoadLayoutSnippet("quest_item");
    $.Msg("-------- QUEST: "+questIndex+" --------------")
    $.Msg(quest)
    listItem.FindChildTraverse('quest-item-image').SetImage(quest.questImage)
    listItem.FindChildTraverse('quest-title').text = $.Localize('#'+quest.questTitle)
    var objective = breakUpTooltip($.Localize('#'+quest.objective))
    $.Msg(objective)
    listItem.FindChildTraverse('quest-description').text = objective
    var progress = quest.state + "/" + quest.goal
    listItem.FindChildTraverse('quest-progress-values').text = progress

    listItem.FindChildTraverse('quest-reward-image').SetImage(quest.questRewardImage)
    listItem.FindChildTraverse('quest-reward-image').tooltipTitle = $.Localize('#'+quest.rewardTitle)
    listItem.FindChildTraverse('quest-reward-image').tooltipDesc = $.Localize('#'+quest.rewardDescription)
    listItem.FindChildTraverse('quest-reward-image').questIndex = questIndex

    listItem.FindChildTraverse('quest-reward-image').SetPanelEvent('onmouseover', function rewardMouseover() {
        var panel = listItem.FindChildTraverse('quest-reward-image')
        var title = "<font color='#FF6161'>"+panel.tooltipTitle
        var tooltip = panel.tooltipDesc
        // tooltip = breakUpTooltip(tooltip)
        $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
    })
    if (quest.state >= quest.goal){
        if (GameUI.QuestLog == 1){
            listItem.FindChildTraverse('quest_item_bg').AddClass('quest_complete')
            listItem.FindChildTraverse('quest-title').text = $.Localize('#'+quest.questTitle) + " - <font color='#63C27C';font-size='12'>" + $.Localize('#tooltip_quest_to_complete') +"</font>"
            listItem.FindChildTraverse('quest_item_bg').SetPanelEvent('onactivate', function rewardClick() {
                if (GameUI.QuestLogLock == 0){
                    GameUI.QuestLogLock = 1
                    var panel = listItem.FindChildTraverse('quest-reward-image')
                    var questIndex = panel.questIndex
                    var playerID = Game.GetLocalPlayerID()
                    var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
                    Game.EmitSound("Tutorial.Quest.complete_01")
                    GameEvents.SendCustomGameEventToServer( "quest_log_complete", {questIndex: questIndex, playerID: playerID, heroIndex: heroIndex} );
                    closeQuestLog()
                }
            })
        }else{
            listItem.FindChildTraverse('quest_item_bg').AddClass('quest_complete_no_hover')
        }
    }
}

function QuestlogRewardTooltip(){
    var panel = $('#quest-reward-image')
    var title = "<font color='#FF6161'>"+panel.tooltipTitle
    var tooltip = panel.tooltipDesc
    // tooltip = breakUpTooltip(tooltip)
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideQuestlogRewardTooltip(){
    var panel = $('#quest-reward-image')
    $.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function breakUpTooltip(specialText){
    var spacePosition10 = getPosition(specialText, " ", 5)
    var spacePosition20 = getPosition(specialText, " ", 10)
    var spacePosition30 = getPosition(specialText, " ", 15)
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

function OpenDonationsBoard(msg){
    var parent = $('#arena_container')
    var board = $.CreatePanel("Panel", parent, "leaderboard")
    board.BLoadLayoutSnippet("donations_board");
    $.Msg("OPENING LEADERBOARD")
    $('#arena_container').AddClass('animateEaseClass')
    // board.FindChildTraverse('donation-tip-text').text = "<a href='https://roshpit.ca/donate'>roshpit.ca/donate</a>"
    GameUI.donationAppendContainer = board.FindChildTraverse("leaderboard-leaders-box")
    // for (i = 1; i <= 20; i++) { 
    //      createLeaderboardItem(i, "charactername", board.FindChildTraverse("leaderboard-leaders-box"), msg.playerRank)
    // }
}

function DonationsLoaded(msg)
{
    if (GameUI.donationAppendContainer){
        $.Msg(msg)
        $.Msg(msg.resultTable)
        $.Msg(msg.resultTable[1])
        $.Msg(msg.resultSize)
        for (var i = 1; i <= msg.resultSize; i++) {
            var listItem = $.CreatePanel("Panel", GameUI.donationAppendContainer, "donationitem"+i)
            listItem.BLoadLayoutSnippet("donation_item");
            createDonationItem(msg.resultTable[i], listItem)
        }

    }
}

function createDonationItem(data, parent)
{
    parent.FindChildTraverse('donation_name').text = data.name
    parent.FindChildTraverse('donation_date').text = data.created_at.substring(0,10);
    var payment = parseFloat(Math.round((data.amount/100)* 100) / 100).toFixed(2);
    parent.FindChildTraverse('donation_amount').text = "$"+payment
    parent.FindChildTraverse('donation_message').text = data.message

}




(function()
{
	InitializeArena();
	GameEvents.Subscribe( "open_left_leaderboard", OpenLeftLeaderboard );
	GameEvents.Subscribe( "close_left_leaderboard", CloseLeftLeaderboard );

	GameEvents.Subscribe( "champions_league_attendant", ArenaNPCDialogue);
	GameEvents.Subscribe( "arena_view_sign", ViewSign);
	GameEvents.Subscribe( "arena_npc_dialogue", ArenaGenericNPCDialogue);

    GameEvents.Subscribe( "arena_terminal", ArenaTerminal);
    GameEvents.Subscribe( "pit_terminal", PitTerminal);

    GameEvents.Subscribe( "init_battle_timer", InitArenaTimer);
    GameEvents.Subscribe( "update_arena_timer", UpdateArenaTimer);

    GameEvents.Subscribe( "arena_fade_to_black", ArenaFadeToBlack);

    GameEvents.Subscribe( "init_battle_ui", ArenaBattleUI);
    GameEvents.Subscribe( "clear_battle_ui", RemoveBattleUI);
    GameEvents.Subscribe( "vs_clash", VSClash);
    GameEvents.Subscribe( "update_arena_HP", UpdateArenaHP);
    GameEvents.Subscribe( "arena_update_bo", updateBo);
    GameEvents.Subscribe( "update_battle_timer", updateTimerBattle)
    GameEvents.Subscribe( "champions_league_lose", championsLeagueLose)
    GameEvents.Subscribe( "update_crowd_favor", UpdateCrowdFavor)
    GameEvents.Subscribe( "hide_arena_skip", hideArenaSkipButton)

    GameEvents.Subscribe( "open_quest_log", OpenQuestLog)
    
    GameEvents.Subscribe( "open_donations_board", OpenDonationsBoard)
    GameEvents.Subscribe( "donations_loaded", DonationsLoaded)
    
   

    GameEvents.Subscribe( "BGMstart", BGMstart)
    GameEvents.Subscribe( "BGMend", BGMend)
})();


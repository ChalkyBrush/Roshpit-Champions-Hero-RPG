GAMEMODE_DEATHMATCH = 0;

function OpenPVPVoteMenu(){
	var parent = $('#pvp_container')
    var board = $.CreatePanel("Panel", parent, "pvp_vote")
    board.BLoadLayoutSnippet("pvp_vote");

    board.FindChildTraverse('mode_selection_deathmatch').SetPanelEvent('onactivate', function SelectDeathmatch() {
			var parent = $('#game_option_2_container')
		    var board2 = $.CreatePanel("Panel", parent, "deathmatch")
		    board2.BLoadLayoutSnippet("deathmatch_count");
		    Game.EmitSound("RoshpitMenu.PVPClick")
		    var gameOptions = [5, 10, 20, 50]
		    for (i = 0; i < 4; i++) { 
		    	 setButtonFunction(i, gameOptions, board2, gameOptions[i])
		    }
		})

    board.FindChildTraverse('mode_selection_line_war').SetPanelEvent('onactivate', function SelectDeathmatch() {
			var parent = $('#game_option_2_container')
		    var board2 = $.CreatePanel("Panel", parent, "deathmatch")
		    board2.BLoadLayoutSnippet("linewar_monster_power");
		    Game.EmitSound("RoshpitMenu.PVPClick")
		    var gameOptions = ["normal", "elite", "legend"]
		    for (i = 0; i < 3; i++) { 
		    	 setButtonFunctionLinewar(i, gameOptions, board2, gameOptions[i])
		    }
		})

}

function setButtonFunctionLinewar(i, gameOptions, board2, linewarOption)
{
    board2.FindChildTraverse('linewar_option_'+linewarOption.toString()).SetPanelEvent('onactivate', function SelectDeathmatchKillAmount() {
		    Game.EmitSound("RoshpitMenu.PVPClick")
		    //submit vote
		    var monsterPower = 0
		    if (linewarOption == "normal"){
		    	monsterPower = 1
		    }else if(linewarOption == "elite"){
		    	monsterPower = 2
		    }else if(linewarOption == "legend"){
		    	monsterPower = 3
		    }
		    GameEvents.SendCustomGameEventToServer( "pvp_vote", {power: monsterPower} );
		    closePVPVoteScreen()
		})
}

function setButtonFunction(i, gameOptions, board2, killOption)
{
    board2.FindChildTraverse('deathmatch_selection_count_'+killOption.toString()).SetPanelEvent('onactivate', function SelectDeathmatchKillAmount() {
		    Game.EmitSound("RoshpitMenu.PVPClick")
		    //submit vote
		    GameEvents.SendCustomGameEventToServer( "pvp_vote", {killAmount: killOption} );
		    closePVPVoteScreen()
		})
}

function OnGameModeChanged(eventL){
	$.Msg(eventL)
	if (gameMode == GAMEMODE_DEATHMATCH){
		// var parent = $('#game_option_2_container')
	 //    var board = $.CreatePanel("Panel", parent, "deathmatch")
	 //    board.BLoadLayoutSnippet("deathmatch_count");
	}
}

function closePVPVoteScreen(){
	$('#pvp_container').RemoveAndDeleteChildren()
}

function createPVPGoal(msg){
	var threshold = msg.killThreshold
	$.Msg("PVP GOAL BOYS")
	var parent = $.GetContextPanel()
    var board = $.CreatePanel("Panel", parent, "pvp_goal")
    board.BLoadLayoutSnippet("pvp_goal");

    board.FindChildTraverse('goal-label').text = threshold
}

function openBuilderMenu(msg, regionCode){
	closeBuilderMenu()
	updateLineWarFoodCap()
	$.Msg("PVP GOAL BOYS")
	var parent = $('#pvp_builder_meta_container')
    var board = $.CreatePanel("Panel", parent, "builder_menu")
    board.BLoadLayoutSnippet("builder_menu");
    board.AddClass('animateFromBottom')

	var parent = $("#builder-contents")
	for (i = 0; i < 3; i++) { 
		var builder_contents= $.CreatePanel("Panel", parent, "builder-row"+i)
	    builder_contents.BLoadLayoutSnippet("builder_row");
	    var builder_row = builder_contents.FindChildTraverse("builder-row-contents");
	    for (j = 0; j < 9; j++) {
	    	var letterIndex = "A"
	    	if (i == 1){
	    		letterIndex = "B"
	    	}else if (i == 2){
	    		letterIndex = "C"
	    	}
	    	var code = letterIndex+j
	    	var builder_item_contents = $.CreatePanel("Panel", builder_row, "builder-item"+code)
	    	var builder_item = builder_item_contents.BLoadLayoutSnippet("builder_item");
	    	$.Msg(builder_item)
	    	var builderItemData = CustomNetTables.GetTableValue( "premium_pass", regionCode+"_"+code )
	    	$('#builder-item'+code).FindChildTraverse('builder-item-image').SetImage( "file://{images}/heroes/" + builderItemData.hero_icon + ".png" );
	    	$('#builder-item'+code).FindChildTraverse('builder_item_gold_cost_label').text = builderItemData.goldCost;
	    	setBuildButtonFunction( $('#builder-item'+code).FindChildTraverse('builder-item-button'), builderItemData, regionCode)


	    }
	}
    board.FindChildTraverse('close_builder_button').SetPanelEvent('onactivate', function SetCloseButton() {
		    closeBuilderMenu()
		});

    // board.FindChildTraverse('goal-label').text = threshold

    // playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" )
}

function setBuildButtonFunction(button, builderItemData, regionCode){
	button.SetPanelEvent('onactivate', function SetButtonItemEvent() {
		var currentGold = Players.GetGold( Players.GetLocalPlayer() )
		var price = builderItemData.goldCost
		if (currentGold >= parseInt(price)){
			Game.EmitSound("PVP.Purchase")
			GameEvents.SendCustomGameEventToServer( "pvp_build", {builderItemData: builderItemData, playerID: Players.GetLocalPlayer(), regionCode: regionCode} );
		}else{
			Game.EmitSound("PVP.UI.Cancel")
		}
	});
	button.SetPanelEvent('onmouseover', function SetButtonItemMouseover(){
		BuilderItemShowTooltip(button, builderItemData)
	});
	button.SetPanelEvent('onmouseout', function SetButtonItemMouseover(){
		BuilderItemHideTooltip(button)
	});
}

function closeBuilderMenu(){
	$('#pvp_builder_meta_container').RemoveAndDeleteChildren();
}

function BuilderItemShowTooltip(button, builderItemData)
{
	var title = "<font color='#ede744'>"+$.Localize(builderItemData.unitName)+"</font>"
	var costTip = "<font color='#a0dd6a'>"+$.Localize("rpc_pvp_gold_cost")+": </font>"+"<font color='#FFFFFF'>"+builderItemData.goldCost+"</font>"
	costTip = costTip+"<br><font color='#a0dd6a'>"+$.Localize("rpc_pvp_income")+": </font>"+"<font color='#FFFFFF'>+"+builderItemData.income+"</font>"
	var tooltip = $.Localize("pvp_"+builderItemData.unitName+"_Description")
	tooltip = "<br>"+breakUpTooltip(tooltip)
	tooltip = costTip+tooltip

	title = title.replace(/(['"])/g, "\\$1");
	tooltip = tooltip.replace(/(['"])/g, "\\$1");

	$.DispatchEvent("DOTAShowTitleTextTooltip", button, title, tooltip);
}

function BuilderItemHideTooltip(button)
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip", button );
}

function createLineWarIncomeTimer(msg){
	var mapName = Game.GetMapInfo().map_display_name
	if (mapName === "rpc_pvp_linewar_no_oracle"){
		GameUI.PVPIncomeTimerActivated = true

		var parent = $.GetContextPanel()
	    var board = $.CreatePanel("Panel", parent, "pvp_goal")
	    board.BLoadLayoutSnippet("pvp_goal");
	    board.FindChildTraverse('goal-name').text = $.Localize("rpc_pvp_income")+":"
	    // board.FindChildTraverse('goal-label').text = msg.incomeTimer
	    board.FindChildTraverse('goal-label').text = 60

	    var board2 = $.CreatePanel("Panel", parent, "line_builder_container")
	    board2.BLoadLayoutSnippet('primary_build_menu')
	    board2.FindChildTraverse('primary_build_button').SetPanelEvent('onactivate', function OpenBuilder() {
	    	openBuilderMenu(msg, "tanari");
		});
	    board2.FindChildTraverse('primary_build_button_2').SetPanelEvent('onactivate', function OpenBuilder() {
	    	openBuilderMenu(msg, "redfall");
		});
	}
	if (mapName === "rpc_battle_of_serengaard"){
		sereengardInitialize()
	}
}

function recreateLineWarIncomeTimer(msg){
	if (GameUI.PVPIncomeTimerActivated){
		var checkPanel = $.GetContextPanel().FindChildTraverse('pvp_goal')
		if (checkPanel === null){
			var parent = $.GetContextPanel()
		    var board = $.CreatePanel("Panel", parent, "pvp_goal")
		    board.BLoadLayoutSnippet("pvp_goal");
		    board.FindChildTraverse('goal-name').text = $.Localize("rpc_pvp_income")+":"
		    board.FindChildTraverse('goal-label').text = msg.incomeTimer

		    var board2 = $.CreatePanel("Panel", parent, "line_builder_container")
		    board2.BLoadLayoutSnippet('primary_build_menu')
		    board2.FindChildTraverse('primary_build_button').SetPanelEvent('onactivate', function OpenBuilder() {
		    	openBuilderMenu(msg, "tanari");
			});
		    board2.FindChildTraverse('primary_build_button_2').SetPanelEvent('onactivate', function OpenBuilder() {
		    	openBuilderMenu(msg, "redfall");
			});


		}
	}
}


function updateLineWarIncomeTimer(msg){
	recreateLineWarIncomeTimer(msg)
	$('#pvp_goal').FindChildTraverse('goal-label').text = msg.incomeTimer


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

function updateLineWarFoodCap(){
	var panel = $.GetContextPanel().FindChildTraverse("food_info_label")
	if (panel === null){

	}else{
		var playerID = Players.GetLocalPlayer()
		var foodData = CustomNetTables.GetTableValue( "premium_pass", "line_war_food_cap_"+playerID )
		panel.text = $.Localize("pvp_max_units")+": "+foodData.currentFood+"/"+foodData.maxFood
	}
	
}

DPS_TIMER_TIME = 7;
magic_immune = false
scientific_display = false
function InitDummmy(){
	var parent = $('#pvp_container')
    var board = $.CreatePanel("Panel", parent, "dummy-box")
    board.BLoadLayoutSnippet('target_dummy')
    board.AddClass('animateFromBottom')
    $.GetContextPanel().dpsText = ""
    $.GetContextPanel().lineCount = 0
    board.FindChildTraverse('capacity_text').text = $.Localize('arena_log_capacity')+": 0/30"
    

    board.FindChildTraverse('target-dummy-button-clear').SetPanelEvent('onactivate', function ClearLog() {
	    $.GetContextPanel().dpsText = ""
	    $.GetContextPanel().lineCount = 0
	    var dpsBox = $.GetContextPanel().FindChildTraverse("target_dummy_contents").FindChildTraverse('dps_text')
	    dpsBox.text = ""
	    $.GetContextPanel().FindChildTraverse('capacity_text').text = $.Localize('arena_log_capacity')+": 0/30"
	});

    board.FindChildTraverse('target-dummy-button-exit').SetPanelEvent('onactivate', function ExitDummy() {
    	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {dummy: 1, exit: 1, playerID: Players.GetLocalPlayer()} );
        $('#pvp_container').RemoveAndDeleteChildren();
        scientific_display = false;
	});
    var timerButton = board.FindChildTraverse('target-dummy-button-timer')
    var timerText = board.FindChildTraverse('timer_button_label')
    var bigTimer = board.FindChildTraverse('dps-timer-2')
    timerButton.SetPanelEvent('onactivate', function DummyTimer() {
    	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {dummy: 1, timer: 1, playerID: Players.GetLocalPlayer()} );
    	timerfunction(timerText, bigTimer)
	});	

    board.FindChildTraverse('target-dummy-button-update-dummy-stats').SetPanelEvent('onactivate', function DummyModArmor() {
		var armorInput = $.GetContextPanel().FindChildTraverse('armor-input').text
		var magicArmorInput = $.GetContextPanel().FindChildTraverse('magic-armor-input').text
    	var attackInput = $.GetContextPanel().FindChildTraverse('attacks-input').text
    	GameEvents.SendCustomGameEventToServer( "arena_dialogue", {dummy: 1, armor: armorInput, magicArmor: magicArmorInput, attack: attackInput, playerID: Players.GetLocalPlayer()} );
	});
	
    board.FindChildTraverse("target-dummy-button-magic-immunity").SetPanelEvent('onactivate', function DummyModMagicImmune() {
    	magic_immunity_button(board)
    });	

    board.FindChildTraverse("target-dummy-button-toggle-dps-display").SetPanelEvent('onactivate', function DummyModToggleDpsDisplay() {
        toggle_dps_display_button(board)
    });		
}

function magic_immunity_button(board)
{
	if (!(magic_immune)){
		board.FindChildTraverse("magic-immunity-label").text = $.Localize("dummy_remove_magic_immunity").toUpperCase()
		magic_immune = true
		GameEvents.SendCustomGameEventToServer( "arena_dialogue", {dummy: 1, magic_immune: 1, playerID: Players.GetLocalPlayer()} );
	}else{
		board.FindChildTraverse("magic-immunity-label").text = $.Localize("dummy_add_magic_immunity").toUpperCase()
		magic_immune = false
		GameEvents.SendCustomGameEventToServer( "arena_dialogue", {dummy: 0, magic_immune: 1, playerID: Players.GetLocalPlayer()} );
	}	
}

function toggle_dps_display_button(board) {
    if (!scientific_display) {
        board.FindChildTraverse("dps-display-label").text = $.Localize("dummy_toggle_dps_scientific").toUpperCase();
        scientific_display = true;
    } else {
        board.FindChildTraverse("dps-display-label").text = $.Localize("dummy_toggle_dps_normal").toUpperCase();
        scientific_display = false;
    }
}

function timerfunction(timerButton, bigTimer)
{
	timerButton.timer = DPS_TIMER_TIME
	$.Msg("ANYTHING?")
	$.Msg(timerButton)
	bigTimer.RemoveClass('invisible')
	for (i = 0; i < DPS_TIMER_TIME; i++) { 
		$.Schedule(i, function(){
		 	timerButton.timer = timerButton.timer - 1
		 	timerButton.text = timerButton.timer + 1
		 	bigTimer.text = timerButton.timer + 1
		 });

	}
	$.Schedule(DPS_TIMER_TIME, function(){
		timerButton.text = $.Localize('arena_training_button_2')
		bigTimer.AddClass('invisible')
	})	
}

function updateDPSLabel(msg){
	var dps = msg.dps
	dps = formatDamageNumbers(dps);
	$.GetContextPanel().FindChildTraverse('dps-value').text = dps
}

function updateTargetDummy(msg){
	var panel = $.GetContextPanel().FindChildTraverse("target_dummy_contents")
	//max 20
	if (panel === null){
		InitDummmy()
	}else{
		if ($.GetContextPanel().lineCount == 30){
			return false;
		}
		var playerID = Players.GetLocalPlayer()
		if (msg.dmg){
			var dpsBox = panel.FindChildTraverse('dps_text')
			var dmg = formatDamageNumbers(msg.dmg);
			var heroName = Entities.GetUnitName( msg.attacker )
			var victimName = Entities.GetUnitName( msg.victim )
			var damageTypeText = getDamageTypeText(msg.damagetype)
			$.Msg($.GetContextPanel().dpsText)
			var element1 = msg.element1
			var element2 = msg.element2
			var elementText = ""
			$.Msg(element1)
			if (element1 > 0){
				var element_main_text = $.Localize('#rpc_element'+element1)
				var elementColor = GetElementColor(element1)
				if (element2 > 0){
					var element_main_text2 = $.Localize('#rpc_element'+element2)
					var elementColor2 = GetElementColor(element2)
					elementText = "<font color='"+elementColor+"'>"+element_main_text+"</font> / <font color='"+elementColor2+"'>"+element_main_text2+"</font>"
				}else{
					elementText = "<font color='"+elementColor+"'>"+element_main_text+"</font>"
				}
			}	
			// $.GetContextPanel().dpsText = $.GetContextPanel().dpsText + "<font color='#CCFF66'>"+ $.Localize(heroName)  + "</font> " + $.Localize('arena_training_dummy_sentence_1') + " <font color='#CCFF66'>" + $.Localize(victimName) + "</font> " + $.Localize('arena_training_dummy_sentence_2') + " <font color='#f99459'>" + dmg + "</font> " + $.Localize('arena_training_dummy_sentence_3') + "<br>"
			$.GetContextPanel().dpsText = $.GetContextPanel().dpsText + "<font color='#CCFF66'>"+ $.Localize(heroName)  + "</font> " + $.Localize('arena_training_dummy_sentence_1') + " " + $.Localize('arena_training_dummy_sentence_2') + " <font color='#f99459'>" + dmg + "</font> " + damageTypeText + " " + elementText + " " + $.Localize('arena_training_dummy_sentence_3') + "<br>"
			dpsBox.text = $.GetContextPanel().dpsText
			$.GetContextPanel().lineCount = $.GetContextPanel().lineCount + 1
			panel.FindChildTraverse('capacity_text').text = $.Localize('arena_log_capacity')+": "+$.GetContextPanel().lineCount+"/30"
		}
	}	
}

function formatDamageNumbers(x) {
    if (scientific_display) {
        return x.toExponential(3);
    } else {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
}

function GetElementColor(element_index){
	var color = "#FFFFFF"
	if (element_index == 1){
		color = "#DDDDDD"
	}else if(element_index == 2){
		color = "#EF4126"
	}else if(element_index == 3){
		color = "#AF843D"
	}else if(element_index == 4){
		color = "#5CCDF9"
	}else if(element_index == 5){
		color = "#37DD3D"
	}else if(element_index == 6){
		color = "#B5FFB7"
	}else if(element_index == 7){
		color = "#F6FFB5"
	}else if(element_index == 8){
		color = "#C25DFC"
	}else if(element_index == 9){
		color = "#87D9FF"
	}else if(element_index == 10){
		color = "#E1A2E8"
	}else if(element_index == 11){
		color = "#7F4F84"
	}else if(element_index == 12){
		color = "#7AE2A7"
	}else if(element_index == 13){
		color = "#9ACCD1"
	}else if(element_index == 14){
		color = "#3894FF"
	}else if(element_index == 15){
		color = "#5B648C"
	}else if(element_index == 16){
		color = "#69BC71"
	}else if(element_index == 17){
		color = "#5C776E"
	}else if(element_index == 18){
		color = "#3289C7"
	}
	return color
}

function getDamageTypeText(damagetype)
{
	var text = ""
	if (damagetype == DAMAGE_TYPES.DAMAGE_TYPE_MAGICAL){
		text = "<font color='#67e071'>" + $.Localize("#DOTA_ToolTip_Damage_Magical") + "</font>"
	}else if (damagetype == DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL){
		text = $.Localize("#DOTA_ToolTip_Damage_Physical")
	}else if (damagetype == DAMAGE_TYPES.DAMAGE_TYPE_PURE){
		text = $.Localize("#DOTA_ToolTip_Damage_Pure")
	}	

	return text
}

function sereengardInitialize()
{
	GameUI.PVPIncomeTimerActivated = true
	var parent = $.GetContextPanel()
    var board = $.CreatePanel("Panel", parent, "pvp_goal")
    board.BLoadLayoutSnippet("pvp_goal");
    board.FindChildTraverse('goal-name').text = $.Localize("wave_starting_timer")+":"
    // board.FindChildTraverse('goal-label').text = msg.incomeTimer
    board.FindChildTraverse('goal-label').text = "-"

	var parent = $('#pvp_container_no_margin')
    var board = $.CreatePanel("Panel", parent, "serengaard")
    board.BLoadLayoutSnippet('serengaard_wave_status')
    var msg = {waveNumber: 0}
    serengaardUpdateData(msg)
}

function serengaardUpdateData(msg)
{
	var waveNumber = msg.waveNumber
	$.GetContextPanel().FindChildTraverse('serengaard_wave_label').text = $.Localize('wave_name')+": "+waveNumber
	if (msg.enemiesMax){
		$.GetContextPanel().FindChildTraverse('serengaard_enemies_label').text = $.Localize("enemies_slain")+": "+msg.currentEnemies+"/"+msg.enemiesMax
		var waveProgressWidth = Math.round((msg.currentEnemies*100)/msg.enemiesMax)
		$.Msg(waveProgressWidth)
		$.GetContextPanel().FindChildTraverse('wave_box_contents').style.width = waveProgressWidth+"%"
	}else{
		$.GetContextPanel().FindChildTraverse('serengaard_enemies_label').text = $.Localize("enemies_slain")+": -"
	}
}

function serengaardWaveSpawn(msg)
{
	var parent = $('#pvp_container')
    var board = $.CreatePanel("Panel", parent, "serengaard_wave_spawning")
    board.BLoadLayoutSnippet("serengaard_wave_spawning");
    board.FindChildTraverse('serengaard_wave_spawn_label').text = $.Localize("wave_spawning")

    board.AddClass('fade-in')
    Game.EmitSound("Serengaard.RoundStart")
	$.Schedule(5, function(){
		board.AddClass('fade-out')
		$.Schedule(0.97, function(){
			board.AddClass('invisible')
			board.RemoveAndDeleteChildren()
		});
	}); 
}

function serengaardInfiniteWaves(){
	$.GetContextPanel().FindChildTraverse("wave_box_contents").RemoveClass('wave_box_inner_base')
	$.GetContextPanel().FindChildTraverse("wave_box_contents").AddClass('wave_box_inner_infinite')
}

function serengaardLeaderboard(msg){
	var parent = $('#pvp_container')
    var board = $.CreatePanel("Panel", parent, "serengaard_leaderboard")
    board.BLoadLayoutSnippet("serengaard_leaderboard");
    board.AddClass('fade-in')
    var leaderContentsContainer = board.FindChildTraverse('serengaard_leaders_contents')
    $.Msg(msg)
    serengaardLeaderboardCategoryActivate(1, msg.resultTable, leaderContentsContainer)
    board.FindChildTraverse('serengaard_leader_button_1').SetPanelEvent('onactivate', function SelectLeaderButton1() {
    	serengaardLeaderboardCategoryActivate(1, msg.resultTable, leaderContentsContainer)
	});
    board.FindChildTraverse('serengaard_leader_button_2').SetPanelEvent('onactivate', function SelectLeaderButton2() {
    	serengaardLeaderboardCategoryActivate(2, msg.resultTable, leaderContentsContainer)
	});
    board.FindChildTraverse('serengaard_leader_button_3').SetPanelEvent('onactivate', function SelectLeaderButton3() {
    	serengaardLeaderboardCategoryActivate(3, msg.resultTable, leaderContentsContainer)
	});
    // board.FindChildTraverse('serengaard_wave_spawn_label').text = $.Localize("wave_spawning")
}

function serengaardLeaderboardHide(){
	$.Msg("Hiding serengaard leaderboard...")
	var parent = $('#pvp_container')
	parent.FindChildTraverse('serengaard_leaderboard').AddClass('invisible')
	$.Msg("Serengaard leaderboard became invisible!")
}

function serengaardLeaderboardCategoryActivate(index, results, leaderContentsContainer)
{
	leaderContentsContainer.RemoveAndDeleteChildren(0)
    // var playerInfo = Game.GetPlayerInfo( Game.GetLocalPlayerID() );
    // var steamID = playerInfo.player_steamid
    // $.Msg("STEAM ID!")
    // $.Msg(steamID)
    $('#serengaard_leader_button_1').RemoveClass('serengaard_button_active')
    $('#serengaard_leader_button_2').RemoveClass('serengaard_button_active')
    $('#serengaard_leader_button_3').RemoveClass('serengaard_button_active')
    $('#serengaard_leader_button_'+index).AddClass('serengaard_button_active')
    var leaderData = null
	if (index == 1){
		leaderData = results.seven
	}else if (index == 2){
		leaderData = results.thisMonth
	}else if (index == 3){
		leaderData = results.allTime
	}
	$.Msg(leaderData)
	for (var i = 1; i <= 10; i++) {
		$.Msg(leaderData[i])
		if (leaderData[i]===undefined){
			break;
		}
		var board = $.CreatePanel("Panel", leaderContentsContainer, "serengaard_leaderboard_item"+i)
		board.AddClass('serengaard_leaderboard_box')
		board.BLoadLayoutSnippet("serengaard_record")
		board.FindChildTraverse('rank_text').text = i+". "
		board.FindChildTraverse('wave_text').text = $.Localize("wave_name")+": <font color='#3bede4'>"+leaderData[i].wave_number+"</font>"
		var heroContainer = board.FindChildTraverse('serengaard_individual_hero_container')
		for (var j = 1; j <= 4; j++){
			var steam_id = -1
			var hero = ""
			var steam_name = ""
			var steam_id_long = ""
			if (j == 1){
				steam_id = leaderData[i].steam_id1
				hero = leaderData[i].hero1
				steam_name = leaderData[i].steam_name1
				steam_id_long = leaderData[i].steam_id_long1
			}else if (j==2){
				steam_id = leaderData[i].steam_id2
				hero = leaderData[i].hero2
				steam_name = leaderData[i].steam_name2	
				steam_id_long = leaderData[i].steam_id_long2		
			}else if (j==3){
				steam_id = leaderData[i].steam_id3
				hero = leaderData[i].hero3
				steam_name = leaderData[i].steam_name3			
				steam_id_long = leaderData[i].steam_id_long3
			}else if (j==4){
				steam_id = leaderData[i].steam_id4
				hero = leaderData[i].hero4
				steam_name = leaderData[i].steam_name4	
				steam_id_long = leaderData[i].steam_id_long4		
			}
			if (steam_id > 0){
				var heroBoard = $.CreatePanel("Panel", heroContainer, "serengaard_leaderboard_hero"+j)
				heroBoard.BLoadLayoutSnippet("serengaard_hero")
				heroBoard.FindChildTraverse('player_avatar').steamid = steam_id_long
				heroBoard.FindChildTraverse('hero_portrait').SetImage("file://{images}/heroes/" + hero + ".png")
				heroBoard.FindChildTraverse('dota_player_name').text = steam_name
			}else{
				var heroBoard = $.CreatePanel("Panel", heroContainer, "serengaard_leaderboard_hero"+j)
				heroBoard.AddClass('width_maker')
			}
		}
	}
}

mVoteSkip = undefined;

function createSerengaardVoteSkip(msg){
	var parent = $.GetContextPanel()
	$.Msg("ARE WE CREATING THIS?")
	if (mVoteSkip === undefined){
		var voteBoard = $.CreatePanel("Panel", parent, "vote_skip")
		voteBoard.BLoadLayoutSnippet("serengaard_vote_skip")
		mVoteSkip = voteBoard
	}else{
		mVoteSkip.BLoadLayoutSnippet("serengaard_vote_skip")
	}
	if (msg.playerCount < 2){
		mVoteSkip.FindChildTraverse('vote_skip_result2').AddClass('invisible')
	}
	if (msg.playerCount < 3){
		mVoteSkip.FindChildTraverse('vote_skip_result3').AddClass('invisible')
	}
	if (msg.playerCount < 4){
		mVoteSkip.FindChildTraverse('vote_skip_result4').AddClass('invisible')
	}
	var skipButton = mVoteSkip.FindChildTraverse('button_vote_skip_wave')
	$.Msg(skipButton)
	skipButton.SetPanelEvent('onactivate', function VoteSkip() {
		GameEvents.SendCustomGameEventToServer( "serengaard_vote", {player: Game.GetLocalPlayerID()} );	
		skipButton.AddClass('invisible')
	});
}

function updateSkipVotes(msg){
	var count = msg.number
	$.Msg("UPDATE COLORS???")
	if (count >= 1){
		mVoteSkip.FindChildTraverse('vote_skip_result1').AddClass('skip_voted')
	}
	if (count >= 2){
		mVoteSkip.FindChildTraverse('vote_skip_result2').AddClass('skip_voted')
	}
	if (count >= 3){
		mVoteSkip.FindChildTraverse('vote_skip_result3').AddClass('skip_voted')
	}
	if (count >= 4){
		mVoteSkip.FindChildTraverse('vote_skip_result4').AddClass('skip_voted')
	}
}

function destroySerengaardVoteSkip(){
	if (!(mVoteSkip===undefined)){
		mVoteSkip.RemoveAndDeleteChildren();
	}
}

(function () {
  createLineWarIncomeTimer();

  GameEvents.Subscribe( "startPVPVoteScreen", OpenPVPVoteMenu );
  GameEvents.Subscribe( "closePVPVoteScreen", closePVPVoteScreen );
  GameEvents.Subscribe( "createPVPGoal", createPVPGoal );
  GameEvents.Subscribe( "openBuilderMenu", openBuilderMenu );
  // GameEvents.Subscribe( "recreateLineWarIncomeTimer", recreateLineWarIncomeTimer );
  GameEvents.Subscribe( "updateLineWarFoodCap", updateLineWarFoodCap );
  GameEvents.Subscribe( "createLineWarIncomeTimer", createLineWarIncomeTimer );
  GameEvents.Subscribe( "updateLineWarIncomeTimer", updateLineWarIncomeTimer );

  GameEvents.Subscribe( "serengaard_vote_skip", createSerengaardVoteSkip );
  GameEvents.Subscribe( "serengaard_between_wave_end", destroySerengaardVoteSkip );
  GameEvents.Subscribe( "serengaard_update_skip_votes", updateSkipVotes)

  GameEvents.Subscribe( "updateTargetDummy", updateTargetDummy );
  GameEvents.Subscribe( "updateDPSLabel", updateDPSLabel );

  GameEvents.Subscribe( "serengaardWaveSpawn", serengaardWaveSpawn );
  GameEvents.Subscribe( "serengaardUpdateData", serengaardUpdateData );

  GameEvents.Subscribe( "serengaardInfiniteWaves", serengaardInfiniteWaves );

  GameEvents.Subscribe( "serengaard_leaderboard", serengaardLeaderboard );
  GameEvents.Subscribe( "serengaard_leaderboard_hide", serengaardLeaderboardHide );

  // serengaardLeaderboard();
})();


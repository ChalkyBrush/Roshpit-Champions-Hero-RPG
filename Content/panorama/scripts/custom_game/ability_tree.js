"use strict";


function OpenAbilityTree()
{
	if ($('#ability_up_button').open){
		$('#ability_up_button').open = false;
		$('#full_ability_tree_skills_container').RemoveClass('animateEaseOutClass');
		$('#full_ability_tree_skills_container').AddClass('animateEaseClass');
		$('#full_ability_tree_skills_container').RemoveClass('invisible');
		UpdateAbilityTree()
	}else{
		$('#ability_up_button').open = true;
		$('#full_ability_tree_skills_container').RemoveClass('animateEaseClass');
		$('#full_ability_tree_skills_container').AddClass('animateEaseOutClass');
		UpdateAbilityTree()
		$.Schedule(0.45, function(){
			$('#full_ability_tree_skills_container').AddClass('invisible');
		});
		
	}
}


function InitializeAbilityTree()
{
	UpdateAbilityTree()
}

function getControllingPlayerIndex()
{
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var playerIndex = Players.GetLocalPlayer();
	if (Entities.IsHero(queryUnit)){
		var playerTable = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString() );
		if (playerTable === undefined){
			playerIndex = Players.GetLocalPlayer();
		}else{
			playerIndex = playerTable.playerOwner
		}
	}else{
		playerIndex = Players.GetLocalPlayer();
	}
	playerIndex = parseInt(playerIndex)
	if (!(Players.IsValidPlayerID(playerIndex))){
		playerIndex = Game.GetAllPlayerIDs()[0];
	}
	return parseInt(playerIndex)
}

function UpdateUnitInfo()
{
	var queryUnit = Players.GetLocalPlayerPortraitUnit()
	GameUI.HealthRegenLabel.text = "+"+parseInt(Entities.GetHealthThinkRegen(queryUnit))
	GameUI.ManaRegenLabel.text = "+"+parseInt(Entities.GetManaThinkRegen(queryUnit))
}

function UpdateAbilityTree(){
	$.Msg("update ability tree")
	$.Msg("------")
	// UpdateUnitInfo()
	var playerID = getControllingPlayerIndex()
	
	// var portraitUnitController = Players.GetLocalPlayerPortraitUnit();
	// for (var i = 1; i <= 4; i++){
	// 	if (Entities.IsControllableByPlayer( portraitUnitController, i))
	// 	{
	// 		playerID = i;

	// 	}
	// }
	// if (!(Players.IsValidPlayerID( playerID ))){
	// 	playerID = 1
	// }
	
	var playerInfo = Game.GetPlayerInfo( playerID );



		// var heroName = $.Localize( "#"+playerInfo.player_selected_hero)
		// $('#skill_hero_name').text = heroName
		// $('#skill_hero_level_text').text = playerInfo.player_level
		var player_stats = CustomNetTables.GetTableValue( "player_stats", playerID.toString() );
		if (!(player_stats === undefined)){
			var skillPoints = player_stats.skillPoints
			if (!($("#basic_skills_text")==null)){
				$("#basic_skills_text").text = $.Localize( "#ui_base_skills")
				$("#rune_text").text = $.Localize( "#ui_runes")
				$.Msg("WTF!?!")
				if (skillPoints > 0){
					$("#basic_skills_text_up").text = "+"+skillPoints
				}else{
					$("#basic_skills_text_up").text = ""
				}
				var runePoints = player_stats.runePoints
				if (runePoints > 0){
					$("#runes_text_up").text = "+"+runePoints
				}else{
					$("#runes_text_up").text = ""
				}
			}
		}else{

		}
	

	var queryUnit = Players.GetLocalPlayerPortraitUnit()
	if ($('#ability_level_overlay1')){
		var ability = Entities.GetAbility( queryUnit, 0 )
		$('#ability_level_overlay_text1').text = "LV"+Abilities.GetLevel( ability )
	}
	if ($('#ability_level_overlay2')){
		var ability = Entities.GetAbility( queryUnit, 1 )
		$('#ability_level_overlay_text2').text = "LV"+Abilities.GetLevel( ability )
	}
	if ($('#ability_level_overlay3')){
		var ability = Entities.GetAbility( queryUnit, 2 )
		$('#ability_level_overlay_text3').text = "LV"+Abilities.GetLevel( ability )
	}
	if ($('#ability_level_overlay4')){
		var ability = Entities.GetAbility( queryUnit, 3 )
		$('#ability_level_overlay_text4').text = "LV"+Abilities.GetLevel( ability )
	}
}

function highlightButton()
{
	$("#character_button_image").src = "file://{images}/custom_game/ui/narrow_panel2_highlight.png"
}

function unhighlightButton()
{
	$("#character_button_image").src = "file://{images}/custom_game/ui/narrow_panel2.png"
}

function OpenCharacterPanel()
{

}
(function()
{
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityTree );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityTree );
	GameEvents.Subscribe( "AbilityUp", UpdateAbilityTree );
	UpdateAbilityTree();
})();

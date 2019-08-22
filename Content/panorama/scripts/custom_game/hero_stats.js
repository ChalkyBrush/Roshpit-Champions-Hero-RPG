function InitializeHeroStatsOnce(){
	// var inventoryPanel = GameUI.InventoryPanel
	// if (inventoryPanel){
	// 	$('#hero_stats_container').SetParent(inventoryPanel)
	// }else{
	// 	$.Schedule( 1.0, InitializeHeroStats );
	// }
	// var inventoryPanel = GameUI.InventoryPanel
	// var positon = GameUI.InventoryPanel.GetPositionWithinWindow()
	// $.Msg(GameUI.InventoryPanel.GetPositionWithinWindow())
	// $.GetContextPanel().style.position = positon.x+"px "+positon.y+"px 0"
	// var positon2 = $.GetContextPanel().GetPositionWithinWindow()
	
	// var differentialX = positon2.x - positon.x 
	// var differentialY = positon2.y - positon.y
	// $.GetContextPanel().style.position = (positon.x-differentialX)+"px "+(positon.y-differentialY)+"px 0"
	// $.Msg($.GetContextPanel().GetPositionWithinWindow())
	$.Schedule( 3, InitializeHeroStats );
}

function InitializeHeroStats(){
	UpdateHeroStats()
	$.Schedule( 0.2, InitializeHeroStats );
	// $.Schedule(0.2, function(){
	// 	InitializeHeroStats()
	// });
}

function UpdateHeroStats(){
	// $.Msg("GAME STATE")
	// $.Msg(Game.GetState())
	// $.Msg(DOTA_GameState.DOTA_GAMERULES_STATE_GAME_IN_PROGRESS)
	if (Game.GetState() < DOTA_GameState.DOTA_GAMERULES_STATE_GAME_IN_PROGRESS){
		return false
	}
	// GameUI.DotaHUD.FindChildTraverse("StatBranch").AddClass("GGStats")
	// GameUI.DotaHUD.FindChildTraverse("StatBranch").style.visibility = "collapse"
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (Entities.IsHero( queryUnit )){
		var heroAttributes = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString()+"_attributes" );
		if (heroAttributes){
			// $('#hero_stats_container').RemoveClass('invisible')
			// $('#strength_label').text = heroAttributes.strength
			// $('#agility_label').text = heroAttributes.agility
			// $('#intelligence_label').text = heroAttributes.intelligence
			var parent = GameUI.DotaHUD.FindChildTraverse("stats_container")
			parent.FindChildTraverse("StrengthLabel").text = heroAttributes.strength
			parent.FindChildTraverse("StrengthModifierLabel").style.visibility = "collapse"
			parent.FindChildTraverse("AgilityLabel").text = heroAttributes.agility
			parent.FindChildTraverse("AgilityModifierLabel").style.visibility = "collapse"
			parent.FindChildTraverse("IntelligenceLabel").text = heroAttributes.intelligence
			parent.FindChildTraverse("IntelligenceModifierLabel").style.visibility = "collapse"
			if (!(heroAttributes.tiamat === undefined) && heroAttributes.tiamat == 1){
				parent.FindChildTraverse("StrengthLabel").style.color = '#6bdcff'
				parent.FindChildTraverse("AgilityLabel").style.color = '#6bdcff'
				parent.FindChildTraverse("IntelligenceLabel").style.color = '#6bdcff'
				parent.FindChildTraverse("StrengthLabel").style.textShadow = '1px 1px 1px #262869'
				parent.FindChildTraverse("AgilityLabel").style.textShadow = '1px 1px 1px #262869'
				parent.FindChildTraverse("IntelligenceLabel").style.textShadow = '1px 1px 1px #262869'
			}else{
				parent.FindChildTraverse("StrengthLabel").style.color = '#cccccc'
				parent.FindChildTraverse("AgilityLabel").style.color = '#cccccc'
				parent.FindChildTraverse("IntelligenceLabel").style.color = '#cccccc'
				parent.FindChildTraverse("StrengthLabel").style.textShadow = '0px 0px 4px 4 #00000088'
				parent.FindChildTraverse("AgilityLabel").style.textShadow = '0px 0px 4px 4 #00000088'
				parent.FindChildTraverse("IntelligenceLabel").style.textShadow = '0px 0px 4px 4 #00000088'
			}
			// var primaryAttribute = parseInt(heroAttributes.primaryAttribute)
			// if (primaryAttribute == 0){
			// 	$('#Hero_Strength_Icon').SetHasClass('primary_attribute', true)
			// 	$('#Hero_Agility_Icon').SetHasClass('primary_attribute', false)
			// 	$('#Hero_Intelligence_Icon').SetHasClass('primary_attribute', false)
			// }else if (primaryAttribute == 1){
			// 	$('#Hero_Strength_Icon').SetHasClass('primary_attribute', false)
			// 	$('#Hero_Agility_Icon').SetHasClass('primary_attribute', true)
			// 	$('#Hero_Intelligence_Icon').SetHasClass('primary_attribute', false)
			// }else if (primaryAttribute == 2){
			// 	$('#Hero_Strength_Icon').SetHasClass('primary_attribute', false)
			// 	$('#Hero_Agility_Icon').SetHasClass('primary_attribute', false)
			// 	$('#Hero_Intelligence_Icon').SetHasClass('primary_attribute', true)
			// }
			var prefix = "+"
			if (heroAttributes.healthRegen < 0){
				prefix = ""
			}
			GameUI.HealthRegenLabel.text = prefix+Math.round(heroAttributes.healthRegen)
			prefix = "+"
			if (heroAttributes.manaRegen < 0){
				prefix = ""
			}
			// $.Msg(Math.round(heroAttributes.manaRegen))
			GameUI.ManaRegenLabel.text = prefix+Math.round(heroAttributes.manaRegen)

			GameUI.MovespeedLabel.text = Math.round(heroAttributes.movespeed)

		}else{

			$('#hero_stats_container').AddClass('invisible')
		}
	}else{
		$('#hero_stats_container').AddClass('invisible')
		// $.Msg("-----------update to other unit?-----------")
		// $.Msg("update to other unit?")
		if (queryUnit > 0){
			$.Msg(Math.round(Entities.GetHealthThinkRegen( queryUnit )))
			$.Msg(Entities.GetUnitName( queryUnit ))
			if (GameUI.HealthRegenLabel){
				GameUI.HealthRegenLabel.text = "+"+Math.round(Entities.GetHealthThinkRegen( queryUnit ))
				GameUI.ManaRegenLabel.text = "+"+Math.round(Entities.GetManaThinkRegen( queryUnit ))
			}
            GameUI.MovespeedLabel.text = Math.round(Entities.GetMoveSpeedModifier(queryUnit, Entities.GetBaseMoveSpeed(queryUnit), false));
		}
	}
}

function InspirationRing(msg)
{
	// if (Players.GetLocalPlayerPortraitUnit() == msg.caster){
		var parent = GameUI.DotaHUD.FindChildTraverse("AbilitiesAndStatBranch")
		var abilities_cast = msg.abilities_cast
		var color = msg.border_color
		$.Msg(abilities_cast)
		for (var j = 1; j <= 4; j++) {
			var panel_index = j-1
			$.Msg(abilities_cast[j])
			if (abilities_cast[j] == 1){
				var ability_panel = parent.FindChildTraverse("Ability"+panel_index).FindChildTraverse("AbilityButton")
				ability_panel.style.border = "3px solid "+color
			}else{
				var ability_panel = parent.FindChildTraverse("Ability"+panel_index).FindChildTraverse("AbilityButton")
				ability_panel.style.border = "0px solid black"
			}
		}
	// }
}

(function()
{
	InitializeHeroStatsOnce()
	GameEvents.Subscribe( "update_hero_stats", UpdateHeroStats );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateHeroStats );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateHeroStats );
	GameEvents.Subscribe( "inspiration_ring", InspirationRing);
})();


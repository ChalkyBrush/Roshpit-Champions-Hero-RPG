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

			parent.FindChildTraverse("ArmorLabelBase").text = heroAttributes.armor_base
			if (heroAttributes.armor_bonus > 0){
				var armor_label = parent.FindChildTraverse("ArmorModifierLabel")
				armor_label.RemoveClass("invisible")
				armor_label.text = "+"+heroAttributes.armor_bonus
				armor_label.style.color = '#44a349'
			}else if(heroAttributes.armor_bonus< 0){
				var armor_label = parent.FindChildTraverse("ArmorModifierLabel")
				armor_label.RemoveClass("invisible")
				armor_label.text = heroAttributes.armor_bonus
				armor_label.style.color = '#a02420'
			}else{
				var armor_label = parent.FindChildTraverse("ArmorModifierLabel")
				armor_label.AddClass("invisible")
				armor_label.style.color = '#EEEEEE'
				armor_label.text = ""
			}
			var totalArmor = parseInt(heroAttributes.armor_base) + parseInt(heroAttributes.armor_bonus)
			var resist = (0.05*totalArmor/(1 + (0.05 * Math.abs(totalArmor))))
			resist = (parseInt(resist*100000))/1000
			parent.FindChildTraverse("PhysicalDamageResist").text = resist+"%"
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
            GameUI.MovespeedLabel.text = Math.round(Entities.GetMoveSpeedModifier(queryUnit, Entities.GetBaseMoveSpeed(queryUnit)));
			var parent = GameUI.DotaHUD.FindChildTraverse("stats_container")
			var buffCount = Entities.GetNumBuffs( queryUnit)
			var unitAttributes = CustomNetTables.GetTableValue( "portal_keys", queryUnit.toString()+"_data" );
			var armor_base = parseInt(unitAttributes.armor_base)
			var armor_bonus = parseInt(unitAttributes.armor_bonus)
			parent.FindChildTraverse("ArmorLabelBase").text = armor_base
			if (armor_bonus > 0){
				var armor_label = parent.FindChildTraverse("ArmorModifierLabel")
				armor_label.RemoveClass("invisible")
				armor_label.text = "+"+armor_bonus
				armor_label.style.color = '#44a349'
			}else if(armor_bonus< 0){
				var armor_label = parent.FindChildTraverse("ArmorModifierLabel")
				armor_label.RemoveClass("invisible")
				armor_label.text = armor_bonus
				armor_label.style.color = '#a02420'
			}else{
				var armor_label = parent.FindChildTraverse("ArmorModifierLabel")
				armor_label.AddClass("invisible")
				armor_label.style.color = '#EEEEEE'
				armor_label.text = ""
			}
			var totalArmor = parseInt(armor_base) + parseInt(armor_bonus)
			var resist = (0.05*totalArmor/(1 + (0.05 * Math.abs(totalArmor))))
			resist = (parseInt(resist*100000))/1000
			parent.FindChildTraverse("PhysicalDamageResist").text = resist+"%"
		}

	}
}

(function()
{
	InitializeHeroStatsOnce()
	GameEvents.Subscribe( "update_hero_stats", UpdateHeroStats );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateHeroStats );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateHeroStats );
})();


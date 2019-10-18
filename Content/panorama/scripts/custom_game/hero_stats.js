mQueryUnit = 0
mAttributesHash = {modifier_roshpit_level: null, modifier_roshpit_armor: null, modifier_negative_roshpit_armor: null, modifier_positive_roshpit_armor: null, modifier_roshpit_magic_armor: null, modifier_negative_roshpit_magic_armor: null, modifier_positive_roshpit_magic_armor: null, modifier_roshpit_armor_pierce: null, modifier_roshpit_spell_pierce: null}

function InitializeHeroStatsOnce(){
	$.Schedule( 3, InitializeHeroStats );
}

function InitializeHeroStats(){
	UnitStats40()
	$.Schedule( 0.2, InitializeHeroStats );
	// $.Schedule(0.2, function(){
	// 	InitializeHeroStats()
	// });

}

function recalculate_attributes(){
	mQueryUnit = 0
	UnitStats40()
}

function get_attributes_for_query_unit(queryUnit){
	var number_of_buffs = Entities.GetNumBuffs( queryUnit )
	mAttributesHash["modifier_negative_roshpit_armor"] = 0
	mAttributesHash["modifier_negative_roshpit_magic_armor"] = 0
	mAttributesHash["modifier_positive_roshpit_armor"] = 0
	mAttributesHash["modifier_positive_roshpit_magic_armor"] = 0
	mAttributesHash["modifier_roshpit_level"] = 0
	mAttributesHash["modifier_roshpit_armor"] = 0
	mAttributesHash["modifier_roshpit_magic_armor"] = 0
	mAttributesHash["modifier_roshpit_armor_pierce"] = 0
	mAttributesHash["modifier_roshpit_spell_pierce"] = 0
	$.Msg("**#*$#*$*#$*#*$")
	for (i = 0; i < number_of_buffs+1; i++) {
	  // var buff = Entities.GetBuff( queryUnit, i)
	  var buffName = Buffs.GetName( queryUnit, i )

	  $.Msg(buffName)
	  if (buffName == "modifier_roshpit_armor"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if(buffName == "modifier_negative_roshpit_armor"){
	  	$.Msg("NEGATIVE ROSHPIT ARMOR")
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if(buffName == "modifier_positive_roshpit_armor"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if(buffName == "modifier_roshpit_magic_armor"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if(buffName == "modifier_negative_roshpit_magic_armor"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if(buffName == "modifier_positive_roshpit_magic_armor"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if(buffName == "modifier_roshpit_armor_pierce"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if(buffName == "modifier_roshpit_spell_pierce"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }else if (buffName == "modifier_roshpit_level"){
	  	mAttributesHash[buffName] = Buffs.GetStackCount( queryUnit, i )
	  }
	}
	mQueryUnit = queryUnit
}

function UnitStats40(){
	GameUI.STATS_PANEL.style.visibility = "visible"
	// if (Game.GetState() < DOTA_GameState.DOTA_GAMERULES_STATE_GAME_IN_PROGRESS){
	// 	return false
	// }	
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	get_attributes_for_query_unit(queryUnit)
	if (Entities.IsHero( queryUnit )){
		$('#hero_attributes').style.visibility = "visible"
		$('#unit_attributes').style.horizontalAlign = "left"
		$('#unit_attributes').AddClass('unit_attributes_for_heroes')

		var heroAttributes = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString()+"_attributes" );
		if (!(heroAttributes===undefined)){
			$('#strength_label').text = heroAttributes.strength
			$('#agility_label').text = heroAttributes.agility
			$('#intelligence_label').text = heroAttributes.intelligence	
			$('#spirit_label').text = heroAttributes.spirit		
			GameUI.level_label.text = Entities.GetLevel( queryUnit )
		}
	}else{
		$('#hero_attributes').style.visibility = "collapse"
		$('#unit_attributes').style.horizontalAlign = "right"
		$('#unit_attributes').RemoveClass('unit_attributes_for_heroes')
		GameUI.level_label.text = mAttributesHash["modifier_roshpit_level"]
	}
	// if (!(mQueryUnit == queryUnit)){
	$('#unit_attribute_armor_label').text = mAttributesHash["modifier_roshpit_armor"]
	if (mAttributesHash["modifier_positive_roshpit_armor"] > 0){
		$('#unit_attribute_armor_label').AddClass('stat_bonus')
		$('#unit_attribute_armor_label').RemoveClass('stat_negative')
		$('#unit_attribute_armor_label').RemoveClass('attribute_neutral')
	}else if (mAttributesHash["modifier_negative_roshpit_armor"] > 0){
		$.Msg("NEGATIVE ARMOR?")
		$('#unit_attribute_armor_label').AddClass('stat_negative')
		$('#unit_attribute_armor_label').RemoveClass('stat_bonus')
		$('#unit_attribute_armor_label').RemoveClass('attribute_neutral')
	}else{
		$.Msg("neutral ARMOR?")
		$('#unit_attribute_armor_label').AddClass('attribute_neutral')
		$('#unit_attribute_armor_label').RemoveClass('stat_negative')
		$('#unit_attribute_armor_label').RemoveClass('stat_bonus')
	}


	$('#unit_attribute_magic_armor_label').text = mAttributesHash["modifier_roshpit_magic_armor"]
	if (mAttributesHash["modifier_positive_roshpit_magic_armor"] > 0){
		$('#unit_attribute_magic_armor_label').AddClass('stat_bonus')
		$('#unit_attribute_magic_armor_label').RemoveClass('stat_negative')
		$('#unit_attribute_magic_armor_label').RemoveClass('attribute_neutral')
	}else if (mAttributesHash["modifier_negative_roshpit_magic_armor"] > 0){
		$('#unit_attribute_magic_armor_label').AddClass('stat_negative')
		$('#unit_attribute_magic_armor_label').RemoveClass('stat_bonus')
		$('#unit_attribute_magic_armor_label').RemoveClass('attribute_neutral')
	}else{
		$('#unit_attribute_magic_armor_label').AddClass('attribute_neutral')
		$('#unit_attribute_magic_armor_label').RemoveClass('stat_negative')
		$('#unit_attribute_magic_armor_label').RemoveClass('stat_bonus')
	}


	$('#unit_attribute_armor_pierce_label').text = mAttributesHash["modifier_roshpit_armor_pierce"]
	$('#unit_attribute_spell_pierce_label').text = mAttributesHash["modifier_roshpit_spell_pierce"]

	$('#unit_attribute_armor_pierce_label').AddClass('attribute_neutral')
	$('#unit_attribute_spell_pierce_label').AddClass('attribute_neutral')
	// }
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

			// GameUI.MovespeedLabel.text = Math.round(heroAttributes.movespeed)

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
            // GameUI.MovespeedLabel.text = Math.round(Entities.GetMoveSpeedModifier(queryUnit, Entities.GetBaseMoveSpeed(queryUnit), false));
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
	// GameEvents.Subscribe( "update_hero_stats", UnitStats40 );
	GameEvents.Subscribe( "update_roshpit_stats", UnitStats40 );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UnitStats40 );
	GameEvents.Subscribe( "dota_player_update_query_unit", UnitStats40 );
	// GameEvents.Subscribe( "recalculate_attributes", recalculate_attributes );
	GameEvents.Subscribe( "inspiration_ring", InspirationRing);
})();


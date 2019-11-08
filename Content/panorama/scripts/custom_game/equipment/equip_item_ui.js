function NewItemEquip(msg)
{
	var root_attach = $.GetContextPanel()
	root_attach.style.width = '650px';
	root_attach.RemoveAndDeleteChildren()
	root_attach.RemoveClass('equip_fade_in')
	root_attach.AddClass('equip_fade_in')
	var old_item_panel = $.CreatePanel("Panel", root_attach, "old_item_panel")
	old_item_panel.BLoadLayoutSnippet("equip_item_container")
	old_item_panel.style.borderRight = "1px solid white"
	var attacher = old_item_panel.FindChildTraverse('item_attacher')
	var old_item_tooltip = $.CreatePanel("Panel", attacher, "old_item_tooltip")
	old_item_tooltip.BLoadLayoutSnippet("equip_item_display")
	old_item_tooltip.FindChildTraverse('new_or_old').text = $.Localize('ui_old_item')
	initializeTooltip(old_item_tooltip, msg.oldItem)

	var button_attacher = old_item_panel.FindChildTraverse('buttons_attacher')
	var buttons_container = $.CreatePanel("Panel", button_attacher, "old_item_button_attacher")
	buttons_container.BLoadLayoutSnippet('equip_item_button_options')
	buttons_container.FindChildTraverse('button-option-1-text').text = $.Localize("ui_old_item_option_1")
	buttons_container.FindChildTraverse('button-option-2-text').text = $.Localize("ui_old_item_option_2")
	buttons_container.FindChildTraverse('buttons-title').text = $.Localize("ui_old_item_main_option") + ":"
	buttons_container.FindChildTraverse('buttons-title').style.color="#6eb1db"
	buttons_container.FindChildTraverse('button-option-1').AddClass('buttons_old_colors')
	buttons_container.FindChildTraverse('button-option-2').AddClass('buttons_old_colors')
	buttons_container.FindChildTraverse('extra-equip-info').DeleteAsync(0)
	var button1 = buttons_container.FindChildTraverse('button-option-1')
	var button2 = buttons_container.FindChildTraverse('button-option-2')

	set_swap_button_event(button1, 1)
	set_swap_button_event(button2, 2)

	var new_item_panel = $.CreatePanel("Panel", root_attach, "new_item_panel")
	new_item_panel.BLoadLayoutSnippet("equip_item_container")
	new_item_panel.style.borderRight = "1px solid white"
	var attacher = new_item_panel.FindChildTraverse('item_attacher')
	var new_item_tooltip = $.CreatePanel("Panel", attacher, "new_item_tooltip")
	new_item_tooltip.BLoadLayoutSnippet("equip_item_display")
	new_item_tooltip.FindChildTraverse('new_or_old').text = "*"+$.Localize('ui_new_item')+"*"
	new_item_tooltip.FindChildTraverse('new_or_old').AddClass('new_item_color')
	initializeTooltip(new_item_tooltip, msg.newItem)

	var button_attacher = new_item_panel.FindChildTraverse('buttons_attacher')
	var buttons_container = $.CreatePanel("Panel", button_attacher, "new_item_button_attacher")
	buttons_container.BLoadLayoutSnippet('equip_item_button_options')
	buttons_container.FindChildTraverse('button-option-1-text').text = $.Localize("ui_new_item_option_1")
	buttons_container.FindChildTraverse('button-option-2-text').text = $.Localize("ui_new_item_option_2")
	buttons_container.FindChildTraverse('buttons-title').text = $.Localize("ui_new_item_main_option") + ":"
	buttons_container.FindChildTraverse('buttons-title').style.color="#6eb1db"
	buttons_container.FindChildTraverse('button-option-1').AddClass('buttons_new_colors')
	buttons_container.FindChildTraverse('button-option-2').AddClass('buttons_new_colors')

	var button1 = buttons_container.FindChildTraverse('button-option-1')
	var button2 = buttons_container.FindChildTraverse('button-option-2')

	set_swap_button_event(button1, 3)
	set_swap_button_event(button2, 4)

	if (msg.hero_slot == 0){
		buttons_container.FindChildTraverse('button-option-1-text').text = $.Localize("ui_new_item_option_no_save_slot")
		button2.AddClass('invisible')
	}

	Game.EmitSound("UI.EquipItemSwap.Popup")
}

function set_swap_button_event(button, index){
	button.SetPanelEvent('onactivate', function Activate(){
		item_swap_input(index)
	});	
}

function EquipTooltip()
{
	var panel = $.GetContextPanel().FindChildTraverse('extra-equip-info')
	var title = "<font color='yellow'>"+$.Localize("ui_new_item_equip_tooltip_title")
	var tooltip = $.Localize("ui_new_item_equip_tooltip_text")
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideEquipTooltip(){
	var panel = $.GetContextPanel().FindChildTraverse('extra-equip-info')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function item_swap_input(index){
	GameEvents.SendCustomGameEventToServer( "item_swap_input", {input_msg: index} );
	if (index == 1){
		Game.EmitSound("UI.Roshpit.ItemReturn")
	}
	CloseItemEquip()
}
// "ui_old_item"			"Old"
// "ui_new_item"			"New"
// "ui_old_item_main_option" "Keep old item equipped"
// "ui_old_item_option_1"	"Return new item to inventory"
// "ui_old_item_option_2"	"Discard new item"
// "ui_old_item_main_option" "Equip new item"
// "ui_new_item_option_1"	"Save Hero"
// "ui_new_item_option_2"	"Don't Save"
// "ui_new_item_extra_help"	"Both of these options will destroy the currently equipped item."

function CloseItemEquip()
{
	var root_attach = $.GetContextPanel()
	root_attach.style.width = '0px';
	root_attach.RemoveAndDeleteChildren()
}

function initializeTooltip(main_panel, item){
	// $.Msg(func)
	// $.Msg("INIT TOOLTIP")
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var heroName = 	Entities.GetUnitName( queryUnit )
	// $.Msg(item)
	// $.Msg(queryUnit)
	var itemName = Abilities.GetAbilityName( item );
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	$.Msg(itemValues)

	itemValues = itemValuesCheck(itemValues)
	var unitName = queryUnit
	if (!(itemValues.requiredHero === undefined)){
		if (Entities.GetUnitName( queryUnit ) == itemValues.requiredHero){

		}else{
			heroName = itemValues.requiredHero
		}
	}
	main_panel.FindChildTraverse('equip_item_image').contextEntityIndex = item;
	manageSocketsWithRoot(main_panel, item)
	//TITLE
	var localizedItemName = $.Localize("#DOTA_Tooltip_Ability_"+Abilities.GetAbilityName(item))
	var itemPrefix = itemValues.itemPrefix
	var itemSuffix = itemValues.itemSuffix
	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+localizedItemName+" "+itemSuffix+"</font>"

	main_panel.FindChildTraverse('tooltip_title').text = title

	//QUALITY AND SLOT

	var tooltip = ""
	// if (itemValues.consumable == 1)
	// {
	// 	tooltip = tooltip+"<font color='#AAAAAA'>Consumable</font><br>"
	// }
	tooltip = tooltip+""+itemValues.itemDescription
	main_panel.FindChildTraverse('tooltip_quality_left').text = itemValues.qualityName
	main_panel.FindChildTraverse('tooltip_quality_right').text = tooltip

		if (!(itemValues.useDescription === undefined)){
			var tooltip = ""
			tooltip = tooltip + "<font color='#A3D4A1'>"+$.Localize(itemValues.useDescription)+"</font>"
			tooltip = replaceConsumableText(itemValues, tooltip)
			tooltip = updateGlyphInTooltip(tooltip, item)
			$.Msg("AGAIN HI:"+queryUnit)
			tooltip = updateSkillInTooltipHandler(tooltip, itemValues, queryUnit)
			main_panel.FindChildTraverse('consumable-text').text = tooltip
			main_panel.FindChildTraverse('consumable-text').RemoveClass('invisible')
			main_panel.FindChildTraverse('properties_name1').AddClass('invisible')
			main_panel.FindChildTraverse('properties_value1').AddClass('invisible')
			main_panel.FindChildTraverse('properties_special1').AddClass('invisible')
			main_panel.FindChildTraverse('properties_name2').AddClass('invisible')
			main_panel.FindChildTraverse('properties_value2').AddClass('invisible')
			main_panel.FindChildTraverse('properties_special2').AddClass('invisible')
			main_panel.FindChildTraverse('properties_name3').AddClass('invisible')
			main_panel.FindChildTraverse('properties_value3').AddClass('invisible')
			main_panel.FindChildTraverse('properties_special3').AddClass('invisible')
			main_panel.FindChildTraverse('properties_name4').AddClass('invisible')
			main_panel.FindChildTraverse('properties_value4').AddClass('invisible')
			main_panel.FindChildTraverse('properties_special4').AddClass('invisible')

			var itemProperty1 = {}
			if (itemValues.property1color) itemProperty1.propertyColor = itemValues.property1color
			if (itemValues.property1) itemProperty1.propertyValue = itemValues.property1
			if (itemValues.property1special) itemProperty1.specialDescription = itemValues.property1special
			if (itemValues.property1tooltip) itemProperty1.propertyName = itemValues.property1tooltip == "rune" ? itemValues.property1name : itemValues.property1tooltip
			$.Msg("Tooltip useDescription")
			if (!(itemProperty1===undefined)){
				var property1text = AddAffixToItem("", itemProperty1, queryUnit, "", 5, itemName)
				if (property1text[0] !== undefined && property1text[1] !== undefined){
					main_panel.FindChildTraverse('properties_name1').text = property1text[0]
					main_panel.FindChildTraverse('properties_value1').text = property1text[1]
					main_panel.FindChildTraverse('properties_name1').RemoveClass('invisible')
					main_panel.FindChildTraverse('properties_value1').RemoveClass('invisible')				
				}				
			}
		}else{
			main_panel.FindChildTraverse('consumable-text').AddClass('invisible')
			
			if (itemValues.base_armor > 0){
				main_panel.FindChildTraverse('armor-text').RemoveClass('invisible')
				main_panel.FindChildTraverse('armor-text').text = itemValues.base_armor
				main_panel.FindChildTraverse('equipment_attribute_armor').RemoveClass('invisible')
			}else{
				main_panel.FindChildTraverse('equipment_attribute_armor').AddClass('invisible')
				main_panel.FindChildTraverse('armor-text').AddClass('invisible')
			}
			if (itemValues.base_magic_armor > 0){
				main_panel.FindChildTraverse('magic-armor-text').RemoveClass('invisible')
				main_panel.FindChildTraverse('magic-armor-text').text = itemValues.base_magic_armor
				main_panel.FindChildTraverse('equipment_attribute_magic_armor').RemoveClass('invisible')
			}else{
				main_panel.FindChildTraverse('magic-armor-text').AddClass('invisible')
				main_panel.FindChildTraverse('equipment_attribute_magic_armor').AddClass('invisible')
			}
			//PROPERTY1
			var itemProperty1 = {}
			itemProperty1.propertyColor = itemValues.property1color
			itemProperty1.propertyValue = itemValues.property1
			itemProperty1.specialDescription = itemValues.property1special
			itemProperty1.propertyName = itemValues.property1tooltip == "rune" ? itemValues.property1name : itemValues.property1tooltip

			var property1text = AddAffixToItem("", itemProperty1, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			main_panel.FindChildTraverse('properties_name1').text = property1text[0]
			main_panel.FindChildTraverse('properties_value1').text = property1text[1]
			main_panel.FindChildTraverse('properties_name1').RemoveClass('invisible')
			main_panel.FindChildTraverse('properties_value1').RemoveClass('invisible')

			handleSpecialProperty(itemProperty1, 1, item, queryUnit, itemValues, itemProperty1, main_panel)
			//PROPERTY2
			var itemProperty2 = {}
			itemProperty2.propertyColor = itemValues.property2color
			itemProperty2.propertyValue = itemValues.property2
			itemProperty2.specialDescription = itemValues.property2special
			itemProperty2.propertyName = itemValues.property2tooltip == "rune" ? itemValues.property2name : itemValues.property2tooltip

			var property2text = AddAffixToItem("", itemProperty2, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			main_panel.FindChildTraverse('properties_name2').text = property2text[0]
			main_panel.FindChildTraverse('properties_value2').text = property2text[1]
			main_panel.FindChildTraverse('properties_name2').RemoveClass('invisible')
			main_panel.FindChildTraverse('properties_value2').RemoveClass('invisible')

			handleSpecialProperty(itemProperty2, 2, item, queryUnit, itemValues, itemProperty2, main_panel)
			//PROPERTY3
			var itemProperty3 = {}
			itemProperty3.propertyColor = itemValues.property3color
			itemProperty3.propertyValue = itemValues.property3
			itemProperty3.specialDescription = itemValues.property3special
			itemProperty3.propertyName = itemValues.property3tooltip == "rune" ? itemValues.property3name : itemValues.property3tooltip

			var property3text = AddAffixToItem("", itemProperty3, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			main_panel.FindChildTraverse('properties_name3').text = property3text[0]
			main_panel.FindChildTraverse('properties_value3').text = property3text[1]
			main_panel.FindChildTraverse('properties_name3').RemoveClass('invisible')
			main_panel.FindChildTraverse('properties_value3').RemoveClass('invisible')

			handleSpecialProperty(itemProperty3, 3, item, queryUnit, itemValues, itemProperty3, main_panel)
			//PROPERTY4
			var itemProperty4 = {}
			itemProperty4.propertyColor = itemValues.property4color
			itemProperty4.propertyValue = itemValues.property4
			itemProperty4.specialDescription = itemValues.property4special
			itemProperty4.propertyName = itemValues.property4tooltip == "rune" ? itemValues.property4name : itemValues.property4tooltip

			var property4text = AddAffixToItem("", itemProperty4, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			main_panel.FindChildTraverse('properties_name4').text = property4text[0]
			main_panel.FindChildTraverse('properties_value4').text = property4text[1]
			main_panel.FindChildTraverse('properties_name4').RemoveClass('invisible')
			main_panel.FindChildTraverse('properties_value4').RemoveClass('invisible')

			handleSpecialProperty(itemProperty4, 4, item, queryUnit, itemValues, itemProperty4, main_panel)

			if(!(itemValues.glyph ===undefined)){
				if (itemValues.glyph == 1){
					main_panel.FindChildTraverse('properties_special1').AddClass('invisible')
				}
			}
		}

		//MINLEVEL
		var bHideReqLines = true
		if (!(itemValues.minLevel ===undefined)){
			var minLevel = itemValues.minLevel
			minLevel = 0 
			//for this
			var minLevelText = ""
			if (minLevel > 0){
				minLevelText = minLevelText + "<font color='#DB2766'>"+$.Localize('#item_min_level')+": "+minLevel+"</font>"
			}
			if (parseInt(minLevel) > 0){
				main_panel.FindChildTraverse('tooltip_requirements_left').RemoveClass('invisible')
				main_panel.FindChildTraverse('tooltip_requirements_left').text = minLevelText
				bHideReqLines = false
			}else{
				main_panel.FindChildTraverse('tooltip_requirements_left').AddClass('invisible')
			}
		}else{
			main_panel.FindChildTraverse('tooltip_requirements_left').AddClass('invisible')
		}
		//REQUIRED HERO
		// if (itemValues.requiredHero === undefined){
		// 	main_panel.FindChildTraverse('tooltip_requirements_right').AddClass('invisible')
		// }else{
		// 	var requiredHeroText = $.Localize(itemValues.requiredHero)
		// 	main_panel.FindChildTraverse('tooltip_requirements_right').RemoveClass('invisible')
		// 	main_panel.FindChildTraverse('tooltip_requirements_right').text = requiredHeroText

		// 	$.Msg(requiredHeroText)
		// 	bHideReqLines = false
		// }
		$.Msg("BHIDEREQ")
		$.Msg(bHideReqLines)
		if(bHideReqLines){
			main_panel.FindChildTraverse('class-splitter3').AddClass('invisible')
			// main_panel.FindChildTraverse('class-splitter4').AddClass('invisible')
		}else{
			main_panel.FindChildTraverse('class-splitter3').RemoveClass('invisible')
			// main_panel.FindChildTraverse('class-splitter4').RemoveClass('invisible')
		}

		// WEAPON DATA

		// tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemTable.requiredHero)+" "+$.Localize('#weapon_usable')+"</font>"
		// tooltip = tooltip + "<br><br><font color='#FF2B2B'>"+$.Localize('#weapon_max_level')+": "+itemTable.maxLevel+"</font>"

		var weaponValues = itemValues
		$.Msg(weaponValues)
		if (!(weaponValues === undefined) && !(weaponValues.level === undefined)){
			$.Msg("SHOULD BE HERE!!!")
			$.Msg("item_tooltip_popout.js weaponValues")
			main_panel.FindChildTraverse('tooltip_weapons_data_container').RemoveClass('invisible')
			main_panel.FindChildTraverse('tooltip_weapon_left1').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_current_level')+":</font>"
			main_panel.FindChildTraverse('tooltip_weapon_right1').text = "<font color='#FFFFFF'>"+weaponValues.level+"</font>"
			main_panel.FindChildTraverse('tooltip_weapon_left2').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_max_level')+":</font>"
			main_panel.FindChildTraverse('tooltip_weapon_right2').text = "<font color='#FFFFFF'>"+weaponValues.maxLevel+"</font>"
			if (weaponValues.item_name == Abilities.GetAbilityName(item)){
				main_panel.FindChildTraverse('weapon_exp_bar').RemoveClass("invisible")
				if (weaponValues.level == weaponValues.maxLevel){
					main_panel.FindChildTraverse('weapon_exp_bar_inner').style.width = "100%"
					main_panel.FindChildTraverse('weapon_exp_bar_text').text = "<font color='#f4dc42'>"+"★ MAX LEVEL ★"+"</font>"
				}else{
					var percentage = (parseInt(weaponValues.xp)/parseInt(weaponValues.xpNeeded))*100
					// percentage = toString(percentage)+"%"
					$.Msg(percentage)
					main_panel.FindChildTraverse('weapon_exp_bar_inner').RemoveClass('invisible')
					main_panel.FindChildTraverse('weapon_exp_bar_inner').style.width = percentage + "%"
					main_panel.FindChildTraverse('weapon_exp_bar_text').text = weaponValues.xp+" / "+weaponValues.xpNeeded
				}
			}
		}else if(itemValues.maxLevel){
			main_panel.FindChildTraverse('tooltip_weapons_data_container').RemoveClass('invisible')
			main_panel.FindChildTraverse('tooltip_weapon_left1').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_current_level')+":</font>"
			main_panel.FindChildTraverse('tooltip_weapon_right1').text = "<font color='#FFFFFF'>"+1+"</font>"
			main_panel.FindChildTraverse('tooltip_weapon_left2').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_max_level')+":</font>"
			main_panel.FindChildTraverse('tooltip_weapon_right2').text = "<font color='#FFFFFF'>"+itemValues.maxLevel+"</font>"
		}else{
			main_panel.FindChildTraverse('weapon_exp_bar').AddClass("invisible")
			main_panel.FindChildTraverse('tooltip_weapons_data_container').AddClass('invisible')
		}

		// var returned = CustomNetTables.GetTableValue( "item_basics", item.toString()+"-returned")
		// if (returned === undefined){
		// 	main_panel.FindChildTraverse('dupe').AddClass("invisible")
		// }else{
		// 	main_panel.FindChildTraverse('dupe').RemoveClass("invisible")
		// 	main_panel.FindChildTraverse('dupe').text = "<font color='#FFFFFF'>*"+$.Localize('item_possibly_duped')+"</font>"
		// }	
}

function updateSkillInTooltipHandler(tooltip, itemValues, queryUnit){
	if (!(itemValues.requiredHero === undefined)){
		if (Entities.GetUnitName( queryUnit ) == itemValues.requiredHero){
			tooltip = updateSkillInTooltip(tooltip, queryUnit)
			tooltip = replaceRuneTooltip(tooltip, queryUnit, itemValues.requiredHero)
		}else{
			tooltip = updateSkillInTooltipByName(tooltip, itemValues.requiredHero)
			tooltip = replaceRuneTooltip(tooltip, -1, itemValues.requiredHero)
		}
	}else{
		tooltip = updateSkillInTooltip(tooltip, queryUnit)
		tooltip = replaceRuneTooltip(tooltip, queryUnit, "")
	}
	return tooltip
}

function handleSpecialProperty(itemProperty, index, item, queryUnit, itemValues, itemProperty, main_panel){
	if (!(itemProperty === undefined)){
		if (!(itemProperty.specialDescription === undefined)){
			specialText1 = $.Localize(itemProperty.specialDescription)
			specialText1 = SpecialDescriptionValues(specialText1, item)
			specialText1 = updateSkillInTooltipHandler(specialText1, itemValues, queryUnit)
			main_panel.FindChildTraverse('properties_special'+index).RemoveClass('invisible')
			main_panel.FindChildTraverse('properties_special_text'+index).text = specialText1
			main_panel.FindChildTraverse('properties_special_title'+index).text = tooltipName = "<font color='"+itemProperty.propertyColor+"'>"+$.Localize(itemProperty.propertyName)+"</font>"
			if (index == 1){
				var typeData = AddDamageTypeAndElementToItem(item)
				if (typeData[2]){
					main_panel.FindChildTraverse('tooltip_special_element_container1').RemoveClass('invisible')
					main_panel.FindChildTraverse('tooltip_special_left1').text = typeData[0][0]
					main_panel.FindChildTraverse('tooltip_special_right1').text = typeData[0][1]
					main_panel.FindChildTraverse('tooltip_special_left2').text = typeData[1][0]
					main_panel.FindChildTraverse('tooltip_special_right2').text = typeData[1][1]
				}else{
					main_panel.FindChildTraverse('tooltip_special_element_container1').AddClass('invisible')
				}
			}
		}else{
			main_panel.FindChildTraverse('properties_special'+index).AddClass('invisible')	
		}
	}else{
		main_panel.FindChildTraverse('properties_name'+index).AddClass('invisible')
		main_panel.FindChildTraverse('properties_value'+index).AddClass('invisible')
		main_panel.FindChildTraverse('properties_special'+index).AddClass('invisible')				
	}
	if (itemValues.rarityFactor < index){
		main_panel.FindChildTraverse('properties_name'+index).AddClass('invisible')
		main_panel.FindChildTraverse('properties_value'+index).AddClass('invisible')
		main_panel.FindChildTraverse('properties_special'+index).AddClass('invisible')		
	}
}

function AddAffixToItem(tooltip, itemProperty, queryUnit, requiredHero, rarityFactor, itemName)
{
	if (itemProperty === undefined){
		return tooltip
	}
	var OGpropertyName = itemProperty.propertyName
	if (OGpropertyName === undefined){
		return tooltip
	}
	var propertyName = $.Localize(itemProperty.propertyName)
	// itemProperty = itemPropertyCheck(itemProperty)
    $.Msg("OGpropertyName: " + OGpropertyName)
	if (OGpropertyName.indexOf("rune_") >= 0){
		var playerIndex = getControllingPlayerIndex()
        var abilitySlot = -1
		if (OGpropertyName.indexOf("rune_q") >= 0){
            abilitySlot = 0
		}else if (OGpropertyName.indexOf("rune_w") >= 0){
            abilitySlot = 1
		}else if (OGpropertyName.indexOf("rune_e") >= 0){
            abilitySlot = 2
		}else if (OGpropertyName.indexOf("rune_r") >= 0){
            abilitySlot = 3
        }
        var runeIndex = getRuneIndexFromRuneName(OGpropertyName)
		if (requiredHero === undefined){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit"+runeIndex );
			var rune_unit_index = skill_tree_data.runeUnit;
            var abilityIndex = Entities.GetAbility(rune_unit_index, abilitySlot)
            var abilityName = Abilities.GetAbilityName(abilityIndex)
            propertyName = $.Localize("DOTA_Tooltip_Ability_" + abilityName)
		}else{
			if (rarityFactor == 6){
				var RPCName = convertFullHeroNameToRPC(requiredHero)	
				var arcanaSuffix = itemName.replace("item_rpc_"+RPCName+"_", "_");
				propertyName = $.Localize("DOTA_Tooltip_Ability_"+RPCName+"_"+OGpropertyName+arcanaSuffix)
				$.Msg(propertyName)
			}else{
				var RPCName = convertFullHeroNameToRPC(requiredHero)	
				propertyName = $.Localize("DOTA_Tooltip_Ability_"+RPCName+"_"+OGpropertyName)
				$.Msg(propertyName)		
			}
		}
		// itemProperty = itemPropertyCheck(itemProperty)
	}
	if (OGpropertyName.indexOf("#DOTA_Tooltip_Ability") >= 0){
		propertyName = $.Localize(OGpropertyName)
		$.Msg("OGPROPERTYNAME!")
	}
	tooltipName = "<font color='"+itemProperty.propertyColor+"'>"+propertyName+"</font>"
	tooltipValue = "<font color='"+itemProperty.propertyColor+"'>"+itemProperty.propertyValue+"</font>"

	return [tooltipName, tooltipValue]
}

function itemValuesCheck(itemValues)
{
	if (itemValues === undefined){
		itemValues = {}
	}
	if (itemValues.qualityName === undefined){
		itemValues.qualityName = "undefined"
	}
	if (itemValues.consumable === undefined){
		itemValues.consumable = 0
	}
	if (itemValues.itemDescription === undefined){
		itemValues.itemDescription = "undefined"
	}
	if (itemValues.rarityFactor === undefined){
		itemValues.rarityFactor = 1
	}
	if (itemValues.itemPrefix === undefined){
		itemValues.itemPrefix = "undefined"
	}
	if (itemValues.itemSuffix === undefined){
		itemValues.itemSuffix = "undefined"
	}
	if (itemValues.qualityColor === undefined){
		itemValues.qualityColor  = "#FFFFFF"
	}
	if (itemValues.item_name === undefined){
		itemValues.item_name  = "undefined"
	}
	return itemValues
}

function replaceConsumableText(itemValues, tooltip)
{
	if (itemValues.property3color && itemValues.property3name){
		tooltip = tooltip.replace("@consumableProperty3", "<font color='"+itemValues.property3color+"'>"+$.Localize(itemValues.property3name)+"</font>")
	}
	return tooltip
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

function getRuneIndexFromRuneName(propertyName) {
    var index = -1
    if (propertyName.indexOf("_1") >= 1) {
        index = 1
    } else if (propertyName.indexOf("_2") >= 1) {
        index = 2
    } else if (propertyName.indexOf("_3") >= 1) {
        index = 3
    } else if (propertyName.indexOf("_4") >= 1) {
        index = 4
    }
    return index
}

function updateGlyphInTooltip(tooltip, item)
{
	var value = Abilities.GetLevelSpecialValueFor( item, "property_one", 1)
	if (tooltip.indexOf("@glyph_property1") > -1){
		tooltip = tooltip.replace("@glyph_property1", "<font color='#CCFF66'>"+value+"</font>");
	}
	var value2 = Abilities.GetLevelSpecialValueFor( item, "property_two", 1)
	if (tooltip.indexOf("@glyph_property2") > -1){
		tooltip = tooltip.replace("@glyph_property2", "<font color='#CCFF66'>"+value2+"</font>");
	}
	var value3 = Abilities.GetLevelSpecialValueFor( item, "property_three", 1)
	if (tooltip.indexOf("@glyph_property3") > -1){
		tooltip = tooltip.replace("@glyph_property3", "<font color='#CCFF66'>"+value3+"</font>");
	}
	var value4 = Abilities.GetLevelSpecialValueFor( item, "property_four", 1)
	if (tooltip.indexOf("@glyph_property4") > -1){
		tooltip = tooltip.replace("@glyph_property4", "<font color='#CCFF66'>"+value4+"</font>");
	}
	var value5 = Abilities.GetLevelSpecialValueFor( item, "property_five", 1)
	if (tooltip.indexOf("@glyph_property5") > -1){
		tooltip = tooltip.replace("@glyph_property5", "<font color='#CCFF66'>"+value5+"</font>");
	}
	var value6 = Abilities.GetLevelSpecialValueFor( item, "property_six", 1)
	if (tooltip.indexOf("@glyph_property6") > -1){
		tooltip = tooltip.replace("@glyph_property6", "<font color='#CCFF66'>"+value6+"</font>");
	}
	var value7 = Abilities.GetLevelSpecialValueFor( item, "property_seven", 1)
	if (tooltip.indexOf("@glyph_property7") > -1){
		tooltip = tooltip.replace("@glyph_property7", "<font color='#CCFF66'>"+value7+"</font>");
	}
	return tooltip
}

function SpecialDescriptionValues(specialText, item)
{
	if (specialText.indexOf("@special_property1") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_one" )
		$.Msg("$$$VALUE: "+value)
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property1", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property2") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_two" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property2", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property3") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_three" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property3", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property4") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_four" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property4", "<font color='#CCFF66'>"+value+"</font>");
	}
	if (specialText.indexOf("@special_property5") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_five" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property5", "<font color='#CCFF66'>"+value+"</font>");
	}
	return specialText
}

function AddDamageTypeAndElementToItem(item)
{
	$.Msg("ELEMENT TIME!")
	var ability = item
	var damageType = Abilities.GetAbilityDamageType( ability )
	var tooltip = ""
	var element1 = Abilities.GetLevelSpecialValueFor( ability, "element_one", 1)
	var element2 = Abilities.GetLevelSpecialValueFor( ability, "element_two", 1)
	$.Msg(damageType)
		// 
	var shouldShow = false
	var tooltipTypeLeft = ""
	var tooltipTypeRight = ""
	var tooltipElementLeft = ""
	var tooltipElementRight = ""
	if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_MAGICAL){
		tooltipTypeLeft = "<font color='#777777'>"+$.Localize("#tooltip_damage_type")+":</font>"
		tooltipTypeRight = "<font color='#7083FF'>"+$.Localize("#DOTA_ToolTip_Damage_Magical")+"</font>"
		shouldShow = true
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL){
		tooltipTypeLeft = "<font color='#777777'>"+$.Localize("#tooltip_damage_type")+":</font>"
		tooltipTypeRight = "<font color='#7083FF'>"+$.Localize("#DOTA_ToolTip_Damage_Physical")+"</font>"
		shouldShow = true
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PURE){
		tooltipTypeLeft = "<font color='#777777'>"+$.Localize("#tooltip_damage_type")+":</font>"
		tooltipTypeRight = "<font color='#7083FF'>"+$.Localize("#DOTA_ToolTip_Damage_Pure")+"</font>"
		shouldShow = true
	}

	if (element1 > 0){
		tooltipElementLeft = "<font color='#777777'>"+$.Localize('#tooltip_element').toUpperCase()+":</font>"
		element_main_text = $.Localize('#rpc_element'+element1)
		var elementColor = GetElementColor(element1)
		if (element2 > 0){
			var element_main_text2 = $.Localize('#rpc_element'+element2)
			var elementColor2 = GetElementColor(element2)
			tooltipElementRight = "<font color='"+elementColor+"'>"+element_main_text+"</font> / <font color='"+elementColor2+"'>"+element_main_text2+"</font>"
		}else{
			tooltipElementRight = "<font color='"+elementColor+"'>"+element_main_text+"</font>"
		}
		shouldShow = true
	}	
	return [[tooltipTypeLeft, tooltipTypeRight], [tooltipElementLeft, tooltipElementRight], shouldShow]
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


GameEvents.Subscribe( "new_item_equip", NewItemEquip);

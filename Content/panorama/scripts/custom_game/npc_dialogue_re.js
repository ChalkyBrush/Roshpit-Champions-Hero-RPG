function SuppliesDealer(msg){
    if (!(GameUI.CustomUIConfig().mainDialog == 1)){
        GameUI.CustomUIConfig().mainDialog = 1
        var parent = $('#npc_dialogue_container')
        var dialogue = $.CreatePanel("Panel", parent, "leaderboard")
        dialogue.BLoadLayoutSnippet("supplies_dealer");
        $('#npc_dialogue_container').AddClass('animateEaseClass')

        dialogue.FindChildTraverse('close_npc_dialogue').SetPanelEvent('onactivate', function CloseDialogue1() {
            CloseDialogue(0)
        });     

        var row = dialogue.FindChildTraverse('supplies_potion_row_1')
        
        for (i = 1; i <= 3; i++) { 
             var potionPanel = $.CreatePanel("Panel", row, "potionPanelr1"+i)
             potionPanel.BLoadLayoutSnippet("supplies_potion")
             potionPanel.FindChildTraverse('potion_image').SetImage("file://{images}/items/potions/damage_potion_"+i+".png")
             if (i <= 2){
                potionPanel.AddClass('potion_margin')
             }
             setPotionPriceText(potionPanel, i)
             potionPanelSetHover(potionPanel, i, 1)
        }    
        var row = dialogue.FindChildTraverse('supplies_potion_row_2')
        for (i = 1; i <= 3; i++) { 
             var potionPanel = $.CreatePanel("Panel", row, "potionPanelr2"+i)
             potionPanel.BLoadLayoutSnippet("supplies_potion")
             var potionIndex = i
             if (potionIndex == 1){
                potionIndex = 2
             }
             potionPanel.FindChildTraverse('potion_image').SetImage("file://{images}/items/potions/ability_potion_"+potionIndex+".png")
             if (i <= 2){
                potionPanel.AddClass('potion_margin')
             }
             setPotionPriceText(potionPanel, i)
             potionPanelSetHover(potionPanel, i, 2)
        }    
        var row = dialogue.FindChildTraverse('supplies_potion_row_3')
        for (i = 1; i <= 3; i++) { 
             var potionPanel = $.CreatePanel("Panel", row, "potionPanelr3"+i)
             potionPanel.BLoadLayoutSnippet("supplies_potion")
             potionPanel.FindChildTraverse('potion_image').SetImage("file://{images}/items/potions/vitality_potion_"+i+".png")
             if (i <= 2){
                potionPanel.AddClass('potion_margin')
             }
             setPotionPriceText(potionPanel, i)
             potionPanelSetHover(potionPanel, i, 3)
        }    

        $.Msg("Open supplies dealear")
    }
}

function setPotionPriceText(potionPanel, i){
    priceLabel = potionPanel.FindChildTraverse('item_price_text')
    if (i == 1){
        priceLabel.text="10,000"
    }else if(i == 2){
        priceLabel.text="20,000"
    }else if(i == 3){
        priceLabel.text="30,000"
    }
}

function potionPanelSetHover(potionPanel, i, row){
    var itemPanel = potionPanel.FindChildTraverse('supplies_potion_button')
    var basePotion = ""
    if (row == 1){
        basePotion = "item_rpc_damage_potion_"
    }else if (row == 2){
        basePotion = "item_rpc_ability_potion_"
    }else if (row == 3){
        basePotion = "item_rpc_vitality_potion_"
    }
    var itemName = basePotion+i
    itemPanel.SetPanelEvent('onmouseover', function ShowToolTip()
    {
        $.DispatchEvent( "DOTAShowAbilityTooltip", itemPanel, itemName);

    })

    itemPanel.SetPanelEvent('onmouseout', function HideToolTip()
    {
        $.DispatchEvent( "DOTAHideAbilityTooltip", itemPanel );
    })

    itemPanel.SetPanelEvent('onactivate', function BuyPotion()
    {
        var playerID = Game.GetLocalPlayerID()
        var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
        GameEvents.SendCustomGameEventToServer( "npc_dialogue", {type:"supplies_dealer", item: itemName, tier: i, heroIndex: heroIndex, playerID: playerID} );
    })
}

function CloseDialogue(msg){
    GameUI.CustomUIConfig().mainDialog = 0
    $('#npc_dialogue_container').AddClass('animateEaseOutClass')
    $.Schedule(0.45, function(){
        $('#npc_dialogue_container').RemoveClass('animateEaseClass')
        $('#npc_dialogue_container').RemoveClass('animateEaseOutClass')
        $('#npc_dialogue_container').RemoveAndDeleteChildren(0);
    });    
}

function GetItemDataForCurator(msg)
{
    $.Msg("GetItemDataForCurator start")
	var item = msg.itemIndex
    var language = $.Language()
    var itemName = Abilities.GetAbilityName( item );
    var localizedName = $.Localize("DOTA_Tooltip_Ability_"+itemName)
    var itemTexture = Abilities.GetAbilityTextureName( item )
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() );

	//Property1
	if (!(itemValues===undefined || itemValues.property1tooltip === undefined)){
		$.Msg("GetItemDataForCurator Property1")
		var tooltip = itemValues.property1tooltip == "rune" ? itemValues.property1name : itemValues.property1tooltip
		var property1special = SpecialDescriptionValues($.Localize(itemValues.property1special), item)
		var property1localized = $.Localize(tooltip)
		if (tooltip.indexOf("rune_") > 0){
			property1localized = $.Localize(tooltip.substr(tooltip.length - 8))
		}
		var property1data = [itemValues.property1color, tooltip, property1localized, itemValues.property1special, property1special, itemValues.property1]
		$.Msg(property1data)
	}

	//Property2
	if (!(itemValues===undefined || itemValues.property2tooltip === undefined)){
		$.Msg("GetItemDataForCurator Property2")
		var tooltip = itemValues.property2tooltip == "rune" ? itemValues.property2name : itemValues.property2tooltip
		var property2special = SpecialDescriptionValues($.Localize(itemValues.property2special), item)
		var property2localized = $.Localize(tooltip)
		if (tooltip.indexOf("rune_") > 0){
			property2localized = $.Localize(tooltip.substr(tooltip.length - 8))
		}
		var property2data = [itemValues.property2color, tooltip, property2localized, itemValues.property2special, property2special, itemValues.property2]
		$.Msg(property2data)
	}

	//Property3
	if (!(itemValues===undefined || itemValues.property3tooltip === undefined)){
		$.Msg("GetItemDataForCurator Property3")
		var tooltip = itemValues.property3tooltip == "rune" ? itemValues.property3name : itemValues.property3tooltip
		var property3special = SpecialDescriptionValues($.Localize(itemValues.property3special), item)
		var property3localized = $.Localize(tooltip)
		if (tooltip.indexOf("rune_") > 0){
			property3localized = $.Localize(tooltip.substr(tooltip.length - 8))
		}
		var property3data = [itemValues.property3color, tooltip, property3localized, itemValues.property3special, property3special, itemValues.property3]
		$.Msg(property3data)
	}

	//Property4
	if (!(itemValues===undefined || itemValues.property4tooltip === undefined)){
		$.Msg("GetItemDataForCurator Property4")
		var tooltip = itemValues.property4tooltip == "rune" ? itemValues.property4name : itemValues.property4tooltip
		var property4special = SpecialDescriptionValues($.Localize(itemValues.property4special), item)
		var property4localized = $.Localize(tooltip)
		if (tooltip.indexOf("rune_") > 0){
			property4localized = $.Localize(tooltip.substr(tooltip.length - 8))
		}
		var property4data = [itemValues.property4color, tooltip, property4localized, itemValues.property4special, property4special, itemValues.property4]
		$.Msg(property4data)
	}
	
    Game.EmitSound("RPC.Curate")
    BigChanges()
    GameEvents.SendCustomGameEventToServer( "curator_client", {item: item, language: language, localizedName: localizedName, itemTexture: itemTexture, property1: property1data, property2: property2data, property3: property3data, property4: property4data, playerID: Game.GetLocalPlayerID()} );

}

function BigChanges(){
    $.Msg("BIG CHANGE")
}



function SpecialDescriptionValues(specialText, item)
{
    if (specialText.indexOf("@special_property1") > -1){
        var value = Abilities.GetSpecialValueFor( item, "property_one" )
        value = round(value, 1)
        specialText = specialText.replace("@special_property1", value);
    }   
    if (specialText.indexOf("@special_property2") > -1){
        var value = Abilities.GetSpecialValueFor( item, "property_two" )
        value = round(value, 1)
        specialText = specialText.replace("@special_property2", value);
    }   
    if (specialText.indexOf("@special_property3") > -1){
        var value = Abilities.GetSpecialValueFor( item, "property_three" )
        value = round(value, 1)
        specialText = specialText.replace("@special_property3", value);
    }   
    if (specialText.indexOf("@special_property4") > -1){
        var value = Abilities.GetSpecialValueFor( item, "property_four" )
        value = round(value, 1)
        specialText = specialText.replace("@special_property4", value);
    }
    return specialText
}

function round(value, decimals) {
  return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
}

function OpenCurator(msg)
{
    $.Msg("OPEN CURATOR1")
    $.Msg(GameUI.curatorOpen)
    if (GameUI.curatorOpen){
    }else{
        GameUI.curatorOpen = true
        var parent = $('#npc_dialogue_big')
        parent.RemoveAndDeleteChildren();
        $.Msg("OPEN CURATOR")
        var listItem = $.CreatePanel("Panel", parent, "curator")
        listItem.BLoadLayoutSnippet("curator");
    }
}

function CloseCurator(msg)
{
    var parent = $('#npc_dialogue_big')
    parent.RemoveAndDeleteChildren();  
    GameUI.curatorOpen = false  
}

function CurateItemActivate(){
    var parent = $('#item-display-content')
    parent.RemoveAndDeleteChildren()
    var panel= $.CreatePanel("Panel", parent, "curator_curate")
    panel.BLoadLayoutSnippet("curate_pre_screen");

    var item_image = panel.FindChildTraverse('item_image')
    $.RegisterEventHandler( 'DragEnter', item_image, OnDragEnter );
    $.RegisterEventHandler( 'DragDrop', item_image, OnDragDrop );
    $.RegisterEventHandler( 'DragLeave', item_image, OnDragLeave );
}

function OnDragEnter( a, draggedPanel )
{
    var draggedItem = draggedPanel.m_DragItem;

    // only care about dragged items other than us
    if ( draggedItem === null || (!(draggedPanel.fromInventory)) )
        return true;

    var itemValues = CustomNetTables.GetTableValue( "item_basics", draggedItem.toString() )
    var rarity = itemValues.rarityFactor
    $.Msg(rarity)
    if (!(rarity >= 5)){
        return true
    }
    // highlight this panel as a drop target
    $('#item_image').AddClass( "item_highlight" );
    Game.EmitSound("Item.DropRecipeWorld")
    return true;
}

function OnDragDrop( panelId, draggedPanel )
{
    var draggedItem = draggedPanel.m_DragItem;
    draggedPanel.lockOrder = true
    // only care about dragged items other than us
    if ( draggedItem === null )
        return true;
    draggedPanel.m_DragCompleted = true
    var itemValues = CustomNetTables.GetTableValue( "item_basics", draggedItem.toString() )
    var rarity = itemValues.rarityFactor
    if (draggedPanel.fromInventory && rarity >= 5){
        $.Msg("DROP ITEM")
            var playerID = Game.GetLocalPlayerID()
            var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
            GameEvents.SendCustomGameEventToServer( "stop_unit", {unitIndex: heroIndex} );
            Game.EmitSound("ui.crafting_pulse")
            populateCurateItem(draggedItem)
            // LoadItemForReroll(draggedItem)
    }
    return true

}

function OnDragLeave( panelId, draggedPanel )
{
    var draggedItem = draggedPanel.m_DragItem;
    if ( draggedItem === null )
        return false;

    $('#item_image').RemoveClass( "item_highlight" );
    return true;
}

function populateCurateItem(item)
{
    $.Msg("populateCurateItem start +++++++++++++++++++")
	$.Msg(item)
    $.Msg("populateCurateItem start +++++++++++++++++++")
	$.GetContextPanel().FindChildTraverse('item_placement_tip').text = $.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( item ));
    $.GetContextPanel().FindChildTraverse('item_image').contextEntityIndex = item;
    $.GetContextPanel().curateItem = item
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() );
	
    var parent = $.GetContextPanel().FindChildTraverse('item_property1')
    parent.RemoveAndDeleteChildren()
    var attributeItem = $.CreatePanel("Panel", parent, "attribute1")
    attributeItem.BLoadLayoutSnippet("curator_item_row");   
	if (!(itemValues===undefined)){
		var tooltip = itemValues.property1tooltip == "rune" ? itemValues.property1name : itemValues.property1tooltip
		attributeItem.FindChildTraverse('property_name').text = "<font color='"+itemValues.property1color+"'>"+$.Localize(tooltip)+"</font>"
		attributeItem.FindChildTraverse('property_value').text = "<font color='"+itemValues.property1color+"'>"+itemValues.property1+"</font>"
	}

    var parent = $.GetContextPanel().FindChildTraverse('item_property2')
    parent.RemoveAndDeleteChildren()
    var attributeItem = $.CreatePanel("Panel", parent, "attribute2")
    attributeItem.BLoadLayoutSnippet("curator_item_row");   
	if (!(itemValues===undefined)){
		var tooltip = itemValues.property2tooltip == "rune" ? itemValues.property2name : itemValues.property2tooltip
		attributeItem.FindChildTraverse('property_name').text = "<font color='"+itemValues.property2color+"'>"+$.Localize(tooltip)+"</font>"
		attributeItem.FindChildTraverse('property_value').text = "<font color='"+itemValues.property2color+"'>"+itemValues.property2+"</font>"
	}

    var parent = $.GetContextPanel().FindChildTraverse('item_property3')
    parent.RemoveAndDeleteChildren()
    var attributeItem = $.CreatePanel("Panel", parent, "attribute3")
    attributeItem.BLoadLayoutSnippet("curator_item_row");   
	if (!(itemValues===undefined)){
		var tooltip = itemValues.property3tooltip == "rune" ? itemValues.property3name : itemValues.property3tooltip
		attributeItem.FindChildTraverse('property_name').text = "<font color='"+itemValues.property3color+"'>"+$.Localize(tooltip)+"</font>"
		attributeItem.FindChildTraverse('property_value').text = "<font color='"+itemValues.property3color+"'>"+itemValues.property3+"</font>"
	}

    var parent = $.GetContextPanel().FindChildTraverse('item_property4')
    parent.RemoveAndDeleteChildren()
    var attributeItem = $.CreatePanel("Panel", parent, "attribute4")
    attributeItem.BLoadLayoutSnippet("curator_item_row");   
	if (!(itemValues===undefined)){
		var tooltip = itemValues.property4tooltip == "rune" ? itemValues.property4name : itemValues.property4tooltip
		attributeItem.FindChildTraverse('property_name').text = "<font color='"+itemValues.property4color+"'>"+$.Localize(tooltip)+"</font>"
		attributeItem.FindChildTraverse('property_value').text = "<font color='"+itemValues.property4color+"'>"+itemValues.property4+"</font>"
	}

    $.GetContextPanel().FindChildTraverse('final_curate_button_container').RemoveClass('invisible')
    
}



function FinalCurateActivate()
{
  var item = $.GetContextPanel().curateItem
  $.Msg("CURATE!!")
  GameEvents.SendCustomGameEventToServer( "curate", {item: item, playerID: Game.GetLocalPlayerID()} );
  CloseCurator(0)
}

function GetHeroDataForCurator(msg)
{
    var hero = msg.heroIndex
    var heroName = Entities.GetUnitName( hero );
    var localizedName = $.Localize(heroName)
    var language = $.Language()
    $.Msg(localizedName)
    GameEvents.SendCustomGameEventToServer( "curateHero", {hero: hero, localizedName: localizedName, playerID: Game.GetLocalPlayerID(), language: language} );
}

function GetAbilityDataForCurator(msg)
{
    var hero = msg.heroIndex
    var heroName = Entities.GetUnitName( hero );
    var language = $.Language()
    $.Msg("AbilityCurateJS")
    $.Msg(msg.abilitySpecial)
    var abilitySpecialData = msg.abilitySpecial

    var ability = msg.abilityIndex
    $.Msg(ability)
    var abilityName = Abilities.GetAbilityName( ability )
    var abilityTexture = Abilities.GetAbilityTextureName( ability )
    var abilityNameLocalized = $.Localize('DOTA_Tooltip_Ability_'+abilityName)
    var abilityDescription = $.Localize('DOTA_Tooltip_Ability_'+abilityName+"_Description")

    Object.keys(abilitySpecialData).forEach(function (key) { 
        var value = abilitySpecialData[key]
        Object.keys(value).forEach(function (key2) { 
            var value2 = value[key2]
            if (value2 === undefined){
            }else{
                if (value2 == "FIELD_INTEGER" || value2 == "FIELD_FLOAT"){

                }else{
                    // $.Msg(value2+"______"+key2)
                    if (typeof value2 == "string"){
                        var localizedKey = $.Localize('DOTA_Tooltip_Ability_'+abilityName+"_"+key2)
                        if (localizedKey.indexOf("DOTA_Tooltip_Ability") == -1){
                            var replacedValues = value2.split(' ').join(' / ');    
                            abilityDescription = abilityDescription+"<br>"+localizedKey+" "+replacedValues
                        }
                    }
                    // $.Msg(abilityDescription)
                }
            }
        })
    })
    var abilityTargetType = Abilities.GetAbilityTargetType( ability )
    $.Msg(abilityDescription)
  
    var runeData1 = GetRuneData(msg.rune1)
    var runeData2 = GetRuneData(msg.rune2)
    var runeData3 = GetRuneData(msg.rune3)
    var runeData4 = GetRuneData(msg.rune4)
    GameEvents.SendCustomGameEventToServer( "curateAbility", {hero: hero, playerID: Game.GetLocalPlayerID(), language: language, ability:ability, abilityNameLocalized: abilityNameLocalized,
        abilityDescription: abilityDescription, abilityTargetType: abilityTargetType, abilityDamageType: Abilities.GetAbilityDamageType( ability ), abilityTexture: abilityTexture, runeData1: runeData1,
        runeData2: runeData2, runeData3: runeData3, runeData4: runeData4, abilityIndex: msg.abilitySlotIndex, arcanaIndex: msg.arcanaIndex, item_reference: msg.item_reference} );
}

function GetRuneData(runeIndex)
{
    var ability = runeIndex
    var abilityName = Abilities.GetAbilityName( ability )
    var abilityTexture = Abilities.GetAbilityTextureName( ability )
    var abilityNameLocalized = $.Localize('DOTA_Tooltip_Ability_'+abilityName)
    var abilityDescription = $.Localize('DOTA_Tooltip_Ability_'+abilityName+"_Description")
    var baseAbility = Abilities.GetLevelSpecialValueFor( ability, "base_ability", 1 )
    var damageType = Abilities.GetAbilityDamageType( ability )
    var property1 = Abilities.GetLevelSpecialValueFor( ability, "property_one", 1 )
    var property2 = Abilities.GetLevelSpecialValueFor( ability, "property_two", 1 )
    var element1 = Abilities.GetLevelSpecialValueFor( ability, "element_one", 1 )
    var element2 = Abilities.GetLevelSpecialValueFor( ability, "element_two", 1 )
    var property1max = Abilities.GetLevelSpecialValueFor( ability, "property_one_max", 1 )
    var property2max = Abilities.GetLevelSpecialValueFor( ability, "property_two_max", 1 )
    var property1base = Abilities.GetLevelSpecialValueFor( ability, "property_one_base", 1 )
    var property2base = Abilities.GetLevelSpecialValueFor( ability, "property_two_base", 1 )

    var prefix1 = $.Localize('DOTA_Tooltip_Ability_'+abilityName+"_property_one")
    var suffix1 = $.Localize('DOTA_Tooltip_Ability_'+abilityName+"_suffix")
    var prefix2 = $.Localize('DOTA_Tooltip_Ability_'+abilityName+"_property_two")
    var suffix2 = $.Localize('DOTA_Tooltip_Ability_'+abilityName+"_suffix_two")
    return [ability, abilityName, abilityTexture, abilityNameLocalized, abilityDescription, baseAbility, damageType, property1, property2, element1, element2, property1max, property2max, property1base, property2base, prefix1, prefix2, suffix1, suffix2]
}

function GetGlyphDataForCurator(msg)
{
    // var hero = msg.heroIndex
    // var heroName = Entities.GetUnitName( hero );
    var localizedName = $.Localize('DOTA_Tooltip_Ability_'+msg.glyphName)
    var localizedDescription  = $.Localize(msg.glyphDescription)
    localizedDescription =  updateGlyphInTooltip(localizedDescription, msg.glyphIndex)
    var language = $.Language()
    $.Msg(localizedName)
    var itemTexture = Abilities.GetAbilityTextureName( msg.glyphIndex)
    GameEvents.SendCustomGameEventToServer( "curateGlyph", {glyphIndex: msg.glyphIndex, localizedName: localizedName, localizedDescription: localizedDescription, language: language, playerID: Game.GetLocalPlayerID(), glyphTexture: itemTexture} );
}

function updateGlyphInTooltip(tooltip, item)
{
    var value = Abilities.GetLevelSpecialValueFor( item, "property_one", 1)
    value = round(value, 1)
    if (tooltip.indexOf("@glyph_property1") > -1){
        tooltip = tooltip.replace("@glyph_property1", "<font color='#CCFF66'>"+value+"</font>");
    }
    var value2 = Abilities.GetLevelSpecialValueFor( item, "property_two", 1)
    value = round(value2, 1)
    if (tooltip.indexOf("@glyph_property2") > -1){
        tooltip = tooltip.replace("@glyph_property2", "<font color='#CCFF66'>"+value2+"</font>");
    }
    var value3 = Abilities.GetLevelSpecialValueFor( item, "property_three", 1)
    value3 = round(value3, 1)
    if (tooltip.indexOf("@glyph_property3") > -1){
        tooltip = tooltip.replace("@glyph_property3", "<font color='#CCFF66'>"+value3+"</font>");
    }
    return tooltip
}

(function()
{
    GameUI.curatorOpen = false  
	GameEvents.Subscribe( "supplies_dealer", SuppliesDealer );
    GameEvents.Subscribe( "close_npc_dialogue", CloseDialogue);
    GameEvents.Subscribe( "get_item_data_for_curator", GetItemDataForCurator)
    GameEvents.Subscribe( "open_curator", OpenCurator)
    GameEvents.Subscribe( "get_hero_curator", GetHeroDataForCurator)
    GameEvents.Subscribe( "get_ability_curator", GetAbilityDataForCurator)
    GameEvents.Subscribe( "get_glyph_curator", GetGlyphDataForCurator)
    // GameEvents.Subscribe( "get_ability_data_for_curator", GetAbilityDataForCurator)
    // GameEvents.Subscribe( "get_rune_data_for_curator", GetRuneDataForCurator)
    // GameEvents.Subscribe( "get_glyph_data_for_curator", GetGlyphDataForCurator)
    // $.RegisterEventHandler( 'DragEnter', $('#item_image'), OnDragEnter );
    // $.RegisterEventHandler( 'DragDrop', $('#item_image'), OnDragDrop );
    // $.RegisterEventHandler( 'DragLeave', $('#item_image'), OnDragLeave );
})();

// Curator:GetItemInfoFromClientAndSendToWeb(item, caster:GetPlayerOwnerID())
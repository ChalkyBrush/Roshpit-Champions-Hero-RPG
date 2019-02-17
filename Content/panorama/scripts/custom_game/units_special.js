onibi_panel = null
onibi_elements = []
open_ability_panel = false

function get_onibi_active_elements(onibi_data){
	var elements = []
	elements.push("nature")
	$.Msg("ELEMENTS kkkkk")
	$.Msg(onibi_data)
	$.Msg(onibi_data["arcanas"])
	if (!(onibi_data["arcanas"]===undefined) && (onibi_data["arcanas"]["fire"] == 1)){
		elements.push("fire")
	}else{
		elements.push("lightning")
	}
	elements.push("cosmic")
	return elements
}

function get_onibi_other_elements(element, onibi_data){
	var elements = get_onibi_active_elements(onibi_data)
	var other_elements = []
	for (var i = 0; i <= 2; i++) {
		if (elements[i] == element){

		}else{
			other_elements.push(elements[i])
		}
	}
	return other_elements
}

function units_special_check(msg){
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var playerIndex = Players.GetLocalPlayer();
	var unitName = Entities.GetUnitName( queryUnit )
	var unit_container = $.GetContextPanel().FindChildTraverse('units_special_attach_point')
	if (msg.reset){
		unit_container.RemoveClass("active")
		unit_container.RemoveAndDeleteChildren(0)
	}
	if (unitName ==	"jex_onibi"){
		if (!(unit_container.BHasClass("active" ))){
			unit_container.RemoveClass("invisible")
			unit_container.AddClass("active")
			var unit_special_panel = $.CreatePanel("Panel", unit_container, "unit_special")
			open_ability_panel = false
			unit_special_panel.BLoadLayoutSnippet("onibi_ability_bar")
			// unit_special_panel.FindChildTraverse('something')
			var ability_bar_attach_panel = unit_special_panel
			var onibi_data = CustomNetTables.GetTableValue( "hero_index", "onibi-"+queryUnit.toString() );
			var elements = get_onibi_active_elements(onibi_data)
			
			onibi_panel = ability_bar_attach_panel
			onibi_elements = []
			$.Msg(onibi_data)
			for (var i = 0; i <= 2; i++) {
				var onibi_element = $.CreatePanel("Panel", ability_bar_attach_panel, "onibi_"+elements[i])
				onibi_elements.push(onibi_element)
				onibi_element.BLoadLayoutSnippet("onibi_element_summary")
				var elementNumber = convertElementNameToNumber(elements[i])
				onibi_element.FindChildTraverse('onibi_element_icon').SetImage("file://{images}/custom_game/ui/elements/element"+elementNumber+".png")
				onibi_element.FindChildTraverse('onibi_element_title').text = $.Localize('rpc_element'+elementNumber)
				var color = get_element_color_by_index(elementNumber)
				onibi_element.FindChildTraverse('onibi_element_title').style.color = color
				var element_data = onibi_data[elements[i]]
				onibi_element.FindChildTraverse('onibi_element_level').text = $.Localize("weapon_current_level") + ": "+element_data["level"]
				if (element_data["tech"] > 0){
					onibi_element.FindChildTraverse('onibi_element_points').text = $.Localize("tech_points") + ": "+element_data["tech"]
				}
				var percentage_exp = 0
				if (element_data["required"] > 0){
					percentage_exp = parseInt((element_data["current"]/element_data["required"])*100)
				}
				if (element_data["level"] >= 100){
					percentage_exp = 100
					onibi_element.FindChildTraverse('onibi_element_progress_text').text = $.Localize("weapon_max_level")
				}else{
					onibi_element.FindChildTraverse('onibi_element_progress_text').text = element_data["current"] + " / " + element_data["required"] 
				}
				onibi_element.FindChildTraverse('onibi_element_progress_inner').style.width = percentage_exp+"%"
				
				set_onibi_element_click(onibi_element.FindChildTraverse('onibi_element_status_bg'), unit_container, i, element_data, elements[i], queryUnit, onibi_data)
			}
		}
	}else{
		if (unit_container.BHasClass("active" ))
		{
			unit_container.RemoveClass("active")
			unit_container.RemoveAndDeleteChildren(0)
			unit_container.AddClass("invisible")
		}
	}
}

function set_onibi_element_click(event_panel, onibi_element, i, element_data, element, queryUnit, onibi_data){
	event_panel.SetPanelEvent('onactivate', function Open() {
		onibi_element_click(onibi_element, i, element_data, element, queryUnit, onibi_data)
	})
}

function onibi_element_click(element_panel, index, element_data, element, queryUnit, onibi_data)
{
	if (!(open_ability_panel == false)){
		$.Msg("DELETE")
		open_ability_panel.RemoveAndDeleteChildren()
		open_ability_panel.AddClass('invisible')
		if (open_ability_panel.slot_index == index){
			open_ability_panel = false
			return false
		}
	}
	Game.EmitSound("Jex.ElementClick")
	var marginLeft = -10 + 197*index
	var ability_element_panel = $.CreatePanel("Panel", element_panel, "onibi_ability_"+element)
	ability_element_panel.BLoadLayoutSnippet("onibi_element_abilities")
	ability_element_panel.AddClass("animate_in")
	open_ability_panel = ability_element_panel
	open_ability_panel.slot_index = index
	ability_element_panel.style.marginLeft = marginLeft+"px"
	var elementNumber = convertElementNameToNumber(element)
	ability_element_panel.FindChildTraverse('onibi_element_abilities_meta_header').text = $.Localize('rpc_element'+elementNumber)
	var color = get_element_color_by_index(elementNumber)
	ability_element_panel.FindChildTraverse('onibi_element_abilities_meta_header').style.color = color
	var abilities = ["Q", "W", "E"]
	var abilities_attach_panel = ability_element_panel.FindChildTraverse('onibi_element_abilities_parent_container')
	var elements = get_onibi_active_elements(onibi_data)
	var other_elements = get_onibi_other_elements(element, onibi_data)
	$.Msg(onibi_data)
	for (var i = 0; i <= 2; i++) {
		var ability_key = abilities[i]
		var ability_slot_panel = $.CreatePanel("Panel", abilities_attach_panel, "onibi_ability_"+abilities[i])
		ability_slot_panel.BLoadLayoutSnippet("onibi_abilities_by_slot")
		ability_slot_panel.FindChildTraverse('onibi_abilities_by_slot_header_label').text = abilities[i]
		for (var j = 0; j<= 2; j++){
			onibi_ability_panel = $.CreatePanel("Panel", abilities_attach_panel, "onibi_ability_"+abilities[i]+"-"+j)
			onibi_ability_panel.BLoadLayoutSnippet("onibi_element_ability")
			var secondaryElement = element
			if (j == 0){
			}else{
				secondaryElement = other_elements[j-1]
			}

			var ability_level = onibi_data[element][secondaryElement][ability_key]["level"]
			var bonus_level = onibi_data[element][secondaryElement][ability_key]["bonus_level"]
			var ability_level_text = ability_level 
			$.Msg(onibi_data)
			$.Msg(onibi_data[element][secondaryElement])
			$.Msg("BONUS LEVEL:"+bonus_level)
			if (bonus_level > 0){
				ability_level_text="<font color='#f4b942'>"+parseInt(parseInt(ability_level)+parseInt(bonus_level))+"</font>"
			}

			var secondaryElementNumber = convertElementNameToNumber(secondaryElement)
			onibi_ability_panel.FindChildTraverse('onibi_ability_element_icon1').SetImage("file://{images}/custom_game/ui/elements/element"+elementNumber+".png")
			onibi_ability_panel.FindChildTraverse('onibi_ability_element_icon2').SetImage("file://{images}/custom_game/ui/elements/element"+secondaryElementNumber+".png")
			onibi_ability_panel.FindChildTraverse('onibi_ability_name').text = $.Localize("DOTA_Tooltip_ability_"+onibi_data[element][secondaryElement][ability_key]["name"])
			onibi_ability_panel.FindChildTraverse('onibi_ability_level').text = "Lv. "+ability_level_text

			set_onibi_ability_hover_event(onibi_data[element][secondaryElement][ability_key]["name"], onibi_ability_panel)

			var tech_cost = calculate_ability_tech_cost(element, secondaryElement, ability_level)
			onibi_ability_panel.FindChildTraverse('onibi_ability_cost1_image').SetImage("file://{images}/custom_game/ui/elements/element"+elementNumber+".png")
			onibi_ability_panel.FindChildTraverse('onibi_ability_cost1_value').text = tech_cost
			// units_special (event)
			$.Msg("----")
			$.Msg(tech_cost)
			if (!(secondaryElement == element)){
				onibi_ability_panel.FindChildTraverse('onibi_ability_cost2_image').SetImage("file://{images}/custom_game/ui/elements/element"+secondaryElementNumber+".png")
				onibi_ability_panel.FindChildTraverse('onibi_ability_cost2_value').text = tech_cost
			}
			var can_upgrade = can_afford_upgrade(onibi_data, element, secondaryElement, ability_level)
			if ((Entities.GetPlayerOwnerID( queryUnit ) == Players.GetLocalPlayer()) && can_upgrade){
				set_onibi_upgrade_event(queryUnit, element, secondaryElement, ability_key)
			}else{
				onibi_ability_panel.FindChildTraverse('onibi_ability_upgrade_button').AddClass("invisible")
			}

		}
	}
}

function set_onibi_ability_hover_event(ability_name, onibi_ability_panel)
{
	onibi_ability_panel.FindChildTraverse('onibi_ability_name').SetPanelEvent('onmouseover', function UpgradeOnibi() {
		var panel = onibi_ability_panel.FindChildTraverse('onibi_ability_name')
		var title = "<font color='white'>"+$.Localize("DOTA_Tooltip_ability_"+ability_name)
		var tooltip = $.Localize("DOTA_Tooltip_ability_"+ability_name+"_description")
		$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
	})
	onibi_ability_panel.FindChildTraverse('onibi_ability_name').SetPanelEvent('onmouseout', function UpgradeOnibi() {
		var panel = onibi_ability_panel.FindChildTraverse('onibi_ability_name')
		$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
	})
	
}

function set_onibi_upgrade_event(queryUnit, element, secondaryElement, ability_key)
{
	onibi_ability_panel.FindChildTraverse('onibi_ability_upgrade_button').SetPanelEvent('onactivate', function UpgradeOnibi() {
		Game.EmitSound("Jex.UpgradeAbility")
		SendOnibiUpgradeToServer(queryUnit, element, secondaryElement, ability_key);
	})
}

function can_afford_upgrade(onibi_data, element1, element2, level)
{
	var cost = calculate_ability_tech_cost(element1, element2, level)
	if ((onibi_data[element1].tech >= cost) && (onibi_data[element2].tech >= cost))
	{
		return true
	}else{
		return false
	}
}

function get_tech_cost(ability_level)
{
	return ability_level + 1
}

function calculate_ability_tech_cost(element, secondaryElement, level){
	var bDoubleMult = 1
	if (secondaryElement == element){
		bDoubleMult = 2
	}
	var cost = get_tech_cost(level)
	cost = cost*bDoubleMult
	return cost
}

function SendOnibiUpgradeToServer(queryUnit, element1, element2, ability_key){
	GameEvents.SendCustomGameEventToServer( "units_special", {onibi: queryUnit, element1: element1, element2: element2, ability_key: ability_key} );
}

function update_onibi(msg){
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var unitName = Entities.GetUnitName( queryUnit )

	if (unitName ==	"jex_onibi"){
		var onibi_data = CustomNetTables.GetTableValue( "hero_index", "onibi-"+queryUnit.toString() );
		var elements = get_onibi_active_elements(onibi_data)
		for (var i = 0; i <= 2; i++) {
			var onibi_element = onibi_elements[i]
			var element_data = onibi_data[elements[i]]
			$.Msg(msg.bLevelUp)
			$.Msg("-----")
			if (parseInt(msg.bLevelUp) == 1){
				onibi_element.FindChildTraverse('onibi_element_level').text = $.Localize("ui_level_up")
				$.Schedule(2, function(){
					var msg2 = {}
					msg2.bLevelUp = 0
					update_onibi(msg2)
				});
			}else{
				onibi_element.FindChildTraverse('onibi_element_level').text = $.Localize("weapon_current_level") + ": "+element_data["level"]
			}
			if (element_data["tech"] > 0){
				onibi_element.FindChildTraverse('onibi_element_points').text = $.Localize("tech_points") + ": "+element_data["tech"]
			}else{
				onibi_element.FindChildTraverse('onibi_element_points').text = ""
			}
			var percentage_exp = 0
			if (element_data["required"] > 0){
				percentage_exp = parseInt((element_data["current"]/element_data["required"])*100)
			}
			if (element_data["level"] >= 100){
				percentage_exp = 100
				onibi_element.FindChildTraverse('onibi_element_progress_text').text = $.Localize("weapon_max_level")
			}else{
				onibi_element.FindChildTraverse('onibi_element_progress_text').text = element_data["current"] + " / " + element_data["required"] 
			}
			onibi_element.FindChildTraverse('onibi_element_progress_inner').style.width = percentage_exp+"%"
			
		}
	}
}



(function()
{
	GameEvents.Subscribe( "dota_player_update_selected_unit", units_special_check );
	GameEvents.Subscribe( "dota_player_update_query_unit", units_special_check );
	GameEvents.Subscribe( "reset_onibi", units_special_check)
	GameEvents.Subscribe( "update_onibi", update_onibi );
})();



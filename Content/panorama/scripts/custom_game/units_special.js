onibi_panel = null
onibi_elements = []
open_ability_panel = false

function get_onibi_active_elements(){
	var elements = ["nature", "lightning", "cosmic"]
	return elements
}

function get_onibi_other_elements(element){
	var elements = get_onibi_active_elements()
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
	if (unitName ==	"jex_onibi"){
		if (!(unit_container.BHasClass("active" ))){
			unit_container.RemoveClass("invisible")
			unit_container.AddClass("active")
			$.Msg("SELECTED ONIBI")
			var unit_special_panel = $.CreatePanel("Panel", unit_container, "unit_special")
			open_ability_panel = false
			unit_special_panel.BLoadLayoutSnippet("onibi_ability_bar")
			// unit_special_panel.FindChildTraverse('something')
			var ability_bar_attach_panel = unit_special_panel
			var elements = get_onibi_active_elements()
			var onibi_data = CustomNetTables.GetTableValue( "hero_index", "onibi-"+queryUnit.toString() );
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
				if (element_data["points"] > 0){
					onibi_element.FindChildTraverse('onibi_element_points').text = "Points Available" + ": "+element_data["points"]
				}
				var percentage_exp = 0
				if (element_data["required"] > 0){
					percentage_exp = parseInt((element_data["current"]/element_data["required"])*100)
				}
				onibi_element.FindChildTraverse('onibi_element_progress_inner').style.width = percentage_exp+"%"
				onibi_element.FindChildTraverse('onibi_element_progress_text').text = element_data["current"] + " / " + element_data["required"] 
				set_onibi_element_click(onibi_element.FindChildTraverse('onibi_element_status_bg'), unit_container, i, element_data, elements[i])

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

function set_onibi_element_click(event_panel, onibi_element, i, element_data, element){
	event_panel.SetPanelEvent('onactivate', function Open() {
		onibi_element_click(onibi_element, i, element_data, element)
	})
}

function onibi_element_click(element_panel, index, element_data, element)
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
	var elements = get_onibi_active_elements()
	var other_elements = get_onibi_other_elements(element)
	for (var i = 0; i <= 2; i++) {
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
			var secondaryElementNumber = convertElementNameToNumber(secondaryElement)
			onibi_ability_panel.FindChildTraverse('onibi_ability_element_icon1').SetImage("file://{images}/custom_game/ui/elements/element"+elementNumber+".png")
			onibi_ability_panel.FindChildTraverse('onibi_ability_element_icon2').SetImage("file://{images}/custom_game/ui/elements/element"+secondaryElementNumber+".png")
			onibi_ability_panel.FindChildTraverse('onibi_ability_name').text = "ABILITY NAME"
			onibi_ability_panel.FindChildTraverse('onibi_ability_level').text = "Lv. 0"

			onibi_ability_panel.FindChildTraverse('onibi_ability_cost1_image').SetImage("file://{images}/custom_game/ui/elements/element"+elementNumber+".png")
			onibi_ability_panel.FindChildTraverse('onibi_ability_cost1_value').text = "1"
			
			if (!(secondaryElement == element)){
				onibi_ability_panel.FindChildTraverse('onibi_ability_cost2_image').SetImage("file://{images}/custom_game/ui/elements/element"+secondaryElementNumber+".png")
				onibi_ability_panel.FindChildTraverse('onibi_ability_cost2_value').text = "1"
			}
		}
	}
}

function update_onibi(msg){
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var unitName = Entities.GetUnitName( queryUnit )
	if (unitName ==	"jex_onibi"){
		var onibi_data = CustomNetTables.GetTableValue( "hero_index", "onibi-"+queryUnit.toString() );
		var elements = get_onibi_active_elements()
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
			if (element_data["points"] > 0){
				onibi_element.FindChildTraverse('onibi_element_points').text = "Points Available" + ": "+element_data["points"]
			}
			var percentage_exp = 0
			if (element_data["required"] > 0){
				percentage_exp = parseInt((element_data["current"]/element_data["required"])*100)
			}
			onibi_element.FindChildTraverse('onibi_element_progress_inner').style.width = percentage_exp+"%"
			onibi_element.FindChildTraverse('onibi_element_progress_text').text = element_data["current"] + " / " + element_data["required"] 
		}
	}
}

(function()
{
	GameEvents.Subscribe( "dota_player_update_selected_unit", units_special_check );
	GameEvents.Subscribe( "dota_player_update_query_unit", units_special_check );
	GameEvents.Subscribe( "update_onibi", update_onibi );
})();


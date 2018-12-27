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
			unit_special_panel.BLoadLayoutSnippet("onibi_ability_bar")
			// unit_special_panel.FindChildTraverse('something')
			var ability_bar_attach_panel = unit_special_panel
			var elements = ["nature", "lightning", "cosmic"]
			var onibi_data = CustomNetTables.GetTableValue( "hero_index", "onibi-"+queryUnit.toString() );
			$.Msg(onibi_data)
			for (var i = 0; i <= 2; i++) {
				var onibi_element = $.CreatePanel("Panel", ability_bar_attach_panel, "onibi_"+elements[i])
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
(function()
{
	GameEvents.Subscribe( "dota_player_update_selected_unit", units_special_check );
	GameEvents.Subscribe( "dota_player_update_query_unit", units_special_check );
})();


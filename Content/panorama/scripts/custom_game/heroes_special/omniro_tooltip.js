function initialize_omniro_tooltip(){
	var element_data = GameUI.CustomUIConfig.omniro_element_data
	var title_color = get_element_color_by_index(element_data["element_number"])
	var title = "<font color='"+title_color+"'>"+$.Localize('rpc_element'+element_data["element_number"])+"</font>"

	var element_name = convertElementNumberToName(element_data["element_number"])

	$('#omniro_element_tooltip_title').text = title

	$('#omniro_element_tooltip_level').text = $.Localize('weapon_current_level')+": "+element_data["level"]
	if (element_data["in_rotation"] == 1){
		$('#omniro_element_help').text = $.Localize('omniro_element_help_disable')
	}else{
		$('#omniro_element_help').text = $.Localize('omniro_element_help_enable')
	}
	$('#omniro_omnimace_title').text = $.Localize('omni_mace_effect')
	$('#omniro_omnimace_effect_description').text = $.Localize("omniro_"+element_name+"_special_description")

	var property1 = Abilities.GetSpecialValueFor( element_data["ability_index"], element_name+"_special_a" )
	property1 = Math.round(property1 * 100, 1) / 100
	if (!(property1 == 0)){
		$('#omniro_content_1').RemoveClass('invisible')
		var display_value = Math.round(property1*element_data["level"] * 100, 1) / 100
		$('#omniro_omnimace_special_property1').text = $.Localize('omniro_'+element_name+"_special_a_pretext")
		$('#omniro_omnimace_special_property1_value').text = "<font color='"+title_color+"'>"+display_value+"</font>"
	}else{
		$('#omniro_content_1').AddClass('invisible')
	}

	var property2 = Abilities.GetSpecialValueFor( element_data["ability_index"], element_name+"_special_b" )
	property2 = Math.round(property2 * 100, 1) / 100
	if (!(property2 == 0)){
		$('#omniro_content_2').RemoveClass('invisible')
		var display_value = Math.round(property2*element_data["level"] * 100, 1) / 100
		$('#omniro_omnimace_special_property2').text = $.Localize('omniro_'+element_name+"_special_b_pretext")
		$('#omniro_omnimace_special_property2_value').text = "<font color='"+title_color+"'>"+display_value+"</font>"
	}else{
		$('#omniro_content_2').AddClass('invisible')
	}

}
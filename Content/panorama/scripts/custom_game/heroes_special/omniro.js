
function UpdateOmniro(msg){
	var omniro = msg.omniro
	var omniro_data = msg.omniro_data
	var omniro_parent = $.GetContextPanel().FindChildTraverse("omniro_parent_attach_point")
	var parent = $.GetContextPanel().FindChildTraverse('heroes_special_attach_point')


	if (omniro_parent===null){

		omniro_parent_start = $.CreatePanel("Panel", parent, "omniro_parent")
		omniro_parent_start.BLoadLayoutSnippet("omniro_parent_layout")
		omniro_parent = omniro_parent_start.FindChildTraverse("omniro_parent_attach_point")
	}

    var arrayLength = 17
    var element_exist_count = 0
    var element_leveled_count = 0

    for (var i = 1; i <= arrayLength; i++) {
        var element_parent = omniro_parent.FindChildTraverse('omniro-element-'+i)
        if (!(element_parent === null)){
        	element_exist_count = element_exist_count + 1
        }
        if (omniro_data[i]["level"] > 0){
        	element_leveled_count = element_leveled_count + 1
        }

    }

    if (!(element_leveled_count == element_exist_count)){
    	reconstruct_omniro_element_ui(omniro_parent, omniro_data, msg.omniro)
    }
    if (msg.reconstruct){
    	reconstruct_omniro_element_ui(omniro_parent, omniro_data, msg.omniro)
    }
    update_omniro_element_ui_items(omniro_parent, omniro_data)
}

function reconstruct_omniro_element_ui(omniro_parent, omniro_data, omniro){
	omniro_parent.RemoveAndDeleteChildren(0)
    var arrayLength = 17
    for (var i = 1; i <= arrayLength; i++) {
    	if (omniro_data[i]["level"] > 0){
	    	var element_parent = $.CreatePanel("Panel", omniro_parent, "omniro-element-"+i)
	    	element_parent.BLoadLayoutSnippet('omniro_element')
	    	var elementNumber = omniro_data[i]["element_number"]
	    	element_parent.FindChildTraverse('omniro_element_image').SetImage("file://{images}/custom_game/ui/elements/element"+elementNumber+".png")
	    	setup_tooltip_mechanisms(element_parent, omniro_data[i], omniro)
	    }
    }
}

function setup_tooltip_mechanisms(element_parent, element_data, omniro){
	var tooltip_element = element_parent.FindChildTraverse('omniro_element_image')
	tooltip_element.SetPanelEvent('onmouseover', function Open() {
		hover_tooltip(tooltip_element, element_data)
	});
	tooltip_element.SetPanelEvent('onmouseout', function Open() {
		unhover_tooltip(tooltip_element)
	})
	tooltip_element.SetPanelEvent('onactivate', function Open() {
		omniro_element_click(element_data, omniro)
	})
}

function omniro_element_click(element_data, omniro){
	if (GameUI.IsAltDown()){
		GameEvents.SendCustomGameEventToServer( "units_special", {omniro: omniro, element_index: element_data["element_number"], alt: 1} )
	}else{
		GameEvents.SendCustomGameEventToServer( "units_special", {omniro: omniro, element_index: element_data["element_number"], alt: 0} );
	}
}

function hover_tooltip(element_parent, element_data){
	GameUI.CustomUIConfig.omniro_element_data = element_data
	$.DispatchEvent("UIShowCustomLayoutTooltip", element_parent, "omniro_tooltip", "file://{resources}/layout/custom_game/hero/omniro_element_tooltip.xml");
}

function unhover_tooltip(element_parent){
	$.DispatchEvent("UIHideCustomLayoutTooltip", "omniro_tooltip");
	// $.DispatchEvent( "DOTAHideTitleTextTooltip", element_parent );
}

function update_omniro_element_ui_items(omniro_parent, omniro_data)
{
    var arrayLength = 17
    for (var i = 1; i <= arrayLength; i++) {
    	var element_parent = omniro_parent.FindChildTraverse('omniro-element-'+i)
    	if (!(element_parent === null)){
    		update_omniro_element(element_parent, omniro_data[i])
    	}
    }
}

function update_omniro_element(element_parent, element_data){
	element_parent.FindChildTraverse('omniro_element_charge_counter').text = element_data["charges"]
	var charge_percentage = (element_data["charge_up_fraction"]*100)/element_data["charge_up_fraction_full"]
	if (element_data["charges"] == element_data["max_charges"]){
		charge_percentage = 100
	}
	if (element_data["charges"] == 0){
		element_parent.FindChildTraverse('omniro_element_charge_counter').AddClass('omniro_element_no_charges')
		element_parent.FindChildTraverse('omniro_charge_fill').AddClass('omniro_element_charge_fill_no_charges')
		element_parent.FindChildTraverse('omniro_element_charge_counter').RemoveClass('omniro_element_charges_exist')
		element_parent.FindChildTraverse('omniro_charge_fill').RemoveClass('omniro_charge_fill_charges_exist')
	}else{
		element_parent.FindChildTraverse('omniro_element_charge_counter').RemoveClass('omniro_element_no_charges')
		element_parent.FindChildTraverse('omniro_charge_fill').RemoveClass('omniro_element_charge_fill_no_charges')
		element_parent.FindChildTraverse('omniro_element_charge_counter').AddClass('omniro_element_charges_exist')
		element_parent.FindChildTraverse('omniro_charge_fill').AddClass('omniro_charge_fill_charges_exist')
	}
	element_parent.FindChildTraverse('omniro_charge_fill').style.width = charge_percentage+"%"
	var omniro_element_active_indicator = element_parent.FindChildTraverse('omniro_element_active_indicator')
	if (element_data["active"]){
		omniro_element_active_indicator.RemoveClass('invisible')
	}else{
		omniro_element_active_indicator.AddClass('invisible')
	}
	if (element_data["in_rotation"] == 1){
		element_parent.style.opacity = 1
		element_parent.FindChildTraverse('omniro_disabled_element_label').AddClass("invisible")
	}else{
		element_parent.style.opacity = 0.2
		element_parent.FindChildTraverse('omniro_disabled_element_label').RemoveClass("invisible")
	}
	if (element_data["locked"]){
		element_parent.FindChildTraverse('omniro_element_image').AddClass("omniro_element_locked")
	}else{
		element_parent.FindChildTraverse('omniro_element_image').RemoveClass("omniro_element_locked")
	}
}

(function()
{
	GameEvents.Subscribe( "update_omniro", UpdateOmniro );
})();


function UpdateOmniro(msg){
	var omniro = msg.omniro
	var omniro_data = msg.omniro_data
	var omniro_parent = $.GetContextPanel().FindChildTraverse("omniro_parent_attach_point")
	var parent = $.GetContextPanel().FindChildTraverse('heroes_special_attach_point')


	if (omniro_parent===null){

		omniro_parent_start = $.CreatePanel("Panel", parent, "omniro_parent")
		omniro_parent_start.BLoadLayoutSnippet("omniro_parent_layout")
		omniro_parent = omniro_parent_start.FindChildTraverse("omniro_parent_attach_point")
		console.log("CAN WE MAKE THIS?")
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
    	reconstruct_omniro_element_ui(omniro_parent, omniro_data)
    }
    update_omniro_element_ui_items(omniro_parent, omniro_data)
}

function reconstruct_omniro_element_ui(omniro_parent, omniro_data){
	omniro_parent.RemoveAndDeleteChildren(0)
    var arrayLength = 17
    for (var i = 1; i <= arrayLength; i++) {
    	if (omniro_data[i]["level"] > 0){
	    	var element_parent = $.CreatePanel("Panel", omniro_parent, "omniro-element-"+i)
	    	element_parent.BLoadLayoutSnippet('omniro_element')
	    	var elementNumber = omniro_data[i]["element_number"]
	    	element_parent.FindChildTraverse('omniro_element_image').SetImage("file://{images}/custom_game/ui/elements/element"+elementNumber+".png")
	    }
    }
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
	if (element_data["enabled"]){
		element_parent.style.opacity = 1
	}else{
		element_parent.style.opacity = 0.3
	}
}

(function()
{
	GameEvents.Subscribe( "update_omniro", UpdateOmniro );
})();

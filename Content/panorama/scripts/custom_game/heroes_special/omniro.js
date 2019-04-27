
function UpdateOmniro(msg){
	var omniro = msg.omniro
	var omniro_data = msg.omniro_data
	var omniro_parent = $.GetContextPanel().FindChildTraverse("omniro_parent")
	var parent = $.GetContextPanel().FindChildTraverse('units_special_attach_point')
	if (omniro_parent===undefined){
		omniro_parent = $.CreatePanel("Panel", parent, "omniro_parent")
		onibi_element.BLoadLayoutSnippet("omniro_parent_layout")
	}

    var arrayLength = omniro_data.length;
    var element_exist_count = 0
    var element_leveled_count = 0
    for (var i = 0; i < arrayLength; i++) {
        console.log(omniro_data[i]);
        var element_parent = omniro_parent.FindChildTraverse('omniro-element-'+i)
        if (!(element_parent === undefined)){
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
    var arrayLength = omniro_data.length;
    for (var i = 0; i < arrayLength; i++) {
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
    var arrayLength = omniro_data.length;
    for (var i = 0; i < arrayLength; i++) {
    	var element_parent = omniro_parent.FindChildTraverse('omniro-element-'+i)
    	if (!(element_parent === undefined)){
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
	element_parent.FindChildTraverse('omniro_element_charge_counter').style.width = charge_percentage+"%"
	var omniro_element_active_indicator = element_parent.FindChildTraverse('omniro_element_active_indicator')
	if (element_data["active"]){
		omniro_element_active_indicator.RemoveClass('invisible')
	}else{
		omniro_element_active_indicator.AddClass('invisible')
	}
	if (element_data["enabled"]){
		element_parent.style.opacity = 0.3
	}else{
		element_parent.style.opacity = 1
	}
}

(function()
{
	GameEvents.Subscribe( "update_omniro", UpdateOmniro );
})();

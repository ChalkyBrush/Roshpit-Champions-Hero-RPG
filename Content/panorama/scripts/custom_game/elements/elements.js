function convertElementNameToNumber(element_name)
{
	var element_number = 0
	if (element_name == "nature"){
		element_number = 16
	}else if(element_name == "cosmic"){
		element_number = 8
	}else if(element_name == "lightning"){
		element_number = 4
	}
	return element_number
}

function get_element_color_by_index(element_index){
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
	}
	return color
}
function convertElementNameToNumber(element_name)
{
	var element_number = 0
	if (element_name == "nature"){
		element_number = 16
	}else if(element_name == "cosmic"){
		element_number = 8
	}else if(element_name == "lightning"){
		element_number = 4
	}else if(element_name == "fire"){
		element_number = 2
	}
	return element_number
}

function convertElementNumberToName(element_number)
{
	var element_name = ""
	if (element_number == 1){
		element_name = "normal"
	}else if(element_number == 2){
		element_name = "fire"
	}else if(element_number == 3){
		element_name = "earth"
	}else if(element_number == 4){
		element_name = "lightning"
	}else if(element_number == 5){
		element_name = "poison"
	}else if(element_number == 6){
		element_name = "time"
	}else if(element_number == 7){
		element_name = "holy"
	}else if(element_number == 8){
		element_name = "cosmic"
	}else if(element_number == 9){
		element_name = "ice"
	}else if(element_number == 10){
		element_name = "arcane"
	}else if(element_number == 11){
		element_name = "shadow"
	}else if(element_number == 12){
		element_name = "wind"
	}else if(element_number == 13){
		element_name = "ghost"
	}else if(element_number == 14){
		element_name = "water"
	}else if(element_number == 15){
		element_name = "demon"
	}else if(element_number == 16){
		element_name = "nature"
	}else if(element_number == 17){
		element_name = "undead"
	}else if(element_number == 18){
		element_name = "dragon"
	}
	return element_name
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
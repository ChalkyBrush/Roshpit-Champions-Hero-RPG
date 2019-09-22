function manageSocketsEquipment(rootPanel, item, slot)
{
	if (rootPanel.gemsSnippet === undefined){
		rootPanel.gemsSnippet = $.CreatePanel("Panel", rootPanel, "gems"+slot)
		rootPanel.gemsSnippet.BLoadLayoutSnippet("gem_snippet")
	}
	if (item > -1){
		var playerID = Players.GetLocalPlayer();
		var item_table = CustomNetTables.GetTableValue( "item_basics", item.toString() );
		if (!(item_table === undefined)){
			if (!(item_table.socket1===undefined) && !(item_table.socket1=="none")){
				rootPanel.gemsSnippet.RemoveClass('invisible')
				var gem1image = "file://{images}/items/gems/"+item_table.socket1+item_table.socket1value+".png"
				rootPanel.gemsSnippet.FindChildTraverse('placed-gem1').SetImage(gem1image)
				if (!(item_table.socket2 === undefined) && !(item_table.socket2=="none")){
					rootPanel.gemsSnippet.FindChildTraverse('gems-small-socket2').RemoveClass('invisible')
					var gem2image = "file://{images}/items/gems/"+item_table.socket2+item_table.socket2value+".png"
					rootPanel.gemsSnippet.FindChildTraverse('placed-gem2').SetImage(gem2image)
				}else{
					rootPanel.gemsSnippet.FindChildTraverse('gems-small-socket2').AddClass('invisible')
				}
			}else{
				rootPanel.gemsSnippet.AddClass('invisible')
			}
		}else{
			rootPanel.gemsSnippet.AddClass('invisible')
		}
	}else{
		rootPanel.gemsSnippet.AddClass('invisible')
	}
}

function manageSocketsWithRoot(rootPanel, item)
{
	var gems_root = rootPanel.FindChildTraverse('gems-small')
	if (item > -1){
		var playerID = Players.GetLocalPlayer();
		var item_table = CustomNetTables.GetTableValue( "item_basics", item.toString() );
		if (!(item_table === undefined)){
			if (!(item_table.socket1===undefined) && !(item_table.socket1=="none")){
				gems_root.RemoveClass('invisible')
				var gem1image = "file://{images}/items/gems/"+item_table.socket1+item_table.socket1value+".png"
				gems_root.FindChildTraverse('placed-gem1').SetImage(gem1image)
				if (!(item_table.socket2 === undefined) && !(item_table.socket2=="none")){
					gems_root.FindChildTraverse('gems-small-socket2').RemoveClass('invisible')
					var gem2image = "file://{images}/items/gems/"+item_table.socket2+item_table.socket2value+".png"
					gems_root.FindChildTraverse('placed-gem2').SetImage(gem2image)
				}else{
					gems_root.FindChildTraverse('gems-small-socket2').AddClass('invisible')
				}
			}else{
				gems_root.AddClass('invisible')
			}
		}else{
			gems_root.AddClass('invisible')
		}
	}else{
		gems_root.AddClass('invisible')
	}
}


function manageSockets(item)
{
	if (item > -1){
		var playerID = Players.GetLocalPlayer();
		var item_table = CustomNetTables.GetTableValue( "item_basics", item.toString() );
		if (!(item_table === undefined)){
			if (!(item_table.socket1===undefined) && !(item_table.socket1=="none")){
				$('#gems-small').RemoveClass('invisible')
				var gem1image = "file://{images}/items/gems/"+item_table.socket1+item_table.socket1value+".png"
				$('#placed-gem1').SetImage(gem1image)
				if (!(item_table.socket2 === undefined) && !(item_table.socket2=="none")){
					$('#gems-small-socket2').RemoveClass('invisible')
					var gem2image = "file://{images}/items/gems/"+item_table.socket2+item_table.socket2value+".png"
					$('#placed-gem2').SetImage(gem2image)
				}else{
					$('#gems-small-socket2').AddClass('invisible')
				}
			}else{
				$('#gems-small').AddClass('invisible')
			}
		}else{
			$('#gems-small').AddClass('invisible')
		}
	}else{
		$('#gems-small').AddClass('invisible')
	}
}

function substituteGemDescriptions(description, gem, gem_level, item){
	var item_name = Abilities.GetAbilityName(item)
	for (i = gem_level; i >= 1; i--) {
		var test_tooltip = $.Localize(item_name+"_"+gem+i)
		if (test_tooltip.indexOf(item_name) > -1){
		}else{
			description = $.Localize(item_name+"_"+gem+i)
			break
		}
	}
	var substitution_color = get_gem_color(gem)
	for (i = 1; i <= 5; i++) {
		var value_name = gem+i
		var value = Abilities.GetLevelSpecialValueFor( item, value_name, gem_level - 1 )
		description = description.replace("@"+gem+"_property"+i, "<font color='"+substitution_color+"'>"+value+"</font>")
	}
	return description
}

function get_gem_color(gem){
	var substitution_color = "#DDDDDD"
	if (gem == "ruby"){
		substitution_color = "#f02929"
	}else if(gem == "emerald"){
		substitution_color = "#36d63b"
	}else if (gem == "sapphire"){
		substitution_color = "#388af5"
	}else if (gem == "amethyst"){
		substitution_color = "#c744b8"
	}	
	return substitution_color
}
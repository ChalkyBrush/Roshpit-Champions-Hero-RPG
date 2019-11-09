gemforge_item = -1
mTooltipPanel = null

ITEM_MIN_LEVEL_PER_GEM = [0, 15, 30, 45, 60]

function OpenGemforger(msg){
	$.Msg("GEM FORGER")
	var parent = $('#gemforger_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	parent.RemoveAndDeleteChildren(0)
    var gemforger_main = $.CreatePanel("Panel", parent, "gemforger-main")
    gemforger_main.BLoadLayoutSnippet("gemforger_main");
    var header = gemforger_main.FindChildTraverse('gemforger_header')
    var imageName = "file://{images}/custom_game/ui/gem_forger_header.jpg"
    header.SetImage(imageName)
    GameUI.CustomUIConfig().gemforge = 0
    if (msg.gem_reward > 0){
	    var attach_point = gemforger_main.FindChildTraverse('gemforger_attach_contents')
	    var gemforger_reward_panel = $.CreatePanel("Panel", attach_point, "gemforger-reward")
	    gemforger_reward_panel.BLoadLayoutSnippet("gemforger_reward");

	    gemforger_reward_panel.FindChildTraverse("gemforger_reward_image").SetImage("file://{images}/custom_game/ui/prismatic_gemstone.png")
    	Game.EmitSound("Gemforger.UI.RewardAvailable")
    	gemforger_reward_panel.FindChildTraverse('reward_amount_label').text = "<b>"+msg.gem_reward + "</b> " + $.Localize('tooltip_prismatic_gemstones')
    	var collect_reward_button = gemforger_reward_panel.FindChildTraverse('gemforger_reward_collect')
    	collect_reward_button.SetPanelEvent('onactivate', function Close() {
			GameEvents.SendCustomGameEventToServer( "gems", {event_type: "collect_reward"});
			Game.EmitSound("Gemforger.UI.CollectReward")
			CloseGemforger();
		})
    }else{

    }

    var attach_point = gemforger_main.FindChildTraverse('gemforger_attach_contents')
    var forge_start_panel= $.CreatePanel("Panel", attach_point, "gemforger-start")
    forge_start_panel.BLoadLayoutSnippet("gemforger_start_button");
    forge_start_panel.FindChildTraverse("gemforger_start_image").SetImage("file://{images}/items/gems/ruby5.png")
    forge_start_button = forge_start_panel.FindChildTraverse('gemforger_start_button_collect')
	forge_start_button.SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("UI.Gemforger.Click")
		forge_gem_step_1(gemforger_main)
	})

    mCloseButton = gemforger_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	gemforger_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseGemforger();
	})

}

function forge_gem_step_1(gemforger_main){
	var attach_point = gemforger_main.FindChildTraverse('gemforger_attach_contents')
	attach_point.RemoveAndDeleteChildren(0)
    var gemforger_item_start = $.CreatePanel("Panel", attach_point, "gemforger-item-start")
    gemforger_item_start.BLoadLayoutSnippet("forge_gems_start");
    gemforger_item_start.FindChildTraverse('forge_gems_item_attacher').BLoadLayout( "file://{resources}/layout/custom_game/gems/gemforger_item_slot.xml", false, false );    

    var mainParent = GameUI.CustomUIConfig().equipmentContainer;
    var helmPanel = mainParent.FindChild("helm_main_container").FindChild("helm_container");
    var chestPanel = mainParent.FindChild("armor_main_container").FindChild("armor_container");
    var glovePanel = mainParent.FindChild("weapon_glove_main_container").FindChild("glove_container");
    var bootPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("boot_container");
    var amuletPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("amulet_container");
    var weaponPanel = mainParent.FindChild("weapon_glove_main_container").FindChild("weapon_container");

    GameUI.CustomUIConfig().socket = 0;
    GameUI.CustomUIConfig().chisel = 0;
    GameUI.CustomUIConfig().gemforge = 1

    helmPanel.AddClass("chiselable_gear");
    chestPanel.AddClass("chiselable_gear");
    glovePanel.AddClass("chiselable_gear");
    bootPanel.AddClass("chiselable_gear");
    amuletPanel.AddClass("chiselable_gear");
    weaponPanel.AddClass("chiselable_gear");

}

function ItemGemforgeMenu(msg){
	var item = msg.item_index
	clearGearHighlighter()
	Game.EmitSound("UI.Gemforger.Click")
	if (msg.success == 0){
		var parent = $('#gemforger_container')
		var attach_point = parent.FindChildTraverse('gemforger_attach_contents')
		attach_point.RemoveAndDeleteChildren(0)
	    var gemforger_fail = $.CreatePanel("Panel", attach_point, "gemforger-item-start")
	    gemforger_fail.BLoadLayoutSnippet("forge_gems_item_fail"); 

	    var item_panel = gemforger_fail.FindChildTraverse('socket_item_fail')
        item_panel.contextEntityIndex = item;
        item_panel.SetAttributeInt("item", item)  

        gemforger_fail.FindChildTraverse('socket_item_name').text = $.Localize("DOTA_Tooltip_ability_"+Abilities.GetAbilityName( item ))
	}else if(msg.success == 1){
		var parent = $('#gemforger_container')
		var attach_point = parent.FindChildTraverse('gemforger_attach_contents')
		attach_point.RemoveAndDeleteChildren(0)
	    var gemforger_item_main = $.CreatePanel("Panel", attach_point, "gemforger-item-start-main")
	    gemforger_item_main.BLoadLayoutSnippet("forge_gems_item_main"); 

	    var item_panel = gemforger_item_main.FindChildTraverse('socket_item_main')
        item_panel.contextEntityIndex = item;
        item_panel.SetAttributeInt("item", item)  

        gemforger_item_main.FindChildTraverse('socket_item_name_main').text = $.Localize("DOTA_Tooltip_ability_"+Abilities.GetAbilityName( item ));
        gemforge_item = item
        manageSocketsWithRoot(item_panel, item)
        mTooltipPanel = item_panel

        var item_table = CustomNetTables.GetTableValue( "item_basics", item.toString() );
        var socket_attacher = gemforger_item_main.FindChildTraverse('gemforging_main_socket_attacher')
        var gems_total_array = [item_table.socket1, item_table.socket2]
        if (!(item_table.socket1===undefined) && !(item_table.socket1=="none")){
        	make_gemforge_socket_panel(1, socket_attacher, item, item_table.socket1, item_table.socket1value, gems_total_array)
        }else{
        	var socket1panel = $.CreatePanel("Panel", socket_attacher, "main_socket_panel1")
        	socket1panel.BLoadLayoutSnippet('gemforging_main_socket_snippet_no_socket')
        	socket1panel.FindChildTraverse('socket_name').text = $.Localize("ui_socket") + " 1"
        }
        var socket_seperator = $.CreatePanel("Panel", socket_attacher, "socket_seperator")
        if (!(item_table.socket2===undefined) && !(item_table.socket2=="none")){
        	make_gemforge_socket_panel(2, socket_attacher, item, item_table.socket2, item_table.socket2value, gems_total_array)
        }else{
        	var socket2panel = $.CreatePanel("Panel", socket_attacher, "main_socket_panel2")
        	socket2panel.BLoadLayoutSnippet('gemforging_main_socket_snippet_no_socket')
        	socket2panel.FindChildTraverse('socket_name').text = $.Localize("ui_socket") + " 2"
        }
	}
}

function make_gemforge_socket_panel(socket_number, socket_attacher, item, socket, socket_value, gems_total_array){
	var socket_panel = $.CreatePanel("Panel", socket_attacher, "main_socket_panel"+socket_number)
	socket_panel.BLoadLayoutSnippet('gemforging_main_socket_snippet')
	socket_panel.FindChildTraverse('socket_name').text = $.Localize("ui_socket") + " " + socket_number
	if (socket == "open"){
		socket_panel.FindChildTraverse('socket_summary_text').text = $.Localize('ui_open_socket')
	}else{
		socket_panel.FindChildTraverse('socket_summary_text').text = $.Localize("gems_"+socket+socket_value)
	}
	socket_panel.FindChildTraverse('socket_summary_text').AddClass('gem_color_'+socket)

	if (socket == "open"){
		var parent = socket_panel.FindChildTraverse('socket_gems_attacher')
		if (!(gems_total_array[0] == "ruby" || gems_total_array[1] == "ruby")){
			attach_gems_list(parent, "ruby", 0, item, socket_number)
		}
		if (!(gems_total_array[0] == "sapphire" || gems_total_array[1] == "sapphire")){
			attach_gems_list(parent, "sapphire", 0, item, socket_number)
		}
		if (!(gems_total_array[0] == "emerald" || gems_total_array[1] == "emerald")){
			attach_gems_list(parent, "emerald", 0, item, socket_number)
		}
		if (!(gems_total_array[0] == "amethyst" || gems_total_array[1] == "amethyst")){
			attach_gems_list(parent, "amethyst", 0, item, socket_number)
		}
	}else{
		var parent = socket_panel.FindChildTraverse('socket_gems_attacher')
		attach_gems_list(parent, socket, socket_value, item, socket_number)
	}
}

function attach_gems_list(parent, gem, gem_level, item, socket_number){
	var attacher = $.CreatePanel("Panel", parent, "gems-list")
	attacher.BLoadLayoutSnippet('socket_gems_list')
	list_attacher = attacher.FindChildTraverse('socket_gems_list_row_attacher')
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	for (i = 1; i <= 5; i++) {
		if (itemValues.minLevel >= ITEM_MIN_LEVEL_PER_GEM[i-1]){
			var gem_panel = $.CreatePanel("Panel", list_attacher, "gem-"+gem+i)
			var check_level = i
			gem_panel.BLoadLayoutSnippet('socket_gem')
			gem_panel.FindChildTraverse('socket_gem_image').SetImage("file://{images}/items/gems/"+gem+i+".png")
			var cost = calculate_forge_cost(gem_level, check_level, gem)
			if (i <= gem_level){
				gem_panel.FindChildTraverse('socket_gem_overlay').SetImage("file://{images}/custom_game/ui/trade-y.png")
			}else{
				gem_panel.AddClass('socket_gem_hoverable')
				if (!(can_afford_gem(cost))){
					gem_panel.FindChildTraverse('socket_gem_overlay').AddClass('too-poor-for-gem')
					gem_panel.SetPanelEvent("onactivate", function GemClick() {
						Game.EmitSound("UI.TooFarDialogue")
					})
				}else{
					set_gem_click(gem_panel, gem, i, item, socket_number)
				}
				set_gem_hover_events(gem_panel, gem, i, item, gem_level)
			}
		}
	}
}

function set_gem_hover_events(gem_panel, gem, i, item, gem_level){
	gem_panel.SetPanelEvent("onmouseover", function GemHover() {
		gem_hover(gem_panel, item, gem, i, gem_level)
	})
	gem_panel.SetPanelEvent("onmouseout", function GemClick() {
		gem_unhover(gem_panel)
	})
}

function set_gem_click(gem_panel, gem, gem_level, item, socket_number){
	gem_panel.SetPanelEvent("onactivate", function GemClick() {
		gem_click(gem, gem_level, item, socket_number)
	})
}

function gem_click(gem, gem_level, item, socket_number){
	GameEvents.SendCustomGameEventToServer( "gems", {event_type: "insert_gem", item: item, gem: gem, gem_level: gem_level, socket_number: socket_number});
	Game.EmitSound("Gemforger.UI.CollectReward")
	CloseGemforger()
}

function gem_hover(panel, item, gem, gem_number, current_level){
	var title_color = "#DDDDDD"
	if (gem == "ruby"){
		title_color = "#f02929"
	}else if(gem == "emerald"){
		title_color = "#36d63b"
	}else if (gem == "sapphire"){
		title_color = "#388af5"
	}else if (gem == "amethyst"){
		title_color = "#c744b8"
	}
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	$.Msg(itemValues)
	var qualityColor = itemValues.qualityColor
	var rarityFactor = itemValues.rarityFactor
	var item_name = Abilities.GetAbilityName(item)
	var title = "<font color='"+title_color+"'>"+$.Localize("gems_"+gem+gem_number)+"</font>"
	var tooltip = "<font color='"+qualityColor+"'>"+$.Localize("DOTA_Tooltip_ability_"+item_name)+"</font>"+"<br><br>"

	var base_gem_tooltip = $.Localize(item_name+"_"+gem+gem_number)

	base_gem_tooltip = substituteGemDescriptions(base_gem_tooltip, gem, gem_number, item, rarityFactor)
	var cost = calculate_forge_cost(current_level, gem_number, gem, rarityFactor)
	tooltip = tooltip + base_gem_tooltip + "<br><br>"
	tooltip = "<font color='"+'#FFFFFF'+"'>"+tooltip + "Cost: " + cost + " Prismatic Gemstones"+"</font>"
	if (!(can_afford_gem(cost))){
		tooltip = tooltip + "<br><font color='#999999' size='12px'> (Not Enough Available)"+"</font>"
	}
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function gem_unhover(panel){
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function calculate_forge_cost(current_level, highlighted_level, gem, rarityFactor){
	$.Msg("CALC FORGE COST:")
	$.Msg("CURRENT LEVEL: "+current_level+" | HIGHLIGHTED: "+highlighted_level)
	var gem_costs = [0, 30, 150, 750, 3750, 18750]
	var total_cost = 0
	if (highlighted_level <= current_level){
		total_cost = 0
	}else{
		for (k = current_level+1; k <= highlighted_level; k++){
			$.Msg(k)
			total_cost = total_cost + gem_costs[k]
		}
	}
	if (rarityFactor < 5){
		total_cost = total_cost/5
	}
	return total_cost
}

function can_afford_gem(cost){
	var playerID = Game.GetLocalPlayerID();
	var prismatics = CustomNetTables.GetTableValue( "player_stats", playerID.toString()+"-gemstones" );
	if (prismatics.gemstones >= cost){
		return true
	}else{
		return false
	}
}

function CloseGemforger(){
	var parent = $('#gemforger_container')
	parent.AddClass('invisible')
	parent.RemoveAndDeleteChildren(0)
	if (GameUI.CustomUIConfig().gemforge == 1){
		clearGearHighlighter()
	}
	mTooltipPanel = null
}

function clearGearHighlighter()
{
	var mainParent = GameUI.CustomUIConfig().equipmentContainer;
    var helmPanel = mainParent.FindChild("helm_main_container").FindChild("helm_container");
    var chestPanel = mainParent.FindChild("armor_main_container").FindChild("armor_container");
    var glovePanel = mainParent.FindChild("weapon_glove_main_container").FindChild("glove_container");
    var bootPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("boot_container");
    var amuletPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("amulet_container");
    var weaponPanel = mainParent.FindChild("weapon_glove_main_container").FindChild("weapon_container");

    helmPanel.RemoveClass("chiselable_gear");
    chestPanel.RemoveClass("chiselable_gear");
    glovePanel.RemoveClass("chiselable_gear");
    bootPanel.RemoveClass("chiselable_gear");
    amuletPanel.RemoveClass("chiselable_gear");
    weaponPanel.RemoveClass("chiselable_gear");
    GameUI.CustomUIConfig().gemforge = 0
}

function ItemShowTooltipInit()
{
	var item = gemforge_item
	if ( item == -1 )
		return;
	ItemShowTooltipOnPanel(mTooltipPanel)
}

function ItemHideTooltipInit()
{
	ItemHideTooltipByPanel(mTooltipPanel)
}

(function()
{
	GameEvents.Subscribe( "open_gemforger", OpenGemforger );
	GameEvents.Subscribe( "item_gemforge_menu", ItemGemforgeMenu );
})();

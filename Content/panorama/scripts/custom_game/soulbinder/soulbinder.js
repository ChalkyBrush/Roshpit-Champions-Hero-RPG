mTooltipPanel = null

SOULBINDER_SLOT_COUNT = 3
SOULBINDER_PREMIUM_SLOTS = [2, 3]

mCurrentItemName = ""
mCurrentItemImage = ""

mSoulbinderState = 0
mSoulbindSlotSelected = 0

mSoulbindViewPage = ""

function OpenSoulbinder(msg){
	//$.Msg("GEM FORGER")
	var parent = $('#soulbinder_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	parent.RemoveAndDeleteChildren(0)
    var soulbinder_main = $.CreatePanel("Panel", parent, "soulbinder-main")
    soulbinder_main.BLoadLayoutSnippet("soulbinder_main");
    var header = soulbinder_main.FindChildTraverse('soulbinder_header')
    var imageName = "file://{images}/custom_game/ui/soulbinder_header.jpg"
    header.SetImage(imageName)


    var attach_point = soulbinder_main.FindChildTraverse('soulbinder_attach_contents')
    var forge_start_panel= $.CreatePanel("Panel", attach_point, "soulbinder-start")
    forge_start_panel.BLoadLayoutSnippet("soulbinder_start_button");
    forge_start_panel.FindChildTraverse("soulbinder_start_image").SetImage("file://{images}/custom_game/ui/spellbinder/soulbinder_search.png")
    forge_start_button = forge_start_panel.FindChildTraverse('soulbinder_start_button_collect')
	forge_start_button.SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("UI.Soulbinder.Click")
		soulbinder_item_search_setup(soulbinder_main)
	})

    var attach_point = soulbinder_main.FindChildTraverse('soulbinder_attach_contents')
    var library_start_panel= $.CreatePanel("Panel", attach_point, "soulbinder-library")
    library_start_panel.BLoadLayoutSnippet("soulbinder_start_button");
    library_start_panel.FindChildTraverse("soulbinder_start_image").SetImage("file://{images}/custom_game/ui/spellbinder/soulbinder_library.png")
    library_start_panel.FindChildTraverse('soulbinder_start_label').text = $.Localize("soulbinder_library_button_title")
    library_button = library_start_panel.FindChildTraverse('soulbinder_start_button_collect')
	library_button.SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("UI.Soulbinder.Click")
		soulbinder_library_init(soulbinder_main)
	})

    var attach_point = soulbinder_main.FindChildTraverse('soulbinder_attach_contents')
    var tips_start_panel= $.CreatePanel("Panel", attach_point, "soulbinder-tips")
    tips_start_panel.BLoadLayoutSnippet("soulbinder_start_button");
    tips_start_panel.FindChildTraverse("soulbinder_start_image").SetImage("file://{images}/custom_game/ui/spellbinder/soulbinder_tips.png")
    tips_start_panel.FindChildTraverse('soulbinder_start_label').text = $.Localize("soulbind_tips_title")
    tips = tips_start_panel.FindChildTraverse('soulbinder_start_button_collect')
	tips.SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("UI.Soulbinder.Click")
		soulbinder_tips_init(soulbinder_main)
	})

    mCloseButton = soulbinder_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	soulbinder_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseSoulbinder();
	})
}


function soulbinder_item_search_setup(soulbinder_main){
	var attach_point = soulbinder_main.FindChildTraverse('soulbinder_attach_contents')
	attach_point.RemoveAndDeleteChildren(0)
    var soulbinder_item_start = $.CreatePanel("Panel", attach_point, "soulbinder-item-search-meta-container")
    soulbinder_item_start.BLoadLayoutSnippet("soulbinder_item_search");
    // soulbinder_item_start.FindChildTraverse('forge_gems_item_attacher').BLoadLayout( "file://{resources}/layout/custom_game/gems/soulbinder_item_slot.xml", false, false );    

    addSoulbindHighlight()

    var search_button = soulbinder_item_start.FindChildTraverse('soulbinder_item_search_button')
    setup_search_button(search_button, soulbinder_item_start)
    mSoulbinderState = 1

    var button = soulbinder_item_start.FindChildTraverse('soulbind_back_button')
    button.SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("UI.Soulbinder.Click")
		OpenSoulbinder(null)
	})
}

function addSoulbindHighlight(){
    var mainParent = GameUI.CustomUIConfig().equipmentContainer;
    var helmPanel = mainParent.FindChild("helm_main_container").FindChild("helm_container");
    var chestPanel = mainParent.FindChild("armor_main_container").FindChild("armor_container");
    var glovePanel = mainParent.FindChild("weapon_glove_main_container").FindChild("glove_container");
    var bootPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("boot_container");
    var amuletPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("amulet_container");
    var weaponPanel = mainParent.FindChild("weapon_glove_main_container").FindChild("weapon_container");

    GameUI.CustomUIConfig().socket = 0;
    GameUI.CustomUIConfig().chisel = 0;
    GameUI.CustomUIConfig().gemforge = 0;
    GameUI.CustomUIConfig().gem_salvage = 0;
    GameUI.CustomUIConfig().soulbind = 1;

    helmPanel.AddClass("soulbindable_gear");
    chestPanel.AddClass("soulbindable_gear");
    glovePanel.AddClass("soulbindable_gear");
    bootPanel.AddClass("soulbindable_gear");
    amuletPanel.AddClass("soulbindable_gear");
    weaponPanel.AddClass("soulbindable_gear");	
}

function setup_search_button(search_button, soulbinder_item_start){
    search_button.SetPanelEvent('onactivate', function Search() {
    	Game.EmitSound("UI.Soulbinder.Search")
		search_button_click(soulbinder_item_start)
	})
}

function search_button_click(soulbinder_item_start)
{
	var query = soulbinder_item_start.FindChildTraverse('soulbinder_item_search_box').text
	if (query.length > 2){
		soulbinder_item_start.FindChildTraverse('search_results_help_text').text = "Searching..."
		GameEvents.SendCustomGameEventToServer( "soulbinder", {event_type: "search", query: query});
	}else{
		soulbinder_item_start.FindChildTraverse('search_results_help_text').text = $.Localize("soulbinder_no_search_query_entered")
	}
}

function SoulbinderSearchResults(msg){
	var result = msg.result
	if (Object.keys(result).length > 0 ){
		// $.GetContextPanel().FindChildTraverse('search_results_help_text').text = Object.keys(result).length
		$.GetContextPanel().FindChildTraverse('search_results_help_text').text = ""
		var attach_point = $.GetContextPanel().FindChildTraverse('soulbinder_search_results_attacher')
		attach_point.RemoveAndDeleteChildren(0)
		Object.keys(result).forEach(function (key) { 
		    var value = result[key]
		    AttachSoulbinderSearchResult(value, attach_point)
		})


	}else{
		var attach_point = $.GetContextPanel().FindChildTraverse('soulbinder_search_results_attacher')
		attach_point.RemoveAndDeleteChildren(0)		
		$.GetContextPanel().FindChildTraverse('search_results_help_text').text = "No Results"
	}

}

function AttachSoulbinderSearchResult(resultData, attach_point){
    var search_result_panel = $.CreatePanel("Panel", attach_point, "soulbinder-search-result")
    search_result_panel.BLoadLayoutSnippet("soulbinder_search_result");
    mCurrentItemName = resultData.image_url
    mCurrentItemName = resultData.roshpit_item_name
    var image_name = "file://{images}/items/"+resultData.image_url+".png"
    var color = GetRarityColor(resultData.rarity)
    search_result_panel.FindChildTraverse("search_result_item_image").SetImage(image_name)
    search_result_panel.FindChildTraverse("search_result_text").text = "<font color='"+color+"'>"+$.Localize("DOTA_Tooltip_ability_"+resultData.roshpit_item_name)+"</font>"
    var button = search_result_panel.FindChildTraverse("soulbinder_search_result_button")
    setup_search_result_button_event(button, resultData.roshpit_item_name, image_name)
}

function setup_search_result_button_event(button, item_variant, image_name)
{
    button.SetPanelEvent('onactivate', function Search() {
    	Game.EmitSound("UI.Soulbinder.Search")
		load_soulbinder_item_page(item_variant, image_name)
		var attach_point = $.GetContextPanel().FindChildTraverse('soulbinder_search_results_attacher')
		attach_point.RemoveAndDeleteChildren(0)		
		$.GetContextPanel().FindChildTraverse('search_results_help_text').text = "Loading Soulbinder Item..."
	})	
}

function load_soulbinder_item_page(item_variant, image_name)
{
	GameEvents.SendCustomGameEventToServer( "soulbinder", {event_type: "item_select", item_variant: item_variant, image_name: image_name});
}

function SoulBinderItemPageLoad(msg)
{
	$.Msg("SELECTED")
	$.Msg(msg)
	mSoulbinderState = 2
	var attach_point = $.GetContextPanel().FindChildTraverse('soulbinder_attach_contents')
	attach_point.RemoveAndDeleteChildren(0)
    var soulbinder_item_start = $.CreatePanel("Panel", attach_point, "soulbinder-item-view")
    soulbinder_item_start.BLoadLayoutSnippet("soulbinder_item_view");
    clearGearHighlighter()
    if (msg.item_variant){
    	mCurrentItemName = msg.item_variant
    	mCurrentItemImage = msg.image_name
    }
    soulbinder_item_start.FindChildTraverse("soulbinder_item_view_item_name").text = $.Localize("DOTA_Tooltip_ability_"+mCurrentItemName)
    soulbinder_item_start.FindChildTraverse('soulbinder_item_view_item_image').SetImage(mCurrentItemImage)

    
    var items_attacher = soulbinder_item_start.FindChildTraverse('soulbinder_item_view_attacher')
    for (i = 1; i <= 3; i++) {
    	var allowButton = true
    	if (msg.result[i]){
		    var soulbound_item_panel = $.CreatePanel("Panel", items_attacher, "soulbinder-item-"+i)
		    soulbound_item_panel.BLoadLayoutSnippet("soulbinder_item_slot");    	
		    soulbound_item_panel.FindChildTraverse('soulbinder_item_slot_title').text = $.Localize("soulbinder_slot") + " " + i
		    soulbound_item_panel.FindChildTraverse('soulbind_item_image').SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png")

		    var item_parent_panel = soulbound_item_panel.FindChildTraverse('soulbind_item_slot')
		    var soulbind_slot_button = soulbound_item_panel.FindChildTraverse('soulbind_slot_select_button')
		    $.Msg(msg.result[i])
		    var slot_data = msg.result[i]
		    var item_panel = soulbound_item_panel.FindChildTraverse('soulbind_item_image')
		    if (msg.result[i].entityIndex){
				item_panel.contextEntityIndex = slot_data.entityIndex;
				item_panel.SetAttributeInt("item", slot_data.entityIndex)
				manageSocketsWithRoot(item_parent_panel, slot_data.entityIndex)
				item_parent_panel.SetAttributeInt("item", slot_data.entityIndex)
				setup_item_image_tooltip(item_parent_panel)
			}else{
				if ((msg.premium == 0) && (i > 1)){
					allowButton = false
					soulbind_slot_button.AddClass("none")
				}
			}
			if (allowButton){
			    setup_soulbind_slot_button(item_parent_panel, i, slot_data, slot_data.entityIndex)
			    setup_soulbind_slot_button(soulbind_slot_button, i, slot_data, slot_data.entityIndex)
			}
		}
    }

}

function setup_item_image_tooltip(item_panel)
{
    item_panel.SetPanelEvent('onmouseover', function ItemTooltipShow() {
    	ItemShowTooltipSoulbinder(item_panel)
	})	
    item_panel.SetPanelEvent('onmouseout', function ItemTooltipHide() {
    	ItemHideTooltipSoulbinder(item_panel)
	})	
}

function setup_soulbind_slot_button(button, index, slot_data, item){
    button.SetPanelEvent('onactivate', function Search() {
    	Game.EmitSound("UI.Soulbinder.Search")
		soulbind_slot_click(index, slot_data, item)
	})
}

function soulbind_slot_click(index, slot_data, item){
	$.Msg(slot_data)
	if (slot_data.soulbind_slot){
		$.Msg("something in slot")
	}else{
		for (i = 1; i <= 3; i++) {
			if (i == index){
				$.GetContextPanel().FindChildTraverse("soulbinder-item-"+i).AddClass("soulbinder_selected_slot")
			}else{
				$.GetContextPanel().FindChildTraverse("soulbinder-item-"+i).RemoveClass("soulbinder_selected_slot")
			}
		}
		var attach_area = $.GetContextPanel().FindChildTraverse('soulbinder_selection_area')
		attach_area.RemoveAndDeleteChildren(0)
		if (item){
		    var soulbinder_equip_options = $.CreatePanel("Panel", attach_area, "empty-soulbind-options")
		    soulbinder_equip_options.BLoadLayoutSnippet("soulbinder_item_slot_options_exists");
		    var delete_button = soulbinder_equip_options.FindChildTraverse('soulbind_final_delete_button')
		    delete_button.SetAttributeInt("state", 0)
			delete_button.SetPanelEvent('onactivate', function FinalBind() {
				var state = delete_button.GetAttributeInt("state", -1)
				if (state == 0){
					$.GetContextPanel().FindChildTraverse('soulbind_final_delete_button_label').text = $.Localize("soulbinder_final_equip_delete_button_confirm")
					Game.EmitSound("UI.Soulbinder.FinalBindButton")
					delete_button.SetAttributeInt("state", 1)
				}else if (state == 1){
					Game.EmitSound("UI.Soulbinder.FinalBindButton")
					delete_button.RemoveClass("final_delete_button_enabled")
					delete_button.AddClass("final_button_disabled")
					$.GetContextPanel().FindChildTraverse('soulbind_final_delete_button_label').text = "Deleting..."
					delete_button.SetAttributeInt("state", 2)		
					$.GetContextPanel().FindChildTraverse('soulbind_final_equip_button').AddClass("none")	
					GameEvents.SendCustomGameEventToServer( "soulbinder", {event_type: "delete_bind", item_name: mCurrentItemName, slot: index});	
				}
			});

			var equip_button = soulbinder_equip_options.FindChildTraverse('soulbind_final_equip_button')
			equip_button.SetPanelEvent('onactivate', function FinalEquip() {
				$.GetContextPanel().FindChildTraverse('soulbind_final_delete_button').AddClass("none")	
				Game.EmitSound("UI.Soulbinder.FinalBindButton")
				$.GetContextPanel().FindChildTraverse('soulbind_final_equip_label').text = "Equipping..."
				equip_button.RemoveClass("final_equip_button_enabled")
				equip_button.AddClass("final_button_disabled")
				GameEvents.SendCustomGameEventToServer( "soulbinder", {event_type: "equip_bind", item_name: mCurrentItemName, slot: index});			
			});
			clearGearHighlighter()
		}else{
		    var soulbinder_empty_options = $.CreatePanel("Panel", attach_area, "empty-soulbind-options")
		    soulbinder_empty_options.BLoadLayoutSnippet("soulbinder_item_slot_options_empty");
		    var item_name_text = "<font color='#E3CDA1'>"+$.Localize("DOTA_Tooltip_ability_"+mCurrentItemName)+"</font>"
		    var base_message = $.Localize("soulbinder_empty_slot_instructions")
		    $.GetContextPanel().FindChildTraverse('soulbind_empty_slot_instructions').text = base_message.replace("@item_name", item_name_text).replace("@item_name", item_name_text)
			$.GetContextPanel().FindChildTraverse('soulbind_slot_item_attacher').BLoadLayout( "file://{resources}/layout/custom_game/soulbinder/soulbinder_binding_slot.xml", false, false );  
			var item_slot_input = $.GetContextPanel().FindChildTraverse('soulbind_slot_item_attacher')
			item_slot_input.SetAttributeString( "item_name", mCurrentItemName)
			item_slot_input.SetAttributeInt( "soulbind_slot", index)
			mSoulbindSlotSelected = index
			addSoulbindHighlight()
		}
	}
}

function SoulbinderItemUpForSoulbind(msg){
	var button = $.GetContextPanel().FindChildTraverse('soulbind_final_bind_button')
	button.RemoveClass("none")
	var cost = msg.cost
	var current_crystals = msg.currentCrystals
	$.GetContextPanel().FindChildTraverse('soulbind-cost-container').RemoveClass("none")
	$.GetContextPanel().FindChildTraverse('soulbind-cost-label').text = $.Localize("soulbinder_cost_to_soulbind") 
	$.GetContextPanel().FindChildTraverse('soulbind-cost-number').text = cost
	var button_text = $.Localize("soulbinder_final_bind_button").replace("@slot_number", msg.slot_number)
	$.GetContextPanel().FindChildTraverse('soulbind_final_bind_label').text = button_text
	if (current_crystals >= cost)
	{
		button.SetPanelEvent('onactivate', function FinalBind() {
			if (!(button.BHasClass("final_button_disabled"))){
				Game.EmitSound("UI.Soulbinder.FinalBindButton")
				GameEvents.SendCustomGameEventToServer( "soulbinder", {event_type: "final_bind"});
				button.RemoveClass("final_button_enabled")
				button.AddClass("final_button_disabled")
				$.GetContextPanel().FindChildTraverse('soulbind_final_bind_label').text = "Binding..."
			}
		});
	}else{
		button.RemoveClass("final_button_enabled")
		button.AddClass("final_button_disabled")
		$.GetContextPanel().FindChildTraverse('soulbind_final_bind_label').text = "Not Enough Crystals"		
	}
}

function GetRarityColor(rarity){
	if (rarity == "immortal"){
		return "#E4AE33"
	}else if(rarity == "arcana"){
		return "#ADE55C"
	}else{
		return "#E3CDA1"
	}
}

function CloseSoulbinder(){
	var parent = $('#soulbinder_container')
	parent.AddClass('invisible')
	parent.RemoveAndDeleteChildren(0)
	if (GameUI.CustomUIConfig().soulbind == 1){
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

    helmPanel.RemoveClass("soulbindable_gear");
    chestPanel.RemoveClass("soulbindable_gear");
    glovePanel.RemoveClass("soulbindable_gear");
    bootPanel.RemoveClass("soulbindable_gear");
    amuletPanel.RemoveClass("soulbindable_gear");
    weaponPanel.RemoveClass("soulbindable_gear");
    GameUI.CustomUIConfig().soulbind = 0
    mSoulbindSlotSelected = 0
}

function ItemShowTooltipSoulbinder(item_panel)
{

	item_panel.AddClass("soulbind_item_highlighted")

	GameUI.CustomUIConfig.itemTooltip = item_panel.GetAttributeInt("item", -1)
	$.DispatchEvent("UIShowCustomLayoutTooltip", item_panel, "ItemTooltipEquip", "file://{resources}/layout/custom_game/equipment/item_tooltip.xml");
}

function ItemHideTooltipSoulbinder(item_panel)
{
	item_panel.RemoveClass("soulbind_item_highlighted")
	$.DispatchEvent("UIHideCustomLayoutTooltip", "ItemTooltipEquip");
}

function GearClickResult(msg){
	if (mSoulbinderState == 1){
		Game.EmitSound("UI.Soulbinder.Search")
		GameEvents.SendCustomGameEventToServer( "soulbinder", {event_type: "item_select", item_variant: msg.item_name, image_name: msg.item_texture});
	}else if (mSoulbinderState == 2){
		if (mSoulbindSlotSelected > 0){
			var soul_bind_slot = mSoulbindSlotSelected
			var item = msg.item
			if (!(mCurrentItemName == Abilities.GetAbilityName(item))){
				Game.EmitSound("General.Cancel")
				return false
			}

			Game.EmitSound("ui.crafting_pulse")
			GameEvents.SendCustomGameEventToServer( "soulbinder", {itemIndex: item, slot: soul_bind_slot, event_type: "item_up_for_binding"});
			$.GetContextPanel().FindChildTraverse('socket_item_slot').contextEntityIndex = item;
			$.GetContextPanel().FindChildTraverse('socket_item_slot').SetAttributeInt("item", item)
			$.GetContextPanel().FindChildTraverse("soulbind_slot_item_attacher").SetAttributeInt("item", item)
		}			
	}
}

function soulbinder_tips_init(soulbinder_main){
	var attach_point = soulbinder_main.FindChildTraverse('soulbinder_attach_contents')
	attach_point.RemoveAndDeleteChildren(0)
    var soulbinder_tips = $.CreatePanel("Panel", attach_point, "soulbinder-item-search-meta-container")
    soulbinder_tips.BLoadLayoutSnippet("soulbinder_tips");	
    var button = soulbinder_tips.FindChildTraverse('soulbind_back_button')
    button.SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("UI.Soulbinder.Click")
		OpenSoulbinder(null)
	})
}

function soulbinder_library_init(soulbinder_main){
	var attach_point = soulbinder_main.FindChildTraverse('soulbinder_attach_contents')
	attach_point.RemoveAndDeleteChildren(0)
    var soulbinder_tips = $.CreatePanel("Panel", attach_point, "soulbinder-item-library-meta-container")
    soulbinder_tips.BLoadLayoutSnippet("soulbinder_library_start");	
    var button = soulbinder_tips.FindChildTraverse('soulbind_back_button')
    button.SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("UI.Soulbinder.Click")
		OpenSoulbinder(null)
	})
}

(function()
{
	GameEvents.Subscribe( "open_soulbinder", OpenSoulbinder );
	GameEvents.Subscribe( "soulbinder_search", SoulbinderSearchResults );
	GameEvents.Subscribe( "soulbinder_item_page_load", SoulBinderItemPageLoad );
	GameEvents.Subscribe( "soulbinder_item_up_for_soulbind", SoulbinderItemUpForSoulbind )
	GameEvents.Subscribe( "close_soulbinder", CloseSoulbinder )
	GameEvents.Subscribe( "soulbinder_gear_click_result", GearClickResult )

})();

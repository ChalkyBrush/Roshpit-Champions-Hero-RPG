gemforge_item = -1
mTooltipPanel = null

function OpenElderRai(msg){
	$.Msg("ELDER RAI")
	var parent = $('#elder_rai_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	parent.RemoveAndDeleteChildren(0)
    var elder_rai_main = $.CreatePanel("Panel", parent, "elder_rai-main")
    elder_rai_main.BLoadLayoutSnippet("elder_rai_main");
    var header = elder_rai_main.FindChildTraverse('elder_rai_header')
    var imageName = "file://{images}/custom_game/ui/elder_rai_header.jpg"
    header.SetImage(imageName)

    var attach_parent = elder_rai_main.FindChildTraverse('elder_rai_attach_contents')
    var phase_2_attacher = elder_rai_main.FindChildTraverse('elder_rai_attach_2')
    var action_panel = $.CreatePanel("Panel", attach_parent, "elder_rai-unrefined-gemstones")
    action_panel.BLoadLayoutSnippet('elder_rai_action')
    action_panel.FindChildTraverse('elder_rai_action_image').SetImage('file://{images}/custom_game/ui/items_for_ui/unrefined_gemstones.png')
    action_panel.FindChildTraverse('elder_rai_action_text').text = $.Localize('elder_rai_refine_gemstones')
    setElderRaiAction(action_panel, "gemstones", phase_2_attacher)

    var action_panel = $.CreatePanel("Panel", attach_parent, "elder_rai-exp-orb")
    action_panel.BLoadLayoutSnippet('elder_rai_action')
    action_panel.FindChildTraverse('elder_rai_action_image').SetImage('file://{images}/custom_game/ui/items_for_ui/exp_orb.png')
    action_panel.FindChildTraverse('elder_rai_action_text').text = $.Localize("elder_rai_buy_exp_orb")
    setElderRaiAction(action_panel, "exp-orb-1", phase_2_attacher)

    var action_panel = $.CreatePanel("Panel", attach_parent, "elder_rai-greater-exp-orb")
    action_panel.BLoadLayoutSnippet('elder_rai_action')
    action_panel.FindChildTraverse('elder_rai_action_image').SetImage('file://{images}/custom_game/ui/items_for_ui/greater_exp_orb.png')
    action_panel.FindChildTraverse('elder_rai_action_text').text = $.Localize('elder_rai_buy_greater_exp_orb')
    setElderRaiAction(action_panel, "exp-orb-2", phase_2_attacher)

    mCloseButton = elder_rai_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	elder_rai_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseElderRai();
	})

}

function setElderRaiAction(button, action, phase_2_attacher){
	button.SetPanelEvent('onactivate', function ElderRaiAction() {
		Game.EmitSound("Gemforger.UI.Close")
		elderRaiAction(action, phase_2_attacher)
	})
}

function elderRaiAction(action, phase_2_attacher){
	phase_2_attacher.RemoveAndDeleteChildren(0)
	if (action == "exp-orb-1"){
		var mithril_cost = 100000
		var playerID = Game.GetLocalPlayerID()
        var shards = CustomNetTables.GetTableValue("player_stats", playerID.toString() + "-mithril").mithril;
		var rai_detail_panel = $.CreatePanel("Panel", phase_2_attacher, "rai-attach-main")
		rai_detail_panel.BLoadLayoutSnippet('elder_rai_exp_orb_purchase')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_image_preview').SetImage('file://{images}/custom_game/ui/items_for_ui/exp_orb.png')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_image_title').text = $.Localize('#DOTA_Tooltip_ability_item_rpc_exp_orb')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_description').text = $.Localize("item_rpc_exp_orb_description")
		rai_detail_panel.FindChildTraverse('elder_rai_orb_mithril_cost_right').text = numberWithCommas(mithril_cost)
		rai_detail_panel.FindChildTraverse('elder_rai_orb_mithril_cost_left').text = $.Localize("ui_cost") + ": "
		rai_detail_panel.FindChildTraverse('elder_rai_orb_your_mithril_right').text = numberWithCommas(shards)
		rai_detail_panel.FindChildTraverse('elder_rai_orb_your_mithril_left').text = $.Localize("elder_rai_your_mithril_shards") + ": "
		rai_detail_panel.FindChildTraverse('final_elder_rai_orb_purchase_label').text = $.Localize("ui_purchase")+" "+$.Localize('DOTA_Tooltip_ability_item_rpc_exp_orb')
		var button = rai_detail_panel.FindChildTraverse('elder_rai_orb_final_purchase')
		if (mithril_cost <= shards){
			set_purchase_orb_button(button, action)
			button.AddClass('elder_rai_orb_final_purchase_ok')
		}else{
			button.FindChildTraverse('final_elder_rai_orb_purchase_label').text = $.Localize("not_enough_shards")
			button.AddClass("button-disabled")
		}
	}else if(action == "exp-orb-2"){
		var mithril_cost = 1000000
		var playerID = Game.GetLocalPlayerID()
        var shards = CustomNetTables.GetTableValue("player_stats", playerID.toString() + "-mithril").mithril;
		var rai_detail_panel = $.CreatePanel("Panel", phase_2_attacher, "rai-attach-main")
		rai_detail_panel.BLoadLayoutSnippet('elder_rai_exp_orb_purchase')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_image_preview').SetImage('file://{images}/custom_game/ui/items_for_ui/greater_exp_orb.png')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_image_title').text = $.Localize('#DOTA_Tooltip_ability_item_rpc_greater_exp_orb')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_description').text = $.Localize("item_rpc_greater_exp_orb_description")
		rai_detail_panel.FindChildTraverse('elder_rai_orb_mithril_cost_right').text = numberWithCommas(mithril_cost)
		rai_detail_panel.FindChildTraverse('elder_rai_orb_mithril_cost_left').text = $.Localize("ui_cost") + ": "
		rai_detail_panel.FindChildTraverse('elder_rai_orb_your_mithril_right').text = numberWithCommas(shards)
		rai_detail_panel.FindChildTraverse('elder_rai_orb_your_mithril_left').text = $.Localize("elder_rai_your_mithril_shards") + ": "
		rai_detail_panel.FindChildTraverse('final_elder_rai_orb_purchase_label').text = $.Localize("ui_purchase")+" "+$.Localize('DOTA_Tooltip_ability_item_rpc_greater_exp_orb')
		var button = rai_detail_panel.FindChildTraverse('elder_rai_orb_final_purchase')
		if (mithril_cost <= shards){
			set_purchase_orb_button(button, action)
			button.AddClass('elder_rai_orb_final_purchase_ok')
		}else{
			button.FindChildTraverse('final_elder_rai_orb_purchase_label').text = $.Localize("not_enough_shards")
			button.AddClass("button-disabled")
		}
	}else if (action == "gemstones"){

		var playerID = Game.GetLocalPlayerID()

		var queryUnit = Players.GetLocalPlayerPortraitUnit();

		var gems_count = 0
		var unrefined_items_count = 0
		for ( var i = 0; i < 12; ++i )
		{
			var item = Entities.GetItemInSlot( queryUnit, i );
			if (Abilities.GetAbilityName( item ) == "item_rpc_unrefined_gemstones"){
				unrefined_items_count = unrefined_items_count + 1
				var gems_value = CustomNetTables.GetTableValue( "item_basics", item.toString() ).property1
				gems_count = gems_count + gems_value
			}
		}

		var rai_detail_panel = $.CreatePanel("Panel", phase_2_attacher, "rai-attach-main")
		rai_detail_panel.BLoadLayoutSnippet('elder_rai_gemstone_refine')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_image_preview').SetImage('file://{images}/custom_game/ui/items_for_ui/unrefined_gemstones.png')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_image_title').text = $.Localize('#DOTA_Tooltip_ability_item_rpc_unrefined_gemstones')
		rai_detail_panel.FindChildTraverse('elder_rai_orb_image_title').style.color = "#E4AE33"
		if (unrefined_items_count <= 1){
			rai_detail_panel.FindChildTraverse('elder_rai_orb_description').text = $.Localize("elder_rai_you_have_x_gemstones_1")
		}else if(unrefined_items_count == 2){
			rai_detail_panel.FindChildTraverse('elder_rai_orb_description').text = $.Localize("elder_rai_you_have_x_gemstones_2")
		}else{
			rai_detail_panel.FindChildTraverse('elder_rai_orb_description').text = $.Localize("elder_rai_you_have_x_gemstones_3").replace("@count", unrefined_items_count)
		}
		rai_detail_panel.FindChildTraverse('elder_rai_orb_description').style.fontSize = "14px"
		rai_detail_panel.FindChildTraverse('elder_rai_orb_mithril_cost_right').text = numberWithCommas(gems_count)
		rai_detail_panel.FindChildTraverse('elder_rai_orb_mithril_cost_left').text = $.Localize("tooltip_prismatic_gemstones") + ": "
		rai_detail_panel.FindChildTraverse('final_elder_rai_orb_purchase_label').text = $.Localize("elder_rai_refine_gemstones")
		var button = rai_detail_panel.FindChildTraverse('elder_rai_orb_final_purchase')
		if (gems_value > 0){
			button.SetPanelEvent('onactivate', function FinalBuy() {
				GameEvents.SendCustomGameEventToServer( "challenges", {event_type: "refine_inventory_gemstones"});
				CloseElderRai();
				Game.EmitSound("Gemforger.UI.Close")
			})	
			button.AddClass('elder_rai_orb_final_purchase_ok')
		}else{
			button.FindChildTraverse('final_elder_rai_orb_purchase_label').text = $.Localize("ui_no_unrefined_gemstones")
			button.AddClass("button-disabled")
		}

	}
}

function set_purchase_orb_button(button, action){
	button.SetPanelEvent('onactivate', function FinalBuy() {
		final_purchase_final(action)
	})	
}

function final_purchase_final(action){
	GameEvents.SendCustomGameEventToServer( "challenges", {event_type: "purchase_exp_orb", action: action});
	CloseElderRai();
}

function CloseElderRai(){
	var parent = $('#elder_rai_container')
	parent.AddClass('invisible')
	parent.RemoveAndDeleteChildren(0)
	if (GameUI.CustomUIConfig().gemforge == 1){
		clearGearHighlighter()
	}
	mTooltipPanel = null
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

(function()
{
	GameEvents.Subscribe( "open_elder_rai", OpenElderRai );
	GameEvents.Subscribe( "close_elder_rai", CloseElderRai );

})();

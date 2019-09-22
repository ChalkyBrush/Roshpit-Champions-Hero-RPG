gemforge_item = -1
mTooltipPanel = null

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

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

    mCloseButton = gemforger_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	gemforger_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseGemforger();
	})

}

function CloseGemforger(){
	var parent = $('#gemforger_container')
	parent.AddClass('invisible')
	parent.RemoveAndDeleteChildren(0)
}

(function()
{
	GameEvents.Subscribe( "open_gemforger", OpenGemforger );
})();

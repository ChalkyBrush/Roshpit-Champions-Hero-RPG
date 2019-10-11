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
    var action_panel = $.CreatePanel("Panel", attach_parent, "elder_rai-unrefined-gemstones")
    action_panel.BLoadLayoutSnippet('elder_rai_action')
    action_panel.FindChildTraverse('elder_rai_action_image').SetImage('file://{images}/custom_game/ui/items_for_ui/unrefined_gemstones.png')
    action_panel.FindChildTraverse('elder_rai_action_text').text = $.Localize('elder_rai_refine_gemstones')
    setElderRaiAction(action_panel, "gemstones")

    var action_panel = $.CreatePanel("Panel", attach_parent, "elder_rai-exp-orb")
    action_panel.BLoadLayoutSnippet('elder_rai_action')
    action_panel.FindChildTraverse('elder_rai_action_image').SetImage('file://{images}/custom_game/ui/items_for_ui/exp_orb.png')
    action_panel.FindChildTraverse('elder_rai_action_text').text = $.Localize("elder_rai_buy_exp_orb")
    setElderRaiAction(action_panel, "exp-orb-1")

    var action_panel = $.CreatePanel("Panel", attach_parent, "elder_rai-greater-exp-orb")
    action_panel.BLoadLayoutSnippet('elder_rai_action')
    action_panel.FindChildTraverse('elder_rai_action_image').SetImage('file://{images}/custom_game/ui/items_for_ui/greater_exp_orb.png')
    action_panel.FindChildTraverse('elder_rai_action_text').text = $.Localize('elder_rai_buy_greater_exp_orb')
    setElderRaiAction(action_panel, "exp-orb-2")

    mCloseButton = elder_rai_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	elder_rai_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseElderRai();
	})

}

function setElderRaiAction(button, action){
	button.SetPanelEvent('onactivate', function ElderRaiAction() {
		Game.EmitSound("Gemforger.UI.Close")
		elderRaiAction(action)
	})
}

function elderRaiAction(action){

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



(function()
{
	GameEvents.Subscribe( "open_elder_rai", OpenElderRai );
	GameEvents.Subscribe( "close_elder_rai", CloseElderRai );

})();

var rollCount = 0

var panel1;
var panel2;
var panel3;
//KNOWN BUGS
//DC Players have broken image portrait
//cant see other players roll colors
function item_roll(msg)
{
	var parentPanel = $('#item_roll_container')
	var rollSlot = msg.rollSlot-1
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "itemroll-box"+rollSlot );
	newChildPanel.itemIndex = msg.item
	newChildPanel.minLevel = msg.minLevel
	// newChildPanel.heroName = msg.heroId
	// newChildPanel.pickup = msg.pickup
	// newChildPanel.playerID = msg.playerId
	
	newChildPanel.rollSlot = rollSlot 
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/new_pickup/item_roll_box.xml", false, false );
	rollCount++;
	if (rollSlot == 0){
		panel1 = newChildPanel;
	}else if(rollSlot==1){
		panel2 = newChildPanel;
	}else if(rollSlot==2){
		panel3 = newChildPanel;
	}
	$.Msg(rollSlot)

}

function getPanel(rollSlot){
	var panel
	if (rollSlot == 0){
		panel = panel1;
	}else if(rollSlot==1){
		panel = panel2;
	}else if(rollSlot==2){
		panel = panel3;
	}
	return panel
}

function item_roll_end(msg)
{
	var rollSlot = msg.rollSlot-1
	$.Msg("END ROLL"+'#itemroll-box'+rollSlot)
	var panel = getPanel(rollSlot)
	panel.RemoveClass("animateIn")
	panel.AddClass("fromBottomFade"+rollSlot)
	panel.FindChildTraverse('option-greed').AddClass('invisible')
	panel.FindChildTraverse('option-need').AddClass('invisible')
	$.Schedule(0.29, function(){
		panel.AddClass("invisible")		
		panel.RemoveAndDeleteChildren()
		// panel.DeleteAsync(0)
	});		
}


(function () {
  GameEvents.Subscribe( "item_roll", item_roll );
  GameEvents.Subscribe( "empty_roll_slot", item_roll_end );
})();

mPropertyTable = $.GetContextPanel().propertyTable
mChisel = $.GetContextPanel().chisel
mReroll = $.GetContextPanel().reroll
mRerollParent = $.GetContextPanel().rerollParent
mPropertySlot = $.GetContextPanel().propertySlot
mPropertyLocked = 0

function InitializeItemPropertyRow()
{
	var itemProperty = mPropertyTable
	$('#property_name').text = "<font color='"+itemProperty.propertyColor+"'>"+$.Localize(itemProperty.propertyName)+"</font>"
	$('#property_value').text = "<font color='"+itemProperty.propertyColor+"'>"+itemProperty.propertyValue+"</font>"
}



function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function PropertyButtonActivate(){
	if (mReroll == 1){
		if (mPropertyLocked==0){
			if (mRerollParent.mLockedSlotsCount < 2){
				mPropertyLocked = 1
				$.GetContextPanel().AddClass('locked_property')
				$('#property-lock-image').RemoveClass('invisible')
				mRerollParent.mLockedSlotsCount = mRerollParent.mLockedSlotsCount + 1
				mRerollParent.setLockSlot(mPropertySlot)
				mRerollParent.RecalculatePrice()

			}
		}else{
			mPropertyLocked = 0
			$.GetContextPanel().RemoveClass('locked_property')
			$('#property-lock-image').AddClass('invisible')
			mRerollParent.mLockedSlotsCount = mRerollParent.mLockedSlotsCount - 1
			mRerollParent.setLockSlot(mPropertySlot)
			mRerollParent.RecalculatePrice()
		}
	}
}

function PropertyLockTooltip(){
	if (mReroll == 1){

		var panel = $('#property_row_button')
		panel.AddClass('property_row_button_hover')
		var title = "<font color='yellow'>"+$.Localize('#property_lock_title')
		var tooltip = $.Localize('#property_lock_tooltip')
		$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
	}
}

function HidePropertyTooltip(){
	var panel = $('#property_row_button')
	panel.RemoveClass('property_row_button_hover')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}


(function()
{
	InitializeItemPropertyRow();
})();

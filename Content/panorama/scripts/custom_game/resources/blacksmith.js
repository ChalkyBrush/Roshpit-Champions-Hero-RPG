function CloseBlacksmith(msg) {
    $('#blacksmith_main_container').AddClass("invisible");
    $('#blacksmith_main_container').style.visibility = "collapse";
    GameUI.CustomUIConfig().mainDialog = 0;
    ToggleChiselState(false);
    ToggleRerollState(false);
    ToggleSocketState(false);
    $('#item-display-content').RemoveAndDeleteChildren(0);
    if (msg !== 0) {
        if (!(msg === undefined)) {
            if (msg.unlock === 1) {
                GameUI.CustomUIConfig().blacksmithLock = 0;
            }
        }
    }
}

function OpenBlacksmith() {
    if (GameUI.CustomUIConfig().mainDialog === 0) {
        GameUI.CustomUIConfig().chisel = 0;
        GameUI.CustomUIConfig().reroll = 0;
        GameUI.CustomUIConfig().socket = 0;
        GameUI.CustomUIConfig().rerollItem = 0;
        $.GetContextPanel().style.visibility = "visible"
        $('#blacksmith_main_container').RemoveClass("invisible");
        $('#blacksmith_main_container').style.visibility = "visible";
        $('#upgrade-tiers-box').RemoveClass("invisible");
        GameUI.CustomUIConfig().mainDialog = 1;
        $('#header_text').text = $.Localize('#ui_blacksmith_title');

        $('#chisel_button_label').text = $.Localize('#chisel_name');
        $('#reroll_button_label').text = $.Localize('#reroll_name');
        $('#socket_button_label').text = $.Localize('#socket_name');

        var playerID = Game.GetLocalPlayerID();
        var shards = CustomNetTables.GetTableValue("player_stats", playerID.toString() + "-mithril").mithril;
        shards = numberWithCommas(shards);
        if (shards < 0) {
            shards = $.Localize('#saveload_loading');
        }
        $('#current_crystals_label_value').text = shards;

        $('#current_crystals_label').text = $.Localize('tooltip_current_shards');
        $('#upgrade-resource-button-label').text = $.Localize('tooltip_collect_income');

        var incomeAvailable = CustomNetTables.GetTableValue("player_stats", playerID.toString() + "-income").available;
        if (incomeAvailable === 0) {
            $('#upgrade-tiers-box').AddClass("invisible");
            $('#resources-box-row').AddClass("no_income");
        }
        $('#income_crystals_label_value').text = $.Localize('#tooltip_daily_income') + ": 1000";
    }
}


function CollectMithrilIncome() {
    if (GameUI.CustomUIConfig().blacksmithLock === 0) {
        GameEvents.SendCustomGameEventToServer("collect_mithril_income", { playerID: Game.GetLocalPlayerID() });
        GameUI.CustomUIConfig().blacksmithLock = 1;
        Game.EmitSound("challenge.success");
    }
}




function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function IncomeTooltip() {
    var panel = $('#upgrade-tiers-box');
    var title = "<font color='yellow'>" + $.Localize('#tooltip_daily_income');
    var tooltip = $.Localize('#collect_income_info');
    tooltip = breakUpTooltip(tooltip);
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideIncomeTooltip() {
    var panel = $('#upgrade-tiers-box');
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
}




function InitializeBlacksmith() {
    GameUI.CustomUIConfig().blacksmithLock = 0;
    CloseBlacksmith(0);
}

function UnlockBlacksmith() {
    GameUI.CustomUIConfig().blacksmithLock = 0;
    GameUI.CustomUIConfig().mainDialog = 0;
    ToggleChiselState(false);
    ToggleRerollState(false);
    ToggleSocketState(false);
    $('#item-display-content').RemoveAndDeleteChildren(0);
    OpenBlacksmith();
}

function UnlockBlacksmithAfterReroll(msg) {
    var itemIndex = msg.itemIndex;
    GameUI.CustomUIConfig().blacksmithLock = 0;
    GameUI.CustomUIConfig().mainDialog = 0;
    ToggleChiselState(false);
    ToggleRerollState(false);
    ToggleSocketState(false);
    var itemValues = CustomNetTables.GetTableValue("item_basics", itemIndex.toString());
    var rarity = itemValues.rarityFactor;
    if (itemValues.slot === "weapon") {
        return false;
    }
    if (rarity === 5) {
        var heroIndex = Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID());
        Game.PrepareUnitOrders({ OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_STOP });
        GameEvents.SendCustomGameEventToServer("drag_into_reroll_slot", { playerID: Game.GetLocalPlayerID(), heroIndex: heroIndex, itemIndex: itemIndex, ignoreLock: 0, lock1: msg.lock1, lock2: msg.lock2, lock3: msg.lock3, lock4: msg.lock4 });
    }
}

function ClearGlyphShop() {
    $('#glyph_content').RemoveAndDeleteChildren();
}

function ChiselButtonActivate() {
    if (GameUI.CustomUIConfig().chisel === 0) {
        Game.EmitSound("ui.crafting_gem_drop");
        ToggleChiselState(true);
    } else {
        ToggleChiselState(false);
    }
}


function ToggleChiselState(bTurnOn) {
    if (!GameUI.CustomUIConfig().equipmentContainer) {
        return;
    }

    var mainParent = GameUI.CustomUIConfig().equipmentContainer;
    var helmPanel = mainParent.FindChild("helm_main_container").FindChild("helm_container");
    var chestPanel = mainParent.FindChild("armor_main_container").FindChild("armor_container");
    var glovePanel = mainParent.FindChild("weapon_glove_main_container").FindChild("glove_container");
    var bootPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("boot_container");
    var amuletPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("amulet_container");
    var weaponPanel = mainParent.FindChild("weapon_glove_main_container").FindChild("weapon_container");
    if (bTurnOn) {
        GameUI.CustomUIConfig().chisel = 1;
        GameUI.CustomUIConfig().socket = 0;
        $('#chisel_button_label').text = $.Localize('#ui_cancel');
        $('#chisel_button').AddClass('active_button');
        $('#socket_button_label').text = $.Localize('#socket_name');
        $('#socket_button').RemoveClass('active_button');
        helmPanel.AddClass("chiselable_gear");
        chestPanel.AddClass("chiselable_gear");
        glovePanel.AddClass("chiselable_gear");
        bootPanel.AddClass("chiselable_gear");
        amuletPanel.AddClass("chiselable_gear");
        weaponPanel.AddClass("chiselable_gear");
        ToggleRerollState(false);
    } else {
        GameUI.CustomUIConfig().chisel = 0;
        $('#chisel_button_label').text = $.Localize('#chisel_name');
        $('#chisel_button').RemoveClass('active_button');
        $('#item-display-content').RemoveAndDeleteChildren(0);
        helmPanel.RemoveClass("chiselable_gear");
        chestPanel.RemoveClass("chiselable_gear");
        glovePanel.RemoveClass("chiselable_gear");
        bootPanel.RemoveClass("chiselable_gear");
        amuletPanel.RemoveClass("chiselable_gear");
        weaponPanel.RemoveClass("chiselable_gear");
        $('#final_forge_button_container').AddClass('invisible');
    }
}

function ToggleRerollState(bTurnOn) {
    if (!GameUI.CustomUIConfig().equipmentContainer) {
        return;
    }
    if (bTurnOn) {
        GameUI.CustomUIConfig().reroll = 1;
        $('#reroll_button_label').text = $.Localize('#ui_cancel');
        $('#reroll_button').AddClass('active_button');
        ToggleChiselState(false);
        ToggleSocketState(false);
    } else {
        GameUI.CustomUIConfig().reroll = 0;
        $('#reroll_button_label').text = $.Localize('#reroll_name');
        $('#reroll_button').RemoveClass('active_button');
        $('#item-display-content').RemoveAndDeleteChildren(0);
        GameUI.CustomUIConfig().rerollItem = 0;
        $('#final_forge_button_container').AddClass('invisible');
    }
}

function RerollButtonActivate() {
    if (GameUI.CustomUIConfig().reroll === 0) {
        ToggleRerollState(true);
        Game.EmitSound("ui.crafting_gem_drop");
        var parentPanel = $('#item-display-content');
        parentPanel.RemoveAndDeleteChildren(0);
        var newChildPanel = $.CreatePanel("Panel", parentPanel, "chisel-item");
        newChildPanel.shards = CustomNetTables.GetTableValue("player_stats", Game.GetLocalPlayerID().toString() + "-mithril").mithril;

        newChildPanel.BLoadLayoutSnippet("blacksmith_reroll_prescreen");
        newChildPanel.SetPanelEvent('onload', function Close() {
            InitializeRerollPreScreen();
        });
        return newChildPanel;
    } else {
        ToggleRerollState(false);

    }
}



function chiselGearSelected(msg) {
    var itemIndex = msg.itemIndex;
    var parentPanel = $('#item-display-content');
    var forgePriceContainer = $('#forge_price_box_container_main');
    parentPanel.RemoveAndDeleteChildren(0);
    var newChildPanel = $.CreatePanel("Panel", parentPanel, "chisel-item");
    newChildPanel.itemIndex = itemIndex;
    newChildPanel.slot = msg.slot;
    GameUI.CustomUIConfig().chisel = 1;
    GameUI.CustomUIConfig().reroll = 0;
    newChildPanel.chisel = 1
    newChildPanel.forgeButton = $('#final_forge_button');
    newChildPanel.forgePriceContainer = forgePriceContainer;
    newChildPanel.shards = CustomNetTables.GetTableValue("player_stats", Game.GetLocalPlayerID().toString() + "-mithril").mithril;
    newChildPanel.BLoadLayout("file://{resources}/layout/custom_game/resources/item_detail_blacksmith.xml", false, false);
    $('#final_forge_button_container').RemoveClass('invisible');
    $('#final_forge_button_label').text = $.Localize('#action_finish_chisel');
}

function FinalForgeActivate() {
    if (GameUI.CustomUIConfig().blacksmithLock === 0) {
        var mShards = CustomNetTables.GetTableValue("player_stats", Game.GetLocalPlayerID().toString() + "-mithril").mithril;
        var forgeButton = $('#final_forge_button');
        var cost = null;
        var itemIndex = null;
        if (GameUI.CustomUIConfig().chisel === 1) {
            cost = GameUI.CustomUIConfig().blacksmithChiselCost
            var slot = GameUI.CustomUIConfig().blacksmithChiselEquipmentSlot;
            if (mShards >= cost) {
                //Complete Chiseling
                GameUI.CustomUIConfig().blacksmithLock = 1;
                $('#final_forge_button_label').text = $.Localize('#tooltip_forge_in_process');
                //forgeButton.RemoveClass('forge_button_color_main');
                //forgeButton.AddClass('forge_button_deactivated');

                itemIndex = GameUI.CustomUIConfig().blacksmithChiselItemIndex;
                Game.EmitSound("ui.crafting_confirm_socket");
                GameEvents.SendCustomGameEventToServer("final_chisel", { playerID: Game.GetLocalPlayerID(), itemIndex: itemIndex, cost: cost, slot: slot });
            } else {
                Game.EmitSound("General.Cancel");
            }
        } else if (GameUI.CustomUIConfig().reroll === 1) {
            cost = forgeButton.rerollCost;
            if (mShards >= cost) {
                var lock1 = forgeButton.lock1;
                var lock2 = forgeButton.lock2;
                var lock3 = forgeButton.lock3;
                var lock4 = forgeButton.lock4;
                if (lock1 + lock2 + lock3 + lock4 > 2) {
                    return false;
                }
                GameUI.CustomUIConfig().blacksmithLock = 1;
                $('#final_forge_button_label').text = $.Localize('#tooltip_forge_in_process');
                forgeButton.RemoveClass('forge_button_color_main');
                forgeButton.AddClass('forge_button_deactivated');
                itemIndex = GameUI.CustomUIConfig().rerollItem;
                // GameUI.CustomUIConfig().backup = GameUI.CustomUIConfig().rerollItem
                Game.EmitSound("ui.crafting_confirm_socket");

                GameEvents.SendCustomGameEventToServer("final_reroll", { playerID: Game.GetLocalPlayerID(), itemIndex: itemIndex, cost: cost, lock1: lock1, lock2: lock2, lock3: lock3, lock4: lock4 });
                GameUI.CustomUIConfig().rerollItem = 0;
            } else {
                Game.EmitSound("General.Cancel");
            }
        } else if (GameUI.CustomUIConfig().socket === 1) {
            GameUI.CustomUIConfig().socket = 0;
            var cutter = GameUI.CustomUIConfig().blacksmithCutterIndex
            var socketingItem = GameUI.CustomUIConfig().blacksmithSocketItem
            GameEvents.SendCustomGameEventToServer("final_socket", { cutter: cutter, socketingItem: socketingItem});
            Game.EmitSound("ui.crafting_confirm_socket");
        }
    }
}

function ChiselTooltip() {
    var panel = $('#chisel_button_container');
    var title = "<font color='yellow'>" + $.Localize('#chisel_name');
    var tooltip = $.Localize('#chisel_tooltip');
    tooltip = breakUpTooltip(tooltip);
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideChiselTooltip() {
    var panel = $('#chisel_button_container');
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
}

function RerollTooltip() {
    var panel = $('#reroll_button_container');
    var title = "<font color='yellow'>" + $.Localize('#reroll_name');
    var tooltip = $.Localize('#reroll_tooltip');
    tooltip = breakUpTooltip(tooltip);
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function breakUpTooltip(tooltip) {
    return tooltip;
}

function HideRerollTooltip() {
    var panel = $('#reroll_button_container');
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
}

function SocketTooltip() {
    var panel = $('#socket_button_container');
    var title = "<font color='yellow'>" + $.Localize('#socket_name');
    var tooltip = $.Localize('#socket_tooltip');
    tooltip = breakUpTooltip(tooltip);
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideSocketTooltip() {
    var panel = $('#socket_button_container');
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
}

function SocketButtonActivate() {
    if (GameUI.CustomUIConfig().socket == 0) {
        Game.EmitSound("ui.crafting_gem_drop");
        ToggleSocketState(true);
    } else {
        ToggleSocketState(false);
    }
}

function ToggleSocketState(bTurnOn) {
    if (!GameUI.CustomUIConfig().equipmentContainer) {
        return;
    }

    var mainParent = GameUI.CustomUIConfig().equipmentContainer;
    var helmPanel = mainParent.FindChild("helm_main_container").FindChild("helm_container");
    var chestPanel = mainParent.FindChild("armor_main_container").FindChild("armor_container");
    var glovePanel = mainParent.FindChild("weapon_glove_main_container").FindChild("glove_container");
    var bootPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("boot_container");
    var amuletPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("amulet_container");
    var weaponPanel = mainParent.FindChild("weapon_glove_main_container").FindChild("weapon_container");
    if (bTurnOn) {
        GameUI.CustomUIConfig().socket = 1;
        GameUI.CustomUIConfig().chisel = 0;
        $('#socket_button_label').text = $.Localize('#ui_cancel');
        $('#socket_button').AddClass('active_button');

        $('#chisel_button_label').text = $.Localize('#chisel_name');
        $('#chisel_button').RemoveClass('active_button');
        helmPanel.AddClass("chiselable_gear");
        chestPanel.AddClass("chiselable_gear");
        glovePanel.AddClass("chiselable_gear");
        bootPanel.AddClass("chiselable_gear");
        amuletPanel.AddClass("chiselable_gear");
        weaponPanel.AddClass("chiselable_gear");
        ToggleRerollState(false);
        socketStep1()
        // ToggleChiselState(false);
    } else {
        GameUI.CustomUIConfig().socket = 0;
        $('#socket_button_label').text = $.Localize('#socket_name');
        $('#socket_button').RemoveClass('active_button');
        $('#item-display-content').RemoveAndDeleteChildren(0);
        helmPanel.RemoveClass("chiselable_gear");
        chestPanel.RemoveClass("chiselable_gear");
        glovePanel.RemoveClass("chiselable_gear");
        bootPanel.RemoveClass("chiselable_gear");
        amuletPanel.RemoveClass("chiselable_gear");
        weaponPanel.RemoveClass("chiselable_gear");
        $('#final_forge_button_container').AddClass('invisible');
    }
}

function socketStep1(){
    $('#item-display-content').RemoveAndDeleteChildren(0);
    var socket_panel = $.CreatePanel("Panel", $('#item-display-content'), "socket_panel")
    socket_panel.BLoadLayoutSnippet("blacksmith_socket_item_select")
    socket_panel.FindChildTraverse('blacksmith_socket_item_attacher').BLoadLayout( "file://{resources}/layout/custom_game/resources/socket_slot.xml", false, false );    
}

function socketStep2(msg){
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

    $('#item-display-content').RemoveAndDeleteChildren(0);
    var socket_panel = $.CreatePanel("Panel", $('#item-display-content'), "socket_panel")
    if (msg.validity == 0){
        socket_panel.BLoadLayoutSnippet("blacksmith_socket_item_selected_fail") 
        socket_panel.FindChildTraverse('blacksmith_socket_item_select_tip').text = $.Localize(msg.error_message)
        Game.EmitSound("General.Cancel");
    }else{
        GameUI.CustomUIConfig().blacksmithSocketItem = msg.itemIndex
        var mithril = CustomNetTables.GetTableValue("player_stats", Game.GetLocalPlayerID().toString() + "-mithril").mithril;
        
        socket_panel.BLoadLayoutSnippet("blacksmith_socket_item_selected_ok") 
        socket_panel.FindChildTraverse('blacksmith_socket_item_select_tip').text = $.Localize(msg.ok_message)
        Game.EmitSound("ui.crafting_pulse");

        socket_panel.FindChildTraverse('blacksmith_socket_item_title').text = $.Localize("DOTA_Tooltip_ability_"+Abilities.GetAbilityName( msg.itemIndex ))
        socket_panel.FindChildTraverse('socket_item_image').contextEntityIndex = msg.itemIndex;
        socket_panel.FindChildTraverse('socket_item_image').SetAttributeInt("item", msg.itemIndex)  

        socket_panel.FindChildTraverse('blacksmith_socket_mithril_cost_text').text = msg.cost + "<br>" + $.Localize("ui_mithril_shards")
        socket_panel.FindChildTraverse('blacksmith_socket_item_forger_tip').text = $.Localize("item_forger_tip_for_socket")

        if (mithril < msg.cost){
            socket_panel.FindChildTraverse('blacksmith_socket_item_forger_attacher').AddClass('invisible')
            socket_panel.FindChildTraverse('blacksmith_socket_item_forger_tip').text = $.Localize("socket_not_enough_mithril")
            socket_panel.FindChildTraverse('blacksmith_socket_item_forger_tip').style.marginTop = "20px"
            socket_panel.FindChildTraverse('plus_sign').AddClass('invisible')
        }

        socket_panel.FindChildTraverse('blacksmith_socket_item_forger_attacher').BLoadLayout( "file://{resources}/layout/custom_game/resources/socket_cutter_slot.xml", false, false );  
        GameUI.CustomUIConfig().socket_panel = socket_panel
    }   
}

function socket_cutter_inserted(msg){
    $.Msg("INSERTED")
    GameUI.CustomUIConfig().blacksmithCutterIndex = msg.itemIndex
    GameUI.CustomUIConfig().socket_panel.FindChildTraverse('blacksmith_socket_item_forger_tip').text = $.Localize("DOTA_Tooltip_ability_item_rpc_socket_cutter")
    $('#final_forge_button_container').RemoveClass('invisible');
    $('#final_forge_button_label').text = $.Localize("final_add_socket");
    $('#final_forge_button').AddClass('forge_button_color_main');
    $('#final_forge_button').RemoveClass('forge_button_deactivated');
}

function playerReceivedItem(){

}

(function () {
    InitializeBlacksmith();
    // CloseOracle();
    GameEvents.Subscribe("open_blacksmith", OpenBlacksmith);
    GameEvents.Subscribe("close_blacksmith", CloseBlacksmith);
    GameEvents.Subscribe("reopen_blacksmith", InitializeBlacksmith);
    GameEvents.Subscribe("unlock_blacksmith", UnlockBlacksmith);

    GameEvents.Subscribe("unlock_blacksmith_after_reroll", UnlockBlacksmithAfterReroll);

    GameEvents.Subscribe("chiselable_gear_clicked", chiselGearSelected);
    GameEvents.Subscribe("socket_gear_clicked", socketStep2);
    GameEvents.Subscribe("playerReceivedItem", playerReceivedItem);
    GameEvents.Subscribe("socket_cutter_inserted", socket_cutter_inserted);
})();

//Previously
//reroll_pre_screen.js

mItemIndex = -1;
mLockedSlot1 = 0;
mLockedSlot2 = 0;
mLockedSlot3 = 0;
mLockedSlot4 = 0;
mButtonTable = [];
mChildPanelTable = [];
mDetailParent = false;
m_Item = 0;

function InitializeRerollPreScreen() {
    $('#item_placement_tip').text = $.Localize('reroll_tip_one');
    $('#reroll_other_tip').text = $.Localize('reroll_tip_two');
    $('#item_image').SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png");
    GameEvents.Subscribe("load_item_for_reroll", LoadItemForReroll);
    GameEvents.Subscribe("lockSlotsFromServerCall", lockSlotsFromServerCall);
    $.GetContextPanel().lockSlotsFromServerCall = lockSlotsFromServerCall;
    $.RegisterEventHandler('DragEnter', $('#item_image'), OnDragEnter);
    $.RegisterEventHandler('DragDrop', $('#item_image'), OnDragDrop);
    $.RegisterEventHandler('DragLeave', $('#item_image'), OnDragLeave);
}

function OnDragEnter(a, draggedPanel) {
    var draggedItem = draggedPanel.m_DragItem;

    // only care about dragged items other than us
    if (draggedItem === null || !draggedPanel.fromInventory)
        return true;

    var itemValues = CustomNetTables.GetTableValue("item_basics", draggedItem.toString());
    var rarity = itemValues.rarityFactor;

    if (!(rarity === 5)) {
        return true;
    }
    if (!(itemValues.socket1 === undefined) && !(itemValues.socket1 == "open")){
        $('#item_image').AddClass("hightlight_red");
        return true
    }
    // highlight this panel as a drop target
    $('#item_image').AddClass("item_highlight");
    Game.EmitSound("Item.DropRecipeWorld");
    return true;
}

function OnDragDrop(panelId, draggedPanel) {
    var draggedItem = draggedPanel.m_DragItem;
    draggedPanel.lockOrder = true;
    $('#item_image').RemoveClass("hightlight_red");
    // only care about dragged items other than us
    if (draggedItem === null)
        return true;
    var itemValues = CustomNetTables.GetTableValue("item_basics", draggedItem.toString());
    var rarity = itemValues.rarityFactor;
    if (itemValues.slot === "weapon") {
        return false;
    }
    if (!(itemValues.socket1 === undefined) && !(itemValues.socket1 == "open")){
        return false
    }
    if (draggedPanel.fromInventory && rarity === 5) {
        var playerID = Game.GetLocalPlayerID();
        var heroIndex = Players.GetPlayerHeroEntityIndex(playerID);
        draggedPanel.m_DragCompleted = true;
        Game.EmitSound("ui.crafting_pulse");
        // LoadItemForReroll(draggedItem)
        GameEvents.SendCustomGameEventToServer("drag_into_reroll_slot", { playerID: playerID, heroIndex: heroIndex, itemIndex: draggedItem, ignoreLock: 0, lock1: 0, lock2: 0, lock3: 0, lock4: 0 });
    }
    return true;
}

function OnDragLeave(panelId, draggedPanel) {
    var draggedItem = draggedPanel.m_DragItem;
    if (draggedItem === null || draggedItem === m_Item)
        return false;

    $('#item_image').RemoveClass("item_highlight");
    $('#item_image').RemoveClass("hightlight_red");
    return true;
}

function LoadItemForReroll(msg) {
    //Reset locked slots, will be set again with server call
    mLockedSlot1 = 0;
    mLockedSlot2 = 0;
    mLockedSlot3 = 0;
    mLockedSlot4 = 0;
    var itemIndex = msg.itemIndex
    if (parseInt(msg.ignoreLock) === 1) {
        GameUI.CustomUIConfig().blacksmithLock = 0
    }
    var parentPanel = $('#item-display-content');
    var forgePriceContainer = $('#forge_price_box_container_main');
    parentPanel.RemoveAndDeleteChildren();
    var newChildPanel = $.CreatePanel("Panel", parentPanel, "reroll-item");
    newChildPanel.itemIndex = itemIndex
    mItemIndex = itemIndex
    GameUI.CustomUIConfig().chisel = 0
    GameUI.CustomUIConfig().socket = 0
    GameUI.CustomUIConfig().reroll = 1
    newChildPanel.forgePriceContainer = forgePriceContainer
    newChildPanel.shards = CustomNetTables.GetTableValue("player_stats", Game.GetLocalPlayerID().toString() + "-mithril").mithril;
    // newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/resources/item_detail_blacksmith.xml", false, false );	
    var playerID = Game.GetLocalPlayerID();


    GameUI.CustomUIConfig().rerollItem = itemIndex
    newChildPanel.BLoadLayoutSnippet("item_detail_blacksmith");
    newChildPanel.lockedSlotsCount = 0
    mDetailParent = newChildPanel
    InitializeItemDisplay(newChildPanel);

    lockSlotsFromServerCall(msg);
    // $.Schedule(0.5, function(){
    $('#final_forge_button_container').RemoveClass('invisible');
    $('#final_forge_button_label').text = $.Localize('#action_finish_reroll');
    // });
}



function InitializeItemDisplay(detail_parent) {
    var minLevel = populateItem(detail_parent)
    detail_parent.minLevel = minLevel
    Game.EmitSound("ui.crafting_gem_drop")
    if (GameUI.CustomUIConfig().chisel === 1) {
        var forgeButton = $('#final_forge_button');
        var chiselPrice = Math.floor(minLevel * 1)
        // chiselPrice = 1000000
        detail_parent.FindChildTraverse('forge_price_label').text = $.Localize('#message_chisel_price')
        detail_parent.FindChildTraverse('forge_price_label_value').text = chiselPrice
        forgeButton.chiselItemIndex = mItemIndex
        forgeButton.blacksmithChiselCost = GameUI.CustomUIConfig().blacksmithChiselCost
        if (detail_parent.shards >= chiselPrice) {
            forgeButton.AddClass('forge_button_color_main')
            forgeButton.RemoveClass('forge_button_deactivated')

        } else {
            forgeButton.RemoveClass('forge_button_color_main')
            forgeButton.AddClass('forge_button_deactivated')
            forgeButton.FindChild('final_forge_button_label').text = $.Localize('#not_enough_shards')
        }
        // mForgePriceContainer.FindChild("forge_price_image_main").RemoveClass('invisible')
        // mForgePriceContainer.FindChild("forge_price_label_value_main").text = chiselPrice
    } else if (GameUI.CustomUIConfig().reroll === 1) {
        recalculatePriceReroll(detail_parent)
    }

}

function recalculatePriceReroll(detail_parent) {
    var minLevel = detail_parent.minLevel;
    var rerollPrice = Math.floor(minLevel * 3);
    var mShards = CustomNetTables.GetTableValue("player_stats", Game.GetLocalPlayerID().toString() + "-mithril").mithril;
    var forgeButton = $('#final_forge_button');
    if (detail_parent.lockedSlotsCount >= 1) {
        rerollPrice = rerollPrice * 2;
    }
    if (detail_parent.lockedSlotsCount >= 2) {
        rerollPrice = rerollPrice * 2;
    }
    detail_parent.FindChildTraverse('forge_price_label').text = $.Localize('#message_reroll_price');
    detail_parent.FindChildTraverse('forge_price_label_value').text = rerollPrice;
    forgeButton.rerollItemIndex = forgeButton.chiselItemIndex;
    forgeButton.rerollCost = rerollPrice;
    forgeButton.itemLevel = minLevel;
    forgeButton.lock1 = mLockedSlot1;
    forgeButton.lock2 = mLockedSlot2;
    forgeButton.lock3 = mLockedSlot3;
    forgeButton.lock4 = mLockedSlot4;
    if (mShards >= rerollPrice) {
        forgeButton.AddClass('forge_button_color_main');
        forgeButton.RemoveClass('forge_button_deactivated');

    } else {
        forgeButton.RemoveClass('forge_button_color_main');
        forgeButton.AddClass('forge_button_deactivated');
        forgeButton.FindChild('final_forge_button_label').text = $.Localize('#not_enough_shards');
    }
}



function populateItem(detail_parent) {
    detail_parent.FindChildTraverse('item_image').contextEntityIndex = mItemIndex;
    detail_parent.FindChildTraverse('item_image').SetAttributeInt("item", mItemIndex)
    var itemName = Abilities.GetAbilityName(mItemIndex);

    var itemValues = CustomNetTables.GetTableValue("item_basics", mItemIndex.toString())

    var rarityColor = itemValues.qualityColor
    detail_parent.FindChildTraverse('item_name').text = "<font color='" + rarityColor + "'>" + $.Localize("#DOTA_Tooltip_Ability_" + itemName) + "</font>"

    var parentPanel = detail_parent.FindChildTraverse("item_properties_container")

    for (i = 1; i <= 4; i++) {
        var itemTable = customNetTableSplitter(itemValues, i)
        createAttributeRow(itemTable, parentPanel, i, detail_parent)
    }

    if (itemValues.minLevel) {
        var minLevelText = $.Localize('#item_min_level')
        var reduction = 0
        detail_parent.FindChildTraverse('min_level_label').text = minLevelText
        var minLevelValue = parseInt(itemValues.minLevel - reduction)
        detail_parent.FindChildTraverse('min_level_label_value').text = minLevelValue
        return minLevelValue
    } else {
        detail_parent.FindChildTraverse('min_level_label').AddClass('invisible')
        detail_parent.FindChildTraverse('min_level_label_value').AddClass('invisible')
        return 1
    }
}

function customNetTableSplitter(itemPropertyesTable, index) {
    var itemPropertyesTableNew = {}
    var propertyColor = undefined
    var propertyName = undefined
    var propertyValue = undefined
    switch (index) {
        case 1:
            propertyColor = itemPropertyesTable.property1color
            propertyName = itemPropertyesTable.property1tooltip === "rune" ? itemPropertyesTable.property1name : itemPropertyesTable.property1tooltip
            propertyValue = itemPropertyesTable.property1
            break;
        case 2:
            propertyColor = itemPropertyesTable.property2color
            propertyName = itemPropertyesTable.property2tooltip === "rune" ? itemPropertyesTable.property2name : itemPropertyesTable.property2tooltip
            propertyValue = itemPropertyesTable.property2
            break;
        case 3:
            propertyColor = itemPropertyesTable.property3color
            propertyName = itemPropertyesTable.property3tooltip === "rune" ? itemPropertyesTable.property3name : itemPropertyesTable.property3tooltip
            propertyValue = itemPropertyesTable.property3
            break;
        case 4:
            propertyColor = itemPropertyesTable.property4color
            propertyName = itemPropertyesTable.property4tooltip === "rune" ? itemPropertyesTable.property4name : itemPropertyesTable.property4tooltip
            propertyValue = itemPropertyesTable.property4
            break;
    }
    if (propertyColor === undefined || propertyColor === undefined || propertyColor === undefined) return null
    itemPropertyesTableNew.propertyColor = propertyColor
    itemPropertyesTableNew.propertyName = propertyName
    itemPropertyesTableNew.propertyValue = propertyValue
    return itemPropertyesTableNew
}

function createAttributeRow(itemProperty, parentPanel, i, detail_parent) {
    if (itemProperty) {
        var newChildPanel = $.CreatePanel("Panel", parentPanel, "chisel-item-attribute" + i);
        newChildPanel.propertyTable = itemProperty
        GameUI.CustomUIConfig().chisel = 0
        GameUI.CustomUIConfig().socket = 0
        GameUI.CustomUIConfig().reroll = 1
        newChildPanel.propertySlot = i
        newChildPanel.rerollParent = $("#reroll_prescreen_root");
        newChildPanel.BLoadLayoutSnippet("blacksmith_item_row");
        newChildPanel.FindChildTraverse('property_name').text = "<font color='" + itemProperty.propertyColor + "'>" + $.Localize(itemProperty.propertyName) + "</font>"
        newChildPanel.FindChildTraverse('property_value').text = "<font color='" + itemProperty.propertyColor + "'>" + itemProperty.propertyValue + "</font>"

        var button = newChildPanel.FindChildTraverse('property_row_button')
        button.slot = i
        button.propertyLocked = 0
        mButtonTable[i] = button
        mChildPanelTable[i] = newChildPanel
        button.SetPanelEvent('onmouseover', function SetButtonItemMouseover() {
            PropertyLockTooltip(button)
        });
        button.SetPanelEvent('onmouseout', function SetButtonItemMouseover() {
            HidePropertyTooltip(button)
        });
        button.SetPanelEvent('onactivate', function SetButtonClick() {
            PropertyButtonActivate(button, detail_parent, newChildPanel)
        });
    }
}



function lockSlotsFromServerCall(msg) {
    if (msg.lock1 === 1) {
        PropertyButtonActivate(mButtonTable[1], mDetailParent, mChildPanelTable[1]);
    }
    if (msg.lock2 === 1) {
        PropertyButtonActivate(mButtonTable[2], mDetailParent, mChildPanelTable[2]);
    }
    if (msg.lock3 === 1) {
        PropertyButtonActivate(mButtonTable[3], mDetailParent, mChildPanelTable[3]);
    }
    if (msg.lock4 === 1) {
        PropertyButtonActivate(mButtonTable[4], mDetailParent, mChildPanelTable[4]);
    }
}

function PropertyButtonActivate(button, detail_parent, newChildPanel) {
    if (button.propertyLocked === 0) {
        if (detail_parent.lockedSlotsCount < 2) {
            button.propertyLocked = 1
            newChildPanel.AddClass('locked_property')
            newChildPanel.FindChildTraverse('property-lock-image').RemoveClass('invisible')
            detail_parent.lockedSlotsCount = detail_parent.lockedSlotsCount + 1
            setLockSlot(button.slot)
            recalculatePriceReroll(detail_parent)
        }
    } else {
        button.propertyLocked = 0
        newChildPanel.RemoveClass('locked_property')
        newChildPanel.FindChildTraverse('property-lock-image').AddClass('invisible')
        detail_parent.lockedSlotsCount = detail_parent.lockedSlotsCount - 1
        setLockSlot(button.slot)
        recalculatePriceReroll(detail_parent)
    }
}

function setLockSlot(slot) {
    if (slot === 1) {
        if (mLockedSlot1 === 0) {
            mLockedSlot1 = 1
        } else {
            mLockedSlot1 = 0
        }
    } else if (slot === 2) {
        if (mLockedSlot2 === 0) {
            mLockedSlot2 = 1
        } else {
            mLockedSlot2 = 0
        }
    } else if (slot === 3) {
        if (mLockedSlot3 === 0) {
            mLockedSlot3 = 1
        } else {
            mLockedSlot3 = 0
        }
    } else if (slot === 4) {
        if (mLockedSlot4 === 0) {
            mLockedSlot4 = 1
        } else {
            mLockedSlot4 = 0
        }
    }
}

function PropertyLockTooltip(panel) {
    // var panel = attributePanel.FindChildTraverse('property_row_button')
    panel.AddClass('property_row_button_hover')
    var title = "<font color='yellow'>" + $.Localize('#property_lock_title')
    var tooltip = $.Localize('#property_lock_tooltip')
    $.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HidePropertyTooltip(panel) {
    // var panel = attributePanel.FindChildTraverse('property_row_button')
    panel.RemoveClass('property_row_button_hover')
    $.DispatchEvent("DOTAHideTitleTextTooltip", panel);
}


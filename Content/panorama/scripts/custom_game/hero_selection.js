var heroPreviews = {};
var previewLoadingQueue = [];
var b_item_loading_done = false
var b_unit_loading_done = false

m_Selected_Hero = ""
m_heroPanels = []
m_MuteMusic = 0
function HeroSelectInit(animation)
{
    $.GetContextPanel().selectLock = false
    if (Players.GetTeam( Game.GetLocalPlayerID()) == -1){
        $.Msg("IS SPECTATOR")
        $.GetContextPanel().selectLock = true
        $.GetContextPanel().FindChildTraverse('hero_select_parent').AddClass('invisible');
        return false       
    }
    var localHero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )
    if (localHero == -1){
        GameUI.CustomUIConfig().muteMusic = 0
    }else{
        var localHeroName = Entities.GetUnitName( localHero )
        $.Msg(localHeroName)
        if (localHeroName == "npc_dota_hero_wisp"){
            GameUI.CustomUIConfig().muteMusic = 0
            $.Msg("STILL WISP")
        }else{
            $.GetContextPanel().selectLock = true
            $.Msg("NOT WISP")
            $.GetContextPanel().FindChildTraverse('hero_select_parent').AddClass('invisible');
            return false
        }
    }
    $.Msg(localHero)

    var parent = $('#hero_select_content')
    var board = $.CreatePanel("Panel", parent, "dummy-box")
    var item_load = $.CreatePanel("Panel", parent, "item_load_panel")
    item_load.BLoadLayoutSnippet('item_load_snippet')
    item_load.FindChildTraverse("item_load_label").text = $.Localize("#ui_loading_items")
    if (b_item_loading_done){ item_load.FindChildTraverse("item_load_label_pct").text = $.Localize("#ui_done")}
        else{ item_load.FindChildTraverse("item_load_label_pct").text = "0%" }
    var unit_load = $.CreatePanel("Panel", parent, "unit_load_panel")
    unit_load.BLoadLayoutSnippet('unit_load_snippet')
    unit_load.FindChildTraverse("unit_load_label").text = $.Localize("#ui_loading_units")
    if (b_unit_loading_done){ unit_load.FindChildTraverse("unit_load_label_pct").text = $.Localize("#ui_done")}
        else{ unit_load.FindChildTraverse("unit_load_label_pct").text = "0%" }
    board.BLoadLayoutSnippet('new-or-load')
    if (animation =="frombottom"){
        board.AddClass('animateFromBottomEpic')
    }else if (animation =="fromleft"){
        board.AddClass('animateSlideInFromLeft')
        $.Schedule(0.35, function(){
            board.RemoveClass('animateSlideInFromLeft')
        });
    }
	// PreloadHeroPreview("npc_dota_hero_omniknight")
	// PreloadHeroPreview("npc_dota_hero_leshrac")

    board.FindChildTraverse('new-character').SetPanelEvent('onactivate', function NewHeroOption() {
        newHeroOptionSelect(board, parent)
        Game.EmitSound("Roshpit.UI.SelectLoadOrNew")
    }); 
    board.FindChildTraverse('load-character').SetPanelEvent('onactivate', function LoadHeroOption() {
        loadHeroOptionSelect(board, parent)
        Game.EmitSound("Roshpit.UI.SelectLoadOrNew")
    }); 
    var mapName = Game.GetMapInfo().map_display_name
    if (mapName == "rpc_pvp_linewar_no_oracle"){
        board.FindChildTraverse('load-character').AddClass('invisible')
        board.FindChildTraverse('new-character').FindChildTraverse('new-character-button-label').text = $.Localize("hero_select_character_general")
    }
    board.FindChildTraverse('mute_music_button').SetPanelEvent('onactivate', function MuteMusic() {
        if (GameUI.CustomUIConfig().muteMusic == 0){
            GameUI.CustomUIConfig().muteMusic = 1
            board.FindChildTraverse('mute_music_button').AddClass('music_button_active')
            board.FindChildTraverse('button_check').RemoveClass('invisible')
        }else{
            GameUI.CustomUIConfig().muteMusic = 0
            board.FindChildTraverse('mute_music_button').RemoveClass('music_button_active')
            board.FindChildTraverse('button_check').AddClass('invisible')
        }
    });
}

function loadHeroOptionSelect(board, parent){
     m_heroPanels = []
     board.AddClass('animateFadeOut')

    $.Schedule(0.27, function(){
        $('#hero_select_content').RemoveAndDeleteChildren()
        var heroList = getHeroList()
        var newBoard = $.CreatePanel("Panel", parent, "loading_characters_parent")
        newBoard.BLoadLayoutSnippet('loading_characters')
        newBoard.AddClass('fadeInSmall')
        // 
        GameEvents.SendCustomGameEventToServer( "save_menu", {playerID: Players.GetLocalPlayer(), saveOrLoad: "load"});

        var backButton = newBoard.FindChildTraverse('back-button')
        backButton.style.marginLeft ="300px"
        backButton.SetPanelEvent('onactivate', function SelectHeroBackButton() {
            backButtonFunction(backButton.GetParent(), backButton)
        });
     });
}

function newHeroOptionSelect(board, parent){
     m_heroPanels = []
     board.AddClass('animateFadeOut')

    $.Schedule(0.27, function(){
        $('#hero_select_content').RemoveAndDeleteChildren()
        var heroList = getHeroList()
        var newBoard = $.CreatePanel("Panel", parent, "newBoard")
        newBoard.BLoadLayoutSnippet('hero_select_new')
        newBoard.AddClass('animateFromBottom')
        var heroPreviewBox = $('#hero_preview_box')
        var heroesTaken = CustomNetTables.GetTableValue( "hero_index", "taken_heroes")
        $.Msg(heroesTaken)
        for ( var i = 1; i < heroList.length; ++i )
        {
            var row = newBoard.FindChildTraverse('hero_selection_row'+getRowNumber(i))
            heroSlotAddAndInit(row, heroList[i], heroPreviewBox, -1, -1, heroesTaken)
        }
        var backButton = newBoard.FindChildTraverse('back-button')
        var heroSelectContent = $('#hero_select_content')
        heroSelectContent.RemoveClass('animateSlideOutRight')

        backButton.SetPanelEvent('onactivate', function SelectHeroBackButton() {
            backButtonFunction(heroSelectContent, backButton)
        });
     });
}

function backButtonFunction(heroSelectContent, backButton){
    backButton.AddClass('invisible')
    Game.EmitSound("Roshpit.UI.HeroSelect.Back")
    heroSelectContent.AddClass('animateSlideOutRight')
    $.Schedule(0.27, function(){
        heroSelectContent.RemoveAndDeleteChildren()
        HeroSelectInit("fromleft");

    });
}

NEW_HEROES_PER_ROW = 7

function getRowNumber(index)
{
    var rowNumber = 1 + Math.floor(index/NEW_HEROES_PER_ROW)
    if (index%NEW_HEROES_PER_ROW == 0)
    {
        rowNumber = rowNumber - 1
    }
    return rowNumber
}

function update_picked_heroes(msg)
{
    var heroesTaken = CustomNetTables.GetTableValue( "hero_index", "taken_heroes")
    for ( var i = 0; i < m_heroPanels.length; ++i ){
        $.Msg(heroesTaken[i])
        var heroPanelHeroName = m_heroPanels[i].heroName
        for ( var j = 0; j < 12; ++j ){
            if (heroesTaken[j] == heroPanelHeroName){
                m_heroPanels[i].FindChildTraverse('hero_portrait_overlay').RemoveClass('invisible')
                var heroImage = m_heroPanels[i].FindChildTraverse('hero_portrait_image')
                heroImage.SetPanelEvent('onactivate', function SelectHero() {

                });
                heroImage.SetPanelEvent('onmouseover', function HeroMouseOver() {

                });
                heroImage.SetPanelEvent('onmouseout', function HeroMouseOut() {

                });
            }
        }
    }
    if (m_Selected_Hero == msg.selectedHero){
        $('#enter-world-button').AddClass('invisible');
    }
}

function heroSlotAddAndInit(row, heroName, heroPreviewBox, level, slot, heroesTaken)
{
    var board = $.CreatePanel("Panel", row, "newBoard")
    board.BLoadLayoutSnippet('hero_select_portrait')
    var heroImage = board.FindChildTraverse('hero_portrait_image')
    board.FindChildTraverse('hero_portrait_name_label').text = $.Localize(heroName)
    board.heroName = heroName
    m_heroPanels.push(board)
    heroImage.SetImage( "file://{images}/heroes/" + heroName + ".png" );
    var heroTaken = false
    for ( var i = 0; i < 12; ++i ){
        $.Msg(heroesTaken[i])
        if (heroesTaken[i] == heroName){
            board.FindChildTraverse('hero_portrait_overlay').RemoveClass('invisible')
            heroTaken = true
        }
    }
    if (level > 0){
        board.FindChildTraverse('hero_portrait_level_label').RemoveClass('invisible')
        board.FindChildTraverse('hero_portrait_level_label').text = "LV"+level
        board.FindChildTraverse('hero_portrait_slot_label').RemoveClass('invisible')
        board.FindChildTraverse('hero_portrait_slot_label').text = slot
    }
    heroImage.level = level
    if (!(heroTaken)){
        heroImage.SetPanelEvent('onactivate', function SelectHero() {
            setHeroSlotActivate(heroImage, heroName, heroPreviewBox, slot)
        });
        heroImage.SetPanelEvent('onmouseover', function HeroMouseOver() {
            setHeroSlotFunctions(heroImage, "mouseover")
        });
        heroImage.SetPanelEvent('onmouseout', function HeroMouseOut() {
            setHeroSlotFunctions(heroImage, "mouseout")
        });
    }
}

function checkIfNoHero()
{
    var localHero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )
    if (localHero == -1){
        return true
    }else{
        var localHeroName = Entities.GetUnitName( localHero )
        $.Msg(localHeroName)
        if (localHeroName == "npc_dota_hero_wisp"){
            return true
        }else{
            $.GetContextPanel().selectLock = true
            $.Msg("NOT WISP")
            $.GetContextPanel().FindChildTraverse('hero_select_parent').AddClass('invisible');
            return false
        }
    }    
}

function setHeroSlotActivate(heroImage, heroName, heroPreviewBox, slot)
{

    if(!($.GetContextPanel().selectLock)){
        if (!(checkIfNoHero())){
            return false
        }
        if (Game.IsGamePaused()){
            return false
        }
        $.GetContextPanel().selectLock = true
        Game.EmitSound("Roshpit.UI.ClickHero")
        m_Selected_Hero = heroName
        var heroPreviewScene = heroPreviewBox.FindChildTraverse('hero_preview_scene')
        heroPreviewScene.RemoveAndDeleteChildren()
        // var board = $.CreatePanel("Panel", heroPreviewScene, "heroPreviewScene")
        heroPreviewScene.BLoadLayoutSnippet('hero_preview') 
        var preview = $.CreatePanel("Panel", heroPreviewScene, "hero_preview_main_scene");
        preview.AddClass("HeroPreview");  
        preview.BCreateChildren("<DOTAScenePanel particleonly='false' antialias='true' class='HeroPreviewScene SceneLoaded' unit='" + heroName + "' always-cache-composition-layer='true'/>")
        var nameLabel = heroPreviewBox.FindChildTraverse('hero_preview_name_label')
        nameLabel.text = $.Localize(heroName)
        nameLabel.RemoveClass("fadeInSmall")
        nameLabel.AddClass("fadeInSmall")
        var enterWorldButton = $.GetContextPanel().FindChildTraverse('enter-world-button')

        enterWorldButton.RemoveClass('invisible')
        enterWorldButton.AddClass('fadeInSmall')
        $('#ability-preview-row').RemoveAndDeleteChildren()
        $('#ability-preview-row').RemoveClass('fadeInSmall')
        var load_hero_abilities = $.CreatePanel("Panel", $('#ability-preview-row'), "load_hero_abilities");
        load_hero_abilities.BLoadLayoutSnippet("load_hero_abilities_snippet")
        load_hero_abilities.AddClass("load_lable_class")
        GameEvents.SendCustomGameEventToServer( "hero_selection_event", {playerID: Players.GetLocalPlayer(), eventName: "previewAbility", heroName: heroName, muteMusic: m_MuteMusic} );
        

        if (heroImage.level > 0){
            heroPreviewBox.FindChildTraverse('hero_preview_level_label').RemoveClass('invisible')
            heroPreviewBox.FindChildTraverse('hero_preview_level_label').text = $.Localize('arena_prizebox_level')+" "+heroImage.level
            setEnterWorldLoad(heroName, enterWorldButton, slot)
        }else{
            setEnterWorldHeroName(heroName, enterWorldButton)
            heroPreviewBox.FindChildTraverse('hero_lore_text').text = $.Localize(heroName+"_lore")
        }
    }
}

function setEnterWorldHeroName(heroName, enterWorldButton)
{
    enterWorldButton.SetPanelEvent('onactivate', function SelectHero() {
        if (!($.GetContextPanel().selectLock)){ 
            if (!(checkIfNoHero())){
                return false
            }
            if (Game.IsGamePaused()){
                return false
            }
            $.GetContextPanel().selectLock = true
            Game.EmitSound("Roshpit.UI.SelectHero")
            enterWorldButton.SetPanelEvent('onactivate', function (){

            });

            var backButton = $.GetContextPanel().FindChildTraverse('back-button')
            backButton.AddClass('invisible')
            backButton.SetPanelEvent('onactivate', function(){

            });
            
            GameEvents.SendCustomGameEventToServer( "hero_selection_event", {playerID: Players.GetLocalPlayer(), eventName: "selectNewHero", heroName: heroName} );
            $.GetContextPanel().FindChildTraverse('hero_select_content').AddClass('animateFadeOutSlow')
            m_heroPanels = []
            $.Schedule(2.87, function(){
                $.GetContextPanel().FindChildTraverse('hero_select_content').RemoveAndDeleteChildren();
                $.GetContextPanel().AddClass('animateFadeOutSlow')
                $.Schedule(2.87, function(){
                    $.GetContextPanel().FindChildTraverse('hero_select_parent').RemoveAndDeleteChildren();
                });
            });
        }
    });    
}

function setEnterWorldLoad(heroName, enterWorldButton, slot)
{
    enterWorldButton.SetPanelEvent('onactivate', function SelectHero() {
        if (!($.GetContextPanel().selectLock)){ 
            $.GetContextPanel().selectLock = true
            Game.EmitSound("Roshpit.UI.SelectHero")
            enterWorldButton.text = $.Localize("ui_loading")
            var backButton = $.GetContextPanel().FindChildTraverse('back-button')
            backButton.AddClass('invisible')
            backButton.SetPanelEvent('onactivate', function(){

            });
            enterWorldButton.SetPanelEvent('onactivate', function (){

            });
            GameEvents.SendCustomGameEventToServer( "hero_selection_event", {playerID: Players.GetLocalPlayer(), eventName: "loadHero", heroName: heroName, slot: slot, muteMusic: m_MuteMusic} );
            m_heroPanels = []
        }
    });    
}

function closePickScreen(){
    if (!($.GetContextPanel().FindChildTraverse('hero_select_content') ===undefined)){
        $.GetContextPanel().FindChildTraverse('hero_select_content').AddClass('animateFadeOutSlow')
        $.Schedule(2.87, function(){
            $.GetContextPanel().FindChildTraverse('hero_select_content').RemoveAndDeleteChildren();
            $.GetContextPanel().AddClass('animateFadeOutSlow')
            $.Schedule(2.87, function(){
                $.GetContextPanel().FindChildTraverse('hero_select_parent').RemoveAndDeleteChildren();
            });
        });
    }
}

function updateSkillPreview(msg)
{
    $.Msg(msg.abilityTable)
    var parent = $('#ability-preview-row')
    parent.RemoveAndDeleteChildren()
    parent.AddClass('fadeInSmall')
    var queryUnit = msg.heroIndex
    $.Msg(msg)

    for ( var i = 0; i < 4; ++i )
    {
        $.Msg(queryUnit)
        if (i == 3){
            i = 5
        }
        var ability = Entities.GetAbility( queryUnit, i );
        $.Msg(ability)
        $.Msg( Abilities.GetLevel(ability))
        var board = $.CreatePanel("Panel", parent, "AbilityPreviewGenerated")
        board.BLoadLayoutSnippet('ability_preview')
        var playerID = Game.GetLocalPlayerID();
        board.FindChildTraverse('AbilityImage').contextEntityIndex = ability;
        var abilityButton = board.FindChildTraverse('AbilityButton')
        setAbilityHoverEvents(abilityButton, ability, queryUnit, parent)
        $.GetContextPanel().selectLock = false
    }

}

function setAbilityHoverEvents(abilityButton, ability, queryUnit, parent)
{
    abilityButton.SetPanelEvent('onmouseover', function AbilityTooltip() {
        showAbilityTooltip(abilityButton, ability, queryUnit, parent)
    });
    abilityButton.SetPanelEvent('onmouseout', function AbilityTooltip() {
        AbilityHideTooltip(abilityButton, ability, queryUnit, parent)
    });     
}

function setHeroSlotFunctions(heroImage, option)
{
    if (option=="mouseover"){
        heroImage.AddClass('faded')
        var label = heroImage.GetParent().FindChildTraverse("hero_portrait_name_label").RemoveClass('invisible')
    }else if (option=="mouseout"){
        heroImage.RemoveClass('faded')
        var label = heroImage.GetParent().FindChildTraverse("hero_portrait_name_label").AddClass('invisible')
    }
}

function showAbilityTooltip(abilityButton, abilityIndex, queryUnit, parent)
{
    $.Msg(abilityIndex)
    var abilityButton = $( "#AbilityButton" );
    var abilityName = Abilities.GetAbilityName( abilityIndex );
    $.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", parent, abilityName, queryUnit );
}

function AbilityHideTooltip(abilityButton, abilityIndex, queryUnit, parent)
{
    $.DispatchEvent( "DOTAHideAbilityTooltip", parent );
}

function LoadCharactersLoaded(msg){
    var result = msg.result
    var parent = $('#hero_select_content')
        $('#hero_select_content').RemoveAndDeleteChildren()

        var heroList = result.characters;
        var newBoard = $.CreatePanel("Panel", parent, "newBoard")
        newBoard.BLoadLayoutSnippet('hero_select_new')
        newBoard.AddClass('animateFromBottom')
        newBoard.FindChildTraverse('hero_select_new_title').text = $.Localize('hero_select_load_character')
        var heroPreviewBox = $('#hero_preview_box')
        newBoard.FindChildTraverse('premium_notifier').RemoveClass('invisible')
        $.Msg(result)
        $.Msg(result.characters.size)
        var rowNumber = 1
        var rowCounter = 0
        var heroesTaken = CustomNetTables.GetTableValue( "hero_index", "taken_heroes")
        for ( var i = 1; i <= 32; ++i )
        {
            $.Msg(result.characters[i].heroName)
            if (!(result.characters[i].heroName == "empty")){
                if (i <= 8){
                    rowNumber = 1
                    rowCounter = 0
                }
                if (i == 9){
                    rowNumber = 2
                    rowCounter = 0
                }else if(i == 10){
                    rowNumber = 2
                    rowCounter = 1
                }
                var row = newBoard.FindChildTraverse('hero_selection_row'+rowNumber)

                heroSlotAddAndInit(row, result.characters[i].heroName, heroPreviewBox, result.characters[i].level, i, heroesTaken)
                rowCounter = rowCounter + 1
                if (rowCounter == 8){
                    rowNumber = rowNumber + 1
                    rowCounter = 0
                }
            }
        }
        var backButton = newBoard.FindChildTraverse('back-button')
        var heroSelectContent = $('#hero_select_content')
        heroSelectContent.RemoveClass('animateSlideOutRight')

        backButton.SetPanelEvent('onactivate', function SelectHeroBackButton() {
            backButtonFunction(heroSelectContent, backButton)
        });
    // $.Msg(result)
    // $('#load_container').RemoveAndDeleteChildren();
    // $('#load_container_premium1').RemoveAndDeleteChildren();
    // $('#load_container_premium2').RemoveAndDeleteChildren();
    // $('#load_container_premium3').RemoveAndDeleteChildren();
    // $('#load_container_premium4').RemoveAndDeleteChildren();
    // if (msg.message=="save_success"){
    //     $('#oracle_content_label').text = $.Localize('#saveload_save_successful')
    //     $('#save_extras_label').text = $.Localize('#saveload_save_successful')
    //     Game.EmitSound("ui.trophy_new")
    // }else{
    //     if (msg.heroSlot > 0){
    //         $('#save_extras_label').text = $.Localize('#saveload_slot_bound')+" "+msg.heroSlot
    //     }
    //     $('#oracle_content_label').style.visibility = "collapse"
    // }
    // $.Msg("HERO SLOT")
    // var parentPanel = $('#load_container')
    // for (var i = 1; i <= 4; i++) {
    //     var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
    //     newChildPanel.heroName = result.characters[i].heroName;
    //     newChildPanel.slot = i
    //     newChildPanel.heroLevel = result.characters[i].level
    //     newChildPanel.heroSlot = msg.heroSlot
    //     newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false ); 
    //     var playerID = Game.GetLocalPlayerID();

    // }
    // parentPanel = $('#load_container_premium1')
    // for (var i = 5; i <= 8; i++) {
    //     var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
    //     newChildPanel.heroName = result.characters[i].heroName;
    //     newChildPanel.slot = i
    //     newChildPanel.heroLevel = result.characters[i].level
    //     newChildPanel.heroSlot = msg.heroSlot
    //     newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false ); 
    //     var playerID = Game.GetLocalPlayerID();

    // }
    // parentPanel = $('#load_container_premium2')
    // for (var i = 9; i <= 12; i++) {
    //     var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
    //     newChildPanel.heroName = result.characters[i].heroName;
    //     newChildPanel.slot = i
    //     newChildPanel.heroLevel = result.characters[i].level
    //     newChildPanel.heroSlot = msg.heroSlot
    //     newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false ); 
    //     var playerID = Game.GetLocalPlayerID();

    // }
    // parentPanel = $('#load_container_premium3')
    // for (var i = 13; i <= 16; i++) {
    //     var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
    //     newChildPanel.heroName = result.characters[i].heroName;
    //     newChildPanel.slot = i
    //     newChildPanel.heroLevel = result.characters[i].level
    //     newChildPanel.heroSlot = msg.heroSlot
    //     newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false ); 
    //     var playerID = Game.GetLocalPlayerID();

    // }
    // parentPanel = $('#load_container_premium4')
    // for (var i = 17; i <= 20; i++) {
    //     var newChildPanel = $.CreatePanel( "Panel", parentPanel, "saved_character"+i );
    //     newChildPanel.heroName = result.characters[i].heroName;
    //     newChildPanel.slot = i
    //     newChildPanel.heroLevel = result.characters[i].level
    //     newChildPanel.heroSlot = msg.heroSlot
    //     newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_slot.xml", false, false ); 
    //     var playerID = Game.GetLocalPlayerID();

    // }
}

function load_characters_fail(){
    $.GetContextPanel().FindChildTraverse('loading_mesage').text = $.Localize("load_characters_fail")
    $.GetContextPanel().FindChildTraverse('reload-characters').RemoveClass('invisible')
    var parent = $('#hero_select_content')
    $.GetContextPanel().FindChildTraverse('reload-characters').SetPanelEvent('onactivate', function LoadHeroOption() {
        reloadHeroes(parent)
        Game.EmitSound("Roshpit.UI.SelectLoadOrNew")
    }); 
}

function reloadHeroes(parent){
     m_heroPanels = []

    $.Schedule(0.27, function(){
        $('#hero_select_content').RemoveAndDeleteChildren()
        var heroList = getHeroList()
        var newBoard = $.CreatePanel("Panel", parent, "loading_characters_parent")
        newBoard.BLoadLayoutSnippet('loading_characters')
        newBoard.AddClass('fadeInSmall')
        // 

        GameEvents.SendCustomGameEventToServer( "save_menu", {playerID: Players.GetLocalPlayer(), saveOrLoad: "load"});
     });
}

function UpdatePrecahe(msg) {
    if (!$("#hero_select_content")){return}
    var item_panel = $("#hero_select_content").FindChildTraverse("item_load_panel")
    var unit_panel = $("#hero_select_content").FindChildTraverse("unit_load_panel")
    if (msg.units){
        if (unit_panel){
            unit_panel.FindChildTraverse("unit_load_label_pct").text = msg.pct+"%"
        }
    }else{
        if (item_panel){
            item_panel.FindChildTraverse("item_load_label_pct").text = msg.pct+"%"
        }
    }
}

function FinishPrecahe(msg) {
    if (!$("#hero_select_content")){return}
    var item_panel = $("#hero_select_content").FindChildTraverse("item_load_panel")
    var unit_panel = $("#hero_select_content").FindChildTraverse("unit_load_panel")
    if (msg.units){
        if (unit_panel){
            unit_panel.FindChildTraverse("unit_load_label_pct").text = $.Localize("#ui_done")
        }
        b_unit_loading_done = true
    }else{
        if (item_panel){
            item_panel.FindChildTraverse("item_load_label_pct").text = $.Localize("#ui_done")
        }
        b_item_loading_done = true
    }
}

(function()
{	
	HeroSelectInit("frombottom");
    GameEvents.Subscribe( "update_precache", UpdatePrecahe );
    GameEvents.Subscribe( "finish_precache", FinishPrecahe );
	GameEvents.Subscribe( "hero_select", HeroSelectInit );
    GameEvents.Subscribe( "updateSkillPreview", updateSkillPreview );
    GameEvents.Subscribe( "load_characters_loaded", LoadCharactersLoaded );
    GameEvents.Subscribe( "close_oracle", closePickScreen );
    GameEvents.Subscribe("update_picked_heroes", update_picked_heroes);
    GameEvents.Subscribe("load_characters_loaded_fail", load_characters_fail);
})();
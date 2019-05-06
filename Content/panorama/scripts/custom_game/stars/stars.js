function InitializeStarsMenu()
{
	GameUI.CustomUIConfig().starsParent = $('#stars_container')
	// OpenStarsMenu()
}

mActiveCategoryButton = false

mButtonRows = 3
mButtonsPerRow = 10
TOTAL_HERO_CATEGORIES = 12
MAX_STARS = 1242

function openStarsFromServer(msg){
	$('#stars_container').RemoveClass('invisible')
	$.Msg("REMOEV INVISIBLE?")
	GameUI.CustomUIConfig().starsOpen = true
	mActiveCategoryButton = false
	GameUI.CustomUIConfig().starsParent.RemoveClass('invisible')
	GameUI.CustomUIConfig().starsParent.RemoveClass('outLeftBig')
	GameUI.CustomUIConfig().starsParent.AddClass('fromLeftBig')
	OpenStarsMenu(msg.playerID, msg.starsData, msg.grandTotalStars)
}

function OpenStarsMenu(playerID, starData, grandTotalStars)
{
	var totalStars =  0
	//--------------------------
	var parent = $('#stars_container')
	parent.RemoveAndDeleteChildren();
    var board = $.CreatePanel("Panel", parent, "stars_menu")
    board.BLoadLayoutSnippet("stars_main_page");
    parent.RemoveClass('stars_container_open')
    board.FindChildTraverse('player_name').text = 	Players.GetPlayerName( playerID)
    var playerInfo = Game.GetPlayerInfo( playerID );
    var steamID = playerInfo.player_steamid
    $.Msg(steamID)
    board.FindChildTraverse('player_avatar').steamid = steamID
    $.Msg(playerInfo)
    board.FindChildTraverse('total_stars_label').text = $.Localize("stars_menu")+": ★"+ grandTotalStars + "/"+MAX_STARS
    board.FindChildTraverse('close-button').SetPanelEvent('onactivate', function ClosePanel() {
		GameUI.CustomUIConfig().starsParent.AddClass('outLeftBig')
		GameUI.CustomUIConfig().starsOpen = false
		GameUI.CustomUIConfig().starsParent.RemoveClass('fromLeftBig')
		$.Schedule(0.26, function(){	
			GameUI.CustomUIConfig().starsParent.AddClass("invisible")
		});	
	})
    //------------BUTTONS------------------
	var availabileHeroArray = getHeroList();
	availabileHeroArray.push("solo_stars")
	var buttonContainer = board.FindChildTraverse('stars_buttons_container')
	var totalButtons = 0
	for (var i = 1; i <= mButtonRows; i++) {
		var newChildPanel = $.CreatePanel( "Panel", buttonContainer, "button_row"+i );
		newChildPanel.BLoadLayoutSnippet("stars_category_row")
	} 
	$.Msg(starData)
	var grandTotalStars = 0
	for (var i = 1; i < availabileHeroArray.length; i++) {
		var buttonRowIndex = Math.floor((i-1)/mButtonsPerRow) + 1
		var buttonParent = $.GetContextPanel().FindChildTraverse("button_row"+buttonRowIndex).FindChildTraverse('stars_category_row_container')
		var newChildPanel = $.CreatePanel( "Panel", buttonParent, "starsButton"+i );
		var mHeroName = availabileHeroArray[i]
		newChildPanel.BLoadLayoutSnippet("stars_category_button")
		if (i < availabileHeroArray.length - 1){
			newChildPanel.FindChildTraverse('stars_button_image').SetImage("file://{images}/heroes/" + mHeroName + ".png")
		}else{
			newChildPanel.FindChildTraverse('stars_button_image').SetImage("file://{images}/items/weapons/mountain_protector/mountain_protector_weapon_00.png")
		}
		totalButtons = totalButtons + 1
		$.Msg("------")
		$.Msg(mHeroName)
		var category = starData[i]
		setButtonEvents(newChildPanel, mHeroName, category)
		$.Msg(category)
		$.Msg("-------")
	}
}

function setButtonEvents(buttonParent, heroName, categoryData){
	buttonImage = buttonParent.FindChildTraverse('stars_button_image')
	buttonImage.SetPanelEvent('onactivate', function SelectDeathmatch() {
		setCategoryButtonFunction($('#stars_container'), heroName, buttonParent, categoryData)
	})
	buttonImage.SetPanelEvent('onmouseover', function buttonHover(){
		buttonMouseOver(buttonParent)
	})
	buttonImage.SetPanelEvent('onmouseout', function buttonHoverOut(){
		buttonMouseOut(buttonParent)
	})

}

function setCategoryButtonFunction(starsContainer, heroName, buttonParent, categoryData){
	$.Msg("BUTTON CLICK")
	$.Msg(starsContainer)
	starsContainer.AddClass('stars_container_open')
	var categoryStars = 0
	if (mActiveCategoryButton){
		mActiveCategoryButton.FindChildTraverse('stars_button_image_overlay').RemoveClass('invisible')
		mActiveCategoryButton.lock = false
	}
	buttonParent.FindChildTraverse('stars_button_image_overlay').AddClass('invisible')
	buttonParent.lock = true
	mActiveCategoryButton = buttonParent
	$.Msg("-----------")
	$.Msg(categoryData)

	starsContainer.FindChildTraverse('stars_details_meta_container').style.height = "580px"
	$.GetContextPanel().FindChildTraverse("stars_details_left_side").RemoveAndDeleteChildren()
	$.GetContextPanel().FindChildTraverse("stars_details_right_side").RemoveAndDeleteChildren()
	
	var herosStarsArray = false
	if (heroName == "solo_stars"){
		herosStarsArray = getSoloStarsArray(heroName)
	}else{
		herosStarsArray = getHeroStarsArray(heroName)
	}
	for (var i = 1; i <= herosStarsArray.length; i++) {
		var sidePanel = $.GetContextPanel().FindChildTraverse("stars_details_left_side")
		if (i > 7){
			sidePanel = $.GetContextPanel().FindChildTraverse("stars_details_right_side")
		}
		var newChildPanel = $.CreatePanel( "Panel", sidePanel, "starDetail"+i );
		newChildPanel.BLoadLayoutSnippet('stars_detail')
		$.Msg(heroName)
		if (heroName == "solo_stars"){
			$.Msg("solo_starsINSIDE")
			var starIcon = newChildPanel.FindChildTraverse('star_item_icon')
		    var starIcon2 = $.CreatePanel("Panel", starIcon, "dialogue_portrait_scene");
		    starIcon2.BLoadLayoutSnippet("image_icon");
			starIcon.FindChildTraverse('image_icon').SetImage("file://{images}/custom_game/ui/sword_icon_star.png")
		}else{
			var starIcon = newChildPanel.FindChildTraverse('star_item_icon')
		    var starIcon2 = $.CreatePanel("DOTAHeroImage", starIcon, "dialogue_portrait_scene");
		    starIcon2.AddClass("HeroButton");
		    starIcon2.heroname = heroName;
		    starIcon2.heroimagestyle = "icon";
		}

		newChildPanel.FindChildTraverse('stars_title').text = $.Localize(herosStarsArray[i-1])
		var starDescriptionData = getStarDescription(categoryData, herosStarsArray[i-1], heroName, 0)
		var starDescription = starDescriptionData[0]
		
		var origStarDescription = starDescription
		var starAmount = starDescriptionData[1]

		var stars_description_label = newChildPanel.FindChildTraverse('stars_description')
		stars_description_label.defaultText = starDescription
		stars_description_label.star_title = herosStarsArray[i-1]
		stars_description_label.heroName = heroName
		stars_description_label.text = stars_description_label.defaultText

		var visualStar1 = newChildPanel.FindChildTraverse('star1')
		var visualStar2 = newChildPanel.FindChildTraverse('star2')
		var visualStar3 = newChildPanel.FindChildTraverse('star3')
		var starColor1 = "#555555"
		var starColor2 = "#555555"
		var starColor3 = "#555555"
		if (starAmount >= 1){
			starColor1 = "#F4DC42"
		}
		if (starAmount >= 2){
			starColor2 = "#F4DC42"
		}
		if (starAmount >= 3){
			starColor3 = "#F4DC42"
		}
		visualStar1.text = "<font color='"+starColor1+"'>★</font>"	
		visualStar2.text = "<font color='"+starColor2+"'>★</font>"
		visualStar3.text = "<font color='"+starColor3+"'>★</font>"
		setStarMouseovers(visualStar1, visualStar2, visualStar3, stars_description_label)
		categoryStars = categoryStars + parseInt(starAmount)
		// "#F4DC42"
		$.Msg("STAR AMOUNT")
		$.Msg(categoryStars)			
		// newChildPanel.FindChildTraverse('stars_visual').text = "<font color='"+herosStarsArray[i-1][2]+"'>★</font><font color='"+herosStarsArray[i-1][3]+"'>★</font><font color='"+herosStarsArray[i-1][4]+"'>★</font>"
	}
	var categoryStarMax = 42
	if (heroName == "solo_stars"){
		categoryStarMax = 33
	}
	$.GetContextPanel().FindChildTraverse('stars_category_text').text = $.Localize(heroName)+" "+$.Localize("stars_menu")+": <font color='#F4DC42'>★"+categoryStars+"/"+categoryStarMax+"</font>"
}

function getStarDescription(categoryData, star_title, heroName, starOverride)
{
	var fontStart = "<font color='#85e5a3'>"
	var fontEnd = "</font>"
	var starDescription = ""
	var starAmount = 0
	if (heroName == "solo_stars"){
		heroName = "solo_stars_in_description"
		$.Msg(categoryData)
		$.Msg("HEJHEHEHE")
	}
	if (star_title == "stars_hero_level_title"){
		starDescription = $.Localize('stars_hero_level_description')
		starAmount = categoryData.power_up
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		starDescription = starDescription.replace("@heroname", localizeWithColor(heroName))
		if (starAmount == 0){
			starDescription = starDescription.replace("@level", fontStart+40+fontEnd)
		}else if (starAmount == 1){
			starDescription = starDescription.replace("@level", fontStart+80+fontEnd)
		}else if (starAmount >= 2){
			starDescription = starDescription.replace("@level", fontStart+120+fontEnd)
		}
	}else if (star_title == "autumn_mist_canyon"){
		starAmount = categoryData.autumnmist
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_basic").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_canyon_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_basic2").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_canyon_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_basic3_redfall").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_canyon_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}			
	}else if (star_title == "abandoned_shipyard"){
		starAmount = categoryData.shipyard
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_basic").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_shipyard_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_basic2").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_shipyard_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_basic3_redfall").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_shipyard_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}			
	}else if (star_title == "redfall_crimsyth_castle"){
		starAmount = categoryData.castle
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_basic").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_crimsyth_castle_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_basic2").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_crimsyth_castle_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_basic3_redfall").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("redfall_crimsyth_castle_boss")).replace("@map_name", $.Localize("zone_redfall"))
		}			
	}else if (star_title == "zone_tanari_wind_temple"){
		starAmount = categoryData.wind
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_basic").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("wind_temple_boss")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_basic2").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("wind_temple_boss")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_basic3_tanari").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("wind_temple_boss")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}			
	}else if (star_title == "zone_tanari_water_temple"){
		starAmount = categoryData.water
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_basic").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("water_temple_boss")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_basic2").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("water_temple_boss")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_basic3_tanari").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("water_temple_boss")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}			
	}else if (star_title == "zone_tanari_fire_temple"){
		starAmount = categoryData.fire
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_basic").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("fire_temple_neverlord_reborn")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_basic2").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("fire_temple_neverlord_reborn")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_basic3_tanari").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("fire_temple_neverlord_reborn")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}			
	}else if (star_title == "arena_left_leaderboard_title"){
		starAmount = categoryData.champleague
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_champions_league").replace("@heroname", localizeWithColor(heroName)).replace("@rank", fontStart+10+fontEnd)
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_champions_league").replace("@heroname", localizeWithColor(heroName)).replace("@rank", fontStart+5+fontEnd)
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_champions_league").replace("@heroname", localizeWithColor(heroName)).replace("@rank", fontStart+1+fontEnd)
		}			
	}else if (star_title == "tooltip_pit_of_trials"){
		starAmount = categoryData.pitoftrials
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_description_pit").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("arena_pit_of_trials_final_boss")).replace("@map_name", $.Localize("roshpit_arena")).replace("@level", fontStart+1+fontEnd)
		}else if (starAmount == 1){
			starDescription = $.Localize("star_description_pit").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("arena_pit_of_trials_final_boss")).replace("@map_name", $.Localize("roshpit_arena")).replace("@level", fontStart+4+fontEnd)
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_description_pit7").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("arena_pit_of_trials_final_boss")).replace("@map_name", $.Localize("roshpit_arena")).replace("@level", fontStart+7+fontEnd)
		}	
		$.Msg("PIT OF TRIALS WTF?")
		$.Msg(starDescription)		
	}else if (star_title == "immortal_weapon_title"){
		starAmount = categoryData.weapon
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("immortal_weapon_star_description").replace("@heroname", localizeWithColor(heroName))
		}else if (starAmount == 1){
			starDescription = $.Localize("immortal_weapon_star_description2").replace("@heroname", localizeWithColor(heroName)).replace("@level", fontStart+30+fontEnd)
		}else if (starAmount >= 2){
			starDescription = $.Localize("immortal_weapon_star_description2").replace("@heroname", localizeWithColor(heroName)).replace("@level", fontStart+40+fontEnd)
		}		
	}else if (star_title == "tanari_ancient_hero"){
		starAmount = categoryData.weapon
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_ancient_god_description1").replace("@heroname", localizeWithColor(heroName)).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_ancient_god_description2").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("tanari_ancient_hero")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_ancient_god_description3").replace("@heroname", localizeWithColor(heroName)).replace("@boss_name", localizeWithColor("tanari_ancient_hero")).replace("@map_name", $.Localize("world_tanari_jungle"))
		}	
	}else if (star_title == "star_serengaard_title"){
		starAmount = categoryData.serengaard
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_serengaard_description").replace("@heroname", localizeWithColor(heroName)).replace("@wave_number", localizeWithColor(20))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_serengaard_description2").replace("@heroname", localizeWithColor(heroName)).replace("@wave_number", localizeWithColor(30))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_serengaard_description3").replace("@heroname", localizeWithColor(heroName)).replace("@wave_number", localizeWithColor(30))
		}
	}else if (star_title == "star_serengaard_infinite_title"){
		starAmount = categoryData.serengaard_infinite
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_serengaard_infinite_description").replace("@heroname", localizeWithColor(heroName)).replace("@wave_number", localizeWithColor(10))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_serengaard_infinite_description").replace("@heroname", localizeWithColor(heroName)).replace("@wave_number", localizeWithColor(30))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_serengaard_infinite_description").replace("@heroname", localizeWithColor(heroName)).replace("@wave_number", localizeWithColor(60))
		}
	}else if (star_title == "star_valdun_title"){
		starAmount = categoryData.valdun
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_valdun_description").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("seafortress_final_boss")).replace("@mapname", $.Localize("rpc_sea_fortress"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_valdun_description2").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("seafortress_final_boss")).replace("@mapname", $.Localize("rpc_sea_fortress"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_valdun_description3").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("seafortress_final_boss")).replace("@mapname", $.Localize("rpc_sea_fortress"))
		}
	}else if (star_title == "star_azalea_title"){
		starAmount = categoryData.azalea
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_azalea_description").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("azalea_boss")).replace("@mapname", $.Localize("rpc_winterblight_mountain"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_azalea_description2").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("azalea_boss")).replace("@mapname", $.Localize("rpc_winterblight_mountain"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_azalea_description3").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("azalea_boss")).replace("@mapname", $.Localize("rpc_winterblight_mountain"))
		}
	}else if (star_title == "star_valdun_title_solo"){
		starAmount = categoryData.valdun
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("star_valdun_description1solo").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("seafortress_final_boss")).replace("@mapname", $.Localize("rpc_sea_fortress"))
		}else if (starAmount == 1){
			starDescription = $.Localize("star_valdun_description2solo").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("seafortress_final_boss")).replace("@mapname", $.Localize("rpc_sea_fortress"))
		}else if (starAmount >= 2){
			starDescription = $.Localize("star_valdun_description3solo").replace("@heroname", localizeWithColor(heroName)).replace("@bossname", localizeWithColor("seafortress_final_boss")).replace("@mapname", $.Localize("rpc_sea_fortress"))
		}
	}else if (star_title == "rpc_tutorial"){
		starAmount = categoryData.champleague
		if (starOverride > 0){
			starAmount = starOverride - 1
		}
		if (starAmount == 0){
			starDescription = $.Localize("tutorial_star_1")
		}else if (starAmount == 1){
			starDescription = $.Localize("tutorial_star_2")
		}else if (starAmount >= 2){
			starDescription = $.Localize("tutorial_star_3")
		}
	}									
	return [starDescription, starAmount]
}

function localizeWithColor(text)
{
	var fontStart = "<font color='#85e5a3'>"
	var fontEnd = "</font>"
	var newString = fontStart + $.Localize(text) + fontEnd
	return newString
}

function setStarMouseovers(visualStar1, visualStar2, visualStar3, stars_description_label)
{
	visualStar1.SetPanelEvent('onmouseover', function starHover(){
		starMouseOver(stars_description_label, 1)
	})	
	visualStar1.SetPanelEvent('onmouseout', function starHover(){
		starMouseOut(stars_description_label, 1)
	})	
	visualStar2.SetPanelEvent('onmouseover', function starHover(){
		starMouseOver(stars_description_label, 2)
	})	
	visualStar2.SetPanelEvent('onmouseout', function starHover(){
		starMouseOut(stars_description_label, 2)
	})	
	visualStar3.SetPanelEvent('onmouseover', function starHover(){
		starMouseOver(stars_description_label, 3)
	})	
	visualStar3.SetPanelEvent('onmouseout', function starHover(){
		starMouseOut(stars_description_label, 3)
	})	
}

function starMouseOver(stars_description_label, starOverride)
{
	$.Msg("MOUSEOVER STAR??")
	var starDescription = getStarDescription([], stars_description_label.star_title, stars_description_label.heroName, starOverride)[0]
	stars_description_label.text = starDescription
	// stars_description_label.AddClass('star_highlighted')
}

function starMouseOut(stars_description_label)
{
	stars_description_label.text = stars_description_label.defaultText
	// stars_description_label.RemoveClass('star_highlighted')
}

function buttonMouseOver(buttonParent){
	
	var overlay = buttonParent.FindChildTraverse('stars_button_image_overlay')
	overlay.AddClass('invisible')
}

function buttonMouseOut(buttonParent){
	if (!(buttonParent.lock)){
		var overlay = buttonParent.FindChildTraverse('stars_button_image_overlay')
		overlay.RemoveClass('invisible')
	}
}

function getHeroStarsArray(heroName){
	var newTable = ["stars_hero_level_title", "autumn_mist_canyon", "abandoned_shipyard", "redfall_crimsyth_castle", "zone_tanari_wind_temple", "zone_tanari_water_temple", "zone_tanari_fire_temple", "star_serengaard_title", "star_serengaard_infinite_title", "arena_left_leaderboard_title", "tooltip_pit_of_trials", "immortal_weapon_title", "star_valdun_title", "star_azalea_title"]
	return newTable
}

function getSoloStarsArray(heroName){
	var newTable = ["autumn_mist_canyon", "abandoned_shipyard", "redfall_crimsyth_castle", "zone_tanari_wind_temple", "zone_tanari_water_temple", "zone_tanari_fire_temple", "tooltip_pit_of_trials", "tanari_ancient_hero", "star_valdun_title_solo", "star_azalea_title", "rpc_tutorial"]
	return newTable
}

function convertStarNameToTitle(starName)
{
	var title = ""
	if (starName == "power_up"){
		title = "stars_hero_level_title"
	}else if(starName == "autumnmist"){
		title = "autumn_mist_canyon"
	}else if(starName == "shipyard"){
		title = "abandoned_shipyard"
	}else if(starName == "castle"){
		title = "redfall_crimsyth_castle"
	}else if(starName == "wind"){
		title = "zone_tanari_wind_temple"
	}else if(starName == "water"){
		title = "zone_tanari_water_temple"
	}else if(starName == "fire"){
		title = "zone_tanari_fire_temple"
	}else if(starName == "champleague"){
		title = "arena_left_leaderboard_title"
	}else if(starName == "pitoftrials"){
		title = "tooltip_pit_of_trials"
	}else if(starName == "weapon"){
		title = "immortal_weapon_title"
	}else if (starName == "serengaard"){
		title = "star_serengaard_title"
	}else if (starName == "serengaard_infinite"){
		title = "star_serengaard_infinite_title"	
	}else if (starName == "valdun"){
		title = "star_valdun_title"
	}else if (starName == "azalea"){
		title = "star_azalea_title"
	}
	return title
}

function starPopout(msg)
{
	var starAmount = msg.starAmount
	var starTitle = msg.starTitle
	var heroName = msg.heroName
	
	$.Msg(starTitle)
	starTitle = convertStarNameToTitle(starTitle)
	var parent = $('#star_popout_container')
	parent.RemoveAndDeleteChildren();
    var board = $.CreatePanel("Panel", parent, "stars_popout_created")
    board.BLoadLayoutSnippet("stars_detail");
    parent.RemoveClass('invisible')

    board.AddClass('fromLeft')

	if (heroName == "solo_stars"){
		$.Msg("solo_starsINSIDE")
		var starIcon = board.FindChildTraverse('star_item_icon')
	    var starIcon2 = $.CreatePanel("Panel", starIcon, "dialogue_portrait_scene");
	    starIcon2.BLoadLayoutSnippet("image_icon");
		starIcon.FindChildTraverse('image_icon').SetImage("file://{images}/custom_game/ui/sword_icon_star.png")
		if (starTitle == "immortal_weapon_title"){
			starTitle = "tanari_ancient_hero"
		}else if(starTitle == "arena_left_leaderboard_title"){
			starTitle = "rpc_tutorial"
		}
	}else{
		var starIcon = board.FindChildTraverse('star_item_icon')
	    var starIcon2 = $.CreatePanel("DOTAHeroImage", starIcon, "dialogue_portrait_scene");
	    starIcon2.AddClass("HeroButton");
	    starIcon2.heroname = heroName;
	    starIcon2.heroimagestyle = "icon";
	}

	board.FindChildTraverse('stars_title').text = $.Localize(starTitle)

	var starDescription = getStarDescription([], starTitle, heroName, starAmount)[0]
	
	var origStarDescription = starDescription

	var stars_description_label = board.FindChildTraverse('stars_description')
	stars_description_label.text = origStarDescription

	var visualStar1 = board.FindChildTraverse('star1')
	var visualStar2 = board.FindChildTraverse('star2')
	var visualStar3 = board.FindChildTraverse('star3')
	var starColor1 = "#555555"
	var starColor2 = "#555555"
	var starColor3 = "#555555"
	if (starAmount >= 1){
		starColor1 = "#F4DC42"
	}
	if (starAmount >= 2){
		starColor2 = "#F4DC42"
	}
	if (starAmount >= 3){
		starColor3 = "#F4DC42"
	}
	visualStar1.text = "<font color='"+starColor1+"'>★</font>"	
	visualStar2.text = "<font color='"+starColor2+"'>★</font>"
	visualStar3.text = "<font color='"+starColor3+"'>★</font>"
	Game.EmitSound("RPCItem.StarsEarned")
	if (starAmount == 3){
		Game.EmitSound("RPCItem.StarsEarnedAccent")
	}
    $.Schedule(8.0, function(){
    	try{
	        board.AddClass('outLeft')
	        $.Schedule(0.45, function(){
	        	parent.AddClass('invisible')
	    	}); 
	    }catch(err){

	    }
    }); 
	var playerID = Game.GetLocalPlayerID();
	var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
    board.SetPanelEvent('onactivate', function ActivatePopout() {
    	parent.RemoveAndDeleteChildren()
    	$.Msg("OPEN STARS MENU?")
		GameEvents.SendCustomGameEventToServer( "stars_menu", {playerID: playerID, heroIndex: heroIndex, openingPlayerID: Players.GetLocalPlayer()});
	})
}

(function()
{
	InitializeStarsMenu()
	GameEvents.Subscribe( "open_stars", openStarsFromServer)
	GameEvents.Subscribe( "star_popout", starPopout)
})();
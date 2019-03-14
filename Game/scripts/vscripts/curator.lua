if Curator == nil then
  Curator = class({})
end

function Curator:StopUnit(msg)
	local unit = EntIndexToHScript(msg.unitIndex)
	print("STOP UNIT!?")
	Timers:CreateTimer(0.03, function()
		unit:Stop()
	end)
end

function Curator:Curate(msg)
	local item = EntIndexToHScript(msg.item)
	local playerID = msg.playerID
	

	local hero = GameState:GetHeroByPlayerID(playerID)
	Quests:ShowDialogueText({hero}, Events.curator, "#curator_dialogue_2", 5, true)
	Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)
end

function Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)
	local player = PlayerResource:GetPlayer(playerID)
	if SaveLoad:GetAllowSaving() then
		CustomGameEventManager:Send_ServerToPlayer(player, "get_item_data_for_curator", {itemIndex = item:GetEntityIndex()} )
	end
end

function Curator:CurateALLBasicWeapons(playerID)
	local heroTable = HerosCustom:GetInternalNameTable()
	local weaponsSuffixTable = {"00", "01", "02", "03", "11", "12", "13", "14", "21", "22", "23", "24", "25"}
	for i = 1, #heroTable, 1 do
		for j = 1, #weaponsSuffixTable, 1 do
			Timers:CreateTimer((i-1)*15 + j, function()
				local weapon = Curator:RollBasicWeapon(heroTable[i], weaponsSuffixTable[j])
				Curator:GetItemInfoFromClientAndSendToWeb(weapon, playerID)
			end)
		end
	end
end

function Curator:CurateBasicWeapons(hero)
	local playerID = hero:GetPlayerOwnerID()
	local heroTable = HerosCustom:GetInternalNameTable()
	local weaponsSuffixTable = {"00", "01", "02", "03", "11", "12", "13", "14", "21", "22", "23", "24", "25"}
	local heroName = HerosCustom:GetInternalHeroName(hero:GetUnitName())
	for j = 1, #weaponsSuffixTable, 1 do
		Timers:CreateTimer(j, function()
			local weapon = Curator:RollBasicWeapon(heroName, weaponsSuffixTable[j])
			print(weapon:GetAbilityName())
			Curator:GetItemInfoFromClientAndSendToWeb(weapon, playerID)
		end)
	end

end

function Curator:CurateBasicEquipment(playerID)
	local xpBounty = 300
	local randomHelm = RandomInt(1, 3)
	local itemVariant = BASE_BOOT_TABLE[randomHelm]
    local item = RPCItems:CreateItem(itemVariant, nil, nil)
    local rarity = "uncommon"


    item.rarity = rarity
    local rarityValue = 2
    local itemName = BASE_BOOT_NAME_TABLE[randomHelm]
    item.slot = "feet"
    item.gear = true
    local prefix = ""
    local additional_prefix = ""
    local suffix = RPCItems:RollFootProperty1(item, xpBounty, randomHelm)
    if rarityValue >= 2 then
    	prefix = RPCItems:RollFootProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollFootProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	additional_prefix = RPCItems:RollFootProperty4(item, xpBounty)
    	itemName = additional_prefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Feet", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)
    --

   	local randomHelm = RandomInt(1, 3)
	local itemVariant = BASE_HEAD_TABLE[randomHelm]
    local item = RPCItems:CreateItem(itemVariant, nil, nil)

    item.rarity = rarity
    local rarityValue = 2
    local itemName = BASE_HEAD_NAME_TABLE[randomHelm]
    item.slot = "head"
    item.gear = true

    local prefix = ""
    local additional_prefix = ""
    local suffix = RPCItems:RollHoodProperty1(item, xpBounty, randomHelm)
    if rarityValue >= 2 then
    	prefix = RPCItems:RollHoodProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollHoodProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	additional_prefix = RPCItems:RollHoodProperty4(item, xpBounty)
    	itemName = additional_prefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Head", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)

    --

	local randomHelm = RandomInt(1, 3)
	local itemVariant = BASE_HAND_TABLE[randomHelm]
    local item = RPCItems:CreateItem(itemVariant, nil, nil)

    item.rarity = rarity
    local rarityValue = 2
    local itemName = BASE_HAND_NAME_TABLE[randomHelm]
    item.slot = "hands"
    item.gear = true
    local suffix = RPCItems:RollHandProperty1(item, xpBounty, randomHelm)
    local prefix = ""
    local additional_prefix = ""
    
    if rarityValue >= 2 then
    	prefix = RPCItems:RollHandProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollHandProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	additional_prefix = RPCItems:RollHandProperty4(item, xpBounty)
    	itemName = additional_prefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Hands", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)

    --

	local randomHelm = RandomInt(1, 3)
	local itemVariant = BASE_BODY_TABLE[randomHelm]
    local item = RPCItems:CreateItem(itemVariant, nil, nil)

    item.rarity = rarity
    local rarityValue = 2
    local itemName = BASE_BODY_NAME_TABLE[randomHelm]

    item.slot = "body"
    item.gear = true
    local prefix = ""
    local additional_prefix = ""
    local suffix = RPCItems:RollBodyProperty1(item, xpBounty, randomHelm)
    if rarityValue >= 2 then
    	prefix = RPCItems:RollBodyProperty2(item, xpBounty)
    else
    	prefix = ""
    end
    if rarityValue>=3 then
    	RPCItems:RollBodyProperty3(item, xpBounty)
    end
    if rarityValue>=4 then
    	additional_prefix = RPCItems:RollBodyProperty4(item, xpBounty)
    	itemName = additional_prefix.." "..itemName
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Body", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)
    --



	local randomHelm = RandomInt(1, 3)
	local itemVariant = BASE_AMULET_TABLE[randomHelm]
    local item = RPCItems:CreateItem(itemVariant, nil, nil)



    item.rarity = rarity
    local rarityValue = 2
    local itemName = BASE_AMULET_NAME_TABLE[randomHelm]
    local suffix = ""
    local prefix = ""
    item.slot = "amulet"
    item.gear = true
    local tier, value, propertyName = RPCItems:RollAmuletProperty1(item, xpBounty, randomHelm)
    if tier == 1 then
        suffix = SUFFIX_TIER_1_SKILL_TABLE[RandomInt(1, 5)]
    elseif tier == 2 then
        suffix = SUFFIX_TIER_2_SKILL_TABLE[RandomInt(1, 5)]
    elseif tier == 0 then
        suffix = propertyName
    end
    if tier > 0 then
        item.property1 = value
        item.property1name = propertyName
        RPCItems:SetPropertyValues(item, item.property1, "rune", "#7DFF12",  1)
    end

    if rarityValue >= 2 then
        local tier, value, propertyName = RPCItems:RollAmuletProperty2(item, xpBounty, randomHelm)
        if tier == 1 then
            prefix = PREFIX_TIER_1_SKILL_TABLE[RandomInt(1, 5)]
        elseif tier == 2 then
            prefix = PREFIX_TIER_2_SKILL_TABLE[RandomInt(1, 5)]
        elseif tier == 0 then
            prefix = propertyName
        end
        if tier > 0 then
            item.property2 = value
            item.property2name = propertyName
            RPCItems:SetPropertyValues(item, item.property2, "rune", "#7DFF12",  2)
        end
    end
    if rarityValue>=3 then
        local tier, value, propertyName = RPCItems:RollSkillProperty()
        if tier > 0 then
            item.property3 = value
            item.property3name = propertyName
            RPCItems:SetPropertyValues(item, item.property3, "rune", "#7DFF12",  3)
        end
    end
    if rarityValue>=4 then
        local tier, value, propertyName = RPCItems:RollSkillProperty()
        if tier > 0 then
            item.property4 = value
            item.property4name = propertyName
            RPCItems:SetPropertyValues(item, item.property4, "rune", "#7DFF12",  4)
        end
    end

    RPCItems:SetTableValues(item, itemName, false, "Slot: Trinket", RPCItems:GetRarityColor(rarity), rarity, prefix, suffix, RPCItems:GetRarityFactor(rarity))
    Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)
end

function Curator:GetWeaponRarityFromDigits(digits)
	if string.sub(digits, 1, 1) == "0" then
		return "uncommon"
	elseif string.sub(digits, 1, 1) == "1" then
		return "rare"
	elseif string.sub(digits, 1, 1) == "2" then
		return "mythical"
	end
end

function Curator:RollBasicWeapon(heroName, digits)
	
	local maxFactor = RPCItems:GetMaxFactor()

	local itemName = ""
	local internalName = heroName

	local basicHeroName = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(heroName)
	local rarity = Curator:GetWeaponRarityFromDigits(digits)
	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes(basicHeroName)


	local mainAttrRoll = RandomInt(1, 3)
	local propensity = (mainAttrRoll-2)*2

	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	if rarityFactor >= 3 then
		propensity = propensity + propensityTable[specialProperty1]
	end
	if rarityFactor >= 4 then
		while specialProperty1 == specialProperty2 do
			specialProperty2 = RandomInt(1, #propensityTable)
		end
		propensity = propensity + propensityTable[specialProperty2]
	end
	local digit2 = Weapons:GetDigit2(propensity, rarityFactor)
	local weaponIndexString = tostring(rarityFactor-2)

	local weaponName = "item_rpc_"..internalName.."_weapon_"..digits
	print(weaponName)
	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, Weapons:GetMaxWeaponLevel(), 0)

	if internalName == "conjuror" then
		local value = Weapons:GetDeviation(2000, 0)
	    weapon.property1 = value
	    weapon.property1name = "aspect_health"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_aspect_health", "#3D82CC",  1) 
	else
		local value = Weapons:GetDeviation(100, 0)
	    weapon.property1 = value
	    weapon.property1name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_bonus_attack_damage", "#343EC9",  1) 
	end
	if mainAttrRoll == 1 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif mainAttrRoll == 2 then
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	else
		local value = Weapons:GetDeviation(15, rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	end
	if rarityFactor >= 3 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty1], rarityFactor)
		weapon.property3 = value
		weapon.property3name = propertyTable[specialProperty1]
		RPCItems:SetPropertyValues(weapon, weapon.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)
	end
	if rarityFactor >= 4 then
		local value = Weapons:GetDeviation(baseValueTable[specialProperty2], rarityFactor)
		weapon.property4 = value
		weapon.property4name = propertyTable[specialProperty2]
		RPCItems:SetPropertyValues(weapon, weapon.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)
	end

    return weapon
end

function Curator:FinishGettingClientData(msg)
	local playerID = msg.playerID
	local item = EntIndexToHScript(msg.item)
	local language = msg.language
	local localizedItemName = Curator:urlencode(msg.localizedName)
	local itemTexture = msg.itemTexture

	DeepPrintTable(msg)
	DeepPrintTable(msg.property1)
	print(msg.property1["0"])
	if msg.property1 then
		if next(msg.property1) == nil then
			property1color = ""
			property1name = ""
			property1localized = ""
			property1special = ""
			property1specialLocalized = ""
			property1value = ""
		else
			property1color = msg.property1["0"]:gsub('#', "")
			property1name = item.property1name
			property1localized = Curator:urlencode(msg.property1["2"])
			property1special = msg.property1["3"]
			if type(property1special) == "table" then
				property1special = ""
			else
				-- DeepPrintTable(property1special)
				property1special = property1special:gsub('#', "")
			end
			property1specialLocalized = msg.property1["4"]
			if property1specialLocalized == "undefined" then
				property1specialLocalized = ""
			else
				property1specialLocalized = Curator:urlencode(property1specialLocalized)
			end
			property1value = item.property1
		end
	end
	if msg.property2 then
		if next(msg.property2) == nil then
			property2color = ""
			property2name = ""
			property2localized = ""
			property2special = ""
			property2specialLocalized = ""
			property2value = ""
		else
			property2color = msg.property2["0"]:gsub('#', "")
			property2name = item.property2name
			property2localized = Curator:urlencode(msg.property2["2"])
			property2special = msg.property2["3"]
			if type(property2special) == "table" then
				property2special = ""
			else
				property2special = property2special:gsub('#', "")
			end
			property2specialLocalized = msg.property2["4"]
			if property2specialLocalized == "undefined" then
				property2specialLocalized = ""
			else
				property2specialLocalized = Curator:urlencode(property2specialLocalized)
			end
			property2value = item.property2
		end
	end
	if msg.property3 then
		if next(msg.property3) == nil then
			property3color = ""
			property3name = ""
			property3localized = ""
			property3special = ""
			property3specialLocalized = ""
			property3value = ""
		else
			DeepPrintTable(msg.property3)
			property3color = msg.property3["0"]:gsub('#', "")
			property3name = item.property3name
			property3localized = Curator:urlencode(msg.property3["2"])
			property3special = msg.property3["3"]
			if type(property3special) == "table" then
				property3special = ""
			else
				property3special = property3special:gsub('#', "")
			end
			property3specialLocalized = msg.property3["4"]
			if property3specialLocalized == "undefined" then
				property3specialLocalized = ""
			else
				property3specialLocalized = Curator:urlencode(property3specialLocalized)
			end
			property3value =item.property3
		end
	end
	if msg.property4 then
		if next(msg.property4) == nil then
			property4color = ""
			property4name = ""
			property4localized = ""
			property4special = ""
			property4specialLocalized = ""
			property4value = ""
		else
			property4color = msg.property4["0"]:gsub('#', "")
			property4name = item.property4name
			property4localized = Curator:urlencode(msg.property4["2"])
			property4special = msg.property4["3"]
			if type(property4special) == "table" then
				property4special = ""
			else
				property4special = property4special:gsub('#', "")
			end
			property4specialLocalized = msg.property4["4"]
			print(property4specialLocalized)
			if property4specialLocalized == "undefined" then
				property4specialLocalized = ""
			else
				property4specialLocalized = Curator:urlencode(property4specialLocalized)
			end
			property4value = item.property4
		end
	end

	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/curatorItemSubmit?"
	url = url.."steam_id="..steamID	
	url = url.."&language="..language
	url = url.."&localizedItemName="..localizedItemName
	url = url.."&texture="..itemTexture
	url = url.."&item_variant="..item:GetAbilityName()
	url = url.."&rarity="..item.rarity
	url = url.."&equipSlot="..item.slot
	url = url.."&damageType="..item:GetAbilityDamageType()
	url = url.."&element1="..item:GetSpecialValueFor("element_one")
	url = url.."&element2="..item:GetSpecialValueFor("element_two")

	url = url.."&propertyColor1="..property1color
	url = url.."&propertyName1="..property1name
	url = url.."&propertyNameLocalized1="..property1localized
	url = url.."&propertySpecial1="..property1special
	url = url.."&propertySpecialLocalized1="..property1specialLocalized
	url = url.."&propertyValue1="..property1value

	url = url.."&propertyColor2="..property2color
	url = url.."&propertyName2="..property2name
	url = url.."&propertyNameLocalized2="..property2localized
	url = url.."&propertySpecial2="..property2special
	url = url.."&propertySpecialLocalized2="..property2specialLocalized
	url = url.."&propertyValue2="..property2value

	url = url.."&propertyColor3="..property3color
	url = url.."&propertyName3="..property3name
	url = url.."&propertyNameLocalized3="..property3localized
	url = url.."&propertySpecial3="..property3special
	url = url.."&propertySpecialLocalized3="..property3specialLocalized
	url = url.."&propertyValue3="..property3value

	url = url.."&propertyColor4="..property4color
	url = url.."&propertyName4="..property4name
	url = url.."&propertyNameLocalized4="..property4localized
	url = url.."&propertySpecial4="..property4special
	url = url.."&propertySpecialLocalized4="..property4specialLocalized
	url = url.."&propertyValue4="..property4value

	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			--SUCCESS
		else
			--FAIL
		end
	end )
end

function Curator:urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end
				
function Curator:GetItemInfoFromClientAndSendToWeb(item, playerID)
	local player = PlayerResource:GetPlayer(playerID)
	if SaveLoad:GetAllowSaving() then
		CustomGameEventManager:Send_ServerToPlayer(player, "get_item_data_for_curator", {itemIndex = item:GetEntityIndex()} )
	end
end

function Curator:CurateHero(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	print(player:GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(player, "get_hero_curator", {heroIndex = hero:GetEntityIndex(), runeUnit1 = hero.runeUnit:GetEntityIndex(), runeUnit2 = hero.runeUnit2:GetEntityIndex(), runeUnit3 = hero.runeUnit3:GetEntityIndex(), runeUnit4 = hero.runeUnit4:GetEntityIndex()} )
	for i = 0, 3, 1 do
		local delay = i*2 + 3
		Timers:CreateTimer(delay, function()
			Curator:CurateAbility(hero, i)
		end)
	end
end

function Curator:CurateALLGlyphs()
	local heroTable = HerosCustom:GetHeroNameTable()
	for i = 1, #heroTable, 1 do
		Timers:CreateTimer(i*20, function()
			Curator:CurateAllGlyphsForHero(heroTable[i])
		end)
	end
end

function Curator:CurateAllGlyphsForHero(heroName)
	local maxTiers = 1
	if heroName == "trapper" or heroName == "sorceress" or heroName == "axe" or heroName == "duskbringer" then
		maxTiers = 2
	end
	if heroName == "neutral" then
		maxTiers = 3
	end
	for j = 1, maxTiers, 1 do
		for i = 1, 7, 1 do
			Timers:CreateTimer(i*2, function()
				local variantName = "item_rpc_"..heroName.."_glyph_"..i.."_"..j
				print(variantName)
				local glyph = Glyphs:RollGlyphAll(variantName, Vector(0,0), 0)
				Curator:CurateGlyph(glyph, heroName)
			end)
		end
	end
	if not heroName == "neutral" then
		Timers:CreateTimer(16, function()
			local variantName = "item_rpc_"..heroName.."_glyph_5_a"
			local glyph = Glyphs:RollGlyphAll(variantName, Vector(0,0), 0)
			Curator:CurateGlyph(glyph, heroName)
		end)
	end
end

function Curator:CurateAllGlyphsForHeroWithTiers(heroName, tiers)
	for j = 1, tiers, 1 do
		for i = 1, 7, 1 do
			Timers:CreateTimer(i*2, function()
				local variantName = "item_rpc_"..heroName.."_glyph_"..i.."_"..j
				print(variantName)
				local glyph = Glyphs:RollGlyphAll(variantName, Vector(0,0), 0)
				Curator:CurateGlyph(glyph, heroName)
			end)
		end
	end
	Timers:CreateTimer(16, function()
		local variantName = "item_rpc_"..heroName.."_glyph_5_a"
		local glyph = Glyphs:RollGlyphAll(variantName, Vector(0,0), 0)
		Curator:CurateGlyph(glyph, heroName)
	end)
end

function Curator:CurateGlyph(glyph, heroName)
	local player = MAIN_HERO_TABLE[1]:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player, "get_glyph_curator", {heroName = heroName, glyphName = glyph:GetAbilityName(), glyphDescription = glyph:GetAbilityName().."_description", glyphIndex = glyph:GetEntityIndex()} )	
end

function Curator:ClientDataGlyph(msg)
	local playerID = msg.playerID
	local language = msg.language
	local localizedGlyphName = Curator:urlencode(msg.localizedName)
	local localizedGlyphDescription = Curator:urlencode(msg.localizedDescription) 
	local glyph = EntIndexToHScript(msg.glyphIndex)
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/curatorGlyphSubmit?"
	url = url.."steam_id="..steamID	
	url = url.."&language="..language
	url = url.."&item_variant="..glyph:GetAbilityName()
	url = url.."&localizedGlyphName="..localizedGlyphName
	url = url.."&localizedGlyphDescription="..localizedGlyphDescription
	url = url.."&reqLevel="..glyph.minLevel
	url = url.."&reqHero="..glyph.requiredHero
	url = url.."&rarity="..glyph.rarity
	url = url.."&glyphTexture="..msg.glyphTexture
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			--SUCCESS
		else
			--FAIL
		end
	end )
end

function Curator:CurateArcanaAbilities(hero)
	local available_arcanas = RPCItems:GetAvailableArcanaData(hero)
	for i = 1, #available_arcanas, 1 do
		Timers:CreateTimer(8*(i-1), function()
			Runes:EquipArcana(hero, available_arcanas[i][1])
			Timers:CreateTimer(2, function()
				local index = available_arcanas[i][2]
				local ability = hero:GetAbilityByIndex(index)
				if index == 3 then
					ability = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
				end
				local abilitySpecial = ability:GetAbilityKeyValues()["AbilitySpecial"]
				local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
				local rune1 = hero.runeUnit:GetAbilityByIndex(index)
				local rune2 = hero.runeUnit2:GetAbilityByIndex(index)
				local rune3 = hero.runeUnit3:GetAbilityByIndex(index)
				local rune4 = hero.runeUnit4:GetAbilityByIndex(index)

				local internalHeroName = HerosCustom:GetInternalHeroName(hero:GetUnitName())
				local item_reference = "item_rpc_"..internalHeroName.."_arcana"..available_arcanas[i][1]
				-- for _,kv in pairs(abilitySpecial) do
				-- 	DeepPrintTable(kv)
				-- end

				print("curate_ability")
				print(ability:GetEntityIndex())
				CustomGameEventManager:Send_ServerToPlayer(player, "get_ability_curator", {heroIndex = hero:GetEntityIndex(), abilityIndex = ability:GetEntityIndex(), abilitySpecial = abilitySpecial, rune1 = rune1:GetEntityIndex(), rune2 = rune2:GetEntityIndex(), rune3 = rune3:GetEntityIndex(), rune4 = rune4:GetEntityIndex(), abilitySlotIndex = index, arcanaIndex = index, item_reference = item_reference} )	
			end)
			Timers:CreateTimer(5, function()
				Runes:UnequipArcana(hero, available_arcanas[i][1])
			end)
		end)
	end
end

function Curator:CurateAbility(hero, index)
	local ability = hero:GetAbilityByIndex(index)
	if index == 3 then
		ability = hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
	end
	local abilitySpecial = ability:GetAbilityKeyValues()["AbilitySpecial"]
	local player = PlayerResource:GetPlayer(hero:GetPlayerOwnerID())
	local rune1 = hero.runeUnit:GetAbilityByIndex(index)
	local rune2 = hero.runeUnit2:GetAbilityByIndex(index)
	local rune3 = hero.runeUnit3:GetAbilityByIndex(index)
	local rune4 = hero.runeUnit4:GetAbilityByIndex(index)
	-- for _,kv in pairs(abilitySpecial) do
	-- 	DeepPrintTable(kv)
	-- end

	print("curate_ability")
	print(ability:GetEntityIndex())
	CustomGameEventManager:Send_ServerToPlayer(player, "get_ability_curator", {heroIndex = hero:GetEntityIndex(), abilityIndex = ability:GetEntityIndex(), abilitySpecial = abilitySpecial, rune1 = rune1:GetEntityIndex(), rune2 = rune2:GetEntityIndex(), rune3 = rune3:GetEntityIndex(), rune4 = rune4:GetEntityIndex(), abilitySlotIndex = index, arcanaIndex = -1, item_reference = ""} )	
end

function Curator:ClientDataAbility(msg)
	local playerID = msg.playerID
	local hero = EntIndexToHScript(msg.hero)
	local language = msg.language
	local ability = EntIndexToHScript(msg.ability)
	local abilityNameLocalized = Curator:urlencode(msg.abilityNameLocalized)
	local abilityDescription = Curator:urlencode(msg.abilityDescription)
	print(abilityDescription)
	local abilityTargetType = msg.abilityTargetType
	local abilityDamageType = msg.abilityDamageType

	local arcanaIndex = msg.arcanaIndex
-- [ability, abilityName, abilityTexture, abilityNameLocalized, abilityDescription, baseAbility, damageType, property1, property2, element1, element2, property1max, property2max, property1base, property2base]

	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/curatorAbilitySubmit?"
	url = url.."steam_id="..steamID
	url = url.."&language="..language
	url = url.."&heroName="..hero:GetUnitName()
	url = url.."&abilityNameInternal="..ability:GetAbilityName()
	url = url.."&abilityNameLocalized="..abilityNameLocalized
	url = url.."&abilityDescription="..abilityDescription
	url = url.."&abilityTexture="..Curator:urlencode(msg.abilityTexture)

	url = url.."&abilityTargetType="..abilityTargetType
	url = url.."&abilityDamageType="..abilityDamageType
	url = url.."&abilityIndex="..msg.abilityIndex
	url = url.."&arcanaIndex="..arcanaIndex
	url = url.."&item_reference="..msg.item_reference
	for i = 1, 4, 1 do
		local runeData = msg.runeData1
		if i == 2 then
			runeData = msg.runeData2
		elseif i == 3 then
			runeData = msg.runeData3
		elseif i == 4 then
			runeData = msg.runeData4
		end
		url = url.."&runeNameInternal"..i.."="..runeData["1"]
		url = url.."&runeTexture"..i.."="..Curator:urlencode(runeData["2"])
		url = url.."&runeNameLocalized"..i.."="..Curator:urlencode(runeData["3"])
		url = url.."&runeDescription"..i.."="..Curator:urlencode(runeData["4"])
		url = url.."&runeBaseAbility"..i.."="..runeData["5"]
		url = url.."&runeDamageType"..i.."="..runeData["6"]
		url = url.."&runePropertyOne"..i.."="..runeData["7"]*100
		url = url.."&runePropertyTwo"..i.."="..runeData["8"]*100
		url = url.."&elementOne"..i.."="..runeData["9"]
		url = url.."&elementTwo"..i.."="..runeData["10"]
		url = url.."&runePropertyOneMax"..i.."="..runeData["11"]*100
		url = url.."&runePropertyTwoMax"..i.."="..runeData["12"]*100
		url = url.."&runePropertyOneBase"..i.."="..runeData["13"]*100
		url = url.."&runePropertyTwoBase"..i.."="..runeData["14"]*100
		url = url.."&runePrefixOne"..i.."="..Curator:urlencode(runeData["15"])
		url = url.."&runePrefixTwo"..i.."="..Curator:urlencode(runeData["16"])
		url = url.."&runeSuffixOne"..i.."="..Curator:urlencode(runeData["17"])
		url = url.."&runeSuffixTwo"..i.."="..Curator:urlencode(runeData["18"])
	end
	local manaString = ""
	for i = 0, 6, 1 do
		
		local manaCost = ability:GetManaCost(i)
		if manaCost <= 0 and i == 1 then
			break
		end
		if i < 6 then
			manaString = manaString..manaCost.." / "
		else
			manaString = manaString..manaCost
			print("MANA STRING:")
			print(manaString)
			url = url.."&manaString="..Curator:urlencode(manaString)
		end
	end
	local cdString = ""
	local cdTable = {}
	for i = 0, 6, 1 do
		
		local cd = Curator:round(ability:GetCooldown(i), 1)
		if cd <= 0 and i == 1 then
			break
		end
		if i < 6 then
			if i > 1 then
				if cd == ability:GetCooldown(i-1) then
				else
					cdString= cdString..cd.." / "
				end
			else
				cdString= cdString..cd.." / "
			end
		else
			cdString= cdString..cd
			if ability:GetCooldown(1) == ability:GetCooldown(2) and ability:GetCooldown(2) == ability:GetCooldown(3) and ability:GetCooldown(3) == ability:GetCooldown(4) and ability:GetCooldown(4) == ability:GetCooldown(5) and ability:GetCooldown(5) == ability:GetCooldown(6) and ability:GetCooldown(6) == ability:GetCooldown(7) then
				cdString = cd
			end 
			print("CD STRING")
			print(cdString)
			url = url.."&cdString="..Curator:urlencode(cdString)
		end
	end
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			--SUCCESS
		else
			--FAIL
		end
	end )
    -- GameEvents.SendCustomGameEventToServer( "curateAbility", {hero: hero, playerID: Game.GetLocalPlayerID(), language: language, ability:ability, abilityNameLocalized: abilityNameLocalized,
    --     abilityDescription: abilityDescription, abilityTargetType: abilityTargetType, abilityDamageType: Abilities.GetAbilityDamageType( ability ), runeData1: runeData1,
    --     runeData2: runeData2, runeData3: runeData3, runeData4: runeData4} );
	
end

function Curator:round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function Curator:ClientDataHero(msg)
	local playerID = msg.playerID
	local hero = EntIndexToHScript(msg.hero)
	local language = msg.language
	local localizedHeroName = Curator:urlencode(msg.localizedName)
	local heroTexture = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")
	local internalName = hero:GetUnitName()



	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/curatorHeroSubmit?"
	url = url.."steam_id="..steamID	
	url = url.."&language="..language
	url = url.."&localizedHeroName="..localizedHeroName
	url = url.."&heroTexture="..heroTexture
	url = url.."&internalName="..internalName
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			--SUCCESS
		else
			--FAIL
		end
	end )
end

function Curator:FullCurateHero(hero)
    Curator:CurateHero(hero:GetPlayerOwnerID())
    -- Timers:CreateTimer(5, function()
    -- 	Curator:CurateBasicWeapons(hero)
    -- end)
    Timers:CreateTimer(10, function()
    	local internalName = HerosCustom:GetInternalHeroName(hero:GetUnitName())
    	local columns = Glyphs:GetAvailableColumnCount(internalName)
    	Curator:CurateAllGlyphsForHeroWithTiers(internalName, columns)
    end)
    Timers:CreateTimer(20, function()
        Curator:CurateArcanaAbilities(hero)
    end)
end

--ABILITIES 

--SOUL BANK 

function Curator:OpenSoulBank()
end

function Curator:CurateALLHeroes()
	local hero_table = HerosCustom:GetAvailableHerosTable()
	local playerID = MAIN_HERO_TABLE[1]:GetPlayerOwnerID()
	for i = 1, #hero_table, 1 do
		local delay = (i-1)*60 + 5
		Timers:CreateTimer(delay, function()
			PlayerResource:ReplaceHeroWith(playerID, hero_table[i], 0, 0)
			Timers:CreateTimer(1, function()
				local hero = GameState:GetHeroByPlayerID(playerID)
				print("Curating: "..hero:GetUnitName())
				Curator:FullCurateHero(hero)
			end)
		end)
	end
end
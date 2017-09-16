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

function Curator:FinishGettingClientData(msg)
	local playerID = msg.playerID
	local item = EntIndexToHScript(msg.item)
	local language = msg.language
	local localizedItemName = Curator:urlencode(msg.localizedName)
	local itemTexture = msg.itemTexture

	-- DeepPrintTable(msg)
	-- DeepPrintTable(msg.property1)
	-- print(msg.property1["0"])
	local property1color = msg.property1["0"]:gsub('#', "")
	local property1name = item.property1name
	local property1localized = Curator:urlencode(msg.property1["2"])
	local property1special = msg.property1["3"]
	if property1special == nil then
		property1special = ""
	else
		property1special = property1special:gsub('#', "")
	end
	local property1specialLocalized = msg.property1["4"]
	if property1specialLocalized == "undefined" then
		property1specialLocalized = ""
	else
		property1specialLocalized = Curator:urlencode(property1specialLocalized)
	end
	local property1value = item.property1

	local property2color = msg.property2["0"]:gsub('#', "")
	local property2name = item.property2name
	local property2localized = Curator:urlencode(msg.property2["2"])
	local property2special = msg.property2["3"]
	if type(property2special) == "table" then
		property2special = ""
	else
		property2special = property2special:gsub('#', "")
	end
	local property2specialLocalized = msg.property2["4"]
	if property2specialLocalized == "undefined" then
		property2specialLocalized = ""
	else
		property2specialLocalized = Curator:urlencode(property2specialLocalized)
	end
	local property2value = item.property2

	local property3color = msg.property3["0"]:gsub('#', "")
	local property3name = item.property3name
	local property3localized = Curator:urlencode(msg.property3["2"])
	local property3special = msg.property3["3"]
	if type(property3special) == "table" then
		property3special = ""
	else
		property3special = property3special:gsub('#', "")
	end
	local property3specialLocalized = msg.property3["4"]
	if property3specialLocalized == "undefined" then
		property3specialLocalized = ""
	else
		property3specialLocalized = Curator:urlencode(property3specialLocalized)
	end
	local property3value =item.property3

	local property4color = msg.property4["0"]:gsub('#', "")
	local property4name = item.property4name
	local property4localized = Curator:urlencode(msg.property4["2"])
	local property4special = msg.property4["3"]
	if type(property4special) == "table" then
		property4special = ""
	else
		property4special = property4special:gsub('#', "")
	end
	local property4specialLocalized = msg.property4["4"]
	print(property4specialLocalized)
	if property4specialLocalized == "undefined" then
		property4specialLocalized = ""
	else
		property4specialLocalized = Curator:urlencode(property4specialLocalized)
	end
	local property4value = item.property4

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
	for i = 1, 7, 1 do
		Timers:CreateTimer(i*2, function()
			local variantName = "item_rpc_"..heroName.."_glyph_"..i.."_1"
			print(variantName)
			local glyph = Glyphs:RollGlyphAll(variantName, Vector(0,0), 0)
			Curator:CurateGlyph(glyph, heroName)
		end)
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

function Curator:CurateAbility(hero, index)
	local ability = hero:GetAbilityByIndex(index)
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
	CustomGameEventManager:Send_ServerToPlayer(player, "get_ability_curator", {heroIndex = hero:GetEntityIndex(), abilityIndex = ability:GetEntityIndex(), abilitySpecial = abilitySpecial, rune1 = rune1:GetEntityIndex(), rune2 = rune2:GetEntityIndex(), rune3 = rune3:GetEntityIndex(), rune4 = rune4:GetEntityIndex(), abilitySlotIndex = index} )	
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

--ABILITIES 

--SOUL BANK 

function Curator:OpenSoulBank()
end
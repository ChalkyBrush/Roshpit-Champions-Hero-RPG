require('libraries/json')

if SaveLoad == nil then
  SaveLoad = class({})
end

SaveLoad.KeyVersion = "1"

function SaveLoad:GetKey()
	if Beacons.cheats then
		return false
	end
	if SaveLoad:GetAllowSaving() then
		Timers:CreateTimer(2, function()
			if SaveLoad.key2 then
				if not SaveLoad.key1 then
					local url = ROSHPIT_URL.."/champions/key?"
					url = url.."param1="..0
					url = url.."&secret_key="..SaveLoad.key2
					CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
						if result.StatusCode == 200 then
							SaveLoad.key1 = result.Body
							CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {} )
							-- SaveLoad:ProcessKey()
						else

						end
					end )
					return 30
				else
					if SaveLoad:GetAllowSaving() then
						CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {} )
					end
				end
			else
				return 10
			end
		end)
	end

end

function SaveLoad:NewKey()
	-- if Beacons.cheats then
	-- 	return false
	-- end
	-- local url = ROSHPIT_URL.."/champions/key?"
	-- url = url.."param1="..0
	-- url = url.."&secret_key="..SaveLoad.key2
	-- CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
	-- 	if result.StatusCode == 200 then
	-- 		SaveLoad.key1 = result.Body
	-- 		if SaveLoad:GetAllowSaving() then
	-- 			CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {} )
	-- 		end
	-- 		-- SaveLoad:ProcessKey()
	-- 	end
	-- end )
end

-- function SaveLoad:KeyDebug()
-- 	local url = ROSHPIT_URL.."/champions/protection_test?"
-- 	url = url.."key1="..SaveLoad.key1
-- 	url = url.."&key2="..SaveLoad.key2
-- 	CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
-- 		local resultTable = {}
-- 		local resultTable = JSON:decode(result.Body)
-- 	end )
-- end

function SaveLoad:ProcessKey()
	-- CustomGameEventManager:Send_ServerToAllClients("process_key", {key = SaveLoad.key1, special_id = SaveLoad.special_id} )
end

function SaveLoad:ProcessedKey(msg)
	SaveLoad.key2 = msg.number
	if SaveLoad:GetAllowSaving() and alert then
		CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {} )
	end
end

function SaveLoad:GetPlayerCharacters(msg)
		local playerID = msg.playerID
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		-- steamID = 118352521
		local player = PlayerResource:GetPlayer(playerID)
		local token = "1337"
		local saveOrLoad = msg.saveOrLoad
		local hero = GameState:GetHeroByPlayerID(playerID)
		local url = ROSHPIT_URL.."/champions/getPlayerCharacters?"
		url = url.."steam_id="..steamID
		CreateHTTPRequestScriptVM("GET", url ):Send( function( result )
			if result.StatusCode == 200 then
				local resultTable = {}
				print( "GET response:\n" )
				for k,v in pairs( result ) do
					print( string.format( "%s : %s\n", k, v ) )
				end
				print( "Done." )
				local resultTable = JSON:decode(result.Body)
				SaveLoad:GetCharacterDataFromJSON(resultTable)
				local premium = 0
				if GameState:GetPlayerPremiumStatus(playerID) then
					premium = 1
				end
				if saveOrLoad == "save" then
					CustomGameEventManager:Send_ServerToPlayer(player, "save_characters_loaded", {result=resultTable, message="collapse", heroSlot=hero.saveSlot, premium=premium, currentLevel = GameState:GetHeroByPlayerID(playerID):GetLevel()} )
				else
					CustomGameEventManager:Send_ServerToPlayer(player, "load_characters_loaded", {result=resultTable, message="collapse", premium=premium} )
				end
			else
				CustomGameEventManager:Send_ServerToPlayer(player, "load_characters_loaded_fail", {} )
			end
		end )
end

function SaveLoad:GetCharacterDataFromJSON(resultTable)
	local characters = {}
	local MAX_SAVE_SLOTS = 36
	for i = 1, MAX_SAVE_SLOTS, 1 do
		characters[i] = {}
	end
	for i = 1, MAX_SAVE_SLOTS, 1 do
		if resultTable[i] then
			local slot = resultTable[i].save_slot
			print(slot)
			characters[slot].heroName = resultTable[i].hero_name
			characters[slot].level = resultTable[i].hero_level
		end
	end
	for i = 1, MAX_SAVE_SLOTS, 1 do
		if not characters[i].heroName then
			characters[i].heroName = "empty"
		end
	end
	resultTable.characters = characters
	
	return resultTable
end

function SaveLoad:GetAllowSaving()
	local developer = Convars:GetBool("developer")
	local cheats = Convars:GetBool("sv_cheats")
	if Beacons.cheats then
		return true
	end
	if GameRules:IsCheatMode() then
		return false
	end
	if not cheats and not developer and not GameState.cheats then
		return true
	else
		return false
	end
end

function SaveLoad:SaveCharacter(msg)
	local playerID = msg.playerID
	local slot = msg.slot
	local hero = EntIndexToHScript(msg.heroIndex)
	hero.saveSlot = slot
	local developer = Convars:GetBool("developer")
	local player = PlayerResource:GetPlayer(playerID)
	local cheats = Convars:GetBool("sv_cheats")
	local player_stats = CustomNetTables:GetTableValue("player_stats", tostring(playerID))
	local current_rune_points = player_stats.runePoints
	local current_skill_points = player_stats.skillPoints
	local runeUnit1 = hero.runeUnit
	local runeUnit2 = hero.runeUnit2
	local runeUnit3 = hero.runeUnit3
	local runeUnit4 = hero.runeUnit4
	hero.loadEnabled = 0
	Weapons:ValidateGear(hero)
	SaveLoad:NewKey()
	if SaveLoad:GetAllowSaving() then
		local url = ROSHPIT_URL.."/champions/saveCharacter?"
		url = url.."slot="..slot
		url = url.."&hero_name="..hero:GetUnitName()
		url = url.."&level="..hero:GetLevel()
		url = url.."&steam_id="..PlayerResource:GetSteamAccountID(playerID)
		url = url.."&current_xp="..hero:GetCurrentXP()
		url = url.."&rune_a_a="..runeUnit1:GetAbilityByIndex(0):GetLevel()
		url = url.."&rune_a_b="..runeUnit1:GetAbilityByIndex(1):GetLevel()
		url = url.."&rune_a_c="..runeUnit1:GetAbilityByIndex(2):GetLevel()
		url = url.."&rune_a_d="..runeUnit1:GetAbilityByIndex(3):GetLevel()
		url = url.."&rune_b_a="..runeUnit2:GetAbilityByIndex(0):GetLevel()
		url = url.."&rune_b_b="..runeUnit2:GetAbilityByIndex(1):GetLevel()
		url = url.."&rune_b_c="..runeUnit2:GetAbilityByIndex(2):GetLevel()
		url = url.."&rune_b_d="..runeUnit2:GetAbilityByIndex(3):GetLevel()
		url = url.."&rune_c_a="..runeUnit3:GetAbilityByIndex(0):GetLevel()
		url = url.."&rune_c_b="..runeUnit3:GetAbilityByIndex(1):GetLevel()
		url = url.."&rune_c_c="..runeUnit3:GetAbilityByIndex(2):GetLevel()
		url = url.."&rune_c_d="..runeUnit3:GetAbilityByIndex(3):GetLevel()
		url = url.."&rune_d_a="..runeUnit4:GetAbilityByIndex(0):GetLevel()
		url = url.."&rune_d_b="..runeUnit4:GetAbilityByIndex(1):GetLevel()
		url = url.."&rune_d_c="..runeUnit4:GetAbilityByIndex(2):GetLevel()
		url = url.."&rune_d_d="..runeUnit4:GetAbilityByIndex(3):GetLevel()
		url = url.."&ability1level="..hero:GetAbilityByIndex(0):GetLevel()
		url = url.."&ability2level="..hero:GetAbilityByIndex(1):GetLevel()
		url = url.."&ability3level="..hero:GetAbilityByIndex(2):GetLevel()
		url = url.."&ability4level="..hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT):GetLevel()
		url = url.."&ability_points="..current_skill_points
		url = url.."&rune_points="..current_rune_points
		url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
		-- if GameState:IsWorld1() then
			url = SaveLoad:AttachPortalKeysToUrl(url, hero)
		-- end
		url = SaveLoad:AttachGlyphsToUrl(url, hero)
		for i = 0, 5, 1 do
			url = SaveLoad:AttachItemToURL(url, hero, 0, 0, playerID, i, 0)
		end
		CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
			print( "POST response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			SaveLoad:NewKey()
			local resultTable = JSON:decode(result.Body)
			-- SaveLoad:GetCharacterDataFromJSON(resultTable)
			CustomGameEventManager:Send_ServerToPlayer(player, "recentlySaved", {} )
			local premium = 0
			if GameState:GetPlayerPremiumStatus(playerID) then
				premium = 1
			end
			Weapons:ValidateGear(hero)
			CustomGameEventManager:Send_ServerToPlayer(player, "save_characters_loaded", {result=resultTable, message="save_success", heroSlot=hero.saveSlot, premium=premium} )
			Events:TutorialServerEvent(hero, "2_3", 0)
			Statistics.dispatch('hero:oracle:save')
			hero.roshpitID = resultTable.id
			if hero:GetUnitName() == "npc_dota_hero_arc_warden" then
				SaveLoad:SaveJex(hero)
			end
		end )
	end	
end

function escape(s)
    return string.gsub(s, "([^A-Za-z0-9_])", function(c)
        return string.format("%%%02x", string.byte(c))
    end)
end

function SaveLoad:AttachGlyphsToUrl(url, hero)
	local glyph = CustomNetTables:GetTableValue("skill_tree", tostring(hero:GetPlayerOwnerID()).."-glyph-"..tostring(1))
	if glyph.glyphIndex > 0 then
		glyph = EntIndexToHScript(glyph.glyphIndex)
		url = url.."&glyph_a="..glyph:GetAbilityName()
	else
		url = url.."&glyph_a=".."empty"
	end
	glyph = CustomNetTables:GetTableValue("skill_tree", tostring(hero:GetPlayerOwnerID()).."-glyph-"..tostring(2))
	if glyph.glyphIndex > 0 then
		glyph = EntIndexToHScript(glyph.glyphIndex)
		url = url.."&glyph_b="..glyph:GetAbilityName()
	else
		url = url.."&glyph_b=".."empty"
	end
	glyph = CustomNetTables:GetTableValue("skill_tree", tostring(hero:GetPlayerOwnerID()).."-glyph-"..tostring(3))
	if glyph.glyphIndex > 0 then
		glyph = EntIndexToHScript(glyph.glyphIndex)
		url = url.."&glyph_c="..glyph:GetAbilityName()
	else
		url = url.."&glyph_c=".."empty"
	end
	return url
end

function SaveLoad:AttachPortalKeysToUrl(url, hero)
	local normalKeys = CustomNetTables:GetTableValue("portal_keys", tostring(hero:GetEntityIndex()).."-"..1)
	local eliteKeys = CustomNetTables:GetTableValue("portal_keys", tostring(hero:GetEntityIndex()).."-"..2)
	local legendKeys = CustomNetTables:GetTableValue("portal_keys", tostring(hero:GetEntityIndex()).."-"..3)
	url = url.."&portal1normal="..normalKeys.forest
	url = url.."&portal2normal="..normalKeys.desert
	url = url.."&portal3normal="..normalKeys.mines
	url = url.."&portal1elite="..eliteKeys.forest
	url = url.."&portal2elite="..eliteKeys.desert
	url = url.."&portal3elite="..eliteKeys.mines
	url = url.."&portal1legend="..legendKeys.forest
	url = url.."&portal2legend="..legendKeys.desert
	url = url.."&portal3legend="..legendKeys.mines
	return url
end

function SaveLoad:DebugGear(playerID)
	for i = 0, 5, 1 do
		local gearTable = CustomNetTables:GetTableValue("equipment", tostring(playerID).."-"..tostring(i))
		DeepPrintTable(gearTable)
	end
end

function SaveLoad:AttachItemToURL(url, hero, is_stash, stash_slot, playerID, gearSlot, itemIndex)

	gearSlot = tostring(gearSlot)
	local gearTable = CustomNetTables:GetTableValue("equipment", tostring(playerID).."-"..gearSlot)
	local itemTable = false
	if gearTable and is_stash == 0 then
		itemIndex = gearTable.itemIndex
		itemTable = CustomNetTables:GetTableValue("item_basics", tostring(itemIndex))
		-- DeepPrintTable(itemTable)
	end
	if itemIndex < 0 then
		url = url.."&build_number"..gearSlot.."="..0
		url = url.."&item_slot"..gearSlot.."="..gearSlot
		return url
	end
	if itemIndex > 0 then
		itemTable = CustomNetTables:GetTableValue("item_basics", tostring(itemIndex))
		print("ITEM TABLE??")
		print(itemIndex)
		-- DeepPrintTable(itemTable)
	end
	local item = EntIndexToHScript(itemIndex)
	if not item then
		url = url.."&build_number"..gearSlot.."="..0
		url = url.."&item_slot"..gearSlot.."="..gearSlot
		return url
	end
	if item.cantStash then
		Notifications:Top(playerID, {text="Can't stash this item", duration=2, style={color="red"}, continue=true})
		return url
	end
	local validatorTable = CustomNetTables:GetTableValue("item_basics", tostring(itemIndex).."-key")
	if validatorTable then
		url = url.."&validator"..gearSlot.."="..validatorTable.key
	end
	if itemTable and item.property1 and not item.glyph and not item.consumable then
		-- local itemName = string.gsub(itemTable.itemName, "%s+", '%%20')
		local itemName = escape(itemTable.itemName)
		local internalMinLevel = math.max(item.minLevel+RPCItems:GetPrereductionMinLevel(item), 1)
		local buildNumber = "1"
		if item.glyphBook then
			buildNumber = "-2"
		end
		url = url.."&build_number"..gearSlot.."="..buildNumber
		url = url.."&is_stash"..gearSlot.."="..is_stash
		url = url.."&stash_slot"..gearSlot.."="..stash_slot
		url = url.."&item_variant"..gearSlot.."="..item:GetAbilityName()
		url = url.."&item_name"..gearSlot.."="..itemName
		-- url = url.."&item_description"..gearSlot.."="..itemTable.itemDescription
		url = url.."&rarity"..gearSlot.."="..itemTable.rarityFactor
		url = url.."&item_slot"..gearSlot.."="..RPCItems:getGearSlot(item.slot)
		url = url.."&min_level"..gearSlot.."="..internalMinLevel
		url = url.."&prefix"..gearSlot.."="..escape(itemTable.itemPrefix)
		url = url.."&suffix"..gearSlot.."="..escape(itemTable.itemSuffix)
		if item.slot == "weapon" then
			url = url.."&is_weapon=".."1"
			url = url.."&weapon_xp="..item.xp
			url = url.."&item_level="..item.level
			url = url.."&max_level1="..item.maxLevel
			url = url.."&required_hero1="..item.requiredHero
		else
			url = url.."&is_weapon=".."0"
			if item.requiredHero then
				if is_stash == 1 then
					url = url.."&required_hero1="..item.requiredHero
				else
					url = url.."&required_hero"..gearSlot.."="..item.requiredHero
				end
			else
				url = url.."&required_hero"..gearSlot.."="..0
			end
		end
		-- if item.level then
		-- 	url = url.."&item_level="..item.level
		-- else
		-- 	url = url.."&item_level=".."0"
		-- end
		local affixCount = itemTable.rarityFactor
		if affixCount > 4 then
			affixCount = 4
		end
		for i = 1, affixCount, 1 do
			local affixTable = CustomNetTables:GetTableValue("item_properties", tostring(item:GetEntityIndex()).."-"..tostring(i))
			-- DeepPrintTable(affixTable)
			local property = 0
			local propertyName = ""
			if i == 1 then
				property = item.property1
				propertyName = item.property1name
			elseif i == 2 then
				property = item.property2
				propertyName = item.property2name
			elseif i == 3 then
				property = item.property3
				propertyName = item.property3name
			elseif i == 4 then
				property = item.property4
				propertyName = item.property4name
			end
			if not property then
				property = 0
			end
			if not propertyName then
				propertyName = ""
			end
			url = url.."&property"..i..gearSlot.."="..property
			url = url.."&property"..i.."name"..gearSlot.."="..propertyName
			url = url.."&property"..i.."color"..gearSlot.."="..escape(affixTable.propertyColor)
			url = url.."&property"..i.."tooltip"..gearSlot.."="..escape(affixTable.propertyName)
			if affixTable.specialDescription then
				url = url.."&property"..i.."special"..gearSlot.."="..escape(affixTable.specialDescription)
			end
		end
		-- url = url.."&min_level"..gearSlot.."="..itemTable.minLevel
	elseif item.stashable then
		local itemName = escape(itemTable.itemName)
		url = url.."&build_number"..gearSlot.."=".."-1"
		url = url.."&is_stash"..gearSlot.."="..is_stash
		url = url.."&stash_slot"..gearSlot.."="..stash_slot
		url = url.."&item_variant"..gearSlot.."="..item:GetAbilityName()
		url = url.."&item_name"..gearSlot.."="..itemName
		-- url = url.."&item_description"..gearSlot.."="..itemTable.itemDescription
		url = url.."&rarity"..gearSlot.."="..itemTable.rarityFactor
		url = url.."&item_slot"..gearSlot.."="..RPCItems:getGearSlot(item.slot)
		url = url.."&min_level"..gearSlot.."="..0
		url = url.."&prefix"..gearSlot.."="..escape(itemTable.itemPrefix)
		url = url.."&suffix"..gearSlot.."="..escape(itemTable.itemSuffix)
		local affixCount = 0
		print("TU78A")
		if item:GetAbilityName() == "item_rpc_web_premium_token" or string.match(item:GetAbilityName(), "galactic_arcana_cache") then
			print("TU78B")
			local affixCount = 1
			for i = 1, affixCount, 1 do
				local affixTable = CustomNetTables:GetTableValue("item_properties", tostring(item:GetEntityIndex()).."-"..tostring(i))
				-- DeepPrintTable(affixTable)
				local property = 0
				local propertyName = ""
				if i == 1 then
					property = item.property1
					propertyName = item.property1name
				elseif i == 2 then
					property = item.property2
					propertyName = item.property2name
				elseif i == 3 then
					property = item.property3
					propertyName = item.property3name
				elseif i == 4 then
					property = item.property4
					propertyName = item.property4name
				end
				if not property then
					property = 0
				end
				if not propertyName then
					propertyName = ""
				end
				url = url.."&property"..i..gearSlot.."="..property
				url = url.."&property"..i.."name"..gearSlot.."="..propertyName
				url = url.."&property"..i.."color"..gearSlot.."="..escape(affixTable.propertyColor)
				url = url.."&property"..i.."tooltip"..gearSlot.."="..escape(affixTable.propertyName)
				print("----TU78C-----")
				print(affixTable)
				print("--------------")
				if affixTable.specialDescription then
					url = url.."&property"..i.."special"..gearSlot.."="..escape(affixTable.specialDescription)
				end
			end
		end
	elseif item.glyph then
		local itemName = item:GetAbilityName()
		url = url.."&build_number"..gearSlot.."=".."-1"
		url = url.."&is_stash"..gearSlot.."="..is_stash
		url = url.."&stash_slot"..gearSlot.."="..stash_slot
		url = url.."&item_variant"..gearSlot.."="..item:GetAbilityName()
		url = url.."&item_name"..gearSlot.."=".."glyph"	
	else
		url = url.."&build_number"..gearSlot.."="..0
		url = url.."&item_slot"..gearSlot.."="..gearSlot

	end

	return url
-- :championcharacter_id, :build_number, :is_stash, :stash_slot, :steam_id, :item_variant, :item_name, :rarity, :item_slot, :level, :current_xp, :property1, :property1value, :property1color, 
-- :property1tooltip, :property1special, :property2, :property2value, :property2color, :property2tooltip, :property2special, :property3, 
-- :property3value, :property3color, :property3tooltip, :property3special, :property4, :property4value, :property4color, :property4tooltip, :property4special, :min_level
end

 -- {itemName = itemName, consumable = consumableBoolean, itemDescription = description, qualityColor = qualityColor, qualityName = qualityName, itemPrefix = prefix, itemSuffix = suffix, rarityFactor = rarityFactor } )

function SaveLoad:LoadCharacter(msg)
	local playerID = msg.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	hero.loadEnabled = 0
	hero.loading = true
	local slot = msg.slot
	local url = ROSHPIT_URL.."/champions/loadCharacter?"
	url = url.."steam_id="..steamID
	url = url.."&slot="..slot
	CreateHTTPRequestScriptVM("GET", url ):Send( function( result )
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		-- DeepPrintTable(resultTable)
		SaveLoad:ApplyDataToHero(resultTable.character, playerID)
		for i = 1, 6, 1 do
			Timers:CreateTimer(0.5+(0.5*i), function()
				SaveLoad:LoadGear(resultTable.gear[i], playerID, 1)
			end)
		end
		Timers:CreateTimer(1, function()
			SaveLoad:LoadGlyphs(resultTable.character, hero)
		end)
		Timers:CreateTimer(3, function()
			SaveLoad:LoadPortalKeys(resultTable.character, hero)
		end)
		CustomGameEventManager:Send_ServerToPlayer(player, "close_oracle", {} )
		if GameState:IsRPCArena() then
			Arena:LoadChampionsLeagueData(hero, nil)
		end
		Timers:CreateTimer(5, function()
			Statistics.dispatch('hero:oracle:load')
		end)
		player.hero_loading = false
		hero.loading = false
	end )
end

function SaveLoad:LoadGlyphs(character, hero)
	if character.glyph_a == "" or character.glyph_a == "empty" then
	else
		local glyph = Glyphs:RollGlyphAll(character.glyph_a, Vector(0, 0), -1)
		Glyphs:ApplyGlyph(hero, 1, glyph:GetEntityIndex())
	end
	if character.glyph_b == "" or character.glyph_b == "empty" then
	else
		local glyph = Glyphs:RollGlyphAll(character.glyph_b, Vector(0, 0), -1)
		Glyphs:ApplyGlyph(hero, 2, glyph:GetEntityIndex())
	end
	if character.glyph_c == "" or character.glyph_c == "empty" then
	else
		local glyph = Glyphs:RollGlyphAll(character.glyph_c, Vector(0, 0), -1)
		Glyphs:ApplyGlyph(hero, 3, glyph:GetEntityIndex())
	end
end

function SaveLoad:LoadPortalKeys(character, hero)
	local heroIndex = hero:GetEntityIndex()
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."1", {forest = character.portal1normal, desert = character.portal2normal, mines = character.portal3normal} )
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."2", {forest = character.portal1elite, desert = character.portal2elite, mines = character.portal3elite} )
    CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex).."-".."3", {forest = character.portal1legend, desert = character.portal2legend, mines = character.portal3legend} )
	if GameState:IsWorld1() then    
	    Beacons:ActivatePortalsForKeys()
	    CustomGameEventManager:Send_ServerToAllClients("update_key_display", {} )
	end
end

function SaveLoad:LoadGear(gearTable, playerID, bEquip)
	local hero = GameState:GetHeroByPlayerID(playerID)
	if not gearTable then
		return false
	end
	if not gearTable.item_variant then
		return false
	end
	DeepPrintTable(gearTable)
	if gearTable.build_number > -1 then
		local gearSlot = RPCItems:GetGearSlotName(gearTable.item_slot)
		print("LOADED ITEM GEARSLOT")
		-- print(gearSlot)
		-- DeepPrintTable(gearTable)
		local item = nil
		if gearTable.is_weapon == 1 then
			item = Weapons:CreateWeaponVariant(gearTable.item_variant, RPCItems:GetRarityNameFromFactor(gearTable.rarity), gearTable.item_name, gearSlot, true, "Slot: "..gearSlot:gsub("^%l", string.upper), gearTable.required_hero, gearTable.max_level, gearTable.min_level)
		else
			if gearTable.rarity == 6 then
				print("ARCANA ADD REQUIRED HERO!")
				print(gearTable)
				print(gearTable.required_hero)
				item = RPCItems:CreateVariantArcana(gearTable.item_variant, RPCItems:GetRarityNameFromFactor(gearTable.rarity), gearTable.item_name, gearSlot, true, "Slot: "..gearSlot:gsub("^%l", string.upper), tostring(gearTable.required_hero), gearTable.min_level)
				print(item.requiredHero)
			else
				item = RPCItems:CreateVariantWithMin(gearTable.item_variant, RPCItems:GetRarityNameFromFactor(gearTable.rarity), gearTable.item_name, gearSlot, true, "Slot: "..gearSlot:gsub("^%l", string.upper), gearTable.min_level, gearTable.prefix, gearTable.suffix)
			end
		end
		item.slot = gearSlot
		item.hasRunePoints = true
		item.pickedUp = true
		gearTable.property1name = SaveLoad:FixLoadedRuneProperties(gearTable.property1name)
		gearTable.property2name = SaveLoad:FixLoadedRuneProperties(gearTable.property2name)
		gearTable.property3name = SaveLoad:FixLoadedRuneProperties(gearTable.property3name)
		gearTable.property4name = SaveLoad:FixLoadedRuneProperties(gearTable.property4name)
		--PROPERTY1
		item.property1 = gearTable.property1
		item.property1name = gearTable.property1name

		if gearTable.property1special then
			local tooltipValue = "★"
			if gearTable.property1 > 1 then
				tooltipValue = gearTable.property1
			end
			if string.match(gearTable.property1name, "rune_") then
				gearTable.property1tooltip = gearTable.property1name
			end
			RPCItems:SetPropertyValuesSpecial(item, tooltipValue, gearTable.property1tooltip, gearTable.property1color, 1, gearTable.property1special)
		else
			if string.match(gearTable.property1name, "rune_") then
				gearTable.property1tooltip = gearTable.property1name
			end
			RPCItems:SetPropertyValues(item, gearTable.property1, gearTable.property1tooltip, gearTable.property1color, 1) 
		end
		--PROPERTY2
		if gearTable.property2 then
			item.property2 = gearTable.property2
			item.property2name = gearTable.property2name
			if gearTable.property2special then
				local tooltipValue = "★"
				if gearTable.property2 > 1 then
					tooltipValue = gearTable.property2
				end
				if string.match(gearTable.property2name, "rune_") then
					gearTable.property2tooltip = gearTable.property2name
				end
				RPCItems:SetPropertyValuesSpecial(item, tooltipValue, gearTable.property2tooltip, gearTable.property2color, 2, gearTable.property2special)
			else
				if string.match(gearTable.property2name, "rune_") then
					gearTable.property2tooltip = gearTable.property2name
				end
				RPCItems:SetPropertyValues(item, gearTable.property2, gearTable.property2tooltip, gearTable.property2color, 2) 
			end
		end
		--PROPERTY3
		if gearTable.property3 then
			item.property3 = gearTable.property3
			item.property3name = gearTable.property3name
			if gearTable.property3special then
				local tooltipValue = "★"
				if gearTable.property3 > 1 then
					tooltipValue = gearTable.property3
				end
				if string.match(gearTable.property3name, "rune_") then
					gearTable.property3tooltip = gearTable.property3name
				end
				RPCItems:SetPropertyValuesSpecial(item, tooltipValue, gearTable.property3tooltip, gearTable.property3color, 3, gearTable.property3special)
			else
				if string.match(gearTable.property3name, "rune_") then
					gearTable.property3tooltip = gearTable.property3name
				end
				RPCItems:SetPropertyValues(item, gearTable.property3, gearTable.property3tooltip, gearTable.property3color, 3) 
			end
		end
		--PROPERTY4
		if gearTable.property4 then
			item.property4 = gearTable.property4
			item.property4name = gearTable.property4name
			if gearTable.property4special then
				local tooltipValue = "★"
				if gearTable.property4 > 1 then
					tooltipValue = gearTable.property4
				end
				if string.match(gearTable.property4name, "rune_") then
					gearTable.property4tooltip = gearTable.property4name
				end
				RPCItems:SetPropertyValuesSpecial(item, tooltipValue, gearTable.property4tooltip, gearTable.property4color, 4, gearTable.property4special)
			else
				if string.match(gearTable.property4name, "rune_") then
					gearTable.property4tooltip = gearTable.property4name
				end
				RPCItems:SetPropertyValues(item, gearTable.property4, gearTable.property4tooltip, gearTable.property4color, 4) 
			end
		end
		--WEAPON
		if gearTable.is_weapon == 1 then
			-- print("GEARTABLE IS WEAPON")

		    item.xp = gearTable.current_xp
		    item.level = gearTable.level
		    item.maxLevel = gearTable.max_level
		    item.requiredHero = gearTable.required_hero
		    Weapons:SetWeaponTable(item)
			if bEquip == 1 then
				hero.weapon = item 
		   		CustomNetTables:SetTableValue("weapons", tostring(hero:GetEntityIndex()), {xp = item.xp, level = item.level, xpNeeded = Weapons.XP_PER_LEVEL_TABLE[item.level], maxLevel = item.maxLevel, requiredHero = item.requiredHero} )
		    end
		    Timers:CreateTimer(0.1, function()
		    	Weapons:UpdateWeaponXP(0)
		    end)
		end
		item.pickedUp = true
		RPCItems:ReduceLevelRequirement(item)
		if bEquip == 1 then
			Weapons:Equip(hero, item)
		else
			SaveLoad:ApplyValidator(gearTable, item)
			return item
		end
	else

		if gearTable.item_variant == "item_reanimation_stone" then
			local item = RPCItems:CreateConsumable("item_reanimation_stone", "mythical", "Reanimation Stone", "consumable", false, "Consumable", "reanimation_stone_desc")
			item.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, item)
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			return item
		elseif gearTable.item_name == "glyph" then
			print(gearTable.item_variant)
			local item = Glyphs:RollGlyphAll(gearTable.item_variant, Vector(0, 0), -1)
			item.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, item)
			SaveLoad:RemoveProperties(item)
			return item
		elseif gearTable.item_name == "temple_key" then
			local key = RPCItems:CreateConsumable(gearTable.item_variant, "rare", "temple_key", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			key.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, key)
			SaveLoad:RemoveProperties(key)
			SaveLoad:RemoveAdditionalData(key, false, false)
			return key
		elseif gearTable.item_name == "tanari_element" then
			local element = RPCItems:CreateConsumable(gearTable.item_variant, "mythical", "tanari_element", "consumable", false, "Key Item", gearTable.item_variant.."_desc")
			element.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, element)
			SaveLoad:RemoveProperties(element)
			SaveLoad:RemoveAdditionalData(element, false, false)
			return element
		elseif gearTable.item_name == "tanari_spirit_stones" then
			local stones = RPCItems:CreateConsumable(gearTable.item_variant, "immortal", "tanari_spirit_stones", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			stones.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, stones)
			SaveLoad:RemoveProperties(stones)
			SaveLoad:RemoveAdditionalData(stones, false, false)
			return stones
		elseif gearTable.item_name == "redfall_key" then
			local key = RPCItems:CreateConsumable(gearTable.item_variant, "rare", "redfall_key", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			key.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, key)
			SaveLoad:RemoveProperties(key)
			SaveLoad:RemoveAdditionalData(key, false, false)
			return key
		elseif gearTable.item_name == "glyph_book" then
			local item = Glyphs:CreateGlyphBook(gearTable.item_variant, gearTable.property1, gearTable.property2)
			item.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, item)
			return item
		elseif gearTable.item_variant == "item_rpc_web_premium_token" then
			print("IN HERE??")
			local item = RPCItems:CreateConsumable("item_rpc_web_premium_token", "immortal", "Web Premium Token", "consumable", false, "Consumable", "web_premium_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.property1 = gearTable.property1
			item.property1color = gearTable.property1color
			item.property1name = gearTable.property1name
			item.property1tooltip = gearTable.property1tooltip
			item.consumable = true
			item.stashable = true
			RPCItems:SetPropertyValues(item, item.property1, "web_prem_tracking_id", item.property1color,  1)
			item.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, item)
			return item
		elseif gearTable.item_variant == "item_rpc_synthesis_vessel" then
			local item = RPCItems:CreateConsumable("item_rpc_synthesis_vessel", "immortal", "Synthesis Vessel", "consumable", false, "Consumable", "synthesis_vessel_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.consumable = true
			item.stashable = true
			item.pickedUp = true
			SaveLoad:ApplyValidator(gearTable, item)
			return item
		elseif string.match(gearTable.item_variant, "galactic_arcana_cache") then
			local item = RPCItems:CreateConsumable(gearTable.item_variant, "immortal", "Arcana Cache Part", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.stashable = true
			item.consumable = true
			item.pickedUp = true
			item.property1 = gearTable.property1
		    item.property1name = gearTable.property1name
			item.property1color = gearTable.property1color
			item.property1tooltip = gearTable.property1tooltip
			RPCItems:SetPropertyValues(item, item.property1, "cache_radiance", item.property1color,  1)
			SaveLoad:ApplyValidator(gearTable, item)
			return item
		elseif gearTable.item_variant == "item_rpc_boreal_granite_chunk" then
			local item = RPCItems:CreateBasicConsumable(nil, gearTable.item_variant, gearTable.item_name, RPCItems:GetRarityNameFromFactor(gearTable.rarity), false)
			SaveLoad:ApplyValidator(gearTable, item)
			return item
		end
	end
end

function SaveLoad:FixLoadedRuneProperties(propertyName)
	if propertyName then
		print("propertyName: "..propertyName)
		if propertyName == "rune_a_a" then
			return "rune_q_1"
		end
		if propertyName == "rune_b_a" then
			return "rune_q_2"
		end
		if propertyName == "rune_c_a" then
			return "rune_q_3"
		end
		if propertyName == "rune_d_a" then
			return "rune_q_4"
		end
		if propertyName == "rune_a_b" then
			return "rune_w_1"
		end
		if propertyName == "rune_b_b" then
			return "rune_w_2"
		end
		if propertyName == "rune_c_b" then
			return "rune_w_3"
		end
		if propertyName == "rune_d_b" then
			return "rune_w_4"
		end
		if propertyName == "rune_a_c" then
			return "rune_e_1"
		end
		if propertyName == "rune_b_c" then
			return "rune_e_2"
		end
		if propertyName == "rune_c_c" then
			return "rune_e_3"
		end
		if propertyName == "rune_d_c" then
			return "rune_e_4"
		end
		if propertyName == "rune_a_d" then
			return "rune_r_1"
		end
		if propertyName == "rune_b_d" then
			return "rune_r_2"
		end
		if propertyName == "rune_c_d" then
			return "rune_r_3"
		end
		if propertyName == "rune_d_d" then
			return "rune_r_4"
		end
		return propertyName
	end
end

function SaveLoad:RemoveProperties(item)
	for i = 1, 4, 1 do
		RPCItems:SetPropertyValues(item, nil, nil, nil, i)
	end
end

function SaveLoad:RemoveAdditionalData(item, bRequiredLevel, bHeroRequirement)
    local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(item:GetEntityIndex()))
    -- if bRequiredLevel then
    -- 	CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemInfo.itemName, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, minLevel = newItem.minLevel} )
    -- elseif bHeroRequirement then
    -- 	CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemInfo.itemName, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, requiredHero = itemInfo.requiredHero  } )
    -- else
    -- 	CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemInfo.itemName, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor } )
    -- end
end

function SaveLoad:ApplyValidator(gearTable, item)
	if gearTable.validator then
		if gearTable.validator == "roshpit" then
		else
			CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()).."-key", {key = gearTable.validator} )
		end
	end
end

function SaveLoad:ApplyDataToHero(results, playerID)
	-- print(results.current_xp)
	-- print(hero)
	-- print(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	hero:AddExperience(results.current_xp-hero:GetCurrentXP(), 0, false, false)
	CustomGameEventManager:Send_ServerToAllClients("xp_earned", {} )
	-- Timers:CreateTimer(0.05, function()
	-- 	hero:AddExperience(results.current_xp, 0, false, false)
	-- end)
	hero.roshpitID = results.id
	hero.saveSlot = results.save_slot
	
	hero.runeUnit:GetAbilityByIndex(0):SetLevel(results.rune_a_a)
	hero.runeUnit:GetAbilityByIndex(1):SetLevel(results.rune_a_b)
	hero.runeUnit:GetAbilityByIndex(2):SetLevel(results.rune_a_c)
	hero.runeUnit:GetAbilityByIndex(3):SetLevel(results.rune_a_d)

	hero.runeUnit2:GetAbilityByIndex(0):SetLevel(results.rune_b_a)
	hero.runeUnit2:GetAbilityByIndex(1):SetLevel(results.rune_b_b)
	hero.runeUnit2:GetAbilityByIndex(2):SetLevel(results.rune_b_c)
	hero.runeUnit2:GetAbilityByIndex(3):SetLevel(results.rune_b_d)

	hero.runeUnit3:GetAbilityByIndex(0):SetLevel(results.rune_c_a)
	hero.runeUnit3:GetAbilityByIndex(1):SetLevel(results.rune_c_b)
	hero.runeUnit3:GetAbilityByIndex(2):SetLevel(results.rune_c_c)
	hero.runeUnit3:GetAbilityByIndex(3):SetLevel(results.rune_c_d)

	hero.runeUnit4:GetAbilityByIndex(0):SetLevel(results.rune_d_a)
	hero.runeUnit4:GetAbilityByIndex(1):SetLevel(results.rune_d_b)
	hero.runeUnit4:GetAbilityByIndex(2):SetLevel(results.rune_d_c)
	hero.runeUnit4:GetAbilityByIndex(3):SetLevel(results.rune_d_d)


	SaveLoad:ApplyAllRunes(hero, playerID)

	
	hero:GetAbilityByIndex(0):SetLevel(results.ability1level)
	hero:GetAbilityByIndex(1):SetLevel(results.ability2level)
	hero:GetAbilityByIndex(2):SetLevel(results.ability3level)
	hero:GetAbilityByIndex(DOTA_ULTIMATE_SLOT):SetLevel(results.ability4level)

	CustomNetTables:SetTableValue("player_stats", tostring(playerID), {skillPoints = results.ability_points, runePoints = results.rune_points} )

end

function SaveLoad:ApplyAllRunes(hero, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(0), hero.runeUnit, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(1), hero.runeUnit, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(2), hero.runeUnit, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(3), hero.runeUnit, playerID)
	Timers:CreateTimer(0.5, function()
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(0), hero.runeUnit2, playerID)
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(1), hero.runeUnit2, playerID)
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(2), hero.runeUnit2, playerID)
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(3), hero.runeUnit2, playerID)
	end)

	Timers:CreateTimer(1, function()
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(0), hero.runeUnit3, playerID)
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(1), hero.runeUnit3, playerID)
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(2), hero.runeUnit3, playerID)
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(3), hero.runeUnit3, playerID)
	end)
end

function SaveLoad:StashOpen(keys)
	local playerID = keys.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local url = ROSHPIT_URL.."/champions/getStash?"
	url = url.."steam_id="..steamID
	CustomGameEventManager:Send_ServerToPlayer(player, "close_swap_ui", {} )
	-- Weapons:ValidateGear(hero)
	if hero.stashTable then
		for i = 1, #hero.stashTable, 1 do
			if IsValidEntity(hero.stashTable[i]) then
				-- print("------")
				-- print(hero.stashTable[i]:GetEntityIndex())
				-- print(hero.pullStashItem)
				if hero.stashTable[i]:GetEntityIndex() == hero.pullStashItem then
					hero.pullStashItem = nil
				else
					UTIL_Remove(hero.stashTable[i])
				end
			end
		end
		hero.stashTable = nil
	end
	CreateHTTPRequestScriptVM("GET", url ):Send( function( result )
		local resultTable = {}
		print( "GET response:\n" )
		for k,v in pairs( result ) do
			print( string.format( "%s : %s\n", k, v ) )
		end
		print( "Done." )
		local resultTable = JSON:decode(result.Body)
		-- Weapons:ValidateGear(hero)
		-- DeepPrintTable(resultTable)
		local delay = #resultTable*0.03 + 0.15
		SaveLoad:GenerateStashItems(resultTable, playerID, hero)
		-- SaveLoad:GetCharacterDataFromJSON(resultTable)
		Timers:CreateTimer(delay, function()
			CustomGameEventManager:Send_ServerToPlayer(player, "stash_loaded", {playerID = playerID, stashTable = hero.stash_view} )
		end)
			-- CustomGameEventManager:Send_ServerToPlayer(player, "load_characters_loaded", {result=resultTable, message="collapse"} )
	end )
end

function SaveLoad:GenerateStashItems(resultTable, playerID, hero)
	local MAX_STASH_SLOTS = 48
	local slotsUsed = {}
	hero.stashTable = {}
	for i = 1, #resultTable, 1 do
		Timers:CreateTimer(i*0.03, function()
			-- local item_basics = CustomNetTables:GetTableValue("item_basics", tostring(player:GetPlayerID()).."-"..tostring(slot))
			local itemData = resultTable[i]
			-- local stashItem = CustomNetTables:GetTableValue("stash", tostring(playerID).."-"..tostring(i))
			local itemEntity = SaveLoad:LoadGear(itemData, playerID, bEquip)

			if itemEntity then
				itemEntity.stash_slot = itemData.stash_slot
				-- CustomNetTables:SetTableValue("stash", tostring(playerID).."-"..tostring(itemData.stash_slot), {itemIndex = itemEntity:GetEntityIndex()} )
				table.insert(slotsUsed, itemData.stash_slot)
				table.insert(hero.stashTable, itemEntity)
			end
			-- else
			-- 	CustomNetTables:SetTableValue("stash", tostring(playerID).."-"..tostring(i), {itemIndex = 0} )
			-- end
		end)
		
	end
	-- local unusedSlots = {}
	-- for i = 1, MAX_STASH_SLOTS, 1 do
	-- 	table.insert(unusedSlots, i)
	-- end
	-- local t = unusedSlots

	-- for i = 1, #slotsUsed, 1 do
	-- 	local index = 1 
	-- 	local size = #t 
	-- 	while index <= size do 
	-- 	    if t[index] == slotsUsed[i] then 
	-- 	        t[index] = t[size] 
	-- 	        t[size] = nil 
	-- 	        size = size - 1 
	-- 	    else index = index + 1 
	-- 	    end 
	-- 	end 
	-- end
	-- for i = 1, #t, 1 do
	-- 	-- CustomNetTables:SetTableValue("stash", tostring(playerID).."-"..tostring(t[i]), {itemIndex = 0} )
	-- end
	local delay = #resultTable*0.03 + 0.05
	Timers:CreateTimer(delay, function()
		local stash_table = {}
		local lastSlotUsed = 0
		for i = 1, MAX_STASH_SLOTS, 1 do
			local attributed = false
			for j = 1, #hero.stashTable, 1 do
				local stashItem = hero.stashTable[j]
				if stashItem.stash_slot == i then
					table.insert(stash_table, stashItem:GetEntityIndex())
					attributed = true
					break
				end
			end
			if not attributed then
				table.insert(stash_table, 0)
			end
		end
		hero.stash_view = stash_table
	end)
	-- for i = 1, hero.stashTable, 1 do
	-- 	local stashItem = hero.stashTable[i]
	-- 	if stashItem.stash_slot == i then
	-- 		table.insert(stash_table)
	-- end
	
end

	-- for i = 1, MAX_SAVE_SLOTS, 1 do
	-- 	characters[i] = {}
	-- end
	-- for i = 1, MAX_SAVE_SLOTS, 1 do
	-- 	if resultTable[i] then
	-- 		local slot = resultTable[i].save_slot
	-- 		print(slot)
	-- 		characters[slot].heroName = resultTable[i].hero_name
	-- 		characters[slot].level = resultTable[i].hero_level
	-- 	end
	-- end
	-- for i = 1, MAX_SAVE_SLOTS, 1 do
	-- 	if not characters[i].heroName then
	-- 		characters[i].heroName = "empty"
	-- 	end
	-- end

function SaveLoad:DraggedToStash(keys)
	local playerID = keys.playerID
	local player = PlayerResource:GetPlayer(playerID)
	local itemIndex = keys.itemIndex
	local stashSlot = keys.slot
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local itemEntity = EntIndexToHScript(itemIndex)
	local fromSlot = keys.fromSlot
	print("DRAGGED TO STASH")
	if itemEntity.cantStash then
		Notifications:Top(playerID, {text="Can't Stash This", duration=2, style={color="red"}, continue=true})
		EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
		return false
	end
	SaveLoad:NewKey()
	print("-----HAS ITEM OR NOT BELOW-----")
	if keys.drag_type == "inventory" then
		if Challenges:CheckIfHeroHasItemByItemIndex(hero, itemIndex) then
			print("HAS ITEM!")
		else
			print("DOESN'T HAVE ITEM")
			return false
		end
	end
	if hero:HasModifier("modifier_stash_lock") then
		return false
	end
	CustomGameEventManager:Send_ServerToPlayer(player, "close_swap_ui", {} )
	print("DRAGGED TO")
	if SaveLoad:GetAllowSaving() then
		if stashSlot < 13 or GameState:GetPlayerPremiumStatus(playerID) then
			if keys.drag_type == "inventory" then
				hero:Stop()
				print("TAKE ITEM")
				hero:TakeItem(itemEntity)
		  		if IsValidEntity(itemEntity:GetContainer()) then
		  			UTIL_Remove(itemEntity:GetContainer())
		  		end
				local url = ROSHPIT_URL.."/champions/saveStashItem?"
				url = url.."steam_id="..steamID
				url = SaveLoad:AttachItemToURL(url, hero, 1, stashSlot, playerID, 0, itemIndex)
				url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
				Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_stash_lock", {duration = 90})
					CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
						print( "POST response:\n" )
						for k,v in pairs( result ) do
							print( string.format( "%s : %s\n", k, v ) )
						end
						SaveLoad:NewKey()
						print( "Done." )
						print(result.StatusCode)
						hero:RemoveModifierByName("modifier_stash_lock")
						if result.StatusCode == 200 then
							RPCItems:ItemUTIL_Remove(itemEntity)
							-- Weapons:ValidateGear(hero)
							local resultTable = JSON:decode(result.Body)
							print("@@@@ WITHDRAW RESULTS @@@@")
							print(resultTable)
							local keys = {}
							-- local inventoryItem = CustomNetTables:GetTableValue("stash", tostring(playerID).."-"..tostring(stashSlot))
							if resultTable then
								local withdrawnItem = SaveLoad:LoadGear(resultTable, playerID, false)
								withdrawnItem.itemIndex = withdrawnItem:GetEntityIndex()
								if not Challenges:CheckIfHeroHasItemByItemIndex(hero, withdrawnItem.itemIndex) then
									SaveLoad:PutItemInInventory(hero, withdrawnItem.itemIndex)
									local returnItem = EntIndexToHScript(withdrawnItem.itemIndex)
									if IsValidEntity(returnItem:GetContainer()) then
										UTIL_Remove(returnItem:GetContainer())
									end
								end
							else
							end
							keys.playerID = playerID
							-- CustomGameEventManager:Send_ServerToPlayer(player, "stash_item_upated", {stashSlot = stashSlot, item = itemIndex} )
							SaveLoad:StashOpen(keys)
							Statistics.dispatch('items:oracle:push')
							Events:TutorialServerEvent(hero, "3_5", 0)
						else
							if not Challenges:CheckIfHeroHasItemByItemIndex(hero, itemEntity:GetEntityIndex()) then
								RPCItems:GiveItemToHeroWithSlotCheck(hero, itemEntity)
								if IsValidEntity(itemEntity:GetContainer()) then
									UTIL_Remove(itemEntity:GetContainer())
								end
								CustomNetTables:SetTableValue( "item_basics", tostring(itemEntity:GetEntityIndex()).."-returned", {returned = 1} )
							end
						end
					end )
			else
				if fromSlot > 12 or stashSlot > 12 then
					if not GameState:GetPlayerPremiumStatus(playerID) then
						Notifications:Top(playerID, {text="Premium Only", duration=2, style={color="red"}, continue=true})
						local keys = {}
						keys.playerID = playerID
						SaveLoad:StashOpen(keys)
						return false
					end
				end
				local url = ROSHPIT_URL.."/champions/moveStashItem?"
				url = url.."steam_id="..steamID
				url = url.."&from_slot="..fromSlot
				url = url.."&to_slot="..stashSlot
				url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
					CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
						SaveLoad:NewKey()
						print( "POST response:\n" )
						for k,v in pairs( result ) do
							print( string.format( "%s : %s\n", k, v ) )
						end
						print( "Done." )
						local resultTable = JSON:decode(result.Body)
						local keys = {}
						
						keys.playerID = playerID
						-- CustomGameEventManager:Send_ServerToPlayer(player, "stash_item_upated", {stashSlot = stashSlot, item = itemIndex} )
						SaveLoad:StashOpen(keys)
					end )
			end
		else
			Notifications:Top(playerID, {text="Premium Only", duration=2, style={color="red"}, continue=true})
			local keys = {}
			keys.playerID = playerID
			SaveLoad:StashOpen(keys)
		end
	end
end

function SaveLoad:DraggedFromStash(keys)
	local playerID = keys.playerID
	local draggedItemIndex = keys.itemIndex
	local stashSlot = keys.stashSlot
	local inventorySlot = keys.inventorySlot
	local hero = GameState:GetHeroByPlayerID(playerID)
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	SaveLoad:NewKey()

	print("DRAGGED FROM STASH")
	if SaveLoad:GetAllowSaving() then
			if hero:GetItemInSlot(inventorySlot) then
				if stashSlot < 12 or GameState:GetPlayerPremiumStatus(playerID) then
					local itemEntity = hero:GetItemInSlot(inventorySlot)
					if itemEntity.cantStash then
						Notifications:Top(playerID, {text="Can't Stash This", duration=2, style={color="red"}, continue=true})
						EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
						return false
					end
					hero:TakeItem(itemEntity)
  					if IsValidEntity(itemEntity:GetContainer()) then
		  				UTIL_Remove(itemEntity:GetContainer())
		  			end
					local url = ROSHPIT_URL.."/champions/saveStashItem?"
					url = url.."steam_id="..steamID
					url = SaveLoad:AttachItemToURL(url, hero, 1, stashSlot, playerID, 0, itemEntity:GetEntityIndex())
					url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
					
						CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
							SaveLoad:NewKey()
							print( "POST response:\n" )
							for k,v in pairs( result ) do
								print( string.format( "%s : %s\n", k, v ) )
							end
							print( "Done." )
							if result.StatusCode == 200 then
								local resultTable = JSON:decode(result.Body)
								local keys = {}
								if resultTable then
									local withdrawnItem = SaveLoad:LoadGear(resultTable, playerID, false)
									withdrawnItem.itemIndex = withdrawnItem:GetEntityIndex()
									if not Challenges:CheckIfHeroHasItemByItemIndex(hero, withdrawnItem.itemIndex) then
										SaveLoad:PutItemInInventory(hero, withdrawnItem.itemIndex)
										local returnItem = EntIndexToHScript(withdrawnItem.itemIndex)
										if IsValidEntity(returnItem:GetContainer()) then
											UTIL_Remove(returnItem:GetContainer())
										end
									end
								else
									RPCItems:GiveItemToHeroWithSlotCheck(hero, itemEntity)
								end
								keys.playerID = playerID
								-- CustomGameEventManager:Send_ServerToPlayer(player, "stash_item_upated", {stashSlot = stashSlot, item = itemIndex} )
								SaveLoad:StashOpen(keys)
								RPCItems:ItemUTIL_Remove(itemEntity)
								Statistics.dispatch('items:oracle:get')
								Events:TutorialServerEvent(hero, "3_5", 1)
								-- Weapons:ValidateGear(hero)
							else
								if not Challenges:CheckIfHeroHasItemByItemIndex(hero, itemEntity:GetEntityIndex()) then
									RPCItems:GiveItemToHeroWithSlotCheck(hero, itemEntity)
									if IsValidEntity(itemEntity:GetContainer()) then
										UTIL_Remove(itemEntity:GetContainer())
									end
									CustomNetTables:SetTableValue( "item_basics", tostring(itemEntity:GetEntityIndex()).."-returned", {returned = 1} )
								end
							end
						end )
				else
					local keys = {}
					keys.playerID = playerID
					SaveLoad:StashOpen(keys)
					Notifications:Top(playerID, {text="Premium Only", duration=2, style={color="red"}, continue=true})
				end		
			else
				local url = ROSHPIT_URL.."/champions/removeStashItem?"
				url = url.."steam_id="..steamID
				url = url.."&stash_slot="..stashSlot
				url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
				print(url)
					CreateHTTPRequestScriptVM( "POST", url ):Send( function( result )
						SaveLoad:NewKey()
						print( "POST response:\n" )
						for k,v in pairs( result ) do
							print( string.format( "%s : %s\n", k, v ) )
						end
						print( "Done." )
						if result.StatusCode == 200 then
							local resultTable = JSON:decode(result.Body)
							local keys = {}
							print(resultTable)
							local withdrawnItem = SaveLoad:LoadGear(resultTable, playerID, false)
							withdrawnItem.itemIndex = withdrawnItem:GetEntityIndex()
							if withdrawnItem.itemIndex == 0 then
							else
								if not Challenges:CheckIfHeroHasItemByItemIndex(hero, withdrawnItem.itemIndex) then
									SaveLoad:PutItemInInventory(hero, withdrawnItem.itemIndex)
								end
							end
							keys.playerID = playerID
							-- CustomGameEventManager:Send_ServerToPlayer(player, "stash_item_upated", {stashSlot = stashSlot, item = itemIndex} )
							SaveLoad:StashOpen(keys)
							CustomNetTables:SetTableValue("stash", tostring(playerID).."-"..tostring(stashSlot), {itemIndex = 0} )
							Events:TutorialServerEvent(hero, "3_5", 1)
						end
					end )	
			end
	end
end

function SaveLoad:PutItemInInventory(hero, itemIndex)
	print("ADD ITEM!")
	hero:AddItem(EntIndexToHScript(itemIndex))
	hero.pullStashItem = itemIndex
	-- SwapItems(int nSlot1, int nSlot2)
end

function SaveLoad:HeroSelectOption(msg)
	if msg.eventName == "previewAbility" then
		SaveLoad:PreviewAbilities(msg)
	elseif msg.eventName == "selectNewHero" then
		SaveLoad:CreateNewHero(msg)
	elseif msg.eventName == "loadHero" then
		SaveLoad:LoadHeroNewSelect(msg)
	end
end

function SaveLoad:PreviewAbilities(msg)
	local playerID = msg.playerID
	local heroName = msg.heroName
	local player = PlayerResource:GetPlayer(playerID)
	if player.previewHero then
		UTIL_Remove(player.previewHero)
	end
	PrecacheUnitByNameAsync(heroName, function()
		local previewHero = CreateUnitByName(heroName, RPCItems.DROP_LOCATION, true, nil, nil, DOTA_TEAM_GOODGUYS)
		previewHero.preview = true
		previewHero:SetDayTimeVisionRange(0)
		previewHero:SetNightTimeVisionRange(0)
		player.previewHero = previewHero

		previewHero:AddNoDraw()

		local abilityTable = {previewHero:GetAbilityByIndex(0):GetEntityIndex(), previewHero:GetAbilityByIndex(1):GetEntityIndex(), previewHero:GetAbilityByIndex(2):GetEntityIndex(), previewHero:GetAbilityByIndex(3):GetEntityIndex()}
		print(EntIndexToHScript(abilityTable[1]):GetAbilityName())
		CustomGameEventManager:Send_ServerToPlayer(player, "updateSkillPreview", {heroIndex = previewHero:GetEntityIndex()} )
	end)


	-- local previewHeroTable = {playerID, previewHero:GetEntityIndex()}
	-- table.insert(PREVIEW_HERO_TABLE, previewHeroTable)
end

function SaveLoad:CreateNewHero(msg)
	local playerID = msg.playerID
	local heroName = msg.heroName
	local player = PlayerResource:GetPlayer(playerID)
	local bPass = true
	for i = 1, #TAKEN_HERO_TABLE, 1 do
		if heroName == TAKEN_HERO_TABLE[i] then
			bPass = false
			break
		end
	end
	if bPass then
	    table.insert(TAKEN_HERO_TABLE, heroName)
	    CustomNetTables:SetTableValue("hero_index", "taken_heroes", TAKEN_HERO_TABLE)
	    CustomGameEventManager:Send_ServerToAllClients("update_picked_heroes", {selectedHero = heroName} )
	    PrecacheUnitByNameAsync(heroName, function(...) end)
		if GameState:GetHeroByPlayerID(playerID) == -1 then
			Timers:CreateTimer(2, function()
				if GameState:GetHeroByPlayerID(playerID) == -1 then
					if player:GetAssignedHero():GetUnitName() == "npc_dota_hero_wisp" then
						PlayerResource:ReplaceHeroWith(playerID, heroName, 0, 0)
						Timers:CreateTimer(1, function()
							local hero = GameState:GetHeroByPlayerID(playerID)
							
							-- hero = EntIndexToHScript(hero)
							hero.muteMusic = msg.muteMusic
						end)
					end
				end
			end)
			Timers:CreateTimer(2.4, function()
				  CustomGameEventManager:Send_ServerToPlayer(player, "AbilityUp", {playerId=PlayerID})
				  CustomGameEventManager:Send_ServerToPlayer(player, "ability_tree_upgrade", {playerId=PlayerID})
			end)
			if player.previewHero then
				UTIL_Remove(player.previewHero)
			end
		end
	end
end

function SaveLoad:LoadHeroNewSelect(msg)
	local playerID = msg.playerID
	local player = PlayerResource:GetPlayer(playerID)
	SaveLoad:CreateNewHero(msg)
	player.hero_loading = true
	Timers:CreateTimer(3.0, function()
		if not player.heroLoaded then
			player.heroLoaded = true
			SaveLoad:LoadCharacter(msg)
		end
	end)
end

function SaveLoad:OpenKeyBank(msg)
	local playerID = msg.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local url = ROSHPIT_URL.."/champions/getPlayerKeys?"
	url = url.."steam_id="..steamID
	CreateHTTPRequestScriptVM("GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			CustomGameEventManager:Send_ServerToPlayer(player, "player_keys_loaded", {result=resultTable, premium=premium} )
			Events:TutorialServerEvent(hero, "5_2", 0)
		else

		end
	end )
end

function SaveLoad:WithdrawKey(msg)
	local playerID = msg.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)

	local keyIndex = msg.keyIndex
	local limit = 20
	local url = ROSHPIT_URL.."/champions/updatePlayerKeys?"
	url = url.."steam_id="..steamID
	url = url.."&limit="..limit
	url = url.."&change=-1"
	url = url.."&keyIndex="..msg.keyIndex
	url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)

	-- local url = ROSHPIT_URL.."/champions/getPlayerKeys?"
	-- url = url.."steam_id="..steamID
	CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
		SaveLoad:NewKey()
		if result.StatusCode == 200 then
			local resultTable = {}
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			CustomGameEventManager:Send_ServerToPlayer(player, "player_keys_loaded", {result=resultTable} )
			SaveLoad:WithdrawKeyFinal(hero, keyIndex)
		else
			print( "GET response:\n" )
			for k,v in pairs( result ) do
				print( string.format( "%s : %s\n", k, v ) )
			end
			print( "Done." )
		end
	end )
end

function SaveLoad:DepositKey(msg)
	local playerID = msg.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)

	local itemIndex = msg.itemIndex
	local limit = msg.limit
	local url = ROSHPIT_URL.."/champions/updatePlayerKeys?"
	url = url.."steam_id="..steamID
	url = url.."&limit="..limit
	url = url.."&change=1"
	url = url.."&keyIndex="..msg.keyIndex
	url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
	if SaveLoad:GetAllowSaving() then
		local itemEntity = EntIndexToHScript(itemIndex)
		hero:TakeItem(itemEntity)
		if IsValidEntity(itemEntity:GetContainer()) then
			UTIL_Remove(itemEntity:GetContainer())
		end

		-- local url = ROSHPIT_URL.."/champions/getPlayerKeys?"
		-- url = url.."steam_id="..steamID
		CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
			SaveLoad:NewKey()
			if result.StatusCode == 200 then
				local resultTable = {}
				print( "GET response:\n" )
				for k,v in pairs( result ) do
					print( string.format( "%s : %s\n", k, v ) )
				end
				print( "Done." )
				local resultTable = JSON:decode(result.Body)
				RPCItems:ItemUTIL_Remove(itemEntity)
				CustomGameEventManager:Send_ServerToPlayer(player, "player_keys_loaded", {result=resultTable, premium=premium} )
			else
				print( "GET response:\n" )
				for k,v in pairs( result ) do
					print( string.format( "%s : %s\n", k, v ) )
				end
				print( "Done." )
			end
		end )
	end
end

function SaveLoad:WithdrawKeyFinal(hero, keyIndex)
	if keyIndex == 1 then
        local itemName = "item_tanari_wind_temple_key_normal"
        local key = RPCItems:CreateConsumable(itemName, "rare", "temple_key", "consumable", false, "Consumable", itemName.."_desc")
        RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
    elseif keyIndex == 2 then
        local itemName = "item_tanari_water_temple_key_normal"
        local key = RPCItems:CreateConsumable(itemName, "rare", "temple_key", "consumable", false, "Consumable", itemName.."_desc")
        RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
    elseif keyIndex == 3 then
        local itemName = "item_tanari_fire_temple_key_normal"
        local key = RPCItems:CreateConsumable(itemName, "rare", "temple_key", "consumable", false, "Consumable", itemName.."_desc")
        RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
    elseif keyIndex == 4 then
  		local itemName = "item_tanari_spirit_stones_normal"
		local stones = RPCItems:CreateConsumable(itemName, "immortal", "tanari_spirit_stones", "consumable", false, "Consumable", itemName.."_desc")
		stones.pickedUp = true
		RPCItems:GiveItemToHeroWithSlotCheck(hero, stones)
    elseif keyIndex == 5 then
	    local itemName = "item_redfall_burgundy_firefly_normal"
	    local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
	    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
    elseif keyIndex == 6 then
	    local itemName = "item_redfall_purified_vermillion_bundle_normal"
	    local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
	    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
    elseif keyIndex == 7 then
	    local itemName = "item_redfall_hidden_shipyard_key_normal"
	    local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
	    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
    elseif keyIndex == 8 then
	    local itemName = "item_redfall_crimsyth_demon_relic_normal"
	    local key = RPCItems:CreateConsumable(itemName, "rare", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
	    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
	elseif keyIndex == 9 then
	    local itemName = "item_redfall_spirit_ruby_normal"
	    local key = RPCItems:CreateConsumable(itemName, "mythical", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
	    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
	elseif keyIndex == 10 then
	    local itemName = "item_serengaard_sunstone"
	    local key = RPCItems:CreateConsumable(itemName, "mythical", "redfall_key", "consumable", false, "Consumable", itemName.."_desc")
	    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
	elseif keyIndex == 11 then
	    local key = RPCItems:CreateConsumable("item_rpc_winterblight_glacier_stone", "mythical", "Glacier Stone", "consumable", false, "Consumable", "item_rpc_winterblight_glacier_stone_desc")
	    key.stashable = true
	    key.consumable = true
	    RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
	end
end

function SaveLoad:SaveJex(hero)
	require('heroes/arc_warden/abilities.onibi')
	local onibi = hero.onibi
	local elements_table = all_possible_onibi_elements(onibi)
	local ability_keys = {"Q", "W", "E"}

	local playerID = hero:GetPlayerOwnerID()
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)

	local url = ROSHPIT_URL.."/champions/save_onibi?"
	url = url.."steam_id="..steamID
	url = url.."&championcharacter_id="..hero.roshpitID
	url = url.."&key1="..GetDedicatedServerKey(SaveLoad.KeyVersion)
	url = url.."&tony_key="..GetDedicatedServerKey("tony")
	for i = 1, #elements_table, 1 do
		local element1 = elements_table[i]
		-- local other_elements = get_other_elements(onibi, element1)
		for k = 1, #elements_table, 1 do
			for j = 1, #ability_keys, 1 do
				local ability_key = ability_keys[j]
				local element2 = elements_table[k]
				url = url.."&tech_"..element1.."-"..element2.."_"..ability_key.."="..onibi.stats_table[element1][element2][ability_key]["level"]
			end
		end
		url = url.."&"..element1.."_exp="..onibi.stats_table[element1]["exp"]
	end
	print(url)
	if SaveLoad:GetAllowSaving() then
		CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
			if result.StatusCode == 200 then
				local resultTable = {}
				print( "GET response:\n" )
				for k,v in pairs( result ) do
					print( string.format( "%s : %s\n", k, v ) )
				end
				print( "Done." )
				local resultTable = JSON:decode(result.Body)
			else
				print( "GET response:\n" )
				for k,v in pairs( result ) do
					print( string.format( "%s : %s\n", k, v ) )
				end
				print( "Done." )
			end
		end )
	end
end
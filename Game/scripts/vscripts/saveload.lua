require('libraries/json')

if SaveLoad == nil then
	SaveLoad = class({})
end

SaveLoad.KeyVersion = "4.0"
SaveLoad.SAVE_COOLDOWN = 4

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
					CreateHTTPRequestScriptVM("POST", url):Send(function(result)
						if result.StatusCode == 200 then
							SaveLoad.key1 = result.Body
							CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {})
							-- SaveLoad:ProcessKey()
						else

						end
					end)
					return 30
				else
					if SaveLoad:GetAllowSaving() then
						CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {})
					end
				end
			else
				return 10
			end
		end)
	end

end

--function SaveLoad:NewKey()
-- if Beacons.cheats then
-- return false
-- end
-- local url = ROSHPIT_URL.."/champions/key?"
-- url = url.."param1="..0
-- url = url.."&secret_key="..SaveLoad.key2
-- CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
-- if result.StatusCode == 200 then
-- SaveLoad.key1 = result.Body
-- if SaveLoad:GetAllowSaving() then
-- CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {} )
-- end
-- -- SaveLoad:ProcessKey()
-- end
-- end )
--end

-- function SaveLoad:KeyDebug()
-- local url = ROSHPIT_URL.."/champions/protection_test?"
-- url = url.."key1="..SaveLoad.key1
-- url = url.."&key2="..SaveLoad.key2
-- CreateHTTPRequestScriptVM("POST", url ):Send( function( result )
-- local resultTable = {}
-- local resultTable = JSON:decode(result.Body)
-- end )
-- end

function SaveLoad:ProcessKey()
	-- CustomGameEventManager:Send_ServerToAllClients("process_key", {key = SaveLoad.key1, special_id = SaveLoad.special_id} )
end

function SaveLoad:ProcessedKey(msg)
	SaveLoad.key2 = msg.number
	if SaveLoad:GetAllowSaving() and alert then
		CustomGameEventManager:Send_ServerToAllClients("server_confirmed", {})
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
	CreateHTTPRequestScriptVM("GET", url):Send(function(result)
		if result.StatusCode == 200 then
			local resultTable = {}
			--print( "GET response:\n" )
			for k, v in pairs(result) do
				--print( string.format( "%s : %s\n", k, v ) )
			end
			--print( "Done." )
			local resultTable = JSON:decode(result.Body)
			SaveLoad:GetCharacterDataFromJSON(resultTable)
			local premium = 0
			if GameState:GetPlayerPremiumStatus(playerID) then
				premium = 1
			end
			if saveOrLoad == "save" then
				CustomGameEventManager:Send_ServerToPlayer(player, "save_characters_loaded", {result = resultTable, message = "collapse", heroSlot = hero.saveSlot, premium = premium, currentLevel = GameState:GetHeroByPlayerID(playerID):GetLevel()})
			else
				CustomGameEventManager:Send_ServerToPlayer(player, "load_characters_loaded", {result = resultTable, message = "collapse", premium = premium})
			end
		else
			CustomGameEventManager:Send_ServerToPlayer(player, "load_characters_loaded_fail", {})
		end
	end)
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
			--print(slot)
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
	local current_rune_points = 0
	local current_skill_points = 0
	local runeUnit1 = hero.runeUnit
	local runeUnit2 = hero.runeUnit2
	local runeUnit3 = hero.runeUnit3
	local runeUnit4 = hero.runeUnit4
	hero.loadEnabled = 0
	Weapons:ValidateGear(hero)
	--SaveLoad:NewKey()
	if SaveLoad:GetAllowSaving() then
		local url = ROSHPIT_URL.."/champions/saveCharacter?"
		url = url.."slot="..slot
		url = url.."&hero_name="..hero:GetUnitName()
		url = url.."&level="..hero:GetLevel()
		url = url.."&steam_id="..PlayerResource:GetSteamAccountID(playerID)
		url = url.."&current_xp="..hero:GetCurrentXP()
		url = url.."&rune_a_a="..runeUnit1:GetAbilityByIndex(DOTA_Q_SLOT):GetBaseRuneLevel()
		url = url.."&rune_a_b="..runeUnit1:GetAbilityByIndex(DOTA_W_SLOT):GetBaseRuneLevel()
		url = url.."&rune_a_c="..runeUnit1:GetAbilityByIndex(DOTA_E_SLOT):GetBaseRuneLevel()
		url = url.."&rune_a_d="..runeUnit1:GetAbilityByIndex(DOTA_D_SLOT):GetBaseRuneLevel()
		url = url.."&rune_b_a="..runeUnit2:GetAbilityByIndex(DOTA_Q_SLOT):GetBaseRuneLevel()
		url = url.."&rune_b_b="..runeUnit2:GetAbilityByIndex(DOTA_W_SLOT):GetBaseRuneLevel()
		url = url.."&rune_b_c="..runeUnit2:GetAbilityByIndex(DOTA_E_SLOT):GetBaseRuneLevel()
		url = url.."&rune_b_d="..runeUnit2:GetAbilityByIndex(DOTA_D_SLOT):GetBaseRuneLevel()
		url = url.."&rune_c_a="..runeUnit3:GetAbilityByIndex(DOTA_Q_SLOT):GetBaseRuneLevel()
		url = url.."&rune_c_b="..runeUnit3:GetAbilityByIndex(DOTA_W_SLOT):GetBaseRuneLevel()
		url = url.."&rune_c_c="..runeUnit3:GetAbilityByIndex(DOTA_E_SLOT):GetBaseRuneLevel()
		url = url.."&rune_c_d="..runeUnit3:GetAbilityByIndex(DOTA_D_SLOT):GetBaseRuneLevel()
		url = url.."&rune_d_a="..runeUnit4:GetAbilityByIndex(DOTA_Q_SLOT):GetBaseRuneLevel()
		url = url.."&rune_d_b="..runeUnit4:GetAbilityByIndex(DOTA_W_SLOT):GetBaseRuneLevel()
		url = url.."&rune_d_c="..runeUnit4:GetAbilityByIndex(DOTA_E_SLOT):GetBaseRuneLevel()
		url = url.."&rune_d_d="..runeUnit4:GetAbilityByIndex(DOTA_D_SLOT):GetBaseRuneLevel()
		url = url.."&ability1level="..hero:GetAbilityByIndex(DOTA_Q_SLOT):GetLevel()
		url = url.."&ability2level="..hero:GetAbilityByIndex(DOTA_W_SLOT):GetLevel()
		url = url.."&ability3level="..hero:GetAbilityByIndex(DOTA_E_SLOT):GetLevel()
		url = url.."&ability4level="..hero:GetAbilityByIndex(DOTA_R_SLOT):GetLevel()
		url = url.."&ability_points="..current_skill_points
		url = url.."&rune_points="..current_rune_points
		url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
		url = SaveLoad:AttachGlyphsToUrl(url, hero)
		for i = 0, 5, 1 do
			url = SaveLoad:AttachItemToURL(url, hero, 0, 0, playerID, i, hero.equipped_gear[i])
		end
		if msg.ignore_callback then
			CreateHTTPRequestScriptVM("POST", url):Send(function(result)
				for k, v in pairs(result) do

				end
				local resultTable = JSON:decode(result.Body)
				SaveLoad:HeroSaveParticle(hero)
			end)
		else
			CreateHTTPRequestScriptVM("POST", url):Send(function(result)
				--print( "POST response:\n" )
				for k, v in pairs(result) do
					--print( string.format( "%s : %s\n", k, v ) )
				end
				--print( "Done." )
				--SaveLoad:NewKey()
				local resultTable = JSON:decode(result.Body)
				-- SaveLoad:GetCharacterDataFromJSON(resultTable)
				CustomGameEventManager:Send_ServerToPlayer(player, "recentlySaved", {})
				local premium = 0
				if GameState:GetPlayerPremiumStatus(playerID) then
					premium = 1
				end
				Weapons:ValidateGear(hero)
				CustomGameEventManager:Send_ServerToPlayer(player, "save_characters_loaded", {result = resultTable, message = "save_success", heroSlot = hero.saveSlot, premium = premium})
				Events:TutorialServerEvent(hero, "2_3", 0)
				Statistics.dispatch('hero:oracle:save')
				hero.roshpitID = resultTable.id
				if hero:GetUnitName() == "npc_dota_hero_arc_warden" then
					SaveLoad:SaveJex(hero)
				end
				SaveLoad:HeroSaveParticle(hero)
			end)
		end
	end
end

function SaveLoad:HeroSaveParticle(hero)
	CustomAbilities:QuickAttachParticle("particles/roshpit/save_game/save_hero/shovel_baby_roshan_spawn.vpcf", hero, 4)
	EmitSoundOn("ui.trophy_new", hero)
end

function escape(s)
	return string.gsub(s, "([^A-Za-z0-9_])", function(c)
		return string.format("%%%02x", string.byte(c))
	end)
end

function SaveLoad:AttachGlyphsToUrl(url, hero)
	local glyph = CustomNetTables:GetTableValue("skill_tree", tostring(hero:GetPlayerOwnerID()) .. "-glyph-"..tostring(1))
	if glyph.glyphIndex > 0 then
		glyph = EntIndexToHScript(glyph.glyphIndex)
		url = url.."&glyph_a="..glyph:GetAbilityName()
	else
		url = url.."&glyph_a=" .. "empty"
	end
	glyph = CustomNetTables:GetTableValue("skill_tree", tostring(hero:GetPlayerOwnerID()) .. "-glyph-"..tostring(2))
	if glyph.glyphIndex > 0 then
		glyph = EntIndexToHScript(glyph.glyphIndex)
		url = url.."&glyph_b="..glyph:GetAbilityName()
	else
		url = url.."&glyph_b=" .. "empty"
	end
	glyph = CustomNetTables:GetTableValue("skill_tree", tostring(hero:GetPlayerOwnerID()) .. "-glyph-"..tostring(3))
	if glyph.glyphIndex > 0 then
		glyph = EntIndexToHScript(glyph.glyphIndex)
		url = url.."&glyph_c="..glyph:GetAbilityName()
	else
		url = url.."&glyph_c=" .. "empty"
	end
	return url
end

function SaveLoad:AttachPortalKeysToUrl(url, hero)
	-- local normalKeys = CustomNetTables:GetTableValue("portal_keys", tostring(hero:GetEntityIndex()) .. "-"..1)
	-- local eliteKeys = CustomNetTables:GetTableValue("portal_keys", tostring(hero:GetEntityIndex()) .. "-"..2)
	-- local legendKeys = CustomNetTables:GetTableValue("portal_keys", tostring(hero:GetEntityIndex()) .. "-"..3)
	-- url = url.."&portal1normal="..normalKeys.forest
	-- url = url.."&portal2normal="..normalKeys.desert
	-- url = url.."&portal3normal="..normalKeys.mines
	-- url = url.."&portal1elite="..eliteKeys.forest
	-- url = url.."&portal2elite="..eliteKeys.desert
	-- url = url.."&portal3elite="..eliteKeys.mines
	-- url = url.."&portal1legend="..legendKeys.forest
	-- url = url.."&portal2legend="..legendKeys.desert
	-- url = url.."&portal3legend="..legendKeys.mines
	-- return url
end

function SaveLoad:DebugGear(playerID)
	for i = 0, 5, 1 do
		local gearTable = CustomNetTables:GetTableValue("equipment", tostring(playerID) .. "-"..tostring(i))
		--DeepPrintTable(gearTable)
	end
end

function SaveLoad:AttachItemToURL(url, hero, is_stash, stash_slot, playerID, gearSlot, item)
	--print("---------")
	--print("[SaveLoad:AttachItemToURL] Start")
	--print("ATTACHING ITEM FOR GEAR SLOT: "..gearSlot)
	if not item then
		--print("NO ITEM")
		return url
	end
	local itemIndex = item:GetEntityIndex()

	local itemTable = item.newItemTable

	if itemTable.cantStash then
		Notifications:Top(playerID, {text = "Can't stash this item", duration = 2, style = {color = "red"}, continue = true})
		return url
	end
	--print("[SaveLoad:AttachItemToURL] 2")
	local validatorValue = itemTable.validator
	if validatorValue then
		url = url.."&validator"..gearSlot.."="..validatorValue
	end

	if itemTable and itemTable.property1 and not itemTable.glyph and itemTable.consumable ~= true then
		--print("[SaveLoad:AttachItemToURL] Item Table and property1 exists")
		--DeepPrintTable(item.newItemTable)
		-- local itemName = string.gsub(itemTable.item_name, "%s+", '%%20')
		local item_name = ""
		if itemTable.item_name then
			item_name = escape(itemTable.item_name)
		end
		local internalMinLevel = math.max(itemTable.minLevel, 1)
		local buildNumber = "1"
		if itemTable.glyphBook then
			buildNumber = "-2"
		end
		url = url.."&build_number"..gearSlot.."="..buildNumber
		url = url.."&is_stash"..gearSlot.."="..is_stash
		url = url.."&stash_slot"..gearSlot.."="..stash_slot
		url = url.."&item_variant"..gearSlot.."="..item:GetAbilityName()
		url = url.."&item_name"..gearSlot.."="..item_name
		-- url = url.."&item_description"..gearSlot.."="..itemTable.itemDescription
		url = url.."&rarity"..gearSlot.."="..itemTable.rarityFactor
		url = url.."&item_slot"..gearSlot.."="..RPCItems:getGearSlot(itemTable.item_slot)
		url = url.."&min_level"..gearSlot.."="..internalMinLevel
		url = url.."&prefix"..gearSlot.."="..escape(itemTable.itemPrefix)
		url = url.."&suffix"..gearSlot.."="..escape(itemTable.itemSuffix)
		if itemTable.item_slot == "weapon" then
			url = url.."&is_weapon=" .. "1"
			url = url.."&weapon_xp="..itemTable.xp
			url = url.."&item_level="..itemTable.level
			url = url.."&max_level1="..itemTable.maxLevel
		else
			url = url.."&is_weapon=" .. "0"
		end
		if itemTable.requiredHero then
			if is_stash == 1 then
				url = url.."&required_hero1="..itemTable.requiredHero
			else
				url = url.."&required_hero"..gearSlot.."="..itemTable.requiredHero
			end
		-- else
		-- 	url = url.."&required_hero"..gearSlot.."="..0
		end

		local affixCount = math.min(itemTable.rarityFactor, 4)

		for i = 1, affixCount, 1 do
			local property = 0
			local propertyName = ""
			local saveTooltip = 1
			if i == 1 then
				--DeepPrintTable(itemTable)
				property = itemTable.property1
				propertyName = itemTable.property1name
				saveColor = itemTable.property1color
				saveTooltip = itemTable.property1tooltip
				saveSpecialDescription = itemTable.property1special
			elseif i == 2 then
				property = itemTable.property2
				propertyName = itemTable.property2name
				saveColor = itemTable.property2color
				saveTooltip = itemTable.property2tooltip
				saveSpecialDescription = itemTable.property2special
			elseif i == 3 then
				property = itemTable.property3
				propertyName = itemTable.property3name
				saveColor = itemTable.property3color
				saveTooltip = itemTable.property3tooltip
				saveSpecialDescription = itemTable.property3special
			elseif i == 4 then
				property = itemTable.property4
				propertyName = itemTable.property4name
				saveColor = itemTable.property4color
				saveTooltip = itemTable.property4tooltip
				saveSpecialDescription = itemTable.property4special
			end
			if type(property) == "string" and property == "★" then
				property = 1
			end
			url = url.."&property"..i..gearSlot.."="..property
			url = url.."&property"..i.."name"..gearSlot.."="..propertyName
			url = url.."&property"..i.."color"..gearSlot.."="..escape(saveColor)
			url = url.."&property"..i.."tooltip"..gearSlot.."="..escape(saveTooltip)
			if saveSpecialDescription then
				url = url.."&property"..i.."special"..gearSlot.."="..escape(saveSpecialDescription)
			end
		end
		if item.newItemTable.base_armor then
			url = url.."&base_armor"..gearSlot.."="..item.newItemTable.base_armor
		end
		if item.newItemTable.base_magic_armor then
			url = url.."&base_magic_armor"..gearSlot.."="..item.newItemTable.base_magic_armor
		end
		if item.newItemTable.inscription then
			url = url.."&inscription"..gearSlot.."="..Curator:urlencode(item.newItemTable.inscription)
		end
		if item.newItemTable.version then
			url = url.."&version"..gearSlot.."="..Curator:urlencode(item.newItemTable.version)
		else
			url = url.."&version"..gearSlot.."="..Curator:urlencode(ROSHPIT_VERSION)
		end
		if item.newItemTable.socket1 then
			url = url.."&socket1"..gearSlot.."="..item.newItemTable.socket1
			if item.newItemTable.socket1value then
				url = url.."&socket1value"..gearSlot.."="..item.newItemTable.socket1value
			end
		else
			url = url.."&socket1"..gearSlot.."=".."none"
			url = url.."&socket1value"..gearSlot.."="..0
		end
		if item.newItemTable.socket2 then
			url = url.."&socket2"..gearSlot.."="..item.newItemTable.socket2
			if item.newItemTable.socket2value then
				url = url.."&socket2value"..gearSlot.."="..item.newItemTable.socket2value
			end
		else
			url = url.."&socket2"..gearSlot.."=".."none"
			url = url.."&socket2value"..gearSlot.."="..0
		end
		if item.newItemTable.soulbound then
			url = url.."&soulbound"..gearSlot.."="..item.newItemTable.soulbound
			print(url)
		else
			url = url.."&soulbound"..gearSlot.."="..0
		end
		--print(url)
		-- url = url.."&min_level"..gearSlot.."="..itemTable.minLevel
	elseif itemTable.stashable then
		--print("[SaveLoad:AttachItemToURL] 4")
		local item_name = escape(itemTable.item_name)
		url = url.."&build_number"..gearSlot.."=" .. "-1"
		url = url.."&is_stash"..gearSlot.."="..is_stash
		url = url.."&stash_slot"..gearSlot.."="..stash_slot
		url = url.."&item_variant"..gearSlot.."="..item:GetAbilityName()
		url = url.."&item_name"..gearSlot.."="..item_name
		-- url = url.."&item_description"..gearSlot.."="..itemTable.itemDescription
		url = url.."&rarity"..gearSlot.."="..itemTable.rarityFactor
		url = url.."&item_slot"..gearSlot.."="..RPCItems:getGearSlot(itemTable.item_slot)
		url = url.."&min_level"..gearSlot.."="..0
		url = url.."&prefix"..gearSlot.."="..escape(itemTable.itemPrefix)
		url = url.."&suffix"..gearSlot.."="..escape(itemTable.itemSuffix)


		local affixCount = 0
		--print("TU78A")
		if item:GetAbilityName() == "item_rpc_web_premium_token" or string.match(item:GetAbilityName(), "galactic_arcana_cache") or string.match(item:GetAbilityName(), "item_serengaard_hyperstone") or string.match(item:GetAbilityName(), "item_rpc_unrefined_gemstones") or string.match(item:GetAbilityName(), "item_rpc_winterblight_tarot_card") or string.match(item:GetAbilityName(), "item_rpc_winterblight_dragon_scale")  then
			--print("TU78B")
			local affixCount = 1
			for i = 1, affixCount, 1 do
				local property = 0
				local propertyName = ""
				if i == 1 then
					property = itemTable.property1
					propertyName = itemTable.property1name
					saveColor = itemTable.property1color
					saveTooltip = itemTable.property1tooltip
					saveSpecialDescription = itemTable.property1special
				elseif i == 2 then
					property = itemTable.property2
					propertyName = itemTable.property2name
					saveColor = itemTable.property2color
					saveTooltip = itemTable.property2tooltip
					saveSpecialDescription = itemTable.property2special
				elseif i == 3 then
					property = itemTable.property3
					propertyName = itemTable.property3name
					saveColor = itemTable.property3color
					saveTooltip = itemTable.property3tooltip
					saveSpecialDescription = itemTable.property3special
				elseif i == 4 then
					property = itemTable.property4
					propertyName = itemTable.property4name
					saveColor = itemTable.property4color
					saveTooltip = itemTable.property4tooltip
					saveSpecialDescription = itemTable.property4special
				end
				if not property then
					property = 0
				end
				if type(property) == "string" and property == "★" then
					property = 1
				end
				if not propertyName then
					propertyName = ""
				end
				url = url.."&property"..i..gearSlot.."="..property
				url = url.."&property"..i.."name"..gearSlot.."="..propertyName
				url = url.."&property"..i.."color"..gearSlot.."="..escape(saveColor)
				url = url.."&property"..i.."tooltip"..gearSlot.."="..escape(saveTooltip)
				--print("----TU78C-----")
				--print(itemTable)
				--print("--------------")
				if saveSpecialDescription then
					url = url.."&property"..i.."special"..gearSlot.."="..escape(saveSpecialDescription)
				end
			end
		end
	elseif itemTable.glyph then
		local item_name = item:GetAbilityName()
		url = url.."&build_number"..gearSlot.."=" .. "-1"
		url = url.."&is_stash"..gearSlot.."="..is_stash
		url = url.."&stash_slot"..gearSlot.."="..stash_slot
		url = url.."&item_variant"..gearSlot.."="..item:GetAbilityName()
		url = url.."&item_name"..gearSlot.."=" .. "glyph"
	else
		url = url.."&build_number"..gearSlot.."="..0
		url = url.."&item_slot"..gearSlot.."="..gearSlot

	end
	--print("FINAL URL +++++++++++++++++++++++")
	----print(url)
	--print("FINAL URL +++++++++++++++++++++++")
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
	CreateHTTPRequestScriptVM("GET", url):Send(function(result)
		local resultTable = {}
		--print( "GET response:\n" )
		for k, v in pairs(result) do
			--print( string.format( "%s : %s\n", k, v ) )
		end
		--print( "Done." )
		local resultTable = JSON:decode(result.Body)
		local resultTable = SaveLoad:FixDuplicatedGear(resultTable)
		-- DeepPrintTable(resultTable)
		SaveLoad:ApplyDataToHero(resultTable.character, playerID)
		for i = 1, 6, 1 do
			Timers:CreateTimer((0.1 * i), function()
				SaveLoad:LoadGear(resultTable.gear[i], playerID, 1)
			end)
		end

		Timers:CreateTimer(1, function()
			SaveLoad:LoadGlyphs(resultTable.character, hero)
		end)
		-- Timers:CreateTimer(3, function()
		-- 	SaveLoad:LoadPortalKeys(resultTable.character, hero)
		-- end)
		CustomGameEventManager:Send_ServerToPlayer(player, "close_oracle", {})
		if GameState:IsRPCArena() then
			Arena:LoadChampionsLeagueData(hero, nil)
		end
		Timers:CreateTimer(3, function()
			hero:ReequipAllGear(nil)
		end)
		Timers:CreateTimer(5, function()
			Statistics.dispatch('hero:oracle:load')
		end)
		player.hero_loading = false
		hero.loading = false
	end)
end

function SaveLoad:FixDuplicatedGear(gearTable)
	print("[SaveLoad:FixDuplicatedGear] "..tostring(type(gearTable)))
	-- print("before ++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	-- DeepPrintTable(gearTable)
	-- print("before ++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	local function tableHasGear(tableToo, gearItemSlot)
		if tableToo and type(tableToo) == "table" and gearItemSlot and type(gearItemSlot) == "number" then
			for k, v in pairs(tableToo) do
				if type(v) == "table" and v.item_slot and type(v.item_slot) == "number" then
					if v.item_slot == gearItemSlot then
						return true
					end
				end
			end
		end
		return false
	end

	local newGearTable = {}
	if gearTable and type(gearTable) == "table" and gearTable.gear and type(gearTable.gear) == "table" then
		for k, v in pairs(gearTable.gear) do
			print(tostring(k).." -------------------------------------------------------------------")
			if type(v) == "table" then 
				if v.item_slot and type(v.item_slot) == "number" then
					if tableHasGear(newGearTable, v.item_slot) then
						print("[SaveLoad:FixDuplicatedGear] Table already have this slot: "..tostring(k))
					else
						table.insert(newGearTable, v)
					end
				end
			end
			print(tostring(k).." -------------------------------------------------------------------")
		end
		gearTable.gear = newGearTable
	end
	-- print("after ++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	-- DeepPrintTable(newGearTable)
	-- print("after ++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	return gearTable
end

function SaveLoad:LoadGlyphs(character, hero)
	if character.glyph_a == "" or character.glyph_a == "empty" then
	else
		local glyph = Glyphs:RollGlyphAll(character.glyph_a, Vector(0, 0), -1)
		--print("APPLY GLYPH: "..glyph:GetAbilityName())
		Glyphs:ApplyGlyph(hero, 1, glyph:GetEntityIndex())
	end
	if character.glyph_b == "" or character.glyph_b == "empty" then
	else
		local glyph = Glyphs:RollGlyphAll(character.glyph_b, Vector(0, 0), -1)
		--print("APPLY GLYPH: "..glyph:GetAbilityName())
		Glyphs:ApplyGlyph(hero, 2, glyph:GetEntityIndex())
	end
	if character.glyph_c == "" or character.glyph_c == "empty" then
	else
		local glyph = Glyphs:RollGlyphAll(character.glyph_c, Vector(0, 0), -1)
		--print("APPLY GLYPH: "..glyph:GetAbilityName())
		Glyphs:ApplyGlyph(hero, 3, glyph:GetEntityIndex())
	end
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_inventory", {})
	CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "update_runes", {})
end

function SaveLoad:LoadPortalKeys(character, hero)
	-- local heroIndex = hero:GetEntityIndex()
	-- CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex) .. "-" .. "1", {forest = character.portal1normal, desert = character.portal2normal, mines = character.portal3normal})
	-- CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex) .. "-" .. "2", {forest = character.portal1elite, desert = character.portal2elite, mines = character.portal3elite})
	-- CustomNetTables:SetTableValue("portal_keys", tostring(heroIndex) .. "-" .. "3", {forest = character.portal1legend, desert = character.portal2legend, mines = character.portal3legend})
	-- if GameState:IsWorld1() then
	-- 	Beacons:ActivatePortalsForKeys()
	-- 	CustomGameEventManager:Send_ServerToAllClients("update_key_display", {})
	-- end
end

function SaveLoad:LoadGear(gearTable, playerID, bEquip)
	--print("SaveLoad:LoadGear+++")
	--DeepPrintTable(gearTable)
	--print("SaveLoad:LoadGear++-")
	local hero = GameState:GetHeroByPlayerID(playerID)
	if not gearTable then
		return false
	end
	if not gearTable.item_variant then
		return false
	end
	gearTable = SaveLoad:CheckForOldNames(gearTable)
	if gearTable.build_number > -1 then
		local gearSlot = RPCItems:GetGearSlotName(gearTable.item_slot)
		--print("LOADED ITEM GEARSLOT")
		-- --print(gearSlot)
		-- DeepPrintTable(gearTable)
		local item = nil
		if gearTable.is_weapon == 1 then
			-- item = Weapons:CreateWeaponVariant(gearTable.item_variant,
			-- 	RPCItems:GetRarityNameFromFactor(gearTable.rarity),
			-- 	gearTable.item_name,
			-- 	gearSlot,
			-- 	true,
			-- 	"Slot: "..gearSlot:gsub("^%l", string.upper),
			-- 	gearTable.required_hero,
			-- 	gearTable.max_level,
			-- gearTable.min_level)
			item = Weapons:SetupBasicWeapon(gearTable.rarity, gearTable.min_level, gearTable.required_hero, gearTable.max_level, gearTable.item_variant, gearTable.level, gearTable.current_xp)
		else
			if gearTable.rarity == 6 then

				item = RPCItems:CreateArcanaBasic(gearTable.item_variant,
					RPCItems:GetRarityNameFromFactor(gearTable.rarity),
					gearTable.item_name,
					gearSlot,
					true,
					"Slot: "..gearSlot:gsub("^%l", string.upper),
					tostring(gearTable.required_hero),
				gearTable.min_level)

				--print(item.newItemTable.requiredHero)
			else

				item = RPCItems:CreateVariantWithMin(gearTable.item_variant,
					RPCItems:GetRarityNameFromFactor(gearTable.rarity),
					gearTable.item_name,
					gearSlot, true,
					"Slot: "..gearSlot:gsub("^%l", string.upper),
					gearTable.min_level,
					gearTable.prefix,
				gearTable.suffix)
				if gearTable.required_hero and gearTable.item_variant == "item_rpc_winterblight_skull_ring" then
					if type(gearTable.required_hero) == "string" and gearTable.required_hero == "0" then
					else
						item.newItemTable.requiredHero = gearTable.required_hero
					end
				end
			end
		end

		item.newItemTable.item_slot = gearSlot
		item.pickedUp = true
		--PROPERTY1
		item.newItemTable.property1 = gearTable.property1
		item.newItemTable.property1name = gearTable.property1name

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
			--print("[SaveLoad:LoadGear] PROPERTY2")
			item.newItemTable.property2 = gearTable.property2
			item.newItemTable.property2name = gearTable.property2name
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
			--print("[SaveLoad:LoadGear] PROPERTY3")
			item.newItemTable.property3 = gearTable.property3
			item.newItemTable.property3name = gearTable.property3name
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
			--print("[SaveLoad:LoadGear] PROPERTY4")
			item.newItemTable.property4 = gearTable.property4
			item.newItemTable.property4name = gearTable.property4name
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
		-- ARMOR AND SOCKETS
		if gearTable.base_armor then
			item.newItemTable.base_armor = gearTable.base_armor
		end
		if gearTable.base_magic_armor then
			item.newItemTable.base_magic_armor = gearTable.base_magic_armor
		end
		if gearTable.special_tag then
			item.newItemTable.inscription = gearTable.special_tag
		end
		if gearTable.version then
			item.newItemTable.version = gearTable.version
		end
		if gearTable.socket1 then
			item.newItemTable.socket1 = gearTable.socket1
			item.newItemTable.socket1value = gearTable.socket1value
		end
		if gearTable.socket2 then
			item.newItemTable.socket2 = gearTable.socket2
			item.newItemTable.socket2value = gearTable.socket2value
		end
		--WEAPON
		if gearTable.is_weapon == 1 then
			item.newItemTable.xp = gearTable.current_xp
			item.newItemTable.level = gearTable.level
			item.newItemTable.maxLevel = gearTable.max_level
		end
		-- SOULBIND
		if gearTable.soulbound then
			item.newItemTable.soulbound = gearTable.soulbound
		else
			item.newItemTable.soulbound = 0
		end
		item.expiryTime = nil
		item.pickedUp = true
		if gearTable.validator then
			item.newItemTable.validator = gearTable.validator
		end
		RPCItems:ItemUpdateCustomNetTables(item)

		if bEquip == 1 then
			if item.newItemTable.version == "3.9" then
				Curator:UpdateItemToCurrentVersion(item, hero, true)
			else
				hero:EquipItem(item, false, false)
			end
		else
			return item
		end
	else
		if gearTable.item_variant == "item_reanimation_stone" then
			local item = RPCItems:CreateConsumable("item_reanimation_stone", "mythical", "Reanimation Stone", "consumable", false, "Consumable", "reanimation_stone_desc")
			item.pickedUp = true
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif gearTable.item_name == "glyph" then
			--print(gearTable.item_variant)
			local item = Glyphs:RollGlyphAll(gearTable.item_variant, Vector(0, 0), -1)
			item.pickedUp = true
			SaveLoad:RemoveProperties(item)
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif gearTable.item_name == "temple_key" then
			local key = RPCItems:CreateConsumable(gearTable.item_variant, "rare", "temple_key", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			key.pickedUp = true
			SaveLoad:RemoveProperties(key)
			SaveLoad:RemoveAdditionalData(key, false, false)
			if gearTable.validator then
				key.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return key
		elseif gearTable.item_name == "tanari_element" then
			local element = RPCItems:CreateConsumable(gearTable.item_variant, "mythical", "tanari_element", "consumable", false, "Key Item", gearTable.item_variant.."_desc")
			element.pickedUp = true
			SaveLoad:RemoveProperties(element)
			SaveLoad:RemoveAdditionalData(element, false, false)
			if gearTable.validator then
				element.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return element
		elseif gearTable.item_name == "tanari_spirit_stones" then
			local stones = RPCItems:CreateConsumable(gearTable.item_variant, "immortal", "tanari_spirit_stones", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			stones.pickedUp = true
			SaveLoad:RemoveProperties(stones)
			SaveLoad:RemoveAdditionalData(stones, false, false)
			if gearTable.validator then
				stones.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return stones
		elseif gearTable.item_name == "redfall_key" then
			local key = RPCItems:CreateConsumable(gearTable.item_variant, "rare", "redfall_key", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			key.pickedUp = true
			SaveLoad:RemoveProperties(key)
			SaveLoad:RemoveAdditionalData(key, false, false)
			if gearTable.validator then
				key.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return key
		elseif gearTable.item_name == "glyph_book" then
			local item = Glyphs:CreateGlyphBook(gearTable.item_variant, gearTable.property1, gearTable.property2)
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif gearTable.item_variant == "item_rpc_web_premium_token" then
			--print("IN HERE??")
			local item = RPCItems:CreateConsumable("item_rpc_web_premium_token", "immortal", "Web Premium Token", "consumable", false, "Consumable", "web_premium_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.newItemTable.property1 = gearTable.property1
			item.newItemTable.property1color = gearTable.property1color
			item.newItemTable.property1name = gearTable.property1name
			item.newItemTable.property1tooltip = gearTable.property1tooltip
			item.newItemTable.consumable = true
			item.newItemTable.stashable = true
			RPCItems:SetPropertyValues(item, item.newItemTable.property1, "web_prem_tracking_id", item.newItemTable.property1color, 1)
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif gearTable.item_variant == "item_rpc_synthesis_vessel" then
			local item = RPCItems:CreateConsumable("item_rpc_synthesis_vessel", "immortal", "Synthesis Vessel", "consumable", false, "Consumable", "synthesis_vessel_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.newItemTable.consumable = true
			item.newItemTable.stashable = true
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif gearTable.item_variant == "item_rpc_socket_cutter" then
			local item = RPCItems:CreateConsumable("item_rpc_socket_cutter", "immortal", "Socket Cutter", "consumable", false, "Consumable", "socket_cutter_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.newItemTable.consumable = true
			item.newItemTable.stashable = true
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif gearTable.item_variant == "item_rpc_inscription_kit" then
			local item = RPCItems:CreateConsumable("item_rpc_inscription_kit", "mythical", "Socket Cutter", "consumable", false, "Consumable", "inscription_kit_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.newItemTable.consumable = true
			item.newItemTable.stashable = true
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif string.match(gearTable.item_variant, "galactic_arcana_cache") then
			local item = RPCItems:CreateConsumable(gearTable.item_variant, "arcana", "Arcana Cache Part", "consumable", false, "Consumable", gearTable.item_variant.."_desc")
			SaveLoad:RemoveProperties(item)
			SaveLoad:RemoveAdditionalData(item, false, false)
			item.newItemTable.stashable = true
			item.newItemTable.consumable = true
			item.pickedUp = true
			item.newItemTable.property1 = gearTable.property1
			item.newItemTable.property1name = gearTable.property1name
			item.newItemTable.property1color = gearTable.property1color
			item.newItemTable.property1tooltip = gearTable.property1tooltip
			RPCItems:SetPropertyValues(item, item.newItemTable.property1, "cache_radiance", item.newItemTable.property1color, 1)
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif gearTable.item_variant == "item_rpc_boreal_granite_chunk" or gearTable.item_variant == "item_rpc_grimloks_soul_vessel" or gearTable.item_variant == "item_rpc_galrens_skull" or gearTable.item_variant == "item_rpc_elynas_feather" or gearTable.item_variant == "item_rpc_emperors_band" or gearTable.item_variant == "item_rpc_empress_jewel" then
			local item = RPCItems:CreateBasicConsumable(nil, gearTable.item_variant, gearTable.item_name, RPCItems:GetRarityNameFromFactor(gearTable.rarity), false)
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif string.match(gearTable.item_variant, "item_serengaard_hyperstone") then
			local item = RPCItems:RollHyperstone(gearTable.property1)
			item.pickedUp = true
			item.newItemTable.stashable = true
			item.newItemTable.consumable = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif string.match(gearTable.item_variant, "item_rpc_currency_whetstone") then
			local item = RPCItems:CreateCurrencyWhetstone()
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif string.match(gearTable.item_variant, "item_rpc_currency_arcana_reroll") then
			local item = RPCItems:CreateCurrencyArcanaReroll()
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		elseif string.match(gearTable.item_variant, "item_rpc_unrefined_gemstones") then
			local item = Gems:CreateUnrefinedGemstones(gearTable.property1)
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			return item
		elseif string.match(gearTable.item_variant, "item_rpc_exp_orb") then
			local item = Challenges:CreateEXPOrb()
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			return item
		elseif string.match(gearTable.item_variant, "item_rpc_greater_exp_orb") then
			local item = Challenges:CreateGreaterEXPOrb()
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			return item
		elseif string.match(gearTable.item_variant, "item_rpc_winterblight_tarot_card") then
			local item = Winterblight:CreateCastleTarotCard(nil, string.gsub(gearTable.property1name, "tarot_", ""))
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			return item
		elseif gearTable.item_variant == "item_rpc_winterblight_dragon_scale" then
			DeepPrintTable(gearTable)
			local item = RPCItems:CreateBasicConsumableWithProperty1(nil, gearTable.item_variant, gearTable.item_name, RPCItems:GetRarityNameFromFactor(gearTable.rarity), false, gearTable.property1name, gearTable.property1, gearTable.property1color)
			item.pickedUp = true
			if gearTable.validator then
				item.newItemTable.validator = gearTable.validator
			end
			RPCItems:ItemUpdateCustomNetTables(item)
			return item
		end
	end
end

itemConverterTable = {
	["item_rpc_dunetread_boots"] = "item_rpc_dunetreads",
	["item_rpc_armor_of_violet_guard"] = "item_rpc_armor_of_the_violet_guard",
}
propertyConverterTable = {
	["!immortal!_modifier_plate_of_the_watcher1"] = "!immortal!_modifier_plate_of_the_watcher_one",
	["!immortal!_modifier_plate_of_the_watcher2"] = "!immortal!_modifier_plate_of_the_watcher_two",
	["!immortal!_modifier_plate_of_the_watcher3"] = "!immortal!_modifier_plate_of_the_watcher_three",
	["!immortal!_modifier_plate_of_the_watcher4"] = "!immortal!_modifier_plate_of_the_watcher_four",
	["!immortal!_modifier_dunetread_boots"] = "!immortal!_modifier_dunetreads",
	["!immortal!_modifier_violet_boots"] = "!immortal!_modifier_boots_of_the_violet_guard",
	["!immortal!_modifier_mask_of_ahnqhir_blue"] = "!immortal!_modifier_twisted_blue_mask_of_ahnqhir",
	["!immortal!_modifier_mask_of_ahnqhir_purple"] = "!immortal!_modifier_twisted_purple_mask_of_ahnqhir",
	["!immortal!_modifier_mask_of_ahnqhir_yellow"] = "!immortal!_modifier_twisted_yellow_mask_of_ahnqhir",
	["!immortal!_modifier_cerulean_high_guard"] = "!immortal!_modifier_veil_of_the_cerulean_high_guard",
	["!immortal!_modifier_armor_of_violet_guard"] = "!immortal!_modifier_armor_of_the_violet_guard",
}
tooltipConverterTable = {
	["#item_property_watcher_one"] = "#item_property_plate_of_the_watcher_one",
	["#item_property_watcher_two"] = "#item_property_plate_of_the_watcher_two",
	["#item_property_watcher_three"] = "#item_property_plate_of_the_watcher_three",
	["#item_property_watcher_four"] = "#item_property_plate_of_the_watcher_four",
	["#item_property_dunetread"] = "#item_property_dunetreads",
	["#item_property_violet_boot"] = "#item_property_boots_of_the_violet_guard",
	["#item_property_signus"] = "#item_property_signus_charm",
	["#item_property_phantom_sorcerer"] = "#item_property_mask_of_the_phantom_sorcerer",
	["#property_twisted_mask_of_ahnqhir_a"] = "#item_property_twisted_purple_mask_of_ahnqhir",
	["#property_twisted_mask_of_ahnqhir_b"] = "#item_property_twisted_yellow_mask_of_ahnqhir",
	["#property_twisted_mask_of_ahnqhir_c"] = "#item_property_twisted_blue_mask_of_ahnqhir",
	["#item_property_cerulean_highguard"] = "#item_property_veil_of_the_cerulean_high_guard",
	["#item_property_spellfire"] = "#item_property_spellfire_gloves",
	["#item_property_violet_guard_armor"] = "#item_property_armor_of_the_violet_guard",
	["#item_property_enchanted_solar"] = "#item_property_enchanted_solar_cape",
	["#item_property_emerald_speed"] = "#item_property_emerald_speed_runners",
	["#item_property_voyager"] = "#item_property_voyager_boots",
}
specialConverterTable = {
	["#property_watcher_one_description"] = "#property_plate_of_the_watcher_one_description",
	["#property_watcher_two_description"] = "#property_plate_of_the_watcher_two_description",
	["#property_watcher_three_description"] = "#property_plate_of_the_watcher_three_description",
	["#property_watcher_four_description"] = "#property_plate_of_the_watcher_four_description",
	["#property_dunetread_description"] = "#property_dunetreads_description",
	["#property_violet_boot_description"] = "#property_boots_of_the_violet_guard_description",
	["#property_signus_description"] = "#property_signus_charm_description",
	["#property_phantom_sorcerer_description"] = "#property_mask_of_the_phantom_sorcerer_description",
	["#property_twisted_mask_of_ahnqhir_a_Description"] = "#property_twisted_purple_mask_of_ahnqhir_Description",
	["#property_twisted_mask_of_ahnqhir_b_Description"] = "#property_twisted_yellow_mask_of_ahnqhir_Description",
	["#property_twisted_mask_of_ahnqhir_c_Description"] = "#property_twisted_blue_mask_of_ahnqhir_Description",
	["#property_cerulean_highguard_description"] = "#property_veil_of_the_cerulean_high_guard_description",
	["#property_spellfire_description"] = "#property_spellfire_gloves_description",
	["#property_violet_guard_armor_description"] = "#property_armor_of_the_violet_guard_description",
	["#property_enchanted_solar_description"] = "#property_enchanted_solar_cape_description",
	["#property_emerald_speed_description"] = "#property_emerald_speed_runners_description",
	["#property_voyager_description"] = "#property_voyager_boots_description",
}

function SaveLoad:CheckForOldNames(item)
	
	if itemConverterTable[item.item_variant] then
		item.item_variant = itemConverterTable[item.item_variant]
	end
	if propertyConverterTable[item.property1name] then
		item.property1name = propertyConverterTable[item.property1name]
	end
	if propertyConverterTable[item.property2name] then
		item.property2name = propertyConverterTable[item.property2name]
	end
	if propertyConverterTable[item.property3name] then
		item.property3name = propertyConverterTable[item.property3name]
	end
	if propertyConverterTable[item.property4name] then
		item.property4name = propertyConverterTable[item.property4name]
	end
	if tooltipConverterTable[item.property1tooltip] then
		item.property1tooltip = tooltipConverterTable[item.property1tooltip]
	end
	if tooltipConverterTable[item.property2tooltip] then
		item.property2tooltip = tooltipConverterTable[item.property2tooltip]
	end
	if tooltipConverterTable[item.property3tooltip] then
		item.property3tooltip = tooltipConverterTable[item.property3tooltip]
	end
	if tooltipConverterTable[item.property4tooltip] then
		item.property4tooltip = tooltipConverterTable[item.property4tooltip]
	end
	if specialConverterTable[item.property1special] then
		item.property1special = specialConverterTable[item.property1special]
	end
	if specialConverterTable[item.property2special] then
		item.property2special = specialConverterTable[item.property2special]
	end
	if specialConverterTable[item.property3special] then
		item.property3special = specialConverterTable[item.property3special]
	end
	if specialConverterTable[item.property4special] then
		item.property4special = specialConverterTable[item.property4special]
	end
	return item
end
function SaveLoad:FixLoadedRuneProperties(propertyName)
	if propertyName then
		--print("propertyName: "..propertyName)
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
	-- for i = 1, 4, 1 do
	-- RPCItems:SetPropertyValues(item, nil, nil, nil, i)
	-- end
end

function SaveLoad:RemoveAdditionalData(item, bRequiredLevel, bHeroRequirement)
	--local itemInfo = CustomNetTables:GetTableValue("item_basics", tostring(item:GetEntityIndex()))
	-- if bRequiredLevel then
	-- CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemInfo.item_name, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, minLevel = newItem.minLevel} )
	-- elseif bHeroRequirement then
	-- CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemInfo.item_name, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor, requiredHero = itemInfo.requiredHero  } )
	-- else
	-- CustomNetTables:SetTableValue( "item_basics", tostring(item:GetEntityIndex()), {itemName = itemInfo.item_name, consumable = itemInfo.consumable, itemDescription = itemInfo.itemDescription, qualityColor = itemInfo.qualityColor, qualityName = itemInfo.qualityName, itemPrefix = itemInfo.itemPrefix, itemSuffix = itemInfo.itemSuffix, rarityFactor = itemInfo.rarityFactor } )
	-- end
end

function SaveLoad:ApplyDataToHero(results, playerID)
	-- --print(results.current_xp)
	-- --print(hero)
	-- --print(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	hero:AddExperience(results.current_xp - hero:GetCurrentXP(), 0, false, false)
	CustomGameEventManager:Send_ServerToAllClients("xp_earned", {})
	-- Timers:CreateTimer(0.05, function()
	-- hero:AddExperience(results.current_xp, 0, false, false)
	-- end)
	hero.roshpitID = results.id
	hero.saveSlot = results.save_slot

	local rune_ability = hero.runeUnit:GetAbilityByIndex(DOTA_Q_SLOT)
	rune_ability.rune_level = math.min(results.rune_a_a, Runes.MAX_LEVEL_T1)
	rune_ability = hero.runeUnit:GetAbilityByIndex(DOTA_W_SLOT)
	rune_ability.rune_level = math.min(results.rune_a_b, Runes.MAX_LEVEL_T1)
	rune_ability = hero.runeUnit:GetAbilityByIndex(DOTA_E_SLOT)
	rune_ability.rune_level = math.min(results.rune_a_c, Runes.MAX_LEVEL_T1)
	rune_ability = hero.runeUnit:GetAbilityByIndex(DOTA_D_SLOT)
	rune_ability.rune_level = math.min(results.rune_a_d, Runes.MAX_LEVEL_T1)

	local rune_ability = hero.runeUnit2:GetAbilityByIndex(DOTA_Q_SLOT)
	rune_ability.rune_level = math.min(results.rune_b_a, Runes.MAX_LEVEL_T2)
	rune_ability = hero.runeUnit2:GetAbilityByIndex(DOTA_W_SLOT)
	rune_ability.rune_level = math.min(results.rune_b_b, Runes.MAX_LEVEL_T2)
	rune_ability = hero.runeUnit2:GetAbilityByIndex(DOTA_E_SLOT)
	rune_ability.rune_level = math.min(results.rune_b_c, Runes.MAX_LEVEL_T2)
	rune_ability = hero.runeUnit2:GetAbilityByIndex(DOTA_D_SLOT)
	rune_ability.rune_level = math.min(results.rune_b_d, Runes.MAX_LEVEL_T2)

	local rune_ability = hero.runeUnit3:GetAbilityByIndex(DOTA_Q_SLOT)
	rune_ability.rune_level = math.min(results.rune_c_a, Runes.MAX_LEVEL_T3)
	rune_ability = hero.runeUnit3:GetAbilityByIndex(DOTA_W_SLOT)
	rune_ability.rune_level = math.min(results.rune_c_b, Runes.MAX_LEVEL_T3)
	rune_ability = hero.runeUnit3:GetAbilityByIndex(DOTA_E_SLOT)
	rune_ability.rune_level = math.min(results.rune_c_c, Runes.MAX_LEVEL_T3)
	rune_ability = hero.runeUnit3:GetAbilityByIndex(DOTA_D_SLOT)
	rune_ability.rune_level = math.min(results.rune_c_d, Runes.MAX_LEVEL_T3)

	local rune_ability = hero.runeUnit4:GetAbilityByIndex(DOTA_Q_SLOT)
	rune_ability.rune_level = math.min(results.rune_d_a, Runes.MAX_LEVEL_T4)
	rune_ability = hero.runeUnit4:GetAbilityByIndex(DOTA_W_SLOT)
	rune_ability.rune_level = math.min(results.rune_d_b, Runes.MAX_LEVEL_T4)
	rune_ability = hero.runeUnit4:GetAbilityByIndex(DOTA_E_SLOT)
	rune_ability.rune_level = math.min(results.rune_d_c, Runes.MAX_LEVEL_T4)
	rune_ability = hero.runeUnit4:GetAbilityByIndex(DOTA_D_SLOT)
	rune_ability.rune_level = math.min(results.rune_d_d, Runes.MAX_LEVEL_T4)

	SaveLoad:ApplyAllRunes(hero, playerID)
	

	hero:GetAbilityByIndex(DOTA_Q_SLOT):SetLevel(results.ability1level)
	hero:GetAbilityByIndex(DOTA_W_SLOT):SetLevel(results.ability2level)
	hero:GetAbilityByIndex(DOTA_E_SLOT):SetLevel(results.ability3level)
	hero:GetAbilityByIndex(DOTA_R_SLOT):SetLevel(results.ability4level)


	Runes:UpdateHeroSkillAndRunePoints(hero, false)
end

function SaveLoad:ApplyAllRunes(hero, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(DOTA_Q_SLOT), hero.runeUnit, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(DOTA_W_SLOT), hero.runeUnit, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(DOTA_E_SLOT), hero.runeUnit, playerID)
	Runes:apply_runes(hero.runeUnit:GetAbilityByIndex(DOTA_D_SLOT), hero.runeUnit, playerID)
	Timers:CreateTimer(0.5, function()
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(DOTA_Q_SLOT), hero.runeUnit2, playerID)
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(DOTA_W_SLOT), hero.runeUnit2, playerID)
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(DOTA_E_SLOT), hero.runeUnit2, playerID)
		Runes:apply_runes(hero.runeUnit2:GetAbilityByIndex(DOTA_D_SLOT), hero.runeUnit2, playerID)
	end)

	Timers:CreateTimer(1, function()
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(DOTA_Q_SLOT), hero.runeUnit3, playerID)
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(DOTA_W_SLOT), hero.runeUnit3, playerID)
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(DOTA_E_SLOT), hero.runeUnit3, playerID)
		Runes:apply_runes(hero.runeUnit3:GetAbilityByIndex(DOTA_D_SLOT), hero.runeUnit3, playerID)
	end)
	Timers:CreateTimer(1.5, function()
		Runes:apply_runes(hero.runeUnit4:GetAbilityByIndex(DOTA_Q_SLOT), hero.runeUnit4, playerID)
		Runes:apply_runes(hero.runeUnit4:GetAbilityByIndex(DOTA_W_SLOT), hero.runeUnit4, playerID)
		Runes:apply_runes(hero.runeUnit4:GetAbilityByIndex(DOTA_E_SLOT), hero.runeUnit4, playerID)
		Runes:apply_runes(hero.runeUnit4:GetAbilityByIndex(DOTA_D_SLOT), hero.runeUnit4, playerID)
	end)
end

function SaveLoad:StashOpen(keys)
	local playerID = keys.playerID
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	local url = ROSHPIT_URL.."/champions/getStash?"
	url = url.."steam_id="..steamID
	CustomGameEventManager:Send_ServerToPlayer(player, "close_swap_ui", {})
	-- Weapons:ValidateGear(hero)
	if hero.stashTable then
		for i = 1, #hero.stashTable, 1 do
			if IsValidEntity(hero.stashTable[i]) then
				-- --print("------")
				-- --print(hero.stashTable[i]:GetEntityIndex())
				-- --print(hero.pullStashItem)
				if hero.stashTable[i]:GetEntityIndex() == hero.pullStashItem then
					hero.pullStashItem = nil
				else
					UTIL_Remove(hero.stashTable[i])
				end
			end
		end
		hero.stashTable = nil
	end
	CreateHTTPRequestScriptVM("GET", url):Send(function(result)
		local resultTable = {}
		--print( "GET response:\n" )
		for k, v in pairs(result) do
			--print( string.format( "%s : %s\n", k, v ) )
		end
		--print( "Done." )
		local resultTable = JSON:decode(result.Body)
		-- Weapons:ValidateGear(hero)
		-- DeepPrintTable(resultTable)
		local delay = #resultTable * 0.03 + 0.15
		SaveLoad:GenerateStashItems(resultTable, playerID, hero)
		-- SaveLoad:GetCharacterDataFromJSON(resultTable)
		Timers:CreateTimer(delay, function()
			CustomGameEventManager:Send_ServerToPlayer(player, "stash_loaded", {playerID = playerID, stashTable = hero.stash_view})
		end)
		-- CustomGameEventManager:Send_ServerToPlayer(player, "load_characters_loaded", {result=resultTable, message="collapse"} )
	end)
end

function SaveLoad:GenerateStashItems(resultTable, playerID, hero)
	local MAX_STASH_SLOTS = 48
	local slotsUsed = {}
	hero.stashTable = {}
	for i = 1, #resultTable, 1 do
		Timers:CreateTimer(i * 0.03, function()
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
			-- CustomNetTables:SetTableValue("stash", tostring(playerID).."-"..tostring(i), {itemIndex = 0} )
			-- end
		end)

	end
	-- local unusedSlots = {}
	-- for i = 1, MAX_STASH_SLOTS, 1 do
	-- table.insert(unusedSlots, i)
	-- end
	-- local t = unusedSlots

	-- for i = 1, #slotsUsed, 1 do
	-- local index = 1
	-- local size = #t
	-- while index <= size do
	--     if t[index] == slotsUsed[i] then
	--         t[index] = t[size]
	--         t[size] = nil
	--         size = size - 1
	--     else index = index + 1
	--     end
	-- end
	-- end
	-- for i = 1, #t, 1 do
	-- -- CustomNetTables:SetTableValue("stash", tostring(playerID).."-"..tostring(t[i]), {itemIndex = 0} )
	-- end
	local delay = #resultTable * 0.03 + 0.05
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
	-- local stashItem = hero.stashTable[i]
	-- if stashItem.stash_slot == i then
	-- table.insert(stash_table)
	-- end

end

	-- for i = 1, MAX_SAVE_SLOTS, 1 do
	-- characters[i] = {}
	-- end
	-- for i = 1, MAX_SAVE_SLOTS, 1 do
	-- if resultTable[i] then
	-- local slot = resultTable[i].save_slot
	-- --print(slot)
	-- characters[slot].heroName = resultTable[i].hero_name
	-- characters[slot].level = resultTable[i].hero_level
	-- end
	-- end
	-- for i = 1, MAX_SAVE_SLOTS, 1 do
	-- if not characters[i].heroName then
	-- characters[i].heroName = "empty"
	-- end
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
		--print("DRAGGED TO STASH")
		if itemEntity.cantStash then
			Notifications:Top(playerID, {text = "Can't Stash This", duration = 2, style = {color = "red"}, continue = true})
			EmitSoundOnClient("General.Cancel", hero:GetPlayerOwner())
			return false
		end
		--SaveLoad:NewKey()
		--print("-----HAS ITEM OR NOT BELOW-----")
		if keys.drag_type == "inventory" then
			if Challenges:CheckIfHeroHasItemByItemIndex(hero, itemIndex) then
				--print("HAS ITEM!")
			else
				--print("DOESN'T HAVE ITEM")
				return false
			end
		end
		if hero:HasModifier("modifier_stash_lock") then
			return false
		end
		CustomGameEventManager:Send_ServerToPlayer(player, "close_swap_ui", {})
		--print("DRAGGED TO")
		if SaveLoad:GetAllowSaving() then
			if stashSlot < 13 or GameState:GetPlayerPremiumStatus(playerID) then
				if keys.drag_type == "inventory" then
					hero:Stop()
					--print("TAKE ITEM")
					hero:TakeItem(itemEntity)
					if IsValidEntity(itemEntity:GetContainer()) then
						UTIL_Remove(itemEntity:GetContainer())
					end
					local url = ROSHPIT_URL.."/champions/saveStashItem?"
					url = url.."steam_id="..steamID
					url = SaveLoad:AttachItemToURL(url, hero, 1, stashSlot, playerID, 0, itemEntity)
					url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
					Events.GameMasterAbility:ApplyDataDrivenModifier(Events.GameMaster, hero, "modifier_stash_lock", {duration = 90})
					CreateHTTPRequestScriptVM("POST", url):Send(function(result)
						--print( "POST response:\n" )
						for k, v in pairs(result) do
							--print( string.format( "%s : %s\n", k, v ) )
						end
						--SaveLoad:NewKey()
						--print( "Done." )
						--print(result.StatusCode)
						hero:RemoveModifierByName("modifier_stash_lock")
						if result.StatusCode == 200 then
							RPCItems:ItemUTIL_Remove(itemEntity)
							-- Weapons:ValidateGear(hero)
							local resultTable = JSON:decode(result.Body)
							--print("@@@@ WITHDRAW RESULTS @@@@")
							--print(resultTable)
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
								CustomNetTables:SetTableValue("item_basics", tostring(itemEntity:GetEntityIndex()) .. "-returned", {returned = 1})
							end
						end
					end)
				else
					if fromSlot > 12 or stashSlot > 12 then
						if not GameState:GetPlayerPremiumStatus(playerID) then
							Notifications:Top(playerID, {text = "Premium Only", duration = 2, style = {color = "red"}, continue = true})
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
					url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
					CreateHTTPRequestScriptVM("POST", url):Send(function(result)
						--SaveLoad:NewKey()
						--print( "POST response:\n" )
						for k, v in pairs(result) do
							--print( string.format( "%s : %s\n", k, v ) )
						end
						--print( "Done." )
						local resultTable = JSON:decode(result.Body)
						local keys = {}

						keys.playerID = playerID
						-- CustomGameEventManager:Send_ServerToPlayer(player, "stash_item_upated", {stashSlot = stashSlot, item = itemIndex} )
						SaveLoad:StashOpen(keys)
					end)
				end
			else
				Notifications:Top(playerID, {text = "Premium Only", duration = 2, style = {color = "red"}, continue = true})
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
		--SaveLoad:NewKey()

		--print("DRAGGED FROM STASH")
		if SaveLoad:GetAllowSaving() then
			if hero:GetItemInSlot(inventorySlot) then
				if stashSlot < 12 or GameState:GetPlayerPremiumStatus(playerID) then
					local itemEntity = hero:GetItemInSlot(inventorySlot)
					if itemEntity.cantStash then
						Notifications:Top(playerID, {text = "Can't Stash This", duration = 2, style = {color = "red"}, continue = true})
						EmitSoundOnClient("General.Cancel", caster:GetPlayerOwner())
						return false
					end
					hero:TakeItem(itemEntity)
					if IsValidEntity(itemEntity:GetContainer()) then
						UTIL_Remove(itemEntity:GetContainer())
					end
					local url = ROSHPIT_URL.."/champions/saveStashItem?"
					url = url.."steam_id="..steamID
					url = SaveLoad:AttachItemToURL(url, hero, 1, stashSlot, playerID, 0, itemEntity)
					url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)

					CreateHTTPRequestScriptVM("POST", url):Send(function(result)
						--SaveLoad:NewKey()
						--print( "POST response:\n" )
						for k, v in pairs(result) do
							--print( string.format( "%s : %s\n", k, v ) )
						end
						--print( "Done." )
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
								CustomNetTables:SetTableValue("item_basics", tostring(itemEntity:GetEntityIndex()) .. "-returned", {returned = 1})
							end
						end
					end)
				else
					local keys = {}
					keys.playerID = playerID
					SaveLoad:StashOpen(keys)
					Notifications:Top(playerID, {text = "Premium Only", duration = 2, style = {color = "red"}, continue = true})
				end
			else
				local url = ROSHPIT_URL.."/champions/removeStashItem?"
				url = url.."steam_id="..steamID
				url = url.."&stash_slot="..stashSlot
				url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
				----print(url)
				CreateHTTPRequestScriptVM("POST", url):Send(function(result)
					--SaveLoad:NewKey()
					--print( "POST response:\n" )
					for k, v in pairs(result) do
						--print( string.format( "%s : %s\n", k, v ) )
					end
					--print( "Done." )
					if result.StatusCode == 200 then
						local resultTable = JSON:decode(result.Body)
						local keys = {}
						--print(resultTable)
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
						CustomNetTables:SetTableValue("stash", tostring(playerID) .. "-"..tostring(stashSlot), {itemIndex = 0})
						Events:TutorialServerEvent(hero, "3_5", 1)
					end
				end)
			end
		end
	end

	function SaveLoad:PutItemInInventory(hero, itemIndex)
		--print("ADD ITEM!")
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

			local abilityTable = {previewHero:GetAbilityByIndex(DOTA_Q_SLOT):GetEntityIndex(), previewHero:GetAbilityByIndex(DOTA_W_SLOT):GetEntityIndex(), previewHero:GetAbilityByIndex(DOTA_E_SLOT):GetEntityIndex(), previewHero:GetAbilityByIndex(DOTA_D_SLOT):GetEntityIndex()}
			CustomGameEventManager:Send_ServerToPlayer(player, "updateSkillPreview", {heroIndex = previewHero:GetEntityIndex()})
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
			CustomGameEventManager:Send_ServerToAllClients("update_picked_heroes", {selectedHero = heroName})
			PrecacheUnitByNameAsync(heroName, function(...) end)
			if GameState:GetHeroByPlayerID(playerID) == -1 then
				Timers:CreateTimer(2, function()
					if GameState:GetHeroByPlayerID(playerID) == -1 then
						if player:GetAssignedHero():GetUnitName() == "npc_dota_hero_wisp" then
							PlayerResource:ReplaceHeroWith(playerID, heroName, 0, 0)
							Timers:CreateTimer(1, function()
								local hero = GameState:GetHeroByPlayerID(playerID)
								hero.actual_game_hero = true
								-- hero = EntIndexToHScript(hero)
								hero.muteMusic = msg.muteMusic
							end)
						end
					end
				end)
				Timers:CreateTimer(2.4, function()
					local hero = GameState:GetHeroByPlayerID(playerID)
					Runes:UpdateHeroSkillAndRunePoints(hero)
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
		CreateHTTPRequestScriptVM("GET", url):Send(function(result)
			if result.StatusCode == 200 then
				local resultTable = {}
				--print( "GET response:\n" )
				for k, v in pairs(result) do
					--print( string.format( "%s : %s\n", k, v ) )
				end
				--print( "Done." )
				local resultTable = JSON:decode(result.Body)
				CustomGameEventManager:Send_ServerToPlayer(player, "player_keys_loaded", {result = resultTable, premium = premium})
				Events:TutorialServerEvent(hero, "5_2", 0)
			else

			end
		end)
	end

	function SaveLoad:WithdrawKey(msg)
		local playerID = msg.playerID
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		local player = PlayerResource:GetPlayer(playerID)
		local hero = GameState:GetHeroByPlayerID(playerID)
		if not SaveLoad:GetAllowSaving() then
			return false
		end
		local keyIndex = msg.keyIndex
		local limit = 20
		local url = ROSHPIT_URL.."/champions/updatePlayerKeys?"
		url = url.."steam_id="..steamID
		url = url.."&limit="..limit
		url = url.."&change=-1"
		url = url.."&keyIndex="..msg.keyIndex
		url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)

		-- local url = ROSHPIT_URL.."/champions/getPlayerKeys?"
		-- url = url.."steam_id="..steamID
		CreateHTTPRequestScriptVM("POST", url):Send(function(result)
			--SaveLoad:NewKey()
			if result.StatusCode == 200 then
				local resultTable = {}
				--print( "GET response:\n" )
				for k, v in pairs(result) do
					--print( string.format( "%s : %s\n", k, v ) )
				end
				--print( "Done." )
				local resultTable = JSON:decode(result.Body)
				CustomGameEventManager:Send_ServerToPlayer(player, "player_keys_loaded", {result = resultTable})
				SaveLoad:WithdrawKeyFinal(hero, keyIndex)
			else
				--print( "GET response:\n" )
				for k, v in pairs(result) do
					--print( string.format( "%s : %s\n", k, v ) )
				end
				--print( "Done." )
			end
		end)
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
		url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
		--print(url)
		if SaveLoad:GetAllowSaving() then
			local itemEntity = EntIndexToHScript(itemIndex)
			hero:TakeItem(itemEntity)
			if IsValidEntity(itemEntity:GetContainer()) then
				UTIL_Remove(itemEntity:GetContainer())
			end

			-- local url = ROSHPIT_URL.."/champions/getPlayerKeys?"
			-- url = url.."steam_id="..steamID
			CreateHTTPRequestScriptVM("POST", url):Send(function(result)
				--SaveLoad:NewKey()
				if result.StatusCode == 200 then
					local resultTable = {}
					--print( "GET response:\n" )
					for k, v in pairs(result) do
						--print( string.format( "%s : %s\n", k, v ) )
					end
					--print( "Done." )
					local resultTable = JSON:decode(result.Body)
					RPCItems:ItemUTIL_Remove(itemEntity)
					CustomGameEventManager:Send_ServerToPlayer(player, "player_keys_loaded", {result = resultTable, premium = premium})
				else
					--print( "GET response:\n" )
					for k, v in pairs(result) do
						--print( string.format( "%s : %s\n", k, v ) )
					end
					--print( "Done." )
				end
			end)
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
			key.newItemTable.stashable = true
			key.newItemTable.consumable = true
			RPCItems:ItemUpdateCustomNetTables(key)
			RPCItems:GiveItemToHeroWithSlotCheck(hero, key)
		elseif keyIndex == 12 then
			local item = RPCItems:CreateConsumable("item_rpc_synthesis_vessel", "immortal", "Synthesis Vessel", "consumable", false, "Consumable", "synthesis_vessel_desc")
			item.newItemTable.consumable = true
			item.newItemTable.stashable = true
			item.pickedUp = true
			RPCItems:ItemUpdateCustomNetTables(item)
			RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
		elseif keyIndex == 13 then
			local item = RPCItems:CreateConsumable("item_rpc_socket_cutter", "immortal", "Socket Cutter", "consumable", false, "Consumable", "socket_cutter_desc")
			item.newItemTable.consumable = true
			item.newItemTable.stashable = true
			item.pickedUp = true
			RPCItems:ItemUpdateCustomNetTables(item)
			RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
		elseif keyIndex == 14 then
			local item = RPCItems:CreateConsumable("item_rpc_inscription_kit", "mythical", "Socket Cutter", "consumable", false, "Consumable", "inscription_kit_desc")
			item.newItemTable.consumable = true
			item.newItemTable.stashable = true
			item.pickedUp = true
			RPCItems:ItemUpdateCustomNetTables(item)
			RPCItems:GiveItemToHeroWithSlotCheck(hero, item)
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
		url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
		url = url.."&tony_key="..GetDedicatedServerKeyV2("tony")
		for i = 1, #elements_table, 1 do
			local element1 = elements_table[i]
			-- local other_elements = get_other_elements(onibi, element1)
			for k = 1, #elements_table, 1 do
				for j = 1, #ability_keys, 1 do
					local ability_key = ability_keys[j]
					local element2 = elements_table[k]
					if onibi.stats_table[element1][element2][ability_key]["level"] then
						url = url.."&tech_"..element1.."-"..element2.."_"..ability_key.."="..onibi.stats_table[element1][element2][ability_key]["level"]
					end
				end
			end
			url = url.."&"..element1.."_exp="..onibi.stats_table[element1]["exp"]
		end
		----print(url)
		if SaveLoad:GetAllowSaving() then
			CreateHTTPRequestScriptVM("POST", url):Send(function(result)
				if result.StatusCode == 200 then
					local resultTable = {}
					--print( "GET response:\n" )
					for k, v in pairs(result) do
						--print( string.format( "%s : %s\n", k, v ) )
					end
					--print( "Done." )
					local resultTable = JSON:decode(result.Body)
				else
					--print( "GET response:\n" )
					for k, v in pairs(result) do
						--print( string.format( "%s : %s\n", k, v ) )
					end
					--print( "Done." )
				end
			end)
		end
	end

	function SaveLoad:SaveCharacterGeneric(hero)
		if SaveLoad:GetAllowSaving() then
			if not hero.save_counter then
				hero.save_counter = 0
			end
			hero.save_counter = hero.save_counter + 1
			local save_count_check = hero.save_counter
			local playerID = hero:GetPlayerOwnerID()
			if hero.saveSlot and hero.saveSlot > 0 then
				Timers:CreateTimer(SaveLoad.SAVE_COOLDOWN, function()
					if hero.save_counter == save_count_check then
						local save_message = {}
						save_message.playerID = playerID
						save_message.slot = hero.saveSlot
						save_message.heroIndex = hero:GetEntityIndex()
						save_message.ignore_callback = true
						SaveLoad:SaveCharacter(save_message)
					end
				end)
			end
		end
	end

	function SaveLoad:GenericSaveWithPremiumCheck(hero)
		local premium_allowed = true
		if hero.saveSlot and hero.saveSlot > 0 then
			if hero.saveSlot > 8 then
				if not GameState:GetPlayerPremiumStatus(hero:GetPlayerOwnerID()) then
					premium_allowed = false
				end
			end
			if premium_allowed then
				SaveLoad:SaveCharacterGeneric(hero)
			end
		end
	end
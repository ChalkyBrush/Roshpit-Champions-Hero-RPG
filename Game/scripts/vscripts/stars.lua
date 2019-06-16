if Stars == nil then
  Stars = class({})
end

function Stars:ActivateStarsMenu(msg)
	local heroIndex = msg.heroIndex
	local hero = EntIndexToHScript(heroIndex)
	local playerID = hero:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(playerID)

	local herosTable = HerosCustom:GetAvailableHerosTable()
	-- starsData.categories = {}
	-- for i = 1, #herosTable, 1 do
	-- 	table.insert(starsData.categories, {herosTable[i], 1, 2, 3, 1, 2, 3, 1, 2, 3, 0})
	-- end
	local starsData = Stars:GetOrganizedStarData(playerID)
	DeepPrintTable(starsData)
	local openingPlayer = PlayerResource:GetPlayer(msg.openingPlayerID)
	CustomGameEventManager:Send_ServerToPlayer(openingPlayer, "open_stars", {playerID = playerID, starsData = starsData, grandTotalStars = hero.grandTotalStars})
	Events:TutorialServerEvent(hero, "1_4", 0)
end

function Stars:StarEventAll(starEventName)
end

function Stars:GetOrganizedStarData(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = GameState:GetHeroByPlayerID(playerID)
	return hero.starsData
end

function Stars:StarEventSolo(starEventName, hero)
	-- if not SaveLoad:GetAllowSaving() then
	-- 	return false
	-- end
	if #MAIN_HERO_TABLE == 1 then
		local heroTable = HerosCustom:GetAvailableHerosTable()
		local heroCount = #heroTable
		local starData = Stars:GetOrganizedStarData(hero:GetPlayerOwnerID())
		if not starData then
			return false
		end
		local categoryData = starData[heroCount + 1]
		local starAmount = 0
		if starEventName == "autumnmist" then
			starAmount = getStarAmountForBasicBossKill()
			if categoryData.autumnmist < starAmount then
				Timers:CreateTimer(5, function()
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
					Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
				end)
			end 
		elseif starEventName == "shipyard" then
			starAmount = getStarAmountForBasicBossKill()
			if categoryData.shipyard < starAmount then
				Timers:CreateTimer(5, function()
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
					Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
				end)
			end
		elseif starEventName == "castle" then
			starAmount = getStarAmountForBasicBossKill()
			if categoryData.castle < starAmount then
				Timers:CreateTimer(5, function()
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
					Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
				end)
			end
		elseif starEventName == "wind" then
			starAmount = getStarAmountForBasicBossKill()
			if categoryData.wind < starAmount then
				Timers:CreateTimer(5, function()
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
					Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
				end)
			end
		elseif starEventName == "water" then
			starAmount = getStarAmountForBasicBossKill()
			if categoryData.water < starAmount then
				Timers:CreateTimer(5, function()
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
					Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
				end)
			end
		elseif starEventName == "fire" then
			starAmount = getStarAmountForBasicBossKill()
			if categoryData.fire < starAmount then
				Timers:CreateTimer(5, function()
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
					Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
				end)
			end
		elseif starEventName == "pitoftrials" then
			if Arena.PitLevel == 7 then
				starAmount = 3
			elseif Arena.PitLevel >= 4 then
				starAmount = 2
			else
				starAmount = 1
			end
			if categoryData.pitoftrials < starAmount then
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
				Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
			end 
		elseif starEventName == "weapon" then
			if GameState:IsTanariJungle() then
				if Tanari.GodDefeated then
					if Events.SpiritRealm then
						starAmount = 3
					else
						starAmount = 2
					end
				else
					starAmount = 1
				end
				if categoryData.weapon < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
					Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
			end
		elseif starEventName == "azalea" then
			starAmount = 1
			if GameState:GetDifficultyFactor() >= 3 then
				starAmount = 2
			end
			if GameState:GetDifficultyFactor() >= 3 and Winterblight.Stones >= 3 then
				starAmount = 3
			end
			if categoryData.azalea < starAmount then
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
				Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
			end 
		elseif starEventName == "valdun" then
			starAmount = 1
			if GameRules:GetDOTATime(false, false) <= 2700 then
				starAmount = 2
			end
			if GameRules:GetDOTATime(false, false) <= 1800 then
				starAmount = 3
			end
			if categoryData.valdun < starAmount then
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
				Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
			end 
		end
	end
	if starEventName == "champleague" then
		local heroTable = HerosCustom:GetAvailableHerosTable()
		local heroCount = #heroTable
		local starData = Stars:GetOrganizedStarData(hero:GetPlayerOwnerID())
		if not starData then
			return false
		end
		local categoryData = starData[heroCount + 1]
		local starAmount = 0
		starAmount = 1
		if hero.tutorial.section1.reward == 1 then
			starAmount = 2
		end
		if hero.tutorial.section6.reward == 1 then
			starAmount = 3
		end
		if categoryData.champleague < starAmount then
			CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = "solo_stars"})
			Stars:UpdateStarsOnServer("solo_stars", starEventName, starAmount, hero:GetPlayerOwnerID())
			return true
		else
			return false
		end
	end
end

function Stars:StarEventPlayer(starEventName, hero)
	print("STAR EVENT PLAYER")
	if SaveLoad:GetAllowSaving() then
		local playerID = hero:GetPlayerOwnerID()
		if not RPCItems:GetIsPlayerConnected(playerID) then
			return false
		end
		print("STAR EVENT PLAYER AND CONNECTED")
		local starAmount = 0
		local starData = Stars:GetOrganizedStarData(hero:GetPlayerOwnerID())
		if starData then
			if starEventName == "power_up" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = math.floor(hero:GetLevel()/40)
				if categoryData.power_up < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end
			elseif starEventName == "autumnmist" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = getStarAmountForBasicBossKill()
				if categoryData.autumnmist < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "shipyard" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = getStarAmountForBasicBossKill()
				if categoryData.shipyard < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "castle" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = getStarAmountForBasicBossKill()
				if categoryData.castle < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "wind" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = getStarAmountForBasicBossKill()
				if categoryData.wind < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "water" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = getStarAmountForBasicBossKill()
				if categoryData.water < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "fire" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = getStarAmountForBasicBossKill()
				if categoryData.fire < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "serengaard" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				if Serengaard.wave == 20 then
					starAmount = 1
				elseif Serengaard.wave == 30 then
					starAmount = 2
					if GameState:GetDifficultyFactor() == 3 then
						starAmount = 3
					end
				end
				if categoryData.serengaard < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
			elseif starEventName == "serengaard_infinite" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				if Serengaard.InfiniteWaveCount == 10 then
					starAmount = 1
				elseif Serengaard.InfiniteWaveCount == 30 then
					starAmount = 2
				elseif Serengaard.InfiniteWaveCount == 60 then
					starAmount = 3
				end
				if categoryData.serengaard_infinite < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
			elseif starEventName == "champleague" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				if hero.ChampionsLeague.rank == 1 then
					starAmount = 3
				elseif hero.ChampionsLeague.rank <= 5 then
					starAmount = 2
				elseif hero.ChampionsLeague.rank <= 10 then
					starAmount = 1
				end
				if categoryData.champleague < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
			elseif starEventName == "pitoftrials" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				if Arena.PitLevel == 7 then
					starAmount = 3
				elseif Arena.PitLevel >= 4 then
					starAmount = 2
				else
					starAmount = 1
				end
				if categoryData.pitoftrials < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "weapon" and hero.weapon then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				local weaponLevel1 = hero.weapon.newItemTable.level
				if weaponLevel1 >= 40 then
					starAmount = 3
				elseif weaponLevel1 >= 30 then
					starAmount = 2
				else
					starAmount = 1
				end
				if categoryData.weapon < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end
			elseif starEventName == "azalea" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = 1
				if GameState:GetDifficultyFactor() >= 3 then
					starAmount = 2
				end
				if GameState:GetDifficultyFactor() >= 3 and Winterblight.Stones >= 3 then
					starAmount = 3
				end
				if categoryData.azalea < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end 
				Stars:StarEventSolo(starEventName, hero)
			elseif starEventName == "valdun" then
				local categoryData = starData[HerosCustom:GetHeroIndex(hero:GetUnitName())]
				starAmount = 1
				if #MAIN_HERO_TABLE == 1 then
					starAmount = 2
				end
				if #MAIN_HERO_TABLE == 1 and GameRules:GetDOTATime(false, false) <= 3600 then
					starAmount = 3
				end
				if categoryData.valdun < starAmount then
					CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "star_popout", {playerID = playerID, starAmount = starAmount, starTitle = starEventName, heroName = hero:GetUnitName()})
					Stars:UpdateStarsOnServer(hero:GetUnitName(), starEventName, starAmount, hero:GetPlayerOwnerID())
				end  
				Stars:StarEventSolo(starEventName, hero)
			end
		--else
		--	Timers:CreateTimer(10, function()
		--		Stars:StarEventPlayer(starEventName, hero)
		--	end)
		end
	end
end

function getStarAmountForBasicBossKill()
	local starAmount = 0
	if GameState:GetDifficultyFactor() <= 2 then
		starAmount = 1
	elseif GameState:GetDifficultyFactor() == 3 then
		if Events.SpiritRealm then
			starAmount = 3
		else
			starAmount = 2
		end
	end
	return starAmount
end

function Stars:UpdateStarsOnServer(heroName, type, starAmount, playerID)
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/updateStars?"
	url = url.."steam_id="..steamID
	url = url.."&starTitle="..type
	url = url.."&stars="..starAmount
	url = url.."&hero_name="..heroName
	url = url.."&key1="..GetDedicatedServerKeyV2(SaveLoad.KeyVersion)
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			-- print( "GET response:\n" )
			for k,v in pairs( result ) do
				-- print( string.format( "%s : %s\n", k, v ) )
			end
			-- print( "Done." )
			-- print("STARS UPDATED")
			local resultTable = JSON:decode(result.Body)
			Stars:parseHeroData(player, resultTable)
		end
	end )	
end

function Stars:parseHeroData(player, resultTable)
	DeepPrintTable(resultTable)
	local herosTable = HerosCustom:GetAvailableHerosTable()
	local heroCount = #herosTable
	table.insert(herosTable, "solo_stars")
	local starsData = {}
	local grandTotalStars = 0
	for j = 1, #herosTable, 1 do
		local gotHero = false
		for i = 1, #resultTable, 1 do
			if herosTable[j] == resultTable[i].hero_name then
				gotHero = true
				table.insert(starsData, {hero_name = herosTable[j], power_up = resultTable[i].power_up, autumnmist = resultTable[i].autumnmist, shipyard = resultTable[i].shipyard, castle = resultTable[i].castle, wind = resultTable[i].wind, water = resultTable[i].water, fire = resultTable[i].fire, champleague = resultTable[i].champleague, pitoftrials = resultTable[i].pitoftrials, weapon = resultTable[i].weapon, serengaard = tonumber(resultTable[i].serengaard), serengaard_infinite = tonumber(resultTable[i].serengaard_infinite), valdun = resultTable[i].valdun, azalea = resultTable[i].azalea})
				grandTotalStars = grandTotalStars + resultTable[i].power_up + resultTable[i].autumnmist + resultTable[i].shipyard + resultTable[i].castle + resultTable[i].wind + resultTable[i].water + resultTable[i].fire + resultTable[i].champleague + resultTable[i].pitoftrials + resultTable[i].weapon + tonumber(resultTable[i].serengaard) + tonumber(resultTable[i].serengaard_infinite) + resultTable[i].valdun + resultTable[i].azalea
			end
		end
		if not gotHero then
			table.insert(starsData, {hero_name = herosTable[j], power_up = 0, autumnmist = 0, shipyard = 0, castle = 0, wind = 0, water = 0, fire = 0, champleague = 0, pitoftrials = 0, weapon = 0, serengaard = 0, serengaard_infinite = 0, valdun = 0, azalea = 0})
		end
	end
	local hero = GameState:GetHeroByPlayerID(player:GetPlayerID())
	hero.starsData = starsData
	hero.grandTotalStars = grandTotalStars
	-- DeepPrintTable(hero.starsData)
end

function Stars:GetPlayerStars(playerID)
	-- if not Beacons.cheats then
	-- 	return false
	-- end
	print("GET STARS!!")
	local steamID = PlayerResource:GetSteamAccountID(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local url = ROSHPIT_URL.."/champions/getStars?"
	url = url.."steam_id="..steamID
	print(url)
	CreateHTTPRequestScriptVM( "GET", url ):Send( function( result )
		if result.StatusCode == 200 then
			local resultTable = {}
			-- print( "GET response:\n" )
			-- for k,v in pairs( result ) do
			-- 	print( string.format( "%s : %s\n", k, v ) )
			-- end
			print( "Done." )
			local resultTable = JSON:decode(result.Body)
			Stars:parseHeroData(player, resultTable)
			Timers:CreateTimer(3, function()
				Stars:StarEventPlayer("power_up", GameState:GetHeroByPlayerID(playerID))
			end)
		end
	end )	
end
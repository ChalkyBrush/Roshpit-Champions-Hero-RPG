function RPCItems:InitiateTrade(msg)
	local heroFrom = EntIndexToHScript(msg.heroFrom)
	local heroTo = EntIndexToHScript(msg.heroTo)
	if not heroFrom.lastTrade then
		heroFrom.lastTrade = 0
	end
	if not heroFrom.tradeSendCount then
		heroFrom.tradeSendCount = 1
	end
	local distance = WallPhysics:GetDistance(heroFrom:GetAbsOrigin(), heroTo:GetAbsOrigin())
	if distance < 500 then
		if heroTo.trading or heroFrom.trading then
			Notifications:Top(heroFrom:GetPlayerOwnerID(), {text = "Busy", duration = 2, style = {color = "red"}, continue = true})
		else
			local tradeTime = (20 * heroFrom.tradeSendCount)
			if heroFrom.lastTrade < GameRules:GetGameTime() - tradeTime then
				heroFrom.lastTrade = GameRules:GetGameTime()
				--print("Trading with: "..heroTo:GetUnitName())

				heroFrom.tradeTable = {-1, -1, -1, -1, -1, -1}
				heroTo.tradeTable = {-1, -1, -1, -1, -1, -1}

				CustomGameEventManager:Send_ServerToPlayer(heroFrom:GetPlayerOwner(), "trade_begin", {playerFrom = heroFrom:GetPlayerOwnerID(), playerTo = heroTo:GetPlayerOwnerID()})
				CustomGameEventManager:Send_ServerToPlayer(heroTo:GetPlayerOwner(), "trade_begin", {playerFrom = heroTo:GetPlayerOwnerID(), playerTo = heroFrom:GetPlayerOwnerID()})
				heroFrom.trading = true
				heroTo.trading = true

				heroFrom.tradingWith = heroTo:GetEntityIndex()
				heroTo.tradingWith = heroFrom:GetEntityIndex()
				heroFrom.tradeLock = 0
				heroTo.tradeLock = 0

				heroFrom.tradeSendCount = heroFrom.tradeSendCount + 1

				CustomGameEventManager:Send_ServerToPlayer(heroFrom:GetPlayerOwner(), "close_blacksmith", {})
				CustomGameEventManager:Send_ServerToPlayer(heroTo:GetPlayerOwner(), "close_blacksmith", {})
				Statistics.dispatch("trade:start");
			else
				local timeUntilCanTrade = math.floor(tradeTime - (GameRules:GetGameTime() - heroFrom.lastTrade))
				Notifications:Top(heroFrom:GetPlayerOwnerID(), {text = "Can't trade for "..timeUntilCanTrade.."s", duration = 2, style = {color = "red"}, continue = true})
			end
		end
	else
		Notifications:Top(heroFrom:GetPlayerOwnerID(), {text = "Too Far Away", duration = 2, style = {color = "red"}, continue = true})
	end
end

function RPCItems:CancelTrade(msg)
	local heroFrom = EntIndexToHScript(msg.heroFrom)
	local heroTo = EntIndexToHScript(msg.heroTo)
	if heroTo.tradeFinalizing then
		return false
	end
	if heroFrom.tradeFinalizing then
		return false
	end
	heroTo.tradeFinalizing = true
	heroFrom.tradeFinalizing = true
	Timers:CreateTimer(1, function()
		heroTo.trading = false
		heroFrom.trading = false
		heroTo.tradeFinalizing = false
		heroFrom.tradeFinalizing = false
		for j = 1, #heroFrom.tradeTable, 1 do
			if heroFrom.tradeTable[j] >= 0 then
				local itemReturn = EntIndexToHScript(heroFrom.tradeTable[j])
				itemReturn.pickedUp = true
				RPCItems:GiveItemToHeroWithSlotCheck(heroFrom, itemReturn)
			end
		end
		for i = 1, #heroTo.tradeTable, 1 do
			if heroTo.tradeTable[i] >= 0 then
				local itemReturn = EntIndexToHScript(heroTo.tradeTable[i])
				itemReturn.pickedUp = true
				RPCItems:GiveItemToHeroWithSlotCheck(heroTo, itemReturn)
			end
		end
		heroFrom.tradeTable = {}
		heroTo.tradeTable = {}
		Statistics.dispatch("trade:finish");
	end)
	CustomGameEventManager:Send_ServerToPlayer(heroFrom:GetPlayerOwner(), "trade_final_close", {sentBy = msg.sentBy})
	CustomGameEventManager:Send_ServerToPlayer(heroTo:GetPlayerOwner(), "trade_final_close", {sentBy = msg.sentBy})
end

function RPCItems:CompleteTrade(heroFrom, heroTo)
	heroTo.tradeFinalizing = true
	heroFrom.tradeFinalizing = true
	Timers:CreateTimer(1, function()
		heroTo.trading = false
		heroFrom.trading = false
		heroTo.tradeFinalizing = false
		heroFrom.tradeFinalizing = false
		local dupeChecker = {}
		for j = 1, #heroFrom.tradeTable, 1 do
			if heroTo.tradeTable[j] >= 0 then
				local proceed = true
				for k = 1, #dupeChecker, 1 do
					if heroTo.tradeTable[j] == dupeChecker[k] then
						proceed = false
					end
				end
				if proceed then
					local itemReturn = EntIndexToHScript(heroTo.tradeTable[j])
					itemReturn.pickedUp = true
					RPCItems:GiveItemToHeroWithSlotCheck(heroFrom, itemReturn)
					table.insert(dupeChecker, heroTo.tradeTable[j])
				end
			end
		end
		for i = 1, #heroTo.tradeTable, 1 do
			if heroFrom.tradeTable[i] >= 0 then
				local proceed = true
				for k = 1, #dupeChecker, 1 do
					if heroFrom.tradeTable[i] == dupeChecker[k] then
						proceed = false
					end
				end
				if proceed then
					local itemReturn = EntIndexToHScript(heroFrom.tradeTable[i])
					itemReturn.pickedUp = true
					RPCItems:GiveItemToHeroWithSlotCheck(heroTo, itemReturn)
					table.insert(dupeChecker, heroFrom.tradeTable[i])
				end
			end
		end
		Statistics.dispatch("trade:finish");
	end)
	CustomGameEventManager:Send_ServerToPlayer(heroFrom:GetPlayerOwner(), "trade_final_close_accept", {})
	CustomGameEventManager:Send_ServerToPlayer(heroTo:GetPlayerOwner(), "trade_final_close_accept", {})
end

function RPCItems:ItemPlaceInTrade(msg)
	local droppingPlayerID = msg.playerID
	local itemIndex = msg.itemIndex
	local slot = msg.slot
	local item = EntIndexToHScript(itemIndex)
	local droppingHero = GameState:GetHeroByPlayerID(droppingPlayerID)
	local otherHero = EntIndexToHScript(droppingHero.tradingWith)
	for i = 1, 6, 1 do
		if droppingHero.tradeTable[i] == itemIndex then
			CustomGameEventManager:Send_ServerToPlayer(droppingHero:GetPlayerOwner(), "trade_item_dupe", {slot = slot})
			return false
		end
	end
	if Challenges:CheckIfHeroHasItemByItemIndex(droppingHero, itemIndex) then
		droppingHero.tradeTable[slot] = itemIndex
		if IsValidEntity(item:GetContainer()) then
			UTIL_Remove(item:GetContainer())
		end
		droppingHero:TakeItem(item)
		if IsValidEntity(item:GetContainer()) then
			UTIL_Remove(item:GetContainer())
		end

		CustomGameEventManager:Send_ServerToPlayer(droppingHero:GetPlayerOwner(), "trade_item_added", {itemsLeft = droppingHero.tradeTable, itemsRight = otherHero.tradeTable})
		CustomGameEventManager:Send_ServerToPlayer(otherHero:GetPlayerOwner(), "trade_item_added", {itemsRight = droppingHero.tradeTable, itemsLeft = otherHero.tradeTable})

		droppingHero.tradeLock = 0
		otherHero.tradeLock = 0
		CustomGameEventManager:Send_ServerToPlayer(droppingHero:GetPlayerOwner(), "trade_lock_updated", {leftLock = droppingHero.tradeLock, rightLock = otherHero.tradeLock})
		CustomGameEventManager:Send_ServerToPlayer(otherHero:GetPlayerOwner(), "trade_lock_updated", {leftLock = otherHero.tradeLock, rightLock = droppingHero.tradeLock})

		droppingHero:Stop()
	end

end

function RPCItems:ItemRemoveFromTrade(msg)
	local droppingPlayerID = msg.playerID
	local itemIndex = msg.itemIndex
	local slot = msg.slot
	local item = EntIndexToHScript(itemIndex)
	local droppingHero = GameState:GetHeroByPlayerID(droppingPlayerID)
	local otherHero = EntIndexToHScript(droppingHero.tradingWith)
	

	--print(msg.bReturnItem)
	--print("RETURN ITEM BOYS")
	--print(droppingHero.tradeTable[slot])
	if droppingHero.tradeTable[slot] == -1 then
	else
		droppingHero.tradeTable[slot] = -1
		if msg.bReturnItem == 1 then
			RPCItems:GiveItemToHeroWithSlotCheck(droppingHero, item)
		end

		CustomGameEventManager:Send_ServerToPlayer(droppingHero:GetPlayerOwner(), "trade_item_added", {itemsLeft = droppingHero.tradeTable, itemsRight = otherHero.tradeTable})
		CustomGameEventManager:Send_ServerToPlayer(otherHero:GetPlayerOwner(), "trade_item_added", {itemsRight = droppingHero.tradeTable, itemsLeft = otherHero.tradeTable})

		droppingHero.tradeLock = 0
		otherHero.tradeLock = 0
		CustomGameEventManager:Send_ServerToPlayer(droppingHero:GetPlayerOwner(), "trade_lock_updated", {leftLock = droppingHero.tradeLock, rightLock = otherHero.tradeLock})
		CustomGameEventManager:Send_ServerToPlayer(otherHero:GetPlayerOwner(), "trade_lock_updated", {leftLock = otherHero.tradeLock, rightLock = droppingHero.tradeLock})

	end
end

function RPCItems:UpdateLock(msg)
	local updatingPlayerID = msg.playerID
	local updatingHero = GameState:GetHeroByPlayerID(updatingPlayerID)
	local otherHero = EntIndexToHScript(updatingHero.tradingWith)

	local system = msg.system
	if updatingHero.tradeLock == 0 then
		updatingHero.tradeLock = 1
	else
		updatingHero.tradeLock = 0
	end
	CustomGameEventManager:Send_ServerToPlayer(updatingHero:GetPlayerOwner(), "trade_lock_updated", {leftLock = updatingHero.tradeLock, rightLock = otherHero.tradeLock})
	CustomGameEventManager:Send_ServerToPlayer(otherHero:GetPlayerOwner(), "trade_lock_updated", {leftLock = otherHero.tradeLock, rightLock = updatingHero.tradeLock})

	if ((updatingHero.tradeLock == 1) and (otherHero.tradeLock == 1)) then
		RPCItems:CompleteTrade(updatingHero, otherHero)
	end
end

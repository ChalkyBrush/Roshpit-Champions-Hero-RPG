local listeners = {}
local data = {}
local matchId = nil
local players = {};
local packetSize = 50000

local statsCollectUrl = 'https://roshpit.xyz/stats/collect/'
local statsGetUtl = 'https://roshpit.xyz/stats/getData/'


-- usual json:encode send data as array if it is possible
local function jsonEncode(data)
    local jsonString
    if type(data) == 'table' then
        jsonString = "{"
        for key, value in pairs(data) do
            local jsonValue = jsonEncode(value)
            jsonString = jsonString .. '"' .. key .. '":' .. jsonValue .. ','
        end
        if jsonString:len() > 1 then
            jsonString = jsonString:sub(0, jsonString:len() - 1)
        end
        jsonString = jsonString .. "}"
    else
        jsonString = '"' .. data .. '"'
    end
    return jsonString
end

local function getBaseGameData(eventInfo)
    local eventData = {}
    eventData['match_id'] = matchId
    eventData['map'] = Events.MapName
    eventData['game_duration'] = math.ceil(GameRules:GetGameTime())
    eventData['difficult'] = GameState:GetDifficultyFactor()
    eventData['event'] = eventInfo['event']
    return eventData
end

local function send(jsonStats, repeatCount)
    local request = CreateHTTPRequestScriptVM("POST", statsCollectUrl)
    request:SetHTTPRequestGetOrPostParameter("data", jsonStats)
    request:Send(function(result)
        if result.StatusCode ~= 200 then
            print("[STATS] Server connection failure, code", result.StatusCode)

            if repeatCount ~= nil and repeatCount > 0 then
                print("[STATS] Repeating in 3 seconds")
                Timers:CreateTimer(3, function() send(jsonStats, repeatCount - 1) end)
            end
        end
    end)
end

local function forceSend(eventInfo)
    local jsonData = JSON:encode(data)
    send(jsonData, 5)
    data = {}
end


local function collect(eventInfo)
    table.insert(data, eventInfo)
    local jsonData = jsonEncode(data)
    if (jsonData:len() < packetSize) then
        return
    end

    send(jsonData, 5)
    data = {}
end


local function dispatch(event, data)
    if listeners[event] == nil then
        return
    end
    if not data then
        data = {}
    end

    data['event'] = event
    print("event dispatched " .. event)

    for k, listener in pairs(listeners[event]) do
        local status, exception = pcall(function()
            listener(data)
        end)
        if not status then
            pcall(function()
                local eventData = getBaseGameData({event = "stats:exception:" .. event})
                eventData['exception'] = jsonEncode(exception)
                collect(eventData)
                forceSend(eventData)
            end)
        end
    end
end

local function subscribe(event, func)
    if not listeners[event] then
        listeners[event] = {}
    end
    table.insert(listeners[event], func)
end

local function getMatchId(eventInfo, repeatCount)
    if not repeatCount then
        repeatCount = 5
    end
    local request = CreateHTTPRequestScriptVM("GET", statsGetUtl)
    request:SetHTTPRequestGetOrPostParameter("type", "getInitialMatchId")
    request:Send(function(result)
        if result.StatusCode ~= 200 then
            print("[STATS] Get initial match id. Server connection failure, code", result.StatusCode)
            if repeatCount ~= nil and repeatCount > 0 then
                print("[STATS] Repeating in 3 seconds")
                Timers:CreateTimer(3, function() getMatchId(eventInfo, repeatCount - 1) end)
            end
        else
            matchId = result.Body
        end
    end)
end

local function getChangedItems(playerId, itemsType, currentItems)
    local data = {};
    if not players[playerId] then
        players[playerId] = {}
    end
    if not players[playerId][itemsType] then
        players[playerId][itemsType] = {}
    end

    for key, item in pairs(currentItems) do
        if not players[playerId][itemsType][key] then
            item['change_type'] = 'add'
            players[playerId][itemsType][key] = item
            table.insert(data, item)
        else
            local savedItem = players[playerId][itemsType][key]
            local isEqual = true
            for property, value in pairs(item) do
                if savedItem[property] ~= value then
                    isEqual = false
                    break
                end
            end
            if not isEqual then
                item['change_type'] = 'change'
                players[playerId][itemsType][key] = item
            end
        end
    end
    for key, item in pairs(players[playerId][itemsType]) do
        if not currentItems[key] then
            item['change_type'] = 'remove'
            players[playerId][itemsType][key] = nil
            table.insert(data, item)
        end
    end
    return data
end

local function getItemsByIndexes(itemsIndexes)
    local items = {}
    for key, itemIndexOnly in pairs(itemsIndexes) do
        local luaItem = EntIndexToHScript(itemIndexOnly.itemIndex)
        if luaItem and not luaItem.glyph and luaItem.property1 then
            local clearedItem = {
                itemName = luaItem.itemName,
                property1 = luaItem.property1,
                property1name = luaItem.property1name,
                property2 = luaItem.property2,
                property2name = luaItem.property2name,
                property3 = luaItem.property3,
                property3name = luaItem.property3name,
                property4 = luaItem.property4,
                property4name = luaItem.property4name,
                minLevel = luaItem.minLevel,
                slot = luaItem.slot,
                itemVariant = luaItem:GetAbilityName(),
                itemIndex = itemIndexOnly.itemIndex,
            }
            if items[itemIndexOnly.itemIndex] then
                items[tostring(itemIndexOnly.itemIndex) .. '_copy'] = clearedItem
            else
                items[itemIndexOnly.itemIndex] = clearedItem
            end
        end
    end
    return items
end

local function getCurrentStashItems(hero)
    if hero.stashTable then
        local items = {}
        for key, luaItem in pairs(hero.stashTable) do
            local itemIndex = luaItem:GetEntityIndex()

            local clearedItem = {
                itemName = luaItem.itemName,
                property1 = luaItem.property1,
                property1name = luaItem.property1name,
                property2 = luaItem.property2,
                property2name = luaItem.property2name,
                property3 = luaItem.property3,
                property3name = luaItem.property3name,
                property4 = luaItem.property4,
                property4name = luaItem.property4name,
                minLevel = luaItem.minLevel,
                slot = luaItem.slot,
                rarity = luaItem.rarity,
                itemVariant = luaItem:GetAbilityName(),
                itemIndex = itemIndex,
            }
            if items[itemIndex] then
                items[tostring(itemIndex) .. '_copy'] = clearedItem
            else
                items[itemIndex] = clearedItem
            end
        end
        return items
    else
        return {}
    end
end

local function getCurrentEquippedItems(hero)
    local gearTable = {}
    local playerId = hero:GetPlayerOwnerID()
    for gearSlot = 0, 5, 1 do
        local item = CustomNetTables:GetTableValue("equipment", tostring(playerId).."-"..tostring(gearSlot))
        gearTable[item['itemIndex']] =  item
    end
    return getItemsByIndexes(gearTable)
end

local function getCurrentBackpackItems(hero)
    local backpackItems = {}
    for i = 0, 8, 1 do
        local backpackItem = hero:GetItemInSlot(i)
        if backpackItem then
            local item = {}
            item.itemIndex = backpackItem:GetEntityIndex()
            table.insert(backpackItems , item)
        end
    end
    return getItemsByIndexes(backpackItems)
end

local function itemsOrHeroesChange(eventInfo)
    local eventData = getBaseGameData(eventInfo)

    eventData['heroes'] = {}

    for i = 1, #GameState.HeroPlayerTable, 1 do
        local dataTable = GameState.HeroPlayerTable[i]
        local heroId = dataTable[2]
        local hero = EntIndexToHScript(heroId)
        local heroInfo = {}
        heroInfo['changed_items'] = {}
        heroInfo['index'] = heroId
        heroInfo['id'] = hero.roshpitID
        heroInfo['steamId'] = PlayerResource:GetSteamAccountID(hero:GetPlayerOwnerID())

        local stashItems = getCurrentStashItems(hero)
        local stashItemsChanged = getChangedItems(heroId, 'stash_items', stashItems)
        heroInfo['changed_items']['stash_items'] = stashItemsChanged

        local backpackItems = getCurrentBackpackItems(hero)
        local backpackItemsChanged = getChangedItems(heroId, 'backpack_items', backpackItems)
        heroInfo['changed_items']['backpack_items'] = backpackItemsChanged

        local equippedItems = getCurrentEquippedItems(hero)
        local equippedItemsChanged = getChangedItems(heroId, 'equipped_items', equippedItems)
        heroInfo['changed_items']['equipped_items'] = equippedItemsChanged

        eventData['heroes'][heroId] = heroInfo
    end
    collect(eventData)
end

local function killBoss(eventInfo)
    local eventData = getBaseGameData(eventInfo)
    eventData['heroes'] = {}

    for i = 1, #GameState.HeroPlayerTable, 1 do
        local dataTable = GameState.HeroPlayerTable[i]
        local heroId = dataTable[2]
        local hero = EntIndexToHScript(heroId)
        local heroData = {}
        heroData['items'] = getCurrentEquippedItems(hero)
        heroData['steamId'] = PlayerResource:GetSteamAccountID(hero:GetPlayerOwnerID())
        heroData['saveSlot'] = hero.saveSlot
        heroData['index'] = heroId
        heroData['id'] = hero.roshpitID
        heroData['level'] = hero:GetLevel()
        heroData['name'] = hero:GetUnitName()
        heroData['enemies_killed'] = PlayerResource:GetKills(hero:GetPlayerOwnerID())
        eventData['heroes'][heroId] = heroData
    end
    collect(eventData)
end

local function mithrilChange(eventInfo)
    local eventData = getBaseGameData(eventInfo)
    eventData['count'] = CustomNetTables:GetTableValue("player_stats", tostring(eventInfo.playerID).."-mithril").mithril
    collect(eventData)
end

local function crystalsChange(eventInfo)
    local eventData = getBaseGameData(eventInfo)
    eventData['count'] = CustomNetTables:GetTableValue("player_stats", tostring(eventInfo.playerID).."-resources").arcane
    collect(eventData)
end

local function finishWave(eventInfo)
    local eventData = getBaseGameData(eventInfo)
    eventData['wave'] = eventInfo['wave']
    collect(eventData)
end

subscribe('sea_fortress:kill:sea_giant', killBoss)
subscribe('sea_fortress:kill:siltbreaker', killBoss)
subscribe('sea_fortress:kill:sea_oracle', killBoss)
subscribe('sea_fortress:kill:valdun', killBoss)

subscribe('redfall_ridge:kill:crimsyth_corruptor', killBoss)
subscribe('redfall_ridge:kill:tyrant_thadelus', killBoss)
subscribe('redfall_ridge:kill:lord_scarloth', killBoss)
subscribe('redfall_ridge:kill:world_tree', killBoss)

subscribe('tanari_jungle:kill:wind_goddess', killBoss)
subscribe('tanari_jungle:kill:king_kraethas', killBoss)
subscribe('tanari_jungle:kill:kolthun', killBoss)
subscribe('tanari_jungle:kill:ancient_god', killBoss)
subscribe('tanari_jungle:kill:wind_spirit', killBoss)
subscribe('tanari_jungle:kill:water_spirit', killBoss)
subscribe('tanari_jungle:kill:fire_spirit', killBoss)

subscribe('serengard:finish_wave', finishWave)

subscribe('arena:kill:black_mage', killBoss)
subscribe('arena:kill:giant_hunter', killBoss)
subscribe('arena:kill:pit_abomination', killBoss)
subscribe('arena:kill:pit_lord', killBoss)

subscribe('items:reroll', itemsOrHeroesChange)
subscribe('items:chisel', itemsOrHeroesChange)
subscribe('items:equip', itemsOrHeroesChange)
subscribe('items:backpack_change', itemsOrHeroesChange)
subscribe('items:oracle:get', itemsOrHeroesChange)
subscribe('items:oracle:push', itemsOrHeroesChange)

subscribe('trade:start', itemsOrHeroesChange)
subscribe('trade:finish', itemsOrHeroesChange)

subscribe('hero:oracle:save', itemsOrHeroesChange)
subscribe('hero:oracle:load', itemsOrHeroesChange)

subscribe('mithril:change', mithrilChange)

subscribe('crystals:change', crystalsChange)

subscribe('player:reconnect', itemsOrHeroesChange)
subscribe('player:disconnect', itemsOrHeroesChange)
subscribe('player:disconnect', forceSend)

subscribe('game:start', getMatchId)

local module = {}
module.dispatch = dispatch
module.subscribe = subscribe

return module
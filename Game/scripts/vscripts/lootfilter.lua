LootFilter = LootFilter or class({})

local lootFilters = {}


local compares = {
    [">"] = function(a,b)
        return a > b
    end,
    ["<"] = function(a,b)
        return a < b
    end,
    ["="] = function(a,b)
        return a == b
    end,
    ["@"] = function(a,b)
        for _,value in pairs(b) do
            if a == value then
                return true
            end
        end
        return false
    end
}

function LootFilter:Load()
    local steamIdsString = ''
    for i = 1, #MAIN_HERO_TABLE, 1 do
        steamIdsString = steamIdsString .. ',' .. PlayerResource:GetSteamAccountID(MAIN_HERO_TABLE[i]:GetPlayerID())
    end
    steamIdsString = steamIdsString:sub(2)

    local url = ROSHPIT_URL.."/champions/lootfilter/?steam_id=" .. steamIdsString

    lootFilters = { [1] = {} } -- remove at release
    --CreateHTTPRequestScriptVM("GET", url):Send(function(result) uncomment at release
    --    local resultTable = JSON:decode(result.Body)
    --    lootFilters = resultTable
    --end)

end

function LootFilter:CanSpawnItem(item)
    if item == nil or item.glyph ~= nil or item.property1name == nil then
        return true
    end
    for _,lootFilter in pairs(lootFilters) do
        if #lootFilter == 0 then
            return true
        end
    end
    for playerId,lootFilter in pairs(lootFilters) do -- if you need to remove filter of disconnected players somehow - welcome
        for _,rule in pairs(lootFilter) do
            if self:CheckRule(item, rule) then
                return true
            end
        end
    end
    return false
end

function LootFilter:CheckRule(item, rule)
    for property,value in pairs(rule) do
        local action = property:sub(-1)
        if type(value) == "table" then
            action = "@"
        elseif compares[action] and action ~= '@' then
            property = property:sub(1, -2)
        else
            action = '='
        end

        local compareValue = item[property]
        if not compares[action](compareValue, value) then
            return false
        end
    end
    return true
end
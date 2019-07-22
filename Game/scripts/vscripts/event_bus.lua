require('/global_constants')
-- Base group of events:
--  ability: something with check ability(elements, radius, etc)
--  creature: something with check for creature(takeDamage, etc)
-- Each levelt of priority have access to initValue and all values calculated by listeners on previous priorities
-- Event priority:
--  Less priority -> later execution, base priority in normal
--  Example: take damage:
--      high 4 priority: ability/item damage
--      high 3 priority: element damage
--      high 2 priority: premitigation taken damage increase
--      high priority: premitigation taken damage reduce(axe shield, cm shield, etc)
--      normal priority: premitigation taken damage increase
--      low  priority: steadfast, shields
--      low 2 priority: postmitigation
--      low 3 priority: i think nothing now
--      low 4 priority: new ability durable

if EventBus == nil then
    EventBus = class({})
end
EventBus.events = {}

local startFrom = EVENTBUS_PRIORITY_HIGH_5
local endOn = EVENTBUS_PRIORITY_LOW_5

-- Add new listener for event
-- @param event string event name
-- @param func function(@param data table, @param initData any)
-- @param priority integer{EVENTBUS_PRIORITY_VERY_LOW, EVENTBUS_PRIORITY_LOW,EVENTBUS_PRIORITY_NORMAL,EVENTBUS_PRIORITY_HIGH, EVENTBUS_PRIORITY_VERY_HIGH}
-- @return id of listener by priority
function EventBus:on(object, event, func, priority)
    if (priority == nil) then
        priority = EVENTBUS_PRIORITY_NORMAL
    end

    if (EventBus.events[event] == nil) then
        EventBus.events[event] = {}
        for priority = startFrom, endOn do
            EventBus.events[event][priority] = {}
        end
    end
    if (EventBus.events[event][priority][object] == nil) then
        EventBus.events[event][priority][object] = {}
    end

    table.insert(EventBus.events[event][priority][object], func)
    return table.maxn(EventBus.events[event][priority][object])
end
-- Trigger all listeners for event. If one of listeners return false prevent execution of next events
-- @param event string event name
-- @param data table data for event
-- @param initValue any value for calculate result
function EventBus:trigger(object, event, data, initValue, priorityMin, priorityMax)
    if (EventBus.events[event] == nil) then
        return initValue
    end

    data.initValueByPriority = {
        base = initValue
    }
    data.object = object

    if (priorityMax == nil) then
        if (priorityMin) then
            priorityMax = priorityMin
        end
        priorityMax = endOn
    end
    if (priorityMin == nil) then
        priorityMin = startFrom
    end

    for priority = priorityMin, priorityMax do
        if EventBus.events[event][priority][object] ~= nil then
            for eventId,listener in pairs(EventBus.events[event][priority][object]) do
                if type(listener) == 'function' then
                    data.eventId = eventId
                    initValue = listener(data, initValue)
                    if (initValue == false) then
                        return initValue
                    end
                end
            end
        end
        data.initValueByPriority[priority] = initValue
    end
    if object ~= 'all' then
        self:trigger('all', event, data, initValue, priorityMin, priorityMax)
    end

    return initValue
end

function EventBus:unsubscribe(object, event, priority, id)
    if (EventBus.events[event] == nil
        or EventBus.events[event][priority] == nil
        or EventBus.events[event][priority][object] == nil
        or EventBus.events[event][priority][object][id] == nil
    ) then
        print('Undefined unsubscribe')
        return false
    end
    EventBus.events[event][priority][object][id] = 1
    return true
end
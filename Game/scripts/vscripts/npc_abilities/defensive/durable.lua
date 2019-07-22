-- Name: durable
-- Description: Set maximum taken damage per second as percent of maximum hp. The limit can be summed up in a few seconds. Nothing can increase taken damage per second
-- Base Values:
--      maximum taken damage: 20/10/5% of maximum hp per second
--      sum up time: 2/4/8 seconds

LinkLuaModifier("modifier_durable", "npc_abilities/defensive/durable", LUA_MODIFIER_MOTION_NONE)

local eventId

require('/npc_abilities/base_ability')
require('/npc_abilities/base_modifier')

durable = setmetatable(class({}), npc_base_ability)
modifier_durable = setmetatable(class({}), npc_base_modifier)

local modifierClass = modifier_durable
local abilityClass = durable

function abilityClass:GetIntrinsicModifierName()
    return 'modifier_durable'
end

function modifierClass:OnCreated()
    local ability = self:GetAbility()
    local owner = self:GetCaster()
    eventId = EventBus:on('none', 'creature:takeDamage', function(data, takenDamage)
        if data.victim ~= owner then
            return takenDamage
        end

        if (ability.maxTakenDamagePerSecond == nil) then
            self:StartIntervalThink(1)

            ability.maxTakenDamagePerSecond = ability:GetSpecialValueFor('max_taken_damage_per_second')
            ability.sumUpTime = ability:GetSpecialValueFor('sum_up_time')
            ability.maxTakenDamage = ability.maxTakenDamagePerSecond
        end
        takenDamage = math.min(takenDamage, ability.maxTakenDamage * data.victim:GetMaxHealth()/100)
        ability.maxTakenDamage = ability.maxTakenDamage - takenDamage/data.victim:GetMaxHealth() * 100
        return takenDamage
    end, EVENTBUS_PRIORITY_LOW_5)

    EventBus:on(owner:GetEntityIndex(), 'creature:beforeDeath', function(data, takenDamage)
        EventBus:unsubscribe('none', 'creature:takeDamage', EVENTBUS_PRIORITY_LOW_5, eventId)
        EventBus:unsubscribe(owner:GetEntityIndex(), 'creature:beforeDeath', EVENTBUS_PRIORITY_LOW_5, data.eventId)
        return takenDamage

    end, EVENTBUS_PRIORITY_LOW_5)
end
function modifierClass:OnIntervalThink()
    local ability = self:GetAbility()
    ability.maxTakenDamage = math.min(ability.maxTakenDamage + ability.maxTakenDamagePerSecond, ability.maxTakenDamagePerSecond * ability.sumUpTime)
end
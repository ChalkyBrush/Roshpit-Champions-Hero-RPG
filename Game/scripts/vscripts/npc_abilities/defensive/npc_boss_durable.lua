-- Name: durable
-- Description: Set maximum taken damage per second as percent of maximum hp. The limit can be summed up in a few seconds. Nothing can increase taken damage per second
-- Base Values:
--      maximum taken damage: 20/10/5% of maximum hp per second
--      sum up time: 2/4/8 seconds

LinkLuaModifier("modifier_durable_passive", "npc_abilities/defensive/durable", LUA_MODIFIER_MOTION_NONE)

local eventId

require('/npc_abilities/base_ability')
require('/npc_abilities/base_modifier')

durable = class({})
--modifier_durable_passive = class(npc_base_modifier)

modifier_durable_passive = class(npc_base_modifier, nil, npc_base_modifier)

local passive = modifier_durable_passive
local abilityClass = durable

function abilityClass:GetIntrinsicModifierName()
    return 'modifier_durable_passive'
end
function passive:IsBuff()
    return true
end
function passive:OnCreated()
    self:SetSpecialTypes({ MODIFIER_SPECIAL_TYPE_EXTRA_POSTMITIGATION })
end
function passive:GetExtraPostmitigationReduce(data)
        local ability = self:GetAbility()
        if (ability.maxTakenDamagePerSecond == nil) then
            self:StartIntervalThink(1)
            ability.maxTakenDamagePerSecond = ability:GetSpecialValueFor('max_taken_damage_per_second')
            ability.sumUpTime = ability:GetSpecialValueFor('sum_up_time')
            ability.maxTakenDamage = ability.maxTakenDamagePerSecond
        end

        local newDamage = math.min(data.damage, ability.maxTakenDamage * data.victim:GetMaxHealth()/100)
        ability.maxTakenDamage = ability.maxTakenDamage - newDamage/data.victim:GetMaxHealth() * 100

        return 1 - newDamage/data.damage
end
function passive:OnIntervalThink()
    local ability = self:GetAbility()
    ability.maxTakenDamage = math.min(ability.maxTakenDamage + ability.maxTakenDamagePerSecond, ability.maxTakenDamagePerSecond * ability.sumUpTime)
end
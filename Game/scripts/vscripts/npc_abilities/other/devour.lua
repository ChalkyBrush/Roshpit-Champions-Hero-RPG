-- Name: devour
-- Description: Restore hp when any hero die from attack of the enemy
-- Base Values:
--      restore: 20/40/60% of maximum hp
--      cooldown: 40/24/8 seconds

LinkLuaModifier("modifier_devour", "npc_abilities/other/devour", LUA_MODIFIER_MOTION_NONE)

local eventId

require('/npc_abilities/base_ability')
require('/npc_abilities/base_modifier')

devour = setmetatable(class({}), npc_base_ability)
modifier_devour = setmetatable(class({}), npc_base_modifier)

local modifierClass = modifier_devour
local abilityClass = devour

function modifierClass:OnCreated()
    local ability = self:GetAbility()
    eventId = EventBus:on(ability:GetOwner():GetEntityIndex(), 'creature:beforeDeath', function(data, takenDamage)
        if not data.victim:IsHero() then
            return takenDamage
        end
        if ability:GetCooldownTimeRemaining() > 0 then
            return takenDamage
        end
        ability:StartCooldown()
        local owner = ability:GetOwner()
        local healAmountPercent = ability:GetSpecialValueFor('restore')
        Filters:ApplyHeal(owner, owner, owner:GetMaxHealth()/100 * healAmountPercent, true)
        return takenDamage
    end, EVENTBUS_PRIORITY_NORMAL)
end
function modifierClass:OnDestroy()
    EventBus:unsubscribe(self:GetAbility():GetOwner(), 'creature:beforeDeath', EVENTBUS_PRIORITY_NORMAL, eventId)
    eventId = nil
end
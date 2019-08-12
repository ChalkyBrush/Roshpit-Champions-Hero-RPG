require('/npc_units/base_unit')
require('/npc_abilities/base_modifier')
ImpMixin = class({}, nil, npc_base_unit)
modifier_imp_passive = class(npc_base_modifier)

local unitName = 'chaos_lords__imp'
local modifierName = 'modifier_' .. unitName
local class = ImpMixin
local modifierClass = modifier_imp_passive

function class:getInitData()
    return {
        armor = 500,
        effectiveHp = 6000,
        modifier = 'modifier_imp_passive',
        abilities = {
            durable = 1,
            fireball = 1,
        }
    }
end
function class:constructor()
    getbase(class).constructor(self)
    self:SetPhysicalArmorBaseValue(3000)
    self:SetEffectiveHp(5*10^12 * amplify)
    self:AddAbility('npc_durable'):SetLevel(1)
    self:AddAbility('fireball'):SetLevel(abilityLvl)
--    unit:AddAbility('explode'):SetLevel(abilityLvl)
--    unit:AddAbility('team_guard'):SetLevel(abilityLvl)
    return self
end
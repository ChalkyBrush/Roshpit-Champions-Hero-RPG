require('/npc_units/base_unit')
require('/npc_abilities/base_modifier')
require('/event_bus')
chaos_lords__imp = class({}, nil, npc_base_unit)
modifier_chaos_lords__imp = class(npc_base_modifier)

local unitName = 'chaos_lords__imp'
local modifierName = 'modifier_' .. unitName
local class = chaos_lords__imp
local modifierClass = modifier_chaos_lords__imp

LinkLuaModifier(modifierName, "npc_abilities/defensive/durable", LUA_MODIFIER_MOTION_NONE)

function class:Create(summoner, position, abilityLvl, amplify)
    local unit = self:_create({
        name =  unitName,
        position = position,
        team = summoner:GetTeamNumber(),
    })
    self:_init(unit)
    self = unit
    self:SetSummoner(summoner)

    self:SetPhysicalArmorBaseValue(3000)
    self:SetEffectiveHp(5*10^12 * amplify)
    self:AddAbility('npc_durable'):SetLevel(1)
    self:AddAbility('fireball'):SetLevel(abilityLvl)
--    unit:AddAbility('explode'):SetLevel(abilityLvl)
--    unit:AddAbility('team_guard'):SetLevel(abilityLvl)
    return self
end
require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')

modifier_chernobog_shadows_aura = class(npc_base_modifier, nil, npc_base_modifier)
local class = modifier_chernobog_shadows_aura

local modifiers = {
    enemyEffect = 'modifier_chernobog_shadows_enemy_effect',
}
function class:IsAura()
    return true
end
function class:IsHidden()
    return true
end
function class:GetModifierAura()
    return modifiers.enemyEffect
end
function class:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function class:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function class:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function class:GetAuraRadius()
    local ability = self:GetAbility()
    return self:GetRadius(ability.shadowsAuraRadius)
end
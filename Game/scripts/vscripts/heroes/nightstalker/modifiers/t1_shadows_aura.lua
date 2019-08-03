require('/npc_abilities/base_modifier')
require('heroes/nightstalker/chernobog_constants')
require('heroes/nightstalker/modifiers/shadows_aura')

local modifiers = {
    enemyEffect = 'modifier_chernobog_t1_shadows_enemy_effect',
}

modifier_chernobog_t1_shadows_aura = class(modifier_chernobog_shadows_aura, nil, modifier_chernobog_shadows_aura)

local class = modifier_chernobog_t1_shadows_aura

function class:GetModifierAura()
    return modifiers.enemyEffect
end
function class:GetAuraRadius()
    local ability = self:GetAbility()
    return self:GetRadius(ability.t1_shadowsAuraRadius)
end
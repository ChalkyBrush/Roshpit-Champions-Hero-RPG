require('/npc_abilities/base_modifier')
modifier_stargazers_sphere_circle_aura = class(npc_base_modifier, nil, npc_base_modifier)
local modifierClass = modifier_stargazers_sphere_circle_aura
local modifierCircleEffectName = 'modifier_stargazers_sphere_circle_effect'

function modifierClass:IsAura()
    return true
end
function modifierClass:GetModifierAura()
    return modifierCircleEffectName
end
function modifierClass:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifierClass:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function modifierClass:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifierClass:GetAuraRadius()
    return self:GetRadius(300)
end
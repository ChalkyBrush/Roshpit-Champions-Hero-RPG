require('heroes/vengeful_spirit/solonua_constants')
require('heroes/base_ability')
warp_flare_base = class(base_ability)

modifier_solunia_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_e_passive", "heroes/vengeful_spirit/ability_scripts/warp_flare_base.lua", LUA_MODIFIER_MOTION_NONE)

function warp_flare_base:GetManaCostBase(level)
    return 0
end

function warp_flare_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function warp_flare_base:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function warp_flare_base:GetAbilitySlot()
    return DOTA_E_SLOT
end

function warp_flare_base:GetCastPoint()
    return 0.26
end

-- function warp_flare_base:GetCastRange()
--     return self:GetSpecialValueFor("range")
-- end

function warp_flare_base:GetCooldownBase(level)
    return 13
end

function warp_flare_base:GetIntrinsicModifierName()
	return "modifier_solunia_e_passive"
end

function warp_flare_base:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCastPosition()
end

-- PASSIVE

function modifier_solunia_e_passive:IsHidden()
	return true
end
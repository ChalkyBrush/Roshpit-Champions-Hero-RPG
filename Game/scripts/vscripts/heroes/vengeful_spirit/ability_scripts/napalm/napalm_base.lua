require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
napalm_base = class(base_ability)

modifier_solunia_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_w_passive", "heroes/vengeful_spirit/ability_scripts/napalm/napalm_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_napalm_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_napalm_thinker", "heroes/vengeful_spirit/ability_scripts/napalm/napalm_base.lua", LUA_MODIFIER_MOTION_NONE)

function napalm_base:IsSoluniaState(state)
	if self:GetAbilityName() == "solonua_napalm_solar" and state == SOLUNIA_STATE_SOLAR then
		return true
	elseif self:GetAbilityName() == "solonua_napalm_lunar" and state == SOLUNIA_STATE_LUNAR then
		return true
	else
		return false
	end
end

function napalm_base:GetManaCostBase(level)
    return 0
end

function napalm_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function napalm_base:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function napalm_base:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function napalm_base:GetCastPoint()
    return 0.36
end

function napalm_base:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function napalm_base:GetCooldownBase(level)
    return 0
end

function napalm_base:GetIntrinsicModifierName()
	return "modifier_solunia_q_passive"
end

function napalm_base:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1, translate = "immortal"})
	EmitSoundOn("Selethas.Throw.VO", caster)

	return true
end

function napalm_base:NapalmStart()
end

-- PASSIVE
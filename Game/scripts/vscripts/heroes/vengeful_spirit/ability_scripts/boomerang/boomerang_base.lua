require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
boomerang_base = class(base_ability)

modifier_solunia_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_w_passive", "heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base.lua", LUA_MODIFIER_MOTION_NONE)


function boomerang_base:GetManaCostBase(level)
    return 0
end

function boomerang_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function boomerang_base:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function boomerang_base:GetAbilitySlot()
    return DOTA_E_SLOT
end

function boomerang_base:GetCastPoint()
    return 0.36
end

function boomerang_base:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function boomerang_base:GetCooldownBase(level)
    return 0
end

function boomerang_base:GetIntrinsicModifierName()
	return "modifier_solunia_w_passive"
end

function boomerang_base:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_ATTACK, rate = 1, translate = "loadout"})
	EmitSoundOn("Selethas.Throw.VO", caster)

	return true
end

function boomerang_base:BoomerangStart()
end
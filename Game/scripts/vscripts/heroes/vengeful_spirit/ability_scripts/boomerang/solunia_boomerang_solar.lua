require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base')
solunia_boomerang_solar = class(boomerang_base)

modifier_boomerang_counter_solar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_boomerang_counter_solar", "heroes/vengeful_spirit/ability_scripts/boomerang/solunia_boomerang_solar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_boomerang_solar:OnSpellStartBase()
    self:BoomerangStart()
end

function solunia_boomerang_solar:GetSwapAbilityName()
	return "solunia_boomerang_lunar"
end

function solunia_boomerang_solar:GetBoomerangRenderColor()
	return Vector(200, 200, 0)
end

function solunia_boomerang_solar:GetEffectParticleName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function solunia_boomerang_solar:GetCounterModifierName()
	return "modifier_boomerang_counter_solar"
end

function solunia_boomerang_solar:GetBoomerangModelName()
	return "models/selethas/solarang.vmdl"
end

function solunia_boomerang_solar:GetAbilityDamageType()
	return DAMAGE_TYPE_PHYSICAL
end

function solunia_boomerang_solar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_NORMAL
	end
end

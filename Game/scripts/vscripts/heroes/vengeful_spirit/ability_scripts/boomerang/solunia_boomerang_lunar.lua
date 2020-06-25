require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base')
solunia_boomerang_lunar = class(boomerang_base)

modifier_boomerang_counter_lunar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_boomerang_counter_lunar", "heroes/vengeful_spirit/ability_scripts/boomerang/solunia_boomerang_lunar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_boomerang_lunar:OnSpellStartBase()
    self:BoomerangStart()
end

function solunia_boomerang_lunar:GetSwapAbilityName()
	return "solunia_boomerang_solar"
end

function solunia_boomerang_lunar:GetBoomerangRenderColor()
	return Vector(0, 100, 255)
end

function solunia_boomerang_lunar:GetEffectParticleName()
	return "particles/roshpit/solunia/lunarang_ambient.vpcf"
end

function solunia_boomerang_lunar:GetCounterModifierName()
	return "modifier_boomerang_counter_lunar"
end

function solunia_boomerang_lunar:GetBoomerangModelName()
	return "models/selethas/solarang.vmdl"
end

function solunia_boomerang_lunar:GetAbilityDamageType()
	return DAMAGE_TYPE_MAGICAL
end

function solunia_boomerang_lunar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_NORMAL
	end
end

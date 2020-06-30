require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/arcana/vorpal_blades/vorpal_blades_base')
solunia_vorpal_blades_lunar = class(vorpal_blades_base)

modifier_vorpal_blades_counter_lunar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_vorpal_blades_counter_lunar", "heroes/vengeful_spirit/arcana/vorpal_blades/solunia_vorpal_blades_lunar.lua", LUA_MODIFIER_MOTION_NONE)

modifier_vorpal_blades_thinker_lunar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_vorpal_blades_thinker_lunar", "heroes/vengeful_spirit/arcana/vorpal_blades/solunia_vorpal_blades_lunar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_vorpal_blades_lunar:OnSpellStartBase()
    self:CastVorpalBlades(0)
end

function solunia_vorpal_blades_lunar:GetSwapAbilityName()
	return "solunia_vorpal_blades_solar"
end

function solunia_vorpal_blades_lunar:GetProjectileParticleName()
	return "particles/econ/items/luna/luna_ti9_weapon/luna_ti9_moon_glaive_bounce.vpcf"
end

function solunia_vorpal_blades_lunar:GetAbilityDamageType()
	return DAMAGE_TYPE_MAGICAL
end

function solunia_vorpal_blades_lunar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_ICE
	end
end

function solunia_vorpal_blades_lunar:GetNonArcana3AbilityName()
	return "solunia_boomerang_lunar"
end

function solunia_vorpal_blades_lunar:GetCounterModifierName()
	return "modifier_vorpal_blades_counter_lunar"
end

function solunia_vorpal_blades_lunar:GetThinkerModifierName()
	return "modifier_vorpal_blades_thinker_lunar"
end

-- THINKER MODIFIER

function modifier_vorpal_blades_thinker_lunar:IsHidden()
	return true
end

function modifier_vorpal_blades_thinker_lunar:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.2)
end

function modifier_vorpal_blades_thinker_lunar:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:GetAbility():VorpalThinker()
end
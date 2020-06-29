require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/arcana/vorpal_blades/vorpal_blades_base')
solunia_vorpal_blades_solar = class(vorpal_blades_base)

modifier_vorpal_blades_counter_solar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_vorpal_blades_counter_solar", "heroes/vengeful_spirit/arcana/vorpal_blades/solunia_vorpal_blades_solar.lua", LUA_MODIFIER_MOTION_NONE)

modifier_vorpal_blades_thinker_solar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_vorpal_blades_thinker_solar", "heroes/vengeful_spirit/arcana/vorpal_blades/solunia_vorpal_blades_solar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_vorpal_blades_solar:OnSpellStartBase()
    self:CastVorpalBlades(0)
end

function solunia_vorpal_blades_solar:GetSwapAbilityName()
	return "solunia_vorpal_blades_lunar"
end

function solunia_vorpal_blades_solar:GetProjectileParticleName()
	return "particles/econ/items/luna/luna_ti9_weapon_gold/luna_ti9_gold_moon_glaive_bounce.vpcf"
end

function solunia_vorpal_blades_solar:GetAbilityDamageType()
	return DAMAGE_TYPE_PHYSICAL
end

function solunia_vorpal_blades_solar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_FIRE
	end
end

function solunia_vorpal_blades_solar:GetNonArcana3AbilityName()
	return "solunia_boomerang_solar"
end

function solunia_vorpal_blades_solar:GetCounterModifierName()
	return "modifier_vorpal_blades_counter_solar"
end

function solunia_vorpal_blades_solar:GetThinkerModifierName()
	return "modifier_vorpal_blades_thinker_solar"
end

-- THINKER MODIFIER

function modifier_vorpal_blades_thinker_solar:IsHidden()
	return true
end

function modifier_vorpal_blades_thinker_solar:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.2)
end

function modifier_vorpal_blades_thinker_solar:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:GetAbility():VorpalThinker()
end
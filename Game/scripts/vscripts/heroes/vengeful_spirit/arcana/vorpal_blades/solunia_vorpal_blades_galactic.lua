require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/arcana/vorpal_blades/vorpal_blades_base')
solunia_vorpal_blades_galactic = class(vorpal_blades_base)

modifier_vorpal_blades_counter_galactic = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_vorpal_blades_counter_galactic", "heroes/vengeful_spirit/arcana/vorpal_blades/solunia_vorpal_blades_galactic.lua", LUA_MODIFIER_MOTION_NONE)

modifier_vorpal_blades_thinker_galactic = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_vorpal_blades_thinker_galactic", "heroes/vengeful_spirit/arcana/vorpal_blades/solunia_vorpal_blades_galactic.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_vorpal_blades_galactic:OnSpellStartBase()
    self:CastVorpalBlades(0)
end

function solunia_vorpal_blades_galactic:GetSwapAbilityName()
	return "solunia_vorpal_blades_solar"
end

function solunia_vorpal_blades_galactic:GetProjectileParticleName()
	return "particles/roshpit/solunia/galactic/galactic_vorpal_blades.vpcf"
end

function solunia_vorpal_blades_galactic:GetAbilityDamageType()
	local luck = RandomInt(1, 1000)
	if luck <= self:GetCaster():GetRuneValue("r", 2)*(SOLUNIA_ARCANA_R2_PURE_CHANCE)*10 then
		return DAMAGE_TYPE_PURE
	else 
		return DAMAGE_TYPE_PHYSICAL
	end
end

function solunia_vorpal_blades_galactic:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_FIRE
	end
end

function solunia_vorpal_blades_galactic:GetNonArcana3AbilityName()
	return "solunia_boomerang_galactic"
end

function solunia_vorpal_blades_galactic:GetCounterModifierName()
	return "modifier_vorpal_blades_counter_galactic"
end

function solunia_vorpal_blades_galactic:GetThinkerModifierName()
	return "modifier_vorpal_blades_thinker_galactic"
end

function solunia_vorpal_blades_galactic:GetSolarAbilityName()
	return "solunia_vorpal_blades_solar"
end

-- THINKER MODIFIER

function modifier_vorpal_blades_thinker_galactic:IsHidden()
	return true
end

function modifier_vorpal_blades_thinker_galactic:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.2)
end

function modifier_vorpal_blades_thinker_galactic:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:GetAbility():VorpalThinker()
end
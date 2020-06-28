require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base')
solunia_boomerang_galactic = class(boomerang_base)

modifier_boomerang_counter_galactic = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_boomerang_counter_galactic", "heroes/vengeful_spirit/ability_scripts/boomerang/solunia_boomerang_galactic.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_boomerang_galactic:OnSpellStartBase()
    self:BoomerangStart()
end

function solunia_boomerang_galactic:GetSwapAbilityName()
	return "solunia_boomerang_solar"
end

function solunia_boomerang_galactic:GetBoomerangRenderColor()
	return Vector(220, 0, 200)
end

function solunia_boomerang_galactic:GetEffectParticleName()
	return "particles/roshpit/solunia/galactic/galactic_boomerang_ambient.vpcf"
end

function solunia_boomerang_galactic:GetCounterModifierName()
	return "modifier_boomerang_counter_galactic"
end

function solunia_boomerang_galactic:GetBoomerangModelName()
	return "models/selethas/solarang.vmdl"
end

function solunia_boomerang_galactic:GetAbilityDamageType()
	local luck = RandomInt(1, 1000)
	if luck <= self:GetCaster():GetRuneValue("r", 2)*(SOLUNIA_ARCANA_R2_PURE_CHANCE)*10 then
		return DAMAGE_TYPE_PURE
	else 
		return DAMAGE_TYPE_PHYSICAL
	end
end

function solunia_boomerang_galactic:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_NORMAL
	end
end

function solunia_boomerang_galactic:GetW2ParticleName()
	return "particles/roshpit/solunia/galactic/flare_explosion_immortal1.vpcf"
end

function solunia_boomerang_galactic:GetArcana3AbilityName()
	return "solunia_vorpal_blades_galactic"
end

function solunia_boomerang_galactic:GetSolarAbilityName()
	return "solunia_boomerang_solar"
end

-- COUNTER

function modifier_boomerang_counter_galactic:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
    	MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS
    })	
end

function modifier_boomerang_counter_galactic:GetRoshpitSpellPierceBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("w", 4)*SOLUNIA_W4_PIERCE_PER_BOOMERANG*self:GetStackCount()
end

function modifier_boomerang_counter_galactic:GetRoshpitArmorPierceBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("w", 4)*SOLUNIA_W4_PIERCE_PER_BOOMERANG*self:GetStackCount()
end
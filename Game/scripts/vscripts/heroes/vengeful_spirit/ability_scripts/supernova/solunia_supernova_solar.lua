require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/supernova/supernova_base')
solunia_supernova_solar = class(supernova_base)

modifier_solunia_r2_dual_burn_solar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_r2_dual_burn_solar", "heroes/vengeful_spirit/ability_scripts/supernova/solunia_supernova_solar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_supernova_solar:OnSpellStartBase()
    self:SuperNovaChannelStart()
end

function solunia_supernova_solar:OnChannelFinish(interrupted)
    if IsServer() then
    	self:SuperNovaChannelFinish(interrupted)
    end
end

function solunia_supernova_solar:GetMainExplosionParticleName()
	return "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
end

function solunia_supernova_solar:GetAbilityDamageType()
	return DAMAGE_TYPE_PHYSICAL
end

function solunia_supernova_solar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_FIRE
	end
end

function solunia_supernova_solar:GetSwapAbilityName()
	return "solunia_supernova_lunar"
end

function solunia_supernova_solar:GetDualBurnModifierName()
	return "modifier_solunia_r2_dual_burn_solar"
end

function solunia_supernova_solar:GetAlternateDualBurnModifierName()
	return "modifier_solunia_r2_dual_burn_lunar"
end

function solunia_supernova_solar:GetWaveProjectileName()
	return "particles/roshpit/solunia/a_a_wave_solar.vpcf"
end

-- BURN MODIFIER

function modifier_solunia_r2_dual_burn_solar:IsHidden()
	return false
end

function modifier_solunia_r2_dual_burn_solar:IsDebuff()
	return true
end

function modifier_solunia_r2_dual_burn_solar:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.5)
end

function modifier_solunia_r2_dual_burn_solar:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local target = self:GetParent()
	local caster = self:GetCaster()
	local damage = ability:GetR2DualBurnDamage(target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, ability:GetAbilityDamageType(), BASE_ABILITY_R, ability:GetAbilityElement(1), ability:GetAbilityElement(2))
end

function modifier_solunia_r2_dual_burn_solar:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_solunia_r2_dual_burn_solar:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
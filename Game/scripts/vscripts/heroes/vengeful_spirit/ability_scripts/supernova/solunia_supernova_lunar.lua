require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/supernova/supernova_base')
solunia_supernova_lunar = class(supernova_base)

modifier_solunia_r2_dual_burn_lunar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_r2_dual_burn_lunar", "heroes/vengeful_spirit/ability_scripts/supernova/solunia_supernova_lunar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_supernova_lunar:OnSpellStartBase()
    self:SuperNovaChannelStart()
end

function solunia_supernova_lunar:OnChannelFinish(interrupted)
    if IsServer() then
    	self:SuperNovaChannelFinish(interrupted)
    end
end

function solunia_supernova_lunar:GetMainExplosionParticleName()
	return "particles/roshpit/solunia/eclipse.vpcf"
end

function solunia_supernova_lunar:GetAbilityDamageType()
	return DAMAGE_TYPE_MAGICAL
end

function solunia_supernova_lunar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_ICE
	end
end

function solunia_supernova_lunar:GetSwapAbilityName()
	return "solunia_supernova_solar"
end

function solunia_supernova_lunar:GetDualBurnModifierName()
	return "modifier_solunia_r2_dual_burn_lunar"
end

function solunia_supernova_lunar:GetAlternateDualBurnModifierName()
	return "modifier_solunia_r2_dual_burn_solar"
end

-- BURN MODIFIER

function modifier_solunia_r2_dual_burn_lunar:IsHidden()
	return false
end

function modifier_solunia_r2_dual_burn_lunar:IsDebuff()
	return true
end

function modifier_solunia_r2_dual_burn_lunar:OnCreated()
	self:StartIntervalThink(0.5)
end

function modifier_solunia_r2_dual_burn_lunar:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local target = self:GetParent()
	local caster = self:GetCaster()
	local damage = ability:GetR2DualBurnDamage(target)
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, ability:GetAbilityDamageType(), BASE_ABILITY_R, ability:GetAbilityElement(1), ability:GetAbilityElement(2))
end

function modifier_solunia_r2_dual_burn_lunar:GetEffectName()
	return "particles/roshpit/solunia/lunarang_ambient.vpcf"
end

function modifier_solunia_r2_dual_burn_lunar:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/supernova/supernova_base')
solunia_supernova_solar = class(supernova_base)

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
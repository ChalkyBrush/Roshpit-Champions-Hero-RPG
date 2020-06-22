require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/supernova/supernova_base')
solunia_supernova_lunar = class(supernova_base)

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
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
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
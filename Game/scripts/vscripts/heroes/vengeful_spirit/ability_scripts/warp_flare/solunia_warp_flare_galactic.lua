require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base')
solunia_warp_flare_galactic = class(warp_flare_base)

function solunia_warp_flare_galactic:OnSpellStartBase()
    self:WarpFlareStart()
end

function solunia_warp_flare_galactic:GetSwapAbilityName()
	return "solunia_warp_flare_solar"
end

function solunia_warp_flare_galactic:GetTravelBandPFXName()
	return "particles/roshpit/solunia/galactic/warp_beam.vpcf"
end

function solunia_warp_flare_galactic:GetTravelEndParticle()
	return "particles/roshpit/solunia/galactic/flare_explosion_immortal1.vpcf"
end

function solunia_warp_flare_galactic:GetE2ParticleName()
	return "particles/roshpit/solunia/galactic/galactic_warp_core.vpcf"
end

function solunia_warp_flare_galactic:GetSolarAbilityName()
	return "solunia_warp_flare_solar"
end
require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base')
solunia_warp_flare_lunar = class(warp_flare_base)

function solunia_warp_flare_lunar:OnSpellStartBase()
    self:WarpFlareStart()
end

function solunia_warp_flare_lunar:GetSwapAbilityName()
	return "solunia_warp_flare_solar"
end

function solunia_warp_flare_lunar:GetTravelBandPFXName()
	return "particles/roshpit/solunia/lunar_warp_beam_blade_golden.vpcf"
end

function solunia_warp_flare_lunar:GetTravelEndParticle()
	return "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
end

function solunia_warp_flare_lunar:GetE2ParticleName()
	return "particles/roshpit/solunia/warp_core_lunar.vpcf"
end
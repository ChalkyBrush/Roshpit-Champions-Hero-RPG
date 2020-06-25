require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/warp_flare/warp_flare_base')
solunia_warp_flare_solar = class(warp_flare_base)

function solunia_warp_flare_solar:OnSpellStartBase()
    self:WarpFlareStart()
end

function solunia_warp_flare_solar:GetSwapAbilityName()
	return "solunia_warp_flare_lunar"
end

function solunia_warp_flare_solar:GetTravelBandPFXName()
	return "particles/roshpit/solunia/warp_flare_beam_beam_blade_golden.vpcf"
end

function solunia_warp_flare_solar:GetTravelEndParticle()
	return "particles/roshpit/solunia/solar_flare_no_ground.vpcf"
end
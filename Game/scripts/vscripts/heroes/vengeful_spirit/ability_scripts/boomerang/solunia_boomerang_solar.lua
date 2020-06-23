require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base')
solunia_boomerang_solar = class(boomerang_base)

function solunia_boomerang_solar:OnSpellStartBase()
    self:BoomerangStart()
end

function solunia_boomerang_solar:GetSwapAbilityName()
	return "solunia_boomerang_lunar"
end
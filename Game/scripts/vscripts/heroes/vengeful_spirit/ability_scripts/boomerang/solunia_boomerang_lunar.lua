require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/boomerang/boomerang_base')
solunia_boomerang_lunar = class(boomerang_base)

function solunia_boomerang_lunar:OnSpellStartBase()
    self:BoomrangStart()
end

function solunia_boomerang_lunar:GetSwapAbilityName()
	return "solunia_boomerang_solar"
end
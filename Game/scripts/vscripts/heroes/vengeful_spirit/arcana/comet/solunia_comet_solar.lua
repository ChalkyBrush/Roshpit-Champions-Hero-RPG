require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/arcana/comet/comet_base')
solunia_comet_solar = class(comet_base)

function solunia_comet_solar:OnSpellStartBase()
    self:CometStart()
end

function solunia_comet_solar:GetSwapAbilityName()
	return "solunia_comet_lunar"
end

function solunia_comet_solar:GetCastParticleName()
	return "particles/roshpit/solunia/comet_cast_sun.vpcf"
end

function solunia_comet_solar:GetExplosionParticleName()
	return "particles/roshpit/solunia/solar_flare_no_ground.vpcf"
end

function solunia_comet_solar:GetCometParticleName()
	return "particles/roshpit/solunia/comet_sun_attack.vpcf"
end

function solunia_comet_solar:GetAbilityDamageType()
	return DAMAGE_TYPE_PHYSICAL
end

function solunia_comet_solar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_FIRE
	end
end

function solunia_comet_solar:GetFlatDamageBonusFromAttribute()
	return self:GetCaster():GetAgility()*self:GetSpecialValueFor("damage_add_agility")
end

function solunia_comet_solar:GetNonArcana1AbilityName()
	return "solunia_napalm_solar"
end

function solunia_comet_solar:GetWaveProjectileName()
	return "particles/roshpit/solunia/a_a_wave_solar.vpcf"
end
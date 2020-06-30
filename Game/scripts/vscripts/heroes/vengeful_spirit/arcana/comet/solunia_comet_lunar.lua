require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/arcana/comet/comet_base')
solunia_comet_lunar = class(comet_base)

function solunia_comet_lunar:OnSpellStartBase()
    self:CometStart()
end

function solunia_comet_lunar:GetSwapAbilityName()
	return "solunia_comet_solar"
end

function solunia_comet_lunar:GetCastParticleName()
	return "particles/roshpit/solunia/comet_cast_moon.vpcf"
end

function solunia_comet_lunar:GetExplosionParticleName()
	return "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
end

function solunia_comet_lunar:GetCometParticleName()
	return "particles/roshpit/solunia/comet_moon_attack_attack.vpcf"
end

function solunia_comet_lunar:GetAbilityDamageType()
	return DAMAGE_TYPE_MAGICAL
end

function solunia_comet_lunar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_ICE
	end
end

function solunia_comet_lunar:GetFlatDamageBonusFromAttribute()
	return self:GetCaster():GetIntellect()*self:GetSpecialValueFor("damage_add_intelligence")
end

function solunia_comet_lunar:GetNonArcana1AbilityName()
	return "solunia_napalm_lunar"
end

function solunia_comet_lunar:GetWaveProjectileName()
	return "particles/roshpit/solunia/a_a_wave_lunar.vpcf"
end
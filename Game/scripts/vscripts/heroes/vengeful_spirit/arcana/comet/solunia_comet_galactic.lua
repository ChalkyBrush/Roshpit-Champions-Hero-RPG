require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/arcana/comet/comet_base')
solunia_comet_galactic = class(comet_base)

function solunia_comet_galactic:OnSpellStartBase()
    self:CometStart()
end

function solunia_comet_galactic:GetSwapAbilityName()
	return "solunia_comet_solar"
end

function solunia_comet_galactic:GetCastParticleName()
	return "particles/roshpit/solunia/galactic/comet_cast_galactic.vpcf"
end

function solunia_comet_galactic:GetExplosionParticleName()
	return "particles/roshpit/solunia/galactic/flare_explosion_immortal1.vpcf"
end

function solunia_comet_galactic:GetCometParticleName()
	return "particles/roshpit/solunia/galactic/galactic_comet_attack.vpcf"	
end

function solunia_comet_galactic:GetAbilityDamageType()
	local luck = RandomInt(1, 1000)
	if luck <= self:GetCaster():GetRuneValue("r", 2)*(SOLUNIA_ARCANA_R2_PURE_CHANCE)*10 then
		return DAMAGE_TYPE_PURE
	else 
		return DAMAGE_TYPE_MAGICAL
	end
end

function solunia_comet_galactic:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_ICE
	end
end

function solunia_comet_galactic:GetFlatDamageBonusFromAttribute()
	return self:GetCaster():GetIntellect()*self:GetSpecialValueFor("damage_add_intelligence") + self:GetCaster():GetAgility()*self:GetSpecialValueFor("damage_add_agility")
end

function solunia_comet_galactic:GetNonArcana1AbilityName()
	return "solunia_napalm_galactic"
end

function solunia_comet_galactic:GetSolarAbilityName()
	return "solunia_comet_solar"
end

function solunia_comet_galactic:GetWaveProjectileName()
	return "particles/roshpit/solunia/galactic/a_a_wave_galactic_2.vpcf"
end
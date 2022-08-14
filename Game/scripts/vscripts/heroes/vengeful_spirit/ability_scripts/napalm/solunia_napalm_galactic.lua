require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/napalm/napalm_base')
solunia_napalm_galactic = class(napalm_base)

modifier_napalm_q_1_galactic = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_napalm_q_1_galactic", "heroes/vengeful_spirit/ability_scripts/napalm/solunia_napalm_galactic.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_napalm_galactic:OnSpellStartBase()
    self:NapalmStart()
end

function solunia_napalm_galactic:GetSwapAbilityName()
	return "solunia_napalm_solar"
end

function solunia_napalm_galactic:GetNapalmRenderColor()
	return Vector(255, 40, 255)
end

function solunia_napalm_galactic:GetCastParticleName()
	return "particles/roshpit/solunia/galactic/flare_explosion_immortal1.vpcf"
end

function solunia_napalm_galactic:GetNapalmForwardVelocity(target, startPosition)
	return (WallPhysics:GetDistance2d(target, startPosition) / 100 + 11)*(1 + (self:GetCaster():GetRuneValue("q", 3)*SOLUNIA_Q3_Q_SPEED_INCREASE_PCT/100))
end

function solunia_napalm_galactic:GetNapalmRandomOffsetFactor()
	return RandomInt(-90, 90)
end

function solunia_napalm_galactic:GetFlareAngle(baseFV, randomOffset)
	return WallPhysics:rotateVector(baseFV, math.pi * randomOffset / 180)
end

function solunia_napalm_galactic:GetNapalmStartingOffsetVector()
	return Vector(0,0,50)
end

function solunia_napalm_galactic:GetNapalmLiftSpeed(startPosition, target)
	return 40
end

function solunia_napalm_galactic:GetNapalmRandomSpeedAdjustment()
	return 0
end

function solunia_napalm_galactic:NapalmThinker(napalm)
	if napalm.disabled then
		return false
	end
	local newFV = WallPhysics:rotateVector(napalm:GetForwardVector(), math.pi / 30)
	if napalm.interval > 10 and napalm.interval <= 15 then
		if napalm.interval == 15 then
			napalm.fv = ((napalm.target_point - napalm:GetAbsOrigin())*Vector(1,1,0)):Normalized()
			napalm.forwardVelocity = napalm.forwardVelocity*4
			local divisor = WallPhysics:GetDistance2d(napalm.target_point, napalm:GetAbsOrigin())/napalm.forwardVelocity
			napalm.liftVelocity = ((napalm.target_point.z - napalm:GetAbsOrigin().z)/divisor)
		end
		napalm:SetAngles(napalm.interval * 4, WallPhysics:vectorToAngle(newFV), napalm.interval * 4)
		napalm.interval = napalm.interval + 1
	else
		napalm:SetAbsOrigin(napalm:GetAbsOrigin() + Vector(0, 0, napalm.liftVelocity) + napalm.fv * napalm.forwardVelocity)
		napalm:SetModelScale(math.min((0.5 + napalm.interval / 5), 3.0))
		
		napalm:SetForwardVector(newFV)
		napalm:SetAngles(napalm.interval * 4, WallPhysics:vectorToAngle(newFV), napalm.interval * 4)
		napalm.interval = napalm.interval + 1
		local groundHeight = GetGroundHeight(napalm:GetAbsOrigin(), napalm)
		if napalm:GetAbsOrigin().z - groundHeight < 10 or napalm.interval > 250 then
			napalm.disabled = true
			local explosionPosition = GetGroundPosition(napalm:GetAbsOrigin(), napalm)
			self:NapalmExplosion(explosionPosition)
			Timers:CreateTimer(0.06, function()
				UTIL_Remove(napalm)
			end)
		end
	end
end

function solunia_napalm_galactic:GetAbilityDamageType()
	local luck = RandomInt(1, 1000)
	if luck <= self:GetCaster():GetRuneValue("r", 2)*(SOLUNIA_ARCANA_R2_PURE_CHANCE)*10 then
		return DAMAGE_TYPE_PURE
	else 
		return DAMAGE_TYPE_MAGICAL
	end
end

function solunia_napalm_galactic:GetFlatDamageBonusFromAttribute()
	return self:GetCaster():GetIntellect()*self:GetSpecialValueFor("damage_add_intelligence") + self:GetCaster():GetAgility()*self:GetSpecialValueFor("damage_add_agility")
end

function solunia_napalm_galactic:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_ICE
	end
end

function solunia_napalm_galactic:GetNapalmExplosionParticleName()
	return "particles/roshpit/solunia/galactic/flare_explosion_immortal1.vpcf"
end

function solunia_napalm_galactic:GetQ1ModifierName()
	return "modifier_napalm_q_1_galactic"
end

function solunia_napalm_galactic:GetArcana1AbilityName()
	return "solunia_comet_galactic"
end

function solunia_napalm_galactic:GetSolarAbilityName()
	return "solunia_napalm_solar"
end

function solunia_napalm_galactic:GetWaveProjectileName()
	return "particles/roshpit/solunia/galactic/a_a_wave_galactic_2.vpcf"
end

-- Q1 MODIFIER

function modifier_napalm_q_1_galactic:IsBuff()
	return true
end

function modifier_napalm_q_1_galactic:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_MASTER_GREEN_DMG,
    	MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG 
    })
    self:StartIntervalThink(0.1)
end

function modifier_napalm_q_1_galactic:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetParent()
	local new_stacks = {}
	for i = 1, #ability.q_1_stacks, 1 do
		local time = ability.q_1_stacks[1]
		if (GameRules:GetGameTime() - time) < SOLUNIA_Q1_BUFF_DURATION then
			table.insert(new_stacks, time)
		end
	end
	ability.q_1_stacks = new_stacks
	if #new_stacks > 0 then
		self:SetStackCount(#ability.q_1_stacks)
	else
		caster:RemoveModifierByName(ability:GetQ1ModifierName())
	end
end

function modifier_napalm_q_1_galactic:GetRoshpitMasterGreenDMG()
	return self:GetStackCount() * SOLUNIA_Q1_DMG_PCT_PER_STACK_LUNAR * self:GetCaster():GetRuneValue("q", 1)
end

function modifier_napalm_q_1_galactic:GetRoshpitMasterBaseDMG()
	return self:GetStackCount() * SOLUNIA_Q1_BASE_DMG_PER_STACK_SOLAR * self:GetCaster():GetRuneValue("q", 1)
end

function modifier_napalm_q_1_galactic:OnRemoved()
	local ability = self:GetAbility()
	ability.q_1_stacks = {}
end

function modifier_napalm_q_1_galactic:GetTexture()
	return "solunia/solunia_rune_q_1"
end
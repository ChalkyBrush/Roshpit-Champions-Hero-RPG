require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/napalm/napalm_base')
solunia_napalm_lunar = class(napalm_base)

modifier_napalm_q_1_lunar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_napalm_q_1_lunar", "heroes/vengeful_spirit/ability_scripts/napalm/solunia_napalm_lunar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_napalm_lunar:OnSpellStartBase()
    self:NapalmStart()
end

function solunia_napalm_lunar:GetSwapAbilityName()
	return "solunia_napalm_solar"
end

function solunia_napalm_lunar:GetNapalmRenderColor()
	return Vector(0, 140, 255)
end

function solunia_napalm_lunar:GetCastParticleName()
	return "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
end

function solunia_napalm_lunar:GetNapalmForwardVelocity(target, startPosition)
	return (WallPhysics:GetDistance2d(target, startPosition) / 100 + 11)*(1 + (self:GetCaster():GetRuneValue("q", 3)*SOLUNIA_Q3_Q_SPEED_INCREASE_PCT/100))
end

function solunia_napalm_lunar:GetNapalmRandomOffsetFactor()
	return RandomInt(-10, 10)
end

function solunia_napalm_lunar:GetFlareAngle(baseFV, randomOffset)
	return WallPhysics:rotateVector(baseFV, math.pi * randomOffset / 180)
end

function solunia_napalm_lunar:GetNapalmStartingOffsetVector()
	return Vector(0,0,50)
end

function solunia_napalm_lunar:GetNapalmLiftSpeed(startPosition, target)
	return 40
end

function solunia_napalm_lunar:GetNapalmRandomSpeedAdjustment()
	return 0
end

function solunia_napalm_lunar:NapalmThinker(napalm)
	if napalm.disabled then
		return false
	end
	napalm:SetAbsOrigin(napalm:GetAbsOrigin() + napalm.fv * napalm.forwardVelocity + napalm.perpFV * 8 * math.cos(napalm.interval * math.pi / 10))
	napalm.liftVelocity = napalm.liftVelocity - 3
	napalm:SetModelScale(math.min((0.5 + napalm.interval / 5), 3.0))
	local newFV = WallPhysics:rotateVector(napalm:GetForwardVector(), math.pi / 30)
	napalm:SetForwardVector(newFV)
	napalm:SetAngles(napalm.interval * 3, WallPhysics:vectorToAngle(newFV), napalm.interval * 3)
	napalm.interval = napalm.interval + 1
	local groundHeight = GetGroundHeight(napalm:GetAbsOrigin(), napalm)
	local distance = WallPhysics:GetDistance2d(napalm.start_point, napalm.target_point)
	if napalm.interval > (distance / (napalm.forwardVelocity)) then
		local explosionPosition = GetGroundPosition(napalm:GetAbsOrigin(), napalm)
		self:NapalmExplosion(explosionPosition)
		napalm.disabled = true
		Timers:CreateTimer(0.06, function()
			UTIL_Remove(napalm)
		end)
	end
end

function solunia_napalm_lunar:GetAbilityDamageType()
	return DAMAGE_TYPE_MAGICAL
end

function solunia_napalm_lunar:GetFlatDamageBonusFromAttribute()
	return self:GetCaster():GetIntellect()*self:GetSpecialValueFor("damage_add_intelligence")
end

function solunia_napalm_lunar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_ICE
	end
end

function solunia_napalm_lunar:GetNapalmExplosionParticleName()
	return "particles/roshpit/solunia/lunar_flare_explosion_immortal1.vpcf"
end

function solunia_napalm_lunar:GetQ1ModifierName()
	return "modifier_napalm_q_1_lunar"
end

function solunia_napalm_lunar:GetArcana1AbilityName()
	return "solunia_comet_lunar"
end

function solunia_napalm_lunar:GetWaveProjectileName()
	return "particles/roshpit/solunia/a_a_wave_lunar.vpcf"
end

-- Q1 MODIFIER

function modifier_napalm_q_1_lunar:IsBuff()
	return true
end

function modifier_napalm_q_1_lunar:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
    self:StartIntervalThink(0.1)
end

function modifier_napalm_q_1_lunar:OnIntervalThink()
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

function modifier_napalm_q_1_lunar:GetRoshpitMasterGreenDMG()
	return self:GetStackCount() * SOLUNIA_Q1_DMG_PCT_PER_STACK_LUNAR * self:GetCaster():GetRuneValue("q", 1)
end

function modifier_napalm_q_1_lunar:OnRemoved()
	local ability = self:GetAbility()
	ability.q_1_stacks = {}
end
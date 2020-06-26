require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/napalm/napalm_base')
solunia_napalm_solar = class(napalm_base)

modifier_napalm_q_1_solar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_napalm_q_1_solar", "heroes/vengeful_spirit/ability_scripts/napalm/solunia_napalm_solar.lua", LUA_MODIFIER_MOTION_NONE)

function solunia_napalm_solar:OnSpellStartBase()
    self:NapalmStart()
end

function solunia_napalm_solar:GetSwapAbilityName()
	return "solunia_napalm_lunar"
end

function solunia_napalm_solar:GetNapalmRenderColor()
	return Vector(255, 140, 0)
end

function solunia_napalm_solar:GetCastParticleName()
	return "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
end

function solunia_napalm_solar:GetNapalmForwardVelocity(target, startPosition)
	return WallPhysics:GetDistance2d(target, startPosition) / 35 + 6
end

function solunia_napalm_solar:GetNapalmRandomOffsetFactor()
	return RandomInt(-20, 20)
end

function solunia_napalm_solar:GetFlareAngle(baseFV, randomOffset)
	return WallPhysics:rotateVector(baseFV, math.pi * randomOffset / 240)
end

function solunia_napalm_solar:GetNapalmStartingOffsetVector()
	return Vector(0,0,0)
end

function solunia_napalm_solar:GetNapalmLiftSpeed(startPosition, target)
	return 40
end

function solunia_napalm_solar:GetNapalmRandomSpeedAdjustment()
	return RandomInt(-3, 3)
end

function solunia_napalm_solar:NapalmThinker(napalm)
	if napalm.disabled then
		return false
	end
	napalm:SetAbsOrigin(napalm:GetAbsOrigin() + Vector(0, 0, napalm.liftVelocity) + napalm.fv * napalm.forwardVelocity)
	napalm.liftVelocity = napalm.liftVelocity - 3
	napalm:SetModelScale(math.min((0.5 + napalm.interval / 5), 3.0))
	local newFV = WallPhysics:rotateVector(napalm:GetForwardVector(), math.pi / 30)
	napalm:SetForwardVector(newFV)
	napalm:SetAngles(napalm.interval * 4, vectorToAngle(newFV), napalm.interval * 4)
	napalm.interval = napalm.interval + 1
	local groundHeight = GetGroundHeight(napalm:GetAbsOrigin(), napalm)
	if napalm:GetAbsOrigin().z - groundHeight < 10 then
		napalm.disabled = true
		local explosionPosition = GetGroundPosition(napalm:GetAbsOrigin(), napalm)
		self:NapalmExplosion(explosionPosition)
		Timers:CreateTimer(0.06, function()
			UTIL_Remove(napalm)
		end)
	end
end

function solunia_napalm_solar:GetAbilityDamageType()
	return DAMAGE_TYPE_PHYSICAL
end

function solunia_napalm_solar:GetFlatDamageBonusFromAttribute()
	return self:GetCaster():GetAgility()*self:GetSpecialValueFor("damage_add_agility")
end

function solunia_napalm_solar:GetAbilityElement(index)
	if index == 1 then
		return RPC_ELEMENT_COSMOS
	elseif index == 2 then
		return RPC_ELEMENT_FIRE
	end
end

function solunia_napalm_solar:GetNapalmExplosionParticleName()
	return "particles/roshpit/solunia/solar_flare_no_ground.vpcf"
end

function solunia_napalm_solar:GetQ1ModifierName()
	return "modifier_napalm_q_1_solar"
end

-- Q1 MODIFIER

function modifier_napalm_q_1_solar:IsBuff()
	return true
end

function modifier_napalm_q_1_solar:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG 
    })
    self:StartIntervalThink(0.1)
end

function modifier_napalm_q_1_solar:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetParent()
	local new_stacks = {}
	for i = 1, #ability.q_1_stacks, 1 do
		local time = ability.q_1_stacks[i]
		if (GameRules:GetGameTime() - time) < SOLUNIA_Q1_BUFF_DURATION then
			table.insert(new_stacks, time)
		end
	end
	ability.q_1_stacks = new_stacks
	if #ability.q_1_stacks > 0 then
		self:SetStackCount(#ability.q_1_stacks)
	else
		caster:RemoveModifierByName(ability:GetQ1ModifierName())
	end
end

function modifier_napalm_q_1_solar:GetRoshpitMasterBaseDMG()
	return self:GetStackCount() * SOLUNIA_Q1_BASE_DMG_PER_STACK_SOLAR * self:GetCaster():GetRuneValue("q", 1)
end

function modifier_napalm_q_1_solar:OnRemoved()
	local ability = self:GetAbility()
	ability.q_1_stacks = {}
end
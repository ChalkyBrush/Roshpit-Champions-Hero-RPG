require('heroes/vengeful_spirit/solunia_constants')
require('heroes/vengeful_spirit/ability_scripts/napalm/napalm_base')
solunia_napalm_lunar = class(napalm_base)

modifier_napalm_counter_lunar = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_napalm_counter_lunar", "heroes/vengeful_spirit/ability_scripts/napalm/solunia_napalm_lunar.lua", LUA_MODIFIER_MOTION_NONE)

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
	return WallPhysics:GetDistance2d(target, startPosition) / 100 + 11
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
	napalm:SetAngles(napalm.interval * 3, vectorToAngle(newFV), napalm.interval * 3)
	napalm.interval = napalm.interval + 1
	local groundHeight = GetGroundHeight(napalm:GetAbsOrigin(), napalm)
	if napalm.interval > napalm.forwardVelocity * 2 then
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
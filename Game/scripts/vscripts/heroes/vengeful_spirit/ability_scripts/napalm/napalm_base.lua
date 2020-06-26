require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
napalm_base = class(base_ability)

modifier_solunia_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_q_passive", "heroes/vengeful_spirit/ability_scripts/napalm/napalm_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_napalm_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_napalm_thinker", "heroes/vengeful_spirit/ability_scripts/napalm/napalm_base.lua", LUA_MODIFIER_MOTION_NONE)

function napalm_base:IsSoluniaState(state)
	if self:GetAbilityName() == "solunia_napalm_solar" and state == SOLUNIA_STATE_SOLAR then
		return true
	elseif self:GetAbilityName() == "solunia_napalm_lunar" and state == SOLUNIA_STATE_LUNAR then
		return true
	else
		return false
	end
end

function napalm_base:GetManaCostBase(level)
	local caster = self:GetCaster()
    return caster:GetModifierStackCount("modifier_solunia_q_passive", caster)*SOLUNIA_Q2_MANA_COST
end

function napalm_base:GetAOERadius()
	return 260
end

function napalm_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AOE
end

function napalm_base:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function napalm_base:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function napalm_base:GetCastPoint()
    return 0.36
end

function napalm_base:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function napalm_base:GetCooldownBase(level)
    return 9
end

function napalm_base:GetIntrinsicModifierName()
	return "modifier_solunia_q_passive"
end

function napalm_base:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1, translate = "immortal"})
	EmitSoundOn("Selethas.Throw.VO", caster)

	return true
end

function napalm_base:NapalmStart()
	local caster = self:GetCaster()
	local ability = self

	local target = self:GetCastPosition()
	ability.targetPoint = target



	local projectiles = self:GetSpecialValueFor("projectiles")

	for i = 0, projectiles - 1, 1 do
		Timers:CreateTimer(i * 0.2, function()
			self:ThrowNapalm(caster:GetAbsOrigin(), target)
		end)
	end
	local pfx = ParticleManager:CreateParticle(self:GetCastParticleName(), PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)
	EmitSoundOn("Solunia.NitroInitialCast", caster)
	Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function napalm_base:ThrowNapalm(startPosition, target)
	local caster = self:GetCaster()
	local ability = self
	local baseFV = (target * Vector(1, 1, 0) - startPosition * Vector(1, 1, 0)):Normalized()
	ability.baseFV = baseFV
	local forwardVelocity = self:GetNapalmForwardVelocity(target, startPosition)

	local randomOffset = self:GetNapalmRandomOffsetFactor()
	local flareAngle = self:GetFlareAngle(baseFV, randomOffset)
	local flare = CreateUnitByName("selethas_boomerang", startPosition + Vector(0, 0, 100), false, caster, nil, caster:GetTeamNumber())
	flare:SetAbsOrigin(startPosition + self:GetNapalmStartingOffsetVector())
	flare:SetOriginalModel("models/items/crystal_maiden/ward_staff/ward_staff_crystal.vmdl")
	flare:SetModel("models/items/crystal_maiden/ward_staff/ward_staff_crystal.vmdl")
	local render_color = self:GetNapalmRenderColor()
	flare:SetRenderColor(render_color.x, render_color.y, render_color.z)
	flare:SetModelScale(0.1)
	flare.fv = flareAngle
	flare.perpFV = WallPhysics:rotateVector(flareAngle, math.pi / 2)
	flare.liftVelocity = self:GetNapalmLiftSpeed(startPosition, target)
	flare.target_point = target
	flare.start_point = flare:GetAbsOrigin()
	flare.forwardVelocity = forwardVelocity + self:GetNapalmRandomSpeedAdjustment()
	flare.interval = 0
	EmitSoundOn("Solunia.SolarGlowThrow", flare)
	flare:AddNewModifier(caster, ability, "modifier_napalm_thinker", {})
end

function napalm_base:GetNapalmDamage()
	return self:GetSpecialValueFor("damage") + self:GetFlatDamageBonusFromAttribute() + self:GetManaCostBase()*SOLUNIA_Q2_BASE_DMG_INCREASE_PER_MANA
end

function napalm_base:NapalmExplosion(position)
	local caster = self:GetCaster()
	local ability = self
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local damage = self:GetNapalmDamage()
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, self:GetAbilityDamageType(), BASE_ABILITY_Q, self:GetAbilityElement(1), self:GetAbilityElement(2))
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
		self:NapalmQ1Increment()
	end
	CustomAbilities:QuickParticleAtPoint(self:GetNapalmExplosionParticleName(), position, 3)
	EmitSoundOnLocationWithCaster(position, "Solunia.SolarGlow.Impact", caster)
end

function napalm_base:NapalmQ1Increment()
	local caster = self:GetCaster()
	local ability = self
	if caster:GetRuneValue("q", 1) > 0 then
		caster:AddNewModifier(caster, self, self:GetQ1ModifierName(), {duration = SOLUNIA_Q1_BUFF_DURATION})
		if not ability.q_1_stacks then
			ability.q_1_stacks = {}
		end
		if #ability.q_1_stacks < SOLUNIA_Q1_MAX_STACKS then
			table.insert(ability.q_1_stacks, GameRules:GetGameTime())
			local modifier = caster:FindModifierByName(self:GetQ1ModifierName())
			modifier:OnIntervalThink()
		else
			table.sort(ability.q_1_stacks)
			ability.q_1_stacks[1] = GameRules:GetGameTime()
			local modifier = caster:FindModifierByName(self:GetQ1ModifierName())
			modifier:OnIntervalThink()
		end
	end
end

-- PASSIVE

function modifier_solunia_q_passive:IsHidden()
	return true
end

function modifier_solunia_q_passive:OnCreated()
	if not IsServer() then
		return false
	end
	if self:GetAbility():IsSoluniaState(SOLUNIA_STATE_SOLAR) then
	    self:SetSpecialTypes({ 
	    	MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
	    	RPC_ELEMENT_FIRE
	    })
	elseif self:GetAbility():IsSoluniaState(SOLUNIA_STATE_LUNAR) then
	    self:SetSpecialTypes({ 
	    	MODIFIER_ROSHPIT_Q_BASE_ABILITY_DMG_BONUS,
	    	RPC_ELEMENT_ICE
	    })
	end
	self:StartIntervalThink(0.1)
end

function modifier_solunia_q_passive:OnIntervalThink()
	self:SetStackCount(self:GetCaster():GetRuneValue("q", 2))
end

function modifier_solunia_q_passive:GetRoshpitQBaseAbilityDmgBonus()
	return self:GetCaster():GetRuneValue("q", 3)*SOLUNIA_Q3_Q_BAD/100
end

function modifier_solunia_q_passive:GetRoshpitElementalDmgBonus()
	return self:GetCaster():GetRuneValue("q", 4)*(SOLUNIA_Q4_ELEMENTAL_AMP/100)
end

-- NAPALM THINKER

function modifier_napalm_thinker:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(0.03)
end

function modifier_napalm_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state	
end

function modifier_napalm_thinker:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	ability:NapalmThinker(self:GetParent())
end
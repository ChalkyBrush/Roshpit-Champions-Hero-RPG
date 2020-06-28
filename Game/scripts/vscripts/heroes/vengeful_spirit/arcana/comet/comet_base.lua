require('heroes/vengeful_spirit/solunia_constants')
require('heroes/base_ability')
comet_base = class(base_ability)

modifier_solunia_arcana_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_arcana_q_passive", "heroes/vengeful_spirit/arcana/comet/comet_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_ultraviolet = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_ultraviolet", "heroes/vengeful_spirit/arcana/comet/comet_base.lua", LUA_MODIFIER_MOTION_NONE)

modifier_solunia_arcana_q_charges = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_solunia_arcana_q_charges", "heroes/vengeful_spirit/arcana/comet/comet_base.lua", LUA_MODIFIER_MOTION_NONE)

function comet_base:IsSoluniaState(state)
	if self:GetAbilityName() == "solunia_comet_solar" and state == SOLUNIA_STATE_SOLAR then
		return true
	elseif self:GetAbilityName() == "solunia_comet_lunar" and state == SOLUNIA_STATE_LUNAR then
		return true
	elseif self:GetAbilityName() == "solunia_comet_galactic" and state == SOLUNIA_STATE_GALACTIC then
		return true
	else
		return false
	end
end

function comet_base:GetManaCostBase(level)
	local caster = self:GetCaster()
    return caster:GetModifierStackCount("modifier_solunia_arcana_q_passive", caster)*SOLUNIA_ARCANA_Q2_MANA_COST
end

function comet_base:GetAOERadius()
	return 240
end

function comet_base:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT
end

function comet_base:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function comet_base:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function comet_base:GetCastPoint()
    return 0
end

function comet_base:GetCastRange()
    return 1400
end

function comet_base:GetCooldownBase(level)
    return 0
end

function comet_base:GetIntrinsicModifierName()
	return "modifier_solunia_arcana_q_passive"
end

function comet_base:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()

	return true
end

function comet_base:CometStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCastPosition()

	StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.8})

	local cast_direction = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	CustomAbilities:QuickParticleAtPoint(self:GetCastParticleName(), caster:GetAbsOrigin(), 3)
	local pfx = ParticleManager:CreateParticle(castParticle, PATTACH_CUSTOMORIGIN, caster)

	EmitSoundOn("Solunia.Arcana1.Cast", caster)
	EmitSoundOnLocationWithCaster(target, "Solunia.Arcana1.Comet", caster)
	CustomAbilities:QuickParticleAtPoint(self:GetCometParticleName(), target, 4)
	Timers:CreateTimer(0.45, function()
		self:CometImpact(target)
	end)
	local new_stacks = caster:GetModifierStackCount("modifier_solunia_arcana_q_charges", caster) - 1
	if new_stacks > 0 then
		caster:SetModifierStackCount("modifier_solunia_arcana_q_charges", caster, new_stacks)
	else
		caster:RemoveModifierByName("modifier_solunia_arcana_q_charges")
	end
	Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function comet_base:CometImpact(position)
	local caster = self:GetCaster()
	local ability = self
	EmitSoundOnLocationWithCaster(position, "Solunia.SolarGlow.Impact", caster)
	CustomAbilities:QuickParticleAtPoint(self:GetExplosionParticleName(), position, 3)
	local damage = self:GetCometDamage()
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, self:GetAbilityDamageType(), BASE_ABILITY_Q, self:GetAbilityElement(1), self:GetAbilityElement(2))
			Filters:ApplyStun(caster, stun_duration, enemy)
		end
		self:RuneQ1()
	end
end

function comet_base:GetCometDamage()
	return self:GetSpecialValueFor("damage") + self:GetFlatDamageBonusFromAttribute() + self:GetManaCostBase()*SOLUNIA_ARCANA_Q2_BASE_DMG_INCREASE_PER_MANA
end

function comet_base:RuneQ1()
	local caster = self:GetCaster()
	local ability = self
	local duration = Filters:GetAdjustedBuffDuration(caster, SOLUNIA_ARCANA1_Q1_DURATION, false)
	caster:AddNewModifier(caster, ability, "modifier_solunia_ultraviolet", {duration = duration})
	
end

function comet_base:GetGalacticName()
	return "solunia_comet_galactic"
end

-- Q ARCANA1 PASSIVE

function modifier_solunia_arcana_q_passive:IsHidden()
	return true
end

function modifier_solunia_arcana_q_passive:OnCreated()
	if not IsServer() then
		return false
	end

    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_STRENGTH_PCT_BONUS,
    	MODIFIER_ROSHPIT_SPIRIT_PCT_BONUS,
    	MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
    })

	self:StartIntervalThink(0.2)
	self:GetAbility():SetActivated(true)
	self:SetupCharges()
end

function modifier_solunia_arcana_q_passive:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:SetStackCount(self:GetCaster():GetRuneValue("q", 2))
	self:GetParent():SetStatsForLevel()
	local caster = self:GetCaster()
	if not caster:HasModifier("modifier_solunia_arcana_q_charges") then
		self:GetAbility():SetActivated(false)
	end
end

function modifier_solunia_arcana_q_passive:GetRoshpitStrengthPctBonus()
	return self:GetCaster():GetRuneValue("q", 3)*SOLUNIA_ARCANA_Q3_STR_AND_SPR_PCT
end

function modifier_solunia_arcana_q_passive:GetRoshpitSpiritPctBonus()
	return self:GetCaster():GetRuneValue("q", 3)*SOLUNIA_ARCANA_Q3_STR_AND_SPR_PCT
end

function modifier_solunia_arcana_q_passive:GetRoshpitMasterBaseDMG()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if ability:IsSoluniaState(SOLUNIA_STATE_SOLAR) then
		return self:GetCaster():GetRuneValue("q", 4)*SOLUNIA_ARCANA_Q4_ATTACK_DMG_PER_ATTR*caster:GetAgility()
	elseif ability:IsSoluniaState(SOLUNIA_STATE_LUNAR) then
		return self:GetCaster():GetRuneValue("q", 4)*SOLUNIA_ARCANA_Q4_ATTACK_DMG_PER_ATTR*caster:GetIntellect()
	elseif ability:IsSoluniaState(SOLUNIA_STATE_GALACTIC) then
		return self:GetCaster():GetRuneValue("q", 4)*SOLUNIA_ARCANA_Q4_ATTACK_DMG_PER_ATTR*(caster:GetIntellect() + caster:GetAgility())
	end
end

function modifier_solunia_arcana_q_passive:OnRemoved()
	if not IsServer() then
		return false
	end
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_solunia_arcana_q_charges")
	self:GetParent():SetStatsForLevel()
end

function modifier_solunia_arcana_q_passive:SetupCharges()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	caster:AddNewModifier(caster, ability, "modifier_solunia_arcana_q_charges", {})
	local level = ability:GetLevel()
	if level < 1 then
		level = 1
	end
	caster:SetModifierStackCount("modifier_solunia_arcana_q_charges", caster, SOLUNIA_ARCANA1_RELOAD_CHARGES[level])
end

-- Q1 Ultraviolet Modifier

function modifier_solunia_ultraviolet:IsHidden()
	return false
end

function modifier_solunia_ultraviolet:IsBuff()
	return true
end

function modifier_solunia_ultraviolet:GetEffectName()
	return "particles/roshpit/solunia/ultraviolet.vpcf"
end

function modifier_solunia_ultraviolet:GetEffectAttachType()
	return "attach_hitloc"
end

function modifier_solunia_ultraviolet:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_MASTER_MANA_REGEN,
    	MODIFIER_ROSHPIT_MASTER_GREEN_DMG
    })
end

function modifier_solunia_ultraviolet:GetRoshpitMasterManaRegen()
	local caster = self:GetCaster()
	return SOLUNIA_ARCANA_Q1_MANA_REGEN*caster:GetRuneValue("q", 1)
end

function modifier_solunia_ultraviolet:GetRoshpitMasterGreenDMG()
	local caster = self:GetCaster()
	return SOLUNIA_ARCANA_Q1_BONUS_ATTACK_PCT*caster:GetRuneValue("q", 1)
end

-- CHARGES MODIFIER

function modifier_solunia_arcana_q_charges:IsHidden()
	return false
end

function modifier_solunia_arcana_q_charges:IsBuff()
	return true
end
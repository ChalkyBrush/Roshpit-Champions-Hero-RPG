require('heroes/dragon_knight/flamewaker_constants')
require('heroes/base_ability')
flamewaker_dragon_fire = class(base_ability)

modifier_flamewaker_arcana_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_arcana_q_passive", "heroes/dragon_knight/arcana/arcana1_dragon_fire.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_arcana_q_freecast = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_arcana_q_freecast", "heroes/dragon_knight/arcana/arcana1_dragon_fire.lua", LUA_MODIFIER_MOTION_NONE)

modifier_flamewaker_arcana_q2_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_flamewaker_arcana_q2_buff", "heroes/dragon_knight/arcana/arcana1_dragon_fire.lua", LUA_MODIFIER_MOTION_NONE)

function flamewaker_dragon_fire:GetManaCostBase(level)
    return 0
end

function flamewaker_dragon_fire:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function flamewaker_dragon_fire:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end

function flamewaker_dragon_fire:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function flamewaker_dragon_fire:GetCastPoint()
    return 0.1
end

function flamewaker_dragon_fire:GetCastRange()
    return 1000
end

function flamewaker_dragon_fire:GetCooldownBase(level)
    return 3.5
end

function flamewaker_dragon_fire:GetIntrinsicModifierName()
	return "modifier_flamewaker_arcana_q_passive"
end

function flamewaker_dragon_fire:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()

	return true
end

function flamewaker_dragon_fire:OnAbilityPhaseInterrupted()

end

function flamewaker_dragon_fire:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function flamewaker_dragon_fire:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCursorPosition()
    self:flame_burst(target_position)

	if not caster:HasModifier("modifier_flamewaker_arcana_q_freecast") then
		local duration = Filters:GetAdjustedBuffDuration(caster, FLAMEWAKER_ARCANA_Q_FREE_CAST_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_flamewaker_arcana_q_freecast", {duration = duration})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_q_freecast", caster, FLAMEWAKER_ARCANA_Q_FREE_CAST_COUNT)
		self:EndCooldown()
		self.original_cast_time = GameRules:GetGameTime()
	else
		new_stacks = caster:GetModifierStackCount("modifier_flamewaker_arcana_q_freecast", caster) - 1
		if new_stacks == 0 then
			caster:RemoveModifierByName("modifier_flamewaker_arcana_q_freecast")
		else
			caster:SetModifierStackCount("modifier_flamewaker_arcana_q_freecast", caster, new_stacks)
			self:EndCooldown()
		end
	end
	if caster:GetRuneValue("q", 2) > 0 then
		local duration = Filters:GetAdjustedBuffDuration(caster, FLAMEWAKER_ARCANA_Q2_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_flamewaker_arcana_q2_buff", {duration = duration})
	end
	if caster:GetRuneValue("q", 3) > 0 then
		self:RuneQ3(target_position)
	end
    Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function flamewaker_dragon_fire:RuneQ3(original_cast_position)
    local ability = self
	local caster = self:GetCaster()	
	local totalChance = caster:GetRuneValue("q", 3) * FLAMEWAKER_ARCANA_Q3_PROC_CHANCE
	local procs = Runes:ProcsByTotalChance(totalChance)
	if procs > 0 then
		for i = 1, procs, 1 do
			Timers:CreateTimer(FLAMEWAKER_ARCANA_Q3_DELAY*i, function()
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), original_cast_position, nil, FLAMEWAKER_ARCANA_Q3_RANGE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				if #enemies > 0 then
					local slight_random_position = enemies[RandomInt(1, #enemies)]:GetAbsOrigin() + RandomVector(RandomInt(0, 60))
					self:flame_burst(slight_random_position)
				else
					local slight_random_position = original_cast_position + RandomVector(RandomInt(0, 90))
					self:flame_burst(slight_random_position)
				end				
			end)
		end
	end
end

function flamewaker_dragon_fire:flame_burst(target_point)
	local caster = self:GetCaster()
	local ability = self
	local radius = self:GetSpecialValueFor("aoe_radius")
	local pfx = ParticleManager:CreateParticle("particles/roshpit/flamewaker/flamewaker_q_arcana1.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target_point + Vector(0, 0, 120))
	Timers:CreateTimer(6, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local damage = self:GetSpecialValueFor("damage") + caster:GetStrength()*self:GetSpecialValueFor("strength_mult")
	local stunDuration = self:GetSpecialValueFor("stun_duration")
	EmitSoundOnLocationWithCaster(target_point, "Flamewaker.ArcanaAbility", caster)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_DRAGON)
			Filters:ApplyStun(caster, stunDuration, enemy)
		end
	end
	GridNav:DestroyTreesAroundPoint(target_point, radius - 20, false)
end

-- PASSIVE MODIFIER

function modifier_flamewaker_arcana_q_passive:IsHidden()
	return true
end

function modifier_flamewaker_arcana_q_passive:RemoveOnDeath()
	return false
end

function modifier_flamewaker_arcana_q_passive:IsPassive()
	return true
end

function modifier_flamewaker_arcana_q_passive:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_CONDITIONAL_DMG_REDUCTION
    })
    self:StartIntervalThink(FLAMEWAKER_ARCANA_Q4_THINK_INTERVAL)
end

function modifier_flamewaker_arcana_q_passive:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	ability.q_4_level = caster:GetRuneValue("q", 4)
	if caster:GetRuneValue("q", 4) > 0 then
		if not ability.pfx then
			local pfx = ParticleManager:CreateParticle("particles/roshpit/flamewaker/flamewaker_arcana_d_arope_arcana.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ability.pfx = pfx	
		end
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability.q_4_level * (FLAMEWAKER_ARCANA_Q4_DMG_PER_ATT/100)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Flamewaker.ArcanaDAStun", enemy)
				CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_flame.vpcf", enemy, 3)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			end
		end		
	end
end

function modifier_flamewaker_arcana_q_passive:GetConditionalDamageReduction(event)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if ability.q_4_level and ability.q_4_level > 0 then
		local attacker = event.attacker
		local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), event.attacker:GetAbsOrigin())
		if distance <= 280 then
			local reduction = math.min(FLAMEWAKER_ARCANA_Q4_DAMAGE_REDUCE_BASE + FLAMEWAKER_ARCANA_Q4_DAMAGE_REDUCE*ability.q_4_level, FLAMEWAKER_ARCANA_Q4_DAMAGE_REDUCE_MAX)
			return reduction/100
		end
	else
		return 0
	end
end

function modifier_flamewaker_arcana_q_passive:GetRoshpitArmorBonus()
	local caster = self:GetCaster()
	local missing_health_pct = math.floor((1 - caster:GetHealth()/caster:GetMaxHealth())*100)
	return missing_health_pct * caster:GetRuneValue("q", 1) * FLAMEWAKER_ARCANA_Q1_ARMOR_MISSING_HP_PCT
end

function modifier_flamewaker_arcana_q_passive:GetRoshpitArmorPierceBonus()
	local caster = self:GetCaster()
	local missing_health_pct = math.floor((1 - caster:GetHealth()/caster:GetMaxHealth())*100)
	return missing_health_pct * caster:GetRuneValue("q", 1) * FLAMEWAKER_ARCANA_Q1_ARMOR_PIERCE_MISSING_HP_PCT
end

function modifier_flamewaker_arcana_q_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_flamewaker_arcana_q_passive:OnDeath()
	local ability = self:GetAbility()
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, false)
		ability.pfx = nil
	end
end
-- FREECAST

function modifier_flamewaker_arcana_q_freecast:IsHidden()
	return false
end

function modifier_flamewaker_arcana_q_freecast:OnDestroy()
	if not IsServer() then
		return false
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local ability_level = ability:GetLevel()
	local cd = ability:GetCooldownBase(ability_level) - (GameRules:GetGameTime() - ability.original_cast_time)
	ability:StartCooldown(cd)
end

-- Q2 BUFF

function modifier_flamewaker_arcana_q2_buff:OnCreated()
	if not IsServer() then
		return false
	end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_MASTER_MS,
        RPC_ELEMENT_FIRE
    })
end

function modifier_flamewaker_arcana_q2_buff:IsHidden()
	return false
end

function modifier_flamewaker_arcana_q2_buff:GetTexture()
	return "flamewaker/flamewaker_q_2_arcana1"
end

function modifier_flamewaker_arcana_q2_buff:GetRoshpitMasterMS()
	local caster = self:GetCaster()
	return caster:GetRuneValue("q", 2)*FLAMEWAKER_ARCANA_Q2_MS 
end

function modifier_flamewaker_arcana_q2_buff:GetRoshpitElementalDmgBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("q", 2)*(FLAMEWAKER_ARCANA_Q2_FIRE_DAMAGE/100)
end

function modifier_flamewaker_arcana_q2_buff:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_e.vpcf"
end

function modifier_flamewaker_arcana_q2_buff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
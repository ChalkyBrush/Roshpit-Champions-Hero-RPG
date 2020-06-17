require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_temporal_grip = class(base_ability)

modifier_epoch_arcana_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_arcana_q_passive", "heroes/obsidian_destroyer/arcana/arcana1_temporal_grip.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_arcana_q_root = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_arcana_q_root", "heroes/obsidian_destroyer/arcana/arcana1_temporal_grip.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_arcana_q4 = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_arcana_q4", "heroes/obsidian_destroyer/arcana/arcana1_temporal_grip.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_temporal_grip:GetManaCostBase(level)
    return 0
end

function epoch_temporal_grip:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function epoch_temporal_grip:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function epoch_temporal_grip:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function epoch_temporal_grip:GetCastPoint()
    return 0.3
end

function epoch_temporal_grip:GetCastRange()
   return 1500 + (self:GetCaster():GetModifierStackCount("modifier_epoch_arcana_q4", caster)*EPOCH_ARCANA_Q4_CAST_RANGE)
end

function epoch_temporal_grip:GetCooldownBase(level)
    return 5
end

function epoch_temporal_grip:GetIntrinsicModifierName()
	return "modifier_epoch_arcana_q_passive"
end

function epoch_temporal_grip:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	local target_position = self:GetCastPosition()

	return true
end

function epoch_temporal_grip:OnAbilityPhaseInterrupted()
	local ability = self

end

function epoch_temporal_grip:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius") + (self:GetCaster():GetModifierStackCount("modifier_epoch_arcana_q4", caster)*EPOCH_ARCANA_Q4_AOE)
end

function epoch_temporal_grip:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target = self:GetCastPosition()
    if not ability.bind_table then
    	ability.bind_table = {}
    end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/epoch/arcana_ability_area.vpcf", PATTACH_CUSTOMORIGIN, caster)
	EmitSoundOnLocationWithCaster(target, "Epoch.ArcanaAbility.Cast", caster)
	local radius = self:GetAOERadius()
	ParticleManager:SetParticleControl(pfx, 0, target + Vector(0, 0, 120))
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 100, radius))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (self:GetSpecialValueFor('dmg_atk_power')/100)
	local rootDuration = self:GetSpecialValueFor("root_duration")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
			if not enemy:HasModifier("modifier_epoch_arcana_q_root") then
				if enemy:IsAlive() then
					enemy:AddNewModifier(caster, ability, "modifier_epoch_arcana_q_root", {duration = rootDuration})
				end
			end
		end
	end


    Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

-- ROOT MODIFIER

function modifier_epoch_arcana_q_root:IsHidden()
	return false
end

function modifier_epoch_arcana_q_root:IsDebuff()
	return true
end

function modifier_epoch_arcana_q_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}
	return state
end

function modifier_epoch_arcana_q_root:GetEffectName()
	return "particles/roshpit/epoch/arcana_root.vpcf"
end

function modifier_epoch_arcana_q_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_epoch_arcana_q_root:OnCreated()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	ability.bind_table[parent:GetEntityIndex()] = true
end

function modifier_epoch_arcana_q_root:OnRemoved()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	ability.bind_table[parent:GetEntityIndex()] = nil
end

-- BOUNCES FOR W

function epoch_temporal_grip:FindNextTargetForW(target, extraData)
	local ability = self
	local next_target = nil

	for source, bool in pairs(ability.bind_table) do
		if extraData[source] then
		else
			next_target = EntIndexToHScript(source)
			break
		end
	end
	return next_target
end

-- PASSIVE

function modifier_epoch_arcana_q_passive:IsHidden()
    return true
end

function modifier_epoch_arcana_q_passive:RemoveOnDeath()
    return false
end

function modifier_epoch_arcana_q_passive:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_OVERRIDE_ATTACK_EVENT,
    	MODIFIER_ROSHPIT_STRENGTH_PCT_BONUS,
    	MODIFIER_ROSHPIT_AGILITY_PCT_BONUS,
    	MODIFIER_ROSHPIT_INTELLIGENCE_PCT_BONUS,
    	MODIFIER_ROSHPIT_SPIRIT_PCT_BONUS,
    	MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
    	MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG

    })
    self:StartIntervalThink(1.0)
end


function modifier_epoch_arcana_q_passive:GetRoshpitMasterBaseDMG()
	local caster = self:GetCaster()
	return caster:GetRuneValue("q", 3)*EPOCH_ARCANA_Q3_BASE_ATTACK_DAMAGE
end

function modifier_epoch_arcana_q_passive:GetRoshpitSpellPierceBonus()
	local caster = self:GetCaster()
	return caster:GetRuneValue("q", 3)*EPOCH_ARCANA_Q3_SPELL_PIERCE
end

function modifier_epoch_arcana_q_passive:BasicAttackOverride(event)
	local target = event.target
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local override = false
    if ability.q_1_attacks then
    	if ability.q_1_attacks[target:GetEntityIndex()] and #ability.q_1_attacks[target:GetEntityIndex()] > 0 then
			local attack_data = ability.q_1_attacks[target:GetEntityIndex()][1]
			local damage = attack_data.mana_drain*EPOCH_ARCANA_Q1_DMG_PER_MANA_DRAIN*caster:GetRuneValue("q", 1) + OverflowProtectedGetAverageTrueAttackDamage(caster)
			attack_data.hit = true
			override = 1
			Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
    	end
    	local new_attack_data_table = {}
    	if ability.q_1_attacks[target:GetEntityIndex()] then
			for i = 1, #ability.q_1_attacks[target:GetEntityIndex()], 1 do
				local attack_data = ability.q_1_attacks[target:GetEntityIndex()][i]
				if not attack_data.hit then
					table.insert(new_attack_data_table, attack_data)
				end
			end
		end
		ability.q_1_attacks[target:GetEntityIndex()] = new_attack_data_table
    end
    return override
end

function epoch_temporal_grip:clean_up_q_1_attacks_table()
	local ability = self
	if ability.q_1_attacks then
		for target, attack_targets in pairs(ability.q_1_attacks) do
			local valid_attacks = {}
			for i = 1, #ability.q_1_attacks[target], 1 do
				if ability.q_1_attacks[target][i].hit or GameRules:GetGameTime() > ability.q_1_attacks[target][i].expiryTime then
				else
					table.insert(valid_attacks, ability.q_1_attacks[target][i])
				end
			end
			ability.q_1_attacks[target] = valid_attacks
			if #ability.q_1_attacks[target] < 1 then
				ability.q_1_attacks[target] = nil
			end
		end
	end
end

function modifier_epoch_arcana_q_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}

	return funcs
end

function modifier_epoch_arcana_q_passive:OnAttackStart(event)
    if not IsServer() then
        return false
    end
    if not self:ParentIsAttacker(event) then
    	return false
    end
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local target = event.target
    local q_1_level = caster:GetRuneValue("q", 1)
    if q_1_level > 0 then
    	local mana_pct = (caster:GetMana() / caster:GetMaxMana())*100
    	if mana_pct >= EPOCH_Q1_MANA_DRAIN_PCT then
    		caster:SetModifierStackCount("modifier_epoch_arcana_q_passive", caster, 1)
    		local mana_drain = caster:GetMaxMana()*(EPOCH_Q1_MANA_DRAIN_PCT/100)
    		caster:ReduceMana(mana_drain)
    		if not ability.q_1_attacks then
    			ability.q_1_attacks = {}
    		end
    		if not ability.q_1_attacks[target:GetEntityIndex()] then
    			ability.q_1_attacks[target:GetEntityIndex()] = {}
    		end
    		local attack_data = {}
    		attack_data.expiryTime = GameRules:GetGameTime() + 5
    		attack_data.mana_drain = mana_drain
    		attack_data.hit = false
    		table.insert(ability.q_1_attacks[target:GetEntityIndex()], attack_data)
    	else
    		caster:SetModifierStackCount("modifier_epoch_arcana_q_passive", caster, 0)
    	end
    end
    ability:clean_up_q_1_attacks_table()
end

function modifier_epoch_arcana_q_passive:GetModifierProjectileName()
	if self:GetStackCount() > 0 then
		return "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
	else
		return false
	end
end

function modifier_epoch_arcana_q_passive:GetRoshpitStrengthPctBonus()
	return self:GetCaster():GetRuneValue("q", 2)*EPOCH_ARCANA_Q2_STAT_PCT
end

function modifier_epoch_arcana_q_passive:GetRoshpitAgilityPctBonus()
	return self:GetCaster():GetRuneValue("q", 2)*EPOCH_ARCANA_Q2_STAT_PCT
end

function modifier_epoch_arcana_q_passive:GetRoshpitIntelligencePctBonus()
	return self:GetCaster():GetRuneValue("q", 2)*EPOCH_ARCANA_Q2_STAT_PCT
end

function modifier_epoch_arcana_q_passive:GetRoshpitSpiritPctBonus()
	return self:GetCaster():GetRuneValue("q", 2)*EPOCH_ARCANA_Q2_STAT_PCT
end

function modifier_epoch_arcana_q_passive:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local caster = self:GetParent()
	caster:SetStatsForLevel()
	if not caster:HasModifier("modifier_epoch_arcana_q4") then
		caster:AddNewModifier(caster, ability, "modifier_epoch_arcana_q4", {})
		caster:SetModifierStackCount("modifier_epoch_arcana_q4", caster, caster:GetRuneValue("q", 4))
	end
end

function modifier_epoch_arcana_q_passive:OnRemoved()
	if not IsServer() then
		return false
	end
	self:GetParent():RemoveModifierByName("modifier_epoch_arcana_q4")
	self:GetParent():SetStatsForLevel()
end

-- Q4_MODIFIER

function modifier_epoch_arcana_q4:IsHidden()
	return true
end

function modifier_epoch_arcana_q4:RoshpitDispellable()
	return 0
end
require('heroes/obsidian_destroyer/epoch_constants')
require('heroes/base_ability')
epoch_time_binder = class(base_ability)

modifier_epoch_q_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_q_passive", "heroes/obsidian_destroyer/ability_scripts/epoch_time_binder.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_time_bind = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_time_bind", "heroes/obsidian_destroyer/ability_scripts/epoch_time_binder.lua", LUA_MODIFIER_MOTION_NONE)

modifier_epoch_eon_phantom = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_epoch_eon_phantom", "heroes/obsidian_destroyer/ability_scripts/epoch_time_binder.lua", LUA_MODIFIER_MOTION_NONE)

function epoch_time_binder:GetManaCostBase(level)
    return 0
end

function epoch_time_binder:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function epoch_time_binder:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function epoch_time_binder:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function epoch_time_binder:GetCastPoint()
    return 0.3
end

function epoch_time_binder:GetCastRange()
    return 2000
end

function epoch_time_binder:GetCooldownBase(level)
    return EPOCH_Q_COOLDOWN
end

function epoch_time_binder:GetIntrinsicModifierName()
	return "modifier_epoch_q_passive"
end

function epoch_time_binder:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function epoch_time_binder:OnAbilityPhaseStart()
	local ability = self
	local caster = self:GetCaster()
	local target_position = self:GetCastPosition()
	StartAnimation(caster, {duration = 0.7, activity = ACT_DOTA_CAST_ABILITY_2, rate = 0.94})

	return true
end

function epoch_time_binder:OnSpellStart()
    local ability = self
	local caster = self:GetCaster()
    local target_position = self:GetCastPosition()

    
	local start_radius = 110
	local end_radius = 110
	local range = self:GetSpecialValueFor("range")
	local speed = self:GetSpecialValueFor("speed")
	speed = speed * (1 + (EPOCH_Q4_PROJECTILE_SPEED/100)*caster:GetRuneValue("q", 4))
	local projectileParticle = "particles/roshpit/epoch/time_binder_projectile_hellfire_linear.vpcf"

	local perpFV = WallPhysics:rotateVector(caster:GetForwardVector()*Vector(1,1,0), 2*math.pi/4)
	local projectileOrigin = caster:GetAbsOrigin() + Vector(0,0,160) + (perpFV*40) + (caster:GetForwardVector()*40)

	local fv = ((target_position - projectileOrigin)*Vector(1,1,0)):Normalized()
	local info =
	{
		Ability = ability,
		EffectName = projectileParticle,
		vSpawnOrigin = projectileOrigin,
		fDistance = range,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		StartPosition = "attach_origin",
		bHasFrontalCone = true,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = fv * speed,
		bProvidesVision = true,
		iVisionRadius = 100,
		iMoveSpeed = speed,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	Filters:LinearProjectile(info)
	EmitSoundOn("Epoch.TimeBinder.Launch", caster)
    Filters:CastSkillArguments(BASE_ABILITY_Q, caster)
end

function epoch_time_binder:OnProjectileHit(target, vLoc)
	local ability = self
	local caster = self:GetCaster()
	if target and target:HasModifier("modifier_epoch_time_bind") then
		return false
	end
	local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, vLoc)
	ParticleManager:SetParticleControl(pfx, 1, vLoc)
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)	
	EmitSoundOnLocationWithCaster(vLoc, "Epoch.TimeBinder.Impact", target)

	local damage = self:GetImpactDamage()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), vLoc, nil, ability:GetSpecialValueFor("impact_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
		end
	end
	if not ability.link_sets then
		ability.link_sets = {}
	end
	local totalChance = caster:GetRuneValue("q", 3)*EPOCH_Q3_PHANTOM_CHANCE
	ability.q_3_ghost_count = Runes:ProcsByTotalChance(totalChance)
	if target then
		if not target:HasModifier("modifier_epoch_time_bind") then
			local link_set = {}
			local max_links = ability:GetSpecialValueFor("max_links")
			local link_duration = self:GetSpecialValueFor("link_duration")
			target:AddNewModifier(caster, ability, "modifier_epoch_time_bind", {duration = link_duration})
			self:e_3_phantom(target, link_set)
			local link_target = self:SetupLink(target, link_set)
			while link_target and WallPhysics:CountItemsInHash(link_set) < max_links do
				link_target = self:SetupLink(link_target, link_set)
				self:e_3_phantom(link_target, link_set)
			end
			for i = 1, ability.q_3_ghost_count, 1 do
				self:e_3_phantom(target, link_set)
			end
			self:RecalculateLinkSet(link_set)
			table.insert(ability.link_sets, link_set)
			return true
		end
	end
end

function epoch_time_binder:e_3_phantom(target, link_set)
	local ability = self
	if ability.q_3_ghost_count > 0 and target then
		local caster = self:GetCaster()
		local phantom = CreateUnitByName("epoch_eon_phantom", target:GetAbsOrigin()+RandomVector(120), false, nil, nil, caster:GetTeamNumber())
		local source_ent_index = phantom:GetEntityIndex()
		phantom.link_target = target
		phantom:AddNewModifier(caster, self, "modifier_epoch_eon_phantom", {})
		local link_duration = self:GetSpecialValueFor("link_duration")
		phantom:AddNewModifier(caster, ability, "modifier_epoch_time_bind", {duration = link_duration})
		link_set[source_ent_index] = {}
		link_set[source_ent_index].target = target
		ability.q_3_ghost_count = ability.q_3_ghost_count - 1
	end
end

function epoch_time_binder:SetupLink(source, link_set)
	local ability = self
	local caster = self:GetCaster()
	local link_duration = self:GetSpecialValueFor("link_duration")
	local link_search_range = self:GetSpecialValueFor("link_search_range")
	local linked_target = nil
	local source_ent_index = source:GetEntityIndex()
	link_set[source_ent_index] = {}

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), source:GetAbsOrigin(), nil, link_search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			if not enemy:HasModifier("modifier_epoch_time_bind") then
				enemy:AddNewModifier(caster, ability, "modifier_epoch_time_bind", {duration = link_duration})
				linked_target = enemy
				break
			end
		end
	end
	if linked_target then
		link_set[source_ent_index].target = linked_target
	end
	return linked_target
end

function epoch_time_binder:GetImpactDamage()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("impact_damage_base") + caster:GetIntellect()*self:GetSpecialValueFor("impact_damage_int_mult")
end

function epoch_time_binder:ReindexAndClearLinkSets()
	local ability = self
	local new_sets_table = {}
	for i = 1, #ability.link_sets, 1 do
		local set = ability.link_sets[i]
		if set and WallPhysics:CountItemsInHash(set) > 0 then
			table.insert(new_sets_table, set)
		else
			if set then
				for source, link in pairs(set) do
					EntIndexToHScript(source):RemoveModifierByName("modifier_epoch_time_bind")
					if link.target then
						link.target:RemoveModifierByName("modifier_epoch_time_bind")
					end
					if link.pfx then
						ParticleManager:DestroyParticle(link.pfx, false)
						link.pfx = nil
					end
				end			
			end
		end
	end
	ability.link_sets = new_sets_table
end

function epoch_time_binder:RecalculateLinkSet(link_set)
	local source_table = {}
	for source, link in pairs(link_set) do
		if link_set[source].pfx then
			ParticleManager:DestroyParticle(link_set[source].pfx, false)
			link_set[source].pfx = nil
		end
		local sourceEntity = EntIndexToHScript(source)
		if sourceEntity then
			if sourceEntity:EntityExistsAndIsAlive() and sourceEntity:HasModifier("modifier_epoch_time_bind") then
				table.insert(source_table, source)
			else
				link_set[source] = nil
			end
		end
	end
	for i = 1, #source_table - 1, 1 do
		link_set[source_table[i]].target = EntIndexToHScript(source_table[i+1])
		if link_set[source_table[i]].pfx then
			ParticleManager:DestroyParticle(link_set[source_table[i]].pfx, false)
			link_set[source_table[i]].pfx = nil
		end
	end
	local link_set_size = WallPhysics:CountItemsInHash(link_set)
	for source, link in pairs(link_set) do
		local source_unit = EntIndexToHScript(source)
		if source_unit and source_unit:EntityExistsAndIsAlive() then
			if not link_set[source].pfx then
				if source_unit and source_unit:HasModifier("modifier_epoch_time_bind") and link_set[source].target and link_set[source].target:EntityExistsAndIsAlive() and link_set[source].target:HasModifier("modifier_epoch_time_bind") then
					self:CreateLinkParticle(link_set, source_unit, link_set[source].target)
				end
			end
		end
		if source_unit and source_unit:EntityExistsAndIsAlive() then
			source_unit:SetModifierStackCount("modifier_epoch_time_bind", caster, (link_set_size))
		end
		if link_set[source].target and link_set[source].target:EntityExistsAndIsAlive() then
			link_set[source].target:SetModifierStackCount("modifier_epoch_time_bind", caster, (link_set_size))
		end
	end
	self:ReindexAndClearLinkSets()
end

function epoch_time_binder:CreateLinkParticle(link_set, source, target)
	if target then
		EmitSoundOn("Epoch.TimeBinder.Link", target)
		local particleName = "particles/units/heroes/hero_wisp/tether_green.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)	
		link_set[source:GetEntityIndex()].pfx = pfx
	end
end

-- PASSIVE

function modifier_epoch_q_passive:IsHidden()
    return true
end

function modifier_epoch_q_passive:RemoveOnDeath()
    return false
end

function modifier_epoch_q_passive:OnCreated()
    if not IsServer() then
        return false
    end
    self:SetSpecialTypes({ 
    	MODIFIER_ROSHPIT_OVERRIDE_ATTACK_EVENT,
    	MODIFIER_ROSHPIT_INTELLIGENCE_PCT_BONUS,
    	MODIFIER_ROSHPIT_Q_PCT_CD_MOD
    })
    self:StartIntervalThink(1.0)
end

function modifier_epoch_q_passive:GetRoshpitQPctCdModifier()
	local q_4_level = self:GetCaster():GetRuneValue("q", 4)
	return -q_4_level*(EPOCH_Q4_CD_REDUCE_PCT/100)
end

function modifier_epoch_q_passive:BasicAttackOverride(event)
	local target = event.target
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local override = false
    if ability.q_1_attacks then
    	if ability.q_1_attacks[target:GetEntityIndex()] and #ability.q_1_attacks[target:GetEntityIndex()] > 0 then
			local attack_data = ability.q_1_attacks[target:GetEntityIndex()][1]
			local damage = attack_data.mana_drain*EPOCH_Q1_DMG_PER_MANA_DRAIN*caster:GetRuneValue("q", 1) + OverflowProtectedGetAverageTrueAttackDamage(caster)
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
		DeepPrintTable(ability.q_1_attacks)
    end
    return override
end

function epoch_time_binder:clean_up_q_1_attacks_table()
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

function modifier_epoch_q_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}

	return funcs
end

function modifier_epoch_q_passive:OnAttackStart(event)
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
    		caster:SetModifierStackCount("modifier_epoch_q_passive", caster, 1)
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
    		caster:SetModifierStackCount("modifier_epoch_q_passive", caster, 0)
    	end
    end
    ability:clean_up_q_1_attacks_table()
    DeepPrintTable(ability.q_1_attacks)
end

function modifier_epoch_q_passive:GetModifierProjectileName()
	if self:GetStackCount() > 0 then
		return "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
	else
		return false
	end
end

function modifier_epoch_q_passive:GetRoshpitIntelligencePctBonus()
	return self:GetCaster():GetRuneValue("q", 2)*EPOCH_Q2_INT_PCT
end

function modifier_epoch_q_passive:OnIntervalThink()
	if not IsServer() then
		return false
	end
	self:GetParent():SetStatsForLevel()
end

function modifier_epoch_q_passive:OnRemoved()
	if not IsServer() then
		return false
	end
	self:GetParent():SetStatsForLevel()
end

-- Q1 PROJECTILE

-- function modifier_epoch_q_1:IsHidden()
-- 	return true
-- end

-- function modifier_epoch_q_1:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_PROJECTILE_NAME
-- 	}

-- 	return funcs
-- end

-- function modifier_epoch_q_1:GetModifierProjectileName()
-- 	return false
-- end

-- BIND MODIFIER

function modifier_epoch_time_bind:IsHidden()
	return false
end

function modifier_epoch_time_bind:IsDebuff()
	return true
end

function modifier_epoch_time_bind:RoshpitDispellable()
	return false
end

function modifier_epoch_time_bind:RemoveOnDeath()
	return true
end

function modifier_epoch_time_bind:OnCreated()
	if not IsServer() then
		return false
	end
	self:StartIntervalThink(1)
end

function modifier_epoch_time_bind:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_epoch_time_bind:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local target = self:GetParent()
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	if target:GetUnitName() ~= "epoch_eon_phantom" then
		local burn_damage = ability:GetImpactDamage() * ((ability:GetSpecialValueFor("dot_damage_pct_impact")/100)*self:GetStackCount())
		Filters:TakeArgumentsAndApplyDamage(target, caster, burn_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
		CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/time_bind_damage.vpcf", target, 1)
		AddFOWViewer(caster:GetTeamNumber(), target:GetAbsOrigin(), 300, 1.2, false)
	end
end

function modifier_epoch_time_bind:GetModifierMoveSpeedBonus_Constant()
	local stacks = self:GetStackCount()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("ms_slow_base") + ability:GetSpecialValueFor("ms_slow_per_stack")*stacks
end

function modifier_epoch_time_bind:OnRemoved()
	if not IsServer() then
		return false
	end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	for i = 1, #ability.link_sets, 1 do
		if ability.link_sets[i] then
			if ability.link_sets[i][parent:GetEntityIndex()] then
				if ability.link_sets[i][parent:GetEntityIndex()].pfx then
					ParticleManager:DestroyParticle(ability.link_sets[i][parent:GetEntityIndex()].pfx, false)
					ability.link_sets[i][parent:GetEntityIndex()].pfx = nil
				end
				ability:RecalculateLinkSet(ability.link_sets[i])
			end
		end
	end
	if parent:GetUnitName() == "epoch_eon_phantom" then
		parent:ForceKill(false)
	end
end

function modifier_epoch_time_bind:CheckState()
	if not IsServer() then
		return false
	end
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
	return state
end

-- EON PHANTOM MODIFIER

function modifier_epoch_eon_phantom:IsHidden()
	return true
end

function modifier_epoch_eon_phantom:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
	return state
end

function modifier_epoch_eon_phantom:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

function modifier_epoch_eon_phantom:StatusEffectPriority()
	return 100
end

function modifier_epoch_eon_phantom:OnCreated()
	if not IsServer() then
		return false
	end
	local phantom = self:GetParent()
	self:StartIntervalThink(2)
end

function modifier_epoch_eon_phantom:OnIntervalThink()
	if not IsServer() then
		return false
	end
	local phantom = self:GetParent()
	if phantom and IsValidEntity(phantom) then
		if phantom.link_target and phantom.link_target:EntityExistsAndIsAlive() then
			phantom:MoveToPosition(phantom.link_target:GetAbsOrigin() + RandomVector(150))
		end
	end
end

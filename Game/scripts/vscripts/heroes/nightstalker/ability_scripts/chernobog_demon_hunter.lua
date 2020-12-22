require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')

chernobog_demon_hunter = class(base_ability)

modifier_demon_hunter = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_demon_hunter", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w_passive", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w2_inner_beast_active = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w2_inner_beast_active", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w2_inner_beast_inactive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w2_inner_beast_inactive", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w3_active = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w3_active", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w3_inactive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w3_inactive", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w4_active = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w4_active", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w4_inactive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w4_inactive", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

function chernobog_demon_hunter:GetManaCostBase(level)
	if level == -1 then
        level = self:GetLevel() - 1
    end
    return CHERNOBOG_DEMON_HUNTER_MANA_COST[level + 1]
end

function chernobog_demon_hunter:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT
end

function chernobog_demon_hunter:GetAbilitySlot()
    return DOTA_W_SLOT
end

function chernobog_demon_hunter:GetCastPoint()
	return 0
end

function chernobog_demon_hunter:GetCooldownBase()
    return 1
end

function chernobog_demon_hunter:GetAbilityTextureName()
	return "chernobog/demon_hunter"
end

function chernobog_demon_hunter:GetIntrinsicModifierName()
	return "modifier_chernobog_w_passive"
end

function chernobog_demon_hunter:OnToggle()
	local ability = self
	local caster = self:GetCaster()
	local w_2_level = caster:GetRuneValue("w", 2)
	local w_4_level = caster:GetRuneValue("w", 4)
	local healthPercent = caster:GetHealth() / caster:GetMaxHealth()
	local glyphed = caster:HasModifier("modifier_chernobog_glyph_5_a")
	local modifiers = {
		demonHunterEffect = "modifier_demon_hunter",
		w2Active = "modifier_chernobog_w2_inner_beast_active",
		w2Inactive = "modifier_chernobog_w2_inner_beast_inactive",
		w4Active = "modifier_chernobog_w4_active",
		w4Inactive = "modifier_chernobog_w4_inactive"
	}
	
	if self:GetToggleState() == true then
		caster:AddNewModifier(caster, ability, modifiers.demonHunterEffect, {})
		caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
		if w_2_level > 0 then
			caster:AddNewModifier(caster, ability, modifiers.w2Active, {}):SetStackCount(w_2_level)
			if not glyphed and caster:HasModifier(modifiers.w2Inactive) then
				caster:RemoveModifierByName(modifiers.w2Inactive)
			end
		end
		if w_4_level > 0 then
			caster:AddNewModifier(caster, ability, modifiers.w4Active, {}):SetStackCount(w_4_level)
			if not glyphed and caster:HasModifier(modifiers.w4Inactive) then
				caster:RemoveModifierByName(modifiers.w4Inactive)
			end
		end
		EmitSoundOn("Chernobog.DemonHunterStart", caster)
		CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", caster, 4)
		if not caster:HasModifier("modifier_chernobog_demon_form") then
			StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_NIGHTSTALKER_TRANSITION, rate = 1})
		else
			StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
		end
		Timers:CreateTimer(0.03, function()
			caster:SetHealth(math.max(caster:GetMaxHealth() * healthPercent, 1))
		end)
	else
		caster:RemoveModifierByName(modifiers.demonHunterEffect)
		if w_2_level > 0 then
			caster:AddNewModifier(caster, ability, modifiers.w2Inactive, {}):SetStackCount(w_2_level)
			if not glyphed and caster:HasModifier(modifiers.w2Active) then
				caster:RemoveModifierByName(modifiers.w2Active)
			end
		end
		if w_4_level > 0 then
			caster:AddNewModifier(caster, ability, modifiers.w4Inactive, {}):SetStackCount(w_4_level)
			if not glyphed and caster:HasModifier(modifiers.w4Active) then
				caster:RemoveModifierByName(modifiers.w4Active)
			end			
		end
		if not caster:HasModifier("modifier_chernobog_demon_form") then
			StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.5})
		else
			StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_ATTACK, rate = 1.5})
		end
		caster:SetRangedProjectileName("particles/roshpit/chernobog/demon_form_attack.vpcf")
		EmitSoundOn("Chernobog.Untoggle", caster)
		CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", caster, 4)
		Timers:CreateTimer(0.03, function()
			caster:SetHealth(math.max(caster:GetMaxHealth() * healthPercent, 1))
		end)
	end
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

--modifiers
--demon hunter effect
function modifier_demon_hunter:IsHidden()
	return false
end

function modifier_demon_hunter:IsDebuff()
	return false
end

function modifier_demon_hunter:IsPurgable()
	return false
end

function modifier_demon_hunter:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end

function modifier_demon_hunter:StatusEffectPriority()
	return 100
end

function modifier_demon_hunter:DeclareFunctions()
	return {MODIFIER_PROPERTY_DISABLE_HEALING,
			MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_demon_hunter:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_AS
	})
	self:StartIntervalThink(0.1)
end

function modifier_demon_hunter:OnIntervalThink()
	if not IsServer() then
		return
	end
	local level = self:GetAbility():GetLevel()
	local mana_cost_threshold = self:GetAbility():GetSpecialValueFor("mana_drain_when_threshold_used")
	if (self:GetCaster():GetMana()) < mana_cost_threshold then	
		self:GetAbility():ToggleAbility()
	end
	
end

function modifier_demon_hunter:OnAttackLanded(event)
	if not IsServer() then
		return
	end
	if event.attacker ~= self:GetCaster() or self:GetCaster() == event.target then
		return
	end
	local caster = self:GetCaster()
	local target = event.target
	local ability = self:GetAbility()
	local w_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("magic_damage_bonus") / 100
	local w_mp_drain = ability:GetSpecialValueFor("mana_drain_per_attack")
	local w_hp_cost = ability:GetSpecialValueFor("health_cost_percent") / 100 * caster:GetMaxHealth()
	local newHealth = math.max(caster:GetHealth() - w_hp_cost, 1)
	caster:SetHealth(newHealth)
	caster:ReduceMana(w_mp_drain)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, CHERNOBOG_W_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do 
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, w_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)	
		end
	end
end

function modifier_demon_hunter:GetRoshpitMasterAS()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_demon_hunter:GetDisableHealing()
	return 1
end

--W passive thinker, to make it realtime update
function modifier_chernobog_w_passive:IsHidden()
	return true
end

function modifier_chernobog_w_passive:IsDebuff()
	return false
end

function modifier_chernobog_w_passive:IsPurgable()
	return false
end

function modifier_chernobog_w_passive:IsPermanent()
	return true
end

function modifier_chernobog_w_passive:RemoveOnDeath()
	return false
end

function modifier_chernobog_w_passive:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_chernobog_w_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.5)
end

function modifier_chernobog_w_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	ability:ModifierThink("modifier_chernobog_w2_inner_beast_active", "w", 2, true)
	ability:ModifierThink("modifier_chernobog_w2_inner_beast_inactive", "w", 2, false)
	ability:ModifierThink("modifier_chernobog_w4_active", "w", 4, true)
	ability:ModifierThink("modifier_chernobog_w4_inactive", "w", 4, false)

	if not caster:IsAlive() then
		if caster:GetTimeUntilRespawn() == 0 then
			caster:SetHealth(10)
			caster:ForceKill(true)
		end
	end
end

function chernobog_demon_hunter:ModifierThink(modifier_name, rune, runeTier, toggleState)
	local caster = self:GetCaster()
	local ability = self
	local abilityToggleState = ability:GetToggleState()
	local rune_level = caster:GetRuneValue(rune, runeTier)
	local glyphed = caster:HasModifier("modifier_chernobog_glyph_5_a")
	local modifier = caster:FindModifierByName(modifier_name)
	if not modifier then
		return false
	end
	if (toggleState ~= abilityToggleState and not glyphed) or not (rune_level > 0) then
		modifier:Destroy()
		return false
	end
	modifier:SetStackCount(rune_level)	
end

function modifier_chernobog_w_passive:OnAttackLanded(event)
	if not IsServer() then
		return
	end
	if event.attacker ~= self:GetParent() or event.target == self:GetParent() then
		return
	end
	local caster = self:GetCaster()
	local target = event.target
	local ability = self:GetAbility()
	ability:ProcW1(caster, "w", 1, target)
	ability:ProcW3(caster, "w", 3, target)
end

function chernobog_demon_hunter:ProcW1(caster, rune, runeTier, target)
	local w_1_level = caster:GetRuneValue(rune, runeTier)
	if not (w_1_level > 0) then
		return false
	end
	local w_1_damage = w_1_level * CHERNOBOG_W1_DMG_PER_MISSING_MP * (caster:GetMaxMana() - caster:GetMana())
	local w_1_heal = w_1_level * CHERNOBOG_W1_HEAL
	local glyphed = caster:HasModifier("modifier_chernobog_glyph_5_a")
	if self:GetToggleState() == true then
		self:ApplyW1Damage(caster, w_1_damage, target)
	else
		CustomAbilities:QuickAttachParticle("particles/chernobog/chernobog_a_b_timedialate.vpcf", caster, 2)
		Filters:ApplyHeal(caster, caster, w_1_heal, true, false)
		if glyphed then
			self:ApplyW1Damage(caster, w_1_damage, target)
		end
	end
end

function chernobog_demon_hunter:ApplyW1Damage(caster, damage, target)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, CHERNOBOG_W1_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do 
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)	
		end
	end
end

function chernobog_demon_hunter:ProcW3(caster, rune, runeTier, target)
	local w_3_level = caster:GetRuneValue(rune, runeTier)
	if not (w_3_level > 0) then
		return false
	end
	local w_3_duration = Filters:GetAdjustedBuffDuration(caster, CHERNOBOG_W3_DURATION, false)
	local glyphed = caster:HasModifier("modifier_chernobog_glyph_5_a")
	local modifiers = {
		w3Active = "modifier_chernobog_w3_active",
		w3Inactive = "modifier_chernobog_w3_inactive"
	}
	if self.fevorTarget then
		if not IsValidEntity(self.fevorTarget) then
			return false
		end
		if target:GetEntityIndex() == self.fevorTarget:GetEntityIndex() then
			if self:GetToggleState() == true then
				self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, false)
				if glyphed then
					self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, false)
				end
			else
				self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, false)
				if glyphed then
					self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, false)
				end
			end
		else
			self.fevorTarget = target
			if self:GetToggleState() == true then
				self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, true)
				if glyphed then
					self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, false)
				end
			else
				self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, false)
				if glyphed then
					self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, CHERNOBOG_W3_MAX_STACKS, true)
				end
			end
		end
	else
		self.fevorTarget = target
	end
end

function chernobog_demon_hunter:ModifyStacks(caster, target, modifier_name, stacks, duration, maxStacks, changeTarget)
	if not IsValidEntity(target) then
		return
	end
	local modifier = target:FindModifierByName(modifier_name)
	if not modifier then
		modifier = target:AddNewModifier(caster, self, modifier_name, {duration = duration})
	end
	local stacks = target:GetModifierStackCount(modifier_name, caster)
	if changeTarget then
		stacks = stacks * CHERNOBOG_W3_STACK_LOSE_PCT / 100 + 1
	else
		stacks = stacks + 1
	end
	modifier:SetStackCount(math.min(stacks, maxStacks))
	modifier:SetDuration(duration, true)
end

--W2 
function modifier_chernobog_w2_inner_beast_active:IsHidden()
	return false
end

function modifier_chernobog_w2_inner_beast_active:IsDebuff()
	return false
end

function modifier_chernobog_w2_inner_beast_active:GetTexture()
	return "chernobog/chernobog_rune_w_2"
end

function modifier_chernobog_w2_inner_beast_active:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
	})
end

function modifier_chernobog_w2_inner_beast_active:GetRoshpitMasterBaseDMG()
	return self:GetStackCount() * CHERNOBOG_W2_ATT
end

function modifier_chernobog_w2_inner_beast_inactive:IsHidden()
	return false
end

function modifier_chernobog_w2_inner_beast_inactive:IsDebuff()
	return false
end

function modifier_chernobog_w2_inner_beast_inactive:GetTexture()
	return "chernobog/chernobog_rune_w_2"
end

function modifier_chernobog_w2_inner_beast_inactive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
			MODIFIER_ROSHPIT_ARMOR_BONUS
	})
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_chernobog_w2_inner_beast_inactive:GetRoshpitArmorBonus()
	return self:GetStackCount() * CHERNOBOG_W2_ARMOR
end

--w3
function modifier_chernobog_w3_active:IsHidden() 
	return false
end

function modifier_chernobog_w3_active:IsDebuff()
	return false
end

function modifier_chernobog_w3_active:GetTexture()
	return "chernobog/chernobog_rune_w_3"
end

function modifier_chernobog_w3_active:GetEffectName()
	return "particles/roshpit/chernobog/fervor.vpcf"
end

function modifier_chernobog_w3_active:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_chernobog_w3_active:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG
	})
end

function modifier_chernobog_w3_active:GetRoshpitMasterBaseDMG()
	return self:GetStackCount() * self:GetCaster():GetRuneValue("w", 3) * CHERNOBOG_W3_ATT
end

function modifier_chernobog_w3_inactive:IsHidden()
	return false
end

function modifier_chernobog_w3_inactive:IsDebuff()
	return true
end

function modifier_chernobog_w3_inactive:GetEffectName()
	return "particles/roshpit/chernobog/fervor.vpcf"
end

function modifier_chernobog_w3_inactive:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_chernobog_w3_inactive:GetTexture()
	return "chernobog/chernobog_rune_w_3"
end

function modifier_chernobog_w3_inactive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_ARMOR_BONUS
	})
	self:GetParent():CalculateAndSaveRoshpitAttributes()
	self:StartIntervalThink(0.1)
end

function modifier_chernobog_w3_inactive:OnIntervalThink()
	if not IsServer() then
		return
	end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_chernobog_w3_inactive:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_chernobog_w3_inactive:GetRoshpitArmorBonus()
	local reduc = self:GetStackCount() * self:GetCaster():GetRuneValue("w", 3) * CHERNOBOG_W3_ARMOR_REDUCE
	return reduc
end

--w4

function modifier_chernobog_w4_active:IsHidden()
	return true
end

function modifier_chernobog_w4_active:IsDebuff()
	return false
end

function modifier_chernobog_w4_active:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_AGILITY_BONUS
	})
end

function modifier_chernobog_w4_active:GetRoshpitAgilityBonus()
	return self:GetStackCount() * CHERNOBOG_W4_AGI_AND_STR
end

function modifier_chernobog_w4_inactive:IsHidden()
	return true
end

function modifier_chernobog_w4_inactive:IsDebuff()
	return false
end

function modifier_chernobog_w4_inactive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_STRENGTH_BONUS
	})
end

function modifier_chernobog_w4_inactive:GetRoshpitStrengthBonus()
	return self:GetStackCount() * CHERNOBOG_W4_AGI_AND_STR
end








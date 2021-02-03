require('heroes/nightstalker/util')

chernobog_demon_hunter = class(base_ability)

modifier_demon_hunter = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_demon_hunter", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_demon_hunter_healing_disable = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_demon_hunter_healing_disable", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w_passive", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w1_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w1_effect", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w2_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w2_effect", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w3_active = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w3_active", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w3_inactive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w3_inactive", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w4_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w4_effect", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

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
	local healthPercent = caster:GetHealth() / caster:GetMaxHealth()
	if self:GetToggleState() == true then
		ApplyModifier(caster, caster, ability, "modifier_demon_hunter", -1, 0)
		caster:FindModifierByName("modifier_chernobog_w_passive"):OnIntervalThink()
		caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
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
		caster:RemoveModifierByName("modifier_demon_hunter")
		caster:FindModifierByName("modifier_chernobog_w_passive"):OnIntervalThink()
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
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_EVENT_ON_TAKEDAMAGE}
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
	if (self:GetCaster():GetMana()) < 1 then	
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
	local radius = CalculateFinalRadius(caster, CHERNOBOG_W_RADIUS, DOTA_W_SLOT)
	local w_damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("magic_damage_bonus") / 100
	local w_mp_drain = ability:GetSpecialValueFor("mana_drain_per_attack")
	local w_hp_cost = ability:GetSpecialValueFor("health_cost_percent") / 100 * caster:GetHealth()
	local newHealth = math.max(caster:GetHealth() - w_hp_cost, 1)
	local R_ability = caster:GetAbilityByIndex(DOTA_R_SLOT)
	if not (caster:HasModifier("modifier_chernobog_glyph_6_2") and (caster:GetHealthPercent() < CHERNOBOG_GLYPH_6_2_THRESHOLD)) then
		caster:SetHealth(newHealth)
	end
	caster:ReduceMana(w_mp_drain)
	local enemies = SearchEnemies(caster, target, radius)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do 
			ChernobogDealDamage(caster, enemy, w_damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, false, true)
		end
	end
end

function modifier_demon_hunter:OnTakeDamage(event)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local modifier_name = "modifier_demon_hunter_healing_disable"
	local disable_duration = CHERNOBOG_DEMON_HUNTER_HEALING_DISABLE_DURATION
	if not caster:HasModifier(modifier_name) then
		caster:AddNewModifier(caster, ability, modifier_name, {duration = disable_duration})
	else
		caster:FindModifierByName(modifier_name):SetDuration(disable_duration, true)
	end
end

function modifier_demon_hunter:OnDestroy()
	if not IsServer() then
		return
	end
	if self:GetCaster():HasModifier("modifier_demon_hunter_healing_disable") then
		self:GetCaster():RemoveModifierByName("modifier_demon_hunter_healing_disable")
	end
end

function modifier_demon_hunter:GetRoshpitMasterAS()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

--HEALING DISABLE MODIFIER--
function modifier_demon_hunter_healing_disable:IsHidden()
	return true
end

function modifier_demon_hunter_healing_disable:IsDebuff()
	return false
end

function modifier_demon_hunter_healing_disable:IsPurgable()
	return false
end

function modifier_demon_hunter_healing_disable:DeclareFunctions()
	return {MODIFIER_PROPERTY_DISABLE_HEALING}
end

function modifier_demon_hunter_healing_disable:GetDisableHealing()
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
	ModifierThink(self:GetCaster(), self:GetAbility(), DOTA_W_SLOT, "w", nil, false)
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
	local aggroTarget = caster:GetAggroTarget()
	local healamount = ability:GetSpecialValueFor("heal_amount")
	if ability:GetToggleState() == false then
		CustomAbilities:QuickAttachParticle("particles/chernobog/chernobog_a_b_timedialate.vpcf", caster, 2)
		Filters:ApplyHeal(caster, caster, healamount, true, false)
	end
	if caster:HasModifier("modifier_chernobog_demon_flight") then
		ability:ProcW3(caster, target)
	elseif (aggroTarget) and (target:GetEntityIndex() == aggroTarget:GetEntityIndex()) then
		ability:ProcW3(caster, target)
	end
end

function chernobog_demon_hunter:ProcW3(caster, target)
	local w_3_level = caster:GetRuneValue("w", 3)
	if not (w_3_level > 0) then
		return false
	end
	local base_w_3_duration = CHERNOBOG_W3_DURATION
	local w_3_duration = Filters:GetAdjustedBuffDuration(caster, base_w_3_duration, false)
	local maxstacks = CHERNOBOG_W3_MAX_STACKS
	local glyphed = caster:HasModifier("modifier_chernobog_glyph_5_a")
	local modifiers = {
		w3Active = "modifier_chernobog_w3_active",
		w3Inactive = "modifier_chernobog_w3_inactive"
	}
	if self.fevorTarget == nil then
		self.fevorTarget = target
	end
	if self.fevorTarget then
		if not IsValidEntity(self.fevorTarget) then
			return false
		end
		if target:GetEntityIndex() == self.fevorTarget:GetEntityIndex() then
			if self:GetToggleState() == true then
				self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, maxstacks, false)
				if glyphed then
					self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, maxstacks, false)
				end
			else
				self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, maxstacks, false)
				if glyphed then
					self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, maxstacks, false)
				end
			end
		else
			self.fevorTarget = target
			if self:GetToggleState() == true then
				self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, maxstacks, true)
				if glyphed then
					self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, maxstacks, false)
				end
			else
				self:ModifyStacks(caster, target, modifiers.w3Inactive, 1, w_3_duration, maxstacks, false)
				if glyphed then
					self:ModifyStacks(caster, caster, modifiers.w3Active, 1, w_3_duration, maxstacks, true)
				end
			end
		end
	end
end

function chernobog_demon_hunter:ModifyStacks(caster, target, modifier_name, stacks, duration, maxStacks, changeTarget)
	if not IsValidEntity(target) then
		return
	end
	local stackCount = target:GetModifierStackCount(modifier_name, caster)
	if caster:HasModifier("modifier_chernobog_glyph_6_1") then
		stacks = stacks + CHERNOBOG_GLYPH_6_1_ADDITION_STACK
		maxStacks = maxStacks + CHERNOBOG_GLYPH_6_1_W3_MAX_STACK_BONUS
	end
	if changeTarget then
		stackCount = math.min(stackCount * CHERNOBOG_W3_STACK_LOSE_PCT / 100 + stacks, maxStacks)
	else
		stackCount = math.min(stackCount + stacks, maxStacks)
	end
	ApplyModifier(caster, target, ability, modifier_name, duration, stackCount)
end

----------
--- W1 ---
----------
function modifier_chernobog_w1_effect:IsHidden()
	return true
end

function modifier_chernobog_w1_effect:IsDebuff()
	return false
end

function modifier_chernobog_w1_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
		MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS
	})
end

function modifier_chernobog_w1_effect:GetRoshpitSpellPierceBonus()
	if (self:GetAbility():GetToggleState() == true) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetStackCount() * self:GetCaster():GetAgility() * CHERNOBOG_W1_PIERCE_SACLE
	end
end

function modifier_chernobog_w1_effect:GetRoshpitArmorPierceBonus()
	if (self:GetAbility():GetToggleState() == false) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetStackCount() * self:GetCaster():GetStrength() * CHERNOBOG_W1_PIERCE_SACLE
	end
end

----------
--- W2 ---
----------
function modifier_chernobog_w2_effect:IsHidden()
	return false
end

function modifier_chernobog_w2_effect:IsDebuff()
	return false
end

function modifier_chernobog_w2_effect:GetTexture()
	return "chernobog/chernobog_rune_w_2"
end

function modifier_chernobog_w2_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG,
		MODIFIER_ROSHPIT_ARMOR_BONUS
	})
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_chernobog_w2_effect:GetRoshpitMasterBaseDMG()
	if (self:GetAbility():GetToggleState() == true) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetStackCount() * CHERNOBOG_W2_ATT
	end
end

function modifier_chernobog_w2_effect:GetRoshpitArmorBonus()
	if (self:GetAbility():GetToggleState() == false) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetStackCount() * CHERNOBOG_W2_ARMOR
	end
end

----------
--- W3 ---
----------
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
		MODIFIER_ROSHPIT_ARMOR_BONUS,
		MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
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
	local base = self:GetStackCount() * self:GetCaster():GetRuneValue("w", 3) * CHERNOBOG_W3_ARMOR_REDUCE
	local reduc = CalculateFinalArmorReduction(self:GetCaster(), base)
	return reduc
end

function modifier_chernobog_w3_inactive:GetRoshpitMagicArmorBonus()
	local base = self:GetStackCount() * self:GetCaster():GetRuneValue("w", 3) * CHERNOBOG_W3_ARMOR_REDUCE
	local reduc = CalculateFinalArmorReduction(self:GetCaster(), base)
	return reduc
end

----------
--- W4 ---
----------
function modifier_chernobog_w4_effect:IsHidden()
	return true
end

function modifier_chernobog_w4_effect:IsDebuff()
	return false
end

function modifier_chernobog_w4_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_AGILITY_BONUS,
		MODIFIER_ROSHPIT_STRENGTH_BONUS
	})
end

function modifier_chernobog_w4_effect:GetRoshpitAgilityBonus()
	if (self:GetAbility():GetToggleState() == true) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetStackCount() * CHERNOBOG_W4_AGI_AND_STR
	end
end

function modifier_chernobog_w4_effect:GetRoshpitStrengthBonus()
	if (self:GetAbility():GetToggleState() == false) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetStackCount() * CHERNOBOG_W4_AGI_AND_STR
	end
end

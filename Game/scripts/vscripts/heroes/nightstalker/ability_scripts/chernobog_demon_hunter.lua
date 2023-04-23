require('heroes/nightstalker/util')

chernobog_demon_hunter = class(base_ability)

modifier_demon_hunter = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_demon_hunter", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w_passive", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_w3_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_w3_effect", "heroes/nightstalker/ability_scripts/chernobog_demon_hunter.lua", LUA_MODIFIER_MOTION_NONE)

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
    return 0.1
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
		caster:AddNewModifier(caster, ability, "modifier_demon_hunter", {})
		caster:SetRangedProjectileName("particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf")
		EmitSoundOn("Chernobog.DemonHunterStart", caster)
		if not caster:HasModifier("modifier_chernobog_demon_form") then
			StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_NIGHTSTALKER_TRANSITION, rate = 1})
		else
			StartAnimation(caster, {duration = 0.9, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1})
		end
	else
		caster:RemoveModifierByName("modifier_demon_hunter")
		caster:SetRangedProjectileName("particles/roshpit/chernobog/demon_form_attack.vpcf")
		EmitSoundOn("Chernobog.Untoggle", caster)
		if not caster:HasModifier("modifier_chernobog_demon_form") then
			StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_SPAWN, rate = 1.5})
		else
			StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_ATTACK, rate = 1.5})
		end
	end
	Timers:CreateTimer(0.03, function()
		caster:SetHealth(math.max(caster:GetMaxHealth() * healthPercent, 1))
	end)
	CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/demon_hunter.vpcf", caster, 4)	
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
end

---------------------------
--- DEMON HUNTER EFFECT ---
---------------------------
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
	return {
	    MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_demon_hunter:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_AS,
		MODIFIER_ROSHPIT_EVENT_ATTACK_LAND,
	})
	self.disableHealing = 0
	self:StartIntervalThink(0.1)
end

function modifier_demon_hunter:OnIntervalThink()
	if not IsServer() then
		return
	end
	if (self.disableHealing == 1) and (GameRules:GetGameTime() >= self.enableHealingTimer) then
		self.disableHealing = 0
	end
end

function modifier_demon_hunter:RoshpitAttackLand(event)
	local target = event.victim
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	local radius = CalculateFinalRadius(caster, CHERNOBOG_W_RADIUS, DOTA_W_SLOT)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("magic_damage_bonus") / 100
	local mp_drain = ability:GetSpecialValueFor("mana_drain_per_attack")
	local hp_cost = ability:GetSpecialValueFor("health_cost_percent") / 100 * caster:GetHealth()
	local newHealth = math.max(caster:GetHealth() - hp_cost, 1)
	if not (caster:HasModifier("modifier_chernobog_glyph_6_2") and (caster:GetHealthPercent() < CHERNOBOG_GLYPH_6_2_THRESHOLD)) then
		caster:SetHealth(newHealth)
	end
	caster:Script_ReduceMana(mp_drain, nil)
	local enemies = SearchEnemies(caster, target, radius, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do 
			ChernobogDealDamage(caster, enemy, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE, false, true)
		end
	end
end

function modifier_demon_hunter:OnTakeDamage(event)
    if not IsServer() then
	    return
	end
	self.disableHealing = 1
	self.enableHealingTimer = GameRules:GetGameTime() + 3
end

function modifier_demon_hunter:GetRoshpitMasterAS()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_demon_hunter:GetDisableHealing()
	return self.disableHealing
end

---------------------------
--- W PASSIVE AND RUNES ---
---------------------------
function modifier_chernobog_w_passive:IsHidden()
	return true
end

function modifier_chernobog_w_passive:IsDebuff()
	return false
end

function modifier_chernobog_w_passive:IsPurgable()
	return false
end

function modifier_chernobog_w_passive:RemoveOnDeath()
	return false
end

function modifier_chernobog_w_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
	    MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
	    MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
	    MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG,
	    MODIFIER_ROSHPIT_ARMOR_BONUS,
		MODIFIER_ROSHPIT_EVENT_ATTACK_LAND,
	    MODIFIER_ROSHPIT_AGILITY_BONUS,
	    MODIFIER_ROSHPIT_STRENGTH_BONUS
	})
	self:StartIntervalThink(0.5)
end

function modifier_chernobog_w_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	if self:GetCaster():HasModifier("modifier_chernobog_glyph_6_1") then
	    self:ModifyStacks(self:GetCaster(), self:GetCaster(), "modifier_chernobog_w3_effect", 0, CHERNOBOG_W3_DURATION, CHERNOBOG_W3_MAX_STACKS, 0, false)
	end
end

function modifier_chernobog_w_passive:GetRoshpitSpellPierceBonus()
	if (self:GetAbility():GetToggleState() == true) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetCaster():GetRuneValue("w", 1) * CHERNOBOG_W1_PIERCE_SACLE * self:GetCaster():GetAgility()
	end
end

function modifier_chernobog_w_passive:GetRoshpitArmorPierceBonus()
	if (self:GetAbility():GetToggleState() == false) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetCaster():GetRuneValue("w", 1) * CHERNOBOG_W1_PIERCE_SACLE * self:GetCaster():GetStrength()
	end
end

function modifier_chernobog_w_passive:GetRoshpitMasterBaseDMG()
	if (self:GetAbility():GetToggleState() == true) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetCaster():GetRuneValue("w", 2) * CHERNOBOG_W2_ATT
	end
end

function modifier_chernobog_w_passive:GetRoshpitArmorBonus()
	if (self:GetAbility():GetToggleState() == false) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetCaster():GetRuneValue("w", 2) * CHERNOBOG_W2_ARMOR
	end
end

function modifier_chernobog_w_passive:GetRoshpitAgilityBonus()
	if (self:GetAbility():GetToggleState() == true) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetCaster():GetRuneValue("w", 4) * CHERNOBOG_W4_AGI_AND_STR
	end
end

function modifier_chernobog_w_passive:GetRoshpitStrengthBonus()
	if (self:GetAbility():GetToggleState() == false) or self:GetCaster():HasModifier("modifier_chernobog_glyph_5_a") then
		return self:GetCaster():GetRuneValue("w", 4) * CHERNOBOG_W4_AGI_AND_STR
	end
end

----------
--- W3 ---
----------
function modifier_chernobog_w_passive:RoshpitAttackLand(event)
	local target = event.victim
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	local healamount = ability:GetSpecialValueFor("heal_amount")
	if ability:GetToggleState() == false then
		CustomAbilities:QuickAttachParticle("particles/chernobog/chernobog_a_b_timedialate.vpcf", caster, 2)
		Filters:ApplyHeal(caster, caster, healamount, true, false)
	end
	self:ProcW3(caster, target)
end

function modifier_chernobog_w_passive:ProcW3(caster, target)
	local modifier = "modifier_chernobog_w3_effect"
	if self.fevorTarget == nil then
		self.fevorTarget = target
	end
	if self.fevorTarget then
		if target == self.fevorTarget then
			self:ModifyStacks(caster, caster, modifier, 1, CHERNOBOG_W3_DURATION, CHERNOBOG_W3_MAX_STACKS, 0, false)
			self:ModifyStacks(caster, target, modifier, 1, CHERNOBOG_W3_DURATION, CHERNOBOG_W3_MAX_STACKS, 0, false)
		else
			self.fevorTarget = target
			self:ModifyStacks(caster, caster, modifier, 1, CHERNOBOG_W3_DURATION, CHERNOBOG_W3_MAX_STACKS, 0, true)
			self:ModifyStacks(caster, target, modifier, 1, CHERNOBOG_W3_DURATION, CHERNOBOG_W3_MAX_STACKS, 0, false)
		end
	end
end

function modifier_chernobog_w_passive:ModifyStacks(caster, target, modifier_name, stacks, duration, maxStacks, minStacks, changeTarget)
	local w_3_level = caster:GetRuneValue("w", 3)
	if not (w_3_level > 0) then
		return
	end
	if not caster:HasModifier("modifier_chernobog_glyph_5_a") then
     	if not ((caster == target and self:GetAbility():GetToggleState() == true) or (caster ~= target and self:GetAbility():GetToggleState() == false)) then
		    return
		end
	end
	if caster:HasModifier("modifier_chernobog_glyph_6_1") then
		maxStacks = maxStacks + CHERNOBOG_GLYPH_6_1_W3_MAX_STACK_BONUS
		if caster == target then
		    minStacks = 20
		end
		if stacks > 0 then
			stacks = stacks + CHERNOBOG_GLYPH_6_1_ADDITION_STACK
		end
	end
	local currentStacks = target:GetModifierStackCount(modifier_name, caster)
	local newStacks = 0
	local finalStacks = 0
	if changeTarget then
		newStacks = math.floor(currentStacks * CHERNOBOG_W3_STACK_LOSE_PCT / 100) + stacks
	else
		newStacks = currentStacks + stacks
	end
	if newStacks > minStacks then
		finalStacks = math.min(maxStacks, newStacks)
	else
		finalStacks = minStacks + stacks
	end
	if stacks > 0 then
	    if not target:HasModifier(modifier_name) then
	        target:AddNewModifier(caster, self:GetAbility(), modifier_name, {duration = duration})
			target:SetModifierStackCount(modifier_name, caster, finalStacks)
		else
		    target:SetModifierStackCount(modifier_name, caster, finalStacks)
			target:FindModifierByName(modifier_name):SetDuration(duration, true)
		end
	else
	    if not (currentStacks > minStacks) then
		    if not target:HasModifier(modifier_name) then
		        target:AddNewModifier(caster, self:GetAbility(), modifier_name, {duration = duration})
				target:SetModifierStackCount(modifier_name, caster, minStacks)
			else
			    target:SetModifierStackCount(modifier_name, target, minStacks)
				target:FindModifierByName(modifier_name):SetDuration(duration, true)
			end
		end
	end
end

function modifier_chernobog_w3_effect:IsHidden() 
	return false
end

function modifier_chernobog_w3_effect:IsDebuff()
	if self:GetParent() ~= self:GetCaster() then
		return true
	end
	return false
end

function modifier_chernobog_w3_effect:GetTexture()
	return "chernobog/chernobog_rune_w_3"
end

function modifier_chernobog_w3_effect:GetEffectName()
	return "particles/roshpit/chernobog/fervor.vpcf"
end

function modifier_chernobog_w3_effect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_chernobog_w3_effect:OnCreated()
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({
		MODIFIER_ROSHPIT_MASTER_BASE_ATTACK_DMG,
		MODIFIER_ROSHPIT_ARMOR_BONUS,
		MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
	})
	self:GetParent():CalculateAndSaveRoshpitAttributes()
	self:StartIntervalThink(0.1)
end

function modifier_chernobog_w3_effect:OnIntervalThink()
	if not IsServer() then
		return
	end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
	if not (self:GetCaster():GetRuneValue("w", 3) > 0) then
	    self:Destroy()
	end
end

function modifier_chernobog_w3_effect:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():CalculateAndSaveRoshpitAttributes()
end

function modifier_chernobog_w3_effect:GetRoshpitMasterBaseDMG()
	if not self:IsDebuff() then
		return self:GetStackCount() * self:GetCaster():GetRuneValue("w", 3) * CHERNOBOG_W3_ATT
	end
end

function modifier_chernobog_w3_effect:GetRoshpitArmorBonus()
	if self:IsDebuff() then
		local base = self:GetStackCount() * self:GetCaster():GetRuneValue("w", 3) * CHERNOBOG_W3_ARMOR_REDUCE
		return CalculateFinalArmorReduction(self:GetCaster(), base)
	end
end

function modifier_chernobog_w3_effect:GetRoshpitMagicArmorBonus()
	if self:IsDebuff() then
		local base = self:GetStackCount() * self:GetCaster():GetRuneValue("w", 3) * CHERNOBOG_W3_ARMOR_REDUCE
		return CalculateFinalArmorReduction(self:GetCaster(), base)
	end
end

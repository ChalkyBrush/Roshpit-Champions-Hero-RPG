require('heroes/nightstalker/chernobog_constants')
require('heroes/base_ability')

chernobog_shadow_hunt = class(base_ability)

modifier_shadow_hunt = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_shadow_hunt", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e_passive = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e_passive", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e1_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e1_buff", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e2_shadow_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e2_shadow_thinker", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e3_thinker = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e3_thinker", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e3_effect = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e3_effect", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

modifier_chernobog_e4_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_chernobog_e4_buff", "heroes/nightstalker/ability_scripts/chernobog_shadow_hunt.lua", LUA_MODIFIER_MOTION_NONE)

function chernobog_shadow_hunt:GetBehaviorBase()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_AOE
end

function chernobog_shadow_hunt:GetAbilitySlot()
	return DOTA_E_SLOT
end

function chernobog_shadow_hunt:GetCastPoint()
	return 0
end

function chernobog_shadow_hunt:GetManaCostBase(level)
	return 0
end

function chernobog_shadow_hunt:GetCooldownBase(level)
	return self:GetSpecialValueFor("cooldown")
end

function chernobog_shadow_hunt:GetIntrinsicModifierName()
	return "modifier_chernobog_e_passive"
end

function chernobog_shadow_hunt:GetAbilityTextureName()
	return 'night_stalker_hunter_in_the_night'
end

function chernobog_shadow_hunt:GetModifierTable()
	return {
			"modifier_chernobog_e1_buff",
			"modifier_chernobog_e2_shadow_thinker",
			"modifier_chernobog_e3_thinker",
			"modifier_chernobog_e4_buff"
	}
end

function chernobog_shadow_hunt:OnToggle()
	local caster = self:GetCaster()
	local ability = self
	if self:GetToggleState() == true then
		caster:AddNewModifier(caster, ability, "modifier_shadow_hunt", {})
	else
		if caster:HasModifier("modifier_shadow_hunt") then
			caster:RemoveModifierByName("modifier_shadow_hunt")
		end
	end
end

--modifiers

function modifier_shadow_hunt:IsHidden()
	return false
end

function modifier_shadow_hunt:IsDebuff()
	return false
end

function modifier_shadow_hunt:OnCreated()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local modifiers = ability:GetModifierTable()
	if not modifiers then
		return
	end
	for i = 1, 4, 1 do
		local rune_level = caster:GetRuneValue("e", i)
		if rune_level > 0 then
			local modifier = caster:AddNewModifier(caster, ability, modifiers[i], {})
			if i == 1 then
				modifier:SetStackCount(rune_level)
			end
		end
	end
	self:StartIntervalThink(CHERNOBOG_E_DRAIN_INTERVAL)
end

function modifier_shadow_hunt:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local currentHealth = caster:GetHealth()
        local currentMana = caster:GetMana()
        local minHealth = 1
        local minMana = 0
        if caster:HasModifier("modifier_chernobog_glyph_5_1") then
            minHealth = caster:GetMaxHealth() * CHERNOBOG_T51_DRAIN_HP_CAP_PCT
            minMana = caster:GetMaxMana() * CHERNOBOG_T51_DRAIN_MP_CAP_PCT
        end
        if currentHealth > minHealth then
            caster:SetHealth(math.max(currentHealth - caster:GetMaxHealth() * CHERNOBOG_E_DRAIN_INTERVAL * CHERNOBOG_E_HP_DRAIN[self:GetAbility():GetLevel()] / 100, minHealth))
        end
        if currentMana > minMana then
            caster:ReduceMana(math.min(caster:GetMaxMana() * CHERNOBOG_E_DRAIN_INTERVAL * CHERNOBOG_E_MP_DRAIN[self:GetAbility():GetLevel()] / 100, currentMana - minMana))
        end
    end
end

function modifier_shadow_hunt:OnRemoved()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
		local modifiers = ability:GetModifierTable()
        for i = 1, 3, 1 do
			if caster:HasModifier(modifiers[i]) then
				caster:RemoveModifierByName(modifiers[i])
			end
		end
        local e_4_level = caster:GetRuneValue("e", 4)
        if e_4_level > 0 then
            local buffDuration = Filters:GetAdjustedBuffDuration(caster, CHERNOBOG_E4_BASE_DUR + CHERNOBOG_E4_DUR * e_4_level, false)
			if not caster:HasModifier(modifiers[4]) then
				caster:AddNewModifier(caster, ability, "modifier_chernobog_e_4", { duration = buffDuration })
			else
				caster:FindModifierByName(modifiers[4]):SetDuration(buffDuration, true)
			end
        end
    end
end

function modifier_shadow_hunt:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS 
    }
end

function modifier_shadow_hunt:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    return CHERNOBOG_E_MS_CAP_INCR[self:GetAbility():GetLevel()]
end

function modifier_shadow_hunt:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    return CHERNOBOG_E_MS_INCR[self:GetAbility():GetLevel()]
end

function modifier_shadow_hunt:GetActivityTranslationModifiers()
    return "haste"
end

function modifier_shadow_hunt:GetTexture()
	return 'night_stalker_hunter_in_the_night'
end

--passive thinker

function modifier_chernobog_e_passive:IsHidden()
	return true
end

function modifier_chernobog_e_passive:IsDebuff()
	return false
end

function modifier_chernobog_e_passive:IsPurgable()
	return false
end

function modifier_chernobog_e_passive:RemoveOnDeath()
	return false
end

function modifier_chernobog_e_passive:OnCreated()
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.2)
end

function modifier_chernobog_e_passive:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local modifiers = ability:GetModifierTable()
	if not modifiers then
		return
	end
	for i = 1, 3, 1 do
		local rune_level = caster:GetRuneValue("e", i)
		if (rune_level > 0) and ability:GetToggleState() == true then 
			if not caster:HasModifier(modifiers[i]) then
				caster:AddNewModifier(caster, ability, modifiers[i], {})
			end
		else
			if caster:HasModifier(modifiers[i]) then
				caster:RemoveModifierByName(modifiers[i])
			end
		end
	end
end

--runes

--E1

function modifier_chernobog_e1_buff:IsHidden()
	return false
end

function modifier_chernobog_e1_buff:IsDebuff()
	return false
end

function modifier_chernobog_e1_buff:GetTexture()
	return	"chernobog/chernobog_rune_e_1"
end

function modifier_chernobog_e1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end

function modifier_chernobog_e1_buff:OnCreated()	
	if not IsServer() then
		return
	end
	self:SetSpecialTypes({MODIFIER_ROSHPIT_MASTER_GREEN_DMG})
	self:StartIntervalThink(0.1)
end

function modifier_chernobog_e1_buff:OnIntervalThink()
	if not IsServer() then
		return
	end
end

function modifier_chernobog_e1_buff:GetRoshpitMasterGreenDMG()
	return self:GetStackCount() * CHERNOBOG_E1_ATT_PCT
end
	
function modifier_chernobog_e1_buff:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * CHERNOBOG_E1_MOVESPEED
end

function modifier_chernobog_e1_buff:GetModifierMoveSpeed_Max_Increase()
	return self:GetStackCount() * CHERNOBOG_E1_MOVESPEED
end
	
--E2

function modifier_chernobog_e2_shadow_thinker:IsHidden()
	return true
end

function modifier_chernobog_e2_shadow_thinker:IsDebuff()
	return false
end

function modifier_chernobog_e2_shadow_thinker:OnCreated()
	if not IsServer() then
		return
	end
	local interval = CHERNOBOG_E2_INTERVAL
	local caster = self:GetCaster()
	local e_4_level = caster:GetRuneValue("e", 4)
	if e_4_level > 0 then
		interval = interval / (1 + e_4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE)
	end
	self:StartIntervalThink(interval)
end

function modifier_chernobog_e2_shadow_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local e_2_level = caster:GetRuneValue("e", 2)
	local e_4_level = caster:GetRuneValue("e", 4)
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * e_2_level * CHERNOBOG_E2_DMG_PCT
	local interval = CHERNOBOG_E2_INTERVAL
	if e_4_level > 0 then
		interval = interval / (1 + e_4_level * CHERNOBOG_E4_SHADOWS_INTERVAL_SCALE)
	end
	local radius = CHERNOBOG_E2_RADIUS
    if caster:HasModifier('modifier_chernobog_glyph_2_1') then
        radius = radius * CHERNOBOG_T21_RADIUS_AMP
    end
    self:StartIntervalThink(interval)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        for _, enemy in ipairs(enemies) do
          local damageDelay =  0.9 * interval
          local animationRate = 1 + 0.3 * (0.5/interval - 1)
          local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/chernobog/nights_procession_illusion.vpcf", enemy, interval)
          ParticleManager:SetParticleControl(pfx, 1, Vector(animationRate, 0, 0))
          Timers:CreateTimer(damageDelay, function()
          EmitSoundOn("Chernobog.BC.Hit", enemy)
          Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_DEMON, RPC_ELEMENT_SHADOW)
          ParticleManager:DestroyParticle(pfx, false)
          ParticleManager:ReleaseParticleIndex(pfx)
      end)
   end
end

--E3

function modifier_chernobog_e3_thinker:IsHidden()
    return true
end

function modifier_chernobog_e3_thinker:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
end
function modifier_chernobog_e3_thinker:OnOrderFilter(data)
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
    }
    if not allowedOrderTypes[data.order_type] then
        return
    end
    if not data.entindex_target then
        return
    end
    local enemy = EntIndexToHScript(data.entindex_target)
    if not IsValidEntity(enemy) then
        return
    end
    local caster = self:GetCaster()
    if (data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET) and (IsValidEntity(enemy)) then
        if enemy.dummy or (enemy:GetClassname() == "dota_item_drop") or (enemy:GetTeamNumber() == caster:GetTeamNumber()) then
            return
        end
        if caster:IsRooted() or caster:IsStunned() then
			return 
		end
		local ability = self:GetAbility()
		local e_3_level = caster:GetRuneValue("e", 3)
		if not (e_3_level > 0) then
			return
		end
		if (data.entindex_target == 0) then
			return
		end
		local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), caster:GetAbsOrigin())
		if (distance <= CHERNOBOG_E3_RANGE_BASE + CHERNOBOG_E3_RANGE * e_3_level) then
			local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), enemy:GetAbsOrigin(), caster)
			if afterWallPosition ~= enemy:GetAbsOrigin() then
				return
			end
			local particleName = "particles/roshpit/chernobog/chernobog_rune_c_c.vpcf"
			local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particle1, 0, caster:GetAbsOrigin())
						
			FindClearSpaceForUnit(caster, afterWallPosition, false)
						
			EmitSoundOn("Chernobog.TeleportMove", caster)
			local particle2 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin() + Vector(0, 0, 100))
			Timers:CreateTimer(3, function()
					ParticleManager:DestroyParticle(particle1, false)
					ParticleManager:ReleaseParticleIndex(particle1)		
					ParticleManager:DestroyParticle(particle2, false)
					ParticleManager:ReleaseParticleIndex(particle2)
			end)
			Timers:CreateTimer(0.15, function()
				local baseDuration = CHERNOBOG_E3_BUFF_DURATION_BASE
				if caster:HasModifier("modifier_chernobog_glyph_6_1") then
					baseDuration = baseDuration + CHERNOBOG_GLYPH_6_1_DURATION_INCREASE
				end
				local buffDuration = Filters:GetAdjustedBuffDuration(caster, baseDuration, false)
				caster:AddNewModifier(caster, ability, "modifier_chernobog_e3_effect", { duration = buffDuration })
				StartAnimation(caster, {duration = 0.3, activity = ACT_DOTA_ATTACK, rate = 3})
				Filters:PerformAttackSpecial(caster, enemy, true, true, true, true, false, false, false)
			end)
		end
    end
end

function modifier_chernobog_e3_effect:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS,
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS
    })
end

function modifier_chernobog_e3_effect:IsHidden()
    return false
end
function modifier_chernobog_e3_effect:GetRoshpitArmorPierceBonus()
    return self:GetParent():GetRuneValue("e", 3) * CHERNOBOG_E3_ARMOR_PIERCE_AND_SPELL_PIERCE
end
function modifier_chernobog_e3_effect:GetRoshpitSpellPierceBonus()
    return self:GetParent():GetRuneValue("e", 3) * CHERNOBOG_E3_ARMOR_PIERCE_AND_SPELL_PIERCE
end
function modifier_chernobog_e3_effect:GetTexture()
    return "chernobog/chernobog_rune_e_3"
end

--E4
function modifier_chernobog_e4_buff:DeclareFunctions()
	return{MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_chernobog_e4_buff:IsDebuff()
    return false
end

function modifier_chernobog_e4_buff:GetModifierEvasion_Constant()
    return CHERNOBOG_E4_EVASION
end

function modifier_chernobog_e4_buff:GetTexture()
    return "chernobog/chernobog_rune_e_4"
end





























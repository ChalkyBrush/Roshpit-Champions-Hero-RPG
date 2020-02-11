require('heroes/antimage/arkimus_constants')
require('heroes/base_ability')
arkimus_flash_source = class(base_ability)

function arkimus_flash_source:GetBaseManaCost(level)
    if level == -1 then
        level = self:GetLevel() - 1
    end
    return ARKIMUS_W_MANA_COST[level + 1]
end

function arkimus_flash_source:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_TOGGLE
end

function arkimus_flash_source:GetAbilitySlot()
    return DOTA_W_SLOT
end

function arkimus_flash_source:GetCastPoint()
    return 0
end

function arkimus_flash_source:GetBaseCooldown(level)
    return 0
end

function arkimus_flash_source:IsToggle()
    return true
end

function arkimus_flash_source:OnToggle()
    if IsServer() then
        local ability = self
        local caster = self:GetCaster()
        if self:GetToggleState() then
            caster:AddNewModifier(caster, ability, "modifier_arkimus_flash_source", {})
            local w_2_level = caster:GetRuneValue("w", 2)
            if w_2_level > 0 then
                caster:AddNewModifier(caster, ability, "modifier_arkimus_w_2_spell_pierce_buff", {})
                caster:SetModifierStackCount("modifier_arkimus_w_2_spell_pierce_buff", caster, w_2_level)
            end
            Filters:CastSkillArguments(BASE_ABILITY_W, caster)
            if not ability.pfx then
                ability.pfx = ParticleManager:CreateParticle("particles/roshpit/heroes/arkimus/weapon_enhance.vpcf", PATTACH_POINT_FOLLOW, caster)
                ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_h1", caster:GetAbsOrigin(), true)
            end
            if not ability.pfx2 then
                ability.pfx2 = ParticleManager:CreateParticle("particles/roshpit/heroes/arkimus/weapon_enhance.vpcf", PATTACH_POINT_FOLLOW, caster)
                ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_h2", caster:GetAbsOrigin(), true)
            end
            if not caster.stormWeaponSound then
                local luck = 1
                if luck == 1 then
                    caster.stormWeaponSound = true
                    EmitSoundOn("Akrimus.MagicWeapon", caster)
                    StartAnimation(caster, {duration = 0.8, activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.6})
                    Timers:CreateTimer(0.6, function()
                        caster.stormWeaponSound = false
                    end)
                end
            end
            EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Akrimus.StormWeapon", caster)
        else
            caster:RemoveModifierByName("modifier_arkimus_flash_source")
            caster:RemoveModifierByName("modifier_arkimus_w_2_spell_pierce_buff")
            if ability.pfx then
                ParticleManager:DestroyParticle(ability.pfx, false)
                ability.pfx = false
            end
            if ability.pfx2 then
                ParticleManager:DestroyParticle(ability.pfx2, false)
                ability.pfx2 = false
            end
        end
    end
end

modifier_arkimus_flash_source = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_flash_source", "heroes/antimage/arkimus_flash_source", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_flash_source:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end
function modifier_arkimus_flash_source:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_SPECIAL_TYPE_ORDER_FILTER
    })
end

function modifier_arkimus_flash_source:OnAttackLanded(event)
    local attacker = event.attacker
    local target = event.target
    local ability = self:GetAbility()
    if attacker ~= self:GetParent() then
        return
    end	
    if attacker:GetMana() < self:GetAbility():GetManaCost(-1) then
        ability:ToggleAbility()
        return false
    else
        self:GetAbility():PayManaCost()
    end
	CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", target, 3)
    local damageMult = ARKIMUS_W_DAMAGE_PCT[self:GetAbility():GetLevel()] / 100
    local attackDamage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
    local damage = attackDamage * damageMult
    Filters:CastSkillArguments(BASE_ABILITY_W, attacker)
	EmitSoundOn("Akrimus.StormWeaponImpact", target)
	attacker:RemoveModifierByName("modifier_burnout")
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, ARKIMUS_W_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, attacker, damage, ARKMIUS_W_DAMAGE_TYPE, BASE_ABILITY_W, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
			CustomAbilities:QuickAttachParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_explode_b_basher_cast.vpcf", enemy, 3)
		end
	end
	local w_1_level = attacker:GetRuneValue("w", 1)
	if w_1_level > 0 then
		local duration = Filters:GetAdjustedBuffDuration(attacker, ARKIMUS_W1_DURATION, false)
        attacker:AddNewModifier(attacker, ability, "modifier_arkimus_w_1_damage_buff", {duration = duration})
		attacker:SetModifierStackCount("modifier_arkimus_w_1_damage_buff", attacker, w_1_level)
	end
	local w_4_level = attacker:GetRuneValue("w", 4)
	local procs = Runes:Procs(w_4_level, ARKIMUS_W4_SHIELD_CHANCE, 1)
	if procs > 0 then
		local duration = Filters:GetAdjustedBuffDuration(attacker, ARKIMUS_W4_SHIELD_DURATION, false)
        attacker:AddNewModifier(attacker, ability, "modifier_arkimus_w_4_shield", {duration = duration})
		attacker:SetModifierStackCount("modifier_arkimus_w_4_shield", attacker, procs)
	end
end

function modifier_arkimus_flash_source:OnOrderFilter(data)
    local allowedOrderTypes = {
        [DOTA_UNIT_ORDER_ATTACK_TARGET] = true,
    }
    self:GetParent():RemoveModifierByName("modifier_arkimus_w_3_dash")
    self:GetParent():RemoveModifierByName("modifier_arkimus_w_3_bonus_damage")
    if not allowedOrderTypes[data.order_type] then
        return
    end
    local enemy = EntIndexToHScript(data.entindex_target)
    local unit = self:GetParent()
    if data.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and IsValidEntity(enemy) then
        if enemy.dummy or enemy:GetClassname() == "dota_item_drop" or enemy:GetTeamNumber() == unit:GetTeamNumber() then
            return
        end
        if not unit:IsRooted() and not unit:IsStunned() then
            local ability = self:GetAbility()
            local w_3_level = unit:GetRuneValue("w", 3)
            if w_3_level > 0 then
                if data.entindex_target == 0 then
                else
                    local distance = WallPhysics:GetDistance2d(enemy:GetAbsOrigin(), unit:GetAbsOrigin())
                    if distance >= 400 then
                        local duration = 3
                        local caster = unit
                        caster:AddNewModifier(caster, ability, "modifier_arkimus_w_3_dash", {duration = duration})
                        caster:AddNewModifier(caster, ability, "modifier_arkimus_w_3_bonus_damage", {duration = duration})
                        caster:SetModifierStackCount("modifier_arkimus_w_3_bonus_damage", caster, w_3_level * ARKIMUS_W3_BONUS_DMG)
                        caster:AddNewModifier(caster, nil, "modifier_animation_translate", {translate = "haste"})
                    end
                end
            end
        end
    end
end

modifier_arkimus_w_1_damage_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_w_1_damage_buff", "heroes/antimage/arkimus_flash_source", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_w_1_damage_buff:IsHidden()
    return false
end
function modifier_arkimus_w_1_damage_buff:IsBuff()
    return true
end
function modifier_arkimus_w_1_damage_buff:GetTexture()
    return "arkimus/arkimus_rune_w_1"
end
function modifier_arkimus_w_1_damage_buff:GetEffectName()
    return "particles/roshpit/arkimus/arcane_a_b_buff.vpcf"
end
function modifier_arkimus_w_1_damage_buff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
function modifier_arkimus_w_1_damage_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }

    return funcs
end

function modifier_arkimus_w_1_damage_buff:GetModifierBaseAttack_BonusDamage()
    return self:GetStackCount() * ARKIMUS_W1_BASE_ATTACK_DMG
end

modifier_arkimus_w_2_spell_pierce_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_w_2_spell_pierce_buff", "heroes/antimage/arkimus_flash_source", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_w_2_spell_pierce_buff:IsHidden()
    return false
end
function modifier_arkimus_w_2_spell_pierce_buff:IsBuff()
    return true
end
function modifier_arkimus_w_2_spell_pierce_buff:GetTexture()
    return "arkimus/arkimus_rune_w_2"
end
function modifier_arkimus_w_2_spell_pierce_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
        MODIFIER_ROSHPIT_SPELL_PIERCE_BONUS,
        MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS
    })
end

function modifier_arkimus_w_2_spell_pierce_buff:GetRoshpitSpellPierceBonus()
    local hero = self:GetParent()
    return self:GetStackCount() * ARKIMUS_W2_SPELL_PIERCE
end
function modifier_arkimus_w_2_spell_pierce_buff:GetRoshpitArmorPierceBonus()
    local hero = self:GetParent()
    if hero:HasModifier("modifier_arkimus_immortal_weapon_1") then
        return self:GetStackCount() * ARKIMUS_W2_SPELL_PIERCE
    else
        return 0
    end
end

modifier_arkimus_w_3_dash = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_w_3_dash", "heroes/antimage/arkimus_flash_source", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_w_3_dash:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end
function modifier_arkimus_w_3_dash:IsHidden()
    return false
end
function modifier_arkimus_w_3_dash:IsBuff()
    return true
end
function modifier_arkimus_w_3_dash:GetTexture()
    return "arkimus/arkimus_rune_w_3"
end
function modifier_arkimus_w_3_dash:GetModifierMoveSpeed_Max_Increase(params)
    if not IsServer() then
        return
    end
    return ARKIMUS_W3_MS_AND_MS_CAP_BONUS
end
function modifier_arkimus_w_3_dash:GetModifierMoveSpeedBonus_Constant(params)
    if not IsServer() then
        return
    end
    return ARKIMUS_W3_MS_AND_MS_CAP_BONUS
end
function modifier_arkimus_w_3_dash:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

    return state
end
function modifier_arkimus_w_3_dash:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.09)
    end
end

function modifier_arkimus_w_3_dash:OnIntervalThink()
    local caster = self:GetParent()
    local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/sprint_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(0.4, function()
		ParticleManager:DestroyParticle(pfx, false)
    end)
end

modifier_arkimus_w_3_bonus_damage = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_w_3_bonus_damage", "heroes/antimage/arkimus_flash_source", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_w_3_bonus_damage:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end
function modifier_arkimus_w_3_bonus_damage:IsHidden()
    return true
end
function modifier_arkimus_w_3_bonus_damage:IsBuff()
    return true
end
function modifier_arkimus_w_3_bonus_damage:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetStackCount() * 1
end

function modifier_arkimus_w_3_bonus_damage:OnAttackLanded(event)
    local attacker = event.attacker
    local target = event.target
    local ability = self:GetAbility()
    if attacker ~= self:GetParent() then
        return
    end
    attacker:RemoveModifierByName("modifier_arkimus_w_3_dash")
    attacker:RemoveModifierByName("modifier_arkimus_w_3_bonus_damage")
end

modifier_arkimus_w_4_shield = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_arkimus_w_4_shield", "heroes/antimage/arkimus_flash_source", LUA_MODIFIER_MOTION_NONE)

function modifier_arkimus_w_4_shield:IsHidden()
    return false
end
function modifier_arkimus_w_4_shield:IsBuff()
    return true
end
function modifier_arkimus_w_4_shield:GetTexture()
    return "arkimus/arkimus_rune_w_4"
end
function modifier_arkimus_w_4_shield:GetEffectName()
    return "particles/roshpit/arkimus/source_relay.vpcf"
end
function modifier_arkimus_w_4_shield:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN
end


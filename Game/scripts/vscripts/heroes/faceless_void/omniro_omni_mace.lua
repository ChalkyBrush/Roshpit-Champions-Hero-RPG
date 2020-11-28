require('heroes/faceless_void/omniro_constants')
require('heroes/faceless_void/omniro_common')
require('heroes/base_ability')
omniro_omni_mace = class(base_ability)

function omniro_omni_mace:GetManaCostBase(level)
    return 0
end

function omniro_omni_mace:GetBehaviorBase()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_TOGGLE
end

function omniro_omni_mace:GetAbilitySlot()
    return DOTA_Q_SLOT
end

function omniro_omni_mace:GetCastPoint()
    return 0
end

function omniro_omni_mace:GetCooldownBase(level)
    return 0
end

function omniro_omni_mace:IsToggle()
    return true
end

function omniro_omni_mace:GetIntrinsicModifierName()
    return "modifier_omniro_omni_mace"
end

function omniro_omni_mace:OnToggle()
    if IsServer() then
        local caster = self:GetCaster()
        if self:GetToggleState() then
            caster.omniro_data[caster.active_element]["locked"] = true
        else
            caster.omniro_data[caster.active_element]["locked"] = false
        end
    end
end

modifier_omniro_omni_mace = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end
function modifier_omniro_omni_mace:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.1)
    self:SetSpecialTypes({ 
    })
end

function modifier_omniro_omni_mace:IsHidden()
    return true
end

function modifier_omniro_omni_mace:OnIntervalThink()
	local caster = self:GetParent()
	local ability = self:GetAbility()

	if not ability.interval then
		ability.interval = 0
	end

	if not caster.omniro_data then
		InitOmniroData(caster, ability)
	end
	

	if caster.offload_think_completed then
		OmniroElementChargeThink(caster)
	end

	local reconstruct = false
	if ability.interval % 10 == 0 then
		caster.offload_think_completed = true
		reconstruct = OmniroRuneCalculate(caster, ability)
	end
	local player = caster:GetPlayerOwner()
	CustomNetTables:SetTableValue("hero_index", "omniro-"..tostring(caster:GetEntityIndex()), caster.omniro_data)
	if reconstruct then
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex(), reconstruct = true})
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex()})
	end
end

function modifier_omniro_omni_mace:OnAttackLanded(event)
	local caster = self:GetParent()
	local target = event.target
	local ability = self:GetAbility()
    if not self:ParentIsAttacker(event) then
        return
    end
	if target.dummy or caster == target then
		return false
	end
	local active_element = caster.active_element

	-- CURRENT ELEMENT EFFECT HERE

	local next_element = nil
	for i = active_element, active_element + 17, 1 do
        if caster.omniro_data[(i % 18) + 1]["level"] > 0 and caster.omniro_data[(i % 18) + 1]["in_rotation"] == 1 then
            if caster:HasModifier("modifier_omniro_glyph_1_1") then
                if caster.omniro_data[(i % 18) + 1]["charges"] > 0 then
                    next_element = (i % 18) + 1
                    break
                end
            else
                next_element = (i % 18) + 1
                break
            end
        end
	end
	local basic_damage = OmniroOmniMaceBasicHit(caster, ability, target)
	if caster:HasModifier("modifier_omniro_immortal_weapon_1") then
		OmniroOmniMaceBasicHit(caster, ability, target)
	end

	if caster:HasModifier("modifier_omni_orb_active") then
		if caster.omniro_data[active_element]["charges"] > 0 or caster:HasModifier("modifier_dimension_stalker_active") then
			if not caster:HasModifier("modifier_dimension_stalker_active") then
				caster.omniro_data[active_element]["charges"] = caster.omniro_data[active_element]["charges"] - 1
			end
			OmniroOmniOrbChargeProceed(caster, ability, target, basic_damage)
		end
	end
	if caster:HasModifier("modifier_omniro_glyph_6_1") then
		caster.omniro_data[active_element]["charge_up_fraction"] = caster.omniro_data[active_element]["charge_up_fraction"] + OMNIRO_GLYPH_6_1_RECHARGE_ON_ATTACK_PERCENT

	end
	if not caster.omniro_data[caster.active_element]["locked"] then
		caster.omniro_data[active_element]["active"] = false
		caster.omniro_data[next_element]["active"] = true
		caster.active_element = next_element

		local mace_hit = OmniroOmniMaceBaseElementData(next_element)
	end
end


modifier_omniro_omni_mace_fire = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_fire", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_fire:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end
function modifier_omniro_omni_mace_fire:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_fire:GetTexture()
    return "omniro/omniro_element_fire"
end
function modifier_omniro_omni_mace_fire:GetModifierBaseAttack_BonusDamage()
    return self:GetStackCount() * OMNIRO_MACE_FIRE_BASE_ATTACK_DAMAGE
end


modifier_omniro_omni_mace_earth = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_earth", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_earth:DeclareFunctions()
	local funcs = {
	}

	return funcs
end
function modifier_omniro_omni_mace_earth:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
		MODIFIER_ROSHPIT_ARMOR_BONUS,
		MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
end
function modifier_omniro_omni_mace_earth:GetTexture()
    return "omniro/omniro_element_earth"
end
function modifier_omniro_omni_mace_earth:GetRoshpitArmorBonus()
    return self:GetStackCount() * OMNIRO_MACE_EARTH_ARMOR[self:GetAbility():GetLevel()]
end
function modifier_omniro_omni_mace_earth:GetRoshpitMagicArmorBonus()
    return self:GetStackCount() * OMNIRO_MACE_EARTH_MAGIC_ARMOR[self:GetAbility():GetLevel()]
end


modifier_omniro_omni_mace_poison = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_poison", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_poison:DeclareFunctions()
	local funcs = {
	}

	return funcs
end
function modifier_omniro_omni_mace_poison:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(OMNIRO_MACE_POISON_TICK_INTERVAL)
    self:SetSpecialTypes({ 
		MODIFIER_ROSHPIT_ARMOR_BONUS,
		MODIFIER_ROSHPIT_MAGIC_ARMOR_BONUS
    })
end
function modifier_omniro_omni_mace_poison:IsDebuff()
	return true
end
function modifier_omniro_omni_mace_poison:GetTexture()
    return "omniro/omniro_element_poison"
end
function modifier_omniro_omni_mace_poison:OnIntervalThink()
	local target = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local poison_damage = OMNIRO_MACE_POISON_ATTACK_POWER_MULT_PCT[ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_POISON]["level"] * OMNIRO_MACE_POISON_TICK_INTERVAL
	if target:HasModifier("modifier_omniro_poison_pool_enemy") then
		poison_damage = poison_damage * OMNIRO_POISON_MULTIPLE_FOR_DOUBLE
	end
	local hit_data = OmniroOmniMaceBaseElementData(RPC_ELEMENT_POISON)
	Filters:ApplyDotDamage(caster, ability, target, poison_damage, hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end
function modifier_omniro_omni_mace_poison:GetEffectName()
    return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
end
function modifier_omniro_omni_mace_poison:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN
end


modifier_omniro_omni_mace_time = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_time", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_time:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end
function modifier_omniro_omni_mace_time:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_time:GetTexture()
    return "omniro/omniro_element_time"
end
function modifier_omniro_omni_mace_time:GetModifierAttackSpeedBonus_Constant()
    return OMNIRO_MACE_TIME_ATTACK_SPEED[self:GetAbility():GetLevel()] * self:GetStackCount()
end
function modifier_omniro_omni_mace_time:GetModifierMoveSpeedBonus_Constant(params)
    return OMNIRO_MACE_TIME_MOVE_SPEED[self:GetAbility():GetLevel()] * self:GetStackCount()
end
function modifier_omniro_omni_mace_time:GetEffectName()
    return "particles/roshpit/omniro/time_haste.vpcf"
end
function modifier_omniro_omni_mace_time:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_omniro_omni_mace_holy = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_holy", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_holy:CheckState()
    local state = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }

    return state
end
function modifier_omniro_omni_mace_holy:OnCreated()
    if not IsServer() then
        return
    end
	EmitSoundOn("Item.GiantHunterImmunity", self:GetParent())
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_holy:GetTexture()
    return "omniro/omniro_element_holy"
end
function modifier_omniro_omni_mace_holy:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end
function modifier_omniro_omni_mace_holy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_omniro_omni_mace_cosmic = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_cosmic", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_cosmic:DeclareFunctions()
	local funcs = {
	}

	return funcs
end
function modifier_omniro_omni_mace_cosmic:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
		MODIFIER_ROSHPIT_FLAT_HEALTH_BONUS
    })
end
function modifier_omniro_omni_mace_cosmic:GetTexture()
    return "omniro/omniro_element_cosmic"
end
function modifier_omniro_omni_mace_cosmic:GetFlatHealthBonus()
    return OMNIRO_MACE_COSMIC_HP[self:GetAbility():GetLevel()] * self:GetStackCount()
end


modifier_omniro_omni_mace_ice = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_ice", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_ice:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end
function modifier_omniro_omni_mace_ice:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_ice:IsDebuff()
	return true
end
function modifier_omniro_omni_mace_ice:GetTexture()
    return "omniro/omniro_element_ice"
end
function modifier_omniro_omni_mace_ice:GetModifierAttackSpeedBonus_Constant()
    return OMNIRO_MACE_ICE_ATTACK_SLOW[self:GetAbility():GetLevel()] * self:GetStackCount()
end
function modifier_omniro_omni_mace_ice:GetModifierMoveSpeedBonus_Constant(params)
    return OMNIRO_MACE_ICE_MOVE_SLOW[self:GetAbility():GetLevel()] * self:GetStackCount()
end
function modifier_omniro_omni_mace_ice:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end
function modifier_omniro_omni_mace_ice:StatusEffectPriority()
	return 20
end

modifier_omniro_omni_mace_shadow = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_shadow", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_shadow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end
function modifier_omniro_omni_mace_shadow:OnCreated()
    if not IsServer() then
        return
    end
	local target = self:GetParent()
	local location = target:GetAbsOrigin()
	local particleName = "particles/roshpit/omniro/shadow_armor_shred.vpcf"
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
	end
	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end)
    self:SetSpecialTypes({ 
		MODIFIER_ROSHPIT_ARMOR_BONUS,
    })
end
function modifier_omniro_omni_mace_shadow:OnDestroy()
	local target = self:GetParent()
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
		target.AmpDamageParticle = nil
	end
	if IsServer() then
		target:CalculateAndSaveRoshpitAttributes()
	end
end
function modifier_omniro_omni_mace_shadow:IsDebuff()
	return true
end
function modifier_omniro_omni_mace_shadow:GetTexture()
    return "omniro/omniro_element_shadow"
end
function modifier_omniro_omni_mace_shadow:GetRoshpitArmorBonus()
    return self:GetStackCount() * OMNIRO_MACE_SHADOW_ARMOR_REDUCTION[self:GetAbility():GetLevel()]
end


modifier_omniro_omni_mace_wind = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_wind", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_wind:DeclareFunctions()
	local funcs = {
	}

	return funcs
end
function modifier_omniro_omni_mace_wind:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
		MODIFIER_ROSHPIT_AGILITY_BONUS
    })
end
function modifier_omniro_omni_mace_wind:GetTexture()
    return "omniro/omniro_element_wind"
end
function modifier_omniro_omni_mace_wind:GetRoshpitAgilityBonus()
    return OMNIRO_MACE_WIND_AGI_BONUS[self:GetAbility():GetLevel()] * self:GetStackCount()
end


modifier_omniro_omni_mace_ghost = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_ghost", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_ghost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end
function modifier_omniro_omni_mace_ghost:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_ghost:GetTexture()
    return "omniro/omniro_element_ghost"
end
function modifier_omniro_omni_mace_ghost:GetModifierEvasion_Constant()
    return OMNIRO_MACE_GHOST_EVASION_PCT
end
function modifier_omniro_omni_mace_ghost:GetEffectName()
    return "particles/roshpit/omniro/omniro_ghost_buff.vpcf"
end
function modifier_omniro_omni_mace_ghost:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_omniro_omni_mace_water = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_water", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_water:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return funcs
end
function modifier_omniro_omni_mace_water:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_water:GetTexture()
    return "omniro/omniro_element_water"
end
function modifier_omniro_omni_mace_water:GetModifierConstantHealthRegen()
    return OMNIRO_MACE_WATER_REGEN[self:GetAbility():GetLevel()] * self:GetStackCount()
end
function modifier_omniro_omni_mace_water:GetEffectName()
    return "particles/roshpit/draghor/mark_of_the_talon_heal.vpcf"
end
function modifier_omniro_omni_mace_water:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_omniro_omni_mace_demon = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_demon", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_demon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end
function modifier_omniro_omni_mace_demon:OnCreated()
    if not IsServer() then
        return
    end
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_demon:GetTexture()
    return "omniro/omniro_element_demon"
end
function modifier_omniro_omni_mace_demon:GetModifierBaseDamageOutgoing_Percentage()
    return OMNIRO_MACE_DEMON_BONUS_ATTACK_DAMAGE[self:GetAbility():GetLevel()] * self:GetStackCount()
end



modifier_omniro_omni_mace_nature = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_nature", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_nature:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function modifier_omniro_omni_mace_nature:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end
function modifier_omniro_omni_mace_nature:IsDebuff()
	return true
end
function modifier_omniro_omni_mace_nature:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(OMNIRO_MACE_NATURE_TICK_INTERVAL)
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_nature:GetTexture()
    return "omniro/omniro_element_nature"
end
function modifier_omniro_omni_mace_nature:GetEffectName()
    return "particles/roshpit/jex/jex_root.vpcf"
end
function modifier_omniro_omni_mace_nature:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_omniro_omni_mace_nature:OnIntervalThink()
	local target = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local nature_damage = OMNIRO_MACE_NATURE_ATTACK_POWER_MULT_PCT[ability:GetLevel()] * OMNIRO_MACE_NATURE_TICK_INTERVAL * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_NATURE]["level"]
	local hit_data = OmniroOmniMaceBaseElementData(RPC_ELEMENT_NATURE)
	Filters:ApplyDotDamage(caster, ability, target, nature_damage, hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
end


modifier_omniro_omni_mace_undead_debuff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_undead_debuff", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_undead_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING
	}

	return funcs
end
function modifier_omniro_omni_mace_undead_debuff:IsDebuff()
	return true
end
function modifier_omniro_omni_mace_undead_debuff:OnCreated()
    if not IsServer() then
        return
    end
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", self:GetParent(), 2)
    self:SetSpecialTypes({ 
    })
end
function modifier_omniro_omni_mace_undead_debuff:GetTexture()
    return "omniro/omniro_element_undead"
end
function modifier_omniro_omni_mace_undead_debuff:GetEffectName()
    return "particles/econ/courier/courier_trail_hw_2012/courier_trail_hw_2012_ghosts.vpcf"
end
function modifier_omniro_omni_mace_undead_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_omniro_omni_mace_undead_debuff:GetDisableHealing()
	return 1
end


modifier_omniro_omni_mace_undead_buff = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_undead_buff", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_undead_buff:DeclareFunctions()
	local funcs = {
	}

	return funcs
end
function modifier_omniro_omni_mace_undead_buff:OnCreated()
    if not IsServer() then
        return
    end
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", self:GetParent(), 2)
    self:SetSpecialTypes({ 
		MODIFIER_ROSHPIT_ARMOR_PIERCE_BONUS
    })
end
function modifier_omniro_omni_mace_undead_buff:GetTexture()
    return "omniro/omniro_element_undead"
end
function modifier_omniro_omni_mace_undead_buff:GetRoshpitArmorPierceBonus()
	return OMNIRO_MACE_UNDEAD_ARMOR_PIERCE[self:GetAbility():GetLevel()] * self:GetStackCount()
end


modifier_omniro_omni_mace_dragon = class(npc_base_modifier, nil, npc_base_modifier)
LinkLuaModifier("modifier_omniro_omni_mace_dragon", "heroes/faceless_void/omniro_omni_mace", LUA_MODIFIER_MOTION_NONE)

function modifier_omniro_omni_mace_dragon:DeclareFunctions()
	local funcs = {
	}

	return funcs
end
function modifier_omniro_omni_mace_dragon:OnCreated()
    if not IsServer() then
        return
    end
    CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", self:GetParent(), 2)
    self:SetSpecialTypes({ 
        RPC_ELEMENT_FIRE,
        RPC_ELEMENT_EARTH,
        RPC_ELEMENT_LIGHTNING,
        RPC_ELEMENT_POISON,
        RPC_ELEMENT_TIME,
        RPC_ELEMENT_HOLY,
        RPC_ELEMENT_COSMOS,
        RPC_ELEMENT_ICE,
        RPC_ELEMENT_ARCANE,
        RPC_ELEMENT_SHADOW,
        RPC_ELEMENT_WIND,
        RPC_ELEMENT_GHOST,
        RPC_ELEMENT_WATER,
        RPC_ELEMENT_DEMON,
        RPC_ELEMENT_NATURE,
        RPC_ELEMENT_UNDEAD,
        RPC_ELEMENT_DRAGON
    })
end
function modifier_omniro_omni_mace_dragon:GetEffectName()
    return "particles/econ/generic/generic_buff_1/rainbow_buff.vpcf"
end
function modifier_omniro_omni_mace_dragon:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniro_omni_mace_dragon:GetRoshpitElementalDmgBonus()
	return OMNIRO_MACE_DRAGON_ELEMENTAL_BUFF * self:GetStackCount()
end